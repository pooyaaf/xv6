
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 32 10 80       	mov    $0x80103290,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 73 10 80       	push   $0x801073c0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 a5 45 00 00       	call   80104600 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 73 10 80       	push   $0x801073c7
80100097:	50                   	push   %eax
80100098:	e8 33 44 00 00       	call   801044d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 e7 46 00 00       	call   801047d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 09 46 00 00       	call   80104770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 43 00 00       	call   80104510 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 7f 23 00 00       	call   80102510 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ce 73 10 80       	push   $0x801073ce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 43 00 00       	call   801045b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 37 23 00 00       	jmp    80102510 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 73 10 80       	push   $0x801073df
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 43 00 00       	call   801045b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 43 00 00       	call   80104570 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 b0 45 00 00       	call   801047d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 44 00 00       	jmp    80104770 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 73 10 80       	push   $0x801073e6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 f7 17 00 00       	call   80101a90 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 2b 45 00 00       	call   801047d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 9e 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 b9 38 00 00       	call   80103ba0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 75 44 00 00       	call   80104770 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ac 16 00 00       	call   801019b0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 1f 44 00 00       	call   80104770 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 56 16 00 00       	call   801019b0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 82 27 00 00       	call   80102b20 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 73 10 80       	push   $0x801073ed
801003a7:	e8 04 04 00 00       	call   801007b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 03 00 00       	call   801007b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 17 7d 10 80 	movl   $0x80107d17,(%esp)
801003bc:	e8 ef 03 00 00       	call   801007b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 42 00 00       	call   80104620 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 74 10 80       	push   $0x80107401
801003dd:	e8 ce 03 00 00       	call   801007b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100409:	56                   	push   %esi
8010040a:	89 fa                	mov    %edi,%edx
8010040c:	53                   	push   %ebx
8010040d:	89 c3                	mov    %eax,%ebx
8010040f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	be d5 03 00 00       	mov    $0x3d5,%esi
8010041d:	89 f2                	mov    %esi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042a:	c1 e1 08             	shl    $0x8,%ecx
8010042d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042e:	89 f2                	mov    %esi,%edx
80100430:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100431:	0f b6 f8             	movzbl %al,%edi
80100434:	09 cf                	or     %ecx,%edi
  if(c == '\n')
80100436:	83 fb 0a             	cmp    $0xa,%ebx
80100439:	0f 84 f1 00 00 00    	je     80100530 <cgaputc+0x130>
  else if(c == BACKSPACE){
8010043f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100445:	0f 84 cd 00 00 00    	je     80100518 <cgaputc+0x118>
  } else if (c == LEFT_ARROW) {
8010044b:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100451:	0f 84 69 01 00 00    	je     801005c0 <cgaputc+0x1c0>
    if(back_counter > 0) {
80100457:	a1 10 ef 10 80       	mov    0x8010ef10,%eax
  } else if (c == RIGHT_ARROW) {
8010045c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100462:	0f 84 38 01 00 00    	je     801005a0 <cgaputc+0x1a0>
    for(int i = pos + back_counter; i >= pos; i--){
80100468:	01 f8                	add    %edi,%eax
8010046a:	39 c7                	cmp    %eax,%edi
8010046c:	7f 20                	jg     8010048e <cgaputc+0x8e>
8010046e:	8d 8c 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%ecx
80100475:	8d 94 3f fe 7f 0b 80 	lea    -0x7ff48002(%edi,%edi,1),%edx
8010047c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      crt[i+1] = crt[i];
80100480:	0f b7 01             	movzwl (%ecx),%eax
    for(int i = pos + back_counter; i >= pos; i--){
80100483:	83 e9 02             	sub    $0x2,%ecx
      crt[i+1] = crt[i];
80100486:	66 89 41 04          	mov    %ax,0x4(%ecx)
    for(int i = pos + back_counter; i >= pos; i--){
8010048a:	39 ca                	cmp    %ecx,%edx
8010048c:	75 f2                	jne    80100480 <cgaputc+0x80>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010048e:	0f b6 c3             	movzbl %bl,%eax
80100491:	8d 77 01             	lea    0x1(%edi),%esi
80100494:	80 cc 07             	or     $0x7,%ah
80100497:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
8010049e:	80 
  if(pos < 0 || pos > 25*80)
8010049f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
801004a5:	0f 87 4c 01 00 00    	ja     801005f7 <cgaputc+0x1f7>
  if((pos/80) >= 24){  // Scroll up.
801004ab:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
801004b1:	0f 8f 99 00 00 00    	jg     80100550 <cgaputc+0x150>
  outb(CRTPORT+1, pos>>8);
801004b7:	89 f0                	mov    %esi,%eax
801004b9:	0f b6 c4             	movzbl %ah,%eax
801004bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  outb(CRTPORT+1, pos);
801004bf:	89 f0                	mov    %esi,%eax
801004c1:	88 45 e7             	mov    %al,-0x19(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c4:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004c9:	b8 0e 00 00 00       	mov    $0xe,%eax
801004ce:	89 fa                	mov    %edi,%edx
801004d0:	ee                   	out    %al,(%dx)
801004d1:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004d6:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
801004da:	89 ca                	mov    %ecx,%edx
801004dc:	ee                   	out    %al,(%dx)
801004dd:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e2:	89 fa                	mov    %edi,%edx
801004e4:	ee                   	out    %al,(%dx)
801004e5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004e9:	89 ca                	mov    %ecx,%edx
801004eb:	ee                   	out    %al,(%dx)
  if(c != LEFT_ARROW && c != RIGHT_ARROW)
801004ec:	81 eb e4 00 00 00    	sub    $0xe4,%ebx
801004f2:	83 fb 01             	cmp    $0x1,%ebx
801004f5:	76 13                	jbe    8010050a <cgaputc+0x10a>
    crt[pos+back_counter] = ' ' | 0x0700;
801004f7:	03 35 10 ef 10 80    	add    0x8010ef10,%esi
801004fd:	b8 20 07 00 00       	mov    $0x720,%eax
80100502:	66 89 84 36 00 80 0b 	mov    %ax,-0x7ff48000(%esi,%esi,1)
80100509:	80 
}
8010050a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010050d:	5b                   	pop    %ebx
8010050e:	5e                   	pop    %esi
8010050f:	5f                   	pop    %edi
80100510:	5d                   	pop    %ebp
80100511:	c3                   	ret    
80100512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pos > 0) --pos;
80100518:	8d 77 ff             	lea    -0x1(%edi),%esi
8010051b:	85 ff                	test   %edi,%edi
8010051d:	75 80                	jne    8010049f <cgaputc+0x9f>
8010051f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100523:	31 f6                	xor    %esi,%esi
80100525:	c6 45 e0 00          	movb   $0x0,-0x20(%ebp)
80100529:	eb 99                	jmp    801004c4 <cgaputc+0xc4>
8010052b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010052f:	90                   	nop
    pos += 80 - pos%80;
80100530:	89 f8                	mov    %edi,%eax
80100532:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100537:	f7 e2                	mul    %edx
80100539:	c1 ea 06             	shr    $0x6,%edx
8010053c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010053f:	c1 e0 04             	shl    $0x4,%eax
80100542:	8d 70 50             	lea    0x50(%eax),%esi
80100545:	e9 55 ff ff ff       	jmp    8010049f <cgaputc+0x9f>
8010054a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100550:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100553:	83 ee 50             	sub    $0x50,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100556:	68 60 0e 00 00       	push   $0xe60
8010055b:	68 a0 80 0b 80       	push   $0x800b80a0
80100560:	68 00 80 0b 80       	push   $0x800b8000
80100565:	e8 c6 43 00 00       	call   80104930 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010056a:	b8 80 07 00 00       	mov    $0x780,%eax
8010056f:	83 c4 0c             	add    $0xc,%esp
80100572:	29 f0                	sub    %esi,%eax
80100574:	01 c0                	add    %eax,%eax
80100576:	50                   	push   %eax
80100577:	8d 84 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%eax
8010057e:	6a 00                	push   $0x0
80100580:	50                   	push   %eax
80100581:	e8 0a 43 00 00       	call   80104890 <memset>
  outb(CRTPORT+1, pos);
80100586:	89 f0                	mov    %esi,%eax
80100588:	c6 45 e0 07          	movb   $0x7,-0x20(%ebp)
8010058c:	83 c4 10             	add    $0x10,%esp
8010058f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100592:	e9 2d ff ff ff       	jmp    801004c4 <cgaputc+0xc4>
80100597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059e:	66 90                	xchg   %ax,%ax
  pos |= inb(CRTPORT+1);
801005a0:	89 fe                	mov    %edi,%esi
    if(back_counter > 0) {
801005a2:	85 c0                	test   %eax,%eax
801005a4:	0f 8e f5 fe ff ff    	jle    8010049f <cgaputc+0x9f>
      back_counter--;
801005aa:	83 e8 01             	sub    $0x1,%eax
      ++pos;
801005ad:	83 c6 01             	add    $0x1,%esi
      back_counter--;
801005b0:	a3 10 ef 10 80       	mov    %eax,0x8010ef10
801005b5:	e9 e5 fe ff ff       	jmp    8010049f <cgaputc+0x9f>
801005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(back_counter < (strlen(input.buf) - backspaces)) {
801005c0:	83 ec 0c             	sub    $0xc,%esp
  pos |= inb(CRTPORT+1);
801005c3:	89 fe                	mov    %edi,%esi
    if(back_counter < (strlen(input.buf) - backspaces)) {
801005c5:	68 80 ee 10 80       	push   $0x8010ee80
801005ca:	e8 c1 44 00 00       	call   80104a90 <strlen>
801005cf:	8b 15 10 ef 10 80    	mov    0x8010ef10,%edx
801005d5:	2b 05 0c ef 10 80    	sub    0x8010ef0c,%eax
801005db:	83 c4 10             	add    $0x10,%esp
801005de:	39 d0                	cmp    %edx,%eax
801005e0:	0f 8e b9 fe ff ff    	jle    8010049f <cgaputc+0x9f>
      back_counter++;
801005e6:	83 c2 01             	add    $0x1,%edx
      --pos;
801005e9:	83 ee 01             	sub    $0x1,%esi
      back_counter++;
801005ec:	89 15 10 ef 10 80    	mov    %edx,0x8010ef10
801005f2:	e9 a8 fe ff ff       	jmp    8010049f <cgaputc+0x9f>
    panic("pos under/overflow");
801005f7:	83 ec 0c             	sub    $0xc,%esp
801005fa:	68 05 74 10 80       	push   $0x80107405
801005ff:	e8 7c fd ff ff       	call   80100380 <panic>
80100604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010060b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010060f:	90                   	nop

80100610 <consputc>:
  if(panicked){
80100610:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100616:	85 d2                	test   %edx,%edx
80100618:	74 06                	je     80100620 <consputc+0x10>
  asm volatile("cli");
8010061a:	fa                   	cli    
    for(;;)
8010061b:	eb fe                	jmp    8010061b <consputc+0xb>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	53                   	push   %ebx
80100624:	89 c3                	mov    %eax,%ebx
80100626:	83 ec 04             	sub    $0x4,%esp
  if(c == BACKSPACE){
80100629:	3d 00 01 00 00       	cmp    $0x100,%eax
8010062e:	74 17                	je     80100647 <consputc+0x37>
    uartputc(c);
80100630:	83 ec 0c             	sub    $0xc,%esp
80100633:	50                   	push   %eax
80100634:	e8 a7 58 00 00       	call   80105ee0 <uartputc>
80100639:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010063c:	89 d8                	mov    %ebx,%eax
}
8010063e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100641:	c9                   	leave  
  cgaputc(c);
80100642:	e9 b9 fd ff ff       	jmp    80100400 <cgaputc>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100647:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
8010064a:	83 05 0c ef 10 80 01 	addl   $0x1,0x8010ef0c
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100651:	6a 08                	push   $0x8
80100653:	e8 88 58 00 00       	call   80105ee0 <uartputc>
80100658:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010065f:	e8 7c 58 00 00       	call   80105ee0 <uartputc>
80100664:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010066b:	e8 70 58 00 00       	call   80105ee0 <uartputc>
80100670:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100673:	89 d8                	mov    %ebx,%eax
}
80100675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100678:	c9                   	leave  
  cgaputc(c);
80100679:	e9 82 fd ff ff       	jmp    80100400 <cgaputc>
8010067e:	66 90                	xchg   %ax,%ax

80100680 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100689:	ff 75 08             	push   0x8(%ebp)
{
8010068c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010068f:	e8 fc 13 00 00       	call   80101a90 <iunlock>
  acquire(&cons.lock);
80100694:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010069b:	e8 30 41 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++)
801006a0:	83 c4 10             	add    $0x10,%esp
801006a3:	85 f6                	test   %esi,%esi
801006a5:	7e 37                	jle    801006de <consolewrite+0x5e>
801006a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006aa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801006ad:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801006b3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801006b6:	85 d2                	test   %edx,%edx
801006b8:	74 06                	je     801006c0 <consolewrite+0x40>
801006ba:	fa                   	cli    
    for(;;)
801006bb:	eb fe                	jmp    801006bb <consolewrite+0x3b>
801006bd:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801006c0:	83 ec 0c             	sub    $0xc,%esp
801006c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < n; i++)
801006c6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801006c9:	50                   	push   %eax
801006ca:	e8 11 58 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
801006cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006d2:	e8 29 fd ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
801006d7:	83 c4 10             	add    $0x10,%esp
801006da:	39 df                	cmp    %ebx,%edi
801006dc:	75 cf                	jne    801006ad <consolewrite+0x2d>
  release(&cons.lock);
801006de:	83 ec 0c             	sub    $0xc,%esp
801006e1:	68 20 ef 10 80       	push   $0x8010ef20
801006e6:	e8 85 40 00 00       	call   80104770 <release>
  ilock(ip);
801006eb:	58                   	pop    %eax
801006ec:	ff 75 08             	push   0x8(%ebp)
801006ef:	e8 bc 12 00 00       	call   801019b0 <ilock>

  return n;
}
801006f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006f7:	89 f0                	mov    %esi,%eax
801006f9:	5b                   	pop    %ebx
801006fa:	5e                   	pop    %esi
801006fb:	5f                   	pop    %edi
801006fc:	5d                   	pop    %ebp
801006fd:	c3                   	ret    
801006fe:	66 90                	xchg   %ax,%ax

80100700 <printint>:
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 2c             	sub    $0x2c,%esp
80100709:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010070c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010070f:	85 c9                	test   %ecx,%ecx
80100711:	74 04                	je     80100717 <printint+0x17>
80100713:	85 c0                	test   %eax,%eax
80100715:	78 7e                	js     80100795 <printint+0x95>
    x = xx;
80100717:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010071e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100720:	31 db                	xor    %ebx,%ebx
80100722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100728:	89 c8                	mov    %ecx,%eax
8010072a:	31 d2                	xor    %edx,%edx
8010072c:	89 de                	mov    %ebx,%esi
8010072e:	89 cf                	mov    %ecx,%edi
80100730:	f7 75 d4             	divl   -0x2c(%ebp)
80100733:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100736:	0f b6 92 30 74 10 80 	movzbl -0x7fef8bd0(%edx),%edx
  }while((x /= base) != 0);
8010073d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010073f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100743:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
80100746:	76 e0                	jbe    80100728 <printint+0x28>
  if(sign)
80100748:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010074b:	85 c9                	test   %ecx,%ecx
8010074d:	74 0c                	je     8010075b <printint+0x5b>
    buf[i++] = '-';
8010074f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100754:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100756:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010075b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010075f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100764:	85 c0                	test   %eax,%eax
80100766:	74 08                	je     80100770 <printint+0x70>
80100768:	fa                   	cli    
    for(;;)
80100769:	eb fe                	jmp    80100769 <printint+0x69>
8010076b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010076f:	90                   	nop
    consputc(buf[i]);
80100770:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100773:	83 ec 0c             	sub    $0xc,%esp
80100776:	56                   	push   %esi
80100777:	e8 64 57 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
8010077c:	89 f0                	mov    %esi,%eax
8010077e:	e8 7d fc ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100783:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100786:	83 c4 10             	add    $0x10,%esp
80100789:	39 c3                	cmp    %eax,%ebx
8010078b:	74 0e                	je     8010079b <printint+0x9b>
    consputc(buf[i]);
8010078d:	0f b6 13             	movzbl (%ebx),%edx
80100790:	83 eb 01             	sub    $0x1,%ebx
80100793:	eb ca                	jmp    8010075f <printint+0x5f>
    x = -xx;
80100795:	f7 d8                	neg    %eax
80100797:	89 c1                	mov    %eax,%ecx
80100799:	eb 85                	jmp    80100720 <printint+0x20>
}
8010079b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010079e:	5b                   	pop    %ebx
8010079f:	5e                   	pop    %esi
801007a0:	5f                   	pop    %edi
801007a1:	5d                   	pop    %ebp
801007a2:	c3                   	ret    
801007a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801007b0 <cprintf>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
801007b5:	53                   	push   %ebx
801007b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007b9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801007be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801007c1:	85 c0                	test   %eax,%eax
801007c3:	0f 85 37 01 00 00    	jne    80100900 <cprintf+0x150>
  if (fmt == 0)
801007c9:	8b 75 08             	mov    0x8(%ebp),%esi
801007cc:	85 f6                	test   %esi,%esi
801007ce:	0f 84 32 02 00 00    	je     80100a06 <cprintf+0x256>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007d4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801007d7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007da:	31 db                	xor    %ebx,%ebx
801007dc:	85 c0                	test   %eax,%eax
801007de:	74 56                	je     80100836 <cprintf+0x86>
    if(c != '%'){
801007e0:	83 f8 25             	cmp    $0x25,%eax
801007e3:	0f 85 d7 00 00 00    	jne    801008c0 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801007e9:	83 c3 01             	add    $0x1,%ebx
801007ec:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801007f0:	85 d2                	test   %edx,%edx
801007f2:	74 42                	je     80100836 <cprintf+0x86>
    switch(c){
801007f4:	83 fa 70             	cmp    $0x70,%edx
801007f7:	0f 84 94 00 00 00    	je     80100891 <cprintf+0xe1>
801007fd:	7f 51                	jg     80100850 <cprintf+0xa0>
801007ff:	83 fa 25             	cmp    $0x25,%edx
80100802:	0f 84 10 01 00 00    	je     80100918 <cprintf+0x168>
80100808:	83 fa 64             	cmp    $0x64,%edx
8010080b:	0f 85 17 01 00 00    	jne    80100928 <cprintf+0x178>
      printint(*argp++, 10, 1);
80100811:	8d 47 04             	lea    0x4(%edi),%eax
80100814:	b9 01 00 00 00       	mov    $0x1,%ecx
80100819:	ba 0a 00 00 00       	mov    $0xa,%edx
8010081e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100821:	8b 07                	mov    (%edi),%eax
80100823:	e8 d8 fe ff ff       	call   80100700 <printint>
80100828:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010082b:	83 c3 01             	add    $0x1,%ebx
8010082e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100832:	85 c0                	test   %eax,%eax
80100834:	75 aa                	jne    801007e0 <cprintf+0x30>
  if(locking)
80100836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100839:	85 c0                	test   %eax,%eax
8010083b:	0f 85 a8 01 00 00    	jne    801009e9 <cprintf+0x239>
}
80100841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100844:	5b                   	pop    %ebx
80100845:	5e                   	pop    %esi
80100846:	5f                   	pop    %edi
80100847:	5d                   	pop    %ebp
80100848:	c3                   	ret    
80100849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100850:	83 fa 73             	cmp    $0x73,%edx
80100853:	75 33                	jne    80100888 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100855:	8d 47 04             	lea    0x4(%edi),%eax
80100858:	8b 3f                	mov    (%edi),%edi
8010085a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010085d:	85 ff                	test   %edi,%edi
8010085f:	0f 85 3b 01 00 00    	jne    801009a0 <cprintf+0x1f0>
        s = "(null)";
80100865:	bf 18 74 10 80       	mov    $0x80107418,%edi
      for(; *s; s++)
8010086a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010086d:	b8 28 00 00 00       	mov    $0x28,%eax
80100872:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100874:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010087a:	85 d2                	test   %edx,%edx
8010087c:	0f 84 38 01 00 00    	je     801009ba <cprintf+0x20a>
80100882:	fa                   	cli    
    for(;;)
80100883:	eb fe                	jmp    80100883 <cprintf+0xd3>
80100885:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100888:	83 fa 78             	cmp    $0x78,%edx
8010088b:	0f 85 97 00 00 00    	jne    80100928 <cprintf+0x178>
      printint(*argp++, 16, 0);
80100891:	8d 47 04             	lea    0x4(%edi),%eax
80100894:	31 c9                	xor    %ecx,%ecx
80100896:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010089b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010089e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008a1:	8b 07                	mov    (%edi),%eax
801008a3:	e8 58 fe ff ff       	call   80100700 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008a8:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801008ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008af:	85 c0                	test   %eax,%eax
801008b1:	0f 85 29 ff ff ff    	jne    801007e0 <cprintf+0x30>
801008b7:	e9 7a ff ff ff       	jmp    80100836 <cprintf+0x86>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801008c0:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801008c6:	85 c9                	test   %ecx,%ecx
801008c8:	74 06                	je     801008d0 <cprintf+0x120>
801008ca:	fa                   	cli    
    for(;;)
801008cb:	eb fe                	jmp    801008cb <cprintf+0x11b>
801008cd:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008d6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801008d9:	50                   	push   %eax
801008da:	e8 01 56 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
801008df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008e2:	e8 19 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008e7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801008eb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008ee:	85 c0                	test   %eax,%eax
801008f0:	0f 85 ea fe ff ff    	jne    801007e0 <cprintf+0x30>
801008f6:	e9 3b ff ff ff       	jmp    80100836 <cprintf+0x86>
801008fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008ff:	90                   	nop
    acquire(&cons.lock);
80100900:	83 ec 0c             	sub    $0xc,%esp
80100903:	68 20 ef 10 80       	push   $0x8010ef20
80100908:	e8 c3 3e 00 00       	call   801047d0 <acquire>
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	e9 b4 fe ff ff       	jmp    801007c9 <cprintf+0x19>
80100915:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100918:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010091d:	85 c0                	test   %eax,%eax
8010091f:	74 4f                	je     80100970 <cprintf+0x1c0>
80100921:	fa                   	cli    
    for(;;)
80100922:	eb fe                	jmp    80100922 <cprintf+0x172>
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100928:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
8010092e:	85 c9                	test   %ecx,%ecx
80100930:	74 06                	je     80100938 <cprintf+0x188>
80100932:	fa                   	cli    
    for(;;)
80100933:	eb fe                	jmp    80100933 <cprintf+0x183>
80100935:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100938:	83 ec 0c             	sub    $0xc,%esp
8010093b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010093e:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100941:	6a 25                	push   $0x25
80100943:	e8 98 55 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
80100948:	b8 25 00 00 00       	mov    $0x25,%eax
8010094d:	e8 ae fa ff ff       	call   80100400 <cgaputc>
      consputc(c);
80100952:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100955:	e8 b6 fc ff ff       	call   80100610 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010095a:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      break;
8010095e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100961:	85 c0                	test   %eax,%eax
80100963:	0f 85 77 fe ff ff    	jne    801007e0 <cprintf+0x30>
80100969:	e9 c8 fe ff ff       	jmp    80100836 <cprintf+0x86>
8010096e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100970:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100973:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100976:	6a 25                	push   $0x25
80100978:	e8 63 55 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
8010097d:	b8 25 00 00 00       	mov    $0x25,%eax
80100982:	e8 79 fa ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100987:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010098b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010098e:	85 c0                	test   %eax,%eax
80100990:	0f 85 4a fe ff ff    	jne    801007e0 <cprintf+0x30>
80100996:	e9 9b fe ff ff       	jmp    80100836 <cprintf+0x86>
8010099b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010099f:	90                   	nop
      for(; *s; s++)
801009a0:	0f b6 07             	movzbl (%edi),%eax
801009a3:	84 c0                	test   %al,%al
801009a5:	74 57                	je     801009fe <cprintf+0x24e>
  if(panicked){
801009a7:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801009ad:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801009b0:	89 fb                	mov    %edi,%ebx
801009b2:	85 d2                	test   %edx,%edx
801009b4:	0f 85 c8 fe ff ff    	jne    80100882 <cprintf+0xd2>
    uartputc(c);
801009ba:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
801009bd:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
801009c0:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801009c3:	57                   	push   %edi
801009c4:	e8 17 55 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
801009c9:	89 f8                	mov    %edi,%eax
801009cb:	e8 30 fa ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
801009d0:	0f b6 03             	movzbl (%ebx),%eax
801009d3:	83 c4 10             	add    $0x10,%esp
801009d6:	84 c0                	test   %al,%al
801009d8:	0f 85 96 fe ff ff    	jne    80100874 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
801009de:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801009e1:	8b 7d e0             	mov    -0x20(%ebp),%edi
801009e4:	e9 42 fe ff ff       	jmp    8010082b <cprintf+0x7b>
    release(&cons.lock);
801009e9:	83 ec 0c             	sub    $0xc,%esp
801009ec:	68 20 ef 10 80       	push   $0x8010ef20
801009f1:	e8 7a 3d 00 00       	call   80104770 <release>
801009f6:	83 c4 10             	add    $0x10,%esp
}
801009f9:	e9 43 fe ff ff       	jmp    80100841 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801009fe:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100a01:	e9 25 fe ff ff       	jmp    8010082b <cprintf+0x7b>
    panic("null fmt");
80100a06:	83 ec 0c             	sub    $0xc,%esp
80100a09:	68 1f 74 10 80       	push   $0x8010741f
80100a0e:	e8 6d f9 ff ff       	call   80100380 <panic>
80100a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a20 <consoleintr>:
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	57                   	push   %edi
  int c, doprocdump = 0;
80100a24:	31 ff                	xor    %edi,%edi
{
80100a26:	56                   	push   %esi
80100a27:	53                   	push   %ebx
80100a28:	83 ec 18             	sub    $0x18,%esp
80100a2b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100a2e:	68 20 ef 10 80       	push   $0x8010ef20
80100a33:	e8 98 3d 00 00       	call   801047d0 <acquire>
  while((c = getc()) >= 0){
80100a38:	83 c4 10             	add    $0x10,%esp
80100a3b:	ff d6                	call   *%esi
80100a3d:	89 c3                	mov    %eax,%ebx
80100a3f:	85 c0                	test   %eax,%eax
80100a41:	78 7b                	js     80100abe <consoleintr+0x9e>
    switch(c){
80100a43:	83 fb 7f             	cmp    $0x7f,%ebx
80100a46:	0f 84 34 01 00 00    	je     80100b80 <consoleintr+0x160>
80100a4c:	7f 4a                	jg     80100a98 <consoleintr+0x78>
80100a4e:	83 fb 10             	cmp    $0x10,%ebx
80100a51:	0f 84 19 01 00 00    	je     80100b70 <consoleintr+0x150>
80100a57:	83 fb 15             	cmp    $0x15,%ebx
80100a5a:	0f 85 80 00 00 00    	jne    80100ae0 <consoleintr+0xc0>
      while(input.e != input.w &&
80100a60:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a65:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100a6b:	74 ce                	je     80100a3b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a6d:	83 e8 01             	sub    $0x1,%eax
80100a70:	89 c2                	mov    %eax,%edx
80100a72:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a75:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a7c:	74 bd                	je     80100a3b <consoleintr+0x1b>
  if(panicked){
80100a7e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a84:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a89:	85 d2                	test   %edx,%edx
80100a8b:	0f 84 4e 01 00 00    	je     80100bdf <consoleintr+0x1bf>
80100a91:	fa                   	cli    
    for(;;)
80100a92:	eb fe                	jmp    80100a92 <consoleintr+0x72>
80100a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100a98:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100a9e:	0f 84 2c 01 00 00    	je     80100bd0 <consoleintr+0x1b0>
80100aa4:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100aaa:	75 45                	jne    80100af1 <consoleintr+0xd1>
      cgaputc(c);
80100aac:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100ab1:	e8 4a f9 ff ff       	call   80100400 <cgaputc>
  while((c = getc()) >= 0){
80100ab6:	ff d6                	call   *%esi
80100ab8:	89 c3                	mov    %eax,%ebx
80100aba:	85 c0                	test   %eax,%eax
80100abc:	79 85                	jns    80100a43 <consoleintr+0x23>
  release(&cons.lock);
80100abe:	83 ec 0c             	sub    $0xc,%esp
80100ac1:	68 20 ef 10 80       	push   $0x8010ef20
80100ac6:	e8 a5 3c 00 00       	call   80104770 <release>
  if(doprocdump) {
80100acb:	83 c4 10             	add    $0x10,%esp
80100ace:	85 ff                	test   %edi,%edi
80100ad0:	0f 85 55 01 00 00    	jne    80100c2b <consoleintr+0x20b>
}
80100ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ad9:	5b                   	pop    %ebx
80100ada:	5e                   	pop    %esi
80100adb:	5f                   	pop    %edi
80100adc:	5d                   	pop    %ebp
80100add:	c3                   	ret    
80100ade:	66 90                	xchg   %ax,%ax
    switch(c){
80100ae0:	83 fb 08             	cmp    $0x8,%ebx
80100ae3:	0f 84 97 00 00 00    	je     80100b80 <consoleintr+0x160>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100ae9:	85 db                	test   %ebx,%ebx
80100aeb:	0f 84 4a ff ff ff    	je     80100a3b <consoleintr+0x1b>
80100af1:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100af6:	89 c2                	mov    %eax,%edx
80100af8:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100afe:	83 fa 7f             	cmp    $0x7f,%edx
80100b01:	0f 87 34 ff ff ff    	ja     80100a3b <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b07:	8d 50 01             	lea    0x1(%eax),%edx
80100b0a:	83 e0 7f             	and    $0x7f,%eax
80100b0d:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100b13:	83 fb 0d             	cmp    $0xd,%ebx
80100b16:	0f 84 1b 01 00 00    	je     80100c37 <consoleintr+0x217>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b1c:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
        consputc(c);
80100b22:	89 d8                	mov    %ebx,%eax
80100b24:	e8 e7 fa ff ff       	call   80100610 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b29:	83 fb 0a             	cmp    $0xa,%ebx
80100b2c:	0f 84 16 01 00 00    	je     80100c48 <consoleintr+0x228>
80100b32:	83 fb 04             	cmp    $0x4,%ebx
80100b35:	0f 84 0d 01 00 00    	je     80100c48 <consoleintr+0x228>
80100b3b:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100b40:	83 e8 80             	sub    $0xffffff80,%eax
80100b43:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100b49:	0f 85 ec fe ff ff    	jne    80100a3b <consoleintr+0x1b>
          wakeup(&input.r);
80100b4f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100b52:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100b57:	68 00 ef 10 80       	push   $0x8010ef00
80100b5c:	e8 cf 37 00 00       	call   80104330 <wakeup>
80100b61:	83 c4 10             	add    $0x10,%esp
80100b64:	e9 d2 fe ff ff       	jmp    80100a3b <consoleintr+0x1b>
80100b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100b70:	bf 01 00 00 00       	mov    $0x1,%edi
80100b75:	e9 c1 fe ff ff       	jmp    80100a3b <consoleintr+0x1b>
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w && back_counter < (strlen(input.buf) - backspaces)){
80100b80:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80100b85:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100b8b:	0f 84 aa fe ff ff    	je     80100a3b <consoleintr+0x1b>
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	68 80 ee 10 80       	push   $0x8010ee80
80100b99:	e8 f2 3e 00 00       	call   80104a90 <strlen>
80100b9e:	8b 15 0c ef 10 80    	mov    0x8010ef0c,%edx
80100ba4:	83 c4 10             	add    $0x10,%esp
80100ba7:	29 d0                	sub    %edx,%eax
80100ba9:	3b 05 10 ef 10 80    	cmp    0x8010ef10,%eax
80100baf:	0f 8e 86 fe ff ff    	jle    80100a3b <consoleintr+0x1b>
  if(panicked){
80100bb5:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
        input.e--;
80100bba:	83 2d 08 ef 10 80 01 	subl   $0x1,0x8010ef08
  if(panicked){
80100bc1:	85 c0                	test   %eax,%eax
80100bc3:	0f 84 89 00 00 00    	je     80100c52 <consoleintr+0x232>
80100bc9:	fa                   	cli    
    for(;;)
80100bca:	eb fe                	jmp    80100bca <consoleintr+0x1aa>
80100bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cgaputc(c);
80100bd0:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100bd5:	e8 26 f8 ff ff       	call   80100400 <cgaputc>
      break;
80100bda:	e9 5c fe ff ff       	jmp    80100a3b <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100bdf:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100be2:	83 05 0c ef 10 80 01 	addl   $0x1,0x8010ef0c
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100be9:	6a 08                	push   $0x8
80100beb:	e8 f0 52 00 00       	call   80105ee0 <uartputc>
80100bf0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100bf7:	e8 e4 52 00 00       	call   80105ee0 <uartputc>
80100bfc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100c03:	e8 d8 52 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
80100c08:	b8 00 01 00 00       	mov    $0x100,%eax
80100c0d:	e8 ee f7 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100c12:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100c17:	83 c4 10             	add    $0x10,%esp
80100c1a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100c20:	0f 85 47 fe ff ff    	jne    80100a6d <consoleintr+0x4d>
80100c26:	e9 10 fe ff ff       	jmp    80100a3b <consoleintr+0x1b>
}
80100c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c2e:	5b                   	pop    %ebx
80100c2f:	5e                   	pop    %esi
80100c30:	5f                   	pop    %edi
80100c31:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100c32:	e9 d9 37 00 00       	jmp    80104410 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c37:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
        consputc(c);
80100c3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100c43:	e8 c8 f9 ff ff       	call   80100610 <consputc>
          input.w = input.e;
80100c48:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100c4d:	e9 fd fe ff ff       	jmp    80100b4f <consoleintr+0x12f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100c52:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100c55:	83 c2 01             	add    $0x1,%edx
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100c58:	6a 08                	push   $0x8
    backspaces++;
80100c5a:	89 15 0c ef 10 80    	mov    %edx,0x8010ef0c
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100c60:	e8 7b 52 00 00       	call   80105ee0 <uartputc>
80100c65:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100c6c:	e8 6f 52 00 00       	call   80105ee0 <uartputc>
80100c71:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100c78:	e8 63 52 00 00       	call   80105ee0 <uartputc>
  cgaputc(c);
80100c7d:	b8 00 01 00 00       	mov    $0x100,%eax
80100c82:	e8 79 f7 ff ff       	call   80100400 <cgaputc>
}
80100c87:	83 c4 10             	add    $0x10,%esp
80100c8a:	e9 ac fd ff ff       	jmp    80100a3b <consoleintr+0x1b>
80100c8f:	90                   	nop

80100c90 <consoleinit>:

void
consoleinit(void)
{
80100c90:	55                   	push   %ebp
80100c91:	89 e5                	mov    %esp,%ebp
80100c93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100c96:	68 28 74 10 80       	push   $0x80107428
80100c9b:	68 20 ef 10 80       	push   $0x8010ef20
80100ca0:	e8 5b 39 00 00       	call   80104600 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ca5:	58                   	pop    %eax
80100ca6:	5a                   	pop    %edx
80100ca7:	6a 00                	push   $0x0
80100ca9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100cab:	c7 05 0c f9 10 80 80 	movl   $0x80100680,0x8010f90c
80100cb2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100cb5:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100cbc:	02 10 80 
  cons.locking = 1;
80100cbf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100cc6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100cc9:	e8 e2 19 00 00       	call   801026b0 <ioapicenable>
}
80100cce:	83 c4 10             	add    $0x10,%esp
80100cd1:	c9                   	leave  
80100cd2:	c3                   	ret    
80100cd3:	66 90                	xchg   %ax,%ax
80100cd5:	66 90                	xchg   %ax,%ax
80100cd7:	66 90                	xchg   %ax,%ax
80100cd9:	66 90                	xchg   %ax,%ax
80100cdb:	66 90                	xchg   %ax,%ax
80100cdd:	66 90                	xchg   %ax,%ax
80100cdf:	90                   	nop

80100ce0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ce0:	55                   	push   %ebp
80100ce1:	89 e5                	mov    %esp,%ebp
80100ce3:	57                   	push   %edi
80100ce4:	56                   	push   %esi
80100ce5:	53                   	push   %ebx
80100ce6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100cec:	e8 af 2e 00 00       	call   80103ba0 <myproc>
80100cf1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100cf7:	e8 94 22 00 00       	call   80102f90 <begin_op>

  if((ip = namei(path)) == 0){
80100cfc:	83 ec 0c             	sub    $0xc,%esp
80100cff:	ff 75 08             	push   0x8(%ebp)
80100d02:	e8 c9 15 00 00       	call   801022d0 <namei>
80100d07:	83 c4 10             	add    $0x10,%esp
80100d0a:	85 c0                	test   %eax,%eax
80100d0c:	0f 84 02 03 00 00    	je     80101014 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d12:	83 ec 0c             	sub    $0xc,%esp
80100d15:	89 c3                	mov    %eax,%ebx
80100d17:	50                   	push   %eax
80100d18:	e8 93 0c 00 00       	call   801019b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d23:	6a 34                	push   $0x34
80100d25:	6a 00                	push   $0x0
80100d27:	50                   	push   %eax
80100d28:	53                   	push   %ebx
80100d29:	e8 92 0f 00 00       	call   80101cc0 <readi>
80100d2e:	83 c4 20             	add    $0x20,%esp
80100d31:	83 f8 34             	cmp    $0x34,%eax
80100d34:	74 22                	je     80100d58 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100d36:	83 ec 0c             	sub    $0xc,%esp
80100d39:	53                   	push   %ebx
80100d3a:	e8 01 0f 00 00       	call   80101c40 <iunlockput>
    end_op();
80100d3f:	e8 bc 22 00 00       	call   80103000 <end_op>
80100d44:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d4f:	5b                   	pop    %ebx
80100d50:	5e                   	pop    %esi
80100d51:	5f                   	pop    %edi
80100d52:	5d                   	pop    %ebp
80100d53:	c3                   	ret    
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100d58:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d5f:	45 4c 46 
80100d62:	75 d2                	jne    80100d36 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100d64:	e8 07 63 00 00       	call   80107070 <setupkvm>
80100d69:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d6f:	85 c0                	test   %eax,%eax
80100d71:	74 c3                	je     80100d36 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d73:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100d7a:	00 
80100d7b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100d81:	0f 84 ac 02 00 00    	je     80101033 <exec+0x353>
  sz = 0;
80100d87:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d8e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d91:	31 ff                	xor    %edi,%edi
80100d93:	e9 8e 00 00 00       	jmp    80100e26 <exec+0x146>
80100d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d9f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100da0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100da7:	75 6c                	jne    80100e15 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100da9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100daf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100db5:	0f 82 87 00 00 00    	jb     80100e42 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100dbb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100dc1:	72 7f                	jb     80100e42 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100dc3:	83 ec 04             	sub    $0x4,%esp
80100dc6:	50                   	push   %eax
80100dc7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100dcd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dd3:	e8 b8 60 00 00       	call   80106e90 <allocuvm>
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100de1:	85 c0                	test   %eax,%eax
80100de3:	74 5d                	je     80100e42 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100de5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100deb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100df0:	75 50                	jne    80100e42 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100df2:	83 ec 0c             	sub    $0xc,%esp
80100df5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100dfb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100e01:	53                   	push   %ebx
80100e02:	50                   	push   %eax
80100e03:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e09:	e8 92 5f 00 00       	call   80106da0 <loaduvm>
80100e0e:	83 c4 20             	add    $0x20,%esp
80100e11:	85 c0                	test   %eax,%eax
80100e13:	78 2d                	js     80100e42 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e15:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e1c:	83 c7 01             	add    $0x1,%edi
80100e1f:	83 c6 20             	add    $0x20,%esi
80100e22:	39 f8                	cmp    %edi,%eax
80100e24:	7e 3a                	jle    80100e60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e26:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e2c:	6a 20                	push   $0x20
80100e2e:	56                   	push   %esi
80100e2f:	50                   	push   %eax
80100e30:	53                   	push   %ebx
80100e31:	e8 8a 0e 00 00       	call   80101cc0 <readi>
80100e36:	83 c4 10             	add    $0x10,%esp
80100e39:	83 f8 20             	cmp    $0x20,%eax
80100e3c:	0f 84 5e ff ff ff    	je     80100da0 <exec+0xc0>
    freevm(pgdir);
80100e42:	83 ec 0c             	sub    $0xc,%esp
80100e45:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e4b:	e8 a0 61 00 00       	call   80106ff0 <freevm>
  if(ip){
80100e50:	83 c4 10             	add    $0x10,%esp
80100e53:	e9 de fe ff ff       	jmp    80100d36 <exec+0x56>
80100e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
  sz = PGROUNDUP(sz);
80100e60:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e66:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100e6c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e72:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100e78:	83 ec 0c             	sub    $0xc,%esp
80100e7b:	53                   	push   %ebx
80100e7c:	e8 bf 0d 00 00       	call   80101c40 <iunlockput>
  end_op();
80100e81:	e8 7a 21 00 00       	call   80103000 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e86:	83 c4 0c             	add    $0xc,%esp
80100e89:	56                   	push   %esi
80100e8a:	57                   	push   %edi
80100e8b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e91:	57                   	push   %edi
80100e92:	e8 f9 5f 00 00       	call   80106e90 <allocuvm>
80100e97:	83 c4 10             	add    $0x10,%esp
80100e9a:	89 c6                	mov    %eax,%esi
80100e9c:	85 c0                	test   %eax,%eax
80100e9e:	0f 84 94 00 00 00    	je     80100f38 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ea4:	83 ec 08             	sub    $0x8,%esp
80100ea7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100ead:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100eaf:	50                   	push   %eax
80100eb0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100eb1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100eb3:	e8 58 62 00 00       	call   80107110 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ebb:	83 c4 10             	add    $0x10,%esp
80100ebe:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100ec4:	8b 00                	mov    (%eax),%eax
80100ec6:	85 c0                	test   %eax,%eax
80100ec8:	0f 84 8b 00 00 00    	je     80100f59 <exec+0x279>
80100ece:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ed4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100eda:	eb 23                	jmp    80100eff <exec+0x21f>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ee3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100eea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100eed:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ef3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ef6:	85 c0                	test   %eax,%eax
80100ef8:	74 59                	je     80100f53 <exec+0x273>
    if(argc >= MAXARG)
80100efa:	83 ff 20             	cmp    $0x20,%edi
80100efd:	74 39                	je     80100f38 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	50                   	push   %eax
80100f03:	e8 88 3b 00 00       	call   80104a90 <strlen>
80100f08:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f0a:	58                   	pop    %eax
80100f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f0e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f11:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f14:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f17:	e8 74 3b 00 00       	call   80104a90 <strlen>
80100f1c:	83 c0 01             	add    $0x1,%eax
80100f1f:	50                   	push   %eax
80100f20:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f23:	ff 34 b8             	push   (%eax,%edi,4)
80100f26:	53                   	push   %ebx
80100f27:	56                   	push   %esi
80100f28:	e8 b3 63 00 00       	call   801072e0 <copyout>
80100f2d:	83 c4 20             	add    $0x20,%esp
80100f30:	85 c0                	test   %eax,%eax
80100f32:	79 ac                	jns    80100ee0 <exec+0x200>
80100f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f41:	e8 aa 60 00 00       	call   80106ff0 <freevm>
80100f46:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f4e:	e9 f9 fd ff ff       	jmp    80100d4c <exec+0x6c>
80100f53:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f59:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100f60:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100f62:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100f69:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f6d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100f6f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100f72:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100f78:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f7a:	50                   	push   %eax
80100f7b:	52                   	push   %edx
80100f7c:	53                   	push   %ebx
80100f7d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100f83:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100f8a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f8d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f93:	e8 48 63 00 00       	call   801072e0 <copyout>
80100f98:	83 c4 10             	add    $0x10,%esp
80100f9b:	85 c0                	test   %eax,%eax
80100f9d:	78 99                	js     80100f38 <exec+0x258>
  for(last=s=path; *s; s++)
80100f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa2:	8b 55 08             	mov    0x8(%ebp),%edx
80100fa5:	0f b6 00             	movzbl (%eax),%eax
80100fa8:	84 c0                	test   %al,%al
80100faa:	74 13                	je     80100fbf <exec+0x2df>
80100fac:	89 d1                	mov    %edx,%ecx
80100fae:	66 90                	xchg   %ax,%ax
      last = s+1;
80100fb0:	83 c1 01             	add    $0x1,%ecx
80100fb3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100fb5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100fb8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100fbb:	84 c0                	test   %al,%al
80100fbd:	75 f1                	jne    80100fb0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fbf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100fc5:	83 ec 04             	sub    $0x4,%esp
80100fc8:	6a 10                	push   $0x10
80100fca:	89 f8                	mov    %edi,%eax
80100fcc:	52                   	push   %edx
80100fcd:	83 c0 6c             	add    $0x6c,%eax
80100fd0:	50                   	push   %eax
80100fd1:	e8 7a 3a 00 00       	call   80104a50 <safestrcpy>
  curproc->pgdir = pgdir;
80100fd6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100fdc:	89 f8                	mov    %edi,%eax
80100fde:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100fe1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100fe3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fe6:	89 c1                	mov    %eax,%ecx
80100fe8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100fee:	8b 40 18             	mov    0x18(%eax),%eax
80100ff1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ff4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ff7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100ffa:	89 0c 24             	mov    %ecx,(%esp)
80100ffd:	e8 0e 5c 00 00       	call   80106c10 <switchuvm>
  freevm(oldpgdir);
80101002:	89 3c 24             	mov    %edi,(%esp)
80101005:	e8 e6 5f 00 00       	call   80106ff0 <freevm>
  return 0;
8010100a:	83 c4 10             	add    $0x10,%esp
8010100d:	31 c0                	xor    %eax,%eax
8010100f:	e9 38 fd ff ff       	jmp    80100d4c <exec+0x6c>
    end_op();
80101014:	e8 e7 1f 00 00       	call   80103000 <end_op>
    cprintf("exec: fail\n");
80101019:	83 ec 0c             	sub    $0xc,%esp
8010101c:	68 41 74 10 80       	push   $0x80107441
80101021:	e8 8a f7 ff ff       	call   801007b0 <cprintf>
    return -1;
80101026:	83 c4 10             	add    $0x10,%esp
80101029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010102e:	e9 19 fd ff ff       	jmp    80100d4c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101033:	be 00 20 00 00       	mov    $0x2000,%esi
80101038:	31 ff                	xor    %edi,%edi
8010103a:	e9 39 fe ff ff       	jmp    80100e78 <exec+0x198>
8010103f:	90                   	nop

80101040 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101046:	68 4d 74 10 80       	push   $0x8010744d
8010104b:	68 60 ef 10 80       	push   $0x8010ef60
80101050:	e8 ab 35 00 00       	call   80104600 <initlock>
}
80101055:	83 c4 10             	add    $0x10,%esp
80101058:	c9                   	leave  
80101059:	c3                   	ret    
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101060 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101064:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80101069:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010106c:	68 60 ef 10 80       	push   $0x8010ef60
80101071:	e8 5a 37 00 00       	call   801047d0 <acquire>
80101076:	83 c4 10             	add    $0x10,%esp
80101079:	eb 10                	jmp    8010108b <filealloc+0x2b>
8010107b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010107f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101080:	83 c3 18             	add    $0x18,%ebx
80101083:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80101089:	74 25                	je     801010b0 <filealloc+0x50>
    if(f->ref == 0){
8010108b:	8b 43 04             	mov    0x4(%ebx),%eax
8010108e:	85 c0                	test   %eax,%eax
80101090:	75 ee                	jne    80101080 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101092:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101095:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010109c:	68 60 ef 10 80       	push   $0x8010ef60
801010a1:	e8 ca 36 00 00       	call   80104770 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801010a6:	89 d8                	mov    %ebx,%eax
      return f;
801010a8:	83 c4 10             	add    $0x10,%esp
}
801010ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010ae:	c9                   	leave  
801010af:	c3                   	ret    
  release(&ftable.lock);
801010b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801010b3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801010b5:	68 60 ef 10 80       	push   $0x8010ef60
801010ba:	e8 b1 36 00 00       	call   80104770 <release>
}
801010bf:	89 d8                	mov    %ebx,%eax
  return 0;
801010c1:	83 c4 10             	add    $0x10,%esp
}
801010c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010c7:	c9                   	leave  
801010c8:	c3                   	ret    
801010c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	53                   	push   %ebx
801010d4:	83 ec 10             	sub    $0x10,%esp
801010d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801010da:	68 60 ef 10 80       	push   $0x8010ef60
801010df:	e8 ec 36 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
801010e4:	8b 43 04             	mov    0x4(%ebx),%eax
801010e7:	83 c4 10             	add    $0x10,%esp
801010ea:	85 c0                	test   %eax,%eax
801010ec:	7e 1a                	jle    80101108 <filedup+0x38>
    panic("filedup");
  f->ref++;
801010ee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801010f1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801010f4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801010f7:	68 60 ef 10 80       	push   $0x8010ef60
801010fc:	e8 6f 36 00 00       	call   80104770 <release>
  return f;
}
80101101:	89 d8                	mov    %ebx,%eax
80101103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101106:	c9                   	leave  
80101107:	c3                   	ret    
    panic("filedup");
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	68 54 74 10 80       	push   $0x80107454
80101110:	e8 6b f2 ff ff       	call   80100380 <panic>
80101115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 28             	sub    $0x28,%esp
80101129:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010112c:	68 60 ef 10 80       	push   $0x8010ef60
80101131:	e8 9a 36 00 00       	call   801047d0 <acquire>
  if(f->ref < 1)
80101136:	8b 53 04             	mov    0x4(%ebx),%edx
80101139:	83 c4 10             	add    $0x10,%esp
8010113c:	85 d2                	test   %edx,%edx
8010113e:	0f 8e a5 00 00 00    	jle    801011e9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101144:	83 ea 01             	sub    $0x1,%edx
80101147:	89 53 04             	mov    %edx,0x4(%ebx)
8010114a:	75 44                	jne    80101190 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010114c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101150:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101153:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010115b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010115e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101161:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101164:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80101169:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010116c:	e8 ff 35 00 00       	call   80104770 <release>

  if(ff.type == FD_PIPE)
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	83 ff 01             	cmp    $0x1,%edi
80101177:	74 57                	je     801011d0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101179:	83 ff 02             	cmp    $0x2,%edi
8010117c:	74 2a                	je     801011a8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010117e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101181:	5b                   	pop    %ebx
80101182:	5e                   	pop    %esi
80101183:	5f                   	pop    %edi
80101184:	5d                   	pop    %ebp
80101185:	c3                   	ret    
80101186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010118d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101190:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80101197:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119a:	5b                   	pop    %ebx
8010119b:	5e                   	pop    %esi
8010119c:	5f                   	pop    %edi
8010119d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010119e:	e9 cd 35 00 00       	jmp    80104770 <release>
801011a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011a7:	90                   	nop
    begin_op();
801011a8:	e8 e3 1d 00 00       	call   80102f90 <begin_op>
    iput(ff.ip);
801011ad:	83 ec 0c             	sub    $0xc,%esp
801011b0:	ff 75 e0             	push   -0x20(%ebp)
801011b3:	e8 28 09 00 00       	call   80101ae0 <iput>
    end_op();
801011b8:	83 c4 10             	add    $0x10,%esp
}
801011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011be:	5b                   	pop    %ebx
801011bf:	5e                   	pop    %esi
801011c0:	5f                   	pop    %edi
801011c1:	5d                   	pop    %ebp
    end_op();
801011c2:	e9 39 1e 00 00       	jmp    80103000 <end_op>
801011c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011ce:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801011d0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	53                   	push   %ebx
801011d8:	56                   	push   %esi
801011d9:	e8 82 25 00 00       	call   80103760 <pipeclose>
801011de:	83 c4 10             	add    $0x10,%esp
}
801011e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e4:	5b                   	pop    %ebx
801011e5:	5e                   	pop    %esi
801011e6:	5f                   	pop    %edi
801011e7:	5d                   	pop    %ebp
801011e8:	c3                   	ret    
    panic("fileclose");
801011e9:	83 ec 0c             	sub    $0xc,%esp
801011ec:	68 5c 74 10 80       	push   $0x8010745c
801011f1:	e8 8a f1 ff ff       	call   80100380 <panic>
801011f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011fd:	8d 76 00             	lea    0x0(%esi),%esi

80101200 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	53                   	push   %ebx
80101204:	83 ec 04             	sub    $0x4,%esp
80101207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010120a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010120d:	75 31                	jne    80101240 <filestat+0x40>
    ilock(f->ip);
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	ff 73 10             	push   0x10(%ebx)
80101215:	e8 96 07 00 00       	call   801019b0 <ilock>
    stati(f->ip, st);
8010121a:	58                   	pop    %eax
8010121b:	5a                   	pop    %edx
8010121c:	ff 75 0c             	push   0xc(%ebp)
8010121f:	ff 73 10             	push   0x10(%ebx)
80101222:	e8 69 0a 00 00       	call   80101c90 <stati>
    iunlock(f->ip);
80101227:	59                   	pop    %ecx
80101228:	ff 73 10             	push   0x10(%ebx)
8010122b:	e8 60 08 00 00       	call   80101a90 <iunlock>
    return 0;
  }
  return -1;
}
80101230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101233:	83 c4 10             	add    $0x10,%esp
80101236:	31 c0                	xor    %eax,%eax
}
80101238:	c9                   	leave  
80101239:	c3                   	ret    
8010123a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101248:	c9                   	leave  
80101249:	c3                   	ret    
8010124a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101250 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 0c             	sub    $0xc,%esp
80101259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010125c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010125f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101262:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101266:	74 60                	je     801012c8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101268:	8b 03                	mov    (%ebx),%eax
8010126a:	83 f8 01             	cmp    $0x1,%eax
8010126d:	74 41                	je     801012b0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010126f:	83 f8 02             	cmp    $0x2,%eax
80101272:	75 5b                	jne    801012cf <fileread+0x7f>
    ilock(f->ip);
80101274:	83 ec 0c             	sub    $0xc,%esp
80101277:	ff 73 10             	push   0x10(%ebx)
8010127a:	e8 31 07 00 00       	call   801019b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010127f:	57                   	push   %edi
80101280:	ff 73 14             	push   0x14(%ebx)
80101283:	56                   	push   %esi
80101284:	ff 73 10             	push   0x10(%ebx)
80101287:	e8 34 0a 00 00       	call   80101cc0 <readi>
8010128c:	83 c4 20             	add    $0x20,%esp
8010128f:	89 c6                	mov    %eax,%esi
80101291:	85 c0                	test   %eax,%eax
80101293:	7e 03                	jle    80101298 <fileread+0x48>
      f->off += r;
80101295:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101298:	83 ec 0c             	sub    $0xc,%esp
8010129b:	ff 73 10             	push   0x10(%ebx)
8010129e:	e8 ed 07 00 00       	call   80101a90 <iunlock>
    return r;
801012a3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801012a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a9:	89 f0                	mov    %esi,%eax
801012ab:	5b                   	pop    %ebx
801012ac:	5e                   	pop    %esi
801012ad:	5f                   	pop    %edi
801012ae:	5d                   	pop    %ebp
801012af:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801012b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801012b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b9:	5b                   	pop    %ebx
801012ba:	5e                   	pop    %esi
801012bb:	5f                   	pop    %edi
801012bc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801012bd:	e9 3e 26 00 00       	jmp    80103900 <piperead>
801012c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801012c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801012cd:	eb d7                	jmp    801012a6 <fileread+0x56>
  panic("fileread");
801012cf:	83 ec 0c             	sub    $0xc,%esp
801012d2:	68 66 74 10 80       	push   $0x80107466
801012d7:	e8 a4 f0 ff ff       	call   80100380 <panic>
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	83 ec 1c             	sub    $0x1c,%esp
801012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801012ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
801012ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
801012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801012f5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801012f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801012fc:	0f 84 bd 00 00 00    	je     801013bf <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101302:	8b 03                	mov    (%ebx),%eax
80101304:	83 f8 01             	cmp    $0x1,%eax
80101307:	0f 84 bf 00 00 00    	je     801013cc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010130d:	83 f8 02             	cmp    $0x2,%eax
80101310:	0f 85 c8 00 00 00    	jne    801013de <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101319:	31 f6                	xor    %esi,%esi
    while(i < n){
8010131b:	85 c0                	test   %eax,%eax
8010131d:	7f 30                	jg     8010134f <filewrite+0x6f>
8010131f:	e9 94 00 00 00       	jmp    801013b8 <filewrite+0xd8>
80101324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101328:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010132b:	83 ec 0c             	sub    $0xc,%esp
8010132e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101331:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101334:	e8 57 07 00 00       	call   80101a90 <iunlock>
      end_op();
80101339:	e8 c2 1c 00 00       	call   80103000 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010133e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101341:	83 c4 10             	add    $0x10,%esp
80101344:	39 c7                	cmp    %eax,%edi
80101346:	75 5c                	jne    801013a4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101348:	01 fe                	add    %edi,%esi
    while(i < n){
8010134a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010134d:	7e 69                	jle    801013b8 <filewrite+0xd8>
      int n1 = n - i;
8010134f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101352:	b8 00 06 00 00       	mov    $0x600,%eax
80101357:	29 f7                	sub    %esi,%edi
80101359:	39 c7                	cmp    %eax,%edi
8010135b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010135e:	e8 2d 1c 00 00       	call   80102f90 <begin_op>
      ilock(f->ip);
80101363:	83 ec 0c             	sub    $0xc,%esp
80101366:	ff 73 10             	push   0x10(%ebx)
80101369:	e8 42 06 00 00       	call   801019b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010136e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101371:	57                   	push   %edi
80101372:	ff 73 14             	push   0x14(%ebx)
80101375:	01 f0                	add    %esi,%eax
80101377:	50                   	push   %eax
80101378:	ff 73 10             	push   0x10(%ebx)
8010137b:	e8 40 0a 00 00       	call   80101dc0 <writei>
80101380:	83 c4 20             	add    $0x20,%esp
80101383:	85 c0                	test   %eax,%eax
80101385:	7f a1                	jg     80101328 <filewrite+0x48>
      iunlock(f->ip);
80101387:	83 ec 0c             	sub    $0xc,%esp
8010138a:	ff 73 10             	push   0x10(%ebx)
8010138d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101390:	e8 fb 06 00 00       	call   80101a90 <iunlock>
      end_op();
80101395:	e8 66 1c 00 00       	call   80103000 <end_op>
      if(r < 0)
8010139a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010139d:	83 c4 10             	add    $0x10,%esp
801013a0:	85 c0                	test   %eax,%eax
801013a2:	75 1b                	jne    801013bf <filewrite+0xdf>
        panic("short filewrite");
801013a4:	83 ec 0c             	sub    $0xc,%esp
801013a7:	68 6f 74 10 80       	push   $0x8010746f
801013ac:	e8 cf ef ff ff       	call   80100380 <panic>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801013b8:	89 f0                	mov    %esi,%eax
801013ba:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801013bd:	74 05                	je     801013c4 <filewrite+0xe4>
801013bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801013c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c7:	5b                   	pop    %ebx
801013c8:	5e                   	pop    %esi
801013c9:	5f                   	pop    %edi
801013ca:	5d                   	pop    %ebp
801013cb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801013cc:	8b 43 0c             	mov    0xc(%ebx),%eax
801013cf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d5:	5b                   	pop    %ebx
801013d6:	5e                   	pop    %esi
801013d7:	5f                   	pop    %edi
801013d8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801013d9:	e9 22 24 00 00       	jmp    80103800 <pipewrite>
  panic("filewrite");
801013de:	83 ec 0c             	sub    $0xc,%esp
801013e1:	68 75 74 10 80       	push   $0x80107475
801013e6:	e8 95 ef ff ff       	call   80100380 <panic>
801013eb:	66 90                	xchg   %ax,%ax
801013ed:	66 90                	xchg   %ax,%ax
801013ef:	90                   	nop

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
801013f8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801013fe:	89 e5                	mov    %esp,%ebp
80101400:	56                   	push   %esi
80101401:	53                   	push   %ebx
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 2e 1d 00 00       	call   80103170 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 7f 74 10 80       	push   $0x8010747f
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146f:	90                   	nop

80101470 <balloc>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	53                   	push   %ebx
80101476:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101479:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010147f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101482:	85 c9                	test   %ecx,%ecx
80101484:	0f 84 87 00 00 00    	je     80101511 <balloc+0xa1>
8010148a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101491:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101494:	83 ec 08             	sub    $0x8,%esp
80101497:	89 f0                	mov    %esi,%eax
80101499:	c1 f8 0c             	sar    $0xc,%eax
8010149c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801014a2:	50                   	push   %eax
801014a3:	ff 75 d8             	push   -0x28(%ebp)
801014a6:	e8 25 ec ff ff       	call   801000d0 <bread>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014b1:	a1 b4 15 11 80       	mov    0x801115b4,%eax
801014b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014b9:	31 c0                	xor    %eax,%eax
801014bb:	eb 2f                	jmp    801014ec <balloc+0x7c>
801014bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801014c0:	89 c1                	mov    %eax,%ecx
801014c2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801014ca:	83 e1 07             	and    $0x7,%ecx
801014cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014cf:	89 c1                	mov    %eax,%ecx
801014d1:	c1 f9 03             	sar    $0x3,%ecx
801014d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801014d9:	89 fa                	mov    %edi,%edx
801014db:	85 df                	test   %ebx,%edi
801014dd:	74 41                	je     80101520 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014df:	83 c0 01             	add    $0x1,%eax
801014e2:	83 c6 01             	add    $0x1,%esi
801014e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014ea:	74 05                	je     801014f1 <balloc+0x81>
801014ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801014ef:	77 cf                	ja     801014c0 <balloc+0x50>
    brelse(bp);
801014f1:	83 ec 0c             	sub    $0xc,%esp
801014f4:	ff 75 e4             	push   -0x1c(%ebp)
801014f7:	e8 f4 ec ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101503:	83 c4 10             	add    $0x10,%esp
80101506:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101509:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010150f:	77 80                	ja     80101491 <balloc+0x21>
  panic("balloc: out of blocks");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 92 74 10 80       	push   $0x80107492
80101519:	e8 62 ee ff ff       	call   80100380 <panic>
8010151e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101520:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101523:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101526:	09 da                	or     %ebx,%edx
80101528:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010152c:	57                   	push   %edi
8010152d:	e8 3e 1c 00 00       	call   80103170 <log_write>
        brelse(bp);
80101532:	89 3c 24             	mov    %edi,(%esp)
80101535:	e8 b6 ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010153a:	58                   	pop    %eax
8010153b:	5a                   	pop    %edx
8010153c:	56                   	push   %esi
8010153d:	ff 75 d8             	push   -0x28(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101545:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101548:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010154a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154d:	68 00 02 00 00       	push   $0x200
80101552:	6a 00                	push   $0x0
80101554:	50                   	push   %eax
80101555:	e8 36 33 00 00       	call   80104890 <memset>
  log_write(bp);
8010155a:	89 1c 24             	mov    %ebx,(%esp)
8010155d:	e8 0e 1c 00 00       	call   80103170 <log_write>
  brelse(bp);
80101562:	89 1c 24             	mov    %ebx,(%esp)
80101565:	e8 86 ec ff ff       	call   801001f0 <brelse>
}
8010156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156d:	89 f0                	mov    %esi,%eax
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5f                   	pop    %edi
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
80101574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010157f:	90                   	nop

80101580 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	89 c7                	mov    %eax,%edi
80101586:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101587:	31 f6                	xor    %esi,%esi
{
80101589:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010158a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010158f:	83 ec 28             	sub    $0x28,%esp
80101592:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101595:	68 60 f9 10 80       	push   $0x8010f960
8010159a:	e8 31 32 00 00       	call   801047d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010159f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801015a2:	83 c4 10             	add    $0x10,%esp
801015a5:	eb 1b                	jmp    801015c2 <iget+0x42>
801015a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ae:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015b0:	39 3b                	cmp    %edi,(%ebx)
801015b2:	74 6c                	je     80101620 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015ba:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801015c0:	73 26                	jae    801015e8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015c2:	8b 43 08             	mov    0x8(%ebx),%eax
801015c5:	85 c0                	test   %eax,%eax
801015c7:	7f e7                	jg     801015b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801015c9:	85 f6                	test   %esi,%esi
801015cb:	75 e7                	jne    801015b4 <iget+0x34>
801015cd:	85 c0                	test   %eax,%eax
801015cf:	75 76                	jne    80101647 <iget+0xc7>
801015d1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015d3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015d9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801015df:	72 e1                	jb     801015c2 <iget+0x42>
801015e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801015e8:	85 f6                	test   %esi,%esi
801015ea:	74 79                	je     80101665 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801015ec:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801015ef:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801015f1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801015f4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015fb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101602:	68 60 f9 10 80       	push   $0x8010f960
80101607:	e8 64 31 00 00       	call   80104770 <release>

  return ip;
8010160c:	83 c4 10             	add    $0x10,%esp
}
8010160f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101612:	89 f0                	mov    %esi,%eax
80101614:	5b                   	pop    %ebx
80101615:	5e                   	pop    %esi
80101616:	5f                   	pop    %edi
80101617:	5d                   	pop    %ebp
80101618:	c3                   	ret    
80101619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101620:	39 53 04             	cmp    %edx,0x4(%ebx)
80101623:	75 8f                	jne    801015b4 <iget+0x34>
      release(&icache.lock);
80101625:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101628:	83 c0 01             	add    $0x1,%eax
      return ip;
8010162b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010162d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101632:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101635:	e8 36 31 00 00       	call   80104770 <release>
      return ip;
8010163a:	83 c4 10             	add    $0x10,%esp
}
8010163d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101640:	89 f0                	mov    %esi,%eax
80101642:	5b                   	pop    %ebx
80101643:	5e                   	pop    %esi
80101644:	5f                   	pop    %edi
80101645:	5d                   	pop    %ebp
80101646:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101647:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010164d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101653:	73 10                	jae    80101665 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101655:	8b 43 08             	mov    0x8(%ebx),%eax
80101658:	85 c0                	test   %eax,%eax
8010165a:	0f 8f 50 ff ff ff    	jg     801015b0 <iget+0x30>
80101660:	e9 68 ff ff ff       	jmp    801015cd <iget+0x4d>
    panic("iget: no inodes");
80101665:	83 ec 0c             	sub    $0xc,%esp
80101668:	68 a8 74 10 80       	push   $0x801074a8
8010166d:	e8 0e ed ff ff       	call   80100380 <panic>
80101672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101680 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	89 c6                	mov    %eax,%esi
80101687:	53                   	push   %ebx
80101688:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010168b:	83 fa 0b             	cmp    $0xb,%edx
8010168e:	0f 86 8c 00 00 00    	jbe    80101720 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101694:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101697:	83 fb 7f             	cmp    $0x7f,%ebx
8010169a:	0f 87 a2 00 00 00    	ja     80101742 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801016a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801016a6:	85 c0                	test   %eax,%eax
801016a8:	74 5e                	je     80101708 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801016aa:	83 ec 08             	sub    $0x8,%esp
801016ad:	50                   	push   %eax
801016ae:	ff 36                	push   (%esi)
801016b0:	e8 1b ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801016b5:	83 c4 10             	add    $0x10,%esp
801016b8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801016bc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801016be:	8b 3b                	mov    (%ebx),%edi
801016c0:	85 ff                	test   %edi,%edi
801016c2:	74 1c                	je     801016e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801016c4:	83 ec 0c             	sub    $0xc,%esp
801016c7:	52                   	push   %edx
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
801016cd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016d3:	89 f8                	mov    %edi,%eax
801016d5:	5b                   	pop    %ebx
801016d6:	5e                   	pop    %esi
801016d7:	5f                   	pop    %edi
801016d8:	5d                   	pop    %ebp
801016d9:	c3                   	ret    
801016da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801016e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801016e3:	8b 06                	mov    (%esi),%eax
801016e5:	e8 86 fd ff ff       	call   80101470 <balloc>
      log_write(bp);
801016ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801016f0:	89 03                	mov    %eax,(%ebx)
801016f2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801016f4:	52                   	push   %edx
801016f5:	e8 76 1a 00 00       	call   80103170 <log_write>
801016fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016fd:	83 c4 10             	add    $0x10,%esp
80101700:	eb c2                	jmp    801016c4 <bmap+0x44>
80101702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101708:	8b 06                	mov    (%esi),%eax
8010170a:	e8 61 fd ff ff       	call   80101470 <balloc>
8010170f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101715:	eb 93                	jmp    801016aa <bmap+0x2a>
80101717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101720:	8d 5a 14             	lea    0x14(%edx),%ebx
80101723:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101727:	85 ff                	test   %edi,%edi
80101729:	75 a5                	jne    801016d0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010172b:	8b 00                	mov    (%eax),%eax
8010172d:	e8 3e fd ff ff       	call   80101470 <balloc>
80101732:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101736:	89 c7                	mov    %eax,%edi
}
80101738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173b:	5b                   	pop    %ebx
8010173c:	89 f8                	mov    %edi,%eax
8010173e:	5e                   	pop    %esi
8010173f:	5f                   	pop    %edi
80101740:	5d                   	pop    %ebp
80101741:	c3                   	ret    
  panic("bmap: out of range");
80101742:	83 ec 0c             	sub    $0xc,%esp
80101745:	68 b8 74 10 80       	push   $0x801074b8
8010174a:	e8 31 ec ff ff       	call   80100380 <panic>
8010174f:	90                   	nop

80101750 <readsb>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101758:	83 ec 08             	sub    $0x8,%esp
8010175b:	6a 01                	push   $0x1
8010175d:	ff 75 08             	push   0x8(%ebp)
80101760:	e8 6b e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101765:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101768:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010176a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010176d:	6a 1c                	push   $0x1c
8010176f:	50                   	push   %eax
80101770:	56                   	push   %esi
80101771:	e8 ba 31 00 00       	call   80104930 <memmove>
  brelse(bp);
80101776:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101779:	83 c4 10             	add    $0x10,%esp
}
8010177c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177f:	5b                   	pop    %ebx
80101780:	5e                   	pop    %esi
80101781:	5d                   	pop    %ebp
  brelse(bp);
80101782:	e9 69 ea ff ff       	jmp    801001f0 <brelse>
80101787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010178e:	66 90                	xchg   %ax,%ax

80101790 <iinit>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	53                   	push   %ebx
80101794:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101799:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010179c:	68 cb 74 10 80       	push   $0x801074cb
801017a1:	68 60 f9 10 80       	push   $0x8010f960
801017a6:	e8 55 2e 00 00       	call   80104600 <initlock>
  for(i = 0; i < NINODE; i++) {
801017ab:	83 c4 10             	add    $0x10,%esp
801017ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801017b0:	83 ec 08             	sub    $0x8,%esp
801017b3:	68 d2 74 10 80       	push   $0x801074d2
801017b8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801017b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801017bf:	e8 0c 2d 00 00       	call   801044d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801017c4:	83 c4 10             	add    $0x10,%esp
801017c7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801017cd:	75 e1                	jne    801017b0 <iinit+0x20>
  bp = bread(dev, 1);
801017cf:	83 ec 08             	sub    $0x8,%esp
801017d2:	6a 01                	push   $0x1
801017d4:	ff 75 08             	push   0x8(%ebp)
801017d7:	e8 f4 e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801017dc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801017df:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801017e1:	8d 40 5c             	lea    0x5c(%eax),%eax
801017e4:	6a 1c                	push   $0x1c
801017e6:	50                   	push   %eax
801017e7:	68 b4 15 11 80       	push   $0x801115b4
801017ec:	e8 3f 31 00 00       	call   80104930 <memmove>
  brelse(bp);
801017f1:	89 1c 24             	mov    %ebx,(%esp)
801017f4:	e8 f7 e9 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017f9:	ff 35 cc 15 11 80    	push   0x801115cc
801017ff:	ff 35 c8 15 11 80    	push   0x801115c8
80101805:	ff 35 c4 15 11 80    	push   0x801115c4
8010180b:	ff 35 c0 15 11 80    	push   0x801115c0
80101811:	ff 35 bc 15 11 80    	push   0x801115bc
80101817:	ff 35 b8 15 11 80    	push   0x801115b8
8010181d:	ff 35 b4 15 11 80    	push   0x801115b4
80101823:	68 38 75 10 80       	push   $0x80107538
80101828:	e8 83 ef ff ff       	call   801007b0 <cprintf>
}
8010182d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101830:	83 c4 30             	add    $0x30,%esp
80101833:	c9                   	leave  
80101834:	c3                   	ret    
80101835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101840 <ialloc>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 1c             	sub    $0x1c,%esp
80101849:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010184c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101853:	8b 75 08             	mov    0x8(%ebp),%esi
80101856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101859:	0f 86 91 00 00 00    	jbe    801018f0 <ialloc+0xb0>
8010185f:	bf 01 00 00 00       	mov    $0x1,%edi
80101864:	eb 21                	jmp    80101887 <ialloc+0x47>
80101866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101870:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101873:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101876:	53                   	push   %ebx
80101877:	e8 74 e9 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010187c:	83 c4 10             	add    $0x10,%esp
8010187f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101885:	73 69                	jae    801018f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101887:	89 f8                	mov    %edi,%eax
80101889:	83 ec 08             	sub    $0x8,%esp
8010188c:	c1 e8 03             	shr    $0x3,%eax
8010188f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101895:	50                   	push   %eax
80101896:	56                   	push   %esi
80101897:	e8 34 e8 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010189c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010189f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801018a1:	89 f8                	mov    %edi,%eax
801018a3:	83 e0 07             	and    $0x7,%eax
801018a6:	c1 e0 06             	shl    $0x6,%eax
801018a9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801018ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801018b1:	75 bd                	jne    80101870 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801018b3:	83 ec 04             	sub    $0x4,%esp
801018b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801018b9:	6a 40                	push   $0x40
801018bb:	6a 00                	push   $0x0
801018bd:	51                   	push   %ecx
801018be:	e8 cd 2f 00 00       	call   80104890 <memset>
      dip->type = type;
801018c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801018c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801018ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801018cd:	89 1c 24             	mov    %ebx,(%esp)
801018d0:	e8 9b 18 00 00       	call   80103170 <log_write>
      brelse(bp);
801018d5:	89 1c 24             	mov    %ebx,(%esp)
801018d8:	e8 13 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801018dd:	83 c4 10             	add    $0x10,%esp
}
801018e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801018e3:	89 fa                	mov    %edi,%edx
}
801018e5:	5b                   	pop    %ebx
      return iget(dev, inum);
801018e6:	89 f0                	mov    %esi,%eax
}
801018e8:	5e                   	pop    %esi
801018e9:	5f                   	pop    %edi
801018ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801018eb:	e9 90 fc ff ff       	jmp    80101580 <iget>
  panic("ialloc: no inodes");
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 d8 74 10 80       	push   $0x801074d8
801018f8:	e8 83 ea ff ff       	call   80100380 <panic>
801018fd:	8d 76 00             	lea    0x0(%esi),%esi

80101900 <iupdate>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	56                   	push   %esi
80101904:	53                   	push   %ebx
80101905:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101908:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010190b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010190e:	83 ec 08             	sub    $0x8,%esp
80101911:	c1 e8 03             	shr    $0x3,%eax
80101914:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010191a:	50                   	push   %eax
8010191b:	ff 73 a4             	push   -0x5c(%ebx)
8010191e:	e8 ad e7 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101923:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101927:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010192a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010192c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010192f:	83 e0 07             	and    $0x7,%eax
80101932:	c1 e0 06             	shl    $0x6,%eax
80101935:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101939:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010193c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101940:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101943:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101947:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010194b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010194f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101953:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101957:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010195a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010195d:	6a 34                	push   $0x34
8010195f:	53                   	push   %ebx
80101960:	50                   	push   %eax
80101961:	e8 ca 2f 00 00       	call   80104930 <memmove>
  log_write(bp);
80101966:	89 34 24             	mov    %esi,(%esp)
80101969:	e8 02 18 00 00       	call   80103170 <log_write>
  brelse(bp);
8010196e:	89 75 08             	mov    %esi,0x8(%ebp)
80101971:	83 c4 10             	add    $0x10,%esp
}
80101974:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101977:	5b                   	pop    %ebx
80101978:	5e                   	pop    %esi
80101979:	5d                   	pop    %ebp
  brelse(bp);
8010197a:	e9 71 e8 ff ff       	jmp    801001f0 <brelse>
8010197f:	90                   	nop

80101980 <idup>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	53                   	push   %ebx
80101984:	83 ec 10             	sub    $0x10,%esp
80101987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010198a:	68 60 f9 10 80       	push   $0x8010f960
8010198f:	e8 3c 2e 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101994:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101998:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010199f:	e8 cc 2d 00 00       	call   80104770 <release>
}
801019a4:	89 d8                	mov    %ebx,%eax
801019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019a9:	c9                   	leave  
801019aa:	c3                   	ret    
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop

801019b0 <ilock>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	56                   	push   %esi
801019b4:	53                   	push   %ebx
801019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801019b8:	85 db                	test   %ebx,%ebx
801019ba:	0f 84 b7 00 00 00    	je     80101a77 <ilock+0xc7>
801019c0:	8b 53 08             	mov    0x8(%ebx),%edx
801019c3:	85 d2                	test   %edx,%edx
801019c5:	0f 8e ac 00 00 00    	jle    80101a77 <ilock+0xc7>
  acquiresleep(&ip->lock);
801019cb:	83 ec 0c             	sub    $0xc,%esp
801019ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801019d1:	50                   	push   %eax
801019d2:	e8 39 2b 00 00       	call   80104510 <acquiresleep>
  if(ip->valid == 0){
801019d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801019da:	83 c4 10             	add    $0x10,%esp
801019dd:	85 c0                	test   %eax,%eax
801019df:	74 0f                	je     801019f0 <ilock+0x40>
}
801019e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e4:	5b                   	pop    %ebx
801019e5:	5e                   	pop    %esi
801019e6:	5d                   	pop    %ebp
801019e7:	c3                   	ret    
801019e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ef:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019f0:	8b 43 04             	mov    0x4(%ebx),%eax
801019f3:	83 ec 08             	sub    $0x8,%esp
801019f6:	c1 e8 03             	shr    $0x3,%eax
801019f9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801019ff:	50                   	push   %eax
80101a00:	ff 33                	push   (%ebx)
80101a02:	e8 c9 e6 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a07:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a0a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a0c:	8b 43 04             	mov    0x4(%ebx),%eax
80101a0f:	83 e0 07             	and    $0x7,%eax
80101a12:	c1 e0 06             	shl    $0x6,%eax
80101a15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a19:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a1c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a1f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a23:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a27:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a2b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a2f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a33:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a37:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a3b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a3e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a41:	6a 34                	push   $0x34
80101a43:	50                   	push   %eax
80101a44:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a47:	50                   	push   %eax
80101a48:	e8 e3 2e 00 00       	call   80104930 <memmove>
    brelse(bp);
80101a4d:	89 34 24             	mov    %esi,(%esp)
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101a55:	83 c4 10             	add    $0x10,%esp
80101a58:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a5d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a64:	0f 85 77 ff ff ff    	jne    801019e1 <ilock+0x31>
      panic("ilock: no type");
80101a6a:	83 ec 0c             	sub    $0xc,%esp
80101a6d:	68 f0 74 10 80       	push   $0x801074f0
80101a72:	e8 09 e9 ff ff       	call   80100380 <panic>
    panic("ilock");
80101a77:	83 ec 0c             	sub    $0xc,%esp
80101a7a:	68 ea 74 10 80       	push   $0x801074ea
80101a7f:	e8 fc e8 ff ff       	call   80100380 <panic>
80101a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <iunlock>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	56                   	push   %esi
80101a94:	53                   	push   %ebx
80101a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a98:	85 db                	test   %ebx,%ebx
80101a9a:	74 28                	je     80101ac4 <iunlock+0x34>
80101a9c:	83 ec 0c             	sub    $0xc,%esp
80101a9f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101aa2:	56                   	push   %esi
80101aa3:	e8 08 2b 00 00       	call   801045b0 <holdingsleep>
80101aa8:	83 c4 10             	add    $0x10,%esp
80101aab:	85 c0                	test   %eax,%eax
80101aad:	74 15                	je     80101ac4 <iunlock+0x34>
80101aaf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ab2:	85 c0                	test   %eax,%eax
80101ab4:	7e 0e                	jle    80101ac4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101ab6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101ab9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101abf:	e9 ac 2a 00 00       	jmp    80104570 <releasesleep>
    panic("iunlock");
80101ac4:	83 ec 0c             	sub    $0xc,%esp
80101ac7:	68 ff 74 10 80       	push   $0x801074ff
80101acc:	e8 af e8 ff ff       	call   80100380 <panic>
80101ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop

80101ae0 <iput>:
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 28             	sub    $0x28,%esp
80101ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101aec:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101aef:	57                   	push   %edi
80101af0:	e8 1b 2a 00 00       	call   80104510 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101af5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	85 d2                	test   %edx,%edx
80101afd:	74 07                	je     80101b06 <iput+0x26>
80101aff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b04:	74 32                	je     80101b38 <iput+0x58>
  releasesleep(&ip->lock);
80101b06:	83 ec 0c             	sub    $0xc,%esp
80101b09:	57                   	push   %edi
80101b0a:	e8 61 2a 00 00       	call   80104570 <releasesleep>
  acquire(&icache.lock);
80101b0f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101b16:	e8 b5 2c 00 00       	call   801047d0 <acquire>
  ip->ref--;
80101b1b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b1f:	83 c4 10             	add    $0x10,%esp
80101b22:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2c:	5b                   	pop    %ebx
80101b2d:	5e                   	pop    %esi
80101b2e:	5f                   	pop    %edi
80101b2f:	5d                   	pop    %ebp
  release(&icache.lock);
80101b30:	e9 3b 2c 00 00       	jmp    80104770 <release>
80101b35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101b38:	83 ec 0c             	sub    $0xc,%esp
80101b3b:	68 60 f9 10 80       	push   $0x8010f960
80101b40:	e8 8b 2c 00 00       	call   801047d0 <acquire>
    int r = ip->ref;
80101b45:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101b48:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101b4f:	e8 1c 2c 00 00       	call   80104770 <release>
    if(r == 1){
80101b54:	83 c4 10             	add    $0x10,%esp
80101b57:	83 fe 01             	cmp    $0x1,%esi
80101b5a:	75 aa                	jne    80101b06 <iput+0x26>
80101b5c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b68:	89 cf                	mov    %ecx,%edi
80101b6a:	eb 0b                	jmp    80101b77 <iput+0x97>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b70:	83 c6 04             	add    $0x4,%esi
80101b73:	39 fe                	cmp    %edi,%esi
80101b75:	74 19                	je     80101b90 <iput+0xb0>
    if(ip->addrs[i]){
80101b77:	8b 16                	mov    (%esi),%edx
80101b79:	85 d2                	test   %edx,%edx
80101b7b:	74 f3                	je     80101b70 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b7d:	8b 03                	mov    (%ebx),%eax
80101b7f:	e8 6c f8 ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101b84:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b8a:	eb e4                	jmp    80101b70 <iput+0x90>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b90:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b99:	85 c0                	test   %eax,%eax
80101b9b:	75 2d                	jne    80101bca <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b9d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ba0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ba7:	53                   	push   %ebx
80101ba8:	e8 53 fd ff ff       	call   80101900 <iupdate>
      ip->type = 0;
80101bad:	31 c0                	xor    %eax,%eax
80101baf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101bb3:	89 1c 24             	mov    %ebx,(%esp)
80101bb6:	e8 45 fd ff ff       	call   80101900 <iupdate>
      ip->valid = 0;
80101bbb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101bc2:	83 c4 10             	add    $0x10,%esp
80101bc5:	e9 3c ff ff ff       	jmp    80101b06 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101bca:	83 ec 08             	sub    $0x8,%esp
80101bcd:	50                   	push   %eax
80101bce:	ff 33                	push   (%ebx)
80101bd0:	e8 fb e4 ff ff       	call   801000d0 <bread>
80101bd5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bd8:	83 c4 10             	add    $0x10,%esp
80101bdb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101be1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101be4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101be7:	89 cf                	mov    %ecx,%edi
80101be9:	eb 0c                	jmp    80101bf7 <iput+0x117>
80101beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bef:	90                   	nop
80101bf0:	83 c6 04             	add    $0x4,%esi
80101bf3:	39 f7                	cmp    %esi,%edi
80101bf5:	74 0f                	je     80101c06 <iput+0x126>
      if(a[j])
80101bf7:	8b 16                	mov    (%esi),%edx
80101bf9:	85 d2                	test   %edx,%edx
80101bfb:	74 f3                	je     80101bf0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101bfd:	8b 03                	mov    (%ebx),%eax
80101bff:	e8 ec f7 ff ff       	call   801013f0 <bfree>
80101c04:	eb ea                	jmp    80101bf0 <iput+0x110>
    brelse(bp);
80101c06:	83 ec 0c             	sub    $0xc,%esp
80101c09:	ff 75 e4             	push   -0x1c(%ebp)
80101c0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c0f:	e8 dc e5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c14:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c1a:	8b 03                	mov    (%ebx),%eax
80101c1c:	e8 cf f7 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c21:	83 c4 10             	add    $0x10,%esp
80101c24:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c2b:	00 00 00 
80101c2e:	e9 6a ff ff ff       	jmp    80101b9d <iput+0xbd>
80101c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c40 <iunlockput>:
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	56                   	push   %esi
80101c44:	53                   	push   %ebx
80101c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c48:	85 db                	test   %ebx,%ebx
80101c4a:	74 34                	je     80101c80 <iunlockput+0x40>
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c52:	56                   	push   %esi
80101c53:	e8 58 29 00 00       	call   801045b0 <holdingsleep>
80101c58:	83 c4 10             	add    $0x10,%esp
80101c5b:	85 c0                	test   %eax,%eax
80101c5d:	74 21                	je     80101c80 <iunlockput+0x40>
80101c5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101c62:	85 c0                	test   %eax,%eax
80101c64:	7e 1a                	jle    80101c80 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101c66:	83 ec 0c             	sub    $0xc,%esp
80101c69:	56                   	push   %esi
80101c6a:	e8 01 29 00 00       	call   80104570 <releasesleep>
  iput(ip);
80101c6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c72:	83 c4 10             	add    $0x10,%esp
}
80101c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c78:	5b                   	pop    %ebx
80101c79:	5e                   	pop    %esi
80101c7a:	5d                   	pop    %ebp
  iput(ip);
80101c7b:	e9 60 fe ff ff       	jmp    80101ae0 <iput>
    panic("iunlock");
80101c80:	83 ec 0c             	sub    $0xc,%esp
80101c83:	68 ff 74 10 80       	push   $0x801074ff
80101c88:	e8 f3 e6 ff ff       	call   80100380 <panic>
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi

80101c90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	8b 55 08             	mov    0x8(%ebp),%edx
80101c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c99:	8b 0a                	mov    (%edx),%ecx
80101c9b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c9e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ca1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ca4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ca8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101cab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101caf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cb3:	8b 52 58             	mov    0x58(%edx),%edx
80101cb6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop

80101cc0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 1c             	sub    $0x1c,%esp
80101cc9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccf:	8b 75 10             	mov    0x10(%ebp),%esi
80101cd2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101cd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cd8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ce0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ce3:	0f 84 a7 00 00 00    	je     80101d90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	8b 40 58             	mov    0x58(%eax),%eax
80101cef:	39 c6                	cmp    %eax,%esi
80101cf1:	0f 87 ba 00 00 00    	ja     80101db1 <readi+0xf1>
80101cf7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101cfa:	31 c9                	xor    %ecx,%ecx
80101cfc:	89 da                	mov    %ebx,%edx
80101cfe:	01 f2                	add    %esi,%edx
80101d00:	0f 92 c1             	setb   %cl
80101d03:	89 cf                	mov    %ecx,%edi
80101d05:	0f 82 a6 00 00 00    	jb     80101db1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d0b:	89 c1                	mov    %eax,%ecx
80101d0d:	29 f1                	sub    %esi,%ecx
80101d0f:	39 d0                	cmp    %edx,%eax
80101d11:	0f 43 cb             	cmovae %ebx,%ecx
80101d14:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d17:	85 c9                	test   %ecx,%ecx
80101d19:	74 67                	je     80101d82 <readi+0xc2>
80101d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d23:	89 f2                	mov    %esi,%edx
80101d25:	c1 ea 09             	shr    $0x9,%edx
80101d28:	89 d8                	mov    %ebx,%eax
80101d2a:	e8 51 f9 ff ff       	call   80101680 <bmap>
80101d2f:	83 ec 08             	sub    $0x8,%esp
80101d32:	50                   	push   %eax
80101d33:	ff 33                	push   (%ebx)
80101d35:	e8 96 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101d3d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d42:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d44:	89 f0                	mov    %esi,%eax
80101d46:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d4b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d4d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d50:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d52:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d56:	39 d9                	cmp    %ebx,%ecx
80101d58:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d5b:	83 c4 0c             	add    $0xc,%esp
80101d5e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d5f:	01 df                	add    %ebx,%edi
80101d61:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d63:	50                   	push   %eax
80101d64:	ff 75 e0             	push   -0x20(%ebp)
80101d67:	e8 c4 2b 00 00       	call   80104930 <memmove>
    brelse(bp);
80101d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d6f:	89 14 24             	mov    %edx,(%esp)
80101d72:	e8 79 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d80:	77 9e                	ja     80101d20 <readi+0x60>
  }
  return n;
80101d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d88:	5b                   	pop    %ebx
80101d89:	5e                   	pop    %esi
80101d8a:	5f                   	pop    %edi
80101d8b:	5d                   	pop    %ebp
80101d8c:	c3                   	ret    
80101d8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d94:	66 83 f8 09          	cmp    $0x9,%ax
80101d98:	77 17                	ja     80101db1 <readi+0xf1>
80101d9a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101da1:	85 c0                	test   %eax,%eax
80101da3:	74 0c                	je     80101db1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101da5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101daf:	ff e0                	jmp    *%eax
      return -1;
80101db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101db6:	eb cd                	jmp    80101d85 <readi+0xc5>
80101db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop

80101dc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	83 ec 1c             	sub    $0x1c,%esp
80101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101dcf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101dd7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101dda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ddd:	8b 75 10             	mov    0x10(%ebp),%esi
80101de0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101de3:	0f 84 b7 00 00 00    	je     80101ea0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101de9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dec:	3b 70 58             	cmp    0x58(%eax),%esi
80101def:	0f 87 e7 00 00 00    	ja     80101edc <writei+0x11c>
80101df5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101df8:	31 d2                	xor    %edx,%edx
80101dfa:	89 f8                	mov    %edi,%eax
80101dfc:	01 f0                	add    %esi,%eax
80101dfe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e01:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e06:	0f 87 d0 00 00 00    	ja     80101edc <writei+0x11c>
80101e0c:	85 d2                	test   %edx,%edx
80101e0e:	0f 85 c8 00 00 00    	jne    80101edc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e1b:	85 ff                	test   %edi,%edi
80101e1d:	74 72                	je     80101e91 <writei+0xd1>
80101e1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e23:	89 f2                	mov    %esi,%edx
80101e25:	c1 ea 09             	shr    $0x9,%edx
80101e28:	89 f8                	mov    %edi,%eax
80101e2a:	e8 51 f8 ff ff       	call   80101680 <bmap>
80101e2f:	83 ec 08             	sub    $0x8,%esp
80101e32:	50                   	push   %eax
80101e33:	ff 37                	push   (%edi)
80101e35:	e8 96 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e3a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e42:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e45:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e47:	89 f0                	mov    %esi,%eax
80101e49:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e4e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e50:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e54:	39 d9                	cmp    %ebx,%ecx
80101e56:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e59:	83 c4 0c             	add    $0xc,%esp
80101e5c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e5d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e5f:	ff 75 dc             	push   -0x24(%ebp)
80101e62:	50                   	push   %eax
80101e63:	e8 c8 2a 00 00       	call   80104930 <memmove>
    log_write(bp);
80101e68:	89 3c 24             	mov    %edi,(%esp)
80101e6b:	e8 00 13 00 00       	call   80103170 <log_write>
    brelse(bp);
80101e70:	89 3c 24             	mov    %edi,(%esp)
80101e73:	e8 78 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e7b:	83 c4 10             	add    $0x10,%esp
80101e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e81:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e87:	77 97                	ja     80101e20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e8f:	77 37                	ja     80101ec8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e97:	5b                   	pop    %ebx
80101e98:	5e                   	pop    %esi
80101e99:	5f                   	pop    %edi
80101e9a:	5d                   	pop    %ebp
80101e9b:	c3                   	ret    
80101e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ea0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ea4:	66 83 f8 09          	cmp    $0x9,%ax
80101ea8:	77 32                	ja     80101edc <writei+0x11c>
80101eaa:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101eb1:	85 c0                	test   %eax,%eax
80101eb3:	74 27                	je     80101edc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101eb5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ebb:	5b                   	pop    %ebx
80101ebc:	5e                   	pop    %esi
80101ebd:	5f                   	pop    %edi
80101ebe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ebf:	ff e0                	jmp    *%eax
80101ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ec8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101ecb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101ece:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ed1:	50                   	push   %eax
80101ed2:	e8 29 fa ff ff       	call   80101900 <iupdate>
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	eb b5                	jmp    80101e91 <writei+0xd1>
      return -1;
80101edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee1:	eb b1                	jmp    80101e94 <writei+0xd4>
80101ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ef0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ef6:	6a 0e                	push   $0xe
80101ef8:	ff 75 0c             	push   0xc(%ebp)
80101efb:	ff 75 08             	push   0x8(%ebp)
80101efe:	e8 9d 2a 00 00       	call   801049a0 <strncmp>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	57                   	push   %edi
80101f14:	56                   	push   %esi
80101f15:	53                   	push   %ebx
80101f16:	83 ec 1c             	sub    $0x1c,%esp
80101f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f21:	0f 85 85 00 00 00    	jne    80101fac <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f27:	8b 53 58             	mov    0x58(%ebx),%edx
80101f2a:	31 ff                	xor    %edi,%edi
80101f2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f2f:	85 d2                	test   %edx,%edx
80101f31:	74 3e                	je     80101f71 <dirlookup+0x61>
80101f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f37:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f38:	6a 10                	push   $0x10
80101f3a:	57                   	push   %edi
80101f3b:	56                   	push   %esi
80101f3c:	53                   	push   %ebx
80101f3d:	e8 7e fd ff ff       	call   80101cc0 <readi>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	83 f8 10             	cmp    $0x10,%eax
80101f48:	75 55                	jne    80101f9f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4f:	74 18                	je     80101f69 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f51:	83 ec 04             	sub    $0x4,%esp
80101f54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f57:	6a 0e                	push   $0xe
80101f59:	50                   	push   %eax
80101f5a:	ff 75 0c             	push   0xc(%ebp)
80101f5d:	e8 3e 2a 00 00       	call   801049a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f62:	83 c4 10             	add    $0x10,%esp
80101f65:	85 c0                	test   %eax,%eax
80101f67:	74 17                	je     80101f80 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f69:	83 c7 10             	add    $0x10,%edi
80101f6c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f6f:	72 c7                	jb     80101f38 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f74:	31 c0                	xor    %eax,%eax
}
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5f                   	pop    %edi
80101f79:	5d                   	pop    %ebp
80101f7a:	c3                   	ret    
80101f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f7f:	90                   	nop
      if(poff)
80101f80:	8b 45 10             	mov    0x10(%ebp),%eax
80101f83:	85 c0                	test   %eax,%eax
80101f85:	74 05                	je     80101f8c <dirlookup+0x7c>
        *poff = off;
80101f87:	8b 45 10             	mov    0x10(%ebp),%eax
80101f8a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f8c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f90:	8b 03                	mov    (%ebx),%eax
80101f92:	e8 e9 f5 ff ff       	call   80101580 <iget>
}
80101f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f9a:	5b                   	pop    %ebx
80101f9b:	5e                   	pop    %esi
80101f9c:	5f                   	pop    %edi
80101f9d:	5d                   	pop    %ebp
80101f9e:	c3                   	ret    
      panic("dirlookup read");
80101f9f:	83 ec 0c             	sub    $0xc,%esp
80101fa2:	68 19 75 10 80       	push   $0x80107519
80101fa7:	e8 d4 e3 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101fac:	83 ec 0c             	sub    $0xc,%esp
80101faf:	68 07 75 10 80       	push   $0x80107507
80101fb4:	e8 c7 e3 ff ff       	call   80100380 <panic>
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	89 c3                	mov    %eax,%ebx
80101fc8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101fcb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101fce:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fd1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101fd4:	0f 84 64 01 00 00    	je     8010213e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101fda:	e8 c1 1b 00 00       	call   80103ba0 <myproc>
  acquire(&icache.lock);
80101fdf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101fe2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101fe5:	68 60 f9 10 80       	push   $0x8010f960
80101fea:	e8 e1 27 00 00       	call   801047d0 <acquire>
  ip->ref++;
80101fef:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ff3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101ffa:	e8 71 27 00 00       	call   80104770 <release>
80101fff:	83 c4 10             	add    $0x10,%esp
80102002:	eb 07                	jmp    8010200b <namex+0x4b>
80102004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102008:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010200b:	0f b6 03             	movzbl (%ebx),%eax
8010200e:	3c 2f                	cmp    $0x2f,%al
80102010:	74 f6                	je     80102008 <namex+0x48>
  if(*path == 0)
80102012:	84 c0                	test   %al,%al
80102014:	0f 84 06 01 00 00    	je     80102120 <namex+0x160>
  while(*path != '/' && *path != 0)
8010201a:	0f b6 03             	movzbl (%ebx),%eax
8010201d:	84 c0                	test   %al,%al
8010201f:	0f 84 10 01 00 00    	je     80102135 <namex+0x175>
80102025:	89 df                	mov    %ebx,%edi
80102027:	3c 2f                	cmp    $0x2f,%al
80102029:	0f 84 06 01 00 00    	je     80102135 <namex+0x175>
8010202f:	90                   	nop
80102030:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102034:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102037:	3c 2f                	cmp    $0x2f,%al
80102039:	74 04                	je     8010203f <namex+0x7f>
8010203b:	84 c0                	test   %al,%al
8010203d:	75 f1                	jne    80102030 <namex+0x70>
  len = path - s;
8010203f:	89 f8                	mov    %edi,%eax
80102041:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102043:	83 f8 0d             	cmp    $0xd,%eax
80102046:	0f 8e ac 00 00 00    	jle    801020f8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010204c:	83 ec 04             	sub    $0x4,%esp
8010204f:	6a 0e                	push   $0xe
80102051:	53                   	push   %ebx
    path++;
80102052:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102054:	ff 75 e4             	push   -0x1c(%ebp)
80102057:	e8 d4 28 00 00       	call   80104930 <memmove>
8010205c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010205f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102062:	75 0c                	jne    80102070 <namex+0xb0>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102068:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010206b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010206e:	74 f8                	je     80102068 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102070:	83 ec 0c             	sub    $0xc,%esp
80102073:	56                   	push   %esi
80102074:	e8 37 f9 ff ff       	call   801019b0 <ilock>
    if(ip->type != T_DIR){
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102081:	0f 85 cd 00 00 00    	jne    80102154 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102087:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010208a:	85 c0                	test   %eax,%eax
8010208c:	74 09                	je     80102097 <namex+0xd7>
8010208e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102091:	0f 84 22 01 00 00    	je     801021b9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102097:	83 ec 04             	sub    $0x4,%esp
8010209a:	6a 00                	push   $0x0
8010209c:	ff 75 e4             	push   -0x1c(%ebp)
8010209f:	56                   	push   %esi
801020a0:	e8 6b fe ff ff       	call   80101f10 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020a5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
801020a8:	83 c4 10             	add    $0x10,%esp
801020ab:	89 c7                	mov    %eax,%edi
801020ad:	85 c0                	test   %eax,%eax
801020af:	0f 84 e1 00 00 00    	je     80102196 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801020bb:	52                   	push   %edx
801020bc:	e8 ef 24 00 00       	call   801045b0 <holdingsleep>
801020c1:	83 c4 10             	add    $0x10,%esp
801020c4:	85 c0                	test   %eax,%eax
801020c6:	0f 84 30 01 00 00    	je     801021fc <namex+0x23c>
801020cc:	8b 56 08             	mov    0x8(%esi),%edx
801020cf:	85 d2                	test   %edx,%edx
801020d1:	0f 8e 25 01 00 00    	jle    801021fc <namex+0x23c>
  releasesleep(&ip->lock);
801020d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020da:	83 ec 0c             	sub    $0xc,%esp
801020dd:	52                   	push   %edx
801020de:	e8 8d 24 00 00       	call   80104570 <releasesleep>
  iput(ip);
801020e3:	89 34 24             	mov    %esi,(%esp)
801020e6:	89 fe                	mov    %edi,%esi
801020e8:	e8 f3 f9 ff ff       	call   80101ae0 <iput>
801020ed:	83 c4 10             	add    $0x10,%esp
801020f0:	e9 16 ff ff ff       	jmp    8010200b <namex+0x4b>
801020f5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801020f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801020fb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801020fe:	83 ec 04             	sub    $0x4,%esp
80102101:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102104:	50                   	push   %eax
80102105:	53                   	push   %ebx
    name[len] = 0;
80102106:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102108:	ff 75 e4             	push   -0x1c(%ebp)
8010210b:	e8 20 28 00 00       	call   80104930 <memmove>
    name[len] = 0;
80102110:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102113:	83 c4 10             	add    $0x10,%esp
80102116:	c6 02 00             	movb   $0x0,(%edx)
80102119:	e9 41 ff ff ff       	jmp    8010205f <namex+0x9f>
8010211e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102120:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102123:	85 c0                	test   %eax,%eax
80102125:	0f 85 be 00 00 00    	jne    801021e9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010212b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212e:	89 f0                	mov    %esi,%eax
80102130:	5b                   	pop    %ebx
80102131:	5e                   	pop    %esi
80102132:	5f                   	pop    %edi
80102133:	5d                   	pop    %ebp
80102134:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102135:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102138:	89 df                	mov    %ebx,%edi
8010213a:	31 c0                	xor    %eax,%eax
8010213c:	eb c0                	jmp    801020fe <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010213e:	ba 01 00 00 00       	mov    $0x1,%edx
80102143:	b8 01 00 00 00       	mov    $0x1,%eax
80102148:	e8 33 f4 ff ff       	call   80101580 <iget>
8010214d:	89 c6                	mov    %eax,%esi
8010214f:	e9 b7 fe ff ff       	jmp    8010200b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102154:	83 ec 0c             	sub    $0xc,%esp
80102157:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010215a:	53                   	push   %ebx
8010215b:	e8 50 24 00 00       	call   801045b0 <holdingsleep>
80102160:	83 c4 10             	add    $0x10,%esp
80102163:	85 c0                	test   %eax,%eax
80102165:	0f 84 91 00 00 00    	je     801021fc <namex+0x23c>
8010216b:	8b 46 08             	mov    0x8(%esi),%eax
8010216e:	85 c0                	test   %eax,%eax
80102170:	0f 8e 86 00 00 00    	jle    801021fc <namex+0x23c>
  releasesleep(&ip->lock);
80102176:	83 ec 0c             	sub    $0xc,%esp
80102179:	53                   	push   %ebx
8010217a:	e8 f1 23 00 00       	call   80104570 <releasesleep>
  iput(ip);
8010217f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102182:	31 f6                	xor    %esi,%esi
  iput(ip);
80102184:	e8 57 f9 ff ff       	call   80101ae0 <iput>
      return 0;
80102189:	83 c4 10             	add    $0x10,%esp
}
8010218c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218f:	89 f0                	mov    %esi,%eax
80102191:	5b                   	pop    %ebx
80102192:	5e                   	pop    %esi
80102193:	5f                   	pop    %edi
80102194:	5d                   	pop    %ebp
80102195:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102196:	83 ec 0c             	sub    $0xc,%esp
80102199:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010219c:	52                   	push   %edx
8010219d:	e8 0e 24 00 00       	call   801045b0 <holdingsleep>
801021a2:	83 c4 10             	add    $0x10,%esp
801021a5:	85 c0                	test   %eax,%eax
801021a7:	74 53                	je     801021fc <namex+0x23c>
801021a9:	8b 4e 08             	mov    0x8(%esi),%ecx
801021ac:	85 c9                	test   %ecx,%ecx
801021ae:	7e 4c                	jle    801021fc <namex+0x23c>
  releasesleep(&ip->lock);
801021b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801021b3:	83 ec 0c             	sub    $0xc,%esp
801021b6:	52                   	push   %edx
801021b7:	eb c1                	jmp    8010217a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021b9:	83 ec 0c             	sub    $0xc,%esp
801021bc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801021bf:	53                   	push   %ebx
801021c0:	e8 eb 23 00 00       	call   801045b0 <holdingsleep>
801021c5:	83 c4 10             	add    $0x10,%esp
801021c8:	85 c0                	test   %eax,%eax
801021ca:	74 30                	je     801021fc <namex+0x23c>
801021cc:	8b 7e 08             	mov    0x8(%esi),%edi
801021cf:	85 ff                	test   %edi,%edi
801021d1:	7e 29                	jle    801021fc <namex+0x23c>
  releasesleep(&ip->lock);
801021d3:	83 ec 0c             	sub    $0xc,%esp
801021d6:	53                   	push   %ebx
801021d7:	e8 94 23 00 00       	call   80104570 <releasesleep>
}
801021dc:	83 c4 10             	add    $0x10,%esp
}
801021df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e2:	89 f0                	mov    %esi,%eax
801021e4:	5b                   	pop    %ebx
801021e5:	5e                   	pop    %esi
801021e6:	5f                   	pop    %edi
801021e7:	5d                   	pop    %ebp
801021e8:	c3                   	ret    
    iput(ip);
801021e9:	83 ec 0c             	sub    $0xc,%esp
801021ec:	56                   	push   %esi
    return 0;
801021ed:	31 f6                	xor    %esi,%esi
    iput(ip);
801021ef:	e8 ec f8 ff ff       	call   80101ae0 <iput>
    return 0;
801021f4:	83 c4 10             	add    $0x10,%esp
801021f7:	e9 2f ff ff ff       	jmp    8010212b <namex+0x16b>
    panic("iunlock");
801021fc:	83 ec 0c             	sub    $0xc,%esp
801021ff:	68 ff 74 10 80       	push   $0x801074ff
80102204:	e8 77 e1 ff ff       	call   80100380 <panic>
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102210 <dirlink>:
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	57                   	push   %edi
80102214:	56                   	push   %esi
80102215:	53                   	push   %ebx
80102216:	83 ec 20             	sub    $0x20,%esp
80102219:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010221c:	6a 00                	push   $0x0
8010221e:	ff 75 0c             	push   0xc(%ebp)
80102221:	53                   	push   %ebx
80102222:	e8 e9 fc ff ff       	call   80101f10 <dirlookup>
80102227:	83 c4 10             	add    $0x10,%esp
8010222a:	85 c0                	test   %eax,%eax
8010222c:	75 67                	jne    80102295 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010222e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102231:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102234:	85 ff                	test   %edi,%edi
80102236:	74 29                	je     80102261 <dirlink+0x51>
80102238:	31 ff                	xor    %edi,%edi
8010223a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010223d:	eb 09                	jmp    80102248 <dirlink+0x38>
8010223f:	90                   	nop
80102240:	83 c7 10             	add    $0x10,%edi
80102243:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102246:	73 19                	jae    80102261 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102248:	6a 10                	push   $0x10
8010224a:	57                   	push   %edi
8010224b:	56                   	push   %esi
8010224c:	53                   	push   %ebx
8010224d:	e8 6e fa ff ff       	call   80101cc0 <readi>
80102252:	83 c4 10             	add    $0x10,%esp
80102255:	83 f8 10             	cmp    $0x10,%eax
80102258:	75 4e                	jne    801022a8 <dirlink+0x98>
    if(de.inum == 0)
8010225a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010225f:	75 df                	jne    80102240 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102261:	83 ec 04             	sub    $0x4,%esp
80102264:	8d 45 da             	lea    -0x26(%ebp),%eax
80102267:	6a 0e                	push   $0xe
80102269:	ff 75 0c             	push   0xc(%ebp)
8010226c:	50                   	push   %eax
8010226d:	e8 7e 27 00 00       	call   801049f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102272:	6a 10                	push   $0x10
  de.inum = inum;
80102274:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102277:	57                   	push   %edi
80102278:	56                   	push   %esi
80102279:	53                   	push   %ebx
  de.inum = inum;
8010227a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010227e:	e8 3d fb ff ff       	call   80101dc0 <writei>
80102283:	83 c4 20             	add    $0x20,%esp
80102286:	83 f8 10             	cmp    $0x10,%eax
80102289:	75 2a                	jne    801022b5 <dirlink+0xa5>
  return 0;
8010228b:	31 c0                	xor    %eax,%eax
}
8010228d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102290:	5b                   	pop    %ebx
80102291:	5e                   	pop    %esi
80102292:	5f                   	pop    %edi
80102293:	5d                   	pop    %ebp
80102294:	c3                   	ret    
    iput(ip);
80102295:	83 ec 0c             	sub    $0xc,%esp
80102298:	50                   	push   %eax
80102299:	e8 42 f8 ff ff       	call   80101ae0 <iput>
    return -1;
8010229e:	83 c4 10             	add    $0x10,%esp
801022a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022a6:	eb e5                	jmp    8010228d <dirlink+0x7d>
      panic("dirlink read");
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	68 28 75 10 80       	push   $0x80107528
801022b0:	e8 cb e0 ff ff       	call   80100380 <panic>
    panic("dirlink");
801022b5:	83 ec 0c             	sub    $0xc,%esp
801022b8:	68 fe 7a 10 80       	push   $0x80107afe
801022bd:	e8 be e0 ff ff       	call   80100380 <panic>
801022c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022d0 <namei>:

struct inode*
namei(char *path)
{
801022d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022d1:	31 d2                	xor    %edx,%edx
{
801022d3:	89 e5                	mov    %esp,%ebp
801022d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801022d8:	8b 45 08             	mov    0x8(%ebp),%eax
801022db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801022de:	e8 dd fc ff ff       	call   80101fc0 <namex>
}
801022e3:	c9                   	leave  
801022e4:	c3                   	ret    
801022e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022f0:	55                   	push   %ebp
  return namex(path, 1, name);
801022f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022ff:	e9 bc fc ff ff       	jmp    80101fc0 <namex>
80102304:	66 90                	xchg   %ax,%ax
80102306:	66 90                	xchg   %ax,%ax
80102308:	66 90                	xchg   %ax,%ax
8010230a:	66 90                	xchg   %ax,%ax
8010230c:	66 90                	xchg   %ax,%ax
8010230e:	66 90                	xchg   %ax,%ax

80102310 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	57                   	push   %edi
80102314:	56                   	push   %esi
80102315:	53                   	push   %ebx
80102316:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102319:	85 c0                	test   %eax,%eax
8010231b:	0f 84 b4 00 00 00    	je     801023d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102321:	8b 70 08             	mov    0x8(%eax),%esi
80102324:	89 c3                	mov    %eax,%ebx
80102326:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010232c:	0f 87 96 00 00 00    	ja     801023c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102332:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233e:	66 90                	xchg   %ax,%ax
80102340:	89 ca                	mov    %ecx,%edx
80102342:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102343:	83 e0 c0             	and    $0xffffffc0,%eax
80102346:	3c 40                	cmp    $0x40,%al
80102348:	75 f6                	jne    80102340 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010234a:	31 ff                	xor    %edi,%edi
8010234c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102351:	89 f8                	mov    %edi,%eax
80102353:	ee                   	out    %al,(%dx)
80102354:	b8 01 00 00 00       	mov    $0x1,%eax
80102359:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010235e:	ee                   	out    %al,(%dx)
8010235f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102364:	89 f0                	mov    %esi,%eax
80102366:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102367:	89 f0                	mov    %esi,%eax
80102369:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010236e:	c1 f8 08             	sar    $0x8,%eax
80102371:	ee                   	out    %al,(%dx)
80102372:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102377:	89 f8                	mov    %edi,%eax
80102379:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010237a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010237e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102383:	c1 e0 04             	shl    $0x4,%eax
80102386:	83 e0 10             	and    $0x10,%eax
80102389:	83 c8 e0             	or     $0xffffffe0,%eax
8010238c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010238d:	f6 03 04             	testb  $0x4,(%ebx)
80102390:	75 16                	jne    801023a8 <idestart+0x98>
80102392:	b8 20 00 00 00       	mov    $0x20,%eax
80102397:	89 ca                	mov    %ecx,%edx
80102399:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010239a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010239d:	5b                   	pop    %ebx
8010239e:	5e                   	pop    %esi
8010239f:	5f                   	pop    %edi
801023a0:	5d                   	pop    %ebp
801023a1:	c3                   	ret    
801023a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023a8:	b8 30 00 00 00       	mov    $0x30,%eax
801023ad:	89 ca                	mov    %ecx,%edx
801023af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801023b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801023b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801023b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023bd:	fc                   	cld    
801023be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c3:	5b                   	pop    %ebx
801023c4:	5e                   	pop    %esi
801023c5:	5f                   	pop    %edi
801023c6:	5d                   	pop    %ebp
801023c7:	c3                   	ret    
    panic("incorrect blockno");
801023c8:	83 ec 0c             	sub    $0xc,%esp
801023cb:	68 94 75 10 80       	push   $0x80107594
801023d0:	e8 ab df ff ff       	call   80100380 <panic>
    panic("idestart");
801023d5:	83 ec 0c             	sub    $0xc,%esp
801023d8:	68 8b 75 10 80       	push   $0x8010758b
801023dd:	e8 9e df ff ff       	call   80100380 <panic>
801023e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023f0 <ideinit>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023f6:	68 a6 75 10 80       	push   $0x801075a6
801023fb:	68 00 16 11 80       	push   $0x80111600
80102400:	e8 fb 21 00 00       	call   80104600 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102405:	58                   	pop    %eax
80102406:	a1 84 17 11 80       	mov    0x80111784,%eax
8010240b:	5a                   	pop    %edx
8010240c:	83 e8 01             	sub    $0x1,%eax
8010240f:	50                   	push   %eax
80102410:	6a 0e                	push   $0xe
80102412:	e8 99 02 00 00       	call   801026b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102417:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010241a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010241f:	90                   	nop
80102420:	ec                   	in     (%dx),%al
80102421:	83 e0 c0             	and    $0xffffffc0,%eax
80102424:	3c 40                	cmp    $0x40,%al
80102426:	75 f8                	jne    80102420 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102428:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010242d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102432:	ee                   	out    %al,(%dx)
80102433:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102438:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010243d:	eb 06                	jmp    80102445 <ideinit+0x55>
8010243f:	90                   	nop
  for(i=0; i<1000; i++){
80102440:	83 e9 01             	sub    $0x1,%ecx
80102443:	74 0f                	je     80102454 <ideinit+0x64>
80102445:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102446:	84 c0                	test   %al,%al
80102448:	74 f6                	je     80102440 <ideinit+0x50>
      havedisk1 = 1;
8010244a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102451:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102454:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102459:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010245e:	ee                   	out    %al,(%dx)
}
8010245f:	c9                   	leave  
80102460:	c3                   	ret    
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246f:	90                   	nop

80102470 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	57                   	push   %edi
80102474:	56                   	push   %esi
80102475:	53                   	push   %ebx
80102476:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102479:	68 00 16 11 80       	push   $0x80111600
8010247e:	e8 4d 23 00 00       	call   801047d0 <acquire>

  if((b = idequeue) == 0){
80102483:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102489:	83 c4 10             	add    $0x10,%esp
8010248c:	85 db                	test   %ebx,%ebx
8010248e:	74 63                	je     801024f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102490:	8b 43 58             	mov    0x58(%ebx),%eax
80102493:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102498:	8b 33                	mov    (%ebx),%esi
8010249a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801024a0:	75 2f                	jne    801024d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ae:	66 90                	xchg   %ax,%ax
801024b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024b1:	89 c1                	mov    %eax,%ecx
801024b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801024b6:	80 f9 40             	cmp    $0x40,%cl
801024b9:	75 f5                	jne    801024b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024bb:	a8 21                	test   $0x21,%al
801024bd:	75 12                	jne    801024d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801024bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801024c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024cc:	fc                   	cld    
801024cd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801024cf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801024d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801024d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024d7:	83 ce 02             	or     $0x2,%esi
801024da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801024dc:	53                   	push   %ebx
801024dd:	e8 4e 1e 00 00       	call   80104330 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024e2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801024e7:	83 c4 10             	add    $0x10,%esp
801024ea:	85 c0                	test   %eax,%eax
801024ec:	74 05                	je     801024f3 <ideintr+0x83>
    idestart(idequeue);
801024ee:	e8 1d fe ff ff       	call   80102310 <idestart>
    release(&idelock);
801024f3:	83 ec 0c             	sub    $0xc,%esp
801024f6:	68 00 16 11 80       	push   $0x80111600
801024fb:	e8 70 22 00 00       	call   80104770 <release>

  release(&idelock);
}
80102500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102503:	5b                   	pop    %ebx
80102504:	5e                   	pop    %esi
80102505:	5f                   	pop    %edi
80102506:	5d                   	pop    %ebp
80102507:	c3                   	ret    
80102508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010250f:	90                   	nop

80102510 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 10             	sub    $0x10,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010251a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010251d:	50                   	push   %eax
8010251e:	e8 8d 20 00 00       	call   801045b0 <holdingsleep>
80102523:	83 c4 10             	add    $0x10,%esp
80102526:	85 c0                	test   %eax,%eax
80102528:	0f 84 c3 00 00 00    	je     801025f1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 e0 06             	and    $0x6,%eax
80102533:	83 f8 02             	cmp    $0x2,%eax
80102536:	0f 84 a8 00 00 00    	je     801025e4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010253c:	8b 53 04             	mov    0x4(%ebx),%edx
8010253f:	85 d2                	test   %edx,%edx
80102541:	74 0d                	je     80102550 <iderw+0x40>
80102543:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102548:	85 c0                	test   %eax,%eax
8010254a:	0f 84 87 00 00 00    	je     801025d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 00 16 11 80       	push   $0x80111600
80102558:	e8 73 22 00 00       	call   801047d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010255d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102562:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102569:	83 c4 10             	add    $0x10,%esp
8010256c:	85 c0                	test   %eax,%eax
8010256e:	74 60                	je     801025d0 <iderw+0xc0>
80102570:	89 c2                	mov    %eax,%edx
80102572:	8b 40 58             	mov    0x58(%eax),%eax
80102575:	85 c0                	test   %eax,%eax
80102577:	75 f7                	jne    80102570 <iderw+0x60>
80102579:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010257c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010257e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102584:	74 3a                	je     801025c0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102586:	8b 03                	mov    (%ebx),%eax
80102588:	83 e0 06             	and    $0x6,%eax
8010258b:	83 f8 02             	cmp    $0x2,%eax
8010258e:	74 1b                	je     801025ab <iderw+0x9b>
    sleep(b, &idelock);
80102590:	83 ec 08             	sub    $0x8,%esp
80102593:	68 00 16 11 80       	push   $0x80111600
80102598:	53                   	push   %ebx
80102599:	e8 d2 1c 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010259e:	8b 03                	mov    (%ebx),%eax
801025a0:	83 c4 10             	add    $0x10,%esp
801025a3:	83 e0 06             	and    $0x6,%eax
801025a6:	83 f8 02             	cmp    $0x2,%eax
801025a9:	75 e5                	jne    80102590 <iderw+0x80>
  }


  release(&idelock);
801025ab:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801025b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025b5:	c9                   	leave  
  release(&idelock);
801025b6:	e9 b5 21 00 00       	jmp    80104770 <release>
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop
    idestart(b);
801025c0:	89 d8                	mov    %ebx,%eax
801025c2:	e8 49 fd ff ff       	call   80102310 <idestart>
801025c7:	eb bd                	jmp    80102586 <iderw+0x76>
801025c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025d0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801025d5:	eb a5                	jmp    8010257c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801025d7:	83 ec 0c             	sub    $0xc,%esp
801025da:	68 d5 75 10 80       	push   $0x801075d5
801025df:	e8 9c dd ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801025e4:	83 ec 0c             	sub    $0xc,%esp
801025e7:	68 c0 75 10 80       	push   $0x801075c0
801025ec:	e8 8f dd ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801025f1:	83 ec 0c             	sub    $0xc,%esp
801025f4:	68 aa 75 10 80       	push   $0x801075aa
801025f9:	e8 82 dd ff ff       	call   80100380 <panic>
801025fe:	66 90                	xchg   %ax,%ax

80102600 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102600:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102601:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102608:	00 c0 fe 
{
8010260b:	89 e5                	mov    %esp,%ebp
8010260d:	56                   	push   %esi
8010260e:	53                   	push   %ebx
  ioapic->reg = reg;
8010260f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102616:	00 00 00 
  return ioapic->data;
80102619:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010261f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102622:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102628:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010262e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102635:	c1 ee 10             	shr    $0x10,%esi
80102638:	89 f0                	mov    %esi,%eax
8010263a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010263d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102640:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102643:	39 c2                	cmp    %eax,%edx
80102645:	74 16                	je     8010265d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102647:	83 ec 0c             	sub    $0xc,%esp
8010264a:	68 f4 75 10 80       	push   $0x801075f4
8010264f:	e8 5c e1 ff ff       	call   801007b0 <cprintf>
  ioapic->reg = reg;
80102654:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010265a:	83 c4 10             	add    $0x10,%esp
8010265d:	83 c6 21             	add    $0x21,%esi
{
80102660:	ba 10 00 00 00       	mov    $0x10,%edx
80102665:	b8 20 00 00 00       	mov    $0x20,%eax
8010266a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102670:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102672:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102674:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010267a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010267d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102683:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102686:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102689:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010268c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010268e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102694:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010269b:	39 f0                	cmp    %esi,%eax
8010269d:	75 d1                	jne    80102670 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010269f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026a2:	5b                   	pop    %ebx
801026a3:	5e                   	pop    %esi
801026a4:	5d                   	pop    %ebp
801026a5:	c3                   	ret    
801026a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ad:	8d 76 00             	lea    0x0(%esi),%esi

801026b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026b0:	55                   	push   %ebp
  ioapic->reg = reg;
801026b1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801026b7:	89 e5                	mov    %esp,%ebp
801026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026bc:	8d 50 20             	lea    0x20(%eax),%edx
801026bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026c5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026d6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026de:	89 50 10             	mov    %edx,0x10(%eax)
}
801026e1:	5d                   	pop    %ebp
801026e2:	c3                   	ret    
801026e3:	66 90                	xchg   %ax,%ax
801026e5:	66 90                	xchg   %ax,%ax
801026e7:	66 90                	xchg   %ax,%ax
801026e9:	66 90                	xchg   %ax,%ax
801026eb:	66 90                	xchg   %ax,%ax
801026ed:	66 90                	xchg   %ax,%ax
801026ef:	90                   	nop

801026f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	53                   	push   %ebx
801026f4:	83 ec 04             	sub    $0x4,%esp
801026f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102700:	75 76                	jne    80102778 <kfree+0x88>
80102702:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
80102708:	72 6e                	jb     80102778 <kfree+0x88>
8010270a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102710:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102715:	77 61                	ja     80102778 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102717:	83 ec 04             	sub    $0x4,%esp
8010271a:	68 00 10 00 00       	push   $0x1000
8010271f:	6a 01                	push   $0x1
80102721:	53                   	push   %ebx
80102722:	e8 69 21 00 00       	call   80104890 <memset>

  if(kmem.use_lock)
80102727:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	85 d2                	test   %edx,%edx
80102732:	75 1c                	jne    80102750 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102734:	a1 78 16 11 80       	mov    0x80111678,%eax
80102739:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010273b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102740:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102746:	85 c0                	test   %eax,%eax
80102748:	75 1e                	jne    80102768 <kfree+0x78>
    release(&kmem.lock);
}
8010274a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010274d:	c9                   	leave  
8010274e:	c3                   	ret    
8010274f:	90                   	nop
    acquire(&kmem.lock);
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	68 40 16 11 80       	push   $0x80111640
80102758:	e8 73 20 00 00       	call   801047d0 <acquire>
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	eb d2                	jmp    80102734 <kfree+0x44>
80102762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102768:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010276f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102772:	c9                   	leave  
    release(&kmem.lock);
80102773:	e9 f8 1f 00 00       	jmp    80104770 <release>
    panic("kfree");
80102778:	83 ec 0c             	sub    $0xc,%esp
8010277b:	68 26 76 10 80       	push   $0x80107626
80102780:	e8 fb db ff ff       	call   80100380 <panic>
80102785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <freerange>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102794:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102797:	8b 75 0c             	mov    0xc(%ebp),%esi
8010279a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010279b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ad:	39 de                	cmp    %ebx,%esi
801027af:	72 23                	jb     801027d4 <freerange+0x44>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027c7:	50                   	push   %eax
801027c8:	e8 23 ff ff ff       	call   801026f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	39 f3                	cmp    %esi,%ebx
801027d2:	76 e4                	jbe    801027b8 <freerange+0x28>
}
801027d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027d7:	5b                   	pop    %ebx
801027d8:	5e                   	pop    %esi
801027d9:	5d                   	pop    %ebp
801027da:	c3                   	ret    
801027db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop

801027e0 <kinit2>:
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801027e4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801027ea:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027fd:	39 de                	cmp    %ebx,%esi
801027ff:	72 23                	jb     80102824 <kinit2+0x44>
80102801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102811:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102817:	50                   	push   %eax
80102818:	e8 d3 fe ff ff       	call   801026f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	39 de                	cmp    %ebx,%esi
80102822:	73 e4                	jae    80102808 <kinit2+0x28>
  kmem.use_lock = 1;
80102824:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010282b:	00 00 00 
}
8010282e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102831:	5b                   	pop    %ebx
80102832:	5e                   	pop    %esi
80102833:	5d                   	pop    %ebp
80102834:	c3                   	ret    
80102835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102840 <kinit1>:
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	56                   	push   %esi
80102844:	53                   	push   %ebx
80102845:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102848:	83 ec 08             	sub    $0x8,%esp
8010284b:	68 2c 76 10 80       	push   $0x8010762c
80102850:	68 40 16 11 80       	push   $0x80111640
80102855:	e8 a6 1d 00 00       	call   80104600 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010285a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010285d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102860:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102867:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010286a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102870:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102876:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010287c:	39 de                	cmp    %ebx,%esi
8010287e:	72 1c                	jb     8010289c <kinit1+0x5c>
    kfree(p);
80102880:	83 ec 0c             	sub    $0xc,%esp
80102883:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102889:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010288f:	50                   	push   %eax
80102890:	e8 5b fe ff ff       	call   801026f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102895:	83 c4 10             	add    $0x10,%esp
80102898:	39 de                	cmp    %ebx,%esi
8010289a:	73 e4                	jae    80102880 <kinit1+0x40>
}
8010289c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010289f:	5b                   	pop    %ebx
801028a0:	5e                   	pop    %esi
801028a1:	5d                   	pop    %ebp
801028a2:	c3                   	ret    
801028a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801028b0:	a1 74 16 11 80       	mov    0x80111674,%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	75 1f                	jne    801028d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801028b9:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
801028be:	85 c0                	test   %eax,%eax
801028c0:	74 0e                	je     801028d0 <kalloc+0x20>
    kmem.freelist = r->next;
801028c2:	8b 10                	mov    (%eax),%edx
801028c4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801028d0:	c3                   	ret    
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801028d8:	55                   	push   %ebp
801028d9:	89 e5                	mov    %esp,%ebp
801028db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801028de:	68 40 16 11 80       	push   $0x80111640
801028e3:	e8 e8 1e 00 00       	call   801047d0 <acquire>
  r = kmem.freelist;
801028e8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801028ed:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801028f3:	83 c4 10             	add    $0x10,%esp
801028f6:	85 c0                	test   %eax,%eax
801028f8:	74 08                	je     80102902 <kalloc+0x52>
    kmem.freelist = r->next;
801028fa:	8b 08                	mov    (%eax),%ecx
801028fc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
80102902:	85 d2                	test   %edx,%edx
80102904:	74 16                	je     8010291c <kalloc+0x6c>
    release(&kmem.lock);
80102906:	83 ec 0c             	sub    $0xc,%esp
80102909:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010290c:	68 40 16 11 80       	push   $0x80111640
80102911:	e8 5a 1e 00 00       	call   80104770 <release>
  return (char*)r;
80102916:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102919:	83 c4 10             	add    $0x10,%esp
}
8010291c:	c9                   	leave  
8010291d:	c3                   	ret    
8010291e:	66 90                	xchg   %ax,%ax

80102920 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	ba 64 00 00 00       	mov    $0x64,%edx
80102925:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102926:	a8 01                	test   $0x1,%al
80102928:	0f 84 c2 00 00 00    	je     801029f0 <kbdgetc+0xd0>
{
8010292e:	55                   	push   %ebp
8010292f:	ba 60 00 00 00       	mov    $0x60,%edx
80102934:	89 e5                	mov    %esp,%ebp
80102936:	53                   	push   %ebx
80102937:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102938:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010293e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102941:	3c e0                	cmp    $0xe0,%al
80102943:	74 5b                	je     801029a0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102945:	89 da                	mov    %ebx,%edx
80102947:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010294a:	84 c0                	test   %al,%al
8010294c:	78 62                	js     801029b0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010294e:	85 d2                	test   %edx,%edx
80102950:	74 09                	je     8010295b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102952:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102955:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102958:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010295b:	0f b6 91 60 77 10 80 	movzbl -0x7fef88a0(%ecx),%edx
  shift ^= togglecode[data];
80102962:	0f b6 81 60 76 10 80 	movzbl -0x7fef89a0(%ecx),%eax
  shift |= shiftcode[data];
80102969:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010296b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010296d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010296f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102975:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102978:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010297b:	8b 04 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%eax
80102982:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102986:	74 0b                	je     80102993 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102988:	8d 50 9f             	lea    -0x61(%eax),%edx
8010298b:	83 fa 19             	cmp    $0x19,%edx
8010298e:	77 48                	ja     801029d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102990:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102993:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102996:	c9                   	leave  
80102997:	c3                   	ret    
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop
    shift |= E0ESC;
801029a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801029a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801029a5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801029ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ae:	c9                   	leave  
801029af:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801029b0:	83 e0 7f             	and    $0x7f,%eax
801029b3:	85 d2                	test   %edx,%edx
801029b5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801029b8:	0f b6 81 60 77 10 80 	movzbl -0x7fef88a0(%ecx),%eax
801029bf:	83 c8 40             	or     $0x40,%eax
801029c2:	0f b6 c0             	movzbl %al,%eax
801029c5:	f7 d0                	not    %eax
801029c7:	21 d8                	and    %ebx,%eax
}
801029c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801029cc:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801029d1:	31 c0                	xor    %eax,%eax
}
801029d3:	c9                   	leave  
801029d4:	c3                   	ret    
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801029d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029db:	8d 50 20             	lea    0x20(%eax),%edx
}
801029de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e1:	c9                   	leave  
      c += 'a' - 'A';
801029e2:	83 f9 1a             	cmp    $0x1a,%ecx
801029e5:	0f 42 c2             	cmovb  %edx,%eax
}
801029e8:	c3                   	ret    
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029f5:	c3                   	ret    
801029f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fd:	8d 76 00             	lea    0x0(%esi),%esi

80102a00 <kbdintr>:

void
kbdintr(void)
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a06:	68 20 29 10 80       	push   $0x80102920
80102a0b:	e8 10 e0 ff ff       	call   80100a20 <consoleintr>
}
80102a10:	83 c4 10             	add    $0x10,%esp
80102a13:	c9                   	leave  
80102a14:	c3                   	ret    
80102a15:	66 90                	xchg   %ax,%ax
80102a17:	66 90                	xchg   %ax,%ax
80102a19:	66 90                	xchg   %ax,%ax
80102a1b:	66 90                	xchg   %ax,%ax
80102a1d:	66 90                	xchg   %ax,%ax
80102a1f:	90                   	nop

80102a20 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a20:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	0f 84 cb 00 00 00    	je     80102af8 <lapicinit+0xd8>
  lapic[index] = value;
80102a2d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a34:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a47:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a4e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a51:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a54:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a5b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a61:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a68:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a75:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a78:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a7b:	8b 50 30             	mov    0x30(%eax),%edx
80102a7e:	c1 ea 10             	shr    $0x10,%edx
80102a81:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a87:	75 77                	jne    80102b00 <lapicinit+0xe0>
  lapic[index] = value;
80102a89:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a90:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a93:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a96:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a9d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aaa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ab7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102abd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ac4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ad1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad4:	8b 50 20             	mov    0x20(%eax),%edx
80102ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ade:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ae0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ae6:	80 e6 10             	and    $0x10,%dh
80102ae9:	75 f5                	jne    80102ae0 <lapicinit+0xc0>
  lapic[index] = value;
80102aeb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102af2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102af8:	c3                   	ret    
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102b00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b0a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102b0d:	e9 77 ff ff ff       	jmp    80102a89 <lapicinit+0x69>
80102b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b20 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b20:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	74 07                	je     80102b30 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102b29:	8b 40 20             	mov    0x20(%eax),%eax
80102b2c:	c1 e8 18             	shr    $0x18,%eax
80102b2f:	c3                   	ret    
    return 0;
80102b30:	31 c0                	xor    %eax,%eax
}
80102b32:	c3                   	ret    
80102b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b40:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b45:	85 c0                	test   %eax,%eax
80102b47:	74 0d                	je     80102b56 <lapiceoi+0x16>
  lapic[index] = value;
80102b49:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b56:	c3                   	ret    
80102b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b5e:	66 90                	xchg   %ax,%ax

80102b60 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b60:	c3                   	ret    
80102b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6f:	90                   	nop

80102b70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b71:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b76:	ba 70 00 00 00       	mov    $0x70,%edx
80102b7b:	89 e5                	mov    %esp,%ebp
80102b7d:	53                   	push   %ebx
80102b7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b84:	ee                   	out    %al,(%dx)
80102b85:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b8a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b8f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b90:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b92:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b95:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b9b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b9d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102ba0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ba2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ba5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ba8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102bae:	a1 80 16 11 80       	mov    0x80111680,%eax
80102bb3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bb9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bbc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bc3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bc9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bd0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bd6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bdc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bdf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102be5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102be8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bf1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bf7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bfd:	c9                   	leave  
80102bfe:	c3                   	ret    
80102bff:	90                   	nop

80102c00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102c00:	55                   	push   %ebp
80102c01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c06:	ba 70 00 00 00       	mov    $0x70,%edx
80102c0b:	89 e5                	mov    %esp,%ebp
80102c0d:	57                   	push   %edi
80102c0e:	56                   	push   %esi
80102c0f:	53                   	push   %ebx
80102c10:	83 ec 4c             	sub    $0x4c,%esp
80102c13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c14:	ba 71 00 00 00       	mov    $0x71,%edx
80102c19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102c1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c25:	8d 76 00             	lea    0x0(%esi),%esi
80102c28:	31 c0                	xor    %eax,%eax
80102c2a:	89 da                	mov    %ebx,%edx
80102c2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c32:	89 ca                	mov    %ecx,%edx
80102c34:	ec                   	in     (%dx),%al
80102c35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c38:	89 da                	mov    %ebx,%edx
80102c3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c40:	89 ca                	mov    %ecx,%edx
80102c42:	ec                   	in     (%dx),%al
80102c43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c46:	89 da                	mov    %ebx,%edx
80102c48:	b8 04 00 00 00       	mov    $0x4,%eax
80102c4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4e:	89 ca                	mov    %ecx,%edx
80102c50:	ec                   	in     (%dx),%al
80102c51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c54:	89 da                	mov    %ebx,%edx
80102c56:	b8 07 00 00 00       	mov    $0x7,%eax
80102c5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5c:	89 ca                	mov    %ecx,%edx
80102c5e:	ec                   	in     (%dx),%al
80102c5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c62:	89 da                	mov    %ebx,%edx
80102c64:	b8 08 00 00 00       	mov    $0x8,%eax
80102c69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6a:	89 ca                	mov    %ecx,%edx
80102c6c:	ec                   	in     (%dx),%al
80102c6d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6f:	89 da                	mov    %ebx,%edx
80102c71:	b8 09 00 00 00       	mov    $0x9,%eax
80102c76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c77:	89 ca                	mov    %ecx,%edx
80102c79:	ec                   	in     (%dx),%al
80102c7a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7c:	89 da                	mov    %ebx,%edx
80102c7e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c84:	89 ca                	mov    %ecx,%edx
80102c86:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c87:	84 c0                	test   %al,%al
80102c89:	78 9d                	js     80102c28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c8b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c8f:	89 fa                	mov    %edi,%edx
80102c91:	0f b6 fa             	movzbl %dl,%edi
80102c94:	89 f2                	mov    %esi,%edx
80102c96:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c99:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c9d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca0:	89 da                	mov    %ebx,%edx
80102ca2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ca5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ca8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102cac:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102caf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102cb2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102cb9:	31 c0                	xor    %eax,%eax
80102cbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbc:	89 ca                	mov    %ecx,%edx
80102cbe:	ec                   	in     (%dx),%al
80102cbf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc2:	89 da                	mov    %ebx,%edx
80102cc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cc7:	b8 02 00 00 00       	mov    $0x2,%eax
80102ccc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccd:	89 ca                	mov    %ecx,%edx
80102ccf:	ec                   	in     (%dx),%al
80102cd0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd3:	89 da                	mov    %ebx,%edx
80102cd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cdd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cde:	89 ca                	mov    %ecx,%edx
80102ce0:	ec                   	in     (%dx),%al
80102ce1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce4:	89 da                	mov    %ebx,%edx
80102ce6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ce9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cef:	89 ca                	mov    %ecx,%edx
80102cf1:	ec                   	in     (%dx),%al
80102cf2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf5:	89 da                	mov    %ebx,%edx
80102cf7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cfa:	b8 08 00 00 00       	mov    $0x8,%eax
80102cff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d00:	89 ca                	mov    %ecx,%edx
80102d02:	ec                   	in     (%dx),%al
80102d03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d06:	89 da                	mov    %ebx,%edx
80102d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d11:	89 ca                	mov    %ecx,%edx
80102d13:	ec                   	in     (%dx),%al
80102d14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d20:	6a 18                	push   $0x18
80102d22:	50                   	push   %eax
80102d23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d26:	50                   	push   %eax
80102d27:	e8 b4 1b 00 00       	call   801048e0 <memcmp>
80102d2c:	83 c4 10             	add    $0x10,%esp
80102d2f:	85 c0                	test   %eax,%eax
80102d31:	0f 85 f1 fe ff ff    	jne    80102c28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d3b:	75 78                	jne    80102db5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	83 e0 0f             	and    $0xf,%eax
80102d45:	c1 ea 04             	shr    $0x4,%edx
80102d48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	c1 ea 04             	shr    $0x4,%edx
80102d5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d68:	89 c2                	mov    %eax,%edx
80102d6a:	83 e0 0f             	and    $0xf,%eax
80102d6d:	c1 ea 04             	shr    $0x4,%edx
80102d70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 c2                	mov    %eax,%edx
80102d7e:	83 e0 0f             	and    $0xf,%eax
80102d81:	c1 ea 04             	shr    $0x4,%edx
80102d84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d90:	89 c2                	mov    %eax,%edx
80102d92:	83 e0 0f             	and    $0xf,%eax
80102d95:	c1 ea 04             	shr    $0x4,%edx
80102d98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102da1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102da4:	89 c2                	mov    %eax,%edx
80102da6:	83 e0 0f             	and    $0xf,%eax
80102da9:	c1 ea 04             	shr    $0x4,%edx
80102dac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102daf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102db2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102db5:	8b 75 08             	mov    0x8(%ebp),%esi
80102db8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dbb:	89 06                	mov    %eax,(%esi)
80102dbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dc0:	89 46 04             	mov    %eax,0x4(%esi)
80102dc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dc6:	89 46 08             	mov    %eax,0x8(%esi)
80102dc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dcc:	89 46 0c             	mov    %eax,0xc(%esi)
80102dcf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dd2:	89 46 10             	mov    %eax,0x10(%esi)
80102dd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102dd8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ddb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102de5:	5b                   	pop    %ebx
80102de6:	5e                   	pop    %esi
80102de7:	5f                   	pop    %edi
80102de8:	5d                   	pop    %ebp
80102de9:	c3                   	ret    
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102df0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102df6:	85 c9                	test   %ecx,%ecx
80102df8:	0f 8e 8a 00 00 00    	jle    80102e88 <install_trans+0x98>
{
80102dfe:	55                   	push   %ebp
80102dff:	89 e5                	mov    %esp,%ebp
80102e01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102e02:	31 ff                	xor    %edi,%edi
{
80102e04:	56                   	push   %esi
80102e05:	53                   	push   %ebx
80102e06:	83 ec 0c             	sub    $0xc,%esp
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e10:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e15:	83 ec 08             	sub    $0x8,%esp
80102e18:	01 f8                	add    %edi,%eax
80102e1a:	83 c0 01             	add    $0x1,%eax
80102e1d:	50                   	push   %eax
80102e1e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e24:	e8 a7 d2 ff ff       	call   801000d0 <bread>
80102e29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e2b:	58                   	pop    %eax
80102e2c:	5a                   	pop    %edx
80102e2d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102e34:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e3d:	e8 8e d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e4a:	68 00 02 00 00       	push   $0x200
80102e4f:	50                   	push   %eax
80102e50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e53:	50                   	push   %eax
80102e54:	e8 d7 1a 00 00       	call   80104930 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e59:	89 1c 24             	mov    %ebx,(%esp)
80102e5c:	e8 4f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e61:	89 34 24             	mov    %esi,(%esp)
80102e64:	e8 87 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e69:	89 1c 24             	mov    %ebx,(%esp)
80102e6c:	e8 7f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e71:	83 c4 10             	add    $0x10,%esp
80102e74:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102e7a:	7f 94                	jg     80102e10 <install_trans+0x20>
  }
}
80102e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e7f:	5b                   	pop    %ebx
80102e80:	5e                   	pop    %esi
80102e81:	5f                   	pop    %edi
80102e82:	5d                   	pop    %ebp
80102e83:	c3                   	ret    
80102e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e88:	c3                   	ret    
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e97:	ff 35 d4 16 11 80    	push   0x801116d4
80102e9d:	ff 35 e4 16 11 80    	push   0x801116e4
80102ea3:	e8 28 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ea8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102eab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ead:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102eb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102eb5:	85 c0                	test   %eax,%eax
80102eb7:	7e 19                	jle    80102ed2 <write_head+0x42>
80102eb9:	31 d2                	xor    %edx,%edx
80102ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ebf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ec0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102ec7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ecb:	83 c2 01             	add    $0x1,%edx
80102ece:	39 d0                	cmp    %edx,%eax
80102ed0:	75 ee                	jne    80102ec0 <write_head+0x30>
  }
  bwrite(buf);
80102ed2:	83 ec 0c             	sub    $0xc,%esp
80102ed5:	53                   	push   %ebx
80102ed6:	e8 d5 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102edb:	89 1c 24             	mov    %ebx,(%esp)
80102ede:	e8 0d d3 ff ff       	call   801001f0 <brelse>
}
80102ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ee6:	83 c4 10             	add    $0x10,%esp
80102ee9:	c9                   	leave  
80102eea:	c3                   	ret    
80102eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eef:	90                   	nop

80102ef0 <initlog>:
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	53                   	push   %ebx
80102ef4:	83 ec 2c             	sub    $0x2c,%esp
80102ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102efa:	68 60 78 10 80       	push   $0x80107860
80102eff:	68 a0 16 11 80       	push   $0x801116a0
80102f04:	e8 f7 16 00 00       	call   80104600 <initlock>
  readsb(dev, &sb);
80102f09:	58                   	pop    %eax
80102f0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 3b e8 ff ff       	call   80101750 <readsb>
  log.start = sb.logstart;
80102f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f18:	59                   	pop    %ecx
  log.dev = dev;
80102f19:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102f1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f22:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102f27:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102f2d:	5a                   	pop    %edx
80102f2e:	50                   	push   %eax
80102f2f:	53                   	push   %ebx
80102f30:	e8 9b d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102f35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102f38:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102f3b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102f41:	85 db                	test   %ebx,%ebx
80102f43:	7e 1d                	jle    80102f62 <initlog+0x72>
80102f45:	31 d2                	xor    %edx,%edx
80102f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f50:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f54:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f5b:	83 c2 01             	add    $0x1,%edx
80102f5e:	39 d3                	cmp    %edx,%ebx
80102f60:	75 ee                	jne    80102f50 <initlog+0x60>
  brelse(buf);
80102f62:	83 ec 0c             	sub    $0xc,%esp
80102f65:	50                   	push   %eax
80102f66:	e8 85 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f6b:	e8 80 fe ff ff       	call   80102df0 <install_trans>
  log.lh.n = 0;
80102f70:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f77:	00 00 00 
  write_head(); // clear the log
80102f7a:	e8 11 ff ff ff       	call   80102e90 <write_head>
}
80102f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f82:	83 c4 10             	add    $0x10,%esp
80102f85:	c9                   	leave  
80102f86:	c3                   	ret    
80102f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8e:	66 90                	xchg   %ax,%ax

80102f90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f96:	68 a0 16 11 80       	push   $0x801116a0
80102f9b:	e8 30 18 00 00       	call   801047d0 <acquire>
80102fa0:	83 c4 10             	add    $0x10,%esp
80102fa3:	eb 18                	jmp    80102fbd <begin_op+0x2d>
80102fa5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fa8:	83 ec 08             	sub    $0x8,%esp
80102fab:	68 a0 16 11 80       	push   $0x801116a0
80102fb0:	68 a0 16 11 80       	push   $0x801116a0
80102fb5:	e8 b6 12 00 00       	call   80104270 <sleep>
80102fba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102fbd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102fc2:	85 c0                	test   %eax,%eax
80102fc4:	75 e2                	jne    80102fa8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fc6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102fcb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102fd1:	83 c0 01             	add    $0x1,%eax
80102fd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fda:	83 fa 1e             	cmp    $0x1e,%edx
80102fdd:	7f c9                	jg     80102fa8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fdf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fe2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102fe7:	68 a0 16 11 80       	push   $0x801116a0
80102fec:	e8 7f 17 00 00       	call   80104770 <release>
      break;
    }
  }
}
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	c9                   	leave  
80102ff5:	c3                   	ret    
80102ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ffd:	8d 76 00             	lea    0x0(%esi),%esi

80103000 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103009:	68 a0 16 11 80       	push   $0x801116a0
8010300e:	e8 bd 17 00 00       	call   801047d0 <acquire>
  log.outstanding -= 1;
80103013:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80103018:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
8010301e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103021:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103024:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
8010302a:	85 f6                	test   %esi,%esi
8010302c:	0f 85 22 01 00 00    	jne    80103154 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103032:	85 db                	test   %ebx,%ebx
80103034:	0f 85 f6 00 00 00    	jne    80103130 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010303a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80103041:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103044:	83 ec 0c             	sub    $0xc,%esp
80103047:	68 a0 16 11 80       	push   $0x801116a0
8010304c:	e8 1f 17 00 00       	call   80104770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103051:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80103057:	83 c4 10             	add    $0x10,%esp
8010305a:	85 c9                	test   %ecx,%ecx
8010305c:	7f 42                	jg     801030a0 <end_op+0xa0>
    acquire(&log.lock);
8010305e:	83 ec 0c             	sub    $0xc,%esp
80103061:	68 a0 16 11 80       	push   $0x801116a0
80103066:	e8 65 17 00 00       	call   801047d0 <acquire>
    wakeup(&log);
8010306b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80103072:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80103079:	00 00 00 
    wakeup(&log);
8010307c:	e8 af 12 00 00       	call   80104330 <wakeup>
    release(&log.lock);
80103081:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103088:	e8 e3 16 00 00       	call   80104770 <release>
8010308d:	83 c4 10             	add    $0x10,%esp
}
80103090:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103093:	5b                   	pop    %ebx
80103094:	5e                   	pop    %esi
80103095:	5f                   	pop    %edi
80103096:	5d                   	pop    %ebp
80103097:	c3                   	ret    
80103098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010309f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801030a0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
801030a5:	83 ec 08             	sub    $0x8,%esp
801030a8:	01 d8                	add    %ebx,%eax
801030aa:	83 c0 01             	add    $0x1,%eax
801030ad:	50                   	push   %eax
801030ae:	ff 35 e4 16 11 80    	push   0x801116e4
801030b4:	e8 17 d0 ff ff       	call   801000d0 <bread>
801030b9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030bb:	58                   	pop    %eax
801030bc:	5a                   	pop    %edx
801030bd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
801030c4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030ca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030cd:	e8 fe cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801030d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030d5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801030da:	68 00 02 00 00       	push   $0x200
801030df:	50                   	push   %eax
801030e0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030e3:	50                   	push   %eax
801030e4:	e8 47 18 00 00       	call   80104930 <memmove>
    bwrite(to);  // write the log
801030e9:	89 34 24             	mov    %esi,(%esp)
801030ec:	e8 bf d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030f1:	89 3c 24             	mov    %edi,(%esp)
801030f4:	e8 f7 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030f9:	89 34 24             	mov    %esi,(%esp)
801030fc:	e8 ef d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103101:	83 c4 10             	add    $0x10,%esp
80103104:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010310a:	7c 94                	jl     801030a0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010310c:	e8 7f fd ff ff       	call   80102e90 <write_head>
    install_trans(); // Now install writes to home locations
80103111:	e8 da fc ff ff       	call   80102df0 <install_trans>
    log.lh.n = 0;
80103116:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010311d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103120:	e8 6b fd ff ff       	call   80102e90 <write_head>
80103125:	e9 34 ff ff ff       	jmp    8010305e <end_op+0x5e>
8010312a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103130:	83 ec 0c             	sub    $0xc,%esp
80103133:	68 a0 16 11 80       	push   $0x801116a0
80103138:	e8 f3 11 00 00       	call   80104330 <wakeup>
  release(&log.lock);
8010313d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103144:	e8 27 16 00 00       	call   80104770 <release>
80103149:	83 c4 10             	add    $0x10,%esp
}
8010314c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314f:	5b                   	pop    %ebx
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
    panic("log.committing");
80103154:	83 ec 0c             	sub    $0xc,%esp
80103157:	68 64 78 10 80       	push   $0x80107864
8010315c:	e8 1f d2 ff ff       	call   80100380 <panic>
80103161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010316f:	90                   	nop

80103170 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103177:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010317d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103180:	83 fa 1d             	cmp    $0x1d,%edx
80103183:	0f 8f 85 00 00 00    	jg     8010320e <log_write+0x9e>
80103189:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010318e:	83 e8 01             	sub    $0x1,%eax
80103191:	39 c2                	cmp    %eax,%edx
80103193:	7d 79                	jge    8010320e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103195:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010319a:	85 c0                	test   %eax,%eax
8010319c:	7e 7d                	jle    8010321b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010319e:	83 ec 0c             	sub    $0xc,%esp
801031a1:	68 a0 16 11 80       	push   $0x801116a0
801031a6:	e8 25 16 00 00       	call   801047d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031ab:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801031b1:	83 c4 10             	add    $0x10,%esp
801031b4:	85 d2                	test   %edx,%edx
801031b6:	7e 4a                	jle    80103202 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031b8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801031bb:	31 c0                	xor    %eax,%eax
801031bd:	eb 08                	jmp    801031c7 <log_write+0x57>
801031bf:	90                   	nop
801031c0:	83 c0 01             	add    $0x1,%eax
801031c3:	39 c2                	cmp    %eax,%edx
801031c5:	74 29                	je     801031f0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801031ce:	75 f0                	jne    801031c0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801031d0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031d7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031dd:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
801031e4:	c9                   	leave  
  release(&log.lock);
801031e5:	e9 86 15 00 00       	jmp    80104770 <release>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031f0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801031f7:	83 c2 01             	add    $0x1,%edx
801031fa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103200:	eb d5                	jmp    801031d7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103202:	8b 43 08             	mov    0x8(%ebx),%eax
80103205:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
8010320a:	75 cb                	jne    801031d7 <log_write+0x67>
8010320c:	eb e9                	jmp    801031f7 <log_write+0x87>
    panic("too big a transaction");
8010320e:	83 ec 0c             	sub    $0xc,%esp
80103211:	68 73 78 10 80       	push   $0x80107873
80103216:	e8 65 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010321b:	83 ec 0c             	sub    $0xc,%esp
8010321e:	68 89 78 10 80       	push   $0x80107889
80103223:	e8 58 d1 ff ff       	call   80100380 <panic>
80103228:	66 90                	xchg   %ax,%ax
8010322a:	66 90                	xchg   %ax,%ax
8010322c:	66 90                	xchg   %ax,%ax
8010322e:	66 90                	xchg   %ax,%ax

80103230 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	53                   	push   %ebx
80103234:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103237:	e8 44 09 00 00       	call   80103b80 <cpuid>
8010323c:	89 c3                	mov    %eax,%ebx
8010323e:	e8 3d 09 00 00       	call   80103b80 <cpuid>
80103243:	83 ec 04             	sub    $0x4,%esp
80103246:	53                   	push   %ebx
80103247:	50                   	push   %eax
80103248:	68 a4 78 10 80       	push   $0x801078a4
8010324d:	e8 5e d5 ff ff       	call   801007b0 <cprintf>
  idtinit();       // load idt register
80103252:	e8 b9 28 00 00       	call   80105b10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103257:	e8 c4 08 00 00       	call   80103b20 <mycpu>
8010325c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010325e:	b8 01 00 00 00       	mov    $0x1,%eax
80103263:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010326a:	e8 f1 0b 00 00       	call   80103e60 <scheduler>
8010326f:	90                   	nop

80103270 <mpenter>:
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103276:	e8 85 39 00 00       	call   80106c00 <switchkvm>
  seginit();
8010327b:	e8 f0 38 00 00       	call   80106b70 <seginit>
  lapicinit();
80103280:	e8 9b f7 ff ff       	call   80102a20 <lapicinit>
  mpmain();
80103285:	e8 a6 ff ff ff       	call   80103230 <mpmain>
8010328a:	66 90                	xchg   %ax,%ax
8010328c:	66 90                	xchg   %ax,%ax
8010328e:	66 90                	xchg   %ax,%ax

80103290 <main>:
{
80103290:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103294:	83 e4 f0             	and    $0xfffffff0,%esp
80103297:	ff 71 fc             	push   -0x4(%ecx)
8010329a:	55                   	push   %ebp
8010329b:	89 e5                	mov    %esp,%ebp
8010329d:	53                   	push   %ebx
8010329e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010329f:	83 ec 08             	sub    $0x8,%esp
801032a2:	68 00 00 40 80       	push   $0x80400000
801032a7:	68 d0 54 11 80       	push   $0x801154d0
801032ac:	e8 8f f5 ff ff       	call   80102840 <kinit1>
  kvmalloc();      // kernel page table
801032b1:	e8 3a 3e 00 00       	call   801070f0 <kvmalloc>
  mpinit();        // detect other processors
801032b6:	e8 85 01 00 00       	call   80103440 <mpinit>
  lapicinit();     // interrupt controller
801032bb:	e8 60 f7 ff ff       	call   80102a20 <lapicinit>
  seginit();       // segment descriptors
801032c0:	e8 ab 38 00 00       	call   80106b70 <seginit>
  picinit();       // disable pic
801032c5:	e8 76 03 00 00       	call   80103640 <picinit>
  ioapicinit();    // another interrupt controller
801032ca:	e8 31 f3 ff ff       	call   80102600 <ioapicinit>
  consoleinit();   // console hardware
801032cf:	e8 bc d9 ff ff       	call   80100c90 <consoleinit>
  uartinit();      // serial port
801032d4:	e8 27 2b 00 00       	call   80105e00 <uartinit>
  pinit();         // process table
801032d9:	e8 22 08 00 00       	call   80103b00 <pinit>
  tvinit();        // trap vectors
801032de:	e8 ad 27 00 00       	call   80105a90 <tvinit>
  binit();         // buffer cache
801032e3:	e8 58 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032e8:	e8 53 dd ff ff       	call   80101040 <fileinit>
  ideinit();       // disk 
801032ed:	e8 fe f0 ff ff       	call   801023f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032f2:	83 c4 0c             	add    $0xc,%esp
801032f5:	68 8a 00 00 00       	push   $0x8a
801032fa:	68 8c a4 10 80       	push   $0x8010a48c
801032ff:	68 00 70 00 80       	push   $0x80007000
80103304:	e8 27 16 00 00       	call   80104930 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103309:	83 c4 10             	add    $0x10,%esp
8010330c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103313:	00 00 00 
80103316:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010331b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103320:	76 7e                	jbe    801033a0 <main+0x110>
80103322:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103327:	eb 20                	jmp    80103349 <main+0xb9>
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103330:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103337:	00 00 00 
8010333a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103340:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103345:	39 c3                	cmp    %eax,%ebx
80103347:	73 57                	jae    801033a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103349:	e8 d2 07 00 00       	call   80103b20 <mycpu>
8010334e:	39 c3                	cmp    %eax,%ebx
80103350:	74 de                	je     80103330 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103352:	e8 59 f5 ff ff       	call   801028b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103357:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010335a:	c7 05 f8 6f 00 80 70 	movl   $0x80103270,0x80006ff8
80103361:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103364:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010336b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010336e:	05 00 10 00 00       	add    $0x1000,%eax
80103373:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103378:	0f b6 03             	movzbl (%ebx),%eax
8010337b:	68 00 70 00 00       	push   $0x7000
80103380:	50                   	push   %eax
80103381:	e8 ea f7 ff ff       	call   80102b70 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103386:	83 c4 10             	add    $0x10,%esp
80103389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103390:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103396:	85 c0                	test   %eax,%eax
80103398:	74 f6                	je     80103390 <main+0x100>
8010339a:	eb 94                	jmp    80103330 <main+0xa0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033a0:	83 ec 08             	sub    $0x8,%esp
801033a3:	68 00 00 00 8e       	push   $0x8e000000
801033a8:	68 00 00 40 80       	push   $0x80400000
801033ad:	e8 2e f4 ff ff       	call   801027e0 <kinit2>
  userinit();      // first user process
801033b2:	e8 19 08 00 00       	call   80103bd0 <userinit>
  mpmain();        // finish this processor's setup
801033b7:	e8 74 fe ff ff       	call   80103230 <mpmain>
801033bc:	66 90                	xchg   %ax,%ax
801033be:	66 90                	xchg   %ax,%ax

801033c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801033cb:	53                   	push   %ebx
  e = addr+len;
801033cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801033cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033d2:	39 de                	cmp    %ebx,%esi
801033d4:	72 10                	jb     801033e6 <mpsearch1+0x26>
801033d6:	eb 50                	jmp    80103428 <mpsearch1+0x68>
801033d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop
801033e0:	89 fe                	mov    %edi,%esi
801033e2:	39 fb                	cmp    %edi,%ebx
801033e4:	76 42                	jbe    80103428 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e6:	83 ec 04             	sub    $0x4,%esp
801033e9:	8d 7e 10             	lea    0x10(%esi),%edi
801033ec:	6a 04                	push   $0x4
801033ee:	68 b8 78 10 80       	push   $0x801078b8
801033f3:	56                   	push   %esi
801033f4:	e8 e7 14 00 00       	call   801048e0 <memcmp>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	85 c0                	test   %eax,%eax
801033fe:	75 e0                	jne    801033e0 <mpsearch1+0x20>
80103400:	89 f2                	mov    %esi,%edx
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103408:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010340b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010340e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103410:	39 fa                	cmp    %edi,%edx
80103412:	75 f4                	jne    80103408 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103414:	84 c0                	test   %al,%al
80103416:	75 c8                	jne    801033e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103418:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341b:	89 f0                	mov    %esi,%eax
8010341d:	5b                   	pop    %ebx
8010341e:	5e                   	pop    %esi
8010341f:	5f                   	pop    %edi
80103420:	5d                   	pop    %ebp
80103421:	c3                   	ret    
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010342b:	31 f6                	xor    %esi,%esi
}
8010342d:	5b                   	pop    %ebx
8010342e:	89 f0                	mov    %esi,%eax
80103430:	5e                   	pop    %esi
80103431:	5f                   	pop    %edi
80103432:	5d                   	pop    %ebp
80103433:	c3                   	ret    
80103434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010343f:	90                   	nop

80103440 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103449:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103450:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103457:	c1 e0 08             	shl    $0x8,%eax
8010345a:	09 d0                	or     %edx,%eax
8010345c:	c1 e0 04             	shl    $0x4,%eax
8010345f:	75 1b                	jne    8010347c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103461:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103468:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010346f:	c1 e0 08             	shl    $0x8,%eax
80103472:	09 d0                	or     %edx,%eax
80103474:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103477:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010347c:	ba 00 04 00 00       	mov    $0x400,%edx
80103481:	e8 3a ff ff ff       	call   801033c0 <mpsearch1>
80103486:	89 c3                	mov    %eax,%ebx
80103488:	85 c0                	test   %eax,%eax
8010348a:	0f 84 40 01 00 00    	je     801035d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103490:	8b 73 04             	mov    0x4(%ebx),%esi
80103493:	85 f6                	test   %esi,%esi
80103495:	0f 84 25 01 00 00    	je     801035c0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010349b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010349e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801034a4:	6a 04                	push   $0x4
801034a6:	68 bd 78 10 80       	push   $0x801078bd
801034ab:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801034af:	e8 2c 14 00 00       	call   801048e0 <memcmp>
801034b4:	83 c4 10             	add    $0x10,%esp
801034b7:	85 c0                	test   %eax,%eax
801034b9:	0f 85 01 01 00 00    	jne    801035c0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801034bf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801034c6:	3c 01                	cmp    $0x1,%al
801034c8:	74 08                	je     801034d2 <mpinit+0x92>
801034ca:	3c 04                	cmp    $0x4,%al
801034cc:	0f 85 ee 00 00 00    	jne    801035c0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801034d2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034d9:	66 85 d2             	test   %dx,%dx
801034dc:	74 22                	je     80103500 <mpinit+0xc0>
801034de:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034e1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034e3:	31 d2                	xor    %edx,%edx
801034e5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034e8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034ef:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034f2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034f4:	39 c7                	cmp    %eax,%edi
801034f6:	75 f0                	jne    801034e8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034f8:	84 d2                	test   %dl,%dl
801034fa:	0f 85 c0 00 00 00    	jne    801035c0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103500:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103506:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010350b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103512:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103518:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010351d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103520:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103527:	90                   	nop
80103528:	39 d0                	cmp    %edx,%eax
8010352a:	73 15                	jae    80103541 <mpinit+0x101>
    switch(*p){
8010352c:	0f b6 08             	movzbl (%eax),%ecx
8010352f:	80 f9 02             	cmp    $0x2,%cl
80103532:	74 4c                	je     80103580 <mpinit+0x140>
80103534:	77 3a                	ja     80103570 <mpinit+0x130>
80103536:	84 c9                	test   %cl,%cl
80103538:	74 56                	je     80103590 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010353a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010353d:	39 d0                	cmp    %edx,%eax
8010353f:	72 eb                	jb     8010352c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103541:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103544:	85 f6                	test   %esi,%esi
80103546:	0f 84 d9 00 00 00    	je     80103625 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010354c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103550:	74 15                	je     80103567 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103552:	b8 70 00 00 00       	mov    $0x70,%eax
80103557:	ba 22 00 00 00       	mov    $0x22,%edx
8010355c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010355d:	ba 23 00 00 00       	mov    $0x23,%edx
80103562:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103563:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103566:	ee                   	out    %al,(%dx)
  }
}
80103567:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010356a:	5b                   	pop    %ebx
8010356b:	5e                   	pop    %esi
8010356c:	5f                   	pop    %edi
8010356d:	5d                   	pop    %ebp
8010356e:	c3                   	ret    
8010356f:	90                   	nop
    switch(*p){
80103570:	83 e9 03             	sub    $0x3,%ecx
80103573:	80 f9 01             	cmp    $0x1,%cl
80103576:	76 c2                	jbe    8010353a <mpinit+0xfa>
80103578:	31 f6                	xor    %esi,%esi
8010357a:	eb ac                	jmp    80103528 <mpinit+0xe8>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103580:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103584:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103587:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010358d:	eb 99                	jmp    80103528 <mpinit+0xe8>
8010358f:	90                   	nop
      if(ncpu < NCPU) {
80103590:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103596:	83 f9 07             	cmp    $0x7,%ecx
80103599:	7f 19                	jg     801035b4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010359b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801035a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801035a5:	83 c1 01             	add    $0x1,%ecx
801035a8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035ae:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801035b4:	83 c0 14             	add    $0x14,%eax
      continue;
801035b7:	e9 6c ff ff ff       	jmp    80103528 <mpinit+0xe8>
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	68 c2 78 10 80       	push   $0x801078c2
801035c8:	e8 b3 cd ff ff       	call   80100380 <panic>
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
{
801035d0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035d5:	eb 13                	jmp    801035ea <mpinit+0x1aa>
801035d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035de:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035e0:	89 f3                	mov    %esi,%ebx
801035e2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035e8:	74 d6                	je     801035c0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ea:	83 ec 04             	sub    $0x4,%esp
801035ed:	8d 73 10             	lea    0x10(%ebx),%esi
801035f0:	6a 04                	push   $0x4
801035f2:	68 b8 78 10 80       	push   $0x801078b8
801035f7:	53                   	push   %ebx
801035f8:	e8 e3 12 00 00       	call   801048e0 <memcmp>
801035fd:	83 c4 10             	add    $0x10,%esp
80103600:	85 c0                	test   %eax,%eax
80103602:	75 dc                	jne    801035e0 <mpinit+0x1a0>
80103604:	89 da                	mov    %ebx,%edx
80103606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010360d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103610:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103613:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103616:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103618:	39 d6                	cmp    %edx,%esi
8010361a:	75 f4                	jne    80103610 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010361c:	84 c0                	test   %al,%al
8010361e:	75 c0                	jne    801035e0 <mpinit+0x1a0>
80103620:	e9 6b fe ff ff       	jmp    80103490 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103625:	83 ec 0c             	sub    $0xc,%esp
80103628:	68 dc 78 10 80       	push   $0x801078dc
8010362d:	e8 4e cd ff ff       	call   80100380 <panic>
80103632:	66 90                	xchg   %ax,%ax
80103634:	66 90                	xchg   %ax,%ax
80103636:	66 90                	xchg   %ax,%ax
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <picinit>:
80103640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103645:	ba 21 00 00 00       	mov    $0x21,%edx
8010364a:	ee                   	out    %al,(%dx)
8010364b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103650:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103651:	c3                   	ret    
80103652:	66 90                	xchg   %ax,%ax
80103654:	66 90                	xchg   %ax,%ax
80103656:	66 90                	xchg   %ax,%ax
80103658:	66 90                	xchg   %ax,%ax
8010365a:	66 90                	xchg   %ax,%ax
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 0c             	sub    $0xc,%esp
80103669:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010366c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010366f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103675:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010367b:	e8 e0 d9 ff ff       	call   80101060 <filealloc>
80103680:	89 03                	mov    %eax,(%ebx)
80103682:	85 c0                	test   %eax,%eax
80103684:	0f 84 a8 00 00 00    	je     80103732 <pipealloc+0xd2>
8010368a:	e8 d1 d9 ff ff       	call   80101060 <filealloc>
8010368f:	89 06                	mov    %eax,(%esi)
80103691:	85 c0                	test   %eax,%eax
80103693:	0f 84 87 00 00 00    	je     80103720 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103699:	e8 12 f2 ff ff       	call   801028b0 <kalloc>
8010369e:	89 c7                	mov    %eax,%edi
801036a0:	85 c0                	test   %eax,%eax
801036a2:	0f 84 b0 00 00 00    	je     80103758 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801036a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801036b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801036b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036bc:	00 00 00 
  p->nwrite = 0;
801036bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036c6:	00 00 00 
  p->nread = 0;
801036c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036d0:	00 00 00 
  initlock(&p->lock, "pipe");
801036d3:	68 fb 78 10 80       	push   $0x801078fb
801036d8:	50                   	push   %eax
801036d9:	e8 22 0f 00 00       	call   80104600 <initlock>
  (*f0)->type = FD_PIPE;
801036de:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036e9:	8b 03                	mov    (%ebx),%eax
801036eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036ef:	8b 03                	mov    (%ebx),%eax
801036f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036f5:	8b 03                	mov    (%ebx),%eax
801036f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036fa:	8b 06                	mov    (%esi),%eax
801036fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103702:	8b 06                	mov    (%esi),%eax
80103704:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103708:	8b 06                	mov    (%esi),%eax
8010370a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010370e:	8b 06                	mov    (%esi),%eax
80103710:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103716:	31 c0                	xor    %eax,%eax
}
80103718:	5b                   	pop    %ebx
80103719:	5e                   	pop    %esi
8010371a:	5f                   	pop    %edi
8010371b:	5d                   	pop    %ebp
8010371c:	c3                   	ret    
8010371d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103720:	8b 03                	mov    (%ebx),%eax
80103722:	85 c0                	test   %eax,%eax
80103724:	74 1e                	je     80103744 <pipealloc+0xe4>
    fileclose(*f0);
80103726:	83 ec 0c             	sub    $0xc,%esp
80103729:	50                   	push   %eax
8010372a:	e8 f1 d9 ff ff       	call   80101120 <fileclose>
8010372f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103732:	8b 06                	mov    (%esi),%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	74 0c                	je     80103744 <pipealloc+0xe4>
    fileclose(*f1);
80103738:	83 ec 0c             	sub    $0xc,%esp
8010373b:	50                   	push   %eax
8010373c:	e8 df d9 ff ff       	call   80101120 <fileclose>
80103741:	83 c4 10             	add    $0x10,%esp
}
80103744:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010374c:	5b                   	pop    %ebx
8010374d:	5e                   	pop    %esi
8010374e:	5f                   	pop    %edi
8010374f:	5d                   	pop    %ebp
80103750:	c3                   	ret    
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103758:	8b 03                	mov    (%ebx),%eax
8010375a:	85 c0                	test   %eax,%eax
8010375c:	75 c8                	jne    80103726 <pipealloc+0xc6>
8010375e:	eb d2                	jmp    80103732 <pipealloc+0xd2>

80103760 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
80103765:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103768:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010376b:	83 ec 0c             	sub    $0xc,%esp
8010376e:	53                   	push   %ebx
8010376f:	e8 5c 10 00 00       	call   801047d0 <acquire>
  if(writable){
80103774:	83 c4 10             	add    $0x10,%esp
80103777:	85 f6                	test   %esi,%esi
80103779:	74 65                	je     801037e0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010377b:	83 ec 0c             	sub    $0xc,%esp
8010377e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103784:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010378b:	00 00 00 
    wakeup(&p->nread);
8010378e:	50                   	push   %eax
8010378f:	e8 9c 0b 00 00       	call   80104330 <wakeup>
80103794:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103797:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010379d:	85 d2                	test   %edx,%edx
8010379f:	75 0a                	jne    801037ab <pipeclose+0x4b>
801037a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037a7:	85 c0                	test   %eax,%eax
801037a9:	74 15                	je     801037c0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801037ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b1:	5b                   	pop    %ebx
801037b2:	5e                   	pop    %esi
801037b3:	5d                   	pop    %ebp
    release(&p->lock);
801037b4:	e9 b7 0f 00 00       	jmp    80104770 <release>
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	53                   	push   %ebx
801037c4:	e8 a7 0f 00 00       	call   80104770 <release>
    kfree((char*)p);
801037c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037cc:	83 c4 10             	add    $0x10,%esp
}
801037cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037d2:	5b                   	pop    %ebx
801037d3:	5e                   	pop    %esi
801037d4:	5d                   	pop    %ebp
    kfree((char*)p);
801037d5:	e9 16 ef ff ff       	jmp    801026f0 <kfree>
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037f0:	00 00 00 
    wakeup(&p->nwrite);
801037f3:	50                   	push   %eax
801037f4:	e8 37 0b 00 00       	call   80104330 <wakeup>
801037f9:	83 c4 10             	add    $0x10,%esp
801037fc:	eb 99                	jmp    80103797 <pipeclose+0x37>
801037fe:	66 90                	xchg   %ax,%ax

80103800 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
80103805:	53                   	push   %ebx
80103806:	83 ec 28             	sub    $0x28,%esp
80103809:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010380c:	53                   	push   %ebx
8010380d:	e8 be 0f 00 00       	call   801047d0 <acquire>
  for(i = 0; i < n; i++){
80103812:	8b 45 10             	mov    0x10(%ebp),%eax
80103815:	83 c4 10             	add    $0x10,%esp
80103818:	85 c0                	test   %eax,%eax
8010381a:	0f 8e c0 00 00 00    	jle    801038e0 <pipewrite+0xe0>
80103820:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103823:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103829:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010382f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103832:	03 45 10             	add    0x10(%ebp),%eax
80103835:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103838:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010383e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103844:	89 ca                	mov    %ecx,%edx
80103846:	05 00 02 00 00       	add    $0x200,%eax
8010384b:	39 c1                	cmp    %eax,%ecx
8010384d:	74 3f                	je     8010388e <pipewrite+0x8e>
8010384f:	eb 67                	jmp    801038b8 <pipewrite+0xb8>
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103858:	e8 43 03 00 00       	call   80103ba0 <myproc>
8010385d:	8b 48 24             	mov    0x24(%eax),%ecx
80103860:	85 c9                	test   %ecx,%ecx
80103862:	75 34                	jne    80103898 <pipewrite+0x98>
      wakeup(&p->nread);
80103864:	83 ec 0c             	sub    $0xc,%esp
80103867:	57                   	push   %edi
80103868:	e8 c3 0a 00 00       	call   80104330 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010386d:	58                   	pop    %eax
8010386e:	5a                   	pop    %edx
8010386f:	53                   	push   %ebx
80103870:	56                   	push   %esi
80103871:	e8 fa 09 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103876:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010387c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103882:	83 c4 10             	add    $0x10,%esp
80103885:	05 00 02 00 00       	add    $0x200,%eax
8010388a:	39 c2                	cmp    %eax,%edx
8010388c:	75 2a                	jne    801038b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010388e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103894:	85 c0                	test   %eax,%eax
80103896:	75 c0                	jne    80103858 <pipewrite+0x58>
        release(&p->lock);
80103898:	83 ec 0c             	sub    $0xc,%esp
8010389b:	53                   	push   %ebx
8010389c:	e8 cf 0e 00 00       	call   80104770 <release>
        return -1;
801038a1:	83 c4 10             	add    $0x10,%esp
801038a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038ac:	5b                   	pop    %ebx
801038ad:	5e                   	pop    %esi
801038ae:	5f                   	pop    %edi
801038af:	5d                   	pop    %ebp
801038b0:	c3                   	ret    
801038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801038bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801038be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801038ca:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801038cd:	83 c6 01             	add    $0x1,%esi
801038d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038da:	0f 85 58 ff ff ff    	jne    80103838 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038e9:	50                   	push   %eax
801038ea:	e8 41 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801038ef:	89 1c 24             	mov    %ebx,(%esp)
801038f2:	e8 79 0e 00 00       	call   80104770 <release>
  return n;
801038f7:	8b 45 10             	mov    0x10(%ebp),%eax
801038fa:	83 c4 10             	add    $0x10,%esp
801038fd:	eb aa                	jmp    801038a9 <pipewrite+0xa9>
801038ff:	90                   	nop

80103900 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 18             	sub    $0x18,%esp
80103909:	8b 75 08             	mov    0x8(%ebp),%esi
8010390c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010390f:	56                   	push   %esi
80103910:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103916:	e8 b5 0e 00 00       	call   801047d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010391b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103921:	83 c4 10             	add    $0x10,%esp
80103924:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010392a:	74 2f                	je     8010395b <piperead+0x5b>
8010392c:	eb 37                	jmp    80103965 <piperead+0x65>
8010392e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103930:	e8 6b 02 00 00       	call   80103ba0 <myproc>
80103935:	8b 48 24             	mov    0x24(%eax),%ecx
80103938:	85 c9                	test   %ecx,%ecx
8010393a:	0f 85 80 00 00 00    	jne    801039c0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103940:	83 ec 08             	sub    $0x8,%esp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
80103945:	e8 26 09 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010394a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103950:	83 c4 10             	add    $0x10,%esp
80103953:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103959:	75 0a                	jne    80103965 <piperead+0x65>
8010395b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103961:	85 c0                	test   %eax,%eax
80103963:	75 cb                	jne    80103930 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103965:	8b 55 10             	mov    0x10(%ebp),%edx
80103968:	31 db                	xor    %ebx,%ebx
8010396a:	85 d2                	test   %edx,%edx
8010396c:	7f 20                	jg     8010398e <piperead+0x8e>
8010396e:	eb 2c                	jmp    8010399c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103970:	8d 48 01             	lea    0x1(%eax),%ecx
80103973:	25 ff 01 00 00       	and    $0x1ff,%eax
80103978:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010397e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103983:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103986:	83 c3 01             	add    $0x1,%ebx
80103989:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010398c:	74 0e                	je     8010399c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010398e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103994:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010399a:	75 d4                	jne    80103970 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010399c:	83 ec 0c             	sub    $0xc,%esp
8010399f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801039a5:	50                   	push   %eax
801039a6:	e8 85 09 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801039ab:	89 34 24             	mov    %esi,(%esp)
801039ae:	e8 bd 0d 00 00       	call   80104770 <release>
  return i;
801039b3:	83 c4 10             	add    $0x10,%esp
}
801039b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b9:	89 d8                	mov    %ebx,%eax
801039bb:	5b                   	pop    %ebx
801039bc:	5e                   	pop    %esi
801039bd:	5f                   	pop    %edi
801039be:	5d                   	pop    %ebp
801039bf:	c3                   	ret    
      release(&p->lock);
801039c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039c8:	56                   	push   %esi
801039c9:	e8 a2 0d 00 00       	call   80104770 <release>
      return -1;
801039ce:	83 c4 10             	add    $0x10,%esp
}
801039d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d4:	89 d8                	mov    %ebx,%eax
801039d6:	5b                   	pop    %ebx
801039d7:	5e                   	pop    %esi
801039d8:	5f                   	pop    %edi
801039d9:	5d                   	pop    %ebp
801039da:	c3                   	ret    
801039db:	66 90                	xchg   %ax,%ax
801039dd:	66 90                	xchg   %ax,%ax
801039df:	90                   	nop

801039e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039e4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801039e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ec:	68 20 1d 11 80       	push   $0x80111d20
801039f1:	e8 da 0d 00 00       	call   801047d0 <acquire>
801039f6:	83 c4 10             	add    $0x10,%esp
801039f9:	eb 10                	jmp    80103a0b <allocproc+0x2b>
801039fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a00:	83 c3 7c             	add    $0x7c,%ebx
80103a03:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103a09:	74 75                	je     80103a80 <allocproc+0xa0>
    if(p->state == UNUSED)
80103a0b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a0e:	85 c0                	test   %eax,%eax
80103a10:	75 ee                	jne    80103a00 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a12:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103a17:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a1a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a21:	89 43 10             	mov    %eax,0x10(%ebx)
80103a24:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103a27:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103a2c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103a32:	e8 39 0d 00 00       	call   80104770 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a37:	e8 74 ee ff ff       	call   801028b0 <kalloc>
80103a3c:	83 c4 10             	add    $0x10,%esp
80103a3f:	89 43 08             	mov    %eax,0x8(%ebx)
80103a42:	85 c0                	test   %eax,%eax
80103a44:	74 53                	je     80103a99 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a46:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a4c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a4f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a54:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a57:	c7 40 14 82 5a 10 80 	movl   $0x80105a82,0x14(%eax)
  p->context = (struct context*)sp;
80103a5e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a61:	6a 14                	push   $0x14
80103a63:	6a 00                	push   $0x0
80103a65:	50                   	push   %eax
80103a66:	e8 25 0e 00 00       	call   80104890 <memset>
  p->context->eip = (uint)forkret;
80103a6b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a6e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a71:	c7 40 10 b0 3a 10 80 	movl   $0x80103ab0,0x10(%eax)
}
80103a78:	89 d8                	mov    %ebx,%eax
80103a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7d:	c9                   	leave  
80103a7e:	c3                   	ret    
80103a7f:	90                   	nop
  release(&ptable.lock);
80103a80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a85:	68 20 1d 11 80       	push   $0x80111d20
80103a8a:	e8 e1 0c 00 00       	call   80104770 <release>
}
80103a8f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a91:	83 c4 10             	add    $0x10,%esp
}
80103a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a97:	c9                   	leave  
80103a98:	c3                   	ret    
    p->state = UNUSED;
80103a99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103aa0:	31 db                	xor    %ebx,%ebx
}
80103aa2:	89 d8                	mov    %ebx,%eax
80103aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aa7:	c9                   	leave  
80103aa8:	c3                   	ret    
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ab0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ab6:	68 20 1d 11 80       	push   $0x80111d20
80103abb:	e8 b0 0c 00 00       	call   80104770 <release>

  if (first) {
80103ac0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	85 c0                	test   %eax,%eax
80103aca:	75 04                	jne    80103ad0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103acc:	c9                   	leave  
80103acd:	c3                   	ret    
80103ace:	66 90                	xchg   %ax,%ax
    first = 0;
80103ad0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103ad7:	00 00 00 
    iinit(ROOTDEV);
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	6a 01                	push   $0x1
80103adf:	e8 ac dc ff ff       	call   80101790 <iinit>
    initlog(ROOTDEV);
80103ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aeb:	e8 00 f4 ff ff       	call   80102ef0 <initlog>
}
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	c9                   	leave  
80103af4:	c3                   	ret    
80103af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b00 <pinit>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b06:	68 00 79 10 80       	push   $0x80107900
80103b0b:	68 20 1d 11 80       	push   $0x80111d20
80103b10:	e8 eb 0a 00 00       	call   80104600 <initlock>
}
80103b15:	83 c4 10             	add    $0x10,%esp
80103b18:	c9                   	leave  
80103b19:	c3                   	ret    
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <mycpu>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
80103b24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b25:	9c                   	pushf  
80103b26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b27:	f6 c4 02             	test   $0x2,%ah
80103b2a:	75 46                	jne    80103b72 <mycpu+0x52>
  apicid = lapicid();
80103b2c:	e8 ef ef ff ff       	call   80102b20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b31:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103b37:	85 f6                	test   %esi,%esi
80103b39:	7e 2a                	jle    80103b65 <mycpu+0x45>
80103b3b:	31 d2                	xor    %edx,%edx
80103b3d:	eb 08                	jmp    80103b47 <mycpu+0x27>
80103b3f:	90                   	nop
80103b40:	83 c2 01             	add    $0x1,%edx
80103b43:	39 f2                	cmp    %esi,%edx
80103b45:	74 1e                	je     80103b65 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b47:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b4d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103b54:	39 c3                	cmp    %eax,%ebx
80103b56:	75 e8                	jne    80103b40 <mycpu+0x20>
}
80103b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b5b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103b61:	5b                   	pop    %ebx
80103b62:	5e                   	pop    %esi
80103b63:	5d                   	pop    %ebp
80103b64:	c3                   	ret    
  panic("unknown apicid\n");
80103b65:	83 ec 0c             	sub    $0xc,%esp
80103b68:	68 07 79 10 80       	push   $0x80107907
80103b6d:	e8 0e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b72:	83 ec 0c             	sub    $0xc,%esp
80103b75:	68 e4 79 10 80       	push   $0x801079e4
80103b7a:	e8 01 c8 ff ff       	call   80100380 <panic>
80103b7f:	90                   	nop

80103b80 <cpuid>:
cpuid() {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b86:	e8 95 ff ff ff       	call   80103b20 <mycpu>
}
80103b8b:	c9                   	leave  
  return mycpu()-cpus;
80103b8c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103b91:	c1 f8 04             	sar    $0x4,%eax
80103b94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b9a:	c3                   	ret    
80103b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <myproc>:
myproc(void) {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ba7:	e8 d4 0a 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103bac:	e8 6f ff ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103bb1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb7:	e8 14 0b 00 00       	call   801046d0 <popcli>
}
80103bbc:	89 d8                	mov    %ebx,%eax
80103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc1:	c9                   	leave  
80103bc2:	c3                   	ret    
80103bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bd0 <userinit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bd7:	e8 04 fe ff ff       	call   801039e0 <allocproc>
80103bdc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bde:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103be3:	e8 88 34 00 00       	call   80107070 <setupkvm>
80103be8:	89 43 04             	mov    %eax,0x4(%ebx)
80103beb:	85 c0                	test   %eax,%eax
80103bed:	0f 84 bd 00 00 00    	je     80103cb0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bf3:	83 ec 04             	sub    $0x4,%esp
80103bf6:	68 2c 00 00 00       	push   $0x2c
80103bfb:	68 60 a4 10 80       	push   $0x8010a460
80103c00:	50                   	push   %eax
80103c01:	e8 1a 31 00 00       	call   80106d20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c0f:	6a 4c                	push   $0x4c
80103c11:	6a 00                	push   $0x0
80103c13:	ff 73 18             	push   0x18(%ebx)
80103c16:	e8 75 0c 00 00       	call   80104890 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c36:	8b 43 18             	mov    0x18(%ebx),%eax
80103c39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c41:	8b 43 18             	mov    0x18(%ebx),%eax
80103c44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c56:	8b 43 18             	mov    0x18(%ebx),%eax
80103c59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c60:	8b 43 18             	mov    0x18(%ebx),%eax
80103c63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	68 30 79 10 80       	push   $0x80107930
80103c74:	50                   	push   %eax
80103c75:	e8 d6 0d 00 00       	call   80104a50 <safestrcpy>
  p->cwd = namei("/");
80103c7a:	c7 04 24 39 79 10 80 	movl   $0x80107939,(%esp)
80103c81:	e8 4a e6 ff ff       	call   801022d0 <namei>
80103c86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c89:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c90:	e8 3b 0b 00 00       	call   801047d0 <acquire>
  p->state = RUNNABLE;
80103c95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c9c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ca3:	e8 c8 0a 00 00       	call   80104770 <release>
}
80103ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	c9                   	leave  
80103caf:	c3                   	ret    
    panic("userinit: out of memory?");
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	68 17 79 10 80       	push   $0x80107917
80103cb8:	e8 c3 c6 ff ff       	call   80100380 <panic>
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi

80103cc0 <growproc>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cc8:	e8 b3 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103ccd:	e8 4e fe ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103cd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd8:	e8 f3 09 00 00       	call   801046d0 <popcli>
  sz = curproc->sz;
80103cdd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cdf:	85 f6                	test   %esi,%esi
80103ce1:	7f 1d                	jg     80103d00 <growproc+0x40>
  } else if(n < 0){
80103ce3:	75 3b                	jne    80103d20 <growproc+0x60>
  switchuvm(curproc);
80103ce5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ce8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cea:	53                   	push   %ebx
80103ceb:	e8 20 2f 00 00       	call   80106c10 <switchuvm>
  return 0;
80103cf0:	83 c4 10             	add    $0x10,%esp
80103cf3:	31 c0                	xor    %eax,%eax
}
80103cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf8:	5b                   	pop    %ebx
80103cf9:	5e                   	pop    %esi
80103cfa:	5d                   	pop    %ebp
80103cfb:	c3                   	ret    
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	push   0x4(%ebx)
80103d0a:	e8 81 31 00 00       	call   80106e90 <allocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 cf                	jne    80103ce5 <growproc+0x25>
      return -1;
80103d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1b:	eb d8                	jmp    80103cf5 <growproc+0x35>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	push   0x4(%ebx)
80103d2a:	e8 91 32 00 00       	call   80106fc0 <deallocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 af                	jne    80103ce5 <growproc+0x25>
80103d36:	eb de                	jmp    80103d16 <growproc+0x56>
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <fork>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d49:	e8 32 09 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103d4e:	e8 cd fd ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103d53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d59:	e8 72 09 00 00       	call   801046d0 <popcli>
  if((np = allocproc()) == 0){
80103d5e:	e8 7d fc ff ff       	call   801039e0 <allocproc>
80103d63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d66:	85 c0                	test   %eax,%eax
80103d68:	0f 84 b7 00 00 00    	je     80103e25 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d6e:	83 ec 08             	sub    $0x8,%esp
80103d71:	ff 33                	push   (%ebx)
80103d73:	89 c7                	mov    %eax,%edi
80103d75:	ff 73 04             	push   0x4(%ebx)
80103d78:	e8 e3 33 00 00       	call   80107160 <copyuvm>
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	89 47 04             	mov    %eax,0x4(%edi)
80103d83:	85 c0                	test   %eax,%eax
80103d85:	0f 84 a1 00 00 00    	je     80103e2c <fork+0xec>
  np->sz = curproc->sz;
80103d8b:	8b 03                	mov    (%ebx),%eax
80103d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d90:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d92:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d95:	89 c8                	mov    %ecx,%eax
80103d97:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d9a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d9f:	8b 73 18             	mov    0x18(%ebx),%esi
80103da2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103da4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103da6:	8b 40 18             	mov    0x18(%eax),%eax
80103da9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103db0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103db4:	85 c0                	test   %eax,%eax
80103db6:	74 13                	je     80103dcb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	50                   	push   %eax
80103dbc:	e8 0f d3 ff ff       	call   801010d0 <filedup>
80103dc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dc4:	83 c4 10             	add    $0x10,%esp
80103dc7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dcb:	83 c6 01             	add    $0x1,%esi
80103dce:	83 fe 10             	cmp    $0x10,%esi
80103dd1:	75 dd                	jne    80103db0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dd9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103ddc:	e8 9f db ff ff       	call   80101980 <idup>
80103de1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103de7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dea:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ded:	6a 10                	push   $0x10
80103def:	53                   	push   %ebx
80103df0:	50                   	push   %eax
80103df1:	e8 5a 0c 00 00       	call   80104a50 <safestrcpy>
  pid = np->pid;
80103df6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103df9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e00:	e8 cb 09 00 00       	call   801047d0 <acquire>
  np->state = RUNNABLE;
80103e05:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e0c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e13:	e8 58 09 00 00       	call   80104770 <release>
  return pid;
80103e18:	83 c4 10             	add    $0x10,%esp
}
80103e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e1e:	89 d8                	mov    %ebx,%eax
80103e20:	5b                   	pop    %ebx
80103e21:	5e                   	pop    %esi
80103e22:	5f                   	pop    %edi
80103e23:	5d                   	pop    %ebp
80103e24:	c3                   	ret    
    return -1;
80103e25:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e2a:	eb ef                	jmp    80103e1b <fork+0xdb>
    kfree(np->kstack);
80103e2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e2f:	83 ec 0c             	sub    $0xc,%esp
80103e32:	ff 73 08             	push   0x8(%ebx)
80103e35:	e8 b6 e8 ff ff       	call   801026f0 <kfree>
    np->kstack = 0;
80103e3a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e41:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e44:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e4b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e50:	eb c9                	jmp    80103e1b <fork+0xdb>
80103e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <scheduler>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e69:	e8 b2 fc ff ff       	call   80103b20 <mycpu>
  c->proc = 0;
80103e6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e75:	00 00 00 
  struct cpu *c = mycpu();
80103e78:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e7a:	8d 78 04             	lea    0x4(%eax),%edi
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e80:	fb                   	sti    
    acquire(&ptable.lock);
80103e81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e84:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103e89:	68 20 1d 11 80       	push   $0x80111d20
80103e8e:	e8 3d 09 00 00       	call   801047d0 <acquire>
80103e93:	83 c4 10             	add    $0x10,%esp
80103e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103ea0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ea4:	75 33                	jne    80103ed9 <scheduler+0x79>
      switchuvm(p);
80103ea6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ea9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103eaf:	53                   	push   %ebx
80103eb0:	e8 5b 2d 00 00       	call   80106c10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103eb5:	58                   	pop    %eax
80103eb6:	5a                   	pop    %edx
80103eb7:	ff 73 1c             	push   0x1c(%ebx)
80103eba:	57                   	push   %edi
      p->state = RUNNING;
80103ebb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ec2:	e8 e4 0b 00 00       	call   80104aab <swtch>
      switchkvm();
80103ec7:	e8 34 2d 00 00       	call   80106c00 <switchkvm>
      c->proc = 0;
80103ecc:	83 c4 10             	add    $0x10,%esp
80103ecf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ed6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed9:	83 c3 7c             	add    $0x7c,%ebx
80103edc:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103ee2:	75 bc                	jne    80103ea0 <scheduler+0x40>
    release(&ptable.lock);
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	68 20 1d 11 80       	push   $0x80111d20
80103eec:	e8 7f 08 00 00       	call   80104770 <release>
    sti();
80103ef1:	83 c4 10             	add    $0x10,%esp
80103ef4:	eb 8a                	jmp    80103e80 <scheduler+0x20>
80103ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi

80103f00 <sched>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
  pushcli();
80103f05:	e8 76 07 00 00       	call   80104680 <pushcli>
  c = mycpu();
80103f0a:	e8 11 fc ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103f0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f15:	e8 b6 07 00 00       	call   801046d0 <popcli>
  if(!holding(&ptable.lock))
80103f1a:	83 ec 0c             	sub    $0xc,%esp
80103f1d:	68 20 1d 11 80       	push   $0x80111d20
80103f22:	e8 09 08 00 00       	call   80104730 <holding>
80103f27:	83 c4 10             	add    $0x10,%esp
80103f2a:	85 c0                	test   %eax,%eax
80103f2c:	74 4f                	je     80103f7d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f2e:	e8 ed fb ff ff       	call   80103b20 <mycpu>
80103f33:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f3a:	75 68                	jne    80103fa4 <sched+0xa4>
  if(p->state == RUNNING)
80103f3c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f40:	74 55                	je     80103f97 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f42:	9c                   	pushf  
80103f43:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f44:	f6 c4 02             	test   $0x2,%ah
80103f47:	75 41                	jne    80103f8a <sched+0x8a>
  intena = mycpu()->intena;
80103f49:	e8 d2 fb ff ff       	call   80103b20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f4e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f51:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f57:	e8 c4 fb ff ff       	call   80103b20 <mycpu>
80103f5c:	83 ec 08             	sub    $0x8,%esp
80103f5f:	ff 70 04             	push   0x4(%eax)
80103f62:	53                   	push   %ebx
80103f63:	e8 43 0b 00 00       	call   80104aab <swtch>
  mycpu()->intena = intena;
80103f68:	e8 b3 fb ff ff       	call   80103b20 <mycpu>
}
80103f6d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f70:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f79:	5b                   	pop    %ebx
80103f7a:	5e                   	pop    %esi
80103f7b:	5d                   	pop    %ebp
80103f7c:	c3                   	ret    
    panic("sched ptable.lock");
80103f7d:	83 ec 0c             	sub    $0xc,%esp
80103f80:	68 3b 79 10 80       	push   $0x8010793b
80103f85:	e8 f6 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 67 79 10 80       	push   $0x80107967
80103f92:	e8 e9 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f97:	83 ec 0c             	sub    $0xc,%esp
80103f9a:	68 59 79 10 80       	push   $0x80107959
80103f9f:	e8 dc c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fa4:	83 ec 0c             	sub    $0xc,%esp
80103fa7:	68 4d 79 10 80       	push   $0x8010794d
80103fac:	e8 cf c3 ff ff       	call   80100380 <panic>
80103fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop

80103fc0 <exit>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fc9:	e8 d2 fb ff ff       	call   80103ba0 <myproc>
  if(curproc == initproc)
80103fce:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103fd4:	0f 84 fd 00 00 00    	je     801040d7 <exit+0x117>
80103fda:	89 c3                	mov    %eax,%ebx
80103fdc:	8d 70 28             	lea    0x28(%eax),%esi
80103fdf:	8d 78 68             	lea    0x68(%eax),%edi
80103fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fe8:	8b 06                	mov    (%esi),%eax
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 12                	je     80104000 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fee:	83 ec 0c             	sub    $0xc,%esp
80103ff1:	50                   	push   %eax
80103ff2:	e8 29 d1 ff ff       	call   80101120 <fileclose>
      curproc->ofile[fd] = 0;
80103ff7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ffd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104000:	83 c6 04             	add    $0x4,%esi
80104003:	39 f7                	cmp    %esi,%edi
80104005:	75 e1                	jne    80103fe8 <exit+0x28>
  begin_op();
80104007:	e8 84 ef ff ff       	call   80102f90 <begin_op>
  iput(curproc->cwd);
8010400c:	83 ec 0c             	sub    $0xc,%esp
8010400f:	ff 73 68             	push   0x68(%ebx)
80104012:	e8 c9 da ff ff       	call   80101ae0 <iput>
  end_op();
80104017:	e8 e4 ef ff ff       	call   80103000 <end_op>
  curproc->cwd = 0;
8010401c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104023:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010402a:	e8 a1 07 00 00       	call   801047d0 <acquire>
  wakeup1(curproc->parent);
8010402f:	8b 53 14             	mov    0x14(%ebx),%edx
80104032:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104035:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010403a:	eb 0e                	jmp    8010404a <exit+0x8a>
8010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104040:	83 c0 7c             	add    $0x7c,%eax
80104043:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104048:	74 1c                	je     80104066 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010404a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010404e:	75 f0                	jne    80104040 <exit+0x80>
80104050:	3b 50 20             	cmp    0x20(%eax),%edx
80104053:	75 eb                	jne    80104040 <exit+0x80>
      p->state = RUNNABLE;
80104055:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010405c:	83 c0 7c             	add    $0x7c,%eax
8010405f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104064:	75 e4                	jne    8010404a <exit+0x8a>
      p->parent = initproc;
80104066:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80104071:	eb 10                	jmp    80104083 <exit+0xc3>
80104073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104077:	90                   	nop
80104078:	83 c2 7c             	add    $0x7c,%edx
8010407b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80104081:	74 3b                	je     801040be <exit+0xfe>
    if(p->parent == curproc){
80104083:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104086:	75 f0                	jne    80104078 <exit+0xb8>
      if(p->state == ZOMBIE)
80104088:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010408c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010408f:	75 e7                	jne    80104078 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104091:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104096:	eb 12                	jmp    801040aa <exit+0xea>
80104098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
801040a0:	83 c0 7c             	add    $0x7c,%eax
801040a3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801040a8:	74 ce                	je     80104078 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801040aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ae:	75 f0                	jne    801040a0 <exit+0xe0>
801040b0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040b3:	75 eb                	jne    801040a0 <exit+0xe0>
      p->state = RUNNABLE;
801040b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040bc:	eb e2                	jmp    801040a0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040be:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040c5:	e8 36 fe ff ff       	call   80103f00 <sched>
  panic("zombie exit");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 88 79 10 80       	push   $0x80107988
801040d2:	e8 a9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 7b 79 10 80       	push   $0x8010797b
801040df:	e8 9c c2 ff ff       	call   80100380 <panic>
801040e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop

801040f0 <wait>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
  pushcli();
801040f5:	e8 86 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
801040fa:	e8 21 fa ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801040ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104105:	e8 c6 05 00 00       	call   801046d0 <popcli>
  acquire(&ptable.lock);
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 20 1d 11 80       	push   $0x80111d20
80104112:	e8 b9 06 00 00       	call   801047d0 <acquire>
80104117:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104121:	eb 10                	jmp    80104133 <wait+0x43>
80104123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104127:	90                   	nop
80104128:	83 c3 7c             	add    $0x7c,%ebx
8010412b:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80104131:	74 1b                	je     8010414e <wait+0x5e>
      if(p->parent != curproc)
80104133:	39 73 14             	cmp    %esi,0x14(%ebx)
80104136:	75 f0                	jne    80104128 <wait+0x38>
      if(p->state == ZOMBIE){
80104138:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010413c:	74 62                	je     801041a0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104141:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104146:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010414c:	75 e5                	jne    80104133 <wait+0x43>
    if(!havekids || curproc->killed){
8010414e:	85 c0                	test   %eax,%eax
80104150:	0f 84 a0 00 00 00    	je     801041f6 <wait+0x106>
80104156:	8b 46 24             	mov    0x24(%esi),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	0f 85 95 00 00 00    	jne    801041f6 <wait+0x106>
  pushcli();
80104161:	e8 1a 05 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104166:	e8 b5 f9 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 5a 05 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104176:	85 db                	test   %ebx,%ebx
80104178:	0f 84 8f 00 00 00    	je     8010420d <wait+0x11d>
  p->chan = chan;
8010417e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104181:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104188:	e8 73 fd ff ff       	call   80103f00 <sched>
  p->chan = 0;
8010418d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104194:	eb 84                	jmp    8010411a <wait+0x2a>
80104196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801041a0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041a3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041a6:	ff 73 08             	push   0x8(%ebx)
801041a9:	e8 42 e5 ff ff       	call   801026f0 <kfree>
        p->kstack = 0;
801041ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041b5:	5a                   	pop    %edx
801041b6:	ff 73 04             	push   0x4(%ebx)
801041b9:	e8 32 2e 00 00       	call   80106ff0 <freevm>
        p->pid = 0;
801041be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041c5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041cc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041d0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041de:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041e5:	e8 86 05 00 00       	call   80104770 <release>
        return pid;
801041ea:	83 c4 10             	add    $0x10,%esp
}
801041ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041f0:	89 f0                	mov    %esi,%eax
801041f2:	5b                   	pop    %ebx
801041f3:	5e                   	pop    %esi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret    
      release(&ptable.lock);
801041f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041fe:	68 20 1d 11 80       	push   $0x80111d20
80104203:	e8 68 05 00 00       	call   80104770 <release>
      return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	eb e0                	jmp    801041ed <wait+0xfd>
    panic("sleep");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 94 79 10 80       	push   $0x80107994
80104215:	e8 66 c1 ff ff       	call   80100380 <panic>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <yield>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104227:	68 20 1d 11 80       	push   $0x80111d20
8010422c:	e8 9f 05 00 00       	call   801047d0 <acquire>
  pushcli();
80104231:	e8 4a 04 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104236:	e8 e5 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010423b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104241:	e8 8a 04 00 00       	call   801046d0 <popcli>
  myproc()->state = RUNNABLE;
80104246:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010424d:	e8 ae fc ff ff       	call   80103f00 <sched>
  release(&ptable.lock);
80104252:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104259:	e8 12 05 00 00       	call   80104770 <release>
}
8010425e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	c9                   	leave  
80104265:	c3                   	ret    
80104266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426d:	8d 76 00             	lea    0x0(%esi),%esi

80104270 <sleep>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010427c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010427f:	e8 fc 03 00 00       	call   80104680 <pushcli>
  c = mycpu();
80104284:	e8 97 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104289:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010428f:	e8 3c 04 00 00       	call   801046d0 <popcli>
  if(p == 0)
80104294:	85 db                	test   %ebx,%ebx
80104296:	0f 84 87 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
8010429c:	85 f6                	test   %esi,%esi
8010429e:	74 76                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801042a6:	74 50                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 20 1d 11 80       	push   $0x80111d20
801042b0:	e8 1b 05 00 00       	call   801047d0 <acquire>
    release(lk);
801042b5:	89 34 24             	mov    %esi,(%esp)
801042b8:	e8 b3 04 00 00       	call   80104770 <release>
  p->chan = chan;
801042bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042c7:	e8 34 fc ff ff       	call   80103f00 <sched>
  p->chan = 0;
801042cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042d3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801042da:	e8 91 04 00 00       	call   80104770 <release>
    acquire(lk);
801042df:	89 75 08             	mov    %esi,0x8(%ebp)
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e8:	5b                   	pop    %ebx
801042e9:	5e                   	pop    %esi
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
    acquire(lk);
801042ec:	e9 df 04 00 00       	jmp    801047d0 <acquire>
801042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104302:	e8 f9 fb ff ff       	call   80103f00 <sched>
  p->chan = 0;
80104307:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 9a 79 10 80       	push   $0x8010799a
8010431e:	e8 5d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 94 79 10 80       	push   $0x80107994
8010432b:	e8 50 c0 ff ff       	call   80100380 <panic>

80104330 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433a:	68 20 1d 11 80       	push   $0x80111d20
8010433f:	e8 8c 04 00 00       	call   801047d0 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104347:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010434c:	eb 0c                	jmp    8010435a <wakeup+0x2a>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	83 c0 7c             	add    $0x7c,%eax
80104353:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104358:	74 1c                	je     80104376 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010435a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010435e:	75 f0                	jne    80104350 <wakeup+0x20>
80104360:	3b 58 20             	cmp    0x20(%eax),%ebx
80104363:	75 eb                	jne    80104350 <wakeup+0x20>
      p->state = RUNNABLE;
80104365:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436c:	83 c0 7c             	add    $0x7c,%eax
8010436f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104374:	75 e4                	jne    8010435a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104376:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010437d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104380:	c9                   	leave  
  release(&ptable.lock);
80104381:	e9 ea 03 00 00       	jmp    80104770 <release>
80104386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439a:	68 20 1d 11 80       	push   $0x80111d20
8010439f:	e8 2c 04 00 00       	call   801047d0 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801043ac:	eb 0c                	jmp    801043ba <kill+0x2a>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 c0 7c             	add    $0x7c,%eax
801043b3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801043b8:	74 36                	je     801043f0 <kill+0x60>
    if(p->pid == pid){
801043ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801043bd:	75 f1                	jne    801043b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ca:	75 07                	jne    801043d3 <kill+0x43>
        p->state = RUNNABLE;
801043cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 20 1d 11 80       	push   $0x80111d20
801043db:	e8 90 03 00 00       	call   80104770 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043e3:	83 c4 10             	add    $0x10,%esp
801043e6:	31 c0                	xor    %eax,%eax
}
801043e8:	c9                   	leave  
801043e9:	c3                   	ret    
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 20 1d 11 80       	push   $0x80111d20
801043f8:	e8 73 03 00 00       	call   80104770 <release>
}
801043fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104408:	c9                   	leave  
80104409:	c3                   	ret    
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104418:	53                   	push   %ebx
80104419:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010441e:	83 ec 3c             	sub    $0x3c,%esp
80104421:	eb 24                	jmp    80104447 <procdump+0x37>
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 17 7d 10 80       	push   $0x80107d17
80104430:	e8 7b c3 ff ff       	call   801007b0 <cprintf>
80104435:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104438:	83 c3 7c             	add    $0x7c,%ebx
8010443b:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104441:	0f 84 81 00 00 00    	je     801044c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104447:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 ea                	je     80104438 <procdump+0x28>
      state = "???";
8010444e:	ba ab 79 10 80       	mov    $0x801079ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104453:	83 f8 05             	cmp    $0x5,%eax
80104456:	77 11                	ja     80104469 <procdump+0x59>
80104458:	8b 14 85 0c 7a 10 80 	mov    -0x7fef85f4(,%eax,4),%edx
      state = "???";
8010445f:	b8 ab 79 10 80       	mov    $0x801079ab,%eax
80104464:	85 d2                	test   %edx,%edx
80104466:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104469:	53                   	push   %ebx
8010446a:	52                   	push   %edx
8010446b:	ff 73 a4             	push   -0x5c(%ebx)
8010446e:	68 af 79 10 80       	push   $0x801079af
80104473:	e8 38 c3 ff ff       	call   801007b0 <cprintf>
    if(p->state == SLEEPING){
80104478:	83 c4 10             	add    $0x10,%esp
8010447b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010447f:	75 a7                	jne    80104428 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104481:	83 ec 08             	sub    $0x8,%esp
80104484:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104487:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010448a:	50                   	push   %eax
8010448b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010448e:	8b 40 0c             	mov    0xc(%eax),%eax
80104491:	83 c0 08             	add    $0x8,%eax
80104494:	50                   	push   %eax
80104495:	e8 86 01 00 00       	call   80104620 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010449a:	83 c4 10             	add    $0x10,%esp
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	8b 17                	mov    (%edi),%edx
801044a2:	85 d2                	test   %edx,%edx
801044a4:	74 82                	je     80104428 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044ac:	52                   	push   %edx
801044ad:	68 01 74 10 80       	push   $0x80107401
801044b2:	e8 f9 c2 ff ff       	call   801007b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	39 fe                	cmp    %edi,%esi
801044bc:	75 e2                	jne    801044a0 <procdump+0x90>
801044be:	e9 65 ff ff ff       	jmp    80104428 <procdump+0x18>
801044c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c7:	90                   	nop
  }
}
801044c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cb:	5b                   	pop    %ebx
801044cc:	5e                   	pop    %esi
801044cd:	5f                   	pop    %edi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret    

801044d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 0c             	sub    $0xc,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044da:	68 24 7a 10 80       	push   $0x80107a24
801044df:	8d 43 04             	lea    0x4(%ebx),%eax
801044e2:	50                   	push   %eax
801044e3:	e8 18 01 00 00       	call   80104600 <initlock>
  lk->name = name;
801044e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104501:	c9                   	leave  
80104502:	c3                   	ret    
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104518:	8d 73 04             	lea    0x4(%ebx),%esi
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	56                   	push   %esi
8010451f:	e8 ac 02 00 00       	call   801047d0 <acquire>
  while (lk->locked) {
80104524:	8b 13                	mov    (%ebx),%edx
80104526:	83 c4 10             	add    $0x10,%esp
80104529:	85 d2                	test   %edx,%edx
8010452b:	74 16                	je     80104543 <acquiresleep+0x33>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104530:	83 ec 08             	sub    $0x8,%esp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	e8 36 fd ff ff       	call   80104270 <sleep>
  while (lk->locked) {
8010453a:	8b 03                	mov    (%ebx),%eax
8010453c:	83 c4 10             	add    $0x10,%esp
8010453f:	85 c0                	test   %eax,%eax
80104541:	75 ed                	jne    80104530 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104543:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104549:	e8 52 f6 ff ff       	call   80103ba0 <myproc>
8010454e:	8b 40 10             	mov    0x10(%eax),%eax
80104551:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104554:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104557:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010455a:	5b                   	pop    %ebx
8010455b:	5e                   	pop    %esi
8010455c:	5d                   	pop    %ebp
  release(&lk->lk);
8010455d:	e9 0e 02 00 00       	jmp    80104770 <release>
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104570 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104578:	8d 73 04             	lea    0x4(%ebx),%esi
8010457b:	83 ec 0c             	sub    $0xc,%esp
8010457e:	56                   	push   %esi
8010457f:	e8 4c 02 00 00       	call   801047d0 <acquire>
  lk->locked = 0;
80104584:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010458a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104591:	89 1c 24             	mov    %ebx,(%esp)
80104594:	e8 97 fd ff ff       	call   80104330 <wakeup>
  release(&lk->lk);
80104599:	89 75 08             	mov    %esi,0x8(%ebp)
8010459c:	83 c4 10             	add    $0x10,%esp
}
8010459f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a2:	5b                   	pop    %ebx
801045a3:	5e                   	pop    %esi
801045a4:	5d                   	pop    %ebp
  release(&lk->lk);
801045a5:	e9 c6 01 00 00       	jmp    80104770 <release>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	31 ff                	xor    %edi,%edi
801045b6:	56                   	push   %esi
801045b7:	53                   	push   %ebx
801045b8:	83 ec 18             	sub    $0x18,%esp
801045bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045be:	8d 73 04             	lea    0x4(%ebx),%esi
801045c1:	56                   	push   %esi
801045c2:	e8 09 02 00 00       	call   801047d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045c7:	8b 03                	mov    (%ebx),%eax
801045c9:	83 c4 10             	add    $0x10,%esp
801045cc:	85 c0                	test   %eax,%eax
801045ce:	75 18                	jne    801045e8 <holdingsleep+0x38>
  release(&lk->lk);
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	56                   	push   %esi
801045d4:	e8 97 01 00 00       	call   80104770 <release>
  return r;
}
801045d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045dc:	89 f8                	mov    %edi,%eax
801045de:	5b                   	pop    %ebx
801045df:	5e                   	pop    %esi
801045e0:	5f                   	pop    %edi
801045e1:	5d                   	pop    %ebp
801045e2:	c3                   	ret    
801045e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045eb:	e8 b0 f5 ff ff       	call   80103ba0 <myproc>
801045f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045f3:	0f 94 c0             	sete   %al
801045f6:	0f b6 c0             	movzbl %al,%eax
801045f9:	89 c7                	mov    %eax,%edi
801045fb:	eb d3                	jmp    801045d0 <holdingsleep+0x20>
801045fd:	66 90                	xchg   %ax,%ax
801045ff:	90                   	nop

80104600 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104606:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010460f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret    
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop

80104620 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104620:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104621:	31 d2                	xor    %edx,%edx
{
80104623:	89 e5                	mov    %esp,%ebp
80104625:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104626:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010462c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010462f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104630:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 58 04             	mov    0x4(%eax),%ebx
80104641:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104644:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104647:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104649:	83 fa 0a             	cmp    $0xa,%edx
8010464c:	75 e2                	jne    80104630 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave  
80104652:	c3                   	ret    
80104653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104657:	90                   	nop
  for(; i < 10; i++)
80104658:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010465b:	8d 51 28             	lea    0x28(%ecx),%edx
8010465e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 d0                	cmp    %edx,%eax
8010466b:	75 f3                	jne    80104660 <getcallerpcs+0x40>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 04             	sub    $0x4,%esp
80104687:	9c                   	pushf  
80104688:	5b                   	pop    %ebx
  asm volatile("cli");
80104689:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010468a:	e8 91 f4 ff ff       	call   80103b20 <mycpu>
8010468f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104695:	85 c0                	test   %eax,%eax
80104697:	74 17                	je     801046b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104699:	e8 82 f4 ff ff       	call   80103b20 <mycpu>
8010469e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a8:	c9                   	leave  
801046a9:	c3                   	ret    
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801046b0:	e8 6b f4 ff ff       	call   80103b20 <mycpu>
801046b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046c1:	eb d6                	jmp    80104699 <pushcli+0x19>
801046c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <popcli>:

void
popcli(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046d6:	9c                   	pushf  
801046d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046d8:	f6 c4 02             	test   $0x2,%ah
801046db:	75 35                	jne    80104712 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046dd:	e8 3e f4 ff ff       	call   80103b20 <mycpu>
801046e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046e9:	78 34                	js     8010471f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046eb:	e8 30 f4 ff ff       	call   80103b20 <mycpu>
801046f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046f6:	85 d2                	test   %edx,%edx
801046f8:	74 06                	je     80104700 <popcli+0x30>
    sti();
}
801046fa:	c9                   	leave  
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104700:	e8 1b f4 ff ff       	call   80103b20 <mycpu>
80104705:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010470b:	85 c0                	test   %eax,%eax
8010470d:	74 eb                	je     801046fa <popcli+0x2a>
  asm volatile("sti");
8010470f:	fb                   	sti    
}
80104710:	c9                   	leave  
80104711:	c3                   	ret    
    panic("popcli - interruptible");
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	68 2f 7a 10 80       	push   $0x80107a2f
8010471a:	e8 61 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010471f:	83 ec 0c             	sub    $0xc,%esp
80104722:	68 46 7a 10 80       	push   $0x80107a46
80104727:	e8 54 bc ff ff       	call   80100380 <panic>
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <holding>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 75 08             	mov    0x8(%ebp),%esi
80104738:	31 db                	xor    %ebx,%ebx
  pushcli();
8010473a:	e8 41 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010473f:	8b 06                	mov    (%esi),%eax
80104741:	85 c0                	test   %eax,%eax
80104743:	75 0b                	jne    80104750 <holding+0x20>
  popcli();
80104745:	e8 86 ff ff ff       	call   801046d0 <popcli>
}
8010474a:	89 d8                	mov    %ebx,%eax
8010474c:	5b                   	pop    %ebx
8010474d:	5e                   	pop    %esi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104750:	8b 5e 08             	mov    0x8(%esi),%ebx
80104753:	e8 c8 f3 ff ff       	call   80103b20 <mycpu>
80104758:	39 c3                	cmp    %eax,%ebx
8010475a:	0f 94 c3             	sete   %bl
  popcli();
8010475d:	e8 6e ff ff ff       	call   801046d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104762:	0f b6 db             	movzbl %bl,%ebx
}
80104765:	89 d8                	mov    %ebx,%eax
80104767:	5b                   	pop    %ebx
80104768:	5e                   	pop    %esi
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret    
8010476b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop

80104770 <release>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104778:	e8 03 ff ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010477d:	8b 03                	mov    (%ebx),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 15                	jne    80104798 <release+0x28>
  popcli();
80104783:	e8 48 ff ff ff       	call   801046d0 <popcli>
    panic("release");
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	68 4d 7a 10 80       	push   $0x80107a4d
80104790:	e8 eb bb ff ff       	call   80100380 <panic>
80104795:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104798:	8b 73 08             	mov    0x8(%ebx),%esi
8010479b:	e8 80 f3 ff ff       	call   80103b20 <mycpu>
801047a0:	39 c6                	cmp    %eax,%esi
801047a2:	75 df                	jne    80104783 <release+0x13>
  popcli();
801047a4:	e8 27 ff ff ff       	call   801046d0 <popcli>
  lk->pcs[0] = 0;
801047a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c5:	5b                   	pop    %ebx
801047c6:	5e                   	pop    %esi
801047c7:	5d                   	pop    %ebp
  popcli();
801047c8:	e9 03 ff ff ff       	jmp    801046d0 <popcli>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <acquire>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047d7:	e8 a4 fe ff ff       	call   80104680 <pushcli>
  if(holding(lk))
801047dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047df:	e8 9c fe ff ff       	call   80104680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047e4:	8b 03                	mov    (%ebx),%eax
801047e6:	85 c0                	test   %eax,%eax
801047e8:	75 7e                	jne    80104868 <acquire+0x98>
  popcli();
801047ea:	e8 e1 fe ff ff       	call   801046d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047f8:	8b 55 08             	mov    0x8(%ebp),%edx
801047fb:	89 c8                	mov    %ecx,%eax
801047fd:	f0 87 02             	lock xchg %eax,(%edx)
80104800:	85 c0                	test   %eax,%eax
80104802:	75 f4                	jne    801047f8 <acquire+0x28>
  __sync_synchronize();
80104804:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104809:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010480c:	e8 0f f3 ff ff       	call   80103b20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104814:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104816:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104819:	31 c0                	xor    %eax,%eax
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104820:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104826:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010482c:	77 1a                	ja     80104848 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010482e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104831:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104835:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104838:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010483a:	83 f8 0a             	cmp    $0xa,%eax
8010483d:	75 e1                	jne    80104820 <acquire+0x50>
}
8010483f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104842:	c9                   	leave  
80104843:	c3                   	ret    
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104848:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010484c:	8d 51 34             	lea    0x34(%ecx),%edx
8010484f:	90                   	nop
    pcs[i] = 0;
80104850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104856:	83 c0 04             	add    $0x4,%eax
80104859:	39 c2                	cmp    %eax,%edx
8010485b:	75 f3                	jne    80104850 <acquire+0x80>
}
8010485d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104860:	c9                   	leave  
80104861:	c3                   	ret    
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104868:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010486b:	e8 b0 f2 ff ff       	call   80103b20 <mycpu>
80104870:	39 c3                	cmp    %eax,%ebx
80104872:	0f 85 72 ff ff ff    	jne    801047ea <acquire+0x1a>
  popcli();
80104878:	e8 53 fe ff ff       	call   801046d0 <popcli>
    panic("acquire");
8010487d:	83 ec 0c             	sub    $0xc,%esp
80104880:	68 55 7a 10 80       	push   $0x80107a55
80104885:	e8 f6 ba ff ff       	call   80100380 <panic>
8010488a:	66 90                	xchg   %ax,%ax
8010488c:	66 90                	xchg   %ax,%ax
8010488e:	66 90                	xchg   %ax,%ax

80104890 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	8b 55 08             	mov    0x8(%ebp),%edx
80104897:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010489a:	53                   	push   %ebx
8010489b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010489e:	89 d7                	mov    %edx,%edi
801048a0:	09 cf                	or     %ecx,%edi
801048a2:	83 e7 03             	and    $0x3,%edi
801048a5:	75 29                	jne    801048d0 <memset+0x40>
    c &= 0xFF;
801048a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048aa:	c1 e0 18             	shl    $0x18,%eax
801048ad:	89 fb                	mov    %edi,%ebx
801048af:	c1 e9 02             	shr    $0x2,%ecx
801048b2:	c1 e3 10             	shl    $0x10,%ebx
801048b5:	09 d8                	or     %ebx,%eax
801048b7:	09 f8                	or     %edi,%eax
801048b9:	c1 e7 08             	shl    $0x8,%edi
801048bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048be:	89 d7                	mov    %edx,%edi
801048c0:	fc                   	cld    
801048c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048c3:	5b                   	pop    %ebx
801048c4:	89 d0                	mov    %edx,%eax
801048c6:	5f                   	pop    %edi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret    
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048d0:	89 d7                	mov    %edx,%edi
801048d2:	fc                   	cld    
801048d3:	f3 aa                	rep stos %al,%es:(%edi)
801048d5:	5b                   	pop    %ebx
801048d6:	89 d0                	mov    %edx,%eax
801048d8:	5f                   	pop    %edi
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop

801048e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	8b 75 10             	mov    0x10(%ebp),%esi
801048e7:	8b 55 08             	mov    0x8(%ebp),%edx
801048ea:	53                   	push   %ebx
801048eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ee:	85 f6                	test   %esi,%esi
801048f0:	74 2e                	je     80104920 <memcmp+0x40>
801048f2:	01 c6                	add    %eax,%esi
801048f4:	eb 14                	jmp    8010490a <memcmp+0x2a>
801048f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104900:	83 c0 01             	add    $0x1,%eax
80104903:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104906:	39 f0                	cmp    %esi,%eax
80104908:	74 16                	je     80104920 <memcmp+0x40>
    if(*s1 != *s2)
8010490a:	0f b6 0a             	movzbl (%edx),%ecx
8010490d:	0f b6 18             	movzbl (%eax),%ebx
80104910:	38 d9                	cmp    %bl,%cl
80104912:	74 ec                	je     80104900 <memcmp+0x20>
      return *s1 - *s2;
80104914:	0f b6 c1             	movzbl %cl,%eax
80104917:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104919:	5b                   	pop    %ebx
8010491a:	5e                   	pop    %esi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
80104920:	5b                   	pop    %ebx
  return 0;
80104921:	31 c0                	xor    %eax,%eax
}
80104923:	5e                   	pop    %esi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	8b 55 08             	mov    0x8(%ebp),%edx
80104937:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010493a:	56                   	push   %esi
8010493b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010493e:	39 d6                	cmp    %edx,%esi
80104940:	73 26                	jae    80104968 <memmove+0x38>
80104942:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104945:	39 fa                	cmp    %edi,%edx
80104947:	73 1f                	jae    80104968 <memmove+0x38>
80104949:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010494c:	85 c9                	test   %ecx,%ecx
8010494e:	74 0c                	je     8010495c <memmove+0x2c>
      *--d = *--s;
80104950:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104954:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104957:	83 e8 01             	sub    $0x1,%eax
8010495a:	73 f4                	jae    80104950 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010495c:	5e                   	pop    %esi
8010495d:	89 d0                	mov    %edx,%eax
8010495f:	5f                   	pop    %edi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104968:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010496b:	89 d7                	mov    %edx,%edi
8010496d:	85 c9                	test   %ecx,%ecx
8010496f:	74 eb                	je     8010495c <memmove+0x2c>
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104978:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104979:	39 c6                	cmp    %eax,%esi
8010497b:	75 fb                	jne    80104978 <memmove+0x48>
}
8010497d:	5e                   	pop    %esi
8010497e:	89 d0                	mov    %edx,%eax
80104980:	5f                   	pop    %edi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret    
80104983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104990:	eb 9e                	jmp    80104930 <memmove>
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	8b 75 10             	mov    0x10(%ebp),%esi
801049a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049aa:	53                   	push   %ebx
801049ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801049ae:	85 f6                	test   %esi,%esi
801049b0:	74 2e                	je     801049e0 <strncmp+0x40>
801049b2:	01 d6                	add    %edx,%esi
801049b4:	eb 18                	jmp    801049ce <strncmp+0x2e>
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	38 d8                	cmp    %bl,%al
801049c2:	75 14                	jne    801049d8 <strncmp+0x38>
    n--, p++, q++;
801049c4:	83 c2 01             	add    $0x1,%edx
801049c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049ca:	39 f2                	cmp    %esi,%edx
801049cc:	74 12                	je     801049e0 <strncmp+0x40>
801049ce:	0f b6 01             	movzbl (%ecx),%eax
801049d1:	0f b6 1a             	movzbl (%edx),%ebx
801049d4:	84 c0                	test   %al,%al
801049d6:	75 e8                	jne    801049c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049d8:	29 d8                	sub    %ebx,%eax
}
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax
801049e0:	5b                   	pop    %ebx
    return 0;
801049e1:	31 c0                	xor    %eax,%eax
}
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret    
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi

801049f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	8b 75 08             	mov    0x8(%ebp),%esi
801049f8:	53                   	push   %ebx
801049f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049fc:	89 f0                	mov    %esi,%eax
801049fe:	eb 15                	jmp    80104a15 <strncpy+0x25>
80104a00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a04:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a07:	83 c0 01             	add    $0x1,%eax
80104a0a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a0e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104a11:	84 d2                	test   %dl,%dl
80104a13:	74 09                	je     80104a1e <strncpy+0x2e>
80104a15:	89 cb                	mov    %ecx,%ebx
80104a17:	83 e9 01             	sub    $0x1,%ecx
80104a1a:	85 db                	test   %ebx,%ebx
80104a1c:	7f e2                	jg     80104a00 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a1e:	89 c2                	mov    %eax,%edx
80104a20:	85 c9                	test   %ecx,%ecx
80104a22:	7e 17                	jle    80104a3b <strncpy+0x4b>
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a28:	83 c2 01             	add    $0x1,%edx
80104a2b:	89 c1                	mov    %eax,%ecx
80104a2d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104a31:	29 d1                	sub    %edx,%ecx
80104a33:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a37:	85 c9                	test   %ecx,%ecx
80104a39:	7f ed                	jg     80104a28 <strncpy+0x38>
  return os;
}
80104a3b:	5b                   	pop    %ebx
80104a3c:	89 f0                	mov    %esi,%eax
80104a3e:	5e                   	pop    %esi
80104a3f:	5f                   	pop    %edi
80104a40:	5d                   	pop    %ebp
80104a41:	c3                   	ret    
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	8b 55 10             	mov    0x10(%ebp),%edx
80104a57:	8b 75 08             	mov    0x8(%ebp),%esi
80104a5a:	53                   	push   %ebx
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a5e:	85 d2                	test   %edx,%edx
80104a60:	7e 25                	jle    80104a87 <safestrcpy+0x37>
80104a62:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a66:	89 f2                	mov    %esi,%edx
80104a68:	eb 16                	jmp    80104a80 <safestrcpy+0x30>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a70:	0f b6 08             	movzbl (%eax),%ecx
80104a73:	83 c0 01             	add    $0x1,%eax
80104a76:	83 c2 01             	add    $0x1,%edx
80104a79:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a7c:	84 c9                	test   %cl,%cl
80104a7e:	74 04                	je     80104a84 <safestrcpy+0x34>
80104a80:	39 d8                	cmp    %ebx,%eax
80104a82:	75 ec                	jne    80104a70 <safestrcpy+0x20>
    ;
  *s = 0;
80104a84:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a87:	89 f0                	mov    %esi,%eax
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <strlen>:

int
strlen(const char *s)
{
80104a90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a91:	31 c0                	xor    %eax,%eax
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a98:	80 3a 00             	cmpb   $0x0,(%edx)
80104a9b:	74 0c                	je     80104aa9 <strlen+0x19>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104aa7:	75 f7                	jne    80104aa0 <strlen+0x10>
    ;
  return n;
}
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    

80104aab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aaf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ab3:	55                   	push   %ebp
  pushl %ebx
80104ab4:	53                   	push   %ebx
  pushl %esi
80104ab5:	56                   	push   %esi
  pushl %edi
80104ab6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ab7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ab9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104abb:	5f                   	pop    %edi
  popl %esi
80104abc:	5e                   	pop    %esi
  popl %ebx
80104abd:	5b                   	pop    %ebx
  popl %ebp
80104abe:	5d                   	pop    %ebp
  ret
80104abf:	c3                   	ret    

80104ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aca:	e8 d1 f0 ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104acf:	8b 00                	mov    (%eax),%eax
80104ad1:	39 d8                	cmp    %ebx,%eax
80104ad3:	76 1b                	jbe    80104af0 <fetchint+0x30>
80104ad5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ad8:	39 d0                	cmp    %edx,%eax
80104ada:	72 14                	jb     80104af0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104adf:	8b 13                	mov    (%ebx),%edx
80104ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae8:	c9                   	leave  
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb ee                	jmp    80104ae5 <fetchint+0x25>
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b0a:	e8 91 f0 ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz)
80104b0f:	39 18                	cmp    %ebx,(%eax)
80104b11:	76 2d                	jbe    80104b40 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b16:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b18:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b1a:	39 d3                	cmp    %edx,%ebx
80104b1c:	73 22                	jae    80104b40 <fetchstr+0x40>
80104b1e:	89 d8                	mov    %ebx,%eax
80104b20:	eb 0d                	jmp    80104b2f <fetchstr+0x2f>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b28:	83 c0 01             	add    $0x1,%eax
80104b2b:	39 c2                	cmp    %eax,%edx
80104b2d:	76 11                	jbe    80104b40 <fetchstr+0x40>
    if(*s == 0)
80104b2f:	80 38 00             	cmpb   $0x0,(%eax)
80104b32:	75 f4                	jne    80104b28 <fetchstr+0x28>
      return s - *pp;
80104b34:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b39:	c9                   	leave  
80104b3a:	c3                   	ret    
80104b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
80104b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b48:	c9                   	leave  
80104b49:	c3                   	ret    
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	e8 46 f0 ff ff       	call   80103ba0 <myproc>
80104b5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5d:	8b 40 18             	mov    0x18(%eax),%eax
80104b60:	8b 40 44             	mov    0x44(%eax),%eax
80104b63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b66:	e8 35 f0 ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6e:	8b 00                	mov    (%eax),%eax
80104b70:	39 c6                	cmp    %eax,%esi
80104b72:	73 1c                	jae    80104b90 <argint+0x40>
80104b74:	8d 53 08             	lea    0x8(%ebx),%edx
80104b77:	39 d0                	cmp    %edx,%eax
80104b79:	72 15                	jb     80104b90 <argint+0x40>
  *ip = *(int*)(addr);
80104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b81:	89 10                	mov    %edx,(%eax)
  return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5b                   	pop    %ebx
80104b86:	5e                   	pop    %esi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret    
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	eb ee                	jmp    80104b85 <argint+0x35>
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	53                   	push   %ebx
80104ba6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ba9:	e8 f2 ef ff ff       	call   80103ba0 <myproc>
80104bae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb0:	e8 eb ef ff ff       	call   80103ba0 <myproc>
80104bb5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb8:	8b 40 18             	mov    0x18(%eax),%eax
80104bbb:	8b 40 44             	mov    0x44(%eax),%eax
80104bbe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc1:	e8 da ef ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bc9:	8b 00                	mov    (%eax),%eax
80104bcb:	39 c7                	cmp    %eax,%edi
80104bcd:	73 31                	jae    80104c00 <argptr+0x60>
80104bcf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bd2:	39 c8                	cmp    %ecx,%eax
80104bd4:	72 2a                	jb     80104c00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bd6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bd9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bdc:	85 d2                	test   %edx,%edx
80104bde:	78 20                	js     80104c00 <argptr+0x60>
80104be0:	8b 16                	mov    (%esi),%edx
80104be2:	39 c2                	cmp    %eax,%edx
80104be4:	76 1a                	jbe    80104c00 <argptr+0x60>
80104be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104be9:	01 c3                	add    %eax,%ebx
80104beb:	39 da                	cmp    %ebx,%edx
80104bed:	72 11                	jb     80104c00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bf2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bf4:	31 c0                	xor    %eax,%eax
}
80104bf6:	83 c4 0c             	add    $0xc,%esp
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5f                   	pop    %edi
80104bfc:	5d                   	pop    %ebp
80104bfd:	c3                   	ret    
80104bfe:	66 90                	xchg   %ax,%ax
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ef                	jmp    80104bf6 <argptr+0x56>
80104c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 86 ef ff ff       	call   80103ba0 <myproc>
80104c1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1d:	8b 40 18             	mov    0x18(%eax),%eax
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 75 ef ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2e:	8b 00                	mov    (%eax),%eax
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 44                	jae    80104c78 <argstr+0x68>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 3d                	jb     80104c78 <argstr+0x68>
  *ip = *(int*)(addr);
80104c3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c3e:	e8 5d ef ff ff       	call   80103ba0 <myproc>
  if(addr >= curproc->sz)
80104c43:	3b 18                	cmp    (%eax),%ebx
80104c45:	73 31                	jae    80104c78 <argstr+0x68>
  *pp = (char*)addr;
80104c47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c4e:	39 d3                	cmp    %edx,%ebx
80104c50:	73 26                	jae    80104c78 <argstr+0x68>
80104c52:	89 d8                	mov    %ebx,%eax
80104c54:	eb 11                	jmp    80104c67 <argstr+0x57>
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	39 c2                	cmp    %eax,%edx
80104c65:	76 11                	jbe    80104c78 <argstr+0x68>
    if(*s == 0)
80104c67:	80 38 00             	cmpb   $0x0,(%eax)
80104c6a:	75 f4                	jne    80104c60 <argstr+0x50>
      return s - *pp;
80104c6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c6e:	5b                   	pop    %ebx
80104c6f:	5e                   	pop    %esi
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret    
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c78:	5b                   	pop    %ebx
    return -1;
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c7e:	5e                   	pop    %esi
80104c7f:	5d                   	pop    %ebp
80104c80:	c3                   	ret    
80104c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop

80104c90 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c97:	e8 04 ef ff ff       	call   80103ba0 <myproc>
80104c9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ca1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ca7:	83 fa 14             	cmp    $0x14,%edx
80104caa:	77 24                	ja     80104cd0 <syscall+0x40>
80104cac:	8b 14 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%edx
80104cb3:	85 d2                	test   %edx,%edx
80104cb5:	74 19                	je     80104cd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104cb7:	ff d2                	call   *%edx
80104cb9:	89 c2                	mov    %eax,%edx
80104cbb:	8b 43 18             	mov    0x18(%ebx),%eax
80104cbe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc4:	c9                   	leave  
80104cc5:	c3                   	ret    
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cd4:	50                   	push   %eax
80104cd5:	ff 73 10             	push   0x10(%ebx)
80104cd8:	68 5d 7a 10 80       	push   $0x80107a5d
80104cdd:	e8 ce ba ff ff       	call   801007b0 <cprintf>
    curproc->tf->eax = -1;
80104ce2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ce5:	83 c4 10             	add    $0x10,%esp
80104ce8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf2:	c9                   	leave  
80104cf3:	c3                   	ret    
80104cf4:	66 90                	xchg   %ax,%ax
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d08:	53                   	push   %ebx
80104d09:	83 ec 34             	sub    $0x34,%esp
80104d0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d12:	57                   	push   %edi
80104d13:	50                   	push   %eax
{
80104d14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d1a:	e8 d1 d5 ff ff       	call   801022f0 <nameiparent>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	85 c0                	test   %eax,%eax
80104d24:	0f 84 46 01 00 00    	je     80104e70 <create+0x170>
    return 0;
  ilock(dp);
80104d2a:	83 ec 0c             	sub    $0xc,%esp
80104d2d:	89 c3                	mov    %eax,%ebx
80104d2f:	50                   	push   %eax
80104d30:	e8 7b cc ff ff       	call   801019b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d35:	83 c4 0c             	add    $0xc,%esp
80104d38:	6a 00                	push   $0x0
80104d3a:	57                   	push   %edi
80104d3b:	53                   	push   %ebx
80104d3c:	e8 cf d1 ff ff       	call   80101f10 <dirlookup>
80104d41:	83 c4 10             	add    $0x10,%esp
80104d44:	89 c6                	mov    %eax,%esi
80104d46:	85 c0                	test   %eax,%eax
80104d48:	74 56                	je     80104da0 <create+0xa0>
    iunlockput(dp);
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	53                   	push   %ebx
80104d4e:	e8 ed ce ff ff       	call   80101c40 <iunlockput>
    ilock(ip);
80104d53:	89 34 24             	mov    %esi,(%esp)
80104d56:	e8 55 cc ff ff       	call   801019b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d5b:	83 c4 10             	add    $0x10,%esp
80104d5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d63:	75 1b                	jne    80104d80 <create+0x80>
80104d65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d6a:	75 14                	jne    80104d80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d6f:	89 f0                	mov    %esi,%eax
80104d71:	5b                   	pop    %ebx
80104d72:	5e                   	pop    %esi
80104d73:	5f                   	pop    %edi
80104d74:	5d                   	pop    %ebp
80104d75:	c3                   	ret    
80104d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d80:	83 ec 0c             	sub    $0xc,%esp
80104d83:	56                   	push   %esi
    return 0;
80104d84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d86:	e8 b5 ce ff ff       	call   80101c40 <iunlockput>
    return 0;
80104d8b:	83 c4 10             	add    $0x10,%esp
}
80104d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d91:	89 f0                	mov    %esi,%eax
80104d93:	5b                   	pop    %ebx
80104d94:	5e                   	pop    %esi
80104d95:	5f                   	pop    %edi
80104d96:	5d                   	pop    %ebp
80104d97:	c3                   	ret    
80104d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104da0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104da4:	83 ec 08             	sub    $0x8,%esp
80104da7:	50                   	push   %eax
80104da8:	ff 33                	push   (%ebx)
80104daa:	e8 91 ca ff ff       	call   80101840 <ialloc>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	89 c6                	mov    %eax,%esi
80104db4:	85 c0                	test   %eax,%eax
80104db6:	0f 84 cd 00 00 00    	je     80104e89 <create+0x189>
  ilock(ip);
80104dbc:	83 ec 0c             	sub    $0xc,%esp
80104dbf:	50                   	push   %eax
80104dc0:	e8 eb cb ff ff       	call   801019b0 <ilock>
  ip->major = major;
80104dc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104dc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dcd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104dd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104dd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dde:	89 34 24             	mov    %esi,(%esp)
80104de1:	e8 1a cb ff ff       	call   80101900 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104de6:	83 c4 10             	add    $0x10,%esp
80104de9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dee:	74 30                	je     80104e20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104df0:	83 ec 04             	sub    $0x4,%esp
80104df3:	ff 76 04             	push   0x4(%esi)
80104df6:	57                   	push   %edi
80104df7:	53                   	push   %ebx
80104df8:	e8 13 d4 ff ff       	call   80102210 <dirlink>
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	85 c0                	test   %eax,%eax
80104e02:	78 78                	js     80104e7c <create+0x17c>
  iunlockput(dp);
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	53                   	push   %ebx
80104e08:	e8 33 ce ff ff       	call   80101c40 <iunlockput>
  return ip;
80104e0d:	83 c4 10             	add    $0x10,%esp
}
80104e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e13:	89 f0                	mov    %esi,%eax
80104e15:	5b                   	pop    %ebx
80104e16:	5e                   	pop    %esi
80104e17:	5f                   	pop    %edi
80104e18:	5d                   	pop    %ebp
80104e19:	c3                   	ret    
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e28:	53                   	push   %ebx
80104e29:	e8 d2 ca ff ff       	call   80101900 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e2e:	83 c4 0c             	add    $0xc,%esp
80104e31:	ff 76 04             	push   0x4(%esi)
80104e34:	68 f4 7a 10 80       	push   $0x80107af4
80104e39:	56                   	push   %esi
80104e3a:	e8 d1 d3 ff ff       	call   80102210 <dirlink>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	78 18                	js     80104e5e <create+0x15e>
80104e46:	83 ec 04             	sub    $0x4,%esp
80104e49:	ff 73 04             	push   0x4(%ebx)
80104e4c:	68 f3 7a 10 80       	push   $0x80107af3
80104e51:	56                   	push   %esi
80104e52:	e8 b9 d3 ff ff       	call   80102210 <dirlink>
80104e57:	83 c4 10             	add    $0x10,%esp
80104e5a:	85 c0                	test   %eax,%eax
80104e5c:	79 92                	jns    80104df0 <create+0xf0>
      panic("create dots");
80104e5e:	83 ec 0c             	sub    $0xc,%esp
80104e61:	68 e7 7a 10 80       	push   $0x80107ae7
80104e66:	e8 15 b5 ff ff       	call   80100380 <panic>
80104e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e6f:	90                   	nop
}
80104e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e73:	31 f6                	xor    %esi,%esi
}
80104e75:	5b                   	pop    %ebx
80104e76:	89 f0                	mov    %esi,%eax
80104e78:	5e                   	pop    %esi
80104e79:	5f                   	pop    %edi
80104e7a:	5d                   	pop    %ebp
80104e7b:	c3                   	ret    
    panic("create: dirlink");
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	68 f6 7a 10 80       	push   $0x80107af6
80104e84:	e8 f7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e89:	83 ec 0c             	sub    $0xc,%esp
80104e8c:	68 d8 7a 10 80       	push   $0x80107ad8
80104e91:	e8 ea b4 ff ff       	call   80100380 <panic>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <sys_dup>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ea5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ea8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eab:	50                   	push   %eax
80104eac:	6a 00                	push   $0x0
80104eae:	e8 9d fc ff ff       	call   80104b50 <argint>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 36                	js     80104ef0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ebe:	77 30                	ja     80104ef0 <sys_dup+0x50>
80104ec0:	e8 db ec ff ff       	call   80103ba0 <myproc>
80104ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ecc:	85 f6                	test   %esi,%esi
80104ece:	74 20                	je     80104ef0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ed0:	e8 cb ec ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ed5:	31 db                	xor    %ebx,%ebx
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ee0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ee4:	85 d2                	test   %edx,%edx
80104ee6:	74 18                	je     80104f00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ee8:	83 c3 01             	add    $0x1,%ebx
80104eeb:	83 fb 10             	cmp    $0x10,%ebx
80104eee:	75 f0                	jne    80104ee0 <sys_dup+0x40>
}
80104ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ef3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ef8:	89 d8                	mov    %ebx,%eax
80104efa:	5b                   	pop    %ebx
80104efb:	5e                   	pop    %esi
80104efc:	5d                   	pop    %ebp
80104efd:	c3                   	ret    
80104efe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f03:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f07:	56                   	push   %esi
80104f08:	e8 c3 c1 ff ff       	call   801010d0 <filedup>
  return fd;
80104f0d:	83 c4 10             	add    $0x10,%esp
}
80104f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f13:	89 d8                	mov    %ebx,%eax
80104f15:	5b                   	pop    %ebx
80104f16:	5e                   	pop    %esi
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret    
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <sys_read>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 1d fc ff ff       	call   80104b50 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 5e                	js     80104f98 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 58                	ja     80104f98 <sys_read+0x78>
80104f40:	e8 5b ec ff ff       	call   80103ba0 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 48                	je     80104f98 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f50:	83 ec 08             	sub    $0x8,%esp
80104f53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f56:	50                   	push   %eax
80104f57:	6a 02                	push   $0x2
80104f59:	e8 f2 fb ff ff       	call   80104b50 <argint>
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	85 c0                	test   %eax,%eax
80104f63:	78 33                	js     80104f98 <sys_read+0x78>
80104f65:	83 ec 04             	sub    $0x4,%esp
80104f68:	ff 75 f0             	push   -0x10(%ebp)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 01                	push   $0x1
80104f6e:	e8 2d fc ff ff       	call   80104ba0 <argptr>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 1e                	js     80104f98 <sys_read+0x78>
  return fileread(f, p, n);
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	ff 75 f0             	push   -0x10(%ebp)
80104f80:	ff 75 f4             	push   -0xc(%ebp)
80104f83:	56                   	push   %esi
80104f84:	e8 c7 c2 ff ff       	call   80101250 <fileread>
80104f89:	83 c4 10             	add    $0x10,%esp
}
80104f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f97:	90                   	nop
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb ed                	jmp    80104f8c <sys_read+0x6c>
80104f9f:	90                   	nop

80104fa0 <sys_write>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 9d fb ff ff       	call   80104b50 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_write+0x78>
80104fc0:	e8 db eb ff ff       	call   80103ba0 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 72 fb ff ff       	call   80104b50 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_write+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 ad fb ff ff       	call   80104ba0 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_write+0x78>
  return filewrite(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 d7 c2 ff ff       	call   801012e0 <filewrite>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105017:	90                   	nop
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_write+0x6c>
8010501f:	90                   	nop

80105020 <sys_close>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	50                   	push   %eax
8010502c:	6a 00                	push   $0x0
8010502e:	e8 1d fb ff ff       	call   80104b50 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 3e                	js     80105078 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 38                	ja     80105078 <sys_close+0x58>
80105040:	e8 5b eb ff ff       	call   80103ba0 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8d 5a 08             	lea    0x8(%edx),%ebx
8010504b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010504f:	85 f6                	test   %esi,%esi
80105051:	74 25                	je     80105078 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105053:	e8 48 eb ff ff       	call   80103ba0 <myproc>
  fileclose(f);
80105058:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010505b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105062:	00 
  fileclose(f);
80105063:	56                   	push   %esi
80105064:	e8 b7 c0 ff ff       	call   80101120 <fileclose>
  return 0;
80105069:	83 c4 10             	add    $0x10,%esp
8010506c:	31 c0                	xor    %eax,%eax
}
8010506e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105071:	5b                   	pop    %ebx
80105072:	5e                   	pop    %esi
80105073:	5d                   	pop    %ebp
80105074:	c3                   	ret    
80105075:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb ef                	jmp    8010506e <sys_close+0x4e>
8010507f:	90                   	nop

80105080 <sys_fstat>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105085:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105088:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508b:	53                   	push   %ebx
8010508c:	6a 00                	push   $0x0
8010508e:	e8 bd fa ff ff       	call   80104b50 <argint>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 46                	js     801050e0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010509e:	77 40                	ja     801050e0 <sys_fstat+0x60>
801050a0:	e8 fb ea ff ff       	call   80103ba0 <myproc>
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ac:	85 f6                	test   %esi,%esi
801050ae:	74 30                	je     801050e0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050b0:	83 ec 04             	sub    $0x4,%esp
801050b3:	6a 14                	push   $0x14
801050b5:	53                   	push   %ebx
801050b6:	6a 01                	push   $0x1
801050b8:	e8 e3 fa ff ff       	call   80104ba0 <argptr>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	78 1c                	js     801050e0 <sys_fstat+0x60>
  return filestat(f, st);
801050c4:	83 ec 08             	sub    $0x8,%esp
801050c7:	ff 75 f4             	push   -0xc(%ebp)
801050ca:	56                   	push   %esi
801050cb:	e8 30 c1 ff ff       	call   80101200 <filestat>
801050d0:	83 c4 10             	add    $0x10,%esp
}
801050d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d6:	5b                   	pop    %ebx
801050d7:	5e                   	pop    %esi
801050d8:	5d                   	pop    %ebp
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e5:	eb ec                	jmp    801050d3 <sys_fstat+0x53>
801050e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <sys_link>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050f8:	53                   	push   %ebx
801050f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050fc:	50                   	push   %eax
801050fd:	6a 00                	push   $0x0
801050ff:	e8 0c fb ff ff       	call   80104c10 <argstr>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	0f 88 fb 00 00 00    	js     8010520a <sys_link+0x11a>
8010510f:	83 ec 08             	sub    $0x8,%esp
80105112:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105115:	50                   	push   %eax
80105116:	6a 01                	push   $0x1
80105118:	e8 f3 fa ff ff       	call   80104c10 <argstr>
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	85 c0                	test   %eax,%eax
80105122:	0f 88 e2 00 00 00    	js     8010520a <sys_link+0x11a>
  begin_op();
80105128:	e8 63 de ff ff       	call   80102f90 <begin_op>
  if((ip = namei(old)) == 0){
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	ff 75 d4             	push   -0x2c(%ebp)
80105133:	e8 98 d1 ff ff       	call   801022d0 <namei>
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	89 c3                	mov    %eax,%ebx
8010513d:	85 c0                	test   %eax,%eax
8010513f:	0f 84 e4 00 00 00    	je     80105229 <sys_link+0x139>
  ilock(ip);
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	50                   	push   %eax
80105149:	e8 62 c8 ff ff       	call   801019b0 <ilock>
  if(ip->type == T_DIR){
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105156:	0f 84 b5 00 00 00    	je     80105211 <sys_link+0x121>
  iupdate(ip);
8010515c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010515f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105164:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105167:	53                   	push   %ebx
80105168:	e8 93 c7 ff ff       	call   80101900 <iupdate>
  iunlock(ip);
8010516d:	89 1c 24             	mov    %ebx,(%esp)
80105170:	e8 1b c9 ff ff       	call   80101a90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105175:	58                   	pop    %eax
80105176:	5a                   	pop    %edx
80105177:	57                   	push   %edi
80105178:	ff 75 d0             	push   -0x30(%ebp)
8010517b:	e8 70 d1 ff ff       	call   801022f0 <nameiparent>
80105180:	83 c4 10             	add    $0x10,%esp
80105183:	89 c6                	mov    %eax,%esi
80105185:	85 c0                	test   %eax,%eax
80105187:	74 5b                	je     801051e4 <sys_link+0xf4>
  ilock(dp);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	50                   	push   %eax
8010518d:	e8 1e c8 ff ff       	call   801019b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105192:	8b 03                	mov    (%ebx),%eax
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	39 06                	cmp    %eax,(%esi)
80105199:	75 3d                	jne    801051d8 <sys_link+0xe8>
8010519b:	83 ec 04             	sub    $0x4,%esp
8010519e:	ff 73 04             	push   0x4(%ebx)
801051a1:	57                   	push   %edi
801051a2:	56                   	push   %esi
801051a3:	e8 68 d0 ff ff       	call   80102210 <dirlink>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	85 c0                	test   %eax,%eax
801051ad:	78 29                	js     801051d8 <sys_link+0xe8>
  iunlockput(dp);
801051af:	83 ec 0c             	sub    $0xc,%esp
801051b2:	56                   	push   %esi
801051b3:	e8 88 ca ff ff       	call   80101c40 <iunlockput>
  iput(ip);
801051b8:	89 1c 24             	mov    %ebx,(%esp)
801051bb:	e8 20 c9 ff ff       	call   80101ae0 <iput>
  end_op();
801051c0:	e8 3b de ff ff       	call   80103000 <end_op>
  return 0;
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	31 c0                	xor    %eax,%eax
}
801051ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051cd:	5b                   	pop    %ebx
801051ce:	5e                   	pop    %esi
801051cf:	5f                   	pop    %edi
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    
801051d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	56                   	push   %esi
801051dc:	e8 5f ca ff ff       	call   80101c40 <iunlockput>
    goto bad;
801051e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	53                   	push   %ebx
801051e8:	e8 c3 c7 ff ff       	call   801019b0 <ilock>
  ip->nlink--;
801051ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051f2:	89 1c 24             	mov    %ebx,(%esp)
801051f5:	e8 06 c7 ff ff       	call   80101900 <iupdate>
  iunlockput(ip);
801051fa:	89 1c 24             	mov    %ebx,(%esp)
801051fd:	e8 3e ca ff ff       	call   80101c40 <iunlockput>
  end_op();
80105202:	e8 f9 dd ff ff       	call   80103000 <end_op>
  return -1;
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520f:	eb b9                	jmp    801051ca <sys_link+0xda>
    iunlockput(ip);
80105211:	83 ec 0c             	sub    $0xc,%esp
80105214:	53                   	push   %ebx
80105215:	e8 26 ca ff ff       	call   80101c40 <iunlockput>
    end_op();
8010521a:	e8 e1 dd ff ff       	call   80103000 <end_op>
    return -1;
8010521f:	83 c4 10             	add    $0x10,%esp
80105222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105227:	eb a1                	jmp    801051ca <sys_link+0xda>
    end_op();
80105229:	e8 d2 dd ff ff       	call   80103000 <end_op>
    return -1;
8010522e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105233:	eb 95                	jmp    801051ca <sys_link+0xda>
80105235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105240 <sys_unlink>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105245:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105248:	53                   	push   %ebx
80105249:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010524c:	50                   	push   %eax
8010524d:	6a 00                	push   $0x0
8010524f:	e8 bc f9 ff ff       	call   80104c10 <argstr>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	0f 88 7a 01 00 00    	js     801053d9 <sys_unlink+0x199>
  begin_op();
8010525f:	e8 2c dd ff ff       	call   80102f90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105264:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105267:	83 ec 08             	sub    $0x8,%esp
8010526a:	53                   	push   %ebx
8010526b:	ff 75 c0             	push   -0x40(%ebp)
8010526e:	e8 7d d0 ff ff       	call   801022f0 <nameiparent>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105279:	85 c0                	test   %eax,%eax
8010527b:	0f 84 62 01 00 00    	je     801053e3 <sys_unlink+0x1a3>
  ilock(dp);
80105281:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105284:	83 ec 0c             	sub    $0xc,%esp
80105287:	57                   	push   %edi
80105288:	e8 23 c7 ff ff       	call   801019b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010528d:	58                   	pop    %eax
8010528e:	5a                   	pop    %edx
8010528f:	68 f4 7a 10 80       	push   $0x80107af4
80105294:	53                   	push   %ebx
80105295:	e8 56 cc ff ff       	call   80101ef0 <namecmp>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	85 c0                	test   %eax,%eax
8010529f:	0f 84 fb 00 00 00    	je     801053a0 <sys_unlink+0x160>
801052a5:	83 ec 08             	sub    $0x8,%esp
801052a8:	68 f3 7a 10 80       	push   $0x80107af3
801052ad:	53                   	push   %ebx
801052ae:	e8 3d cc ff ff       	call   80101ef0 <namecmp>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	0f 84 e2 00 00 00    	je     801053a0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052be:	83 ec 04             	sub    $0x4,%esp
801052c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052c4:	50                   	push   %eax
801052c5:	53                   	push   %ebx
801052c6:	57                   	push   %edi
801052c7:	e8 44 cc ff ff       	call   80101f10 <dirlookup>
801052cc:	83 c4 10             	add    $0x10,%esp
801052cf:	89 c3                	mov    %eax,%ebx
801052d1:	85 c0                	test   %eax,%eax
801052d3:	0f 84 c7 00 00 00    	je     801053a0 <sys_unlink+0x160>
  ilock(ip);
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	50                   	push   %eax
801052dd:	e8 ce c6 ff ff       	call   801019b0 <ilock>
  if(ip->nlink < 1)
801052e2:	83 c4 10             	add    $0x10,%esp
801052e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ea:	0f 8e 1c 01 00 00    	jle    8010540c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052f8:	74 66                	je     80105360 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052fa:	83 ec 04             	sub    $0x4,%esp
801052fd:	6a 10                	push   $0x10
801052ff:	6a 00                	push   $0x0
80105301:	57                   	push   %edi
80105302:	e8 89 f5 ff ff       	call   80104890 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105307:	6a 10                	push   $0x10
80105309:	ff 75 c4             	push   -0x3c(%ebp)
8010530c:	57                   	push   %edi
8010530d:	ff 75 b4             	push   -0x4c(%ebp)
80105310:	e8 ab ca ff ff       	call   80101dc0 <writei>
80105315:	83 c4 20             	add    $0x20,%esp
80105318:	83 f8 10             	cmp    $0x10,%eax
8010531b:	0f 85 de 00 00 00    	jne    801053ff <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105321:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105326:	0f 84 94 00 00 00    	je     801053c0 <sys_unlink+0x180>
  iunlockput(dp);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	ff 75 b4             	push   -0x4c(%ebp)
80105332:	e8 09 c9 ff ff       	call   80101c40 <iunlockput>
  ip->nlink--;
80105337:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010533c:	89 1c 24             	mov    %ebx,(%esp)
8010533f:	e8 bc c5 ff ff       	call   80101900 <iupdate>
  iunlockput(ip);
80105344:	89 1c 24             	mov    %ebx,(%esp)
80105347:	e8 f4 c8 ff ff       	call   80101c40 <iunlockput>
  end_op();
8010534c:	e8 af dc ff ff       	call   80103000 <end_op>
  return 0;
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	31 c0                	xor    %eax,%eax
}
80105356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5f                   	pop    %edi
8010535c:	5d                   	pop    %ebp
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105360:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105364:	76 94                	jbe    801052fa <sys_unlink+0xba>
80105366:	be 20 00 00 00       	mov    $0x20,%esi
8010536b:	eb 0b                	jmp    80105378 <sys_unlink+0x138>
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
80105370:	83 c6 10             	add    $0x10,%esi
80105373:	3b 73 58             	cmp    0x58(%ebx),%esi
80105376:	73 82                	jae    801052fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105378:	6a 10                	push   $0x10
8010537a:	56                   	push   %esi
8010537b:	57                   	push   %edi
8010537c:	53                   	push   %ebx
8010537d:	e8 3e c9 ff ff       	call   80101cc0 <readi>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	83 f8 10             	cmp    $0x10,%eax
80105388:	75 68                	jne    801053f2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010538a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010538f:	74 df                	je     80105370 <sys_unlink+0x130>
    iunlockput(ip);
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	53                   	push   %ebx
80105395:	e8 a6 c8 ff ff       	call   80101c40 <iunlockput>
    goto bad;
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	ff 75 b4             	push   -0x4c(%ebp)
801053a6:	e8 95 c8 ff ff       	call   80101c40 <iunlockput>
  end_op();
801053ab:	e8 50 dc ff ff       	call   80103000 <end_op>
  return -1;
801053b0:	83 c4 10             	add    $0x10,%esp
801053b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b8:	eb 9c                	jmp    80105356 <sys_unlink+0x116>
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053c3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053c6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053cb:	50                   	push   %eax
801053cc:	e8 2f c5 ff ff       	call   80101900 <iupdate>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	e9 53 ff ff ff       	jmp    8010532c <sys_unlink+0xec>
    return -1;
801053d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053de:	e9 73 ff ff ff       	jmp    80105356 <sys_unlink+0x116>
    end_op();
801053e3:	e8 18 dc ff ff       	call   80103000 <end_op>
    return -1;
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ed:	e9 64 ff ff ff       	jmp    80105356 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053f2:	83 ec 0c             	sub    $0xc,%esp
801053f5:	68 18 7b 10 80       	push   $0x80107b18
801053fa:	e8 81 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	68 2a 7b 10 80       	push   $0x80107b2a
80105407:	e8 74 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010540c:	83 ec 0c             	sub    $0xc,%esp
8010540f:	68 06 7b 10 80       	push   $0x80107b06
80105414:	e8 67 af ff ff       	call   80100380 <panic>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_open>:

int
sys_open(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105425:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105428:	53                   	push   %ebx
80105429:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010542c:	50                   	push   %eax
8010542d:	6a 00                	push   $0x0
8010542f:	e8 dc f7 ff ff       	call   80104c10 <argstr>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	0f 88 8e 00 00 00    	js     801054cd <sys_open+0xad>
8010543f:	83 ec 08             	sub    $0x8,%esp
80105442:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105445:	50                   	push   %eax
80105446:	6a 01                	push   $0x1
80105448:	e8 03 f7 ff ff       	call   80104b50 <argint>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	78 79                	js     801054cd <sys_open+0xad>
    return -1;

  begin_op();
80105454:	e8 37 db ff ff       	call   80102f90 <begin_op>

  if(omode & O_CREATE){
80105459:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010545d:	75 79                	jne    801054d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	ff 75 e0             	push   -0x20(%ebp)
80105465:	e8 66 ce ff ff       	call   801022d0 <namei>
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	89 c6                	mov    %eax,%esi
8010546f:	85 c0                	test   %eax,%eax
80105471:	0f 84 7e 00 00 00    	je     801054f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	50                   	push   %eax
8010547b:	e8 30 c5 ff ff       	call   801019b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105488:	0f 84 c2 00 00 00    	je     80105550 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010548e:	e8 cd bb ff ff       	call   80101060 <filealloc>
80105493:	89 c7                	mov    %eax,%edi
80105495:	85 c0                	test   %eax,%eax
80105497:	74 23                	je     801054bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105499:	e8 02 e7 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010549e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054a4:	85 d2                	test   %edx,%edx
801054a6:	74 60                	je     80105508 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054a8:	83 c3 01             	add    $0x1,%ebx
801054ab:	83 fb 10             	cmp    $0x10,%ebx
801054ae:	75 f0                	jne    801054a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	57                   	push   %edi
801054b4:	e8 67 bc ff ff       	call   80101120 <fileclose>
801054b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	56                   	push   %esi
801054c0:	e8 7b c7 ff ff       	call   80101c40 <iunlockput>
    end_op();
801054c5:	e8 36 db ff ff       	call   80103000 <end_op>
    return -1;
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054d2:	eb 6d                	jmp    80105541 <sys_open+0x121>
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054de:	31 c9                	xor    %ecx,%ecx
801054e0:	ba 02 00 00 00       	mov    $0x2,%edx
801054e5:	6a 00                	push   $0x0
801054e7:	e8 14 f8 ff ff       	call   80104d00 <create>
    if(ip == 0){
801054ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054f1:	85 c0                	test   %eax,%eax
801054f3:	75 99                	jne    8010548e <sys_open+0x6e>
      end_op();
801054f5:	e8 06 db ff ff       	call   80103000 <end_op>
      return -1;
801054fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054ff:	eb 40                	jmp    80105541 <sys_open+0x121>
80105501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105508:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010550b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010550f:	56                   	push   %esi
80105510:	e8 7b c5 ff ff       	call   80101a90 <iunlock>
  end_op();
80105515:	e8 e6 da ff ff       	call   80103000 <end_op>

  f->type = FD_INODE;
8010551a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105523:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105526:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105529:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010552b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105532:	f7 d0                	not    %eax
80105534:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105537:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010553a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105544:	89 d8                	mov    %ebx,%eax
80105546:	5b                   	pop    %ebx
80105547:	5e                   	pop    %esi
80105548:	5f                   	pop    %edi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105553:	85 c9                	test   %ecx,%ecx
80105555:	0f 84 33 ff ff ff    	je     8010548e <sys_open+0x6e>
8010555b:	e9 5c ff ff ff       	jmp    801054bc <sys_open+0x9c>

80105560 <sys_mkdir>:

int
sys_mkdir(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105566:	e8 25 da ff ff       	call   80102f90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105571:	50                   	push   %eax
80105572:	6a 00                	push   $0x0
80105574:	e8 97 f6 ff ff       	call   80104c10 <argstr>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	85 c0                	test   %eax,%eax
8010557e:	78 30                	js     801055b0 <sys_mkdir+0x50>
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105586:	31 c9                	xor    %ecx,%ecx
80105588:	ba 01 00 00 00       	mov    $0x1,%edx
8010558d:	6a 00                	push   $0x0
8010558f:	e8 6c f7 ff ff       	call   80104d00 <create>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	74 15                	je     801055b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	50                   	push   %eax
8010559f:	e8 9c c6 ff ff       	call   80101c40 <iunlockput>
  end_op();
801055a4:	e8 57 da ff ff       	call   80103000 <end_op>
  return 0;
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	31 c0                	xor    %eax,%eax
}
801055ae:	c9                   	leave  
801055af:	c3                   	ret    
    end_op();
801055b0:	e8 4b da ff ff       	call   80103000 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ba:	c9                   	leave  
801055bb:	c3                   	ret    
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_mknod>:

int
sys_mknod(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055c6:	e8 c5 d9 ff ff       	call   80102f90 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055cb:	83 ec 08             	sub    $0x8,%esp
801055ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055d1:	50                   	push   %eax
801055d2:	6a 00                	push   $0x0
801055d4:	e8 37 f6 ff ff       	call   80104c10 <argstr>
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	85 c0                	test   %eax,%eax
801055de:	78 60                	js     80105640 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 62 f5 ff ff       	call   80104b50 <argint>
  if((argstr(0, &path)) < 0 ||
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 4b                	js     80105640 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fb:	50                   	push   %eax
801055fc:	6a 02                	push   $0x2
801055fe:	e8 4d f5 ff ff       	call   80104b50 <argint>
     argint(1, &major) < 0 ||
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 36                	js     80105640 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010560a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010560e:	83 ec 0c             	sub    $0xc,%esp
80105611:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105615:	ba 03 00 00 00       	mov    $0x3,%edx
8010561a:	50                   	push   %eax
8010561b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010561e:	e8 dd f6 ff ff       	call   80104d00 <create>
     argint(2, &minor) < 0 ||
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	74 16                	je     80105640 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	50                   	push   %eax
8010562e:	e8 0d c6 ff ff       	call   80101c40 <iunlockput>
  end_op();
80105633:	e8 c8 d9 ff ff       	call   80103000 <end_op>
  return 0;
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	31 c0                	xor    %eax,%eax
}
8010563d:	c9                   	leave  
8010563e:	c3                   	ret    
8010563f:	90                   	nop
    end_op();
80105640:	e8 bb d9 ff ff       	call   80103000 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_chdir>:

int
sys_chdir(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
80105655:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105658:	e8 43 e5 ff ff       	call   80103ba0 <myproc>
8010565d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010565f:	e8 2c d9 ff ff       	call   80102f90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566a:	50                   	push   %eax
8010566b:	6a 00                	push   $0x0
8010566d:	e8 9e f5 ff ff       	call   80104c10 <argstr>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 77                	js     801056f0 <sys_chdir+0xa0>
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	ff 75 f4             	push   -0xc(%ebp)
8010567f:	e8 4c cc ff ff       	call   801022d0 <namei>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	89 c3                	mov    %eax,%ebx
80105689:	85 c0                	test   %eax,%eax
8010568b:	74 63                	je     801056f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	50                   	push   %eax
80105691:	e8 1a c3 ff ff       	call   801019b0 <ilock>
  if(ip->type != T_DIR){
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010569e:	75 30                	jne    801056d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 e7 c3 ff ff       	call   80101a90 <iunlock>
  iput(curproc->cwd);
801056a9:	58                   	pop    %eax
801056aa:	ff 76 68             	push   0x68(%esi)
801056ad:	e8 2e c4 ff ff       	call   80101ae0 <iput>
  end_op();
801056b2:	e8 49 d9 ff ff       	call   80103000 <end_op>
  curproc->cwd = ip;
801056b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	31 c0                	xor    %eax,%eax
}
801056bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret    
801056c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 67 c5 ff ff       	call   80101c40 <iunlockput>
    end_op();
801056d9:	e8 22 d9 ff ff       	call   80103000 <end_op>
    return -1;
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e6:	eb d7                	jmp    801056bf <sys_chdir+0x6f>
801056e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
    end_op();
801056f0:	e8 0b d9 ff ff       	call   80103000 <end_op>
    return -1;
801056f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fa:	eb c3                	jmp    801056bf <sys_chdir+0x6f>
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exec>:

int
sys_exec(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105705:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010570b:	53                   	push   %ebx
8010570c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105712:	50                   	push   %eax
80105713:	6a 00                	push   $0x0
80105715:	e8 f6 f4 ff ff       	call   80104c10 <argstr>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 88 87 00 00 00    	js     801057ac <sys_exec+0xac>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010572e:	50                   	push   %eax
8010572f:	6a 01                	push   $0x1
80105731:	e8 1a f4 ff ff       	call   80104b50 <argint>
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	85 c0                	test   %eax,%eax
8010573b:	78 6f                	js     801057ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010573d:	83 ec 04             	sub    $0x4,%esp
80105740:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105746:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105748:	68 80 00 00 00       	push   $0x80
8010574d:	6a 00                	push   $0x0
8010574f:	56                   	push   %esi
80105750:	e8 3b f1 ff ff       	call   80104890 <memset>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105769:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105770:	50                   	push   %eax
80105771:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105777:	01 f8                	add    %edi,%eax
80105779:	50                   	push   %eax
8010577a:	e8 41 f3 ff ff       	call   80104ac0 <fetchint>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	78 26                	js     801057ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105786:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010578c:	85 c0                	test   %eax,%eax
8010578e:	74 30                	je     801057c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105790:	83 ec 08             	sub    $0x8,%esp
80105793:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105796:	52                   	push   %edx
80105797:	50                   	push   %eax
80105798:	e8 63 f3 ff ff       	call   80104b00 <fetchstr>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 08                	js     801057ac <sys_exec+0xac>
  for(i=0;; i++){
801057a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057a7:	83 fb 20             	cmp    $0x20,%ebx
801057aa:	75 b4                	jne    80105760 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057c7:	00 00 00 00 
  return exec(path, argv);
801057cb:	83 ec 08             	sub    $0x8,%esp
801057ce:	56                   	push   %esi
801057cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057d5:	e8 06 b5 ff ff       	call   80100ce0 <exec>
801057da:	83 c4 10             	add    $0x10,%esp
}
801057dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e0:	5b                   	pop    %ebx
801057e1:	5e                   	pop    %esi
801057e2:	5f                   	pop    %edi
801057e3:	5d                   	pop    %ebp
801057e4:	c3                   	ret    
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_pipe>:

int
sys_pipe(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057f8:	53                   	push   %ebx
801057f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057fc:	6a 08                	push   $0x8
801057fe:	50                   	push   %eax
801057ff:	6a 00                	push   $0x0
80105801:	e8 9a f3 ff ff       	call   80104ba0 <argptr>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 4a                	js     80105857 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010580d:	83 ec 08             	sub    $0x8,%esp
80105810:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105813:	50                   	push   %eax
80105814:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105817:	50                   	push   %eax
80105818:	e8 43 de ff ff       	call   80103660 <pipealloc>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 33                	js     80105857 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105824:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105827:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105829:	e8 72 e3 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010582e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105830:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105834:	85 f6                	test   %esi,%esi
80105836:	74 28                	je     80105860 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105838:	83 c3 01             	add    $0x1,%ebx
8010583b:	83 fb 10             	cmp    $0x10,%ebx
8010583e:	75 f0                	jne    80105830 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	ff 75 e0             	push   -0x20(%ebp)
80105846:	e8 d5 b8 ff ff       	call   80101120 <fileclose>
    fileclose(wf);
8010584b:	58                   	pop    %eax
8010584c:	ff 75 e4             	push   -0x1c(%ebp)
8010584f:	e8 cc b8 ff ff       	call   80101120 <fileclose>
    return -1;
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	eb 53                	jmp    801058b1 <sys_pipe+0xc1>
8010585e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105860:	8d 73 08             	lea    0x8(%ebx),%esi
80105863:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010586a:	e8 31 e3 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010586f:	31 d2                	xor    %edx,%edx
80105871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105878:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010587c:	85 c9                	test   %ecx,%ecx
8010587e:	74 20                	je     801058a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105880:	83 c2 01             	add    $0x1,%edx
80105883:	83 fa 10             	cmp    $0x10,%edx
80105886:	75 f0                	jne    80105878 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105888:	e8 13 e3 ff ff       	call   80103ba0 <myproc>
8010588d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105894:	00 
80105895:	eb a9                	jmp    80105840 <sys_pipe+0x50>
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801058a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058af:	31 c0                	xor    %eax,%eax
}
801058b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b4:	5b                   	pop    %ebx
801058b5:	5e                   	pop    %esi
801058b6:	5f                   	pop    %edi
801058b7:	5d                   	pop    %ebp
801058b8:	c3                   	ret    
801058b9:	66 90                	xchg   %ax,%ax
801058bb:	66 90                	xchg   %ax,%ax
801058bd:	66 90                	xchg   %ax,%ax
801058bf:	90                   	nop

801058c0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058c0:	e9 7b e4 ff ff       	jmp    80103d40 <fork>
801058c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exit>:
}

int
sys_exit(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058d6:	e8 e5 e6 ff ff       	call   80103fc0 <exit>
  return 0;  // not reached
}
801058db:	31 c0                	xor    %eax,%eax
801058dd:	c9                   	leave  
801058de:	c3                   	ret    
801058df:	90                   	nop

801058e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058e0:	e9 0b e8 ff ff       	jmp    801040f0 <wait>
801058e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_kill>:
}

int
sys_kill(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f9:	50                   	push   %eax
801058fa:	6a 00                	push   $0x0
801058fc:	e8 4f f2 ff ff       	call   80104b50 <argint>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	85 c0                	test   %eax,%eax
80105906:	78 18                	js     80105920 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	ff 75 f4             	push   -0xc(%ebp)
8010590e:	e8 7d ea ff ff       	call   80104390 <kill>
80105913:	83 c4 10             	add    $0x10,%esp
}
80105916:	c9                   	leave  
80105917:	c3                   	ret    
80105918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
80105920:	c9                   	leave  
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105926:	c3                   	ret    
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_getpid>:

int
sys_getpid(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105936:	e8 65 e2 ff ff       	call   80103ba0 <myproc>
8010593b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010593e:	c9                   	leave  
8010593f:	c3                   	ret    

80105940 <sys_sbrk>:

int
sys_sbrk(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105947:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 fe f1 ff ff       	call   80104b50 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 27                	js     80105980 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105959:	e8 42 e2 ff ff       	call   80103ba0 <myproc>
  if(growproc(n) < 0)
8010595e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105961:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105963:	ff 75 f4             	push   -0xc(%ebp)
80105966:	e8 55 e3 ff ff       	call   80103cc0 <growproc>
8010596b:	83 c4 10             	add    $0x10,%esp
8010596e:	85 c0                	test   %eax,%eax
80105970:	78 0e                	js     80105980 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105972:	89 d8                	mov    %ebx,%eax
80105974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105977:	c9                   	leave  
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105980:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105985:	eb eb                	jmp    80105972 <sys_sbrk+0x32>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_sleep>:

int
sys_sleep(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105994:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105997:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010599a:	50                   	push   %eax
8010599b:	6a 00                	push   $0x0
8010599d:	e8 ae f1 ff ff       	call   80104b50 <argint>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	0f 88 8a 00 00 00    	js     80105a37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	68 80 3c 11 80       	push   $0x80113c80
801059b5:	e8 16 ee ff ff       	call   801047d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059bd:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
801059c3:	83 c4 10             	add    $0x10,%esp
801059c6:	85 d2                	test   %edx,%edx
801059c8:	75 27                	jne    801059f1 <sys_sleep+0x61>
801059ca:	eb 54                	jmp    80105a20 <sys_sleep+0x90>
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059d0:	83 ec 08             	sub    $0x8,%esp
801059d3:	68 80 3c 11 80       	push   $0x80113c80
801059d8:	68 60 3c 11 80       	push   $0x80113c60
801059dd:	e8 8e e8 ff ff       	call   80104270 <sleep>
  while(ticks - ticks0 < n){
801059e2:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	29 d8                	sub    %ebx,%eax
801059ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059ef:	73 2f                	jae    80105a20 <sys_sleep+0x90>
    if(myproc()->killed){
801059f1:	e8 aa e1 ff ff       	call   80103ba0 <myproc>
801059f6:	8b 40 24             	mov    0x24(%eax),%eax
801059f9:	85 c0                	test   %eax,%eax
801059fb:	74 d3                	je     801059d0 <sys_sleep+0x40>
      release(&tickslock);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	68 80 3c 11 80       	push   $0x80113c80
80105a05:	e8 66 ed ff ff       	call   80104770 <release>
  }
  release(&tickslock);
  return 0;
}
80105a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	68 80 3c 11 80       	push   $0x80113c80
80105a28:	e8 43 ed ff ff       	call   80104770 <release>
  return 0;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	31 c0                	xor    %eax,%eax
}
80105a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
    return -1;
80105a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3c:	eb f4                	jmp    80105a32 <sys_sleep+0xa2>
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
80105a44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a47:	68 80 3c 11 80       	push   $0x80113c80
80105a4c:	e8 7f ed ff ff       	call   801047d0 <acquire>
  xticks = ticks;
80105a51:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105a57:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105a5e:	e8 0d ed ff ff       	call   80104770 <release>
  return xticks;
}
80105a63:	89 d8                	mov    %ebx,%eax
80105a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a68:	c9                   	leave  
80105a69:	c3                   	ret    

80105a6a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a6a:	1e                   	push   %ds
  pushl %es
80105a6b:	06                   	push   %es
  pushl %fs
80105a6c:	0f a0                	push   %fs
  pushl %gs
80105a6e:	0f a8                	push   %gs
  pushal
80105a70:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a71:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a75:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a77:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a79:	54                   	push   %esp
  call trap
80105a7a:	e8 c1 00 00 00       	call   80105b40 <trap>
  addl $4, %esp
80105a7f:	83 c4 04             	add    $0x4,%esp

80105a82 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a82:	61                   	popa   
  popl %gs
80105a83:	0f a9                	pop    %gs
  popl %fs
80105a85:	0f a1                	pop    %fs
  popl %es
80105a87:	07                   	pop    %es
  popl %ds
80105a88:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a89:	83 c4 08             	add    $0x8,%esp
  iret
80105a8c:	cf                   	iret   
80105a8d:	66 90                	xchg   %ax,%ax
80105a8f:	90                   	nop

80105a90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a91:	31 c0                	xor    %eax,%eax
{
80105a93:	89 e5                	mov    %esp,%ebp
80105a95:	83 ec 08             	sub    $0x8,%esp
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105aa0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105aa7:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
80105aae:	08 00 00 8e 
80105ab2:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105ab9:	80 
80105aba:	c1 ea 10             	shr    $0x10,%edx
80105abd:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105ac4:	80 
  for(i = 0; i < 256; i++)
80105ac5:	83 c0 01             	add    $0x1,%eax
80105ac8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105acd:	75 d1                	jne    80105aa0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105acf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ad2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105ad7:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
80105ade:	00 00 ef 
  initlock(&tickslock, "time");
80105ae1:	68 39 7b 10 80       	push   $0x80107b39
80105ae6:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aeb:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105af1:	c1 e8 10             	shr    $0x10,%eax
80105af4:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105afa:	e8 01 eb ff ff       	call   80104600 <initlock>
}
80105aff:	83 c4 10             	add    $0x10,%esp
80105b02:	c9                   	leave  
80105b03:	c3                   	ret    
80105b04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop

80105b10 <idtinit>:

void
idtinit(void)
{
80105b10:	55                   	push   %ebp
  pd[0] = size-1;
80105b11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b16:	89 e5                	mov    %esp,%ebp
80105b18:	83 ec 10             	sub    $0x10,%esp
80105b1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b1f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105b24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b28:	c1 e8 10             	shr    $0x10,%eax
80105b2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
80105b46:	83 ec 1c             	sub    $0x1c,%esp
80105b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b4c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b4f:	83 f8 40             	cmp    $0x40,%eax
80105b52:	0f 84 68 01 00 00    	je     80105cc0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b58:	83 e8 20             	sub    $0x20,%eax
80105b5b:	83 f8 1f             	cmp    $0x1f,%eax
80105b5e:	0f 87 8c 00 00 00    	ja     80105bf0 <trap+0xb0>
80105b64:	ff 24 85 e0 7b 10 80 	jmp    *-0x7fef8420(,%eax,4)
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b70:	e8 fb c8 ff ff       	call   80102470 <ideintr>
    lapiceoi();
80105b75:	e8 c6 cf ff ff       	call   80102b40 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b7a:	e8 21 e0 ff ff       	call   80103ba0 <myproc>
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	74 1d                	je     80105ba0 <trap+0x60>
80105b83:	e8 18 e0 ff ff       	call   80103ba0 <myproc>
80105b88:	8b 50 24             	mov    0x24(%eax),%edx
80105b8b:	85 d2                	test   %edx,%edx
80105b8d:	74 11                	je     80105ba0 <trap+0x60>
80105b8f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b93:	83 e0 03             	and    $0x3,%eax
80105b96:	66 83 f8 03          	cmp    $0x3,%ax
80105b9a:	0f 84 e8 01 00 00    	je     80105d88 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ba0:	e8 fb df ff ff       	call   80103ba0 <myproc>
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	74 0f                	je     80105bb8 <trap+0x78>
80105ba9:	e8 f2 df ff ff       	call   80103ba0 <myproc>
80105bae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bb2:	0f 84 b8 00 00 00    	je     80105c70 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bb8:	e8 e3 df ff ff       	call   80103ba0 <myproc>
80105bbd:	85 c0                	test   %eax,%eax
80105bbf:	74 1d                	je     80105bde <trap+0x9e>
80105bc1:	e8 da df ff ff       	call   80103ba0 <myproc>
80105bc6:	8b 40 24             	mov    0x24(%eax),%eax
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	74 11                	je     80105bde <trap+0x9e>
80105bcd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bd1:	83 e0 03             	and    $0x3,%eax
80105bd4:	66 83 f8 03          	cmp    $0x3,%ax
80105bd8:	0f 84 0f 01 00 00    	je     80105ced <trap+0x1ad>
    exit();
}
80105bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be1:	5b                   	pop    %ebx
80105be2:	5e                   	pop    %esi
80105be3:	5f                   	pop    %edi
80105be4:	5d                   	pop    %ebp
80105be5:	c3                   	ret    
80105be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bed:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bf0:	e8 ab df ff ff       	call   80103ba0 <myproc>
80105bf5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bf8:	85 c0                	test   %eax,%eax
80105bfa:	0f 84 a2 01 00 00    	je     80105da2 <trap+0x262>
80105c00:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c04:	0f 84 98 01 00 00    	je     80105da2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c0a:	0f 20 d1             	mov    %cr2,%ecx
80105c0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c10:	e8 6b df ff ff       	call   80103b80 <cpuid>
80105c15:	8b 73 30             	mov    0x30(%ebx),%esi
80105c18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c1b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c21:	e8 7a df ff ff       	call   80103ba0 <myproc>
80105c26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c29:	e8 72 df ff ff       	call   80103ba0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c31:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c34:	51                   	push   %ecx
80105c35:	57                   	push   %edi
80105c36:	52                   	push   %edx
80105c37:	ff 75 e4             	push   -0x1c(%ebp)
80105c3a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c3b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c3e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c41:	56                   	push   %esi
80105c42:	ff 70 10             	push   0x10(%eax)
80105c45:	68 9c 7b 10 80       	push   $0x80107b9c
80105c4a:	e8 61 ab ff ff       	call   801007b0 <cprintf>
    myproc()->killed = 1;
80105c4f:	83 c4 20             	add    $0x20,%esp
80105c52:	e8 49 df ff ff       	call   80103ba0 <myproc>
80105c57:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c5e:	e8 3d df ff ff       	call   80103ba0 <myproc>
80105c63:	85 c0                	test   %eax,%eax
80105c65:	0f 85 18 ff ff ff    	jne    80105b83 <trap+0x43>
80105c6b:	e9 30 ff ff ff       	jmp    80105ba0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105c70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c74:	0f 85 3e ff ff ff    	jne    80105bb8 <trap+0x78>
    yield();
80105c7a:	e8 a1 e5 ff ff       	call   80104220 <yield>
80105c7f:	e9 34 ff ff ff       	jmp    80105bb8 <trap+0x78>
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c88:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c8b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c8f:	e8 ec de ff ff       	call   80103b80 <cpuid>
80105c94:	57                   	push   %edi
80105c95:	56                   	push   %esi
80105c96:	50                   	push   %eax
80105c97:	68 44 7b 10 80       	push   $0x80107b44
80105c9c:	e8 0f ab ff ff       	call   801007b0 <cprintf>
    lapiceoi();
80105ca1:	e8 9a ce ff ff       	call   80102b40 <lapiceoi>
    break;
80105ca6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ca9:	e8 f2 de ff ff       	call   80103ba0 <myproc>
80105cae:	85 c0                	test   %eax,%eax
80105cb0:	0f 85 cd fe ff ff    	jne    80105b83 <trap+0x43>
80105cb6:	e9 e5 fe ff ff       	jmp    80105ba0 <trap+0x60>
80105cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop
    if(myproc()->killed)
80105cc0:	e8 db de ff ff       	call   80103ba0 <myproc>
80105cc5:	8b 70 24             	mov    0x24(%eax),%esi
80105cc8:	85 f6                	test   %esi,%esi
80105cca:	0f 85 c8 00 00 00    	jne    80105d98 <trap+0x258>
    myproc()->tf = tf;
80105cd0:	e8 cb de ff ff       	call   80103ba0 <myproc>
80105cd5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105cd8:	e8 b3 ef ff ff       	call   80104c90 <syscall>
    if(myproc()->killed)
80105cdd:	e8 be de ff ff       	call   80103ba0 <myproc>
80105ce2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ce5:	85 c9                	test   %ecx,%ecx
80105ce7:	0f 84 f1 fe ff ff    	je     80105bde <trap+0x9e>
}
80105ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf0:	5b                   	pop    %ebx
80105cf1:	5e                   	pop    %esi
80105cf2:	5f                   	pop    %edi
80105cf3:	5d                   	pop    %ebp
      exit();
80105cf4:	e9 c7 e2 ff ff       	jmp    80103fc0 <exit>
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d00:	e8 3b 02 00 00       	call   80105f40 <uartintr>
    lapiceoi();
80105d05:	e8 36 ce ff ff       	call   80102b40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0a:	e8 91 de ff ff       	call   80103ba0 <myproc>
80105d0f:	85 c0                	test   %eax,%eax
80105d11:	0f 85 6c fe ff ff    	jne    80105b83 <trap+0x43>
80105d17:	e9 84 fe ff ff       	jmp    80105ba0 <trap+0x60>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d20:	e8 db cc ff ff       	call   80102a00 <kbdintr>
    lapiceoi();
80105d25:	e8 16 ce ff ff       	call   80102b40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d2a:	e8 71 de ff ff       	call   80103ba0 <myproc>
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	0f 85 4c fe ff ff    	jne    80105b83 <trap+0x43>
80105d37:	e9 64 fe ff ff       	jmp    80105ba0 <trap+0x60>
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d40:	e8 3b de ff ff       	call   80103b80 <cpuid>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	0f 85 28 fe ff ff    	jne    80105b75 <trap+0x35>
      acquire(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 80 3c 11 80       	push   $0x80113c80
80105d55:	e8 76 ea ff ff       	call   801047d0 <acquire>
      wakeup(&ticks);
80105d5a:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
      ticks++;
80105d61:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105d68:	e8 c3 e5 ff ff       	call   80104330 <wakeup>
      release(&tickslock);
80105d6d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105d74:	e8 f7 e9 ff ff       	call   80104770 <release>
80105d79:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d7c:	e9 f4 fd ff ff       	jmp    80105b75 <trap+0x35>
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105d88:	e8 33 e2 ff ff       	call   80103fc0 <exit>
80105d8d:	e9 0e fe ff ff       	jmp    80105ba0 <trap+0x60>
80105d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d98:	e8 23 e2 ff ff       	call   80103fc0 <exit>
80105d9d:	e9 2e ff ff ff       	jmp    80105cd0 <trap+0x190>
80105da2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105da5:	e8 d6 dd ff ff       	call   80103b80 <cpuid>
80105daa:	83 ec 0c             	sub    $0xc,%esp
80105dad:	56                   	push   %esi
80105dae:	57                   	push   %edi
80105daf:	50                   	push   %eax
80105db0:	ff 73 30             	push   0x30(%ebx)
80105db3:	68 68 7b 10 80       	push   $0x80107b68
80105db8:	e8 f3 a9 ff ff       	call   801007b0 <cprintf>
      panic("trap");
80105dbd:	83 c4 14             	add    $0x14,%esp
80105dc0:	68 3e 7b 10 80       	push   $0x80107b3e
80105dc5:	e8 b6 a5 ff ff       	call   80100380 <panic>
80105dca:	66 90                	xchg   %ax,%ax
80105dcc:	66 90                	xchg   %ax,%ax
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105dd0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 17                	je     80105df0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dd9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dde:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ddf:	a8 01                	test   $0x1,%al
80105de1:	74 0d                	je     80105df0 <uartgetc+0x20>
80105de3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105de8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105de9:	0f b6 c0             	movzbl %al,%eax
80105dec:	c3                   	ret    
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df5:	c3                   	ret    
80105df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfd:	8d 76 00             	lea    0x0(%esi),%esi

80105e00 <uartinit>:
{
80105e00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e01:	31 c9                	xor    %ecx,%ecx
80105e03:	89 c8                	mov    %ecx,%eax
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	57                   	push   %edi
80105e08:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e0d:	56                   	push   %esi
80105e0e:	89 fa                	mov    %edi,%edx
80105e10:	53                   	push   %ebx
80105e11:	83 ec 1c             	sub    $0x1c,%esp
80105e14:	ee                   	out    %al,(%dx)
80105e15:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e1f:	89 f2                	mov    %esi,%edx
80105e21:	ee                   	out    %al,(%dx)
80105e22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e2c:	ee                   	out    %al,(%dx)
80105e2d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e32:	89 c8                	mov    %ecx,%eax
80105e34:	89 da                	mov    %ebx,%edx
80105e36:	ee                   	out    %al,(%dx)
80105e37:	b8 03 00 00 00       	mov    $0x3,%eax
80105e3c:	89 f2                	mov    %esi,%edx
80105e3e:	ee                   	out    %al,(%dx)
80105e3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e44:	89 c8                	mov    %ecx,%eax
80105e46:	ee                   	out    %al,(%dx)
80105e47:	b8 01 00 00 00       	mov    $0x1,%eax
80105e4c:	89 da                	mov    %ebx,%edx
80105e4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e54:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e55:	3c ff                	cmp    $0xff,%al
80105e57:	74 78                	je     80105ed1 <uartinit+0xd1>
  uart = 1;
80105e59:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105e60:	00 00 00 
80105e63:	89 fa                	mov    %edi,%edx
80105e65:	ec                   	in     (%dx),%al
80105e66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e6c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e6f:	bf 60 7c 10 80       	mov    $0x80107c60,%edi
80105e74:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e79:	6a 00                	push   $0x0
80105e7b:	6a 04                	push   $0x4
80105e7d:	e8 2e c8 ff ff       	call   801026b0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105e82:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105e86:	83 c4 10             	add    $0x10,%esp
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105e90:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105e95:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e9a:	85 c0                	test   %eax,%eax
80105e9c:	75 14                	jne    80105eb2 <uartinit+0xb2>
80105e9e:	eb 23                	jmp    80105ec3 <uartinit+0xc3>
    microdelay(10);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	6a 0a                	push   $0xa
80105ea5:	e8 b6 cc ff ff       	call   80102b60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	83 eb 01             	sub    $0x1,%ebx
80105eb0:	74 07                	je     80105eb9 <uartinit+0xb9>
80105eb2:	89 f2                	mov    %esi,%edx
80105eb4:	ec                   	in     (%dx),%al
80105eb5:	a8 20                	test   $0x20,%al
80105eb7:	74 e7                	je     80105ea0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105eb9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105ebd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ec2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105ec3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105ec7:	83 c7 01             	add    $0x1,%edi
80105eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80105ecd:	84 c0                	test   %al,%al
80105ecf:	75 bf                	jne    80105e90 <uartinit+0x90>
}
80105ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed4:	5b                   	pop    %ebx
80105ed5:	5e                   	pop    %esi
80105ed6:	5f                   	pop    %edi
80105ed7:	5d                   	pop    %ebp
80105ed8:	c3                   	ret    
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <uartputc>:
  if(!uart)
80105ee0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	74 47                	je     80105f30 <uartputc+0x50>
{
80105ee9:	55                   	push   %ebp
80105eea:	89 e5                	mov    %esp,%ebp
80105eec:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eed:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ef2:	53                   	push   %ebx
80105ef3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ef8:	eb 18                	jmp    80105f12 <uartputc+0x32>
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	6a 0a                	push   $0xa
80105f05:	e8 56 cc ff ff       	call   80102b60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	83 eb 01             	sub    $0x1,%ebx
80105f10:	74 07                	je     80105f19 <uartputc+0x39>
80105f12:	89 f2                	mov    %esi,%edx
80105f14:	ec                   	in     (%dx),%al
80105f15:	a8 20                	test   $0x20,%al
80105f17:	74 e7                	je     80105f00 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f19:	8b 45 08             	mov    0x8(%ebp),%eax
80105f1c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f21:	ee                   	out    %al,(%dx)
}
80105f22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f25:	5b                   	pop    %ebx
80105f26:	5e                   	pop    %esi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f30:	c3                   	ret    
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3f:	90                   	nop

80105f40 <uartintr>:

void
uartintr(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f46:	68 d0 5d 10 80       	push   $0x80105dd0
80105f4b:	e8 d0 aa ff ff       	call   80100a20 <consoleintr>
}
80105f50:	83 c4 10             	add    $0x10,%esp
80105f53:	c9                   	leave  
80105f54:	c3                   	ret    

80105f55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f55:	6a 00                	push   $0x0
  pushl $0
80105f57:	6a 00                	push   $0x0
  jmp alltraps
80105f59:	e9 0c fb ff ff       	jmp    80105a6a <alltraps>

80105f5e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $1
80105f60:	6a 01                	push   $0x1
  jmp alltraps
80105f62:	e9 03 fb ff ff       	jmp    80105a6a <alltraps>

80105f67 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $2
80105f69:	6a 02                	push   $0x2
  jmp alltraps
80105f6b:	e9 fa fa ff ff       	jmp    80105a6a <alltraps>

80105f70 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f70:	6a 00                	push   $0x0
  pushl $3
80105f72:	6a 03                	push   $0x3
  jmp alltraps
80105f74:	e9 f1 fa ff ff       	jmp    80105a6a <alltraps>

80105f79 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f79:	6a 00                	push   $0x0
  pushl $4
80105f7b:	6a 04                	push   $0x4
  jmp alltraps
80105f7d:	e9 e8 fa ff ff       	jmp    80105a6a <alltraps>

80105f82 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $5
80105f84:	6a 05                	push   $0x5
  jmp alltraps
80105f86:	e9 df fa ff ff       	jmp    80105a6a <alltraps>

80105f8b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $6
80105f8d:	6a 06                	push   $0x6
  jmp alltraps
80105f8f:	e9 d6 fa ff ff       	jmp    80105a6a <alltraps>

80105f94 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f94:	6a 00                	push   $0x0
  pushl $7
80105f96:	6a 07                	push   $0x7
  jmp alltraps
80105f98:	e9 cd fa ff ff       	jmp    80105a6a <alltraps>

80105f9d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f9d:	6a 08                	push   $0x8
  jmp alltraps
80105f9f:	e9 c6 fa ff ff       	jmp    80105a6a <alltraps>

80105fa4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $9
80105fa6:	6a 09                	push   $0x9
  jmp alltraps
80105fa8:	e9 bd fa ff ff       	jmp    80105a6a <alltraps>

80105fad <vector10>:
.globl vector10
vector10:
  pushl $10
80105fad:	6a 0a                	push   $0xa
  jmp alltraps
80105faf:	e9 b6 fa ff ff       	jmp    80105a6a <alltraps>

80105fb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fb4:	6a 0b                	push   $0xb
  jmp alltraps
80105fb6:	e9 af fa ff ff       	jmp    80105a6a <alltraps>

80105fbb <vector12>:
.globl vector12
vector12:
  pushl $12
80105fbb:	6a 0c                	push   $0xc
  jmp alltraps
80105fbd:	e9 a8 fa ff ff       	jmp    80105a6a <alltraps>

80105fc2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105fc2:	6a 0d                	push   $0xd
  jmp alltraps
80105fc4:	e9 a1 fa ff ff       	jmp    80105a6a <alltraps>

80105fc9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105fc9:	6a 0e                	push   $0xe
  jmp alltraps
80105fcb:	e9 9a fa ff ff       	jmp    80105a6a <alltraps>

80105fd0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $15
80105fd2:	6a 0f                	push   $0xf
  jmp alltraps
80105fd4:	e9 91 fa ff ff       	jmp    80105a6a <alltraps>

80105fd9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $16
80105fdb:	6a 10                	push   $0x10
  jmp alltraps
80105fdd:	e9 88 fa ff ff       	jmp    80105a6a <alltraps>

80105fe2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fe2:	6a 11                	push   $0x11
  jmp alltraps
80105fe4:	e9 81 fa ff ff       	jmp    80105a6a <alltraps>

80105fe9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $18
80105feb:	6a 12                	push   $0x12
  jmp alltraps
80105fed:	e9 78 fa ff ff       	jmp    80105a6a <alltraps>

80105ff2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $19
80105ff4:	6a 13                	push   $0x13
  jmp alltraps
80105ff6:	e9 6f fa ff ff       	jmp    80105a6a <alltraps>

80105ffb <vector20>:
.globl vector20
vector20:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $20
80105ffd:	6a 14                	push   $0x14
  jmp alltraps
80105fff:	e9 66 fa ff ff       	jmp    80105a6a <alltraps>

80106004 <vector21>:
.globl vector21
vector21:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $21
80106006:	6a 15                	push   $0x15
  jmp alltraps
80106008:	e9 5d fa ff ff       	jmp    80105a6a <alltraps>

8010600d <vector22>:
.globl vector22
vector22:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $22
8010600f:	6a 16                	push   $0x16
  jmp alltraps
80106011:	e9 54 fa ff ff       	jmp    80105a6a <alltraps>

80106016 <vector23>:
.globl vector23
vector23:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $23
80106018:	6a 17                	push   $0x17
  jmp alltraps
8010601a:	e9 4b fa ff ff       	jmp    80105a6a <alltraps>

8010601f <vector24>:
.globl vector24
vector24:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $24
80106021:	6a 18                	push   $0x18
  jmp alltraps
80106023:	e9 42 fa ff ff       	jmp    80105a6a <alltraps>

80106028 <vector25>:
.globl vector25
vector25:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $25
8010602a:	6a 19                	push   $0x19
  jmp alltraps
8010602c:	e9 39 fa ff ff       	jmp    80105a6a <alltraps>

80106031 <vector26>:
.globl vector26
vector26:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $26
80106033:	6a 1a                	push   $0x1a
  jmp alltraps
80106035:	e9 30 fa ff ff       	jmp    80105a6a <alltraps>

8010603a <vector27>:
.globl vector27
vector27:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $27
8010603c:	6a 1b                	push   $0x1b
  jmp alltraps
8010603e:	e9 27 fa ff ff       	jmp    80105a6a <alltraps>

80106043 <vector28>:
.globl vector28
vector28:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $28
80106045:	6a 1c                	push   $0x1c
  jmp alltraps
80106047:	e9 1e fa ff ff       	jmp    80105a6a <alltraps>

8010604c <vector29>:
.globl vector29
vector29:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $29
8010604e:	6a 1d                	push   $0x1d
  jmp alltraps
80106050:	e9 15 fa ff ff       	jmp    80105a6a <alltraps>

80106055 <vector30>:
.globl vector30
vector30:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $30
80106057:	6a 1e                	push   $0x1e
  jmp alltraps
80106059:	e9 0c fa ff ff       	jmp    80105a6a <alltraps>

8010605e <vector31>:
.globl vector31
vector31:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $31
80106060:	6a 1f                	push   $0x1f
  jmp alltraps
80106062:	e9 03 fa ff ff       	jmp    80105a6a <alltraps>

80106067 <vector32>:
.globl vector32
vector32:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $32
80106069:	6a 20                	push   $0x20
  jmp alltraps
8010606b:	e9 fa f9 ff ff       	jmp    80105a6a <alltraps>

80106070 <vector33>:
.globl vector33
vector33:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $33
80106072:	6a 21                	push   $0x21
  jmp alltraps
80106074:	e9 f1 f9 ff ff       	jmp    80105a6a <alltraps>

80106079 <vector34>:
.globl vector34
vector34:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $34
8010607b:	6a 22                	push   $0x22
  jmp alltraps
8010607d:	e9 e8 f9 ff ff       	jmp    80105a6a <alltraps>

80106082 <vector35>:
.globl vector35
vector35:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $35
80106084:	6a 23                	push   $0x23
  jmp alltraps
80106086:	e9 df f9 ff ff       	jmp    80105a6a <alltraps>

8010608b <vector36>:
.globl vector36
vector36:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $36
8010608d:	6a 24                	push   $0x24
  jmp alltraps
8010608f:	e9 d6 f9 ff ff       	jmp    80105a6a <alltraps>

80106094 <vector37>:
.globl vector37
vector37:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $37
80106096:	6a 25                	push   $0x25
  jmp alltraps
80106098:	e9 cd f9 ff ff       	jmp    80105a6a <alltraps>

8010609d <vector38>:
.globl vector38
vector38:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $38
8010609f:	6a 26                	push   $0x26
  jmp alltraps
801060a1:	e9 c4 f9 ff ff       	jmp    80105a6a <alltraps>

801060a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $39
801060a8:	6a 27                	push   $0x27
  jmp alltraps
801060aa:	e9 bb f9 ff ff       	jmp    80105a6a <alltraps>

801060af <vector40>:
.globl vector40
vector40:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $40
801060b1:	6a 28                	push   $0x28
  jmp alltraps
801060b3:	e9 b2 f9 ff ff       	jmp    80105a6a <alltraps>

801060b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $41
801060ba:	6a 29                	push   $0x29
  jmp alltraps
801060bc:	e9 a9 f9 ff ff       	jmp    80105a6a <alltraps>

801060c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $42
801060c3:	6a 2a                	push   $0x2a
  jmp alltraps
801060c5:	e9 a0 f9 ff ff       	jmp    80105a6a <alltraps>

801060ca <vector43>:
.globl vector43
vector43:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $43
801060cc:	6a 2b                	push   $0x2b
  jmp alltraps
801060ce:	e9 97 f9 ff ff       	jmp    80105a6a <alltraps>

801060d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $44
801060d5:	6a 2c                	push   $0x2c
  jmp alltraps
801060d7:	e9 8e f9 ff ff       	jmp    80105a6a <alltraps>

801060dc <vector45>:
.globl vector45
vector45:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $45
801060de:	6a 2d                	push   $0x2d
  jmp alltraps
801060e0:	e9 85 f9 ff ff       	jmp    80105a6a <alltraps>

801060e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $46
801060e7:	6a 2e                	push   $0x2e
  jmp alltraps
801060e9:	e9 7c f9 ff ff       	jmp    80105a6a <alltraps>

801060ee <vector47>:
.globl vector47
vector47:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $47
801060f0:	6a 2f                	push   $0x2f
  jmp alltraps
801060f2:	e9 73 f9 ff ff       	jmp    80105a6a <alltraps>

801060f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $48
801060f9:	6a 30                	push   $0x30
  jmp alltraps
801060fb:	e9 6a f9 ff ff       	jmp    80105a6a <alltraps>

80106100 <vector49>:
.globl vector49
vector49:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $49
80106102:	6a 31                	push   $0x31
  jmp alltraps
80106104:	e9 61 f9 ff ff       	jmp    80105a6a <alltraps>

80106109 <vector50>:
.globl vector50
vector50:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $50
8010610b:	6a 32                	push   $0x32
  jmp alltraps
8010610d:	e9 58 f9 ff ff       	jmp    80105a6a <alltraps>

80106112 <vector51>:
.globl vector51
vector51:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $51
80106114:	6a 33                	push   $0x33
  jmp alltraps
80106116:	e9 4f f9 ff ff       	jmp    80105a6a <alltraps>

8010611b <vector52>:
.globl vector52
vector52:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $52
8010611d:	6a 34                	push   $0x34
  jmp alltraps
8010611f:	e9 46 f9 ff ff       	jmp    80105a6a <alltraps>

80106124 <vector53>:
.globl vector53
vector53:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $53
80106126:	6a 35                	push   $0x35
  jmp alltraps
80106128:	e9 3d f9 ff ff       	jmp    80105a6a <alltraps>

8010612d <vector54>:
.globl vector54
vector54:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $54
8010612f:	6a 36                	push   $0x36
  jmp alltraps
80106131:	e9 34 f9 ff ff       	jmp    80105a6a <alltraps>

80106136 <vector55>:
.globl vector55
vector55:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $55
80106138:	6a 37                	push   $0x37
  jmp alltraps
8010613a:	e9 2b f9 ff ff       	jmp    80105a6a <alltraps>

8010613f <vector56>:
.globl vector56
vector56:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $56
80106141:	6a 38                	push   $0x38
  jmp alltraps
80106143:	e9 22 f9 ff ff       	jmp    80105a6a <alltraps>

80106148 <vector57>:
.globl vector57
vector57:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $57
8010614a:	6a 39                	push   $0x39
  jmp alltraps
8010614c:	e9 19 f9 ff ff       	jmp    80105a6a <alltraps>

80106151 <vector58>:
.globl vector58
vector58:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $58
80106153:	6a 3a                	push   $0x3a
  jmp alltraps
80106155:	e9 10 f9 ff ff       	jmp    80105a6a <alltraps>

8010615a <vector59>:
.globl vector59
vector59:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $59
8010615c:	6a 3b                	push   $0x3b
  jmp alltraps
8010615e:	e9 07 f9 ff ff       	jmp    80105a6a <alltraps>

80106163 <vector60>:
.globl vector60
vector60:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $60
80106165:	6a 3c                	push   $0x3c
  jmp alltraps
80106167:	e9 fe f8 ff ff       	jmp    80105a6a <alltraps>

8010616c <vector61>:
.globl vector61
vector61:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $61
8010616e:	6a 3d                	push   $0x3d
  jmp alltraps
80106170:	e9 f5 f8 ff ff       	jmp    80105a6a <alltraps>

80106175 <vector62>:
.globl vector62
vector62:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $62
80106177:	6a 3e                	push   $0x3e
  jmp alltraps
80106179:	e9 ec f8 ff ff       	jmp    80105a6a <alltraps>

8010617e <vector63>:
.globl vector63
vector63:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $63
80106180:	6a 3f                	push   $0x3f
  jmp alltraps
80106182:	e9 e3 f8 ff ff       	jmp    80105a6a <alltraps>

80106187 <vector64>:
.globl vector64
vector64:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $64
80106189:	6a 40                	push   $0x40
  jmp alltraps
8010618b:	e9 da f8 ff ff       	jmp    80105a6a <alltraps>

80106190 <vector65>:
.globl vector65
vector65:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $65
80106192:	6a 41                	push   $0x41
  jmp alltraps
80106194:	e9 d1 f8 ff ff       	jmp    80105a6a <alltraps>

80106199 <vector66>:
.globl vector66
vector66:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $66
8010619b:	6a 42                	push   $0x42
  jmp alltraps
8010619d:	e9 c8 f8 ff ff       	jmp    80105a6a <alltraps>

801061a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $67
801061a4:	6a 43                	push   $0x43
  jmp alltraps
801061a6:	e9 bf f8 ff ff       	jmp    80105a6a <alltraps>

801061ab <vector68>:
.globl vector68
vector68:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $68
801061ad:	6a 44                	push   $0x44
  jmp alltraps
801061af:	e9 b6 f8 ff ff       	jmp    80105a6a <alltraps>

801061b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $69
801061b6:	6a 45                	push   $0x45
  jmp alltraps
801061b8:	e9 ad f8 ff ff       	jmp    80105a6a <alltraps>

801061bd <vector70>:
.globl vector70
vector70:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $70
801061bf:	6a 46                	push   $0x46
  jmp alltraps
801061c1:	e9 a4 f8 ff ff       	jmp    80105a6a <alltraps>

801061c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $71
801061c8:	6a 47                	push   $0x47
  jmp alltraps
801061ca:	e9 9b f8 ff ff       	jmp    80105a6a <alltraps>

801061cf <vector72>:
.globl vector72
vector72:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $72
801061d1:	6a 48                	push   $0x48
  jmp alltraps
801061d3:	e9 92 f8 ff ff       	jmp    80105a6a <alltraps>

801061d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $73
801061da:	6a 49                	push   $0x49
  jmp alltraps
801061dc:	e9 89 f8 ff ff       	jmp    80105a6a <alltraps>

801061e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $74
801061e3:	6a 4a                	push   $0x4a
  jmp alltraps
801061e5:	e9 80 f8 ff ff       	jmp    80105a6a <alltraps>

801061ea <vector75>:
.globl vector75
vector75:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $75
801061ec:	6a 4b                	push   $0x4b
  jmp alltraps
801061ee:	e9 77 f8 ff ff       	jmp    80105a6a <alltraps>

801061f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $76
801061f5:	6a 4c                	push   $0x4c
  jmp alltraps
801061f7:	e9 6e f8 ff ff       	jmp    80105a6a <alltraps>

801061fc <vector77>:
.globl vector77
vector77:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $77
801061fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106200:	e9 65 f8 ff ff       	jmp    80105a6a <alltraps>

80106205 <vector78>:
.globl vector78
vector78:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $78
80106207:	6a 4e                	push   $0x4e
  jmp alltraps
80106209:	e9 5c f8 ff ff       	jmp    80105a6a <alltraps>

8010620e <vector79>:
.globl vector79
vector79:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $79
80106210:	6a 4f                	push   $0x4f
  jmp alltraps
80106212:	e9 53 f8 ff ff       	jmp    80105a6a <alltraps>

80106217 <vector80>:
.globl vector80
vector80:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $80
80106219:	6a 50                	push   $0x50
  jmp alltraps
8010621b:	e9 4a f8 ff ff       	jmp    80105a6a <alltraps>

80106220 <vector81>:
.globl vector81
vector81:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $81
80106222:	6a 51                	push   $0x51
  jmp alltraps
80106224:	e9 41 f8 ff ff       	jmp    80105a6a <alltraps>

80106229 <vector82>:
.globl vector82
vector82:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $82
8010622b:	6a 52                	push   $0x52
  jmp alltraps
8010622d:	e9 38 f8 ff ff       	jmp    80105a6a <alltraps>

80106232 <vector83>:
.globl vector83
vector83:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $83
80106234:	6a 53                	push   $0x53
  jmp alltraps
80106236:	e9 2f f8 ff ff       	jmp    80105a6a <alltraps>

8010623b <vector84>:
.globl vector84
vector84:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $84
8010623d:	6a 54                	push   $0x54
  jmp alltraps
8010623f:	e9 26 f8 ff ff       	jmp    80105a6a <alltraps>

80106244 <vector85>:
.globl vector85
vector85:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $85
80106246:	6a 55                	push   $0x55
  jmp alltraps
80106248:	e9 1d f8 ff ff       	jmp    80105a6a <alltraps>

8010624d <vector86>:
.globl vector86
vector86:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $86
8010624f:	6a 56                	push   $0x56
  jmp alltraps
80106251:	e9 14 f8 ff ff       	jmp    80105a6a <alltraps>

80106256 <vector87>:
.globl vector87
vector87:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $87
80106258:	6a 57                	push   $0x57
  jmp alltraps
8010625a:	e9 0b f8 ff ff       	jmp    80105a6a <alltraps>

8010625f <vector88>:
.globl vector88
vector88:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $88
80106261:	6a 58                	push   $0x58
  jmp alltraps
80106263:	e9 02 f8 ff ff       	jmp    80105a6a <alltraps>

80106268 <vector89>:
.globl vector89
vector89:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $89
8010626a:	6a 59                	push   $0x59
  jmp alltraps
8010626c:	e9 f9 f7 ff ff       	jmp    80105a6a <alltraps>

80106271 <vector90>:
.globl vector90
vector90:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $90
80106273:	6a 5a                	push   $0x5a
  jmp alltraps
80106275:	e9 f0 f7 ff ff       	jmp    80105a6a <alltraps>

8010627a <vector91>:
.globl vector91
vector91:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $91
8010627c:	6a 5b                	push   $0x5b
  jmp alltraps
8010627e:	e9 e7 f7 ff ff       	jmp    80105a6a <alltraps>

80106283 <vector92>:
.globl vector92
vector92:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $92
80106285:	6a 5c                	push   $0x5c
  jmp alltraps
80106287:	e9 de f7 ff ff       	jmp    80105a6a <alltraps>

8010628c <vector93>:
.globl vector93
vector93:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $93
8010628e:	6a 5d                	push   $0x5d
  jmp alltraps
80106290:	e9 d5 f7 ff ff       	jmp    80105a6a <alltraps>

80106295 <vector94>:
.globl vector94
vector94:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $94
80106297:	6a 5e                	push   $0x5e
  jmp alltraps
80106299:	e9 cc f7 ff ff       	jmp    80105a6a <alltraps>

8010629e <vector95>:
.globl vector95
vector95:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $95
801062a0:	6a 5f                	push   $0x5f
  jmp alltraps
801062a2:	e9 c3 f7 ff ff       	jmp    80105a6a <alltraps>

801062a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $96
801062a9:	6a 60                	push   $0x60
  jmp alltraps
801062ab:	e9 ba f7 ff ff       	jmp    80105a6a <alltraps>

801062b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $97
801062b2:	6a 61                	push   $0x61
  jmp alltraps
801062b4:	e9 b1 f7 ff ff       	jmp    80105a6a <alltraps>

801062b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $98
801062bb:	6a 62                	push   $0x62
  jmp alltraps
801062bd:	e9 a8 f7 ff ff       	jmp    80105a6a <alltraps>

801062c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $99
801062c4:	6a 63                	push   $0x63
  jmp alltraps
801062c6:	e9 9f f7 ff ff       	jmp    80105a6a <alltraps>

801062cb <vector100>:
.globl vector100
vector100:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $100
801062cd:	6a 64                	push   $0x64
  jmp alltraps
801062cf:	e9 96 f7 ff ff       	jmp    80105a6a <alltraps>

801062d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $101
801062d6:	6a 65                	push   $0x65
  jmp alltraps
801062d8:	e9 8d f7 ff ff       	jmp    80105a6a <alltraps>

801062dd <vector102>:
.globl vector102
vector102:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $102
801062df:	6a 66                	push   $0x66
  jmp alltraps
801062e1:	e9 84 f7 ff ff       	jmp    80105a6a <alltraps>

801062e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $103
801062e8:	6a 67                	push   $0x67
  jmp alltraps
801062ea:	e9 7b f7 ff ff       	jmp    80105a6a <alltraps>

801062ef <vector104>:
.globl vector104
vector104:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $104
801062f1:	6a 68                	push   $0x68
  jmp alltraps
801062f3:	e9 72 f7 ff ff       	jmp    80105a6a <alltraps>

801062f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $105
801062fa:	6a 69                	push   $0x69
  jmp alltraps
801062fc:	e9 69 f7 ff ff       	jmp    80105a6a <alltraps>

80106301 <vector106>:
.globl vector106
vector106:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $106
80106303:	6a 6a                	push   $0x6a
  jmp alltraps
80106305:	e9 60 f7 ff ff       	jmp    80105a6a <alltraps>

8010630a <vector107>:
.globl vector107
vector107:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $107
8010630c:	6a 6b                	push   $0x6b
  jmp alltraps
8010630e:	e9 57 f7 ff ff       	jmp    80105a6a <alltraps>

80106313 <vector108>:
.globl vector108
vector108:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $108
80106315:	6a 6c                	push   $0x6c
  jmp alltraps
80106317:	e9 4e f7 ff ff       	jmp    80105a6a <alltraps>

8010631c <vector109>:
.globl vector109
vector109:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $109
8010631e:	6a 6d                	push   $0x6d
  jmp alltraps
80106320:	e9 45 f7 ff ff       	jmp    80105a6a <alltraps>

80106325 <vector110>:
.globl vector110
vector110:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $110
80106327:	6a 6e                	push   $0x6e
  jmp alltraps
80106329:	e9 3c f7 ff ff       	jmp    80105a6a <alltraps>

8010632e <vector111>:
.globl vector111
vector111:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $111
80106330:	6a 6f                	push   $0x6f
  jmp alltraps
80106332:	e9 33 f7 ff ff       	jmp    80105a6a <alltraps>

80106337 <vector112>:
.globl vector112
vector112:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $112
80106339:	6a 70                	push   $0x70
  jmp alltraps
8010633b:	e9 2a f7 ff ff       	jmp    80105a6a <alltraps>

80106340 <vector113>:
.globl vector113
vector113:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $113
80106342:	6a 71                	push   $0x71
  jmp alltraps
80106344:	e9 21 f7 ff ff       	jmp    80105a6a <alltraps>

80106349 <vector114>:
.globl vector114
vector114:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $114
8010634b:	6a 72                	push   $0x72
  jmp alltraps
8010634d:	e9 18 f7 ff ff       	jmp    80105a6a <alltraps>

80106352 <vector115>:
.globl vector115
vector115:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $115
80106354:	6a 73                	push   $0x73
  jmp alltraps
80106356:	e9 0f f7 ff ff       	jmp    80105a6a <alltraps>

8010635b <vector116>:
.globl vector116
vector116:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $116
8010635d:	6a 74                	push   $0x74
  jmp alltraps
8010635f:	e9 06 f7 ff ff       	jmp    80105a6a <alltraps>

80106364 <vector117>:
.globl vector117
vector117:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $117
80106366:	6a 75                	push   $0x75
  jmp alltraps
80106368:	e9 fd f6 ff ff       	jmp    80105a6a <alltraps>

8010636d <vector118>:
.globl vector118
vector118:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $118
8010636f:	6a 76                	push   $0x76
  jmp alltraps
80106371:	e9 f4 f6 ff ff       	jmp    80105a6a <alltraps>

80106376 <vector119>:
.globl vector119
vector119:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $119
80106378:	6a 77                	push   $0x77
  jmp alltraps
8010637a:	e9 eb f6 ff ff       	jmp    80105a6a <alltraps>

8010637f <vector120>:
.globl vector120
vector120:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $120
80106381:	6a 78                	push   $0x78
  jmp alltraps
80106383:	e9 e2 f6 ff ff       	jmp    80105a6a <alltraps>

80106388 <vector121>:
.globl vector121
vector121:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $121
8010638a:	6a 79                	push   $0x79
  jmp alltraps
8010638c:	e9 d9 f6 ff ff       	jmp    80105a6a <alltraps>

80106391 <vector122>:
.globl vector122
vector122:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $122
80106393:	6a 7a                	push   $0x7a
  jmp alltraps
80106395:	e9 d0 f6 ff ff       	jmp    80105a6a <alltraps>

8010639a <vector123>:
.globl vector123
vector123:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $123
8010639c:	6a 7b                	push   $0x7b
  jmp alltraps
8010639e:	e9 c7 f6 ff ff       	jmp    80105a6a <alltraps>

801063a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $124
801063a5:	6a 7c                	push   $0x7c
  jmp alltraps
801063a7:	e9 be f6 ff ff       	jmp    80105a6a <alltraps>

801063ac <vector125>:
.globl vector125
vector125:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $125
801063ae:	6a 7d                	push   $0x7d
  jmp alltraps
801063b0:	e9 b5 f6 ff ff       	jmp    80105a6a <alltraps>

801063b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $126
801063b7:	6a 7e                	push   $0x7e
  jmp alltraps
801063b9:	e9 ac f6 ff ff       	jmp    80105a6a <alltraps>

801063be <vector127>:
.globl vector127
vector127:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $127
801063c0:	6a 7f                	push   $0x7f
  jmp alltraps
801063c2:	e9 a3 f6 ff ff       	jmp    80105a6a <alltraps>

801063c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $128
801063c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063ce:	e9 97 f6 ff ff       	jmp    80105a6a <alltraps>

801063d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $129
801063d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063da:	e9 8b f6 ff ff       	jmp    80105a6a <alltraps>

801063df <vector130>:
.globl vector130
vector130:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $130
801063e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063e6:	e9 7f f6 ff ff       	jmp    80105a6a <alltraps>

801063eb <vector131>:
.globl vector131
vector131:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $131
801063ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063f2:	e9 73 f6 ff ff       	jmp    80105a6a <alltraps>

801063f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $132
801063f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063fe:	e9 67 f6 ff ff       	jmp    80105a6a <alltraps>

80106403 <vector133>:
.globl vector133
vector133:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $133
80106405:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010640a:	e9 5b f6 ff ff       	jmp    80105a6a <alltraps>

8010640f <vector134>:
.globl vector134
vector134:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $134
80106411:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106416:	e9 4f f6 ff ff       	jmp    80105a6a <alltraps>

8010641b <vector135>:
.globl vector135
vector135:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $135
8010641d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106422:	e9 43 f6 ff ff       	jmp    80105a6a <alltraps>

80106427 <vector136>:
.globl vector136
vector136:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $136
80106429:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010642e:	e9 37 f6 ff ff       	jmp    80105a6a <alltraps>

80106433 <vector137>:
.globl vector137
vector137:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $137
80106435:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010643a:	e9 2b f6 ff ff       	jmp    80105a6a <alltraps>

8010643f <vector138>:
.globl vector138
vector138:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $138
80106441:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106446:	e9 1f f6 ff ff       	jmp    80105a6a <alltraps>

8010644b <vector139>:
.globl vector139
vector139:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $139
8010644d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106452:	e9 13 f6 ff ff       	jmp    80105a6a <alltraps>

80106457 <vector140>:
.globl vector140
vector140:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $140
80106459:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010645e:	e9 07 f6 ff ff       	jmp    80105a6a <alltraps>

80106463 <vector141>:
.globl vector141
vector141:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $141
80106465:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010646a:	e9 fb f5 ff ff       	jmp    80105a6a <alltraps>

8010646f <vector142>:
.globl vector142
vector142:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $142
80106471:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106476:	e9 ef f5 ff ff       	jmp    80105a6a <alltraps>

8010647b <vector143>:
.globl vector143
vector143:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $143
8010647d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106482:	e9 e3 f5 ff ff       	jmp    80105a6a <alltraps>

80106487 <vector144>:
.globl vector144
vector144:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $144
80106489:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010648e:	e9 d7 f5 ff ff       	jmp    80105a6a <alltraps>

80106493 <vector145>:
.globl vector145
vector145:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $145
80106495:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010649a:	e9 cb f5 ff ff       	jmp    80105a6a <alltraps>

8010649f <vector146>:
.globl vector146
vector146:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $146
801064a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064a6:	e9 bf f5 ff ff       	jmp    80105a6a <alltraps>

801064ab <vector147>:
.globl vector147
vector147:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $147
801064ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064b2:	e9 b3 f5 ff ff       	jmp    80105a6a <alltraps>

801064b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $148
801064b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064be:	e9 a7 f5 ff ff       	jmp    80105a6a <alltraps>

801064c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $149
801064c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064ca:	e9 9b f5 ff ff       	jmp    80105a6a <alltraps>

801064cf <vector150>:
.globl vector150
vector150:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $150
801064d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064d6:	e9 8f f5 ff ff       	jmp    80105a6a <alltraps>

801064db <vector151>:
.globl vector151
vector151:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $151
801064dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064e2:	e9 83 f5 ff ff       	jmp    80105a6a <alltraps>

801064e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $152
801064e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064ee:	e9 77 f5 ff ff       	jmp    80105a6a <alltraps>

801064f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $153
801064f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064fa:	e9 6b f5 ff ff       	jmp    80105a6a <alltraps>

801064ff <vector154>:
.globl vector154
vector154:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $154
80106501:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106506:	e9 5f f5 ff ff       	jmp    80105a6a <alltraps>

8010650b <vector155>:
.globl vector155
vector155:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $155
8010650d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106512:	e9 53 f5 ff ff       	jmp    80105a6a <alltraps>

80106517 <vector156>:
.globl vector156
vector156:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $156
80106519:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010651e:	e9 47 f5 ff ff       	jmp    80105a6a <alltraps>

80106523 <vector157>:
.globl vector157
vector157:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $157
80106525:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010652a:	e9 3b f5 ff ff       	jmp    80105a6a <alltraps>

8010652f <vector158>:
.globl vector158
vector158:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $158
80106531:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106536:	e9 2f f5 ff ff       	jmp    80105a6a <alltraps>

8010653b <vector159>:
.globl vector159
vector159:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $159
8010653d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106542:	e9 23 f5 ff ff       	jmp    80105a6a <alltraps>

80106547 <vector160>:
.globl vector160
vector160:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $160
80106549:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010654e:	e9 17 f5 ff ff       	jmp    80105a6a <alltraps>

80106553 <vector161>:
.globl vector161
vector161:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $161
80106555:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010655a:	e9 0b f5 ff ff       	jmp    80105a6a <alltraps>

8010655f <vector162>:
.globl vector162
vector162:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $162
80106561:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106566:	e9 ff f4 ff ff       	jmp    80105a6a <alltraps>

8010656b <vector163>:
.globl vector163
vector163:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $163
8010656d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106572:	e9 f3 f4 ff ff       	jmp    80105a6a <alltraps>

80106577 <vector164>:
.globl vector164
vector164:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $164
80106579:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010657e:	e9 e7 f4 ff ff       	jmp    80105a6a <alltraps>

80106583 <vector165>:
.globl vector165
vector165:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $165
80106585:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010658a:	e9 db f4 ff ff       	jmp    80105a6a <alltraps>

8010658f <vector166>:
.globl vector166
vector166:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $166
80106591:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106596:	e9 cf f4 ff ff       	jmp    80105a6a <alltraps>

8010659b <vector167>:
.globl vector167
vector167:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $167
8010659d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065a2:	e9 c3 f4 ff ff       	jmp    80105a6a <alltraps>

801065a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $168
801065a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065ae:	e9 b7 f4 ff ff       	jmp    80105a6a <alltraps>

801065b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $169
801065b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065ba:	e9 ab f4 ff ff       	jmp    80105a6a <alltraps>

801065bf <vector170>:
.globl vector170
vector170:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $170
801065c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065c6:	e9 9f f4 ff ff       	jmp    80105a6a <alltraps>

801065cb <vector171>:
.globl vector171
vector171:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $171
801065cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065d2:	e9 93 f4 ff ff       	jmp    80105a6a <alltraps>

801065d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $172
801065d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065de:	e9 87 f4 ff ff       	jmp    80105a6a <alltraps>

801065e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $173
801065e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065ea:	e9 7b f4 ff ff       	jmp    80105a6a <alltraps>

801065ef <vector174>:
.globl vector174
vector174:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $174
801065f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065f6:	e9 6f f4 ff ff       	jmp    80105a6a <alltraps>

801065fb <vector175>:
.globl vector175
vector175:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $175
801065fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106602:	e9 63 f4 ff ff       	jmp    80105a6a <alltraps>

80106607 <vector176>:
.globl vector176
vector176:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $176
80106609:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010660e:	e9 57 f4 ff ff       	jmp    80105a6a <alltraps>

80106613 <vector177>:
.globl vector177
vector177:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $177
80106615:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010661a:	e9 4b f4 ff ff       	jmp    80105a6a <alltraps>

8010661f <vector178>:
.globl vector178
vector178:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $178
80106621:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106626:	e9 3f f4 ff ff       	jmp    80105a6a <alltraps>

8010662b <vector179>:
.globl vector179
vector179:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $179
8010662d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106632:	e9 33 f4 ff ff       	jmp    80105a6a <alltraps>

80106637 <vector180>:
.globl vector180
vector180:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $180
80106639:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010663e:	e9 27 f4 ff ff       	jmp    80105a6a <alltraps>

80106643 <vector181>:
.globl vector181
vector181:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $181
80106645:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010664a:	e9 1b f4 ff ff       	jmp    80105a6a <alltraps>

8010664f <vector182>:
.globl vector182
vector182:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $182
80106651:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106656:	e9 0f f4 ff ff       	jmp    80105a6a <alltraps>

8010665b <vector183>:
.globl vector183
vector183:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $183
8010665d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106662:	e9 03 f4 ff ff       	jmp    80105a6a <alltraps>

80106667 <vector184>:
.globl vector184
vector184:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $184
80106669:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010666e:	e9 f7 f3 ff ff       	jmp    80105a6a <alltraps>

80106673 <vector185>:
.globl vector185
vector185:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $185
80106675:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010667a:	e9 eb f3 ff ff       	jmp    80105a6a <alltraps>

8010667f <vector186>:
.globl vector186
vector186:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $186
80106681:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106686:	e9 df f3 ff ff       	jmp    80105a6a <alltraps>

8010668b <vector187>:
.globl vector187
vector187:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $187
8010668d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106692:	e9 d3 f3 ff ff       	jmp    80105a6a <alltraps>

80106697 <vector188>:
.globl vector188
vector188:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $188
80106699:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010669e:	e9 c7 f3 ff ff       	jmp    80105a6a <alltraps>

801066a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $189
801066a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066aa:	e9 bb f3 ff ff       	jmp    80105a6a <alltraps>

801066af <vector190>:
.globl vector190
vector190:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $190
801066b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066b6:	e9 af f3 ff ff       	jmp    80105a6a <alltraps>

801066bb <vector191>:
.globl vector191
vector191:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $191
801066bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066c2:	e9 a3 f3 ff ff       	jmp    80105a6a <alltraps>

801066c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $192
801066c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066ce:	e9 97 f3 ff ff       	jmp    80105a6a <alltraps>

801066d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $193
801066d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066da:	e9 8b f3 ff ff       	jmp    80105a6a <alltraps>

801066df <vector194>:
.globl vector194
vector194:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $194
801066e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066e6:	e9 7f f3 ff ff       	jmp    80105a6a <alltraps>

801066eb <vector195>:
.globl vector195
vector195:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $195
801066ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066f2:	e9 73 f3 ff ff       	jmp    80105a6a <alltraps>

801066f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $196
801066f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066fe:	e9 67 f3 ff ff       	jmp    80105a6a <alltraps>

80106703 <vector197>:
.globl vector197
vector197:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $197
80106705:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010670a:	e9 5b f3 ff ff       	jmp    80105a6a <alltraps>

8010670f <vector198>:
.globl vector198
vector198:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $198
80106711:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106716:	e9 4f f3 ff ff       	jmp    80105a6a <alltraps>

8010671b <vector199>:
.globl vector199
vector199:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $199
8010671d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106722:	e9 43 f3 ff ff       	jmp    80105a6a <alltraps>

80106727 <vector200>:
.globl vector200
vector200:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $200
80106729:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010672e:	e9 37 f3 ff ff       	jmp    80105a6a <alltraps>

80106733 <vector201>:
.globl vector201
vector201:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $201
80106735:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010673a:	e9 2b f3 ff ff       	jmp    80105a6a <alltraps>

8010673f <vector202>:
.globl vector202
vector202:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $202
80106741:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106746:	e9 1f f3 ff ff       	jmp    80105a6a <alltraps>

8010674b <vector203>:
.globl vector203
vector203:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $203
8010674d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106752:	e9 13 f3 ff ff       	jmp    80105a6a <alltraps>

80106757 <vector204>:
.globl vector204
vector204:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $204
80106759:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010675e:	e9 07 f3 ff ff       	jmp    80105a6a <alltraps>

80106763 <vector205>:
.globl vector205
vector205:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $205
80106765:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010676a:	e9 fb f2 ff ff       	jmp    80105a6a <alltraps>

8010676f <vector206>:
.globl vector206
vector206:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $206
80106771:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106776:	e9 ef f2 ff ff       	jmp    80105a6a <alltraps>

8010677b <vector207>:
.globl vector207
vector207:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $207
8010677d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106782:	e9 e3 f2 ff ff       	jmp    80105a6a <alltraps>

80106787 <vector208>:
.globl vector208
vector208:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $208
80106789:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010678e:	e9 d7 f2 ff ff       	jmp    80105a6a <alltraps>

80106793 <vector209>:
.globl vector209
vector209:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $209
80106795:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010679a:	e9 cb f2 ff ff       	jmp    80105a6a <alltraps>

8010679f <vector210>:
.globl vector210
vector210:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $210
801067a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067a6:	e9 bf f2 ff ff       	jmp    80105a6a <alltraps>

801067ab <vector211>:
.globl vector211
vector211:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $211
801067ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067b2:	e9 b3 f2 ff ff       	jmp    80105a6a <alltraps>

801067b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $212
801067b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067be:	e9 a7 f2 ff ff       	jmp    80105a6a <alltraps>

801067c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $213
801067c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067ca:	e9 9b f2 ff ff       	jmp    80105a6a <alltraps>

801067cf <vector214>:
.globl vector214
vector214:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $214
801067d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067d6:	e9 8f f2 ff ff       	jmp    80105a6a <alltraps>

801067db <vector215>:
.globl vector215
vector215:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $215
801067dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067e2:	e9 83 f2 ff ff       	jmp    80105a6a <alltraps>

801067e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $216
801067e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067ee:	e9 77 f2 ff ff       	jmp    80105a6a <alltraps>

801067f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $217
801067f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067fa:	e9 6b f2 ff ff       	jmp    80105a6a <alltraps>

801067ff <vector218>:
.globl vector218
vector218:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $218
80106801:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106806:	e9 5f f2 ff ff       	jmp    80105a6a <alltraps>

8010680b <vector219>:
.globl vector219
vector219:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $219
8010680d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106812:	e9 53 f2 ff ff       	jmp    80105a6a <alltraps>

80106817 <vector220>:
.globl vector220
vector220:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $220
80106819:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010681e:	e9 47 f2 ff ff       	jmp    80105a6a <alltraps>

80106823 <vector221>:
.globl vector221
vector221:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $221
80106825:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010682a:	e9 3b f2 ff ff       	jmp    80105a6a <alltraps>

8010682f <vector222>:
.globl vector222
vector222:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $222
80106831:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106836:	e9 2f f2 ff ff       	jmp    80105a6a <alltraps>

8010683b <vector223>:
.globl vector223
vector223:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $223
8010683d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106842:	e9 23 f2 ff ff       	jmp    80105a6a <alltraps>

80106847 <vector224>:
.globl vector224
vector224:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $224
80106849:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010684e:	e9 17 f2 ff ff       	jmp    80105a6a <alltraps>

80106853 <vector225>:
.globl vector225
vector225:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $225
80106855:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010685a:	e9 0b f2 ff ff       	jmp    80105a6a <alltraps>

8010685f <vector226>:
.globl vector226
vector226:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $226
80106861:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106866:	e9 ff f1 ff ff       	jmp    80105a6a <alltraps>

8010686b <vector227>:
.globl vector227
vector227:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $227
8010686d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106872:	e9 f3 f1 ff ff       	jmp    80105a6a <alltraps>

80106877 <vector228>:
.globl vector228
vector228:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $228
80106879:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010687e:	e9 e7 f1 ff ff       	jmp    80105a6a <alltraps>

80106883 <vector229>:
.globl vector229
vector229:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $229
80106885:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010688a:	e9 db f1 ff ff       	jmp    80105a6a <alltraps>

8010688f <vector230>:
.globl vector230
vector230:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $230
80106891:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106896:	e9 cf f1 ff ff       	jmp    80105a6a <alltraps>

8010689b <vector231>:
.globl vector231
vector231:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $231
8010689d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068a2:	e9 c3 f1 ff ff       	jmp    80105a6a <alltraps>

801068a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $232
801068a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068ae:	e9 b7 f1 ff ff       	jmp    80105a6a <alltraps>

801068b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $233
801068b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068ba:	e9 ab f1 ff ff       	jmp    80105a6a <alltraps>

801068bf <vector234>:
.globl vector234
vector234:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $234
801068c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068c6:	e9 9f f1 ff ff       	jmp    80105a6a <alltraps>

801068cb <vector235>:
.globl vector235
vector235:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $235
801068cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068d2:	e9 93 f1 ff ff       	jmp    80105a6a <alltraps>

801068d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $236
801068d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068de:	e9 87 f1 ff ff       	jmp    80105a6a <alltraps>

801068e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $237
801068e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068ea:	e9 7b f1 ff ff       	jmp    80105a6a <alltraps>

801068ef <vector238>:
.globl vector238
vector238:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $238
801068f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068f6:	e9 6f f1 ff ff       	jmp    80105a6a <alltraps>

801068fb <vector239>:
.globl vector239
vector239:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $239
801068fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106902:	e9 63 f1 ff ff       	jmp    80105a6a <alltraps>

80106907 <vector240>:
.globl vector240
vector240:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $240
80106909:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010690e:	e9 57 f1 ff ff       	jmp    80105a6a <alltraps>

80106913 <vector241>:
.globl vector241
vector241:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $241
80106915:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010691a:	e9 4b f1 ff ff       	jmp    80105a6a <alltraps>

8010691f <vector242>:
.globl vector242
vector242:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $242
80106921:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106926:	e9 3f f1 ff ff       	jmp    80105a6a <alltraps>

8010692b <vector243>:
.globl vector243
vector243:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $243
8010692d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106932:	e9 33 f1 ff ff       	jmp    80105a6a <alltraps>

80106937 <vector244>:
.globl vector244
vector244:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $244
80106939:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010693e:	e9 27 f1 ff ff       	jmp    80105a6a <alltraps>

80106943 <vector245>:
.globl vector245
vector245:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $245
80106945:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010694a:	e9 1b f1 ff ff       	jmp    80105a6a <alltraps>

8010694f <vector246>:
.globl vector246
vector246:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $246
80106951:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106956:	e9 0f f1 ff ff       	jmp    80105a6a <alltraps>

8010695b <vector247>:
.globl vector247
vector247:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $247
8010695d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106962:	e9 03 f1 ff ff       	jmp    80105a6a <alltraps>

80106967 <vector248>:
.globl vector248
vector248:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $248
80106969:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010696e:	e9 f7 f0 ff ff       	jmp    80105a6a <alltraps>

80106973 <vector249>:
.globl vector249
vector249:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $249
80106975:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010697a:	e9 eb f0 ff ff       	jmp    80105a6a <alltraps>

8010697f <vector250>:
.globl vector250
vector250:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $250
80106981:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106986:	e9 df f0 ff ff       	jmp    80105a6a <alltraps>

8010698b <vector251>:
.globl vector251
vector251:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $251
8010698d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106992:	e9 d3 f0 ff ff       	jmp    80105a6a <alltraps>

80106997 <vector252>:
.globl vector252
vector252:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $252
80106999:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010699e:	e9 c7 f0 ff ff       	jmp    80105a6a <alltraps>

801069a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $253
801069a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069aa:	e9 bb f0 ff ff       	jmp    80105a6a <alltraps>

801069af <vector254>:
.globl vector254
vector254:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $254
801069b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069b6:	e9 af f0 ff ff       	jmp    80105a6a <alltraps>

801069bb <vector255>:
.globl vector255
vector255:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $255
801069bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069c2:	e9 a3 f0 ff ff       	jmp    80105a6a <alltraps>
801069c7:	66 90                	xchg   %ax,%ax
801069c9:	66 90                	xchg   %ax,%ax
801069cb:	66 90                	xchg   %ax,%ax
801069cd:	66 90                	xchg   %ax,%ax
801069cf:	90                   	nop

801069d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069e2:	83 ec 1c             	sub    $0x1c,%esp
801069e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069e8:	39 d3                	cmp    %edx,%ebx
801069ea:	73 49                	jae    80106a35 <deallocuvm.part.0+0x65>
801069ec:	89 c7                	mov    %eax,%edi
801069ee:	eb 0c                	jmp    801069fc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069f0:	83 c0 01             	add    $0x1,%eax
801069f3:	c1 e0 16             	shl    $0x16,%eax
801069f6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069f8:	39 da                	cmp    %ebx,%edx
801069fa:	76 39                	jbe    80106a35 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801069fc:	89 d8                	mov    %ebx,%eax
801069fe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a01:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106a04:	f6 c1 01             	test   $0x1,%cl
80106a07:	74 e7                	je     801069f0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106a09:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a0b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106a11:	c1 ee 0a             	shr    $0xa,%esi
80106a14:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106a1a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106a21:	85 f6                	test   %esi,%esi
80106a23:	74 cb                	je     801069f0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106a25:	8b 06                	mov    (%esi),%eax
80106a27:	a8 01                	test   $0x1,%al
80106a29:	75 15                	jne    80106a40 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106a2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a31:	39 da                	cmp    %ebx,%edx
80106a33:	77 c7                	ja     801069fc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a3b:	5b                   	pop    %ebx
80106a3c:	5e                   	pop    %esi
80106a3d:	5f                   	pop    %edi
80106a3e:	5d                   	pop    %ebp
80106a3f:	c3                   	ret    
      if(pa == 0)
80106a40:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a45:	74 25                	je     80106a6c <deallocuvm.part.0+0x9c>
      kfree(v);
80106a47:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a4a:	05 00 00 00 80       	add    $0x80000000,%eax
80106a4f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a52:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a58:	50                   	push   %eax
80106a59:	e8 92 bc ff ff       	call   801026f0 <kfree>
      *pte = 0;
80106a5e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a67:	83 c4 10             	add    $0x10,%esp
80106a6a:	eb 8c                	jmp    801069f8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106a6c:	83 ec 0c             	sub    $0xc,%esp
80106a6f:	68 26 76 10 80       	push   $0x80107626
80106a74:	e8 07 99 ff ff       	call   80100380 <panic>
80106a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a80 <mappages>:
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a86:	89 d3                	mov    %edx,%ebx
80106a88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a8e:	83 ec 1c             	sub    $0x1c,%esp
80106a91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa3:	29 d8                	sub    %ebx,%eax
80106aa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106aa8:	eb 3d                	jmp    80106ae7 <mappages+0x67>
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ab0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ab7:	c1 ea 0a             	shr    $0xa,%edx
80106aba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ac0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	74 75                	je     80106b40 <mappages+0xc0>
    if(*pte & PTE_P)
80106acb:	f6 00 01             	testb  $0x1,(%eax)
80106ace:	0f 85 86 00 00 00    	jne    80106b5a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ad4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ad7:	83 ce 01             	or     $0x1,%esi
80106ada:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106adc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106adf:	74 6f                	je     80106b50 <mappages+0xd0>
    a += PGSIZE;
80106ae1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106aea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106aed:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106af0:	89 d8                	mov    %ebx,%eax
80106af2:	c1 e8 16             	shr    $0x16,%eax
80106af5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106af8:	8b 07                	mov    (%edi),%eax
80106afa:	a8 01                	test   $0x1,%al
80106afc:	75 b2                	jne    80106ab0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106afe:	e8 ad bd ff ff       	call   801028b0 <kalloc>
80106b03:	85 c0                	test   %eax,%eax
80106b05:	74 39                	je     80106b40 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b07:	83 ec 04             	sub    $0x4,%esp
80106b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b0d:	68 00 10 00 00       	push   $0x1000
80106b12:	6a 00                	push   $0x0
80106b14:	50                   	push   %eax
80106b15:	e8 76 dd ff ff       	call   80104890 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b1d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b20:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b26:	83 c8 07             	or     $0x7,%eax
80106b29:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b2b:	89 d8                	mov    %ebx,%eax
80106b2d:	c1 e8 0a             	shr    $0xa,%eax
80106b30:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b35:	01 d0                	add    %edx,%eax
80106b37:	eb 92                	jmp    80106acb <mappages+0x4b>
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b48:	5b                   	pop    %ebx
80106b49:	5e                   	pop    %esi
80106b4a:	5f                   	pop    %edi
80106b4b:	5d                   	pop    %ebp
80106b4c:	c3                   	ret    
80106b4d:	8d 76 00             	lea    0x0(%esi),%esi
80106b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b53:	31 c0                	xor    %eax,%eax
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret    
      panic("remap");
80106b5a:	83 ec 0c             	sub    $0xc,%esp
80106b5d:	68 68 7c 10 80       	push   $0x80107c68
80106b62:	e8 19 98 ff ff       	call   80100380 <panic>
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <seginit>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b76:	e8 05 d0 ff ff       	call   80103b80 <cpuid>
  pd[0] = size-1;
80106b7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b8a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106b91:	ff 00 00 
80106b94:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106b9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b9e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106ba5:	ff 00 00 
80106ba8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106baf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bb2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106bb9:	ff 00 00 
80106bbc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106bc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bc6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106bcd:	ff 00 00 
80106bd0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106bd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bda:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106bdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106be3:	c1 e8 10             	shr    $0x10,%eax
80106be6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bed:	0f 01 10             	lgdtl  (%eax)
}
80106bf0:	c9                   	leave  
80106bf1:	c3                   	ret    
80106bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c00:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106c05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c0a:	0f 22 d8             	mov    %eax,%cr3
}
80106c0d:	c3                   	ret    
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <switchuvm>:
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	83 ec 1c             	sub    $0x1c,%esp
80106c19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c1c:	85 f6                	test   %esi,%esi
80106c1e:	0f 84 cb 00 00 00    	je     80106cef <switchuvm+0xdf>
  if(p->kstack == 0)
80106c24:	8b 46 08             	mov    0x8(%esi),%eax
80106c27:	85 c0                	test   %eax,%eax
80106c29:	0f 84 da 00 00 00    	je     80106d09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c2f:	8b 46 04             	mov    0x4(%esi),%eax
80106c32:	85 c0                	test   %eax,%eax
80106c34:	0f 84 c2 00 00 00    	je     80106cfc <switchuvm+0xec>
  pushcli();
80106c3a:	e8 41 da ff ff       	call   80104680 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c3f:	e8 dc ce ff ff       	call   80103b20 <mycpu>
80106c44:	89 c3                	mov    %eax,%ebx
80106c46:	e8 d5 ce ff ff       	call   80103b20 <mycpu>
80106c4b:	89 c7                	mov    %eax,%edi
80106c4d:	e8 ce ce ff ff       	call   80103b20 <mycpu>
80106c52:	83 c7 08             	add    $0x8,%edi
80106c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c58:	e8 c3 ce ff ff       	call   80103b20 <mycpu>
80106c5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c60:	ba 67 00 00 00       	mov    $0x67,%edx
80106c65:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c6c:	83 c0 08             	add    $0x8,%eax
80106c6f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c7b:	83 c1 08             	add    $0x8,%ecx
80106c7e:	c1 e8 18             	shr    $0x18,%eax
80106c81:	c1 e9 10             	shr    $0x10,%ecx
80106c84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c8a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c95:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ca1:	e8 7a ce ff ff       	call   80103b20 <mycpu>
80106ca6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cad:	e8 6e ce ff ff       	call   80103b20 <mycpu>
80106cb2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cb6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106cb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cbf:	e8 5c ce ff ff       	call   80103b20 <mycpu>
80106cc4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cc7:	e8 54 ce ff ff       	call   80103b20 <mycpu>
80106ccc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106cd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cd8:	8b 46 04             	mov    0x4(%esi),%eax
80106cdb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ce0:	0f 22 d8             	mov    %eax,%cr3
}
80106ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce6:	5b                   	pop    %ebx
80106ce7:	5e                   	pop    %esi
80106ce8:	5f                   	pop    %edi
80106ce9:	5d                   	pop    %ebp
  popcli();
80106cea:	e9 e1 d9 ff ff       	jmp    801046d0 <popcli>
    panic("switchuvm: no process");
80106cef:	83 ec 0c             	sub    $0xc,%esp
80106cf2:	68 6e 7c 10 80       	push   $0x80107c6e
80106cf7:	e8 84 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106cfc:	83 ec 0c             	sub    $0xc,%esp
80106cff:	68 99 7c 10 80       	push   $0x80107c99
80106d04:	e8 77 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d09:	83 ec 0c             	sub    $0xc,%esp
80106d0c:	68 84 7c 10 80       	push   $0x80107c84
80106d11:	e8 6a 96 ff ff       	call   80100380 <panic>
80106d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi

80106d20 <inituvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d2f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d3b:	77 4b                	ja     80106d88 <inituvm+0x68>
  mem = kalloc();
80106d3d:	e8 6e bb ff ff       	call   801028b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d42:	83 ec 04             	sub    $0x4,%esp
80106d45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d4c:	6a 00                	push   $0x0
80106d4e:	50                   	push   %eax
80106d4f:	e8 3c db ff ff       	call   80104890 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d54:	58                   	pop    %eax
80106d55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d5b:	5a                   	pop    %edx
80106d5c:	6a 06                	push   $0x6
80106d5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d63:	31 d2                	xor    %edx,%edx
80106d65:	50                   	push   %eax
80106d66:	89 f8                	mov    %edi,%eax
80106d68:	e8 13 fd ff ff       	call   80106a80 <mappages>
  memmove(mem, init, sz);
80106d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d70:	89 75 10             	mov    %esi,0x10(%ebp)
80106d73:	83 c4 10             	add    $0x10,%esp
80106d76:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d79:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d7f:	5b                   	pop    %ebx
80106d80:	5e                   	pop    %esi
80106d81:	5f                   	pop    %edi
80106d82:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d83:	e9 a8 db ff ff       	jmp    80104930 <memmove>
    panic("inituvm: more than a page");
80106d88:	83 ec 0c             	sub    $0xc,%esp
80106d8b:	68 ad 7c 10 80       	push   $0x80107cad
80106d90:	e8 eb 95 ff ff       	call   80100380 <panic>
80106d95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106da0 <loaduvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 1c             	sub    $0x1c,%esp
80106da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106daf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106db4:	0f 85 bb 00 00 00    	jne    80106e75 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106dba:	01 f0                	add    %esi,%eax
80106dbc:	89 f3                	mov    %esi,%ebx
80106dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dc1:	8b 45 14             	mov    0x14(%ebp),%eax
80106dc4:	01 f0                	add    %esi,%eax
80106dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106dc9:	85 f6                	test   %esi,%esi
80106dcb:	0f 84 87 00 00 00    	je     80106e58 <loaduvm+0xb8>
80106dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106ddb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106dde:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106de0:	89 c2                	mov    %eax,%edx
80106de2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106de5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106de8:	f6 c2 01             	test   $0x1,%dl
80106deb:	75 13                	jne    80106e00 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106ded:	83 ec 0c             	sub    $0xc,%esp
80106df0:	68 c7 7c 10 80       	push   $0x80107cc7
80106df5:	e8 86 95 ff ff       	call   80100380 <panic>
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e00:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e03:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106e09:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e0e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e15:	85 c0                	test   %eax,%eax
80106e17:	74 d4                	je     80106ded <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106e19:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e1b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e1e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e28:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e2e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e31:	29 d9                	sub    %ebx,%ecx
80106e33:	05 00 00 00 80       	add    $0x80000000,%eax
80106e38:	57                   	push   %edi
80106e39:	51                   	push   %ecx
80106e3a:	50                   	push   %eax
80106e3b:	ff 75 10             	push   0x10(%ebp)
80106e3e:	e8 7d ae ff ff       	call   80101cc0 <readi>
80106e43:	83 c4 10             	add    $0x10,%esp
80106e46:	39 f8                	cmp    %edi,%eax
80106e48:	75 1e                	jne    80106e68 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e4a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e50:	89 f0                	mov    %esi,%eax
80106e52:	29 d8                	sub    %ebx,%eax
80106e54:	39 c6                	cmp    %eax,%esi
80106e56:	77 80                	ja     80106dd8 <loaduvm+0x38>
}
80106e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e5b:	31 c0                	xor    %eax,%eax
}
80106e5d:	5b                   	pop    %ebx
80106e5e:	5e                   	pop    %esi
80106e5f:	5f                   	pop    %edi
80106e60:	5d                   	pop    %ebp
80106e61:	c3                   	ret    
80106e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e70:	5b                   	pop    %ebx
80106e71:	5e                   	pop    %esi
80106e72:	5f                   	pop    %edi
80106e73:	5d                   	pop    %ebp
80106e74:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106e75:	83 ec 0c             	sub    $0xc,%esp
80106e78:	68 68 7d 10 80       	push   $0x80107d68
80106e7d:	e8 fe 94 ff ff       	call   80100380 <panic>
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <allocuvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e99:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106e9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ea2:	85 c0                	test   %eax,%eax
80106ea4:	0f 88 b6 00 00 00    	js     80106f60 <allocuvm+0xd0>
  if(newsz < oldsz)
80106eaa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106eb0:	0f 82 9a 00 00 00    	jb     80106f50 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106eb6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106ebc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106ec2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ec5:	77 44                	ja     80106f0b <allocuvm+0x7b>
80106ec7:	e9 87 00 00 00       	jmp    80106f53 <allocuvm+0xc3>
80106ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ed0:	83 ec 04             	sub    $0x4,%esp
80106ed3:	68 00 10 00 00       	push   $0x1000
80106ed8:	6a 00                	push   $0x0
80106eda:	50                   	push   %eax
80106edb:	e8 b0 d9 ff ff       	call   80104890 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ee0:	58                   	pop    %eax
80106ee1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ee7:	5a                   	pop    %edx
80106ee8:	6a 06                	push   $0x6
80106eea:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eef:	89 f2                	mov    %esi,%edx
80106ef1:	50                   	push   %eax
80106ef2:	89 f8                	mov    %edi,%eax
80106ef4:	e8 87 fb ff ff       	call   80106a80 <mappages>
80106ef9:	83 c4 10             	add    $0x10,%esp
80106efc:	85 c0                	test   %eax,%eax
80106efe:	78 78                	js     80106f78 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f00:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f06:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f09:	76 48                	jbe    80106f53 <allocuvm+0xc3>
    mem = kalloc();
80106f0b:	e8 a0 b9 ff ff       	call   801028b0 <kalloc>
80106f10:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f12:	85 c0                	test   %eax,%eax
80106f14:	75 ba                	jne    80106ed0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f16:	83 ec 0c             	sub    $0xc,%esp
80106f19:	68 e5 7c 10 80       	push   $0x80107ce5
80106f1e:	e8 8d 98 ff ff       	call   801007b0 <cprintf>
  if(newsz >= oldsz)
80106f23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f26:	83 c4 10             	add    $0x10,%esp
80106f29:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f2c:	74 32                	je     80106f60 <allocuvm+0xd0>
80106f2e:	8b 55 10             	mov    0x10(%ebp),%edx
80106f31:	89 c1                	mov    %eax,%ecx
80106f33:	89 f8                	mov    %edi,%eax
80106f35:	e8 96 fa ff ff       	call   801069d0 <deallocuvm.part.0>
      return 0;
80106f3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f47:	5b                   	pop    %ebx
80106f48:	5e                   	pop    %esi
80106f49:	5f                   	pop    %edi
80106f4a:	5d                   	pop    %ebp
80106f4b:	c3                   	ret    
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f59:	5b                   	pop    %ebx
80106f5a:	5e                   	pop    %esi
80106f5b:	5f                   	pop    %edi
80106f5c:	5d                   	pop    %ebp
80106f5d:	c3                   	ret    
80106f5e:	66 90                	xchg   %ax,%ax
    return 0;
80106f60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f6d:	5b                   	pop    %ebx
80106f6e:	5e                   	pop    %esi
80106f6f:	5f                   	pop    %edi
80106f70:	5d                   	pop    %ebp
80106f71:	c3                   	ret    
80106f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f78:	83 ec 0c             	sub    $0xc,%esp
80106f7b:	68 fd 7c 10 80       	push   $0x80107cfd
80106f80:	e8 2b 98 ff ff       	call   801007b0 <cprintf>
  if(newsz >= oldsz)
80106f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f88:	83 c4 10             	add    $0x10,%esp
80106f8b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f8e:	74 0c                	je     80106f9c <allocuvm+0x10c>
80106f90:	8b 55 10             	mov    0x10(%ebp),%edx
80106f93:	89 c1                	mov    %eax,%ecx
80106f95:	89 f8                	mov    %edi,%eax
80106f97:	e8 34 fa ff ff       	call   801069d0 <deallocuvm.part.0>
      kfree(mem);
80106f9c:	83 ec 0c             	sub    $0xc,%esp
80106f9f:	53                   	push   %ebx
80106fa0:	e8 4b b7 ff ff       	call   801026f0 <kfree>
      return 0;
80106fa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106fac:	83 c4 10             	add    $0x10,%esp
}
80106faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb5:	5b                   	pop    %ebx
80106fb6:	5e                   	pop    %esi
80106fb7:	5f                   	pop    %edi
80106fb8:	5d                   	pop    %ebp
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <deallocuvm>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fcc:	39 d1                	cmp    %edx,%ecx
80106fce:	73 10                	jae    80106fe0 <deallocuvm+0x20>
}
80106fd0:	5d                   	pop    %ebp
80106fd1:	e9 fa f9 ff ff       	jmp    801069d0 <deallocuvm.part.0>
80106fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
80106fe0:	89 d0                	mov    %edx,%eax
80106fe2:	5d                   	pop    %ebp
80106fe3:	c3                   	ret    
80106fe4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fef:	90                   	nop

80106ff0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 0c             	sub    $0xc,%esp
80106ff9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ffc:	85 f6                	test   %esi,%esi
80106ffe:	74 59                	je     80107059 <freevm+0x69>
  if(newsz >= oldsz)
80107000:	31 c9                	xor    %ecx,%ecx
80107002:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107007:	89 f0                	mov    %esi,%eax
80107009:	89 f3                	mov    %esi,%ebx
8010700b:	e8 c0 f9 ff ff       	call   801069d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107010:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107016:	eb 0f                	jmp    80107027 <freevm+0x37>
80107018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701f:	90                   	nop
80107020:	83 c3 04             	add    $0x4,%ebx
80107023:	39 df                	cmp    %ebx,%edi
80107025:	74 23                	je     8010704a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107027:	8b 03                	mov    (%ebx),%eax
80107029:	a8 01                	test   $0x1,%al
8010702b:	74 f3                	je     80107020 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010702d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107032:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107035:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107038:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010703d:	50                   	push   %eax
8010703e:	e8 ad b6 ff ff       	call   801026f0 <kfree>
80107043:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107046:	39 df                	cmp    %ebx,%edi
80107048:	75 dd                	jne    80107027 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010704a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010704d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107050:	5b                   	pop    %ebx
80107051:	5e                   	pop    %esi
80107052:	5f                   	pop    %edi
80107053:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107054:	e9 97 b6 ff ff       	jmp    801026f0 <kfree>
    panic("freevm: no pgdir");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 19 7d 10 80       	push   $0x80107d19
80107061:	e8 1a 93 ff ff       	call   80100380 <panic>
80107066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706d:	8d 76 00             	lea    0x0(%esi),%esi

80107070 <setupkvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	56                   	push   %esi
80107074:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107075:	e8 36 b8 ff ff       	call   801028b0 <kalloc>
8010707a:	89 c6                	mov    %eax,%esi
8010707c:	85 c0                	test   %eax,%eax
8010707e:	74 42                	je     801070c2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107080:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107083:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107088:	68 00 10 00 00       	push   $0x1000
8010708d:	6a 00                	push   $0x0
8010708f:	50                   	push   %eax
80107090:	e8 fb d7 ff ff       	call   80104890 <memset>
80107095:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107098:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010709b:	83 ec 08             	sub    $0x8,%esp
8010709e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070a1:	ff 73 0c             	push   0xc(%ebx)
801070a4:	8b 13                	mov    (%ebx),%edx
801070a6:	50                   	push   %eax
801070a7:	29 c1                	sub    %eax,%ecx
801070a9:	89 f0                	mov    %esi,%eax
801070ab:	e8 d0 f9 ff ff       	call   80106a80 <mappages>
801070b0:	83 c4 10             	add    $0x10,%esp
801070b3:	85 c0                	test   %eax,%eax
801070b5:	78 19                	js     801070d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070b7:	83 c3 10             	add    $0x10,%ebx
801070ba:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070c0:	75 d6                	jne    80107098 <setupkvm+0x28>
}
801070c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070c5:	89 f0                	mov    %esi,%eax
801070c7:	5b                   	pop    %ebx
801070c8:	5e                   	pop    %esi
801070c9:	5d                   	pop    %ebp
801070ca:	c3                   	ret    
801070cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070cf:	90                   	nop
      freevm(pgdir);
801070d0:	83 ec 0c             	sub    $0xc,%esp
801070d3:	56                   	push   %esi
      return 0;
801070d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801070d6:	e8 15 ff ff ff       	call   80106ff0 <freevm>
      return 0;
801070db:	83 c4 10             	add    $0x10,%esp
}
801070de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070e1:	89 f0                	mov    %esi,%eax
801070e3:	5b                   	pop    %ebx
801070e4:	5e                   	pop    %esi
801070e5:	5d                   	pop    %ebp
801070e6:	c3                   	ret    
801070e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <kvmalloc>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070f6:	e8 75 ff ff ff       	call   80107070 <setupkvm>
801070fb:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107100:	05 00 00 00 80       	add    $0x80000000,%eax
80107105:	0f 22 d8             	mov    %eax,%cr3
}
80107108:	c9                   	leave  
80107109:	c3                   	ret    
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107110 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 08             	sub    $0x8,%esp
80107116:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107119:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010711c:	89 c1                	mov    %eax,%ecx
8010711e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107121:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107124:	f6 c2 01             	test   $0x1,%dl
80107127:	75 17                	jne    80107140 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 2a 7d 10 80       	push   $0x80107d2a
80107131:	e8 4a 92 ff ff       	call   80100380 <panic>
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107140:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107143:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107149:	25 fc 0f 00 00       	and    $0xffc,%eax
8010714e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107155:	85 c0                	test   %eax,%eax
80107157:	74 d0                	je     80107129 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107159:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010715c:	c9                   	leave  
8010715d:	c3                   	ret    
8010715e:	66 90                	xchg   %ax,%ax

80107160 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
80107166:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107169:	e8 02 ff ff ff       	call   80107070 <setupkvm>
8010716e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107171:	85 c0                	test   %eax,%eax
80107173:	0f 84 bd 00 00 00    	je     80107236 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010717c:	85 c9                	test   %ecx,%ecx
8010717e:	0f 84 b2 00 00 00    	je     80107236 <copyuvm+0xd6>
80107184:	31 f6                	xor    %esi,%esi
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107190:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107193:	89 f0                	mov    %esi,%eax
80107195:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107198:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010719b:	a8 01                	test   $0x1,%al
8010719d:	75 11                	jne    801071b0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010719f:	83 ec 0c             	sub    $0xc,%esp
801071a2:	68 34 7d 10 80       	push   $0x80107d34
801071a7:	e8 d4 91 ff ff       	call   80100380 <panic>
801071ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801071b0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071b7:	c1 ea 0a             	shr    $0xa,%edx
801071ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071c7:	85 c0                	test   %eax,%eax
801071c9:	74 d4                	je     8010719f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801071cb:	8b 00                	mov    (%eax),%eax
801071cd:	a8 01                	test   $0x1,%al
801071cf:	0f 84 9f 00 00 00    	je     80107274 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071d5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801071d7:	25 ff 0f 00 00       	and    $0xfff,%eax
801071dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801071df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801071e5:	e8 c6 b6 ff ff       	call   801028b0 <kalloc>
801071ea:	89 c3                	mov    %eax,%ebx
801071ec:	85 c0                	test   %eax,%eax
801071ee:	74 64                	je     80107254 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071f0:	83 ec 04             	sub    $0x4,%esp
801071f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071f9:	68 00 10 00 00       	push   $0x1000
801071fe:	57                   	push   %edi
801071ff:	50                   	push   %eax
80107200:	e8 2b d7 ff ff       	call   80104930 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107205:	58                   	pop    %eax
80107206:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010720c:	5a                   	pop    %edx
8010720d:	ff 75 e4             	push   -0x1c(%ebp)
80107210:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107215:	89 f2                	mov    %esi,%edx
80107217:	50                   	push   %eax
80107218:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010721b:	e8 60 f8 ff ff       	call   80106a80 <mappages>
80107220:	83 c4 10             	add    $0x10,%esp
80107223:	85 c0                	test   %eax,%eax
80107225:	78 21                	js     80107248 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107227:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010722d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107230:	0f 87 5a ff ff ff    	ja     80107190 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107236:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107239:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723c:	5b                   	pop    %ebx
8010723d:	5e                   	pop    %esi
8010723e:	5f                   	pop    %edi
8010723f:	5d                   	pop    %ebp
80107240:	c3                   	ret    
80107241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107248:	83 ec 0c             	sub    $0xc,%esp
8010724b:	53                   	push   %ebx
8010724c:	e8 9f b4 ff ff       	call   801026f0 <kfree>
      goto bad;
80107251:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107254:	83 ec 0c             	sub    $0xc,%esp
80107257:	ff 75 e0             	push   -0x20(%ebp)
8010725a:	e8 91 fd ff ff       	call   80106ff0 <freevm>
  return 0;
8010725f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107266:	83 c4 10             	add    $0x10,%esp
}
80107269:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010726c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726f:	5b                   	pop    %ebx
80107270:	5e                   	pop    %esi
80107271:	5f                   	pop    %edi
80107272:	5d                   	pop    %ebp
80107273:	c3                   	ret    
      panic("copyuvm: page not present");
80107274:	83 ec 0c             	sub    $0xc,%esp
80107277:	68 4e 7d 10 80       	push   $0x80107d4e
8010727c:	e8 ff 90 ff ff       	call   80100380 <panic>
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728f:	90                   	nop

80107290 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107296:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107299:	89 c1                	mov    %eax,%ecx
8010729b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010729e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072a1:	f6 c2 01             	test   $0x1,%dl
801072a4:	0f 84 00 01 00 00    	je     801073aa <uva2ka.cold>
  return &pgtab[PTX(va)];
801072aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801072b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801072b9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801072c0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072c7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072ca:	05 00 00 00 80       	add    $0x80000000,%eax
801072cf:	83 fa 05             	cmp    $0x5,%edx
801072d2:	ba 00 00 00 00       	mov    $0x0,%edx
801072d7:	0f 45 c2             	cmovne %edx,%eax
}
801072da:	c3                   	ret    
801072db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072df:	90                   	nop

801072e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 0c             	sub    $0xc,%esp
801072e9:	8b 75 14             	mov    0x14(%ebp),%esi
801072ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072f2:	85 f6                	test   %esi,%esi
801072f4:	75 51                	jne    80107347 <copyout+0x67>
801072f6:	e9 a5 00 00 00       	jmp    801073a0 <copyout+0xc0>
801072fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072ff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107300:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107306:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010730c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107312:	74 75                	je     80107389 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107314:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107316:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107319:	29 c3                	sub    %eax,%ebx
8010731b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107321:	39 f3                	cmp    %esi,%ebx
80107323:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107326:	29 f8                	sub    %edi,%eax
80107328:	83 ec 04             	sub    $0x4,%esp
8010732b:	01 c1                	add    %eax,%ecx
8010732d:	53                   	push   %ebx
8010732e:	52                   	push   %edx
8010732f:	51                   	push   %ecx
80107330:	e8 fb d5 ff ff       	call   80104930 <memmove>
    len -= n;
    buf += n;
80107335:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107338:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010733e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107341:	01 da                	add    %ebx,%edx
  while(len > 0){
80107343:	29 de                	sub    %ebx,%esi
80107345:	74 59                	je     801073a0 <copyout+0xc0>
  if(*pde & PTE_P){
80107347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010734a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010734c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010734e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107351:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107357:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010735a:	f6 c1 01             	test   $0x1,%cl
8010735d:	0f 84 4e 00 00 00    	je     801073b1 <copyout.cold>
  return &pgtab[PTX(va)];
80107363:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107365:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010736b:	c1 eb 0c             	shr    $0xc,%ebx
8010736e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107374:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010737b:	89 d9                	mov    %ebx,%ecx
8010737d:	83 e1 05             	and    $0x5,%ecx
80107380:	83 f9 05             	cmp    $0x5,%ecx
80107383:	0f 84 77 ff ff ff    	je     80107300 <copyout+0x20>
  }
  return 0;
}
80107389:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010738c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107391:	5b                   	pop    %ebx
80107392:	5e                   	pop    %esi
80107393:	5f                   	pop    %edi
80107394:	5d                   	pop    %ebp
80107395:	c3                   	ret    
80107396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739d:	8d 76 00             	lea    0x0(%esi),%esi
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073a3:	31 c0                	xor    %eax,%eax
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    

801073aa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801073aa:	a1 00 00 00 00       	mov    0x0,%eax
801073af:	0f 0b                	ud2    

801073b1 <copyout.cold>:
801073b1:	a1 00 00 00 00       	mov    0x0,%eax
801073b6:	0f 0b                	ud2    
