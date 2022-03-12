
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc f0 69 11 80       	mov    $0x801169f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 38 10 80       	mov    $0x80103810,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 79 10 80       	push   $0x80107940
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 4b 00 00       	call   80104b80 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
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
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 79 10 80       	push   $0x80107947
80100097:	50                   	push   %eax
80100098:	e8 b3 49 00 00       	call   80104a50 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 67 4c 00 00       	call   80104d50 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 89 4b 00 00       	call   80104cf0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 49 00 00       	call   80104a90 <acquiresleep>
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
8010018c:	e8 ff 28 00 00       	call   80102a90 <iderw>
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
801001a1:	68 4e 79 10 80       	push   $0x8010794e
801001a6:	e8 a5 02 00 00       	call   80100450 <panic>
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
801001be:	e8 6d 49 00 00       	call   80104b30 <holdingsleep>
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
801001d4:	e9 b7 28 00 00       	jmp    80102a90 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 79 10 80       	push   $0x8010795f
801001e1:	e8 6a 02 00 00       	call   80100450 <panic>
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
801001ff:	e8 2c 49 00 00       	call   80104b30 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 48 00 00       	call   80104af0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 30 4b 00 00       	call   80104d50 <acquire>
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
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 7f 4a 00 00       	jmp    80104cf0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 79 10 80       	push   $0x80107966
80100279:	e8 d2 01 00 00       	call   80100450 <panic>
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
80100294:	e8 77 1d 00 00       	call   80102010 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
801002a0:	e8 ab 4a 00 00       	call   80104d50 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
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
801002c3:	68 40 04 11 80       	push   $0x80110440
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 45 00 00       	call   801047f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 3e 00 00       	call   80104120 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 04 11 80       	push   $0x80110440
801002f6:	e8 f5 49 00 00       	call   80104cf0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 2c 1c 00 00       	call   80101f30 <ilock>
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
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
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
80100347:	68 40 04 11 80       	push   $0x80110440
8010034c:	e8 9f 49 00 00       	call   80104cf0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 d6 1b 00 00       	call   80101f30 <ilock>
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
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <addHistory.part.0>:
void addHistory(char *command){
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	57                   	push   %edi
80100384:	56                   	push   %esi
80100385:	89 c6                	mov    %eax,%esi
80100387:	53                   	push   %ebx
80100388:	83 ec 28             	sub    $0x28,%esp
    int length = strlen(command) <= INPUT_BUF ? strlen(command) : INPUT_BUF-1;
8010038b:	50                   	push   %eax
8010038c:	e8 7f 4c 00 00       	call   80105010 <strlen>
80100391:	c7 45 e0 7f 00 00 00 	movl   $0x7f,-0x20(%ebp)
80100398:	83 c4 10             	add    $0x10,%esp
8010039b:	c7 45 e4 7f 00 00 00 	movl   $0x7f,-0x1c(%ebp)
801003a2:	3d 80 00 00 00       	cmp    $0x80,%eax
801003a7:	0f 8e 8b 00 00 00    	jle    80100438 <addHistory.part.0+0xb8>
    if(commandHistoryCounter < 10){
801003ad:	a1 28 04 11 80       	mov    0x80110428,%eax
801003b2:	83 f8 09             	cmp    $0x9,%eax
801003b5:	7f 49                	jg     80100400 <addHistory.part.0+0x80>
      commandHistoryCounter++;
801003b7:	8d 50 01             	lea    0x1(%eax),%edx
801003ba:	89 15 28 04 11 80    	mov    %edx,0x80110428
    memmove(history[commandHistoryCounter-1], command, sizeof(char)* length);
801003c0:	c1 e0 07             	shl    $0x7,%eax
801003c3:	83 ec 04             	sub    $0x4,%esp
801003c6:	ff 75 e0             	push   -0x20(%ebp)
801003c9:	05 20 ff 10 80       	add    $0x8010ff20,%eax
801003ce:	56                   	push   %esi
801003cf:	50                   	push   %eax
801003d0:	e8 db 4a 00 00       	call   80104eb0 <memmove>
    history[commandHistoryCounter-1][length] = '\0';
801003d5:	a1 28 04 11 80       	mov    0x80110428,%eax
801003da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
}
801003dd:	83 c4 10             	add    $0x10,%esp
    history[commandHistoryCounter-1][length] = '\0';
801003e0:	83 e8 01             	sub    $0x1,%eax
801003e3:	89 c2                	mov    %eax,%edx
    curr_index = commandHistoryCounter - 1;
801003e5:	a3 10 ff 10 80       	mov    %eax,0x8010ff10
    history[commandHistoryCounter-1][length] = '\0';
801003ea:	c1 e2 07             	shl    $0x7,%edx
801003ed:	c6 84 11 20 ff 10 80 	movb   $0x0,-0x7fef00e0(%ecx,%edx,1)
801003f4:	00 
}
801003f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801003f8:	5b                   	pop    %ebx
801003f9:	5e                   	pop    %esi
801003fa:	5f                   	pop    %edi
801003fb:	5d                   	pop    %ebp
801003fc:	c3                   	ret    
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
80100400:	bf 20 ff 10 80       	mov    $0x8010ff20,%edi
80100405:	bb 20 04 11 80       	mov    $0x80110420,%ebx
8010040a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        memmove(history[i], history[i+1], sizeof(char)* INPUT_BUF);
80100410:	83 ec 04             	sub    $0x4,%esp
80100413:	89 f8                	mov    %edi,%eax
80100415:	83 ef 80             	sub    $0xffffff80,%edi
80100418:	68 80 00 00 00       	push   $0x80
8010041d:	57                   	push   %edi
8010041e:	50                   	push   %eax
8010041f:	e8 8c 4a 00 00       	call   80104eb0 <memmove>
      for(i = 0; i < 10 ; i++){
80100424:	83 c4 10             	add    $0x10,%esp
80100427:	39 fb                	cmp    %edi,%ebx
80100429:	75 e5                	jne    80100410 <addHistory.part.0+0x90>
    memmove(history[commandHistoryCounter-1], command, sizeof(char)* length);
8010042b:	a1 28 04 11 80       	mov    0x80110428,%eax
80100430:	83 e8 01             	sub    $0x1,%eax
80100433:	eb 8b                	jmp    801003c0 <addHistory.part.0+0x40>
80100435:	8d 76 00             	lea    0x0(%esi),%esi
    int length = strlen(command) <= INPUT_BUF ? strlen(command) : INPUT_BUF-1;
80100438:	83 ec 0c             	sub    $0xc,%esp
8010043b:	56                   	push   %esi
8010043c:	e8 cf 4b 00 00       	call   80105010 <strlen>
80100441:	83 c4 10             	add    $0x10,%esp
80100444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    memmove(history[commandHistoryCounter-1], command, sizeof(char)* length);
80100447:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010044a:	e9 5e ff ff ff       	jmp    801003ad <addHistory.part.0+0x2d>
8010044f:	90                   	nop

80100450 <panic>:
{
80100450:	55                   	push   %ebp
80100451:	89 e5                	mov    %esp,%ebp
80100453:	56                   	push   %esi
80100454:	53                   	push   %ebx
80100455:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100458:	fa                   	cli    
  cons.locking = 0;
80100459:	c7 05 74 04 11 80 00 	movl   $0x0,0x80110474
80100460:	00 00 00 
  getcallerpcs(&s, pcs);
80100463:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100466:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100469:	e8 32 2c 00 00       	call   801030a0 <lapicid>
8010046e:	83 ec 08             	sub    $0x8,%esp
80100471:	50                   	push   %eax
80100472:	68 6d 79 10 80       	push   $0x8010796d
80100477:	e8 04 04 00 00       	call   80100880 <cprintf>
  cprintf(s);
8010047c:	58                   	pop    %eax
8010047d:	ff 75 08             	push   0x8(%ebp)
80100480:	e8 fb 03 00 00       	call   80100880 <cprintf>
  cprintf("\n");
80100485:	c7 04 24 97 82 10 80 	movl   $0x80108297,(%esp)
8010048c:	e8 ef 03 00 00       	call   80100880 <cprintf>
  getcallerpcs(&s, pcs);
80100491:	8d 45 08             	lea    0x8(%ebp),%eax
80100494:	5a                   	pop    %edx
80100495:	59                   	pop    %ecx
80100496:	53                   	push   %ebx
80100497:	50                   	push   %eax
80100498:	e8 03 47 00 00       	call   80104ba0 <getcallerpcs>
  for(i=0; i<10; i++)
8010049d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004a0:	83 ec 08             	sub    $0x8,%esp
801004a3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801004a5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801004a8:	68 81 79 10 80       	push   $0x80107981
801004ad:	e8 ce 03 00 00       	call   80100880 <cprintf>
  for(i=0; i<10; i++)
801004b2:	83 c4 10             	add    $0x10,%esp
801004b5:	39 f3                	cmp    %esi,%ebx
801004b7:	75 e7                	jne    801004a0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004b9:	c7 05 78 04 11 80 01 	movl   $0x1,0x80110478
801004c0:	00 00 00 
  for(;;)
801004c3:	eb fe                	jmp    801004c3 <panic+0x73>
801004c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801004d0 <cgaputc>:
{
801004d0:	55                   	push   %ebp
801004d1:	89 e5                	mov    %esp,%ebp
801004d3:	57                   	push   %edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004d4:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004d9:	56                   	push   %esi
801004da:	89 fa                	mov    %edi,%edx
801004dc:	53                   	push   %ebx
801004dd:	89 c3                	mov    %eax,%ebx
801004df:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e4:	83 ec 1c             	sub    $0x1c,%esp
801004e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004e8:	be d5 03 00 00       	mov    $0x3d5,%esi
801004ed:	89 f2                	mov    %esi,%edx
801004ef:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801004f0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004f3:	89 fa                	mov    %edi,%edx
801004f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004fa:	c1 e1 08             	shl    $0x8,%ecx
801004fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004fe:	89 f2                	mov    %esi,%edx
80100500:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100501:	0f b6 f8             	movzbl %al,%edi
80100504:	09 cf                	or     %ecx,%edi
  if(c == '\n'){
80100506:	83 fb 0a             	cmp    $0xa,%ebx
80100509:	0f 84 f1 00 00 00    	je     80100600 <cgaputc+0x130>
  else if(c == BACKSPACE){
8010050f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100515:	0f 84 cd 00 00 00    	je     801005e8 <cgaputc+0x118>
  } else if (c == LEFT_ARROW) {
8010051b:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100521:	0f 84 69 01 00 00    	je     80100690 <cgaputc+0x1c0>
    if(back_counter > 0) {
80100527:	a1 24 04 11 80       	mov    0x80110424,%eax
  } else if (c == RIGHT_ARROW) {
8010052c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100532:	0f 84 38 01 00 00    	je     80100670 <cgaputc+0x1a0>
    for(int i = pos + back_counter; i >= pos; i--){
80100538:	01 f8                	add    %edi,%eax
8010053a:	39 c7                	cmp    %eax,%edi
8010053c:	7f 20                	jg     8010055e <cgaputc+0x8e>
8010053e:	8d 8c 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%ecx
80100545:	8d 94 3f fe 7f 0b 80 	lea    -0x7ff48002(%edi,%edi,1),%edx
8010054c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      crt[i+1] = crt[i];
80100550:	0f b7 01             	movzwl (%ecx),%eax
    for(int i = pos + back_counter; i >= pos; i--){
80100553:	83 e9 02             	sub    $0x2,%ecx
      crt[i+1] = crt[i];
80100556:	66 89 41 04          	mov    %ax,0x4(%ecx)
    for(int i = pos + back_counter; i >= pos; i--){
8010055a:	39 ca                	cmp    %ecx,%edx
8010055c:	75 f2                	jne    80100550 <cgaputc+0x80>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010055e:	0f b6 c3             	movzbl %bl,%eax
80100561:	8d 77 01             	lea    0x1(%edi),%esi
80100564:	80 cc 07             	or     $0x7,%ah
80100567:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
8010056e:	80 
  if(pos < 0 || pos > 25*80)
8010056f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100575:	0f 87 4c 01 00 00    	ja     801006c7 <cgaputc+0x1f7>
  if((pos/80) >= 24){  // Scroll up.
8010057b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100581:	0f 8f 99 00 00 00    	jg     80100620 <cgaputc+0x150>
  outb(CRTPORT+1, pos>>8);
80100587:	89 f0                	mov    %esi,%eax
80100589:	0f b6 c4             	movzbl %ah,%eax
8010058c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  outb(CRTPORT+1, pos);
8010058f:	89 f0                	mov    %esi,%eax
80100591:	88 45 e7             	mov    %al,-0x19(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100594:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100599:	b8 0e 00 00 00       	mov    $0xe,%eax
8010059e:	89 fa                	mov    %edi,%edx
801005a0:	ee                   	out    %al,(%dx)
801005a1:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801005a6:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
801005aa:	89 ca                	mov    %ecx,%edx
801005ac:	ee                   	out    %al,(%dx)
801005ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801005b2:	89 fa                	mov    %edi,%edx
801005b4:	ee                   	out    %al,(%dx)
801005b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801005b9:	89 ca                	mov    %ecx,%edx
801005bb:	ee                   	out    %al,(%dx)
  if(c != LEFT_ARROW && c != RIGHT_ARROW)
801005bc:	81 eb e4 00 00 00    	sub    $0xe4,%ebx
801005c2:	83 fb 01             	cmp    $0x1,%ebx
801005c5:	76 13                	jbe    801005da <cgaputc+0x10a>
    crt[pos+back_counter] = ' ' | 0x0700;
801005c7:	03 35 24 04 11 80    	add    0x80110424,%esi
801005cd:	b8 20 07 00 00       	mov    $0x720,%eax
801005d2:	66 89 84 36 00 80 0b 	mov    %ax,-0x7ff48000(%esi,%esi,1)
801005d9:	80 
}
801005da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005dd:	5b                   	pop    %ebx
801005de:	5e                   	pop    %esi
801005df:	5f                   	pop    %edi
801005e0:	5d                   	pop    %ebp
801005e1:	c3                   	ret    
801005e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pos > 0) --pos;
801005e8:	8d 77 ff             	lea    -0x1(%edi),%esi
801005eb:	85 ff                	test   %edi,%edi
801005ed:	75 80                	jne    8010056f <cgaputc+0x9f>
801005ef:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801005f3:	31 f6                	xor    %esi,%esi
801005f5:	c6 45 e0 00          	movb   $0x0,-0x20(%ebp)
801005f9:	eb 99                	jmp    80100594 <cgaputc+0xc4>
801005fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801005ff:	90                   	nop
    pos += 80 - pos%80;
80100600:	89 f8                	mov    %edi,%eax
80100602:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100607:	f7 e2                	mul    %edx
80100609:	c1 ea 06             	shr    $0x6,%edx
8010060c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010060f:	c1 e0 04             	shl    $0x4,%eax
80100612:	8d 70 50             	lea    0x50(%eax),%esi
80100615:	e9 55 ff ff ff       	jmp    8010056f <cgaputc+0x9f>
8010061a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100620:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100623:	83 ee 50             	sub    $0x50,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100626:	68 60 0e 00 00       	push   $0xe60
8010062b:	68 a0 80 0b 80       	push   $0x800b80a0
80100630:	68 00 80 0b 80       	push   $0x800b8000
80100635:	e8 76 48 00 00       	call   80104eb0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010063a:	b8 80 07 00 00       	mov    $0x780,%eax
8010063f:	83 c4 0c             	add    $0xc,%esp
80100642:	29 f0                	sub    %esi,%eax
80100644:	01 c0                	add    %eax,%eax
80100646:	50                   	push   %eax
80100647:	8d 84 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%eax
8010064e:	6a 00                	push   $0x0
80100650:	50                   	push   %eax
80100651:	e8 ba 47 00 00       	call   80104e10 <memset>
  outb(CRTPORT+1, pos);
80100656:	89 f0                	mov    %esi,%eax
80100658:	c6 45 e0 07          	movb   $0x7,-0x20(%ebp)
8010065c:	83 c4 10             	add    $0x10,%esp
8010065f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100662:	e9 2d ff ff ff       	jmp    80100594 <cgaputc+0xc4>
80100667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010066e:	66 90                	xchg   %ax,%ax
  pos |= inb(CRTPORT+1);
80100670:	89 fe                	mov    %edi,%esi
    if(back_counter > 0) {
80100672:	85 c0                	test   %eax,%eax
80100674:	0f 8e f5 fe ff ff    	jle    8010056f <cgaputc+0x9f>
      back_counter--;
8010067a:	83 e8 01             	sub    $0x1,%eax
      ++pos;
8010067d:	83 c6 01             	add    $0x1,%esi
      back_counter--;
80100680:	a3 24 04 11 80       	mov    %eax,0x80110424
80100685:	e9 e5 fe ff ff       	jmp    8010056f <cgaputc+0x9f>
8010068a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(back_counter < (strlen(input.buf) - backspaces)) {
80100690:	83 ec 0c             	sub    $0xc,%esp
  pos |= inb(CRTPORT+1);
80100693:	89 fe                	mov    %edi,%esi
    if(back_counter < (strlen(input.buf) - backspaces)) {
80100695:	68 80 fe 10 80       	push   $0x8010fe80
8010069a:	e8 71 49 00 00       	call   80105010 <strlen>
8010069f:	8b 15 24 04 11 80    	mov    0x80110424,%edx
801006a5:	2b 05 20 04 11 80    	sub    0x80110420,%eax
801006ab:	83 c4 10             	add    $0x10,%esp
801006ae:	39 d0                	cmp    %edx,%eax
801006b0:	0f 8e b9 fe ff ff    	jle    8010056f <cgaputc+0x9f>
      back_counter++;
801006b6:	83 c2 01             	add    $0x1,%edx
      --pos;
801006b9:	83 ee 01             	sub    $0x1,%esi
      back_counter++;
801006bc:	89 15 24 04 11 80    	mov    %edx,0x80110424
801006c2:	e9 a8 fe ff ff       	jmp    8010056f <cgaputc+0x9f>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 85 79 10 80       	push   $0x80107985
801006cf:	e8 7c fd ff ff       	call   80100450 <panic>
801006d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006df:	90                   	nop

801006e0 <consputc>:
  if(panicked){
801006e0:	8b 15 78 04 11 80    	mov    0x80110478,%edx
801006e6:	85 d2                	test   %edx,%edx
801006e8:	74 06                	je     801006f0 <consputc+0x10>
  asm volatile("cli");
801006ea:	fa                   	cli    
    for(;;)
801006eb:	eb fe                	jmp    801006eb <consputc+0xb>
801006ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	53                   	push   %ebx
801006f4:	89 c3                	mov    %eax,%ebx
801006f6:	83 ec 04             	sub    $0x4,%esp
  if(c == BACKSPACE){
801006f9:	3d 00 01 00 00       	cmp    $0x100,%eax
801006fe:	74 17                	je     80100717 <consputc+0x37>
    uartputc(c);
80100700:	83 ec 0c             	sub    $0xc,%esp
80100703:	50                   	push   %eax
80100704:	e8 57 5d 00 00       	call   80106460 <uartputc>
80100709:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010070c:	89 d8                	mov    %ebx,%eax
}
8010070e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100711:	c9                   	leave  
  cgaputc(c);
80100712:	e9 b9 fd ff ff       	jmp    801004d0 <cgaputc>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100717:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
8010071a:	83 05 20 04 11 80 01 	addl   $0x1,0x80110420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100721:	6a 08                	push   $0x8
80100723:	e8 38 5d 00 00       	call   80106460 <uartputc>
80100728:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010072f:	e8 2c 5d 00 00       	call   80106460 <uartputc>
80100734:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010073b:	e8 20 5d 00 00       	call   80106460 <uartputc>
80100740:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100743:	89 d8                	mov    %ebx,%eax
}
80100745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100748:	c9                   	leave  
  cgaputc(c);
80100749:	e9 82 fd ff ff       	jmp    801004d0 <cgaputc>
8010074e:	66 90                	xchg   %ax,%ax

80100750 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	57                   	push   %edi
80100754:	56                   	push   %esi
80100755:	53                   	push   %ebx
80100756:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100759:	ff 75 08             	push   0x8(%ebp)
{
8010075c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010075f:	e8 ac 18 00 00       	call   80102010 <iunlock>
  acquire(&cons.lock);
80100764:	c7 04 24 40 04 11 80 	movl   $0x80110440,(%esp)
8010076b:	e8 e0 45 00 00       	call   80104d50 <acquire>
  for(i = 0; i < n; i++)
80100770:	83 c4 10             	add    $0x10,%esp
80100773:	85 f6                	test   %esi,%esi
80100775:	7e 37                	jle    801007ae <consolewrite+0x5e>
80100777:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010077a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010077d:	8b 15 78 04 11 80    	mov    0x80110478,%edx
    consputc(buf[i] & 0xff);
80100783:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100786:	85 d2                	test   %edx,%edx
80100788:	74 06                	je     80100790 <consolewrite+0x40>
8010078a:	fa                   	cli    
    for(;;)
8010078b:	eb fe                	jmp    8010078b <consolewrite+0x3b>
8010078d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100790:	83 ec 0c             	sub    $0xc,%esp
80100793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < n; i++)
80100796:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100799:	50                   	push   %eax
8010079a:	e8 c1 5c 00 00       	call   80106460 <uartputc>
  cgaputc(c);
8010079f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007a2:	e8 29 fd ff ff       	call   801004d0 <cgaputc>
  for(i = 0; i < n; i++)
801007a7:	83 c4 10             	add    $0x10,%esp
801007aa:	39 df                	cmp    %ebx,%edi
801007ac:	75 cf                	jne    8010077d <consolewrite+0x2d>
  release(&cons.lock);
801007ae:	83 ec 0c             	sub    $0xc,%esp
801007b1:	68 40 04 11 80       	push   $0x80110440
801007b6:	e8 35 45 00 00       	call   80104cf0 <release>
  ilock(ip);
801007bb:	58                   	pop    %eax
801007bc:	ff 75 08             	push   0x8(%ebp)
801007bf:	e8 6c 17 00 00       	call   80101f30 <ilock>

  return n;
}
801007c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007c7:	89 f0                	mov    %esi,%eax
801007c9:	5b                   	pop    %ebx
801007ca:	5e                   	pop    %esi
801007cb:	5f                   	pop    %edi
801007cc:	5d                   	pop    %ebp
801007cd:	c3                   	ret    
801007ce:	66 90                	xchg   %ax,%ax

801007d0 <printint>:
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	57                   	push   %edi
801007d4:	56                   	push   %esi
801007d5:	53                   	push   %ebx
801007d6:	83 ec 2c             	sub    $0x2c,%esp
801007d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801007dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801007df:	85 c9                	test   %ecx,%ecx
801007e1:	74 04                	je     801007e7 <printint+0x17>
801007e3:	85 c0                	test   %eax,%eax
801007e5:	78 7e                	js     80100865 <printint+0x95>
    x = xx;
801007e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801007ee:	89 c1                	mov    %eax,%ecx
  i = 0;
801007f0:	31 db                	xor    %ebx,%ebx
801007f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
801007f8:	89 c8                	mov    %ecx,%eax
801007fa:	31 d2                	xor    %edx,%edx
801007fc:	89 de                	mov    %ebx,%esi
801007fe:	89 cf                	mov    %ecx,%edi
80100800:	f7 75 d4             	divl   -0x2c(%ebp)
80100803:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100806:	0f b6 92 b0 79 10 80 	movzbl -0x7fef8650(%edx),%edx
  }while((x /= base) != 0);
8010080d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010080f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100813:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
80100816:	76 e0                	jbe    801007f8 <printint+0x28>
  if(sign)
80100818:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010081b:	85 c9                	test   %ecx,%ecx
8010081d:	74 0c                	je     8010082b <printint+0x5b>
    buf[i++] = '-';
8010081f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100824:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100826:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010082b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010082f:	a1 78 04 11 80       	mov    0x80110478,%eax
80100834:	85 c0                	test   %eax,%eax
80100836:	74 08                	je     80100840 <printint+0x70>
80100838:	fa                   	cli    
    for(;;)
80100839:	eb fe                	jmp    80100839 <printint+0x69>
8010083b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010083f:	90                   	nop
    consputc(buf[i]);
80100840:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100843:	83 ec 0c             	sub    $0xc,%esp
80100846:	56                   	push   %esi
80100847:	e8 14 5c 00 00       	call   80106460 <uartputc>
  cgaputc(c);
8010084c:	89 f0                	mov    %esi,%eax
8010084e:	e8 7d fc ff ff       	call   801004d0 <cgaputc>
  while(--i >= 0)
80100853:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100856:	83 c4 10             	add    $0x10,%esp
80100859:	39 c3                	cmp    %eax,%ebx
8010085b:	74 0e                	je     8010086b <printint+0x9b>
    consputc(buf[i]);
8010085d:	0f b6 13             	movzbl (%ebx),%edx
80100860:	83 eb 01             	sub    $0x1,%ebx
80100863:	eb ca                	jmp    8010082f <printint+0x5f>
    x = -xx;
80100865:	f7 d8                	neg    %eax
80100867:	89 c1                	mov    %eax,%ecx
80100869:	eb 85                	jmp    801007f0 <printint+0x20>
}
8010086b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086e:	5b                   	pop    %ebx
8010086f:	5e                   	pop    %esi
80100870:	5f                   	pop    %edi
80100871:	5d                   	pop    %ebp
80100872:	c3                   	ret    
80100873:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010087a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100880 <cprintf>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
80100885:	53                   	push   %ebx
80100886:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100889:	a1 74 04 11 80       	mov    0x80110474,%eax
8010088e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100891:	85 c0                	test   %eax,%eax
80100893:	0f 85 37 01 00 00    	jne    801009d0 <cprintf+0x150>
  if (fmt == 0)
80100899:	8b 75 08             	mov    0x8(%ebp),%esi
8010089c:	85 f6                	test   %esi,%esi
8010089e:	0f 84 32 02 00 00    	je     80100ad6 <cprintf+0x256>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008a4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801008a7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008aa:	31 db                	xor    %ebx,%ebx
801008ac:	85 c0                	test   %eax,%eax
801008ae:	74 56                	je     80100906 <cprintf+0x86>
    if(c != '%'){
801008b0:	83 f8 25             	cmp    $0x25,%eax
801008b3:	0f 85 d7 00 00 00    	jne    80100990 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801008b9:	83 c3 01             	add    $0x1,%ebx
801008bc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801008c0:	85 d2                	test   %edx,%edx
801008c2:	74 42                	je     80100906 <cprintf+0x86>
    switch(c){
801008c4:	83 fa 70             	cmp    $0x70,%edx
801008c7:	0f 84 94 00 00 00    	je     80100961 <cprintf+0xe1>
801008cd:	7f 51                	jg     80100920 <cprintf+0xa0>
801008cf:	83 fa 25             	cmp    $0x25,%edx
801008d2:	0f 84 10 01 00 00    	je     801009e8 <cprintf+0x168>
801008d8:	83 fa 64             	cmp    $0x64,%edx
801008db:	0f 85 17 01 00 00    	jne    801009f8 <cprintf+0x178>
      printint(*argp++, 10, 1);
801008e1:	8d 47 04             	lea    0x4(%edi),%eax
801008e4:	b9 01 00 00 00       	mov    $0x1,%ecx
801008e9:	ba 0a 00 00 00       	mov    $0xa,%edx
801008ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008f1:	8b 07                	mov    (%edi),%eax
801008f3:	e8 d8 fe ff ff       	call   801007d0 <printint>
801008f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008fb:	83 c3 01             	add    $0x1,%ebx
801008fe:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100902:	85 c0                	test   %eax,%eax
80100904:	75 aa                	jne    801008b0 <cprintf+0x30>
  if(locking)
80100906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100909:	85 c0                	test   %eax,%eax
8010090b:	0f 85 a8 01 00 00    	jne    80100ab9 <cprintf+0x239>
}
80100911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100914:	5b                   	pop    %ebx
80100915:	5e                   	pop    %esi
80100916:	5f                   	pop    %edi
80100917:	5d                   	pop    %ebp
80100918:	c3                   	ret    
80100919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100920:	83 fa 73             	cmp    $0x73,%edx
80100923:	75 33                	jne    80100958 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100925:	8d 47 04             	lea    0x4(%edi),%eax
80100928:	8b 3f                	mov    (%edi),%edi
8010092a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010092d:	85 ff                	test   %edi,%edi
8010092f:	0f 85 3b 01 00 00    	jne    80100a70 <cprintf+0x1f0>
        s = "(null)";
80100935:	bf 98 79 10 80       	mov    $0x80107998,%edi
      for(; *s; s++)
8010093a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010093d:	b8 28 00 00 00       	mov    $0x28,%eax
80100942:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100944:	8b 15 78 04 11 80    	mov    0x80110478,%edx
8010094a:	85 d2                	test   %edx,%edx
8010094c:	0f 84 38 01 00 00    	je     80100a8a <cprintf+0x20a>
80100952:	fa                   	cli    
    for(;;)
80100953:	eb fe                	jmp    80100953 <cprintf+0xd3>
80100955:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100958:	83 fa 78             	cmp    $0x78,%edx
8010095b:	0f 85 97 00 00 00    	jne    801009f8 <cprintf+0x178>
      printint(*argp++, 16, 0);
80100961:	8d 47 04             	lea    0x4(%edi),%eax
80100964:	31 c9                	xor    %ecx,%ecx
80100966:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010096b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010096e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100971:	8b 07                	mov    (%edi),%eax
80100973:	e8 58 fe ff ff       	call   801007d0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100978:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010097c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010097f:	85 c0                	test   %eax,%eax
80100981:	0f 85 29 ff ff ff    	jne    801008b0 <cprintf+0x30>
80100987:	e9 7a ff ff ff       	jmp    80100906 <cprintf+0x86>
8010098c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100990:	8b 0d 78 04 11 80    	mov    0x80110478,%ecx
80100996:	85 c9                	test   %ecx,%ecx
80100998:	74 06                	je     801009a0 <cprintf+0x120>
8010099a:	fa                   	cli    
    for(;;)
8010099b:	eb fe                	jmp    8010099b <cprintf+0x11b>
8010099d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801009a0:	83 ec 0c             	sub    $0xc,%esp
801009a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009a6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801009a9:	50                   	push   %eax
801009aa:	e8 b1 5a 00 00       	call   80106460 <uartputc>
  cgaputc(c);
801009af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801009b2:	e8 19 fb ff ff       	call   801004d0 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801009bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009be:	85 c0                	test   %eax,%eax
801009c0:	0f 85 ea fe ff ff    	jne    801008b0 <cprintf+0x30>
801009c6:	e9 3b ff ff ff       	jmp    80100906 <cprintf+0x86>
801009cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009cf:	90                   	nop
    acquire(&cons.lock);
801009d0:	83 ec 0c             	sub    $0xc,%esp
801009d3:	68 40 04 11 80       	push   $0x80110440
801009d8:	e8 73 43 00 00       	call   80104d50 <acquire>
801009dd:	83 c4 10             	add    $0x10,%esp
801009e0:	e9 b4 fe ff ff       	jmp    80100899 <cprintf+0x19>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801009e8:	a1 78 04 11 80       	mov    0x80110478,%eax
801009ed:	85 c0                	test   %eax,%eax
801009ef:	74 4f                	je     80100a40 <cprintf+0x1c0>
801009f1:	fa                   	cli    
    for(;;)
801009f2:	eb fe                	jmp    801009f2 <cprintf+0x172>
801009f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801009f8:	8b 0d 78 04 11 80    	mov    0x80110478,%ecx
801009fe:	85 c9                	test   %ecx,%ecx
80100a00:	74 06                	je     80100a08 <cprintf+0x188>
80100a02:	fa                   	cli    
    for(;;)
80100a03:	eb fe                	jmp    80100a03 <cprintf+0x183>
80100a05:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100a08:	83 ec 0c             	sub    $0xc,%esp
80100a0b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100a0e:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100a11:	6a 25                	push   $0x25
80100a13:	e8 48 5a 00 00       	call   80106460 <uartputc>
  cgaputc(c);
80100a18:	b8 25 00 00 00       	mov    $0x25,%eax
80100a1d:	e8 ae fa ff ff       	call   801004d0 <cgaputc>
      consputc(c);
80100a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100a25:	e8 b6 fc ff ff       	call   801006e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100a2a:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      break;
80100a2e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100a31:	85 c0                	test   %eax,%eax
80100a33:	0f 85 77 fe ff ff    	jne    801008b0 <cprintf+0x30>
80100a39:	e9 c8 fe ff ff       	jmp    80100906 <cprintf+0x86>
80100a3e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100a40:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100a43:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100a46:	6a 25                	push   $0x25
80100a48:	e8 13 5a 00 00       	call   80106460 <uartputc>
  cgaputc(c);
80100a4d:	b8 25 00 00 00       	mov    $0x25,%eax
80100a52:	e8 79 fa ff ff       	call   801004d0 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100a57:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
80100a5b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100a5e:	85 c0                	test   %eax,%eax
80100a60:	0f 85 4a fe ff ff    	jne    801008b0 <cprintf+0x30>
80100a66:	e9 9b fe ff ff       	jmp    80100906 <cprintf+0x86>
80100a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a6f:	90                   	nop
      for(; *s; s++)
80100a70:	0f b6 07             	movzbl (%edi),%eax
80100a73:	84 c0                	test   %al,%al
80100a75:	74 57                	je     80100ace <cprintf+0x24e>
  if(panicked){
80100a77:	8b 15 78 04 11 80    	mov    0x80110478,%edx
80100a7d:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100a80:	89 fb                	mov    %edi,%ebx
80100a82:	85 d2                	test   %edx,%edx
80100a84:	0f 85 c8 fe ff ff    	jne    80100952 <cprintf+0xd2>
    uartputc(c);
80100a8a:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
80100a8d:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
80100a90:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100a93:	57                   	push   %edi
80100a94:	e8 c7 59 00 00       	call   80106460 <uartputc>
  cgaputc(c);
80100a99:	89 f8                	mov    %edi,%eax
80100a9b:	e8 30 fa ff ff       	call   801004d0 <cgaputc>
      for(; *s; s++)
80100aa0:	0f b6 03             	movzbl (%ebx),%eax
80100aa3:	83 c4 10             	add    $0x10,%esp
80100aa6:	84 c0                	test   %al,%al
80100aa8:	0f 85 96 fe ff ff    	jne    80100944 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
80100aae:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80100ab1:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100ab4:	e9 42 fe ff ff       	jmp    801008fb <cprintf+0x7b>
    release(&cons.lock);
80100ab9:	83 ec 0c             	sub    $0xc,%esp
80100abc:	68 40 04 11 80       	push   $0x80110440
80100ac1:	e8 2a 42 00 00       	call   80104cf0 <release>
80100ac6:	83 c4 10             	add    $0x10,%esp
}
80100ac9:	e9 43 fe ff ff       	jmp    80100911 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100ace:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100ad1:	e9 25 fe ff ff       	jmp    801008fb <cprintf+0x7b>
    panic("null fmt");
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	68 9f 79 10 80       	push   $0x8010799f
80100ade:	e8 6d f9 ff ff       	call   80100450 <panic>
80100ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100af0 <for_str>:
void for_str(char a[],char b[],int size){
80100af0:	55                   	push   %ebp
  for(int i=0;i<127;i++){
80100af1:	31 c0                	xor    %eax,%eax
void for_str(char a[],char b[],int size){
80100af3:	89 e5                	mov    %esp,%ebp
80100af5:	53                   	push   %ebx
80100af6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    b[i]=a[i];
80100b00:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80100b04:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  for(int i=0;i<127;i++){
80100b07:	83 c0 01             	add    $0x1,%eax
80100b0a:	83 f8 7f             	cmp    $0x7f,%eax
80100b0d:	75 f1                	jne    80100b00 <for_str+0x10>
}
80100b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b12:	c9                   	leave  
80100b13:	c3                   	ret    
80100b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b1f:	90                   	nop

80100b20 <insertChar>:
void insertChar(int c, int back_counter){
80100b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b21:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b26:	89 e5                	mov    %esp,%ebp
80100b28:	56                   	push   %esi
80100b29:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b2e:	53                   	push   %ebx
80100b2f:	89 f2                	mov    %esi,%edx
80100b31:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b32:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b37:	89 da                	mov    %ebx,%edx
80100b39:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100b3a:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b3d:	89 f2                	mov    %esi,%edx
80100b3f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b44:	c1 e1 08             	shl    $0x8,%ecx
80100b47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b48:	89 da                	mov    %ebx,%edx
80100b4a:	ec                   	in     (%dx),%al
  for(int i = pos + back_counter; i >= pos; i--){
80100b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  pos |= inb(CRTPORT+1);
80100b4e:	0f b6 c0             	movzbl %al,%eax
80100b51:	09 c8                	or     %ecx,%eax
  for(int i = pos + back_counter; i >= pos; i--){
80100b53:	01 c2                	add    %eax,%edx
80100b55:	39 d0                	cmp    %edx,%eax
80100b57:	7f 25                	jg     80100b7e <insertChar+0x5e>
80100b59:	8d 94 12 00 80 0b 80 	lea    -0x7ff48000(%edx,%edx,1),%edx
80100b60:	8d 9c 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%ebx
80100b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6e:	66 90                	xchg   %ax,%ax
    crt[i+1] = crt[i];
80100b70:	0f b7 0a             	movzwl (%edx),%ecx
  for(int i = pos + back_counter; i >= pos; i--){
80100b73:	83 ea 02             	sub    $0x2,%edx
    crt[i+1] = crt[i];
80100b76:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for(int i = pos + back_counter; i >= pos; i--){
80100b7a:	39 d3                	cmp    %edx,%ebx
80100b7c:	75 f2                	jne    80100b70 <insertChar+0x50>
  crt[pos] = (c&0xff) | 0x0700;  
80100b7e:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b82:	be d4 03 00 00       	mov    $0x3d4,%esi
  pos += 1;
80100b87:	8d 48 01             	lea    0x1(%eax),%ecx
  crt[pos] = (c&0xff) | 0x0700;  
80100b8a:	80 ce 07             	or     $0x7,%dh
80100b8d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100b94:	80 
80100b95:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b9a:	89 f2                	mov    %esi,%edx
80100b9c:	ee                   	out    %al,(%dx)
80100b9d:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
80100ba2:	89 c8                	mov    %ecx,%eax
80100ba4:	c1 f8 08             	sar    $0x8,%eax
80100ba7:	89 da                	mov    %ebx,%edx
80100ba9:	ee                   	out    %al,(%dx)
80100baa:	b8 0f 00 00 00       	mov    $0xf,%eax
80100baf:	89 f2                	mov    %esi,%edx
80100bb1:	ee                   	out    %al,(%dx)
80100bb2:	89 c8                	mov    %ecx,%eax
80100bb4:	89 da                	mov    %ebx,%edx
80100bb6:	ee                   	out    %al,(%dx)
  crt[pos+back_counter] = ' ' | 0x0700;
80100bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bba:	ba 20 07 00 00       	mov    $0x720,%edx
80100bbf:	01 c8                	add    %ecx,%eax
80100bc1:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100bc8:	80 
}
80100bc9:	5b                   	pop    %ebx
80100bca:	5e                   	pop    %esi
80100bcb:	5d                   	pop    %ebp
80100bcc:	c3                   	ret    
80100bcd:	8d 76 00             	lea    0x0(%esi),%esi

80100bd0 <addHistory>:
void addHistory(char *command){
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
if(command[0]!='\0')
80100bd6:	80 38 00             	cmpb   $0x0,(%eax)
80100bd9:	75 05                	jne    80100be0 <addHistory+0x10>
}
80100bdb:	5d                   	pop    %ebp
80100bdc:	c3                   	ret    
80100bdd:	8d 76 00             	lea    0x0(%esi),%esi
80100be0:	5d                   	pop    %ebp
80100be1:	e9 9a f7 ff ff       	jmp    80100380 <addHistory.part.0>
80100be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bed:	8d 76 00             	lea    0x0(%esi),%esi

80100bf0 <forwardCursor>:
void forwardCursor(){
80100bf0:	55                   	push   %ebp
80100bf1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bf6:	89 e5                	mov    %esp,%ebp
80100bf8:	57                   	push   %edi
80100bf9:	56                   	push   %esi
80100bfa:	be d4 03 00 00       	mov    $0x3d4,%esi
80100bff:	53                   	push   %ebx
80100c00:	89 f2                	mov    %esi,%edx
80100c02:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c03:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c08:	89 da                	mov    %ebx,%edx
80100c0a:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100c0b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c0e:	bf 0f 00 00 00       	mov    $0xf,%edi
80100c13:	89 f2                	mov    %esi,%edx
80100c15:	89 c1                	mov    %eax,%ecx
80100c17:	89 f8                	mov    %edi,%eax
80100c19:	c1 e1 08             	shl    $0x8,%ecx
80100c1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c1d:	89 da                	mov    %ebx,%edx
80100c1f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100c20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c23:	89 f2                	mov    %esi,%edx
80100c25:	09 c1                	or     %eax,%ecx
80100c27:	89 f8                	mov    %edi,%eax
  pos++;
80100c29:	83 c1 01             	add    $0x1,%ecx
80100c2c:	ee                   	out    %al,(%dx)
80100c2d:	89 c8                	mov    %ecx,%eax
80100c2f:	89 da                	mov    %ebx,%edx
80100c31:	ee                   	out    %al,(%dx)
80100c32:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c37:	89 f2                	mov    %esi,%edx
80100c39:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100c3a:	89 c8                	mov    %ecx,%eax
80100c3c:	89 da                	mov    %ebx,%edx
80100c3e:	c1 f8 08             	sar    $0x8,%eax
80100c41:	ee                   	out    %al,(%dx)
}
80100c42:	5b                   	pop    %ebx
80100c43:	5e                   	pop    %esi
80100c44:	5f                   	pop    %edi
80100c45:	5d                   	pop    %ebp
80100c46:	c3                   	ret    
80100c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c4e:	66 90                	xchg   %ax,%ax

80100c50 <removeChar>:
void removeChar(){
80100c50:	55                   	push   %ebp
80100c51:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c56:	89 e5                	mov    %esp,%ebp
80100c58:	57                   	push   %edi
80100c59:	56                   	push   %esi
80100c5a:	be d4 03 00 00       	mov    $0x3d4,%esi
80100c5f:	53                   	push   %ebx
80100c60:	89 f2                	mov    %esi,%edx
80100c62:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c63:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c68:	89 da                	mov    %ebx,%edx
80100c6a:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100c6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c6e:	bf 0f 00 00 00       	mov    $0xf,%edi
80100c73:	89 f2                	mov    %esi,%edx
80100c75:	89 c1                	mov    %eax,%ecx
80100c77:	89 f8                	mov    %edi,%eax
80100c79:	c1 e1 08             	shl    $0x8,%ecx
80100c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c7d:	89 da                	mov    %ebx,%edx
80100c7f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100c80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c83:	89 f2                	mov    %esi,%edx
80100c85:	09 c1                	or     %eax,%ecx
80100c87:	89 f8                	mov    %edi,%eax
  pos--;
80100c89:	83 e9 01             	sub    $0x1,%ecx
80100c8c:	ee                   	out    %al,(%dx)
80100c8d:	89 c8                	mov    %ecx,%eax
80100c8f:	89 da                	mov    %ebx,%edx
80100c91:	ee                   	out    %al,(%dx)
80100c92:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c97:	89 f2                	mov    %esi,%edx
80100c99:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100c9a:	89 c8                	mov    %ecx,%eax
80100c9c:	89 da                	mov    %ebx,%edx
80100c9e:	c1 f8 08             	sar    $0x8,%eax
80100ca1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100ca2:	b8 20 07 00 00       	mov    $0x720,%eax
80100ca7:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100cae:	80 
}
80100caf:	5b                   	pop    %ebx
80100cb0:	5e                   	pop    %esi
80100cb1:	5f                   	pop    %edi
80100cb2:	5d                   	pop    %ebp
80100cb3:	c3                   	ret    
80100cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cbf:	90                   	nop

80100cc0 <consoleintr>:
{
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	57                   	push   %edi
80100cc4:	56                   	push   %esi
80100cc5:	53                   	push   %ebx
80100cc6:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  acquire(&cons.lock);
80100ccc:	68 40 04 11 80       	push   $0x80110440
80100cd1:	e8 7a 40 00 00       	call   80104d50 <acquire>
  while((c = getc()) >= 0){
80100cd6:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100cd9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
80100ce0:	00 00 00 
  while((c = getc()) >= 0){
80100ce3:	ff 55 08             	call   *0x8(%ebp)
80100ce6:	89 c3                	mov    %eax,%ebx
80100ce8:	85 c0                	test   %eax,%eax
80100cea:	78 3c                	js     80100d28 <consoleintr+0x68>
    switch(c){
80100cec:	83 fb 7f             	cmp    $0x7f,%ebx
80100cef:	0f 84 f4 01 00 00    	je     80100ee9 <consoleintr+0x229>
80100cf5:	7e 59                	jle    80100d50 <consoleintr+0x90>
80100cf7:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100cfd:	0f 84 4d 02 00 00    	je     80100f50 <consoleintr+0x290>
80100d03:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100d09:	0f 85 91 00 00 00    	jne    80100da0 <consoleintr+0xe0>
      cgaputc(c);
80100d0f:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d14:	e8 b7 f7 ff ff       	call   801004d0 <cgaputc>
  while((c = getc()) >= 0){
80100d19:	ff 55 08             	call   *0x8(%ebp)
80100d1c:	89 c3                	mov    %eax,%ebx
80100d1e:	85 c0                	test   %eax,%eax
80100d20:	79 ca                	jns    80100cec <consoleintr+0x2c>
80100d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&cons.lock);
80100d28:	83 ec 0c             	sub    $0xc,%esp
80100d2b:	68 40 04 11 80       	push   $0x80110440
80100d30:	e8 bb 3f 00 00       	call   80104cf0 <release>
  if(doprocdump) {
80100d35:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80100d3b:	83 c4 10             	add    $0x10,%esp
80100d3e:	85 c0                	test   %eax,%eax
80100d40:	0f 85 27 03 00 00    	jne    8010106d <consoleintr+0x3ad>
}
80100d46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d49:	5b                   	pop    %ebx
80100d4a:	5e                   	pop    %esi
80100d4b:	5f                   	pop    %edi
80100d4c:	5d                   	pop    %ebp
80100d4d:	c3                   	ret    
80100d4e:	66 90                	xchg   %ax,%ax
    switch(c){
80100d50:	83 fb 10             	cmp    $0x10,%ebx
80100d53:	0f 84 e7 01 00 00    	je     80100f40 <consoleintr+0x280>
80100d59:	83 fb 15             	cmp    $0x15,%ebx
80100d5c:	0f 85 7e 01 00 00    	jne    80100ee0 <consoleintr+0x220>
      while(input.e != input.w &&
80100d62:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d67:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100d6d:	0f 84 70 ff ff ff    	je     80100ce3 <consoleintr+0x23>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100d73:	83 e8 01             	sub    $0x1,%eax
80100d76:	89 c2                	mov    %eax,%edx
80100d78:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100d7b:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100d82:	0f 84 5b ff ff ff    	je     80100ce3 <consoleintr+0x23>
  if(panicked){
80100d88:	8b 1d 78 04 11 80    	mov    0x80110478,%ebx
        input.e--;
80100d8e:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100d93:	85 db                	test   %ebx,%ebx
80100d95:	0f 84 c4 01 00 00    	je     80100f5f <consoleintr+0x29f>
  asm volatile("cli");
80100d9b:	fa                   	cli    
    for(;;)
80100d9c:	eb fe                	jmp    80100d9c <consoleintr+0xdc>
80100d9e:	66 90                	xchg   %ax,%ax
    switch(c){
80100da0:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100da6:	0f 85 14 02 00 00    	jne    80100fc0 <consoleintr+0x300>
      if(curr_index >= 0){
80100dac:	a1 10 ff 10 80       	mov    0x8010ff10,%eax
80100db1:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
80100db7:	85 c0                	test   %eax,%eax
80100db9:	0f 88 24 ff ff ff    	js     80100ce3 <consoleintr+0x23>
        for(int i=input.pos; i < input.e; i++){
80100dbf:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100dc4:	8b 3d 08 ff 10 80    	mov    0x8010ff08,%edi
80100dca:	39 f8                	cmp    %edi,%eax
80100dcc:	73 69                	jae    80100e37 <consoleintr+0x177>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100dce:	89 bd 60 ff ff ff    	mov    %edi,-0xa0(%ebp)
80100dd4:	be d4 03 00 00       	mov    $0x3d4,%esi
80100dd9:	89 c7                	mov    %eax,%edi
80100ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ddf:	90                   	nop
80100de0:	b8 0e 00 00 00       	mov    $0xe,%eax
80100de5:	89 f2                	mov    %esi,%edx
80100de7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100de8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100ded:	89 da                	mov    %ebx,%edx
80100def:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100df0:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100df3:	89 f2                	mov    %esi,%edx
80100df5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100dfa:	c1 e1 08             	shl    $0x8,%ecx
80100dfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dfe:	89 da                	mov    %ebx,%edx
80100e00:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100e01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e04:	89 f2                	mov    %esi,%edx
80100e06:	09 c1                	or     %eax,%ecx
80100e08:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos++;
80100e0d:	83 c1 01             	add    $0x1,%ecx
80100e10:	ee                   	out    %al,(%dx)
80100e11:	89 c8                	mov    %ecx,%eax
80100e13:	89 da                	mov    %ebx,%edx
80100e15:	ee                   	out    %al,(%dx)
80100e16:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e1b:	89 f2                	mov    %esi,%edx
80100e1d:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100e1e:	89 c8                	mov    %ecx,%eax
80100e20:	89 da                	mov    %ebx,%edx
80100e22:	c1 f8 08             	sar    $0x8,%eax
80100e25:	ee                   	out    %al,(%dx)
        for(int i=input.pos; i < input.e; i++){
80100e26:	83 c7 01             	add    $0x1,%edi
80100e29:	39 bd 60 ff ff ff    	cmp    %edi,-0xa0(%ebp)
80100e2f:	77 af                	ja     80100de0 <consoleintr+0x120>
80100e31:	8b bd 60 ff ff ff    	mov    -0xa0(%ebp),%edi
        while(input.e > input.w){
80100e37:	3b 3d 04 ff 10 80    	cmp    0x8010ff04,%edi
80100e3d:	76 28                	jbe    80100e67 <consoleintr+0x1a7>
80100e3f:	90                   	nop
          input.e--;
80100e40:	83 ef 01             	sub    $0x1,%edi
80100e43:	89 3d 08 ff 10 80    	mov    %edi,0x8010ff08
          removeChar();
80100e49:	e8 02 fe ff ff       	call   80100c50 <removeChar>
        while(input.e > input.w){
80100e4e:	8b 3d 08 ff 10 80    	mov    0x8010ff08,%edi
80100e54:	3b 3d 04 ff 10 80    	cmp    0x8010ff04,%edi
80100e5a:	77 e4                	ja     80100e40 <consoleintr+0x180>
        for(int i=0; i < strlen(history[curr_index]); i++){
80100e5c:	a1 10 ff 10 80       	mov    0x8010ff10,%eax
80100e61:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
80100e67:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80100e6d:	31 db                	xor    %ebx,%ebx
80100e6f:	eb 3f                	jmp    80100eb0 <consoleintr+0x1f0>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          x = history[curr_index][i];
80100e78:	a1 10 ff 10 80       	mov    0x8010ff10,%eax
80100e7d:	c1 e0 07             	shl    $0x7,%eax
80100e80:	0f b6 b4 03 20 ff 10 	movzbl -0x7fef00e0(%ebx,%eax,1),%esi
80100e87:	80 
        for(int i=0; i < strlen(history[curr_index]); i++){
80100e88:	83 c3 01             	add    $0x1,%ebx
          x = history[curr_index][i];
80100e8b:	89 f0                	mov    %esi,%eax
80100e8d:	0f be c0             	movsbl %al,%eax
          consputc(x);
80100e90:	e8 4b f8 ff ff       	call   801006e0 <consputc>
          input.buf[input.e++] = x;
80100e95:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e9a:	89 f1                	mov    %esi,%ecx
80100e9c:	8d 50 01             	lea    0x1(%eax),%edx
80100e9f:	88 88 80 fe 10 80    	mov    %cl,-0x7fef0180(%eax)
        for(int i=0; i < strlen(history[curr_index]); i++){
80100ea5:	a1 10 ff 10 80       	mov    0x8010ff10,%eax
          input.buf[input.e++] = x;
80100eaa:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
        for(int i=0; i < strlen(history[curr_index]); i++){
80100eb0:	c1 e0 07             	shl    $0x7,%eax
80100eb3:	83 ec 0c             	sub    $0xc,%esp
80100eb6:	05 20 ff 10 80       	add    $0x8010ff20,%eax
80100ebb:	50                   	push   %eax
80100ebc:	e8 4f 41 00 00       	call   80105010 <strlen>
80100ec1:	83 c4 10             	add    $0x10,%esp
80100ec4:	39 d8                	cmp    %ebx,%eax
80100ec6:	7f b0                	jg     80100e78 <consoleintr+0x1b8>
        input.pos = input.e;
80100ec8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
        curr_index  --;
80100ecd:	83 2d 10 ff 10 80 01 	subl   $0x1,0x8010ff10
        input.pos = input.e;
80100ed4:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
80100ed9:	e9 05 fe ff ff       	jmp    80100ce3 <consoleintr+0x23>
80100ede:	66 90                	xchg   %ax,%ax
    switch(c){
80100ee0:	83 fb 08             	cmp    $0x8,%ebx
80100ee3:	0f 85 c7 00 00 00    	jne    80100fb0 <consoleintr+0x2f0>
      if(input.e != input.w && back_counter < (strlen(input.buf) - backspaces)){
80100ee9:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80100eee:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100ef4:	0f 84 e9 fd ff ff    	je     80100ce3 <consoleintr+0x23>
80100efa:	83 ec 0c             	sub    $0xc,%esp
80100efd:	68 80 fe 10 80       	push   $0x8010fe80
80100f02:	e8 09 41 00 00       	call   80105010 <strlen>
80100f07:	8b 15 20 04 11 80    	mov    0x80110420,%edx
80100f0d:	83 c4 10             	add    $0x10,%esp
80100f10:	29 d0                	sub    %edx,%eax
80100f12:	3b 05 24 04 11 80    	cmp    0x80110424,%eax
80100f18:	0f 8e c5 fd ff ff    	jle    80100ce3 <consoleintr+0x23>
  if(panicked){
80100f1e:	8b 0d 78 04 11 80    	mov    0x80110478,%ecx
        input.e--;
80100f24:	83 2d 08 ff 10 80 01 	subl   $0x1,0x8010ff08
  if(panicked){
80100f2b:	85 c9                	test   %ecx,%ecx
80100f2d:	0f 84 47 01 00 00    	je     8010107a <consoleintr+0x3ba>
  asm volatile("cli");
80100f33:	fa                   	cli    
    for(;;)
80100f34:	eb fe                	jmp    80100f34 <consoleintr+0x274>
80100f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100f40:	c7 85 64 ff ff ff 01 	movl   $0x1,-0x9c(%ebp)
80100f47:	00 00 00 
80100f4a:	e9 94 fd ff ff       	jmp    80100ce3 <consoleintr+0x23>
80100f4f:	90                   	nop
      cgaputc(c);
80100f50:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100f55:	e8 76 f5 ff ff       	call   801004d0 <cgaputc>
      break;
80100f5a:	e9 84 fd ff ff       	jmp    80100ce3 <consoleintr+0x23>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100f5f:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100f62:	83 05 20 04 11 80 01 	addl   $0x1,0x80110420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100f69:	6a 08                	push   $0x8
80100f6b:	e8 f0 54 00 00       	call   80106460 <uartputc>
80100f70:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100f77:	e8 e4 54 00 00       	call   80106460 <uartputc>
80100f7c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100f83:	e8 d8 54 00 00       	call   80106460 <uartputc>
  cgaputc(c);
80100f88:	b8 00 01 00 00       	mov    $0x100,%eax
80100f8d:	e8 3e f5 ff ff       	call   801004d0 <cgaputc>
      while(input.e != input.w &&
80100f92:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f97:	83 c4 10             	add    $0x10,%esp
80100f9a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100fa0:	0f 85 cd fd ff ff    	jne    80100d73 <consoleintr+0xb3>
80100fa6:	e9 38 fd ff ff       	jmp    80100ce3 <consoleintr+0x23>
80100fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100faf:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100fb0:	85 db                	test   %ebx,%ebx
80100fb2:	0f 84 2b fd ff ff    	je     80100ce3 <consoleintr+0x23>
80100fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbf:	90                   	nop
80100fc0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100fc5:	2b 05 00 ff 10 80    	sub    0x8010ff00,%eax
80100fcb:	83 f8 7f             	cmp    $0x7f,%eax
80100fce:	0f 87 0f fd ff ff    	ja     80100ce3 <consoleintr+0x23>
        uartputc('-');
80100fd4:	83 ec 0c             	sub    $0xc,%esp
80100fd7:	6a 2d                	push   $0x2d
80100fd9:	e8 82 54 00 00       	call   80106460 <uartputc>
        uartputc(c); 
80100fde:	89 1c 24             	mov    %ebx,(%esp)
80100fe1:	e8 7a 54 00 00       	call   80106460 <uartputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ // if input is \n, put it on the back, and process it
80100fe6:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
        c = (c == '\r') ? '\n' : c;
80100fec:	83 c4 10             	add    $0x10,%esp
80100fef:	83 fb 0d             	cmp    $0xd,%ebx
80100ff2:	0f 84 3a 01 00 00    	je     80101132 <consoleintr+0x472>
            input.buf[input.e++ % INPUT_BUF] = c;
80100ff8:	8d 42 01             	lea    0x1(%edx),%eax
80100ffb:	88 9d 5c ff ff ff    	mov    %bl,-0xa4(%ebp)
80101001:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ // if input is \n, put it on the back, and process it
80101007:	83 fb 0a             	cmp    $0xa,%ebx
8010100a:	0f 84 37 01 00 00    	je     80101147 <consoleintr+0x487>
80101010:	83 fb 04             	cmp    $0x4,%ebx
80101013:	0f 84 2e 01 00 00    	je     80101147 <consoleintr+0x487>
80101019:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010101e:	83 e8 80             	sub    $0xffffff80,%eax
80101021:	39 d0                	cmp    %edx,%eax
80101023:	0f 84 1e 01 00 00    	je     80101147 <consoleintr+0x487>
            input.pos ++;
80101029:	8b 35 0c ff 10 80    	mov    0x8010ff0c,%esi
          if(back_counter == 0){
8010102f:	a1 24 04 11 80       	mov    0x80110424,%eax
            input.pos ++;
80101034:	8d 7e 01             	lea    0x1(%esi),%edi
          if(back_counter == 0){
80101037:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
            input.pos ++;
8010103d:	89 bd 54 ff ff ff    	mov    %edi,-0xac(%ebp)
          if(back_counter == 0){
80101043:	85 c0                	test   %eax,%eax
80101045:	75 70                	jne    801010b7 <consoleintr+0x3f7>
            input.buf[input.e++ % INPUT_BUF] = c;
80101047:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010104d:	83 e2 7f             	and    $0x7f,%edx
            input.pos ++;
80101050:	89 3d 0c ff 10 80    	mov    %edi,0x8010ff0c
            input.buf[input.e++ % INPUT_BUF] = c;
80101056:	88 9a 80 fe 10 80    	mov    %bl,-0x7fef0180(%edx)
8010105c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            consputc(c);
80101061:	89 d8                	mov    %ebx,%eax
80101063:	e8 78 f6 ff ff       	call   801006e0 <consputc>
80101068:	e9 76 fc ff ff       	jmp    80100ce3 <consoleintr+0x23>
    procdump();  // now call procdump() wo. cons.lock held
8010106d:	e8 1e 39 00 00       	call   80104990 <procdump>
}
80101072:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101075:	5b                   	pop    %ebx
80101076:	5e                   	pop    %esi
80101077:	5f                   	pop    %edi
80101078:	5d                   	pop    %ebp
80101079:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010107a:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
8010107d:	83 c2 01             	add    $0x1,%edx
    uartputc('\b'); uartputc(' '); uartputc('\b');
80101080:	6a 08                	push   $0x8
    backspaces++;
80101082:	89 15 20 04 11 80    	mov    %edx,0x80110420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80101088:	e8 d3 53 00 00       	call   80106460 <uartputc>
8010108d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80101094:	e8 c7 53 00 00       	call   80106460 <uartputc>
80101099:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801010a0:	e8 bb 53 00 00       	call   80106460 <uartputc>
  cgaputc(c);
801010a5:	b8 00 01 00 00       	mov    $0x100,%eax
801010aa:	e8 21 f4 ff ff       	call   801004d0 <cgaputc>
}
801010af:	83 c4 10             	add    $0x10,%esp
801010b2:	e9 2c fc ff ff       	jmp    80100ce3 <consoleintr+0x23>
            for(int k=input.e; k >= input.pos; k--){
801010b7:	89 df                	mov    %ebx,%edi
801010b9:	39 d6                	cmp    %edx,%esi
801010bb:	77 38                	ja     801010f5 <consoleintr+0x435>
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
801010bd:	89 d1                	mov    %edx,%ecx
801010bf:	c1 f9 1f             	sar    $0x1f,%ecx
801010c2:	c1 e9 19             	shr    $0x19,%ecx
801010c5:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
801010c8:	83 e0 7f             	and    $0x7f,%eax
801010cb:	29 c8                	sub    %ecx,%eax
801010cd:	0f b6 98 80 fe 10 80 	movzbl -0x7fef0180(%eax),%ebx
801010d4:	8d 42 01             	lea    0x1(%edx),%eax
            for(int k=input.e; k >= input.pos; k--){
801010d7:	83 ea 01             	sub    $0x1,%edx
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
801010da:	89 c1                	mov    %eax,%ecx
801010dc:	c1 f9 1f             	sar    $0x1f,%ecx
801010df:	c1 e9 19             	shr    $0x19,%ecx
801010e2:	01 c8                	add    %ecx,%eax
801010e4:	83 e0 7f             	and    $0x7f,%eax
801010e7:	29 c8                	sub    %ecx,%eax
801010e9:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
            for(int k=input.e; k >= input.pos; k--){
801010ef:	39 f2                	cmp    %esi,%edx
801010f1:	73 ca                	jae    801010bd <consoleintr+0x3fd>
801010f3:	89 fb                	mov    %edi,%ebx
            input.buf[input.pos % INPUT_BUF] = c;
801010f5:	0f b6 85 5c ff ff ff 	movzbl -0xa4(%ebp),%eax
801010fc:	83 e6 7f             	and    $0x7f,%esi
            insertChar(c, back_counter);
801010ff:	83 ec 08             	sub    $0x8,%esp
80101102:	ff b5 58 ff ff ff    	push   -0xa8(%ebp)
80101108:	53                   	push   %ebx
            input.buf[input.pos % INPUT_BUF] = c;
80101109:	88 86 80 fe 10 80    	mov    %al,-0x7fef0180(%esi)
            input.e++;
8010110f:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80101115:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            input.pos++;
8010111a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
80101120:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            insertChar(c, back_counter);
80101125:	e8 f6 f9 ff ff       	call   80100b20 <insertChar>
8010112a:	83 c4 10             	add    $0x10,%esp
8010112d:	e9 b1 fb ff ff       	jmp    80100ce3 <consoleintr+0x23>
80101132:	8d 42 01             	lea    0x1(%edx),%eax
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ // if input is \n, put it on the back, and process it
80101135:	c6 85 5c ff ff ff 0a 	movb   $0xa,-0xa4(%ebp)
        c = (c == '\r') ? '\n' : c;
8010113c:	bb 0a 00 00 00       	mov    $0xa,%ebx
80101141:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
          input.buf[input.e++ % INPUT_BUF] = c;
80101147:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010114d:	83 e2 7f             	and    $0x7f,%edx
            buffer[k] = input.buf[i % INPUT_BUF];
80101150:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
          input.buf[input.e++ % INPUT_BUF] = c;
80101156:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
8010115b:	0f b6 85 5c ff ff ff 	movzbl -0xa4(%ebp),%eax
80101162:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
          consputc(c);
80101168:	89 d8                	mov    %ebx,%eax
8010116a:	e8 71 f5 ff ff       	call   801006e0 <consputc>
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
8010116f:	8b 35 08 ff 10 80    	mov    0x8010ff08,%esi
80101175:	8b 0d 04 ff 10 80    	mov    0x8010ff04,%ecx
          back_counter = 0;
8010117b:	c7 05 24 04 11 80 00 	movl   $0x0,0x80110424
80101182:	00 00 00 
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80101185:	8d 5e ff             	lea    -0x1(%esi),%ebx
80101188:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
8010118e:	89 c8                	mov    %ecx,%eax
            buffer[k] = input.buf[i % INPUT_BUF];
80101190:	29 cf                	sub    %ecx,%edi
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80101192:	39 d9                	cmp    %ebx,%ecx
80101194:	73 21                	jae    801011b7 <consoleintr+0x4f7>
            buffer[k] = input.buf[i % INPUT_BUF];
80101196:	89 c1                	mov    %eax,%ecx
80101198:	c1 f9 1f             	sar    $0x1f,%ecx
8010119b:	c1 e9 19             	shr    $0x19,%ecx
8010119e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
801011a1:	83 e2 7f             	and    $0x7f,%edx
801011a4:	29 ca                	sub    %ecx,%edx
801011a6:	0f b6 92 80 fe 10 80 	movzbl -0x7fef0180(%edx),%edx
801011ad:	88 14 07             	mov    %dl,(%edi,%eax,1)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
801011b0:	83 c0 01             	add    $0x1,%eax
801011b3:	39 c3                	cmp    %eax,%ebx
801011b5:	77 df                	ja     80101196 <consoleintr+0x4d6>
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';
801011b7:	89 d8                	mov    %ebx,%eax
801011b9:	2b 85 60 ff ff ff    	sub    -0xa0(%ebp),%eax
801011bf:	83 e0 7f             	and    $0x7f,%eax
801011c2:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
801011c9:	00 
if(command[0]!='\0')
801011ca:	80 bd 68 ff ff ff 00 	cmpb   $0x0,-0x98(%ebp)
801011d1:	75 21                	jne    801011f4 <consoleintr+0x534>
          wakeup(&input.r);
801011d3:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801011d6:	89 35 04 ff 10 80    	mov    %esi,0x8010ff04
          wakeup(&input.r);
801011dc:	68 00 ff 10 80       	push   $0x8010ff00
          input.pos = input.e;
801011e1:	89 35 0c ff 10 80    	mov    %esi,0x8010ff0c
          wakeup(&input.r);
801011e7:	e8 c4 36 00 00       	call   801048b0 <wakeup>
801011ec:	83 c4 10             	add    $0x10,%esp
801011ef:	e9 ef fa ff ff       	jmp    80100ce3 <consoleintr+0x23>
801011f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801011fa:	e8 81 f1 ff ff       	call   80100380 <addHistory.part.0>
          input.w = input.e;
801011ff:	8b 35 08 ff 10 80    	mov    0x8010ff08,%esi
80101205:	eb cc                	jmp    801011d3 <consoleintr+0x513>
80101207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010120e:	66 90                	xchg   %ax,%ax

80101210 <consoleinit>:

void
consoleinit(void)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101216:	68 a8 79 10 80       	push   $0x801079a8
8010121b:	68 40 04 11 80       	push   $0x80110440
80101220:	e8 5b 39 00 00       	call   80104b80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101225:	58                   	pop    %eax
80101226:	5a                   	pop    %edx
80101227:	6a 00                	push   $0x0
80101229:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010122b:	c7 05 2c 0e 11 80 50 	movl   $0x80100750,0x80110e2c
80101232:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80101235:	c7 05 28 0e 11 80 80 	movl   $0x80100280,0x80110e28
8010123c:	02 10 80 
  cons.locking = 1;
8010123f:	c7 05 74 04 11 80 01 	movl   $0x1,0x80110474
80101246:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101249:	e8 e2 19 00 00       	call   80102c30 <ioapicenable>
}
8010124e:	83 c4 10             	add    $0x10,%esp
80101251:	c9                   	leave  
80101252:	c3                   	ret    
80101253:	66 90                	xchg   %ax,%ax
80101255:	66 90                	xchg   %ax,%ax
80101257:	66 90                	xchg   %ax,%ax
80101259:	66 90                	xchg   %ax,%ax
8010125b:	66 90                	xchg   %ax,%ax
8010125d:	66 90                	xchg   %ax,%ax
8010125f:	90                   	nop

80101260 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010126c:	e8 af 2e 00 00       	call   80104120 <myproc>
80101271:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101277:	e8 94 22 00 00       	call   80103510 <begin_op>

  if((ip = namei(path)) == 0){
8010127c:	83 ec 0c             	sub    $0xc,%esp
8010127f:	ff 75 08             	push   0x8(%ebp)
80101282:	e8 c9 15 00 00       	call   80102850 <namei>
80101287:	83 c4 10             	add    $0x10,%esp
8010128a:	85 c0                	test   %eax,%eax
8010128c:	0f 84 02 03 00 00    	je     80101594 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101292:	83 ec 0c             	sub    $0xc,%esp
80101295:	89 c3                	mov    %eax,%ebx
80101297:	50                   	push   %eax
80101298:	e8 93 0c 00 00       	call   80101f30 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010129d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801012a3:	6a 34                	push   $0x34
801012a5:	6a 00                	push   $0x0
801012a7:	50                   	push   %eax
801012a8:	53                   	push   %ebx
801012a9:	e8 92 0f 00 00       	call   80102240 <readi>
801012ae:	83 c4 20             	add    $0x20,%esp
801012b1:	83 f8 34             	cmp    $0x34,%eax
801012b4:	74 22                	je     801012d8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	53                   	push   %ebx
801012ba:	e8 01 0f 00 00       	call   801021c0 <iunlockput>
    end_op();
801012bf:	e8 bc 22 00 00       	call   80103580 <end_op>
801012c4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801012c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012cf:	5b                   	pop    %ebx
801012d0:	5e                   	pop    %esi
801012d1:	5f                   	pop    %edi
801012d2:	5d                   	pop    %ebp
801012d3:	c3                   	ret    
801012d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
801012d8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801012df:	45 4c 46 
801012e2:	75 d2                	jne    801012b6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
801012e4:	e8 07 63 00 00       	call   801075f0 <setupkvm>
801012e9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801012ef:	85 c0                	test   %eax,%eax
801012f1:	74 c3                	je     801012b6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012f3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801012fa:	00 
801012fb:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101301:	0f 84 ac 02 00 00    	je     801015b3 <exec+0x353>
  sz = 0;
80101307:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
8010130e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101311:	31 ff                	xor    %edi,%edi
80101313:	e9 8e 00 00 00       	jmp    801013a6 <exec+0x146>
80101318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010131f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101320:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101327:	75 6c                	jne    80101395 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101329:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010132f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101335:	0f 82 87 00 00 00    	jb     801013c2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010133b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101341:	72 7f                	jb     801013c2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101343:	83 ec 04             	sub    $0x4,%esp
80101346:	50                   	push   %eax
80101347:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
8010134d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101353:	e8 b8 60 00 00       	call   80107410 <allocuvm>
80101358:	83 c4 10             	add    $0x10,%esp
8010135b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101361:	85 c0                	test   %eax,%eax
80101363:	74 5d                	je     801013c2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101365:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010136b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101370:	75 50                	jne    801013c2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101372:	83 ec 0c             	sub    $0xc,%esp
80101375:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010137b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101381:	53                   	push   %ebx
80101382:	50                   	push   %eax
80101383:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101389:	e8 92 5f 00 00       	call   80107320 <loaduvm>
8010138e:	83 c4 20             	add    $0x20,%esp
80101391:	85 c0                	test   %eax,%eax
80101393:	78 2d                	js     801013c2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101395:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010139c:	83 c7 01             	add    $0x1,%edi
8010139f:	83 c6 20             	add    $0x20,%esi
801013a2:	39 f8                	cmp    %edi,%eax
801013a4:	7e 3a                	jle    801013e0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801013a6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801013ac:	6a 20                	push   $0x20
801013ae:	56                   	push   %esi
801013af:	50                   	push   %eax
801013b0:	53                   	push   %ebx
801013b1:	e8 8a 0e 00 00       	call   80102240 <readi>
801013b6:	83 c4 10             	add    $0x10,%esp
801013b9:	83 f8 20             	cmp    $0x20,%eax
801013bc:	0f 84 5e ff ff ff    	je     80101320 <exec+0xc0>
    freevm(pgdir);
801013c2:	83 ec 0c             	sub    $0xc,%esp
801013c5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801013cb:	e8 a0 61 00 00       	call   80107570 <freevm>
  if(ip){
801013d0:	83 c4 10             	add    $0x10,%esp
801013d3:	e9 de fe ff ff       	jmp    801012b6 <exec+0x56>
801013d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop
  sz = PGROUNDUP(sz);
801013e0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801013e6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801013ec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801013f2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801013f8:	83 ec 0c             	sub    $0xc,%esp
801013fb:	53                   	push   %ebx
801013fc:	e8 bf 0d 00 00       	call   801021c0 <iunlockput>
  end_op();
80101401:	e8 7a 21 00 00       	call   80103580 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101406:	83 c4 0c             	add    $0xc,%esp
80101409:	56                   	push   %esi
8010140a:	57                   	push   %edi
8010140b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101411:	57                   	push   %edi
80101412:	e8 f9 5f 00 00       	call   80107410 <allocuvm>
80101417:	83 c4 10             	add    $0x10,%esp
8010141a:	89 c6                	mov    %eax,%esi
8010141c:	85 c0                	test   %eax,%eax
8010141e:	0f 84 94 00 00 00    	je     801014b8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101424:	83 ec 08             	sub    $0x8,%esp
80101427:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010142d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010142f:	50                   	push   %eax
80101430:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101431:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101433:	e8 58 62 00 00       	call   80107690 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101438:	8b 45 0c             	mov    0xc(%ebp),%eax
8010143b:	83 c4 10             	add    $0x10,%esp
8010143e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101444:	8b 00                	mov    (%eax),%eax
80101446:	85 c0                	test   %eax,%eax
80101448:	0f 84 8b 00 00 00    	je     801014d9 <exec+0x279>
8010144e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101454:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010145a:	eb 23                	jmp    8010147f <exec+0x21f>
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101460:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101463:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010146a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010146d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101473:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 59                	je     801014d3 <exec+0x273>
    if(argc >= MAXARG)
8010147a:	83 ff 20             	cmp    $0x20,%edi
8010147d:	74 39                	je     801014b8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010147f:	83 ec 0c             	sub    $0xc,%esp
80101482:	50                   	push   %eax
80101483:	e8 88 3b 00 00       	call   80105010 <strlen>
80101488:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010148a:	58                   	pop    %eax
8010148b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010148e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101491:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101494:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101497:	e8 74 3b 00 00       	call   80105010 <strlen>
8010149c:	83 c0 01             	add    $0x1,%eax
8010149f:	50                   	push   %eax
801014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014a3:	ff 34 b8             	push   (%eax,%edi,4)
801014a6:	53                   	push   %ebx
801014a7:	56                   	push   %esi
801014a8:	e8 b3 63 00 00       	call   80107860 <copyout>
801014ad:	83 c4 20             	add    $0x20,%esp
801014b0:	85 c0                	test   %eax,%eax
801014b2:	79 ac                	jns    80101460 <exec+0x200>
801014b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801014b8:	83 ec 0c             	sub    $0xc,%esp
801014bb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801014c1:	e8 aa 60 00 00       	call   80107570 <freevm>
801014c6:	83 c4 10             	add    $0x10,%esp
  return -1;
801014c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014ce:	e9 f9 fd ff ff       	jmp    801012cc <exec+0x6c>
801014d3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801014d9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801014e0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801014e2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801014e9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801014ed:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801014ef:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801014f2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801014f8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801014fa:	50                   	push   %eax
801014fb:	52                   	push   %edx
801014fc:	53                   	push   %ebx
801014fd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101503:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010150a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010150d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101513:	e8 48 63 00 00       	call   80107860 <copyout>
80101518:	83 c4 10             	add    $0x10,%esp
8010151b:	85 c0                	test   %eax,%eax
8010151d:	78 99                	js     801014b8 <exec+0x258>
  for(last=s=path; *s; s++)
8010151f:	8b 45 08             	mov    0x8(%ebp),%eax
80101522:	8b 55 08             	mov    0x8(%ebp),%edx
80101525:	0f b6 00             	movzbl (%eax),%eax
80101528:	84 c0                	test   %al,%al
8010152a:	74 13                	je     8010153f <exec+0x2df>
8010152c:	89 d1                	mov    %edx,%ecx
8010152e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101530:	83 c1 01             	add    $0x1,%ecx
80101533:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101535:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101538:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010153b:	84 c0                	test   %al,%al
8010153d:	75 f1                	jne    80101530 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010153f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101545:	83 ec 04             	sub    $0x4,%esp
80101548:	6a 10                	push   $0x10
8010154a:	89 f8                	mov    %edi,%eax
8010154c:	52                   	push   %edx
8010154d:	83 c0 6c             	add    $0x6c,%eax
80101550:	50                   	push   %eax
80101551:	e8 7a 3a 00 00       	call   80104fd0 <safestrcpy>
  curproc->pgdir = pgdir;
80101556:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010155c:	89 f8                	mov    %edi,%eax
8010155e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101561:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101563:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101566:	89 c1                	mov    %eax,%ecx
80101568:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010156e:	8b 40 18             	mov    0x18(%eax),%eax
80101571:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101574:	8b 41 18             	mov    0x18(%ecx),%eax
80101577:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010157a:	89 0c 24             	mov    %ecx,(%esp)
8010157d:	e8 0e 5c 00 00       	call   80107190 <switchuvm>
  freevm(oldpgdir);
80101582:	89 3c 24             	mov    %edi,(%esp)
80101585:	e8 e6 5f 00 00       	call   80107570 <freevm>
  return 0;
8010158a:	83 c4 10             	add    $0x10,%esp
8010158d:	31 c0                	xor    %eax,%eax
8010158f:	e9 38 fd ff ff       	jmp    801012cc <exec+0x6c>
    end_op();
80101594:	e8 e7 1f 00 00       	call   80103580 <end_op>
    cprintf("exec: fail\n");
80101599:	83 ec 0c             	sub    $0xc,%esp
8010159c:	68 c1 79 10 80       	push   $0x801079c1
801015a1:	e8 da f2 ff ff       	call   80100880 <cprintf>
    return -1;
801015a6:	83 c4 10             	add    $0x10,%esp
801015a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801015ae:	e9 19 fd ff ff       	jmp    801012cc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801015b3:	be 00 20 00 00       	mov    $0x2000,%esi
801015b8:	31 ff                	xor    %edi,%edi
801015ba:	e9 39 fe ff ff       	jmp    801013f8 <exec+0x198>
801015bf:	90                   	nop

801015c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801015c6:	68 cd 79 10 80       	push   $0x801079cd
801015cb:	68 80 04 11 80       	push   $0x80110480
801015d0:	e8 ab 35 00 00       	call   80104b80 <initlock>
}
801015d5:	83 c4 10             	add    $0x10,%esp
801015d8:	c9                   	leave  
801015d9:	c3                   	ret    
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801015e4:	bb b4 04 11 80       	mov    $0x801104b4,%ebx
{
801015e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801015ec:	68 80 04 11 80       	push   $0x80110480
801015f1:	e8 5a 37 00 00       	call   80104d50 <acquire>
801015f6:	83 c4 10             	add    $0x10,%esp
801015f9:	eb 10                	jmp    8010160b <filealloc+0x2b>
801015fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015ff:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101600:	83 c3 18             	add    $0x18,%ebx
80101603:	81 fb 14 0e 11 80    	cmp    $0x80110e14,%ebx
80101609:	74 25                	je     80101630 <filealloc+0x50>
    if(f->ref == 0){
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
8010160e:	85 c0                	test   %eax,%eax
80101610:	75 ee                	jne    80101600 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101612:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101615:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010161c:	68 80 04 11 80       	push   $0x80110480
80101621:	e8 ca 36 00 00       	call   80104cf0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101626:	89 d8                	mov    %ebx,%eax
      return f;
80101628:	83 c4 10             	add    $0x10,%esp
}
8010162b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010162e:	c9                   	leave  
8010162f:	c3                   	ret    
  release(&ftable.lock);
80101630:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101633:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101635:	68 80 04 11 80       	push   $0x80110480
8010163a:	e8 b1 36 00 00       	call   80104cf0 <release>
}
8010163f:	89 d8                	mov    %ebx,%eax
  return 0;
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101647:	c9                   	leave  
80101648:	c3                   	ret    
80101649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101650 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010165a:	68 80 04 11 80       	push   $0x80110480
8010165f:	e8 ec 36 00 00       	call   80104d50 <acquire>
  if(f->ref < 1)
80101664:	8b 43 04             	mov    0x4(%ebx),%eax
80101667:	83 c4 10             	add    $0x10,%esp
8010166a:	85 c0                	test   %eax,%eax
8010166c:	7e 1a                	jle    80101688 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010166e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101671:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101674:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101677:	68 80 04 11 80       	push   $0x80110480
8010167c:	e8 6f 36 00 00       	call   80104cf0 <release>
  return f;
}
80101681:	89 d8                	mov    %ebx,%eax
80101683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101686:	c9                   	leave  
80101687:	c3                   	ret    
    panic("filedup");
80101688:	83 ec 0c             	sub    $0xc,%esp
8010168b:	68 d4 79 10 80       	push   $0x801079d4
80101690:	e8 bb ed ff ff       	call   80100450 <panic>
80101695:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	56                   	push   %esi
801016a5:	53                   	push   %ebx
801016a6:	83 ec 28             	sub    $0x28,%esp
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801016ac:	68 80 04 11 80       	push   $0x80110480
801016b1:	e8 9a 36 00 00       	call   80104d50 <acquire>
  if(f->ref < 1)
801016b6:	8b 53 04             	mov    0x4(%ebx),%edx
801016b9:	83 c4 10             	add    $0x10,%esp
801016bc:	85 d2                	test   %edx,%edx
801016be:	0f 8e a5 00 00 00    	jle    80101769 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801016c4:	83 ea 01             	sub    $0x1,%edx
801016c7:	89 53 04             	mov    %edx,0x4(%ebx)
801016ca:	75 44                	jne    80101710 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801016cc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801016d0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801016d3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801016d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801016db:	8b 73 0c             	mov    0xc(%ebx),%esi
801016de:	88 45 e7             	mov    %al,-0x19(%ebp)
801016e1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801016e4:	68 80 04 11 80       	push   $0x80110480
  ff = *f;
801016e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801016ec:	e8 ff 35 00 00       	call   80104cf0 <release>

  if(ff.type == FD_PIPE)
801016f1:	83 c4 10             	add    $0x10,%esp
801016f4:	83 ff 01             	cmp    $0x1,%edi
801016f7:	74 57                	je     80101750 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801016f9:	83 ff 02             	cmp    $0x2,%edi
801016fc:	74 2a                	je     80101728 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101701:	5b                   	pop    %ebx
80101702:	5e                   	pop    %esi
80101703:	5f                   	pop    %edi
80101704:	5d                   	pop    %ebp
80101705:	c3                   	ret    
80101706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010170d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101710:	c7 45 08 80 04 11 80 	movl   $0x80110480,0x8(%ebp)
}
80101717:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010171a:	5b                   	pop    %ebx
8010171b:	5e                   	pop    %esi
8010171c:	5f                   	pop    %edi
8010171d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010171e:	e9 cd 35 00 00       	jmp    80104cf0 <release>
80101723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101727:	90                   	nop
    begin_op();
80101728:	e8 e3 1d 00 00       	call   80103510 <begin_op>
    iput(ff.ip);
8010172d:	83 ec 0c             	sub    $0xc,%esp
80101730:	ff 75 e0             	push   -0x20(%ebp)
80101733:	e8 28 09 00 00       	call   80102060 <iput>
    end_op();
80101738:	83 c4 10             	add    $0x10,%esp
}
8010173b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173e:	5b                   	pop    %ebx
8010173f:	5e                   	pop    %esi
80101740:	5f                   	pop    %edi
80101741:	5d                   	pop    %ebp
    end_op();
80101742:	e9 39 1e 00 00       	jmp    80103580 <end_op>
80101747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101750:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101754:	83 ec 08             	sub    $0x8,%esp
80101757:	53                   	push   %ebx
80101758:	56                   	push   %esi
80101759:	e8 82 25 00 00       	call   80103ce0 <pipeclose>
8010175e:	83 c4 10             	add    $0x10,%esp
}
80101761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5f                   	pop    %edi
80101767:	5d                   	pop    %ebp
80101768:	c3                   	ret    
    panic("fileclose");
80101769:	83 ec 0c             	sub    $0xc,%esp
8010176c:	68 dc 79 10 80       	push   $0x801079dc
80101771:	e8 da ec ff ff       	call   80100450 <panic>
80101776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010177d:	8d 76 00             	lea    0x0(%esi),%esi

80101780 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	53                   	push   %ebx
80101784:	83 ec 04             	sub    $0x4,%esp
80101787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010178a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010178d:	75 31                	jne    801017c0 <filestat+0x40>
    ilock(f->ip);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	ff 73 10             	push   0x10(%ebx)
80101795:	e8 96 07 00 00       	call   80101f30 <ilock>
    stati(f->ip, st);
8010179a:	58                   	pop    %eax
8010179b:	5a                   	pop    %edx
8010179c:	ff 75 0c             	push   0xc(%ebp)
8010179f:	ff 73 10             	push   0x10(%ebx)
801017a2:	e8 69 0a 00 00       	call   80102210 <stati>
    iunlock(f->ip);
801017a7:	59                   	pop    %ecx
801017a8:	ff 73 10             	push   0x10(%ebx)
801017ab:	e8 60 08 00 00       	call   80102010 <iunlock>
    return 0;
  }
  return -1;
}
801017b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801017b3:	83 c4 10             	add    $0x10,%esp
801017b6:	31 c0                	xor    %eax,%eax
}
801017b8:	c9                   	leave  
801017b9:	c3                   	ret    
801017ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801017c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801017c8:	c9                   	leave  
801017c9:	c3                   	ret    
801017ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801017d0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017dc:	8b 75 0c             	mov    0xc(%ebp),%esi
801017df:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801017e2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801017e6:	74 60                	je     80101848 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801017e8:	8b 03                	mov    (%ebx),%eax
801017ea:	83 f8 01             	cmp    $0x1,%eax
801017ed:	74 41                	je     80101830 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801017ef:	83 f8 02             	cmp    $0x2,%eax
801017f2:	75 5b                	jne    8010184f <fileread+0x7f>
    ilock(f->ip);
801017f4:	83 ec 0c             	sub    $0xc,%esp
801017f7:	ff 73 10             	push   0x10(%ebx)
801017fa:	e8 31 07 00 00       	call   80101f30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801017ff:	57                   	push   %edi
80101800:	ff 73 14             	push   0x14(%ebx)
80101803:	56                   	push   %esi
80101804:	ff 73 10             	push   0x10(%ebx)
80101807:	e8 34 0a 00 00       	call   80102240 <readi>
8010180c:	83 c4 20             	add    $0x20,%esp
8010180f:	89 c6                	mov    %eax,%esi
80101811:	85 c0                	test   %eax,%eax
80101813:	7e 03                	jle    80101818 <fileread+0x48>
      f->off += r;
80101815:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	ff 73 10             	push   0x10(%ebx)
8010181e:	e8 ed 07 00 00       	call   80102010 <iunlock>
    return r;
80101823:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101826:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101829:	89 f0                	mov    %esi,%eax
8010182b:	5b                   	pop    %ebx
8010182c:	5e                   	pop    %esi
8010182d:	5f                   	pop    %edi
8010182e:	5d                   	pop    %ebp
8010182f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101830:	8b 43 0c             	mov    0xc(%ebx),%eax
80101833:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101839:	5b                   	pop    %ebx
8010183a:	5e                   	pop    %esi
8010183b:	5f                   	pop    %edi
8010183c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010183d:	e9 3e 26 00 00       	jmp    80103e80 <piperead>
80101842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101848:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010184d:	eb d7                	jmp    80101826 <fileread+0x56>
  panic("fileread");
8010184f:	83 ec 0c             	sub    $0xc,%esp
80101852:	68 e6 79 10 80       	push   $0x801079e6
80101857:	e8 f4 eb ff ff       	call   80100450 <panic>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101860 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	57                   	push   %edi
80101864:	56                   	push   %esi
80101865:	53                   	push   %ebx
80101866:	83 ec 1c             	sub    $0x1c,%esp
80101869:	8b 45 0c             	mov    0xc(%ebp),%eax
8010186c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010186f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101872:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101875:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010187c:	0f 84 bd 00 00 00    	je     8010193f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101882:	8b 03                	mov    (%ebx),%eax
80101884:	83 f8 01             	cmp    $0x1,%eax
80101887:	0f 84 bf 00 00 00    	je     8010194c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010188d:	83 f8 02             	cmp    $0x2,%eax
80101890:	0f 85 c8 00 00 00    	jne    8010195e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101896:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101899:	31 f6                	xor    %esi,%esi
    while(i < n){
8010189b:	85 c0                	test   %eax,%eax
8010189d:	7f 30                	jg     801018cf <filewrite+0x6f>
8010189f:	e9 94 00 00 00       	jmp    80101938 <filewrite+0xd8>
801018a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801018a8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801018ab:	83 ec 0c             	sub    $0xc,%esp
801018ae:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801018b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801018b4:	e8 57 07 00 00       	call   80102010 <iunlock>
      end_op();
801018b9:	e8 c2 1c 00 00       	call   80103580 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801018be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801018c1:	83 c4 10             	add    $0x10,%esp
801018c4:	39 c7                	cmp    %eax,%edi
801018c6:	75 5c                	jne    80101924 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801018c8:	01 fe                	add    %edi,%esi
    while(i < n){
801018ca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801018cd:	7e 69                	jle    80101938 <filewrite+0xd8>
      int n1 = n - i;
801018cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018d2:	b8 00 06 00 00       	mov    $0x600,%eax
801018d7:	29 f7                	sub    %esi,%edi
801018d9:	39 c7                	cmp    %eax,%edi
801018db:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801018de:	e8 2d 1c 00 00       	call   80103510 <begin_op>
      ilock(f->ip);
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	ff 73 10             	push   0x10(%ebx)
801018e9:	e8 42 06 00 00       	call   80101f30 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801018ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
801018f1:	57                   	push   %edi
801018f2:	ff 73 14             	push   0x14(%ebx)
801018f5:	01 f0                	add    %esi,%eax
801018f7:	50                   	push   %eax
801018f8:	ff 73 10             	push   0x10(%ebx)
801018fb:	e8 40 0a 00 00       	call   80102340 <writei>
80101900:	83 c4 20             	add    $0x20,%esp
80101903:	85 c0                	test   %eax,%eax
80101905:	7f a1                	jg     801018a8 <filewrite+0x48>
      iunlock(f->ip);
80101907:	83 ec 0c             	sub    $0xc,%esp
8010190a:	ff 73 10             	push   0x10(%ebx)
8010190d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101910:	e8 fb 06 00 00       	call   80102010 <iunlock>
      end_op();
80101915:	e8 66 1c 00 00       	call   80103580 <end_op>
      if(r < 0)
8010191a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010191d:	83 c4 10             	add    $0x10,%esp
80101920:	85 c0                	test   %eax,%eax
80101922:	75 1b                	jne    8010193f <filewrite+0xdf>
        panic("short filewrite");
80101924:	83 ec 0c             	sub    $0xc,%esp
80101927:	68 ef 79 10 80       	push   $0x801079ef
8010192c:	e8 1f eb ff ff       	call   80100450 <panic>
80101931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101938:	89 f0                	mov    %esi,%eax
8010193a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010193d:	74 05                	je     80101944 <filewrite+0xe4>
8010193f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101944:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101947:	5b                   	pop    %ebx
80101948:	5e                   	pop    %esi
80101949:	5f                   	pop    %edi
8010194a:	5d                   	pop    %ebp
8010194b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010194c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010194f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101952:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101955:	5b                   	pop    %ebx
80101956:	5e                   	pop    %esi
80101957:	5f                   	pop    %edi
80101958:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101959:	e9 22 24 00 00       	jmp    80103d80 <pipewrite>
  panic("filewrite");
8010195e:	83 ec 0c             	sub    $0xc,%esp
80101961:	68 f5 79 10 80       	push   $0x801079f5
80101966:	e8 e5 ea ff ff       	call   80100450 <panic>
8010196b:	66 90                	xchg   %ax,%ax
8010196d:	66 90                	xchg   %ax,%ax
8010196f:	90                   	nop

80101970 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101970:	55                   	push   %ebp
80101971:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101973:	89 d0                	mov    %edx,%eax
80101975:	c1 e8 0c             	shr    $0xc,%eax
80101978:	03 05 ec 2a 11 80    	add    0x80112aec,%eax
{
8010197e:	89 e5                	mov    %esp,%ebp
80101980:	56                   	push   %esi
80101981:	53                   	push   %ebx
80101982:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101984:	83 ec 08             	sub    $0x8,%esp
80101987:	50                   	push   %eax
80101988:	51                   	push   %ecx
80101989:	e8 42 e7 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010198e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101990:	c1 fb 03             	sar    $0x3,%ebx
80101993:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101996:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101998:	83 e1 07             	and    $0x7,%ecx
8010199b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801019a0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801019a6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801019a8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801019ad:	85 c1                	test   %eax,%ecx
801019af:	74 23                	je     801019d4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801019b1:	f7 d0                	not    %eax
  log_write(bp);
801019b3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801019b6:	21 c8                	and    %ecx,%eax
801019b8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801019bc:	56                   	push   %esi
801019bd:	e8 2e 1d 00 00       	call   801036f0 <log_write>
  brelse(bp);
801019c2:	89 34 24             	mov    %esi,(%esp)
801019c5:	e8 26 e8 ff ff       	call   801001f0 <brelse>
}
801019ca:	83 c4 10             	add    $0x10,%esp
801019cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019d0:	5b                   	pop    %ebx
801019d1:	5e                   	pop    %esi
801019d2:	5d                   	pop    %ebp
801019d3:	c3                   	ret    
    panic("freeing free block");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 ff 79 10 80       	push   $0x801079ff
801019dc:	e8 6f ea ff ff       	call   80100450 <panic>
801019e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ef:	90                   	nop

801019f0 <balloc>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801019f9:	8b 0d d4 2a 11 80    	mov    0x80112ad4,%ecx
{
801019ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101a02:	85 c9                	test   %ecx,%ecx
80101a04:	0f 84 87 00 00 00    	je     80101a91 <balloc+0xa1>
80101a0a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101a11:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101a14:	83 ec 08             	sub    $0x8,%esp
80101a17:	89 f0                	mov    %esi,%eax
80101a19:	c1 f8 0c             	sar    $0xc,%eax
80101a1c:	03 05 ec 2a 11 80    	add    0x80112aec,%eax
80101a22:	50                   	push   %eax
80101a23:	ff 75 d8             	push   -0x28(%ebp)
80101a26:	e8 a5 e6 ff ff       	call   801000d0 <bread>
80101a2b:	83 c4 10             	add    $0x10,%esp
80101a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101a31:	a1 d4 2a 11 80       	mov    0x80112ad4,%eax
80101a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a39:	31 c0                	xor    %eax,%eax
80101a3b:	eb 2f                	jmp    80101a6c <balloc+0x7c>
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101a40:	89 c1                	mov    %eax,%ecx
80101a42:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101a47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101a4a:	83 e1 07             	and    $0x7,%ecx
80101a4d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101a4f:	89 c1                	mov    %eax,%ecx
80101a51:	c1 f9 03             	sar    $0x3,%ecx
80101a54:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101a59:	89 fa                	mov    %edi,%edx
80101a5b:	85 df                	test   %ebx,%edi
80101a5d:	74 41                	je     80101aa0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101a5f:	83 c0 01             	add    $0x1,%eax
80101a62:	83 c6 01             	add    $0x1,%esi
80101a65:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101a6a:	74 05                	je     80101a71 <balloc+0x81>
80101a6c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101a6f:	77 cf                	ja     80101a40 <balloc+0x50>
    brelse(bp);
80101a71:	83 ec 0c             	sub    $0xc,%esp
80101a74:	ff 75 e4             	push   -0x1c(%ebp)
80101a77:	e8 74 e7 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101a7c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101a83:	83 c4 10             	add    $0x10,%esp
80101a86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101a89:	39 05 d4 2a 11 80    	cmp    %eax,0x80112ad4
80101a8f:	77 80                	ja     80101a11 <balloc+0x21>
  panic("balloc: out of blocks");
80101a91:	83 ec 0c             	sub    $0xc,%esp
80101a94:	68 12 7a 10 80       	push   $0x80107a12
80101a99:	e8 b2 e9 ff ff       	call   80100450 <panic>
80101a9e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101aa0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101aa3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101aa6:	09 da                	or     %ebx,%edx
80101aa8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101aac:	57                   	push   %edi
80101aad:	e8 3e 1c 00 00       	call   801036f0 <log_write>
        brelse(bp);
80101ab2:	89 3c 24             	mov    %edi,(%esp)
80101ab5:	e8 36 e7 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101aba:	58                   	pop    %eax
80101abb:	5a                   	pop    %edx
80101abc:	56                   	push   %esi
80101abd:	ff 75 d8             	push   -0x28(%ebp)
80101ac0:	e8 0b e6 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101ac5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101ac8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101aca:	8d 40 5c             	lea    0x5c(%eax),%eax
80101acd:	68 00 02 00 00       	push   $0x200
80101ad2:	6a 00                	push   $0x0
80101ad4:	50                   	push   %eax
80101ad5:	e8 36 33 00 00       	call   80104e10 <memset>
  log_write(bp);
80101ada:	89 1c 24             	mov    %ebx,(%esp)
80101add:	e8 0e 1c 00 00       	call   801036f0 <log_write>
  brelse(bp);
80101ae2:	89 1c 24             	mov    %ebx,(%esp)
80101ae5:	e8 06 e7 ff ff       	call   801001f0 <brelse>
}
80101aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aed:	89 f0                	mov    %esi,%eax
80101aef:	5b                   	pop    %ebx
80101af0:	5e                   	pop    %esi
80101af1:	5f                   	pop    %edi
80101af2:	5d                   	pop    %ebp
80101af3:	c3                   	ret    
80101af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	89 c7                	mov    %eax,%edi
80101b06:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101b07:	31 f6                	xor    %esi,%esi
{
80101b09:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b0a:	bb b4 0e 11 80       	mov    $0x80110eb4,%ebx
{
80101b0f:	83 ec 28             	sub    $0x28,%esp
80101b12:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101b15:	68 80 0e 11 80       	push   $0x80110e80
80101b1a:	e8 31 32 00 00       	call   80104d50 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101b22:	83 c4 10             	add    $0x10,%esp
80101b25:	eb 1b                	jmp    80101b42 <iget+0x42>
80101b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b2e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101b30:	39 3b                	cmp    %edi,(%ebx)
80101b32:	74 6c                	je     80101ba0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b34:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101b3a:	81 fb d4 2a 11 80    	cmp    $0x80112ad4,%ebx
80101b40:	73 26                	jae    80101b68 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101b42:	8b 43 08             	mov    0x8(%ebx),%eax
80101b45:	85 c0                	test   %eax,%eax
80101b47:	7f e7                	jg     80101b30 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101b49:	85 f6                	test   %esi,%esi
80101b4b:	75 e7                	jne    80101b34 <iget+0x34>
80101b4d:	85 c0                	test   %eax,%eax
80101b4f:	75 76                	jne    80101bc7 <iget+0xc7>
80101b51:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b53:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101b59:	81 fb d4 2a 11 80    	cmp    $0x80112ad4,%ebx
80101b5f:	72 e1                	jb     80101b42 <iget+0x42>
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101b68:	85 f6                	test   %esi,%esi
80101b6a:	74 79                	je     80101be5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101b6c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101b6f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101b71:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101b74:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101b7b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101b82:	68 80 0e 11 80       	push   $0x80110e80
80101b87:	e8 64 31 00 00       	call   80104cf0 <release>

  return ip;
80101b8c:	83 c4 10             	add    $0x10,%esp
}
80101b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b92:	89 f0                	mov    %esi,%eax
80101b94:	5b                   	pop    %ebx
80101b95:	5e                   	pop    %esi
80101b96:	5f                   	pop    %edi
80101b97:	5d                   	pop    %ebp
80101b98:	c3                   	ret    
80101b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101ba0:	39 53 04             	cmp    %edx,0x4(%ebx)
80101ba3:	75 8f                	jne    80101b34 <iget+0x34>
      release(&icache.lock);
80101ba5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101ba8:	83 c0 01             	add    $0x1,%eax
      return ip;
80101bab:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101bad:	68 80 0e 11 80       	push   $0x80110e80
      ip->ref++;
80101bb2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101bb5:	e8 36 31 00 00       	call   80104cf0 <release>
      return ip;
80101bba:	83 c4 10             	add    $0x10,%esp
}
80101bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc0:	89 f0                	mov    %esi,%eax
80101bc2:	5b                   	pop    %ebx
80101bc3:	5e                   	pop    %esi
80101bc4:	5f                   	pop    %edi
80101bc5:	5d                   	pop    %ebp
80101bc6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bc7:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101bcd:	81 fb d4 2a 11 80    	cmp    $0x80112ad4,%ebx
80101bd3:	73 10                	jae    80101be5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bd5:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd8:	85 c0                	test   %eax,%eax
80101bda:	0f 8f 50 ff ff ff    	jg     80101b30 <iget+0x30>
80101be0:	e9 68 ff ff ff       	jmp    80101b4d <iget+0x4d>
    panic("iget: no inodes");
80101be5:	83 ec 0c             	sub    $0xc,%esp
80101be8:	68 28 7a 10 80       	push   $0x80107a28
80101bed:	e8 5e e8 ff ff       	call   80100450 <panic>
80101bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c00 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	89 c6                	mov    %eax,%esi
80101c07:	53                   	push   %ebx
80101c08:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c0b:	83 fa 0b             	cmp    $0xb,%edx
80101c0e:	0f 86 8c 00 00 00    	jbe    80101ca0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101c14:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101c17:	83 fb 7f             	cmp    $0x7f,%ebx
80101c1a:	0f 87 a2 00 00 00    	ja     80101cc2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c20:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101c26:	85 c0                	test   %eax,%eax
80101c28:	74 5e                	je     80101c88 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101c2a:	83 ec 08             	sub    $0x8,%esp
80101c2d:	50                   	push   %eax
80101c2e:	ff 36                	push   (%esi)
80101c30:	e8 9b e4 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101c35:	83 c4 10             	add    $0x10,%esp
80101c38:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101c3c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101c3e:	8b 3b                	mov    (%ebx),%edi
80101c40:	85 ff                	test   %edi,%edi
80101c42:	74 1c                	je     80101c60 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101c44:	83 ec 0c             	sub    $0xc,%esp
80101c47:	52                   	push   %edx
80101c48:	e8 a3 e5 ff ff       	call   801001f0 <brelse>
80101c4d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c53:	89 f8                	mov    %edi,%eax
80101c55:	5b                   	pop    %ebx
80101c56:	5e                   	pop    %esi
80101c57:	5f                   	pop    %edi
80101c58:	5d                   	pop    %ebp
80101c59:	c3                   	ret    
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101c63:	8b 06                	mov    (%esi),%eax
80101c65:	e8 86 fd ff ff       	call   801019f0 <balloc>
      log_write(bp);
80101c6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c6d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101c70:	89 03                	mov    %eax,(%ebx)
80101c72:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101c74:	52                   	push   %edx
80101c75:	e8 76 1a 00 00       	call   801036f0 <log_write>
80101c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c7d:	83 c4 10             	add    $0x10,%esp
80101c80:	eb c2                	jmp    80101c44 <bmap+0x44>
80101c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c88:	8b 06                	mov    (%esi),%eax
80101c8a:	e8 61 fd ff ff       	call   801019f0 <balloc>
80101c8f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101c95:	eb 93                	jmp    80101c2a <bmap+0x2a>
80101c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101ca0:	8d 5a 14             	lea    0x14(%edx),%ebx
80101ca3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101ca7:	85 ff                	test   %edi,%edi
80101ca9:	75 a5                	jne    80101c50 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cab:	8b 00                	mov    (%eax),%eax
80101cad:	e8 3e fd ff ff       	call   801019f0 <balloc>
80101cb2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101cb6:	89 c7                	mov    %eax,%edi
}
80101cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cbb:	5b                   	pop    %ebx
80101cbc:	89 f8                	mov    %edi,%eax
80101cbe:	5e                   	pop    %esi
80101cbf:	5f                   	pop    %edi
80101cc0:	5d                   	pop    %ebp
80101cc1:	c3                   	ret    
  panic("bmap: out of range");
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	68 38 7a 10 80       	push   $0x80107a38
80101cca:	e8 81 e7 ff ff       	call   80100450 <panic>
80101ccf:	90                   	nop

80101cd0 <readsb>:
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	56                   	push   %esi
80101cd4:	53                   	push   %ebx
80101cd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101cd8:	83 ec 08             	sub    $0x8,%esp
80101cdb:	6a 01                	push   $0x1
80101cdd:	ff 75 08             	push   0x8(%ebp)
80101ce0:	e8 eb e3 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101ce5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101ce8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101cea:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ced:	6a 1c                	push   $0x1c
80101cef:	50                   	push   %eax
80101cf0:	56                   	push   %esi
80101cf1:	e8 ba 31 00 00       	call   80104eb0 <memmove>
  brelse(bp);
80101cf6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101cf9:	83 c4 10             	add    $0x10,%esp
}
80101cfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cff:	5b                   	pop    %ebx
80101d00:	5e                   	pop    %esi
80101d01:	5d                   	pop    %ebp
  brelse(bp);
80101d02:	e9 e9 e4 ff ff       	jmp    801001f0 <brelse>
80101d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d0e:	66 90                	xchg   %ax,%ax

80101d10 <iinit>:
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	53                   	push   %ebx
80101d14:	bb c0 0e 11 80       	mov    $0x80110ec0,%ebx
80101d19:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101d1c:	68 4b 7a 10 80       	push   $0x80107a4b
80101d21:	68 80 0e 11 80       	push   $0x80110e80
80101d26:	e8 55 2e 00 00       	call   80104b80 <initlock>
  for(i = 0; i < NINODE; i++) {
80101d2b:	83 c4 10             	add    $0x10,%esp
80101d2e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101d30:	83 ec 08             	sub    $0x8,%esp
80101d33:	68 52 7a 10 80       	push   $0x80107a52
80101d38:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101d39:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101d3f:	e8 0c 2d 00 00       	call   80104a50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101d44:	83 c4 10             	add    $0x10,%esp
80101d47:	81 fb e0 2a 11 80    	cmp    $0x80112ae0,%ebx
80101d4d:	75 e1                	jne    80101d30 <iinit+0x20>
  bp = bread(dev, 1);
80101d4f:	83 ec 08             	sub    $0x8,%esp
80101d52:	6a 01                	push   $0x1
80101d54:	ff 75 08             	push   0x8(%ebp)
80101d57:	e8 74 e3 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101d5c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101d5f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101d61:	8d 40 5c             	lea    0x5c(%eax),%eax
80101d64:	6a 1c                	push   $0x1c
80101d66:	50                   	push   %eax
80101d67:	68 d4 2a 11 80       	push   $0x80112ad4
80101d6c:	e8 3f 31 00 00       	call   80104eb0 <memmove>
  brelse(bp);
80101d71:	89 1c 24             	mov    %ebx,(%esp)
80101d74:	e8 77 e4 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101d79:	ff 35 ec 2a 11 80    	push   0x80112aec
80101d7f:	ff 35 e8 2a 11 80    	push   0x80112ae8
80101d85:	ff 35 e4 2a 11 80    	push   0x80112ae4
80101d8b:	ff 35 e0 2a 11 80    	push   0x80112ae0
80101d91:	ff 35 dc 2a 11 80    	push   0x80112adc
80101d97:	ff 35 d8 2a 11 80    	push   0x80112ad8
80101d9d:	ff 35 d4 2a 11 80    	push   0x80112ad4
80101da3:	68 b8 7a 10 80       	push   $0x80107ab8
80101da8:	e8 d3 ea ff ff       	call   80100880 <cprintf>
}
80101dad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101db0:	83 c4 30             	add    $0x30,%esp
80101db3:	c9                   	leave  
80101db4:	c3                   	ret    
80101db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <ialloc>:
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	83 ec 1c             	sub    $0x1c,%esp
80101dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101dcc:	83 3d dc 2a 11 80 01 	cmpl   $0x1,0x80112adc
{
80101dd3:	8b 75 08             	mov    0x8(%ebp),%esi
80101dd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101dd9:	0f 86 91 00 00 00    	jbe    80101e70 <ialloc+0xb0>
80101ddf:	bf 01 00 00 00       	mov    $0x1,%edi
80101de4:	eb 21                	jmp    80101e07 <ialloc+0x47>
80101de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ded:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101df0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101df3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101df6:	53                   	push   %ebx
80101df7:	e8 f4 e3 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101dfc:	83 c4 10             	add    $0x10,%esp
80101dff:	3b 3d dc 2a 11 80    	cmp    0x80112adc,%edi
80101e05:	73 69                	jae    80101e70 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101e07:	89 f8                	mov    %edi,%eax
80101e09:	83 ec 08             	sub    $0x8,%esp
80101e0c:	c1 e8 03             	shr    $0x3,%eax
80101e0f:	03 05 e8 2a 11 80    	add    0x80112ae8,%eax
80101e15:	50                   	push   %eax
80101e16:	56                   	push   %esi
80101e17:	e8 b4 e2 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101e1c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101e1f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101e21:	89 f8                	mov    %edi,%eax
80101e23:	83 e0 07             	and    $0x7,%eax
80101e26:	c1 e0 06             	shl    $0x6,%eax
80101e29:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101e2d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101e31:	75 bd                	jne    80101df0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101e33:	83 ec 04             	sub    $0x4,%esp
80101e36:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e39:	6a 40                	push   $0x40
80101e3b:	6a 00                	push   $0x0
80101e3d:	51                   	push   %ecx
80101e3e:	e8 cd 2f 00 00       	call   80104e10 <memset>
      dip->type = type;
80101e43:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101e47:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101e4a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101e4d:	89 1c 24             	mov    %ebx,(%esp)
80101e50:	e8 9b 18 00 00       	call   801036f0 <log_write>
      brelse(bp);
80101e55:	89 1c 24             	mov    %ebx,(%esp)
80101e58:	e8 93 e3 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101e5d:	83 c4 10             	add    $0x10,%esp
}
80101e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101e63:	89 fa                	mov    %edi,%edx
}
80101e65:	5b                   	pop    %ebx
      return iget(dev, inum);
80101e66:	89 f0                	mov    %esi,%eax
}
80101e68:	5e                   	pop    %esi
80101e69:	5f                   	pop    %edi
80101e6a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101e6b:	e9 90 fc ff ff       	jmp    80101b00 <iget>
  panic("ialloc: no inodes");
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	68 58 7a 10 80       	push   $0x80107a58
80101e78:	e8 d3 e5 ff ff       	call   80100450 <panic>
80101e7d:	8d 76 00             	lea    0x0(%esi),%esi

80101e80 <iupdate>:
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	56                   	push   %esi
80101e84:	53                   	push   %ebx
80101e85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e88:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101e8b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e8e:	83 ec 08             	sub    $0x8,%esp
80101e91:	c1 e8 03             	shr    $0x3,%eax
80101e94:	03 05 e8 2a 11 80    	add    0x80112ae8,%eax
80101e9a:	50                   	push   %eax
80101e9b:	ff 73 a4             	push   -0x5c(%ebx)
80101e9e:	e8 2d e2 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101ea3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ea7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101eaa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101eac:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101eaf:	83 e0 07             	and    $0x7,%eax
80101eb2:	c1 e0 06             	shl    $0x6,%eax
80101eb5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101eb9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101ebc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ec0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101ec3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101ec7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101ecb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101ecf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ed3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101ed7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101eda:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101edd:	6a 34                	push   $0x34
80101edf:	53                   	push   %ebx
80101ee0:	50                   	push   %eax
80101ee1:	e8 ca 2f 00 00       	call   80104eb0 <memmove>
  log_write(bp);
80101ee6:	89 34 24             	mov    %esi,(%esp)
80101ee9:	e8 02 18 00 00       	call   801036f0 <log_write>
  brelse(bp);
80101eee:	89 75 08             	mov    %esi,0x8(%ebp)
80101ef1:	83 c4 10             	add    $0x10,%esp
}
80101ef4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ef7:	5b                   	pop    %ebx
80101ef8:	5e                   	pop    %esi
80101ef9:	5d                   	pop    %ebp
  brelse(bp);
80101efa:	e9 f1 e2 ff ff       	jmp    801001f0 <brelse>
80101eff:	90                   	nop

80101f00 <idup>:
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	53                   	push   %ebx
80101f04:	83 ec 10             	sub    $0x10,%esp
80101f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101f0a:	68 80 0e 11 80       	push   $0x80110e80
80101f0f:	e8 3c 2e 00 00       	call   80104d50 <acquire>
  ip->ref++;
80101f14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101f18:	c7 04 24 80 0e 11 80 	movl   $0x80110e80,(%esp)
80101f1f:	e8 cc 2d 00 00       	call   80104cf0 <release>
}
80101f24:	89 d8                	mov    %ebx,%eax
80101f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f29:	c9                   	leave  
80101f2a:	c3                   	ret    
80101f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop

80101f30 <ilock>:
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	56                   	push   %esi
80101f34:	53                   	push   %ebx
80101f35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101f38:	85 db                	test   %ebx,%ebx
80101f3a:	0f 84 b7 00 00 00    	je     80101ff7 <ilock+0xc7>
80101f40:	8b 53 08             	mov    0x8(%ebx),%edx
80101f43:	85 d2                	test   %edx,%edx
80101f45:	0f 8e ac 00 00 00    	jle    80101ff7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101f4b:	83 ec 0c             	sub    $0xc,%esp
80101f4e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101f51:	50                   	push   %eax
80101f52:	e8 39 2b 00 00       	call   80104a90 <acquiresleep>
  if(ip->valid == 0){
80101f57:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101f5a:	83 c4 10             	add    $0x10,%esp
80101f5d:	85 c0                	test   %eax,%eax
80101f5f:	74 0f                	je     80101f70 <ilock+0x40>
}
80101f61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f64:	5b                   	pop    %ebx
80101f65:	5e                   	pop    %esi
80101f66:	5d                   	pop    %ebp
80101f67:	c3                   	ret    
80101f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f70:	8b 43 04             	mov    0x4(%ebx),%eax
80101f73:	83 ec 08             	sub    $0x8,%esp
80101f76:	c1 e8 03             	shr    $0x3,%eax
80101f79:	03 05 e8 2a 11 80    	add    0x80112ae8,%eax
80101f7f:	50                   	push   %eax
80101f80:	ff 33                	push   (%ebx)
80101f82:	e8 49 e1 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101f87:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f8a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101f8c:	8b 43 04             	mov    0x4(%ebx),%eax
80101f8f:	83 e0 07             	and    $0x7,%eax
80101f92:	c1 e0 06             	shl    $0x6,%eax
80101f95:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101f99:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101f9c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101f9f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101fa3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101fa7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101fab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101faf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101fb3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101fb7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101fbb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101fbe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101fc1:	6a 34                	push   $0x34
80101fc3:	50                   	push   %eax
80101fc4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101fc7:	50                   	push   %eax
80101fc8:	e8 e3 2e 00 00       	call   80104eb0 <memmove>
    brelse(bp);
80101fcd:	89 34 24             	mov    %esi,(%esp)
80101fd0:	e8 1b e2 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101fd5:	83 c4 10             	add    $0x10,%esp
80101fd8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101fdd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101fe4:	0f 85 77 ff ff ff    	jne    80101f61 <ilock+0x31>
      panic("ilock: no type");
80101fea:	83 ec 0c             	sub    $0xc,%esp
80101fed:	68 70 7a 10 80       	push   $0x80107a70
80101ff2:	e8 59 e4 ff ff       	call   80100450 <panic>
    panic("ilock");
80101ff7:	83 ec 0c             	sub    $0xc,%esp
80101ffa:	68 6a 7a 10 80       	push   $0x80107a6a
80101fff:	e8 4c e4 ff ff       	call   80100450 <panic>
80102004:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010200b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010200f:	90                   	nop

80102010 <iunlock>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	56                   	push   %esi
80102014:	53                   	push   %ebx
80102015:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102018:	85 db                	test   %ebx,%ebx
8010201a:	74 28                	je     80102044 <iunlock+0x34>
8010201c:	83 ec 0c             	sub    $0xc,%esp
8010201f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102022:	56                   	push   %esi
80102023:	e8 08 2b 00 00       	call   80104b30 <holdingsleep>
80102028:	83 c4 10             	add    $0x10,%esp
8010202b:	85 c0                	test   %eax,%eax
8010202d:	74 15                	je     80102044 <iunlock+0x34>
8010202f:	8b 43 08             	mov    0x8(%ebx),%eax
80102032:	85 c0                	test   %eax,%eax
80102034:	7e 0e                	jle    80102044 <iunlock+0x34>
  releasesleep(&ip->lock);
80102036:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102039:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010203c:	5b                   	pop    %ebx
8010203d:	5e                   	pop    %esi
8010203e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010203f:	e9 ac 2a 00 00       	jmp    80104af0 <releasesleep>
    panic("iunlock");
80102044:	83 ec 0c             	sub    $0xc,%esp
80102047:	68 7f 7a 10 80       	push   $0x80107a7f
8010204c:	e8 ff e3 ff ff       	call   80100450 <panic>
80102051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205f:	90                   	nop

80102060 <iput>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 28             	sub    $0x28,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010206c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010206f:	57                   	push   %edi
80102070:	e8 1b 2a 00 00       	call   80104a90 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102075:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	85 d2                	test   %edx,%edx
8010207d:	74 07                	je     80102086 <iput+0x26>
8010207f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102084:	74 32                	je     801020b8 <iput+0x58>
  releasesleep(&ip->lock);
80102086:	83 ec 0c             	sub    $0xc,%esp
80102089:	57                   	push   %edi
8010208a:	e8 61 2a 00 00       	call   80104af0 <releasesleep>
  acquire(&icache.lock);
8010208f:	c7 04 24 80 0e 11 80 	movl   $0x80110e80,(%esp)
80102096:	e8 b5 2c 00 00       	call   80104d50 <acquire>
  ip->ref--;
8010209b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010209f:	83 c4 10             	add    $0x10,%esp
801020a2:	c7 45 08 80 0e 11 80 	movl   $0x80110e80,0x8(%ebp)
}
801020a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ac:	5b                   	pop    %ebx
801020ad:	5e                   	pop    %esi
801020ae:	5f                   	pop    %edi
801020af:	5d                   	pop    %ebp
  release(&icache.lock);
801020b0:	e9 3b 2c 00 00       	jmp    80104cf0 <release>
801020b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 80 0e 11 80       	push   $0x80110e80
801020c0:	e8 8b 2c 00 00       	call   80104d50 <acquire>
    int r = ip->ref;
801020c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801020c8:	c7 04 24 80 0e 11 80 	movl   $0x80110e80,(%esp)
801020cf:	e8 1c 2c 00 00       	call   80104cf0 <release>
    if(r == 1){
801020d4:	83 c4 10             	add    $0x10,%esp
801020d7:	83 fe 01             	cmp    $0x1,%esi
801020da:	75 aa                	jne    80102086 <iput+0x26>
801020dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801020e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801020e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020e8:	89 cf                	mov    %ecx,%edi
801020ea:	eb 0b                	jmp    801020f7 <iput+0x97>
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801020f0:	83 c6 04             	add    $0x4,%esi
801020f3:	39 fe                	cmp    %edi,%esi
801020f5:	74 19                	je     80102110 <iput+0xb0>
    if(ip->addrs[i]){
801020f7:	8b 16                	mov    (%esi),%edx
801020f9:	85 d2                	test   %edx,%edx
801020fb:	74 f3                	je     801020f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801020fd:	8b 03                	mov    (%ebx),%eax
801020ff:	e8 6c f8 ff ff       	call   80101970 <bfree>
      ip->addrs[i] = 0;
80102104:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010210a:	eb e4                	jmp    801020f0 <iput+0x90>
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102110:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102116:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102119:	85 c0                	test   %eax,%eax
8010211b:	75 2d                	jne    8010214a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010211d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102120:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102127:	53                   	push   %ebx
80102128:	e8 53 fd ff ff       	call   80101e80 <iupdate>
      ip->type = 0;
8010212d:	31 c0                	xor    %eax,%eax
8010212f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102133:	89 1c 24             	mov    %ebx,(%esp)
80102136:	e8 45 fd ff ff       	call   80101e80 <iupdate>
      ip->valid = 0;
8010213b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102142:	83 c4 10             	add    $0x10,%esp
80102145:	e9 3c ff ff ff       	jmp    80102086 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010214a:	83 ec 08             	sub    $0x8,%esp
8010214d:	50                   	push   %eax
8010214e:	ff 33                	push   (%ebx)
80102150:	e8 7b df ff ff       	call   801000d0 <bread>
80102155:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102158:	83 c4 10             	add    $0x10,%esp
8010215b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102164:	8d 70 5c             	lea    0x5c(%eax),%esi
80102167:	89 cf                	mov    %ecx,%edi
80102169:	eb 0c                	jmp    80102177 <iput+0x117>
8010216b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010216f:	90                   	nop
80102170:	83 c6 04             	add    $0x4,%esi
80102173:	39 f7                	cmp    %esi,%edi
80102175:	74 0f                	je     80102186 <iput+0x126>
      if(a[j])
80102177:	8b 16                	mov    (%esi),%edx
80102179:	85 d2                	test   %edx,%edx
8010217b:	74 f3                	je     80102170 <iput+0x110>
        bfree(ip->dev, a[j]);
8010217d:	8b 03                	mov    (%ebx),%eax
8010217f:	e8 ec f7 ff ff       	call   80101970 <bfree>
80102184:	eb ea                	jmp    80102170 <iput+0x110>
    brelse(bp);
80102186:	83 ec 0c             	sub    $0xc,%esp
80102189:	ff 75 e4             	push   -0x1c(%ebp)
8010218c:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010218f:	e8 5c e0 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102194:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010219a:	8b 03                	mov    (%ebx),%eax
8010219c:	e8 cf f7 ff ff       	call   80101970 <bfree>
    ip->addrs[NDIRECT] = 0;
801021a1:	83 c4 10             	add    $0x10,%esp
801021a4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801021ab:	00 00 00 
801021ae:	e9 6a ff ff ff       	jmp    8010211d <iput+0xbd>
801021b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021c0 <iunlockput>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx
801021c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021c8:	85 db                	test   %ebx,%ebx
801021ca:	74 34                	je     80102200 <iunlockput+0x40>
801021cc:	83 ec 0c             	sub    $0xc,%esp
801021cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801021d2:	56                   	push   %esi
801021d3:	e8 58 29 00 00       	call   80104b30 <holdingsleep>
801021d8:	83 c4 10             	add    $0x10,%esp
801021db:	85 c0                	test   %eax,%eax
801021dd:	74 21                	je     80102200 <iunlockput+0x40>
801021df:	8b 43 08             	mov    0x8(%ebx),%eax
801021e2:	85 c0                	test   %eax,%eax
801021e4:	7e 1a                	jle    80102200 <iunlockput+0x40>
  releasesleep(&ip->lock);
801021e6:	83 ec 0c             	sub    $0xc,%esp
801021e9:	56                   	push   %esi
801021ea:	e8 01 29 00 00       	call   80104af0 <releasesleep>
  iput(ip);
801021ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
801021f2:	83 c4 10             	add    $0x10,%esp
}
801021f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021f8:	5b                   	pop    %ebx
801021f9:	5e                   	pop    %esi
801021fa:	5d                   	pop    %ebp
  iput(ip);
801021fb:	e9 60 fe ff ff       	jmp    80102060 <iput>
    panic("iunlock");
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	68 7f 7a 10 80       	push   $0x80107a7f
80102208:	e8 43 e2 ff ff       	call   80100450 <panic>
8010220d:	8d 76 00             	lea    0x0(%esi),%esi

80102210 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	8b 55 08             	mov    0x8(%ebp),%edx
80102216:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102219:	8b 0a                	mov    (%edx),%ecx
8010221b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010221e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102221:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102224:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102228:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010222b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010222f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102233:	8b 52 58             	mov    0x58(%edx),%edx
80102236:	89 50 10             	mov    %edx,0x10(%eax)
}
80102239:	5d                   	pop    %ebp
8010223a:	c3                   	ret    
8010223b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 1c             	sub    $0x1c,%esp
80102249:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010224c:	8b 45 08             	mov    0x8(%ebp),%eax
8010224f:	8b 75 10             	mov    0x10(%ebp),%esi
80102252:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102255:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102258:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010225d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102260:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102263:	0f 84 a7 00 00 00    	je     80102310 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102269:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010226c:	8b 40 58             	mov    0x58(%eax),%eax
8010226f:	39 c6                	cmp    %eax,%esi
80102271:	0f 87 ba 00 00 00    	ja     80102331 <readi+0xf1>
80102277:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010227a:	31 c9                	xor    %ecx,%ecx
8010227c:	89 da                	mov    %ebx,%edx
8010227e:	01 f2                	add    %esi,%edx
80102280:	0f 92 c1             	setb   %cl
80102283:	89 cf                	mov    %ecx,%edi
80102285:	0f 82 a6 00 00 00    	jb     80102331 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010228b:	89 c1                	mov    %eax,%ecx
8010228d:	29 f1                	sub    %esi,%ecx
8010228f:	39 d0                	cmp    %edx,%eax
80102291:	0f 43 cb             	cmovae %ebx,%ecx
80102294:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102297:	85 c9                	test   %ecx,%ecx
80102299:	74 67                	je     80102302 <readi+0xc2>
8010229b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801022a3:	89 f2                	mov    %esi,%edx
801022a5:	c1 ea 09             	shr    $0x9,%edx
801022a8:	89 d8                	mov    %ebx,%eax
801022aa:	e8 51 f9 ff ff       	call   80101c00 <bmap>
801022af:	83 ec 08             	sub    $0x8,%esp
801022b2:	50                   	push   %eax
801022b3:	ff 33                	push   (%ebx)
801022b5:	e8 16 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801022ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801022bd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022c2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801022c4:	89 f0                	mov    %esi,%eax
801022c6:	25 ff 01 00 00       	and    $0x1ff,%eax
801022cb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801022cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022d0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801022d2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801022d6:	39 d9                	cmp    %ebx,%ecx
801022d8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801022db:	83 c4 0c             	add    $0xc,%esp
801022de:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801022df:	01 df                	add    %ebx,%edi
801022e1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801022e3:	50                   	push   %eax
801022e4:	ff 75 e0             	push   -0x20(%ebp)
801022e7:	e8 c4 2b 00 00       	call   80104eb0 <memmove>
    brelse(bp);
801022ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
801022ef:	89 14 24             	mov    %edx,(%esp)
801022f2:	e8 f9 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801022f7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801022fa:	83 c4 10             	add    $0x10,%esp
801022fd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102300:	77 9e                	ja     801022a0 <readi+0x60>
  }
  return n;
80102302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102308:	5b                   	pop    %ebx
80102309:	5e                   	pop    %esi
8010230a:	5f                   	pop    %edi
8010230b:	5d                   	pop    %ebp
8010230c:	c3                   	ret    
8010230d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102310:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102314:	66 83 f8 09          	cmp    $0x9,%ax
80102318:	77 17                	ja     80102331 <readi+0xf1>
8010231a:	8b 04 c5 20 0e 11 80 	mov    -0x7feef1e0(,%eax,8),%eax
80102321:	85 c0                	test   %eax,%eax
80102323:	74 0c                	je     80102331 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102325:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010232b:	5b                   	pop    %ebx
8010232c:	5e                   	pop    %esi
8010232d:	5f                   	pop    %edi
8010232e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010232f:	ff e0                	jmp    *%eax
      return -1;
80102331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102336:	eb cd                	jmp    80102305 <readi+0xc5>
80102338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop

80102340 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	57                   	push   %edi
80102344:	56                   	push   %esi
80102345:	53                   	push   %ebx
80102346:	83 ec 1c             	sub    $0x1c,%esp
80102349:	8b 45 08             	mov    0x8(%ebp),%eax
8010234c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010234f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102352:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102357:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010235a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010235d:	8b 75 10             	mov    0x10(%ebp),%esi
80102360:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102363:	0f 84 b7 00 00 00    	je     80102420 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102369:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010236c:	3b 70 58             	cmp    0x58(%eax),%esi
8010236f:	0f 87 e7 00 00 00    	ja     8010245c <writei+0x11c>
80102375:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102378:	31 d2                	xor    %edx,%edx
8010237a:	89 f8                	mov    %edi,%eax
8010237c:	01 f0                	add    %esi,%eax
8010237e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102381:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102386:	0f 87 d0 00 00 00    	ja     8010245c <writei+0x11c>
8010238c:	85 d2                	test   %edx,%edx
8010238e:	0f 85 c8 00 00 00    	jne    8010245c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102394:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010239b:	85 ff                	test   %edi,%edi
8010239d:	74 72                	je     80102411 <writei+0xd1>
8010239f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801023a0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801023a3:	89 f2                	mov    %esi,%edx
801023a5:	c1 ea 09             	shr    $0x9,%edx
801023a8:	89 f8                	mov    %edi,%eax
801023aa:	e8 51 f8 ff ff       	call   80101c00 <bmap>
801023af:	83 ec 08             	sub    $0x8,%esp
801023b2:	50                   	push   %eax
801023b3:	ff 37                	push   (%edi)
801023b5:	e8 16 dd ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801023ba:	b9 00 02 00 00       	mov    $0x200,%ecx
801023bf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801023c2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801023c5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801023c7:	89 f0                	mov    %esi,%eax
801023c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801023ce:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801023d0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801023d4:	39 d9                	cmp    %ebx,%ecx
801023d6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801023d9:	83 c4 0c             	add    $0xc,%esp
801023dc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801023dd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801023df:	ff 75 dc             	push   -0x24(%ebp)
801023e2:	50                   	push   %eax
801023e3:	e8 c8 2a 00 00       	call   80104eb0 <memmove>
    log_write(bp);
801023e8:	89 3c 24             	mov    %edi,(%esp)
801023eb:	e8 00 13 00 00       	call   801036f0 <log_write>
    brelse(bp);
801023f0:	89 3c 24             	mov    %edi,(%esp)
801023f3:	e8 f8 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801023f8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801023fb:	83 c4 10             	add    $0x10,%esp
801023fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102401:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102404:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102407:	77 97                	ja     801023a0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102409:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010240c:	3b 70 58             	cmp    0x58(%eax),%esi
8010240f:	77 37                	ja     80102448 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102411:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102417:	5b                   	pop    %ebx
80102418:	5e                   	pop    %esi
80102419:	5f                   	pop    %edi
8010241a:	5d                   	pop    %ebp
8010241b:	c3                   	ret    
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102420:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102424:	66 83 f8 09          	cmp    $0x9,%ax
80102428:	77 32                	ja     8010245c <writei+0x11c>
8010242a:	8b 04 c5 24 0e 11 80 	mov    -0x7feef1dc(,%eax,8),%eax
80102431:	85 c0                	test   %eax,%eax
80102433:	74 27                	je     8010245c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102435:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102438:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010243b:	5b                   	pop    %ebx
8010243c:	5e                   	pop    %esi
8010243d:	5f                   	pop    %edi
8010243e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010243f:	ff e0                	jmp    *%eax
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102448:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010244b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010244e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102451:	50                   	push   %eax
80102452:	e8 29 fa ff ff       	call   80101e80 <iupdate>
80102457:	83 c4 10             	add    $0x10,%esp
8010245a:	eb b5                	jmp    80102411 <writei+0xd1>
      return -1;
8010245c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102461:	eb b1                	jmp    80102414 <writei+0xd4>
80102463:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102470 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102476:	6a 0e                	push   $0xe
80102478:	ff 75 0c             	push   0xc(%ebp)
8010247b:	ff 75 08             	push   0x8(%ebp)
8010247e:	e8 9d 2a 00 00       	call   80104f20 <strncmp>
}
80102483:	c9                   	leave  
80102484:	c3                   	ret    
80102485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	57                   	push   %edi
80102494:	56                   	push   %esi
80102495:	53                   	push   %ebx
80102496:	83 ec 1c             	sub    $0x1c,%esp
80102499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010249c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801024a1:	0f 85 85 00 00 00    	jne    8010252c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801024a7:	8b 53 58             	mov    0x58(%ebx),%edx
801024aa:	31 ff                	xor    %edi,%edi
801024ac:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024af:	85 d2                	test   %edx,%edx
801024b1:	74 3e                	je     801024f1 <dirlookup+0x61>
801024b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b8:	6a 10                	push   $0x10
801024ba:	57                   	push   %edi
801024bb:	56                   	push   %esi
801024bc:	53                   	push   %ebx
801024bd:	e8 7e fd ff ff       	call   80102240 <readi>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	83 f8 10             	cmp    $0x10,%eax
801024c8:	75 55                	jne    8010251f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801024ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024cf:	74 18                	je     801024e9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801024d1:	83 ec 04             	sub    $0x4,%esp
801024d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801024d7:	6a 0e                	push   $0xe
801024d9:	50                   	push   %eax
801024da:	ff 75 0c             	push   0xc(%ebp)
801024dd:	e8 3e 2a 00 00       	call   80104f20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801024e2:	83 c4 10             	add    $0x10,%esp
801024e5:	85 c0                	test   %eax,%eax
801024e7:	74 17                	je     80102500 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801024e9:	83 c7 10             	add    $0x10,%edi
801024ec:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024ef:	72 c7                	jb     801024b8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801024f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801024f4:	31 c0                	xor    %eax,%eax
}
801024f6:	5b                   	pop    %ebx
801024f7:	5e                   	pop    %esi
801024f8:	5f                   	pop    %edi
801024f9:	5d                   	pop    %ebp
801024fa:	c3                   	ret    
801024fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop
      if(poff)
80102500:	8b 45 10             	mov    0x10(%ebp),%eax
80102503:	85 c0                	test   %eax,%eax
80102505:	74 05                	je     8010250c <dirlookup+0x7c>
        *poff = off;
80102507:	8b 45 10             	mov    0x10(%ebp),%eax
8010250a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010250c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102510:	8b 03                	mov    (%ebx),%eax
80102512:	e8 e9 f5 ff ff       	call   80101b00 <iget>
}
80102517:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010251a:	5b                   	pop    %ebx
8010251b:	5e                   	pop    %esi
8010251c:	5f                   	pop    %edi
8010251d:	5d                   	pop    %ebp
8010251e:	c3                   	ret    
      panic("dirlookup read");
8010251f:	83 ec 0c             	sub    $0xc,%esp
80102522:	68 99 7a 10 80       	push   $0x80107a99
80102527:	e8 24 df ff ff       	call   80100450 <panic>
    panic("dirlookup not DIR");
8010252c:	83 ec 0c             	sub    $0xc,%esp
8010252f:	68 87 7a 10 80       	push   $0x80107a87
80102534:	e8 17 df ff ff       	call   80100450 <panic>
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102540 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	57                   	push   %edi
80102544:	56                   	push   %esi
80102545:	53                   	push   %ebx
80102546:	89 c3                	mov    %eax,%ebx
80102548:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010254b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010254e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102551:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102554:	0f 84 64 01 00 00    	je     801026be <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010255a:	e8 c1 1b 00 00       	call   80104120 <myproc>
  acquire(&icache.lock);
8010255f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102562:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102565:	68 80 0e 11 80       	push   $0x80110e80
8010256a:	e8 e1 27 00 00       	call   80104d50 <acquire>
  ip->ref++;
8010256f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102573:	c7 04 24 80 0e 11 80 	movl   $0x80110e80,(%esp)
8010257a:	e8 71 27 00 00       	call   80104cf0 <release>
8010257f:	83 c4 10             	add    $0x10,%esp
80102582:	eb 07                	jmp    8010258b <namex+0x4b>
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102588:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010258b:	0f b6 03             	movzbl (%ebx),%eax
8010258e:	3c 2f                	cmp    $0x2f,%al
80102590:	74 f6                	je     80102588 <namex+0x48>
  if(*path == 0)
80102592:	84 c0                	test   %al,%al
80102594:	0f 84 06 01 00 00    	je     801026a0 <namex+0x160>
  while(*path != '/' && *path != 0)
8010259a:	0f b6 03             	movzbl (%ebx),%eax
8010259d:	84 c0                	test   %al,%al
8010259f:	0f 84 10 01 00 00    	je     801026b5 <namex+0x175>
801025a5:	89 df                	mov    %ebx,%edi
801025a7:	3c 2f                	cmp    $0x2f,%al
801025a9:	0f 84 06 01 00 00    	je     801026b5 <namex+0x175>
801025af:	90                   	nop
801025b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801025b4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801025b7:	3c 2f                	cmp    $0x2f,%al
801025b9:	74 04                	je     801025bf <namex+0x7f>
801025bb:	84 c0                	test   %al,%al
801025bd:	75 f1                	jne    801025b0 <namex+0x70>
  len = path - s;
801025bf:	89 f8                	mov    %edi,%eax
801025c1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801025c3:	83 f8 0d             	cmp    $0xd,%eax
801025c6:	0f 8e ac 00 00 00    	jle    80102678 <namex+0x138>
    memmove(name, s, DIRSIZ);
801025cc:	83 ec 04             	sub    $0x4,%esp
801025cf:	6a 0e                	push   $0xe
801025d1:	53                   	push   %ebx
    path++;
801025d2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801025d4:	ff 75 e4             	push   -0x1c(%ebp)
801025d7:	e8 d4 28 00 00       	call   80104eb0 <memmove>
801025dc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801025df:	80 3f 2f             	cmpb   $0x2f,(%edi)
801025e2:	75 0c                	jne    801025f0 <namex+0xb0>
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801025e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801025eb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801025ee:	74 f8                	je     801025e8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801025f0:	83 ec 0c             	sub    $0xc,%esp
801025f3:	56                   	push   %esi
801025f4:	e8 37 f9 ff ff       	call   80101f30 <ilock>
    if(ip->type != T_DIR){
801025f9:	83 c4 10             	add    $0x10,%esp
801025fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102601:	0f 85 cd 00 00 00    	jne    801026d4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102607:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010260a:	85 c0                	test   %eax,%eax
8010260c:	74 09                	je     80102617 <namex+0xd7>
8010260e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102611:	0f 84 22 01 00 00    	je     80102739 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102617:	83 ec 04             	sub    $0x4,%esp
8010261a:	6a 00                	push   $0x0
8010261c:	ff 75 e4             	push   -0x1c(%ebp)
8010261f:	56                   	push   %esi
80102620:	e8 6b fe ff ff       	call   80102490 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102625:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102628:	83 c4 10             	add    $0x10,%esp
8010262b:	89 c7                	mov    %eax,%edi
8010262d:	85 c0                	test   %eax,%eax
8010262f:	0f 84 e1 00 00 00    	je     80102716 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102635:	83 ec 0c             	sub    $0xc,%esp
80102638:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010263b:	52                   	push   %edx
8010263c:	e8 ef 24 00 00       	call   80104b30 <holdingsleep>
80102641:	83 c4 10             	add    $0x10,%esp
80102644:	85 c0                	test   %eax,%eax
80102646:	0f 84 30 01 00 00    	je     8010277c <namex+0x23c>
8010264c:	8b 56 08             	mov    0x8(%esi),%edx
8010264f:	85 d2                	test   %edx,%edx
80102651:	0f 8e 25 01 00 00    	jle    8010277c <namex+0x23c>
  releasesleep(&ip->lock);
80102657:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010265a:	83 ec 0c             	sub    $0xc,%esp
8010265d:	52                   	push   %edx
8010265e:	e8 8d 24 00 00       	call   80104af0 <releasesleep>
  iput(ip);
80102663:	89 34 24             	mov    %esi,(%esp)
80102666:	89 fe                	mov    %edi,%esi
80102668:	e8 f3 f9 ff ff       	call   80102060 <iput>
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	e9 16 ff ff ff       	jmp    8010258b <namex+0x4b>
80102675:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102678:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010267b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010267e:	83 ec 04             	sub    $0x4,%esp
80102681:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102684:	50                   	push   %eax
80102685:	53                   	push   %ebx
    name[len] = 0;
80102686:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102688:	ff 75 e4             	push   -0x1c(%ebp)
8010268b:	e8 20 28 00 00       	call   80104eb0 <memmove>
    name[len] = 0;
80102690:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	c6 02 00             	movb   $0x0,(%edx)
80102699:	e9 41 ff ff ff       	jmp    801025df <namex+0x9f>
8010269e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801026a3:	85 c0                	test   %eax,%eax
801026a5:	0f 85 be 00 00 00    	jne    80102769 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801026ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ae:	89 f0                	mov    %esi,%eax
801026b0:	5b                   	pop    %ebx
801026b1:	5e                   	pop    %esi
801026b2:	5f                   	pop    %edi
801026b3:	5d                   	pop    %ebp
801026b4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801026b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801026b8:	89 df                	mov    %ebx,%edi
801026ba:	31 c0                	xor    %eax,%eax
801026bc:	eb c0                	jmp    8010267e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801026be:	ba 01 00 00 00       	mov    $0x1,%edx
801026c3:	b8 01 00 00 00       	mov    $0x1,%eax
801026c8:	e8 33 f4 ff ff       	call   80101b00 <iget>
801026cd:	89 c6                	mov    %eax,%esi
801026cf:	e9 b7 fe ff ff       	jmp    8010258b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801026d4:	83 ec 0c             	sub    $0xc,%esp
801026d7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801026da:	53                   	push   %ebx
801026db:	e8 50 24 00 00       	call   80104b30 <holdingsleep>
801026e0:	83 c4 10             	add    $0x10,%esp
801026e3:	85 c0                	test   %eax,%eax
801026e5:	0f 84 91 00 00 00    	je     8010277c <namex+0x23c>
801026eb:	8b 46 08             	mov    0x8(%esi),%eax
801026ee:	85 c0                	test   %eax,%eax
801026f0:	0f 8e 86 00 00 00    	jle    8010277c <namex+0x23c>
  releasesleep(&ip->lock);
801026f6:	83 ec 0c             	sub    $0xc,%esp
801026f9:	53                   	push   %ebx
801026fa:	e8 f1 23 00 00       	call   80104af0 <releasesleep>
  iput(ip);
801026ff:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102702:	31 f6                	xor    %esi,%esi
  iput(ip);
80102704:	e8 57 f9 ff ff       	call   80102060 <iput>
      return 0;
80102709:	83 c4 10             	add    $0x10,%esp
}
8010270c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010270f:	89 f0                	mov    %esi,%eax
80102711:	5b                   	pop    %ebx
80102712:	5e                   	pop    %esi
80102713:	5f                   	pop    %edi
80102714:	5d                   	pop    %ebp
80102715:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102716:	83 ec 0c             	sub    $0xc,%esp
80102719:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010271c:	52                   	push   %edx
8010271d:	e8 0e 24 00 00       	call   80104b30 <holdingsleep>
80102722:	83 c4 10             	add    $0x10,%esp
80102725:	85 c0                	test   %eax,%eax
80102727:	74 53                	je     8010277c <namex+0x23c>
80102729:	8b 4e 08             	mov    0x8(%esi),%ecx
8010272c:	85 c9                	test   %ecx,%ecx
8010272e:	7e 4c                	jle    8010277c <namex+0x23c>
  releasesleep(&ip->lock);
80102730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102733:	83 ec 0c             	sub    $0xc,%esp
80102736:	52                   	push   %edx
80102737:	eb c1                	jmp    801026fa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102739:	83 ec 0c             	sub    $0xc,%esp
8010273c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010273f:	53                   	push   %ebx
80102740:	e8 eb 23 00 00       	call   80104b30 <holdingsleep>
80102745:	83 c4 10             	add    $0x10,%esp
80102748:	85 c0                	test   %eax,%eax
8010274a:	74 30                	je     8010277c <namex+0x23c>
8010274c:	8b 7e 08             	mov    0x8(%esi),%edi
8010274f:	85 ff                	test   %edi,%edi
80102751:	7e 29                	jle    8010277c <namex+0x23c>
  releasesleep(&ip->lock);
80102753:	83 ec 0c             	sub    $0xc,%esp
80102756:	53                   	push   %ebx
80102757:	e8 94 23 00 00       	call   80104af0 <releasesleep>
}
8010275c:	83 c4 10             	add    $0x10,%esp
}
8010275f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102762:	89 f0                	mov    %esi,%eax
80102764:	5b                   	pop    %ebx
80102765:	5e                   	pop    %esi
80102766:	5f                   	pop    %edi
80102767:	5d                   	pop    %ebp
80102768:	c3                   	ret    
    iput(ip);
80102769:	83 ec 0c             	sub    $0xc,%esp
8010276c:	56                   	push   %esi
    return 0;
8010276d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010276f:	e8 ec f8 ff ff       	call   80102060 <iput>
    return 0;
80102774:	83 c4 10             	add    $0x10,%esp
80102777:	e9 2f ff ff ff       	jmp    801026ab <namex+0x16b>
    panic("iunlock");
8010277c:	83 ec 0c             	sub    $0xc,%esp
8010277f:	68 7f 7a 10 80       	push   $0x80107a7f
80102784:	e8 c7 dc ff ff       	call   80100450 <panic>
80102789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102790 <dirlink>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	57                   	push   %edi
80102794:	56                   	push   %esi
80102795:	53                   	push   %ebx
80102796:	83 ec 20             	sub    $0x20,%esp
80102799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010279c:	6a 00                	push   $0x0
8010279e:	ff 75 0c             	push   0xc(%ebp)
801027a1:	53                   	push   %ebx
801027a2:	e8 e9 fc ff ff       	call   80102490 <dirlookup>
801027a7:	83 c4 10             	add    $0x10,%esp
801027aa:	85 c0                	test   %eax,%eax
801027ac:	75 67                	jne    80102815 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801027ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801027b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801027b4:	85 ff                	test   %edi,%edi
801027b6:	74 29                	je     801027e1 <dirlink+0x51>
801027b8:	31 ff                	xor    %edi,%edi
801027ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801027bd:	eb 09                	jmp    801027c8 <dirlink+0x38>
801027bf:	90                   	nop
801027c0:	83 c7 10             	add    $0x10,%edi
801027c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801027c6:	73 19                	jae    801027e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027c8:	6a 10                	push   $0x10
801027ca:	57                   	push   %edi
801027cb:	56                   	push   %esi
801027cc:	53                   	push   %ebx
801027cd:	e8 6e fa ff ff       	call   80102240 <readi>
801027d2:	83 c4 10             	add    $0x10,%esp
801027d5:	83 f8 10             	cmp    $0x10,%eax
801027d8:	75 4e                	jne    80102828 <dirlink+0x98>
    if(de.inum == 0)
801027da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801027df:	75 df                	jne    801027c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801027e1:	83 ec 04             	sub    $0x4,%esp
801027e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801027e7:	6a 0e                	push   $0xe
801027e9:	ff 75 0c             	push   0xc(%ebp)
801027ec:	50                   	push   %eax
801027ed:	e8 7e 27 00 00       	call   80104f70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027f2:	6a 10                	push   $0x10
  de.inum = inum;
801027f4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027f7:	57                   	push   %edi
801027f8:	56                   	push   %esi
801027f9:	53                   	push   %ebx
  de.inum = inum;
801027fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027fe:	e8 3d fb ff ff       	call   80102340 <writei>
80102803:	83 c4 20             	add    $0x20,%esp
80102806:	83 f8 10             	cmp    $0x10,%eax
80102809:	75 2a                	jne    80102835 <dirlink+0xa5>
  return 0;
8010280b:	31 c0                	xor    %eax,%eax
}
8010280d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102810:	5b                   	pop    %ebx
80102811:	5e                   	pop    %esi
80102812:	5f                   	pop    %edi
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
    iput(ip);
80102815:	83 ec 0c             	sub    $0xc,%esp
80102818:	50                   	push   %eax
80102819:	e8 42 f8 ff ff       	call   80102060 <iput>
    return -1;
8010281e:	83 c4 10             	add    $0x10,%esp
80102821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102826:	eb e5                	jmp    8010280d <dirlink+0x7d>
      panic("dirlink read");
80102828:	83 ec 0c             	sub    $0xc,%esp
8010282b:	68 a8 7a 10 80       	push   $0x80107aa8
80102830:	e8 1b dc ff ff       	call   80100450 <panic>
    panic("dirlink");
80102835:	83 ec 0c             	sub    $0xc,%esp
80102838:	68 7e 80 10 80       	push   $0x8010807e
8010283d:	e8 0e dc ff ff       	call   80100450 <panic>
80102842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102850 <namei>:

struct inode*
namei(char *path)
{
80102850:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102851:	31 d2                	xor    %edx,%edx
{
80102853:	89 e5                	mov    %esp,%ebp
80102855:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102858:	8b 45 08             	mov    0x8(%ebp),%eax
8010285b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010285e:	e8 dd fc ff ff       	call   80102540 <namex>
}
80102863:	c9                   	leave  
80102864:	c3                   	ret    
80102865:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102870 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102870:	55                   	push   %ebp
  return namex(path, 1, name);
80102871:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102876:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102878:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010287b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010287e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010287f:	e9 bc fc ff ff       	jmp    80102540 <namex>
80102884:	66 90                	xchg   %ax,%ax
80102886:	66 90                	xchg   %ax,%ax
80102888:	66 90                	xchg   %ax,%ax
8010288a:	66 90                	xchg   %ax,%ax
8010288c:	66 90                	xchg   %ax,%ax
8010288e:	66 90                	xchg   %ax,%ax

80102890 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	57                   	push   %edi
80102894:	56                   	push   %esi
80102895:	53                   	push   %ebx
80102896:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102899:	85 c0                	test   %eax,%eax
8010289b:	0f 84 b4 00 00 00    	je     80102955 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801028a1:	8b 70 08             	mov    0x8(%eax),%esi
801028a4:	89 c3                	mov    %eax,%ebx
801028a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801028ac:	0f 87 96 00 00 00    	ja     80102948 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028c3:	83 e0 c0             	and    $0xffffffc0,%eax
801028c6:	3c 40                	cmp    $0x40,%al
801028c8:	75 f6                	jne    801028c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ca:	31 ff                	xor    %edi,%edi
801028cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801028d1:	89 f8                	mov    %edi,%eax
801028d3:	ee                   	out    %al,(%dx)
801028d4:	b8 01 00 00 00       	mov    $0x1,%eax
801028d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801028de:	ee                   	out    %al,(%dx)
801028df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801028e4:	89 f0                	mov    %esi,%eax
801028e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801028e7:	89 f0                	mov    %esi,%eax
801028e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801028ee:	c1 f8 08             	sar    $0x8,%eax
801028f1:	ee                   	out    %al,(%dx)
801028f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801028f7:	89 f8                	mov    %edi,%eax
801028f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801028fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801028fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102903:	c1 e0 04             	shl    $0x4,%eax
80102906:	83 e0 10             	and    $0x10,%eax
80102909:	83 c8 e0             	or     $0xffffffe0,%eax
8010290c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010290d:	f6 03 04             	testb  $0x4,(%ebx)
80102910:	75 16                	jne    80102928 <idestart+0x98>
80102912:	b8 20 00 00 00       	mov    $0x20,%eax
80102917:	89 ca                	mov    %ecx,%edx
80102919:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010291a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010291d:	5b                   	pop    %ebx
8010291e:	5e                   	pop    %esi
8010291f:	5f                   	pop    %edi
80102920:	5d                   	pop    %ebp
80102921:	c3                   	ret    
80102922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102928:	b8 30 00 00 00       	mov    $0x30,%eax
8010292d:	89 ca                	mov    %ecx,%edx
8010292f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102930:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102938:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010293d:	fc                   	cld    
8010293e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102943:	5b                   	pop    %ebx
80102944:	5e                   	pop    %esi
80102945:	5f                   	pop    %edi
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
    panic("incorrect blockno");
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	68 14 7b 10 80       	push   $0x80107b14
80102950:	e8 fb da ff ff       	call   80100450 <panic>
    panic("idestart");
80102955:	83 ec 0c             	sub    $0xc,%esp
80102958:	68 0b 7b 10 80       	push   $0x80107b0b
8010295d:	e8 ee da ff ff       	call   80100450 <panic>
80102962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102970 <ideinit>:
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102976:	68 26 7b 10 80       	push   $0x80107b26
8010297b:	68 20 2b 11 80       	push   $0x80112b20
80102980:	e8 fb 21 00 00       	call   80104b80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102985:	58                   	pop    %eax
80102986:	a1 a4 2c 11 80       	mov    0x80112ca4,%eax
8010298b:	5a                   	pop    %edx
8010298c:	83 e8 01             	sub    $0x1,%eax
8010298f:	50                   	push   %eax
80102990:	6a 0e                	push   $0xe
80102992:	e8 99 02 00 00       	call   80102c30 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102997:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010299f:	90                   	nop
801029a0:	ec                   	in     (%dx),%al
801029a1:	83 e0 c0             	and    $0xffffffc0,%eax
801029a4:	3c 40                	cmp    $0x40,%al
801029a6:	75 f8                	jne    801029a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801029ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801029b2:	ee                   	out    %al,(%dx)
801029b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801029bd:	eb 06                	jmp    801029c5 <ideinit+0x55>
801029bf:	90                   	nop
  for(i=0; i<1000; i++){
801029c0:	83 e9 01             	sub    $0x1,%ecx
801029c3:	74 0f                	je     801029d4 <ideinit+0x64>
801029c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801029c6:	84 c0                	test   %al,%al
801029c8:	74 f6                	je     801029c0 <ideinit+0x50>
      havedisk1 = 1;
801029ca:	c7 05 00 2b 11 80 01 	movl   $0x1,0x80112b00
801029d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801029d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801029de:	ee                   	out    %al,(%dx)
}
801029df:	c9                   	leave  
801029e0:	c3                   	ret    
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop

801029f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801029f9:	68 20 2b 11 80       	push   $0x80112b20
801029fe:	e8 4d 23 00 00       	call   80104d50 <acquire>

  if((b = idequeue) == 0){
80102a03:	8b 1d 04 2b 11 80    	mov    0x80112b04,%ebx
80102a09:	83 c4 10             	add    $0x10,%esp
80102a0c:	85 db                	test   %ebx,%ebx
80102a0e:	74 63                	je     80102a73 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102a10:	8b 43 58             	mov    0x58(%ebx),%eax
80102a13:	a3 04 2b 11 80       	mov    %eax,0x80112b04

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a18:	8b 33                	mov    (%ebx),%esi
80102a1a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102a20:	75 2f                	jne    80102a51 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a22:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2e:	66 90                	xchg   %ax,%ax
80102a30:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102a31:	89 c1                	mov    %eax,%ecx
80102a33:	83 e1 c0             	and    $0xffffffc0,%ecx
80102a36:	80 f9 40             	cmp    $0x40,%cl
80102a39:	75 f5                	jne    80102a30 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102a3b:	a8 21                	test   $0x21,%al
80102a3d:	75 12                	jne    80102a51 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102a3f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102a42:	b9 80 00 00 00       	mov    $0x80,%ecx
80102a47:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102a4c:	fc                   	cld    
80102a4d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a4f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102a51:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102a54:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102a57:	83 ce 02             	or     $0x2,%esi
80102a5a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102a5c:	53                   	push   %ebx
80102a5d:	e8 4e 1e 00 00       	call   801048b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a62:	a1 04 2b 11 80       	mov    0x80112b04,%eax
80102a67:	83 c4 10             	add    $0x10,%esp
80102a6a:	85 c0                	test   %eax,%eax
80102a6c:	74 05                	je     80102a73 <ideintr+0x83>
    idestart(idequeue);
80102a6e:	e8 1d fe ff ff       	call   80102890 <idestart>
    release(&idelock);
80102a73:	83 ec 0c             	sub    $0xc,%esp
80102a76:	68 20 2b 11 80       	push   $0x80112b20
80102a7b:	e8 70 22 00 00       	call   80104cf0 <release>

  release(&idelock);
}
80102a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a83:	5b                   	pop    %ebx
80102a84:	5e                   	pop    %esi
80102a85:	5f                   	pop    %edi
80102a86:	5d                   	pop    %ebp
80102a87:	c3                   	ret    
80102a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8f:	90                   	nop

80102a90 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	53                   	push   %ebx
80102a94:	83 ec 10             	sub    $0x10,%esp
80102a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102a9a:	8d 43 0c             	lea    0xc(%ebx),%eax
80102a9d:	50                   	push   %eax
80102a9e:	e8 8d 20 00 00       	call   80104b30 <holdingsleep>
80102aa3:	83 c4 10             	add    $0x10,%esp
80102aa6:	85 c0                	test   %eax,%eax
80102aa8:	0f 84 c3 00 00 00    	je     80102b71 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102aae:	8b 03                	mov    (%ebx),%eax
80102ab0:	83 e0 06             	and    $0x6,%eax
80102ab3:	83 f8 02             	cmp    $0x2,%eax
80102ab6:	0f 84 a8 00 00 00    	je     80102b64 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102abc:	8b 53 04             	mov    0x4(%ebx),%edx
80102abf:	85 d2                	test   %edx,%edx
80102ac1:	74 0d                	je     80102ad0 <iderw+0x40>
80102ac3:	a1 00 2b 11 80       	mov    0x80112b00,%eax
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	0f 84 87 00 00 00    	je     80102b57 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102ad0:	83 ec 0c             	sub    $0xc,%esp
80102ad3:	68 20 2b 11 80       	push   $0x80112b20
80102ad8:	e8 73 22 00 00       	call   80104d50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102add:	a1 04 2b 11 80       	mov    0x80112b04,%eax
  b->qnext = 0;
80102ae2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102ae9:	83 c4 10             	add    $0x10,%esp
80102aec:	85 c0                	test   %eax,%eax
80102aee:	74 60                	je     80102b50 <iderw+0xc0>
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	8b 40 58             	mov    0x58(%eax),%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	75 f7                	jne    80102af0 <iderw+0x60>
80102af9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102afc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102afe:	39 1d 04 2b 11 80    	cmp    %ebx,0x80112b04
80102b04:	74 3a                	je     80102b40 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b06:	8b 03                	mov    (%ebx),%eax
80102b08:	83 e0 06             	and    $0x6,%eax
80102b0b:	83 f8 02             	cmp    $0x2,%eax
80102b0e:	74 1b                	je     80102b2b <iderw+0x9b>
    sleep(b, &idelock);
80102b10:	83 ec 08             	sub    $0x8,%esp
80102b13:	68 20 2b 11 80       	push   $0x80112b20
80102b18:	53                   	push   %ebx
80102b19:	e8 d2 1c 00 00       	call   801047f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b1e:	8b 03                	mov    (%ebx),%eax
80102b20:	83 c4 10             	add    $0x10,%esp
80102b23:	83 e0 06             	and    $0x6,%eax
80102b26:	83 f8 02             	cmp    $0x2,%eax
80102b29:	75 e5                	jne    80102b10 <iderw+0x80>
  }


  release(&idelock);
80102b2b:	c7 45 08 20 2b 11 80 	movl   $0x80112b20,0x8(%ebp)
}
80102b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b35:	c9                   	leave  
  release(&idelock);
80102b36:	e9 b5 21 00 00       	jmp    80104cf0 <release>
80102b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b3f:	90                   	nop
    idestart(b);
80102b40:	89 d8                	mov    %ebx,%eax
80102b42:	e8 49 fd ff ff       	call   80102890 <idestart>
80102b47:	eb bd                	jmp    80102b06 <iderw+0x76>
80102b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b50:	ba 04 2b 11 80       	mov    $0x80112b04,%edx
80102b55:	eb a5                	jmp    80102afc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102b57:	83 ec 0c             	sub    $0xc,%esp
80102b5a:	68 55 7b 10 80       	push   $0x80107b55
80102b5f:	e8 ec d8 ff ff       	call   80100450 <panic>
    panic("iderw: nothing to do");
80102b64:	83 ec 0c             	sub    $0xc,%esp
80102b67:	68 40 7b 10 80       	push   $0x80107b40
80102b6c:	e8 df d8 ff ff       	call   80100450 <panic>
    panic("iderw: buf not locked");
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	68 2a 7b 10 80       	push   $0x80107b2a
80102b79:	e8 d2 d8 ff ff       	call   80100450 <panic>
80102b7e:	66 90                	xchg   %ax,%ax

80102b80 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102b80:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102b81:	c7 05 54 2b 11 80 00 	movl   $0xfec00000,0x80112b54
80102b88:	00 c0 fe 
{
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	56                   	push   %esi
80102b8e:	53                   	push   %ebx
  ioapic->reg = reg;
80102b8f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102b96:	00 00 00 
  return ioapic->data;
80102b99:	8b 15 54 2b 11 80    	mov    0x80112b54,%edx
80102b9f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102ba2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102ba8:	8b 0d 54 2b 11 80    	mov    0x80112b54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102bae:	0f b6 15 a0 2c 11 80 	movzbl 0x80112ca0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102bb5:	c1 ee 10             	shr    $0x10,%esi
80102bb8:	89 f0                	mov    %esi,%eax
80102bba:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102bbd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102bc0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102bc3:	39 c2                	cmp    %eax,%edx
80102bc5:	74 16                	je     80102bdd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102bc7:	83 ec 0c             	sub    $0xc,%esp
80102bca:	68 74 7b 10 80       	push   $0x80107b74
80102bcf:	e8 ac dc ff ff       	call   80100880 <cprintf>
  ioapic->reg = reg;
80102bd4:	8b 0d 54 2b 11 80    	mov    0x80112b54,%ecx
80102bda:	83 c4 10             	add    $0x10,%esp
80102bdd:	83 c6 21             	add    $0x21,%esi
{
80102be0:	ba 10 00 00 00       	mov    $0x10,%edx
80102be5:	b8 20 00 00 00       	mov    $0x20,%eax
80102bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102bf0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102bf2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102bf4:	8b 0d 54 2b 11 80    	mov    0x80112b54,%ecx
  for(i = 0; i <= maxintr; i++){
80102bfa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102bfd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102c03:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102c06:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102c09:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102c0c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102c0e:	8b 0d 54 2b 11 80    	mov    0x80112b54,%ecx
80102c14:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102c1b:	39 f0                	cmp    %esi,%eax
80102c1d:	75 d1                	jne    80102bf0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c22:	5b                   	pop    %ebx
80102c23:	5e                   	pop    %esi
80102c24:	5d                   	pop    %ebp
80102c25:	c3                   	ret    
80102c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2d:	8d 76 00             	lea    0x0(%esi),%esi

80102c30 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c30:	55                   	push   %ebp
  ioapic->reg = reg;
80102c31:	8b 0d 54 2b 11 80    	mov    0x80112b54,%ecx
{
80102c37:	89 e5                	mov    %esp,%ebp
80102c39:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c3c:	8d 50 20             	lea    0x20(%eax),%edx
80102c3f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102c43:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102c45:	8b 0d 54 2b 11 80    	mov    0x80112b54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c4b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102c4e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102c54:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102c56:	a1 54 2b 11 80       	mov    0x80112b54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c5b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102c5e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102c61:	5d                   	pop    %ebp
80102c62:	c3                   	ret    
80102c63:	66 90                	xchg   %ax,%ax
80102c65:	66 90                	xchg   %ax,%ax
80102c67:	66 90                	xchg   %ax,%ax
80102c69:	66 90                	xchg   %ax,%ax
80102c6b:	66 90                	xchg   %ax,%ax
80102c6d:	66 90                	xchg   %ax,%ax
80102c6f:	90                   	nop

80102c70 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 04             	sub    $0x4,%esp
80102c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c7a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102c80:	75 76                	jne    80102cf8 <kfree+0x88>
80102c82:	81 fb f0 69 11 80    	cmp    $0x801169f0,%ebx
80102c88:	72 6e                	jb     80102cf8 <kfree+0x88>
80102c8a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102c90:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c95:	77 61                	ja     80102cf8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c97:	83 ec 04             	sub    $0x4,%esp
80102c9a:	68 00 10 00 00       	push   $0x1000
80102c9f:	6a 01                	push   $0x1
80102ca1:	53                   	push   %ebx
80102ca2:	e8 69 21 00 00       	call   80104e10 <memset>

  if(kmem.use_lock)
80102ca7:	8b 15 94 2b 11 80    	mov    0x80112b94,%edx
80102cad:	83 c4 10             	add    $0x10,%esp
80102cb0:	85 d2                	test   %edx,%edx
80102cb2:	75 1c                	jne    80102cd0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102cb4:	a1 98 2b 11 80       	mov    0x80112b98,%eax
80102cb9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102cbb:	a1 94 2b 11 80       	mov    0x80112b94,%eax
  kmem.freelist = r;
80102cc0:	89 1d 98 2b 11 80    	mov    %ebx,0x80112b98
  if(kmem.use_lock)
80102cc6:	85 c0                	test   %eax,%eax
80102cc8:	75 1e                	jne    80102ce8 <kfree+0x78>
    release(&kmem.lock);
}
80102cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ccd:	c9                   	leave  
80102cce:	c3                   	ret    
80102ccf:	90                   	nop
    acquire(&kmem.lock);
80102cd0:	83 ec 0c             	sub    $0xc,%esp
80102cd3:	68 60 2b 11 80       	push   $0x80112b60
80102cd8:	e8 73 20 00 00       	call   80104d50 <acquire>
80102cdd:	83 c4 10             	add    $0x10,%esp
80102ce0:	eb d2                	jmp    80102cb4 <kfree+0x44>
80102ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102ce8:	c7 45 08 60 2b 11 80 	movl   $0x80112b60,0x8(%ebp)
}
80102cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cf2:	c9                   	leave  
    release(&kmem.lock);
80102cf3:	e9 f8 1f 00 00       	jmp    80104cf0 <release>
    panic("kfree");
80102cf8:	83 ec 0c             	sub    $0xc,%esp
80102cfb:	68 a6 7b 10 80       	push   $0x80107ba6
80102d00:	e8 4b d7 ff ff       	call   80100450 <panic>
80102d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d10 <freerange>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d14:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d17:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d1a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d1b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d21:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d27:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d2d:	39 de                	cmp    %ebx,%esi
80102d2f:	72 23                	jb     80102d54 <freerange+0x44>
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d47:	50                   	push   %eax
80102d48:	e8 23 ff ff ff       	call   80102c70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d4d:	83 c4 10             	add    $0x10,%esp
80102d50:	39 f3                	cmp    %esi,%ebx
80102d52:	76 e4                	jbe    80102d38 <freerange+0x28>
}
80102d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5d                   	pop    %ebp
80102d5a:	c3                   	ret    
80102d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d5f:	90                   	nop

80102d60 <kinit2>:
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d64:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d67:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d6a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d6b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d71:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d7d:	39 de                	cmp    %ebx,%esi
80102d7f:	72 23                	jb     80102da4 <kinit2+0x44>
80102d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102d88:	83 ec 0c             	sub    $0xc,%esp
80102d8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d97:	50                   	push   %eax
80102d98:	e8 d3 fe ff ff       	call   80102c70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d9d:	83 c4 10             	add    $0x10,%esp
80102da0:	39 de                	cmp    %ebx,%esi
80102da2:	73 e4                	jae    80102d88 <kinit2+0x28>
  kmem.use_lock = 1;
80102da4:	c7 05 94 2b 11 80 01 	movl   $0x1,0x80112b94
80102dab:	00 00 00 
}
80102dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102db1:	5b                   	pop    %ebx
80102db2:	5e                   	pop    %esi
80102db3:	5d                   	pop    %ebp
80102db4:	c3                   	ret    
80102db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <kinit1>:
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	56                   	push   %esi
80102dc4:	53                   	push   %ebx
80102dc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102dc8:	83 ec 08             	sub    $0x8,%esp
80102dcb:	68 ac 7b 10 80       	push   $0x80107bac
80102dd0:	68 60 2b 11 80       	push   $0x80112b60
80102dd5:	e8 a6 1d 00 00       	call   80104b80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102dda:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ddd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102de0:	c7 05 94 2b 11 80 00 	movl   $0x0,0x80112b94
80102de7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102dea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102df0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102df6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102dfc:	39 de                	cmp    %ebx,%esi
80102dfe:	72 1c                	jb     80102e1c <kinit1+0x5c>
    kfree(p);
80102e00:	83 ec 0c             	sub    $0xc,%esp
80102e03:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e0f:	50                   	push   %eax
80102e10:	e8 5b fe ff ff       	call   80102c70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e15:	83 c4 10             	add    $0x10,%esp
80102e18:	39 de                	cmp    %ebx,%esi
80102e1a:	73 e4                	jae    80102e00 <kinit1+0x40>
}
80102e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e1f:	5b                   	pop    %ebx
80102e20:	5e                   	pop    %esi
80102e21:	5d                   	pop    %ebp
80102e22:	c3                   	ret    
80102e23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e30 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102e30:	a1 94 2b 11 80       	mov    0x80112b94,%eax
80102e35:	85 c0                	test   %eax,%eax
80102e37:	75 1f                	jne    80102e58 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102e39:	a1 98 2b 11 80       	mov    0x80112b98,%eax
  if(r)
80102e3e:	85 c0                	test   %eax,%eax
80102e40:	74 0e                	je     80102e50 <kalloc+0x20>
    kmem.freelist = r->next;
80102e42:	8b 10                	mov    (%eax),%edx
80102e44:	89 15 98 2b 11 80    	mov    %edx,0x80112b98
  if(kmem.use_lock)
80102e4a:	c3                   	ret    
80102e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102e50:	c3                   	ret    
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102e58:	55                   	push   %ebp
80102e59:	89 e5                	mov    %esp,%ebp
80102e5b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102e5e:	68 60 2b 11 80       	push   $0x80112b60
80102e63:	e8 e8 1e 00 00       	call   80104d50 <acquire>
  r = kmem.freelist;
80102e68:	a1 98 2b 11 80       	mov    0x80112b98,%eax
  if(kmem.use_lock)
80102e6d:	8b 15 94 2b 11 80    	mov    0x80112b94,%edx
  if(r)
80102e73:	83 c4 10             	add    $0x10,%esp
80102e76:	85 c0                	test   %eax,%eax
80102e78:	74 08                	je     80102e82 <kalloc+0x52>
    kmem.freelist = r->next;
80102e7a:	8b 08                	mov    (%eax),%ecx
80102e7c:	89 0d 98 2b 11 80    	mov    %ecx,0x80112b98
  if(kmem.use_lock)
80102e82:	85 d2                	test   %edx,%edx
80102e84:	74 16                	je     80102e9c <kalloc+0x6c>
    release(&kmem.lock);
80102e86:	83 ec 0c             	sub    $0xc,%esp
80102e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e8c:	68 60 2b 11 80       	push   $0x80112b60
80102e91:	e8 5a 1e 00 00       	call   80104cf0 <release>
  return (char*)r;
80102e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102e99:	83 c4 10             	add    $0x10,%esp
}
80102e9c:	c9                   	leave  
80102e9d:	c3                   	ret    
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ea5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ea6:	a8 01                	test   $0x1,%al
80102ea8:	0f 84 c2 00 00 00    	je     80102f70 <kbdgetc+0xd0>
{
80102eae:	55                   	push   %ebp
80102eaf:	ba 60 00 00 00       	mov    $0x60,%edx
80102eb4:	89 e5                	mov    %esp,%ebp
80102eb6:	53                   	push   %ebx
80102eb7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102eb8:	8b 1d 9c 2b 11 80    	mov    0x80112b9c,%ebx
  data = inb(KBDATAP);
80102ebe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102ec1:	3c e0                	cmp    $0xe0,%al
80102ec3:	74 5b                	je     80102f20 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ec5:	89 da                	mov    %ebx,%edx
80102ec7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102eca:	84 c0                	test   %al,%al
80102ecc:	78 62                	js     80102f30 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ece:	85 d2                	test   %edx,%edx
80102ed0:	74 09                	je     80102edb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ed2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ed5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102ed8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102edb:	0f b6 91 e0 7c 10 80 	movzbl -0x7fef8320(%ecx),%edx
  shift ^= togglecode[data];
80102ee2:	0f b6 81 e0 7b 10 80 	movzbl -0x7fef8420(%ecx),%eax
  shift |= shiftcode[data];
80102ee9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102eeb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102eed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102eef:	89 15 9c 2b 11 80    	mov    %edx,0x80112b9c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ef5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102ef8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102efb:	8b 04 85 c0 7b 10 80 	mov    -0x7fef8440(,%eax,4),%eax
80102f02:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102f06:	74 0b                	je     80102f13 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102f08:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f0b:	83 fa 19             	cmp    $0x19,%edx
80102f0e:	77 48                	ja     80102f58 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f10:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f16:	c9                   	leave  
80102f17:	c3                   	ret    
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop
    shift |= E0ESC;
80102f20:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102f23:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102f25:	89 1d 9c 2b 11 80    	mov    %ebx,0x80112b9c
}
80102f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f2e:	c9                   	leave  
80102f2f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102f30:	83 e0 7f             	and    $0x7f,%eax
80102f33:	85 d2                	test   %edx,%edx
80102f35:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102f38:	0f b6 81 e0 7c 10 80 	movzbl -0x7fef8320(%ecx),%eax
80102f3f:	83 c8 40             	or     $0x40,%eax
80102f42:	0f b6 c0             	movzbl %al,%eax
80102f45:	f7 d0                	not    %eax
80102f47:	21 d8                	and    %ebx,%eax
}
80102f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102f4c:	a3 9c 2b 11 80       	mov    %eax,0x80112b9c
    return 0;
80102f51:	31 c0                	xor    %eax,%eax
}
80102f53:	c9                   	leave  
80102f54:	c3                   	ret    
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102f58:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102f5b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f61:	c9                   	leave  
      c += 'a' - 'A';
80102f62:	83 f9 1a             	cmp    $0x1a,%ecx
80102f65:	0f 42 c2             	cmovb  %edx,%eax
}
80102f68:	c3                   	ret    
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f75:	c3                   	ret    
80102f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7d:	8d 76 00             	lea    0x0(%esi),%esi

80102f80 <kbdintr>:

void
kbdintr(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102f86:	68 a0 2e 10 80       	push   $0x80102ea0
80102f8b:	e8 30 dd ff ff       	call   80100cc0 <consoleintr>
}
80102f90:	83 c4 10             	add    $0x10,%esp
80102f93:	c9                   	leave  
80102f94:	c3                   	ret    
80102f95:	66 90                	xchg   %ax,%ax
80102f97:	66 90                	xchg   %ax,%ax
80102f99:	66 90                	xchg   %ax,%ax
80102f9b:	66 90                	xchg   %ax,%ax
80102f9d:	66 90                	xchg   %ax,%ax
80102f9f:	90                   	nop

80102fa0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102fa0:	a1 a0 2b 11 80       	mov    0x80112ba0,%eax
80102fa5:	85 c0                	test   %eax,%eax
80102fa7:	0f 84 cb 00 00 00    	je     80103078 <lapicinit+0xd8>
  lapic[index] = value;
80102fad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102fb4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102fc1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fc4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fc7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102fce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102fd1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fd4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102fdb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102fde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fe1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102fe8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102feb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ff5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ff8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ffb:	8b 50 30             	mov    0x30(%eax),%edx
80102ffe:	c1 ea 10             	shr    $0x10,%edx
80103001:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80103007:	75 77                	jne    80103080 <lapicinit+0xe0>
  lapic[index] = value;
80103009:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103010:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103013:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103016:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010301d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103020:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103023:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010302a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010302d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103030:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103037:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010303a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010303d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103044:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103047:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010304a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103051:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103054:	8b 50 20             	mov    0x20(%eax),%edx
80103057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010305e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103060:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103066:	80 e6 10             	and    $0x10,%dh
80103069:	75 f5                	jne    80103060 <lapicinit+0xc0>
  lapic[index] = value;
8010306b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103072:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103075:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103078:	c3                   	ret    
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103080:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103087:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010308a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010308d:	e9 77 ff ff ff       	jmp    80103009 <lapicinit+0x69>
80103092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801030a0:	a1 a0 2b 11 80       	mov    0x80112ba0,%eax
801030a5:	85 c0                	test   %eax,%eax
801030a7:	74 07                	je     801030b0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801030a9:	8b 40 20             	mov    0x20(%eax),%eax
801030ac:	c1 e8 18             	shr    $0x18,%eax
801030af:	c3                   	ret    
    return 0;
801030b0:	31 c0                	xor    %eax,%eax
}
801030b2:	c3                   	ret    
801030b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801030c0:	a1 a0 2b 11 80       	mov    0x80112ba0,%eax
801030c5:	85 c0                	test   %eax,%eax
801030c7:	74 0d                	je     801030d6 <lapiceoi+0x16>
  lapic[index] = value;
801030c9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801030d6:	c3                   	ret    
801030d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030de:	66 90                	xchg   %ax,%ax

801030e0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801030e0:	c3                   	ret    
801030e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop

801030f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801030f6:	ba 70 00 00 00       	mov    $0x70,%edx
801030fb:	89 e5                	mov    %esp,%ebp
801030fd:	53                   	push   %ebx
801030fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103101:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103104:	ee                   	out    %al,(%dx)
80103105:	b8 0a 00 00 00       	mov    $0xa,%eax
8010310a:	ba 71 00 00 00       	mov    $0x71,%edx
8010310f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103110:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103112:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103115:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010311b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010311d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103120:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103122:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103125:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103128:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010312e:	a1 a0 2b 11 80       	mov    0x80112ba0,%eax
80103133:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103139:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010313c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103143:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103146:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103149:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103150:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103153:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103156:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010315c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010315f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103165:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103168:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010316e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103171:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103177:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010317a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010317d:	c9                   	leave  
8010317e:	c3                   	ret    
8010317f:	90                   	nop

80103180 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103180:	55                   	push   %ebp
80103181:	b8 0b 00 00 00       	mov    $0xb,%eax
80103186:	ba 70 00 00 00       	mov    $0x70,%edx
8010318b:	89 e5                	mov    %esp,%ebp
8010318d:	57                   	push   %edi
8010318e:	56                   	push   %esi
8010318f:	53                   	push   %ebx
80103190:	83 ec 4c             	sub    $0x4c,%esp
80103193:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103194:	ba 71 00 00 00       	mov    $0x71,%edx
80103199:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010319a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010319d:	bb 70 00 00 00       	mov    $0x70,%ebx
801031a2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
801031a8:	31 c0                	xor    %eax,%eax
801031aa:	89 da                	mov    %ebx,%edx
801031ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031ad:	b9 71 00 00 00       	mov    $0x71,%ecx
801031b2:	89 ca                	mov    %ecx,%edx
801031b4:	ec                   	in     (%dx),%al
801031b5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b8:	89 da                	mov    %ebx,%edx
801031ba:	b8 02 00 00 00       	mov    $0x2,%eax
801031bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c0:	89 ca                	mov    %ecx,%edx
801031c2:	ec                   	in     (%dx),%al
801031c3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031c6:	89 da                	mov    %ebx,%edx
801031c8:	b8 04 00 00 00       	mov    $0x4,%eax
801031cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031ce:	89 ca                	mov    %ecx,%edx
801031d0:	ec                   	in     (%dx),%al
801031d1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d4:	89 da                	mov    %ebx,%edx
801031d6:	b8 07 00 00 00       	mov    $0x7,%eax
801031db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031dc:	89 ca                	mov    %ecx,%edx
801031de:	ec                   	in     (%dx),%al
801031df:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e2:	89 da                	mov    %ebx,%edx
801031e4:	b8 08 00 00 00       	mov    $0x8,%eax
801031e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031ea:	89 ca                	mov    %ecx,%edx
801031ec:	ec                   	in     (%dx),%al
801031ed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ef:	89 da                	mov    %ebx,%edx
801031f1:	b8 09 00 00 00       	mov    $0x9,%eax
801031f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f7:	89 ca                	mov    %ecx,%edx
801031f9:	ec                   	in     (%dx),%al
801031fa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031fc:	89 da                	mov    %ebx,%edx
801031fe:	b8 0a 00 00 00       	mov    $0xa,%eax
80103203:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103204:	89 ca                	mov    %ecx,%edx
80103206:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103207:	84 c0                	test   %al,%al
80103209:	78 9d                	js     801031a8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010320b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010320f:	89 fa                	mov    %edi,%edx
80103211:	0f b6 fa             	movzbl %dl,%edi
80103214:	89 f2                	mov    %esi,%edx
80103216:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103219:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010321d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103220:	89 da                	mov    %ebx,%edx
80103222:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103225:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103228:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010322c:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010322f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103232:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103236:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103239:	31 c0                	xor    %eax,%eax
8010323b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010323c:	89 ca                	mov    %ecx,%edx
8010323e:	ec                   	in     (%dx),%al
8010323f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103242:	89 da                	mov    %ebx,%edx
80103244:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103247:	b8 02 00 00 00       	mov    $0x2,%eax
8010324c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010324d:	89 ca                	mov    %ecx,%edx
8010324f:	ec                   	in     (%dx),%al
80103250:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103253:	89 da                	mov    %ebx,%edx
80103255:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103258:	b8 04 00 00 00       	mov    $0x4,%eax
8010325d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010325e:	89 ca                	mov    %ecx,%edx
80103260:	ec                   	in     (%dx),%al
80103261:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103264:	89 da                	mov    %ebx,%edx
80103266:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103269:	b8 07 00 00 00       	mov    $0x7,%eax
8010326e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010326f:	89 ca                	mov    %ecx,%edx
80103271:	ec                   	in     (%dx),%al
80103272:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103275:	89 da                	mov    %ebx,%edx
80103277:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010327a:	b8 08 00 00 00       	mov    $0x8,%eax
8010327f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103280:	89 ca                	mov    %ecx,%edx
80103282:	ec                   	in     (%dx),%al
80103283:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103286:	89 da                	mov    %ebx,%edx
80103288:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010328b:	b8 09 00 00 00       	mov    $0x9,%eax
80103290:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103291:	89 ca                	mov    %ecx,%edx
80103293:	ec                   	in     (%dx),%al
80103294:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103297:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010329a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010329d:	8d 45 d0             	lea    -0x30(%ebp),%eax
801032a0:	6a 18                	push   $0x18
801032a2:	50                   	push   %eax
801032a3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801032a6:	50                   	push   %eax
801032a7:	e8 b4 1b 00 00       	call   80104e60 <memcmp>
801032ac:	83 c4 10             	add    $0x10,%esp
801032af:	85 c0                	test   %eax,%eax
801032b1:	0f 85 f1 fe ff ff    	jne    801031a8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801032b7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801032bb:	75 78                	jne    80103335 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
801032c0:	89 c2                	mov    %eax,%edx
801032c2:	83 e0 0f             	and    $0xf,%eax
801032c5:	c1 ea 04             	shr    $0x4,%edx
801032c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801032d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801032d4:	89 c2                	mov    %eax,%edx
801032d6:	83 e0 0f             	and    $0xf,%eax
801032d9:	c1 ea 04             	shr    $0x4,%edx
801032dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801032e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801032e8:	89 c2                	mov    %eax,%edx
801032ea:	83 e0 0f             	and    $0xf,%eax
801032ed:	c1 ea 04             	shr    $0x4,%edx
801032f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801032f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801032fc:	89 c2                	mov    %eax,%edx
801032fe:	83 e0 0f             	and    $0xf,%eax
80103301:	c1 ea 04             	shr    $0x4,%edx
80103304:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103307:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010330a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010330d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103310:	89 c2                	mov    %eax,%edx
80103312:	83 e0 0f             	and    $0xf,%eax
80103315:	c1 ea 04             	shr    $0x4,%edx
80103318:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010331b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010331e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103321:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103324:	89 c2                	mov    %eax,%edx
80103326:	83 e0 0f             	and    $0xf,%eax
80103329:	c1 ea 04             	shr    $0x4,%edx
8010332c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010332f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103332:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103335:	8b 75 08             	mov    0x8(%ebp),%esi
80103338:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010333b:	89 06                	mov    %eax,(%esi)
8010333d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103340:	89 46 04             	mov    %eax,0x4(%esi)
80103343:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103346:	89 46 08             	mov    %eax,0x8(%esi)
80103349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010334c:	89 46 0c             	mov    %eax,0xc(%esi)
8010334f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103352:	89 46 10             	mov    %eax,0x10(%esi)
80103355:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103358:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010335b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103362:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103365:	5b                   	pop    %ebx
80103366:	5e                   	pop    %esi
80103367:	5f                   	pop    %edi
80103368:	5d                   	pop    %ebp
80103369:	c3                   	ret    
8010336a:	66 90                	xchg   %ax,%ax
8010336c:	66 90                	xchg   %ax,%ax
8010336e:	66 90                	xchg   %ax,%ax

80103370 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103370:	8b 0d 08 2c 11 80    	mov    0x80112c08,%ecx
80103376:	85 c9                	test   %ecx,%ecx
80103378:	0f 8e 8a 00 00 00    	jle    80103408 <install_trans+0x98>
{
8010337e:	55                   	push   %ebp
8010337f:	89 e5                	mov    %esp,%ebp
80103381:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103382:	31 ff                	xor    %edi,%edi
{
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 0c             	sub    $0xc,%esp
80103389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103390:	a1 f4 2b 11 80       	mov    0x80112bf4,%eax
80103395:	83 ec 08             	sub    $0x8,%esp
80103398:	01 f8                	add    %edi,%eax
8010339a:	83 c0 01             	add    $0x1,%eax
8010339d:	50                   	push   %eax
8010339e:	ff 35 04 2c 11 80    	push   0x80112c04
801033a4:	e8 27 cd ff ff       	call   801000d0 <bread>
801033a9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033ab:	58                   	pop    %eax
801033ac:	5a                   	pop    %edx
801033ad:	ff 34 bd 0c 2c 11 80 	push   -0x7feed3f4(,%edi,4)
801033b4:	ff 35 04 2c 11 80    	push   0x80112c04
  for (tail = 0; tail < log.lh.n; tail++) {
801033ba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033bd:	e8 0e cd ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033c5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033c7:	8d 46 5c             	lea    0x5c(%esi),%eax
801033ca:	68 00 02 00 00       	push   $0x200
801033cf:	50                   	push   %eax
801033d0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801033d3:	50                   	push   %eax
801033d4:	e8 d7 1a 00 00       	call   80104eb0 <memmove>
    bwrite(dbuf);  // write dst to disk
801033d9:	89 1c 24             	mov    %ebx,(%esp)
801033dc:	e8 cf cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801033e1:	89 34 24             	mov    %esi,(%esp)
801033e4:	e8 07 ce ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801033e9:	89 1c 24             	mov    %ebx,(%esp)
801033ec:	e8 ff cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801033f1:	83 c4 10             	add    $0x10,%esp
801033f4:	39 3d 08 2c 11 80    	cmp    %edi,0x80112c08
801033fa:	7f 94                	jg     80103390 <install_trans+0x20>
  }
}
801033fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ff:	5b                   	pop    %ebx
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
80103404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103408:	c3                   	ret    
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103410 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	53                   	push   %ebx
80103414:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103417:	ff 35 f4 2b 11 80    	push   0x80112bf4
8010341d:	ff 35 04 2c 11 80    	push   0x80112c04
80103423:	e8 a8 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103428:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010342b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010342d:	a1 08 2c 11 80       	mov    0x80112c08,%eax
80103432:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103435:	85 c0                	test   %eax,%eax
80103437:	7e 19                	jle    80103452 <write_head+0x42>
80103439:	31 d2                	xor    %edx,%edx
8010343b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010343f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103440:	8b 0c 95 0c 2c 11 80 	mov    -0x7feed3f4(,%edx,4),%ecx
80103447:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010344b:	83 c2 01             	add    $0x1,%edx
8010344e:	39 d0                	cmp    %edx,%eax
80103450:	75 ee                	jne    80103440 <write_head+0x30>
  }
  bwrite(buf);
80103452:	83 ec 0c             	sub    $0xc,%esp
80103455:	53                   	push   %ebx
80103456:	e8 55 cd ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010345b:	89 1c 24             	mov    %ebx,(%esp)
8010345e:	e8 8d cd ff ff       	call   801001f0 <brelse>
}
80103463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103466:	83 c4 10             	add    $0x10,%esp
80103469:	c9                   	leave  
8010346a:	c3                   	ret    
8010346b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010346f:	90                   	nop

80103470 <initlog>:
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	53                   	push   %ebx
80103474:	83 ec 2c             	sub    $0x2c,%esp
80103477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010347a:	68 e0 7d 10 80       	push   $0x80107de0
8010347f:	68 c0 2b 11 80       	push   $0x80112bc0
80103484:	e8 f7 16 00 00       	call   80104b80 <initlock>
  readsb(dev, &sb);
80103489:	58                   	pop    %eax
8010348a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010348d:	5a                   	pop    %edx
8010348e:	50                   	push   %eax
8010348f:	53                   	push   %ebx
80103490:	e8 3b e8 ff ff       	call   80101cd0 <readsb>
  log.start = sb.logstart;
80103495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103498:	59                   	pop    %ecx
  log.dev = dev;
80103499:	89 1d 04 2c 11 80    	mov    %ebx,0x80112c04
  log.size = sb.nlog;
8010349f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801034a2:	a3 f4 2b 11 80       	mov    %eax,0x80112bf4
  log.size = sb.nlog;
801034a7:	89 15 f8 2b 11 80    	mov    %edx,0x80112bf8
  struct buf *buf = bread(log.dev, log.start);
801034ad:	5a                   	pop    %edx
801034ae:	50                   	push   %eax
801034af:	53                   	push   %ebx
801034b0:	e8 1b cc ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801034b5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801034b8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801034bb:	89 1d 08 2c 11 80    	mov    %ebx,0x80112c08
  for (i = 0; i < log.lh.n; i++) {
801034c1:	85 db                	test   %ebx,%ebx
801034c3:	7e 1d                	jle    801034e2 <initlog+0x72>
801034c5:	31 d2                	xor    %edx,%edx
801034c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ce:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801034d0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801034d4:	89 0c 95 0c 2c 11 80 	mov    %ecx,-0x7feed3f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034db:	83 c2 01             	add    $0x1,%edx
801034de:	39 d3                	cmp    %edx,%ebx
801034e0:	75 ee                	jne    801034d0 <initlog+0x60>
  brelse(buf);
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	50                   	push   %eax
801034e6:	e8 05 cd ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801034eb:	e8 80 fe ff ff       	call   80103370 <install_trans>
  log.lh.n = 0;
801034f0:	c7 05 08 2c 11 80 00 	movl   $0x0,0x80112c08
801034f7:	00 00 00 
  write_head(); // clear the log
801034fa:	e8 11 ff ff ff       	call   80103410 <write_head>
}
801034ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103502:	83 c4 10             	add    $0x10,%esp
80103505:	c9                   	leave  
80103506:	c3                   	ret    
80103507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350e:	66 90                	xchg   %ax,%ax

80103510 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103516:	68 c0 2b 11 80       	push   $0x80112bc0
8010351b:	e8 30 18 00 00       	call   80104d50 <acquire>
80103520:	83 c4 10             	add    $0x10,%esp
80103523:	eb 18                	jmp    8010353d <begin_op+0x2d>
80103525:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103528:	83 ec 08             	sub    $0x8,%esp
8010352b:	68 c0 2b 11 80       	push   $0x80112bc0
80103530:	68 c0 2b 11 80       	push   $0x80112bc0
80103535:	e8 b6 12 00 00       	call   801047f0 <sleep>
8010353a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010353d:	a1 00 2c 11 80       	mov    0x80112c00,%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	75 e2                	jne    80103528 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103546:	a1 fc 2b 11 80       	mov    0x80112bfc,%eax
8010354b:	8b 15 08 2c 11 80    	mov    0x80112c08,%edx
80103551:	83 c0 01             	add    $0x1,%eax
80103554:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103557:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010355a:	83 fa 1e             	cmp    $0x1e,%edx
8010355d:	7f c9                	jg     80103528 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010355f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103562:	a3 fc 2b 11 80       	mov    %eax,0x80112bfc
      release(&log.lock);
80103567:	68 c0 2b 11 80       	push   $0x80112bc0
8010356c:	e8 7f 17 00 00       	call   80104cf0 <release>
      break;
    }
  }
}
80103571:	83 c4 10             	add    $0x10,%esp
80103574:	c9                   	leave  
80103575:	c3                   	ret    
80103576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357d:	8d 76 00             	lea    0x0(%esi),%esi

80103580 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103589:	68 c0 2b 11 80       	push   $0x80112bc0
8010358e:	e8 bd 17 00 00       	call   80104d50 <acquire>
  log.outstanding -= 1;
80103593:	a1 fc 2b 11 80       	mov    0x80112bfc,%eax
  if(log.committing)
80103598:	8b 35 00 2c 11 80    	mov    0x80112c00,%esi
8010359e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801035a4:	89 1d fc 2b 11 80    	mov    %ebx,0x80112bfc
  if(log.committing)
801035aa:	85 f6                	test   %esi,%esi
801035ac:	0f 85 22 01 00 00    	jne    801036d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801035b2:	85 db                	test   %ebx,%ebx
801035b4:	0f 85 f6 00 00 00    	jne    801036b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801035ba:	c7 05 00 2c 11 80 01 	movl   $0x1,0x80112c00
801035c1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801035c4:	83 ec 0c             	sub    $0xc,%esp
801035c7:	68 c0 2b 11 80       	push   $0x80112bc0
801035cc:	e8 1f 17 00 00       	call   80104cf0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801035d1:	8b 0d 08 2c 11 80    	mov    0x80112c08,%ecx
801035d7:	83 c4 10             	add    $0x10,%esp
801035da:	85 c9                	test   %ecx,%ecx
801035dc:	7f 42                	jg     80103620 <end_op+0xa0>
    acquire(&log.lock);
801035de:	83 ec 0c             	sub    $0xc,%esp
801035e1:	68 c0 2b 11 80       	push   $0x80112bc0
801035e6:	e8 65 17 00 00       	call   80104d50 <acquire>
    wakeup(&log);
801035eb:	c7 04 24 c0 2b 11 80 	movl   $0x80112bc0,(%esp)
    log.committing = 0;
801035f2:	c7 05 00 2c 11 80 00 	movl   $0x0,0x80112c00
801035f9:	00 00 00 
    wakeup(&log);
801035fc:	e8 af 12 00 00       	call   801048b0 <wakeup>
    release(&log.lock);
80103601:	c7 04 24 c0 2b 11 80 	movl   $0x80112bc0,(%esp)
80103608:	e8 e3 16 00 00       	call   80104cf0 <release>
8010360d:	83 c4 10             	add    $0x10,%esp
}
80103610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103613:	5b                   	pop    %ebx
80103614:	5e                   	pop    %esi
80103615:	5f                   	pop    %edi
80103616:	5d                   	pop    %ebp
80103617:	c3                   	ret    
80103618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010361f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103620:	a1 f4 2b 11 80       	mov    0x80112bf4,%eax
80103625:	83 ec 08             	sub    $0x8,%esp
80103628:	01 d8                	add    %ebx,%eax
8010362a:	83 c0 01             	add    $0x1,%eax
8010362d:	50                   	push   %eax
8010362e:	ff 35 04 2c 11 80    	push   0x80112c04
80103634:	e8 97 ca ff ff       	call   801000d0 <bread>
80103639:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010363b:	58                   	pop    %eax
8010363c:	5a                   	pop    %edx
8010363d:	ff 34 9d 0c 2c 11 80 	push   -0x7feed3f4(,%ebx,4)
80103644:	ff 35 04 2c 11 80    	push   0x80112c04
  for (tail = 0; tail < log.lh.n; tail++) {
8010364a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010364d:	e8 7e ca ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103652:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103655:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103657:	8d 40 5c             	lea    0x5c(%eax),%eax
8010365a:	68 00 02 00 00       	push   $0x200
8010365f:	50                   	push   %eax
80103660:	8d 46 5c             	lea    0x5c(%esi),%eax
80103663:	50                   	push   %eax
80103664:	e8 47 18 00 00       	call   80104eb0 <memmove>
    bwrite(to);  // write the log
80103669:	89 34 24             	mov    %esi,(%esp)
8010366c:	e8 3f cb ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103671:	89 3c 24             	mov    %edi,(%esp)
80103674:	e8 77 cb ff ff       	call   801001f0 <brelse>
    brelse(to);
80103679:	89 34 24             	mov    %esi,(%esp)
8010367c:	e8 6f cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	3b 1d 08 2c 11 80    	cmp    0x80112c08,%ebx
8010368a:	7c 94                	jl     80103620 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010368c:	e8 7f fd ff ff       	call   80103410 <write_head>
    install_trans(); // Now install writes to home locations
80103691:	e8 da fc ff ff       	call   80103370 <install_trans>
    log.lh.n = 0;
80103696:	c7 05 08 2c 11 80 00 	movl   $0x0,0x80112c08
8010369d:	00 00 00 
    write_head();    // Erase the transaction from the log
801036a0:	e8 6b fd ff ff       	call   80103410 <write_head>
801036a5:	e9 34 ff ff ff       	jmp    801035de <end_op+0x5e>
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	68 c0 2b 11 80       	push   $0x80112bc0
801036b8:	e8 f3 11 00 00       	call   801048b0 <wakeup>
  release(&log.lock);
801036bd:	c7 04 24 c0 2b 11 80 	movl   $0x80112bc0,(%esp)
801036c4:	e8 27 16 00 00       	call   80104cf0 <release>
801036c9:	83 c4 10             	add    $0x10,%esp
}
801036cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036cf:	5b                   	pop    %ebx
801036d0:	5e                   	pop    %esi
801036d1:	5f                   	pop    %edi
801036d2:	5d                   	pop    %ebp
801036d3:	c3                   	ret    
    panic("log.committing");
801036d4:	83 ec 0c             	sub    $0xc,%esp
801036d7:	68 e4 7d 10 80       	push   $0x80107de4
801036dc:	e8 6f cd ff ff       	call   80100450 <panic>
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ef:	90                   	nop

801036f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036f7:	8b 15 08 2c 11 80    	mov    0x80112c08,%edx
{
801036fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103700:	83 fa 1d             	cmp    $0x1d,%edx
80103703:	0f 8f 85 00 00 00    	jg     8010378e <log_write+0x9e>
80103709:	a1 f8 2b 11 80       	mov    0x80112bf8,%eax
8010370e:	83 e8 01             	sub    $0x1,%eax
80103711:	39 c2                	cmp    %eax,%edx
80103713:	7d 79                	jge    8010378e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103715:	a1 fc 2b 11 80       	mov    0x80112bfc,%eax
8010371a:	85 c0                	test   %eax,%eax
8010371c:	7e 7d                	jle    8010379b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010371e:	83 ec 0c             	sub    $0xc,%esp
80103721:	68 c0 2b 11 80       	push   $0x80112bc0
80103726:	e8 25 16 00 00       	call   80104d50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010372b:	8b 15 08 2c 11 80    	mov    0x80112c08,%edx
80103731:	83 c4 10             	add    $0x10,%esp
80103734:	85 d2                	test   %edx,%edx
80103736:	7e 4a                	jle    80103782 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103738:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010373b:	31 c0                	xor    %eax,%eax
8010373d:	eb 08                	jmp    80103747 <log_write+0x57>
8010373f:	90                   	nop
80103740:	83 c0 01             	add    $0x1,%eax
80103743:	39 c2                	cmp    %eax,%edx
80103745:	74 29                	je     80103770 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103747:	39 0c 85 0c 2c 11 80 	cmp    %ecx,-0x7feed3f4(,%eax,4)
8010374e:	75 f0                	jne    80103740 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103750:	89 0c 85 0c 2c 11 80 	mov    %ecx,-0x7feed3f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103757:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010375a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010375d:	c7 45 08 c0 2b 11 80 	movl   $0x80112bc0,0x8(%ebp)
}
80103764:	c9                   	leave  
  release(&log.lock);
80103765:	e9 86 15 00 00       	jmp    80104cf0 <release>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103770:	89 0c 95 0c 2c 11 80 	mov    %ecx,-0x7feed3f4(,%edx,4)
    log.lh.n++;
80103777:	83 c2 01             	add    $0x1,%edx
8010377a:	89 15 08 2c 11 80    	mov    %edx,0x80112c08
80103780:	eb d5                	jmp    80103757 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103782:	8b 43 08             	mov    0x8(%ebx),%eax
80103785:	a3 0c 2c 11 80       	mov    %eax,0x80112c0c
  if (i == log.lh.n)
8010378a:	75 cb                	jne    80103757 <log_write+0x67>
8010378c:	eb e9                	jmp    80103777 <log_write+0x87>
    panic("too big a transaction");
8010378e:	83 ec 0c             	sub    $0xc,%esp
80103791:	68 f3 7d 10 80       	push   $0x80107df3
80103796:	e8 b5 cc ff ff       	call   80100450 <panic>
    panic("log_write outside of trans");
8010379b:	83 ec 0c             	sub    $0xc,%esp
8010379e:	68 09 7e 10 80       	push   $0x80107e09
801037a3:	e8 a8 cc ff ff       	call   80100450 <panic>
801037a8:	66 90                	xchg   %ax,%ax
801037aa:	66 90                	xchg   %ax,%ax
801037ac:	66 90                	xchg   %ax,%ax
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
801037b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801037b7:	e8 44 09 00 00       	call   80104100 <cpuid>
801037bc:	89 c3                	mov    %eax,%ebx
801037be:	e8 3d 09 00 00       	call   80104100 <cpuid>
801037c3:	83 ec 04             	sub    $0x4,%esp
801037c6:	53                   	push   %ebx
801037c7:	50                   	push   %eax
801037c8:	68 24 7e 10 80       	push   $0x80107e24
801037cd:	e8 ae d0 ff ff       	call   80100880 <cprintf>
  idtinit();       // load idt register
801037d2:	e8 b9 28 00 00       	call   80106090 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801037d7:	e8 c4 08 00 00       	call   801040a0 <mycpu>
801037dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037de:	b8 01 00 00 00       	mov    $0x1,%eax
801037e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801037ea:	e8 f1 0b 00 00       	call   801043e0 <scheduler>
801037ef:	90                   	nop

801037f0 <mpenter>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037f6:	e8 85 39 00 00       	call   80107180 <switchkvm>
  seginit();
801037fb:	e8 f0 38 00 00       	call   801070f0 <seginit>
  lapicinit();
80103800:	e8 9b f7 ff ff       	call   80102fa0 <lapicinit>
  mpmain();
80103805:	e8 a6 ff ff ff       	call   801037b0 <mpmain>
8010380a:	66 90                	xchg   %ax,%ax
8010380c:	66 90                	xchg   %ax,%ax
8010380e:	66 90                	xchg   %ax,%ax

80103810 <main>:
{
80103810:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103814:	83 e4 f0             	and    $0xfffffff0,%esp
80103817:	ff 71 fc             	push   -0x4(%ecx)
8010381a:	55                   	push   %ebp
8010381b:	89 e5                	mov    %esp,%ebp
8010381d:	53                   	push   %ebx
8010381e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010381f:	83 ec 08             	sub    $0x8,%esp
80103822:	68 00 00 40 80       	push   $0x80400000
80103827:	68 f0 69 11 80       	push   $0x801169f0
8010382c:	e8 8f f5 ff ff       	call   80102dc0 <kinit1>
  kvmalloc();      // kernel page table
80103831:	e8 3a 3e 00 00       	call   80107670 <kvmalloc>
  mpinit();        // detect other processors
80103836:	e8 85 01 00 00       	call   801039c0 <mpinit>
  lapicinit();     // interrupt controller
8010383b:	e8 60 f7 ff ff       	call   80102fa0 <lapicinit>
  seginit();       // segment descriptors
80103840:	e8 ab 38 00 00       	call   801070f0 <seginit>
  picinit();       // disable pic
80103845:	e8 76 03 00 00       	call   80103bc0 <picinit>
  ioapicinit();    // another interrupt controller
8010384a:	e8 31 f3 ff ff       	call   80102b80 <ioapicinit>
  consoleinit();   // console hardware
8010384f:	e8 bc d9 ff ff       	call   80101210 <consoleinit>
  uartinit();      // serial port
80103854:	e8 27 2b 00 00       	call   80106380 <uartinit>
  pinit();         // process table
80103859:	e8 22 08 00 00       	call   80104080 <pinit>
  tvinit();        // trap vectors
8010385e:	e8 ad 27 00 00       	call   80106010 <tvinit>
  binit();         // buffer cache
80103863:	e8 d8 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103868:	e8 53 dd ff ff       	call   801015c0 <fileinit>
  ideinit();       // disk 
8010386d:	e8 fe f0 ff ff       	call   80102970 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103872:	83 c4 0c             	add    $0xc,%esp
80103875:	68 8a 00 00 00       	push   $0x8a
8010387a:	68 8c b4 10 80       	push   $0x8010b48c
8010387f:	68 00 70 00 80       	push   $0x80007000
80103884:	e8 27 16 00 00       	call   80104eb0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	69 05 a4 2c 11 80 b0 	imul   $0xb0,0x80112ca4,%eax
80103893:	00 00 00 
80103896:	05 c0 2c 11 80       	add    $0x80112cc0,%eax
8010389b:	3d c0 2c 11 80       	cmp    $0x80112cc0,%eax
801038a0:	76 7e                	jbe    80103920 <main+0x110>
801038a2:	bb c0 2c 11 80       	mov    $0x80112cc0,%ebx
801038a7:	eb 20                	jmp    801038c9 <main+0xb9>
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038b0:	69 05 a4 2c 11 80 b0 	imul   $0xb0,0x80112ca4,%eax
801038b7:	00 00 00 
801038ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801038c0:	05 c0 2c 11 80       	add    $0x80112cc0,%eax
801038c5:	39 c3                	cmp    %eax,%ebx
801038c7:	73 57                	jae    80103920 <main+0x110>
    if(c == mycpu())  // We've started already.
801038c9:	e8 d2 07 00 00       	call   801040a0 <mycpu>
801038ce:	39 c3                	cmp    %eax,%ebx
801038d0:	74 de                	je     801038b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038d2:	e8 59 f5 ff ff       	call   80102e30 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801038d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801038da:	c7 05 f8 6f 00 80 f0 	movl   $0x801037f0,0x80006ff8
801038e1:	37 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038e4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801038eb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801038ee:	05 00 10 00 00       	add    $0x1000,%eax
801038f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801038f8:	0f b6 03             	movzbl (%ebx),%eax
801038fb:	68 00 70 00 00       	push   $0x7000
80103900:	50                   	push   %eax
80103901:	e8 ea f7 ff ff       	call   801030f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103906:	83 c4 10             	add    $0x10,%esp
80103909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103910:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103916:	85 c0                	test   %eax,%eax
80103918:	74 f6                	je     80103910 <main+0x100>
8010391a:	eb 94                	jmp    801038b0 <main+0xa0>
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103920:	83 ec 08             	sub    $0x8,%esp
80103923:	68 00 00 00 8e       	push   $0x8e000000
80103928:	68 00 00 40 80       	push   $0x80400000
8010392d:	e8 2e f4 ff ff       	call   80102d60 <kinit2>
  userinit();      // first user process
80103932:	e8 19 08 00 00       	call   80104150 <userinit>
  mpmain();        // finish this processor's setup
80103937:	e8 74 fe ff ff       	call   801037b0 <mpmain>
8010393c:	66 90                	xchg   %ax,%ax
8010393e:	66 90                	xchg   %ax,%ax

80103940 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103945:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010394b:	53                   	push   %ebx
  e = addr+len;
8010394c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010394f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103952:	39 de                	cmp    %ebx,%esi
80103954:	72 10                	jb     80103966 <mpsearch1+0x26>
80103956:	eb 50                	jmp    801039a8 <mpsearch1+0x68>
80103958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop
80103960:	89 fe                	mov    %edi,%esi
80103962:	39 fb                	cmp    %edi,%ebx
80103964:	76 42                	jbe    801039a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103966:	83 ec 04             	sub    $0x4,%esp
80103969:	8d 7e 10             	lea    0x10(%esi),%edi
8010396c:	6a 04                	push   $0x4
8010396e:	68 38 7e 10 80       	push   $0x80107e38
80103973:	56                   	push   %esi
80103974:	e8 e7 14 00 00       	call   80104e60 <memcmp>
80103979:	83 c4 10             	add    $0x10,%esp
8010397c:	85 c0                	test   %eax,%eax
8010397e:	75 e0                	jne    80103960 <mpsearch1+0x20>
80103980:	89 f2                	mov    %esi,%edx
80103982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103988:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010398b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010398e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103990:	39 fa                	cmp    %edi,%edx
80103992:	75 f4                	jne    80103988 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103994:	84 c0                	test   %al,%al
80103996:	75 c8                	jne    80103960 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103998:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010399b:	89 f0                	mov    %esi,%eax
8010399d:	5b                   	pop    %ebx
8010399e:	5e                   	pop    %esi
8010399f:	5f                   	pop    %edi
801039a0:	5d                   	pop    %ebp
801039a1:	c3                   	ret    
801039a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039ab:	31 f6                	xor    %esi,%esi
}
801039ad:	5b                   	pop    %ebx
801039ae:	89 f0                	mov    %esi,%eax
801039b0:	5e                   	pop    %esi
801039b1:	5f                   	pop    %edi
801039b2:	5d                   	pop    %ebp
801039b3:	c3                   	ret    
801039b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	56                   	push   %esi
801039c5:	53                   	push   %ebx
801039c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801039c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801039d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801039d7:	c1 e0 08             	shl    $0x8,%eax
801039da:	09 d0                	or     %edx,%eax
801039dc:	c1 e0 04             	shl    $0x4,%eax
801039df:	75 1b                	jne    801039fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801039e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801039e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801039ef:	c1 e0 08             	shl    $0x8,%eax
801039f2:	09 d0                	or     %edx,%eax
801039f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801039f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801039fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103a01:	e8 3a ff ff ff       	call   80103940 <mpsearch1>
80103a06:	89 c3                	mov    %eax,%ebx
80103a08:	85 c0                	test   %eax,%eax
80103a0a:	0f 84 40 01 00 00    	je     80103b50 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a10:	8b 73 04             	mov    0x4(%ebx),%esi
80103a13:	85 f6                	test   %esi,%esi
80103a15:	0f 84 25 01 00 00    	je     80103b40 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
80103a1b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a1e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103a24:	6a 04                	push   $0x4
80103a26:	68 3d 7e 10 80       	push   $0x80107e3d
80103a2b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103a2f:	e8 2c 14 00 00       	call   80104e60 <memcmp>
80103a34:	83 c4 10             	add    $0x10,%esp
80103a37:	85 c0                	test   %eax,%eax
80103a39:	0f 85 01 01 00 00    	jne    80103b40 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
80103a3f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103a46:	3c 01                	cmp    $0x1,%al
80103a48:	74 08                	je     80103a52 <mpinit+0x92>
80103a4a:	3c 04                	cmp    $0x4,%al
80103a4c:	0f 85 ee 00 00 00    	jne    80103b40 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103a52:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103a59:	66 85 d2             	test   %dx,%dx
80103a5c:	74 22                	je     80103a80 <mpinit+0xc0>
80103a5e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103a61:	89 f0                	mov    %esi,%eax
  sum = 0;
80103a63:	31 d2                	xor    %edx,%edx
80103a65:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103a68:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103a6f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103a72:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103a74:	39 c7                	cmp    %eax,%edi
80103a76:	75 f0                	jne    80103a68 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103a78:	84 d2                	test   %dl,%dl
80103a7a:	0f 85 c0 00 00 00    	jne    80103b40 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103a80:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103a86:	a3 a0 2b 11 80       	mov    %eax,0x80112ba0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a8b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103a92:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103a98:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a9d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103aa0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103aa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aa7:	90                   	nop
80103aa8:	39 d0                	cmp    %edx,%eax
80103aaa:	73 15                	jae    80103ac1 <mpinit+0x101>
    switch(*p){
80103aac:	0f b6 08             	movzbl (%eax),%ecx
80103aaf:	80 f9 02             	cmp    $0x2,%cl
80103ab2:	74 4c                	je     80103b00 <mpinit+0x140>
80103ab4:	77 3a                	ja     80103af0 <mpinit+0x130>
80103ab6:	84 c9                	test   %cl,%cl
80103ab8:	74 56                	je     80103b10 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103aba:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103abd:	39 d0                	cmp    %edx,%eax
80103abf:	72 eb                	jb     80103aac <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103ac1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ac4:	85 f6                	test   %esi,%esi
80103ac6:	0f 84 d9 00 00 00    	je     80103ba5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103acc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103ad0:	74 15                	je     80103ae7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ad2:	b8 70 00 00 00       	mov    $0x70,%eax
80103ad7:	ba 22 00 00 00       	mov    $0x22,%edx
80103adc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103add:	ba 23 00 00 00       	mov    $0x23,%edx
80103ae2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ae3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ae6:	ee                   	out    %al,(%dx)
  }
}
80103ae7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aea:	5b                   	pop    %ebx
80103aeb:	5e                   	pop    %esi
80103aec:	5f                   	pop    %edi
80103aed:	5d                   	pop    %ebp
80103aee:	c3                   	ret    
80103aef:	90                   	nop
    switch(*p){
80103af0:	83 e9 03             	sub    $0x3,%ecx
80103af3:	80 f9 01             	cmp    $0x1,%cl
80103af6:	76 c2                	jbe    80103aba <mpinit+0xfa>
80103af8:	31 f6                	xor    %esi,%esi
80103afa:	eb ac                	jmp    80103aa8 <mpinit+0xe8>
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b00:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103b04:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b07:	88 0d a0 2c 11 80    	mov    %cl,0x80112ca0
      continue;
80103b0d:	eb 99                	jmp    80103aa8 <mpinit+0xe8>
80103b0f:	90                   	nop
      if(ncpu < NCPU) {
80103b10:	8b 0d a4 2c 11 80    	mov    0x80112ca4,%ecx
80103b16:	83 f9 07             	cmp    $0x7,%ecx
80103b19:	7f 19                	jg     80103b34 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b1b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103b21:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103b25:	83 c1 01             	add    $0x1,%ecx
80103b28:	89 0d a4 2c 11 80    	mov    %ecx,0x80112ca4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b2e:	88 9f c0 2c 11 80    	mov    %bl,-0x7feed340(%edi)
      p += sizeof(struct mpproc);
80103b34:	83 c0 14             	add    $0x14,%eax
      continue;
80103b37:	e9 6c ff ff ff       	jmp    80103aa8 <mpinit+0xe8>
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 42 7e 10 80       	push   $0x80107e42
80103b48:	e8 03 c9 ff ff       	call   80100450 <panic>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103b50:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103b55:	eb 13                	jmp    80103b6a <mpinit+0x1aa>
80103b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103b60:	89 f3                	mov    %esi,%ebx
80103b62:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103b68:	74 d6                	je     80103b40 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b6a:	83 ec 04             	sub    $0x4,%esp
80103b6d:	8d 73 10             	lea    0x10(%ebx),%esi
80103b70:	6a 04                	push   $0x4
80103b72:	68 38 7e 10 80       	push   $0x80107e38
80103b77:	53                   	push   %ebx
80103b78:	e8 e3 12 00 00       	call   80104e60 <memcmp>
80103b7d:	83 c4 10             	add    $0x10,%esp
80103b80:	85 c0                	test   %eax,%eax
80103b82:	75 dc                	jne    80103b60 <mpinit+0x1a0>
80103b84:	89 da                	mov    %ebx,%edx
80103b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103b90:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103b93:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103b96:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103b98:	39 d6                	cmp    %edx,%esi
80103b9a:	75 f4                	jne    80103b90 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b9c:	84 c0                	test   %al,%al
80103b9e:	75 c0                	jne    80103b60 <mpinit+0x1a0>
80103ba0:	e9 6b fe ff ff       	jmp    80103a10 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103ba5:	83 ec 0c             	sub    $0xc,%esp
80103ba8:	68 5c 7e 10 80       	push   $0x80107e5c
80103bad:	e8 9e c8 ff ff       	call   80100450 <panic>
80103bb2:	66 90                	xchg   %ax,%ax
80103bb4:	66 90                	xchg   %ax,%ax
80103bb6:	66 90                	xchg   %ax,%ax
80103bb8:	66 90                	xchg   %ax,%ax
80103bba:	66 90                	xchg   %ax,%ax
80103bbc:	66 90                	xchg   %ax,%ax
80103bbe:	66 90                	xchg   %ax,%ax

80103bc0 <picinit>:
80103bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bc5:	ba 21 00 00 00       	mov    $0x21,%edx
80103bca:	ee                   	out    %al,(%dx)
80103bcb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103bd0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103bd1:	c3                   	ret    
80103bd2:	66 90                	xchg   %ax,%ax
80103bd4:	66 90                	xchg   %ax,%ax
80103bd6:	66 90                	xchg   %ax,%ax
80103bd8:	66 90                	xchg   %ax,%ax
80103bda:	66 90                	xchg   %ax,%ax
80103bdc:	66 90                	xchg   %ax,%ax
80103bde:	66 90                	xchg   %ax,%ax

80103be0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 0c             	sub    $0xc,%esp
80103be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103bef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103bf5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bfb:	e8 e0 d9 ff ff       	call   801015e0 <filealloc>
80103c00:	89 03                	mov    %eax,(%ebx)
80103c02:	85 c0                	test   %eax,%eax
80103c04:	0f 84 a8 00 00 00    	je     80103cb2 <pipealloc+0xd2>
80103c0a:	e8 d1 d9 ff ff       	call   801015e0 <filealloc>
80103c0f:	89 06                	mov    %eax,(%esi)
80103c11:	85 c0                	test   %eax,%eax
80103c13:	0f 84 87 00 00 00    	je     80103ca0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c19:	e8 12 f2 ff ff       	call   80102e30 <kalloc>
80103c1e:	89 c7                	mov    %eax,%edi
80103c20:	85 c0                	test   %eax,%eax
80103c22:	0f 84 b0 00 00 00    	je     80103cd8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103c28:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c2f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103c32:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103c35:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c3c:	00 00 00 
  p->nwrite = 0;
80103c3f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c46:	00 00 00 
  p->nread = 0;
80103c49:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c50:	00 00 00 
  initlock(&p->lock, "pipe");
80103c53:	68 7b 7e 10 80       	push   $0x80107e7b
80103c58:	50                   	push   %eax
80103c59:	e8 22 0f 00 00       	call   80104b80 <initlock>
  (*f0)->type = FD_PIPE;
80103c5e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103c60:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103c63:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c69:	8b 03                	mov    (%ebx),%eax
80103c6b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c6f:	8b 03                	mov    (%ebx),%eax
80103c71:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c75:	8b 03                	mov    (%ebx),%eax
80103c77:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c7a:	8b 06                	mov    (%esi),%eax
80103c7c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103c82:	8b 06                	mov    (%esi),%eax
80103c84:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103c88:	8b 06                	mov    (%esi),%eax
80103c8a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103c8e:	8b 06                	mov    (%esi),%eax
80103c90:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c96:	31 c0                	xor    %eax,%eax
}
80103c98:	5b                   	pop    %ebx
80103c99:	5e                   	pop    %esi
80103c9a:	5f                   	pop    %edi
80103c9b:	5d                   	pop    %ebp
80103c9c:	c3                   	ret    
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103ca0:	8b 03                	mov    (%ebx),%eax
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	74 1e                	je     80103cc4 <pipealloc+0xe4>
    fileclose(*f0);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	50                   	push   %eax
80103caa:	e8 f1 d9 ff ff       	call   801016a0 <fileclose>
80103caf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103cb2:	8b 06                	mov    (%esi),%eax
80103cb4:	85 c0                	test   %eax,%eax
80103cb6:	74 0c                	je     80103cc4 <pipealloc+0xe4>
    fileclose(*f1);
80103cb8:	83 ec 0c             	sub    $0xc,%esp
80103cbb:	50                   	push   %eax
80103cbc:	e8 df d9 ff ff       	call   801016a0 <fileclose>
80103cc1:	83 c4 10             	add    $0x10,%esp
}
80103cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103cc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ccc:	5b                   	pop    %ebx
80103ccd:	5e                   	pop    %esi
80103cce:	5f                   	pop    %edi
80103ccf:	5d                   	pop    %ebp
80103cd0:	c3                   	ret    
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103cd8:	8b 03                	mov    (%ebx),%eax
80103cda:	85 c0                	test   %eax,%eax
80103cdc:	75 c8                	jne    80103ca6 <pipealloc+0xc6>
80103cde:	eb d2                	jmp    80103cb2 <pipealloc+0xd2>

80103ce0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ce8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103ceb:	83 ec 0c             	sub    $0xc,%esp
80103cee:	53                   	push   %ebx
80103cef:	e8 5c 10 00 00       	call   80104d50 <acquire>
  if(writable){
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	85 f6                	test   %esi,%esi
80103cf9:	74 65                	je     80103d60 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103cfb:	83 ec 0c             	sub    $0xc,%esp
80103cfe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103d04:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d0b:	00 00 00 
    wakeup(&p->nread);
80103d0e:	50                   	push   %eax
80103d0f:	e8 9c 0b 00 00       	call   801048b0 <wakeup>
80103d14:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d17:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d1d:	85 d2                	test   %edx,%edx
80103d1f:	75 0a                	jne    80103d2b <pipeclose+0x4b>
80103d21:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	74 15                	je     80103d40 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103d2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d31:	5b                   	pop    %ebx
80103d32:	5e                   	pop    %esi
80103d33:	5d                   	pop    %ebp
    release(&p->lock);
80103d34:	e9 b7 0f 00 00       	jmp    80104cf0 <release>
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	53                   	push   %ebx
80103d44:	e8 a7 0f 00 00       	call   80104cf0 <release>
    kfree((char*)p);
80103d49:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d4c:	83 c4 10             	add    $0x10,%esp
}
80103d4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d52:	5b                   	pop    %ebx
80103d53:	5e                   	pop    %esi
80103d54:	5d                   	pop    %ebp
    kfree((char*)p);
80103d55:	e9 16 ef ff ff       	jmp    80102c70 <kfree>
80103d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103d69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d70:	00 00 00 
    wakeup(&p->nwrite);
80103d73:	50                   	push   %eax
80103d74:	e8 37 0b 00 00       	call   801048b0 <wakeup>
80103d79:	83 c4 10             	add    $0x10,%esp
80103d7c:	eb 99                	jmp    80103d17 <pipeclose+0x37>
80103d7e:	66 90                	xchg   %ax,%ax

80103d80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 28             	sub    $0x28,%esp
80103d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103d8c:	53                   	push   %ebx
80103d8d:	e8 be 0f 00 00       	call   80104d50 <acquire>
  for(i = 0; i < n; i++){
80103d92:	8b 45 10             	mov    0x10(%ebp),%eax
80103d95:	83 c4 10             	add    $0x10,%esp
80103d98:	85 c0                	test   %eax,%eax
80103d9a:	0f 8e c0 00 00 00    	jle    80103e60 <pipewrite+0xe0>
80103da0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103da3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103da9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103daf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103db2:	03 45 10             	add    0x10(%ebp),%eax
80103db5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103db8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103dbe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dc4:	89 ca                	mov    %ecx,%edx
80103dc6:	05 00 02 00 00       	add    $0x200,%eax
80103dcb:	39 c1                	cmp    %eax,%ecx
80103dcd:	74 3f                	je     80103e0e <pipewrite+0x8e>
80103dcf:	eb 67                	jmp    80103e38 <pipewrite+0xb8>
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103dd8:	e8 43 03 00 00       	call   80104120 <myproc>
80103ddd:	8b 48 24             	mov    0x24(%eax),%ecx
80103de0:	85 c9                	test   %ecx,%ecx
80103de2:	75 34                	jne    80103e18 <pipewrite+0x98>
      wakeup(&p->nread);
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	57                   	push   %edi
80103de8:	e8 c3 0a 00 00       	call   801048b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ded:	58                   	pop    %eax
80103dee:	5a                   	pop    %edx
80103def:	53                   	push   %ebx
80103df0:	56                   	push   %esi
80103df1:	e8 fa 09 00 00       	call   801047f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103df6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103dfc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e02:	83 c4 10             	add    $0x10,%esp
80103e05:	05 00 02 00 00       	add    $0x200,%eax
80103e0a:	39 c2                	cmp    %eax,%edx
80103e0c:	75 2a                	jne    80103e38 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103e0e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	75 c0                	jne    80103dd8 <pipewrite+0x58>
        release(&p->lock);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	53                   	push   %ebx
80103e1c:	e8 cf 0e 00 00       	call   80104cf0 <release>
        return -1;
80103e21:	83 c4 10             	add    $0x10,%esp
80103e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e2c:	5b                   	pop    %ebx
80103e2d:	5e                   	pop    %esi
80103e2e:	5f                   	pop    %edi
80103e2f:	5d                   	pop    %ebp
80103e30:	c3                   	ret    
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103e3b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103e3e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103e44:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103e4a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103e4d:	83 c6 01             	add    $0x1,%esi
80103e50:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e53:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e57:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e5a:	0f 85 58 ff ff ff    	jne    80103db8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e69:	50                   	push   %eax
80103e6a:	e8 41 0a 00 00       	call   801048b0 <wakeup>
  release(&p->lock);
80103e6f:	89 1c 24             	mov    %ebx,(%esp)
80103e72:	e8 79 0e 00 00       	call   80104cf0 <release>
  return n;
80103e77:	8b 45 10             	mov    0x10(%ebp),%eax
80103e7a:	83 c4 10             	add    $0x10,%esp
80103e7d:	eb aa                	jmp    80103e29 <pipewrite+0xa9>
80103e7f:	90                   	nop

80103e80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 18             	sub    $0x18,%esp
80103e89:	8b 75 08             	mov    0x8(%ebp),%esi
80103e8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103e8f:	56                   	push   %esi
80103e90:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103e96:	e8 b5 0e 00 00       	call   80104d50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e9b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103eaa:	74 2f                	je     80103edb <piperead+0x5b>
80103eac:	eb 37                	jmp    80103ee5 <piperead+0x65>
80103eae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103eb0:	e8 6b 02 00 00       	call   80104120 <myproc>
80103eb5:	8b 48 24             	mov    0x24(%eax),%ecx
80103eb8:	85 c9                	test   %ecx,%ecx
80103eba:	0f 85 80 00 00 00    	jne    80103f40 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ec0:	83 ec 08             	sub    $0x8,%esp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
80103ec5:	e8 26 09 00 00       	call   801047f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103eca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ed0:	83 c4 10             	add    $0x10,%esp
80103ed3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103ed9:	75 0a                	jne    80103ee5 <piperead+0x65>
80103edb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103ee1:	85 c0                	test   %eax,%eax
80103ee3:	75 cb                	jne    80103eb0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ee5:	8b 55 10             	mov    0x10(%ebp),%edx
80103ee8:	31 db                	xor    %ebx,%ebx
80103eea:	85 d2                	test   %edx,%edx
80103eec:	7f 20                	jg     80103f0e <piperead+0x8e>
80103eee:	eb 2c                	jmp    80103f1c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103ef0:	8d 48 01             	lea    0x1(%eax),%ecx
80103ef3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103ef8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103efe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103f03:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f06:	83 c3 01             	add    $0x1,%ebx
80103f09:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f0c:	74 0e                	je     80103f1c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103f0e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f14:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103f1a:	75 d4                	jne    80103ef0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f1c:	83 ec 0c             	sub    $0xc,%esp
80103f1f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103f25:	50                   	push   %eax
80103f26:	e8 85 09 00 00       	call   801048b0 <wakeup>
  release(&p->lock);
80103f2b:	89 34 24             	mov    %esi,(%esp)
80103f2e:	e8 bd 0d 00 00       	call   80104cf0 <release>
  return i;
80103f33:	83 c4 10             	add    $0x10,%esp
}
80103f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f39:	89 d8                	mov    %ebx,%eax
80103f3b:	5b                   	pop    %ebx
80103f3c:	5e                   	pop    %esi
80103f3d:	5f                   	pop    %edi
80103f3e:	5d                   	pop    %ebp
80103f3f:	c3                   	ret    
      release(&p->lock);
80103f40:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f48:	56                   	push   %esi
80103f49:	e8 a2 0d 00 00       	call   80104cf0 <release>
      return -1;
80103f4e:	83 c4 10             	add    $0x10,%esp
}
80103f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f54:	89 d8                	mov    %ebx,%eax
80103f56:	5b                   	pop    %ebx
80103f57:	5e                   	pop    %esi
80103f58:	5f                   	pop    %edi
80103f59:	5d                   	pop    %ebp
80103f5a:	c3                   	ret    
80103f5b:	66 90                	xchg   %ax,%ax
80103f5d:	66 90                	xchg   %ax,%ax
80103f5f:	90                   	nop

80103f60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f64:	bb 74 32 11 80       	mov    $0x80113274,%ebx
{
80103f69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103f6c:	68 40 32 11 80       	push   $0x80113240
80103f71:	e8 da 0d 00 00       	call   80104d50 <acquire>
80103f76:	83 c4 10             	add    $0x10,%esp
80103f79:	eb 10                	jmp    80103f8b <allocproc+0x2b>
80103f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f7f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f80:	83 c3 7c             	add    $0x7c,%ebx
80103f83:	81 fb 74 51 11 80    	cmp    $0x80115174,%ebx
80103f89:	74 75                	je     80104000 <allocproc+0xa0>
    if(p->state == UNUSED)
80103f8b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	75 ee                	jne    80103f80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103f92:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103f97:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103f9a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103fa1:	89 43 10             	mov    %eax,0x10(%ebx)
80103fa4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103fa7:	68 40 32 11 80       	push   $0x80113240
  p->pid = nextpid++;
80103fac:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103fb2:	e8 39 0d 00 00       	call   80104cf0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103fb7:	e8 74 ee ff ff       	call   80102e30 <kalloc>
80103fbc:	83 c4 10             	add    $0x10,%esp
80103fbf:	89 43 08             	mov    %eax,0x8(%ebx)
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	74 53                	je     80104019 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103fc6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103fcc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103fcf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103fd4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103fd7:	c7 40 14 02 60 10 80 	movl   $0x80106002,0x14(%eax)
  p->context = (struct context*)sp;
80103fde:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103fe1:	6a 14                	push   $0x14
80103fe3:	6a 00                	push   $0x0
80103fe5:	50                   	push   %eax
80103fe6:	e8 25 0e 00 00       	call   80104e10 <memset>
  p->context->eip = (uint)forkret;
80103feb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103fee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ff1:	c7 40 10 30 40 10 80 	movl   $0x80104030,0x10(%eax)
}
80103ff8:	89 d8                	mov    %ebx,%eax
80103ffa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ffd:	c9                   	leave  
80103ffe:	c3                   	ret    
80103fff:	90                   	nop
  release(&ptable.lock);
80104000:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104003:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104005:	68 40 32 11 80       	push   $0x80113240
8010400a:	e8 e1 0c 00 00       	call   80104cf0 <release>
}
8010400f:	89 d8                	mov    %ebx,%eax
  return 0;
80104011:	83 c4 10             	add    $0x10,%esp
}
80104014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104017:	c9                   	leave  
80104018:	c3                   	ret    
    p->state = UNUSED;
80104019:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104020:	31 db                	xor    %ebx,%ebx
}
80104022:	89 d8                	mov    %ebx,%eax
80104024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104027:	c9                   	leave  
80104028:	c3                   	ret    
80104029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104030 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104036:	68 40 32 11 80       	push   $0x80113240
8010403b:	e8 b0 0c 00 00       	call   80104cf0 <release>

  if (first) {
80104040:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	85 c0                	test   %eax,%eax
8010404a:	75 04                	jne    80104050 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010404c:	c9                   	leave  
8010404d:	c3                   	ret    
8010404e:	66 90                	xchg   %ax,%ax
    first = 0;
80104050:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80104057:	00 00 00 
    iinit(ROOTDEV);
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	6a 01                	push   $0x1
8010405f:	e8 ac dc ff ff       	call   80101d10 <iinit>
    initlog(ROOTDEV);
80104064:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010406b:	e8 00 f4 ff ff       	call   80103470 <initlog>
}
80104070:	83 c4 10             	add    $0x10,%esp
80104073:	c9                   	leave  
80104074:	c3                   	ret    
80104075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104080 <pinit>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104086:	68 80 7e 10 80       	push   $0x80107e80
8010408b:	68 40 32 11 80       	push   $0x80113240
80104090:	e8 eb 0a 00 00       	call   80104b80 <initlock>
}
80104095:	83 c4 10             	add    $0x10,%esp
80104098:	c9                   	leave  
80104099:	c3                   	ret    
8010409a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040a0 <mycpu>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040a5:	9c                   	pushf  
801040a6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040a7:	f6 c4 02             	test   $0x2,%ah
801040aa:	75 46                	jne    801040f2 <mycpu+0x52>
  apicid = lapicid();
801040ac:	e8 ef ef ff ff       	call   801030a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801040b1:	8b 35 a4 2c 11 80    	mov    0x80112ca4,%esi
801040b7:	85 f6                	test   %esi,%esi
801040b9:	7e 2a                	jle    801040e5 <mycpu+0x45>
801040bb:	31 d2                	xor    %edx,%edx
801040bd:	eb 08                	jmp    801040c7 <mycpu+0x27>
801040bf:	90                   	nop
801040c0:	83 c2 01             	add    $0x1,%edx
801040c3:	39 f2                	cmp    %esi,%edx
801040c5:	74 1e                	je     801040e5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801040c7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801040cd:	0f b6 99 c0 2c 11 80 	movzbl -0x7feed340(%ecx),%ebx
801040d4:	39 c3                	cmp    %eax,%ebx
801040d6:	75 e8                	jne    801040c0 <mycpu+0x20>
}
801040d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801040db:	8d 81 c0 2c 11 80    	lea    -0x7feed340(%ecx),%eax
}
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5d                   	pop    %ebp
801040e4:	c3                   	ret    
  panic("unknown apicid\n");
801040e5:	83 ec 0c             	sub    $0xc,%esp
801040e8:	68 87 7e 10 80       	push   $0x80107e87
801040ed:	e8 5e c3 ff ff       	call   80100450 <panic>
    panic("mycpu called with interrupts enabled\n");
801040f2:	83 ec 0c             	sub    $0xc,%esp
801040f5:	68 64 7f 10 80       	push   $0x80107f64
801040fa:	e8 51 c3 ff ff       	call   80100450 <panic>
801040ff:	90                   	nop

80104100 <cpuid>:
cpuid() {
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104106:	e8 95 ff ff ff       	call   801040a0 <mycpu>
}
8010410b:	c9                   	leave  
  return mycpu()-cpus;
8010410c:	2d c0 2c 11 80       	sub    $0x80112cc0,%eax
80104111:	c1 f8 04             	sar    $0x4,%eax
80104114:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010411a:	c3                   	ret    
8010411b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop

80104120 <myproc>:
myproc(void) {
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104127:	e8 d4 0a 00 00       	call   80104c00 <pushcli>
  c = mycpu();
8010412c:	e8 6f ff ff ff       	call   801040a0 <mycpu>
  p = c->proc;
80104131:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104137:	e8 14 0b 00 00       	call   80104c50 <popcli>
}
8010413c:	89 d8                	mov    %ebx,%eax
8010413e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104141:	c9                   	leave  
80104142:	c3                   	ret    
80104143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <userinit>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104157:	e8 04 fe ff ff       	call   80103f60 <allocproc>
8010415c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010415e:	a3 74 51 11 80       	mov    %eax,0x80115174
  if((p->pgdir = setupkvm()) == 0)
80104163:	e8 88 34 00 00       	call   801075f0 <setupkvm>
80104168:	89 43 04             	mov    %eax,0x4(%ebx)
8010416b:	85 c0                	test   %eax,%eax
8010416d:	0f 84 bd 00 00 00    	je     80104230 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104173:	83 ec 04             	sub    $0x4,%esp
80104176:	68 2c 00 00 00       	push   $0x2c
8010417b:	68 60 b4 10 80       	push   $0x8010b460
80104180:	50                   	push   %eax
80104181:	e8 1a 31 00 00       	call   801072a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104186:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104189:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010418f:	6a 4c                	push   $0x4c
80104191:	6a 00                	push   $0x0
80104193:	ff 73 18             	push   0x18(%ebx)
80104196:	e8 75 0c 00 00       	call   80104e10 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010419b:	8b 43 18             	mov    0x18(%ebx),%eax
8010419e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041a3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041a6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041ab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041af:	8b 43 18             	mov    0x18(%ebx),%eax
801041b2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041b6:	8b 43 18             	mov    0x18(%ebx),%eax
801041b9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041bd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801041c1:	8b 43 18             	mov    0x18(%ebx),%eax
801041c4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041c8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041cc:	8b 43 18             	mov    0x18(%ebx),%eax
801041cf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041d6:	8b 43 18             	mov    0x18(%ebx),%eax
801041d9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041e0:	8b 43 18             	mov    0x18(%ebx),%eax
801041e3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041ea:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041ed:	6a 10                	push   $0x10
801041ef:	68 b0 7e 10 80       	push   $0x80107eb0
801041f4:	50                   	push   %eax
801041f5:	e8 d6 0d 00 00       	call   80104fd0 <safestrcpy>
  p->cwd = namei("/");
801041fa:	c7 04 24 b9 7e 10 80 	movl   $0x80107eb9,(%esp)
80104201:	e8 4a e6 ff ff       	call   80102850 <namei>
80104206:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104209:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104210:	e8 3b 0b 00 00       	call   80104d50 <acquire>
  p->state = RUNNABLE;
80104215:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010421c:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104223:	e8 c8 0a 00 00       	call   80104cf0 <release>
}
80104228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010422b:	83 c4 10             	add    $0x10,%esp
8010422e:	c9                   	leave  
8010422f:	c3                   	ret    
    panic("userinit: out of memory?");
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	68 97 7e 10 80       	push   $0x80107e97
80104238:	e8 13 c2 ff ff       	call   80100450 <panic>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi

80104240 <growproc>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104248:	e8 b3 09 00 00       	call   80104c00 <pushcli>
  c = mycpu();
8010424d:	e8 4e fe ff ff       	call   801040a0 <mycpu>
  p = c->proc;
80104252:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104258:	e8 f3 09 00 00       	call   80104c50 <popcli>
  sz = curproc->sz;
8010425d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010425f:	85 f6                	test   %esi,%esi
80104261:	7f 1d                	jg     80104280 <growproc+0x40>
  } else if(n < 0){
80104263:	75 3b                	jne    801042a0 <growproc+0x60>
  switchuvm(curproc);
80104265:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104268:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010426a:	53                   	push   %ebx
8010426b:	e8 20 2f 00 00       	call   80107190 <switchuvm>
  return 0;
80104270:	83 c4 10             	add    $0x10,%esp
80104273:	31 c0                	xor    %eax,%eax
}
80104275:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104278:	5b                   	pop    %ebx
80104279:	5e                   	pop    %esi
8010427a:	5d                   	pop    %ebp
8010427b:	c3                   	ret    
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104280:	83 ec 04             	sub    $0x4,%esp
80104283:	01 c6                	add    %eax,%esi
80104285:	56                   	push   %esi
80104286:	50                   	push   %eax
80104287:	ff 73 04             	push   0x4(%ebx)
8010428a:	e8 81 31 00 00       	call   80107410 <allocuvm>
8010428f:	83 c4 10             	add    $0x10,%esp
80104292:	85 c0                	test   %eax,%eax
80104294:	75 cf                	jne    80104265 <growproc+0x25>
      return -1;
80104296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429b:	eb d8                	jmp    80104275 <growproc+0x35>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801042a0:	83 ec 04             	sub    $0x4,%esp
801042a3:	01 c6                	add    %eax,%esi
801042a5:	56                   	push   %esi
801042a6:	50                   	push   %eax
801042a7:	ff 73 04             	push   0x4(%ebx)
801042aa:	e8 91 32 00 00       	call   80107540 <deallocuvm>
801042af:	83 c4 10             	add    $0x10,%esp
801042b2:	85 c0                	test   %eax,%eax
801042b4:	75 af                	jne    80104265 <growproc+0x25>
801042b6:	eb de                	jmp    80104296 <growproc+0x56>
801042b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bf:	90                   	nop

801042c0 <fork>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	53                   	push   %ebx
801042c6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042c9:	e8 32 09 00 00       	call   80104c00 <pushcli>
  c = mycpu();
801042ce:	e8 cd fd ff ff       	call   801040a0 <mycpu>
  p = c->proc;
801042d3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d9:	e8 72 09 00 00       	call   80104c50 <popcli>
  if((np = allocproc()) == 0){
801042de:	e8 7d fc ff ff       	call   80103f60 <allocproc>
801042e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042e6:	85 c0                	test   %eax,%eax
801042e8:	0f 84 b7 00 00 00    	je     801043a5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801042ee:	83 ec 08             	sub    $0x8,%esp
801042f1:	ff 33                	push   (%ebx)
801042f3:	89 c7                	mov    %eax,%edi
801042f5:	ff 73 04             	push   0x4(%ebx)
801042f8:	e8 e3 33 00 00       	call   801076e0 <copyuvm>
801042fd:	83 c4 10             	add    $0x10,%esp
80104300:	89 47 04             	mov    %eax,0x4(%edi)
80104303:	85 c0                	test   %eax,%eax
80104305:	0f 84 a1 00 00 00    	je     801043ac <fork+0xec>
  np->sz = curproc->sz;
8010430b:	8b 03                	mov    (%ebx),%eax
8010430d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104310:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104312:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104315:	89 c8                	mov    %ecx,%eax
80104317:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010431a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010431f:	8b 73 18             	mov    0x18(%ebx),%esi
80104322:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104324:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104326:	8b 40 18             	mov    0x18(%eax),%eax
80104329:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104330:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104334:	85 c0                	test   %eax,%eax
80104336:	74 13                	je     8010434b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	50                   	push   %eax
8010433c:	e8 0f d3 ff ff       	call   80101650 <filedup>
80104341:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104344:	83 c4 10             	add    $0x10,%esp
80104347:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010434b:	83 c6 01             	add    $0x1,%esi
8010434e:	83 fe 10             	cmp    $0x10,%esi
80104351:	75 dd                	jne    80104330 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104353:	83 ec 0c             	sub    $0xc,%esp
80104356:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104359:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010435c:	e8 9f db ff ff       	call   80101f00 <idup>
80104361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104364:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104367:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010436a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010436d:	6a 10                	push   $0x10
8010436f:	53                   	push   %ebx
80104370:	50                   	push   %eax
80104371:	e8 5a 0c 00 00       	call   80104fd0 <safestrcpy>
  pid = np->pid;
80104376:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104379:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104380:	e8 cb 09 00 00       	call   80104d50 <acquire>
  np->state = RUNNABLE;
80104385:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010438c:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104393:	e8 58 09 00 00       	call   80104cf0 <release>
  return pid;
80104398:	83 c4 10             	add    $0x10,%esp
}
8010439b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010439e:	89 d8                	mov    %ebx,%eax
801043a0:	5b                   	pop    %ebx
801043a1:	5e                   	pop    %esi
801043a2:	5f                   	pop    %edi
801043a3:	5d                   	pop    %ebp
801043a4:	c3                   	ret    
    return -1;
801043a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043aa:	eb ef                	jmp    8010439b <fork+0xdb>
    kfree(np->kstack);
801043ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	ff 73 08             	push   0x8(%ebx)
801043b5:	e8 b6 e8 ff ff       	call   80102c70 <kfree>
    np->kstack = 0;
801043ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801043c1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801043c4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801043cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043d0:	eb c9                	jmp    8010439b <fork+0xdb>
801043d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <scheduler>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801043e9:	e8 b2 fc ff ff       	call   801040a0 <mycpu>
  c->proc = 0;
801043ee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043f5:	00 00 00 
  struct cpu *c = mycpu();
801043f8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801043fa:	8d 78 04             	lea    0x4(%eax),%edi
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104400:	fb                   	sti    
    acquire(&ptable.lock);
80104401:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104404:	bb 74 32 11 80       	mov    $0x80113274,%ebx
    acquire(&ptable.lock);
80104409:	68 40 32 11 80       	push   $0x80113240
8010440e:	e8 3d 09 00 00       	call   80104d50 <acquire>
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104420:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104424:	75 33                	jne    80104459 <scheduler+0x79>
      switchuvm(p);
80104426:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104429:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010442f:	53                   	push   %ebx
80104430:	e8 5b 2d 00 00       	call   80107190 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104435:	58                   	pop    %eax
80104436:	5a                   	pop    %edx
80104437:	ff 73 1c             	push   0x1c(%ebx)
8010443a:	57                   	push   %edi
      p->state = RUNNING;
8010443b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104442:	e8 e4 0b 00 00       	call   8010502b <swtch>
      switchkvm();
80104447:	e8 34 2d 00 00       	call   80107180 <switchkvm>
      c->proc = 0;
8010444c:	83 c4 10             	add    $0x10,%esp
8010444f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104456:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104459:	83 c3 7c             	add    $0x7c,%ebx
8010445c:	81 fb 74 51 11 80    	cmp    $0x80115174,%ebx
80104462:	75 bc                	jne    80104420 <scheduler+0x40>
    release(&ptable.lock);
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	68 40 32 11 80       	push   $0x80113240
8010446c:	e8 7f 08 00 00       	call   80104cf0 <release>
    sti();
80104471:	83 c4 10             	add    $0x10,%esp
80104474:	eb 8a                	jmp    80104400 <scheduler+0x20>
80104476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447d:	8d 76 00             	lea    0x0(%esi),%esi

80104480 <sched>:
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
  pushcli();
80104485:	e8 76 07 00 00       	call   80104c00 <pushcli>
  c = mycpu();
8010448a:	e8 11 fc ff ff       	call   801040a0 <mycpu>
  p = c->proc;
8010448f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104495:	e8 b6 07 00 00       	call   80104c50 <popcli>
  if(!holding(&ptable.lock))
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	68 40 32 11 80       	push   $0x80113240
801044a2:	e8 09 08 00 00       	call   80104cb0 <holding>
801044a7:	83 c4 10             	add    $0x10,%esp
801044aa:	85 c0                	test   %eax,%eax
801044ac:	74 4f                	je     801044fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801044ae:	e8 ed fb ff ff       	call   801040a0 <mycpu>
801044b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801044ba:	75 68                	jne    80104524 <sched+0xa4>
  if(p->state == RUNNING)
801044bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801044c0:	74 55                	je     80104517 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044c2:	9c                   	pushf  
801044c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044c4:	f6 c4 02             	test   $0x2,%ah
801044c7:	75 41                	jne    8010450a <sched+0x8a>
  intena = mycpu()->intena;
801044c9:	e8 d2 fb ff ff       	call   801040a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801044ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801044d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801044d7:	e8 c4 fb ff ff       	call   801040a0 <mycpu>
801044dc:	83 ec 08             	sub    $0x8,%esp
801044df:	ff 70 04             	push   0x4(%eax)
801044e2:	53                   	push   %ebx
801044e3:	e8 43 0b 00 00       	call   8010502b <swtch>
  mycpu()->intena = intena;
801044e8:	e8 b3 fb ff ff       	call   801040a0 <mycpu>
}
801044ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801044f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801044f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044f9:	5b                   	pop    %ebx
801044fa:	5e                   	pop    %esi
801044fb:	5d                   	pop    %ebp
801044fc:	c3                   	ret    
    panic("sched ptable.lock");
801044fd:	83 ec 0c             	sub    $0xc,%esp
80104500:	68 bb 7e 10 80       	push   $0x80107ebb
80104505:	e8 46 bf ff ff       	call   80100450 <panic>
    panic("sched interruptible");
8010450a:	83 ec 0c             	sub    $0xc,%esp
8010450d:	68 e7 7e 10 80       	push   $0x80107ee7
80104512:	e8 39 bf ff ff       	call   80100450 <panic>
    panic("sched running");
80104517:	83 ec 0c             	sub    $0xc,%esp
8010451a:	68 d9 7e 10 80       	push   $0x80107ed9
8010451f:	e8 2c bf ff ff       	call   80100450 <panic>
    panic("sched locks");
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	68 cd 7e 10 80       	push   $0x80107ecd
8010452c:	e8 1f bf ff ff       	call   80100450 <panic>
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop

80104540 <exit>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104549:	e8 d2 fb ff ff       	call   80104120 <myproc>
  if(curproc == initproc)
8010454e:	39 05 74 51 11 80    	cmp    %eax,0x80115174
80104554:	0f 84 fd 00 00 00    	je     80104657 <exit+0x117>
8010455a:	89 c3                	mov    %eax,%ebx
8010455c:	8d 70 28             	lea    0x28(%eax),%esi
8010455f:	8d 78 68             	lea    0x68(%eax),%edi
80104562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104568:	8b 06                	mov    (%esi),%eax
8010456a:	85 c0                	test   %eax,%eax
8010456c:	74 12                	je     80104580 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010456e:	83 ec 0c             	sub    $0xc,%esp
80104571:	50                   	push   %eax
80104572:	e8 29 d1 ff ff       	call   801016a0 <fileclose>
      curproc->ofile[fd] = 0;
80104577:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010457d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104580:	83 c6 04             	add    $0x4,%esi
80104583:	39 f7                	cmp    %esi,%edi
80104585:	75 e1                	jne    80104568 <exit+0x28>
  begin_op();
80104587:	e8 84 ef ff ff       	call   80103510 <begin_op>
  iput(curproc->cwd);
8010458c:	83 ec 0c             	sub    $0xc,%esp
8010458f:	ff 73 68             	push   0x68(%ebx)
80104592:	e8 c9 da ff ff       	call   80102060 <iput>
  end_op();
80104597:	e8 e4 ef ff ff       	call   80103580 <end_op>
  curproc->cwd = 0;
8010459c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801045a3:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801045aa:	e8 a1 07 00 00       	call   80104d50 <acquire>
  wakeup1(curproc->parent);
801045af:	8b 53 14             	mov    0x14(%ebx),%edx
801045b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045b5:	b8 74 32 11 80       	mov    $0x80113274,%eax
801045ba:	eb 0e                	jmp    801045ca <exit+0x8a>
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c0:	83 c0 7c             	add    $0x7c,%eax
801045c3:	3d 74 51 11 80       	cmp    $0x80115174,%eax
801045c8:	74 1c                	je     801045e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801045ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ce:	75 f0                	jne    801045c0 <exit+0x80>
801045d0:	3b 50 20             	cmp    0x20(%eax),%edx
801045d3:	75 eb                	jne    801045c0 <exit+0x80>
      p->state = RUNNABLE;
801045d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045dc:	83 c0 7c             	add    $0x7c,%eax
801045df:	3d 74 51 11 80       	cmp    $0x80115174,%eax
801045e4:	75 e4                	jne    801045ca <exit+0x8a>
      p->parent = initproc;
801045e6:	8b 0d 74 51 11 80    	mov    0x80115174,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ec:	ba 74 32 11 80       	mov    $0x80113274,%edx
801045f1:	eb 10                	jmp    80104603 <exit+0xc3>
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
801045f8:	83 c2 7c             	add    $0x7c,%edx
801045fb:	81 fa 74 51 11 80    	cmp    $0x80115174,%edx
80104601:	74 3b                	je     8010463e <exit+0xfe>
    if(p->parent == curproc){
80104603:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104606:	75 f0                	jne    801045f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80104608:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010460c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010460f:	75 e7                	jne    801045f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104611:	b8 74 32 11 80       	mov    $0x80113274,%eax
80104616:	eb 12                	jmp    8010462a <exit+0xea>
80104618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
80104620:	83 c0 7c             	add    $0x7c,%eax
80104623:	3d 74 51 11 80       	cmp    $0x80115174,%eax
80104628:	74 ce                	je     801045f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010462a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010462e:	75 f0                	jne    80104620 <exit+0xe0>
80104630:	3b 48 20             	cmp    0x20(%eax),%ecx
80104633:	75 eb                	jne    80104620 <exit+0xe0>
      p->state = RUNNABLE;
80104635:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010463c:	eb e2                	jmp    80104620 <exit+0xe0>
  curproc->state = ZOMBIE;
8010463e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104645:	e8 36 fe ff ff       	call   80104480 <sched>
  panic("zombie exit");
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 08 7f 10 80       	push   $0x80107f08
80104652:	e8 f9 bd ff ff       	call   80100450 <panic>
    panic("init exiting");
80104657:	83 ec 0c             	sub    $0xc,%esp
8010465a:	68 fb 7e 10 80       	push   $0x80107efb
8010465f:	e8 ec bd ff ff       	call   80100450 <panic>
80104664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <wait>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
  pushcli();
80104675:	e8 86 05 00 00       	call   80104c00 <pushcli>
  c = mycpu();
8010467a:	e8 21 fa ff ff       	call   801040a0 <mycpu>
  p = c->proc;
8010467f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104685:	e8 c6 05 00 00       	call   80104c50 <popcli>
  acquire(&ptable.lock);
8010468a:	83 ec 0c             	sub    $0xc,%esp
8010468d:	68 40 32 11 80       	push   $0x80113240
80104692:	e8 b9 06 00 00       	call   80104d50 <acquire>
80104697:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010469a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469c:	bb 74 32 11 80       	mov    $0x80113274,%ebx
801046a1:	eb 10                	jmp    801046b3 <wait+0x43>
801046a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a7:	90                   	nop
801046a8:	83 c3 7c             	add    $0x7c,%ebx
801046ab:	81 fb 74 51 11 80    	cmp    $0x80115174,%ebx
801046b1:	74 1b                	je     801046ce <wait+0x5e>
      if(p->parent != curproc)
801046b3:	39 73 14             	cmp    %esi,0x14(%ebx)
801046b6:	75 f0                	jne    801046a8 <wait+0x38>
      if(p->state == ZOMBIE){
801046b8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801046bc:	74 62                	je     80104720 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046be:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801046c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c6:	81 fb 74 51 11 80    	cmp    $0x80115174,%ebx
801046cc:	75 e5                	jne    801046b3 <wait+0x43>
    if(!havekids || curproc->killed){
801046ce:	85 c0                	test   %eax,%eax
801046d0:	0f 84 a0 00 00 00    	je     80104776 <wait+0x106>
801046d6:	8b 46 24             	mov    0x24(%esi),%eax
801046d9:	85 c0                	test   %eax,%eax
801046db:	0f 85 95 00 00 00    	jne    80104776 <wait+0x106>
  pushcli();
801046e1:	e8 1a 05 00 00       	call   80104c00 <pushcli>
  c = mycpu();
801046e6:	e8 b5 f9 ff ff       	call   801040a0 <mycpu>
  p = c->proc;
801046eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046f1:	e8 5a 05 00 00       	call   80104c50 <popcli>
  if(p == 0)
801046f6:	85 db                	test   %ebx,%ebx
801046f8:	0f 84 8f 00 00 00    	je     8010478d <wait+0x11d>
  p->chan = chan;
801046fe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104701:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104708:	e8 73 fd ff ff       	call   80104480 <sched>
  p->chan = 0;
8010470d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104714:	eb 84                	jmp    8010469a <wait+0x2a>
80104716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104720:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104723:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104726:	ff 73 08             	push   0x8(%ebx)
80104729:	e8 42 e5 ff ff       	call   80102c70 <kfree>
        p->kstack = 0;
8010472e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104735:	5a                   	pop    %edx
80104736:	ff 73 04             	push   0x4(%ebx)
80104739:	e8 32 2e 00 00       	call   80107570 <freevm>
        p->pid = 0;
8010473e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104745:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010474c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104750:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104757:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010475e:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104765:	e8 86 05 00 00       	call   80104cf0 <release>
        return pid;
8010476a:	83 c4 10             	add    $0x10,%esp
}
8010476d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104770:	89 f0                	mov    %esi,%eax
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret    
      release(&ptable.lock);
80104776:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104779:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010477e:	68 40 32 11 80       	push   $0x80113240
80104783:	e8 68 05 00 00       	call   80104cf0 <release>
      return -1;
80104788:	83 c4 10             	add    $0x10,%esp
8010478b:	eb e0                	jmp    8010476d <wait+0xfd>
    panic("sleep");
8010478d:	83 ec 0c             	sub    $0xc,%esp
80104790:	68 14 7f 10 80       	push   $0x80107f14
80104795:	e8 b6 bc ff ff       	call   80100450 <panic>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <yield>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047a7:	68 40 32 11 80       	push   $0x80113240
801047ac:	e8 9f 05 00 00       	call   80104d50 <acquire>
  pushcli();
801047b1:	e8 4a 04 00 00       	call   80104c00 <pushcli>
  c = mycpu();
801047b6:	e8 e5 f8 ff ff       	call   801040a0 <mycpu>
  p = c->proc;
801047bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047c1:	e8 8a 04 00 00       	call   80104c50 <popcli>
  myproc()->state = RUNNABLE;
801047c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801047cd:	e8 ae fc ff ff       	call   80104480 <sched>
  release(&ptable.lock);
801047d2:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801047d9:	e8 12 05 00 00       	call   80104cf0 <release>
}
801047de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e1:	83 c4 10             	add    $0x10,%esp
801047e4:	c9                   	leave  
801047e5:	c3                   	ret    
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <sleep>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	56                   	push   %esi
801047f5:	53                   	push   %ebx
801047f6:	83 ec 0c             	sub    $0xc,%esp
801047f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801047fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047ff:	e8 fc 03 00 00       	call   80104c00 <pushcli>
  c = mycpu();
80104804:	e8 97 f8 ff ff       	call   801040a0 <mycpu>
  p = c->proc;
80104809:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010480f:	e8 3c 04 00 00       	call   80104c50 <popcli>
  if(p == 0)
80104814:	85 db                	test   %ebx,%ebx
80104816:	0f 84 87 00 00 00    	je     801048a3 <sleep+0xb3>
  if(lk == 0)
8010481c:	85 f6                	test   %esi,%esi
8010481e:	74 76                	je     80104896 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104820:	81 fe 40 32 11 80    	cmp    $0x80113240,%esi
80104826:	74 50                	je     80104878 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 40 32 11 80       	push   $0x80113240
80104830:	e8 1b 05 00 00       	call   80104d50 <acquire>
    release(lk);
80104835:	89 34 24             	mov    %esi,(%esp)
80104838:	e8 b3 04 00 00       	call   80104cf0 <release>
  p->chan = chan;
8010483d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104840:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104847:	e8 34 fc ff ff       	call   80104480 <sched>
  p->chan = 0;
8010484c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104853:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
8010485a:	e8 91 04 00 00       	call   80104cf0 <release>
    acquire(lk);
8010485f:	89 75 08             	mov    %esi,0x8(%ebp)
80104862:	83 c4 10             	add    $0x10,%esp
}
80104865:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104868:	5b                   	pop    %ebx
80104869:	5e                   	pop    %esi
8010486a:	5f                   	pop    %edi
8010486b:	5d                   	pop    %ebp
    acquire(lk);
8010486c:	e9 df 04 00 00       	jmp    80104d50 <acquire>
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104878:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010487b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104882:	e8 f9 fb ff ff       	call   80104480 <sched>
  p->chan = 0;
80104887:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010488e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104891:	5b                   	pop    %ebx
80104892:	5e                   	pop    %esi
80104893:	5f                   	pop    %edi
80104894:	5d                   	pop    %ebp
80104895:	c3                   	ret    
    panic("sleep without lk");
80104896:	83 ec 0c             	sub    $0xc,%esp
80104899:	68 1a 7f 10 80       	push   $0x80107f1a
8010489e:	e8 ad bb ff ff       	call   80100450 <panic>
    panic("sleep");
801048a3:	83 ec 0c             	sub    $0xc,%esp
801048a6:	68 14 7f 10 80       	push   $0x80107f14
801048ab:	e8 a0 bb ff ff       	call   80100450 <panic>

801048b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 10             	sub    $0x10,%esp
801048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048ba:	68 40 32 11 80       	push   $0x80113240
801048bf:	e8 8c 04 00 00       	call   80104d50 <acquire>
801048c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048c7:	b8 74 32 11 80       	mov    $0x80113274,%eax
801048cc:	eb 0c                	jmp    801048da <wakeup+0x2a>
801048ce:	66 90                	xchg   %ax,%ax
801048d0:	83 c0 7c             	add    $0x7c,%eax
801048d3:	3d 74 51 11 80       	cmp    $0x80115174,%eax
801048d8:	74 1c                	je     801048f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801048da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048de:	75 f0                	jne    801048d0 <wakeup+0x20>
801048e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801048e3:	75 eb                	jne    801048d0 <wakeup+0x20>
      p->state = RUNNABLE;
801048e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048ec:	83 c0 7c             	add    $0x7c,%eax
801048ef:	3d 74 51 11 80       	cmp    $0x80115174,%eax
801048f4:	75 e4                	jne    801048da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801048f6:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
801048fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104900:	c9                   	leave  
  release(&ptable.lock);
80104901:	e9 ea 03 00 00       	jmp    80104cf0 <release>
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 10             	sub    $0x10,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010491a:	68 40 32 11 80       	push   $0x80113240
8010491f:	e8 2c 04 00 00       	call   80104d50 <acquire>
80104924:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104927:	b8 74 32 11 80       	mov    $0x80113274,%eax
8010492c:	eb 0c                	jmp    8010493a <kill+0x2a>
8010492e:	66 90                	xchg   %ax,%ax
80104930:	83 c0 7c             	add    $0x7c,%eax
80104933:	3d 74 51 11 80       	cmp    $0x80115174,%eax
80104938:	74 36                	je     80104970 <kill+0x60>
    if(p->pid == pid){
8010493a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010493d:	75 f1                	jne    80104930 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010493f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104943:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010494a:	75 07                	jne    80104953 <kill+0x43>
        p->state = RUNNABLE;
8010494c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	68 40 32 11 80       	push   $0x80113240
8010495b:	e8 90 03 00 00       	call   80104cf0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104963:	83 c4 10             	add    $0x10,%esp
80104966:	31 c0                	xor    %eax,%eax
}
80104968:	c9                   	leave  
80104969:	c3                   	ret    
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	68 40 32 11 80       	push   $0x80113240
80104978:	e8 73 03 00 00       	call   80104cf0 <release>
}
8010497d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104980:	83 c4 10             	add    $0x10,%esp
80104983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104988:	c9                   	leave  
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104998:	53                   	push   %ebx
80104999:	bb e0 32 11 80       	mov    $0x801132e0,%ebx
8010499e:	83 ec 3c             	sub    $0x3c,%esp
801049a1:	eb 24                	jmp    801049c7 <procdump+0x37>
801049a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	68 97 82 10 80       	push   $0x80108297
801049b0:	e8 cb be ff ff       	call   80100880 <cprintf>
801049b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b8:	83 c3 7c             	add    $0x7c,%ebx
801049bb:	81 fb e0 51 11 80    	cmp    $0x801151e0,%ebx
801049c1:	0f 84 81 00 00 00    	je     80104a48 <procdump+0xb8>
    if(p->state == UNUSED)
801049c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049ca:	85 c0                	test   %eax,%eax
801049cc:	74 ea                	je     801049b8 <procdump+0x28>
      state = "???";
801049ce:	ba 2b 7f 10 80       	mov    $0x80107f2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801049d3:	83 f8 05             	cmp    $0x5,%eax
801049d6:	77 11                	ja     801049e9 <procdump+0x59>
801049d8:	8b 14 85 8c 7f 10 80 	mov    -0x7fef8074(,%eax,4),%edx
      state = "???";
801049df:	b8 2b 7f 10 80       	mov    $0x80107f2b,%eax
801049e4:	85 d2                	test   %edx,%edx
801049e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801049e9:	53                   	push   %ebx
801049ea:	52                   	push   %edx
801049eb:	ff 73 a4             	push   -0x5c(%ebx)
801049ee:	68 2f 7f 10 80       	push   $0x80107f2f
801049f3:	e8 88 be ff ff       	call   80100880 <cprintf>
    if(p->state == SLEEPING){
801049f8:	83 c4 10             	add    $0x10,%esp
801049fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801049ff:	75 a7                	jne    801049a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a01:	83 ec 08             	sub    $0x8,%esp
80104a04:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a07:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a0a:	50                   	push   %eax
80104a0b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104a11:	83 c0 08             	add    $0x8,%eax
80104a14:	50                   	push   %eax
80104a15:	e8 86 01 00 00       	call   80104ba0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a1a:	83 c4 10             	add    $0x10,%esp
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	8b 17                	mov    (%edi),%edx
80104a22:	85 d2                	test   %edx,%edx
80104a24:	74 82                	je     801049a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104a26:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104a29:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104a2c:	52                   	push   %edx
80104a2d:	68 81 79 10 80       	push   $0x80107981
80104a32:	e8 49 be ff ff       	call   80100880 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a37:	83 c4 10             	add    $0x10,%esp
80104a3a:	39 fe                	cmp    %edi,%esi
80104a3c:	75 e2                	jne    80104a20 <procdump+0x90>
80104a3e:	e9 65 ff ff ff       	jmp    801049a8 <procdump+0x18>
80104a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a47:	90                   	nop
  }
}
80104a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a4b:	5b                   	pop    %ebx
80104a4c:	5e                   	pop    %esi
80104a4d:	5f                   	pop    %edi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 0c             	sub    $0xc,%esp
80104a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a5a:	68 a4 7f 10 80       	push   $0x80107fa4
80104a5f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a62:	50                   	push   %eax
80104a63:	e8 18 01 00 00       	call   80104b80 <initlock>
  lk->name = name;
80104a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a6b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a71:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a74:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a7b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a81:	c9                   	leave  
80104a82:	c3                   	ret    
80104a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a98:	8d 73 04             	lea    0x4(%ebx),%esi
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	56                   	push   %esi
80104a9f:	e8 ac 02 00 00       	call   80104d50 <acquire>
  while (lk->locked) {
80104aa4:	8b 13                	mov    (%ebx),%edx
80104aa6:	83 c4 10             	add    $0x10,%esp
80104aa9:	85 d2                	test   %edx,%edx
80104aab:	74 16                	je     80104ac3 <acquiresleep+0x33>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ab0:	83 ec 08             	sub    $0x8,%esp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	e8 36 fd ff ff       	call   801047f0 <sleep>
  while (lk->locked) {
80104aba:	8b 03                	mov    (%ebx),%eax
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	75 ed                	jne    80104ab0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ac3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ac9:	e8 52 f6 ff ff       	call   80104120 <myproc>
80104ace:	8b 40 10             	mov    0x10(%eax),%eax
80104ad1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ad4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ada:	5b                   	pop    %ebx
80104adb:	5e                   	pop    %esi
80104adc:	5d                   	pop    %ebp
  release(&lk->lk);
80104add:	e9 0e 02 00 00       	jmp    80104cf0 <release>
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104af0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104af8:	8d 73 04             	lea    0x4(%ebx),%esi
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	56                   	push   %esi
80104aff:	e8 4c 02 00 00       	call   80104d50 <acquire>
  lk->locked = 0;
80104b04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b0a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b11:	89 1c 24             	mov    %ebx,(%esp)
80104b14:	e8 97 fd ff ff       	call   801048b0 <wakeup>
  release(&lk->lk);
80104b19:	89 75 08             	mov    %esi,0x8(%ebp)
80104b1c:	83 c4 10             	add    $0x10,%esp
}
80104b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b22:	5b                   	pop    %ebx
80104b23:	5e                   	pop    %esi
80104b24:	5d                   	pop    %ebp
  release(&lk->lk);
80104b25:	e9 c6 01 00 00       	jmp    80104cf0 <release>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	31 ff                	xor    %edi,%edi
80104b36:	56                   	push   %esi
80104b37:	53                   	push   %ebx
80104b38:	83 ec 18             	sub    $0x18,%esp
80104b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b3e:	8d 73 04             	lea    0x4(%ebx),%esi
80104b41:	56                   	push   %esi
80104b42:	e8 09 02 00 00       	call   80104d50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b47:	8b 03                	mov    (%ebx),%eax
80104b49:	83 c4 10             	add    $0x10,%esp
80104b4c:	85 c0                	test   %eax,%eax
80104b4e:	75 18                	jne    80104b68 <holdingsleep+0x38>
  release(&lk->lk);
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	56                   	push   %esi
80104b54:	e8 97 01 00 00       	call   80104cf0 <release>
  return r;
}
80104b59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b5c:	89 f8                	mov    %edi,%eax
80104b5e:	5b                   	pop    %ebx
80104b5f:	5e                   	pop    %esi
80104b60:	5f                   	pop    %edi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b67:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104b68:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b6b:	e8 b0 f5 ff ff       	call   80104120 <myproc>
80104b70:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b73:	0f 94 c0             	sete   %al
80104b76:	0f b6 c0             	movzbl %al,%eax
80104b79:	89 c7                	mov    %eax,%edi
80104b7b:	eb d3                	jmp    80104b50 <holdingsleep+0x20>
80104b7d:	66 90                	xchg   %ax,%ax
80104b7f:	90                   	nop

80104b80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop

80104ba0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ba0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ba1:	31 d2                	xor    %edx,%edx
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ba6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ba9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104baf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bb0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bb6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bbc:	77 1a                	ja     80104bd8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bbe:	8b 58 04             	mov    0x4(%eax),%ebx
80104bc1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bc4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bc7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bc9:	83 fa 0a             	cmp    $0xa,%edx
80104bcc:	75 e2                	jne    80104bb0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd1:	c9                   	leave  
80104bd2:	c3                   	ret    
80104bd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd7:	90                   	nop
  for(; i < 10; i++)
80104bd8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104bdb:	8d 51 28             	lea    0x28(%ecx),%edx
80104bde:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104be6:	83 c0 04             	add    $0x4,%eax
80104be9:	39 d0                	cmp    %edx,%eax
80104beb:	75 f3                	jne    80104be0 <getcallerpcs+0x40>
}
80104bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf0:	c9                   	leave  
80104bf1:	c3                   	ret    
80104bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c00 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	9c                   	pushf  
80104c08:	5b                   	pop    %ebx
  asm volatile("cli");
80104c09:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c0a:	e8 91 f4 ff ff       	call   801040a0 <mycpu>
80104c0f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c15:	85 c0                	test   %eax,%eax
80104c17:	74 17                	je     80104c30 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c19:	e8 82 f4 ff ff       	call   801040a0 <mycpu>
80104c1e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c28:	c9                   	leave  
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104c30:	e8 6b f4 ff ff       	call   801040a0 <mycpu>
80104c35:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c3b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c41:	eb d6                	jmp    80104c19 <pushcli+0x19>
80104c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c50 <popcli>:

void
popcli(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c56:	9c                   	pushf  
80104c57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c58:	f6 c4 02             	test   $0x2,%ah
80104c5b:	75 35                	jne    80104c92 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c5d:	e8 3e f4 ff ff       	call   801040a0 <mycpu>
80104c62:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c69:	78 34                	js     80104c9f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c6b:	e8 30 f4 ff ff       	call   801040a0 <mycpu>
80104c70:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c76:	85 d2                	test   %edx,%edx
80104c78:	74 06                	je     80104c80 <popcli+0x30>
    sti();
}
80104c7a:	c9                   	leave  
80104c7b:	c3                   	ret    
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c80:	e8 1b f4 ff ff       	call   801040a0 <mycpu>
80104c85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c8b:	85 c0                	test   %eax,%eax
80104c8d:	74 eb                	je     80104c7a <popcli+0x2a>
  asm volatile("sti");
80104c8f:	fb                   	sti    
}
80104c90:	c9                   	leave  
80104c91:	c3                   	ret    
    panic("popcli - interruptible");
80104c92:	83 ec 0c             	sub    $0xc,%esp
80104c95:	68 af 7f 10 80       	push   $0x80107faf
80104c9a:	e8 b1 b7 ff ff       	call   80100450 <panic>
    panic("popcli");
80104c9f:	83 ec 0c             	sub    $0xc,%esp
80104ca2:	68 c6 7f 10 80       	push   $0x80107fc6
80104ca7:	e8 a4 b7 ff ff       	call   80100450 <panic>
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <holding>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
80104cb5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cb8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104cba:	e8 41 ff ff ff       	call   80104c00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cbf:	8b 06                	mov    (%esi),%eax
80104cc1:	85 c0                	test   %eax,%eax
80104cc3:	75 0b                	jne    80104cd0 <holding+0x20>
  popcli();
80104cc5:	e8 86 ff ff ff       	call   80104c50 <popcli>
}
80104cca:	89 d8                	mov    %ebx,%eax
80104ccc:	5b                   	pop    %ebx
80104ccd:	5e                   	pop    %esi
80104cce:	5d                   	pop    %ebp
80104ccf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104cd0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104cd3:	e8 c8 f3 ff ff       	call   801040a0 <mycpu>
80104cd8:	39 c3                	cmp    %eax,%ebx
80104cda:	0f 94 c3             	sete   %bl
  popcli();
80104cdd:	e8 6e ff ff ff       	call   80104c50 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104ce2:	0f b6 db             	movzbl %bl,%ebx
}
80104ce5:	89 d8                	mov    %ebx,%eax
80104ce7:	5b                   	pop    %ebx
80104ce8:	5e                   	pop    %esi
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cef:	90                   	nop

80104cf0 <release>:
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
80104cf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104cf8:	e8 03 ff ff ff       	call   80104c00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cfd:	8b 03                	mov    (%ebx),%eax
80104cff:	85 c0                	test   %eax,%eax
80104d01:	75 15                	jne    80104d18 <release+0x28>
  popcli();
80104d03:	e8 48 ff ff ff       	call   80104c50 <popcli>
    panic("release");
80104d08:	83 ec 0c             	sub    $0xc,%esp
80104d0b:	68 cd 7f 10 80       	push   $0x80107fcd
80104d10:	e8 3b b7 ff ff       	call   80100450 <panic>
80104d15:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d18:	8b 73 08             	mov    0x8(%ebx),%esi
80104d1b:	e8 80 f3 ff ff       	call   801040a0 <mycpu>
80104d20:	39 c6                	cmp    %eax,%esi
80104d22:	75 df                	jne    80104d03 <release+0x13>
  popcli();
80104d24:	e8 27 ff ff ff       	call   80104c50 <popcli>
  lk->pcs[0] = 0;
80104d29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d30:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d37:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d3c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d45:	5b                   	pop    %ebx
80104d46:	5e                   	pop    %esi
80104d47:	5d                   	pop    %ebp
  popcli();
80104d48:	e9 03 ff ff ff       	jmp    80104c50 <popcli>
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi

80104d50 <acquire>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d57:	e8 a4 fe ff ff       	call   80104c00 <pushcli>
  if(holding(lk))
80104d5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d5f:	e8 9c fe ff ff       	call   80104c00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d64:	8b 03                	mov    (%ebx),%eax
80104d66:	85 c0                	test   %eax,%eax
80104d68:	75 7e                	jne    80104de8 <acquire+0x98>
  popcli();
80104d6a:	e8 e1 fe ff ff       	call   80104c50 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104d6f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104d78:	8b 55 08             	mov    0x8(%ebp),%edx
80104d7b:	89 c8                	mov    %ecx,%eax
80104d7d:	f0 87 02             	lock xchg %eax,(%edx)
80104d80:	85 c0                	test   %eax,%eax
80104d82:	75 f4                	jne    80104d78 <acquire+0x28>
  __sync_synchronize();
80104d84:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d8c:	e8 0f f3 ff ff       	call   801040a0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d94:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104d96:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104d99:	31 c0                	xor    %eax,%eax
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104da0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104da6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104dac:	77 1a                	ja     80104dc8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104dae:	8b 5a 04             	mov    0x4(%edx),%ebx
80104db1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104db5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104db8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104dba:	83 f8 0a             	cmp    $0xa,%eax
80104dbd:	75 e1                	jne    80104da0 <acquire+0x50>
}
80104dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc2:	c9                   	leave  
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104dc8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104dcc:	8d 51 34             	lea    0x34(%ecx),%edx
80104dcf:	90                   	nop
    pcs[i] = 0;
80104dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104dd6:	83 c0 04             	add    $0x4,%eax
80104dd9:	39 c2                	cmp    %eax,%edx
80104ddb:	75 f3                	jne    80104dd0 <acquire+0x80>
}
80104ddd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de0:	c9                   	leave  
80104de1:	c3                   	ret    
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104de8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104deb:	e8 b0 f2 ff ff       	call   801040a0 <mycpu>
80104df0:	39 c3                	cmp    %eax,%ebx
80104df2:	0f 85 72 ff ff ff    	jne    80104d6a <acquire+0x1a>
  popcli();
80104df8:	e8 53 fe ff ff       	call   80104c50 <popcli>
    panic("acquire");
80104dfd:	83 ec 0c             	sub    $0xc,%esp
80104e00:	68 d5 7f 10 80       	push   $0x80107fd5
80104e05:	e8 46 b6 ff ff       	call   80100450 <panic>
80104e0a:	66 90                	xchg   %ax,%ax
80104e0c:	66 90                	xchg   %ax,%ax
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	8b 55 08             	mov    0x8(%ebp),%edx
80104e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e1a:	53                   	push   %ebx
80104e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e1e:	89 d7                	mov    %edx,%edi
80104e20:	09 cf                	or     %ecx,%edi
80104e22:	83 e7 03             	and    $0x3,%edi
80104e25:	75 29                	jne    80104e50 <memset+0x40>
    c &= 0xFF;
80104e27:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e2a:	c1 e0 18             	shl    $0x18,%eax
80104e2d:	89 fb                	mov    %edi,%ebx
80104e2f:	c1 e9 02             	shr    $0x2,%ecx
80104e32:	c1 e3 10             	shl    $0x10,%ebx
80104e35:	09 d8                	or     %ebx,%eax
80104e37:	09 f8                	or     %edi,%eax
80104e39:	c1 e7 08             	shl    $0x8,%edi
80104e3c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e3e:	89 d7                	mov    %edx,%edi
80104e40:	fc                   	cld    
80104e41:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e43:	5b                   	pop    %ebx
80104e44:	89 d0                	mov    %edx,%eax
80104e46:	5f                   	pop    %edi
80104e47:	5d                   	pop    %ebp
80104e48:	c3                   	ret    
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104e50:	89 d7                	mov    %edx,%edi
80104e52:	fc                   	cld    
80104e53:	f3 aa                	rep stos %al,%es:(%edi)
80104e55:	5b                   	pop    %ebx
80104e56:	89 d0                	mov    %edx,%eax
80104e58:	5f                   	pop    %edi
80104e59:	5d                   	pop    %ebp
80104e5a:	c3                   	ret    
80104e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop

80104e60 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	8b 75 10             	mov    0x10(%ebp),%esi
80104e67:	8b 55 08             	mov    0x8(%ebp),%edx
80104e6a:	53                   	push   %ebx
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e6e:	85 f6                	test   %esi,%esi
80104e70:	74 2e                	je     80104ea0 <memcmp+0x40>
80104e72:	01 c6                	add    %eax,%esi
80104e74:	eb 14                	jmp    80104e8a <memcmp+0x2a>
80104e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e80:	83 c0 01             	add    $0x1,%eax
80104e83:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e86:	39 f0                	cmp    %esi,%eax
80104e88:	74 16                	je     80104ea0 <memcmp+0x40>
    if(*s1 != *s2)
80104e8a:	0f b6 0a             	movzbl (%edx),%ecx
80104e8d:	0f b6 18             	movzbl (%eax),%ebx
80104e90:	38 d9                	cmp    %bl,%cl
80104e92:	74 ec                	je     80104e80 <memcmp+0x20>
      return *s1 - *s2;
80104e94:	0f b6 c1             	movzbl %cl,%eax
80104e97:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104e99:	5b                   	pop    %ebx
80104e9a:	5e                   	pop    %esi
80104e9b:	5d                   	pop    %ebp
80104e9c:	c3                   	ret    
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ea0:	5b                   	pop    %ebx
  return 0;
80104ea1:	31 c0                	xor    %eax,%eax
}
80104ea3:	5e                   	pop    %esi
80104ea4:	5d                   	pop    %ebp
80104ea5:	c3                   	ret    
80104ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ead:	8d 76 00             	lea    0x0(%esi),%esi

80104eb0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	8b 55 08             	mov    0x8(%ebp),%edx
80104eb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eba:	56                   	push   %esi
80104ebb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ebe:	39 d6                	cmp    %edx,%esi
80104ec0:	73 26                	jae    80104ee8 <memmove+0x38>
80104ec2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ec5:	39 fa                	cmp    %edi,%edx
80104ec7:	73 1f                	jae    80104ee8 <memmove+0x38>
80104ec9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104ecc:	85 c9                	test   %ecx,%ecx
80104ece:	74 0c                	je     80104edc <memmove+0x2c>
      *--d = *--s;
80104ed0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ed4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104ed7:	83 e8 01             	sub    $0x1,%eax
80104eda:	73 f4                	jae    80104ed0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104edc:	5e                   	pop    %esi
80104edd:	89 d0                	mov    %edx,%eax
80104edf:	5f                   	pop    %edi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ee8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104eeb:	89 d7                	mov    %edx,%edi
80104eed:	85 c9                	test   %ecx,%ecx
80104eef:	74 eb                	je     80104edc <memmove+0x2c>
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ef8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ef9:	39 c6                	cmp    %eax,%esi
80104efb:	75 fb                	jne    80104ef8 <memmove+0x48>
}
80104efd:	5e                   	pop    %esi
80104efe:	89 d0                	mov    %edx,%eax
80104f00:	5f                   	pop    %edi
80104f01:	5d                   	pop    %ebp
80104f02:	c3                   	ret    
80104f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104f10:	eb 9e                	jmp    80104eb0 <memmove>
80104f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	8b 75 10             	mov    0x10(%ebp),%esi
80104f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f2a:	53                   	push   %ebx
80104f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104f2e:	85 f6                	test   %esi,%esi
80104f30:	74 2e                	je     80104f60 <strncmp+0x40>
80104f32:	01 d6                	add    %edx,%esi
80104f34:	eb 18                	jmp    80104f4e <strncmp+0x2e>
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
80104f40:	38 d8                	cmp    %bl,%al
80104f42:	75 14                	jne    80104f58 <strncmp+0x38>
    n--, p++, q++;
80104f44:	83 c2 01             	add    $0x1,%edx
80104f47:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f4a:	39 f2                	cmp    %esi,%edx
80104f4c:	74 12                	je     80104f60 <strncmp+0x40>
80104f4e:	0f b6 01             	movzbl (%ecx),%eax
80104f51:	0f b6 1a             	movzbl (%edx),%ebx
80104f54:	84 c0                	test   %al,%al
80104f56:	75 e8                	jne    80104f40 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f58:	29 d8                	sub    %ebx,%eax
}
80104f5a:	5b                   	pop    %ebx
80104f5b:	5e                   	pop    %esi
80104f5c:	5d                   	pop    %ebp
80104f5d:	c3                   	ret    
80104f5e:	66 90                	xchg   %ax,%ax
80104f60:	5b                   	pop    %ebx
    return 0;
80104f61:	31 c0                	xor    %eax,%eax
}
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi

80104f70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
80104f75:	8b 75 08             	mov    0x8(%ebp),%esi
80104f78:	53                   	push   %ebx
80104f79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f7c:	89 f0                	mov    %esi,%eax
80104f7e:	eb 15                	jmp    80104f95 <strncpy+0x25>
80104f80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f84:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f87:	83 c0 01             	add    $0x1,%eax
80104f8a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104f8e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104f91:	84 d2                	test   %dl,%dl
80104f93:	74 09                	je     80104f9e <strncpy+0x2e>
80104f95:	89 cb                	mov    %ecx,%ebx
80104f97:	83 e9 01             	sub    $0x1,%ecx
80104f9a:	85 db                	test   %ebx,%ebx
80104f9c:	7f e2                	jg     80104f80 <strncpy+0x10>
    ;
  while(n-- > 0)
80104f9e:	89 c2                	mov    %eax,%edx
80104fa0:	85 c9                	test   %ecx,%ecx
80104fa2:	7e 17                	jle    80104fbb <strncpy+0x4b>
80104fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104fa8:	83 c2 01             	add    $0x1,%edx
80104fab:	89 c1                	mov    %eax,%ecx
80104fad:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104fb1:	29 d1                	sub    %edx,%ecx
80104fb3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104fb7:	85 c9                	test   %ecx,%ecx
80104fb9:	7f ed                	jg     80104fa8 <strncpy+0x38>
  return os;
}
80104fbb:	5b                   	pop    %ebx
80104fbc:	89 f0                	mov    %esi,%eax
80104fbe:	5e                   	pop    %esi
80104fbf:	5f                   	pop    %edi
80104fc0:	5d                   	pop    %ebp
80104fc1:	c3                   	ret    
80104fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	8b 55 10             	mov    0x10(%ebp),%edx
80104fd7:	8b 75 08             	mov    0x8(%ebp),%esi
80104fda:	53                   	push   %ebx
80104fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104fde:	85 d2                	test   %edx,%edx
80104fe0:	7e 25                	jle    80105007 <safestrcpy+0x37>
80104fe2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104fe6:	89 f2                	mov    %esi,%edx
80104fe8:	eb 16                	jmp    80105000 <safestrcpy+0x30>
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ff0:	0f b6 08             	movzbl (%eax),%ecx
80104ff3:	83 c0 01             	add    $0x1,%eax
80104ff6:	83 c2 01             	add    $0x1,%edx
80104ff9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ffc:	84 c9                	test   %cl,%cl
80104ffe:	74 04                	je     80105004 <safestrcpy+0x34>
80105000:	39 d8                	cmp    %ebx,%eax
80105002:	75 ec                	jne    80104ff0 <safestrcpy+0x20>
    ;
  *s = 0;
80105004:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105007:	89 f0                	mov    %esi,%eax
80105009:	5b                   	pop    %ebx
8010500a:	5e                   	pop    %esi
8010500b:	5d                   	pop    %ebp
8010500c:	c3                   	ret    
8010500d:	8d 76 00             	lea    0x0(%esi),%esi

80105010 <strlen>:

int
strlen(const char *s)
{
80105010:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105011:	31 c0                	xor    %eax,%eax
{
80105013:	89 e5                	mov    %esp,%ebp
80105015:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105018:	80 3a 00             	cmpb   $0x0,(%edx)
8010501b:	74 0c                	je     80105029 <strlen+0x19>
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
80105020:	83 c0 01             	add    $0x1,%eax
80105023:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105027:	75 f7                	jne    80105020 <strlen+0x10>
    ;
  return n;
}
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    

8010502b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010502b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010502f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105033:	55                   	push   %ebp
  pushl %ebx
80105034:	53                   	push   %ebx
  pushl %esi
80105035:	56                   	push   %esi
  pushl %edi
80105036:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105037:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105039:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010503b:	5f                   	pop    %edi
  popl %esi
8010503c:	5e                   	pop    %esi
  popl %ebx
8010503d:	5b                   	pop    %ebx
  popl %ebp
8010503e:	5d                   	pop    %ebp
  ret
8010503f:	c3                   	ret    

80105040 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	53                   	push   %ebx
80105044:	83 ec 04             	sub    $0x4,%esp
80105047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010504a:	e8 d1 f0 ff ff       	call   80104120 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010504f:	8b 00                	mov    (%eax),%eax
80105051:	39 d8                	cmp    %ebx,%eax
80105053:	76 1b                	jbe    80105070 <fetchint+0x30>
80105055:	8d 53 04             	lea    0x4(%ebx),%edx
80105058:	39 d0                	cmp    %edx,%eax
8010505a:	72 14                	jb     80105070 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010505c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505f:	8b 13                	mov    (%ebx),%edx
80105061:	89 10                	mov    %edx,(%eax)
  return 0;
80105063:	31 c0                	xor    %eax,%eax
}
80105065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105068:	c9                   	leave  
80105069:	c3                   	ret    
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105075:	eb ee                	jmp    80105065 <fetchint+0x25>
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax

80105080 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	53                   	push   %ebx
80105084:	83 ec 04             	sub    $0x4,%esp
80105087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010508a:	e8 91 f0 ff ff       	call   80104120 <myproc>

  if(addr >= curproc->sz)
8010508f:	39 18                	cmp    %ebx,(%eax)
80105091:	76 2d                	jbe    801050c0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105093:	8b 55 0c             	mov    0xc(%ebp),%edx
80105096:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105098:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010509a:	39 d3                	cmp    %edx,%ebx
8010509c:	73 22                	jae    801050c0 <fetchstr+0x40>
8010509e:	89 d8                	mov    %ebx,%eax
801050a0:	eb 0d                	jmp    801050af <fetchstr+0x2f>
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050a8:	83 c0 01             	add    $0x1,%eax
801050ab:	39 c2                	cmp    %eax,%edx
801050ad:	76 11                	jbe    801050c0 <fetchstr+0x40>
    if(*s == 0)
801050af:	80 38 00             	cmpb   $0x0,(%eax)
801050b2:	75 f4                	jne    801050a8 <fetchstr+0x28>
      return s - *pp;
801050b4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801050b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b9:	c9                   	leave  
801050ba:	c3                   	ret    
801050bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop
801050c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801050c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c8:	c9                   	leave  
801050c9:	c3                   	ret    
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050d5:	e8 46 f0 ff ff       	call   80104120 <myproc>
801050da:	8b 55 08             	mov    0x8(%ebp),%edx
801050dd:	8b 40 18             	mov    0x18(%eax),%eax
801050e0:	8b 40 44             	mov    0x44(%eax),%eax
801050e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050e6:	e8 35 f0 ff ff       	call   80104120 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ee:	8b 00                	mov    (%eax),%eax
801050f0:	39 c6                	cmp    %eax,%esi
801050f2:	73 1c                	jae    80105110 <argint+0x40>
801050f4:	8d 53 08             	lea    0x8(%ebx),%edx
801050f7:	39 d0                	cmp    %edx,%eax
801050f9:	72 15                	jb     80105110 <argint+0x40>
  *ip = *(int*)(addr);
801050fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050fe:	8b 53 04             	mov    0x4(%ebx),%edx
80105101:	89 10                	mov    %edx,(%eax)
  return 0;
80105103:	31 c0                	xor    %eax,%eax
}
80105105:	5b                   	pop    %ebx
80105106:	5e                   	pop    %esi
80105107:	5d                   	pop    %ebp
80105108:	c3                   	ret    
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105115:	eb ee                	jmp    80105105 <argint+0x35>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
80105126:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105129:	e8 f2 ef ff ff       	call   80104120 <myproc>
8010512e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105130:	e8 eb ef ff ff       	call   80104120 <myproc>
80105135:	8b 55 08             	mov    0x8(%ebp),%edx
80105138:	8b 40 18             	mov    0x18(%eax),%eax
8010513b:	8b 40 44             	mov    0x44(%eax),%eax
8010513e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105141:	e8 da ef ff ff       	call   80104120 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105146:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105149:	8b 00                	mov    (%eax),%eax
8010514b:	39 c7                	cmp    %eax,%edi
8010514d:	73 31                	jae    80105180 <argptr+0x60>
8010514f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105152:	39 c8                	cmp    %ecx,%eax
80105154:	72 2a                	jb     80105180 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105156:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105159:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010515c:	85 d2                	test   %edx,%edx
8010515e:	78 20                	js     80105180 <argptr+0x60>
80105160:	8b 16                	mov    (%esi),%edx
80105162:	39 c2                	cmp    %eax,%edx
80105164:	76 1a                	jbe    80105180 <argptr+0x60>
80105166:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105169:	01 c3                	add    %eax,%ebx
8010516b:	39 da                	cmp    %ebx,%edx
8010516d:	72 11                	jb     80105180 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010516f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105172:	89 02                	mov    %eax,(%edx)
  return 0;
80105174:	31 c0                	xor    %eax,%eax
}
80105176:	83 c4 0c             	add    $0xc,%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5f                   	pop    %edi
8010517c:	5d                   	pop    %ebp
8010517d:	c3                   	ret    
8010517e:	66 90                	xchg   %ax,%ax
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105185:	eb ef                	jmp    80105176 <argptr+0x56>
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax

80105190 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105195:	e8 86 ef ff ff       	call   80104120 <myproc>
8010519a:	8b 55 08             	mov    0x8(%ebp),%edx
8010519d:	8b 40 18             	mov    0x18(%eax),%eax
801051a0:	8b 40 44             	mov    0x44(%eax),%eax
801051a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051a6:	e8 75 ef ff ff       	call   80104120 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051ae:	8b 00                	mov    (%eax),%eax
801051b0:	39 c6                	cmp    %eax,%esi
801051b2:	73 44                	jae    801051f8 <argstr+0x68>
801051b4:	8d 53 08             	lea    0x8(%ebx),%edx
801051b7:	39 d0                	cmp    %edx,%eax
801051b9:	72 3d                	jb     801051f8 <argstr+0x68>
  *ip = *(int*)(addr);
801051bb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801051be:	e8 5d ef ff ff       	call   80104120 <myproc>
  if(addr >= curproc->sz)
801051c3:	3b 18                	cmp    (%eax),%ebx
801051c5:	73 31                	jae    801051f8 <argstr+0x68>
  *pp = (char*)addr;
801051c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051ca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051cc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051ce:	39 d3                	cmp    %edx,%ebx
801051d0:	73 26                	jae    801051f8 <argstr+0x68>
801051d2:	89 d8                	mov    %ebx,%eax
801051d4:	eb 11                	jmp    801051e7 <argstr+0x57>
801051d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
801051e0:	83 c0 01             	add    $0x1,%eax
801051e3:	39 c2                	cmp    %eax,%edx
801051e5:	76 11                	jbe    801051f8 <argstr+0x68>
    if(*s == 0)
801051e7:	80 38 00             	cmpb   $0x0,(%eax)
801051ea:	75 f4                	jne    801051e0 <argstr+0x50>
      return s - *pp;
801051ec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801051ee:	5b                   	pop    %ebx
801051ef:	5e                   	pop    %esi
801051f0:	5d                   	pop    %ebp
801051f1:	c3                   	ret    
801051f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051f8:	5b                   	pop    %ebx
    return -1;
801051f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051fe:	5e                   	pop    %esi
801051ff:	5d                   	pop    %ebp
80105200:	c3                   	ret    
80105201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop

80105210 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105217:	e8 04 ef ff ff       	call   80104120 <myproc>
8010521c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010521e:	8b 40 18             	mov    0x18(%eax),%eax
80105221:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105224:	8d 50 ff             	lea    -0x1(%eax),%edx
80105227:	83 fa 14             	cmp    $0x14,%edx
8010522a:	77 24                	ja     80105250 <syscall+0x40>
8010522c:	8b 14 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%edx
80105233:	85 d2                	test   %edx,%edx
80105235:	74 19                	je     80105250 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105237:	ff d2                	call   *%edx
80105239:	89 c2                	mov    %eax,%edx
8010523b:	8b 43 18             	mov    0x18(%ebx),%eax
8010523e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105244:	c9                   	leave  
80105245:	c3                   	ret    
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105250:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105251:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105254:	50                   	push   %eax
80105255:	ff 73 10             	push   0x10(%ebx)
80105258:	68 dd 7f 10 80       	push   $0x80107fdd
8010525d:	e8 1e b6 ff ff       	call   80100880 <cprintf>
    curproc->tf->eax = -1;
80105262:	8b 43 18             	mov    0x18(%ebx),%eax
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010526f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105272:	c9                   	leave  
80105273:	c3                   	ret    
80105274:	66 90                	xchg   %ax,%ax
80105276:	66 90                	xchg   %ax,%ax
80105278:	66 90                	xchg   %ax,%ax
8010527a:	66 90                	xchg   %ax,%ax
8010527c:	66 90                	xchg   %ax,%ax
8010527e:	66 90                	xchg   %ax,%ax

80105280 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105285:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105288:	53                   	push   %ebx
80105289:	83 ec 34             	sub    $0x34,%esp
8010528c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010528f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105292:	57                   	push   %edi
80105293:	50                   	push   %eax
{
80105294:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105297:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010529a:	e8 d1 d5 ff ff       	call   80102870 <nameiparent>
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	85 c0                	test   %eax,%eax
801052a4:	0f 84 46 01 00 00    	je     801053f0 <create+0x170>
    return 0;
  ilock(dp);
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	89 c3                	mov    %eax,%ebx
801052af:	50                   	push   %eax
801052b0:	e8 7b cc ff ff       	call   80101f30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052b5:	83 c4 0c             	add    $0xc,%esp
801052b8:	6a 00                	push   $0x0
801052ba:	57                   	push   %edi
801052bb:	53                   	push   %ebx
801052bc:	e8 cf d1 ff ff       	call   80102490 <dirlookup>
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	89 c6                	mov    %eax,%esi
801052c6:	85 c0                	test   %eax,%eax
801052c8:	74 56                	je     80105320 <create+0xa0>
    iunlockput(dp);
801052ca:	83 ec 0c             	sub    $0xc,%esp
801052cd:	53                   	push   %ebx
801052ce:	e8 ed ce ff ff       	call   801021c0 <iunlockput>
    ilock(ip);
801052d3:	89 34 24             	mov    %esi,(%esp)
801052d6:	e8 55 cc ff ff       	call   80101f30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801052db:	83 c4 10             	add    $0x10,%esp
801052de:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801052e3:	75 1b                	jne    80105300 <create+0x80>
801052e5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801052ea:	75 14                	jne    80105300 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801052ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ef:	89 f0                	mov    %esi,%eax
801052f1:	5b                   	pop    %ebx
801052f2:	5e                   	pop    %esi
801052f3:	5f                   	pop    %edi
801052f4:	5d                   	pop    %ebp
801052f5:	c3                   	ret    
801052f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	56                   	push   %esi
    return 0;
80105304:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105306:	e8 b5 ce ff ff       	call   801021c0 <iunlockput>
    return 0;
8010530b:	83 c4 10             	add    $0x10,%esp
}
8010530e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105311:	89 f0                	mov    %esi,%eax
80105313:	5b                   	pop    %ebx
80105314:	5e                   	pop    %esi
80105315:	5f                   	pop    %edi
80105316:	5d                   	pop    %ebp
80105317:	c3                   	ret    
80105318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105320:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105324:	83 ec 08             	sub    $0x8,%esp
80105327:	50                   	push   %eax
80105328:	ff 33                	push   (%ebx)
8010532a:	e8 91 ca ff ff       	call   80101dc0 <ialloc>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	89 c6                	mov    %eax,%esi
80105334:	85 c0                	test   %eax,%eax
80105336:	0f 84 cd 00 00 00    	je     80105409 <create+0x189>
  ilock(ip);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	50                   	push   %eax
80105340:	e8 eb cb ff ff       	call   80101f30 <ilock>
  ip->major = major;
80105345:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105349:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010534d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105351:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105355:	b8 01 00 00 00       	mov    $0x1,%eax
8010535a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010535e:	89 34 24             	mov    %esi,(%esp)
80105361:	e8 1a cb ff ff       	call   80101e80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105366:	83 c4 10             	add    $0x10,%esp
80105369:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010536e:	74 30                	je     801053a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105370:	83 ec 04             	sub    $0x4,%esp
80105373:	ff 76 04             	push   0x4(%esi)
80105376:	57                   	push   %edi
80105377:	53                   	push   %ebx
80105378:	e8 13 d4 ff ff       	call   80102790 <dirlink>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	78 78                	js     801053fc <create+0x17c>
  iunlockput(dp);
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	53                   	push   %ebx
80105388:	e8 33 ce ff ff       	call   801021c0 <iunlockput>
  return ip;
8010538d:	83 c4 10             	add    $0x10,%esp
}
80105390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105393:	89 f0                	mov    %esi,%eax
80105395:	5b                   	pop    %ebx
80105396:	5e                   	pop    %esi
80105397:	5f                   	pop    %edi
80105398:	5d                   	pop    %ebp
80105399:	c3                   	ret    
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053a8:	53                   	push   %ebx
801053a9:	e8 d2 ca ff ff       	call   80101e80 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053ae:	83 c4 0c             	add    $0xc,%esp
801053b1:	ff 76 04             	push   0x4(%esi)
801053b4:	68 74 80 10 80       	push   $0x80108074
801053b9:	56                   	push   %esi
801053ba:	e8 d1 d3 ff ff       	call   80102790 <dirlink>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	85 c0                	test   %eax,%eax
801053c4:	78 18                	js     801053de <create+0x15e>
801053c6:	83 ec 04             	sub    $0x4,%esp
801053c9:	ff 73 04             	push   0x4(%ebx)
801053cc:	68 73 80 10 80       	push   $0x80108073
801053d1:	56                   	push   %esi
801053d2:	e8 b9 d3 ff ff       	call   80102790 <dirlink>
801053d7:	83 c4 10             	add    $0x10,%esp
801053da:	85 c0                	test   %eax,%eax
801053dc:	79 92                	jns    80105370 <create+0xf0>
      panic("create dots");
801053de:	83 ec 0c             	sub    $0xc,%esp
801053e1:	68 67 80 10 80       	push   $0x80108067
801053e6:	e8 65 b0 ff ff       	call   80100450 <panic>
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
}
801053f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801053f3:	31 f6                	xor    %esi,%esi
}
801053f5:	5b                   	pop    %ebx
801053f6:	89 f0                	mov    %esi,%eax
801053f8:	5e                   	pop    %esi
801053f9:	5f                   	pop    %edi
801053fa:	5d                   	pop    %ebp
801053fb:	c3                   	ret    
    panic("create: dirlink");
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	68 76 80 10 80       	push   $0x80108076
80105404:	e8 47 b0 ff ff       	call   80100450 <panic>
    panic("create: ialloc");
80105409:	83 ec 0c             	sub    $0xc,%esp
8010540c:	68 58 80 10 80       	push   $0x80108058
80105411:	e8 3a b0 ff ff       	call   80100450 <panic>
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi

80105420 <sys_dup>:
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105425:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105428:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010542b:	50                   	push   %eax
8010542c:	6a 00                	push   $0x0
8010542e:	e8 9d fc ff ff       	call   801050d0 <argint>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 36                	js     80105470 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010543a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010543e:	77 30                	ja     80105470 <sys_dup+0x50>
80105440:	e8 db ec ff ff       	call   80104120 <myproc>
80105445:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105448:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010544c:	85 f6                	test   %esi,%esi
8010544e:	74 20                	je     80105470 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105450:	e8 cb ec ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105455:	31 db                	xor    %ebx,%ebx
80105457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105460:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105464:	85 d2                	test   %edx,%edx
80105466:	74 18                	je     80105480 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105468:	83 c3 01             	add    $0x1,%ebx
8010546b:	83 fb 10             	cmp    $0x10,%ebx
8010546e:	75 f0                	jne    80105460 <sys_dup+0x40>
}
80105470:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105473:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105478:	89 d8                	mov    %ebx,%eax
8010547a:	5b                   	pop    %ebx
8010547b:	5e                   	pop    %esi
8010547c:	5d                   	pop    %ebp
8010547d:	c3                   	ret    
8010547e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105480:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105483:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105487:	56                   	push   %esi
80105488:	e8 c3 c1 ff ff       	call   80101650 <filedup>
  return fd;
8010548d:	83 c4 10             	add    $0x10,%esp
}
80105490:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105493:	89 d8                	mov    %ebx,%eax
80105495:	5b                   	pop    %ebx
80105496:	5e                   	pop    %esi
80105497:	5d                   	pop    %ebp
80105498:	c3                   	ret    
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_read>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054ab:	53                   	push   %ebx
801054ac:	6a 00                	push   $0x0
801054ae:	e8 1d fc ff ff       	call   801050d0 <argint>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 5e                	js     80105518 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054be:	77 58                	ja     80105518 <sys_read+0x78>
801054c0:	e8 5b ec ff ff       	call   80104120 <myproc>
801054c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801054cc:	85 f6                	test   %esi,%esi
801054ce:	74 48                	je     80105518 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054d6:	50                   	push   %eax
801054d7:	6a 02                	push   $0x2
801054d9:	e8 f2 fb ff ff       	call   801050d0 <argint>
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	85 c0                	test   %eax,%eax
801054e3:	78 33                	js     80105518 <sys_read+0x78>
801054e5:	83 ec 04             	sub    $0x4,%esp
801054e8:	ff 75 f0             	push   -0x10(%ebp)
801054eb:	53                   	push   %ebx
801054ec:	6a 01                	push   $0x1
801054ee:	e8 2d fc ff ff       	call   80105120 <argptr>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 1e                	js     80105518 <sys_read+0x78>
  return fileread(f, p, n);
801054fa:	83 ec 04             	sub    $0x4,%esp
801054fd:	ff 75 f0             	push   -0x10(%ebp)
80105500:	ff 75 f4             	push   -0xc(%ebp)
80105503:	56                   	push   %esi
80105504:	e8 c7 c2 ff ff       	call   801017d0 <fileread>
80105509:	83 c4 10             	add    $0x10,%esp
}
8010550c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010550f:	5b                   	pop    %ebx
80105510:	5e                   	pop    %esi
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105517:	90                   	nop
    return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551d:	eb ed                	jmp    8010550c <sys_read+0x6c>
8010551f:	90                   	nop

80105520 <sys_write>:
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105525:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105528:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010552b:	53                   	push   %ebx
8010552c:	6a 00                	push   $0x0
8010552e:	e8 9d fb ff ff       	call   801050d0 <argint>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	78 5e                	js     80105598 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010553a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010553e:	77 58                	ja     80105598 <sys_write+0x78>
80105540:	e8 db eb ff ff       	call   80104120 <myproc>
80105545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105548:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010554c:	85 f6                	test   %esi,%esi
8010554e:	74 48                	je     80105598 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105550:	83 ec 08             	sub    $0x8,%esp
80105553:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105556:	50                   	push   %eax
80105557:	6a 02                	push   $0x2
80105559:	e8 72 fb ff ff       	call   801050d0 <argint>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	85 c0                	test   %eax,%eax
80105563:	78 33                	js     80105598 <sys_write+0x78>
80105565:	83 ec 04             	sub    $0x4,%esp
80105568:	ff 75 f0             	push   -0x10(%ebp)
8010556b:	53                   	push   %ebx
8010556c:	6a 01                	push   $0x1
8010556e:	e8 ad fb ff ff       	call   80105120 <argptr>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 1e                	js     80105598 <sys_write+0x78>
  return filewrite(f, p, n);
8010557a:	83 ec 04             	sub    $0x4,%esp
8010557d:	ff 75 f0             	push   -0x10(%ebp)
80105580:	ff 75 f4             	push   -0xc(%ebp)
80105583:	56                   	push   %esi
80105584:	e8 d7 c2 ff ff       	call   80101860 <filewrite>
80105589:	83 c4 10             	add    $0x10,%esp
}
8010558c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010558f:	5b                   	pop    %ebx
80105590:	5e                   	pop    %esi
80105591:	5d                   	pop    %ebp
80105592:	c3                   	ret    
80105593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105597:	90                   	nop
    return -1;
80105598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559d:	eb ed                	jmp    8010558c <sys_write+0x6c>
8010559f:	90                   	nop

801055a0 <sys_close>:
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	56                   	push   %esi
801055a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055ab:	50                   	push   %eax
801055ac:	6a 00                	push   $0x0
801055ae:	e8 1d fb ff ff       	call   801050d0 <argint>
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	78 3e                	js     801055f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055be:	77 38                	ja     801055f8 <sys_close+0x58>
801055c0:	e8 5b eb ff ff       	call   80104120 <myproc>
801055c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801055cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801055cf:	85 f6                	test   %esi,%esi
801055d1:	74 25                	je     801055f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801055d3:	e8 48 eb ff ff       	call   80104120 <myproc>
  fileclose(f);
801055d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801055db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801055e2:	00 
  fileclose(f);
801055e3:	56                   	push   %esi
801055e4:	e8 b7 c0 ff ff       	call   801016a0 <fileclose>
  return 0;
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	31 c0                	xor    %eax,%eax
}
801055ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f1:	5b                   	pop    %ebx
801055f2:	5e                   	pop    %esi
801055f3:	5d                   	pop    %ebp
801055f4:	c3                   	ret    
801055f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fd:	eb ef                	jmp    801055ee <sys_close+0x4e>
801055ff:	90                   	nop

80105600 <sys_fstat>:
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	56                   	push   %esi
80105604:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105605:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105608:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010560b:	53                   	push   %ebx
8010560c:	6a 00                	push   $0x0
8010560e:	e8 bd fa ff ff       	call   801050d0 <argint>
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	78 46                	js     80105660 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010561a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010561e:	77 40                	ja     80105660 <sys_fstat+0x60>
80105620:	e8 fb ea ff ff       	call   80104120 <myproc>
80105625:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105628:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010562c:	85 f6                	test   %esi,%esi
8010562e:	74 30                	je     80105660 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105630:	83 ec 04             	sub    $0x4,%esp
80105633:	6a 14                	push   $0x14
80105635:	53                   	push   %ebx
80105636:	6a 01                	push   $0x1
80105638:	e8 e3 fa ff ff       	call   80105120 <argptr>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	78 1c                	js     80105660 <sys_fstat+0x60>
  return filestat(f, st);
80105644:	83 ec 08             	sub    $0x8,%esp
80105647:	ff 75 f4             	push   -0xc(%ebp)
8010564a:	56                   	push   %esi
8010564b:	e8 30 c1 ff ff       	call   80101780 <filestat>
80105650:	83 c4 10             	add    $0x10,%esp
}
80105653:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105656:	5b                   	pop    %ebx
80105657:	5e                   	pop    %esi
80105658:	5d                   	pop    %ebp
80105659:	c3                   	ret    
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105665:	eb ec                	jmp    80105653 <sys_fstat+0x53>
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_link>:
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105675:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105678:	53                   	push   %ebx
80105679:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010567c:	50                   	push   %eax
8010567d:	6a 00                	push   $0x0
8010567f:	e8 0c fb ff ff       	call   80105190 <argstr>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	85 c0                	test   %eax,%eax
80105689:	0f 88 fb 00 00 00    	js     8010578a <sys_link+0x11a>
8010568f:	83 ec 08             	sub    $0x8,%esp
80105692:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105695:	50                   	push   %eax
80105696:	6a 01                	push   $0x1
80105698:	e8 f3 fa ff ff       	call   80105190 <argstr>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	0f 88 e2 00 00 00    	js     8010578a <sys_link+0x11a>
  begin_op();
801056a8:	e8 63 de ff ff       	call   80103510 <begin_op>
  if((ip = namei(old)) == 0){
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	ff 75 d4             	push   -0x2c(%ebp)
801056b3:	e8 98 d1 ff ff       	call   80102850 <namei>
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	89 c3                	mov    %eax,%ebx
801056bd:	85 c0                	test   %eax,%eax
801056bf:	0f 84 e4 00 00 00    	je     801057a9 <sys_link+0x139>
  ilock(ip);
801056c5:	83 ec 0c             	sub    $0xc,%esp
801056c8:	50                   	push   %eax
801056c9:	e8 62 c8 ff ff       	call   80101f30 <ilock>
  if(ip->type == T_DIR){
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056d6:	0f 84 b5 00 00 00    	je     80105791 <sys_link+0x121>
  iupdate(ip);
801056dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801056df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801056e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801056e7:	53                   	push   %ebx
801056e8:	e8 93 c7 ff ff       	call   80101e80 <iupdate>
  iunlock(ip);
801056ed:	89 1c 24             	mov    %ebx,(%esp)
801056f0:	e8 1b c9 ff ff       	call   80102010 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801056f5:	58                   	pop    %eax
801056f6:	5a                   	pop    %edx
801056f7:	57                   	push   %edi
801056f8:	ff 75 d0             	push   -0x30(%ebp)
801056fb:	e8 70 d1 ff ff       	call   80102870 <nameiparent>
80105700:	83 c4 10             	add    $0x10,%esp
80105703:	89 c6                	mov    %eax,%esi
80105705:	85 c0                	test   %eax,%eax
80105707:	74 5b                	je     80105764 <sys_link+0xf4>
  ilock(dp);
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	50                   	push   %eax
8010570d:	e8 1e c8 ff ff       	call   80101f30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105712:	8b 03                	mov    (%ebx),%eax
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	39 06                	cmp    %eax,(%esi)
80105719:	75 3d                	jne    80105758 <sys_link+0xe8>
8010571b:	83 ec 04             	sub    $0x4,%esp
8010571e:	ff 73 04             	push   0x4(%ebx)
80105721:	57                   	push   %edi
80105722:	56                   	push   %esi
80105723:	e8 68 d0 ff ff       	call   80102790 <dirlink>
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	85 c0                	test   %eax,%eax
8010572d:	78 29                	js     80105758 <sys_link+0xe8>
  iunlockput(dp);
8010572f:	83 ec 0c             	sub    $0xc,%esp
80105732:	56                   	push   %esi
80105733:	e8 88 ca ff ff       	call   801021c0 <iunlockput>
  iput(ip);
80105738:	89 1c 24             	mov    %ebx,(%esp)
8010573b:	e8 20 c9 ff ff       	call   80102060 <iput>
  end_op();
80105740:	e8 3b de ff ff       	call   80103580 <end_op>
  return 0;
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	31 c0                	xor    %eax,%eax
}
8010574a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010574d:	5b                   	pop    %ebx
8010574e:	5e                   	pop    %esi
8010574f:	5f                   	pop    %edi
80105750:	5d                   	pop    %ebp
80105751:	c3                   	ret    
80105752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	56                   	push   %esi
8010575c:	e8 5f ca ff ff       	call   801021c0 <iunlockput>
    goto bad;
80105761:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	53                   	push   %ebx
80105768:	e8 c3 c7 ff ff       	call   80101f30 <ilock>
  ip->nlink--;
8010576d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105772:	89 1c 24             	mov    %ebx,(%esp)
80105775:	e8 06 c7 ff ff       	call   80101e80 <iupdate>
  iunlockput(ip);
8010577a:	89 1c 24             	mov    %ebx,(%esp)
8010577d:	e8 3e ca ff ff       	call   801021c0 <iunlockput>
  end_op();
80105782:	e8 f9 dd ff ff       	call   80103580 <end_op>
  return -1;
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578f:	eb b9                	jmp    8010574a <sys_link+0xda>
    iunlockput(ip);
80105791:	83 ec 0c             	sub    $0xc,%esp
80105794:	53                   	push   %ebx
80105795:	e8 26 ca ff ff       	call   801021c0 <iunlockput>
    end_op();
8010579a:	e8 e1 dd ff ff       	call   80103580 <end_op>
    return -1;
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a7:	eb a1                	jmp    8010574a <sys_link+0xda>
    end_op();
801057a9:	e8 d2 dd ff ff       	call   80103580 <end_op>
    return -1;
801057ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b3:	eb 95                	jmp    8010574a <sys_link+0xda>
801057b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_unlink>:
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057c8:	53                   	push   %ebx
801057c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801057cc:	50                   	push   %eax
801057cd:	6a 00                	push   $0x0
801057cf:	e8 bc f9 ff ff       	call   80105190 <argstr>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
801057d9:	0f 88 7a 01 00 00    	js     80105959 <sys_unlink+0x199>
  begin_op();
801057df:	e8 2c dd ff ff       	call   80103510 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801057e7:	83 ec 08             	sub    $0x8,%esp
801057ea:	53                   	push   %ebx
801057eb:	ff 75 c0             	push   -0x40(%ebp)
801057ee:	e8 7d d0 ff ff       	call   80102870 <nameiparent>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801057f9:	85 c0                	test   %eax,%eax
801057fb:	0f 84 62 01 00 00    	je     80105963 <sys_unlink+0x1a3>
  ilock(dp);
80105801:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	57                   	push   %edi
80105808:	e8 23 c7 ff ff       	call   80101f30 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010580d:	58                   	pop    %eax
8010580e:	5a                   	pop    %edx
8010580f:	68 74 80 10 80       	push   $0x80108074
80105814:	53                   	push   %ebx
80105815:	e8 56 cc ff ff       	call   80102470 <namecmp>
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	85 c0                	test   %eax,%eax
8010581f:	0f 84 fb 00 00 00    	je     80105920 <sys_unlink+0x160>
80105825:	83 ec 08             	sub    $0x8,%esp
80105828:	68 73 80 10 80       	push   $0x80108073
8010582d:	53                   	push   %ebx
8010582e:	e8 3d cc ff ff       	call   80102470 <namecmp>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	0f 84 e2 00 00 00    	je     80105920 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010583e:	83 ec 04             	sub    $0x4,%esp
80105841:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105844:	50                   	push   %eax
80105845:	53                   	push   %ebx
80105846:	57                   	push   %edi
80105847:	e8 44 cc ff ff       	call   80102490 <dirlookup>
8010584c:	83 c4 10             	add    $0x10,%esp
8010584f:	89 c3                	mov    %eax,%ebx
80105851:	85 c0                	test   %eax,%eax
80105853:	0f 84 c7 00 00 00    	je     80105920 <sys_unlink+0x160>
  ilock(ip);
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	50                   	push   %eax
8010585d:	e8 ce c6 ff ff       	call   80101f30 <ilock>
  if(ip->nlink < 1)
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010586a:	0f 8e 1c 01 00 00    	jle    8010598c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105870:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105875:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105878:	74 66                	je     801058e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010587a:	83 ec 04             	sub    $0x4,%esp
8010587d:	6a 10                	push   $0x10
8010587f:	6a 00                	push   $0x0
80105881:	57                   	push   %edi
80105882:	e8 89 f5 ff ff       	call   80104e10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105887:	6a 10                	push   $0x10
80105889:	ff 75 c4             	push   -0x3c(%ebp)
8010588c:	57                   	push   %edi
8010588d:	ff 75 b4             	push   -0x4c(%ebp)
80105890:	e8 ab ca ff ff       	call   80102340 <writei>
80105895:	83 c4 20             	add    $0x20,%esp
80105898:	83 f8 10             	cmp    $0x10,%eax
8010589b:	0f 85 de 00 00 00    	jne    8010597f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801058a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058a6:	0f 84 94 00 00 00    	je     80105940 <sys_unlink+0x180>
  iunlockput(dp);
801058ac:	83 ec 0c             	sub    $0xc,%esp
801058af:	ff 75 b4             	push   -0x4c(%ebp)
801058b2:	e8 09 c9 ff ff       	call   801021c0 <iunlockput>
  ip->nlink--;
801058b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058bc:	89 1c 24             	mov    %ebx,(%esp)
801058bf:	e8 bc c5 ff ff       	call   80101e80 <iupdate>
  iunlockput(ip);
801058c4:	89 1c 24             	mov    %ebx,(%esp)
801058c7:	e8 f4 c8 ff ff       	call   801021c0 <iunlockput>
  end_op();
801058cc:	e8 af dc ff ff       	call   80103580 <end_op>
  return 0;
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	31 c0                	xor    %eax,%eax
}
801058d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d9:	5b                   	pop    %ebx
801058da:	5e                   	pop    %esi
801058db:	5f                   	pop    %edi
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret    
801058de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801058e4:	76 94                	jbe    8010587a <sys_unlink+0xba>
801058e6:	be 20 00 00 00       	mov    $0x20,%esi
801058eb:	eb 0b                	jmp    801058f8 <sys_unlink+0x138>
801058ed:	8d 76 00             	lea    0x0(%esi),%esi
801058f0:	83 c6 10             	add    $0x10,%esi
801058f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801058f6:	73 82                	jae    8010587a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058f8:	6a 10                	push   $0x10
801058fa:	56                   	push   %esi
801058fb:	57                   	push   %edi
801058fc:	53                   	push   %ebx
801058fd:	e8 3e c9 ff ff       	call   80102240 <readi>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	83 f8 10             	cmp    $0x10,%eax
80105908:	75 68                	jne    80105972 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010590a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010590f:	74 df                	je     801058f0 <sys_unlink+0x130>
    iunlockput(ip);
80105911:	83 ec 0c             	sub    $0xc,%esp
80105914:	53                   	push   %ebx
80105915:	e8 a6 c8 ff ff       	call   801021c0 <iunlockput>
    goto bad;
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	ff 75 b4             	push   -0x4c(%ebp)
80105926:	e8 95 c8 ff ff       	call   801021c0 <iunlockput>
  end_op();
8010592b:	e8 50 dc ff ff       	call   80103580 <end_op>
  return -1;
80105930:	83 c4 10             	add    $0x10,%esp
80105933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105938:	eb 9c                	jmp    801058d6 <sys_unlink+0x116>
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105940:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105943:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105946:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010594b:	50                   	push   %eax
8010594c:	e8 2f c5 ff ff       	call   80101e80 <iupdate>
80105951:	83 c4 10             	add    $0x10,%esp
80105954:	e9 53 ff ff ff       	jmp    801058ac <sys_unlink+0xec>
    return -1;
80105959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595e:	e9 73 ff ff ff       	jmp    801058d6 <sys_unlink+0x116>
    end_op();
80105963:	e8 18 dc ff ff       	call   80103580 <end_op>
    return -1;
80105968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596d:	e9 64 ff ff ff       	jmp    801058d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105972:	83 ec 0c             	sub    $0xc,%esp
80105975:	68 98 80 10 80       	push   $0x80108098
8010597a:	e8 d1 aa ff ff       	call   80100450 <panic>
    panic("unlink: writei");
8010597f:	83 ec 0c             	sub    $0xc,%esp
80105982:	68 aa 80 10 80       	push   $0x801080aa
80105987:	e8 c4 aa ff ff       	call   80100450 <panic>
    panic("unlink: nlink < 1");
8010598c:	83 ec 0c             	sub    $0xc,%esp
8010598f:	68 86 80 10 80       	push   $0x80108086
80105994:	e8 b7 aa ff ff       	call   80100450 <panic>
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_open>:

int
sys_open(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059a8:	53                   	push   %ebx
801059a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059ac:	50                   	push   %eax
801059ad:	6a 00                	push   $0x0
801059af:	e8 dc f7 ff ff       	call   80105190 <argstr>
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	85 c0                	test   %eax,%eax
801059b9:	0f 88 8e 00 00 00    	js     80105a4d <sys_open+0xad>
801059bf:	83 ec 08             	sub    $0x8,%esp
801059c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059c5:	50                   	push   %eax
801059c6:	6a 01                	push   $0x1
801059c8:	e8 03 f7 ff ff       	call   801050d0 <argint>
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	78 79                	js     80105a4d <sys_open+0xad>
    return -1;

  begin_op();
801059d4:	e8 37 db ff ff       	call   80103510 <begin_op>

  if(omode & O_CREATE){
801059d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801059dd:	75 79                	jne    80105a58 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801059df:	83 ec 0c             	sub    $0xc,%esp
801059e2:	ff 75 e0             	push   -0x20(%ebp)
801059e5:	e8 66 ce ff ff       	call   80102850 <namei>
801059ea:	83 c4 10             	add    $0x10,%esp
801059ed:	89 c6                	mov    %eax,%esi
801059ef:	85 c0                	test   %eax,%eax
801059f1:	0f 84 7e 00 00 00    	je     80105a75 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801059f7:	83 ec 0c             	sub    $0xc,%esp
801059fa:	50                   	push   %eax
801059fb:	e8 30 c5 ff ff       	call   80101f30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a00:	83 c4 10             	add    $0x10,%esp
80105a03:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a08:	0f 84 c2 00 00 00    	je     80105ad0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a0e:	e8 cd bb ff ff       	call   801015e0 <filealloc>
80105a13:	89 c7                	mov    %eax,%edi
80105a15:	85 c0                	test   %eax,%eax
80105a17:	74 23                	je     80105a3c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a19:	e8 02 e7 ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a1e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a24:	85 d2                	test   %edx,%edx
80105a26:	74 60                	je     80105a88 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a28:	83 c3 01             	add    $0x1,%ebx
80105a2b:	83 fb 10             	cmp    $0x10,%ebx
80105a2e:	75 f0                	jne    80105a20 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	57                   	push   %edi
80105a34:	e8 67 bc ff ff       	call   801016a0 <fileclose>
80105a39:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a3c:	83 ec 0c             	sub    $0xc,%esp
80105a3f:	56                   	push   %esi
80105a40:	e8 7b c7 ff ff       	call   801021c0 <iunlockput>
    end_op();
80105a45:	e8 36 db ff ff       	call   80103580 <end_op>
    return -1;
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a52:	eb 6d                	jmp    80105ac1 <sys_open+0x121>
80105a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a58:	83 ec 0c             	sub    $0xc,%esp
80105a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a5e:	31 c9                	xor    %ecx,%ecx
80105a60:	ba 02 00 00 00       	mov    $0x2,%edx
80105a65:	6a 00                	push   $0x0
80105a67:	e8 14 f8 ff ff       	call   80105280 <create>
    if(ip == 0){
80105a6c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a6f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a71:	85 c0                	test   %eax,%eax
80105a73:	75 99                	jne    80105a0e <sys_open+0x6e>
      end_op();
80105a75:	e8 06 db ff ff       	call   80103580 <end_op>
      return -1;
80105a7a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a7f:	eb 40                	jmp    80105ac1 <sys_open+0x121>
80105a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105a88:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a8b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a8f:	56                   	push   %esi
80105a90:	e8 7b c5 ff ff       	call   80102010 <iunlock>
  end_op();
80105a95:	e8 e6 da ff ff       	call   80103580 <end_op>

  f->type = FD_INODE;
80105a9a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aa3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105aa6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105aa9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105aab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ab2:	f7 d0                	not    %eax
80105ab4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ab7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105abd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ac4:	89 d8                	mov    %ebx,%eax
80105ac6:	5b                   	pop    %ebx
80105ac7:	5e                   	pop    %esi
80105ac8:	5f                   	pop    %edi
80105ac9:	5d                   	pop    %ebp
80105aca:	c3                   	ret    
80105acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105acf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ad0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ad3:	85 c9                	test   %ecx,%ecx
80105ad5:	0f 84 33 ff ff ff    	je     80105a0e <sys_open+0x6e>
80105adb:	e9 5c ff ff ff       	jmp    80105a3c <sys_open+0x9c>

80105ae0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ae6:	e8 25 da ff ff       	call   80103510 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105aeb:	83 ec 08             	sub    $0x8,%esp
80105aee:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af1:	50                   	push   %eax
80105af2:	6a 00                	push   $0x0
80105af4:	e8 97 f6 ff ff       	call   80105190 <argstr>
80105af9:	83 c4 10             	add    $0x10,%esp
80105afc:	85 c0                	test   %eax,%eax
80105afe:	78 30                	js     80105b30 <sys_mkdir+0x50>
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b06:	31 c9                	xor    %ecx,%ecx
80105b08:	ba 01 00 00 00       	mov    $0x1,%edx
80105b0d:	6a 00                	push   $0x0
80105b0f:	e8 6c f7 ff ff       	call   80105280 <create>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	74 15                	je     80105b30 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b1b:	83 ec 0c             	sub    $0xc,%esp
80105b1e:	50                   	push   %eax
80105b1f:	e8 9c c6 ff ff       	call   801021c0 <iunlockput>
  end_op();
80105b24:	e8 57 da ff ff       	call   80103580 <end_op>
  return 0;
80105b29:	83 c4 10             	add    $0x10,%esp
80105b2c:	31 c0                	xor    %eax,%eax
}
80105b2e:	c9                   	leave  
80105b2f:	c3                   	ret    
    end_op();
80105b30:	e8 4b da ff ff       	call   80103580 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b3a:	c9                   	leave  
80105b3b:	c3                   	ret    
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_mknod>:

int
sys_mknod(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b46:	e8 c5 d9 ff ff       	call   80103510 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b4b:	83 ec 08             	sub    $0x8,%esp
80105b4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b51:	50                   	push   %eax
80105b52:	6a 00                	push   $0x0
80105b54:	e8 37 f6 ff ff       	call   80105190 <argstr>
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	78 60                	js     80105bc0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b60:	83 ec 08             	sub    $0x8,%esp
80105b63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b66:	50                   	push   %eax
80105b67:	6a 01                	push   $0x1
80105b69:	e8 62 f5 ff ff       	call   801050d0 <argint>
  if((argstr(0, &path)) < 0 ||
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	85 c0                	test   %eax,%eax
80105b73:	78 4b                	js     80105bc0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105b75:	83 ec 08             	sub    $0x8,%esp
80105b78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b7b:	50                   	push   %eax
80105b7c:	6a 02                	push   $0x2
80105b7e:	e8 4d f5 ff ff       	call   801050d0 <argint>
     argint(1, &major) < 0 ||
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	85 c0                	test   %eax,%eax
80105b88:	78 36                	js     80105bc0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b8a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b8e:	83 ec 0c             	sub    $0xc,%esp
80105b91:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b95:	ba 03 00 00 00       	mov    $0x3,%edx
80105b9a:	50                   	push   %eax
80105b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b9e:	e8 dd f6 ff ff       	call   80105280 <create>
     argint(2, &minor) < 0 ||
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	74 16                	je     80105bc0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105baa:	83 ec 0c             	sub    $0xc,%esp
80105bad:	50                   	push   %eax
80105bae:	e8 0d c6 ff ff       	call   801021c0 <iunlockput>
  end_op();
80105bb3:	e8 c8 d9 ff ff       	call   80103580 <end_op>
  return 0;
80105bb8:	83 c4 10             	add    $0x10,%esp
80105bbb:	31 c0                	xor    %eax,%eax
}
80105bbd:	c9                   	leave  
80105bbe:	c3                   	ret    
80105bbf:	90                   	nop
    end_op();
80105bc0:	e8 bb d9 ff ff       	call   80103580 <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bca:	c9                   	leave  
80105bcb:	c3                   	ret    
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_chdir>:

int
sys_chdir(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	56                   	push   %esi
80105bd4:	53                   	push   %ebx
80105bd5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105bd8:	e8 43 e5 ff ff       	call   80104120 <myproc>
80105bdd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105bdf:	e8 2c d9 ff ff       	call   80103510 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105be4:	83 ec 08             	sub    $0x8,%esp
80105be7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bea:	50                   	push   %eax
80105beb:	6a 00                	push   $0x0
80105bed:	e8 9e f5 ff ff       	call   80105190 <argstr>
80105bf2:	83 c4 10             	add    $0x10,%esp
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	78 77                	js     80105c70 <sys_chdir+0xa0>
80105bf9:	83 ec 0c             	sub    $0xc,%esp
80105bfc:	ff 75 f4             	push   -0xc(%ebp)
80105bff:	e8 4c cc ff ff       	call   80102850 <namei>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	89 c3                	mov    %eax,%ebx
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	74 63                	je     80105c70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	50                   	push   %eax
80105c11:	e8 1a c3 ff ff       	call   80101f30 <ilock>
  if(ip->type != T_DIR){
80105c16:	83 c4 10             	add    $0x10,%esp
80105c19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c1e:	75 30                	jne    80105c50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	53                   	push   %ebx
80105c24:	e8 e7 c3 ff ff       	call   80102010 <iunlock>
  iput(curproc->cwd);
80105c29:	58                   	pop    %eax
80105c2a:	ff 76 68             	push   0x68(%esi)
80105c2d:	e8 2e c4 ff ff       	call   80102060 <iput>
  end_op();
80105c32:	e8 49 d9 ff ff       	call   80103580 <end_op>
  curproc->cwd = ip;
80105c37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c3a:	83 c4 10             	add    $0x10,%esp
80105c3d:	31 c0                	xor    %eax,%eax
}
80105c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c42:	5b                   	pop    %ebx
80105c43:	5e                   	pop    %esi
80105c44:	5d                   	pop    %ebp
80105c45:	c3                   	ret    
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	53                   	push   %ebx
80105c54:	e8 67 c5 ff ff       	call   801021c0 <iunlockput>
    end_op();
80105c59:	e8 22 d9 ff ff       	call   80103580 <end_op>
    return -1;
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c66:	eb d7                	jmp    80105c3f <sys_chdir+0x6f>
80105c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop
    end_op();
80105c70:	e8 0b d9 ff ff       	call   80103580 <end_op>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7a:	eb c3                	jmp    80105c3f <sys_chdir+0x6f>
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_exec>:

int
sys_exec(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c85:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c8b:	53                   	push   %ebx
80105c8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c92:	50                   	push   %eax
80105c93:	6a 00                	push   $0x0
80105c95:	e8 f6 f4 ff ff       	call   80105190 <argstr>
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	0f 88 87 00 00 00    	js     80105d2c <sys_exec+0xac>
80105ca5:	83 ec 08             	sub    $0x8,%esp
80105ca8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105cae:	50                   	push   %eax
80105caf:	6a 01                	push   $0x1
80105cb1:	e8 1a f4 ff ff       	call   801050d0 <argint>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	78 6f                	js     80105d2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105cbd:	83 ec 04             	sub    $0x4,%esp
80105cc0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105cc6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105cc8:	68 80 00 00 00       	push   $0x80
80105ccd:	6a 00                	push   $0x0
80105ccf:	56                   	push   %esi
80105cd0:	e8 3b f1 ff ff       	call   80104e10 <memset>
80105cd5:	83 c4 10             	add    $0x10,%esp
80105cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ce0:	83 ec 08             	sub    $0x8,%esp
80105ce3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ce9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105cf0:	50                   	push   %eax
80105cf1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105cf7:	01 f8                	add    %edi,%eax
80105cf9:	50                   	push   %eax
80105cfa:	e8 41 f3 ff ff       	call   80105040 <fetchint>
80105cff:	83 c4 10             	add    $0x10,%esp
80105d02:	85 c0                	test   %eax,%eax
80105d04:	78 26                	js     80105d2c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d06:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d0c:	85 c0                	test   %eax,%eax
80105d0e:	74 30                	je     80105d40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105d16:	52                   	push   %edx
80105d17:	50                   	push   %eax
80105d18:	e8 63 f3 ff ff       	call   80105080 <fetchstr>
80105d1d:	83 c4 10             	add    $0x10,%esp
80105d20:	85 c0                	test   %eax,%eax
80105d22:	78 08                	js     80105d2c <sys_exec+0xac>
  for(i=0;; i++){
80105d24:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d27:	83 fb 20             	cmp    $0x20,%ebx
80105d2a:	75 b4                	jne    80105ce0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105d40:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d47:	00 00 00 00 
  return exec(path, argv);
80105d4b:	83 ec 08             	sub    $0x8,%esp
80105d4e:	56                   	push   %esi
80105d4f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105d55:	e8 06 b5 ff ff       	call   80101260 <exec>
80105d5a:	83 c4 10             	add    $0x10,%esp
}
80105d5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d60:	5b                   	pop    %ebx
80105d61:	5e                   	pop    %esi
80105d62:	5f                   	pop    %edi
80105d63:	5d                   	pop    %ebp
80105d64:	c3                   	ret    
80105d65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_pipe>:

int
sys_pipe(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d75:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d78:	53                   	push   %ebx
80105d79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d7c:	6a 08                	push   $0x8
80105d7e:	50                   	push   %eax
80105d7f:	6a 00                	push   $0x0
80105d81:	e8 9a f3 ff ff       	call   80105120 <argptr>
80105d86:	83 c4 10             	add    $0x10,%esp
80105d89:	85 c0                	test   %eax,%eax
80105d8b:	78 4a                	js     80105dd7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d8d:	83 ec 08             	sub    $0x8,%esp
80105d90:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d93:	50                   	push   %eax
80105d94:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d97:	50                   	push   %eax
80105d98:	e8 43 de ff ff       	call   80103be0 <pipealloc>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	78 33                	js     80105dd7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105da4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105da7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105da9:	e8 72 e3 ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105db0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105db4:	85 f6                	test   %esi,%esi
80105db6:	74 28                	je     80105de0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105db8:	83 c3 01             	add    $0x1,%ebx
80105dbb:	83 fb 10             	cmp    $0x10,%ebx
80105dbe:	75 f0                	jne    80105db0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	ff 75 e0             	push   -0x20(%ebp)
80105dc6:	e8 d5 b8 ff ff       	call   801016a0 <fileclose>
    fileclose(wf);
80105dcb:	58                   	pop    %eax
80105dcc:	ff 75 e4             	push   -0x1c(%ebp)
80105dcf:	e8 cc b8 ff ff       	call   801016a0 <fileclose>
    return -1;
80105dd4:	83 c4 10             	add    $0x10,%esp
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddc:	eb 53                	jmp    80105e31 <sys_pipe+0xc1>
80105dde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105de0:	8d 73 08             	lea    0x8(%ebx),%esi
80105de3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105de7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105dea:	e8 31 e3 ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105def:	31 d2                	xor    %edx,%edx
80105df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105df8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105dfc:	85 c9                	test   %ecx,%ecx
80105dfe:	74 20                	je     80105e20 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e00:	83 c2 01             	add    $0x1,%edx
80105e03:	83 fa 10             	cmp    $0x10,%edx
80105e06:	75 f0                	jne    80105df8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e08:	e8 13 e3 ff ff       	call   80104120 <myproc>
80105e0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e14:	00 
80105e15:	eb a9                	jmp    80105dc0 <sys_pipe+0x50>
80105e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e2f:	31 c0                	xor    %eax,%eax
}
80105e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e34:	5b                   	pop    %ebx
80105e35:	5e                   	pop    %esi
80105e36:	5f                   	pop    %edi
80105e37:	5d                   	pop    %ebp
80105e38:	c3                   	ret    
80105e39:	66 90                	xchg   %ax,%ax
80105e3b:	66 90                	xchg   %ax,%ax
80105e3d:	66 90                	xchg   %ax,%ax
80105e3f:	90                   	nop

80105e40 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e40:	e9 7b e4 ff ff       	jmp    801042c0 <fork>
80105e45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e50 <sys_exit>:
}

int
sys_exit(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e56:	e8 e5 e6 ff ff       	call   80104540 <exit>
  return 0;  // not reached
}
80105e5b:	31 c0                	xor    %eax,%eax
80105e5d:	c9                   	leave  
80105e5e:	c3                   	ret    
80105e5f:	90                   	nop

80105e60 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105e60:	e9 0b e8 ff ff       	jmp    80104670 <wait>
80105e65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e70 <sys_kill>:
}

int
sys_kill(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e79:	50                   	push   %eax
80105e7a:	6a 00                	push   $0x0
80105e7c:	e8 4f f2 ff ff       	call   801050d0 <argint>
80105e81:	83 c4 10             	add    $0x10,%esp
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 18                	js     80105ea0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	ff 75 f4             	push   -0xc(%ebp)
80105e8e:	e8 7d ea ff ff       	call   80104910 <kill>
80105e93:	83 c4 10             	add    $0x10,%esp
}
80105e96:	c9                   	leave  
80105e97:	c3                   	ret    
80105e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop
80105ea0:	c9                   	leave  
    return -1;
80105ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ea6:	c3                   	ret    
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <sys_getpid>:

int
sys_getpid(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105eb6:	e8 65 e2 ff ff       	call   80104120 <myproc>
80105ebb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ebe:	c9                   	leave  
80105ebf:	c3                   	ret    

80105ec0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ec4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ec7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105eca:	50                   	push   %eax
80105ecb:	6a 00                	push   $0x0
80105ecd:	e8 fe f1 ff ff       	call   801050d0 <argint>
80105ed2:	83 c4 10             	add    $0x10,%esp
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	78 27                	js     80105f00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ed9:	e8 42 e2 ff ff       	call   80104120 <myproc>
  if(growproc(n) < 0)
80105ede:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ee1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ee3:	ff 75 f4             	push   -0xc(%ebp)
80105ee6:	e8 55 e3 ff ff       	call   80104240 <growproc>
80105eeb:	83 c4 10             	add    $0x10,%esp
80105eee:	85 c0                	test   %eax,%eax
80105ef0:	78 0e                	js     80105f00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ef2:	89 d8                	mov    %ebx,%eax
80105ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ef7:	c9                   	leave  
80105ef8:	c3                   	ret    
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f05:	eb eb                	jmp    80105ef2 <sys_sbrk+0x32>
80105f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_sleep>:

int
sys_sleep(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f1a:	50                   	push   %eax
80105f1b:	6a 00                	push   $0x0
80105f1d:	e8 ae f1 ff ff       	call   801050d0 <argint>
80105f22:	83 c4 10             	add    $0x10,%esp
80105f25:	85 c0                	test   %eax,%eax
80105f27:	0f 88 8a 00 00 00    	js     80105fb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f2d:	83 ec 0c             	sub    $0xc,%esp
80105f30:	68 a0 51 11 80       	push   $0x801151a0
80105f35:	e8 16 ee ff ff       	call   80104d50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f3d:	8b 1d 80 51 11 80    	mov    0x80115180,%ebx
  while(ticks - ticks0 < n){
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 d2                	test   %edx,%edx
80105f48:	75 27                	jne    80105f71 <sys_sleep+0x61>
80105f4a:	eb 54                	jmp    80105fa0 <sys_sleep+0x90>
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f50:	83 ec 08             	sub    $0x8,%esp
80105f53:	68 a0 51 11 80       	push   $0x801151a0
80105f58:	68 80 51 11 80       	push   $0x80115180
80105f5d:	e8 8e e8 ff ff       	call   801047f0 <sleep>
  while(ticks - ticks0 < n){
80105f62:	a1 80 51 11 80       	mov    0x80115180,%eax
80105f67:	83 c4 10             	add    $0x10,%esp
80105f6a:	29 d8                	sub    %ebx,%eax
80105f6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f6f:	73 2f                	jae    80105fa0 <sys_sleep+0x90>
    if(myproc()->killed){
80105f71:	e8 aa e1 ff ff       	call   80104120 <myproc>
80105f76:	8b 40 24             	mov    0x24(%eax),%eax
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	74 d3                	je     80105f50 <sys_sleep+0x40>
      release(&tickslock);
80105f7d:	83 ec 0c             	sub    $0xc,%esp
80105f80:	68 a0 51 11 80       	push   $0x801151a0
80105f85:	e8 66 ed ff ff       	call   80104cf0 <release>
  }
  release(&tickslock);
  return 0;
}
80105f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105fa0:	83 ec 0c             	sub    $0xc,%esp
80105fa3:	68 a0 51 11 80       	push   $0x801151a0
80105fa8:	e8 43 ed ff ff       	call   80104cf0 <release>
  return 0;
80105fad:	83 c4 10             	add    $0x10,%esp
80105fb0:	31 c0                	xor    %eax,%eax
}
80105fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fb5:	c9                   	leave  
80105fb6:	c3                   	ret    
    return -1;
80105fb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fbc:	eb f4                	jmp    80105fb2 <sys_sleep+0xa2>
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	53                   	push   %ebx
80105fc4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105fc7:	68 a0 51 11 80       	push   $0x801151a0
80105fcc:	e8 7f ed ff ff       	call   80104d50 <acquire>
  xticks = ticks;
80105fd1:	8b 1d 80 51 11 80    	mov    0x80115180,%ebx
  release(&tickslock);
80105fd7:	c7 04 24 a0 51 11 80 	movl   $0x801151a0,(%esp)
80105fde:	e8 0d ed ff ff       	call   80104cf0 <release>
  return xticks;
}
80105fe3:	89 d8                	mov    %ebx,%eax
80105fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe8:	c9                   	leave  
80105fe9:	c3                   	ret    

80105fea <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fea:	1e                   	push   %ds
  pushl %es
80105feb:	06                   	push   %es
  pushl %fs
80105fec:	0f a0                	push   %fs
  pushl %gs
80105fee:	0f a8                	push   %gs
  pushal
80105ff0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ff1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ff5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ff7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ff9:	54                   	push   %esp
  call trap
80105ffa:	e8 c1 00 00 00       	call   801060c0 <trap>
  addl $4, %esp
80105fff:	83 c4 04             	add    $0x4,%esp

80106002 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106002:	61                   	popa   
  popl %gs
80106003:	0f a9                	pop    %gs
  popl %fs
80106005:	0f a1                	pop    %fs
  popl %es
80106007:	07                   	pop    %es
  popl %ds
80106008:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106009:	83 c4 08             	add    $0x8,%esp
  iret
8010600c:	cf                   	iret   
8010600d:	66 90                	xchg   %ax,%ax
8010600f:	90                   	nop

80106010 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106010:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106011:	31 c0                	xor    %eax,%eax
{
80106013:	89 e5                	mov    %esp,%ebp
80106015:	83 ec 08             	sub    $0x8,%esp
80106018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106020:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106027:	c7 04 c5 e2 51 11 80 	movl   $0x8e000008,-0x7feeae1e(,%eax,8)
8010602e:	08 00 00 8e 
80106032:	66 89 14 c5 e0 51 11 	mov    %dx,-0x7feeae20(,%eax,8)
80106039:	80 
8010603a:	c1 ea 10             	shr    $0x10,%edx
8010603d:	66 89 14 c5 e6 51 11 	mov    %dx,-0x7feeae1a(,%eax,8)
80106044:	80 
  for(i = 0; i < 256; i++)
80106045:	83 c0 01             	add    $0x1,%eax
80106048:	3d 00 01 00 00       	cmp    $0x100,%eax
8010604d:	75 d1                	jne    80106020 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010604f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106052:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106057:	c7 05 e2 53 11 80 08 	movl   $0xef000008,0x801153e2
8010605e:	00 00 ef 
  initlock(&tickslock, "time");
80106061:	68 b9 80 10 80       	push   $0x801080b9
80106066:	68 a0 51 11 80       	push   $0x801151a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010606b:	66 a3 e0 53 11 80    	mov    %ax,0x801153e0
80106071:	c1 e8 10             	shr    $0x10,%eax
80106074:	66 a3 e6 53 11 80    	mov    %ax,0x801153e6
  initlock(&tickslock, "time");
8010607a:	e8 01 eb ff ff       	call   80104b80 <initlock>
}
8010607f:	83 c4 10             	add    $0x10,%esp
80106082:	c9                   	leave  
80106083:	c3                   	ret    
80106084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010608f:	90                   	nop

80106090 <idtinit>:

void
idtinit(void)
{
80106090:	55                   	push   %ebp
  pd[0] = size-1;
80106091:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106096:	89 e5                	mov    %esp,%ebp
80106098:	83 ec 10             	sub    $0x10,%esp
8010609b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010609f:	b8 e0 51 11 80       	mov    $0x801151e0,%eax
801060a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801060a8:	c1 e8 10             	shr    $0x10,%eax
801060ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801060b5:	c9                   	leave  
801060b6:	c3                   	ret    
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax

801060c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	57                   	push   %edi
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
801060c6:	83 ec 1c             	sub    $0x1c,%esp
801060c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801060cc:	8b 43 30             	mov    0x30(%ebx),%eax
801060cf:	83 f8 40             	cmp    $0x40,%eax
801060d2:	0f 84 68 01 00 00    	je     80106240 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060d8:	83 e8 20             	sub    $0x20,%eax
801060db:	83 f8 1f             	cmp    $0x1f,%eax
801060de:	0f 87 8c 00 00 00    	ja     80106170 <trap+0xb0>
801060e4:	ff 24 85 60 81 10 80 	jmp    *-0x7fef7ea0(,%eax,4)
801060eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801060f0:	e8 fb c8 ff ff       	call   801029f0 <ideintr>
    lapiceoi();
801060f5:	e8 c6 cf ff ff       	call   801030c0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060fa:	e8 21 e0 ff ff       	call   80104120 <myproc>
801060ff:	85 c0                	test   %eax,%eax
80106101:	74 1d                	je     80106120 <trap+0x60>
80106103:	e8 18 e0 ff ff       	call   80104120 <myproc>
80106108:	8b 50 24             	mov    0x24(%eax),%edx
8010610b:	85 d2                	test   %edx,%edx
8010610d:	74 11                	je     80106120 <trap+0x60>
8010610f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106113:	83 e0 03             	and    $0x3,%eax
80106116:	66 83 f8 03          	cmp    $0x3,%ax
8010611a:	0f 84 e8 01 00 00    	je     80106308 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106120:	e8 fb df ff ff       	call   80104120 <myproc>
80106125:	85 c0                	test   %eax,%eax
80106127:	74 0f                	je     80106138 <trap+0x78>
80106129:	e8 f2 df ff ff       	call   80104120 <myproc>
8010612e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106132:	0f 84 b8 00 00 00    	je     801061f0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106138:	e8 e3 df ff ff       	call   80104120 <myproc>
8010613d:	85 c0                	test   %eax,%eax
8010613f:	74 1d                	je     8010615e <trap+0x9e>
80106141:	e8 da df ff ff       	call   80104120 <myproc>
80106146:	8b 40 24             	mov    0x24(%eax),%eax
80106149:	85 c0                	test   %eax,%eax
8010614b:	74 11                	je     8010615e <trap+0x9e>
8010614d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106151:	83 e0 03             	and    $0x3,%eax
80106154:	66 83 f8 03          	cmp    $0x3,%ax
80106158:	0f 84 0f 01 00 00    	je     8010626d <trap+0x1ad>
    exit();
}
8010615e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106161:	5b                   	pop    %ebx
80106162:	5e                   	pop    %esi
80106163:	5f                   	pop    %edi
80106164:	5d                   	pop    %ebp
80106165:	c3                   	ret    
80106166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106170:	e8 ab df ff ff       	call   80104120 <myproc>
80106175:	8b 7b 38             	mov    0x38(%ebx),%edi
80106178:	85 c0                	test   %eax,%eax
8010617a:	0f 84 a2 01 00 00    	je     80106322 <trap+0x262>
80106180:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106184:	0f 84 98 01 00 00    	je     80106322 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010618a:	0f 20 d1             	mov    %cr2,%ecx
8010618d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106190:	e8 6b df ff ff       	call   80104100 <cpuid>
80106195:	8b 73 30             	mov    0x30(%ebx),%esi
80106198:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010619b:	8b 43 34             	mov    0x34(%ebx),%eax
8010619e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801061a1:	e8 7a df ff ff       	call   80104120 <myproc>
801061a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061a9:	e8 72 df ff ff       	call   80104120 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061b4:	51                   	push   %ecx
801061b5:	57                   	push   %edi
801061b6:	52                   	push   %edx
801061b7:	ff 75 e4             	push   -0x1c(%ebp)
801061ba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801061bb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801061be:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061c1:	56                   	push   %esi
801061c2:	ff 70 10             	push   0x10(%eax)
801061c5:	68 1c 81 10 80       	push   $0x8010811c
801061ca:	e8 b1 a6 ff ff       	call   80100880 <cprintf>
    myproc()->killed = 1;
801061cf:	83 c4 20             	add    $0x20,%esp
801061d2:	e8 49 df ff ff       	call   80104120 <myproc>
801061d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061de:	e8 3d df ff ff       	call   80104120 <myproc>
801061e3:	85 c0                	test   %eax,%eax
801061e5:	0f 85 18 ff ff ff    	jne    80106103 <trap+0x43>
801061eb:	e9 30 ff ff ff       	jmp    80106120 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801061f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801061f4:	0f 85 3e ff ff ff    	jne    80106138 <trap+0x78>
    yield();
801061fa:	e8 a1 e5 ff ff       	call   801047a0 <yield>
801061ff:	e9 34 ff ff ff       	jmp    80106138 <trap+0x78>
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106208:	8b 7b 38             	mov    0x38(%ebx),%edi
8010620b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010620f:	e8 ec de ff ff       	call   80104100 <cpuid>
80106214:	57                   	push   %edi
80106215:	56                   	push   %esi
80106216:	50                   	push   %eax
80106217:	68 c4 80 10 80       	push   $0x801080c4
8010621c:	e8 5f a6 ff ff       	call   80100880 <cprintf>
    lapiceoi();
80106221:	e8 9a ce ff ff       	call   801030c0 <lapiceoi>
    break;
80106226:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106229:	e8 f2 de ff ff       	call   80104120 <myproc>
8010622e:	85 c0                	test   %eax,%eax
80106230:	0f 85 cd fe ff ff    	jne    80106103 <trap+0x43>
80106236:	e9 e5 fe ff ff       	jmp    80106120 <trap+0x60>
8010623b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010623f:	90                   	nop
    if(myproc()->killed)
80106240:	e8 db de ff ff       	call   80104120 <myproc>
80106245:	8b 70 24             	mov    0x24(%eax),%esi
80106248:	85 f6                	test   %esi,%esi
8010624a:	0f 85 c8 00 00 00    	jne    80106318 <trap+0x258>
    myproc()->tf = tf;
80106250:	e8 cb de ff ff       	call   80104120 <myproc>
80106255:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106258:	e8 b3 ef ff ff       	call   80105210 <syscall>
    if(myproc()->killed)
8010625d:	e8 be de ff ff       	call   80104120 <myproc>
80106262:	8b 48 24             	mov    0x24(%eax),%ecx
80106265:	85 c9                	test   %ecx,%ecx
80106267:	0f 84 f1 fe ff ff    	je     8010615e <trap+0x9e>
}
8010626d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106270:	5b                   	pop    %ebx
80106271:	5e                   	pop    %esi
80106272:	5f                   	pop    %edi
80106273:	5d                   	pop    %ebp
      exit();
80106274:	e9 c7 e2 ff ff       	jmp    80104540 <exit>
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106280:	e8 3b 02 00 00       	call   801064c0 <uartintr>
    lapiceoi();
80106285:	e8 36 ce ff ff       	call   801030c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010628a:	e8 91 de ff ff       	call   80104120 <myproc>
8010628f:	85 c0                	test   %eax,%eax
80106291:	0f 85 6c fe ff ff    	jne    80106103 <trap+0x43>
80106297:	e9 84 fe ff ff       	jmp    80106120 <trap+0x60>
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801062a0:	e8 db cc ff ff       	call   80102f80 <kbdintr>
    lapiceoi();
801062a5:	e8 16 ce ff ff       	call   801030c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062aa:	e8 71 de ff ff       	call   80104120 <myproc>
801062af:	85 c0                	test   %eax,%eax
801062b1:	0f 85 4c fe ff ff    	jne    80106103 <trap+0x43>
801062b7:	e9 64 fe ff ff       	jmp    80106120 <trap+0x60>
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801062c0:	e8 3b de ff ff       	call   80104100 <cpuid>
801062c5:	85 c0                	test   %eax,%eax
801062c7:	0f 85 28 fe ff ff    	jne    801060f5 <trap+0x35>
      acquire(&tickslock);
801062cd:	83 ec 0c             	sub    $0xc,%esp
801062d0:	68 a0 51 11 80       	push   $0x801151a0
801062d5:	e8 76 ea ff ff       	call   80104d50 <acquire>
      wakeup(&ticks);
801062da:	c7 04 24 80 51 11 80 	movl   $0x80115180,(%esp)
      ticks++;
801062e1:	83 05 80 51 11 80 01 	addl   $0x1,0x80115180
      wakeup(&ticks);
801062e8:	e8 c3 e5 ff ff       	call   801048b0 <wakeup>
      release(&tickslock);
801062ed:	c7 04 24 a0 51 11 80 	movl   $0x801151a0,(%esp)
801062f4:	e8 f7 e9 ff ff       	call   80104cf0 <release>
801062f9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062fc:	e9 f4 fd ff ff       	jmp    801060f5 <trap+0x35>
80106301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106308:	e8 33 e2 ff ff       	call   80104540 <exit>
8010630d:	e9 0e fe ff ff       	jmp    80106120 <trap+0x60>
80106312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106318:	e8 23 e2 ff ff       	call   80104540 <exit>
8010631d:	e9 2e ff ff ff       	jmp    80106250 <trap+0x190>
80106322:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106325:	e8 d6 dd ff ff       	call   80104100 <cpuid>
8010632a:	83 ec 0c             	sub    $0xc,%esp
8010632d:	56                   	push   %esi
8010632e:	57                   	push   %edi
8010632f:	50                   	push   %eax
80106330:	ff 73 30             	push   0x30(%ebx)
80106333:	68 e8 80 10 80       	push   $0x801080e8
80106338:	e8 43 a5 ff ff       	call   80100880 <cprintf>
      panic("trap");
8010633d:	83 c4 14             	add    $0x14,%esp
80106340:	68 be 80 10 80       	push   $0x801080be
80106345:	e8 06 a1 ff ff       	call   80100450 <panic>
8010634a:	66 90                	xchg   %ax,%ax
8010634c:	66 90                	xchg   %ax,%ax
8010634e:	66 90                	xchg   %ax,%ax

80106350 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106350:	a1 e0 59 11 80       	mov    0x801159e0,%eax
80106355:	85 c0                	test   %eax,%eax
80106357:	74 17                	je     80106370 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106359:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010635e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010635f:	a8 01                	test   $0x1,%al
80106361:	74 0d                	je     80106370 <uartgetc+0x20>
80106363:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106368:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106369:	0f b6 c0             	movzbl %al,%eax
8010636c:	c3                   	ret    
8010636d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106375:	c3                   	ret    
80106376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010637d:	8d 76 00             	lea    0x0(%esi),%esi

80106380 <uartinit>:
{
80106380:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106381:	31 c9                	xor    %ecx,%ecx
80106383:	89 c8                	mov    %ecx,%eax
80106385:	89 e5                	mov    %esp,%ebp
80106387:	57                   	push   %edi
80106388:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010638d:	56                   	push   %esi
8010638e:	89 fa                	mov    %edi,%edx
80106390:	53                   	push   %ebx
80106391:	83 ec 1c             	sub    $0x1c,%esp
80106394:	ee                   	out    %al,(%dx)
80106395:	be fb 03 00 00       	mov    $0x3fb,%esi
8010639a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010639f:	89 f2                	mov    %esi,%edx
801063a1:	ee                   	out    %al,(%dx)
801063a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801063a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ac:	ee                   	out    %al,(%dx)
801063ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801063b2:	89 c8                	mov    %ecx,%eax
801063b4:	89 da                	mov    %ebx,%edx
801063b6:	ee                   	out    %al,(%dx)
801063b7:	b8 03 00 00 00       	mov    $0x3,%eax
801063bc:	89 f2                	mov    %esi,%edx
801063be:	ee                   	out    %al,(%dx)
801063bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063c4:	89 c8                	mov    %ecx,%eax
801063c6:	ee                   	out    %al,(%dx)
801063c7:	b8 01 00 00 00       	mov    $0x1,%eax
801063cc:	89 da                	mov    %ebx,%edx
801063ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063d5:	3c ff                	cmp    $0xff,%al
801063d7:	74 78                	je     80106451 <uartinit+0xd1>
  uart = 1;
801063d9:	c7 05 e0 59 11 80 01 	movl   $0x1,0x801159e0
801063e0:	00 00 00 
801063e3:	89 fa                	mov    %edi,%edx
801063e5:	ec                   	in     (%dx),%al
801063e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801063ef:	bf e0 81 10 80       	mov    $0x801081e0,%edi
801063f4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801063f9:	6a 00                	push   $0x0
801063fb:	6a 04                	push   $0x4
801063fd:	e8 2e c8 ff ff       	call   80102c30 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106402:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106406:	83 c4 10             	add    $0x10,%esp
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106410:	a1 e0 59 11 80       	mov    0x801159e0,%eax
80106415:	bb 80 00 00 00       	mov    $0x80,%ebx
8010641a:	85 c0                	test   %eax,%eax
8010641c:	75 14                	jne    80106432 <uartinit+0xb2>
8010641e:	eb 23                	jmp    80106443 <uartinit+0xc3>
    microdelay(10);
80106420:	83 ec 0c             	sub    $0xc,%esp
80106423:	6a 0a                	push   $0xa
80106425:	e8 b6 cc ff ff       	call   801030e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	83 eb 01             	sub    $0x1,%ebx
80106430:	74 07                	je     80106439 <uartinit+0xb9>
80106432:	89 f2                	mov    %esi,%edx
80106434:	ec                   	in     (%dx),%al
80106435:	a8 20                	test   $0x20,%al
80106437:	74 e7                	je     80106420 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106439:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010643d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106442:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106443:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106447:	83 c7 01             	add    $0x1,%edi
8010644a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010644d:	84 c0                	test   %al,%al
8010644f:	75 bf                	jne    80106410 <uartinit+0x90>
}
80106451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106454:	5b                   	pop    %ebx
80106455:	5e                   	pop    %esi
80106456:	5f                   	pop    %edi
80106457:	5d                   	pop    %ebp
80106458:	c3                   	ret    
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <uartputc>:
  if(!uart)
80106460:	a1 e0 59 11 80       	mov    0x801159e0,%eax
80106465:	85 c0                	test   %eax,%eax
80106467:	74 47                	je     801064b0 <uartputc+0x50>
{
80106469:	55                   	push   %ebp
8010646a:	89 e5                	mov    %esp,%ebp
8010646c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010646d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106472:	53                   	push   %ebx
80106473:	bb 80 00 00 00       	mov    $0x80,%ebx
80106478:	eb 18                	jmp    80106492 <uartputc+0x32>
8010647a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	6a 0a                	push   $0xa
80106485:	e8 56 cc ff ff       	call   801030e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010648a:	83 c4 10             	add    $0x10,%esp
8010648d:	83 eb 01             	sub    $0x1,%ebx
80106490:	74 07                	je     80106499 <uartputc+0x39>
80106492:	89 f2                	mov    %esi,%edx
80106494:	ec                   	in     (%dx),%al
80106495:	a8 20                	test   $0x20,%al
80106497:	74 e7                	je     80106480 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106499:	8b 45 08             	mov    0x8(%ebp),%eax
8010649c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064a1:	ee                   	out    %al,(%dx)
}
801064a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064a5:	5b                   	pop    %ebx
801064a6:	5e                   	pop    %esi
801064a7:	5d                   	pop    %ebp
801064a8:	c3                   	ret    
801064a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064b0:	c3                   	ret    
801064b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064bf:	90                   	nop

801064c0 <uartintr>:

void
uartintr(void)
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801064c6:	68 50 63 10 80       	push   $0x80106350
801064cb:	e8 f0 a7 ff ff       	call   80100cc0 <consoleintr>
}
801064d0:	83 c4 10             	add    $0x10,%esp
801064d3:	c9                   	leave  
801064d4:	c3                   	ret    

801064d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $0
801064d7:	6a 00                	push   $0x0
  jmp alltraps
801064d9:	e9 0c fb ff ff       	jmp    80105fea <alltraps>

801064de <vector1>:
.globl vector1
vector1:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $1
801064e0:	6a 01                	push   $0x1
  jmp alltraps
801064e2:	e9 03 fb ff ff       	jmp    80105fea <alltraps>

801064e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $2
801064e9:	6a 02                	push   $0x2
  jmp alltraps
801064eb:	e9 fa fa ff ff       	jmp    80105fea <alltraps>

801064f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $3
801064f2:	6a 03                	push   $0x3
  jmp alltraps
801064f4:	e9 f1 fa ff ff       	jmp    80105fea <alltraps>

801064f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $4
801064fb:	6a 04                	push   $0x4
  jmp alltraps
801064fd:	e9 e8 fa ff ff       	jmp    80105fea <alltraps>

80106502 <vector5>:
.globl vector5
vector5:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $5
80106504:	6a 05                	push   $0x5
  jmp alltraps
80106506:	e9 df fa ff ff       	jmp    80105fea <alltraps>

8010650b <vector6>:
.globl vector6
vector6:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $6
8010650d:	6a 06                	push   $0x6
  jmp alltraps
8010650f:	e9 d6 fa ff ff       	jmp    80105fea <alltraps>

80106514 <vector7>:
.globl vector7
vector7:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $7
80106516:	6a 07                	push   $0x7
  jmp alltraps
80106518:	e9 cd fa ff ff       	jmp    80105fea <alltraps>

8010651d <vector8>:
.globl vector8
vector8:
  pushl $8
8010651d:	6a 08                	push   $0x8
  jmp alltraps
8010651f:	e9 c6 fa ff ff       	jmp    80105fea <alltraps>

80106524 <vector9>:
.globl vector9
vector9:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $9
80106526:	6a 09                	push   $0x9
  jmp alltraps
80106528:	e9 bd fa ff ff       	jmp    80105fea <alltraps>

8010652d <vector10>:
.globl vector10
vector10:
  pushl $10
8010652d:	6a 0a                	push   $0xa
  jmp alltraps
8010652f:	e9 b6 fa ff ff       	jmp    80105fea <alltraps>

80106534 <vector11>:
.globl vector11
vector11:
  pushl $11
80106534:	6a 0b                	push   $0xb
  jmp alltraps
80106536:	e9 af fa ff ff       	jmp    80105fea <alltraps>

8010653b <vector12>:
.globl vector12
vector12:
  pushl $12
8010653b:	6a 0c                	push   $0xc
  jmp alltraps
8010653d:	e9 a8 fa ff ff       	jmp    80105fea <alltraps>

80106542 <vector13>:
.globl vector13
vector13:
  pushl $13
80106542:	6a 0d                	push   $0xd
  jmp alltraps
80106544:	e9 a1 fa ff ff       	jmp    80105fea <alltraps>

80106549 <vector14>:
.globl vector14
vector14:
  pushl $14
80106549:	6a 0e                	push   $0xe
  jmp alltraps
8010654b:	e9 9a fa ff ff       	jmp    80105fea <alltraps>

80106550 <vector15>:
.globl vector15
vector15:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $15
80106552:	6a 0f                	push   $0xf
  jmp alltraps
80106554:	e9 91 fa ff ff       	jmp    80105fea <alltraps>

80106559 <vector16>:
.globl vector16
vector16:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $16
8010655b:	6a 10                	push   $0x10
  jmp alltraps
8010655d:	e9 88 fa ff ff       	jmp    80105fea <alltraps>

80106562 <vector17>:
.globl vector17
vector17:
  pushl $17
80106562:	6a 11                	push   $0x11
  jmp alltraps
80106564:	e9 81 fa ff ff       	jmp    80105fea <alltraps>

80106569 <vector18>:
.globl vector18
vector18:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $18
8010656b:	6a 12                	push   $0x12
  jmp alltraps
8010656d:	e9 78 fa ff ff       	jmp    80105fea <alltraps>

80106572 <vector19>:
.globl vector19
vector19:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $19
80106574:	6a 13                	push   $0x13
  jmp alltraps
80106576:	e9 6f fa ff ff       	jmp    80105fea <alltraps>

8010657b <vector20>:
.globl vector20
vector20:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $20
8010657d:	6a 14                	push   $0x14
  jmp alltraps
8010657f:	e9 66 fa ff ff       	jmp    80105fea <alltraps>

80106584 <vector21>:
.globl vector21
vector21:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $21
80106586:	6a 15                	push   $0x15
  jmp alltraps
80106588:	e9 5d fa ff ff       	jmp    80105fea <alltraps>

8010658d <vector22>:
.globl vector22
vector22:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $22
8010658f:	6a 16                	push   $0x16
  jmp alltraps
80106591:	e9 54 fa ff ff       	jmp    80105fea <alltraps>

80106596 <vector23>:
.globl vector23
vector23:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $23
80106598:	6a 17                	push   $0x17
  jmp alltraps
8010659a:	e9 4b fa ff ff       	jmp    80105fea <alltraps>

8010659f <vector24>:
.globl vector24
vector24:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $24
801065a1:	6a 18                	push   $0x18
  jmp alltraps
801065a3:	e9 42 fa ff ff       	jmp    80105fea <alltraps>

801065a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $25
801065aa:	6a 19                	push   $0x19
  jmp alltraps
801065ac:	e9 39 fa ff ff       	jmp    80105fea <alltraps>

801065b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $26
801065b3:	6a 1a                	push   $0x1a
  jmp alltraps
801065b5:	e9 30 fa ff ff       	jmp    80105fea <alltraps>

801065ba <vector27>:
.globl vector27
vector27:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $27
801065bc:	6a 1b                	push   $0x1b
  jmp alltraps
801065be:	e9 27 fa ff ff       	jmp    80105fea <alltraps>

801065c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $28
801065c5:	6a 1c                	push   $0x1c
  jmp alltraps
801065c7:	e9 1e fa ff ff       	jmp    80105fea <alltraps>

801065cc <vector29>:
.globl vector29
vector29:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $29
801065ce:	6a 1d                	push   $0x1d
  jmp alltraps
801065d0:	e9 15 fa ff ff       	jmp    80105fea <alltraps>

801065d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $30
801065d7:	6a 1e                	push   $0x1e
  jmp alltraps
801065d9:	e9 0c fa ff ff       	jmp    80105fea <alltraps>

801065de <vector31>:
.globl vector31
vector31:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $31
801065e0:	6a 1f                	push   $0x1f
  jmp alltraps
801065e2:	e9 03 fa ff ff       	jmp    80105fea <alltraps>

801065e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $32
801065e9:	6a 20                	push   $0x20
  jmp alltraps
801065eb:	e9 fa f9 ff ff       	jmp    80105fea <alltraps>

801065f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $33
801065f2:	6a 21                	push   $0x21
  jmp alltraps
801065f4:	e9 f1 f9 ff ff       	jmp    80105fea <alltraps>

801065f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $34
801065fb:	6a 22                	push   $0x22
  jmp alltraps
801065fd:	e9 e8 f9 ff ff       	jmp    80105fea <alltraps>

80106602 <vector35>:
.globl vector35
vector35:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $35
80106604:	6a 23                	push   $0x23
  jmp alltraps
80106606:	e9 df f9 ff ff       	jmp    80105fea <alltraps>

8010660b <vector36>:
.globl vector36
vector36:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $36
8010660d:	6a 24                	push   $0x24
  jmp alltraps
8010660f:	e9 d6 f9 ff ff       	jmp    80105fea <alltraps>

80106614 <vector37>:
.globl vector37
vector37:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $37
80106616:	6a 25                	push   $0x25
  jmp alltraps
80106618:	e9 cd f9 ff ff       	jmp    80105fea <alltraps>

8010661d <vector38>:
.globl vector38
vector38:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $38
8010661f:	6a 26                	push   $0x26
  jmp alltraps
80106621:	e9 c4 f9 ff ff       	jmp    80105fea <alltraps>

80106626 <vector39>:
.globl vector39
vector39:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $39
80106628:	6a 27                	push   $0x27
  jmp alltraps
8010662a:	e9 bb f9 ff ff       	jmp    80105fea <alltraps>

8010662f <vector40>:
.globl vector40
vector40:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $40
80106631:	6a 28                	push   $0x28
  jmp alltraps
80106633:	e9 b2 f9 ff ff       	jmp    80105fea <alltraps>

80106638 <vector41>:
.globl vector41
vector41:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $41
8010663a:	6a 29                	push   $0x29
  jmp alltraps
8010663c:	e9 a9 f9 ff ff       	jmp    80105fea <alltraps>

80106641 <vector42>:
.globl vector42
vector42:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $42
80106643:	6a 2a                	push   $0x2a
  jmp alltraps
80106645:	e9 a0 f9 ff ff       	jmp    80105fea <alltraps>

8010664a <vector43>:
.globl vector43
vector43:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $43
8010664c:	6a 2b                	push   $0x2b
  jmp alltraps
8010664e:	e9 97 f9 ff ff       	jmp    80105fea <alltraps>

80106653 <vector44>:
.globl vector44
vector44:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $44
80106655:	6a 2c                	push   $0x2c
  jmp alltraps
80106657:	e9 8e f9 ff ff       	jmp    80105fea <alltraps>

8010665c <vector45>:
.globl vector45
vector45:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $45
8010665e:	6a 2d                	push   $0x2d
  jmp alltraps
80106660:	e9 85 f9 ff ff       	jmp    80105fea <alltraps>

80106665 <vector46>:
.globl vector46
vector46:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $46
80106667:	6a 2e                	push   $0x2e
  jmp alltraps
80106669:	e9 7c f9 ff ff       	jmp    80105fea <alltraps>

8010666e <vector47>:
.globl vector47
vector47:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $47
80106670:	6a 2f                	push   $0x2f
  jmp alltraps
80106672:	e9 73 f9 ff ff       	jmp    80105fea <alltraps>

80106677 <vector48>:
.globl vector48
vector48:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $48
80106679:	6a 30                	push   $0x30
  jmp alltraps
8010667b:	e9 6a f9 ff ff       	jmp    80105fea <alltraps>

80106680 <vector49>:
.globl vector49
vector49:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $49
80106682:	6a 31                	push   $0x31
  jmp alltraps
80106684:	e9 61 f9 ff ff       	jmp    80105fea <alltraps>

80106689 <vector50>:
.globl vector50
vector50:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $50
8010668b:	6a 32                	push   $0x32
  jmp alltraps
8010668d:	e9 58 f9 ff ff       	jmp    80105fea <alltraps>

80106692 <vector51>:
.globl vector51
vector51:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $51
80106694:	6a 33                	push   $0x33
  jmp alltraps
80106696:	e9 4f f9 ff ff       	jmp    80105fea <alltraps>

8010669b <vector52>:
.globl vector52
vector52:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $52
8010669d:	6a 34                	push   $0x34
  jmp alltraps
8010669f:	e9 46 f9 ff ff       	jmp    80105fea <alltraps>

801066a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $53
801066a6:	6a 35                	push   $0x35
  jmp alltraps
801066a8:	e9 3d f9 ff ff       	jmp    80105fea <alltraps>

801066ad <vector54>:
.globl vector54
vector54:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $54
801066af:	6a 36                	push   $0x36
  jmp alltraps
801066b1:	e9 34 f9 ff ff       	jmp    80105fea <alltraps>

801066b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $55
801066b8:	6a 37                	push   $0x37
  jmp alltraps
801066ba:	e9 2b f9 ff ff       	jmp    80105fea <alltraps>

801066bf <vector56>:
.globl vector56
vector56:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $56
801066c1:	6a 38                	push   $0x38
  jmp alltraps
801066c3:	e9 22 f9 ff ff       	jmp    80105fea <alltraps>

801066c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $57
801066ca:	6a 39                	push   $0x39
  jmp alltraps
801066cc:	e9 19 f9 ff ff       	jmp    80105fea <alltraps>

801066d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $58
801066d3:	6a 3a                	push   $0x3a
  jmp alltraps
801066d5:	e9 10 f9 ff ff       	jmp    80105fea <alltraps>

801066da <vector59>:
.globl vector59
vector59:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $59
801066dc:	6a 3b                	push   $0x3b
  jmp alltraps
801066de:	e9 07 f9 ff ff       	jmp    80105fea <alltraps>

801066e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $60
801066e5:	6a 3c                	push   $0x3c
  jmp alltraps
801066e7:	e9 fe f8 ff ff       	jmp    80105fea <alltraps>

801066ec <vector61>:
.globl vector61
vector61:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $61
801066ee:	6a 3d                	push   $0x3d
  jmp alltraps
801066f0:	e9 f5 f8 ff ff       	jmp    80105fea <alltraps>

801066f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $62
801066f7:	6a 3e                	push   $0x3e
  jmp alltraps
801066f9:	e9 ec f8 ff ff       	jmp    80105fea <alltraps>

801066fe <vector63>:
.globl vector63
vector63:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $63
80106700:	6a 3f                	push   $0x3f
  jmp alltraps
80106702:	e9 e3 f8 ff ff       	jmp    80105fea <alltraps>

80106707 <vector64>:
.globl vector64
vector64:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $64
80106709:	6a 40                	push   $0x40
  jmp alltraps
8010670b:	e9 da f8 ff ff       	jmp    80105fea <alltraps>

80106710 <vector65>:
.globl vector65
vector65:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $65
80106712:	6a 41                	push   $0x41
  jmp alltraps
80106714:	e9 d1 f8 ff ff       	jmp    80105fea <alltraps>

80106719 <vector66>:
.globl vector66
vector66:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $66
8010671b:	6a 42                	push   $0x42
  jmp alltraps
8010671d:	e9 c8 f8 ff ff       	jmp    80105fea <alltraps>

80106722 <vector67>:
.globl vector67
vector67:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $67
80106724:	6a 43                	push   $0x43
  jmp alltraps
80106726:	e9 bf f8 ff ff       	jmp    80105fea <alltraps>

8010672b <vector68>:
.globl vector68
vector68:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $68
8010672d:	6a 44                	push   $0x44
  jmp alltraps
8010672f:	e9 b6 f8 ff ff       	jmp    80105fea <alltraps>

80106734 <vector69>:
.globl vector69
vector69:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $69
80106736:	6a 45                	push   $0x45
  jmp alltraps
80106738:	e9 ad f8 ff ff       	jmp    80105fea <alltraps>

8010673d <vector70>:
.globl vector70
vector70:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $70
8010673f:	6a 46                	push   $0x46
  jmp alltraps
80106741:	e9 a4 f8 ff ff       	jmp    80105fea <alltraps>

80106746 <vector71>:
.globl vector71
vector71:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $71
80106748:	6a 47                	push   $0x47
  jmp alltraps
8010674a:	e9 9b f8 ff ff       	jmp    80105fea <alltraps>

8010674f <vector72>:
.globl vector72
vector72:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $72
80106751:	6a 48                	push   $0x48
  jmp alltraps
80106753:	e9 92 f8 ff ff       	jmp    80105fea <alltraps>

80106758 <vector73>:
.globl vector73
vector73:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $73
8010675a:	6a 49                	push   $0x49
  jmp alltraps
8010675c:	e9 89 f8 ff ff       	jmp    80105fea <alltraps>

80106761 <vector74>:
.globl vector74
vector74:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $74
80106763:	6a 4a                	push   $0x4a
  jmp alltraps
80106765:	e9 80 f8 ff ff       	jmp    80105fea <alltraps>

8010676a <vector75>:
.globl vector75
vector75:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $75
8010676c:	6a 4b                	push   $0x4b
  jmp alltraps
8010676e:	e9 77 f8 ff ff       	jmp    80105fea <alltraps>

80106773 <vector76>:
.globl vector76
vector76:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $76
80106775:	6a 4c                	push   $0x4c
  jmp alltraps
80106777:	e9 6e f8 ff ff       	jmp    80105fea <alltraps>

8010677c <vector77>:
.globl vector77
vector77:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $77
8010677e:	6a 4d                	push   $0x4d
  jmp alltraps
80106780:	e9 65 f8 ff ff       	jmp    80105fea <alltraps>

80106785 <vector78>:
.globl vector78
vector78:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $78
80106787:	6a 4e                	push   $0x4e
  jmp alltraps
80106789:	e9 5c f8 ff ff       	jmp    80105fea <alltraps>

8010678e <vector79>:
.globl vector79
vector79:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $79
80106790:	6a 4f                	push   $0x4f
  jmp alltraps
80106792:	e9 53 f8 ff ff       	jmp    80105fea <alltraps>

80106797 <vector80>:
.globl vector80
vector80:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $80
80106799:	6a 50                	push   $0x50
  jmp alltraps
8010679b:	e9 4a f8 ff ff       	jmp    80105fea <alltraps>

801067a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $81
801067a2:	6a 51                	push   $0x51
  jmp alltraps
801067a4:	e9 41 f8 ff ff       	jmp    80105fea <alltraps>

801067a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $82
801067ab:	6a 52                	push   $0x52
  jmp alltraps
801067ad:	e9 38 f8 ff ff       	jmp    80105fea <alltraps>

801067b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $83
801067b4:	6a 53                	push   $0x53
  jmp alltraps
801067b6:	e9 2f f8 ff ff       	jmp    80105fea <alltraps>

801067bb <vector84>:
.globl vector84
vector84:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $84
801067bd:	6a 54                	push   $0x54
  jmp alltraps
801067bf:	e9 26 f8 ff ff       	jmp    80105fea <alltraps>

801067c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $85
801067c6:	6a 55                	push   $0x55
  jmp alltraps
801067c8:	e9 1d f8 ff ff       	jmp    80105fea <alltraps>

801067cd <vector86>:
.globl vector86
vector86:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $86
801067cf:	6a 56                	push   $0x56
  jmp alltraps
801067d1:	e9 14 f8 ff ff       	jmp    80105fea <alltraps>

801067d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $87
801067d8:	6a 57                	push   $0x57
  jmp alltraps
801067da:	e9 0b f8 ff ff       	jmp    80105fea <alltraps>

801067df <vector88>:
.globl vector88
vector88:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $88
801067e1:	6a 58                	push   $0x58
  jmp alltraps
801067e3:	e9 02 f8 ff ff       	jmp    80105fea <alltraps>

801067e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $89
801067ea:	6a 59                	push   $0x59
  jmp alltraps
801067ec:	e9 f9 f7 ff ff       	jmp    80105fea <alltraps>

801067f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $90
801067f3:	6a 5a                	push   $0x5a
  jmp alltraps
801067f5:	e9 f0 f7 ff ff       	jmp    80105fea <alltraps>

801067fa <vector91>:
.globl vector91
vector91:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $91
801067fc:	6a 5b                	push   $0x5b
  jmp alltraps
801067fe:	e9 e7 f7 ff ff       	jmp    80105fea <alltraps>

80106803 <vector92>:
.globl vector92
vector92:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $92
80106805:	6a 5c                	push   $0x5c
  jmp alltraps
80106807:	e9 de f7 ff ff       	jmp    80105fea <alltraps>

8010680c <vector93>:
.globl vector93
vector93:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $93
8010680e:	6a 5d                	push   $0x5d
  jmp alltraps
80106810:	e9 d5 f7 ff ff       	jmp    80105fea <alltraps>

80106815 <vector94>:
.globl vector94
vector94:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $94
80106817:	6a 5e                	push   $0x5e
  jmp alltraps
80106819:	e9 cc f7 ff ff       	jmp    80105fea <alltraps>

8010681e <vector95>:
.globl vector95
vector95:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $95
80106820:	6a 5f                	push   $0x5f
  jmp alltraps
80106822:	e9 c3 f7 ff ff       	jmp    80105fea <alltraps>

80106827 <vector96>:
.globl vector96
vector96:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $96
80106829:	6a 60                	push   $0x60
  jmp alltraps
8010682b:	e9 ba f7 ff ff       	jmp    80105fea <alltraps>

80106830 <vector97>:
.globl vector97
vector97:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $97
80106832:	6a 61                	push   $0x61
  jmp alltraps
80106834:	e9 b1 f7 ff ff       	jmp    80105fea <alltraps>

80106839 <vector98>:
.globl vector98
vector98:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $98
8010683b:	6a 62                	push   $0x62
  jmp alltraps
8010683d:	e9 a8 f7 ff ff       	jmp    80105fea <alltraps>

80106842 <vector99>:
.globl vector99
vector99:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $99
80106844:	6a 63                	push   $0x63
  jmp alltraps
80106846:	e9 9f f7 ff ff       	jmp    80105fea <alltraps>

8010684b <vector100>:
.globl vector100
vector100:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $100
8010684d:	6a 64                	push   $0x64
  jmp alltraps
8010684f:	e9 96 f7 ff ff       	jmp    80105fea <alltraps>

80106854 <vector101>:
.globl vector101
vector101:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $101
80106856:	6a 65                	push   $0x65
  jmp alltraps
80106858:	e9 8d f7 ff ff       	jmp    80105fea <alltraps>

8010685d <vector102>:
.globl vector102
vector102:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $102
8010685f:	6a 66                	push   $0x66
  jmp alltraps
80106861:	e9 84 f7 ff ff       	jmp    80105fea <alltraps>

80106866 <vector103>:
.globl vector103
vector103:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $103
80106868:	6a 67                	push   $0x67
  jmp alltraps
8010686a:	e9 7b f7 ff ff       	jmp    80105fea <alltraps>

8010686f <vector104>:
.globl vector104
vector104:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $104
80106871:	6a 68                	push   $0x68
  jmp alltraps
80106873:	e9 72 f7 ff ff       	jmp    80105fea <alltraps>

80106878 <vector105>:
.globl vector105
vector105:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $105
8010687a:	6a 69                	push   $0x69
  jmp alltraps
8010687c:	e9 69 f7 ff ff       	jmp    80105fea <alltraps>

80106881 <vector106>:
.globl vector106
vector106:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $106
80106883:	6a 6a                	push   $0x6a
  jmp alltraps
80106885:	e9 60 f7 ff ff       	jmp    80105fea <alltraps>

8010688a <vector107>:
.globl vector107
vector107:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $107
8010688c:	6a 6b                	push   $0x6b
  jmp alltraps
8010688e:	e9 57 f7 ff ff       	jmp    80105fea <alltraps>

80106893 <vector108>:
.globl vector108
vector108:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $108
80106895:	6a 6c                	push   $0x6c
  jmp alltraps
80106897:	e9 4e f7 ff ff       	jmp    80105fea <alltraps>

8010689c <vector109>:
.globl vector109
vector109:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $109
8010689e:	6a 6d                	push   $0x6d
  jmp alltraps
801068a0:	e9 45 f7 ff ff       	jmp    80105fea <alltraps>

801068a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $110
801068a7:	6a 6e                	push   $0x6e
  jmp alltraps
801068a9:	e9 3c f7 ff ff       	jmp    80105fea <alltraps>

801068ae <vector111>:
.globl vector111
vector111:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $111
801068b0:	6a 6f                	push   $0x6f
  jmp alltraps
801068b2:	e9 33 f7 ff ff       	jmp    80105fea <alltraps>

801068b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $112
801068b9:	6a 70                	push   $0x70
  jmp alltraps
801068bb:	e9 2a f7 ff ff       	jmp    80105fea <alltraps>

801068c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $113
801068c2:	6a 71                	push   $0x71
  jmp alltraps
801068c4:	e9 21 f7 ff ff       	jmp    80105fea <alltraps>

801068c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $114
801068cb:	6a 72                	push   $0x72
  jmp alltraps
801068cd:	e9 18 f7 ff ff       	jmp    80105fea <alltraps>

801068d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $115
801068d4:	6a 73                	push   $0x73
  jmp alltraps
801068d6:	e9 0f f7 ff ff       	jmp    80105fea <alltraps>

801068db <vector116>:
.globl vector116
vector116:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $116
801068dd:	6a 74                	push   $0x74
  jmp alltraps
801068df:	e9 06 f7 ff ff       	jmp    80105fea <alltraps>

801068e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $117
801068e6:	6a 75                	push   $0x75
  jmp alltraps
801068e8:	e9 fd f6 ff ff       	jmp    80105fea <alltraps>

801068ed <vector118>:
.globl vector118
vector118:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $118
801068ef:	6a 76                	push   $0x76
  jmp alltraps
801068f1:	e9 f4 f6 ff ff       	jmp    80105fea <alltraps>

801068f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $119
801068f8:	6a 77                	push   $0x77
  jmp alltraps
801068fa:	e9 eb f6 ff ff       	jmp    80105fea <alltraps>

801068ff <vector120>:
.globl vector120
vector120:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $120
80106901:	6a 78                	push   $0x78
  jmp alltraps
80106903:	e9 e2 f6 ff ff       	jmp    80105fea <alltraps>

80106908 <vector121>:
.globl vector121
vector121:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $121
8010690a:	6a 79                	push   $0x79
  jmp alltraps
8010690c:	e9 d9 f6 ff ff       	jmp    80105fea <alltraps>

80106911 <vector122>:
.globl vector122
vector122:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $122
80106913:	6a 7a                	push   $0x7a
  jmp alltraps
80106915:	e9 d0 f6 ff ff       	jmp    80105fea <alltraps>

8010691a <vector123>:
.globl vector123
vector123:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $123
8010691c:	6a 7b                	push   $0x7b
  jmp alltraps
8010691e:	e9 c7 f6 ff ff       	jmp    80105fea <alltraps>

80106923 <vector124>:
.globl vector124
vector124:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $124
80106925:	6a 7c                	push   $0x7c
  jmp alltraps
80106927:	e9 be f6 ff ff       	jmp    80105fea <alltraps>

8010692c <vector125>:
.globl vector125
vector125:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $125
8010692e:	6a 7d                	push   $0x7d
  jmp alltraps
80106930:	e9 b5 f6 ff ff       	jmp    80105fea <alltraps>

80106935 <vector126>:
.globl vector126
vector126:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $126
80106937:	6a 7e                	push   $0x7e
  jmp alltraps
80106939:	e9 ac f6 ff ff       	jmp    80105fea <alltraps>

8010693e <vector127>:
.globl vector127
vector127:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $127
80106940:	6a 7f                	push   $0x7f
  jmp alltraps
80106942:	e9 a3 f6 ff ff       	jmp    80105fea <alltraps>

80106947 <vector128>:
.globl vector128
vector128:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $128
80106949:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010694e:	e9 97 f6 ff ff       	jmp    80105fea <alltraps>

80106953 <vector129>:
.globl vector129
vector129:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $129
80106955:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010695a:	e9 8b f6 ff ff       	jmp    80105fea <alltraps>

8010695f <vector130>:
.globl vector130
vector130:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $130
80106961:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106966:	e9 7f f6 ff ff       	jmp    80105fea <alltraps>

8010696b <vector131>:
.globl vector131
vector131:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $131
8010696d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106972:	e9 73 f6 ff ff       	jmp    80105fea <alltraps>

80106977 <vector132>:
.globl vector132
vector132:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $132
80106979:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010697e:	e9 67 f6 ff ff       	jmp    80105fea <alltraps>

80106983 <vector133>:
.globl vector133
vector133:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $133
80106985:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010698a:	e9 5b f6 ff ff       	jmp    80105fea <alltraps>

8010698f <vector134>:
.globl vector134
vector134:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $134
80106991:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106996:	e9 4f f6 ff ff       	jmp    80105fea <alltraps>

8010699b <vector135>:
.globl vector135
vector135:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $135
8010699d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069a2:	e9 43 f6 ff ff       	jmp    80105fea <alltraps>

801069a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $136
801069a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801069ae:	e9 37 f6 ff ff       	jmp    80105fea <alltraps>

801069b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $137
801069b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069ba:	e9 2b f6 ff ff       	jmp    80105fea <alltraps>

801069bf <vector138>:
.globl vector138
vector138:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $138
801069c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801069c6:	e9 1f f6 ff ff       	jmp    80105fea <alltraps>

801069cb <vector139>:
.globl vector139
vector139:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $139
801069cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801069d2:	e9 13 f6 ff ff       	jmp    80105fea <alltraps>

801069d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $140
801069d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801069de:	e9 07 f6 ff ff       	jmp    80105fea <alltraps>

801069e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $141
801069e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801069ea:	e9 fb f5 ff ff       	jmp    80105fea <alltraps>

801069ef <vector142>:
.globl vector142
vector142:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $142
801069f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069f6:	e9 ef f5 ff ff       	jmp    80105fea <alltraps>

801069fb <vector143>:
.globl vector143
vector143:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $143
801069fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a02:	e9 e3 f5 ff ff       	jmp    80105fea <alltraps>

80106a07 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $144
80106a09:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a0e:	e9 d7 f5 ff ff       	jmp    80105fea <alltraps>

80106a13 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $145
80106a15:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a1a:	e9 cb f5 ff ff       	jmp    80105fea <alltraps>

80106a1f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $146
80106a21:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a26:	e9 bf f5 ff ff       	jmp    80105fea <alltraps>

80106a2b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $147
80106a2d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a32:	e9 b3 f5 ff ff       	jmp    80105fea <alltraps>

80106a37 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $148
80106a39:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a3e:	e9 a7 f5 ff ff       	jmp    80105fea <alltraps>

80106a43 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $149
80106a45:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a4a:	e9 9b f5 ff ff       	jmp    80105fea <alltraps>

80106a4f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $150
80106a51:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a56:	e9 8f f5 ff ff       	jmp    80105fea <alltraps>

80106a5b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $151
80106a5d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a62:	e9 83 f5 ff ff       	jmp    80105fea <alltraps>

80106a67 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $152
80106a69:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a6e:	e9 77 f5 ff ff       	jmp    80105fea <alltraps>

80106a73 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $153
80106a75:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a7a:	e9 6b f5 ff ff       	jmp    80105fea <alltraps>

80106a7f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $154
80106a81:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a86:	e9 5f f5 ff ff       	jmp    80105fea <alltraps>

80106a8b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $155
80106a8d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a92:	e9 53 f5 ff ff       	jmp    80105fea <alltraps>

80106a97 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $156
80106a99:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a9e:	e9 47 f5 ff ff       	jmp    80105fea <alltraps>

80106aa3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $157
80106aa5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106aaa:	e9 3b f5 ff ff       	jmp    80105fea <alltraps>

80106aaf <vector158>:
.globl vector158
vector158:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $158
80106ab1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ab6:	e9 2f f5 ff ff       	jmp    80105fea <alltraps>

80106abb <vector159>:
.globl vector159
vector159:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $159
80106abd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ac2:	e9 23 f5 ff ff       	jmp    80105fea <alltraps>

80106ac7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $160
80106ac9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106ace:	e9 17 f5 ff ff       	jmp    80105fea <alltraps>

80106ad3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $161
80106ad5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106ada:	e9 0b f5 ff ff       	jmp    80105fea <alltraps>

80106adf <vector162>:
.globl vector162
vector162:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $162
80106ae1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ae6:	e9 ff f4 ff ff       	jmp    80105fea <alltraps>

80106aeb <vector163>:
.globl vector163
vector163:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $163
80106aed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106af2:	e9 f3 f4 ff ff       	jmp    80105fea <alltraps>

80106af7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $164
80106af9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106afe:	e9 e7 f4 ff ff       	jmp    80105fea <alltraps>

80106b03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $165
80106b05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b0a:	e9 db f4 ff ff       	jmp    80105fea <alltraps>

80106b0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $166
80106b11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b16:	e9 cf f4 ff ff       	jmp    80105fea <alltraps>

80106b1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $167
80106b1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b22:	e9 c3 f4 ff ff       	jmp    80105fea <alltraps>

80106b27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $168
80106b29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b2e:	e9 b7 f4 ff ff       	jmp    80105fea <alltraps>

80106b33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $169
80106b35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b3a:	e9 ab f4 ff ff       	jmp    80105fea <alltraps>

80106b3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $170
80106b41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b46:	e9 9f f4 ff ff       	jmp    80105fea <alltraps>

80106b4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $171
80106b4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b52:	e9 93 f4 ff ff       	jmp    80105fea <alltraps>

80106b57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $172
80106b59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b5e:	e9 87 f4 ff ff       	jmp    80105fea <alltraps>

80106b63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $173
80106b65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b6a:	e9 7b f4 ff ff       	jmp    80105fea <alltraps>

80106b6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $174
80106b71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b76:	e9 6f f4 ff ff       	jmp    80105fea <alltraps>

80106b7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $175
80106b7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b82:	e9 63 f4 ff ff       	jmp    80105fea <alltraps>

80106b87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $176
80106b89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b8e:	e9 57 f4 ff ff       	jmp    80105fea <alltraps>

80106b93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $177
80106b95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b9a:	e9 4b f4 ff ff       	jmp    80105fea <alltraps>

80106b9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $178
80106ba1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ba6:	e9 3f f4 ff ff       	jmp    80105fea <alltraps>

80106bab <vector179>:
.globl vector179
vector179:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $179
80106bad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106bb2:	e9 33 f4 ff ff       	jmp    80105fea <alltraps>

80106bb7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $180
80106bb9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bbe:	e9 27 f4 ff ff       	jmp    80105fea <alltraps>

80106bc3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $181
80106bc5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106bca:	e9 1b f4 ff ff       	jmp    80105fea <alltraps>

80106bcf <vector182>:
.globl vector182
vector182:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $182
80106bd1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106bd6:	e9 0f f4 ff ff       	jmp    80105fea <alltraps>

80106bdb <vector183>:
.globl vector183
vector183:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $183
80106bdd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106be2:	e9 03 f4 ff ff       	jmp    80105fea <alltraps>

80106be7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $184
80106be9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106bee:	e9 f7 f3 ff ff       	jmp    80105fea <alltraps>

80106bf3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $185
80106bf5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106bfa:	e9 eb f3 ff ff       	jmp    80105fea <alltraps>

80106bff <vector186>:
.globl vector186
vector186:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $186
80106c01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c06:	e9 df f3 ff ff       	jmp    80105fea <alltraps>

80106c0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $187
80106c0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c12:	e9 d3 f3 ff ff       	jmp    80105fea <alltraps>

80106c17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $188
80106c19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c1e:	e9 c7 f3 ff ff       	jmp    80105fea <alltraps>

80106c23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $189
80106c25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c2a:	e9 bb f3 ff ff       	jmp    80105fea <alltraps>

80106c2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $190
80106c31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c36:	e9 af f3 ff ff       	jmp    80105fea <alltraps>

80106c3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $191
80106c3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c42:	e9 a3 f3 ff ff       	jmp    80105fea <alltraps>

80106c47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $192
80106c49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c4e:	e9 97 f3 ff ff       	jmp    80105fea <alltraps>

80106c53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $193
80106c55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c5a:	e9 8b f3 ff ff       	jmp    80105fea <alltraps>

80106c5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $194
80106c61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c66:	e9 7f f3 ff ff       	jmp    80105fea <alltraps>

80106c6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $195
80106c6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c72:	e9 73 f3 ff ff       	jmp    80105fea <alltraps>

80106c77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $196
80106c79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c7e:	e9 67 f3 ff ff       	jmp    80105fea <alltraps>

80106c83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $197
80106c85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c8a:	e9 5b f3 ff ff       	jmp    80105fea <alltraps>

80106c8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $198
80106c91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c96:	e9 4f f3 ff ff       	jmp    80105fea <alltraps>

80106c9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $199
80106c9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ca2:	e9 43 f3 ff ff       	jmp    80105fea <alltraps>

80106ca7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $200
80106ca9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106cae:	e9 37 f3 ff ff       	jmp    80105fea <alltraps>

80106cb3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $201
80106cb5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106cba:	e9 2b f3 ff ff       	jmp    80105fea <alltraps>

80106cbf <vector202>:
.globl vector202
vector202:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $202
80106cc1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106cc6:	e9 1f f3 ff ff       	jmp    80105fea <alltraps>

80106ccb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $203
80106ccd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106cd2:	e9 13 f3 ff ff       	jmp    80105fea <alltraps>

80106cd7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $204
80106cd9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106cde:	e9 07 f3 ff ff       	jmp    80105fea <alltraps>

80106ce3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $205
80106ce5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106cea:	e9 fb f2 ff ff       	jmp    80105fea <alltraps>

80106cef <vector206>:
.globl vector206
vector206:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $206
80106cf1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106cf6:	e9 ef f2 ff ff       	jmp    80105fea <alltraps>

80106cfb <vector207>:
.globl vector207
vector207:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $207
80106cfd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d02:	e9 e3 f2 ff ff       	jmp    80105fea <alltraps>

80106d07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $208
80106d09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d0e:	e9 d7 f2 ff ff       	jmp    80105fea <alltraps>

80106d13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $209
80106d15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d1a:	e9 cb f2 ff ff       	jmp    80105fea <alltraps>

80106d1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $210
80106d21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d26:	e9 bf f2 ff ff       	jmp    80105fea <alltraps>

80106d2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $211
80106d2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d32:	e9 b3 f2 ff ff       	jmp    80105fea <alltraps>

80106d37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $212
80106d39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d3e:	e9 a7 f2 ff ff       	jmp    80105fea <alltraps>

80106d43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $213
80106d45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d4a:	e9 9b f2 ff ff       	jmp    80105fea <alltraps>

80106d4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $214
80106d51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d56:	e9 8f f2 ff ff       	jmp    80105fea <alltraps>

80106d5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $215
80106d5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d62:	e9 83 f2 ff ff       	jmp    80105fea <alltraps>

80106d67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $216
80106d69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d6e:	e9 77 f2 ff ff       	jmp    80105fea <alltraps>

80106d73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $217
80106d75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d7a:	e9 6b f2 ff ff       	jmp    80105fea <alltraps>

80106d7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $218
80106d81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d86:	e9 5f f2 ff ff       	jmp    80105fea <alltraps>

80106d8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $219
80106d8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d92:	e9 53 f2 ff ff       	jmp    80105fea <alltraps>

80106d97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $220
80106d99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d9e:	e9 47 f2 ff ff       	jmp    80105fea <alltraps>

80106da3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $221
80106da5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106daa:	e9 3b f2 ff ff       	jmp    80105fea <alltraps>

80106daf <vector222>:
.globl vector222
vector222:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $222
80106db1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106db6:	e9 2f f2 ff ff       	jmp    80105fea <alltraps>

80106dbb <vector223>:
.globl vector223
vector223:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $223
80106dbd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106dc2:	e9 23 f2 ff ff       	jmp    80105fea <alltraps>

80106dc7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $224
80106dc9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106dce:	e9 17 f2 ff ff       	jmp    80105fea <alltraps>

80106dd3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $225
80106dd5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106dda:	e9 0b f2 ff ff       	jmp    80105fea <alltraps>

80106ddf <vector226>:
.globl vector226
vector226:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $226
80106de1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106de6:	e9 ff f1 ff ff       	jmp    80105fea <alltraps>

80106deb <vector227>:
.globl vector227
vector227:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $227
80106ded:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106df2:	e9 f3 f1 ff ff       	jmp    80105fea <alltraps>

80106df7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $228
80106df9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106dfe:	e9 e7 f1 ff ff       	jmp    80105fea <alltraps>

80106e03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $229
80106e05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e0a:	e9 db f1 ff ff       	jmp    80105fea <alltraps>

80106e0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $230
80106e11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e16:	e9 cf f1 ff ff       	jmp    80105fea <alltraps>

80106e1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $231
80106e1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e22:	e9 c3 f1 ff ff       	jmp    80105fea <alltraps>

80106e27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $232
80106e29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e2e:	e9 b7 f1 ff ff       	jmp    80105fea <alltraps>

80106e33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $233
80106e35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e3a:	e9 ab f1 ff ff       	jmp    80105fea <alltraps>

80106e3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $234
80106e41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e46:	e9 9f f1 ff ff       	jmp    80105fea <alltraps>

80106e4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $235
80106e4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e52:	e9 93 f1 ff ff       	jmp    80105fea <alltraps>

80106e57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $236
80106e59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e5e:	e9 87 f1 ff ff       	jmp    80105fea <alltraps>

80106e63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $237
80106e65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e6a:	e9 7b f1 ff ff       	jmp    80105fea <alltraps>

80106e6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $238
80106e71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e76:	e9 6f f1 ff ff       	jmp    80105fea <alltraps>

80106e7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $239
80106e7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e82:	e9 63 f1 ff ff       	jmp    80105fea <alltraps>

80106e87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $240
80106e89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e8e:	e9 57 f1 ff ff       	jmp    80105fea <alltraps>

80106e93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $241
80106e95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e9a:	e9 4b f1 ff ff       	jmp    80105fea <alltraps>

80106e9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $242
80106ea1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ea6:	e9 3f f1 ff ff       	jmp    80105fea <alltraps>

80106eab <vector243>:
.globl vector243
vector243:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $243
80106ead:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106eb2:	e9 33 f1 ff ff       	jmp    80105fea <alltraps>

80106eb7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $244
80106eb9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ebe:	e9 27 f1 ff ff       	jmp    80105fea <alltraps>

80106ec3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $245
80106ec5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106eca:	e9 1b f1 ff ff       	jmp    80105fea <alltraps>

80106ecf <vector246>:
.globl vector246
vector246:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $246
80106ed1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ed6:	e9 0f f1 ff ff       	jmp    80105fea <alltraps>

80106edb <vector247>:
.globl vector247
vector247:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $247
80106edd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ee2:	e9 03 f1 ff ff       	jmp    80105fea <alltraps>

80106ee7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $248
80106ee9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106eee:	e9 f7 f0 ff ff       	jmp    80105fea <alltraps>

80106ef3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $249
80106ef5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106efa:	e9 eb f0 ff ff       	jmp    80105fea <alltraps>

80106eff <vector250>:
.globl vector250
vector250:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $250
80106f01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f06:	e9 df f0 ff ff       	jmp    80105fea <alltraps>

80106f0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $251
80106f0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f12:	e9 d3 f0 ff ff       	jmp    80105fea <alltraps>

80106f17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $252
80106f19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f1e:	e9 c7 f0 ff ff       	jmp    80105fea <alltraps>

80106f23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $253
80106f25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f2a:	e9 bb f0 ff ff       	jmp    80105fea <alltraps>

80106f2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $254
80106f31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f36:	e9 af f0 ff ff       	jmp    80105fea <alltraps>

80106f3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $255
80106f3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f42:	e9 a3 f0 ff ff       	jmp    80105fea <alltraps>
80106f47:	66 90                	xchg   %ax,%ax
80106f49:	66 90                	xchg   %ax,%ax
80106f4b:	66 90                	xchg   %ax,%ax
80106f4d:	66 90                	xchg   %ax,%ax
80106f4f:	90                   	nop

80106f50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106f5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f62:	83 ec 1c             	sub    $0x1c,%esp
80106f65:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f68:	39 d3                	cmp    %edx,%ebx
80106f6a:	73 49                	jae    80106fb5 <deallocuvm.part.0+0x65>
80106f6c:	89 c7                	mov    %eax,%edi
80106f6e:	eb 0c                	jmp    80106f7c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f70:	83 c0 01             	add    $0x1,%eax
80106f73:	c1 e0 16             	shl    $0x16,%eax
80106f76:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f78:	39 da                	cmp    %ebx,%edx
80106f7a:	76 39                	jbe    80106fb5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106f7c:	89 d8                	mov    %ebx,%eax
80106f7e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106f81:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106f84:	f6 c1 01             	test   $0x1,%cl
80106f87:	74 e7                	je     80106f70 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106f89:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f8b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106f91:	c1 ee 0a             	shr    $0xa,%esi
80106f94:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106f9a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106fa1:	85 f6                	test   %esi,%esi
80106fa3:	74 cb                	je     80106f70 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106fa5:	8b 06                	mov    (%esi),%eax
80106fa7:	a8 01                	test   $0x1,%al
80106fa9:	75 15                	jne    80106fc0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106fab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fb1:	39 da                	cmp    %ebx,%edx
80106fb3:	77 c7                	ja     80106f7c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106fb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbb:	5b                   	pop    %ebx
80106fbc:	5e                   	pop    %esi
80106fbd:	5f                   	pop    %edi
80106fbe:	5d                   	pop    %ebp
80106fbf:	c3                   	ret    
      if(pa == 0)
80106fc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fc5:	74 25                	je     80106fec <deallocuvm.part.0+0x9c>
      kfree(v);
80106fc7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fca:	05 00 00 00 80       	add    $0x80000000,%eax
80106fcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fd2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106fd8:	50                   	push   %eax
80106fd9:	e8 92 bc ff ff       	call   80102c70 <kfree>
      *pte = 0;
80106fde:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106fe4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fe7:	83 c4 10             	add    $0x10,%esp
80106fea:	eb 8c                	jmp    80106f78 <deallocuvm.part.0+0x28>
        panic("kfree");
80106fec:	83 ec 0c             	sub    $0xc,%esp
80106fef:	68 a6 7b 10 80       	push   $0x80107ba6
80106ff4:	e8 57 94 ff ff       	call   80100450 <panic>
80106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107000 <mappages>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107006:	89 d3                	mov    %edx,%ebx
80107008:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010700e:	83 ec 1c             	sub    $0x1c,%esp
80107011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107014:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010701d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107020:	8b 45 08             	mov    0x8(%ebp),%eax
80107023:	29 d8                	sub    %ebx,%eax
80107025:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107028:	eb 3d                	jmp    80107067 <mappages+0x67>
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107030:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107032:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107037:	c1 ea 0a             	shr    $0xa,%edx
8010703a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107040:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107047:	85 c0                	test   %eax,%eax
80107049:	74 75                	je     801070c0 <mappages+0xc0>
    if(*pte & PTE_P)
8010704b:	f6 00 01             	testb  $0x1,(%eax)
8010704e:	0f 85 86 00 00 00    	jne    801070da <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107054:	0b 75 0c             	or     0xc(%ebp),%esi
80107057:	83 ce 01             	or     $0x1,%esi
8010705a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010705c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010705f:	74 6f                	je     801070d0 <mappages+0xd0>
    a += PGSIZE;
80107061:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010706a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010706d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107070:	89 d8                	mov    %ebx,%eax
80107072:	c1 e8 16             	shr    $0x16,%eax
80107075:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107078:	8b 07                	mov    (%edi),%eax
8010707a:	a8 01                	test   $0x1,%al
8010707c:	75 b2                	jne    80107030 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010707e:	e8 ad bd ff ff       	call   80102e30 <kalloc>
80107083:	85 c0                	test   %eax,%eax
80107085:	74 39                	je     801070c0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107087:	83 ec 04             	sub    $0x4,%esp
8010708a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010708d:	68 00 10 00 00       	push   $0x1000
80107092:	6a 00                	push   $0x0
80107094:	50                   	push   %eax
80107095:	e8 76 dd ff ff       	call   80104e10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010709a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010709d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070a0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801070a6:	83 c8 07             	or     $0x7,%eax
801070a9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801070ab:	89 d8                	mov    %ebx,%eax
801070ad:	c1 e8 0a             	shr    $0xa,%eax
801070b0:	25 fc 0f 00 00       	and    $0xffc,%eax
801070b5:	01 d0                	add    %edx,%eax
801070b7:	eb 92                	jmp    8010704b <mappages+0x4b>
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801070c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c8:	5b                   	pop    %ebx
801070c9:	5e                   	pop    %esi
801070ca:	5f                   	pop    %edi
801070cb:	5d                   	pop    %ebp
801070cc:	c3                   	ret    
801070cd:	8d 76 00             	lea    0x0(%esi),%esi
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
      panic("remap");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 e8 81 10 80       	push   $0x801081e8
801070e2:	e8 69 93 ff ff       	call   80100450 <panic>
801070e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <seginit>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070f6:	e8 05 d0 ff ff       	call   80104100 <cpuid>
  pd[0] = size-1;
801070fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107100:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107106:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010710a:	c7 80 38 2d 11 80 ff 	movl   $0xffff,-0x7feed2c8(%eax)
80107111:	ff 00 00 
80107114:	c7 80 3c 2d 11 80 00 	movl   $0xcf9a00,-0x7feed2c4(%eax)
8010711b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010711e:	c7 80 40 2d 11 80 ff 	movl   $0xffff,-0x7feed2c0(%eax)
80107125:	ff 00 00 
80107128:	c7 80 44 2d 11 80 00 	movl   $0xcf9200,-0x7feed2bc(%eax)
8010712f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107132:	c7 80 48 2d 11 80 ff 	movl   $0xffff,-0x7feed2b8(%eax)
80107139:	ff 00 00 
8010713c:	c7 80 4c 2d 11 80 00 	movl   $0xcffa00,-0x7feed2b4(%eax)
80107143:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107146:	c7 80 50 2d 11 80 ff 	movl   $0xffff,-0x7feed2b0(%eax)
8010714d:	ff 00 00 
80107150:	c7 80 54 2d 11 80 00 	movl   $0xcff200,-0x7feed2ac(%eax)
80107157:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010715a:	05 30 2d 11 80       	add    $0x80112d30,%eax
  pd[1] = (uint)p;
8010715f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107163:	c1 e8 10             	shr    $0x10,%eax
80107166:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010716a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010716d:	0f 01 10             	lgdtl  (%eax)
}
80107170:	c9                   	leave  
80107171:	c3                   	ret    
80107172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107180 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107180:	a1 e4 59 11 80       	mov    0x801159e4,%eax
80107185:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010718a:	0f 22 d8             	mov    %eax,%cr3
}
8010718d:	c3                   	ret    
8010718e:	66 90                	xchg   %ax,%ax

80107190 <switchuvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 1c             	sub    $0x1c,%esp
80107199:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010719c:	85 f6                	test   %esi,%esi
8010719e:	0f 84 cb 00 00 00    	je     8010726f <switchuvm+0xdf>
  if(p->kstack == 0)
801071a4:	8b 46 08             	mov    0x8(%esi),%eax
801071a7:	85 c0                	test   %eax,%eax
801071a9:	0f 84 da 00 00 00    	je     80107289 <switchuvm+0xf9>
  if(p->pgdir == 0)
801071af:	8b 46 04             	mov    0x4(%esi),%eax
801071b2:	85 c0                	test   %eax,%eax
801071b4:	0f 84 c2 00 00 00    	je     8010727c <switchuvm+0xec>
  pushcli();
801071ba:	e8 41 da ff ff       	call   80104c00 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071bf:	e8 dc ce ff ff       	call   801040a0 <mycpu>
801071c4:	89 c3                	mov    %eax,%ebx
801071c6:	e8 d5 ce ff ff       	call   801040a0 <mycpu>
801071cb:	89 c7                	mov    %eax,%edi
801071cd:	e8 ce ce ff ff       	call   801040a0 <mycpu>
801071d2:	83 c7 08             	add    $0x8,%edi
801071d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d8:	e8 c3 ce ff ff       	call   801040a0 <mycpu>
801071dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071e0:	ba 67 00 00 00       	mov    $0x67,%edx
801071e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071ec:	83 c0 08             	add    $0x8,%eax
801071ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071fb:	83 c1 08             	add    $0x8,%ecx
801071fe:	c1 e8 18             	shr    $0x18,%eax
80107201:	c1 e9 10             	shr    $0x10,%ecx
80107204:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010720a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107210:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107215:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010721c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107221:	e8 7a ce ff ff       	call   801040a0 <mycpu>
80107226:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010722d:	e8 6e ce ff ff       	call   801040a0 <mycpu>
80107232:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107236:	8b 5e 08             	mov    0x8(%esi),%ebx
80107239:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010723f:	e8 5c ce ff ff       	call   801040a0 <mycpu>
80107244:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107247:	e8 54 ce ff ff       	call   801040a0 <mycpu>
8010724c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107250:	b8 28 00 00 00       	mov    $0x28,%eax
80107255:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107258:	8b 46 04             	mov    0x4(%esi),%eax
8010725b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107260:	0f 22 d8             	mov    %eax,%cr3
}
80107263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107266:	5b                   	pop    %ebx
80107267:	5e                   	pop    %esi
80107268:	5f                   	pop    %edi
80107269:	5d                   	pop    %ebp
  popcli();
8010726a:	e9 e1 d9 ff ff       	jmp    80104c50 <popcli>
    panic("switchuvm: no process");
8010726f:	83 ec 0c             	sub    $0xc,%esp
80107272:	68 ee 81 10 80       	push   $0x801081ee
80107277:	e8 d4 91 ff ff       	call   80100450 <panic>
    panic("switchuvm: no pgdir");
8010727c:	83 ec 0c             	sub    $0xc,%esp
8010727f:	68 19 82 10 80       	push   $0x80108219
80107284:	e8 c7 91 ff ff       	call   80100450 <panic>
    panic("switchuvm: no kstack");
80107289:	83 ec 0c             	sub    $0xc,%esp
8010728c:	68 04 82 10 80       	push   $0x80108204
80107291:	e8 ba 91 ff ff       	call   80100450 <panic>
80107296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729d:	8d 76 00             	lea    0x0(%esi),%esi

801072a0 <inituvm>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 1c             	sub    $0x1c,%esp
801072a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ac:	8b 75 10             	mov    0x10(%ebp),%esi
801072af:	8b 7d 08             	mov    0x8(%ebp),%edi
801072b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801072b5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072bb:	77 4b                	ja     80107308 <inituvm+0x68>
  mem = kalloc();
801072bd:	e8 6e bb ff ff       	call   80102e30 <kalloc>
  memset(mem, 0, PGSIZE);
801072c2:	83 ec 04             	sub    $0x4,%esp
801072c5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801072ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072cc:	6a 00                	push   $0x0
801072ce:	50                   	push   %eax
801072cf:	e8 3c db ff ff       	call   80104e10 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072d4:	58                   	pop    %eax
801072d5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072db:	5a                   	pop    %edx
801072dc:	6a 06                	push   $0x6
801072de:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072e3:	31 d2                	xor    %edx,%edx
801072e5:	50                   	push   %eax
801072e6:	89 f8                	mov    %edi,%eax
801072e8:	e8 13 fd ff ff       	call   80107000 <mappages>
  memmove(mem, init, sz);
801072ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072f0:	89 75 10             	mov    %esi,0x10(%ebp)
801072f3:	83 c4 10             	add    $0x10,%esp
801072f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801072f9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801072fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ff:	5b                   	pop    %ebx
80107300:	5e                   	pop    %esi
80107301:	5f                   	pop    %edi
80107302:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107303:	e9 a8 db ff ff       	jmp    80104eb0 <memmove>
    panic("inituvm: more than a page");
80107308:	83 ec 0c             	sub    $0xc,%esp
8010730b:	68 2d 82 10 80       	push   $0x8010822d
80107310:	e8 3b 91 ff ff       	call   80100450 <panic>
80107315:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107320 <loaduvm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
80107329:	8b 45 0c             	mov    0xc(%ebp),%eax
8010732c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010732f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107334:	0f 85 bb 00 00 00    	jne    801073f5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010733a:	01 f0                	add    %esi,%eax
8010733c:	89 f3                	mov    %esi,%ebx
8010733e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107341:	8b 45 14             	mov    0x14(%ebp),%eax
80107344:	01 f0                	add    %esi,%eax
80107346:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107349:	85 f6                	test   %esi,%esi
8010734b:	0f 84 87 00 00 00    	je     801073d8 <loaduvm+0xb8>
80107351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010735b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010735e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107360:	89 c2                	mov    %eax,%edx
80107362:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107365:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107368:	f6 c2 01             	test   $0x1,%dl
8010736b:	75 13                	jne    80107380 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010736d:	83 ec 0c             	sub    $0xc,%esp
80107370:	68 47 82 10 80       	push   $0x80108247
80107375:	e8 d6 90 ff ff       	call   80100450 <panic>
8010737a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107380:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107383:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107389:	25 fc 0f 00 00       	and    $0xffc,%eax
8010738e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107395:	85 c0                	test   %eax,%eax
80107397:	74 d4                	je     8010736d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107399:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010739b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010739e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801073a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801073a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801073ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073b1:	29 d9                	sub    %ebx,%ecx
801073b3:	05 00 00 00 80       	add    $0x80000000,%eax
801073b8:	57                   	push   %edi
801073b9:	51                   	push   %ecx
801073ba:	50                   	push   %eax
801073bb:	ff 75 10             	push   0x10(%ebp)
801073be:	e8 7d ae ff ff       	call   80102240 <readi>
801073c3:	83 c4 10             	add    $0x10,%esp
801073c6:	39 f8                	cmp    %edi,%eax
801073c8:	75 1e                	jne    801073e8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801073ca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801073d0:	89 f0                	mov    %esi,%eax
801073d2:	29 d8                	sub    %ebx,%eax
801073d4:	39 c6                	cmp    %eax,%esi
801073d6:	77 80                	ja     80107358 <loaduvm+0x38>
}
801073d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073db:	31 c0                	xor    %eax,%eax
}
801073dd:	5b                   	pop    %ebx
801073de:	5e                   	pop    %esi
801073df:	5f                   	pop    %edi
801073e0:	5d                   	pop    %ebp
801073e1:	c3                   	ret    
801073e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073f0:	5b                   	pop    %ebx
801073f1:	5e                   	pop    %esi
801073f2:	5f                   	pop    %edi
801073f3:	5d                   	pop    %ebp
801073f4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801073f5:	83 ec 0c             	sub    $0xc,%esp
801073f8:	68 e8 82 10 80       	push   $0x801082e8
801073fd:	e8 4e 90 ff ff       	call   80100450 <panic>
80107402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107410 <allocuvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107419:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010741c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010741f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107422:	85 c0                	test   %eax,%eax
80107424:	0f 88 b6 00 00 00    	js     801074e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010742a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010742d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107430:	0f 82 9a 00 00 00    	jb     801074d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107436:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010743c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107442:	39 75 10             	cmp    %esi,0x10(%ebp)
80107445:	77 44                	ja     8010748b <allocuvm+0x7b>
80107447:	e9 87 00 00 00       	jmp    801074d3 <allocuvm+0xc3>
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107450:	83 ec 04             	sub    $0x4,%esp
80107453:	68 00 10 00 00       	push   $0x1000
80107458:	6a 00                	push   $0x0
8010745a:	50                   	push   %eax
8010745b:	e8 b0 d9 ff ff       	call   80104e10 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107460:	58                   	pop    %eax
80107461:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107467:	5a                   	pop    %edx
80107468:	6a 06                	push   $0x6
8010746a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010746f:	89 f2                	mov    %esi,%edx
80107471:	50                   	push   %eax
80107472:	89 f8                	mov    %edi,%eax
80107474:	e8 87 fb ff ff       	call   80107000 <mappages>
80107479:	83 c4 10             	add    $0x10,%esp
8010747c:	85 c0                	test   %eax,%eax
8010747e:	78 78                	js     801074f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107480:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107486:	39 75 10             	cmp    %esi,0x10(%ebp)
80107489:	76 48                	jbe    801074d3 <allocuvm+0xc3>
    mem = kalloc();
8010748b:	e8 a0 b9 ff ff       	call   80102e30 <kalloc>
80107490:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107492:	85 c0                	test   %eax,%eax
80107494:	75 ba                	jne    80107450 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107496:	83 ec 0c             	sub    $0xc,%esp
80107499:	68 65 82 10 80       	push   $0x80108265
8010749e:	e8 dd 93 ff ff       	call   80100880 <cprintf>
  if(newsz >= oldsz)
801074a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801074a6:	83 c4 10             	add    $0x10,%esp
801074a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ac:	74 32                	je     801074e0 <allocuvm+0xd0>
801074ae:	8b 55 10             	mov    0x10(%ebp),%edx
801074b1:	89 c1                	mov    %eax,%ecx
801074b3:	89 f8                	mov    %edi,%eax
801074b5:	e8 96 fa ff ff       	call   80106f50 <deallocuvm.part.0>
      return 0;
801074ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801074c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c7:	5b                   	pop    %ebx
801074c8:	5e                   	pop    %esi
801074c9:	5f                   	pop    %edi
801074ca:	5d                   	pop    %ebp
801074cb:	c3                   	ret    
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801074d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801074d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d9:	5b                   	pop    %ebx
801074da:	5e                   	pop    %esi
801074db:	5f                   	pop    %edi
801074dc:	5d                   	pop    %ebp
801074dd:	c3                   	ret    
801074de:	66 90                	xchg   %ax,%ax
    return 0;
801074e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801074e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ed:	5b                   	pop    %ebx
801074ee:	5e                   	pop    %esi
801074ef:	5f                   	pop    %edi
801074f0:	5d                   	pop    %ebp
801074f1:	c3                   	ret    
801074f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801074f8:	83 ec 0c             	sub    $0xc,%esp
801074fb:	68 7d 82 10 80       	push   $0x8010827d
80107500:	e8 7b 93 ff ff       	call   80100880 <cprintf>
  if(newsz >= oldsz)
80107505:	8b 45 0c             	mov    0xc(%ebp),%eax
80107508:	83 c4 10             	add    $0x10,%esp
8010750b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010750e:	74 0c                	je     8010751c <allocuvm+0x10c>
80107510:	8b 55 10             	mov    0x10(%ebp),%edx
80107513:	89 c1                	mov    %eax,%ecx
80107515:	89 f8                	mov    %edi,%eax
80107517:	e8 34 fa ff ff       	call   80106f50 <deallocuvm.part.0>
      kfree(mem);
8010751c:	83 ec 0c             	sub    $0xc,%esp
8010751f:	53                   	push   %ebx
80107520:	e8 4b b7 ff ff       	call   80102c70 <kfree>
      return 0;
80107525:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010752c:	83 c4 10             	add    $0x10,%esp
}
8010752f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107532:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107535:	5b                   	pop    %ebx
80107536:	5e                   	pop    %esi
80107537:	5f                   	pop    %edi
80107538:	5d                   	pop    %ebp
80107539:	c3                   	ret    
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107540 <deallocuvm>:
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	8b 55 0c             	mov    0xc(%ebp),%edx
80107546:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107549:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010754c:	39 d1                	cmp    %edx,%ecx
8010754e:	73 10                	jae    80107560 <deallocuvm+0x20>
}
80107550:	5d                   	pop    %ebp
80107551:	e9 fa f9 ff ff       	jmp    80106f50 <deallocuvm.part.0>
80107556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755d:	8d 76 00             	lea    0x0(%esi),%esi
80107560:	89 d0                	mov    %edx,%eax
80107562:	5d                   	pop    %ebp
80107563:	c3                   	ret    
80107564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010756f:	90                   	nop

80107570 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 0c             	sub    $0xc,%esp
80107579:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010757c:	85 f6                	test   %esi,%esi
8010757e:	74 59                	je     801075d9 <freevm+0x69>
  if(newsz >= oldsz)
80107580:	31 c9                	xor    %ecx,%ecx
80107582:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107587:	89 f0                	mov    %esi,%eax
80107589:	89 f3                	mov    %esi,%ebx
8010758b:	e8 c0 f9 ff ff       	call   80106f50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107590:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107596:	eb 0f                	jmp    801075a7 <freevm+0x37>
80107598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010759f:	90                   	nop
801075a0:	83 c3 04             	add    $0x4,%ebx
801075a3:	39 df                	cmp    %ebx,%edi
801075a5:	74 23                	je     801075ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801075a7:	8b 03                	mov    (%ebx),%eax
801075a9:	a8 01                	test   $0x1,%al
801075ab:	74 f3                	je     801075a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801075b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801075b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801075bd:	50                   	push   %eax
801075be:	e8 ad b6 ff ff       	call   80102c70 <kfree>
801075c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801075c6:	39 df                	cmp    %ebx,%edi
801075c8:	75 dd                	jne    801075a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801075ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801075cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075d0:	5b                   	pop    %ebx
801075d1:	5e                   	pop    %esi
801075d2:	5f                   	pop    %edi
801075d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801075d4:	e9 97 b6 ff ff       	jmp    80102c70 <kfree>
    panic("freevm: no pgdir");
801075d9:	83 ec 0c             	sub    $0xc,%esp
801075dc:	68 99 82 10 80       	push   $0x80108299
801075e1:	e8 6a 8e ff ff       	call   80100450 <panic>
801075e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ed:	8d 76 00             	lea    0x0(%esi),%esi

801075f0 <setupkvm>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	56                   	push   %esi
801075f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075f5:	e8 36 b8 ff ff       	call   80102e30 <kalloc>
801075fa:	89 c6                	mov    %eax,%esi
801075fc:	85 c0                	test   %eax,%eax
801075fe:	74 42                	je     80107642 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107600:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107603:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107608:	68 00 10 00 00       	push   $0x1000
8010760d:	6a 00                	push   $0x0
8010760f:	50                   	push   %eax
80107610:	e8 fb d7 ff ff       	call   80104e10 <memset>
80107615:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107618:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010761b:	83 ec 08             	sub    $0x8,%esp
8010761e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107621:	ff 73 0c             	push   0xc(%ebx)
80107624:	8b 13                	mov    (%ebx),%edx
80107626:	50                   	push   %eax
80107627:	29 c1                	sub    %eax,%ecx
80107629:	89 f0                	mov    %esi,%eax
8010762b:	e8 d0 f9 ff ff       	call   80107000 <mappages>
80107630:	83 c4 10             	add    $0x10,%esp
80107633:	85 c0                	test   %eax,%eax
80107635:	78 19                	js     80107650 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107637:	83 c3 10             	add    $0x10,%ebx
8010763a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107640:	75 d6                	jne    80107618 <setupkvm+0x28>
}
80107642:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107645:	89 f0                	mov    %esi,%eax
80107647:	5b                   	pop    %ebx
80107648:	5e                   	pop    %esi
80107649:	5d                   	pop    %ebp
8010764a:	c3                   	ret    
8010764b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010764f:	90                   	nop
      freevm(pgdir);
80107650:	83 ec 0c             	sub    $0xc,%esp
80107653:	56                   	push   %esi
      return 0;
80107654:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107656:	e8 15 ff ff ff       	call   80107570 <freevm>
      return 0;
8010765b:	83 c4 10             	add    $0x10,%esp
}
8010765e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107661:	89 f0                	mov    %esi,%eax
80107663:	5b                   	pop    %ebx
80107664:	5e                   	pop    %esi
80107665:	5d                   	pop    %ebp
80107666:	c3                   	ret    
80107667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010766e:	66 90                	xchg   %ax,%ax

80107670 <kvmalloc>:
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107676:	e8 75 ff ff ff       	call   801075f0 <setupkvm>
8010767b:	a3 e4 59 11 80       	mov    %eax,0x801159e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107680:	05 00 00 00 80       	add    $0x80000000,%eax
80107685:	0f 22 d8             	mov    %eax,%cr3
}
80107688:	c9                   	leave  
80107689:	c3                   	ret    
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107690 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	83 ec 08             	sub    $0x8,%esp
80107696:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107699:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010769c:	89 c1                	mov    %eax,%ecx
8010769e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801076a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801076a4:	f6 c2 01             	test   $0x1,%dl
801076a7:	75 17                	jne    801076c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801076a9:	83 ec 0c             	sub    $0xc,%esp
801076ac:	68 aa 82 10 80       	push   $0x801082aa
801076b1:	e8 9a 8d ff ff       	call   80100450 <panic>
801076b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801076c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801076c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801076ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801076d5:	85 c0                	test   %eax,%eax
801076d7:	74 d0                	je     801076a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801076d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801076dc:	c9                   	leave  
801076dd:	c3                   	ret    
801076de:	66 90                	xchg   %ax,%ax

801076e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
801076e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076e9:	e8 02 ff ff ff       	call   801075f0 <setupkvm>
801076ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076f1:	85 c0                	test   %eax,%eax
801076f3:	0f 84 bd 00 00 00    	je     801077b6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076fc:	85 c9                	test   %ecx,%ecx
801076fe:	0f 84 b2 00 00 00    	je     801077b6 <copyuvm+0xd6>
80107704:	31 f6                	xor    %esi,%esi
80107706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107710:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107713:	89 f0                	mov    %esi,%eax
80107715:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107718:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010771b:	a8 01                	test   $0x1,%al
8010771d:	75 11                	jne    80107730 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010771f:	83 ec 0c             	sub    $0xc,%esp
80107722:	68 b4 82 10 80       	push   $0x801082b4
80107727:	e8 24 8d ff ff       	call   80100450 <panic>
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107730:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107732:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107737:	c1 ea 0a             	shr    $0xa,%edx
8010773a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107740:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107747:	85 c0                	test   %eax,%eax
80107749:	74 d4                	je     8010771f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010774b:	8b 00                	mov    (%eax),%eax
8010774d:	a8 01                	test   $0x1,%al
8010774f:	0f 84 9f 00 00 00    	je     801077f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107755:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107757:	25 ff 0f 00 00       	and    $0xfff,%eax
8010775c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010775f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107765:	e8 c6 b6 ff ff       	call   80102e30 <kalloc>
8010776a:	89 c3                	mov    %eax,%ebx
8010776c:	85 c0                	test   %eax,%eax
8010776e:	74 64                	je     801077d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107770:	83 ec 04             	sub    $0x4,%esp
80107773:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107779:	68 00 10 00 00       	push   $0x1000
8010777e:	57                   	push   %edi
8010777f:	50                   	push   %eax
80107780:	e8 2b d7 ff ff       	call   80104eb0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107785:	58                   	pop    %eax
80107786:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010778c:	5a                   	pop    %edx
8010778d:	ff 75 e4             	push   -0x1c(%ebp)
80107790:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107795:	89 f2                	mov    %esi,%edx
80107797:	50                   	push   %eax
80107798:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010779b:	e8 60 f8 ff ff       	call   80107000 <mappages>
801077a0:	83 c4 10             	add    $0x10,%esp
801077a3:	85 c0                	test   %eax,%eax
801077a5:	78 21                	js     801077c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801077a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801077ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801077b0:	0f 87 5a ff ff ff    	ja     80107710 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801077b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077bc:	5b                   	pop    %ebx
801077bd:	5e                   	pop    %esi
801077be:	5f                   	pop    %edi
801077bf:	5d                   	pop    %ebp
801077c0:	c3                   	ret    
801077c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801077c8:	83 ec 0c             	sub    $0xc,%esp
801077cb:	53                   	push   %ebx
801077cc:	e8 9f b4 ff ff       	call   80102c70 <kfree>
      goto bad;
801077d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801077d4:	83 ec 0c             	sub    $0xc,%esp
801077d7:	ff 75 e0             	push   -0x20(%ebp)
801077da:	e8 91 fd ff ff       	call   80107570 <freevm>
  return 0;
801077df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801077e6:	83 c4 10             	add    $0x10,%esp
}
801077e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ef:	5b                   	pop    %ebx
801077f0:	5e                   	pop    %esi
801077f1:	5f                   	pop    %edi
801077f2:	5d                   	pop    %ebp
801077f3:	c3                   	ret    
      panic("copyuvm: page not present");
801077f4:	83 ec 0c             	sub    $0xc,%esp
801077f7:	68 ce 82 10 80       	push   $0x801082ce
801077fc:	e8 4f 8c ff ff       	call   80100450 <panic>
80107801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780f:	90                   	nop

80107810 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107816:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107819:	89 c1                	mov    %eax,%ecx
8010781b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010781e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107821:	f6 c2 01             	test   $0x1,%dl
80107824:	0f 84 00 01 00 00    	je     8010792a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010782a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010782d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107833:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107834:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107839:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107840:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107847:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010784a:	05 00 00 00 80       	add    $0x80000000,%eax
8010784f:	83 fa 05             	cmp    $0x5,%edx
80107852:	ba 00 00 00 00       	mov    $0x0,%edx
80107857:	0f 45 c2             	cmovne %edx,%eax
}
8010785a:	c3                   	ret    
8010785b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010785f:	90                   	nop

80107860 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	57                   	push   %edi
80107864:	56                   	push   %esi
80107865:	53                   	push   %ebx
80107866:	83 ec 0c             	sub    $0xc,%esp
80107869:	8b 75 14             	mov    0x14(%ebp),%esi
8010786c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010786f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107872:	85 f6                	test   %esi,%esi
80107874:	75 51                	jne    801078c7 <copyout+0x67>
80107876:	e9 a5 00 00 00       	jmp    80107920 <copyout+0xc0>
8010787b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010787f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107880:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107886:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010788c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107892:	74 75                	je     80107909 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107894:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107896:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107899:	29 c3                	sub    %eax,%ebx
8010789b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078a1:	39 f3                	cmp    %esi,%ebx
801078a3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801078a6:	29 f8                	sub    %edi,%eax
801078a8:	83 ec 04             	sub    $0x4,%esp
801078ab:	01 c1                	add    %eax,%ecx
801078ad:	53                   	push   %ebx
801078ae:	52                   	push   %edx
801078af:	51                   	push   %ecx
801078b0:	e8 fb d5 ff ff       	call   80104eb0 <memmove>
    len -= n;
    buf += n;
801078b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801078b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801078be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801078c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801078c3:	29 de                	sub    %ebx,%esi
801078c5:	74 59                	je     80107920 <copyout+0xc0>
  if(*pde & PTE_P){
801078c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801078ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801078cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801078ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801078d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801078d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801078da:	f6 c1 01             	test   $0x1,%cl
801078dd:	0f 84 4e 00 00 00    	je     80107931 <copyout.cold>
  return &pgtab[PTX(va)];
801078e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801078eb:	c1 eb 0c             	shr    $0xc,%ebx
801078ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801078f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801078fb:	89 d9                	mov    %ebx,%ecx
801078fd:	83 e1 05             	and    $0x5,%ecx
80107900:	83 f9 05             	cmp    $0x5,%ecx
80107903:	0f 84 77 ff ff ff    	je     80107880 <copyout+0x20>
  }
  return 0;
}
80107909:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010790c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107911:	5b                   	pop    %ebx
80107912:	5e                   	pop    %esi
80107913:	5f                   	pop    %edi
80107914:	5d                   	pop    %ebp
80107915:	c3                   	ret    
80107916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010791d:	8d 76 00             	lea    0x0(%esi),%esi
80107920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107923:	31 c0                	xor    %eax,%eax
}
80107925:	5b                   	pop    %ebx
80107926:	5e                   	pop    %esi
80107927:	5f                   	pop    %edi
80107928:	5d                   	pop    %ebp
80107929:	c3                   	ret    

8010792a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010792a:	a1 00 00 00 00       	mov    0x0,%eax
8010792f:	0f 0b                	ud2    

80107931 <copyout.cold>:
80107931:	a1 00 00 00 00       	mov    0x0,%eax
80107936:	0f 0b                	ud2    
