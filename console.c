// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"



static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
#define LEFT_ARROW 0xE4
#define RIGHT_ARROW 0xE5
#define UP_ARROW 0xE2

#define INPUT_BUF 128
// 
int count_entered = 0;
int commandHisCounter = 0;
//
void for_str(char a[],char b[],int size){
  for(int i=0;i<127;i++){
    b[i]=a[i];
  }
}
//
int back_counter = 0;
int backspaces = 0;
char history[10][INPUT_BUF];
int curr_index=0 ;


static ushort *crt = (ushort*)P2V(0xb8000);  

struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  uint pos;
} input;
///
void insertChar(int c, int back_counter){
  int pos;

  // get cursor position
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  //move back crt buffer
  for(int i = pos + back_counter; i >= pos; i--){
    crt[i+1] = crt[i];
  }
  crt[pos] = (c&0xff) | 0x0700;  

  // move cursor to next position
  pos += 1;

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos+back_counter] = ' ' | 0x0700;
}
///
void addHistory(char *command){
if(command[0]!='\0')
{
    int length = strlen(command) <= INPUT_BUF ? strlen(command) : INPUT_BUF-1;
    int i;

    if(commandHisCounter < 10){
      commandHisCounter++;
    }else{
    // move back
      for(i = 0; i < 10 ; i++){
        memmove(history[i], history[i+1], sizeof(char)* INPUT_BUF);
      }   
    }

  //store
    memmove(history[commandHisCounter-1], command, sizeof(char)* length);
    history[commandHisCounter-1][length] = '\0';

    curr_index = commandHisCounter - 1;
  }
}
///
void forwardCursor(){
  int pos;
  
  // cursor pos
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    

 
  pos++;

  // cursor reset
  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));

}

void removeChar(){
  int pos;
  
  // cursor pos

  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    
 
  pos--;

    // cursor reset
  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
  crt[pos] = ' ' | 0x0700;
}

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n'){
   // count_entered++;
    
    pos += 80 - pos%80;
  }
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  } else if (c == LEFT_ARROW) {
    if(back_counter < (strlen(input.buf) - backspaces)) {
      --pos;
      back_counter++;
    }
  } else if (c == RIGHT_ARROW) {
    if(back_counter > 0) {
      ++pos;
      back_counter--;
    }
  }else {
    for(int i = pos + back_counter; i >= pos; i--){
      crt[i+1] = crt[i];
    }
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  }

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  if(c != LEFT_ARROW && c != RIGHT_ARROW)
    crt[pos+back_counter] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    backspaces++;
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
  int x;
  char buffer[128];
  //
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w && back_counter < (strlen(input.buf) - backspaces)){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case LEFT_ARROW: // Left move cursor
      cgaputc(c);
      break;
    case RIGHT_ARROW:      // Right move cursor
      cgaputc(c);
      break;
    case UP_ARROW:                // Last command in history
      if(curr_index >= 0){
        //move to the right most pos 
        for(int i=input.pos; i < input.e; i++){
          forwardCursor();
        }
      

        //clear input
        while(input.e > input.w){
          input.e--;
          removeChar();
        }

        //load last command
        for(int i=0; i < strlen(history[curr_index]); i++){
          x = history[curr_index][i];
          consputc(x);
          input.buf[input.e++] = x;
        }
        curr_index  --;
        input.pos = input.e;
      }
      break;
default:
      if(c != 0 && input.e-input.r < INPUT_BUF){

        uartputc('-');
        uartputc(c); 

        c = (c == '\r') ? '\n' : c;
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ // if input is \n, put it on the back, and process it

          //write to buffer
          input.buf[input.e++ % INPUT_BUF] = c;
          consputc(c);

          //back counter to 0
          back_counter = 0;

          //copy the command
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
            buffer[k] = input.buf[i % INPUT_BUF];
          }
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';

          //add histories
          addHistory(buffer);
          

          //process
          input.w = input.e;
          input.pos = input.e;
          wakeup(&input.r);

        }else{
          
          if(back_counter == 0){

            input.buf[input.e++ % INPUT_BUF] = c;
            input.pos ++;

            // output direct
            consputc(c);
          
          }else{

            //move back
            for(int k=input.e; k >= input.pos; k--){
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
            }

            //insert
            input.buf[input.pos % INPUT_BUF] = c;

            input.e++;
            input.pos++;

            insertChar(c, back_counter);
          }
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
