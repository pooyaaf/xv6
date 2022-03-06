
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
80100028:	bc f0 59 11 80       	mov    $0x801159f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 34 10 80       	mov    $0x80103400,%eax
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
8010004c:	68 40 75 10 80       	push   $0x80107540
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 15 47 00 00       	call   80104770 <initlock>
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
80100092:	68 47 75 10 80       	push   $0x80107547
80100097:	50                   	push   %eax
80100098:	e8 a3 45 00 00       	call   80104640 <initsleeplock>
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
801000e4:	e8 57 48 00 00       	call   80104940 <acquire>
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
80100162:	e8 79 47 00 00       	call   801048e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 45 00 00       	call   80104680 <acquiresleep>
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
8010018c:	e8 ef 24 00 00       	call   80102680 <iderw>
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
801001a1:	68 4e 75 10 80       	push   $0x8010754e
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
801001be:	e8 5d 45 00 00       	call   80104720 <holdingsleep>
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
801001d4:	e9 a7 24 00 00       	jmp    80102680 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 75 10 80       	push   $0x8010755f
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
801001ff:	e8 1c 45 00 00       	call   80104720 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 44 00 00       	call   801046e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 20 47 00 00       	call   80104940 <acquire>
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
8010026c:	e9 6f 46 00 00       	jmp    801048e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 75 10 80       	push   $0x80107566
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
80100294:	e8 67 19 00 00       	call   80101c00 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 f4 10 80 	movl   $0x8010f440,(%esp)
801002a0:	e8 9b 46 00 00       	call   80104940 <acquire>
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
801002c3:	68 40 f4 10 80       	push   $0x8010f440
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 0e 41 00 00       	call   801043e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 29 3a 00 00       	call   80103d10 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 f4 10 80       	push   $0x8010f440
801002f6:	e8 e5 45 00 00       	call   801048e0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 1c 18 00 00       	call   80101b20 <ilock>
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
80100347:	68 40 f4 10 80       	push   $0x8010f440
8010034c:	e8 8f 45 00 00       	call   801048e0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 c6 17 00 00       	call   80101b20 <ilock>
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
80100389:	c7 05 74 f4 10 80 00 	movl   $0x0,0x8010f474
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 28 00 00       	call   80102c90 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 75 10 80       	push   $0x8010756d
801003a7:	e8 64 04 00 00       	call   80100810 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 5b 04 00 00       	call   80100810 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 97 7e 10 80 	movl   $0x80107e97,(%esp)
801003bc:	e8 4f 04 00 00       	call   80100810 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 43 00 00       	call   80104790 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 75 10 80       	push   $0x80107581
801003dd:	e8 2e 04 00 00       	call   80100810 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 f4 10 80 01 	movl   $0x1,0x8010f478
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
80100404:	56                   	push   %esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100405:	be d4 03 00 00       	mov    $0x3d4,%esi
8010040a:	53                   	push   %ebx
8010040b:	89 f2                	mov    %esi,%edx
8010040d:	83 ec 1c             	sub    $0x1c,%esp
80100410:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100419:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010041e:	89 da                	mov    %ebx,%edx
80100420:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100421:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100424:	89 f2                	mov    %esi,%edx
80100426:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042b:	c1 e1 08             	shl    $0x8,%ecx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	89 da                	mov    %ebx,%edx
80100431:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100432:	0f b6 c0             	movzbl %al,%eax
80100435:	89 c7                	mov    %eax,%edi
80100437:	09 cf                	or     %ecx,%edi
  if(c == '\n'){
80100439:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
8010043d:	0f 84 e5 00 00 00    	je     80100528 <cgaputc+0x128>
  else if(c == BACKSPACE){
80100443:	81 7d e0 00 01 00 00 	cmpl   $0x100,-0x20(%ebp)
8010044a:	0f 84 c4 00 00 00    	je     80100514 <cgaputc+0x114>
  } else if (c == LEFT_ARROW) {
80100450:	81 7d e0 e4 00 00 00 	cmpl   $0xe4,-0x20(%ebp)
80100457:	0f 84 c3 01 00 00    	je     80100620 <cgaputc+0x220>
  } else if (c == RIGHT_ARROW) {
8010045d:	81 7d e0 e5 00 00 00 	cmpl   $0xe5,-0x20(%ebp)
    if(back_counter > 0) {
80100464:	a1 24 f4 10 80       	mov    0x8010f424,%eax
  } else if (c == RIGHT_ARROW) {
80100469:	0f 84 97 01 00 00    	je     80100606 <cgaputc+0x206>
    for(int i = pos + back_counter; i >= pos; i--){
8010046f:	01 f8                	add    %edi,%eax
80100471:	39 c7                	cmp    %eax,%edi
80100473:	7f 21                	jg     80100496 <cgaputc+0x96>
80100475:	8d 84 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%eax
8010047c:	8d 8c 3f fe 7f 0b 80 	lea    -0x7ff48002(%edi,%edi,1),%ecx
80100483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100487:	90                   	nop
      crt[i+1] = crt[i];
80100488:	0f b7 10             	movzwl (%eax),%edx
    for(int i = pos + back_counter; i >= pos; i--){
8010048b:	83 e8 02             	sub    $0x2,%eax
      crt[i+1] = crt[i];
8010048e:	66 89 50 04          	mov    %dx,0x4(%eax)
    for(int i = pos + back_counter; i >= pos; i--){
80100492:	39 c1                	cmp    %eax,%ecx
80100494:	75 f2                	jne    80100488 <cgaputc+0x88>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100496:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
8010049a:	8d 5f 01             	lea    0x1(%edi),%ebx
8010049d:	80 cc 07             	or     $0x7,%ah
801004a0:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
801004a7:	80 
  if(pos < 0 || pos > 25*80)
801004a8:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004ae:	0f 87 a3 01 00 00    	ja     80100657 <cgaputc+0x257>
  if((pos/80) >= 24){  // Scroll up.
801004b4:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004ba:	0f 8f 00 01 00 00    	jg     801005c0 <cgaputc+0x1c0>
  outb(CRTPORT+1, pos);
801004c0:	88 5d e4             	mov    %bl,-0x1c(%ebp)
  outb(CRTPORT+1, pos>>8);
801004c3:	0f b6 ff             	movzbl %bh,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c6:	be d4 03 00 00       	mov    $0x3d4,%esi
801004cb:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d0:	89 f2                	mov    %esi,%edx
801004d2:	ee                   	out    %al,(%dx)
801004d3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004d8:	89 f8                	mov    %edi,%eax
801004da:	89 ca                	mov    %ecx,%edx
801004dc:	ee                   	out    %al,(%dx)
801004dd:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e2:	89 f2                	mov    %esi,%edx
801004e4:	ee                   	out    %al,(%dx)
801004e5:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004e9:	89 ca                	mov    %ecx,%edx
801004eb:	ee                   	out    %al,(%dx)
  if(c != LEFT_ARROW && c != RIGHT_ARROW)
801004ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801004ef:	2d e4 00 00 00       	sub    $0xe4,%eax
801004f4:	83 f8 01             	cmp    $0x1,%eax
801004f7:	76 13                	jbe    8010050c <cgaputc+0x10c>
    crt[pos+back_counter] = ' ' | 0x0700;
801004f9:	03 1d 24 f4 10 80    	add    0x8010f424,%ebx
801004ff:	b8 20 07 00 00       	mov    $0x720,%eax
80100504:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
8010050b:	80 
}
8010050c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010050f:	5b                   	pop    %ebx
80100510:	5e                   	pop    %esi
80100511:	5f                   	pop    %edi
80100512:	5d                   	pop    %ebp
80100513:	c3                   	ret    
    if(pos > 0) --pos;
80100514:	8d 5f ff             	lea    -0x1(%edi),%ebx
80100517:	85 ff                	test   %edi,%edi
80100519:	75 8d                	jne    801004a8 <cgaputc+0xa8>
8010051b:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
8010051f:	31 db                	xor    %ebx,%ebx
80100521:	31 ff                	xor    %edi,%edi
80100523:	eb a1                	jmp    801004c6 <cgaputc+0xc6>
80100525:	8d 76 00             	lea    0x0(%esi),%esi
    count_entered++;
80100528:	a1 28 f4 10 80       	mov    0x8010f428,%eax
8010052d:	ba 20 ef 10 80       	mov    $0x8010ef20,%edx
80100532:	8d 70 01             	lea    0x1(%eax),%esi
  for(int i=0;i<count_entered/4+1;i++){
80100535:	8d 48 04             	lea    0x4(%eax),%ecx
80100538:	85 f6                	test   %esi,%esi
    count_entered++;
8010053a:	89 35 28 f4 10 80    	mov    %esi,0x8010f428
  for(int i=0;i<count_entered/4+1;i++){
80100540:	0f 49 ce             	cmovns %esi,%ecx
80100543:	c1 f9 02             	sar    $0x2,%ecx
80100546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010054d:	8d 76 00             	lea    0x0(%esi),%esi
      for_str(history[i],history[i+1]);
80100550:	89 d3                	mov    %edx,%ebx
  for(int i=0;i<count_entered/4+1;i++){
80100552:	31 c0                	xor    %eax,%eax
80100554:	83 ea 80             	sub    $0xffffff80,%edx
80100557:	83 fe fd             	cmp    $0xfffffffd,%esi
8010055a:	7c 16                	jl     80100572 <cgaputc+0x172>
8010055c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010055f:	90                   	nop
    b[i]=a[i];
80100560:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
80100564:	88 0c 02             	mov    %cl,(%edx,%eax,1)
  for(int i=0;i<count_entered/4+1;i++){
80100567:	83 c0 01             	add    $0x1,%eax
8010056a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
8010056d:	7e f1                	jle    80100560 <cgaputc+0x160>
8010056f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    for(int i = 0 ; i < 9 ; i++){
80100572:	81 fa a0 f3 10 80    	cmp    $0x8010f3a0,%edx
80100578:	75 d6                	jne    80100550 <cgaputc+0x150>
  for(int i=0;i<count_entered/4+1;i++){
8010057a:	31 d2                	xor    %edx,%edx
8010057c:	83 fe fd             	cmp    $0xfffffffd,%esi
8010057f:	7c 1b                	jl     8010059c <cgaputc+0x19c>
80100581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    b[i]=a[i];
80100588:	0f b6 82 80 ee 10 80 	movzbl -0x7fef1180(%edx),%eax
  for(int i=0;i<count_entered/4+1;i++){
8010058f:	83 c2 01             	add    $0x1,%edx
    b[i]=a[i];
80100592:	88 82 1f ef 10 80    	mov    %al,-0x7fef10e1(%edx)
  for(int i=0;i<count_entered/4+1;i++){
80100598:	39 ca                	cmp    %ecx,%edx
8010059a:	7e ec                	jle    80100588 <cgaputc+0x188>
    pos += 80 - pos%80;
8010059c:	89 f8                	mov    %edi,%eax
8010059e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801005a3:	f7 e2                	mul    %edx
801005a5:	c1 ea 06             	shr    $0x6,%edx
801005a8:	8d 04 92             	lea    (%edx,%edx,4),%eax
801005ab:	c1 e0 04             	shl    $0x4,%eax
801005ae:	8d 58 50             	lea    0x50(%eax),%ebx
801005b1:	e9 f2 fe ff ff       	jmp    801004a8 <cgaputc+0xa8>
801005b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005bd:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005c0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801005c3:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT+1, pos);
801005c6:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005cb:	68 60 0e 00 00       	push   $0xe60
801005d0:	68 a0 80 0b 80       	push   $0x800b80a0
801005d5:	68 00 80 0b 80       	push   $0x800b8000
801005da:	e8 c1 44 00 00       	call   80104aa0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005df:	b8 80 07 00 00       	mov    $0x780,%eax
801005e4:	83 c4 0c             	add    $0xc,%esp
801005e7:	29 d8                	sub    %ebx,%eax
801005e9:	01 c0                	add    %eax,%eax
801005eb:	50                   	push   %eax
801005ec:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005f3:	6a 00                	push   $0x0
801005f5:	50                   	push   %eax
801005f6:	e8 05 44 00 00       	call   80104a00 <memset>
  outb(CRTPORT+1, pos);
801005fb:	88 5d e4             	mov    %bl,-0x1c(%ebp)
801005fe:	83 c4 10             	add    $0x10,%esp
80100601:	e9 c0 fe ff ff       	jmp    801004c6 <cgaputc+0xc6>
  pos |= inb(CRTPORT+1);
80100606:	89 fb                	mov    %edi,%ebx
    if(back_counter > 0) {
80100608:	85 c0                	test   %eax,%eax
8010060a:	0f 8e 98 fe ff ff    	jle    801004a8 <cgaputc+0xa8>
      back_counter--;
80100610:	83 e8 01             	sub    $0x1,%eax
      ++pos;
80100613:	83 c3 01             	add    $0x1,%ebx
      back_counter--;
80100616:	a3 24 f4 10 80       	mov    %eax,0x8010f424
8010061b:	e9 88 fe ff ff       	jmp    801004a8 <cgaputc+0xa8>
    if(back_counter < (strlen(input.buf) - backspaces)) {
80100620:	83 ec 0c             	sub    $0xc,%esp
  pos |= inb(CRTPORT+1);
80100623:	89 fb                	mov    %edi,%ebx
    if(back_counter < (strlen(input.buf) - backspaces)) {
80100625:	68 80 ee 10 80       	push   $0x8010ee80
8010062a:	e8 d1 45 00 00       	call   80104c00 <strlen>
8010062f:	8b 15 24 f4 10 80    	mov    0x8010f424,%edx
80100635:	2b 05 20 f4 10 80    	sub    0x8010f420,%eax
8010063b:	83 c4 10             	add    $0x10,%esp
8010063e:	39 d0                	cmp    %edx,%eax
80100640:	0f 8e 62 fe ff ff    	jle    801004a8 <cgaputc+0xa8>
      back_counter++;
80100646:	83 c2 01             	add    $0x1,%edx
      --pos;
80100649:	83 eb 01             	sub    $0x1,%ebx
      back_counter++;
8010064c:	89 15 24 f4 10 80    	mov    %edx,0x8010f424
80100652:	e9 51 fe ff ff       	jmp    801004a8 <cgaputc+0xa8>
    panic("pos under/overflow");
80100657:	83 ec 0c             	sub    $0xc,%esp
8010065a:	68 85 75 10 80       	push   $0x80107585
8010065f:	e8 1c fd ff ff       	call   80100380 <panic>
80100664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010066b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010066f:	90                   	nop

80100670 <consputc>:
  if(panicked){
80100670:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
80100676:	85 d2                	test   %edx,%edx
80100678:	74 06                	je     80100680 <consputc+0x10>
  asm volatile("cli");
8010067a:	fa                   	cli    
    for(;;)
8010067b:	eb fe                	jmp    8010067b <consputc+0xb>
8010067d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	53                   	push   %ebx
80100684:	89 c3                	mov    %eax,%ebx
80100686:	83 ec 04             	sub    $0x4,%esp
  if(c == BACKSPACE){
80100689:	3d 00 01 00 00       	cmp    $0x100,%eax
8010068e:	74 17                	je     801006a7 <consputc+0x37>
    uartputc(c);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	50                   	push   %eax
80100694:	e8 b7 59 00 00       	call   80106050 <uartputc>
80100699:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010069c:	89 d8                	mov    %ebx,%eax
}
8010069e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801006a1:	c9                   	leave  
  cgaputc(c);
801006a2:	e9 59 fd ff ff       	jmp    80100400 <cgaputc>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801006a7:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
801006aa:	83 05 20 f4 10 80 01 	addl   $0x1,0x8010f420
    uartputc('\b'); uartputc(' '); uartputc('\b');
801006b1:	6a 08                	push   $0x8
801006b3:	e8 98 59 00 00       	call   80106050 <uartputc>
801006b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801006bf:	e8 8c 59 00 00       	call   80106050 <uartputc>
801006c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801006cb:	e8 80 59 00 00       	call   80106050 <uartputc>
801006d0:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801006d3:	89 d8                	mov    %ebx,%eax
}
801006d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801006d8:	c9                   	leave  
  cgaputc(c);
801006d9:	e9 22 fd ff ff       	jmp    80100400 <cgaputc>
801006de:	66 90                	xchg   %ax,%ax

801006e0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	57                   	push   %edi
801006e4:	56                   	push   %esi
801006e5:	53                   	push   %ebx
801006e6:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
801006e9:	ff 75 08             	push   0x8(%ebp)
{
801006ec:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801006ef:	e8 0c 15 00 00       	call   80101c00 <iunlock>
  acquire(&cons.lock);
801006f4:	c7 04 24 40 f4 10 80 	movl   $0x8010f440,(%esp)
801006fb:	e8 40 42 00 00       	call   80104940 <acquire>
  for(i = 0; i < n; i++)
80100700:	83 c4 10             	add    $0x10,%esp
80100703:	85 f6                	test   %esi,%esi
80100705:	7e 37                	jle    8010073e <consolewrite+0x5e>
80100707:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010070a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010070d:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
    consputc(buf[i] & 0xff);
80100713:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100716:	85 d2                	test   %edx,%edx
80100718:	74 06                	je     80100720 <consolewrite+0x40>
8010071a:	fa                   	cli    
    for(;;)
8010071b:	eb fe                	jmp    8010071b <consolewrite+0x3b>
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100720:	83 ec 0c             	sub    $0xc,%esp
80100723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < n; i++)
80100726:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100729:	50                   	push   %eax
8010072a:	e8 21 59 00 00       	call   80106050 <uartputc>
  cgaputc(c);
8010072f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100732:	e8 c9 fc ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
80100737:	83 c4 10             	add    $0x10,%esp
8010073a:	39 df                	cmp    %ebx,%edi
8010073c:	75 cf                	jne    8010070d <consolewrite+0x2d>
  release(&cons.lock);
8010073e:	83 ec 0c             	sub    $0xc,%esp
80100741:	68 40 f4 10 80       	push   $0x8010f440
80100746:	e8 95 41 00 00       	call   801048e0 <release>
  ilock(ip);
8010074b:	58                   	pop    %eax
8010074c:	ff 75 08             	push   0x8(%ebp)
8010074f:	e8 cc 13 00 00       	call   80101b20 <ilock>

  return n;
}
80100754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100757:	89 f0                	mov    %esi,%eax
80100759:	5b                   	pop    %ebx
8010075a:	5e                   	pop    %esi
8010075b:	5f                   	pop    %edi
8010075c:	5d                   	pop    %ebp
8010075d:	c3                   	ret    
8010075e:	66 90                	xchg   %ax,%ax

80100760 <printint>:
{
80100760:	55                   	push   %ebp
80100761:	89 e5                	mov    %esp,%ebp
80100763:	57                   	push   %edi
80100764:	56                   	push   %esi
80100765:	53                   	push   %ebx
80100766:	83 ec 2c             	sub    $0x2c,%esp
80100769:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010076c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010076f:	85 c9                	test   %ecx,%ecx
80100771:	74 04                	je     80100777 <printint+0x17>
80100773:	85 c0                	test   %eax,%eax
80100775:	78 7e                	js     801007f5 <printint+0x95>
    x = xx;
80100777:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010077e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100780:	31 db                	xor    %ebx,%ebx
80100782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100788:	89 c8                	mov    %ecx,%eax
8010078a:	31 d2                	xor    %edx,%edx
8010078c:	89 de                	mov    %ebx,%esi
8010078e:	89 cf                	mov    %ecx,%edi
80100790:	f7 75 d4             	divl   -0x2c(%ebp)
80100793:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100796:	0f b6 92 b0 75 10 80 	movzbl -0x7fef8a50(%edx),%edx
  }while((x /= base) != 0);
8010079d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010079f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801007a3:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
801007a6:	76 e0                	jbe    80100788 <printint+0x28>
  if(sign)
801007a8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801007ab:	85 c9                	test   %ecx,%ecx
801007ad:	74 0c                	je     801007bb <printint+0x5b>
    buf[i++] = '-';
801007af:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801007b4:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
801007b6:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801007bb:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
801007bf:	a1 78 f4 10 80       	mov    0x8010f478,%eax
801007c4:	85 c0                	test   %eax,%eax
801007c6:	74 08                	je     801007d0 <printint+0x70>
801007c8:	fa                   	cli    
    for(;;)
801007c9:	eb fe                	jmp    801007c9 <printint+0x69>
801007cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007cf:	90                   	nop
    consputc(buf[i]);
801007d0:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
801007d3:	83 ec 0c             	sub    $0xc,%esp
801007d6:	56                   	push   %esi
801007d7:	e8 74 58 00 00       	call   80106050 <uartputc>
  cgaputc(c);
801007dc:	89 f0                	mov    %esi,%eax
801007de:	e8 1d fc ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
801007e3:	8d 45 d7             	lea    -0x29(%ebp),%eax
801007e6:	83 c4 10             	add    $0x10,%esp
801007e9:	39 c3                	cmp    %eax,%ebx
801007eb:	74 0e                	je     801007fb <printint+0x9b>
    consputc(buf[i]);
801007ed:	0f b6 13             	movzbl (%ebx),%edx
801007f0:	83 eb 01             	sub    $0x1,%ebx
801007f3:	eb ca                	jmp    801007bf <printint+0x5f>
    x = -xx;
801007f5:	f7 d8                	neg    %eax
801007f7:	89 c1                	mov    %eax,%ecx
801007f9:	eb 85                	jmp    80100780 <printint+0x20>
}
801007fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007fe:	5b                   	pop    %ebx
801007ff:	5e                   	pop    %esi
80100800:	5f                   	pop    %edi
80100801:	5d                   	pop    %ebp
80100802:	c3                   	ret    
80100803:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <cprintf>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
80100816:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100819:	a1 74 f4 10 80       	mov    0x8010f474,%eax
8010081e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100821:	85 c0                	test   %eax,%eax
80100823:	0f 85 37 01 00 00    	jne    80100960 <cprintf+0x150>
  if (fmt == 0)
80100829:	8b 75 08             	mov    0x8(%ebp),%esi
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 84 32 02 00 00    	je     80100a66 <cprintf+0x256>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100834:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100837:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010083a:	31 db                	xor    %ebx,%ebx
8010083c:	85 c0                	test   %eax,%eax
8010083e:	74 56                	je     80100896 <cprintf+0x86>
    if(c != '%'){
80100840:	83 f8 25             	cmp    $0x25,%eax
80100843:	0f 85 d7 00 00 00    	jne    80100920 <cprintf+0x110>
    c = fmt[++i] & 0xff;
80100849:	83 c3 01             	add    $0x1,%ebx
8010084c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100850:	85 d2                	test   %edx,%edx
80100852:	74 42                	je     80100896 <cprintf+0x86>
    switch(c){
80100854:	83 fa 70             	cmp    $0x70,%edx
80100857:	0f 84 94 00 00 00    	je     801008f1 <cprintf+0xe1>
8010085d:	7f 51                	jg     801008b0 <cprintf+0xa0>
8010085f:	83 fa 25             	cmp    $0x25,%edx
80100862:	0f 84 10 01 00 00    	je     80100978 <cprintf+0x168>
80100868:	83 fa 64             	cmp    $0x64,%edx
8010086b:	0f 85 17 01 00 00    	jne    80100988 <cprintf+0x178>
      printint(*argp++, 10, 1);
80100871:	8d 47 04             	lea    0x4(%edi),%eax
80100874:	b9 01 00 00 00       	mov    $0x1,%ecx
80100879:	ba 0a 00 00 00       	mov    $0xa,%edx
8010087e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100881:	8b 07                	mov    (%edi),%eax
80100883:	e8 d8 fe ff ff       	call   80100760 <printint>
80100888:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010088b:	83 c3 01             	add    $0x1,%ebx
8010088e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100892:	85 c0                	test   %eax,%eax
80100894:	75 aa                	jne    80100840 <cprintf+0x30>
  if(locking)
80100896:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100899:	85 c0                	test   %eax,%eax
8010089b:	0f 85 a8 01 00 00    	jne    80100a49 <cprintf+0x239>
}
801008a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008a4:	5b                   	pop    %ebx
801008a5:	5e                   	pop    %esi
801008a6:	5f                   	pop    %edi
801008a7:	5d                   	pop    %ebp
801008a8:	c3                   	ret    
801008a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801008b0:	83 fa 73             	cmp    $0x73,%edx
801008b3:	75 33                	jne    801008e8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
801008b5:	8d 47 04             	lea    0x4(%edi),%eax
801008b8:	8b 3f                	mov    (%edi),%edi
801008ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801008bd:	85 ff                	test   %edi,%edi
801008bf:	0f 85 3b 01 00 00    	jne    80100a00 <cprintf+0x1f0>
        s = "(null)";
801008c5:	bf 98 75 10 80       	mov    $0x80107598,%edi
      for(; *s; s++)
801008ca:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801008cd:	b8 28 00 00 00       	mov    $0x28,%eax
801008d2:	89 fb                	mov    %edi,%ebx
  if(panicked){
801008d4:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
801008da:	85 d2                	test   %edx,%edx
801008dc:	0f 84 38 01 00 00    	je     80100a1a <cprintf+0x20a>
801008e2:	fa                   	cli    
    for(;;)
801008e3:	eb fe                	jmp    801008e3 <cprintf+0xd3>
801008e5:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e8:	83 fa 78             	cmp    $0x78,%edx
801008eb:	0f 85 97 00 00 00    	jne    80100988 <cprintf+0x178>
      printint(*argp++, 16, 0);
801008f1:	8d 47 04             	lea    0x4(%edi),%eax
801008f4:	31 c9                	xor    %ecx,%ecx
801008f6:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008fb:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801008fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100901:	8b 07                	mov    (%edi),%eax
80100903:	e8 58 fe ff ff       	call   80100760 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100908:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010090c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010090f:	85 c0                	test   %eax,%eax
80100911:	0f 85 29 ff ff ff    	jne    80100840 <cprintf+0x30>
80100917:	e9 7a ff ff ff       	jmp    80100896 <cprintf+0x86>
8010091c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100920:	8b 0d 78 f4 10 80    	mov    0x8010f478,%ecx
80100926:	85 c9                	test   %ecx,%ecx
80100928:	74 06                	je     80100930 <cprintf+0x120>
8010092a:	fa                   	cli    
    for(;;)
8010092b:	eb fe                	jmp    8010092b <cprintf+0x11b>
8010092d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100930:	83 ec 0c             	sub    $0xc,%esp
80100933:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100936:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100939:	50                   	push   %eax
8010093a:	e8 11 57 00 00       	call   80106050 <uartputc>
  cgaputc(c);
8010093f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100942:	e8 b9 fa ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100947:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
8010094b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010094e:	85 c0                	test   %eax,%eax
80100950:	0f 85 ea fe ff ff    	jne    80100840 <cprintf+0x30>
80100956:	e9 3b ff ff ff       	jmp    80100896 <cprintf+0x86>
8010095b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
    acquire(&cons.lock);
80100960:	83 ec 0c             	sub    $0xc,%esp
80100963:	68 40 f4 10 80       	push   $0x8010f440
80100968:	e8 d3 3f 00 00       	call   80104940 <acquire>
8010096d:	83 c4 10             	add    $0x10,%esp
80100970:	e9 b4 fe ff ff       	jmp    80100829 <cprintf+0x19>
80100975:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100978:	a1 78 f4 10 80       	mov    0x8010f478,%eax
8010097d:	85 c0                	test   %eax,%eax
8010097f:	74 4f                	je     801009d0 <cprintf+0x1c0>
80100981:	fa                   	cli    
    for(;;)
80100982:	eb fe                	jmp    80100982 <cprintf+0x172>
80100984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100988:	8b 0d 78 f4 10 80    	mov    0x8010f478,%ecx
8010098e:	85 c9                	test   %ecx,%ecx
80100990:	74 06                	je     80100998 <cprintf+0x188>
80100992:	fa                   	cli    
    for(;;)
80100993:	eb fe                	jmp    80100993 <cprintf+0x183>
80100995:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100998:	83 ec 0c             	sub    $0xc,%esp
8010099b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010099e:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801009a1:	6a 25                	push   $0x25
801009a3:	e8 a8 56 00 00       	call   80106050 <uartputc>
  cgaputc(c);
801009a8:	b8 25 00 00 00       	mov    $0x25,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <cgaputc>
      consputc(c);
801009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801009b5:	e8 b6 fc ff ff       	call   80100670 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009ba:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      break;
801009be:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009c1:	85 c0                	test   %eax,%eax
801009c3:	0f 85 77 fe ff ff    	jne    80100840 <cprintf+0x30>
801009c9:	e9 c8 fe ff ff       	jmp    80100896 <cprintf+0x86>
801009ce:	66 90                	xchg   %ax,%ax
    uartputc(c);
801009d0:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009d3:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801009d6:	6a 25                	push   $0x25
801009d8:	e8 73 56 00 00       	call   80106050 <uartputc>
  cgaputc(c);
801009dd:	b8 25 00 00 00       	mov    $0x25,%eax
801009e2:	e8 19 fa ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009e7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
801009eb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009ee:	85 c0                	test   %eax,%eax
801009f0:	0f 85 4a fe ff ff    	jne    80100840 <cprintf+0x30>
801009f6:	e9 9b fe ff ff       	jmp    80100896 <cprintf+0x86>
801009fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ff:	90                   	nop
      for(; *s; s++)
80100a00:	0f b6 07             	movzbl (%edi),%eax
80100a03:	84 c0                	test   %al,%al
80100a05:	74 57                	je     80100a5e <cprintf+0x24e>
  if(panicked){
80100a07:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
80100a0d:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100a10:	89 fb                	mov    %edi,%ebx
80100a12:	85 d2                	test   %edx,%edx
80100a14:	0f 85 c8 fe ff ff    	jne    801008e2 <cprintf+0xd2>
    uartputc(c);
80100a1a:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
80100a1d:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
80100a20:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100a23:	57                   	push   %edi
80100a24:	e8 27 56 00 00       	call   80106050 <uartputc>
  cgaputc(c);
80100a29:	89 f8                	mov    %edi,%eax
80100a2b:	e8 d0 f9 ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
80100a30:	0f b6 03             	movzbl (%ebx),%eax
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	84 c0                	test   %al,%al
80100a38:	0f 85 96 fe ff ff    	jne    801008d4 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
80100a3e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80100a41:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100a44:	e9 42 fe ff ff       	jmp    8010088b <cprintf+0x7b>
    release(&cons.lock);
80100a49:	83 ec 0c             	sub    $0xc,%esp
80100a4c:	68 40 f4 10 80       	push   $0x8010f440
80100a51:	e8 8a 3e 00 00       	call   801048e0 <release>
80100a56:	83 c4 10             	add    $0x10,%esp
}
80100a59:	e9 43 fe ff ff       	jmp    801008a1 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100a5e:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100a61:	e9 25 fe ff ff       	jmp    8010088b <cprintf+0x7b>
    panic("null fmt");
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	68 9f 75 10 80       	push   $0x8010759f
80100a6e:	e8 0d f9 ff ff       	call   80100380 <panic>
80100a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a80 <for_str>:
void for_str(char a[count_entered+1],char b[count_entered+1]){
80100a80:	55                   	push   %ebp
  for(int i=0;i<count_entered/4+1;i++){
80100a81:	83 3d 28 f4 10 80 fd 	cmpl   $0xfffffffd,0x8010f428
void for_str(char a[count_entered+1],char b[count_entered+1]){
80100a88:	89 e5                	mov    %esp,%ebp
80100a8a:	56                   	push   %esi
80100a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100a8e:	53                   	push   %ebx
80100a8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(int i=0;i<count_entered/4+1;i++){
80100a92:	7c 2b                	jl     80100abf <for_str+0x3f>
80100a94:	31 d2                	xor    %edx,%edx
80100a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
    b[i]=a[i];
80100aa0:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
80100aa4:	88 04 13             	mov    %al,(%ebx,%edx,1)
  for(int i=0;i<count_entered/4+1;i++){
80100aa7:	8b 35 28 f4 10 80    	mov    0x8010f428,%esi
80100aad:	83 c2 01             	add    $0x1,%edx
80100ab0:	8d 46 03             	lea    0x3(%esi),%eax
80100ab3:	85 f6                	test   %esi,%esi
80100ab5:	0f 49 c6             	cmovns %esi,%eax
80100ab8:	c1 f8 02             	sar    $0x2,%eax
80100abb:	39 d0                	cmp    %edx,%eax
80100abd:	7d e1                	jge    80100aa0 <for_str+0x20>
}
80100abf:	5b                   	pop    %ebx
80100ac0:	5e                   	pop    %esi
80100ac1:	5d                   	pop    %ebp
80100ac2:	c3                   	ret    
80100ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ad0 <consoleintr>:
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	57                   	push   %edi
  int c, doprocdump = 0;
80100ad4:	31 ff                	xor    %edi,%edi
{
80100ad6:	56                   	push   %esi
80100ad7:	53                   	push   %ebx
80100ad8:	83 ec 28             	sub    $0x28,%esp
80100adb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100ade:	68 40 f4 10 80       	push   $0x8010f440
80100ae3:	e8 58 3e 00 00       	call   80104940 <acquire>
  while((c = getc()) >= 0){
80100ae8:	83 c4 10             	add    $0x10,%esp
80100aeb:	ff d6                	call   *%esi
80100aed:	85 c0                	test   %eax,%eax
80100aef:	78 37                	js     80100b28 <consoleintr+0x58>
    switch(c){
80100af1:	83 f8 7f             	cmp    $0x7f,%eax
80100af4:	0f 84 af 00 00 00    	je     80100ba9 <consoleintr+0xd9>
80100afa:	7e 54                	jle    80100b50 <consoleintr+0x80>
80100afc:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100b01:	0f 84 e9 01 00 00    	je     80100cf0 <consoleintr+0x220>
80100b07:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100b0c:	0f 85 ee 00 00 00    	jne    80100c00 <consoleintr+0x130>
      cgaputc(c);
80100b12:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100b17:	e8 e4 f8 ff ff       	call   80100400 <cgaputc>
  while((c = getc()) >= 0){
80100b1c:	ff d6                	call   *%esi
80100b1e:	85 c0                	test   %eax,%eax
80100b20:	79 cf                	jns    80100af1 <consoleintr+0x21>
80100b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&cons.lock);
80100b28:	83 ec 0c             	sub    $0xc,%esp
80100b2b:	68 40 f4 10 80       	push   $0x8010f440
80100b30:	e8 ab 3d 00 00       	call   801048e0 <release>
  if(doprocdump) {
80100b35:	83 c4 10             	add    $0x10,%esp
80100b38:	85 ff                	test   %edi,%edi
80100b3a:	0f 85 4d 02 00 00    	jne    80100d8d <consoleintr+0x2bd>
}
80100b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b43:	5b                   	pop    %ebx
80100b44:	5e                   	pop    %esi
80100b45:	5f                   	pop    %edi
80100b46:	5d                   	pop    %ebp
80100b47:	c3                   	ret    
80100b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b4f:	90                   	nop
    switch(c){
80100b50:	83 f8 10             	cmp    $0x10,%eax
80100b53:	0f 84 f7 00 00 00    	je     80100c50 <consoleintr+0x180>
80100b59:	83 f8 15             	cmp    $0x15,%eax
80100b5c:	75 42                	jne    80100ba0 <consoleintr+0xd0>
      while(input.e != input.w &&
80100b5e:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b63:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100b69:	74 80                	je     80100aeb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100b6b:	83 e8 01             	sub    $0x1,%eax
80100b6e:	89 c2                	mov    %eax,%edx
80100b70:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100b73:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100b7a:	0f 84 6b ff ff ff    	je     80100aeb <consoleintr+0x1b>
  if(panicked){
80100b80:	8b 1d 78 f4 10 80    	mov    0x8010f478,%ebx
        input.e--;
80100b86:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100b8b:	85 db                	test   %ebx,%ebx
80100b8d:	0f 84 c7 00 00 00    	je     80100c5a <consoleintr+0x18a>
80100b93:	fa                   	cli    
    for(;;)
80100b94:	eb fe                	jmp    80100b94 <consoleintr+0xc4>
80100b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b9d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100ba0:	83 f8 08             	cmp    $0x8,%eax
80100ba3:	0f 85 57 01 00 00    	jne    80100d00 <consoleintr+0x230>
      if(input.e != input.w && back_counter < (strlen(input.buf) - backspaces)){
80100ba9:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80100bae:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100bb4:	0f 84 31 ff ff ff    	je     80100aeb <consoleintr+0x1b>
80100bba:	83 ec 0c             	sub    $0xc,%esp
80100bbd:	68 80 ee 10 80       	push   $0x8010ee80
80100bc2:	e8 39 40 00 00       	call   80104c00 <strlen>
80100bc7:	8b 15 20 f4 10 80    	mov    0x8010f420,%edx
80100bcd:	83 c4 10             	add    $0x10,%esp
80100bd0:	29 d0                	sub    %edx,%eax
80100bd2:	3b 05 24 f4 10 80    	cmp    0x8010f424,%eax
80100bd8:	0f 8e 0d ff ff ff    	jle    80100aeb <consoleintr+0x1b>
  if(panicked){
80100bde:	8b 0d 78 f4 10 80    	mov    0x8010f478,%ecx
        input.e--;
80100be4:	83 2d 08 ef 10 80 01 	subl   $0x1,0x8010ef08
  if(panicked){
80100beb:	85 c9                	test   %ecx,%ecx
80100bed:	0f 84 b2 01 00 00    	je     80100da5 <consoleintr+0x2d5>
80100bf3:	fa                   	cli    
    for(;;)
80100bf4:	eb fe                	jmp    80100bf4 <consoleintr+0x124>
80100bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bfd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100c00:	31 db                	xor    %ebx,%ebx
80100c02:	3d e2 00 00 00       	cmp    $0xe2,%eax
80100c07:	0f 85 03 01 00 00    	jne    80100d10 <consoleintr+0x240>
      for(int i=0; i < strlen(history[curr_index]); i++){
80100c0d:	a1 0c ef 10 80       	mov    0x8010ef0c,%eax
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	c1 e0 07             	shl    $0x7,%eax
80100c18:	05 20 ef 10 80       	add    $0x8010ef20,%eax
80100c1d:	50                   	push   %eax
80100c1e:	e8 dd 3f 00 00       	call   80104c00 <strlen>
80100c23:	83 c4 10             	add    $0x10,%esp
80100c26:	39 d8                	cmp    %ebx,%eax
80100c28:	0f 8e 6b 01 00 00    	jle    80100d99 <consoleintr+0x2c9>
          x = history[curr_index][i];
80100c2e:	a1 0c ef 10 80       	mov    0x8010ef0c,%eax
80100c33:	c1 e0 07             	shl    $0x7,%eax
80100c36:	0f b6 94 03 20 ef 10 	movzbl -0x7fef10e0(%ebx,%eax,1),%edx
80100c3d:	80 
  if(panicked){
80100c3e:	a1 78 f4 10 80       	mov    0x8010f478,%eax
80100c43:	85 c0                	test   %eax,%eax
80100c45:	74 69                	je     80100cb0 <consoleintr+0x1e0>
80100c47:	fa                   	cli    
    for(;;)
80100c48:	eb fe                	jmp    80100c48 <consoleintr+0x178>
80100c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100c50:	bf 01 00 00 00       	mov    $0x1,%edi
80100c55:	e9 91 fe ff ff       	jmp    80100aeb <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100c5a:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100c5d:	83 05 20 f4 10 80 01 	addl   $0x1,0x8010f420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100c64:	6a 08                	push   $0x8
80100c66:	e8 e5 53 00 00       	call   80106050 <uartputc>
80100c6b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100c72:	e8 d9 53 00 00       	call   80106050 <uartputc>
80100c77:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100c7e:	e8 cd 53 00 00       	call   80106050 <uartputc>
  cgaputc(c);
80100c83:	b8 00 01 00 00       	mov    $0x100,%eax
80100c88:	e8 73 f7 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100c8d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100c92:	83 c4 10             	add    $0x10,%esp
80100c95:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100c9b:	0f 85 ca fe ff ff    	jne    80100b6b <consoleintr+0x9b>
80100ca1:	e9 45 fe ff ff       	jmp    80100aeb <consoleintr+0x1b>
80100ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cad:	8d 76 00             	lea    0x0(%esi),%esi
          consputc(x);
80100cb0:	0f be c2             	movsbl %dl,%eax
    uartputc(c);
80100cb3:	83 ec 0c             	sub    $0xc,%esp
          consputc(x);
80100cb6:	88 55 e3             	mov    %dl,-0x1d(%ebp)
      for(int i=0; i < strlen(history[curr_index]); i++){
80100cb9:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100cbc:	50                   	push   %eax
80100cbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cc0:	e8 8b 53 00 00       	call   80106050 <uartputc>
  cgaputc(c);
80100cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cc8:	e8 33 f7 ff ff       	call   80100400 <cgaputc>
          input.buf[input.e++] = x;
80100ccd:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100cd2:	0f b6 55 e3          	movzbl -0x1d(%ebp),%edx
      for(int i=0; i < strlen(history[curr_index]); i++){
80100cd6:	83 c4 10             	add    $0x10,%esp
          input.buf[input.e++] = x;
80100cd9:	8d 48 01             	lea    0x1(%eax),%ecx
80100cdc:	88 90 80 ee 10 80    	mov    %dl,-0x7fef1180(%eax)
80100ce2:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100ce8:	e9 20 ff ff ff       	jmp    80100c0d <consoleintr+0x13d>
80100ced:	8d 76 00             	lea    0x0(%esi),%esi
      cgaputc(c);
80100cf0:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100cf5:	e8 06 f7 ff ff       	call   80100400 <cgaputc>
      break;
80100cfa:	e9 ec fd ff ff       	jmp    80100aeb <consoleintr+0x1b>
80100cff:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100d00:	85 c0                	test   %eax,%eax
80100d02:	0f 84 e3 fd ff ff    	je     80100aeb <consoleintr+0x1b>
80100d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d0f:	90                   	nop
80100d10:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100d16:	89 ca                	mov    %ecx,%edx
80100d18:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100d1e:	83 fa 7f             	cmp    $0x7f,%edx
80100d21:	0f 87 c4 fd ff ff    	ja     80100aeb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d27:	8d 51 01             	lea    0x1(%ecx),%edx
80100d2a:	83 e1 7f             	and    $0x7f,%ecx
80100d2d:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100d33:	83 f8 0d             	cmp    $0xd,%eax
80100d36:	0f 84 a6 00 00 00    	je     80100de2 <consoleintr+0x312>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d3c:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
        consputc(c);
80100d42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100d45:	e8 26 f9 ff ff       	call   80100670 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d4d:	83 f8 0a             	cmp    $0xa,%eax
80100d50:	0f 84 9d 00 00 00    	je     80100df3 <consoleintr+0x323>
80100d56:	83 f8 04             	cmp    $0x4,%eax
80100d59:	0f 84 94 00 00 00    	je     80100df3 <consoleintr+0x323>
80100d5f:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100d64:	83 e8 80             	sub    $0xffffff80,%eax
80100d67:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100d6d:	0f 85 78 fd ff ff    	jne    80100aeb <consoleintr+0x1b>
          wakeup(&input.r);
80100d73:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100d76:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100d7b:	68 00 ef 10 80       	push   $0x8010ef00
80100d80:	e8 1b 37 00 00       	call   801044a0 <wakeup>
80100d85:	83 c4 10             	add    $0x10,%esp
80100d88:	e9 5e fd ff ff       	jmp    80100aeb <consoleintr+0x1b>
}
80100d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d90:	5b                   	pop    %ebx
80100d91:	5e                   	pop    %esi
80100d92:	5f                   	pop    %edi
80100d93:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100d94:	e9 e7 37 00 00       	jmp    80104580 <procdump>
        curr_index --;
80100d99:	83 2d 0c ef 10 80 01 	subl   $0x1,0x8010ef0c
      break;
80100da0:	e9 46 fd ff ff       	jmp    80100aeb <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100da5:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100da8:	83 c2 01             	add    $0x1,%edx
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100dab:	6a 08                	push   $0x8
    backspaces++;
80100dad:	89 15 20 f4 10 80    	mov    %edx,0x8010f420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100db3:	e8 98 52 00 00       	call   80106050 <uartputc>
80100db8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100dbf:	e8 8c 52 00 00       	call   80106050 <uartputc>
80100dc4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100dcb:	e8 80 52 00 00       	call   80106050 <uartputc>
  cgaputc(c);
80100dd0:	b8 00 01 00 00       	mov    $0x100,%eax
80100dd5:	e8 26 f6 ff ff       	call   80100400 <cgaputc>
}
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	e9 09 fd ff ff       	jmp    80100aeb <consoleintr+0x1b>
        consputc(c);
80100de2:	b8 0a 00 00 00       	mov    $0xa,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100de7:	c6 81 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ecx)
        consputc(c);
80100dee:	e8 7d f8 ff ff       	call   80100670 <consputc>
          input.w = input.e;
80100df3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100df8:	e9 76 ff ff ff       	jmp    80100d73 <consoleintr+0x2a3>
80100dfd:	8d 76 00             	lea    0x0(%esi),%esi

80100e00 <consoleinit>:

void
consoleinit(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100e06:	68 a8 75 10 80       	push   $0x801075a8
80100e0b:	68 40 f4 10 80       	push   $0x8010f440
80100e10:	e8 5b 39 00 00       	call   80104770 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100e15:	58                   	pop    %eax
80100e16:	5a                   	pop    %edx
80100e17:	6a 00                	push   $0x0
80100e19:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100e1b:	c7 05 2c fe 10 80 e0 	movl   $0x801006e0,0x8010fe2c
80100e22:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100e25:	c7 05 28 fe 10 80 80 	movl   $0x80100280,0x8010fe28
80100e2c:	02 10 80 
  cons.locking = 1;
80100e2f:	c7 05 74 f4 10 80 01 	movl   $0x1,0x8010f474
80100e36:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100e39:	e8 e2 19 00 00       	call   80102820 <ioapicenable>
}
80100e3e:	83 c4 10             	add    $0x10,%esp
80100e41:	c9                   	leave  
80100e42:	c3                   	ret    
80100e43:	66 90                	xchg   %ax,%ax
80100e45:	66 90                	xchg   %ax,%ax
80100e47:	66 90                	xchg   %ax,%ax
80100e49:	66 90                	xchg   %ax,%ax
80100e4b:	66 90                	xchg   %ax,%ax
80100e4d:	66 90                	xchg   %ax,%ax
80100e4f:	90                   	nop

80100e50 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100e5c:	e8 af 2e 00 00       	call   80103d10 <myproc>
80100e61:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100e67:	e8 94 22 00 00       	call   80103100 <begin_op>

  if((ip = namei(path)) == 0){
80100e6c:	83 ec 0c             	sub    $0xc,%esp
80100e6f:	ff 75 08             	push   0x8(%ebp)
80100e72:	e8 c9 15 00 00       	call   80102440 <namei>
80100e77:	83 c4 10             	add    $0x10,%esp
80100e7a:	85 c0                	test   %eax,%eax
80100e7c:	0f 84 02 03 00 00    	je     80101184 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100e82:	83 ec 0c             	sub    $0xc,%esp
80100e85:	89 c3                	mov    %eax,%ebx
80100e87:	50                   	push   %eax
80100e88:	e8 93 0c 00 00       	call   80101b20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e8d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100e93:	6a 34                	push   $0x34
80100e95:	6a 00                	push   $0x0
80100e97:	50                   	push   %eax
80100e98:	53                   	push   %ebx
80100e99:	e8 92 0f 00 00       	call   80101e30 <readi>
80100e9e:	83 c4 20             	add    $0x20,%esp
80100ea1:	83 f8 34             	cmp    $0x34,%eax
80100ea4:	74 22                	je     80100ec8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ea6:	83 ec 0c             	sub    $0xc,%esp
80100ea9:	53                   	push   %ebx
80100eaa:	e8 01 0f 00 00       	call   80101db0 <iunlockput>
    end_op();
80100eaf:	e8 bc 22 00 00       	call   80103170 <end_op>
80100eb4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebf:	5b                   	pop    %ebx
80100ec0:	5e                   	pop    %esi
80100ec1:	5f                   	pop    %edi
80100ec2:	5d                   	pop    %ebp
80100ec3:	c3                   	ret    
80100ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100ec8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ecf:	45 4c 46 
80100ed2:	75 d2                	jne    80100ea6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100ed4:	e8 07 63 00 00       	call   801071e0 <setupkvm>
80100ed9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100edf:	85 c0                	test   %eax,%eax
80100ee1:	74 c3                	je     80100ea6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ee3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100eea:	00 
80100eeb:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100ef1:	0f 84 ac 02 00 00    	je     801011a3 <exec+0x353>
  sz = 0;
80100ef7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100efe:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f01:	31 ff                	xor    %edi,%edi
80100f03:	e9 8e 00 00 00       	jmp    80100f96 <exec+0x146>
80100f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f0f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100f10:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100f17:	75 6c                	jne    80100f85 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100f19:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100f1f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100f25:	0f 82 87 00 00 00    	jb     80100fb2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100f2b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100f31:	72 7f                	jb     80100fb2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100f33:	83 ec 04             	sub    $0x4,%esp
80100f36:	50                   	push   %eax
80100f37:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100f3d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f43:	e8 b8 60 00 00       	call   80107000 <allocuvm>
80100f48:	83 c4 10             	add    $0x10,%esp
80100f4b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f51:	85 c0                	test   %eax,%eax
80100f53:	74 5d                	je     80100fb2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100f55:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f5b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f60:	75 50                	jne    80100fb2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f62:	83 ec 0c             	sub    $0xc,%esp
80100f65:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100f6b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100f71:	53                   	push   %ebx
80100f72:	50                   	push   %eax
80100f73:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f79:	e8 92 5f 00 00       	call   80106f10 <loaduvm>
80100f7e:	83 c4 20             	add    $0x20,%esp
80100f81:	85 c0                	test   %eax,%eax
80100f83:	78 2d                	js     80100fb2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f85:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f8c:	83 c7 01             	add    $0x1,%edi
80100f8f:	83 c6 20             	add    $0x20,%esi
80100f92:	39 f8                	cmp    %edi,%eax
80100f94:	7e 3a                	jle    80100fd0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100f96:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100f9c:	6a 20                	push   $0x20
80100f9e:	56                   	push   %esi
80100f9f:	50                   	push   %eax
80100fa0:	53                   	push   %ebx
80100fa1:	e8 8a 0e 00 00       	call   80101e30 <readi>
80100fa6:	83 c4 10             	add    $0x10,%esp
80100fa9:	83 f8 20             	cmp    $0x20,%eax
80100fac:	0f 84 5e ff ff ff    	je     80100f10 <exec+0xc0>
    freevm(pgdir);
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100fbb:	e8 a0 61 00 00       	call   80107160 <freevm>
  if(ip){
80100fc0:	83 c4 10             	add    $0x10,%esp
80100fc3:	e9 de fe ff ff       	jmp    80100ea6 <exec+0x56>
80100fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcf:	90                   	nop
  sz = PGROUNDUP(sz);
80100fd0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100fd6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100fdc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100fe2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	53                   	push   %ebx
80100fec:	e8 bf 0d 00 00       	call   80101db0 <iunlockput>
  end_op();
80100ff1:	e8 7a 21 00 00       	call   80103170 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ff6:	83 c4 0c             	add    $0xc,%esp
80100ff9:	56                   	push   %esi
80100ffa:	57                   	push   %edi
80100ffb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101001:	57                   	push   %edi
80101002:	e8 f9 5f 00 00       	call   80107000 <allocuvm>
80101007:	83 c4 10             	add    $0x10,%esp
8010100a:	89 c6                	mov    %eax,%esi
8010100c:	85 c0                	test   %eax,%eax
8010100e:	0f 84 94 00 00 00    	je     801010a8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101014:	83 ec 08             	sub    $0x8,%esp
80101017:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010101d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010101f:	50                   	push   %eax
80101020:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101021:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101023:	e8 58 62 00 00       	call   80107280 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101028:	8b 45 0c             	mov    0xc(%ebp),%eax
8010102b:	83 c4 10             	add    $0x10,%esp
8010102e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101034:	8b 00                	mov    (%eax),%eax
80101036:	85 c0                	test   %eax,%eax
80101038:	0f 84 8b 00 00 00    	je     801010c9 <exec+0x279>
8010103e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101044:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010104a:	eb 23                	jmp    8010106f <exec+0x21f>
8010104c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101050:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101053:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010105a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010105d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101063:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101066:	85 c0                	test   %eax,%eax
80101068:	74 59                	je     801010c3 <exec+0x273>
    if(argc >= MAXARG)
8010106a:	83 ff 20             	cmp    $0x20,%edi
8010106d:	74 39                	je     801010a8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	50                   	push   %eax
80101073:	e8 88 3b 00 00       	call   80104c00 <strlen>
80101078:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010107a:	58                   	pop    %eax
8010107b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010107e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101081:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101084:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101087:	e8 74 3b 00 00       	call   80104c00 <strlen>
8010108c:	83 c0 01             	add    $0x1,%eax
8010108f:	50                   	push   %eax
80101090:	8b 45 0c             	mov    0xc(%ebp),%eax
80101093:	ff 34 b8             	push   (%eax,%edi,4)
80101096:	53                   	push   %ebx
80101097:	56                   	push   %esi
80101098:	e8 b3 63 00 00       	call   80107450 <copyout>
8010109d:	83 c4 20             	add    $0x20,%esp
801010a0:	85 c0                	test   %eax,%eax
801010a2:	79 ac                	jns    80101050 <exec+0x200>
801010a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801010a8:	83 ec 0c             	sub    $0xc,%esp
801010ab:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010b1:	e8 aa 60 00 00       	call   80107160 <freevm>
801010b6:	83 c4 10             	add    $0x10,%esp
  return -1;
801010b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010be:	e9 f9 fd ff ff       	jmp    80100ebc <exec+0x6c>
801010c3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010c9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801010d0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801010d2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801010d9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010dd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801010df:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801010e2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801010e8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010ea:	50                   	push   %eax
801010eb:	52                   	push   %edx
801010ec:	53                   	push   %ebx
801010ed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801010f3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801010fa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010fd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101103:	e8 48 63 00 00       	call   80107450 <copyout>
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	85 c0                	test   %eax,%eax
8010110d:	78 99                	js     801010a8 <exec+0x258>
  for(last=s=path; *s; s++)
8010110f:	8b 45 08             	mov    0x8(%ebp),%eax
80101112:	8b 55 08             	mov    0x8(%ebp),%edx
80101115:	0f b6 00             	movzbl (%eax),%eax
80101118:	84 c0                	test   %al,%al
8010111a:	74 13                	je     8010112f <exec+0x2df>
8010111c:	89 d1                	mov    %edx,%ecx
8010111e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101120:	83 c1 01             	add    $0x1,%ecx
80101123:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101125:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101128:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010112b:	84 c0                	test   %al,%al
8010112d:	75 f1                	jne    80101120 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010112f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101135:	83 ec 04             	sub    $0x4,%esp
80101138:	6a 10                	push   $0x10
8010113a:	89 f8                	mov    %edi,%eax
8010113c:	52                   	push   %edx
8010113d:	83 c0 6c             	add    $0x6c,%eax
80101140:	50                   	push   %eax
80101141:	e8 7a 3a 00 00       	call   80104bc0 <safestrcpy>
  curproc->pgdir = pgdir;
80101146:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010114c:	89 f8                	mov    %edi,%eax
8010114e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101151:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101153:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101156:	89 c1                	mov    %eax,%ecx
80101158:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010115e:	8b 40 18             	mov    0x18(%eax),%eax
80101161:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101164:	8b 41 18             	mov    0x18(%ecx),%eax
80101167:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010116a:	89 0c 24             	mov    %ecx,(%esp)
8010116d:	e8 0e 5c 00 00       	call   80106d80 <switchuvm>
  freevm(oldpgdir);
80101172:	89 3c 24             	mov    %edi,(%esp)
80101175:	e8 e6 5f 00 00       	call   80107160 <freevm>
  return 0;
8010117a:	83 c4 10             	add    $0x10,%esp
8010117d:	31 c0                	xor    %eax,%eax
8010117f:	e9 38 fd ff ff       	jmp    80100ebc <exec+0x6c>
    end_op();
80101184:	e8 e7 1f 00 00       	call   80103170 <end_op>
    cprintf("exec: fail\n");
80101189:	83 ec 0c             	sub    $0xc,%esp
8010118c:	68 c1 75 10 80       	push   $0x801075c1
80101191:	e8 7a f6 ff ff       	call   80100810 <cprintf>
    return -1;
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010119e:	e9 19 fd ff ff       	jmp    80100ebc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011a3:	be 00 20 00 00       	mov    $0x2000,%esi
801011a8:	31 ff                	xor    %edi,%edi
801011aa:	e9 39 fe ff ff       	jmp    80100fe8 <exec+0x198>
801011af:	90                   	nop

801011b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801011b6:	68 cd 75 10 80       	push   $0x801075cd
801011bb:	68 80 f4 10 80       	push   $0x8010f480
801011c0:	e8 ab 35 00 00       	call   80104770 <initlock>
}
801011c5:	83 c4 10             	add    $0x10,%esp
801011c8:	c9                   	leave  
801011c9:	c3                   	ret    
801011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d4:	bb b4 f4 10 80       	mov    $0x8010f4b4,%ebx
{
801011d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011dc:	68 80 f4 10 80       	push   $0x8010f480
801011e1:	e8 5a 37 00 00       	call   80104940 <acquire>
801011e6:	83 c4 10             	add    $0x10,%esp
801011e9:	eb 10                	jmp    801011fb <filealloc+0x2b>
801011eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011ef:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011f0:	83 c3 18             	add    $0x18,%ebx
801011f3:	81 fb 14 fe 10 80    	cmp    $0x8010fe14,%ebx
801011f9:	74 25                	je     80101220 <filealloc+0x50>
    if(f->ref == 0){
801011fb:	8b 43 04             	mov    0x4(%ebx),%eax
801011fe:	85 c0                	test   %eax,%eax
80101200:	75 ee                	jne    801011f0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101202:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101205:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010120c:	68 80 f4 10 80       	push   $0x8010f480
80101211:	e8 ca 36 00 00       	call   801048e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101216:	89 d8                	mov    %ebx,%eax
      return f;
80101218:	83 c4 10             	add    $0x10,%esp
}
8010121b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010121e:	c9                   	leave  
8010121f:	c3                   	ret    
  release(&ftable.lock);
80101220:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101223:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101225:	68 80 f4 10 80       	push   $0x8010f480
8010122a:	e8 b1 36 00 00       	call   801048e0 <release>
}
8010122f:	89 d8                	mov    %ebx,%eax
  return 0;
80101231:	83 c4 10             	add    $0x10,%esp
}
80101234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101237:	c9                   	leave  
80101238:	c3                   	ret    
80101239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101240 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	53                   	push   %ebx
80101244:	83 ec 10             	sub    $0x10,%esp
80101247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010124a:	68 80 f4 10 80       	push   $0x8010f480
8010124f:	e8 ec 36 00 00       	call   80104940 <acquire>
  if(f->ref < 1)
80101254:	8b 43 04             	mov    0x4(%ebx),%eax
80101257:	83 c4 10             	add    $0x10,%esp
8010125a:	85 c0                	test   %eax,%eax
8010125c:	7e 1a                	jle    80101278 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010125e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101261:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101264:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101267:	68 80 f4 10 80       	push   $0x8010f480
8010126c:	e8 6f 36 00 00       	call   801048e0 <release>
  return f;
}
80101271:	89 d8                	mov    %ebx,%eax
80101273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101276:	c9                   	leave  
80101277:	c3                   	ret    
    panic("filedup");
80101278:	83 ec 0c             	sub    $0xc,%esp
8010127b:	68 d4 75 10 80       	push   $0x801075d4
80101280:	e8 fb f0 ff ff       	call   80100380 <panic>
80101285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101290 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 28             	sub    $0x28,%esp
80101299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010129c:	68 80 f4 10 80       	push   $0x8010f480
801012a1:	e8 9a 36 00 00       	call   80104940 <acquire>
  if(f->ref < 1)
801012a6:	8b 53 04             	mov    0x4(%ebx),%edx
801012a9:	83 c4 10             	add    $0x10,%esp
801012ac:	85 d2                	test   %edx,%edx
801012ae:	0f 8e a5 00 00 00    	jle    80101359 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801012b4:	83 ea 01             	sub    $0x1,%edx
801012b7:	89 53 04             	mov    %edx,0x4(%ebx)
801012ba:	75 44                	jne    80101300 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012bc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012c0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012c3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801012c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012cb:	8b 73 0c             	mov    0xc(%ebx),%esi
801012ce:	88 45 e7             	mov    %al,-0x19(%ebp)
801012d1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012d4:	68 80 f4 10 80       	push   $0x8010f480
  ff = *f;
801012d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012dc:	e8 ff 35 00 00       	call   801048e0 <release>

  if(ff.type == FD_PIPE)
801012e1:	83 c4 10             	add    $0x10,%esp
801012e4:	83 ff 01             	cmp    $0x1,%edi
801012e7:	74 57                	je     80101340 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012e9:	83 ff 02             	cmp    $0x2,%edi
801012ec:	74 2a                	je     80101318 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f1:	5b                   	pop    %ebx
801012f2:	5e                   	pop    %esi
801012f3:	5f                   	pop    %edi
801012f4:	5d                   	pop    %ebp
801012f5:	c3                   	ret    
801012f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012fd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101300:	c7 45 08 80 f4 10 80 	movl   $0x8010f480,0x8(%ebp)
}
80101307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130a:	5b                   	pop    %ebx
8010130b:	5e                   	pop    %esi
8010130c:	5f                   	pop    %edi
8010130d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010130e:	e9 cd 35 00 00       	jmp    801048e0 <release>
80101313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101317:	90                   	nop
    begin_op();
80101318:	e8 e3 1d 00 00       	call   80103100 <begin_op>
    iput(ff.ip);
8010131d:	83 ec 0c             	sub    $0xc,%esp
80101320:	ff 75 e0             	push   -0x20(%ebp)
80101323:	e8 28 09 00 00       	call   80101c50 <iput>
    end_op();
80101328:	83 c4 10             	add    $0x10,%esp
}
8010132b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132e:	5b                   	pop    %ebx
8010132f:	5e                   	pop    %esi
80101330:	5f                   	pop    %edi
80101331:	5d                   	pop    %ebp
    end_op();
80101332:	e9 39 1e 00 00       	jmp    80103170 <end_op>
80101337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101340:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101344:	83 ec 08             	sub    $0x8,%esp
80101347:	53                   	push   %ebx
80101348:	56                   	push   %esi
80101349:	e8 82 25 00 00       	call   801038d0 <pipeclose>
8010134e:	83 c4 10             	add    $0x10,%esp
}
80101351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
    panic("fileclose");
80101359:	83 ec 0c             	sub    $0xc,%esp
8010135c:	68 dc 75 10 80       	push   $0x801075dc
80101361:	e8 1a f0 ff ff       	call   80100380 <panic>
80101366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136d:	8d 76 00             	lea    0x0(%esi),%esi

80101370 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	53                   	push   %ebx
80101374:	83 ec 04             	sub    $0x4,%esp
80101377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010137a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010137d:	75 31                	jne    801013b0 <filestat+0x40>
    ilock(f->ip);
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	ff 73 10             	push   0x10(%ebx)
80101385:	e8 96 07 00 00       	call   80101b20 <ilock>
    stati(f->ip, st);
8010138a:	58                   	pop    %eax
8010138b:	5a                   	pop    %edx
8010138c:	ff 75 0c             	push   0xc(%ebp)
8010138f:	ff 73 10             	push   0x10(%ebx)
80101392:	e8 69 0a 00 00       	call   80101e00 <stati>
    iunlock(f->ip);
80101397:	59                   	pop    %ecx
80101398:	ff 73 10             	push   0x10(%ebx)
8010139b:	e8 60 08 00 00       	call   80101c00 <iunlock>
    return 0;
  }
  return -1;
}
801013a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801013a3:	83 c4 10             	add    $0x10,%esp
801013a6:	31 c0                	xor    %eax,%eax
}
801013a8:	c9                   	leave  
801013a9:	c3                   	ret    
801013aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801013b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013b8:	c9                   	leave  
801013b9:	c3                   	ret    
801013ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	83 ec 0c             	sub    $0xc,%esp
801013c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801013cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013d2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013d6:	74 60                	je     80101438 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801013d8:	8b 03                	mov    (%ebx),%eax
801013da:	83 f8 01             	cmp    $0x1,%eax
801013dd:	74 41                	je     80101420 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013df:	83 f8 02             	cmp    $0x2,%eax
801013e2:	75 5b                	jne    8010143f <fileread+0x7f>
    ilock(f->ip);
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	ff 73 10             	push   0x10(%ebx)
801013ea:	e8 31 07 00 00       	call   80101b20 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013ef:	57                   	push   %edi
801013f0:	ff 73 14             	push   0x14(%ebx)
801013f3:	56                   	push   %esi
801013f4:	ff 73 10             	push   0x10(%ebx)
801013f7:	e8 34 0a 00 00       	call   80101e30 <readi>
801013fc:	83 c4 20             	add    $0x20,%esp
801013ff:	89 c6                	mov    %eax,%esi
80101401:	85 c0                	test   %eax,%eax
80101403:	7e 03                	jle    80101408 <fileread+0x48>
      f->off += r;
80101405:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101408:	83 ec 0c             	sub    $0xc,%esp
8010140b:	ff 73 10             	push   0x10(%ebx)
8010140e:	e8 ed 07 00 00       	call   80101c00 <iunlock>
    return r;
80101413:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101419:	89 f0                	mov    %esi,%eax
8010141b:	5b                   	pop    %ebx
8010141c:	5e                   	pop    %esi
8010141d:	5f                   	pop    %edi
8010141e:	5d                   	pop    %ebp
8010141f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101420:	8b 43 0c             	mov    0xc(%ebx),%eax
80101423:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101429:	5b                   	pop    %ebx
8010142a:	5e                   	pop    %esi
8010142b:	5f                   	pop    %edi
8010142c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010142d:	e9 3e 26 00 00       	jmp    80103a70 <piperead>
80101432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101438:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010143d:	eb d7                	jmp    80101416 <fileread+0x56>
  panic("fileread");
8010143f:	83 ec 0c             	sub    $0xc,%esp
80101442:	68 e6 75 10 80       	push   $0x801075e6
80101447:	e8 34 ef ff ff       	call   80100380 <panic>
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101450 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	53                   	push   %ebx
80101456:	83 ec 1c             	sub    $0x1c,%esp
80101459:	8b 45 0c             	mov    0xc(%ebp),%eax
8010145c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010145f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101462:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101465:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010146c:	0f 84 bd 00 00 00    	je     8010152f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101472:	8b 03                	mov    (%ebx),%eax
80101474:	83 f8 01             	cmp    $0x1,%eax
80101477:	0f 84 bf 00 00 00    	je     8010153c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010147d:	83 f8 02             	cmp    $0x2,%eax
80101480:	0f 85 c8 00 00 00    	jne    8010154e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101489:	31 f6                	xor    %esi,%esi
    while(i < n){
8010148b:	85 c0                	test   %eax,%eax
8010148d:	7f 30                	jg     801014bf <filewrite+0x6f>
8010148f:	e9 94 00 00 00       	jmp    80101528 <filewrite+0xd8>
80101494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101498:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010149b:	83 ec 0c             	sub    $0xc,%esp
8010149e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801014a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801014a4:	e8 57 07 00 00       	call   80101c00 <iunlock>
      end_op();
801014a9:	e8 c2 1c 00 00       	call   80103170 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801014ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014b1:	83 c4 10             	add    $0x10,%esp
801014b4:	39 c7                	cmp    %eax,%edi
801014b6:	75 5c                	jne    80101514 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801014b8:	01 fe                	add    %edi,%esi
    while(i < n){
801014ba:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801014bd:	7e 69                	jle    80101528 <filewrite+0xd8>
      int n1 = n - i;
801014bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801014c2:	b8 00 06 00 00       	mov    $0x600,%eax
801014c7:	29 f7                	sub    %esi,%edi
801014c9:	39 c7                	cmp    %eax,%edi
801014cb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801014ce:	e8 2d 1c 00 00       	call   80103100 <begin_op>
      ilock(f->ip);
801014d3:	83 ec 0c             	sub    $0xc,%esp
801014d6:	ff 73 10             	push   0x10(%ebx)
801014d9:	e8 42 06 00 00       	call   80101b20 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014e1:	57                   	push   %edi
801014e2:	ff 73 14             	push   0x14(%ebx)
801014e5:	01 f0                	add    %esi,%eax
801014e7:	50                   	push   %eax
801014e8:	ff 73 10             	push   0x10(%ebx)
801014eb:	e8 40 0a 00 00       	call   80101f30 <writei>
801014f0:	83 c4 20             	add    $0x20,%esp
801014f3:	85 c0                	test   %eax,%eax
801014f5:	7f a1                	jg     80101498 <filewrite+0x48>
      iunlock(f->ip);
801014f7:	83 ec 0c             	sub    $0xc,%esp
801014fa:	ff 73 10             	push   0x10(%ebx)
801014fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101500:	e8 fb 06 00 00       	call   80101c00 <iunlock>
      end_op();
80101505:	e8 66 1c 00 00       	call   80103170 <end_op>
      if(r < 0)
8010150a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010150d:	83 c4 10             	add    $0x10,%esp
80101510:	85 c0                	test   %eax,%eax
80101512:	75 1b                	jne    8010152f <filewrite+0xdf>
        panic("short filewrite");
80101514:	83 ec 0c             	sub    $0xc,%esp
80101517:	68 ef 75 10 80       	push   $0x801075ef
8010151c:	e8 5f ee ff ff       	call   80100380 <panic>
80101521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101528:	89 f0                	mov    %esi,%eax
8010152a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010152d:	74 05                	je     80101534 <filewrite+0xe4>
8010152f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101537:	5b                   	pop    %ebx
80101538:	5e                   	pop    %esi
80101539:	5f                   	pop    %edi
8010153a:	5d                   	pop    %ebp
8010153b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010153c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010153f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101542:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101545:	5b                   	pop    %ebx
80101546:	5e                   	pop    %esi
80101547:	5f                   	pop    %edi
80101548:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101549:	e9 22 24 00 00       	jmp    80103970 <pipewrite>
  panic("filewrite");
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	68 f5 75 10 80       	push   $0x801075f5
80101556:	e8 25 ee ff ff       	call   80100380 <panic>
8010155b:	66 90                	xchg   %ax,%ax
8010155d:	66 90                	xchg   %ax,%ax
8010155f:	90                   	nop

80101560 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101560:	55                   	push   %ebp
80101561:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101563:	89 d0                	mov    %edx,%eax
80101565:	c1 e8 0c             	shr    $0xc,%eax
80101568:	03 05 ec 1a 11 80    	add    0x80111aec,%eax
{
8010156e:	89 e5                	mov    %esp,%ebp
80101570:	56                   	push   %esi
80101571:	53                   	push   %ebx
80101572:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101574:	83 ec 08             	sub    $0x8,%esp
80101577:	50                   	push   %eax
80101578:	51                   	push   %ecx
80101579:	e8 52 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010157e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101580:	c1 fb 03             	sar    $0x3,%ebx
80101583:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101586:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101588:	83 e1 07             	and    $0x7,%ecx
8010158b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101590:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101596:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101598:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010159d:	85 c1                	test   %eax,%ecx
8010159f:	74 23                	je     801015c4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801015a1:	f7 d0                	not    %eax
  log_write(bp);
801015a3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015a6:	21 c8                	and    %ecx,%eax
801015a8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801015ac:	56                   	push   %esi
801015ad:	e8 2e 1d 00 00       	call   801032e0 <log_write>
  brelse(bp);
801015b2:	89 34 24             	mov    %esi,(%esp)
801015b5:	e8 36 ec ff ff       	call   801001f0 <brelse>
}
801015ba:	83 c4 10             	add    $0x10,%esp
801015bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c0:	5b                   	pop    %ebx
801015c1:	5e                   	pop    %esi
801015c2:	5d                   	pop    %ebp
801015c3:	c3                   	ret    
    panic("freeing free block");
801015c4:	83 ec 0c             	sub    $0xc,%esp
801015c7:	68 ff 75 10 80       	push   $0x801075ff
801015cc:	e8 af ed ff ff       	call   80100380 <panic>
801015d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015df:	90                   	nop

801015e0 <balloc>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	57                   	push   %edi
801015e4:	56                   	push   %esi
801015e5:	53                   	push   %ebx
801015e6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015e9:	8b 0d d4 1a 11 80    	mov    0x80111ad4,%ecx
{
801015ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015f2:	85 c9                	test   %ecx,%ecx
801015f4:	0f 84 87 00 00 00    	je     80101681 <balloc+0xa1>
801015fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101601:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101604:	83 ec 08             	sub    $0x8,%esp
80101607:	89 f0                	mov    %esi,%eax
80101609:	c1 f8 0c             	sar    $0xc,%eax
8010160c:	03 05 ec 1a 11 80    	add    0x80111aec,%eax
80101612:	50                   	push   %eax
80101613:	ff 75 d8             	push   -0x28(%ebp)
80101616:	e8 b5 ea ff ff       	call   801000d0 <bread>
8010161b:	83 c4 10             	add    $0x10,%esp
8010161e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101621:	a1 d4 1a 11 80       	mov    0x80111ad4,%eax
80101626:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101629:	31 c0                	xor    %eax,%eax
8010162b:	eb 2f                	jmp    8010165c <balloc+0x7c>
8010162d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101630:	89 c1                	mov    %eax,%ecx
80101632:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101637:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010163a:	83 e1 07             	and    $0x7,%ecx
8010163d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010163f:	89 c1                	mov    %eax,%ecx
80101641:	c1 f9 03             	sar    $0x3,%ecx
80101644:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101649:	89 fa                	mov    %edi,%edx
8010164b:	85 df                	test   %ebx,%edi
8010164d:	74 41                	je     80101690 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010164f:	83 c0 01             	add    $0x1,%eax
80101652:	83 c6 01             	add    $0x1,%esi
80101655:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010165a:	74 05                	je     80101661 <balloc+0x81>
8010165c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010165f:	77 cf                	ja     80101630 <balloc+0x50>
    brelse(bp);
80101661:	83 ec 0c             	sub    $0xc,%esp
80101664:	ff 75 e4             	push   -0x1c(%ebp)
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010166c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101673:	83 c4 10             	add    $0x10,%esp
80101676:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101679:	39 05 d4 1a 11 80    	cmp    %eax,0x80111ad4
8010167f:	77 80                	ja     80101601 <balloc+0x21>
  panic("balloc: out of blocks");
80101681:	83 ec 0c             	sub    $0xc,%esp
80101684:	68 12 76 10 80       	push   $0x80107612
80101689:	e8 f2 ec ff ff       	call   80100380 <panic>
8010168e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101690:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101693:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101696:	09 da                	or     %ebx,%edx
80101698:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010169c:	57                   	push   %edi
8010169d:	e8 3e 1c 00 00       	call   801032e0 <log_write>
        brelse(bp);
801016a2:	89 3c 24             	mov    %edi,(%esp)
801016a5:	e8 46 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801016aa:	58                   	pop    %eax
801016ab:	5a                   	pop    %edx
801016ac:	56                   	push   %esi
801016ad:	ff 75 d8             	push   -0x28(%ebp)
801016b0:	e8 1b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801016b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801016b8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801016bd:	68 00 02 00 00       	push   $0x200
801016c2:	6a 00                	push   $0x0
801016c4:	50                   	push   %eax
801016c5:	e8 36 33 00 00       	call   80104a00 <memset>
  log_write(bp);
801016ca:	89 1c 24             	mov    %ebx,(%esp)
801016cd:	e8 0e 1c 00 00       	call   801032e0 <log_write>
  brelse(bp);
801016d2:	89 1c 24             	mov    %ebx,(%esp)
801016d5:	e8 16 eb ff ff       	call   801001f0 <brelse>
}
801016da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016dd:	89 f0                	mov    %esi,%eax
801016df:	5b                   	pop    %ebx
801016e0:	5e                   	pop    %esi
801016e1:	5f                   	pop    %edi
801016e2:	5d                   	pop    %ebp
801016e3:	c3                   	ret    
801016e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016ef:	90                   	nop

801016f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	57                   	push   %edi
801016f4:	89 c7                	mov    %eax,%edi
801016f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016f7:	31 f6                	xor    %esi,%esi
{
801016f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016fa:	bb b4 fe 10 80       	mov    $0x8010feb4,%ebx
{
801016ff:	83 ec 28             	sub    $0x28,%esp
80101702:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101705:	68 80 fe 10 80       	push   $0x8010fe80
8010170a:	e8 31 32 00 00       	call   80104940 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010170f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101712:	83 c4 10             	add    $0x10,%esp
80101715:	eb 1b                	jmp    80101732 <iget+0x42>
80101717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101720:	39 3b                	cmp    %edi,(%ebx)
80101722:	74 6c                	je     80101790 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101724:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010172a:	81 fb d4 1a 11 80    	cmp    $0x80111ad4,%ebx
80101730:	73 26                	jae    80101758 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101732:	8b 43 08             	mov    0x8(%ebx),%eax
80101735:	85 c0                	test   %eax,%eax
80101737:	7f e7                	jg     80101720 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101739:	85 f6                	test   %esi,%esi
8010173b:	75 e7                	jne    80101724 <iget+0x34>
8010173d:	85 c0                	test   %eax,%eax
8010173f:	75 76                	jne    801017b7 <iget+0xc7>
80101741:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101743:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101749:	81 fb d4 1a 11 80    	cmp    $0x80111ad4,%ebx
8010174f:	72 e1                	jb     80101732 <iget+0x42>
80101751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101758:	85 f6                	test   %esi,%esi
8010175a:	74 79                	je     801017d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010175c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010175f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101761:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101764:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010176b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101772:	68 80 fe 10 80       	push   $0x8010fe80
80101777:	e8 64 31 00 00       	call   801048e0 <release>

  return ip;
8010177c:	83 c4 10             	add    $0x10,%esp
}
8010177f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101782:	89 f0                	mov    %esi,%eax
80101784:	5b                   	pop    %ebx
80101785:	5e                   	pop    %esi
80101786:	5f                   	pop    %edi
80101787:	5d                   	pop    %ebp
80101788:	c3                   	ret    
80101789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101790:	39 53 04             	cmp    %edx,0x4(%ebx)
80101793:	75 8f                	jne    80101724 <iget+0x34>
      release(&icache.lock);
80101795:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101798:	83 c0 01             	add    $0x1,%eax
      return ip;
8010179b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010179d:	68 80 fe 10 80       	push   $0x8010fe80
      ip->ref++;
801017a2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801017a5:	e8 36 31 00 00       	call   801048e0 <release>
      return ip;
801017aa:	83 c4 10             	add    $0x10,%esp
}
801017ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017b0:	89 f0                	mov    %esi,%eax
801017b2:	5b                   	pop    %ebx
801017b3:	5e                   	pop    %esi
801017b4:	5f                   	pop    %edi
801017b5:	5d                   	pop    %ebp
801017b6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801017bd:	81 fb d4 1a 11 80    	cmp    $0x80111ad4,%ebx
801017c3:	73 10                	jae    801017d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017c5:	8b 43 08             	mov    0x8(%ebx),%eax
801017c8:	85 c0                	test   %eax,%eax
801017ca:	0f 8f 50 ff ff ff    	jg     80101720 <iget+0x30>
801017d0:	e9 68 ff ff ff       	jmp    8010173d <iget+0x4d>
    panic("iget: no inodes");
801017d5:	83 ec 0c             	sub    $0xc,%esp
801017d8:	68 28 76 10 80       	push   $0x80107628
801017dd:	e8 9e eb ff ff       	call   80100380 <panic>
801017e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801017f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	89 c6                	mov    %eax,%esi
801017f7:	53                   	push   %ebx
801017f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017fb:	83 fa 0b             	cmp    $0xb,%edx
801017fe:	0f 86 8c 00 00 00    	jbe    80101890 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101804:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101807:	83 fb 7f             	cmp    $0x7f,%ebx
8010180a:	0f 87 a2 00 00 00    	ja     801018b2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101810:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101816:	85 c0                	test   %eax,%eax
80101818:	74 5e                	je     80101878 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010181a:	83 ec 08             	sub    $0x8,%esp
8010181d:	50                   	push   %eax
8010181e:	ff 36                	push   (%esi)
80101820:	e8 ab e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010182c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010182e:	8b 3b                	mov    (%ebx),%edi
80101830:	85 ff                	test   %edi,%edi
80101832:	74 1c                	je     80101850 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	52                   	push   %edx
80101838:	e8 b3 e9 ff ff       	call   801001f0 <brelse>
8010183d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101843:	89 f8                	mov    %edi,%eax
80101845:	5b                   	pop    %ebx
80101846:	5e                   	pop    %esi
80101847:	5f                   	pop    %edi
80101848:	5d                   	pop    %ebp
80101849:	c3                   	ret    
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101853:	8b 06                	mov    (%esi),%eax
80101855:	e8 86 fd ff ff       	call   801015e0 <balloc>
      log_write(bp);
8010185a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010185d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101860:	89 03                	mov    %eax,(%ebx)
80101862:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101864:	52                   	push   %edx
80101865:	e8 76 1a 00 00       	call   801032e0 <log_write>
8010186a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010186d:	83 c4 10             	add    $0x10,%esp
80101870:	eb c2                	jmp    80101834 <bmap+0x44>
80101872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101878:	8b 06                	mov    (%esi),%eax
8010187a:	e8 61 fd ff ff       	call   801015e0 <balloc>
8010187f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101885:	eb 93                	jmp    8010181a <bmap+0x2a>
80101887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101890:	8d 5a 14             	lea    0x14(%edx),%ebx
80101893:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101897:	85 ff                	test   %edi,%edi
80101899:	75 a5                	jne    80101840 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010189b:	8b 00                	mov    (%eax),%eax
8010189d:	e8 3e fd ff ff       	call   801015e0 <balloc>
801018a2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801018a6:	89 c7                	mov    %eax,%edi
}
801018a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ab:	5b                   	pop    %ebx
801018ac:	89 f8                	mov    %edi,%eax
801018ae:	5e                   	pop    %esi
801018af:	5f                   	pop    %edi
801018b0:	5d                   	pop    %ebp
801018b1:	c3                   	ret    
  panic("bmap: out of range");
801018b2:	83 ec 0c             	sub    $0xc,%esp
801018b5:	68 38 76 10 80       	push   $0x80107638
801018ba:	e8 c1 ea ff ff       	call   80100380 <panic>
801018bf:	90                   	nop

801018c0 <readsb>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	56                   	push   %esi
801018c4:	53                   	push   %ebx
801018c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801018c8:	83 ec 08             	sub    $0x8,%esp
801018cb:	6a 01                	push   $0x1
801018cd:	ff 75 08             	push   0x8(%ebp)
801018d0:	e8 fb e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018d8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018da:	8d 40 5c             	lea    0x5c(%eax),%eax
801018dd:	6a 1c                	push   $0x1c
801018df:	50                   	push   %eax
801018e0:	56                   	push   %esi
801018e1:	e8 ba 31 00 00       	call   80104aa0 <memmove>
  brelse(bp);
801018e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018e9:	83 c4 10             	add    $0x10,%esp
}
801018ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ef:	5b                   	pop    %ebx
801018f0:	5e                   	pop    %esi
801018f1:	5d                   	pop    %ebp
  brelse(bp);
801018f2:	e9 f9 e8 ff ff       	jmp    801001f0 <brelse>
801018f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018fe:	66 90                	xchg   %ax,%ax

80101900 <iinit>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	bb c0 fe 10 80       	mov    $0x8010fec0,%ebx
80101909:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010190c:	68 4b 76 10 80       	push   $0x8010764b
80101911:	68 80 fe 10 80       	push   $0x8010fe80
80101916:	e8 55 2e 00 00       	call   80104770 <initlock>
  for(i = 0; i < NINODE; i++) {
8010191b:	83 c4 10             	add    $0x10,%esp
8010191e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101920:	83 ec 08             	sub    $0x8,%esp
80101923:	68 52 76 10 80       	push   $0x80107652
80101928:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101929:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010192f:	e8 0c 2d 00 00       	call   80104640 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101934:	83 c4 10             	add    $0x10,%esp
80101937:	81 fb e0 1a 11 80    	cmp    $0x80111ae0,%ebx
8010193d:	75 e1                	jne    80101920 <iinit+0x20>
  bp = bread(dev, 1);
8010193f:	83 ec 08             	sub    $0x8,%esp
80101942:	6a 01                	push   $0x1
80101944:	ff 75 08             	push   0x8(%ebp)
80101947:	e8 84 e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010194c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010194f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101951:	8d 40 5c             	lea    0x5c(%eax),%eax
80101954:	6a 1c                	push   $0x1c
80101956:	50                   	push   %eax
80101957:	68 d4 1a 11 80       	push   $0x80111ad4
8010195c:	e8 3f 31 00 00       	call   80104aa0 <memmove>
  brelse(bp);
80101961:	89 1c 24             	mov    %ebx,(%esp)
80101964:	e8 87 e8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101969:	ff 35 ec 1a 11 80    	push   0x80111aec
8010196f:	ff 35 e8 1a 11 80    	push   0x80111ae8
80101975:	ff 35 e4 1a 11 80    	push   0x80111ae4
8010197b:	ff 35 e0 1a 11 80    	push   0x80111ae0
80101981:	ff 35 dc 1a 11 80    	push   0x80111adc
80101987:	ff 35 d8 1a 11 80    	push   0x80111ad8
8010198d:	ff 35 d4 1a 11 80    	push   0x80111ad4
80101993:	68 b8 76 10 80       	push   $0x801076b8
80101998:	e8 73 ee ff ff       	call   80100810 <cprintf>
}
8010199d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019a0:	83 c4 30             	add    $0x30,%esp
801019a3:	c9                   	leave  
801019a4:	c3                   	ret    
801019a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019b0 <ialloc>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	57                   	push   %edi
801019b4:	56                   	push   %esi
801019b5:	53                   	push   %ebx
801019b6:	83 ec 1c             	sub    $0x1c,%esp
801019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801019bc:	83 3d dc 1a 11 80 01 	cmpl   $0x1,0x80111adc
{
801019c3:	8b 75 08             	mov    0x8(%ebp),%esi
801019c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801019c9:	0f 86 91 00 00 00    	jbe    80101a60 <ialloc+0xb0>
801019cf:	bf 01 00 00 00       	mov    $0x1,%edi
801019d4:	eb 21                	jmp    801019f7 <ialloc+0x47>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801019e3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801019e6:	53                   	push   %ebx
801019e7:	e8 04 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801019ec:	83 c4 10             	add    $0x10,%esp
801019ef:	3b 3d dc 1a 11 80    	cmp    0x80111adc,%edi
801019f5:	73 69                	jae    80101a60 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019f7:	89 f8                	mov    %edi,%eax
801019f9:	83 ec 08             	sub    $0x8,%esp
801019fc:	c1 e8 03             	shr    $0x3,%eax
801019ff:	03 05 e8 1a 11 80    	add    0x80111ae8,%eax
80101a05:	50                   	push   %eax
80101a06:	56                   	push   %esi
80101a07:	e8 c4 e6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101a0c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101a0f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101a11:	89 f8                	mov    %edi,%eax
80101a13:	83 e0 07             	and    $0x7,%eax
80101a16:	c1 e0 06             	shl    $0x6,%eax
80101a19:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101a1d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101a21:	75 bd                	jne    801019e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101a23:	83 ec 04             	sub    $0x4,%esp
80101a26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a29:	6a 40                	push   $0x40
80101a2b:	6a 00                	push   $0x0
80101a2d:	51                   	push   %ecx
80101a2e:	e8 cd 2f 00 00       	call   80104a00 <memset>
      dip->type = type;
80101a33:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101a37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a3a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101a3d:	89 1c 24             	mov    %ebx,(%esp)
80101a40:	e8 9b 18 00 00       	call   801032e0 <log_write>
      brelse(bp);
80101a45:	89 1c 24             	mov    %ebx,(%esp)
80101a48:	e8 a3 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101a4d:	83 c4 10             	add    $0x10,%esp
}
80101a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a53:	89 fa                	mov    %edi,%edx
}
80101a55:	5b                   	pop    %ebx
      return iget(dev, inum);
80101a56:	89 f0                	mov    %esi,%eax
}
80101a58:	5e                   	pop    %esi
80101a59:	5f                   	pop    %edi
80101a5a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a5b:	e9 90 fc ff ff       	jmp    801016f0 <iget>
  panic("ialloc: no inodes");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 58 76 10 80       	push   $0x80107658
80101a68:	e8 13 e9 ff ff       	call   80100380 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <iupdate>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	56                   	push   %esi
80101a74:	53                   	push   %ebx
80101a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a78:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a7b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a7e:	83 ec 08             	sub    $0x8,%esp
80101a81:	c1 e8 03             	shr    $0x3,%eax
80101a84:	03 05 e8 1a 11 80    	add    0x80111ae8,%eax
80101a8a:	50                   	push   %eax
80101a8b:	ff 73 a4             	push   -0x5c(%ebx)
80101a8e:	e8 3d e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a93:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a97:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a9a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a9c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101a9f:	83 e0 07             	and    $0x7,%eax
80101aa2:	c1 e0 06             	shl    $0x6,%eax
80101aa5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101aa9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101aac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ab0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101ab3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101ab7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101abb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101abf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ac3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101ac7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101aca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101acd:	6a 34                	push   $0x34
80101acf:	53                   	push   %ebx
80101ad0:	50                   	push   %eax
80101ad1:	e8 ca 2f 00 00       	call   80104aa0 <memmove>
  log_write(bp);
80101ad6:	89 34 24             	mov    %esi,(%esp)
80101ad9:	e8 02 18 00 00       	call   801032e0 <log_write>
  brelse(bp);
80101ade:	89 75 08             	mov    %esi,0x8(%ebp)
80101ae1:	83 c4 10             	add    $0x10,%esp
}
80101ae4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ae7:	5b                   	pop    %ebx
80101ae8:	5e                   	pop    %esi
80101ae9:	5d                   	pop    %ebp
  brelse(bp);
80101aea:	e9 01 e7 ff ff       	jmp    801001f0 <brelse>
80101aef:	90                   	nop

80101af0 <idup>:
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	53                   	push   %ebx
80101af4:	83 ec 10             	sub    $0x10,%esp
80101af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101afa:	68 80 fe 10 80       	push   $0x8010fe80
80101aff:	e8 3c 2e 00 00       	call   80104940 <acquire>
  ip->ref++;
80101b04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b08:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
80101b0f:	e8 cc 2d 00 00       	call   801048e0 <release>
}
80101b14:	89 d8                	mov    %ebx,%eax
80101b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b19:	c9                   	leave  
80101b1a:	c3                   	ret    
80101b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b1f:	90                   	nop

80101b20 <ilock>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	0f 84 b7 00 00 00    	je     80101be7 <ilock+0xc7>
80101b30:	8b 53 08             	mov    0x8(%ebx),%edx
80101b33:	85 d2                	test   %edx,%edx
80101b35:	0f 8e ac 00 00 00    	jle    80101be7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101b3b:	83 ec 0c             	sub    $0xc,%esp
80101b3e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101b41:	50                   	push   %eax
80101b42:	e8 39 2b 00 00       	call   80104680 <acquiresleep>
  if(ip->valid == 0){
80101b47:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	85 c0                	test   %eax,%eax
80101b4f:	74 0f                	je     80101b60 <ilock+0x40>
}
80101b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b54:	5b                   	pop    %ebx
80101b55:	5e                   	pop    %esi
80101b56:	5d                   	pop    %ebp
80101b57:	c3                   	ret    
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b60:	8b 43 04             	mov    0x4(%ebx),%eax
80101b63:	83 ec 08             	sub    $0x8,%esp
80101b66:	c1 e8 03             	shr    $0x3,%eax
80101b69:	03 05 e8 1a 11 80    	add    0x80111ae8,%eax
80101b6f:	50                   	push   %eax
80101b70:	ff 33                	push   (%ebx)
80101b72:	e8 59 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b77:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b7a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b7c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b7f:	83 e0 07             	and    $0x7,%eax
80101b82:	c1 e0 06             	shl    $0x6,%eax
80101b85:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b89:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b8c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b8f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b93:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b97:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b9b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b9f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ba3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ba7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101bab:	8b 50 fc             	mov    -0x4(%eax),%edx
80101bae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bb1:	6a 34                	push   $0x34
80101bb3:	50                   	push   %eax
80101bb4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101bb7:	50                   	push   %eax
80101bb8:	e8 e3 2e 00 00       	call   80104aa0 <memmove>
    brelse(bp);
80101bbd:	89 34 24             	mov    %esi,(%esp)
80101bc0:	e8 2b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101bc5:	83 c4 10             	add    $0x10,%esp
80101bc8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101bcd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101bd4:	0f 85 77 ff ff ff    	jne    80101b51 <ilock+0x31>
      panic("ilock: no type");
80101bda:	83 ec 0c             	sub    $0xc,%esp
80101bdd:	68 70 76 10 80       	push   $0x80107670
80101be2:	e8 99 e7 ff ff       	call   80100380 <panic>
    panic("ilock");
80101be7:	83 ec 0c             	sub    $0xc,%esp
80101bea:	68 6a 76 10 80       	push   $0x8010766a
80101bef:	e8 8c e7 ff ff       	call   80100380 <panic>
80101bf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <iunlock>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	56                   	push   %esi
80101c04:	53                   	push   %ebx
80101c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c08:	85 db                	test   %ebx,%ebx
80101c0a:	74 28                	je     80101c34 <iunlock+0x34>
80101c0c:	83 ec 0c             	sub    $0xc,%esp
80101c0f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c12:	56                   	push   %esi
80101c13:	e8 08 2b 00 00       	call   80104720 <holdingsleep>
80101c18:	83 c4 10             	add    $0x10,%esp
80101c1b:	85 c0                	test   %eax,%eax
80101c1d:	74 15                	je     80101c34 <iunlock+0x34>
80101c1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101c22:	85 c0                	test   %eax,%eax
80101c24:	7e 0e                	jle    80101c34 <iunlock+0x34>
  releasesleep(&ip->lock);
80101c26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c2c:	5b                   	pop    %ebx
80101c2d:	5e                   	pop    %esi
80101c2e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101c2f:	e9 ac 2a 00 00       	jmp    801046e0 <releasesleep>
    panic("iunlock");
80101c34:	83 ec 0c             	sub    $0xc,%esp
80101c37:	68 7f 76 10 80       	push   $0x8010767f
80101c3c:	e8 3f e7 ff ff       	call   80100380 <panic>
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4f:	90                   	nop

80101c50 <iput>:
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 28             	sub    $0x28,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c5c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c5f:	57                   	push   %edi
80101c60:	e8 1b 2a 00 00       	call   80104680 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c65:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c68:	83 c4 10             	add    $0x10,%esp
80101c6b:	85 d2                	test   %edx,%edx
80101c6d:	74 07                	je     80101c76 <iput+0x26>
80101c6f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c74:	74 32                	je     80101ca8 <iput+0x58>
  releasesleep(&ip->lock);
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	57                   	push   %edi
80101c7a:	e8 61 2a 00 00       	call   801046e0 <releasesleep>
  acquire(&icache.lock);
80101c7f:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
80101c86:	e8 b5 2c 00 00       	call   80104940 <acquire>
  ip->ref--;
80101c8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c8f:	83 c4 10             	add    $0x10,%esp
80101c92:	c7 45 08 80 fe 10 80 	movl   $0x8010fe80,0x8(%ebp)
}
80101c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9c:	5b                   	pop    %ebx
80101c9d:	5e                   	pop    %esi
80101c9e:	5f                   	pop    %edi
80101c9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101ca0:	e9 3b 2c 00 00       	jmp    801048e0 <release>
80101ca5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ca8:	83 ec 0c             	sub    $0xc,%esp
80101cab:	68 80 fe 10 80       	push   $0x8010fe80
80101cb0:	e8 8b 2c 00 00       	call   80104940 <acquire>
    int r = ip->ref;
80101cb5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cb8:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
80101cbf:	e8 1c 2c 00 00       	call   801048e0 <release>
    if(r == 1){
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	83 fe 01             	cmp    $0x1,%esi
80101cca:	75 aa                	jne    80101c76 <iput+0x26>
80101ccc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101cd2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101cd5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101cd8:	89 cf                	mov    %ecx,%edi
80101cda:	eb 0b                	jmp    80101ce7 <iput+0x97>
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ce0:	83 c6 04             	add    $0x4,%esi
80101ce3:	39 fe                	cmp    %edi,%esi
80101ce5:	74 19                	je     80101d00 <iput+0xb0>
    if(ip->addrs[i]){
80101ce7:	8b 16                	mov    (%esi),%edx
80101ce9:	85 d2                	test   %edx,%edx
80101ceb:	74 f3                	je     80101ce0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101ced:	8b 03                	mov    (%ebx),%eax
80101cef:	e8 6c f8 ff ff       	call   80101560 <bfree>
      ip->addrs[i] = 0;
80101cf4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101cfa:	eb e4                	jmp    80101ce0 <iput+0x90>
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101d00:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101d06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d09:	85 c0                	test   %eax,%eax
80101d0b:	75 2d                	jne    80101d3a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101d0d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101d10:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101d17:	53                   	push   %ebx
80101d18:	e8 53 fd ff ff       	call   80101a70 <iupdate>
      ip->type = 0;
80101d1d:	31 c0                	xor    %eax,%eax
80101d1f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101d23:	89 1c 24             	mov    %ebx,(%esp)
80101d26:	e8 45 fd ff ff       	call   80101a70 <iupdate>
      ip->valid = 0;
80101d2b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	e9 3c ff ff ff       	jmp    80101c76 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d3a:	83 ec 08             	sub    $0x8,%esp
80101d3d:	50                   	push   %eax
80101d3e:	ff 33                	push   (%ebx)
80101d40:	e8 8b e3 ff ff       	call   801000d0 <bread>
80101d45:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d48:	83 c4 10             	add    $0x10,%esp
80101d4b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d54:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d57:	89 cf                	mov    %ecx,%edi
80101d59:	eb 0c                	jmp    80101d67 <iput+0x117>
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop
80101d60:	83 c6 04             	add    $0x4,%esi
80101d63:	39 f7                	cmp    %esi,%edi
80101d65:	74 0f                	je     80101d76 <iput+0x126>
      if(a[j])
80101d67:	8b 16                	mov    (%esi),%edx
80101d69:	85 d2                	test   %edx,%edx
80101d6b:	74 f3                	je     80101d60 <iput+0x110>
        bfree(ip->dev, a[j]);
80101d6d:	8b 03                	mov    (%ebx),%eax
80101d6f:	e8 ec f7 ff ff       	call   80101560 <bfree>
80101d74:	eb ea                	jmp    80101d60 <iput+0x110>
    brelse(bp);
80101d76:	83 ec 0c             	sub    $0xc,%esp
80101d79:	ff 75 e4             	push   -0x1c(%ebp)
80101d7c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d7f:	e8 6c e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d84:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d8a:	8b 03                	mov    (%ebx),%eax
80101d8c:	e8 cf f7 ff ff       	call   80101560 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d91:	83 c4 10             	add    $0x10,%esp
80101d94:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d9b:	00 00 00 
80101d9e:	e9 6a ff ff ff       	jmp    80101d0d <iput+0xbd>
80101da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101db0 <iunlockput>:
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	56                   	push   %esi
80101db4:	53                   	push   %ebx
80101db5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101db8:	85 db                	test   %ebx,%ebx
80101dba:	74 34                	je     80101df0 <iunlockput+0x40>
80101dbc:	83 ec 0c             	sub    $0xc,%esp
80101dbf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101dc2:	56                   	push   %esi
80101dc3:	e8 58 29 00 00       	call   80104720 <holdingsleep>
80101dc8:	83 c4 10             	add    $0x10,%esp
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	74 21                	je     80101df0 <iunlockput+0x40>
80101dcf:	8b 43 08             	mov    0x8(%ebx),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	7e 1a                	jle    80101df0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101dd6:	83 ec 0c             	sub    $0xc,%esp
80101dd9:	56                   	push   %esi
80101dda:	e8 01 29 00 00       	call   801046e0 <releasesleep>
  iput(ip);
80101ddf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101de2:	83 c4 10             	add    $0x10,%esp
}
80101de5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101de8:	5b                   	pop    %ebx
80101de9:	5e                   	pop    %esi
80101dea:	5d                   	pop    %ebp
  iput(ip);
80101deb:	e9 60 fe ff ff       	jmp    80101c50 <iput>
    panic("iunlock");
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	68 7f 76 10 80       	push   $0x8010767f
80101df8:	e8 83 e5 ff ff       	call   80100380 <panic>
80101dfd:	8d 76 00             	lea    0x0(%esi),%esi

80101e00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	8b 55 08             	mov    0x8(%ebp),%edx
80101e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101e09:	8b 0a                	mov    (%edx),%ecx
80101e0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101e0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101e11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101e14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101e18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101e1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101e23:	8b 52 58             	mov    0x58(%edx),%edx
80101e26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e29:	5d                   	pop    %ebp
80101e2a:	c3                   	ret    
80101e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e2f:	90                   	nop

80101e30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 1c             	sub    $0x1c,%esp
80101e39:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101e3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3f:	8b 75 10             	mov    0x10(%ebp),%esi
80101e42:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e45:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e48:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e53:	0f 84 a7 00 00 00    	je     80101f00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e5c:	8b 40 58             	mov    0x58(%eax),%eax
80101e5f:	39 c6                	cmp    %eax,%esi
80101e61:	0f 87 ba 00 00 00    	ja     80101f21 <readi+0xf1>
80101e67:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e6a:	31 c9                	xor    %ecx,%ecx
80101e6c:	89 da                	mov    %ebx,%edx
80101e6e:	01 f2                	add    %esi,%edx
80101e70:	0f 92 c1             	setb   %cl
80101e73:	89 cf                	mov    %ecx,%edi
80101e75:	0f 82 a6 00 00 00    	jb     80101f21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e7b:	89 c1                	mov    %eax,%ecx
80101e7d:	29 f1                	sub    %esi,%ecx
80101e7f:	39 d0                	cmp    %edx,%eax
80101e81:	0f 43 cb             	cmovae %ebx,%ecx
80101e84:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e87:	85 c9                	test   %ecx,%ecx
80101e89:	74 67                	je     80101ef2 <readi+0xc2>
80101e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e93:	89 f2                	mov    %esi,%edx
80101e95:	c1 ea 09             	shr    $0x9,%edx
80101e98:	89 d8                	mov    %ebx,%eax
80101e9a:	e8 51 f9 ff ff       	call   801017f0 <bmap>
80101e9f:	83 ec 08             	sub    $0x8,%esp
80101ea2:	50                   	push   %eax
80101ea3:	ff 33                	push   (%ebx)
80101ea5:	e8 26 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101eaa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ead:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eb2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb4:	89 f0                	mov    %esi,%eax
80101eb6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ebb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ebd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ec0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ec2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ec6:	39 d9                	cmp    %ebx,%ecx
80101ec8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ecb:	83 c4 0c             	add    $0xc,%esp
80101ece:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ecf:	01 df                	add    %ebx,%edi
80101ed1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ed3:	50                   	push   %eax
80101ed4:	ff 75 e0             	push   -0x20(%ebp)
80101ed7:	e8 c4 2b 00 00       	call   80104aa0 <memmove>
    brelse(bp);
80101edc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101edf:	89 14 24             	mov    %edx,(%esp)
80101ee2:	e8 09 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ee7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101eea:	83 c4 10             	add    $0x10,%esp
80101eed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ef0:	77 9e                	ja     80101e90 <readi+0x60>
  }
  return n;
80101ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef8:	5b                   	pop    %ebx
80101ef9:	5e                   	pop    %esi
80101efa:	5f                   	pop    %edi
80101efb:	5d                   	pop    %ebp
80101efc:	c3                   	ret    
80101efd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	77 17                	ja     80101f21 <readi+0xf1>
80101f0a:	8b 04 c5 20 fe 10 80 	mov    -0x7fef01e0(,%eax,8),%eax
80101f11:	85 c0                	test   %eax,%eax
80101f13:	74 0c                	je     80101f21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101f15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1b:	5b                   	pop    %ebx
80101f1c:	5e                   	pop    %esi
80101f1d:	5f                   	pop    %edi
80101f1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101f1f:	ff e0                	jmp    *%eax
      return -1;
80101f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f26:	eb cd                	jmp    80101ef5 <readi+0xc5>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop

80101f30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f3f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101f4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101f50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f53:	0f 84 b7 00 00 00    	je     80102010 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f5f:	0f 87 e7 00 00 00    	ja     8010204c <writei+0x11c>
80101f65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f68:	31 d2                	xor    %edx,%edx
80101f6a:	89 f8                	mov    %edi,%eax
80101f6c:	01 f0                	add    %esi,%eax
80101f6e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f71:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f76:	0f 87 d0 00 00 00    	ja     8010204c <writei+0x11c>
80101f7c:	85 d2                	test   %edx,%edx
80101f7e:	0f 85 c8 00 00 00    	jne    8010204c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f8b:	85 ff                	test   %edi,%edi
80101f8d:	74 72                	je     80102001 <writei+0xd1>
80101f8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f93:	89 f2                	mov    %esi,%edx
80101f95:	c1 ea 09             	shr    $0x9,%edx
80101f98:	89 f8                	mov    %edi,%eax
80101f9a:	e8 51 f8 ff ff       	call   801017f0 <bmap>
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 37                	push   (%edi)
80101fa5:	e8 26 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101faa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101faf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101fb2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb7:	89 f0                	mov    %esi,%eax
80101fb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fbe:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101fc0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc4:	39 d9                	cmp    %ebx,%ecx
80101fc6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101fc9:	83 c4 0c             	add    $0xc,%esp
80101fcc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fcd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101fcf:	ff 75 dc             	push   -0x24(%ebp)
80101fd2:	50                   	push   %eax
80101fd3:	e8 c8 2a 00 00       	call   80104aa0 <memmove>
    log_write(bp);
80101fd8:	89 3c 24             	mov    %edi,(%esp)
80101fdb:	e8 00 13 00 00       	call   801032e0 <log_write>
    brelse(bp);
80101fe0:	89 3c 24             	mov    %edi,(%esp)
80101fe3:	e8 08 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fe8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ff1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ff4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ff7:	77 97                	ja     80101f90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ff9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ffc:	3b 70 58             	cmp    0x58(%eax),%esi
80101fff:	77 37                	ja     80102038 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102001:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102007:	5b                   	pop    %ebx
80102008:	5e                   	pop    %esi
80102009:	5f                   	pop    %edi
8010200a:	5d                   	pop    %ebp
8010200b:	c3                   	ret    
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102010:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102014:	66 83 f8 09          	cmp    $0x9,%ax
80102018:	77 32                	ja     8010204c <writei+0x11c>
8010201a:	8b 04 c5 24 fe 10 80 	mov    -0x7fef01dc(,%eax,8),%eax
80102021:	85 c0                	test   %eax,%eax
80102023:	74 27                	je     8010204c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102025:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5f                   	pop    %edi
8010202e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010202f:	ff e0                	jmp    *%eax
80102031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102038:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010203b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010203e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102041:	50                   	push   %eax
80102042:	e8 29 fa ff ff       	call   80101a70 <iupdate>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	eb b5                	jmp    80102001 <writei+0xd1>
      return -1;
8010204c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102051:	eb b1                	jmp    80102004 <writei+0xd4>
80102053:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102060 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102066:	6a 0e                	push   $0xe
80102068:	ff 75 0c             	push   0xc(%ebp)
8010206b:	ff 75 08             	push   0x8(%ebp)
8010206e:	e8 9d 2a 00 00       	call   80104b10 <strncmp>
}
80102073:	c9                   	leave  
80102074:	c3                   	ret    
80102075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010207c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102080 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
80102089:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010208c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102091:	0f 85 85 00 00 00    	jne    8010211c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102097:	8b 53 58             	mov    0x58(%ebx),%edx
8010209a:	31 ff                	xor    %edi,%edi
8010209c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010209f:	85 d2                	test   %edx,%edx
801020a1:	74 3e                	je     801020e1 <dirlookup+0x61>
801020a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020a7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a8:	6a 10                	push   $0x10
801020aa:	57                   	push   %edi
801020ab:	56                   	push   %esi
801020ac:	53                   	push   %ebx
801020ad:	e8 7e fd ff ff       	call   80101e30 <readi>
801020b2:	83 c4 10             	add    $0x10,%esp
801020b5:	83 f8 10             	cmp    $0x10,%eax
801020b8:	75 55                	jne    8010210f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801020ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020bf:	74 18                	je     801020d9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801020c1:	83 ec 04             	sub    $0x4,%esp
801020c4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020c7:	6a 0e                	push   $0xe
801020c9:	50                   	push   %eax
801020ca:	ff 75 0c             	push   0xc(%ebp)
801020cd:	e8 3e 2a 00 00       	call   80104b10 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801020d2:	83 c4 10             	add    $0x10,%esp
801020d5:	85 c0                	test   %eax,%eax
801020d7:	74 17                	je     801020f0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020d9:	83 c7 10             	add    $0x10,%edi
801020dc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020df:	72 c7                	jb     801020a8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801020e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801020e4:	31 c0                	xor    %eax,%eax
}
801020e6:	5b                   	pop    %ebx
801020e7:	5e                   	pop    %esi
801020e8:	5f                   	pop    %edi
801020e9:	5d                   	pop    %ebp
801020ea:	c3                   	ret    
801020eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020ef:	90                   	nop
      if(poff)
801020f0:	8b 45 10             	mov    0x10(%ebp),%eax
801020f3:	85 c0                	test   %eax,%eax
801020f5:	74 05                	je     801020fc <dirlookup+0x7c>
        *poff = off;
801020f7:	8b 45 10             	mov    0x10(%ebp),%eax
801020fa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801020fc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102100:	8b 03                	mov    (%ebx),%eax
80102102:	e8 e9 f5 ff ff       	call   801016f0 <iget>
}
80102107:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210a:	5b                   	pop    %ebx
8010210b:	5e                   	pop    %esi
8010210c:	5f                   	pop    %edi
8010210d:	5d                   	pop    %ebp
8010210e:	c3                   	ret    
      panic("dirlookup read");
8010210f:	83 ec 0c             	sub    $0xc,%esp
80102112:	68 99 76 10 80       	push   $0x80107699
80102117:	e8 64 e2 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010211c:	83 ec 0c             	sub    $0xc,%esp
8010211f:	68 87 76 10 80       	push   $0x80107687
80102124:	e8 57 e2 ff ff       	call   80100380 <panic>
80102129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102130 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	89 c3                	mov    %eax,%ebx
80102138:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010213b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010213e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102141:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102144:	0f 84 64 01 00 00    	je     801022ae <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010214a:	e8 c1 1b 00 00       	call   80103d10 <myproc>
  acquire(&icache.lock);
8010214f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102152:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102155:	68 80 fe 10 80       	push   $0x8010fe80
8010215a:	e8 e1 27 00 00       	call   80104940 <acquire>
  ip->ref++;
8010215f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102163:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
8010216a:	e8 71 27 00 00       	call   801048e0 <release>
8010216f:	83 c4 10             	add    $0x10,%esp
80102172:	eb 07                	jmp    8010217b <namex+0x4b>
80102174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102178:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010217b:	0f b6 03             	movzbl (%ebx),%eax
8010217e:	3c 2f                	cmp    $0x2f,%al
80102180:	74 f6                	je     80102178 <namex+0x48>
  if(*path == 0)
80102182:	84 c0                	test   %al,%al
80102184:	0f 84 06 01 00 00    	je     80102290 <namex+0x160>
  while(*path != '/' && *path != 0)
8010218a:	0f b6 03             	movzbl (%ebx),%eax
8010218d:	84 c0                	test   %al,%al
8010218f:	0f 84 10 01 00 00    	je     801022a5 <namex+0x175>
80102195:	89 df                	mov    %ebx,%edi
80102197:	3c 2f                	cmp    $0x2f,%al
80102199:	0f 84 06 01 00 00    	je     801022a5 <namex+0x175>
8010219f:	90                   	nop
801021a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801021a4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801021a7:	3c 2f                	cmp    $0x2f,%al
801021a9:	74 04                	je     801021af <namex+0x7f>
801021ab:	84 c0                	test   %al,%al
801021ad:	75 f1                	jne    801021a0 <namex+0x70>
  len = path - s;
801021af:	89 f8                	mov    %edi,%eax
801021b1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801021b3:	83 f8 0d             	cmp    $0xd,%eax
801021b6:	0f 8e ac 00 00 00    	jle    80102268 <namex+0x138>
    memmove(name, s, DIRSIZ);
801021bc:	83 ec 04             	sub    $0x4,%esp
801021bf:	6a 0e                	push   $0xe
801021c1:	53                   	push   %ebx
    path++;
801021c2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801021c4:	ff 75 e4             	push   -0x1c(%ebp)
801021c7:	e8 d4 28 00 00       	call   80104aa0 <memmove>
801021cc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801021cf:	80 3f 2f             	cmpb   $0x2f,(%edi)
801021d2:	75 0c                	jne    801021e0 <namex+0xb0>
801021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801021d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801021db:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801021de:	74 f8                	je     801021d8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801021e0:	83 ec 0c             	sub    $0xc,%esp
801021e3:	56                   	push   %esi
801021e4:	e8 37 f9 ff ff       	call   80101b20 <ilock>
    if(ip->type != T_DIR){
801021e9:	83 c4 10             	add    $0x10,%esp
801021ec:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801021f1:	0f 85 cd 00 00 00    	jne    801022c4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801021f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801021fa:	85 c0                	test   %eax,%eax
801021fc:	74 09                	je     80102207 <namex+0xd7>
801021fe:	80 3b 00             	cmpb   $0x0,(%ebx)
80102201:	0f 84 22 01 00 00    	je     80102329 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102207:	83 ec 04             	sub    $0x4,%esp
8010220a:	6a 00                	push   $0x0
8010220c:	ff 75 e4             	push   -0x1c(%ebp)
8010220f:	56                   	push   %esi
80102210:	e8 6b fe ff ff       	call   80102080 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102215:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102218:	83 c4 10             	add    $0x10,%esp
8010221b:	89 c7                	mov    %eax,%edi
8010221d:	85 c0                	test   %eax,%eax
8010221f:	0f 84 e1 00 00 00    	je     80102306 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010222b:	52                   	push   %edx
8010222c:	e8 ef 24 00 00       	call   80104720 <holdingsleep>
80102231:	83 c4 10             	add    $0x10,%esp
80102234:	85 c0                	test   %eax,%eax
80102236:	0f 84 30 01 00 00    	je     8010236c <namex+0x23c>
8010223c:	8b 56 08             	mov    0x8(%esi),%edx
8010223f:	85 d2                	test   %edx,%edx
80102241:	0f 8e 25 01 00 00    	jle    8010236c <namex+0x23c>
  releasesleep(&ip->lock);
80102247:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010224a:	83 ec 0c             	sub    $0xc,%esp
8010224d:	52                   	push   %edx
8010224e:	e8 8d 24 00 00       	call   801046e0 <releasesleep>
  iput(ip);
80102253:	89 34 24             	mov    %esi,(%esp)
80102256:	89 fe                	mov    %edi,%esi
80102258:	e8 f3 f9 ff ff       	call   80101c50 <iput>
8010225d:	83 c4 10             	add    $0x10,%esp
80102260:	e9 16 ff ff ff       	jmp    8010217b <namex+0x4b>
80102265:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102268:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010226b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010226e:	83 ec 04             	sub    $0x4,%esp
80102271:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102274:	50                   	push   %eax
80102275:	53                   	push   %ebx
    name[len] = 0;
80102276:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102278:	ff 75 e4             	push   -0x1c(%ebp)
8010227b:	e8 20 28 00 00       	call   80104aa0 <memmove>
    name[len] = 0;
80102280:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102283:	83 c4 10             	add    $0x10,%esp
80102286:	c6 02 00             	movb   $0x0,(%edx)
80102289:	e9 41 ff ff ff       	jmp    801021cf <namex+0x9f>
8010228e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102290:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102293:	85 c0                	test   %eax,%eax
80102295:	0f 85 be 00 00 00    	jne    80102359 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010229b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010229e:	89 f0                	mov    %esi,%eax
801022a0:	5b                   	pop    %ebx
801022a1:	5e                   	pop    %esi
801022a2:	5f                   	pop    %edi
801022a3:	5d                   	pop    %ebp
801022a4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801022a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801022a8:	89 df                	mov    %ebx,%edi
801022aa:	31 c0                	xor    %eax,%eax
801022ac:	eb c0                	jmp    8010226e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801022ae:	ba 01 00 00 00       	mov    $0x1,%edx
801022b3:	b8 01 00 00 00       	mov    $0x1,%eax
801022b8:	e8 33 f4 ff ff       	call   801016f0 <iget>
801022bd:	89 c6                	mov    %eax,%esi
801022bf:	e9 b7 fe ff ff       	jmp    8010217b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801022ca:	53                   	push   %ebx
801022cb:	e8 50 24 00 00       	call   80104720 <holdingsleep>
801022d0:	83 c4 10             	add    $0x10,%esp
801022d3:	85 c0                	test   %eax,%eax
801022d5:	0f 84 91 00 00 00    	je     8010236c <namex+0x23c>
801022db:	8b 46 08             	mov    0x8(%esi),%eax
801022de:	85 c0                	test   %eax,%eax
801022e0:	0f 8e 86 00 00 00    	jle    8010236c <namex+0x23c>
  releasesleep(&ip->lock);
801022e6:	83 ec 0c             	sub    $0xc,%esp
801022e9:	53                   	push   %ebx
801022ea:	e8 f1 23 00 00       	call   801046e0 <releasesleep>
  iput(ip);
801022ef:	89 34 24             	mov    %esi,(%esp)
      return 0;
801022f2:	31 f6                	xor    %esi,%esi
  iput(ip);
801022f4:	e8 57 f9 ff ff       	call   80101c50 <iput>
      return 0;
801022f9:	83 c4 10             	add    $0x10,%esp
}
801022fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ff:	89 f0                	mov    %esi,%eax
80102301:	5b                   	pop    %ebx
80102302:	5e                   	pop    %esi
80102303:	5f                   	pop    %edi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102306:	83 ec 0c             	sub    $0xc,%esp
80102309:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010230c:	52                   	push   %edx
8010230d:	e8 0e 24 00 00       	call   80104720 <holdingsleep>
80102312:	83 c4 10             	add    $0x10,%esp
80102315:	85 c0                	test   %eax,%eax
80102317:	74 53                	je     8010236c <namex+0x23c>
80102319:	8b 4e 08             	mov    0x8(%esi),%ecx
8010231c:	85 c9                	test   %ecx,%ecx
8010231e:	7e 4c                	jle    8010236c <namex+0x23c>
  releasesleep(&ip->lock);
80102320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	52                   	push   %edx
80102327:	eb c1                	jmp    801022ea <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102329:	83 ec 0c             	sub    $0xc,%esp
8010232c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010232f:	53                   	push   %ebx
80102330:	e8 eb 23 00 00       	call   80104720 <holdingsleep>
80102335:	83 c4 10             	add    $0x10,%esp
80102338:	85 c0                	test   %eax,%eax
8010233a:	74 30                	je     8010236c <namex+0x23c>
8010233c:	8b 7e 08             	mov    0x8(%esi),%edi
8010233f:	85 ff                	test   %edi,%edi
80102341:	7e 29                	jle    8010236c <namex+0x23c>
  releasesleep(&ip->lock);
80102343:	83 ec 0c             	sub    $0xc,%esp
80102346:	53                   	push   %ebx
80102347:	e8 94 23 00 00       	call   801046e0 <releasesleep>
}
8010234c:	83 c4 10             	add    $0x10,%esp
}
8010234f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102352:	89 f0                	mov    %esi,%eax
80102354:	5b                   	pop    %ebx
80102355:	5e                   	pop    %esi
80102356:	5f                   	pop    %edi
80102357:	5d                   	pop    %ebp
80102358:	c3                   	ret    
    iput(ip);
80102359:	83 ec 0c             	sub    $0xc,%esp
8010235c:	56                   	push   %esi
    return 0;
8010235d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010235f:	e8 ec f8 ff ff       	call   80101c50 <iput>
    return 0;
80102364:	83 c4 10             	add    $0x10,%esp
80102367:	e9 2f ff ff ff       	jmp    8010229b <namex+0x16b>
    panic("iunlock");
8010236c:	83 ec 0c             	sub    $0xc,%esp
8010236f:	68 7f 76 10 80       	push   $0x8010767f
80102374:	e8 07 e0 ff ff       	call   80100380 <panic>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102380 <dirlink>:
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	57                   	push   %edi
80102384:	56                   	push   %esi
80102385:	53                   	push   %ebx
80102386:	83 ec 20             	sub    $0x20,%esp
80102389:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010238c:	6a 00                	push   $0x0
8010238e:	ff 75 0c             	push   0xc(%ebp)
80102391:	53                   	push   %ebx
80102392:	e8 e9 fc ff ff       	call   80102080 <dirlookup>
80102397:	83 c4 10             	add    $0x10,%esp
8010239a:	85 c0                	test   %eax,%eax
8010239c:	75 67                	jne    80102405 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010239e:	8b 7b 58             	mov    0x58(%ebx),%edi
801023a1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801023a4:	85 ff                	test   %edi,%edi
801023a6:	74 29                	je     801023d1 <dirlink+0x51>
801023a8:	31 ff                	xor    %edi,%edi
801023aa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801023ad:	eb 09                	jmp    801023b8 <dirlink+0x38>
801023af:	90                   	nop
801023b0:	83 c7 10             	add    $0x10,%edi
801023b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023b6:	73 19                	jae    801023d1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b8:	6a 10                	push   $0x10
801023ba:	57                   	push   %edi
801023bb:	56                   	push   %esi
801023bc:	53                   	push   %ebx
801023bd:	e8 6e fa ff ff       	call   80101e30 <readi>
801023c2:	83 c4 10             	add    $0x10,%esp
801023c5:	83 f8 10             	cmp    $0x10,%eax
801023c8:	75 4e                	jne    80102418 <dirlink+0x98>
    if(de.inum == 0)
801023ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801023cf:	75 df                	jne    801023b0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801023d1:	83 ec 04             	sub    $0x4,%esp
801023d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801023d7:	6a 0e                	push   $0xe
801023d9:	ff 75 0c             	push   0xc(%ebp)
801023dc:	50                   	push   %eax
801023dd:	e8 7e 27 00 00       	call   80104b60 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023e2:	6a 10                	push   $0x10
  de.inum = inum;
801023e4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023e7:	57                   	push   %edi
801023e8:	56                   	push   %esi
801023e9:	53                   	push   %ebx
  de.inum = inum;
801023ea:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023ee:	e8 3d fb ff ff       	call   80101f30 <writei>
801023f3:	83 c4 20             	add    $0x20,%esp
801023f6:	83 f8 10             	cmp    $0x10,%eax
801023f9:	75 2a                	jne    80102425 <dirlink+0xa5>
  return 0;
801023fb:	31 c0                	xor    %eax,%eax
}
801023fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102400:	5b                   	pop    %ebx
80102401:	5e                   	pop    %esi
80102402:	5f                   	pop    %edi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
    iput(ip);
80102405:	83 ec 0c             	sub    $0xc,%esp
80102408:	50                   	push   %eax
80102409:	e8 42 f8 ff ff       	call   80101c50 <iput>
    return -1;
8010240e:	83 c4 10             	add    $0x10,%esp
80102411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102416:	eb e5                	jmp    801023fd <dirlink+0x7d>
      panic("dirlink read");
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	68 a8 76 10 80       	push   $0x801076a8
80102420:	e8 5b df ff ff       	call   80100380 <panic>
    panic("dirlink");
80102425:	83 ec 0c             	sub    $0xc,%esp
80102428:	68 7e 7c 10 80       	push   $0x80107c7e
8010242d:	e8 4e df ff ff       	call   80100380 <panic>
80102432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102440 <namei>:

struct inode*
namei(char *path)
{
80102440:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102441:	31 d2                	xor    %edx,%edx
{
80102443:	89 e5                	mov    %esp,%ebp
80102445:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
8010244b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010244e:	e8 dd fc ff ff       	call   80102130 <namex>
}
80102453:	c9                   	leave  
80102454:	c3                   	ret    
80102455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102460 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102460:	55                   	push   %ebp
  return namex(path, 1, name);
80102461:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102466:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102468:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010246b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010246e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010246f:	e9 bc fc ff ff       	jmp    80102130 <namex>
80102474:	66 90                	xchg   %ax,%ax
80102476:	66 90                	xchg   %ax,%ax
80102478:	66 90                	xchg   %ax,%ax
8010247a:	66 90                	xchg   %ax,%ax
8010247c:	66 90                	xchg   %ax,%ax
8010247e:	66 90                	xchg   %ax,%ax

80102480 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	57                   	push   %edi
80102484:	56                   	push   %esi
80102485:	53                   	push   %ebx
80102486:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102489:	85 c0                	test   %eax,%eax
8010248b:	0f 84 b4 00 00 00    	je     80102545 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102491:	8b 70 08             	mov    0x8(%eax),%esi
80102494:	89 c3                	mov    %eax,%ebx
80102496:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010249c:	0f 87 96 00 00 00    	ja     80102538 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ae:	66 90                	xchg   %ax,%ax
801024b0:	89 ca                	mov    %ecx,%edx
801024b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024b3:	83 e0 c0             	and    $0xffffffc0,%eax
801024b6:	3c 40                	cmp    $0x40,%al
801024b8:	75 f6                	jne    801024b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ba:	31 ff                	xor    %edi,%edi
801024bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801024c1:	89 f8                	mov    %edi,%eax
801024c3:	ee                   	out    %al,(%dx)
801024c4:	b8 01 00 00 00       	mov    $0x1,%eax
801024c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801024ce:	ee                   	out    %al,(%dx)
801024cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801024d4:	89 f0                	mov    %esi,%eax
801024d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801024d7:	89 f0                	mov    %esi,%eax
801024d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801024de:	c1 f8 08             	sar    $0x8,%eax
801024e1:	ee                   	out    %al,(%dx)
801024e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801024e7:	89 f8                	mov    %edi,%eax
801024e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801024ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801024ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024f3:	c1 e0 04             	shl    $0x4,%eax
801024f6:	83 e0 10             	and    $0x10,%eax
801024f9:	83 c8 e0             	or     $0xffffffe0,%eax
801024fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024fd:	f6 03 04             	testb  $0x4,(%ebx)
80102500:	75 16                	jne    80102518 <idestart+0x98>
80102502:	b8 20 00 00 00       	mov    $0x20,%eax
80102507:	89 ca                	mov    %ecx,%edx
80102509:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010250a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010250d:	5b                   	pop    %ebx
8010250e:	5e                   	pop    %esi
8010250f:	5f                   	pop    %edi
80102510:	5d                   	pop    %ebp
80102511:	c3                   	ret    
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102518:	b8 30 00 00 00       	mov    $0x30,%eax
8010251d:	89 ca                	mov    %ecx,%edx
8010251f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102520:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102525:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102528:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010252d:	fc                   	cld    
8010252e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102533:	5b                   	pop    %ebx
80102534:	5e                   	pop    %esi
80102535:	5f                   	pop    %edi
80102536:	5d                   	pop    %ebp
80102537:	c3                   	ret    
    panic("incorrect blockno");
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	68 14 77 10 80       	push   $0x80107714
80102540:	e8 3b de ff ff       	call   80100380 <panic>
    panic("idestart");
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	68 0b 77 10 80       	push   $0x8010770b
8010254d:	e8 2e de ff ff       	call   80100380 <panic>
80102552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102560 <ideinit>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102566:	68 26 77 10 80       	push   $0x80107726
8010256b:	68 20 1b 11 80       	push   $0x80111b20
80102570:	e8 fb 21 00 00       	call   80104770 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102575:	58                   	pop    %eax
80102576:	a1 a4 1c 11 80       	mov    0x80111ca4,%eax
8010257b:	5a                   	pop    %edx
8010257c:	83 e8 01             	sub    $0x1,%eax
8010257f:	50                   	push   %eax
80102580:	6a 0e                	push   $0xe
80102582:	e8 99 02 00 00       	call   80102820 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102587:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010258a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010258f:	90                   	nop
80102590:	ec                   	in     (%dx),%al
80102591:	83 e0 c0             	and    $0xffffffc0,%eax
80102594:	3c 40                	cmp    $0x40,%al
80102596:	75 f8                	jne    80102590 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102598:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010259d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025a2:	ee                   	out    %al,(%dx)
801025a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025ad:	eb 06                	jmp    801025b5 <ideinit+0x55>
801025af:	90                   	nop
  for(i=0; i<1000; i++){
801025b0:	83 e9 01             	sub    $0x1,%ecx
801025b3:	74 0f                	je     801025c4 <ideinit+0x64>
801025b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801025b6:	84 c0                	test   %al,%al
801025b8:	74 f6                	je     801025b0 <ideinit+0x50>
      havedisk1 = 1;
801025ba:	c7 05 00 1b 11 80 01 	movl   $0x1,0x80111b00
801025c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801025c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025ce:	ee                   	out    %al,(%dx)
}
801025cf:	c9                   	leave  
801025d0:	c3                   	ret    
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	57                   	push   %edi
801025e4:	56                   	push   %esi
801025e5:	53                   	push   %ebx
801025e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801025e9:	68 20 1b 11 80       	push   $0x80111b20
801025ee:	e8 4d 23 00 00       	call   80104940 <acquire>

  if((b = idequeue) == 0){
801025f3:	8b 1d 04 1b 11 80    	mov    0x80111b04,%ebx
801025f9:	83 c4 10             	add    $0x10,%esp
801025fc:	85 db                	test   %ebx,%ebx
801025fe:	74 63                	je     80102663 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102600:	8b 43 58             	mov    0x58(%ebx),%eax
80102603:	a3 04 1b 11 80       	mov    %eax,0x80111b04

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102608:	8b 33                	mov    (%ebx),%esi
8010260a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102610:	75 2f                	jne    80102641 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102612:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261e:	66 90                	xchg   %ax,%ax
80102620:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102621:	89 c1                	mov    %eax,%ecx
80102623:	83 e1 c0             	and    $0xffffffc0,%ecx
80102626:	80 f9 40             	cmp    $0x40,%cl
80102629:	75 f5                	jne    80102620 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010262b:	a8 21                	test   $0x21,%al
8010262d:	75 12                	jne    80102641 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010262f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102632:	b9 80 00 00 00       	mov    $0x80,%ecx
80102637:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010263c:	fc                   	cld    
8010263d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010263f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102641:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102644:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102647:	83 ce 02             	or     $0x2,%esi
8010264a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010264c:	53                   	push   %ebx
8010264d:	e8 4e 1e 00 00       	call   801044a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102652:	a1 04 1b 11 80       	mov    0x80111b04,%eax
80102657:	83 c4 10             	add    $0x10,%esp
8010265a:	85 c0                	test   %eax,%eax
8010265c:	74 05                	je     80102663 <ideintr+0x83>
    idestart(idequeue);
8010265e:	e8 1d fe ff ff       	call   80102480 <idestart>
    release(&idelock);
80102663:	83 ec 0c             	sub    $0xc,%esp
80102666:	68 20 1b 11 80       	push   $0x80111b20
8010266b:	e8 70 22 00 00       	call   801048e0 <release>

  release(&idelock);
}
80102670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102673:	5b                   	pop    %ebx
80102674:	5e                   	pop    %esi
80102675:	5f                   	pop    %edi
80102676:	5d                   	pop    %ebp
80102677:	c3                   	ret    
80102678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop

80102680 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	53                   	push   %ebx
80102684:	83 ec 10             	sub    $0x10,%esp
80102687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010268a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010268d:	50                   	push   %eax
8010268e:	e8 8d 20 00 00       	call   80104720 <holdingsleep>
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	85 c0                	test   %eax,%eax
80102698:	0f 84 c3 00 00 00    	je     80102761 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010269e:	8b 03                	mov    (%ebx),%eax
801026a0:	83 e0 06             	and    $0x6,%eax
801026a3:	83 f8 02             	cmp    $0x2,%eax
801026a6:	0f 84 a8 00 00 00    	je     80102754 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801026ac:	8b 53 04             	mov    0x4(%ebx),%edx
801026af:	85 d2                	test   %edx,%edx
801026b1:	74 0d                	je     801026c0 <iderw+0x40>
801026b3:	a1 00 1b 11 80       	mov    0x80111b00,%eax
801026b8:	85 c0                	test   %eax,%eax
801026ba:	0f 84 87 00 00 00    	je     80102747 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801026c0:	83 ec 0c             	sub    $0xc,%esp
801026c3:	68 20 1b 11 80       	push   $0x80111b20
801026c8:	e8 73 22 00 00       	call   80104940 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026cd:	a1 04 1b 11 80       	mov    0x80111b04,%eax
  b->qnext = 0;
801026d2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026d9:	83 c4 10             	add    $0x10,%esp
801026dc:	85 c0                	test   %eax,%eax
801026de:	74 60                	je     80102740 <iderw+0xc0>
801026e0:	89 c2                	mov    %eax,%edx
801026e2:	8b 40 58             	mov    0x58(%eax),%eax
801026e5:	85 c0                	test   %eax,%eax
801026e7:	75 f7                	jne    801026e0 <iderw+0x60>
801026e9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801026ec:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801026ee:	39 1d 04 1b 11 80    	cmp    %ebx,0x80111b04
801026f4:	74 3a                	je     80102730 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026f6:	8b 03                	mov    (%ebx),%eax
801026f8:	83 e0 06             	and    $0x6,%eax
801026fb:	83 f8 02             	cmp    $0x2,%eax
801026fe:	74 1b                	je     8010271b <iderw+0x9b>
    sleep(b, &idelock);
80102700:	83 ec 08             	sub    $0x8,%esp
80102703:	68 20 1b 11 80       	push   $0x80111b20
80102708:	53                   	push   %ebx
80102709:	e8 d2 1c 00 00       	call   801043e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010270e:	8b 03                	mov    (%ebx),%eax
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	83 e0 06             	and    $0x6,%eax
80102716:	83 f8 02             	cmp    $0x2,%eax
80102719:	75 e5                	jne    80102700 <iderw+0x80>
  }


  release(&idelock);
8010271b:	c7 45 08 20 1b 11 80 	movl   $0x80111b20,0x8(%ebp)
}
80102722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102725:	c9                   	leave  
  release(&idelock);
80102726:	e9 b5 21 00 00       	jmp    801048e0 <release>
8010272b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010272f:	90                   	nop
    idestart(b);
80102730:	89 d8                	mov    %ebx,%eax
80102732:	e8 49 fd ff ff       	call   80102480 <idestart>
80102737:	eb bd                	jmp    801026f6 <iderw+0x76>
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102740:	ba 04 1b 11 80       	mov    $0x80111b04,%edx
80102745:	eb a5                	jmp    801026ec <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102747:	83 ec 0c             	sub    $0xc,%esp
8010274a:	68 55 77 10 80       	push   $0x80107755
8010274f:	e8 2c dc ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102754:	83 ec 0c             	sub    $0xc,%esp
80102757:	68 40 77 10 80       	push   $0x80107740
8010275c:	e8 1f dc ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102761:	83 ec 0c             	sub    $0xc,%esp
80102764:	68 2a 77 10 80       	push   $0x8010772a
80102769:	e8 12 dc ff ff       	call   80100380 <panic>
8010276e:	66 90                	xchg   %ax,%ax

80102770 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102770:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102771:	c7 05 54 1b 11 80 00 	movl   $0xfec00000,0x80111b54
80102778:	00 c0 fe 
{
8010277b:	89 e5                	mov    %esp,%ebp
8010277d:	56                   	push   %esi
8010277e:	53                   	push   %ebx
  ioapic->reg = reg;
8010277f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102786:	00 00 00 
  return ioapic->data;
80102789:	8b 15 54 1b 11 80    	mov    0x80111b54,%edx
8010278f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102792:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102798:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010279e:	0f b6 15 a0 1c 11 80 	movzbl 0x80111ca0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027a5:	c1 ee 10             	shr    $0x10,%esi
801027a8:	89 f0                	mov    %esi,%eax
801027aa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801027ad:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801027b0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801027b3:	39 c2                	cmp    %eax,%edx
801027b5:	74 16                	je     801027cd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801027b7:	83 ec 0c             	sub    $0xc,%esp
801027ba:	68 74 77 10 80       	push   $0x80107774
801027bf:	e8 4c e0 ff ff       	call   80100810 <cprintf>
  ioapic->reg = reg;
801027c4:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
801027ca:	83 c4 10             	add    $0x10,%esp
801027cd:	83 c6 21             	add    $0x21,%esi
{
801027d0:	ba 10 00 00 00       	mov    $0x10,%edx
801027d5:	b8 20 00 00 00       	mov    $0x20,%eax
801027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801027e0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027e2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801027e4:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
  for(i = 0; i <= maxintr; i++){
801027ea:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027ed:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801027f3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801027f6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801027f9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801027fc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801027fe:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
80102804:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010280b:	39 f0                	cmp    %esi,%eax
8010280d:	75 d1                	jne    801027e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010280f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102812:	5b                   	pop    %ebx
80102813:	5e                   	pop    %esi
80102814:	5d                   	pop    %ebp
80102815:	c3                   	ret    
80102816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102820:	55                   	push   %ebp
  ioapic->reg = reg;
80102821:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
{
80102827:	89 e5                	mov    %esp,%ebp
80102829:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010282c:	8d 50 20             	lea    0x20(%eax),%edx
8010282f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102833:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102835:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010283b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010283e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102841:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102844:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102846:	a1 54 1b 11 80       	mov    0x80111b54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010284b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010284e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102851:	5d                   	pop    %ebp
80102852:	c3                   	ret    
80102853:	66 90                	xchg   %ax,%ax
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	53                   	push   %ebx
80102864:	83 ec 04             	sub    $0x4,%esp
80102867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010286a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102870:	75 76                	jne    801028e8 <kfree+0x88>
80102872:	81 fb f0 59 11 80    	cmp    $0x801159f0,%ebx
80102878:	72 6e                	jb     801028e8 <kfree+0x88>
8010287a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102880:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102885:	77 61                	ja     801028e8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102887:	83 ec 04             	sub    $0x4,%esp
8010288a:	68 00 10 00 00       	push   $0x1000
8010288f:	6a 01                	push   $0x1
80102891:	53                   	push   %ebx
80102892:	e8 69 21 00 00       	call   80104a00 <memset>

  if(kmem.use_lock)
80102897:	8b 15 94 1b 11 80    	mov    0x80111b94,%edx
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	85 d2                	test   %edx,%edx
801028a2:	75 1c                	jne    801028c0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801028a4:	a1 98 1b 11 80       	mov    0x80111b98,%eax
801028a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801028ab:	a1 94 1b 11 80       	mov    0x80111b94,%eax
  kmem.freelist = r;
801028b0:	89 1d 98 1b 11 80    	mov    %ebx,0x80111b98
  if(kmem.use_lock)
801028b6:	85 c0                	test   %eax,%eax
801028b8:	75 1e                	jne    801028d8 <kfree+0x78>
    release(&kmem.lock);
}
801028ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028bd:	c9                   	leave  
801028be:	c3                   	ret    
801028bf:	90                   	nop
    acquire(&kmem.lock);
801028c0:	83 ec 0c             	sub    $0xc,%esp
801028c3:	68 60 1b 11 80       	push   $0x80111b60
801028c8:	e8 73 20 00 00       	call   80104940 <acquire>
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	eb d2                	jmp    801028a4 <kfree+0x44>
801028d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801028d8:	c7 45 08 60 1b 11 80 	movl   $0x80111b60,0x8(%ebp)
}
801028df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e2:	c9                   	leave  
    release(&kmem.lock);
801028e3:	e9 f8 1f 00 00       	jmp    801048e0 <release>
    panic("kfree");
801028e8:	83 ec 0c             	sub    $0xc,%esp
801028eb:	68 a6 77 10 80       	push   $0x801077a6
801028f0:	e8 8b da ff ff       	call   80100380 <panic>
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <freerange>:
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102904:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102907:	8b 75 0c             	mov    0xc(%ebp),%esi
8010290a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010290b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102911:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102917:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010291d:	39 de                	cmp    %ebx,%esi
8010291f:	72 23                	jb     80102944 <freerange+0x44>
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102937:	50                   	push   %eax
80102938:	e8 23 ff ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	39 f3                	cmp    %esi,%ebx
80102942:	76 e4                	jbe    80102928 <freerange+0x28>
}
80102944:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102947:	5b                   	pop    %ebx
80102948:	5e                   	pop    %esi
80102949:	5d                   	pop    %ebp
8010294a:	c3                   	ret    
8010294b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <kinit2>:
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102954:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102957:	8b 75 0c             	mov    0xc(%ebp),%esi
8010295a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010295b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102961:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102967:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010296d:	39 de                	cmp    %ebx,%esi
8010296f:	72 23                	jb     80102994 <kinit2+0x44>
80102971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102981:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102987:	50                   	push   %eax
80102988:	e8 d3 fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010298d:	83 c4 10             	add    $0x10,%esp
80102990:	39 de                	cmp    %ebx,%esi
80102992:	73 e4                	jae    80102978 <kinit2+0x28>
  kmem.use_lock = 1;
80102994:	c7 05 94 1b 11 80 01 	movl   $0x1,0x80111b94
8010299b:	00 00 00 
}
8010299e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029a1:	5b                   	pop    %ebx
801029a2:	5e                   	pop    %esi
801029a3:	5d                   	pop    %ebp
801029a4:	c3                   	ret    
801029a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029b0 <kinit1>:
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	56                   	push   %esi
801029b4:	53                   	push   %ebx
801029b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801029b8:	83 ec 08             	sub    $0x8,%esp
801029bb:	68 ac 77 10 80       	push   $0x801077ac
801029c0:	68 60 1b 11 80       	push   $0x80111b60
801029c5:	e8 a6 1d 00 00       	call   80104770 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029cd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801029d0:	c7 05 94 1b 11 80 00 	movl   $0x0,0x80111b94
801029d7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801029da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029ec:	39 de                	cmp    %ebx,%esi
801029ee:	72 1c                	jb     80102a0c <kinit1+0x5c>
    kfree(p);
801029f0:	83 ec 0c             	sub    $0xc,%esp
801029f3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029ff:	50                   	push   %eax
80102a00:	e8 5b fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a05:	83 c4 10             	add    $0x10,%esp
80102a08:	39 de                	cmp    %ebx,%esi
80102a0a:	73 e4                	jae    801029f0 <kinit1+0x40>
}
80102a0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a0f:	5b                   	pop    %ebx
80102a10:	5e                   	pop    %esi
80102a11:	5d                   	pop    %ebp
80102a12:	c3                   	ret    
80102a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a20 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102a20:	a1 94 1b 11 80       	mov    0x80111b94,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	75 1f                	jne    80102a48 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102a29:	a1 98 1b 11 80       	mov    0x80111b98,%eax
  if(r)
80102a2e:	85 c0                	test   %eax,%eax
80102a30:	74 0e                	je     80102a40 <kalloc+0x20>
    kmem.freelist = r->next;
80102a32:	8b 10                	mov    (%eax),%edx
80102a34:	89 15 98 1b 11 80    	mov    %edx,0x80111b98
  if(kmem.use_lock)
80102a3a:	c3                   	ret    
80102a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102a40:	c3                   	ret    
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102a48:	55                   	push   %ebp
80102a49:	89 e5                	mov    %esp,%ebp
80102a4b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102a4e:	68 60 1b 11 80       	push   $0x80111b60
80102a53:	e8 e8 1e 00 00       	call   80104940 <acquire>
  r = kmem.freelist;
80102a58:	a1 98 1b 11 80       	mov    0x80111b98,%eax
  if(kmem.use_lock)
80102a5d:	8b 15 94 1b 11 80    	mov    0x80111b94,%edx
  if(r)
80102a63:	83 c4 10             	add    $0x10,%esp
80102a66:	85 c0                	test   %eax,%eax
80102a68:	74 08                	je     80102a72 <kalloc+0x52>
    kmem.freelist = r->next;
80102a6a:	8b 08                	mov    (%eax),%ecx
80102a6c:	89 0d 98 1b 11 80    	mov    %ecx,0x80111b98
  if(kmem.use_lock)
80102a72:	85 d2                	test   %edx,%edx
80102a74:	74 16                	je     80102a8c <kalloc+0x6c>
    release(&kmem.lock);
80102a76:	83 ec 0c             	sub    $0xc,%esp
80102a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a7c:	68 60 1b 11 80       	push   $0x80111b60
80102a81:	e8 5a 1e 00 00       	call   801048e0 <release>
  return (char*)r;
80102a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a89:	83 c4 10             	add    $0x10,%esp
}
80102a8c:	c9                   	leave  
80102a8d:	c3                   	ret    
80102a8e:	66 90                	xchg   %ax,%ax

80102a90 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a90:	ba 64 00 00 00       	mov    $0x64,%edx
80102a95:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a96:	a8 01                	test   $0x1,%al
80102a98:	0f 84 c2 00 00 00    	je     80102b60 <kbdgetc+0xd0>
{
80102a9e:	55                   	push   %ebp
80102a9f:	ba 60 00 00 00       	mov    $0x60,%edx
80102aa4:	89 e5                	mov    %esp,%ebp
80102aa6:	53                   	push   %ebx
80102aa7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102aa8:	8b 1d 9c 1b 11 80    	mov    0x80111b9c,%ebx
  data = inb(KBDATAP);
80102aae:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102ab1:	3c e0                	cmp    $0xe0,%al
80102ab3:	74 5b                	je     80102b10 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ab5:	89 da                	mov    %ebx,%edx
80102ab7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102aba:	84 c0                	test   %al,%al
80102abc:	78 62                	js     80102b20 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102abe:	85 d2                	test   %edx,%edx
80102ac0:	74 09                	je     80102acb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ac2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ac5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102ac8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102acb:	0f b6 91 e0 78 10 80 	movzbl -0x7fef8720(%ecx),%edx
  shift ^= togglecode[data];
80102ad2:	0f b6 81 e0 77 10 80 	movzbl -0x7fef8820(%ecx),%eax
  shift |= shiftcode[data];
80102ad9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102adb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102add:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102adf:	89 15 9c 1b 11 80    	mov    %edx,0x80111b9c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ae5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102ae8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102aeb:	8b 04 85 c0 77 10 80 	mov    -0x7fef8840(,%eax,4),%eax
80102af2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102af6:	74 0b                	je     80102b03 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102af8:	8d 50 9f             	lea    -0x61(%eax),%edx
80102afb:	83 fa 19             	cmp    $0x19,%edx
80102afe:	77 48                	ja     80102b48 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102b00:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b06:	c9                   	leave  
80102b07:	c3                   	ret    
80102b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0f:	90                   	nop
    shift |= E0ESC;
80102b10:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102b13:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b15:	89 1d 9c 1b 11 80    	mov    %ebx,0x80111b9c
}
80102b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b1e:	c9                   	leave  
80102b1f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102b20:	83 e0 7f             	and    $0x7f,%eax
80102b23:	85 d2                	test   %edx,%edx
80102b25:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102b28:	0f b6 81 e0 78 10 80 	movzbl -0x7fef8720(%ecx),%eax
80102b2f:	83 c8 40             	or     $0x40,%eax
80102b32:	0f b6 c0             	movzbl %al,%eax
80102b35:	f7 d0                	not    %eax
80102b37:	21 d8                	and    %ebx,%eax
}
80102b39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102b3c:	a3 9c 1b 11 80       	mov    %eax,0x80111b9c
    return 0;
80102b41:	31 c0                	xor    %eax,%eax
}
80102b43:	c9                   	leave  
80102b44:	c3                   	ret    
80102b45:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102b48:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102b4b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b51:	c9                   	leave  
      c += 'a' - 'A';
80102b52:	83 f9 1a             	cmp    $0x1a,%ecx
80102b55:	0f 42 c2             	cmovb  %edx,%eax
}
80102b58:	c3                   	ret    
80102b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b65:	c3                   	ret    
80102b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi

80102b70 <kbdintr>:

void
kbdintr(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b76:	68 90 2a 10 80       	push   $0x80102a90
80102b7b:	e8 50 df ff ff       	call   80100ad0 <consoleintr>
}
80102b80:	83 c4 10             	add    $0x10,%esp
80102b83:	c9                   	leave  
80102b84:	c3                   	ret    
80102b85:	66 90                	xchg   %ax,%ax
80102b87:	66 90                	xchg   %ax,%ax
80102b89:	66 90                	xchg   %ax,%ax
80102b8b:	66 90                	xchg   %ax,%ax
80102b8d:	66 90                	xchg   %ax,%ax
80102b8f:	90                   	nop

80102b90 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b90:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102b95:	85 c0                	test   %eax,%eax
80102b97:	0f 84 cb 00 00 00    	je     80102c68 <lapicinit+0xd8>
  lapic[index] = value;
80102b9d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ba4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102baa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102bb1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102bbe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102bcb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102bd8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bdb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bde:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102be5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102be8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102beb:	8b 50 30             	mov    0x30(%eax),%edx
80102bee:	c1 ea 10             	shr    $0x10,%edx
80102bf1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102bf7:	75 77                	jne    80102c70 <lapicinit+0xe0>
  lapic[index] = value;
80102bf9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102c00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c03:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c06:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c20:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c2d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102c34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c3a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102c41:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102c44:	8b 50 20             	mov    0x20(%eax),%edx
80102c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c56:	80 e6 10             	and    $0x10,%dh
80102c59:	75 f5                	jne    80102c50 <lapicinit+0xc0>
  lapic[index] = value;
80102c5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c7a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102c7d:	e9 77 ff ff ff       	jmp    80102bf9 <lapicinit+0x69>
80102c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c90:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102c95:	85 c0                	test   %eax,%eax
80102c97:	74 07                	je     80102ca0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102c99:	8b 40 20             	mov    0x20(%eax),%eax
80102c9c:	c1 e8 18             	shr    $0x18,%eax
80102c9f:	c3                   	ret    
    return 0;
80102ca0:	31 c0                	xor    %eax,%eax
}
80102ca2:	c3                   	ret    
80102ca3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102cb0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102cb0:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	74 0d                	je     80102cc6 <lapiceoi+0x16>
  lapic[index] = value;
80102cb9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cc0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102cc6:	c3                   	ret    
80102cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102cd0:	c3                   	ret    
80102cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ce0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ce6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ceb:	89 e5                	mov    %esp,%ebp
80102ced:	53                   	push   %ebx
80102cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cf4:	ee                   	out    %al,(%dx)
80102cf5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cfa:	ba 71 00 00 00       	mov    $0x71,%edx
80102cff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102d00:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102d02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102d05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102d0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102d10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102d12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102d1e:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102d23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102d33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102d40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d6d:	c9                   	leave  
80102d6e:	c3                   	ret    
80102d6f:	90                   	nop

80102d70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d70:	55                   	push   %ebp
80102d71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d76:	ba 70 00 00 00       	mov    $0x70,%edx
80102d7b:	89 e5                	mov    %esp,%ebp
80102d7d:	57                   	push   %edi
80102d7e:	56                   	push   %esi
80102d7f:	53                   	push   %ebx
80102d80:	83 ec 4c             	sub    $0x4c,%esp
80102d83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d84:	ba 71 00 00 00       	mov    $0x71,%edx
80102d89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d8d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
80102d98:	31 c0                	xor    %eax,%eax
80102d9a:	89 da                	mov    %ebx,%edx
80102d9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102da2:	89 ca                	mov    %ecx,%edx
80102da4:	ec                   	in     (%dx),%al
80102da5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da8:	89 da                	mov    %ebx,%edx
80102daa:	b8 02 00 00 00       	mov    $0x2,%eax
80102daf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102db0:	89 ca                	mov    %ecx,%edx
80102db2:	ec                   	in     (%dx),%al
80102db3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db6:	89 da                	mov    %ebx,%edx
80102db8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbe:	89 ca                	mov    %ecx,%edx
80102dc0:	ec                   	in     (%dx),%al
80102dc1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc4:	89 da                	mov    %ebx,%edx
80102dc6:	b8 07 00 00 00       	mov    $0x7,%eax
80102dcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dcc:	89 ca                	mov    %ecx,%edx
80102dce:	ec                   	in     (%dx),%al
80102dcf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd2:	89 da                	mov    %ebx,%edx
80102dd4:	b8 08 00 00 00       	mov    $0x8,%eax
80102dd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dda:	89 ca                	mov    %ecx,%edx
80102ddc:	ec                   	in     (%dx),%al
80102ddd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ddf:	89 da                	mov    %ebx,%edx
80102de1:	b8 09 00 00 00       	mov    $0x9,%eax
80102de6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de7:	89 ca                	mov    %ecx,%edx
80102de9:	ec                   	in     (%dx),%al
80102dea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dec:	89 da                	mov    %ebx,%edx
80102dee:	b8 0a 00 00 00       	mov    $0xa,%eax
80102df3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df4:	89 ca                	mov    %ecx,%edx
80102df6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102df7:	84 c0                	test   %al,%al
80102df9:	78 9d                	js     80102d98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102dfb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102dff:	89 fa                	mov    %edi,%edx
80102e01:	0f b6 fa             	movzbl %dl,%edi
80102e04:	89 f2                	mov    %esi,%edx
80102e06:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102e09:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102e0d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e10:	89 da                	mov    %ebx,%edx
80102e12:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102e15:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102e18:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102e1c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102e1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102e22:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102e26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102e29:	31 c0                	xor    %eax,%eax
80102e2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e2c:	89 ca                	mov    %ecx,%edx
80102e2e:	ec                   	in     (%dx),%al
80102e2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e32:	89 da                	mov    %ebx,%edx
80102e34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102e37:	b8 02 00 00 00       	mov    $0x2,%eax
80102e3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e3d:	89 ca                	mov    %ecx,%edx
80102e3f:	ec                   	in     (%dx),%al
80102e40:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e43:	89 da                	mov    %ebx,%edx
80102e45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102e48:	b8 04 00 00 00       	mov    $0x4,%eax
80102e4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4e:	89 ca                	mov    %ecx,%edx
80102e50:	ec                   	in     (%dx),%al
80102e51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e54:	89 da                	mov    %ebx,%edx
80102e56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e59:	b8 07 00 00 00       	mov    $0x7,%eax
80102e5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e5f:	89 ca                	mov    %ecx,%edx
80102e61:	ec                   	in     (%dx),%al
80102e62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e65:	89 da                	mov    %ebx,%edx
80102e67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e70:	89 ca                	mov    %ecx,%edx
80102e72:	ec                   	in     (%dx),%al
80102e73:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e76:	89 da                	mov    %ebx,%edx
80102e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e80:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e81:	89 ca                	mov    %ecx,%edx
80102e83:	ec                   	in     (%dx),%al
80102e84:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e87:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e8d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e90:	6a 18                	push   $0x18
80102e92:	50                   	push   %eax
80102e93:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e96:	50                   	push   %eax
80102e97:	e8 b4 1b 00 00       	call   80104a50 <memcmp>
80102e9c:	83 c4 10             	add    $0x10,%esp
80102e9f:	85 c0                	test   %eax,%eax
80102ea1:	0f 85 f1 fe ff ff    	jne    80102d98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ea7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102eab:	75 78                	jne    80102f25 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ead:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102eb0:	89 c2                	mov    %eax,%edx
80102eb2:	83 e0 0f             	and    $0xf,%eax
80102eb5:	c1 ea 04             	shr    $0x4,%edx
80102eb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ebb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ebe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ec1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ec4:	89 c2                	mov    %eax,%edx
80102ec6:	83 e0 0f             	and    $0xf,%eax
80102ec9:	c1 ea 04             	shr    $0x4,%edx
80102ecc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ecf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ed2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ed5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ed8:	89 c2                	mov    %eax,%edx
80102eda:	83 e0 0f             	and    $0xf,%eax
80102edd:	c1 ea 04             	shr    $0x4,%edx
80102ee0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ee3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ee6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ee9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102eec:	89 c2                	mov    %eax,%edx
80102eee:	83 e0 0f             	and    $0xf,%eax
80102ef1:	c1 ea 04             	shr    $0x4,%edx
80102ef4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ef7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102efa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102efd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f00:	89 c2                	mov    %eax,%edx
80102f02:	83 e0 0f             	and    $0xf,%eax
80102f05:	c1 ea 04             	shr    $0x4,%edx
80102f08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102f11:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f14:	89 c2                	mov    %eax,%edx
80102f16:	83 e0 0f             	and    $0xf,%eax
80102f19:	c1 ea 04             	shr    $0x4,%edx
80102f1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f22:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102f25:	8b 75 08             	mov    0x8(%ebp),%esi
80102f28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f2b:	89 06                	mov    %eax,(%esi)
80102f2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f30:	89 46 04             	mov    %eax,0x4(%esi)
80102f33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f36:	89 46 08             	mov    %eax,0x8(%esi)
80102f39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f3c:	89 46 0c             	mov    %eax,0xc(%esi)
80102f3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f42:	89 46 10             	mov    %eax,0x10(%esi)
80102f45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f48:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102f4b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f55:	5b                   	pop    %ebx
80102f56:	5e                   	pop    %esi
80102f57:	5f                   	pop    %edi
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    
80102f5a:	66 90                	xchg   %ax,%ax
80102f5c:	66 90                	xchg   %ax,%ax
80102f5e:	66 90                	xchg   %ax,%ax

80102f60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f60:	8b 0d 08 1c 11 80    	mov    0x80111c08,%ecx
80102f66:	85 c9                	test   %ecx,%ecx
80102f68:	0f 8e 8a 00 00 00    	jle    80102ff8 <install_trans+0x98>
{
80102f6e:	55                   	push   %ebp
80102f6f:	89 e5                	mov    %esp,%ebp
80102f71:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f72:	31 ff                	xor    %edi,%edi
{
80102f74:	56                   	push   %esi
80102f75:	53                   	push   %ebx
80102f76:	83 ec 0c             	sub    $0xc,%esp
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f80:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
80102f85:	83 ec 08             	sub    $0x8,%esp
80102f88:	01 f8                	add    %edi,%eax
80102f8a:	83 c0 01             	add    $0x1,%eax
80102f8d:	50                   	push   %eax
80102f8e:	ff 35 04 1c 11 80    	push   0x80111c04
80102f94:	e8 37 d1 ff ff       	call   801000d0 <bread>
80102f99:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f9b:	58                   	pop    %eax
80102f9c:	5a                   	pop    %edx
80102f9d:	ff 34 bd 0c 1c 11 80 	push   -0x7feee3f4(,%edi,4)
80102fa4:	ff 35 04 1c 11 80    	push   0x80111c04
  for (tail = 0; tail < log.lh.n; tail++) {
80102faa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fad:	e8 1e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fb5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fb7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fba:	68 00 02 00 00       	push   $0x200
80102fbf:	50                   	push   %eax
80102fc0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102fc3:	50                   	push   %eax
80102fc4:	e8 d7 1a 00 00       	call   80104aa0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102fc9:	89 1c 24             	mov    %ebx,(%esp)
80102fcc:	e8 df d1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102fd1:	89 34 24             	mov    %esi,(%esp)
80102fd4:	e8 17 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102fd9:	89 1c 24             	mov    %ebx,(%esp)
80102fdc:	e8 0f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	39 3d 08 1c 11 80    	cmp    %edi,0x80111c08
80102fea:	7f 94                	jg     80102f80 <install_trans+0x20>
  }
}
80102fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fef:	5b                   	pop    %ebx
80102ff0:	5e                   	pop    %esi
80102ff1:	5f                   	pop    %edi
80102ff2:	5d                   	pop    %ebp
80102ff3:	c3                   	ret    
80102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ff8:	c3                   	ret    
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103000 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103007:	ff 35 f4 1b 11 80    	push   0x80111bf4
8010300d:	ff 35 04 1c 11 80    	push   0x80111c04
80103013:	e8 b8 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103018:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010301b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010301d:	a1 08 1c 11 80       	mov    0x80111c08,%eax
80103022:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103025:	85 c0                	test   %eax,%eax
80103027:	7e 19                	jle    80103042 <write_head+0x42>
80103029:	31 d2                	xor    %edx,%edx
8010302b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103030:	8b 0c 95 0c 1c 11 80 	mov    -0x7feee3f4(,%edx,4),%ecx
80103037:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010303b:	83 c2 01             	add    $0x1,%edx
8010303e:	39 d0                	cmp    %edx,%eax
80103040:	75 ee                	jne    80103030 <write_head+0x30>
  }
  bwrite(buf);
80103042:	83 ec 0c             	sub    $0xc,%esp
80103045:	53                   	push   %ebx
80103046:	e8 65 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010304b:	89 1c 24             	mov    %ebx,(%esp)
8010304e:	e8 9d d1 ff ff       	call   801001f0 <brelse>
}
80103053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103056:	83 c4 10             	add    $0x10,%esp
80103059:	c9                   	leave  
8010305a:	c3                   	ret    
8010305b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010305f:	90                   	nop

80103060 <initlog>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 2c             	sub    $0x2c,%esp
80103067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010306a:	68 e0 79 10 80       	push   $0x801079e0
8010306f:	68 c0 1b 11 80       	push   $0x80111bc0
80103074:	e8 f7 16 00 00       	call   80104770 <initlock>
  readsb(dev, &sb);
80103079:	58                   	pop    %eax
8010307a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010307d:	5a                   	pop    %edx
8010307e:	50                   	push   %eax
8010307f:	53                   	push   %ebx
80103080:	e8 3b e8 ff ff       	call   801018c0 <readsb>
  log.start = sb.logstart;
80103085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103088:	59                   	pop    %ecx
  log.dev = dev;
80103089:	89 1d 04 1c 11 80    	mov    %ebx,0x80111c04
  log.size = sb.nlog;
8010308f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103092:	a3 f4 1b 11 80       	mov    %eax,0x80111bf4
  log.size = sb.nlog;
80103097:	89 15 f8 1b 11 80    	mov    %edx,0x80111bf8
  struct buf *buf = bread(log.dev, log.start);
8010309d:	5a                   	pop    %edx
8010309e:	50                   	push   %eax
8010309f:	53                   	push   %ebx
801030a0:	e8 2b d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801030a5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801030a8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801030ab:	89 1d 08 1c 11 80    	mov    %ebx,0x80111c08
  for (i = 0; i < log.lh.n; i++) {
801030b1:	85 db                	test   %ebx,%ebx
801030b3:	7e 1d                	jle    801030d2 <initlog+0x72>
801030b5:	31 d2                	xor    %edx,%edx
801030b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030be:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801030c0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801030c4:	89 0c 95 0c 1c 11 80 	mov    %ecx,-0x7feee3f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801030cb:	83 c2 01             	add    $0x1,%edx
801030ce:	39 d3                	cmp    %edx,%ebx
801030d0:	75 ee                	jne    801030c0 <initlog+0x60>
  brelse(buf);
801030d2:	83 ec 0c             	sub    $0xc,%esp
801030d5:	50                   	push   %eax
801030d6:	e8 15 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801030db:	e8 80 fe ff ff       	call   80102f60 <install_trans>
  log.lh.n = 0;
801030e0:	c7 05 08 1c 11 80 00 	movl   $0x0,0x80111c08
801030e7:	00 00 00 
  write_head(); // clear the log
801030ea:	e8 11 ff ff ff       	call   80103000 <write_head>
}
801030ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030f2:	83 c4 10             	add    $0x10,%esp
801030f5:	c9                   	leave  
801030f6:	c3                   	ret    
801030f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030fe:	66 90                	xchg   %ax,%ax

80103100 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103106:	68 c0 1b 11 80       	push   $0x80111bc0
8010310b:	e8 30 18 00 00       	call   80104940 <acquire>
80103110:	83 c4 10             	add    $0x10,%esp
80103113:	eb 18                	jmp    8010312d <begin_op+0x2d>
80103115:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103118:	83 ec 08             	sub    $0x8,%esp
8010311b:	68 c0 1b 11 80       	push   $0x80111bc0
80103120:	68 c0 1b 11 80       	push   $0x80111bc0
80103125:	e8 b6 12 00 00       	call   801043e0 <sleep>
8010312a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010312d:	a1 00 1c 11 80       	mov    0x80111c00,%eax
80103132:	85 c0                	test   %eax,%eax
80103134:	75 e2                	jne    80103118 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103136:	a1 fc 1b 11 80       	mov    0x80111bfc,%eax
8010313b:	8b 15 08 1c 11 80    	mov    0x80111c08,%edx
80103141:	83 c0 01             	add    $0x1,%eax
80103144:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103147:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010314a:	83 fa 1e             	cmp    $0x1e,%edx
8010314d:	7f c9                	jg     80103118 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010314f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103152:	a3 fc 1b 11 80       	mov    %eax,0x80111bfc
      release(&log.lock);
80103157:	68 c0 1b 11 80       	push   $0x80111bc0
8010315c:	e8 7f 17 00 00       	call   801048e0 <release>
      break;
    }
  }
}
80103161:	83 c4 10             	add    $0x10,%esp
80103164:	c9                   	leave  
80103165:	c3                   	ret    
80103166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010316d:	8d 76 00             	lea    0x0(%esi),%esi

80103170 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103179:	68 c0 1b 11 80       	push   $0x80111bc0
8010317e:	e8 bd 17 00 00       	call   80104940 <acquire>
  log.outstanding -= 1;
80103183:	a1 fc 1b 11 80       	mov    0x80111bfc,%eax
  if(log.committing)
80103188:	8b 35 00 1c 11 80    	mov    0x80111c00,%esi
8010318e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103191:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103194:	89 1d fc 1b 11 80    	mov    %ebx,0x80111bfc
  if(log.committing)
8010319a:	85 f6                	test   %esi,%esi
8010319c:	0f 85 22 01 00 00    	jne    801032c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801031a2:	85 db                	test   %ebx,%ebx
801031a4:	0f 85 f6 00 00 00    	jne    801032a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801031aa:	c7 05 00 1c 11 80 01 	movl   $0x1,0x80111c00
801031b1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801031b4:	83 ec 0c             	sub    $0xc,%esp
801031b7:	68 c0 1b 11 80       	push   $0x80111bc0
801031bc:	e8 1f 17 00 00       	call   801048e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801031c1:	8b 0d 08 1c 11 80    	mov    0x80111c08,%ecx
801031c7:	83 c4 10             	add    $0x10,%esp
801031ca:	85 c9                	test   %ecx,%ecx
801031cc:	7f 42                	jg     80103210 <end_op+0xa0>
    acquire(&log.lock);
801031ce:	83 ec 0c             	sub    $0xc,%esp
801031d1:	68 c0 1b 11 80       	push   $0x80111bc0
801031d6:	e8 65 17 00 00       	call   80104940 <acquire>
    wakeup(&log);
801031db:	c7 04 24 c0 1b 11 80 	movl   $0x80111bc0,(%esp)
    log.committing = 0;
801031e2:	c7 05 00 1c 11 80 00 	movl   $0x0,0x80111c00
801031e9:	00 00 00 
    wakeup(&log);
801031ec:	e8 af 12 00 00       	call   801044a0 <wakeup>
    release(&log.lock);
801031f1:	c7 04 24 c0 1b 11 80 	movl   $0x80111bc0,(%esp)
801031f8:	e8 e3 16 00 00       	call   801048e0 <release>
801031fd:	83 c4 10             	add    $0x10,%esp
}
80103200:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103203:	5b                   	pop    %ebx
80103204:	5e                   	pop    %esi
80103205:	5f                   	pop    %edi
80103206:	5d                   	pop    %ebp
80103207:	c3                   	ret    
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103210:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
80103215:	83 ec 08             	sub    $0x8,%esp
80103218:	01 d8                	add    %ebx,%eax
8010321a:	83 c0 01             	add    $0x1,%eax
8010321d:	50                   	push   %eax
8010321e:	ff 35 04 1c 11 80    	push   0x80111c04
80103224:	e8 a7 ce ff ff       	call   801000d0 <bread>
80103229:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010322b:	58                   	pop    %eax
8010322c:	5a                   	pop    %edx
8010322d:	ff 34 9d 0c 1c 11 80 	push   -0x7feee3f4(,%ebx,4)
80103234:	ff 35 04 1c 11 80    	push   0x80111c04
  for (tail = 0; tail < log.lh.n; tail++) {
8010323a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010323d:	e8 8e ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103242:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103245:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010324a:	68 00 02 00 00       	push   $0x200
8010324f:	50                   	push   %eax
80103250:	8d 46 5c             	lea    0x5c(%esi),%eax
80103253:	50                   	push   %eax
80103254:	e8 47 18 00 00       	call   80104aa0 <memmove>
    bwrite(to);  // write the log
80103259:	89 34 24             	mov    %esi,(%esp)
8010325c:	e8 4f cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103261:	89 3c 24             	mov    %edi,(%esp)
80103264:	e8 87 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103269:	89 34 24             	mov    %esi,(%esp)
8010326c:	e8 7f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103271:	83 c4 10             	add    $0x10,%esp
80103274:	3b 1d 08 1c 11 80    	cmp    0x80111c08,%ebx
8010327a:	7c 94                	jl     80103210 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010327c:	e8 7f fd ff ff       	call   80103000 <write_head>
    install_trans(); // Now install writes to home locations
80103281:	e8 da fc ff ff       	call   80102f60 <install_trans>
    log.lh.n = 0;
80103286:	c7 05 08 1c 11 80 00 	movl   $0x0,0x80111c08
8010328d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103290:	e8 6b fd ff ff       	call   80103000 <write_head>
80103295:	e9 34 ff ff ff       	jmp    801031ce <end_op+0x5e>
8010329a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801032a0:	83 ec 0c             	sub    $0xc,%esp
801032a3:	68 c0 1b 11 80       	push   $0x80111bc0
801032a8:	e8 f3 11 00 00       	call   801044a0 <wakeup>
  release(&log.lock);
801032ad:	c7 04 24 c0 1b 11 80 	movl   $0x80111bc0,(%esp)
801032b4:	e8 27 16 00 00       	call   801048e0 <release>
801032b9:	83 c4 10             	add    $0x10,%esp
}
801032bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032bf:	5b                   	pop    %ebx
801032c0:	5e                   	pop    %esi
801032c1:	5f                   	pop    %edi
801032c2:	5d                   	pop    %ebp
801032c3:	c3                   	ret    
    panic("log.committing");
801032c4:	83 ec 0c             	sub    $0xc,%esp
801032c7:	68 e4 79 10 80       	push   $0x801079e4
801032cc:	e8 af d0 ff ff       	call   80100380 <panic>
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop

801032e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	53                   	push   %ebx
801032e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032e7:	8b 15 08 1c 11 80    	mov    0x80111c08,%edx
{
801032ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032f0:	83 fa 1d             	cmp    $0x1d,%edx
801032f3:	0f 8f 85 00 00 00    	jg     8010337e <log_write+0x9e>
801032f9:	a1 f8 1b 11 80       	mov    0x80111bf8,%eax
801032fe:	83 e8 01             	sub    $0x1,%eax
80103301:	39 c2                	cmp    %eax,%edx
80103303:	7d 79                	jge    8010337e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103305:	a1 fc 1b 11 80       	mov    0x80111bfc,%eax
8010330a:	85 c0                	test   %eax,%eax
8010330c:	7e 7d                	jle    8010338b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010330e:	83 ec 0c             	sub    $0xc,%esp
80103311:	68 c0 1b 11 80       	push   $0x80111bc0
80103316:	e8 25 16 00 00       	call   80104940 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010331b:	8b 15 08 1c 11 80    	mov    0x80111c08,%edx
80103321:	83 c4 10             	add    $0x10,%esp
80103324:	85 d2                	test   %edx,%edx
80103326:	7e 4a                	jle    80103372 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103328:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010332b:	31 c0                	xor    %eax,%eax
8010332d:	eb 08                	jmp    80103337 <log_write+0x57>
8010332f:	90                   	nop
80103330:	83 c0 01             	add    $0x1,%eax
80103333:	39 c2                	cmp    %eax,%edx
80103335:	74 29                	je     80103360 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103337:	39 0c 85 0c 1c 11 80 	cmp    %ecx,-0x7feee3f4(,%eax,4)
8010333e:	75 f0                	jne    80103330 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103340:	89 0c 85 0c 1c 11 80 	mov    %ecx,-0x7feee3f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103347:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010334a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010334d:	c7 45 08 c0 1b 11 80 	movl   $0x80111bc0,0x8(%ebp)
}
80103354:	c9                   	leave  
  release(&log.lock);
80103355:	e9 86 15 00 00       	jmp    801048e0 <release>
8010335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103360:	89 0c 95 0c 1c 11 80 	mov    %ecx,-0x7feee3f4(,%edx,4)
    log.lh.n++;
80103367:	83 c2 01             	add    $0x1,%edx
8010336a:	89 15 08 1c 11 80    	mov    %edx,0x80111c08
80103370:	eb d5                	jmp    80103347 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103372:	8b 43 08             	mov    0x8(%ebx),%eax
80103375:	a3 0c 1c 11 80       	mov    %eax,0x80111c0c
  if (i == log.lh.n)
8010337a:	75 cb                	jne    80103347 <log_write+0x67>
8010337c:	eb e9                	jmp    80103367 <log_write+0x87>
    panic("too big a transaction");
8010337e:	83 ec 0c             	sub    $0xc,%esp
80103381:	68 f3 79 10 80       	push   $0x801079f3
80103386:	e8 f5 cf ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010338b:	83 ec 0c             	sub    $0xc,%esp
8010338e:	68 09 7a 10 80       	push   $0x80107a09
80103393:	e8 e8 cf ff ff       	call   80100380 <panic>
80103398:	66 90                	xchg   %ax,%ax
8010339a:	66 90                	xchg   %ax,%ax
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	53                   	push   %ebx
801033a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801033a7:	e8 44 09 00 00       	call   80103cf0 <cpuid>
801033ac:	89 c3                	mov    %eax,%ebx
801033ae:	e8 3d 09 00 00       	call   80103cf0 <cpuid>
801033b3:	83 ec 04             	sub    $0x4,%esp
801033b6:	53                   	push   %ebx
801033b7:	50                   	push   %eax
801033b8:	68 24 7a 10 80       	push   $0x80107a24
801033bd:	e8 4e d4 ff ff       	call   80100810 <cprintf>
  idtinit();       // load idt register
801033c2:	e8 b9 28 00 00       	call   80105c80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801033c7:	e8 c4 08 00 00       	call   80103c90 <mycpu>
801033cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033ce:	b8 01 00 00 00       	mov    $0x1,%eax
801033d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801033da:	e8 f1 0b 00 00       	call   80103fd0 <scheduler>
801033df:	90                   	nop

801033e0 <mpenter>:
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033e6:	e8 85 39 00 00       	call   80106d70 <switchkvm>
  seginit();
801033eb:	e8 f0 38 00 00       	call   80106ce0 <seginit>
  lapicinit();
801033f0:	e8 9b f7 ff ff       	call   80102b90 <lapicinit>
  mpmain();
801033f5:	e8 a6 ff ff ff       	call   801033a0 <mpmain>
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <main>:
{
80103400:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103404:	83 e4 f0             	and    $0xfffffff0,%esp
80103407:	ff 71 fc             	push   -0x4(%ecx)
8010340a:	55                   	push   %ebp
8010340b:	89 e5                	mov    %esp,%ebp
8010340d:	53                   	push   %ebx
8010340e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010340f:	83 ec 08             	sub    $0x8,%esp
80103412:	68 00 00 40 80       	push   $0x80400000
80103417:	68 f0 59 11 80       	push   $0x801159f0
8010341c:	e8 8f f5 ff ff       	call   801029b0 <kinit1>
  kvmalloc();      // kernel page table
80103421:	e8 3a 3e 00 00       	call   80107260 <kvmalloc>
  mpinit();        // detect other processors
80103426:	e8 85 01 00 00       	call   801035b0 <mpinit>
  lapicinit();     // interrupt controller
8010342b:	e8 60 f7 ff ff       	call   80102b90 <lapicinit>
  seginit();       // segment descriptors
80103430:	e8 ab 38 00 00       	call   80106ce0 <seginit>
  picinit();       // disable pic
80103435:	e8 76 03 00 00       	call   801037b0 <picinit>
  ioapicinit();    // another interrupt controller
8010343a:	e8 31 f3 ff ff       	call   80102770 <ioapicinit>
  consoleinit();   // console hardware
8010343f:	e8 bc d9 ff ff       	call   80100e00 <consoleinit>
  uartinit();      // serial port
80103444:	e8 27 2b 00 00       	call   80105f70 <uartinit>
  pinit();         // process table
80103449:	e8 22 08 00 00       	call   80103c70 <pinit>
  tvinit();        // trap vectors
8010344e:	e8 ad 27 00 00       	call   80105c00 <tvinit>
  binit();         // buffer cache
80103453:	e8 e8 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103458:	e8 53 dd ff ff       	call   801011b0 <fileinit>
  ideinit();       // disk 
8010345d:	e8 fe f0 ff ff       	call   80102560 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103462:	83 c4 0c             	add    $0xc,%esp
80103465:	68 8a 00 00 00       	push   $0x8a
8010346a:	68 8c a4 10 80       	push   $0x8010a48c
8010346f:	68 00 70 00 80       	push   $0x80007000
80103474:	e8 27 16 00 00       	call   80104aa0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	69 05 a4 1c 11 80 b0 	imul   $0xb0,0x80111ca4,%eax
80103483:	00 00 00 
80103486:	05 c0 1c 11 80       	add    $0x80111cc0,%eax
8010348b:	3d c0 1c 11 80       	cmp    $0x80111cc0,%eax
80103490:	76 7e                	jbe    80103510 <main+0x110>
80103492:	bb c0 1c 11 80       	mov    $0x80111cc0,%ebx
80103497:	eb 20                	jmp    801034b9 <main+0xb9>
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a0:	69 05 a4 1c 11 80 b0 	imul   $0xb0,0x80111ca4,%eax
801034a7:	00 00 00 
801034aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801034b0:	05 c0 1c 11 80       	add    $0x80111cc0,%eax
801034b5:	39 c3                	cmp    %eax,%ebx
801034b7:	73 57                	jae    80103510 <main+0x110>
    if(c == mycpu())  // We've started already.
801034b9:	e8 d2 07 00 00       	call   80103c90 <mycpu>
801034be:	39 c3                	cmp    %eax,%ebx
801034c0:	74 de                	je     801034a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801034c2:	e8 59 f5 ff ff       	call   80102a20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801034c7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801034ca:	c7 05 f8 6f 00 80 e0 	movl   $0x801033e0,0x80006ff8
801034d1:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034d4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801034db:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801034de:	05 00 10 00 00       	add    $0x1000,%eax
801034e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801034e8:	0f b6 03             	movzbl (%ebx),%eax
801034eb:	68 00 70 00 00       	push   $0x7000
801034f0:	50                   	push   %eax
801034f1:	e8 ea f7 ff ff       	call   80102ce0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034f6:	83 c4 10             	add    $0x10,%esp
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103500:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103506:	85 c0                	test   %eax,%eax
80103508:	74 f6                	je     80103500 <main+0x100>
8010350a:	eb 94                	jmp    801034a0 <main+0xa0>
8010350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103510:	83 ec 08             	sub    $0x8,%esp
80103513:	68 00 00 00 8e       	push   $0x8e000000
80103518:	68 00 00 40 80       	push   $0x80400000
8010351d:	e8 2e f4 ff ff       	call   80102950 <kinit2>
  userinit();      // first user process
80103522:	e8 19 08 00 00       	call   80103d40 <userinit>
  mpmain();        // finish this processor's setup
80103527:	e8 74 fe ff ff       	call   801033a0 <mpmain>
8010352c:	66 90                	xchg   %ax,%ax
8010352e:	66 90                	xchg   %ax,%ax

80103530 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103535:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010353b:	53                   	push   %ebx
  e = addr+len;
8010353c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010353f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103542:	39 de                	cmp    %ebx,%esi
80103544:	72 10                	jb     80103556 <mpsearch1+0x26>
80103546:	eb 50                	jmp    80103598 <mpsearch1+0x68>
80103548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop
80103550:	89 fe                	mov    %edi,%esi
80103552:	39 fb                	cmp    %edi,%ebx
80103554:	76 42                	jbe    80103598 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103556:	83 ec 04             	sub    $0x4,%esp
80103559:	8d 7e 10             	lea    0x10(%esi),%edi
8010355c:	6a 04                	push   $0x4
8010355e:	68 38 7a 10 80       	push   $0x80107a38
80103563:	56                   	push   %esi
80103564:	e8 e7 14 00 00       	call   80104a50 <memcmp>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	85 c0                	test   %eax,%eax
8010356e:	75 e0                	jne    80103550 <mpsearch1+0x20>
80103570:	89 f2                	mov    %esi,%edx
80103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103578:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010357b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010357e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103580:	39 fa                	cmp    %edi,%edx
80103582:	75 f4                	jne    80103578 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103584:	84 c0                	test   %al,%al
80103586:	75 c8                	jne    80103550 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103588:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010358b:	89 f0                	mov    %esi,%eax
8010358d:	5b                   	pop    %ebx
8010358e:	5e                   	pop    %esi
8010358f:	5f                   	pop    %edi
80103590:	5d                   	pop    %ebp
80103591:	c3                   	ret    
80103592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103598:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010359b:	31 f6                	xor    %esi,%esi
}
8010359d:	5b                   	pop    %ebx
8010359e:	89 f0                	mov    %esi,%eax
801035a0:	5e                   	pop    %esi
801035a1:	5f                   	pop    %edi
801035a2:	5d                   	pop    %ebp
801035a3:	c3                   	ret    
801035a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035af:	90                   	nop

801035b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801035b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801035c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801035c7:	c1 e0 08             	shl    $0x8,%eax
801035ca:	09 d0                	or     %edx,%eax
801035cc:	c1 e0 04             	shl    $0x4,%eax
801035cf:	75 1b                	jne    801035ec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801035d1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801035d8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035df:	c1 e0 08             	shl    $0x8,%eax
801035e2:	09 d0                	or     %edx,%eax
801035e4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035e7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035ec:	ba 00 04 00 00       	mov    $0x400,%edx
801035f1:	e8 3a ff ff ff       	call   80103530 <mpsearch1>
801035f6:	89 c3                	mov    %eax,%ebx
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 84 40 01 00 00    	je     80103740 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103600:	8b 73 04             	mov    0x4(%ebx),%esi
80103603:	85 f6                	test   %esi,%esi
80103605:	0f 84 25 01 00 00    	je     80103730 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010360b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010360e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103614:	6a 04                	push   $0x4
80103616:	68 3d 7a 10 80       	push   $0x80107a3d
8010361b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010361c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010361f:	e8 2c 14 00 00       	call   80104a50 <memcmp>
80103624:	83 c4 10             	add    $0x10,%esp
80103627:	85 c0                	test   %eax,%eax
80103629:	0f 85 01 01 00 00    	jne    80103730 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010362f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103636:	3c 01                	cmp    $0x1,%al
80103638:	74 08                	je     80103642 <mpinit+0x92>
8010363a:	3c 04                	cmp    $0x4,%al
8010363c:	0f 85 ee 00 00 00    	jne    80103730 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103642:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103649:	66 85 d2             	test   %dx,%dx
8010364c:	74 22                	je     80103670 <mpinit+0xc0>
8010364e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103651:	89 f0                	mov    %esi,%eax
  sum = 0;
80103653:	31 d2                	xor    %edx,%edx
80103655:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103658:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010365f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103662:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103664:	39 c7                	cmp    %eax,%edi
80103666:	75 f0                	jne    80103658 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103668:	84 d2                	test   %dl,%dl
8010366a:	0f 85 c0 00 00 00    	jne    80103730 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103670:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103676:	a3 a0 1b 11 80       	mov    %eax,0x80111ba0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010367b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103682:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103688:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010368d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103690:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103697:	90                   	nop
80103698:	39 d0                	cmp    %edx,%eax
8010369a:	73 15                	jae    801036b1 <mpinit+0x101>
    switch(*p){
8010369c:	0f b6 08             	movzbl (%eax),%ecx
8010369f:	80 f9 02             	cmp    $0x2,%cl
801036a2:	74 4c                	je     801036f0 <mpinit+0x140>
801036a4:	77 3a                	ja     801036e0 <mpinit+0x130>
801036a6:	84 c9                	test   %cl,%cl
801036a8:	74 56                	je     80103700 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801036aa:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036ad:	39 d0                	cmp    %edx,%eax
801036af:	72 eb                	jb     8010369c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801036b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801036b4:	85 f6                	test   %esi,%esi
801036b6:	0f 84 d9 00 00 00    	je     80103795 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801036bc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801036c0:	74 15                	je     801036d7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036c2:	b8 70 00 00 00       	mov    $0x70,%eax
801036c7:	ba 22 00 00 00       	mov    $0x22,%edx
801036cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036cd:	ba 23 00 00 00       	mov    $0x23,%edx
801036d2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801036d3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036d6:	ee                   	out    %al,(%dx)
  }
}
801036d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036da:	5b                   	pop    %ebx
801036db:	5e                   	pop    %esi
801036dc:	5f                   	pop    %edi
801036dd:	5d                   	pop    %ebp
801036de:	c3                   	ret    
801036df:	90                   	nop
    switch(*p){
801036e0:	83 e9 03             	sub    $0x3,%ecx
801036e3:	80 f9 01             	cmp    $0x1,%cl
801036e6:	76 c2                	jbe    801036aa <mpinit+0xfa>
801036e8:	31 f6                	xor    %esi,%esi
801036ea:	eb ac                	jmp    80103698 <mpinit+0xe8>
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801036f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036f7:	88 0d a0 1c 11 80    	mov    %cl,0x80111ca0
      continue;
801036fd:	eb 99                	jmp    80103698 <mpinit+0xe8>
801036ff:	90                   	nop
      if(ncpu < NCPU) {
80103700:	8b 0d a4 1c 11 80    	mov    0x80111ca4,%ecx
80103706:	83 f9 07             	cmp    $0x7,%ecx
80103709:	7f 19                	jg     80103724 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010370b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103711:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103715:	83 c1 01             	add    $0x1,%ecx
80103718:	89 0d a4 1c 11 80    	mov    %ecx,0x80111ca4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010371e:	88 9f c0 1c 11 80    	mov    %bl,-0x7feee340(%edi)
      p += sizeof(struct mpproc);
80103724:	83 c0 14             	add    $0x14,%eax
      continue;
80103727:	e9 6c ff ff ff       	jmp    80103698 <mpinit+0xe8>
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 42 7a 10 80       	push   $0x80107a42
80103738:	e8 43 cc ff ff       	call   80100380 <panic>
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103740:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103745:	eb 13                	jmp    8010375a <mpinit+0x1aa>
80103747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010374e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103750:	89 f3                	mov    %esi,%ebx
80103752:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103758:	74 d6                	je     80103730 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010375a:	83 ec 04             	sub    $0x4,%esp
8010375d:	8d 73 10             	lea    0x10(%ebx),%esi
80103760:	6a 04                	push   $0x4
80103762:	68 38 7a 10 80       	push   $0x80107a38
80103767:	53                   	push   %ebx
80103768:	e8 e3 12 00 00       	call   80104a50 <memcmp>
8010376d:	83 c4 10             	add    $0x10,%esp
80103770:	85 c0                	test   %eax,%eax
80103772:	75 dc                	jne    80103750 <mpinit+0x1a0>
80103774:	89 da                	mov    %ebx,%edx
80103776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103780:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103783:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103786:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103788:	39 d6                	cmp    %edx,%esi
8010378a:	75 f4                	jne    80103780 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010378c:	84 c0                	test   %al,%al
8010378e:	75 c0                	jne    80103750 <mpinit+0x1a0>
80103790:	e9 6b fe ff ff       	jmp    80103600 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103795:	83 ec 0c             	sub    $0xc,%esp
80103798:	68 5c 7a 10 80       	push   $0x80107a5c
8010379d:	e8 de cb ff ff       	call   80100380 <panic>
801037a2:	66 90                	xchg   %ax,%ax
801037a4:	66 90                	xchg   %ax,%ax
801037a6:	66 90                	xchg   %ax,%ax
801037a8:	66 90                	xchg   %ax,%ax
801037aa:	66 90                	xchg   %ax,%ax
801037ac:	66 90                	xchg   %ax,%ax
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <picinit>:
801037b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037b5:	ba 21 00 00 00       	mov    $0x21,%edx
801037ba:	ee                   	out    %al,(%dx)
801037bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801037c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801037c1:	c3                   	ret    
801037c2:	66 90                	xchg   %ax,%ax
801037c4:	66 90                	xchg   %ax,%ax
801037c6:	66 90                	xchg   %ax,%ax
801037c8:	66 90                	xchg   %ax,%ax
801037ca:	66 90                	xchg   %ax,%ax
801037cc:	66 90                	xchg   %ax,%ax
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 0c             	sub    $0xc,%esp
801037d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801037df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801037e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801037eb:	e8 e0 d9 ff ff       	call   801011d0 <filealloc>
801037f0:	89 03                	mov    %eax,(%ebx)
801037f2:	85 c0                	test   %eax,%eax
801037f4:	0f 84 a8 00 00 00    	je     801038a2 <pipealloc+0xd2>
801037fa:	e8 d1 d9 ff ff       	call   801011d0 <filealloc>
801037ff:	89 06                	mov    %eax,(%esi)
80103801:	85 c0                	test   %eax,%eax
80103803:	0f 84 87 00 00 00    	je     80103890 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103809:	e8 12 f2 ff ff       	call   80102a20 <kalloc>
8010380e:	89 c7                	mov    %eax,%edi
80103810:	85 c0                	test   %eax,%eax
80103812:	0f 84 b0 00 00 00    	je     801038c8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103818:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010381f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103822:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103825:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010382c:	00 00 00 
  p->nwrite = 0;
8010382f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103836:	00 00 00 
  p->nread = 0;
80103839:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103840:	00 00 00 
  initlock(&p->lock, "pipe");
80103843:	68 7b 7a 10 80       	push   $0x80107a7b
80103848:	50                   	push   %eax
80103849:	e8 22 0f 00 00       	call   80104770 <initlock>
  (*f0)->type = FD_PIPE;
8010384e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103850:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103853:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103859:	8b 03                	mov    (%ebx),%eax
8010385b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010385f:	8b 03                	mov    (%ebx),%eax
80103861:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103865:	8b 03                	mov    (%ebx),%eax
80103867:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010386a:	8b 06                	mov    (%esi),%eax
8010386c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103872:	8b 06                	mov    (%esi),%eax
80103874:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103878:	8b 06                	mov    (%esi),%eax
8010387a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010387e:	8b 06                	mov    (%esi),%eax
80103880:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103883:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103886:	31 c0                	xor    %eax,%eax
}
80103888:	5b                   	pop    %ebx
80103889:	5e                   	pop    %esi
8010388a:	5f                   	pop    %edi
8010388b:	5d                   	pop    %ebp
8010388c:	c3                   	ret    
8010388d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103890:	8b 03                	mov    (%ebx),%eax
80103892:	85 c0                	test   %eax,%eax
80103894:	74 1e                	je     801038b4 <pipealloc+0xe4>
    fileclose(*f0);
80103896:	83 ec 0c             	sub    $0xc,%esp
80103899:	50                   	push   %eax
8010389a:	e8 f1 d9 ff ff       	call   80101290 <fileclose>
8010389f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801038a2:	8b 06                	mov    (%esi),%eax
801038a4:	85 c0                	test   %eax,%eax
801038a6:	74 0c                	je     801038b4 <pipealloc+0xe4>
    fileclose(*f1);
801038a8:	83 ec 0c             	sub    $0xc,%esp
801038ab:	50                   	push   %eax
801038ac:	e8 df d9 ff ff       	call   80101290 <fileclose>
801038b1:	83 c4 10             	add    $0x10,%esp
}
801038b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801038b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038bc:	5b                   	pop    %ebx
801038bd:	5e                   	pop    %esi
801038be:	5f                   	pop    %edi
801038bf:	5d                   	pop    %ebp
801038c0:	c3                   	ret    
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801038c8:	8b 03                	mov    (%ebx),%eax
801038ca:	85 c0                	test   %eax,%eax
801038cc:	75 c8                	jne    80103896 <pipealloc+0xc6>
801038ce:	eb d2                	jmp    801038a2 <pipealloc+0xd2>

801038d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
801038d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801038db:	83 ec 0c             	sub    $0xc,%esp
801038de:	53                   	push   %ebx
801038df:	e8 5c 10 00 00       	call   80104940 <acquire>
  if(writable){
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	85 f6                	test   %esi,%esi
801038e9:	74 65                	je     80103950 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801038eb:	83 ec 0c             	sub    $0xc,%esp
801038ee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801038f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038fb:	00 00 00 
    wakeup(&p->nread);
801038fe:	50                   	push   %eax
801038ff:	e8 9c 0b 00 00       	call   801044a0 <wakeup>
80103904:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103907:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010390d:	85 d2                	test   %edx,%edx
8010390f:	75 0a                	jne    8010391b <pipeclose+0x4b>
80103911:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103917:	85 c0                	test   %eax,%eax
80103919:	74 15                	je     80103930 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010391b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010391e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5d                   	pop    %ebp
    release(&p->lock);
80103924:	e9 b7 0f 00 00       	jmp    801048e0 <release>
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	53                   	push   %ebx
80103934:	e8 a7 0f 00 00       	call   801048e0 <release>
    kfree((char*)p);
80103939:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010393c:	83 c4 10             	add    $0x10,%esp
}
8010393f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103942:	5b                   	pop    %ebx
80103943:	5e                   	pop    %esi
80103944:	5d                   	pop    %ebp
    kfree((char*)p);
80103945:	e9 16 ef ff ff       	jmp    80102860 <kfree>
8010394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103959:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103960:	00 00 00 
    wakeup(&p->nwrite);
80103963:	50                   	push   %eax
80103964:	e8 37 0b 00 00       	call   801044a0 <wakeup>
80103969:	83 c4 10             	add    $0x10,%esp
8010396c:	eb 99                	jmp    80103907 <pipeclose+0x37>
8010396e:	66 90                	xchg   %ax,%ax

80103970 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 28             	sub    $0x28,%esp
80103979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010397c:	53                   	push   %ebx
8010397d:	e8 be 0f 00 00       	call   80104940 <acquire>
  for(i = 0; i < n; i++){
80103982:	8b 45 10             	mov    0x10(%ebp),%eax
80103985:	83 c4 10             	add    $0x10,%esp
80103988:	85 c0                	test   %eax,%eax
8010398a:	0f 8e c0 00 00 00    	jle    80103a50 <pipewrite+0xe0>
80103990:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103993:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103999:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010399f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039a2:	03 45 10             	add    0x10(%ebp),%eax
801039a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039ae:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039b4:	89 ca                	mov    %ecx,%edx
801039b6:	05 00 02 00 00       	add    $0x200,%eax
801039bb:	39 c1                	cmp    %eax,%ecx
801039bd:	74 3f                	je     801039fe <pipewrite+0x8e>
801039bf:	eb 67                	jmp    80103a28 <pipewrite+0xb8>
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801039c8:	e8 43 03 00 00       	call   80103d10 <myproc>
801039cd:	8b 48 24             	mov    0x24(%eax),%ecx
801039d0:	85 c9                	test   %ecx,%ecx
801039d2:	75 34                	jne    80103a08 <pipewrite+0x98>
      wakeup(&p->nread);
801039d4:	83 ec 0c             	sub    $0xc,%esp
801039d7:	57                   	push   %edi
801039d8:	e8 c3 0a 00 00       	call   801044a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039dd:	58                   	pop    %eax
801039de:	5a                   	pop    %edx
801039df:	53                   	push   %ebx
801039e0:	56                   	push   %esi
801039e1:	e8 fa 09 00 00       	call   801043e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039e6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801039ec:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039f2:	83 c4 10             	add    $0x10,%esp
801039f5:	05 00 02 00 00       	add    $0x200,%eax
801039fa:	39 c2                	cmp    %eax,%edx
801039fc:	75 2a                	jne    80103a28 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801039fe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a04:	85 c0                	test   %eax,%eax
80103a06:	75 c0                	jne    801039c8 <pipewrite+0x58>
        release(&p->lock);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	53                   	push   %ebx
80103a0c:	e8 cf 0e 00 00       	call   801048e0 <release>
        return -1;
80103a11:	83 c4 10             	add    $0x10,%esp
80103a14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a1c:	5b                   	pop    %ebx
80103a1d:	5e                   	pop    %esi
80103a1e:	5f                   	pop    %edi
80103a1f:	5d                   	pop    %ebp
80103a20:	c3                   	ret    
80103a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a28:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103a2b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103a2e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103a34:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103a3a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103a3d:	83 c6 01             	add    $0x1,%esi
80103a40:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a43:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103a47:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103a4a:	0f 85 58 ff ff ff    	jne    801039a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a59:	50                   	push   %eax
80103a5a:	e8 41 0a 00 00       	call   801044a0 <wakeup>
  release(&p->lock);
80103a5f:	89 1c 24             	mov    %ebx,(%esp)
80103a62:	e8 79 0e 00 00       	call   801048e0 <release>
  return n;
80103a67:	8b 45 10             	mov    0x10(%ebp),%eax
80103a6a:	83 c4 10             	add    $0x10,%esp
80103a6d:	eb aa                	jmp    80103a19 <pipewrite+0xa9>
80103a6f:	90                   	nop

80103a70 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 18             	sub    $0x18,%esp
80103a79:	8b 75 08             	mov    0x8(%ebp),%esi
80103a7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a7f:	56                   	push   %esi
80103a80:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a86:	e8 b5 0e 00 00       	call   80104940 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a8b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a91:	83 c4 10             	add    $0x10,%esp
80103a94:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a9a:	74 2f                	je     80103acb <piperead+0x5b>
80103a9c:	eb 37                	jmp    80103ad5 <piperead+0x65>
80103a9e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103aa0:	e8 6b 02 00 00       	call   80103d10 <myproc>
80103aa5:	8b 48 24             	mov    0x24(%eax),%ecx
80103aa8:	85 c9                	test   %ecx,%ecx
80103aaa:	0f 85 80 00 00 00    	jne    80103b30 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ab0:	83 ec 08             	sub    $0x8,%esp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	e8 26 09 00 00       	call   801043e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103aba:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103ac9:	75 0a                	jne    80103ad5 <piperead+0x65>
80103acb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103ad1:	85 c0                	test   %eax,%eax
80103ad3:	75 cb                	jne    80103aa0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ad5:	8b 55 10             	mov    0x10(%ebp),%edx
80103ad8:	31 db                	xor    %ebx,%ebx
80103ada:	85 d2                	test   %edx,%edx
80103adc:	7f 20                	jg     80103afe <piperead+0x8e>
80103ade:	eb 2c                	jmp    80103b0c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103ae0:	8d 48 01             	lea    0x1(%eax),%ecx
80103ae3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103ae8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103aee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103af3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103af6:	83 c3 01             	add    $0x1,%ebx
80103af9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103afc:	74 0e                	je     80103b0c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103afe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b04:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103b0a:	75 d4                	jne    80103ae0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103b0c:	83 ec 0c             	sub    $0xc,%esp
80103b0f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103b15:	50                   	push   %eax
80103b16:	e8 85 09 00 00       	call   801044a0 <wakeup>
  release(&p->lock);
80103b1b:	89 34 24             	mov    %esi,(%esp)
80103b1e:	e8 bd 0d 00 00       	call   801048e0 <release>
  return i;
80103b23:	83 c4 10             	add    $0x10,%esp
}
80103b26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b29:	89 d8                	mov    %ebx,%eax
80103b2b:	5b                   	pop    %ebx
80103b2c:	5e                   	pop    %esi
80103b2d:	5f                   	pop    %edi
80103b2e:	5d                   	pop    %ebp
80103b2f:	c3                   	ret    
      release(&p->lock);
80103b30:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103b33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103b38:	56                   	push   %esi
80103b39:	e8 a2 0d 00 00       	call   801048e0 <release>
      return -1;
80103b3e:	83 c4 10             	add    $0x10,%esp
}
80103b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b44:	89 d8                	mov    %ebx,%eax
80103b46:	5b                   	pop    %ebx
80103b47:	5e                   	pop    %esi
80103b48:	5f                   	pop    %edi
80103b49:	5d                   	pop    %ebp
80103b4a:	c3                   	ret    
80103b4b:	66 90                	xchg   %ax,%ax
80103b4d:	66 90                	xchg   %ax,%ax
80103b4f:	90                   	nop

80103b50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b54:	bb 74 22 11 80       	mov    $0x80112274,%ebx
{
80103b59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b5c:	68 40 22 11 80       	push   $0x80112240
80103b61:	e8 da 0d 00 00       	call   80104940 <acquire>
80103b66:	83 c4 10             	add    $0x10,%esp
80103b69:	eb 10                	jmp    80103b7b <allocproc+0x2b>
80103b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b70:	83 c3 7c             	add    $0x7c,%ebx
80103b73:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
80103b79:	74 75                	je     80103bf0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b7b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b7e:	85 c0                	test   %eax,%eax
80103b80:	75 ee                	jne    80103b70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b82:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103b87:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b8a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b91:	89 43 10             	mov    %eax,0x10(%ebx)
80103b94:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b97:	68 40 22 11 80       	push   $0x80112240
  p->pid = nextpid++;
80103b9c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103ba2:	e8 39 0d 00 00       	call   801048e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ba7:	e8 74 ee ff ff       	call   80102a20 <kalloc>
80103bac:	83 c4 10             	add    $0x10,%esp
80103baf:	89 43 08             	mov    %eax,0x8(%ebx)
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	74 53                	je     80103c09 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103bb6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103bbc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103bbf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103bc4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103bc7:	c7 40 14 f2 5b 10 80 	movl   $0x80105bf2,0x14(%eax)
  p->context = (struct context*)sp;
80103bce:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bd1:	6a 14                	push   $0x14
80103bd3:	6a 00                	push   $0x0
80103bd5:	50                   	push   %eax
80103bd6:	e8 25 0e 00 00       	call   80104a00 <memset>
  p->context->eip = (uint)forkret;
80103bdb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103bde:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103be1:	c7 40 10 20 3c 10 80 	movl   $0x80103c20,0x10(%eax)
}
80103be8:	89 d8                	mov    %ebx,%eax
80103bea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bed:	c9                   	leave  
80103bee:	c3                   	ret    
80103bef:	90                   	nop
  release(&ptable.lock);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103bf3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103bf5:	68 40 22 11 80       	push   $0x80112240
80103bfa:	e8 e1 0c 00 00       	call   801048e0 <release>
}
80103bff:	89 d8                	mov    %ebx,%eax
  return 0;
80103c01:	83 c4 10             	add    $0x10,%esp
}
80103c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c07:	c9                   	leave  
80103c08:	c3                   	ret    
    p->state = UNUSED;
80103c09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c10:	31 db                	xor    %ebx,%ebx
}
80103c12:	89 d8                	mov    %ebx,%eax
80103c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c17:	c9                   	leave  
80103c18:	c3                   	ret    
80103c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c26:	68 40 22 11 80       	push   $0x80112240
80103c2b:	e8 b0 0c 00 00       	call   801048e0 <release>

  if (first) {
80103c30:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	85 c0                	test   %eax,%eax
80103c3a:	75 04                	jne    80103c40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c3c:	c9                   	leave  
80103c3d:	c3                   	ret    
80103c3e:	66 90                	xchg   %ax,%ax
    first = 0;
80103c40:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103c47:	00 00 00 
    iinit(ROOTDEV);
80103c4a:	83 ec 0c             	sub    $0xc,%esp
80103c4d:	6a 01                	push   $0x1
80103c4f:	e8 ac dc ff ff       	call   80101900 <iinit>
    initlog(ROOTDEV);
80103c54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c5b:	e8 00 f4 ff ff       	call   80103060 <initlog>
}
80103c60:	83 c4 10             	add    $0x10,%esp
80103c63:	c9                   	leave  
80103c64:	c3                   	ret    
80103c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c70 <pinit>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c76:	68 80 7a 10 80       	push   $0x80107a80
80103c7b:	68 40 22 11 80       	push   $0x80112240
80103c80:	e8 eb 0a 00 00       	call   80104770 <initlock>
}
80103c85:	83 c4 10             	add    $0x10,%esp
80103c88:	c9                   	leave  
80103c89:	c3                   	ret    
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c90 <mycpu>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c95:	9c                   	pushf  
80103c96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c97:	f6 c4 02             	test   $0x2,%ah
80103c9a:	75 46                	jne    80103ce2 <mycpu+0x52>
  apicid = lapicid();
80103c9c:	e8 ef ef ff ff       	call   80102c90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ca1:	8b 35 a4 1c 11 80    	mov    0x80111ca4,%esi
80103ca7:	85 f6                	test   %esi,%esi
80103ca9:	7e 2a                	jle    80103cd5 <mycpu+0x45>
80103cab:	31 d2                	xor    %edx,%edx
80103cad:	eb 08                	jmp    80103cb7 <mycpu+0x27>
80103caf:	90                   	nop
80103cb0:	83 c2 01             	add    $0x1,%edx
80103cb3:	39 f2                	cmp    %esi,%edx
80103cb5:	74 1e                	je     80103cd5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103cb7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103cbd:	0f b6 99 c0 1c 11 80 	movzbl -0x7feee340(%ecx),%ebx
80103cc4:	39 c3                	cmp    %eax,%ebx
80103cc6:	75 e8                	jne    80103cb0 <mycpu+0x20>
}
80103cc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103ccb:	8d 81 c0 1c 11 80    	lea    -0x7feee340(%ecx),%eax
}
80103cd1:	5b                   	pop    %ebx
80103cd2:	5e                   	pop    %esi
80103cd3:	5d                   	pop    %ebp
80103cd4:	c3                   	ret    
  panic("unknown apicid\n");
80103cd5:	83 ec 0c             	sub    $0xc,%esp
80103cd8:	68 87 7a 10 80       	push   $0x80107a87
80103cdd:	e8 9e c6 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ce2:	83 ec 0c             	sub    $0xc,%esp
80103ce5:	68 64 7b 10 80       	push   $0x80107b64
80103cea:	e8 91 c6 ff ff       	call   80100380 <panic>
80103cef:	90                   	nop

80103cf0 <cpuid>:
cpuid() {
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103cf6:	e8 95 ff ff ff       	call   80103c90 <mycpu>
}
80103cfb:	c9                   	leave  
  return mycpu()-cpus;
80103cfc:	2d c0 1c 11 80       	sub    $0x80111cc0,%eax
80103d01:	c1 f8 04             	sar    $0x4,%eax
80103d04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d0a:	c3                   	ret    
80103d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop

80103d10 <myproc>:
myproc(void) {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	53                   	push   %ebx
80103d14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d17:	e8 d4 0a 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80103d1c:	e8 6f ff ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103d21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d27:	e8 14 0b 00 00       	call   80104840 <popcli>
}
80103d2c:	89 d8                	mov    %ebx,%eax
80103d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d31:	c9                   	leave  
80103d32:	c3                   	ret    
80103d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d40 <userinit>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d47:	e8 04 fe ff ff       	call   80103b50 <allocproc>
80103d4c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d4e:	a3 74 41 11 80       	mov    %eax,0x80114174
  if((p->pgdir = setupkvm()) == 0)
80103d53:	e8 88 34 00 00       	call   801071e0 <setupkvm>
80103d58:	89 43 04             	mov    %eax,0x4(%ebx)
80103d5b:	85 c0                	test   %eax,%eax
80103d5d:	0f 84 bd 00 00 00    	je     80103e20 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d63:	83 ec 04             	sub    $0x4,%esp
80103d66:	68 2c 00 00 00       	push   $0x2c
80103d6b:	68 60 a4 10 80       	push   $0x8010a460
80103d70:	50                   	push   %eax
80103d71:	e8 1a 31 00 00       	call   80106e90 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d76:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d79:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d7f:	6a 4c                	push   $0x4c
80103d81:	6a 00                	push   $0x0
80103d83:	ff 73 18             	push   0x18(%ebx)
80103d86:	e8 75 0c 00 00       	call   80104a00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d8b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d8e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d93:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d96:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d9b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103da2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103da6:	8b 43 18             	mov    0x18(%ebx),%eax
80103da9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103db1:	8b 43 18             	mov    0x18(%ebx),%eax
80103db4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103db8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103dbc:	8b 43 18             	mov    0x18(%ebx),%eax
80103dbf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103dc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103dd0:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dda:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ddd:	6a 10                	push   $0x10
80103ddf:	68 b0 7a 10 80       	push   $0x80107ab0
80103de4:	50                   	push   %eax
80103de5:	e8 d6 0d 00 00       	call   80104bc0 <safestrcpy>
  p->cwd = namei("/");
80103dea:	c7 04 24 b9 7a 10 80 	movl   $0x80107ab9,(%esp)
80103df1:	e8 4a e6 ff ff       	call   80102440 <namei>
80103df6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103df9:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103e00:	e8 3b 0b 00 00       	call   80104940 <acquire>
  p->state = RUNNABLE;
80103e05:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e0c:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103e13:	e8 c8 0a 00 00       	call   801048e0 <release>
}
80103e18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e1b:	83 c4 10             	add    $0x10,%esp
80103e1e:	c9                   	leave  
80103e1f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	68 97 7a 10 80       	push   $0x80107a97
80103e28:	e8 53 c5 ff ff       	call   80100380 <panic>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi

80103e30 <growproc>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
80103e35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e38:	e8 b3 09 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80103e3d:	e8 4e fe ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103e42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e48:	e8 f3 09 00 00       	call   80104840 <popcli>
  sz = curproc->sz;
80103e4d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e4f:	85 f6                	test   %esi,%esi
80103e51:	7f 1d                	jg     80103e70 <growproc+0x40>
  } else if(n < 0){
80103e53:	75 3b                	jne    80103e90 <growproc+0x60>
  switchuvm(curproc);
80103e55:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e58:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e5a:	53                   	push   %ebx
80103e5b:	e8 20 2f 00 00       	call   80106d80 <switchuvm>
  return 0;
80103e60:	83 c4 10             	add    $0x10,%esp
80103e63:	31 c0                	xor    %eax,%eax
}
80103e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e68:	5b                   	pop    %ebx
80103e69:	5e                   	pop    %esi
80103e6a:	5d                   	pop    %ebp
80103e6b:	c3                   	ret    
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e70:	83 ec 04             	sub    $0x4,%esp
80103e73:	01 c6                	add    %eax,%esi
80103e75:	56                   	push   %esi
80103e76:	50                   	push   %eax
80103e77:	ff 73 04             	push   0x4(%ebx)
80103e7a:	e8 81 31 00 00       	call   80107000 <allocuvm>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	85 c0                	test   %eax,%eax
80103e84:	75 cf                	jne    80103e55 <growproc+0x25>
      return -1;
80103e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8b:	eb d8                	jmp    80103e65 <growproc+0x35>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e90:	83 ec 04             	sub    $0x4,%esp
80103e93:	01 c6                	add    %eax,%esi
80103e95:	56                   	push   %esi
80103e96:	50                   	push   %eax
80103e97:	ff 73 04             	push   0x4(%ebx)
80103e9a:	e8 91 32 00 00       	call   80107130 <deallocuvm>
80103e9f:	83 c4 10             	add    $0x10,%esp
80103ea2:	85 c0                	test   %eax,%eax
80103ea4:	75 af                	jne    80103e55 <growproc+0x25>
80103ea6:	eb de                	jmp    80103e86 <growproc+0x56>
80103ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <fork>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103eb9:	e8 32 09 00 00       	call   801047f0 <pushcli>
  c = mycpu();
80103ebe:	e8 cd fd ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103ec3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec9:	e8 72 09 00 00       	call   80104840 <popcli>
  if((np = allocproc()) == 0){
80103ece:	e8 7d fc ff ff       	call   80103b50 <allocproc>
80103ed3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ed6:	85 c0                	test   %eax,%eax
80103ed8:	0f 84 b7 00 00 00    	je     80103f95 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ede:	83 ec 08             	sub    $0x8,%esp
80103ee1:	ff 33                	push   (%ebx)
80103ee3:	89 c7                	mov    %eax,%edi
80103ee5:	ff 73 04             	push   0x4(%ebx)
80103ee8:	e8 e3 33 00 00       	call   801072d0 <copyuvm>
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	89 47 04             	mov    %eax,0x4(%edi)
80103ef3:	85 c0                	test   %eax,%eax
80103ef5:	0f 84 a1 00 00 00    	je     80103f9c <fork+0xec>
  np->sz = curproc->sz;
80103efb:	8b 03                	mov    (%ebx),%eax
80103efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f00:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103f02:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103f05:	89 c8                	mov    %ecx,%eax
80103f07:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103f0a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f0f:	8b 73 18             	mov    0x18(%ebx),%esi
80103f12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f14:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f16:	8b 40 18             	mov    0x18(%eax),%eax
80103f19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	74 13                	je     80103f3b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	50                   	push   %eax
80103f2c:	e8 0f d3 ff ff       	call   80101240 <filedup>
80103f31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f34:	83 c4 10             	add    $0x10,%esp
80103f37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f3b:	83 c6 01             	add    $0x1,%esi
80103f3e:	83 fe 10             	cmp    $0x10,%esi
80103f41:	75 dd                	jne    80103f20 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f49:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f4c:	e8 9f db ff ff       	call   80101af0 <idup>
80103f51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f57:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f5d:	6a 10                	push   $0x10
80103f5f:	53                   	push   %ebx
80103f60:	50                   	push   %eax
80103f61:	e8 5a 0c 00 00       	call   80104bc0 <safestrcpy>
  pid = np->pid;
80103f66:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f69:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103f70:	e8 cb 09 00 00       	call   80104940 <acquire>
  np->state = RUNNABLE;
80103f75:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f7c:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103f83:	e8 58 09 00 00       	call   801048e0 <release>
  return pid;
80103f88:	83 c4 10             	add    $0x10,%esp
}
80103f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8e:	89 d8                	mov    %ebx,%eax
80103f90:	5b                   	pop    %ebx
80103f91:	5e                   	pop    %esi
80103f92:	5f                   	pop    %edi
80103f93:	5d                   	pop    %ebp
80103f94:	c3                   	ret    
    return -1;
80103f95:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f9a:	eb ef                	jmp    80103f8b <fork+0xdb>
    kfree(np->kstack);
80103f9c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f9f:	83 ec 0c             	sub    $0xc,%esp
80103fa2:	ff 73 08             	push   0x8(%ebx)
80103fa5:	e8 b6 e8 ff ff       	call   80102860 <kfree>
    np->kstack = 0;
80103faa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103fb1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103fb4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fc0:	eb c9                	jmp    80103f8b <fork+0xdb>
80103fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fd0 <scheduler>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103fd9:	e8 b2 fc ff ff       	call   80103c90 <mycpu>
  c->proc = 0;
80103fde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fe5:	00 00 00 
  struct cpu *c = mycpu();
80103fe8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103fea:	8d 78 04             	lea    0x4(%eax),%edi
80103fed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ff0:	fb                   	sti    
    acquire(&ptable.lock);
80103ff1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff4:	bb 74 22 11 80       	mov    $0x80112274,%ebx
    acquire(&ptable.lock);
80103ff9:	68 40 22 11 80       	push   $0x80112240
80103ffe:	e8 3d 09 00 00       	call   80104940 <acquire>
80104003:	83 c4 10             	add    $0x10,%esp
80104006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104010:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104014:	75 33                	jne    80104049 <scheduler+0x79>
      switchuvm(p);
80104016:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104019:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010401f:	53                   	push   %ebx
80104020:	e8 5b 2d 00 00       	call   80106d80 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104025:	58                   	pop    %eax
80104026:	5a                   	pop    %edx
80104027:	ff 73 1c             	push   0x1c(%ebx)
8010402a:	57                   	push   %edi
      p->state = RUNNING;
8010402b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104032:	e8 e4 0b 00 00       	call   80104c1b <swtch>
      switchkvm();
80104037:	e8 34 2d 00 00       	call   80106d70 <switchkvm>
      c->proc = 0;
8010403c:	83 c4 10             	add    $0x10,%esp
8010403f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104046:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104049:	83 c3 7c             	add    $0x7c,%ebx
8010404c:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
80104052:	75 bc                	jne    80104010 <scheduler+0x40>
    release(&ptable.lock);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	68 40 22 11 80       	push   $0x80112240
8010405c:	e8 7f 08 00 00       	call   801048e0 <release>
    sti();
80104061:	83 c4 10             	add    $0x10,%esp
80104064:	eb 8a                	jmp    80103ff0 <scheduler+0x20>
80104066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406d:	8d 76 00             	lea    0x0(%esi),%esi

80104070 <sched>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	56                   	push   %esi
80104074:	53                   	push   %ebx
  pushcli();
80104075:	e8 76 07 00 00       	call   801047f0 <pushcli>
  c = mycpu();
8010407a:	e8 11 fc ff ff       	call   80103c90 <mycpu>
  p = c->proc;
8010407f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104085:	e8 b6 07 00 00       	call   80104840 <popcli>
  if(!holding(&ptable.lock))
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	68 40 22 11 80       	push   $0x80112240
80104092:	e8 09 08 00 00       	call   801048a0 <holding>
80104097:	83 c4 10             	add    $0x10,%esp
8010409a:	85 c0                	test   %eax,%eax
8010409c:	74 4f                	je     801040ed <sched+0x7d>
  if(mycpu()->ncli != 1)
8010409e:	e8 ed fb ff ff       	call   80103c90 <mycpu>
801040a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040aa:	75 68                	jne    80104114 <sched+0xa4>
  if(p->state == RUNNING)
801040ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040b0:	74 55                	je     80104107 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040b2:	9c                   	pushf  
801040b3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040b4:	f6 c4 02             	test   $0x2,%ah
801040b7:	75 41                	jne    801040fa <sched+0x8a>
  intena = mycpu()->intena;
801040b9:	e8 d2 fb ff ff       	call   80103c90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801040be:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801040c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801040c7:	e8 c4 fb ff ff       	call   80103c90 <mycpu>
801040cc:	83 ec 08             	sub    $0x8,%esp
801040cf:	ff 70 04             	push   0x4(%eax)
801040d2:	53                   	push   %ebx
801040d3:	e8 43 0b 00 00       	call   80104c1b <swtch>
  mycpu()->intena = intena;
801040d8:	e8 b3 fb ff ff       	call   80103c90 <mycpu>
}
801040dd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040e9:	5b                   	pop    %ebx
801040ea:	5e                   	pop    %esi
801040eb:	5d                   	pop    %ebp
801040ec:	c3                   	ret    
    panic("sched ptable.lock");
801040ed:	83 ec 0c             	sub    $0xc,%esp
801040f0:	68 bb 7a 10 80       	push   $0x80107abb
801040f5:	e8 86 c2 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 e7 7a 10 80       	push   $0x80107ae7
80104102:	e8 79 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
80104107:	83 ec 0c             	sub    $0xc,%esp
8010410a:	68 d9 7a 10 80       	push   $0x80107ad9
8010410f:	e8 6c c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	68 cd 7a 10 80       	push   $0x80107acd
8010411c:	e8 5f c2 ff ff       	call   80100380 <panic>
80104121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412f:	90                   	nop

80104130 <exit>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104139:	e8 d2 fb ff ff       	call   80103d10 <myproc>
  if(curproc == initproc)
8010413e:	39 05 74 41 11 80    	cmp    %eax,0x80114174
80104144:	0f 84 fd 00 00 00    	je     80104247 <exit+0x117>
8010414a:	89 c3                	mov    %eax,%ebx
8010414c:	8d 70 28             	lea    0x28(%eax),%esi
8010414f:	8d 78 68             	lea    0x68(%eax),%edi
80104152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104158:	8b 06                	mov    (%esi),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	74 12                	je     80104170 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	50                   	push   %eax
80104162:	e8 29 d1 ff ff       	call   80101290 <fileclose>
      curproc->ofile[fd] = 0;
80104167:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010416d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104170:	83 c6 04             	add    $0x4,%esi
80104173:	39 f7                	cmp    %esi,%edi
80104175:	75 e1                	jne    80104158 <exit+0x28>
  begin_op();
80104177:	e8 84 ef ff ff       	call   80103100 <begin_op>
  iput(curproc->cwd);
8010417c:	83 ec 0c             	sub    $0xc,%esp
8010417f:	ff 73 68             	push   0x68(%ebx)
80104182:	e8 c9 da ff ff       	call   80101c50 <iput>
  end_op();
80104187:	e8 e4 ef ff ff       	call   80103170 <end_op>
  curproc->cwd = 0;
8010418c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104193:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
8010419a:	e8 a1 07 00 00       	call   80104940 <acquire>
  wakeup1(curproc->parent);
8010419f:	8b 53 14             	mov    0x14(%ebx),%edx
801041a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041a5:	b8 74 22 11 80       	mov    $0x80112274,%eax
801041aa:	eb 0e                	jmp    801041ba <exit+0x8a>
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b0:	83 c0 7c             	add    $0x7c,%eax
801041b3:	3d 74 41 11 80       	cmp    $0x80114174,%eax
801041b8:	74 1c                	je     801041d6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801041ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041be:	75 f0                	jne    801041b0 <exit+0x80>
801041c0:	3b 50 20             	cmp    0x20(%eax),%edx
801041c3:	75 eb                	jne    801041b0 <exit+0x80>
      p->state = RUNNABLE;
801041c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041cc:	83 c0 7c             	add    $0x7c,%eax
801041cf:	3d 74 41 11 80       	cmp    $0x80114174,%eax
801041d4:	75 e4                	jne    801041ba <exit+0x8a>
      p->parent = initproc;
801041d6:	8b 0d 74 41 11 80    	mov    0x80114174,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	ba 74 22 11 80       	mov    $0x80112274,%edx
801041e1:	eb 10                	jmp    801041f3 <exit+0xc3>
801041e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e7:	90                   	nop
801041e8:	83 c2 7c             	add    $0x7c,%edx
801041eb:	81 fa 74 41 11 80    	cmp    $0x80114174,%edx
801041f1:	74 3b                	je     8010422e <exit+0xfe>
    if(p->parent == curproc){
801041f3:	39 5a 14             	cmp    %ebx,0x14(%edx)
801041f6:	75 f0                	jne    801041e8 <exit+0xb8>
      if(p->state == ZOMBIE)
801041f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041ff:	75 e7                	jne    801041e8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104201:	b8 74 22 11 80       	mov    $0x80112274,%eax
80104206:	eb 12                	jmp    8010421a <exit+0xea>
80104208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420f:	90                   	nop
80104210:	83 c0 7c             	add    $0x7c,%eax
80104213:	3d 74 41 11 80       	cmp    $0x80114174,%eax
80104218:	74 ce                	je     801041e8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010421a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010421e:	75 f0                	jne    80104210 <exit+0xe0>
80104220:	3b 48 20             	cmp    0x20(%eax),%ecx
80104223:	75 eb                	jne    80104210 <exit+0xe0>
      p->state = RUNNABLE;
80104225:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010422c:	eb e2                	jmp    80104210 <exit+0xe0>
  curproc->state = ZOMBIE;
8010422e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104235:	e8 36 fe ff ff       	call   80104070 <sched>
  panic("zombie exit");
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 08 7b 10 80       	push   $0x80107b08
80104242:	e8 39 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	68 fb 7a 10 80       	push   $0x80107afb
8010424f:	e8 2c c1 ff ff       	call   80100380 <panic>
80104254:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010425f:	90                   	nop

80104260 <wait>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
  pushcli();
80104265:	e8 86 05 00 00       	call   801047f0 <pushcli>
  c = mycpu();
8010426a:	e8 21 fa ff ff       	call   80103c90 <mycpu>
  p = c->proc;
8010426f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104275:	e8 c6 05 00 00       	call   80104840 <popcli>
  acquire(&ptable.lock);
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 40 22 11 80       	push   $0x80112240
80104282:	e8 b9 06 00 00       	call   80104940 <acquire>
80104287:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010428a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428c:	bb 74 22 11 80       	mov    $0x80112274,%ebx
80104291:	eb 10                	jmp    801042a3 <wait+0x43>
80104293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104297:	90                   	nop
80104298:	83 c3 7c             	add    $0x7c,%ebx
8010429b:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
801042a1:	74 1b                	je     801042be <wait+0x5e>
      if(p->parent != curproc)
801042a3:	39 73 14             	cmp    %esi,0x14(%ebx)
801042a6:	75 f0                	jne    80104298 <wait+0x38>
      if(p->state == ZOMBIE){
801042a8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042ac:	74 62                	je     80104310 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ae:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801042b1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b6:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
801042bc:	75 e5                	jne    801042a3 <wait+0x43>
    if(!havekids || curproc->killed){
801042be:	85 c0                	test   %eax,%eax
801042c0:	0f 84 a0 00 00 00    	je     80104366 <wait+0x106>
801042c6:	8b 46 24             	mov    0x24(%esi),%eax
801042c9:	85 c0                	test   %eax,%eax
801042cb:	0f 85 95 00 00 00    	jne    80104366 <wait+0x106>
  pushcli();
801042d1:	e8 1a 05 00 00       	call   801047f0 <pushcli>
  c = mycpu();
801042d6:	e8 b5 f9 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801042db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e1:	e8 5a 05 00 00       	call   80104840 <popcli>
  if(p == 0)
801042e6:	85 db                	test   %ebx,%ebx
801042e8:	0f 84 8f 00 00 00    	je     8010437d <wait+0x11d>
  p->chan = chan;
801042ee:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801042f1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042f8:	e8 73 fd ff ff       	call   80104070 <sched>
  p->chan = 0;
801042fd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104304:	eb 84                	jmp    8010428a <wait+0x2a>
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104310:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104313:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104316:	ff 73 08             	push   0x8(%ebx)
80104319:	e8 42 e5 ff ff       	call   80102860 <kfree>
        p->kstack = 0;
8010431e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104325:	5a                   	pop    %edx
80104326:	ff 73 04             	push   0x4(%ebx)
80104329:	e8 32 2e 00 00       	call   80107160 <freevm>
        p->pid = 0;
8010432e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104335:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010433c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104340:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104347:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010434e:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80104355:	e8 86 05 00 00       	call   801048e0 <release>
        return pid;
8010435a:	83 c4 10             	add    $0x10,%esp
}
8010435d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104360:	89 f0                	mov    %esi,%eax
80104362:	5b                   	pop    %ebx
80104363:	5e                   	pop    %esi
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    
      release(&ptable.lock);
80104366:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104369:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010436e:	68 40 22 11 80       	push   $0x80112240
80104373:	e8 68 05 00 00       	call   801048e0 <release>
      return -1;
80104378:	83 c4 10             	add    $0x10,%esp
8010437b:	eb e0                	jmp    8010435d <wait+0xfd>
    panic("sleep");
8010437d:	83 ec 0c             	sub    $0xc,%esp
80104380:	68 14 7b 10 80       	push   $0x80107b14
80104385:	e8 f6 bf ff ff       	call   80100380 <panic>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <yield>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104397:	68 40 22 11 80       	push   $0x80112240
8010439c:	e8 9f 05 00 00       	call   80104940 <acquire>
  pushcli();
801043a1:	e8 4a 04 00 00       	call   801047f0 <pushcli>
  c = mycpu();
801043a6:	e8 e5 f8 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801043ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043b1:	e8 8a 04 00 00       	call   80104840 <popcli>
  myproc()->state = RUNNABLE;
801043b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801043bd:	e8 ae fc ff ff       	call   80104070 <sched>
  release(&ptable.lock);
801043c2:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801043c9:	e8 12 05 00 00       	call   801048e0 <release>
}
801043ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d1:	83 c4 10             	add    $0x10,%esp
801043d4:	c9                   	leave  
801043d5:	c3                   	ret    
801043d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043dd:	8d 76 00             	lea    0x0(%esi),%esi

801043e0 <sleep>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	83 ec 0c             	sub    $0xc,%esp
801043e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043ef:	e8 fc 03 00 00       	call   801047f0 <pushcli>
  c = mycpu();
801043f4:	e8 97 f8 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801043f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ff:	e8 3c 04 00 00       	call   80104840 <popcli>
  if(p == 0)
80104404:	85 db                	test   %ebx,%ebx
80104406:	0f 84 87 00 00 00    	je     80104493 <sleep+0xb3>
  if(lk == 0)
8010440c:	85 f6                	test   %esi,%esi
8010440e:	74 76                	je     80104486 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104410:	81 fe 40 22 11 80    	cmp    $0x80112240,%esi
80104416:	74 50                	je     80104468 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 40 22 11 80       	push   $0x80112240
80104420:	e8 1b 05 00 00       	call   80104940 <acquire>
    release(lk);
80104425:	89 34 24             	mov    %esi,(%esp)
80104428:	e8 b3 04 00 00       	call   801048e0 <release>
  p->chan = chan;
8010442d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104430:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104437:	e8 34 fc ff ff       	call   80104070 <sched>
  p->chan = 0;
8010443c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104443:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
8010444a:	e8 91 04 00 00       	call   801048e0 <release>
    acquire(lk);
8010444f:	89 75 08             	mov    %esi,0x8(%ebp)
80104452:	83 c4 10             	add    $0x10,%esp
}
80104455:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104458:	5b                   	pop    %ebx
80104459:	5e                   	pop    %esi
8010445a:	5f                   	pop    %edi
8010445b:	5d                   	pop    %ebp
    acquire(lk);
8010445c:	e9 df 04 00 00       	jmp    80104940 <acquire>
80104461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104468:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010446b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104472:	e8 f9 fb ff ff       	call   80104070 <sched>
  p->chan = 0;
80104477:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010447e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104481:	5b                   	pop    %ebx
80104482:	5e                   	pop    %esi
80104483:	5f                   	pop    %edi
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret    
    panic("sleep without lk");
80104486:	83 ec 0c             	sub    $0xc,%esp
80104489:	68 1a 7b 10 80       	push   $0x80107b1a
8010448e:	e8 ed be ff ff       	call   80100380 <panic>
    panic("sleep");
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	68 14 7b 10 80       	push   $0x80107b14
8010449b:	e8 e0 be ff ff       	call   80100380 <panic>

801044a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 10             	sub    $0x10,%esp
801044a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044aa:	68 40 22 11 80       	push   $0x80112240
801044af:	e8 8c 04 00 00       	call   80104940 <acquire>
801044b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b7:	b8 74 22 11 80       	mov    $0x80112274,%eax
801044bc:	eb 0c                	jmp    801044ca <wakeup+0x2a>
801044be:	66 90                	xchg   %ax,%ax
801044c0:	83 c0 7c             	add    $0x7c,%eax
801044c3:	3d 74 41 11 80       	cmp    $0x80114174,%eax
801044c8:	74 1c                	je     801044e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801044ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044ce:	75 f0                	jne    801044c0 <wakeup+0x20>
801044d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801044d3:	75 eb                	jne    801044c0 <wakeup+0x20>
      p->state = RUNNABLE;
801044d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044dc:	83 c0 7c             	add    $0x7c,%eax
801044df:	3d 74 41 11 80       	cmp    $0x80114174,%eax
801044e4:	75 e4                	jne    801044ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801044e6:	c7 45 08 40 22 11 80 	movl   $0x80112240,0x8(%ebp)
}
801044ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f0:	c9                   	leave  
  release(&ptable.lock);
801044f1:	e9 ea 03 00 00       	jmp    801048e0 <release>
801044f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fd:	8d 76 00             	lea    0x0(%esi),%esi

80104500 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 10             	sub    $0x10,%esp
80104507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010450a:	68 40 22 11 80       	push   $0x80112240
8010450f:	e8 2c 04 00 00       	call   80104940 <acquire>
80104514:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104517:	b8 74 22 11 80       	mov    $0x80112274,%eax
8010451c:	eb 0c                	jmp    8010452a <kill+0x2a>
8010451e:	66 90                	xchg   %ax,%ax
80104520:	83 c0 7c             	add    $0x7c,%eax
80104523:	3d 74 41 11 80       	cmp    $0x80114174,%eax
80104528:	74 36                	je     80104560 <kill+0x60>
    if(p->pid == pid){
8010452a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010452d:	75 f1                	jne    80104520 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010452f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104533:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010453a:	75 07                	jne    80104543 <kill+0x43>
        p->state = RUNNABLE;
8010453c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	68 40 22 11 80       	push   $0x80112240
8010454b:	e8 90 03 00 00       	call   801048e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104553:	83 c4 10             	add    $0x10,%esp
80104556:	31 c0                	xor    %eax,%eax
}
80104558:	c9                   	leave  
80104559:	c3                   	ret    
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	68 40 22 11 80       	push   $0x80112240
80104568:	e8 73 03 00 00       	call   801048e0 <release>
}
8010456d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104570:	83 c4 10             	add    $0x10,%esp
80104573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104578:	c9                   	leave  
80104579:	c3                   	ret    
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	56                   	push   %esi
80104585:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104588:	53                   	push   %ebx
80104589:	bb e0 22 11 80       	mov    $0x801122e0,%ebx
8010458e:	83 ec 3c             	sub    $0x3c,%esp
80104591:	eb 24                	jmp    801045b7 <procdump+0x37>
80104593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104597:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	68 97 7e 10 80       	push   $0x80107e97
801045a0:	e8 6b c2 ff ff       	call   80100810 <cprintf>
801045a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a8:	83 c3 7c             	add    $0x7c,%ebx
801045ab:	81 fb e0 41 11 80    	cmp    $0x801141e0,%ebx
801045b1:	0f 84 81 00 00 00    	je     80104638 <procdump+0xb8>
    if(p->state == UNUSED)
801045b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045ba:	85 c0                	test   %eax,%eax
801045bc:	74 ea                	je     801045a8 <procdump+0x28>
      state = "???";
801045be:	ba 2b 7b 10 80       	mov    $0x80107b2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045c3:	83 f8 05             	cmp    $0x5,%eax
801045c6:	77 11                	ja     801045d9 <procdump+0x59>
801045c8:	8b 14 85 8c 7b 10 80 	mov    -0x7fef8474(,%eax,4),%edx
      state = "???";
801045cf:	b8 2b 7b 10 80       	mov    $0x80107b2b,%eax
801045d4:	85 d2                	test   %edx,%edx
801045d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801045d9:	53                   	push   %ebx
801045da:	52                   	push   %edx
801045db:	ff 73 a4             	push   -0x5c(%ebx)
801045de:	68 2f 7b 10 80       	push   $0x80107b2f
801045e3:	e8 28 c2 ff ff       	call   80100810 <cprintf>
    if(p->state == SLEEPING){
801045e8:	83 c4 10             	add    $0x10,%esp
801045eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045ef:	75 a7                	jne    80104598 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045f1:	83 ec 08             	sub    $0x8,%esp
801045f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045fa:	50                   	push   %eax
801045fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104601:	83 c0 08             	add    $0x8,%eax
80104604:	50                   	push   %eax
80104605:	e8 86 01 00 00       	call   80104790 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010460a:	83 c4 10             	add    $0x10,%esp
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
80104610:	8b 17                	mov    (%edi),%edx
80104612:	85 d2                	test   %edx,%edx
80104614:	74 82                	je     80104598 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104616:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104619:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010461c:	52                   	push   %edx
8010461d:	68 81 75 10 80       	push   $0x80107581
80104622:	e8 e9 c1 ff ff       	call   80100810 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104627:	83 c4 10             	add    $0x10,%esp
8010462a:	39 fe                	cmp    %edi,%esi
8010462c:	75 e2                	jne    80104610 <procdump+0x90>
8010462e:	e9 65 ff ff ff       	jmp    80104598 <procdump+0x18>
80104633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104637:	90                   	nop
  }
}
80104638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010463b:	5b                   	pop    %ebx
8010463c:	5e                   	pop    %esi
8010463d:	5f                   	pop    %edi
8010463e:	5d                   	pop    %ebp
8010463f:	c3                   	ret    

80104640 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 0c             	sub    $0xc,%esp
80104647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010464a:	68 a4 7b 10 80       	push   $0x80107ba4
8010464f:	8d 43 04             	lea    0x4(%ebx),%eax
80104652:	50                   	push   %eax
80104653:	e8 18 01 00 00       	call   80104770 <initlock>
  lk->name = name;
80104658:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010465b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104661:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104664:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010466b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010466e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104671:	c9                   	leave  
80104672:	c3                   	ret    
80104673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104688:	8d 73 04             	lea    0x4(%ebx),%esi
8010468b:	83 ec 0c             	sub    $0xc,%esp
8010468e:	56                   	push   %esi
8010468f:	e8 ac 02 00 00       	call   80104940 <acquire>
  while (lk->locked) {
80104694:	8b 13                	mov    (%ebx),%edx
80104696:	83 c4 10             	add    $0x10,%esp
80104699:	85 d2                	test   %edx,%edx
8010469b:	74 16                	je     801046b3 <acquiresleep+0x33>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046a0:	83 ec 08             	sub    $0x8,%esp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	e8 36 fd ff ff       	call   801043e0 <sleep>
  while (lk->locked) {
801046aa:	8b 03                	mov    (%ebx),%eax
801046ac:	83 c4 10             	add    $0x10,%esp
801046af:	85 c0                	test   %eax,%eax
801046b1:	75 ed                	jne    801046a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801046b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046b9:	e8 52 f6 ff ff       	call   80103d10 <myproc>
801046be:	8b 40 10             	mov    0x10(%eax),%eax
801046c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046ca:	5b                   	pop    %ebx
801046cb:	5e                   	pop    %esi
801046cc:	5d                   	pop    %ebp
  release(&lk->lk);
801046cd:	e9 0e 02 00 00       	jmp    801048e0 <release>
801046d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046e8:	8d 73 04             	lea    0x4(%ebx),%esi
801046eb:	83 ec 0c             	sub    $0xc,%esp
801046ee:	56                   	push   %esi
801046ef:	e8 4c 02 00 00       	call   80104940 <acquire>
  lk->locked = 0;
801046f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104701:	89 1c 24             	mov    %ebx,(%esp)
80104704:	e8 97 fd ff ff       	call   801044a0 <wakeup>
  release(&lk->lk);
80104709:	89 75 08             	mov    %esi,0x8(%ebp)
8010470c:	83 c4 10             	add    $0x10,%esp
}
8010470f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104712:	5b                   	pop    %ebx
80104713:	5e                   	pop    %esi
80104714:	5d                   	pop    %ebp
  release(&lk->lk);
80104715:	e9 c6 01 00 00       	jmp    801048e0 <release>
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	31 ff                	xor    %edi,%edi
80104726:	56                   	push   %esi
80104727:	53                   	push   %ebx
80104728:	83 ec 18             	sub    $0x18,%esp
8010472b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010472e:	8d 73 04             	lea    0x4(%ebx),%esi
80104731:	56                   	push   %esi
80104732:	e8 09 02 00 00       	call   80104940 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104737:	8b 03                	mov    (%ebx),%eax
80104739:	83 c4 10             	add    $0x10,%esp
8010473c:	85 c0                	test   %eax,%eax
8010473e:	75 18                	jne    80104758 <holdingsleep+0x38>
  release(&lk->lk);
80104740:	83 ec 0c             	sub    $0xc,%esp
80104743:	56                   	push   %esi
80104744:	e8 97 01 00 00       	call   801048e0 <release>
  return r;
}
80104749:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474c:	89 f8                	mov    %edi,%eax
8010474e:	5b                   	pop    %ebx
8010474f:	5e                   	pop    %esi
80104750:	5f                   	pop    %edi
80104751:	5d                   	pop    %ebp
80104752:	c3                   	ret    
80104753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104757:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104758:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010475b:	e8 b0 f5 ff ff       	call   80103d10 <myproc>
80104760:	39 58 10             	cmp    %ebx,0x10(%eax)
80104763:	0f 94 c0             	sete   %al
80104766:	0f b6 c0             	movzbl %al,%eax
80104769:	89 c7                	mov    %eax,%edi
8010476b:	eb d3                	jmp    80104740 <holdingsleep+0x20>
8010476d:	66 90                	xchg   %ax,%ax
8010476f:	90                   	nop

80104770 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104776:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010477f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104782:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104790:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104791:	31 d2                	xor    %edx,%edx
{
80104793:	89 e5                	mov    %esp,%ebp
80104795:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104796:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104799:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010479c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010479f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047ac:	77 1a                	ja     801047c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047ae:	8b 58 04             	mov    0x4(%eax),%ebx
801047b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047b9:	83 fa 0a             	cmp    $0xa,%edx
801047bc:	75 e2                	jne    801047a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c1:	c9                   	leave  
801047c2:	c3                   	ret    
801047c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c7:	90                   	nop
  for(; i < 10; i++)
801047c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047cb:	8d 51 28             	lea    0x28(%ecx),%edx
801047ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047d6:	83 c0 04             	add    $0x4,%eax
801047d9:	39 d0                	cmp    %edx,%eax
801047db:	75 f3                	jne    801047d0 <getcallerpcs+0x40>
}
801047dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e0:	c9                   	leave  
801047e1:	c3                   	ret    
801047e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
801047f7:	9c                   	pushf  
801047f8:	5b                   	pop    %ebx
  asm volatile("cli");
801047f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047fa:	e8 91 f4 ff ff       	call   80103c90 <mycpu>
801047ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104805:	85 c0                	test   %eax,%eax
80104807:	74 17                	je     80104820 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104809:	e8 82 f4 ff ff       	call   80103c90 <mycpu>
8010480e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104818:	c9                   	leave  
80104819:	c3                   	ret    
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104820:	e8 6b f4 ff ff       	call   80103c90 <mycpu>
80104825:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010482b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104831:	eb d6                	jmp    80104809 <pushcli+0x19>
80104833:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104840 <popcli>:

void
popcli(void)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104846:	9c                   	pushf  
80104847:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104848:	f6 c4 02             	test   $0x2,%ah
8010484b:	75 35                	jne    80104882 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010484d:	e8 3e f4 ff ff       	call   80103c90 <mycpu>
80104852:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104859:	78 34                	js     8010488f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010485b:	e8 30 f4 ff ff       	call   80103c90 <mycpu>
80104860:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104866:	85 d2                	test   %edx,%edx
80104868:	74 06                	je     80104870 <popcli+0x30>
    sti();
}
8010486a:	c9                   	leave  
8010486b:	c3                   	ret    
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104870:	e8 1b f4 ff ff       	call   80103c90 <mycpu>
80104875:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010487b:	85 c0                	test   %eax,%eax
8010487d:	74 eb                	je     8010486a <popcli+0x2a>
  asm volatile("sti");
8010487f:	fb                   	sti    
}
80104880:	c9                   	leave  
80104881:	c3                   	ret    
    panic("popcli - interruptible");
80104882:	83 ec 0c             	sub    $0xc,%esp
80104885:	68 af 7b 10 80       	push   $0x80107baf
8010488a:	e8 f1 ba ff ff       	call   80100380 <panic>
    panic("popcli");
8010488f:	83 ec 0c             	sub    $0xc,%esp
80104892:	68 c6 7b 10 80       	push   $0x80107bc6
80104897:	e8 e4 ba ff ff       	call   80100380 <panic>
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <holding>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 75 08             	mov    0x8(%ebp),%esi
801048a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048aa:	e8 41 ff ff ff       	call   801047f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048af:	8b 06                	mov    (%esi),%eax
801048b1:	85 c0                	test   %eax,%eax
801048b3:	75 0b                	jne    801048c0 <holding+0x20>
  popcli();
801048b5:	e8 86 ff ff ff       	call   80104840 <popcli>
}
801048ba:	89 d8                	mov    %ebx,%eax
801048bc:	5b                   	pop    %ebx
801048bd:	5e                   	pop    %esi
801048be:	5d                   	pop    %ebp
801048bf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801048c0:	8b 5e 08             	mov    0x8(%esi),%ebx
801048c3:	e8 c8 f3 ff ff       	call   80103c90 <mycpu>
801048c8:	39 c3                	cmp    %eax,%ebx
801048ca:	0f 94 c3             	sete   %bl
  popcli();
801048cd:	e8 6e ff ff ff       	call   80104840 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801048d2:	0f b6 db             	movzbl %bl,%ebx
}
801048d5:	89 d8                	mov    %ebx,%eax
801048d7:	5b                   	pop    %ebx
801048d8:	5e                   	pop    %esi
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop

801048e0 <release>:
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048e8:	e8 03 ff ff ff       	call   801047f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048ed:	8b 03                	mov    (%ebx),%eax
801048ef:	85 c0                	test   %eax,%eax
801048f1:	75 15                	jne    80104908 <release+0x28>
  popcli();
801048f3:	e8 48 ff ff ff       	call   80104840 <popcli>
    panic("release");
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	68 cd 7b 10 80       	push   $0x80107bcd
80104900:	e8 7b ba ff ff       	call   80100380 <panic>
80104905:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104908:	8b 73 08             	mov    0x8(%ebx),%esi
8010490b:	e8 80 f3 ff ff       	call   80103c90 <mycpu>
80104910:	39 c6                	cmp    %eax,%esi
80104912:	75 df                	jne    801048f3 <release+0x13>
  popcli();
80104914:	e8 27 ff ff ff       	call   80104840 <popcli>
  lk->pcs[0] = 0;
80104919:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104920:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104927:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010492c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104932:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104935:	5b                   	pop    %ebx
80104936:	5e                   	pop    %esi
80104937:	5d                   	pop    %ebp
  popcli();
80104938:	e9 03 ff ff ff       	jmp    80104840 <popcli>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <acquire>:
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104947:	e8 a4 fe ff ff       	call   801047f0 <pushcli>
  if(holding(lk))
8010494c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010494f:	e8 9c fe ff ff       	call   801047f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104954:	8b 03                	mov    (%ebx),%eax
80104956:	85 c0                	test   %eax,%eax
80104958:	75 7e                	jne    801049d8 <acquire+0x98>
  popcli();
8010495a:	e8 e1 fe ff ff       	call   80104840 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010495f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104968:	8b 55 08             	mov    0x8(%ebp),%edx
8010496b:	89 c8                	mov    %ecx,%eax
8010496d:	f0 87 02             	lock xchg %eax,(%edx)
80104970:	85 c0                	test   %eax,%eax
80104972:	75 f4                	jne    80104968 <acquire+0x28>
  __sync_synchronize();
80104974:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104979:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010497c:	e8 0f f3 ff ff       	call   80103c90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104981:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104984:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104986:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104989:	31 c0                	xor    %eax,%eax
8010498b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104990:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104996:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010499c:	77 1a                	ja     801049b8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010499e:	8b 5a 04             	mov    0x4(%edx),%ebx
801049a1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801049a5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801049a8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801049aa:	83 f8 0a             	cmp    $0xa,%eax
801049ad:	75 e1                	jne    80104990 <acquire+0x50>
}
801049af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801049b8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801049bc:	8d 51 34             	lea    0x34(%ecx),%edx
801049bf:	90                   	nop
    pcs[i] = 0;
801049c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049c6:	83 c0 04             	add    $0x4,%eax
801049c9:	39 c2                	cmp    %eax,%edx
801049cb:	75 f3                	jne    801049c0 <acquire+0x80>
}
801049cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d0:	c9                   	leave  
801049d1:	c3                   	ret    
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801049db:	e8 b0 f2 ff ff       	call   80103c90 <mycpu>
801049e0:	39 c3                	cmp    %eax,%ebx
801049e2:	0f 85 72 ff ff ff    	jne    8010495a <acquire+0x1a>
  popcli();
801049e8:	e8 53 fe ff ff       	call   80104840 <popcli>
    panic("acquire");
801049ed:	83 ec 0c             	sub    $0xc,%esp
801049f0:	68 d5 7b 10 80       	push   $0x80107bd5
801049f5:	e8 86 b9 ff ff       	call   80100380 <panic>
801049fa:	66 90                	xchg   %ax,%ax
801049fc:	66 90                	xchg   %ax,%ax
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	8b 55 08             	mov    0x8(%ebp),%edx
80104a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a0a:	53                   	push   %ebx
80104a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104a0e:	89 d7                	mov    %edx,%edi
80104a10:	09 cf                	or     %ecx,%edi
80104a12:	83 e7 03             	and    $0x3,%edi
80104a15:	75 29                	jne    80104a40 <memset+0x40>
    c &= 0xFF;
80104a17:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a1a:	c1 e0 18             	shl    $0x18,%eax
80104a1d:	89 fb                	mov    %edi,%ebx
80104a1f:	c1 e9 02             	shr    $0x2,%ecx
80104a22:	c1 e3 10             	shl    $0x10,%ebx
80104a25:	09 d8                	or     %ebx,%eax
80104a27:	09 f8                	or     %edi,%eax
80104a29:	c1 e7 08             	shl    $0x8,%edi
80104a2c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a2e:	89 d7                	mov    %edx,%edi
80104a30:	fc                   	cld    
80104a31:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a33:	5b                   	pop    %ebx
80104a34:	89 d0                	mov    %edx,%eax
80104a36:	5f                   	pop    %edi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104a40:	89 d7                	mov    %edx,%edi
80104a42:	fc                   	cld    
80104a43:	f3 aa                	rep stos %al,%es:(%edi)
80104a45:	5b                   	pop    %ebx
80104a46:	89 d0                	mov    %edx,%eax
80104a48:	5f                   	pop    %edi
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a4f:	90                   	nop

80104a50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	8b 75 10             	mov    0x10(%ebp),%esi
80104a57:	8b 55 08             	mov    0x8(%ebp),%edx
80104a5a:	53                   	push   %ebx
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a5e:	85 f6                	test   %esi,%esi
80104a60:	74 2e                	je     80104a90 <memcmp+0x40>
80104a62:	01 c6                	add    %eax,%esi
80104a64:	eb 14                	jmp    80104a7a <memcmp+0x2a>
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a76:	39 f0                	cmp    %esi,%eax
80104a78:	74 16                	je     80104a90 <memcmp+0x40>
    if(*s1 != *s2)
80104a7a:	0f b6 0a             	movzbl (%edx),%ecx
80104a7d:	0f b6 18             	movzbl (%eax),%ebx
80104a80:	38 d9                	cmp    %bl,%cl
80104a82:	74 ec                	je     80104a70 <memcmp+0x20>
      return *s1 - *s2;
80104a84:	0f b6 c1             	movzbl %cl,%eax
80104a87:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	5b                   	pop    %ebx
  return 0;
80104a91:	31 c0                	xor    %eax,%eax
}
80104a93:	5e                   	pop    %esi
80104a94:	5d                   	pop    %ebp
80104a95:	c3                   	ret    
80104a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104aaa:	56                   	push   %esi
80104aab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104aae:	39 d6                	cmp    %edx,%esi
80104ab0:	73 26                	jae    80104ad8 <memmove+0x38>
80104ab2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ab5:	39 fa                	cmp    %edi,%edx
80104ab7:	73 1f                	jae    80104ad8 <memmove+0x38>
80104ab9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104abc:	85 c9                	test   %ecx,%ecx
80104abe:	74 0c                	je     80104acc <memmove+0x2c>
      *--d = *--s;
80104ac0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ac4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104ac7:	83 e8 01             	sub    $0x1,%eax
80104aca:	73 f4                	jae    80104ac0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104acc:	5e                   	pop    %esi
80104acd:	89 d0                	mov    %edx,%eax
80104acf:	5f                   	pop    %edi
80104ad0:	5d                   	pop    %ebp
80104ad1:	c3                   	ret    
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ad8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104adb:	89 d7                	mov    %edx,%edi
80104add:	85 c9                	test   %ecx,%ecx
80104adf:	74 eb                	je     80104acc <memmove+0x2c>
80104ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ae8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ae9:	39 c6                	cmp    %eax,%esi
80104aeb:	75 fb                	jne    80104ae8 <memmove+0x48>
}
80104aed:	5e                   	pop    %esi
80104aee:	89 d0                	mov    %edx,%eax
80104af0:	5f                   	pop    %edi
80104af1:	5d                   	pop    %ebp
80104af2:	c3                   	ret    
80104af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b00:	eb 9e                	jmp    80104aa0 <memmove>
80104b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	8b 75 10             	mov    0x10(%ebp),%esi
80104b17:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b1a:	53                   	push   %ebx
80104b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104b1e:	85 f6                	test   %esi,%esi
80104b20:	74 2e                	je     80104b50 <strncmp+0x40>
80104b22:	01 d6                	add    %edx,%esi
80104b24:	eb 18                	jmp    80104b3e <strncmp+0x2e>
80104b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
80104b30:	38 d8                	cmp    %bl,%al
80104b32:	75 14                	jne    80104b48 <strncmp+0x38>
    n--, p++, q++;
80104b34:	83 c2 01             	add    $0x1,%edx
80104b37:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b3a:	39 f2                	cmp    %esi,%edx
80104b3c:	74 12                	je     80104b50 <strncmp+0x40>
80104b3e:	0f b6 01             	movzbl (%ecx),%eax
80104b41:	0f b6 1a             	movzbl (%edx),%ebx
80104b44:	84 c0                	test   %al,%al
80104b46:	75 e8                	jne    80104b30 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b48:	29 d8                	sub    %ebx,%eax
}
80104b4a:	5b                   	pop    %ebx
80104b4b:	5e                   	pop    %esi
80104b4c:	5d                   	pop    %ebp
80104b4d:	c3                   	ret    
80104b4e:	66 90                	xchg   %ax,%ax
80104b50:	5b                   	pop    %ebx
    return 0;
80104b51:	31 c0                	xor    %eax,%eax
}
80104b53:	5e                   	pop    %esi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

80104b60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	8b 75 08             	mov    0x8(%ebp),%esi
80104b68:	53                   	push   %ebx
80104b69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b6c:	89 f0                	mov    %esi,%eax
80104b6e:	eb 15                	jmp    80104b85 <strncpy+0x25>
80104b70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b74:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b77:	83 c0 01             	add    $0x1,%eax
80104b7a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104b7e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b81:	84 d2                	test   %dl,%dl
80104b83:	74 09                	je     80104b8e <strncpy+0x2e>
80104b85:	89 cb                	mov    %ecx,%ebx
80104b87:	83 e9 01             	sub    $0x1,%ecx
80104b8a:	85 db                	test   %ebx,%ebx
80104b8c:	7f e2                	jg     80104b70 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b8e:	89 c2                	mov    %eax,%edx
80104b90:	85 c9                	test   %ecx,%ecx
80104b92:	7e 17                	jle    80104bab <strncpy+0x4b>
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b98:	83 c2 01             	add    $0x1,%edx
80104b9b:	89 c1                	mov    %eax,%ecx
80104b9d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104ba1:	29 d1                	sub    %edx,%ecx
80104ba3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104ba7:	85 c9                	test   %ecx,%ecx
80104ba9:	7f ed                	jg     80104b98 <strncpy+0x38>
  return os;
}
80104bab:	5b                   	pop    %ebx
80104bac:	89 f0                	mov    %esi,%eax
80104bae:	5e                   	pop    %esi
80104baf:	5f                   	pop    %edi
80104bb0:	5d                   	pop    %ebp
80104bb1:	c3                   	ret    
80104bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	8b 55 10             	mov    0x10(%ebp),%edx
80104bc7:	8b 75 08             	mov    0x8(%ebp),%esi
80104bca:	53                   	push   %ebx
80104bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104bce:	85 d2                	test   %edx,%edx
80104bd0:	7e 25                	jle    80104bf7 <safestrcpy+0x37>
80104bd2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104bd6:	89 f2                	mov    %esi,%edx
80104bd8:	eb 16                	jmp    80104bf0 <safestrcpy+0x30>
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104be0:	0f b6 08             	movzbl (%eax),%ecx
80104be3:	83 c0 01             	add    $0x1,%eax
80104be6:	83 c2 01             	add    $0x1,%edx
80104be9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bec:	84 c9                	test   %cl,%cl
80104bee:	74 04                	je     80104bf4 <safestrcpy+0x34>
80104bf0:	39 d8                	cmp    %ebx,%eax
80104bf2:	75 ec                	jne    80104be0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bf4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104bf7:	89 f0                	mov    %esi,%eax
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5d                   	pop    %ebp
80104bfc:	c3                   	ret    
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <strlen>:

int
strlen(const char *s)
{
80104c00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c01:	31 c0                	xor    %eax,%eax
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c08:	80 3a 00             	cmpb   $0x0,(%edx)
80104c0b:	74 0c                	je     80104c19 <strlen+0x19>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
80104c10:	83 c0 01             	add    $0x1,%eax
80104c13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c17:	75 f7                	jne    80104c10 <strlen+0x10>
    ;
  return n;
}
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    

80104c1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c23:	55                   	push   %ebp
  pushl %ebx
80104c24:	53                   	push   %ebx
  pushl %esi
80104c25:	56                   	push   %esi
  pushl %edi
80104c26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c2b:	5f                   	pop    %edi
  popl %esi
80104c2c:	5e                   	pop    %esi
  popl %ebx
80104c2d:	5b                   	pop    %ebx
  popl %ebp
80104c2e:	5d                   	pop    %ebp
  ret
80104c2f:	c3                   	ret    

80104c30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c3a:	e8 d1 f0 ff ff       	call   80103d10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3f:	8b 00                	mov    (%eax),%eax
80104c41:	39 d8                	cmp    %ebx,%eax
80104c43:	76 1b                	jbe    80104c60 <fetchint+0x30>
80104c45:	8d 53 04             	lea    0x4(%ebx),%edx
80104c48:	39 d0                	cmp    %edx,%eax
80104c4a:	72 14                	jb     80104c60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4f:	8b 13                	mov    (%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c58:	c9                   	leave  
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c65:	eb ee                	jmp    80104c55 <fetchint+0x25>
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c7a:	e8 91 f0 ff ff       	call   80103d10 <myproc>

  if(addr >= curproc->sz)
80104c7f:	39 18                	cmp    %ebx,(%eax)
80104c81:	76 2d                	jbe    80104cb0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c86:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c88:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c8a:	39 d3                	cmp    %edx,%ebx
80104c8c:	73 22                	jae    80104cb0 <fetchstr+0x40>
80104c8e:	89 d8                	mov    %ebx,%eax
80104c90:	eb 0d                	jmp    80104c9f <fetchstr+0x2f>
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c98:	83 c0 01             	add    $0x1,%eax
80104c9b:	39 c2                	cmp    %eax,%edx
80104c9d:	76 11                	jbe    80104cb0 <fetchstr+0x40>
    if(*s == 0)
80104c9f:	80 38 00             	cmpb   $0x0,(%eax)
80104ca2:	75 f4                	jne    80104c98 <fetchstr+0x28>
      return s - *pp;
80104ca4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ca6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca9:	c9                   	leave  
80104caa:	c3                   	ret    
80104cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop
80104cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb8:	c9                   	leave  
80104cb9:	c3                   	ret    
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cc5:	e8 46 f0 ff ff       	call   80103d10 <myproc>
80104cca:	8b 55 08             	mov    0x8(%ebp),%edx
80104ccd:	8b 40 18             	mov    0x18(%eax),%eax
80104cd0:	8b 40 44             	mov    0x44(%eax),%eax
80104cd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cd6:	e8 35 f0 ff ff       	call   80103d10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cdb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cde:	8b 00                	mov    (%eax),%eax
80104ce0:	39 c6                	cmp    %eax,%esi
80104ce2:	73 1c                	jae    80104d00 <argint+0x40>
80104ce4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ce7:	39 d0                	cmp    %edx,%eax
80104ce9:	72 15                	jb     80104d00 <argint+0x40>
  *ip = *(int*)(addr);
80104ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cee:	8b 53 04             	mov    0x4(%ebx),%edx
80104cf1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cf3:	31 c0                	xor    %eax,%eax
}
80104cf5:	5b                   	pop    %ebx
80104cf6:	5e                   	pop    %esi
80104cf7:	5d                   	pop    %ebp
80104cf8:	c3                   	ret    
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d05:	eb ee                	jmp    80104cf5 <argint+0x35>
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	53                   	push   %ebx
80104d16:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104d19:	e8 f2 ef ff ff       	call   80103d10 <myproc>
80104d1e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d20:	e8 eb ef ff ff       	call   80103d10 <myproc>
80104d25:	8b 55 08             	mov    0x8(%ebp),%edx
80104d28:	8b 40 18             	mov    0x18(%eax),%eax
80104d2b:	8b 40 44             	mov    0x44(%eax),%eax
80104d2e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d31:	e8 da ef ff ff       	call   80103d10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d36:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d39:	8b 00                	mov    (%eax),%eax
80104d3b:	39 c7                	cmp    %eax,%edi
80104d3d:	73 31                	jae    80104d70 <argptr+0x60>
80104d3f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d42:	39 c8                	cmp    %ecx,%eax
80104d44:	72 2a                	jb     80104d70 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d46:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d49:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d4c:	85 d2                	test   %edx,%edx
80104d4e:	78 20                	js     80104d70 <argptr+0x60>
80104d50:	8b 16                	mov    (%esi),%edx
80104d52:	39 c2                	cmp    %eax,%edx
80104d54:	76 1a                	jbe    80104d70 <argptr+0x60>
80104d56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d59:	01 c3                	add    %eax,%ebx
80104d5b:	39 da                	cmp    %ebx,%edx
80104d5d:	72 11                	jb     80104d70 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d62:	89 02                	mov    %eax,(%edx)
  return 0;
80104d64:	31 c0                	xor    %eax,%eax
}
80104d66:	83 c4 0c             	add    $0xc,%esp
80104d69:	5b                   	pop    %ebx
80104d6a:	5e                   	pop    %esi
80104d6b:	5f                   	pop    %edi
80104d6c:	5d                   	pop    %ebp
80104d6d:	c3                   	ret    
80104d6e:	66 90                	xchg   %ax,%ax
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d75:	eb ef                	jmp    80104d66 <argptr+0x56>
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d85:	e8 86 ef ff ff       	call   80103d10 <myproc>
80104d8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d8d:	8b 40 18             	mov    0x18(%eax),%eax
80104d90:	8b 40 44             	mov    0x44(%eax),%eax
80104d93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d96:	e8 75 ef ff ff       	call   80103d10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d9e:	8b 00                	mov    (%eax),%eax
80104da0:	39 c6                	cmp    %eax,%esi
80104da2:	73 44                	jae    80104de8 <argstr+0x68>
80104da4:	8d 53 08             	lea    0x8(%ebx),%edx
80104da7:	39 d0                	cmp    %edx,%eax
80104da9:	72 3d                	jb     80104de8 <argstr+0x68>
  *ip = *(int*)(addr);
80104dab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104dae:	e8 5d ef ff ff       	call   80103d10 <myproc>
  if(addr >= curproc->sz)
80104db3:	3b 18                	cmp    (%eax),%ebx
80104db5:	73 31                	jae    80104de8 <argstr+0x68>
  *pp = (char*)addr;
80104db7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104dbc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dbe:	39 d3                	cmp    %edx,%ebx
80104dc0:	73 26                	jae    80104de8 <argstr+0x68>
80104dc2:	89 d8                	mov    %ebx,%eax
80104dc4:	eb 11                	jmp    80104dd7 <argstr+0x57>
80104dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
80104dd0:	83 c0 01             	add    $0x1,%eax
80104dd3:	39 c2                	cmp    %eax,%edx
80104dd5:	76 11                	jbe    80104de8 <argstr+0x68>
    if(*s == 0)
80104dd7:	80 38 00             	cmpb   $0x0,(%eax)
80104dda:	75 f4                	jne    80104dd0 <argstr+0x50>
      return s - *pp;
80104ddc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104dde:	5b                   	pop    %ebx
80104ddf:	5e                   	pop    %esi
80104de0:	5d                   	pop    %ebp
80104de1:	c3                   	ret    
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104de8:	5b                   	pop    %ebx
    return -1;
80104de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dee:	5e                   	pop    %esi
80104def:	5d                   	pop    %ebp
80104df0:	c3                   	ret    
80104df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop

80104e00 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
80104e04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e07:	e8 04 ef ff ff       	call   80103d10 <myproc>
80104e0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e0e:	8b 40 18             	mov    0x18(%eax),%eax
80104e11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e17:	83 fa 14             	cmp    $0x14,%edx
80104e1a:	77 24                	ja     80104e40 <syscall+0x40>
80104e1c:	8b 14 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%edx
80104e23:	85 d2                	test   %edx,%edx
80104e25:	74 19                	je     80104e40 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104e27:	ff d2                	call   *%edx
80104e29:	89 c2                	mov    %eax,%edx
80104e2b:	8b 43 18             	mov    0x18(%ebx),%eax
80104e2e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e34:	c9                   	leave  
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e40:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e41:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e44:	50                   	push   %eax
80104e45:	ff 73 10             	push   0x10(%ebx)
80104e48:	68 dd 7b 10 80       	push   $0x80107bdd
80104e4d:	e8 be b9 ff ff       	call   80100810 <cprintf>
    curproc->tf->eax = -1;
80104e52:	8b 43 18             	mov    0x18(%ebx),%eax
80104e55:	83 c4 10             	add    $0x10,%esp
80104e58:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e62:	c9                   	leave  
80104e63:	c3                   	ret    
80104e64:	66 90                	xchg   %ax,%ax
80104e66:	66 90                	xchg   %ax,%ax
80104e68:	66 90                	xchg   %ax,%ax
80104e6a:	66 90                	xchg   %ax,%ax
80104e6c:	66 90                	xchg   %ax,%ax
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e75:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e78:	53                   	push   %ebx
80104e79:	83 ec 34             	sub    $0x34,%esp
80104e7c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e82:	57                   	push   %edi
80104e83:	50                   	push   %eax
{
80104e84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e87:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e8a:	e8 d1 d5 ff ff       	call   80102460 <nameiparent>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	85 c0                	test   %eax,%eax
80104e94:	0f 84 46 01 00 00    	je     80104fe0 <create+0x170>
    return 0;
  ilock(dp);
80104e9a:	83 ec 0c             	sub    $0xc,%esp
80104e9d:	89 c3                	mov    %eax,%ebx
80104e9f:	50                   	push   %eax
80104ea0:	e8 7b cc ff ff       	call   80101b20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ea5:	83 c4 0c             	add    $0xc,%esp
80104ea8:	6a 00                	push   $0x0
80104eaa:	57                   	push   %edi
80104eab:	53                   	push   %ebx
80104eac:	e8 cf d1 ff ff       	call   80102080 <dirlookup>
80104eb1:	83 c4 10             	add    $0x10,%esp
80104eb4:	89 c6                	mov    %eax,%esi
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	74 56                	je     80104f10 <create+0xa0>
    iunlockput(dp);
80104eba:	83 ec 0c             	sub    $0xc,%esp
80104ebd:	53                   	push   %ebx
80104ebe:	e8 ed ce ff ff       	call   80101db0 <iunlockput>
    ilock(ip);
80104ec3:	89 34 24             	mov    %esi,(%esp)
80104ec6:	e8 55 cc ff ff       	call   80101b20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ecb:	83 c4 10             	add    $0x10,%esp
80104ece:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ed3:	75 1b                	jne    80104ef0 <create+0x80>
80104ed5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104eda:	75 14                	jne    80104ef0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104edf:	89 f0                	mov    %esi,%eax
80104ee1:	5b                   	pop    %ebx
80104ee2:	5e                   	pop    %esi
80104ee3:	5f                   	pop    %edi
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	56                   	push   %esi
    return 0;
80104ef4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ef6:	e8 b5 ce ff ff       	call   80101db0 <iunlockput>
    return 0;
80104efb:	83 c4 10             	add    $0x10,%esp
}
80104efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f01:	89 f0                	mov    %esi,%eax
80104f03:	5b                   	pop    %ebx
80104f04:	5e                   	pop    %esi
80104f05:	5f                   	pop    %edi
80104f06:	5d                   	pop    %ebp
80104f07:	c3                   	ret    
80104f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104f10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f14:	83 ec 08             	sub    $0x8,%esp
80104f17:	50                   	push   %eax
80104f18:	ff 33                	push   (%ebx)
80104f1a:	e8 91 ca ff ff       	call   801019b0 <ialloc>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	89 c6                	mov    %eax,%esi
80104f24:	85 c0                	test   %eax,%eax
80104f26:	0f 84 cd 00 00 00    	je     80104ff9 <create+0x189>
  ilock(ip);
80104f2c:	83 ec 0c             	sub    $0xc,%esp
80104f2f:	50                   	push   %eax
80104f30:	e8 eb cb ff ff       	call   80101b20 <ilock>
  ip->major = major;
80104f35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f45:	b8 01 00 00 00       	mov    $0x1,%eax
80104f4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f4e:	89 34 24             	mov    %esi,(%esp)
80104f51:	e8 1a cb ff ff       	call   80101a70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f56:	83 c4 10             	add    $0x10,%esp
80104f59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f5e:	74 30                	je     80104f90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f60:	83 ec 04             	sub    $0x4,%esp
80104f63:	ff 76 04             	push   0x4(%esi)
80104f66:	57                   	push   %edi
80104f67:	53                   	push   %ebx
80104f68:	e8 13 d4 ff ff       	call   80102380 <dirlink>
80104f6d:	83 c4 10             	add    $0x10,%esp
80104f70:	85 c0                	test   %eax,%eax
80104f72:	78 78                	js     80104fec <create+0x17c>
  iunlockput(dp);
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	53                   	push   %ebx
80104f78:	e8 33 ce ff ff       	call   80101db0 <iunlockput>
  return ip;
80104f7d:	83 c4 10             	add    $0x10,%esp
}
80104f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f83:	89 f0                	mov    %esi,%eax
80104f85:	5b                   	pop    %ebx
80104f86:	5e                   	pop    %esi
80104f87:	5f                   	pop    %edi
80104f88:	5d                   	pop    %ebp
80104f89:	c3                   	ret    
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f98:	53                   	push   %ebx
80104f99:	e8 d2 ca ff ff       	call   80101a70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f9e:	83 c4 0c             	add    $0xc,%esp
80104fa1:	ff 76 04             	push   0x4(%esi)
80104fa4:	68 74 7c 10 80       	push   $0x80107c74
80104fa9:	56                   	push   %esi
80104faa:	e8 d1 d3 ff ff       	call   80102380 <dirlink>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	78 18                	js     80104fce <create+0x15e>
80104fb6:	83 ec 04             	sub    $0x4,%esp
80104fb9:	ff 73 04             	push   0x4(%ebx)
80104fbc:	68 73 7c 10 80       	push   $0x80107c73
80104fc1:	56                   	push   %esi
80104fc2:	e8 b9 d3 ff ff       	call   80102380 <dirlink>
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	79 92                	jns    80104f60 <create+0xf0>
      panic("create dots");
80104fce:	83 ec 0c             	sub    $0xc,%esp
80104fd1:	68 67 7c 10 80       	push   $0x80107c67
80104fd6:	e8 a5 b3 ff ff       	call   80100380 <panic>
80104fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fdf:	90                   	nop
}
80104fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104fe3:	31 f6                	xor    %esi,%esi
}
80104fe5:	5b                   	pop    %ebx
80104fe6:	89 f0                	mov    %esi,%eax
80104fe8:	5e                   	pop    %esi
80104fe9:	5f                   	pop    %edi
80104fea:	5d                   	pop    %ebp
80104feb:	c3                   	ret    
    panic("create: dirlink");
80104fec:	83 ec 0c             	sub    $0xc,%esp
80104fef:	68 76 7c 10 80       	push   $0x80107c76
80104ff4:	e8 87 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	68 58 7c 10 80       	push   $0x80107c58
80105001:	e8 7a b3 ff ff       	call   80100380 <panic>
80105006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500d:	8d 76 00             	lea    0x0(%esi),%esi

80105010 <sys_dup>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105015:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105018:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010501b:	50                   	push   %eax
8010501c:	6a 00                	push   $0x0
8010501e:	e8 9d fc ff ff       	call   80104cc0 <argint>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	78 36                	js     80105060 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010502a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010502e:	77 30                	ja     80105060 <sys_dup+0x50>
80105030:	e8 db ec ff ff       	call   80103d10 <myproc>
80105035:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105038:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010503c:	85 f6                	test   %esi,%esi
8010503e:	74 20                	je     80105060 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105040:	e8 cb ec ff ff       	call   80103d10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105045:	31 db                	xor    %ebx,%ebx
80105047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105050:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105054:	85 d2                	test   %edx,%edx
80105056:	74 18                	je     80105070 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105058:	83 c3 01             	add    $0x1,%ebx
8010505b:	83 fb 10             	cmp    $0x10,%ebx
8010505e:	75 f0                	jne    80105050 <sys_dup+0x40>
}
80105060:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105063:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105068:	89 d8                	mov    %ebx,%eax
8010506a:	5b                   	pop    %ebx
8010506b:	5e                   	pop    %esi
8010506c:	5d                   	pop    %ebp
8010506d:	c3                   	ret    
8010506e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105070:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105073:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105077:	56                   	push   %esi
80105078:	e8 c3 c1 ff ff       	call   80101240 <filedup>
  return fd;
8010507d:	83 c4 10             	add    $0x10,%esp
}
80105080:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105083:	89 d8                	mov    %ebx,%eax
80105085:	5b                   	pop    %ebx
80105086:	5e                   	pop    %esi
80105087:	5d                   	pop    %ebp
80105088:	c3                   	ret    
80105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105090 <sys_read>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105095:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105098:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010509b:	53                   	push   %ebx
8010509c:	6a 00                	push   $0x0
8010509e:	e8 1d fc ff ff       	call   80104cc0 <argint>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 5e                	js     80105108 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ae:	77 58                	ja     80105108 <sys_read+0x78>
801050b0:	e8 5b ec ff ff       	call   80103d10 <myproc>
801050b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050bc:	85 f6                	test   %esi,%esi
801050be:	74 48                	je     80105108 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c0:	83 ec 08             	sub    $0x8,%esp
801050c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050c6:	50                   	push   %eax
801050c7:	6a 02                	push   $0x2
801050c9:	e8 f2 fb ff ff       	call   80104cc0 <argint>
801050ce:	83 c4 10             	add    $0x10,%esp
801050d1:	85 c0                	test   %eax,%eax
801050d3:	78 33                	js     80105108 <sys_read+0x78>
801050d5:	83 ec 04             	sub    $0x4,%esp
801050d8:	ff 75 f0             	push   -0x10(%ebp)
801050db:	53                   	push   %ebx
801050dc:	6a 01                	push   $0x1
801050de:	e8 2d fc ff ff       	call   80104d10 <argptr>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	78 1e                	js     80105108 <sys_read+0x78>
  return fileread(f, p, n);
801050ea:	83 ec 04             	sub    $0x4,%esp
801050ed:	ff 75 f0             	push   -0x10(%ebp)
801050f0:	ff 75 f4             	push   -0xc(%ebp)
801050f3:	56                   	push   %esi
801050f4:	e8 c7 c2 ff ff       	call   801013c0 <fileread>
801050f9:	83 c4 10             	add    $0x10,%esp
}
801050fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105107:	90                   	nop
    return -1;
80105108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510d:	eb ed                	jmp    801050fc <sys_read+0x6c>
8010510f:	90                   	nop

80105110 <sys_write>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105115:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105118:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010511b:	53                   	push   %ebx
8010511c:	6a 00                	push   $0x0
8010511e:	e8 9d fb ff ff       	call   80104cc0 <argint>
80105123:	83 c4 10             	add    $0x10,%esp
80105126:	85 c0                	test   %eax,%eax
80105128:	78 5e                	js     80105188 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010512a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010512e:	77 58                	ja     80105188 <sys_write+0x78>
80105130:	e8 db eb ff ff       	call   80103d10 <myproc>
80105135:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105138:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010513c:	85 f6                	test   %esi,%esi
8010513e:	74 48                	je     80105188 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105140:	83 ec 08             	sub    $0x8,%esp
80105143:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105146:	50                   	push   %eax
80105147:	6a 02                	push   $0x2
80105149:	e8 72 fb ff ff       	call   80104cc0 <argint>
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	85 c0                	test   %eax,%eax
80105153:	78 33                	js     80105188 <sys_write+0x78>
80105155:	83 ec 04             	sub    $0x4,%esp
80105158:	ff 75 f0             	push   -0x10(%ebp)
8010515b:	53                   	push   %ebx
8010515c:	6a 01                	push   $0x1
8010515e:	e8 ad fb ff ff       	call   80104d10 <argptr>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	78 1e                	js     80105188 <sys_write+0x78>
  return filewrite(f, p, n);
8010516a:	83 ec 04             	sub    $0x4,%esp
8010516d:	ff 75 f0             	push   -0x10(%ebp)
80105170:	ff 75 f4             	push   -0xc(%ebp)
80105173:	56                   	push   %esi
80105174:	e8 d7 c2 ff ff       	call   80101450 <filewrite>
80105179:	83 c4 10             	add    $0x10,%esp
}
8010517c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010517f:	5b                   	pop    %ebx
80105180:	5e                   	pop    %esi
80105181:	5d                   	pop    %ebp
80105182:	c3                   	ret    
80105183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105187:	90                   	nop
    return -1;
80105188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518d:	eb ed                	jmp    8010517c <sys_write+0x6c>
8010518f:	90                   	nop

80105190 <sys_close>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105195:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105198:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010519b:	50                   	push   %eax
8010519c:	6a 00                	push   $0x0
8010519e:	e8 1d fb ff ff       	call   80104cc0 <argint>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	85 c0                	test   %eax,%eax
801051a8:	78 3e                	js     801051e8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051ae:	77 38                	ja     801051e8 <sys_close+0x58>
801051b0:	e8 5b eb ff ff       	call   80103d10 <myproc>
801051b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051b8:	8d 5a 08             	lea    0x8(%edx),%ebx
801051bb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801051bf:	85 f6                	test   %esi,%esi
801051c1:	74 25                	je     801051e8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801051c3:	e8 48 eb ff ff       	call   80103d10 <myproc>
  fileclose(f);
801051c8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051cb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801051d2:	00 
  fileclose(f);
801051d3:	56                   	push   %esi
801051d4:	e8 b7 c0 ff ff       	call   80101290 <fileclose>
  return 0;
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	31 c0                	xor    %eax,%eax
}
801051de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051e1:	5b                   	pop    %ebx
801051e2:	5e                   	pop    %esi
801051e3:	5d                   	pop    %ebp
801051e4:	c3                   	ret    
801051e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ed:	eb ef                	jmp    801051de <sys_close+0x4e>
801051ef:	90                   	nop

801051f0 <sys_fstat>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051fb:	53                   	push   %ebx
801051fc:	6a 00                	push   $0x0
801051fe:	e8 bd fa ff ff       	call   80104cc0 <argint>
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	78 46                	js     80105250 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010520a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010520e:	77 40                	ja     80105250 <sys_fstat+0x60>
80105210:	e8 fb ea ff ff       	call   80103d10 <myproc>
80105215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105218:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010521c:	85 f6                	test   %esi,%esi
8010521e:	74 30                	je     80105250 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105220:	83 ec 04             	sub    $0x4,%esp
80105223:	6a 14                	push   $0x14
80105225:	53                   	push   %ebx
80105226:	6a 01                	push   $0x1
80105228:	e8 e3 fa ff ff       	call   80104d10 <argptr>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	78 1c                	js     80105250 <sys_fstat+0x60>
  return filestat(f, st);
80105234:	83 ec 08             	sub    $0x8,%esp
80105237:	ff 75 f4             	push   -0xc(%ebp)
8010523a:	56                   	push   %esi
8010523b:	e8 30 c1 ff ff       	call   80101370 <filestat>
80105240:	83 c4 10             	add    $0x10,%esp
}
80105243:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105246:	5b                   	pop    %ebx
80105247:	5e                   	pop    %esi
80105248:	5d                   	pop    %ebp
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105255:	eb ec                	jmp    80105243 <sys_fstat+0x53>
80105257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525e:	66 90                	xchg   %ax,%ax

80105260 <sys_link>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105265:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105268:	53                   	push   %ebx
80105269:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010526c:	50                   	push   %eax
8010526d:	6a 00                	push   $0x0
8010526f:	e8 0c fb ff ff       	call   80104d80 <argstr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 88 fb 00 00 00    	js     8010537a <sys_link+0x11a>
8010527f:	83 ec 08             	sub    $0x8,%esp
80105282:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105285:	50                   	push   %eax
80105286:	6a 01                	push   $0x1
80105288:	e8 f3 fa ff ff       	call   80104d80 <argstr>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	0f 88 e2 00 00 00    	js     8010537a <sys_link+0x11a>
  begin_op();
80105298:	e8 63 de ff ff       	call   80103100 <begin_op>
  if((ip = namei(old)) == 0){
8010529d:	83 ec 0c             	sub    $0xc,%esp
801052a0:	ff 75 d4             	push   -0x2c(%ebp)
801052a3:	e8 98 d1 ff ff       	call   80102440 <namei>
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	89 c3                	mov    %eax,%ebx
801052ad:	85 c0                	test   %eax,%eax
801052af:	0f 84 e4 00 00 00    	je     80105399 <sys_link+0x139>
  ilock(ip);
801052b5:	83 ec 0c             	sub    $0xc,%esp
801052b8:	50                   	push   %eax
801052b9:	e8 62 c8 ff ff       	call   80101b20 <ilock>
  if(ip->type == T_DIR){
801052be:	83 c4 10             	add    $0x10,%esp
801052c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052c6:	0f 84 b5 00 00 00    	je     80105381 <sys_link+0x121>
  iupdate(ip);
801052cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801052d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052d7:	53                   	push   %ebx
801052d8:	e8 93 c7 ff ff       	call   80101a70 <iupdate>
  iunlock(ip);
801052dd:	89 1c 24             	mov    %ebx,(%esp)
801052e0:	e8 1b c9 ff ff       	call   80101c00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052e5:	58                   	pop    %eax
801052e6:	5a                   	pop    %edx
801052e7:	57                   	push   %edi
801052e8:	ff 75 d0             	push   -0x30(%ebp)
801052eb:	e8 70 d1 ff ff       	call   80102460 <nameiparent>
801052f0:	83 c4 10             	add    $0x10,%esp
801052f3:	89 c6                	mov    %eax,%esi
801052f5:	85 c0                	test   %eax,%eax
801052f7:	74 5b                	je     80105354 <sys_link+0xf4>
  ilock(dp);
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	50                   	push   %eax
801052fd:	e8 1e c8 ff ff       	call   80101b20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105302:	8b 03                	mov    (%ebx),%eax
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	39 06                	cmp    %eax,(%esi)
80105309:	75 3d                	jne    80105348 <sys_link+0xe8>
8010530b:	83 ec 04             	sub    $0x4,%esp
8010530e:	ff 73 04             	push   0x4(%ebx)
80105311:	57                   	push   %edi
80105312:	56                   	push   %esi
80105313:	e8 68 d0 ff ff       	call   80102380 <dirlink>
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	85 c0                	test   %eax,%eax
8010531d:	78 29                	js     80105348 <sys_link+0xe8>
  iunlockput(dp);
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	56                   	push   %esi
80105323:	e8 88 ca ff ff       	call   80101db0 <iunlockput>
  iput(ip);
80105328:	89 1c 24             	mov    %ebx,(%esp)
8010532b:	e8 20 c9 ff ff       	call   80101c50 <iput>
  end_op();
80105330:	e8 3b de ff ff       	call   80103170 <end_op>
  return 0;
80105335:	83 c4 10             	add    $0x10,%esp
80105338:	31 c0                	xor    %eax,%eax
}
8010533a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010533d:	5b                   	pop    %ebx
8010533e:	5e                   	pop    %esi
8010533f:	5f                   	pop    %edi
80105340:	5d                   	pop    %ebp
80105341:	c3                   	ret    
80105342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	56                   	push   %esi
8010534c:	e8 5f ca ff ff       	call   80101db0 <iunlockput>
    goto bad;
80105351:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	53                   	push   %ebx
80105358:	e8 c3 c7 ff ff       	call   80101b20 <ilock>
  ip->nlink--;
8010535d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105362:	89 1c 24             	mov    %ebx,(%esp)
80105365:	e8 06 c7 ff ff       	call   80101a70 <iupdate>
  iunlockput(ip);
8010536a:	89 1c 24             	mov    %ebx,(%esp)
8010536d:	e8 3e ca ff ff       	call   80101db0 <iunlockput>
  end_op();
80105372:	e8 f9 dd ff ff       	call   80103170 <end_op>
  return -1;
80105377:	83 c4 10             	add    $0x10,%esp
8010537a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537f:	eb b9                	jmp    8010533a <sys_link+0xda>
    iunlockput(ip);
80105381:	83 ec 0c             	sub    $0xc,%esp
80105384:	53                   	push   %ebx
80105385:	e8 26 ca ff ff       	call   80101db0 <iunlockput>
    end_op();
8010538a:	e8 e1 dd ff ff       	call   80103170 <end_op>
    return -1;
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105397:	eb a1                	jmp    8010533a <sys_link+0xda>
    end_op();
80105399:	e8 d2 dd ff ff       	call   80103170 <end_op>
    return -1;
8010539e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a3:	eb 95                	jmp    8010533a <sys_link+0xda>
801053a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_unlink>:
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	57                   	push   %edi
801053b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053b8:	53                   	push   %ebx
801053b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053bc:	50                   	push   %eax
801053bd:	6a 00                	push   $0x0
801053bf:	e8 bc f9 ff ff       	call   80104d80 <argstr>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	0f 88 7a 01 00 00    	js     80105549 <sys_unlink+0x199>
  begin_op();
801053cf:	e8 2c dd ff ff       	call   80103100 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053d7:	83 ec 08             	sub    $0x8,%esp
801053da:	53                   	push   %ebx
801053db:	ff 75 c0             	push   -0x40(%ebp)
801053de:	e8 7d d0 ff ff       	call   80102460 <nameiparent>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053e9:	85 c0                	test   %eax,%eax
801053eb:	0f 84 62 01 00 00    	je     80105553 <sys_unlink+0x1a3>
  ilock(dp);
801053f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	57                   	push   %edi
801053f8:	e8 23 c7 ff ff       	call   80101b20 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053fd:	58                   	pop    %eax
801053fe:	5a                   	pop    %edx
801053ff:	68 74 7c 10 80       	push   $0x80107c74
80105404:	53                   	push   %ebx
80105405:	e8 56 cc ff ff       	call   80102060 <namecmp>
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	85 c0                	test   %eax,%eax
8010540f:	0f 84 fb 00 00 00    	je     80105510 <sys_unlink+0x160>
80105415:	83 ec 08             	sub    $0x8,%esp
80105418:	68 73 7c 10 80       	push   $0x80107c73
8010541d:	53                   	push   %ebx
8010541e:	e8 3d cc ff ff       	call   80102060 <namecmp>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	0f 84 e2 00 00 00    	je     80105510 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010542e:	83 ec 04             	sub    $0x4,%esp
80105431:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105434:	50                   	push   %eax
80105435:	53                   	push   %ebx
80105436:	57                   	push   %edi
80105437:	e8 44 cc ff ff       	call   80102080 <dirlookup>
8010543c:	83 c4 10             	add    $0x10,%esp
8010543f:	89 c3                	mov    %eax,%ebx
80105441:	85 c0                	test   %eax,%eax
80105443:	0f 84 c7 00 00 00    	je     80105510 <sys_unlink+0x160>
  ilock(ip);
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	50                   	push   %eax
8010544d:	e8 ce c6 ff ff       	call   80101b20 <ilock>
  if(ip->nlink < 1)
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010545a:	0f 8e 1c 01 00 00    	jle    8010557c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105460:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105465:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105468:	74 66                	je     801054d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010546a:	83 ec 04             	sub    $0x4,%esp
8010546d:	6a 10                	push   $0x10
8010546f:	6a 00                	push   $0x0
80105471:	57                   	push   %edi
80105472:	e8 89 f5 ff ff       	call   80104a00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105477:	6a 10                	push   $0x10
80105479:	ff 75 c4             	push   -0x3c(%ebp)
8010547c:	57                   	push   %edi
8010547d:	ff 75 b4             	push   -0x4c(%ebp)
80105480:	e8 ab ca ff ff       	call   80101f30 <writei>
80105485:	83 c4 20             	add    $0x20,%esp
80105488:	83 f8 10             	cmp    $0x10,%eax
8010548b:	0f 85 de 00 00 00    	jne    8010556f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105491:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105496:	0f 84 94 00 00 00    	je     80105530 <sys_unlink+0x180>
  iunlockput(dp);
8010549c:	83 ec 0c             	sub    $0xc,%esp
8010549f:	ff 75 b4             	push   -0x4c(%ebp)
801054a2:	e8 09 c9 ff ff       	call   80101db0 <iunlockput>
  ip->nlink--;
801054a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054ac:	89 1c 24             	mov    %ebx,(%esp)
801054af:	e8 bc c5 ff ff       	call   80101a70 <iupdate>
  iunlockput(ip);
801054b4:	89 1c 24             	mov    %ebx,(%esp)
801054b7:	e8 f4 c8 ff ff       	call   80101db0 <iunlockput>
  end_op();
801054bc:	e8 af dc ff ff       	call   80103170 <end_op>
  return 0;
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	31 c0                	xor    %eax,%eax
}
801054c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054c9:	5b                   	pop    %ebx
801054ca:	5e                   	pop    %esi
801054cb:	5f                   	pop    %edi
801054cc:	5d                   	pop    %ebp
801054cd:	c3                   	ret    
801054ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054d4:	76 94                	jbe    8010546a <sys_unlink+0xba>
801054d6:	be 20 00 00 00       	mov    $0x20,%esi
801054db:	eb 0b                	jmp    801054e8 <sys_unlink+0x138>
801054dd:	8d 76 00             	lea    0x0(%esi),%esi
801054e0:	83 c6 10             	add    $0x10,%esi
801054e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801054e6:	73 82                	jae    8010546a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054e8:	6a 10                	push   $0x10
801054ea:	56                   	push   %esi
801054eb:	57                   	push   %edi
801054ec:	53                   	push   %ebx
801054ed:	e8 3e c9 ff ff       	call   80101e30 <readi>
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	83 f8 10             	cmp    $0x10,%eax
801054f8:	75 68                	jne    80105562 <sys_unlink+0x1b2>
    if(de.inum != 0)
801054fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054ff:	74 df                	je     801054e0 <sys_unlink+0x130>
    iunlockput(ip);
80105501:	83 ec 0c             	sub    $0xc,%esp
80105504:	53                   	push   %ebx
80105505:	e8 a6 c8 ff ff       	call   80101db0 <iunlockput>
    goto bad;
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	ff 75 b4             	push   -0x4c(%ebp)
80105516:	e8 95 c8 ff ff       	call   80101db0 <iunlockput>
  end_op();
8010551b:	e8 50 dc ff ff       	call   80103170 <end_op>
  return -1;
80105520:	83 c4 10             	add    $0x10,%esp
80105523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105528:	eb 9c                	jmp    801054c6 <sys_unlink+0x116>
8010552a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105530:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105533:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105536:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010553b:	50                   	push   %eax
8010553c:	e8 2f c5 ff ff       	call   80101a70 <iupdate>
80105541:	83 c4 10             	add    $0x10,%esp
80105544:	e9 53 ff ff ff       	jmp    8010549c <sys_unlink+0xec>
    return -1;
80105549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554e:	e9 73 ff ff ff       	jmp    801054c6 <sys_unlink+0x116>
    end_op();
80105553:	e8 18 dc ff ff       	call   80103170 <end_op>
    return -1;
80105558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555d:	e9 64 ff ff ff       	jmp    801054c6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105562:	83 ec 0c             	sub    $0xc,%esp
80105565:	68 98 7c 10 80       	push   $0x80107c98
8010556a:	e8 11 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010556f:	83 ec 0c             	sub    $0xc,%esp
80105572:	68 aa 7c 10 80       	push   $0x80107caa
80105577:	e8 04 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	68 86 7c 10 80       	push   $0x80107c86
80105584:	e8 f7 ad ff ff       	call   80100380 <panic>
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_open>:

int
sys_open(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105595:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105598:	53                   	push   %ebx
80105599:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 dc f7 ff ff       	call   80104d80 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 8e 00 00 00    	js     8010563d <sys_open+0xad>
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055b5:	50                   	push   %eax
801055b6:	6a 01                	push   $0x1
801055b8:	e8 03 f7 ff ff       	call   80104cc0 <argint>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 79                	js     8010563d <sys_open+0xad>
    return -1;

  begin_op();
801055c4:	e8 37 db ff ff       	call   80103100 <begin_op>

  if(omode & O_CREATE){
801055c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055cd:	75 79                	jne    80105648 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055cf:	83 ec 0c             	sub    $0xc,%esp
801055d2:	ff 75 e0             	push   -0x20(%ebp)
801055d5:	e8 66 ce ff ff       	call   80102440 <namei>
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	89 c6                	mov    %eax,%esi
801055df:	85 c0                	test   %eax,%eax
801055e1:	0f 84 7e 00 00 00    	je     80105665 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	50                   	push   %eax
801055eb:	e8 30 c5 ff ff       	call   80101b20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055f8:	0f 84 c2 00 00 00    	je     801056c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055fe:	e8 cd bb ff ff       	call   801011d0 <filealloc>
80105603:	89 c7                	mov    %eax,%edi
80105605:	85 c0                	test   %eax,%eax
80105607:	74 23                	je     8010562c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105609:	e8 02 e7 ff ff       	call   80103d10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010560e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105610:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105614:	85 d2                	test   %edx,%edx
80105616:	74 60                	je     80105678 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105618:	83 c3 01             	add    $0x1,%ebx
8010561b:	83 fb 10             	cmp    $0x10,%ebx
8010561e:	75 f0                	jne    80105610 <sys_open+0x80>
    if(f)
      fileclose(f);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	57                   	push   %edi
80105624:	e8 67 bc ff ff       	call   80101290 <fileclose>
80105629:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	56                   	push   %esi
80105630:	e8 7b c7 ff ff       	call   80101db0 <iunlockput>
    end_op();
80105635:	e8 36 db ff ff       	call   80103170 <end_op>
    return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105642:	eb 6d                	jmp    801056b1 <sys_open+0x121>
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010564e:	31 c9                	xor    %ecx,%ecx
80105650:	ba 02 00 00 00       	mov    $0x2,%edx
80105655:	6a 00                	push   $0x0
80105657:	e8 14 f8 ff ff       	call   80104e70 <create>
    if(ip == 0){
8010565c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010565f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105661:	85 c0                	test   %eax,%eax
80105663:	75 99                	jne    801055fe <sys_open+0x6e>
      end_op();
80105665:	e8 06 db ff ff       	call   80103170 <end_op>
      return -1;
8010566a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010566f:	eb 40                	jmp    801056b1 <sys_open+0x121>
80105671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105678:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010567b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010567f:	56                   	push   %esi
80105680:	e8 7b c5 ff ff       	call   80101c00 <iunlock>
  end_op();
80105685:	e8 e6 da ff ff       	call   80103170 <end_op>

  f->type = FD_INODE;
8010568a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105693:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105696:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105699:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010569b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056a2:	f7 d0                	not    %eax
801056a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b4:	89 d8                	mov    %ebx,%eax
801056b6:	5b                   	pop    %ebx
801056b7:	5e                   	pop    %esi
801056b8:	5f                   	pop    %edi
801056b9:	5d                   	pop    %ebp
801056ba:	c3                   	ret    
801056bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801056c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056c3:	85 c9                	test   %ecx,%ecx
801056c5:	0f 84 33 ff ff ff    	je     801055fe <sys_open+0x6e>
801056cb:	e9 5c ff ff ff       	jmp    8010562c <sys_open+0x9c>

801056d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056d6:	e8 25 da ff ff       	call   80103100 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056db:	83 ec 08             	sub    $0x8,%esp
801056de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e1:	50                   	push   %eax
801056e2:	6a 00                	push   $0x0
801056e4:	e8 97 f6 ff ff       	call   80104d80 <argstr>
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	85 c0                	test   %eax,%eax
801056ee:	78 30                	js     80105720 <sys_mkdir+0x50>
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f6:	31 c9                	xor    %ecx,%ecx
801056f8:	ba 01 00 00 00       	mov    $0x1,%edx
801056fd:	6a 00                	push   $0x0
801056ff:	e8 6c f7 ff ff       	call   80104e70 <create>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	74 15                	je     80105720 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010570b:	83 ec 0c             	sub    $0xc,%esp
8010570e:	50                   	push   %eax
8010570f:	e8 9c c6 ff ff       	call   80101db0 <iunlockput>
  end_op();
80105714:	e8 57 da ff ff       	call   80103170 <end_op>
  return 0;
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	31 c0                	xor    %eax,%eax
}
8010571e:	c9                   	leave  
8010571f:	c3                   	ret    
    end_op();
80105720:	e8 4b da ff ff       	call   80103170 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_mknod>:

int
sys_mknod(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105736:	e8 c5 d9 ff ff       	call   80103100 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010573b:	83 ec 08             	sub    $0x8,%esp
8010573e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 37 f6 ff ff       	call   80104d80 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 60                	js     801057b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105750:	83 ec 08             	sub    $0x8,%esp
80105753:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105756:	50                   	push   %eax
80105757:	6a 01                	push   $0x1
80105759:	e8 62 f5 ff ff       	call   80104cc0 <argint>
  if((argstr(0, &path)) < 0 ||
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	85 c0                	test   %eax,%eax
80105763:	78 4b                	js     801057b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576b:	50                   	push   %eax
8010576c:	6a 02                	push   $0x2
8010576e:	e8 4d f5 ff ff       	call   80104cc0 <argint>
     argint(1, &major) < 0 ||
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	78 36                	js     801057b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010577a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010577e:	83 ec 0c             	sub    $0xc,%esp
80105781:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105785:	ba 03 00 00 00       	mov    $0x3,%edx
8010578a:	50                   	push   %eax
8010578b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010578e:	e8 dd f6 ff ff       	call   80104e70 <create>
     argint(2, &minor) < 0 ||
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	74 16                	je     801057b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010579a:	83 ec 0c             	sub    $0xc,%esp
8010579d:	50                   	push   %eax
8010579e:	e8 0d c6 ff ff       	call   80101db0 <iunlockput>
  end_op();
801057a3:	e8 c8 d9 ff ff       	call   80103170 <end_op>
  return 0;
801057a8:	83 c4 10             	add    $0x10,%esp
801057ab:	31 c0                	xor    %eax,%eax
}
801057ad:	c9                   	leave  
801057ae:	c3                   	ret    
801057af:	90                   	nop
    end_op();
801057b0:	e8 bb d9 ff ff       	call   80103170 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ba:	c9                   	leave  
801057bb:	c3                   	ret    
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_chdir>:

int
sys_chdir(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
801057c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057c8:	e8 43 e5 ff ff       	call   80103d10 <myproc>
801057cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057cf:	e8 2c d9 ff ff       	call   80103100 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057d4:	83 ec 08             	sub    $0x8,%esp
801057d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057da:	50                   	push   %eax
801057db:	6a 00                	push   $0x0
801057dd:	e8 9e f5 ff ff       	call   80104d80 <argstr>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	78 77                	js     80105860 <sys_chdir+0xa0>
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	ff 75 f4             	push   -0xc(%ebp)
801057ef:	e8 4c cc ff ff       	call   80102440 <namei>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	89 c3                	mov    %eax,%ebx
801057f9:	85 c0                	test   %eax,%eax
801057fb:	74 63                	je     80105860 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	50                   	push   %eax
80105801:	e8 1a c3 ff ff       	call   80101b20 <ilock>
  if(ip->type != T_DIR){
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010580e:	75 30                	jne    80105840 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	53                   	push   %ebx
80105814:	e8 e7 c3 ff ff       	call   80101c00 <iunlock>
  iput(curproc->cwd);
80105819:	58                   	pop    %eax
8010581a:	ff 76 68             	push   0x68(%esi)
8010581d:	e8 2e c4 ff ff       	call   80101c50 <iput>
  end_op();
80105822:	e8 49 d9 ff ff       	call   80103170 <end_op>
  curproc->cwd = ip;
80105827:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	31 c0                	xor    %eax,%eax
}
8010582f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105832:	5b                   	pop    %ebx
80105833:	5e                   	pop    %esi
80105834:	5d                   	pop    %ebp
80105835:	c3                   	ret    
80105836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	53                   	push   %ebx
80105844:	e8 67 c5 ff ff       	call   80101db0 <iunlockput>
    end_op();
80105849:	e8 22 d9 ff ff       	call   80103170 <end_op>
    return -1;
8010584e:	83 c4 10             	add    $0x10,%esp
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105856:	eb d7                	jmp    8010582f <sys_chdir+0x6f>
80105858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
    end_op();
80105860:	e8 0b d9 ff ff       	call   80103170 <end_op>
    return -1;
80105865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586a:	eb c3                	jmp    8010582f <sys_chdir+0x6f>
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_exec>:

int
sys_exec(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105875:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010587b:	53                   	push   %ebx
8010587c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105882:	50                   	push   %eax
80105883:	6a 00                	push   $0x0
80105885:	e8 f6 f4 ff ff       	call   80104d80 <argstr>
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	85 c0                	test   %eax,%eax
8010588f:	0f 88 87 00 00 00    	js     8010591c <sys_exec+0xac>
80105895:	83 ec 08             	sub    $0x8,%esp
80105898:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010589e:	50                   	push   %eax
8010589f:	6a 01                	push   $0x1
801058a1:	e8 1a f4 ff ff       	call   80104cc0 <argint>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	78 6f                	js     8010591c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058ad:	83 ec 04             	sub    $0x4,%esp
801058b0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801058b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801058b8:	68 80 00 00 00       	push   $0x80
801058bd:	6a 00                	push   $0x0
801058bf:	56                   	push   %esi
801058c0:	e8 3b f1 ff ff       	call   80104a00 <memset>
801058c5:	83 c4 10             	add    $0x10,%esp
801058c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058d0:	83 ec 08             	sub    $0x8,%esp
801058d3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058d9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801058e0:	50                   	push   %eax
801058e1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058e7:	01 f8                	add    %edi,%eax
801058e9:	50                   	push   %eax
801058ea:	e8 41 f3 ff ff       	call   80104c30 <fetchint>
801058ef:	83 c4 10             	add    $0x10,%esp
801058f2:	85 c0                	test   %eax,%eax
801058f4:	78 26                	js     8010591c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058f6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058fc:	85 c0                	test   %eax,%eax
801058fe:	74 30                	je     80105930 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105906:	52                   	push   %edx
80105907:	50                   	push   %eax
80105908:	e8 63 f3 ff ff       	call   80104c70 <fetchstr>
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	85 c0                	test   %eax,%eax
80105912:	78 08                	js     8010591c <sys_exec+0xac>
  for(i=0;; i++){
80105914:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105917:	83 fb 20             	cmp    $0x20,%ebx
8010591a:	75 b4                	jne    801058d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010591c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010591f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret    
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105930:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105937:	00 00 00 00 
  return exec(path, argv);
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	56                   	push   %esi
8010593f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105945:	e8 06 b5 ff ff       	call   80100e50 <exec>
8010594a:	83 c4 10             	add    $0x10,%esp
}
8010594d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105950:	5b                   	pop    %ebx
80105951:	5e                   	pop    %esi
80105952:	5f                   	pop    %edi
80105953:	5d                   	pop    %ebp
80105954:	c3                   	ret    
80105955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_pipe>:

int
sys_pipe(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105965:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105968:	53                   	push   %ebx
80105969:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010596c:	6a 08                	push   $0x8
8010596e:	50                   	push   %eax
8010596f:	6a 00                	push   $0x0
80105971:	e8 9a f3 ff ff       	call   80104d10 <argptr>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	78 4a                	js     801059c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010597d:	83 ec 08             	sub    $0x8,%esp
80105980:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105983:	50                   	push   %eax
80105984:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105987:	50                   	push   %eax
80105988:	e8 43 de ff ff       	call   801037d0 <pipealloc>
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	85 c0                	test   %eax,%eax
80105992:	78 33                	js     801059c7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105994:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105997:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105999:	e8 72 e3 ff ff       	call   80103d10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010599e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801059a0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059a4:	85 f6                	test   %esi,%esi
801059a6:	74 28                	je     801059d0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801059a8:	83 c3 01             	add    $0x1,%ebx
801059ab:	83 fb 10             	cmp    $0x10,%ebx
801059ae:	75 f0                	jne    801059a0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	ff 75 e0             	push   -0x20(%ebp)
801059b6:	e8 d5 b8 ff ff       	call   80101290 <fileclose>
    fileclose(wf);
801059bb:	58                   	pop    %eax
801059bc:	ff 75 e4             	push   -0x1c(%ebp)
801059bf:	e8 cc b8 ff ff       	call   80101290 <fileclose>
    return -1;
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cc:	eb 53                	jmp    80105a21 <sys_pipe+0xc1>
801059ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059d0:	8d 73 08             	lea    0x8(%ebx),%esi
801059d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059da:	e8 31 e3 ff ff       	call   80103d10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059df:	31 d2                	xor    %edx,%edx
801059e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059ec:	85 c9                	test   %ecx,%ecx
801059ee:	74 20                	je     80105a10 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801059f0:	83 c2 01             	add    $0x1,%edx
801059f3:	83 fa 10             	cmp    $0x10,%edx
801059f6:	75 f0                	jne    801059e8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801059f8:	e8 13 e3 ff ff       	call   80103d10 <myproc>
801059fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a04:	00 
80105a05:	eb a9                	jmp    801059b0 <sys_pipe+0x50>
80105a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a1f:	31 c0                	xor    %eax,%eax
}
80105a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a24:	5b                   	pop    %ebx
80105a25:	5e                   	pop    %esi
80105a26:	5f                   	pop    %edi
80105a27:	5d                   	pop    %ebp
80105a28:	c3                   	ret    
80105a29:	66 90                	xchg   %ax,%ax
80105a2b:	66 90                	xchg   %ax,%ax
80105a2d:	66 90                	xchg   %ax,%ax
80105a2f:	90                   	nop

80105a30 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105a30:	e9 7b e4 ff ff       	jmp    80103eb0 <fork>
80105a35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_exit>:
}

int
sys_exit(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a46:	e8 e5 e6 ff ff       	call   80104130 <exit>
  return 0;  // not reached
}
80105a4b:	31 c0                	xor    %eax,%eax
80105a4d:	c9                   	leave  
80105a4e:	c3                   	ret    
80105a4f:	90                   	nop

80105a50 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a50:	e9 0b e8 ff ff       	jmp    80104260 <wait>
80105a55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_kill>:
}

int
sys_kill(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a69:	50                   	push   %eax
80105a6a:	6a 00                	push   $0x0
80105a6c:	e8 4f f2 ff ff       	call   80104cc0 <argint>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	85 c0                	test   %eax,%eax
80105a76:	78 18                	js     80105a90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	ff 75 f4             	push   -0xc(%ebp)
80105a7e:	e8 7d ea ff ff       	call   80104500 <kill>
80105a83:	83 c4 10             	add    $0x10,%esp
}
80105a86:	c9                   	leave  
80105a87:	c3                   	ret    
80105a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop
80105a90:	c9                   	leave  
    return -1;
80105a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a96:	c3                   	ret    
80105a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_getpid>:

int
sys_getpid(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105aa6:	e8 65 e2 ff ff       	call   80103d10 <myproc>
80105aab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105aae:	c9                   	leave  
80105aaf:	c3                   	ret    

80105ab0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ab7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aba:	50                   	push   %eax
80105abb:	6a 00                	push   $0x0
80105abd:	e8 fe f1 ff ff       	call   80104cc0 <argint>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	78 27                	js     80105af0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ac9:	e8 42 e2 ff ff       	call   80103d10 <myproc>
  if(growproc(n) < 0)
80105ace:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ad1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ad3:	ff 75 f4             	push   -0xc(%ebp)
80105ad6:	e8 55 e3 ff ff       	call   80103e30 <growproc>
80105adb:	83 c4 10             	add    $0x10,%esp
80105ade:	85 c0                	test   %eax,%eax
80105ae0:	78 0e                	js     80105af0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ae2:	89 d8                	mov    %ebx,%eax
80105ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae7:	c9                   	leave  
80105ae8:	c3                   	ret    
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105af0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105af5:	eb eb                	jmp    80105ae2 <sys_sbrk+0x32>
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <sys_sleep>:

int
sys_sleep(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b0a:	50                   	push   %eax
80105b0b:	6a 00                	push   $0x0
80105b0d:	e8 ae f1 ff ff       	call   80104cc0 <argint>
80105b12:	83 c4 10             	add    $0x10,%esp
80105b15:	85 c0                	test   %eax,%eax
80105b17:	0f 88 8a 00 00 00    	js     80105ba7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	68 a0 41 11 80       	push   $0x801141a0
80105b25:	e8 16 ee ff ff       	call   80104940 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b2d:	8b 1d 80 41 11 80    	mov    0x80114180,%ebx
  while(ticks - ticks0 < n){
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 d2                	test   %edx,%edx
80105b38:	75 27                	jne    80105b61 <sys_sleep+0x61>
80105b3a:	eb 54                	jmp    80105b90 <sys_sleep+0x90>
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b40:	83 ec 08             	sub    $0x8,%esp
80105b43:	68 a0 41 11 80       	push   $0x801141a0
80105b48:	68 80 41 11 80       	push   $0x80114180
80105b4d:	e8 8e e8 ff ff       	call   801043e0 <sleep>
  while(ticks - ticks0 < n){
80105b52:	a1 80 41 11 80       	mov    0x80114180,%eax
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	29 d8                	sub    %ebx,%eax
80105b5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b5f:	73 2f                	jae    80105b90 <sys_sleep+0x90>
    if(myproc()->killed){
80105b61:	e8 aa e1 ff ff       	call   80103d10 <myproc>
80105b66:	8b 40 24             	mov    0x24(%eax),%eax
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	74 d3                	je     80105b40 <sys_sleep+0x40>
      release(&tickslock);
80105b6d:	83 ec 0c             	sub    $0xc,%esp
80105b70:	68 a0 41 11 80       	push   $0x801141a0
80105b75:	e8 66 ed ff ff       	call   801048e0 <release>
  }
  release(&tickslock);
  return 0;
}
80105b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	68 a0 41 11 80       	push   $0x801141a0
80105b98:	e8 43 ed ff ff       	call   801048e0 <release>
  return 0;
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	31 c0                	xor    %eax,%eax
}
80105ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    
    return -1;
80105ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bac:	eb f4                	jmp    80105ba2 <sys_sleep+0xa2>
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	53                   	push   %ebx
80105bb4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105bb7:	68 a0 41 11 80       	push   $0x801141a0
80105bbc:	e8 7f ed ff ff       	call   80104940 <acquire>
  xticks = ticks;
80105bc1:	8b 1d 80 41 11 80    	mov    0x80114180,%ebx
  release(&tickslock);
80105bc7:	c7 04 24 a0 41 11 80 	movl   $0x801141a0,(%esp)
80105bce:	e8 0d ed ff ff       	call   801048e0 <release>
  return xticks;
}
80105bd3:	89 d8                	mov    %ebx,%eax
80105bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bd8:	c9                   	leave  
80105bd9:	c3                   	ret    

80105bda <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bda:	1e                   	push   %ds
  pushl %es
80105bdb:	06                   	push   %es
  pushl %fs
80105bdc:	0f a0                	push   %fs
  pushl %gs
80105bde:	0f a8                	push   %gs
  pushal
80105be0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105be1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105be5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105be7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105be9:	54                   	push   %esp
  call trap
80105bea:	e8 c1 00 00 00       	call   80105cb0 <trap>
  addl $4, %esp
80105bef:	83 c4 04             	add    $0x4,%esp

80105bf2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bf2:	61                   	popa   
  popl %gs
80105bf3:	0f a9                	pop    %gs
  popl %fs
80105bf5:	0f a1                	pop    %fs
  popl %es
80105bf7:	07                   	pop    %es
  popl %ds
80105bf8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bf9:	83 c4 08             	add    $0x8,%esp
  iret
80105bfc:	cf                   	iret   
80105bfd:	66 90                	xchg   %ax,%ax
80105bff:	90                   	nop

80105c00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c01:	31 c0                	xor    %eax,%eax
{
80105c03:	89 e5                	mov    %esp,%ebp
80105c05:	83 ec 08             	sub    $0x8,%esp
80105c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c10:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c17:	c7 04 c5 e2 41 11 80 	movl   $0x8e000008,-0x7feebe1e(,%eax,8)
80105c1e:	08 00 00 8e 
80105c22:	66 89 14 c5 e0 41 11 	mov    %dx,-0x7feebe20(,%eax,8)
80105c29:	80 
80105c2a:	c1 ea 10             	shr    $0x10,%edx
80105c2d:	66 89 14 c5 e6 41 11 	mov    %dx,-0x7feebe1a(,%eax,8)
80105c34:	80 
  for(i = 0; i < 256; i++)
80105c35:	83 c0 01             	add    $0x1,%eax
80105c38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c3d:	75 d1                	jne    80105c10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c3f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c42:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c47:	c7 05 e2 43 11 80 08 	movl   $0xef000008,0x801143e2
80105c4e:	00 00 ef 
  initlock(&tickslock, "time");
80105c51:	68 b9 7c 10 80       	push   $0x80107cb9
80105c56:	68 a0 41 11 80       	push   $0x801141a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c5b:	66 a3 e0 43 11 80    	mov    %ax,0x801143e0
80105c61:	c1 e8 10             	shr    $0x10,%eax
80105c64:	66 a3 e6 43 11 80    	mov    %ax,0x801143e6
  initlock(&tickslock, "time");
80105c6a:	e8 01 eb ff ff       	call   80104770 <initlock>
}
80105c6f:	83 c4 10             	add    $0x10,%esp
80105c72:	c9                   	leave  
80105c73:	c3                   	ret    
80105c74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop

80105c80 <idtinit>:

void
idtinit(void)
{
80105c80:	55                   	push   %ebp
  pd[0] = size-1;
80105c81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c86:	89 e5                	mov    %esp,%ebp
80105c88:	83 ec 10             	sub    $0x10,%esp
80105c8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c8f:	b8 e0 41 11 80       	mov    $0x801141e0,%eax
80105c94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c98:	c1 e8 10             	shr    $0x10,%eax
80105c9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ca2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ca5:	c9                   	leave  
80105ca6:	c3                   	ret    
80105ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	57                   	push   %edi
80105cb4:	56                   	push   %esi
80105cb5:	53                   	push   %ebx
80105cb6:	83 ec 1c             	sub    $0x1c,%esp
80105cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cbc:	8b 43 30             	mov    0x30(%ebx),%eax
80105cbf:	83 f8 40             	cmp    $0x40,%eax
80105cc2:	0f 84 68 01 00 00    	je     80105e30 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cc8:	83 e8 20             	sub    $0x20,%eax
80105ccb:	83 f8 1f             	cmp    $0x1f,%eax
80105cce:	0f 87 8c 00 00 00    	ja     80105d60 <trap+0xb0>
80105cd4:	ff 24 85 60 7d 10 80 	jmp    *-0x7fef82a0(,%eax,4)
80105cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ce0:	e8 fb c8 ff ff       	call   801025e0 <ideintr>
    lapiceoi();
80105ce5:	e8 c6 cf ff ff       	call   80102cb0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cea:	e8 21 e0 ff ff       	call   80103d10 <myproc>
80105cef:	85 c0                	test   %eax,%eax
80105cf1:	74 1d                	je     80105d10 <trap+0x60>
80105cf3:	e8 18 e0 ff ff       	call   80103d10 <myproc>
80105cf8:	8b 50 24             	mov    0x24(%eax),%edx
80105cfb:	85 d2                	test   %edx,%edx
80105cfd:	74 11                	je     80105d10 <trap+0x60>
80105cff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d03:	83 e0 03             	and    $0x3,%eax
80105d06:	66 83 f8 03          	cmp    $0x3,%ax
80105d0a:	0f 84 e8 01 00 00    	je     80105ef8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d10:	e8 fb df ff ff       	call   80103d10 <myproc>
80105d15:	85 c0                	test   %eax,%eax
80105d17:	74 0f                	je     80105d28 <trap+0x78>
80105d19:	e8 f2 df ff ff       	call   80103d10 <myproc>
80105d1e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d22:	0f 84 b8 00 00 00    	je     80105de0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d28:	e8 e3 df ff ff       	call   80103d10 <myproc>
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	74 1d                	je     80105d4e <trap+0x9e>
80105d31:	e8 da df ff ff       	call   80103d10 <myproc>
80105d36:	8b 40 24             	mov    0x24(%eax),%eax
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 11                	je     80105d4e <trap+0x9e>
80105d3d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d41:	83 e0 03             	and    $0x3,%eax
80105d44:	66 83 f8 03          	cmp    $0x3,%ax
80105d48:	0f 84 0f 01 00 00    	je     80105e5d <trap+0x1ad>
    exit();
}
80105d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d51:	5b                   	pop    %ebx
80105d52:	5e                   	pop    %esi
80105d53:	5f                   	pop    %edi
80105d54:	5d                   	pop    %ebp
80105d55:	c3                   	ret    
80105d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d60:	e8 ab df ff ff       	call   80103d10 <myproc>
80105d65:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d68:	85 c0                	test   %eax,%eax
80105d6a:	0f 84 a2 01 00 00    	je     80105f12 <trap+0x262>
80105d70:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d74:	0f 84 98 01 00 00    	je     80105f12 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d7a:	0f 20 d1             	mov    %cr2,%ecx
80105d7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d80:	e8 6b df ff ff       	call   80103cf0 <cpuid>
80105d85:	8b 73 30             	mov    0x30(%ebx),%esi
80105d88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d8b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d91:	e8 7a df ff ff       	call   80103d10 <myproc>
80105d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d99:	e8 72 df ff ff       	call   80103d10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105da4:	51                   	push   %ecx
80105da5:	57                   	push   %edi
80105da6:	52                   	push   %edx
80105da7:	ff 75 e4             	push   -0x1c(%ebp)
80105daa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dab:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105db1:	56                   	push   %esi
80105db2:	ff 70 10             	push   0x10(%eax)
80105db5:	68 1c 7d 10 80       	push   $0x80107d1c
80105dba:	e8 51 aa ff ff       	call   80100810 <cprintf>
    myproc()->killed = 1;
80105dbf:	83 c4 20             	add    $0x20,%esp
80105dc2:	e8 49 df ff ff       	call   80103d10 <myproc>
80105dc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dce:	e8 3d df ff ff       	call   80103d10 <myproc>
80105dd3:	85 c0                	test   %eax,%eax
80105dd5:	0f 85 18 ff ff ff    	jne    80105cf3 <trap+0x43>
80105ddb:	e9 30 ff ff ff       	jmp    80105d10 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105de0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105de4:	0f 85 3e ff ff ff    	jne    80105d28 <trap+0x78>
    yield();
80105dea:	e8 a1 e5 ff ff       	call   80104390 <yield>
80105def:	e9 34 ff ff ff       	jmp    80105d28 <trap+0x78>
80105df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105df8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dfb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105dff:	e8 ec de ff ff       	call   80103cf0 <cpuid>
80105e04:	57                   	push   %edi
80105e05:	56                   	push   %esi
80105e06:	50                   	push   %eax
80105e07:	68 c4 7c 10 80       	push   $0x80107cc4
80105e0c:	e8 ff a9 ff ff       	call   80100810 <cprintf>
    lapiceoi();
80105e11:	e8 9a ce ff ff       	call   80102cb0 <lapiceoi>
    break;
80105e16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e19:	e8 f2 de ff ff       	call   80103d10 <myproc>
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	0f 85 cd fe ff ff    	jne    80105cf3 <trap+0x43>
80105e26:	e9 e5 fe ff ff       	jmp    80105d10 <trap+0x60>
80105e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
    if(myproc()->killed)
80105e30:	e8 db de ff ff       	call   80103d10 <myproc>
80105e35:	8b 70 24             	mov    0x24(%eax),%esi
80105e38:	85 f6                	test   %esi,%esi
80105e3a:	0f 85 c8 00 00 00    	jne    80105f08 <trap+0x258>
    myproc()->tf = tf;
80105e40:	e8 cb de ff ff       	call   80103d10 <myproc>
80105e45:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e48:	e8 b3 ef ff ff       	call   80104e00 <syscall>
    if(myproc()->killed)
80105e4d:	e8 be de ff ff       	call   80103d10 <myproc>
80105e52:	8b 48 24             	mov    0x24(%eax),%ecx
80105e55:	85 c9                	test   %ecx,%ecx
80105e57:	0f 84 f1 fe ff ff    	je     80105d4e <trap+0x9e>
}
80105e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e60:	5b                   	pop    %ebx
80105e61:	5e                   	pop    %esi
80105e62:	5f                   	pop    %edi
80105e63:	5d                   	pop    %ebp
      exit();
80105e64:	e9 c7 e2 ff ff       	jmp    80104130 <exit>
80105e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e70:	e8 3b 02 00 00       	call   801060b0 <uartintr>
    lapiceoi();
80105e75:	e8 36 ce ff ff       	call   80102cb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e7a:	e8 91 de ff ff       	call   80103d10 <myproc>
80105e7f:	85 c0                	test   %eax,%eax
80105e81:	0f 85 6c fe ff ff    	jne    80105cf3 <trap+0x43>
80105e87:	e9 84 fe ff ff       	jmp    80105d10 <trap+0x60>
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e90:	e8 db cc ff ff       	call   80102b70 <kbdintr>
    lapiceoi();
80105e95:	e8 16 ce ff ff       	call   80102cb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e9a:	e8 71 de ff ff       	call   80103d10 <myproc>
80105e9f:	85 c0                	test   %eax,%eax
80105ea1:	0f 85 4c fe ff ff    	jne    80105cf3 <trap+0x43>
80105ea7:	e9 64 fe ff ff       	jmp    80105d10 <trap+0x60>
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105eb0:	e8 3b de ff ff       	call   80103cf0 <cpuid>
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	0f 85 28 fe ff ff    	jne    80105ce5 <trap+0x35>
      acquire(&tickslock);
80105ebd:	83 ec 0c             	sub    $0xc,%esp
80105ec0:	68 a0 41 11 80       	push   $0x801141a0
80105ec5:	e8 76 ea ff ff       	call   80104940 <acquire>
      wakeup(&ticks);
80105eca:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
      ticks++;
80105ed1:	83 05 80 41 11 80 01 	addl   $0x1,0x80114180
      wakeup(&ticks);
80105ed8:	e8 c3 e5 ff ff       	call   801044a0 <wakeup>
      release(&tickslock);
80105edd:	c7 04 24 a0 41 11 80 	movl   $0x801141a0,(%esp)
80105ee4:	e8 f7 e9 ff ff       	call   801048e0 <release>
80105ee9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105eec:	e9 f4 fd ff ff       	jmp    80105ce5 <trap+0x35>
80105ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ef8:	e8 33 e2 ff ff       	call   80104130 <exit>
80105efd:	e9 0e fe ff ff       	jmp    80105d10 <trap+0x60>
80105f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f08:	e8 23 e2 ff ff       	call   80104130 <exit>
80105f0d:	e9 2e ff ff ff       	jmp    80105e40 <trap+0x190>
80105f12:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f15:	e8 d6 dd ff ff       	call   80103cf0 <cpuid>
80105f1a:	83 ec 0c             	sub    $0xc,%esp
80105f1d:	56                   	push   %esi
80105f1e:	57                   	push   %edi
80105f1f:	50                   	push   %eax
80105f20:	ff 73 30             	push   0x30(%ebx)
80105f23:	68 e8 7c 10 80       	push   $0x80107ce8
80105f28:	e8 e3 a8 ff ff       	call   80100810 <cprintf>
      panic("trap");
80105f2d:	83 c4 14             	add    $0x14,%esp
80105f30:	68 be 7c 10 80       	push   $0x80107cbe
80105f35:	e8 46 a4 ff ff       	call   80100380 <panic>
80105f3a:	66 90                	xchg   %ax,%ax
80105f3c:	66 90                	xchg   %ax,%ax
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f40:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80105f45:	85 c0                	test   %eax,%eax
80105f47:	74 17                	je     80105f60 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f49:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f4e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f4f:	a8 01                	test   $0x1,%al
80105f51:	74 0d                	je     80105f60 <uartgetc+0x20>
80105f53:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f58:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f59:	0f b6 c0             	movzbl %al,%eax
80105f5c:	c3                   	ret    
80105f5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f65:	c3                   	ret    
80105f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6d:	8d 76 00             	lea    0x0(%esi),%esi

80105f70 <uartinit>:
{
80105f70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f71:	31 c9                	xor    %ecx,%ecx
80105f73:	89 c8                	mov    %ecx,%eax
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	57                   	push   %edi
80105f78:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f7d:	56                   	push   %esi
80105f7e:	89 fa                	mov    %edi,%edx
80105f80:	53                   	push   %ebx
80105f81:	83 ec 1c             	sub    $0x1c,%esp
80105f84:	ee                   	out    %al,(%dx)
80105f85:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f8f:	89 f2                	mov    %esi,%edx
80105f91:	ee                   	out    %al,(%dx)
80105f92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9c:	ee                   	out    %al,(%dx)
80105f9d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fa2:	89 c8                	mov    %ecx,%eax
80105fa4:	89 da                	mov    %ebx,%edx
80105fa6:	ee                   	out    %al,(%dx)
80105fa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fac:	89 f2                	mov    %esi,%edx
80105fae:	ee                   	out    %al,(%dx)
80105faf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fb4:	89 c8                	mov    %ecx,%eax
80105fb6:	ee                   	out    %al,(%dx)
80105fb7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fbc:	89 da                	mov    %ebx,%edx
80105fbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fc4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fc5:	3c ff                	cmp    $0xff,%al
80105fc7:	74 78                	je     80106041 <uartinit+0xd1>
  uart = 1;
80105fc9:	c7 05 e0 49 11 80 01 	movl   $0x1,0x801149e0
80105fd0:	00 00 00 
80105fd3:	89 fa                	mov    %edi,%edx
80105fd5:	ec                   	in     (%dx),%al
80105fd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fdc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fdf:	bf e0 7d 10 80       	mov    $0x80107de0,%edi
80105fe4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105fe9:	6a 00                	push   $0x0
80105feb:	6a 04                	push   $0x4
80105fed:	e8 2e c8 ff ff       	call   80102820 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ff2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105ff6:	83 c4 10             	add    $0x10,%esp
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106000:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80106005:	bb 80 00 00 00       	mov    $0x80,%ebx
8010600a:	85 c0                	test   %eax,%eax
8010600c:	75 14                	jne    80106022 <uartinit+0xb2>
8010600e:	eb 23                	jmp    80106033 <uartinit+0xc3>
    microdelay(10);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	6a 0a                	push   $0xa
80106015:	e8 b6 cc ff ff       	call   80102cd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	83 eb 01             	sub    $0x1,%ebx
80106020:	74 07                	je     80106029 <uartinit+0xb9>
80106022:	89 f2                	mov    %esi,%edx
80106024:	ec                   	in     (%dx),%al
80106025:	a8 20                	test   $0x20,%al
80106027:	74 e7                	je     80106010 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106029:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010602d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106032:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106033:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106037:	83 c7 01             	add    $0x1,%edi
8010603a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010603d:	84 c0                	test   %al,%al
8010603f:	75 bf                	jne    80106000 <uartinit+0x90>
}
80106041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106044:	5b                   	pop    %ebx
80106045:	5e                   	pop    %esi
80106046:	5f                   	pop    %edi
80106047:	5d                   	pop    %ebp
80106048:	c3                   	ret    
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106050 <uartputc>:
  if(!uart)
80106050:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80106055:	85 c0                	test   %eax,%eax
80106057:	74 47                	je     801060a0 <uartputc+0x50>
{
80106059:	55                   	push   %ebp
8010605a:	89 e5                	mov    %esp,%ebp
8010605c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010605d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106062:	53                   	push   %ebx
80106063:	bb 80 00 00 00       	mov    $0x80,%ebx
80106068:	eb 18                	jmp    80106082 <uartputc+0x32>
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	6a 0a                	push   $0xa
80106075:	e8 56 cc ff ff       	call   80102cd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	83 eb 01             	sub    $0x1,%ebx
80106080:	74 07                	je     80106089 <uartputc+0x39>
80106082:	89 f2                	mov    %esi,%edx
80106084:	ec                   	in     (%dx),%al
80106085:	a8 20                	test   $0x20,%al
80106087:	74 e7                	je     80106070 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106089:	8b 45 08             	mov    0x8(%ebp),%eax
8010608c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106091:	ee                   	out    %al,(%dx)
}
80106092:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106095:	5b                   	pop    %ebx
80106096:	5e                   	pop    %esi
80106097:	5d                   	pop    %ebp
80106098:	c3                   	ret    
80106099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060a0:	c3                   	ret    
801060a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop

801060b0 <uartintr>:

void
uartintr(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060b6:	68 40 5f 10 80       	push   $0x80105f40
801060bb:	e8 10 aa ff ff       	call   80100ad0 <consoleintr>
}
801060c0:	83 c4 10             	add    $0x10,%esp
801060c3:	c9                   	leave  
801060c4:	c3                   	ret    

801060c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $0
801060c7:	6a 00                	push   $0x0
  jmp alltraps
801060c9:	e9 0c fb ff ff       	jmp    80105bda <alltraps>

801060ce <vector1>:
.globl vector1
vector1:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $1
801060d0:	6a 01                	push   $0x1
  jmp alltraps
801060d2:	e9 03 fb ff ff       	jmp    80105bda <alltraps>

801060d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $2
801060d9:	6a 02                	push   $0x2
  jmp alltraps
801060db:	e9 fa fa ff ff       	jmp    80105bda <alltraps>

801060e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $3
801060e2:	6a 03                	push   $0x3
  jmp alltraps
801060e4:	e9 f1 fa ff ff       	jmp    80105bda <alltraps>

801060e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $4
801060eb:	6a 04                	push   $0x4
  jmp alltraps
801060ed:	e9 e8 fa ff ff       	jmp    80105bda <alltraps>

801060f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $5
801060f4:	6a 05                	push   $0x5
  jmp alltraps
801060f6:	e9 df fa ff ff       	jmp    80105bda <alltraps>

801060fb <vector6>:
.globl vector6
vector6:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $6
801060fd:	6a 06                	push   $0x6
  jmp alltraps
801060ff:	e9 d6 fa ff ff       	jmp    80105bda <alltraps>

80106104 <vector7>:
.globl vector7
vector7:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $7
80106106:	6a 07                	push   $0x7
  jmp alltraps
80106108:	e9 cd fa ff ff       	jmp    80105bda <alltraps>

8010610d <vector8>:
.globl vector8
vector8:
  pushl $8
8010610d:	6a 08                	push   $0x8
  jmp alltraps
8010610f:	e9 c6 fa ff ff       	jmp    80105bda <alltraps>

80106114 <vector9>:
.globl vector9
vector9:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $9
80106116:	6a 09                	push   $0x9
  jmp alltraps
80106118:	e9 bd fa ff ff       	jmp    80105bda <alltraps>

8010611d <vector10>:
.globl vector10
vector10:
  pushl $10
8010611d:	6a 0a                	push   $0xa
  jmp alltraps
8010611f:	e9 b6 fa ff ff       	jmp    80105bda <alltraps>

80106124 <vector11>:
.globl vector11
vector11:
  pushl $11
80106124:	6a 0b                	push   $0xb
  jmp alltraps
80106126:	e9 af fa ff ff       	jmp    80105bda <alltraps>

8010612b <vector12>:
.globl vector12
vector12:
  pushl $12
8010612b:	6a 0c                	push   $0xc
  jmp alltraps
8010612d:	e9 a8 fa ff ff       	jmp    80105bda <alltraps>

80106132 <vector13>:
.globl vector13
vector13:
  pushl $13
80106132:	6a 0d                	push   $0xd
  jmp alltraps
80106134:	e9 a1 fa ff ff       	jmp    80105bda <alltraps>

80106139 <vector14>:
.globl vector14
vector14:
  pushl $14
80106139:	6a 0e                	push   $0xe
  jmp alltraps
8010613b:	e9 9a fa ff ff       	jmp    80105bda <alltraps>

80106140 <vector15>:
.globl vector15
vector15:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $15
80106142:	6a 0f                	push   $0xf
  jmp alltraps
80106144:	e9 91 fa ff ff       	jmp    80105bda <alltraps>

80106149 <vector16>:
.globl vector16
vector16:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $16
8010614b:	6a 10                	push   $0x10
  jmp alltraps
8010614d:	e9 88 fa ff ff       	jmp    80105bda <alltraps>

80106152 <vector17>:
.globl vector17
vector17:
  pushl $17
80106152:	6a 11                	push   $0x11
  jmp alltraps
80106154:	e9 81 fa ff ff       	jmp    80105bda <alltraps>

80106159 <vector18>:
.globl vector18
vector18:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $18
8010615b:	6a 12                	push   $0x12
  jmp alltraps
8010615d:	e9 78 fa ff ff       	jmp    80105bda <alltraps>

80106162 <vector19>:
.globl vector19
vector19:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $19
80106164:	6a 13                	push   $0x13
  jmp alltraps
80106166:	e9 6f fa ff ff       	jmp    80105bda <alltraps>

8010616b <vector20>:
.globl vector20
vector20:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $20
8010616d:	6a 14                	push   $0x14
  jmp alltraps
8010616f:	e9 66 fa ff ff       	jmp    80105bda <alltraps>

80106174 <vector21>:
.globl vector21
vector21:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $21
80106176:	6a 15                	push   $0x15
  jmp alltraps
80106178:	e9 5d fa ff ff       	jmp    80105bda <alltraps>

8010617d <vector22>:
.globl vector22
vector22:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $22
8010617f:	6a 16                	push   $0x16
  jmp alltraps
80106181:	e9 54 fa ff ff       	jmp    80105bda <alltraps>

80106186 <vector23>:
.globl vector23
vector23:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $23
80106188:	6a 17                	push   $0x17
  jmp alltraps
8010618a:	e9 4b fa ff ff       	jmp    80105bda <alltraps>

8010618f <vector24>:
.globl vector24
vector24:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $24
80106191:	6a 18                	push   $0x18
  jmp alltraps
80106193:	e9 42 fa ff ff       	jmp    80105bda <alltraps>

80106198 <vector25>:
.globl vector25
vector25:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $25
8010619a:	6a 19                	push   $0x19
  jmp alltraps
8010619c:	e9 39 fa ff ff       	jmp    80105bda <alltraps>

801061a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $26
801061a3:	6a 1a                	push   $0x1a
  jmp alltraps
801061a5:	e9 30 fa ff ff       	jmp    80105bda <alltraps>

801061aa <vector27>:
.globl vector27
vector27:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $27
801061ac:	6a 1b                	push   $0x1b
  jmp alltraps
801061ae:	e9 27 fa ff ff       	jmp    80105bda <alltraps>

801061b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $28
801061b5:	6a 1c                	push   $0x1c
  jmp alltraps
801061b7:	e9 1e fa ff ff       	jmp    80105bda <alltraps>

801061bc <vector29>:
.globl vector29
vector29:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $29
801061be:	6a 1d                	push   $0x1d
  jmp alltraps
801061c0:	e9 15 fa ff ff       	jmp    80105bda <alltraps>

801061c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $30
801061c7:	6a 1e                	push   $0x1e
  jmp alltraps
801061c9:	e9 0c fa ff ff       	jmp    80105bda <alltraps>

801061ce <vector31>:
.globl vector31
vector31:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $31
801061d0:	6a 1f                	push   $0x1f
  jmp alltraps
801061d2:	e9 03 fa ff ff       	jmp    80105bda <alltraps>

801061d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $32
801061d9:	6a 20                	push   $0x20
  jmp alltraps
801061db:	e9 fa f9 ff ff       	jmp    80105bda <alltraps>

801061e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $33
801061e2:	6a 21                	push   $0x21
  jmp alltraps
801061e4:	e9 f1 f9 ff ff       	jmp    80105bda <alltraps>

801061e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $34
801061eb:	6a 22                	push   $0x22
  jmp alltraps
801061ed:	e9 e8 f9 ff ff       	jmp    80105bda <alltraps>

801061f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $35
801061f4:	6a 23                	push   $0x23
  jmp alltraps
801061f6:	e9 df f9 ff ff       	jmp    80105bda <alltraps>

801061fb <vector36>:
.globl vector36
vector36:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $36
801061fd:	6a 24                	push   $0x24
  jmp alltraps
801061ff:	e9 d6 f9 ff ff       	jmp    80105bda <alltraps>

80106204 <vector37>:
.globl vector37
vector37:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $37
80106206:	6a 25                	push   $0x25
  jmp alltraps
80106208:	e9 cd f9 ff ff       	jmp    80105bda <alltraps>

8010620d <vector38>:
.globl vector38
vector38:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $38
8010620f:	6a 26                	push   $0x26
  jmp alltraps
80106211:	e9 c4 f9 ff ff       	jmp    80105bda <alltraps>

80106216 <vector39>:
.globl vector39
vector39:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $39
80106218:	6a 27                	push   $0x27
  jmp alltraps
8010621a:	e9 bb f9 ff ff       	jmp    80105bda <alltraps>

8010621f <vector40>:
.globl vector40
vector40:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $40
80106221:	6a 28                	push   $0x28
  jmp alltraps
80106223:	e9 b2 f9 ff ff       	jmp    80105bda <alltraps>

80106228 <vector41>:
.globl vector41
vector41:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $41
8010622a:	6a 29                	push   $0x29
  jmp alltraps
8010622c:	e9 a9 f9 ff ff       	jmp    80105bda <alltraps>

80106231 <vector42>:
.globl vector42
vector42:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $42
80106233:	6a 2a                	push   $0x2a
  jmp alltraps
80106235:	e9 a0 f9 ff ff       	jmp    80105bda <alltraps>

8010623a <vector43>:
.globl vector43
vector43:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $43
8010623c:	6a 2b                	push   $0x2b
  jmp alltraps
8010623e:	e9 97 f9 ff ff       	jmp    80105bda <alltraps>

80106243 <vector44>:
.globl vector44
vector44:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $44
80106245:	6a 2c                	push   $0x2c
  jmp alltraps
80106247:	e9 8e f9 ff ff       	jmp    80105bda <alltraps>

8010624c <vector45>:
.globl vector45
vector45:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $45
8010624e:	6a 2d                	push   $0x2d
  jmp alltraps
80106250:	e9 85 f9 ff ff       	jmp    80105bda <alltraps>

80106255 <vector46>:
.globl vector46
vector46:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $46
80106257:	6a 2e                	push   $0x2e
  jmp alltraps
80106259:	e9 7c f9 ff ff       	jmp    80105bda <alltraps>

8010625e <vector47>:
.globl vector47
vector47:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $47
80106260:	6a 2f                	push   $0x2f
  jmp alltraps
80106262:	e9 73 f9 ff ff       	jmp    80105bda <alltraps>

80106267 <vector48>:
.globl vector48
vector48:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $48
80106269:	6a 30                	push   $0x30
  jmp alltraps
8010626b:	e9 6a f9 ff ff       	jmp    80105bda <alltraps>

80106270 <vector49>:
.globl vector49
vector49:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $49
80106272:	6a 31                	push   $0x31
  jmp alltraps
80106274:	e9 61 f9 ff ff       	jmp    80105bda <alltraps>

80106279 <vector50>:
.globl vector50
vector50:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $50
8010627b:	6a 32                	push   $0x32
  jmp alltraps
8010627d:	e9 58 f9 ff ff       	jmp    80105bda <alltraps>

80106282 <vector51>:
.globl vector51
vector51:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $51
80106284:	6a 33                	push   $0x33
  jmp alltraps
80106286:	e9 4f f9 ff ff       	jmp    80105bda <alltraps>

8010628b <vector52>:
.globl vector52
vector52:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $52
8010628d:	6a 34                	push   $0x34
  jmp alltraps
8010628f:	e9 46 f9 ff ff       	jmp    80105bda <alltraps>

80106294 <vector53>:
.globl vector53
vector53:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $53
80106296:	6a 35                	push   $0x35
  jmp alltraps
80106298:	e9 3d f9 ff ff       	jmp    80105bda <alltraps>

8010629d <vector54>:
.globl vector54
vector54:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $54
8010629f:	6a 36                	push   $0x36
  jmp alltraps
801062a1:	e9 34 f9 ff ff       	jmp    80105bda <alltraps>

801062a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $55
801062a8:	6a 37                	push   $0x37
  jmp alltraps
801062aa:	e9 2b f9 ff ff       	jmp    80105bda <alltraps>

801062af <vector56>:
.globl vector56
vector56:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $56
801062b1:	6a 38                	push   $0x38
  jmp alltraps
801062b3:	e9 22 f9 ff ff       	jmp    80105bda <alltraps>

801062b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $57
801062ba:	6a 39                	push   $0x39
  jmp alltraps
801062bc:	e9 19 f9 ff ff       	jmp    80105bda <alltraps>

801062c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $58
801062c3:	6a 3a                	push   $0x3a
  jmp alltraps
801062c5:	e9 10 f9 ff ff       	jmp    80105bda <alltraps>

801062ca <vector59>:
.globl vector59
vector59:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $59
801062cc:	6a 3b                	push   $0x3b
  jmp alltraps
801062ce:	e9 07 f9 ff ff       	jmp    80105bda <alltraps>

801062d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $60
801062d5:	6a 3c                	push   $0x3c
  jmp alltraps
801062d7:	e9 fe f8 ff ff       	jmp    80105bda <alltraps>

801062dc <vector61>:
.globl vector61
vector61:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $61
801062de:	6a 3d                	push   $0x3d
  jmp alltraps
801062e0:	e9 f5 f8 ff ff       	jmp    80105bda <alltraps>

801062e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $62
801062e7:	6a 3e                	push   $0x3e
  jmp alltraps
801062e9:	e9 ec f8 ff ff       	jmp    80105bda <alltraps>

801062ee <vector63>:
.globl vector63
vector63:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $63
801062f0:	6a 3f                	push   $0x3f
  jmp alltraps
801062f2:	e9 e3 f8 ff ff       	jmp    80105bda <alltraps>

801062f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $64
801062f9:	6a 40                	push   $0x40
  jmp alltraps
801062fb:	e9 da f8 ff ff       	jmp    80105bda <alltraps>

80106300 <vector65>:
.globl vector65
vector65:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $65
80106302:	6a 41                	push   $0x41
  jmp alltraps
80106304:	e9 d1 f8 ff ff       	jmp    80105bda <alltraps>

80106309 <vector66>:
.globl vector66
vector66:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $66
8010630b:	6a 42                	push   $0x42
  jmp alltraps
8010630d:	e9 c8 f8 ff ff       	jmp    80105bda <alltraps>

80106312 <vector67>:
.globl vector67
vector67:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $67
80106314:	6a 43                	push   $0x43
  jmp alltraps
80106316:	e9 bf f8 ff ff       	jmp    80105bda <alltraps>

8010631b <vector68>:
.globl vector68
vector68:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $68
8010631d:	6a 44                	push   $0x44
  jmp alltraps
8010631f:	e9 b6 f8 ff ff       	jmp    80105bda <alltraps>

80106324 <vector69>:
.globl vector69
vector69:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $69
80106326:	6a 45                	push   $0x45
  jmp alltraps
80106328:	e9 ad f8 ff ff       	jmp    80105bda <alltraps>

8010632d <vector70>:
.globl vector70
vector70:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $70
8010632f:	6a 46                	push   $0x46
  jmp alltraps
80106331:	e9 a4 f8 ff ff       	jmp    80105bda <alltraps>

80106336 <vector71>:
.globl vector71
vector71:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $71
80106338:	6a 47                	push   $0x47
  jmp alltraps
8010633a:	e9 9b f8 ff ff       	jmp    80105bda <alltraps>

8010633f <vector72>:
.globl vector72
vector72:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $72
80106341:	6a 48                	push   $0x48
  jmp alltraps
80106343:	e9 92 f8 ff ff       	jmp    80105bda <alltraps>

80106348 <vector73>:
.globl vector73
vector73:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $73
8010634a:	6a 49                	push   $0x49
  jmp alltraps
8010634c:	e9 89 f8 ff ff       	jmp    80105bda <alltraps>

80106351 <vector74>:
.globl vector74
vector74:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $74
80106353:	6a 4a                	push   $0x4a
  jmp alltraps
80106355:	e9 80 f8 ff ff       	jmp    80105bda <alltraps>

8010635a <vector75>:
.globl vector75
vector75:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $75
8010635c:	6a 4b                	push   $0x4b
  jmp alltraps
8010635e:	e9 77 f8 ff ff       	jmp    80105bda <alltraps>

80106363 <vector76>:
.globl vector76
vector76:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $76
80106365:	6a 4c                	push   $0x4c
  jmp alltraps
80106367:	e9 6e f8 ff ff       	jmp    80105bda <alltraps>

8010636c <vector77>:
.globl vector77
vector77:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $77
8010636e:	6a 4d                	push   $0x4d
  jmp alltraps
80106370:	e9 65 f8 ff ff       	jmp    80105bda <alltraps>

80106375 <vector78>:
.globl vector78
vector78:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $78
80106377:	6a 4e                	push   $0x4e
  jmp alltraps
80106379:	e9 5c f8 ff ff       	jmp    80105bda <alltraps>

8010637e <vector79>:
.globl vector79
vector79:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $79
80106380:	6a 4f                	push   $0x4f
  jmp alltraps
80106382:	e9 53 f8 ff ff       	jmp    80105bda <alltraps>

80106387 <vector80>:
.globl vector80
vector80:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $80
80106389:	6a 50                	push   $0x50
  jmp alltraps
8010638b:	e9 4a f8 ff ff       	jmp    80105bda <alltraps>

80106390 <vector81>:
.globl vector81
vector81:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $81
80106392:	6a 51                	push   $0x51
  jmp alltraps
80106394:	e9 41 f8 ff ff       	jmp    80105bda <alltraps>

80106399 <vector82>:
.globl vector82
vector82:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $82
8010639b:	6a 52                	push   $0x52
  jmp alltraps
8010639d:	e9 38 f8 ff ff       	jmp    80105bda <alltraps>

801063a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $83
801063a4:	6a 53                	push   $0x53
  jmp alltraps
801063a6:	e9 2f f8 ff ff       	jmp    80105bda <alltraps>

801063ab <vector84>:
.globl vector84
vector84:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $84
801063ad:	6a 54                	push   $0x54
  jmp alltraps
801063af:	e9 26 f8 ff ff       	jmp    80105bda <alltraps>

801063b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $85
801063b6:	6a 55                	push   $0x55
  jmp alltraps
801063b8:	e9 1d f8 ff ff       	jmp    80105bda <alltraps>

801063bd <vector86>:
.globl vector86
vector86:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $86
801063bf:	6a 56                	push   $0x56
  jmp alltraps
801063c1:	e9 14 f8 ff ff       	jmp    80105bda <alltraps>

801063c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $87
801063c8:	6a 57                	push   $0x57
  jmp alltraps
801063ca:	e9 0b f8 ff ff       	jmp    80105bda <alltraps>

801063cf <vector88>:
.globl vector88
vector88:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $88
801063d1:	6a 58                	push   $0x58
  jmp alltraps
801063d3:	e9 02 f8 ff ff       	jmp    80105bda <alltraps>

801063d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $89
801063da:	6a 59                	push   $0x59
  jmp alltraps
801063dc:	e9 f9 f7 ff ff       	jmp    80105bda <alltraps>

801063e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $90
801063e3:	6a 5a                	push   $0x5a
  jmp alltraps
801063e5:	e9 f0 f7 ff ff       	jmp    80105bda <alltraps>

801063ea <vector91>:
.globl vector91
vector91:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $91
801063ec:	6a 5b                	push   $0x5b
  jmp alltraps
801063ee:	e9 e7 f7 ff ff       	jmp    80105bda <alltraps>

801063f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $92
801063f5:	6a 5c                	push   $0x5c
  jmp alltraps
801063f7:	e9 de f7 ff ff       	jmp    80105bda <alltraps>

801063fc <vector93>:
.globl vector93
vector93:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $93
801063fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106400:	e9 d5 f7 ff ff       	jmp    80105bda <alltraps>

80106405 <vector94>:
.globl vector94
vector94:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $94
80106407:	6a 5e                	push   $0x5e
  jmp alltraps
80106409:	e9 cc f7 ff ff       	jmp    80105bda <alltraps>

8010640e <vector95>:
.globl vector95
vector95:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $95
80106410:	6a 5f                	push   $0x5f
  jmp alltraps
80106412:	e9 c3 f7 ff ff       	jmp    80105bda <alltraps>

80106417 <vector96>:
.globl vector96
vector96:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $96
80106419:	6a 60                	push   $0x60
  jmp alltraps
8010641b:	e9 ba f7 ff ff       	jmp    80105bda <alltraps>

80106420 <vector97>:
.globl vector97
vector97:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $97
80106422:	6a 61                	push   $0x61
  jmp alltraps
80106424:	e9 b1 f7 ff ff       	jmp    80105bda <alltraps>

80106429 <vector98>:
.globl vector98
vector98:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $98
8010642b:	6a 62                	push   $0x62
  jmp alltraps
8010642d:	e9 a8 f7 ff ff       	jmp    80105bda <alltraps>

80106432 <vector99>:
.globl vector99
vector99:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $99
80106434:	6a 63                	push   $0x63
  jmp alltraps
80106436:	e9 9f f7 ff ff       	jmp    80105bda <alltraps>

8010643b <vector100>:
.globl vector100
vector100:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $100
8010643d:	6a 64                	push   $0x64
  jmp alltraps
8010643f:	e9 96 f7 ff ff       	jmp    80105bda <alltraps>

80106444 <vector101>:
.globl vector101
vector101:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $101
80106446:	6a 65                	push   $0x65
  jmp alltraps
80106448:	e9 8d f7 ff ff       	jmp    80105bda <alltraps>

8010644d <vector102>:
.globl vector102
vector102:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $102
8010644f:	6a 66                	push   $0x66
  jmp alltraps
80106451:	e9 84 f7 ff ff       	jmp    80105bda <alltraps>

80106456 <vector103>:
.globl vector103
vector103:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $103
80106458:	6a 67                	push   $0x67
  jmp alltraps
8010645a:	e9 7b f7 ff ff       	jmp    80105bda <alltraps>

8010645f <vector104>:
.globl vector104
vector104:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $104
80106461:	6a 68                	push   $0x68
  jmp alltraps
80106463:	e9 72 f7 ff ff       	jmp    80105bda <alltraps>

80106468 <vector105>:
.globl vector105
vector105:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $105
8010646a:	6a 69                	push   $0x69
  jmp alltraps
8010646c:	e9 69 f7 ff ff       	jmp    80105bda <alltraps>

80106471 <vector106>:
.globl vector106
vector106:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $106
80106473:	6a 6a                	push   $0x6a
  jmp alltraps
80106475:	e9 60 f7 ff ff       	jmp    80105bda <alltraps>

8010647a <vector107>:
.globl vector107
vector107:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $107
8010647c:	6a 6b                	push   $0x6b
  jmp alltraps
8010647e:	e9 57 f7 ff ff       	jmp    80105bda <alltraps>

80106483 <vector108>:
.globl vector108
vector108:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $108
80106485:	6a 6c                	push   $0x6c
  jmp alltraps
80106487:	e9 4e f7 ff ff       	jmp    80105bda <alltraps>

8010648c <vector109>:
.globl vector109
vector109:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $109
8010648e:	6a 6d                	push   $0x6d
  jmp alltraps
80106490:	e9 45 f7 ff ff       	jmp    80105bda <alltraps>

80106495 <vector110>:
.globl vector110
vector110:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $110
80106497:	6a 6e                	push   $0x6e
  jmp alltraps
80106499:	e9 3c f7 ff ff       	jmp    80105bda <alltraps>

8010649e <vector111>:
.globl vector111
vector111:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $111
801064a0:	6a 6f                	push   $0x6f
  jmp alltraps
801064a2:	e9 33 f7 ff ff       	jmp    80105bda <alltraps>

801064a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $112
801064a9:	6a 70                	push   $0x70
  jmp alltraps
801064ab:	e9 2a f7 ff ff       	jmp    80105bda <alltraps>

801064b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $113
801064b2:	6a 71                	push   $0x71
  jmp alltraps
801064b4:	e9 21 f7 ff ff       	jmp    80105bda <alltraps>

801064b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $114
801064bb:	6a 72                	push   $0x72
  jmp alltraps
801064bd:	e9 18 f7 ff ff       	jmp    80105bda <alltraps>

801064c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $115
801064c4:	6a 73                	push   $0x73
  jmp alltraps
801064c6:	e9 0f f7 ff ff       	jmp    80105bda <alltraps>

801064cb <vector116>:
.globl vector116
vector116:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $116
801064cd:	6a 74                	push   $0x74
  jmp alltraps
801064cf:	e9 06 f7 ff ff       	jmp    80105bda <alltraps>

801064d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $117
801064d6:	6a 75                	push   $0x75
  jmp alltraps
801064d8:	e9 fd f6 ff ff       	jmp    80105bda <alltraps>

801064dd <vector118>:
.globl vector118
vector118:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $118
801064df:	6a 76                	push   $0x76
  jmp alltraps
801064e1:	e9 f4 f6 ff ff       	jmp    80105bda <alltraps>

801064e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $119
801064e8:	6a 77                	push   $0x77
  jmp alltraps
801064ea:	e9 eb f6 ff ff       	jmp    80105bda <alltraps>

801064ef <vector120>:
.globl vector120
vector120:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $120
801064f1:	6a 78                	push   $0x78
  jmp alltraps
801064f3:	e9 e2 f6 ff ff       	jmp    80105bda <alltraps>

801064f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $121
801064fa:	6a 79                	push   $0x79
  jmp alltraps
801064fc:	e9 d9 f6 ff ff       	jmp    80105bda <alltraps>

80106501 <vector122>:
.globl vector122
vector122:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $122
80106503:	6a 7a                	push   $0x7a
  jmp alltraps
80106505:	e9 d0 f6 ff ff       	jmp    80105bda <alltraps>

8010650a <vector123>:
.globl vector123
vector123:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $123
8010650c:	6a 7b                	push   $0x7b
  jmp alltraps
8010650e:	e9 c7 f6 ff ff       	jmp    80105bda <alltraps>

80106513 <vector124>:
.globl vector124
vector124:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $124
80106515:	6a 7c                	push   $0x7c
  jmp alltraps
80106517:	e9 be f6 ff ff       	jmp    80105bda <alltraps>

8010651c <vector125>:
.globl vector125
vector125:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $125
8010651e:	6a 7d                	push   $0x7d
  jmp alltraps
80106520:	e9 b5 f6 ff ff       	jmp    80105bda <alltraps>

80106525 <vector126>:
.globl vector126
vector126:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $126
80106527:	6a 7e                	push   $0x7e
  jmp alltraps
80106529:	e9 ac f6 ff ff       	jmp    80105bda <alltraps>

8010652e <vector127>:
.globl vector127
vector127:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $127
80106530:	6a 7f                	push   $0x7f
  jmp alltraps
80106532:	e9 a3 f6 ff ff       	jmp    80105bda <alltraps>

80106537 <vector128>:
.globl vector128
vector128:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $128
80106539:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010653e:	e9 97 f6 ff ff       	jmp    80105bda <alltraps>

80106543 <vector129>:
.globl vector129
vector129:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $129
80106545:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010654a:	e9 8b f6 ff ff       	jmp    80105bda <alltraps>

8010654f <vector130>:
.globl vector130
vector130:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $130
80106551:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106556:	e9 7f f6 ff ff       	jmp    80105bda <alltraps>

8010655b <vector131>:
.globl vector131
vector131:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $131
8010655d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106562:	e9 73 f6 ff ff       	jmp    80105bda <alltraps>

80106567 <vector132>:
.globl vector132
vector132:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $132
80106569:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010656e:	e9 67 f6 ff ff       	jmp    80105bda <alltraps>

80106573 <vector133>:
.globl vector133
vector133:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $133
80106575:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010657a:	e9 5b f6 ff ff       	jmp    80105bda <alltraps>

8010657f <vector134>:
.globl vector134
vector134:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $134
80106581:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106586:	e9 4f f6 ff ff       	jmp    80105bda <alltraps>

8010658b <vector135>:
.globl vector135
vector135:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $135
8010658d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106592:	e9 43 f6 ff ff       	jmp    80105bda <alltraps>

80106597 <vector136>:
.globl vector136
vector136:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $136
80106599:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010659e:	e9 37 f6 ff ff       	jmp    80105bda <alltraps>

801065a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $137
801065a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065aa:	e9 2b f6 ff ff       	jmp    80105bda <alltraps>

801065af <vector138>:
.globl vector138
vector138:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $138
801065b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065b6:	e9 1f f6 ff ff       	jmp    80105bda <alltraps>

801065bb <vector139>:
.globl vector139
vector139:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $139
801065bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065c2:	e9 13 f6 ff ff       	jmp    80105bda <alltraps>

801065c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $140
801065c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065ce:	e9 07 f6 ff ff       	jmp    80105bda <alltraps>

801065d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $141
801065d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065da:	e9 fb f5 ff ff       	jmp    80105bda <alltraps>

801065df <vector142>:
.globl vector142
vector142:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $142
801065e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801065e6:	e9 ef f5 ff ff       	jmp    80105bda <alltraps>

801065eb <vector143>:
.globl vector143
vector143:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $143
801065ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065f2:	e9 e3 f5 ff ff       	jmp    80105bda <alltraps>

801065f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $144
801065f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065fe:	e9 d7 f5 ff ff       	jmp    80105bda <alltraps>

80106603 <vector145>:
.globl vector145
vector145:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $145
80106605:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010660a:	e9 cb f5 ff ff       	jmp    80105bda <alltraps>

8010660f <vector146>:
.globl vector146
vector146:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $146
80106611:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106616:	e9 bf f5 ff ff       	jmp    80105bda <alltraps>

8010661b <vector147>:
.globl vector147
vector147:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $147
8010661d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106622:	e9 b3 f5 ff ff       	jmp    80105bda <alltraps>

80106627 <vector148>:
.globl vector148
vector148:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $148
80106629:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010662e:	e9 a7 f5 ff ff       	jmp    80105bda <alltraps>

80106633 <vector149>:
.globl vector149
vector149:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $149
80106635:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010663a:	e9 9b f5 ff ff       	jmp    80105bda <alltraps>

8010663f <vector150>:
.globl vector150
vector150:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $150
80106641:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106646:	e9 8f f5 ff ff       	jmp    80105bda <alltraps>

8010664b <vector151>:
.globl vector151
vector151:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $151
8010664d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106652:	e9 83 f5 ff ff       	jmp    80105bda <alltraps>

80106657 <vector152>:
.globl vector152
vector152:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $152
80106659:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010665e:	e9 77 f5 ff ff       	jmp    80105bda <alltraps>

80106663 <vector153>:
.globl vector153
vector153:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $153
80106665:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010666a:	e9 6b f5 ff ff       	jmp    80105bda <alltraps>

8010666f <vector154>:
.globl vector154
vector154:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $154
80106671:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106676:	e9 5f f5 ff ff       	jmp    80105bda <alltraps>

8010667b <vector155>:
.globl vector155
vector155:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $155
8010667d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106682:	e9 53 f5 ff ff       	jmp    80105bda <alltraps>

80106687 <vector156>:
.globl vector156
vector156:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $156
80106689:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010668e:	e9 47 f5 ff ff       	jmp    80105bda <alltraps>

80106693 <vector157>:
.globl vector157
vector157:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $157
80106695:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010669a:	e9 3b f5 ff ff       	jmp    80105bda <alltraps>

8010669f <vector158>:
.globl vector158
vector158:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $158
801066a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066a6:	e9 2f f5 ff ff       	jmp    80105bda <alltraps>

801066ab <vector159>:
.globl vector159
vector159:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $159
801066ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066b2:	e9 23 f5 ff ff       	jmp    80105bda <alltraps>

801066b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $160
801066b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066be:	e9 17 f5 ff ff       	jmp    80105bda <alltraps>

801066c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $161
801066c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066ca:	e9 0b f5 ff ff       	jmp    80105bda <alltraps>

801066cf <vector162>:
.globl vector162
vector162:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $162
801066d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066d6:	e9 ff f4 ff ff       	jmp    80105bda <alltraps>

801066db <vector163>:
.globl vector163
vector163:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $163
801066dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801066e2:	e9 f3 f4 ff ff       	jmp    80105bda <alltraps>

801066e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $164
801066e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066ee:	e9 e7 f4 ff ff       	jmp    80105bda <alltraps>

801066f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $165
801066f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066fa:	e9 db f4 ff ff       	jmp    80105bda <alltraps>

801066ff <vector166>:
.globl vector166
vector166:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $166
80106701:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106706:	e9 cf f4 ff ff       	jmp    80105bda <alltraps>

8010670b <vector167>:
.globl vector167
vector167:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $167
8010670d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106712:	e9 c3 f4 ff ff       	jmp    80105bda <alltraps>

80106717 <vector168>:
.globl vector168
vector168:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $168
80106719:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010671e:	e9 b7 f4 ff ff       	jmp    80105bda <alltraps>

80106723 <vector169>:
.globl vector169
vector169:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $169
80106725:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010672a:	e9 ab f4 ff ff       	jmp    80105bda <alltraps>

8010672f <vector170>:
.globl vector170
vector170:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $170
80106731:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106736:	e9 9f f4 ff ff       	jmp    80105bda <alltraps>

8010673b <vector171>:
.globl vector171
vector171:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $171
8010673d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106742:	e9 93 f4 ff ff       	jmp    80105bda <alltraps>

80106747 <vector172>:
.globl vector172
vector172:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $172
80106749:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010674e:	e9 87 f4 ff ff       	jmp    80105bda <alltraps>

80106753 <vector173>:
.globl vector173
vector173:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $173
80106755:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010675a:	e9 7b f4 ff ff       	jmp    80105bda <alltraps>

8010675f <vector174>:
.globl vector174
vector174:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $174
80106761:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106766:	e9 6f f4 ff ff       	jmp    80105bda <alltraps>

8010676b <vector175>:
.globl vector175
vector175:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $175
8010676d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106772:	e9 63 f4 ff ff       	jmp    80105bda <alltraps>

80106777 <vector176>:
.globl vector176
vector176:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $176
80106779:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010677e:	e9 57 f4 ff ff       	jmp    80105bda <alltraps>

80106783 <vector177>:
.globl vector177
vector177:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $177
80106785:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010678a:	e9 4b f4 ff ff       	jmp    80105bda <alltraps>

8010678f <vector178>:
.globl vector178
vector178:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $178
80106791:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106796:	e9 3f f4 ff ff       	jmp    80105bda <alltraps>

8010679b <vector179>:
.globl vector179
vector179:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $179
8010679d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067a2:	e9 33 f4 ff ff       	jmp    80105bda <alltraps>

801067a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $180
801067a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067ae:	e9 27 f4 ff ff       	jmp    80105bda <alltraps>

801067b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $181
801067b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067ba:	e9 1b f4 ff ff       	jmp    80105bda <alltraps>

801067bf <vector182>:
.globl vector182
vector182:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $182
801067c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067c6:	e9 0f f4 ff ff       	jmp    80105bda <alltraps>

801067cb <vector183>:
.globl vector183
vector183:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $183
801067cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067d2:	e9 03 f4 ff ff       	jmp    80105bda <alltraps>

801067d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $184
801067d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067de:	e9 f7 f3 ff ff       	jmp    80105bda <alltraps>

801067e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $185
801067e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801067ea:	e9 eb f3 ff ff       	jmp    80105bda <alltraps>

801067ef <vector186>:
.globl vector186
vector186:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $186
801067f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067f6:	e9 df f3 ff ff       	jmp    80105bda <alltraps>

801067fb <vector187>:
.globl vector187
vector187:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $187
801067fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106802:	e9 d3 f3 ff ff       	jmp    80105bda <alltraps>

80106807 <vector188>:
.globl vector188
vector188:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $188
80106809:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010680e:	e9 c7 f3 ff ff       	jmp    80105bda <alltraps>

80106813 <vector189>:
.globl vector189
vector189:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $189
80106815:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010681a:	e9 bb f3 ff ff       	jmp    80105bda <alltraps>

8010681f <vector190>:
.globl vector190
vector190:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $190
80106821:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106826:	e9 af f3 ff ff       	jmp    80105bda <alltraps>

8010682b <vector191>:
.globl vector191
vector191:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $191
8010682d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106832:	e9 a3 f3 ff ff       	jmp    80105bda <alltraps>

80106837 <vector192>:
.globl vector192
vector192:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $192
80106839:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010683e:	e9 97 f3 ff ff       	jmp    80105bda <alltraps>

80106843 <vector193>:
.globl vector193
vector193:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $193
80106845:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010684a:	e9 8b f3 ff ff       	jmp    80105bda <alltraps>

8010684f <vector194>:
.globl vector194
vector194:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $194
80106851:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106856:	e9 7f f3 ff ff       	jmp    80105bda <alltraps>

8010685b <vector195>:
.globl vector195
vector195:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $195
8010685d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106862:	e9 73 f3 ff ff       	jmp    80105bda <alltraps>

80106867 <vector196>:
.globl vector196
vector196:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $196
80106869:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010686e:	e9 67 f3 ff ff       	jmp    80105bda <alltraps>

80106873 <vector197>:
.globl vector197
vector197:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $197
80106875:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010687a:	e9 5b f3 ff ff       	jmp    80105bda <alltraps>

8010687f <vector198>:
.globl vector198
vector198:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $198
80106881:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106886:	e9 4f f3 ff ff       	jmp    80105bda <alltraps>

8010688b <vector199>:
.globl vector199
vector199:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $199
8010688d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106892:	e9 43 f3 ff ff       	jmp    80105bda <alltraps>

80106897 <vector200>:
.globl vector200
vector200:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $200
80106899:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010689e:	e9 37 f3 ff ff       	jmp    80105bda <alltraps>

801068a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $201
801068a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068aa:	e9 2b f3 ff ff       	jmp    80105bda <alltraps>

801068af <vector202>:
.globl vector202
vector202:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $202
801068b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068b6:	e9 1f f3 ff ff       	jmp    80105bda <alltraps>

801068bb <vector203>:
.globl vector203
vector203:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $203
801068bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068c2:	e9 13 f3 ff ff       	jmp    80105bda <alltraps>

801068c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $204
801068c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068ce:	e9 07 f3 ff ff       	jmp    80105bda <alltraps>

801068d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $205
801068d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068da:	e9 fb f2 ff ff       	jmp    80105bda <alltraps>

801068df <vector206>:
.globl vector206
vector206:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $206
801068e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801068e6:	e9 ef f2 ff ff       	jmp    80105bda <alltraps>

801068eb <vector207>:
.globl vector207
vector207:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $207
801068ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068f2:	e9 e3 f2 ff ff       	jmp    80105bda <alltraps>

801068f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $208
801068f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068fe:	e9 d7 f2 ff ff       	jmp    80105bda <alltraps>

80106903 <vector209>:
.globl vector209
vector209:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $209
80106905:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010690a:	e9 cb f2 ff ff       	jmp    80105bda <alltraps>

8010690f <vector210>:
.globl vector210
vector210:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $210
80106911:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106916:	e9 bf f2 ff ff       	jmp    80105bda <alltraps>

8010691b <vector211>:
.globl vector211
vector211:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $211
8010691d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106922:	e9 b3 f2 ff ff       	jmp    80105bda <alltraps>

80106927 <vector212>:
.globl vector212
vector212:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $212
80106929:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010692e:	e9 a7 f2 ff ff       	jmp    80105bda <alltraps>

80106933 <vector213>:
.globl vector213
vector213:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $213
80106935:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010693a:	e9 9b f2 ff ff       	jmp    80105bda <alltraps>

8010693f <vector214>:
.globl vector214
vector214:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $214
80106941:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106946:	e9 8f f2 ff ff       	jmp    80105bda <alltraps>

8010694b <vector215>:
.globl vector215
vector215:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $215
8010694d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106952:	e9 83 f2 ff ff       	jmp    80105bda <alltraps>

80106957 <vector216>:
.globl vector216
vector216:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $216
80106959:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010695e:	e9 77 f2 ff ff       	jmp    80105bda <alltraps>

80106963 <vector217>:
.globl vector217
vector217:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $217
80106965:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010696a:	e9 6b f2 ff ff       	jmp    80105bda <alltraps>

8010696f <vector218>:
.globl vector218
vector218:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $218
80106971:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106976:	e9 5f f2 ff ff       	jmp    80105bda <alltraps>

8010697b <vector219>:
.globl vector219
vector219:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $219
8010697d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106982:	e9 53 f2 ff ff       	jmp    80105bda <alltraps>

80106987 <vector220>:
.globl vector220
vector220:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $220
80106989:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010698e:	e9 47 f2 ff ff       	jmp    80105bda <alltraps>

80106993 <vector221>:
.globl vector221
vector221:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $221
80106995:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010699a:	e9 3b f2 ff ff       	jmp    80105bda <alltraps>

8010699f <vector222>:
.globl vector222
vector222:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $222
801069a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069a6:	e9 2f f2 ff ff       	jmp    80105bda <alltraps>

801069ab <vector223>:
.globl vector223
vector223:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $223
801069ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069b2:	e9 23 f2 ff ff       	jmp    80105bda <alltraps>

801069b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $224
801069b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069be:	e9 17 f2 ff ff       	jmp    80105bda <alltraps>

801069c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $225
801069c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069ca:	e9 0b f2 ff ff       	jmp    80105bda <alltraps>

801069cf <vector226>:
.globl vector226
vector226:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $226
801069d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069d6:	e9 ff f1 ff ff       	jmp    80105bda <alltraps>

801069db <vector227>:
.globl vector227
vector227:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $227
801069dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801069e2:	e9 f3 f1 ff ff       	jmp    80105bda <alltraps>

801069e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $228
801069e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069ee:	e9 e7 f1 ff ff       	jmp    80105bda <alltraps>

801069f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $229
801069f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069fa:	e9 db f1 ff ff       	jmp    80105bda <alltraps>

801069ff <vector230>:
.globl vector230
vector230:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $230
80106a01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a06:	e9 cf f1 ff ff       	jmp    80105bda <alltraps>

80106a0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $231
80106a0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a12:	e9 c3 f1 ff ff       	jmp    80105bda <alltraps>

80106a17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $232
80106a19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a1e:	e9 b7 f1 ff ff       	jmp    80105bda <alltraps>

80106a23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $233
80106a25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a2a:	e9 ab f1 ff ff       	jmp    80105bda <alltraps>

80106a2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $234
80106a31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a36:	e9 9f f1 ff ff       	jmp    80105bda <alltraps>

80106a3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $235
80106a3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a42:	e9 93 f1 ff ff       	jmp    80105bda <alltraps>

80106a47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $236
80106a49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a4e:	e9 87 f1 ff ff       	jmp    80105bda <alltraps>

80106a53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $237
80106a55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a5a:	e9 7b f1 ff ff       	jmp    80105bda <alltraps>

80106a5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $238
80106a61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a66:	e9 6f f1 ff ff       	jmp    80105bda <alltraps>

80106a6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $239
80106a6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a72:	e9 63 f1 ff ff       	jmp    80105bda <alltraps>

80106a77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $240
80106a79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a7e:	e9 57 f1 ff ff       	jmp    80105bda <alltraps>

80106a83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $241
80106a85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a8a:	e9 4b f1 ff ff       	jmp    80105bda <alltraps>

80106a8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $242
80106a91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a96:	e9 3f f1 ff ff       	jmp    80105bda <alltraps>

80106a9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $243
80106a9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106aa2:	e9 33 f1 ff ff       	jmp    80105bda <alltraps>

80106aa7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $244
80106aa9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106aae:	e9 27 f1 ff ff       	jmp    80105bda <alltraps>

80106ab3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $245
80106ab5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aba:	e9 1b f1 ff ff       	jmp    80105bda <alltraps>

80106abf <vector246>:
.globl vector246
vector246:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $246
80106ac1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ac6:	e9 0f f1 ff ff       	jmp    80105bda <alltraps>

80106acb <vector247>:
.globl vector247
vector247:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $247
80106acd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ad2:	e9 03 f1 ff ff       	jmp    80105bda <alltraps>

80106ad7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $248
80106ad9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ade:	e9 f7 f0 ff ff       	jmp    80105bda <alltraps>

80106ae3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $249
80106ae5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106aea:	e9 eb f0 ff ff       	jmp    80105bda <alltraps>

80106aef <vector250>:
.globl vector250
vector250:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $250
80106af1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106af6:	e9 df f0 ff ff       	jmp    80105bda <alltraps>

80106afb <vector251>:
.globl vector251
vector251:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $251
80106afd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b02:	e9 d3 f0 ff ff       	jmp    80105bda <alltraps>

80106b07 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $252
80106b09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b0e:	e9 c7 f0 ff ff       	jmp    80105bda <alltraps>

80106b13 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $253
80106b15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b1a:	e9 bb f0 ff ff       	jmp    80105bda <alltraps>

80106b1f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $254
80106b21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b26:	e9 af f0 ff ff       	jmp    80105bda <alltraps>

80106b2b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $255
80106b2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b32:	e9 a3 f0 ff ff       	jmp    80105bda <alltraps>
80106b37:	66 90                	xchg   %ax,%ax
80106b39:	66 90                	xchg   %ax,%ax
80106b3b:	66 90                	xchg   %ax,%ax
80106b3d:	66 90                	xchg   %ax,%ax
80106b3f:	90                   	nop

80106b40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b4c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b52:	83 ec 1c             	sub    $0x1c,%esp
80106b55:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b58:	39 d3                	cmp    %edx,%ebx
80106b5a:	73 49                	jae    80106ba5 <deallocuvm.part.0+0x65>
80106b5c:	89 c7                	mov    %eax,%edi
80106b5e:	eb 0c                	jmp    80106b6c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b60:	83 c0 01             	add    $0x1,%eax
80106b63:	c1 e0 16             	shl    $0x16,%eax
80106b66:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b68:	39 da                	cmp    %ebx,%edx
80106b6a:	76 39                	jbe    80106ba5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b6c:	89 d8                	mov    %ebx,%eax
80106b6e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b71:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b74:	f6 c1 01             	test   $0x1,%cl
80106b77:	74 e7                	je     80106b60 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b79:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b7b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106b81:	c1 ee 0a             	shr    $0xa,%esi
80106b84:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b8a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106b91:	85 f6                	test   %esi,%esi
80106b93:	74 cb                	je     80106b60 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106b95:	8b 06                	mov    (%esi),%eax
80106b97:	a8 01                	test   $0x1,%al
80106b99:	75 15                	jne    80106bb0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106b9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ba1:	39 da                	cmp    %ebx,%edx
80106ba3:	77 c7                	ja     80106b6c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bab:	5b                   	pop    %ebx
80106bac:	5e                   	pop    %esi
80106bad:	5f                   	pop    %edi
80106bae:	5d                   	pop    %ebp
80106baf:	c3                   	ret    
      if(pa == 0)
80106bb0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bb5:	74 25                	je     80106bdc <deallocuvm.part.0+0x9c>
      kfree(v);
80106bb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bba:	05 00 00 00 80       	add    $0x80000000,%eax
80106bbf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bc2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106bc8:	50                   	push   %eax
80106bc9:	e8 92 bc ff ff       	call   80102860 <kfree>
      *pte = 0;
80106bce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106bd7:	83 c4 10             	add    $0x10,%esp
80106bda:	eb 8c                	jmp    80106b68 <deallocuvm.part.0+0x28>
        panic("kfree");
80106bdc:	83 ec 0c             	sub    $0xc,%esp
80106bdf:	68 a6 77 10 80       	push   $0x801077a6
80106be4:	e8 97 97 ff ff       	call   80100380 <panic>
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <mappages>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106bf6:	89 d3                	mov    %edx,%ebx
80106bf8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bfe:	83 ec 1c             	sub    $0x1c,%esp
80106c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c10:	8b 45 08             	mov    0x8(%ebp),%eax
80106c13:	29 d8                	sub    %ebx,%eax
80106c15:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c18:	eb 3d                	jmp    80106c57 <mappages+0x67>
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c20:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c27:	c1 ea 0a             	shr    $0xa,%edx
80106c2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c37:	85 c0                	test   %eax,%eax
80106c39:	74 75                	je     80106cb0 <mappages+0xc0>
    if(*pte & PTE_P)
80106c3b:	f6 00 01             	testb  $0x1,(%eax)
80106c3e:	0f 85 86 00 00 00    	jne    80106cca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c44:	0b 75 0c             	or     0xc(%ebp),%esi
80106c47:	83 ce 01             	or     $0x1,%esi
80106c4a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c4c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c4f:	74 6f                	je     80106cc0 <mappages+0xd0>
    a += PGSIZE;
80106c51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c5a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c5d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c60:	89 d8                	mov    %ebx,%eax
80106c62:	c1 e8 16             	shr    $0x16,%eax
80106c65:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c68:	8b 07                	mov    (%edi),%eax
80106c6a:	a8 01                	test   $0x1,%al
80106c6c:	75 b2                	jne    80106c20 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c6e:	e8 ad bd ff ff       	call   80102a20 <kalloc>
80106c73:	85 c0                	test   %eax,%eax
80106c75:	74 39                	je     80106cb0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c77:	83 ec 04             	sub    $0x4,%esp
80106c7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c7d:	68 00 10 00 00       	push   $0x1000
80106c82:	6a 00                	push   $0x0
80106c84:	50                   	push   %eax
80106c85:	e8 76 dd ff ff       	call   80104a00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c8d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c90:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c96:	83 c8 07             	or     $0x7,%eax
80106c99:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c9b:	89 d8                	mov    %ebx,%eax
80106c9d:	c1 e8 0a             	shr    $0xa,%eax
80106ca0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ca5:	01 d0                	add    %edx,%eax
80106ca7:	eb 92                	jmp    80106c3b <mappages+0x4b>
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cb8:	5b                   	pop    %ebx
80106cb9:	5e                   	pop    %esi
80106cba:	5f                   	pop    %edi
80106cbb:	5d                   	pop    %ebp
80106cbc:	c3                   	ret    
80106cbd:	8d 76 00             	lea    0x0(%esi),%esi
80106cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cc3:	31 c0                	xor    %eax,%eax
}
80106cc5:	5b                   	pop    %ebx
80106cc6:	5e                   	pop    %esi
80106cc7:	5f                   	pop    %edi
80106cc8:	5d                   	pop    %ebp
80106cc9:	c3                   	ret    
      panic("remap");
80106cca:	83 ec 0c             	sub    $0xc,%esp
80106ccd:	68 e8 7d 10 80       	push   $0x80107de8
80106cd2:	e8 a9 96 ff ff       	call   80100380 <panic>
80106cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cde:	66 90                	xchg   %ax,%ax

80106ce0 <seginit>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ce6:	e8 05 d0 ff ff       	call   80103cf0 <cpuid>
  pd[0] = size-1;
80106ceb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cf0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106cf6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cfa:	c7 80 38 1d 11 80 ff 	movl   $0xffff,-0x7feee2c8(%eax)
80106d01:	ff 00 00 
80106d04:	c7 80 3c 1d 11 80 00 	movl   $0xcf9a00,-0x7feee2c4(%eax)
80106d0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d0e:	c7 80 40 1d 11 80 ff 	movl   $0xffff,-0x7feee2c0(%eax)
80106d15:	ff 00 00 
80106d18:	c7 80 44 1d 11 80 00 	movl   $0xcf9200,-0x7feee2bc(%eax)
80106d1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d22:	c7 80 48 1d 11 80 ff 	movl   $0xffff,-0x7feee2b8(%eax)
80106d29:	ff 00 00 
80106d2c:	c7 80 4c 1d 11 80 00 	movl   $0xcffa00,-0x7feee2b4(%eax)
80106d33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d36:	c7 80 50 1d 11 80 ff 	movl   $0xffff,-0x7feee2b0(%eax)
80106d3d:	ff 00 00 
80106d40:	c7 80 54 1d 11 80 00 	movl   $0xcff200,-0x7feee2ac(%eax)
80106d47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d4a:	05 30 1d 11 80       	add    $0x80111d30,%eax
  pd[1] = (uint)p;
80106d4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d53:	c1 e8 10             	shr    $0x10,%eax
80106d56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d5d:	0f 01 10             	lgdtl  (%eax)
}
80106d60:	c9                   	leave  
80106d61:	c3                   	ret    
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d70:	a1 e4 49 11 80       	mov    0x801149e4,%eax
80106d75:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d7a:	0f 22 d8             	mov    %eax,%cr3
}
80106d7d:	c3                   	ret    
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <switchuvm>:
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 1c             	sub    $0x1c,%esp
80106d89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d8c:	85 f6                	test   %esi,%esi
80106d8e:	0f 84 cb 00 00 00    	je     80106e5f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d94:	8b 46 08             	mov    0x8(%esi),%eax
80106d97:	85 c0                	test   %eax,%eax
80106d99:	0f 84 da 00 00 00    	je     80106e79 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d9f:	8b 46 04             	mov    0x4(%esi),%eax
80106da2:	85 c0                	test   %eax,%eax
80106da4:	0f 84 c2 00 00 00    	je     80106e6c <switchuvm+0xec>
  pushcli();
80106daa:	e8 41 da ff ff       	call   801047f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106daf:	e8 dc ce ff ff       	call   80103c90 <mycpu>
80106db4:	89 c3                	mov    %eax,%ebx
80106db6:	e8 d5 ce ff ff       	call   80103c90 <mycpu>
80106dbb:	89 c7                	mov    %eax,%edi
80106dbd:	e8 ce ce ff ff       	call   80103c90 <mycpu>
80106dc2:	83 c7 08             	add    $0x8,%edi
80106dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dc8:	e8 c3 ce ff ff       	call   80103c90 <mycpu>
80106dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dd0:	ba 67 00 00 00       	mov    $0x67,%edx
80106dd5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ddc:	83 c0 08             	add    $0x8,%eax
80106ddf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106de6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106deb:	83 c1 08             	add    $0x8,%ecx
80106dee:	c1 e8 18             	shr    $0x18,%eax
80106df1:	c1 e9 10             	shr    $0x10,%ecx
80106df4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106dfa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e00:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e05:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e11:	e8 7a ce ff ff       	call   80103c90 <mycpu>
80106e16:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e1d:	e8 6e ce ff ff       	call   80103c90 <mycpu>
80106e22:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e26:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e2f:	e8 5c ce ff ff       	call   80103c90 <mycpu>
80106e34:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e37:	e8 54 ce ff ff       	call   80103c90 <mycpu>
80106e3c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e40:	b8 28 00 00 00       	mov    $0x28,%eax
80106e45:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e48:	8b 46 04             	mov    0x4(%esi),%eax
80106e4b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e50:	0f 22 d8             	mov    %eax,%cr3
}
80106e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e56:	5b                   	pop    %ebx
80106e57:	5e                   	pop    %esi
80106e58:	5f                   	pop    %edi
80106e59:	5d                   	pop    %ebp
  popcli();
80106e5a:	e9 e1 d9 ff ff       	jmp    80104840 <popcli>
    panic("switchuvm: no process");
80106e5f:	83 ec 0c             	sub    $0xc,%esp
80106e62:	68 ee 7d 10 80       	push   $0x80107dee
80106e67:	e8 14 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e6c:	83 ec 0c             	sub    $0xc,%esp
80106e6f:	68 19 7e 10 80       	push   $0x80107e19
80106e74:	e8 07 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e79:	83 ec 0c             	sub    $0xc,%esp
80106e7c:	68 04 7e 10 80       	push   $0x80107e04
80106e81:	e8 fa 94 ff ff       	call   80100380 <panic>
80106e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi

80106e90 <inituvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e9c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e9f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ea5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106eab:	77 4b                	ja     80106ef8 <inituvm+0x68>
  mem = kalloc();
80106ead:	e8 6e bb ff ff       	call   80102a20 <kalloc>
  memset(mem, 0, PGSIZE);
80106eb2:	83 ec 04             	sub    $0x4,%esp
80106eb5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106eba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ebc:	6a 00                	push   $0x0
80106ebe:	50                   	push   %eax
80106ebf:	e8 3c db ff ff       	call   80104a00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ec4:	58                   	pop    %eax
80106ec5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ecb:	5a                   	pop    %edx
80106ecc:	6a 06                	push   $0x6
80106ece:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ed3:	31 d2                	xor    %edx,%edx
80106ed5:	50                   	push   %eax
80106ed6:	89 f8                	mov    %edi,%eax
80106ed8:	e8 13 fd ff ff       	call   80106bf0 <mappages>
  memmove(mem, init, sz);
80106edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ee0:	89 75 10             	mov    %esi,0x10(%ebp)
80106ee3:	83 c4 10             	add    $0x10,%esp
80106ee6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ee9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eef:	5b                   	pop    %ebx
80106ef0:	5e                   	pop    %esi
80106ef1:	5f                   	pop    %edi
80106ef2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ef3:	e9 a8 db ff ff       	jmp    80104aa0 <memmove>
    panic("inituvm: more than a page");
80106ef8:	83 ec 0c             	sub    $0xc,%esp
80106efb:	68 2d 7e 10 80       	push   $0x80107e2d
80106f00:	e8 7b 94 ff ff       	call   80100380 <panic>
80106f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f10 <loaduvm>:
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f1c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f1f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f24:	0f 85 bb 00 00 00    	jne    80106fe5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106f2a:	01 f0                	add    %esi,%eax
80106f2c:	89 f3                	mov    %esi,%ebx
80106f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f31:	8b 45 14             	mov    0x14(%ebp),%eax
80106f34:	01 f0                	add    %esi,%eax
80106f36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f39:	85 f6                	test   %esi,%esi
80106f3b:	0f 84 87 00 00 00    	je     80106fc8 <loaduvm+0xb8>
80106f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106f4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f4e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f50:	89 c2                	mov    %eax,%edx
80106f52:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f55:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f58:	f6 c2 01             	test   $0x1,%dl
80106f5b:	75 13                	jne    80106f70 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f5d:	83 ec 0c             	sub    $0xc,%esp
80106f60:	68 47 7e 10 80       	push   $0x80107e47
80106f65:	e8 16 94 ff ff       	call   80100380 <panic>
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f70:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f73:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f79:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f7e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f85:	85 c0                	test   %eax,%eax
80106f87:	74 d4                	je     80106f5d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f89:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f8e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f98:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f9e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fa1:	29 d9                	sub    %ebx,%ecx
80106fa3:	05 00 00 00 80       	add    $0x80000000,%eax
80106fa8:	57                   	push   %edi
80106fa9:	51                   	push   %ecx
80106faa:	50                   	push   %eax
80106fab:	ff 75 10             	push   0x10(%ebp)
80106fae:	e8 7d ae ff ff       	call   80101e30 <readi>
80106fb3:	83 c4 10             	add    $0x10,%esp
80106fb6:	39 f8                	cmp    %edi,%eax
80106fb8:	75 1e                	jne    80106fd8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106fba:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106fc0:	89 f0                	mov    %esi,%eax
80106fc2:	29 d8                	sub    %ebx,%eax
80106fc4:	39 c6                	cmp    %eax,%esi
80106fc6:	77 80                	ja     80106f48 <loaduvm+0x38>
}
80106fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fcb:	31 c0                	xor    %eax,%eax
}
80106fcd:	5b                   	pop    %ebx
80106fce:	5e                   	pop    %esi
80106fcf:	5f                   	pop    %edi
80106fd0:	5d                   	pop    %ebp
80106fd1:	c3                   	ret    
80106fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fe0:	5b                   	pop    %ebx
80106fe1:	5e                   	pop    %esi
80106fe2:	5f                   	pop    %edi
80106fe3:	5d                   	pop    %ebp
80106fe4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106fe5:	83 ec 0c             	sub    $0xc,%esp
80106fe8:	68 e8 7e 10 80       	push   $0x80107ee8
80106fed:	e8 8e 93 ff ff       	call   80100380 <panic>
80106ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107000 <allocuvm>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107009:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010700c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010700f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107012:	85 c0                	test   %eax,%eax
80107014:	0f 88 b6 00 00 00    	js     801070d0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010701a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010701d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107020:	0f 82 9a 00 00 00    	jb     801070c0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107026:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010702c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107032:	39 75 10             	cmp    %esi,0x10(%ebp)
80107035:	77 44                	ja     8010707b <allocuvm+0x7b>
80107037:	e9 87 00 00 00       	jmp    801070c3 <allocuvm+0xc3>
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107040:	83 ec 04             	sub    $0x4,%esp
80107043:	68 00 10 00 00       	push   $0x1000
80107048:	6a 00                	push   $0x0
8010704a:	50                   	push   %eax
8010704b:	e8 b0 d9 ff ff       	call   80104a00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107050:	58                   	pop    %eax
80107051:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107057:	5a                   	pop    %edx
80107058:	6a 06                	push   $0x6
8010705a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010705f:	89 f2                	mov    %esi,%edx
80107061:	50                   	push   %eax
80107062:	89 f8                	mov    %edi,%eax
80107064:	e8 87 fb ff ff       	call   80106bf0 <mappages>
80107069:	83 c4 10             	add    $0x10,%esp
8010706c:	85 c0                	test   %eax,%eax
8010706e:	78 78                	js     801070e8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107070:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107076:	39 75 10             	cmp    %esi,0x10(%ebp)
80107079:	76 48                	jbe    801070c3 <allocuvm+0xc3>
    mem = kalloc();
8010707b:	e8 a0 b9 ff ff       	call   80102a20 <kalloc>
80107080:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107082:	85 c0                	test   %eax,%eax
80107084:	75 ba                	jne    80107040 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107086:	83 ec 0c             	sub    $0xc,%esp
80107089:	68 65 7e 10 80       	push   $0x80107e65
8010708e:	e8 7d 97 ff ff       	call   80100810 <cprintf>
  if(newsz >= oldsz)
80107093:	8b 45 0c             	mov    0xc(%ebp),%eax
80107096:	83 c4 10             	add    $0x10,%esp
80107099:	39 45 10             	cmp    %eax,0x10(%ebp)
8010709c:	74 32                	je     801070d0 <allocuvm+0xd0>
8010709e:	8b 55 10             	mov    0x10(%ebp),%edx
801070a1:	89 c1                	mov    %eax,%ecx
801070a3:	89 f8                	mov    %edi,%eax
801070a5:	e8 96 fa ff ff       	call   80106b40 <deallocuvm.part.0>
      return 0;
801070aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b7:	5b                   	pop    %ebx
801070b8:	5e                   	pop    %esi
801070b9:	5f                   	pop    %edi
801070ba:	5d                   	pop    %ebp
801070bb:	c3                   	ret    
801070bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801070c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801070c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c9:	5b                   	pop    %ebx
801070ca:	5e                   	pop    %esi
801070cb:	5f                   	pop    %edi
801070cc:	5d                   	pop    %ebp
801070cd:	c3                   	ret    
801070ce:	66 90                	xchg   %ax,%ax
    return 0;
801070d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070dd:	5b                   	pop    %ebx
801070de:	5e                   	pop    %esi
801070df:	5f                   	pop    %edi
801070e0:	5d                   	pop    %ebp
801070e1:	c3                   	ret    
801070e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070e8:	83 ec 0c             	sub    $0xc,%esp
801070eb:	68 7d 7e 10 80       	push   $0x80107e7d
801070f0:	e8 1b 97 ff ff       	call   80100810 <cprintf>
  if(newsz >= oldsz)
801070f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070f8:	83 c4 10             	add    $0x10,%esp
801070fb:	39 45 10             	cmp    %eax,0x10(%ebp)
801070fe:	74 0c                	je     8010710c <allocuvm+0x10c>
80107100:	8b 55 10             	mov    0x10(%ebp),%edx
80107103:	89 c1                	mov    %eax,%ecx
80107105:	89 f8                	mov    %edi,%eax
80107107:	e8 34 fa ff ff       	call   80106b40 <deallocuvm.part.0>
      kfree(mem);
8010710c:	83 ec 0c             	sub    $0xc,%esp
8010710f:	53                   	push   %ebx
80107110:	e8 4b b7 ff ff       	call   80102860 <kfree>
      return 0;
80107115:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010711c:	83 c4 10             	add    $0x10,%esp
}
8010711f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107122:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107125:	5b                   	pop    %ebx
80107126:	5e                   	pop    %esi
80107127:	5f                   	pop    %edi
80107128:	5d                   	pop    %ebp
80107129:	c3                   	ret    
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <deallocuvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	8b 55 0c             	mov    0xc(%ebp),%edx
80107136:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107139:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010713c:	39 d1                	cmp    %edx,%ecx
8010713e:	73 10                	jae    80107150 <deallocuvm+0x20>
}
80107140:	5d                   	pop    %ebp
80107141:	e9 fa f9 ff ff       	jmp    80106b40 <deallocuvm.part.0>
80107146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010714d:	8d 76 00             	lea    0x0(%esi),%esi
80107150:	89 d0                	mov    %edx,%eax
80107152:	5d                   	pop    %ebp
80107153:	c3                   	ret    
80107154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop

80107160 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010716c:	85 f6                	test   %esi,%esi
8010716e:	74 59                	je     801071c9 <freevm+0x69>
  if(newsz >= oldsz)
80107170:	31 c9                	xor    %ecx,%ecx
80107172:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107177:	89 f0                	mov    %esi,%eax
80107179:	89 f3                	mov    %esi,%ebx
8010717b:	e8 c0 f9 ff ff       	call   80106b40 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107180:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107186:	eb 0f                	jmp    80107197 <freevm+0x37>
80107188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718f:	90                   	nop
80107190:	83 c3 04             	add    $0x4,%ebx
80107193:	39 df                	cmp    %ebx,%edi
80107195:	74 23                	je     801071ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107197:	8b 03                	mov    (%ebx),%eax
80107199:	a8 01                	test   $0x1,%al
8010719b:	74 f3                	je     80107190 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010719d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071a2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071ad:	50                   	push   %eax
801071ae:	e8 ad b6 ff ff       	call   80102860 <kfree>
801071b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071b6:	39 df                	cmp    %ebx,%edi
801071b8:	75 dd                	jne    80107197 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071c0:	5b                   	pop    %ebx
801071c1:	5e                   	pop    %esi
801071c2:	5f                   	pop    %edi
801071c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071c4:	e9 97 b6 ff ff       	jmp    80102860 <kfree>
    panic("freevm: no pgdir");
801071c9:	83 ec 0c             	sub    $0xc,%esp
801071cc:	68 99 7e 10 80       	push   $0x80107e99
801071d1:	e8 aa 91 ff ff       	call   80100380 <panic>
801071d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071dd:	8d 76 00             	lea    0x0(%esi),%esi

801071e0 <setupkvm>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	56                   	push   %esi
801071e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071e5:	e8 36 b8 ff ff       	call   80102a20 <kalloc>
801071ea:	89 c6                	mov    %eax,%esi
801071ec:	85 c0                	test   %eax,%eax
801071ee:	74 42                	je     80107232 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801071f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071f3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801071f8:	68 00 10 00 00       	push   $0x1000
801071fd:	6a 00                	push   $0x0
801071ff:	50                   	push   %eax
80107200:	e8 fb d7 ff ff       	call   80104a00 <memset>
80107205:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107208:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010720b:	83 ec 08             	sub    $0x8,%esp
8010720e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107211:	ff 73 0c             	push   0xc(%ebx)
80107214:	8b 13                	mov    (%ebx),%edx
80107216:	50                   	push   %eax
80107217:	29 c1                	sub    %eax,%ecx
80107219:	89 f0                	mov    %esi,%eax
8010721b:	e8 d0 f9 ff ff       	call   80106bf0 <mappages>
80107220:	83 c4 10             	add    $0x10,%esp
80107223:	85 c0                	test   %eax,%eax
80107225:	78 19                	js     80107240 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107227:	83 c3 10             	add    $0x10,%ebx
8010722a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107230:	75 d6                	jne    80107208 <setupkvm+0x28>
}
80107232:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107235:	89 f0                	mov    %esi,%eax
80107237:	5b                   	pop    %ebx
80107238:	5e                   	pop    %esi
80107239:	5d                   	pop    %ebp
8010723a:	c3                   	ret    
8010723b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop
      freevm(pgdir);
80107240:	83 ec 0c             	sub    $0xc,%esp
80107243:	56                   	push   %esi
      return 0;
80107244:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107246:	e8 15 ff ff ff       	call   80107160 <freevm>
      return 0;
8010724b:	83 c4 10             	add    $0x10,%esp
}
8010724e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107251:	89 f0                	mov    %esi,%eax
80107253:	5b                   	pop    %ebx
80107254:	5e                   	pop    %esi
80107255:	5d                   	pop    %ebp
80107256:	c3                   	ret    
80107257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725e:	66 90                	xchg   %ax,%ax

80107260 <kvmalloc>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107266:	e8 75 ff ff ff       	call   801071e0 <setupkvm>
8010726b:	a3 e4 49 11 80       	mov    %eax,0x801149e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107270:	05 00 00 00 80       	add    $0x80000000,%eax
80107275:	0f 22 d8             	mov    %eax,%cr3
}
80107278:	c9                   	leave  
80107279:	c3                   	ret    
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107280 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	83 ec 08             	sub    $0x8,%esp
80107286:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107289:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010728c:	89 c1                	mov    %eax,%ecx
8010728e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107291:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107294:	f6 c2 01             	test   $0x1,%dl
80107297:	75 17                	jne    801072b0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107299:	83 ec 0c             	sub    $0xc,%esp
8010729c:	68 aa 7e 10 80       	push   $0x80107eaa
801072a1:	e8 da 90 ff ff       	call   80100380 <panic>
801072a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801072c5:	85 c0                	test   %eax,%eax
801072c7:	74 d0                	je     80107299 <clearpteu+0x19>
  *pte &= ~PTE_U;
801072c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072cc:	c9                   	leave  
801072cd:	c3                   	ret    
801072ce:	66 90                	xchg   %ax,%ax

801072d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	53                   	push   %ebx
801072d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072d9:	e8 02 ff ff ff       	call   801071e0 <setupkvm>
801072de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072e1:	85 c0                	test   %eax,%eax
801072e3:	0f 84 bd 00 00 00    	je     801073a6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072ec:	85 c9                	test   %ecx,%ecx
801072ee:	0f 84 b2 00 00 00    	je     801073a6 <copyuvm+0xd6>
801072f4:	31 f6                	xor    %esi,%esi
801072f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107300:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107303:	89 f0                	mov    %esi,%eax
80107305:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107308:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010730b:	a8 01                	test   $0x1,%al
8010730d:	75 11                	jne    80107320 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010730f:	83 ec 0c             	sub    $0xc,%esp
80107312:	68 b4 7e 10 80       	push   $0x80107eb4
80107317:	e8 64 90 ff ff       	call   80100380 <panic>
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107320:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107322:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107327:	c1 ea 0a             	shr    $0xa,%edx
8010732a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107330:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107337:	85 c0                	test   %eax,%eax
80107339:	74 d4                	je     8010730f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010733b:	8b 00                	mov    (%eax),%eax
8010733d:	a8 01                	test   $0x1,%al
8010733f:	0f 84 9f 00 00 00    	je     801073e4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107345:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107347:	25 ff 0f 00 00       	and    $0xfff,%eax
8010734c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010734f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107355:	e8 c6 b6 ff ff       	call   80102a20 <kalloc>
8010735a:	89 c3                	mov    %eax,%ebx
8010735c:	85 c0                	test   %eax,%eax
8010735e:	74 64                	je     801073c4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107360:	83 ec 04             	sub    $0x4,%esp
80107363:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107369:	68 00 10 00 00       	push   $0x1000
8010736e:	57                   	push   %edi
8010736f:	50                   	push   %eax
80107370:	e8 2b d7 ff ff       	call   80104aa0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107375:	58                   	pop    %eax
80107376:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010737c:	5a                   	pop    %edx
8010737d:	ff 75 e4             	push   -0x1c(%ebp)
80107380:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107385:	89 f2                	mov    %esi,%edx
80107387:	50                   	push   %eax
80107388:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010738b:	e8 60 f8 ff ff       	call   80106bf0 <mappages>
80107390:	83 c4 10             	add    $0x10,%esp
80107393:	85 c0                	test   %eax,%eax
80107395:	78 21                	js     801073b8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107397:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010739d:	39 75 0c             	cmp    %esi,0xc(%ebp)
801073a0:	0f 87 5a ff ff ff    	ja     80107300 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801073a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ac:	5b                   	pop    %ebx
801073ad:	5e                   	pop    %esi
801073ae:	5f                   	pop    %edi
801073af:	5d                   	pop    %ebp
801073b0:	c3                   	ret    
801073b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073b8:	83 ec 0c             	sub    $0xc,%esp
801073bb:	53                   	push   %ebx
801073bc:	e8 9f b4 ff ff       	call   80102860 <kfree>
      goto bad;
801073c1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801073c4:	83 ec 0c             	sub    $0xc,%esp
801073c7:	ff 75 e0             	push   -0x20(%ebp)
801073ca:	e8 91 fd ff ff       	call   80107160 <freevm>
  return 0;
801073cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801073d6:	83 c4 10             	add    $0x10,%esp
}
801073d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073df:	5b                   	pop    %ebx
801073e0:	5e                   	pop    %esi
801073e1:	5f                   	pop    %edi
801073e2:	5d                   	pop    %ebp
801073e3:	c3                   	ret    
      panic("copyuvm: page not present");
801073e4:	83 ec 0c             	sub    $0xc,%esp
801073e7:	68 ce 7e 10 80       	push   $0x80107ece
801073ec:	e8 8f 8f ff ff       	call   80100380 <panic>
801073f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop

80107400 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107406:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107409:	89 c1                	mov    %eax,%ecx
8010740b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010740e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107411:	f6 c2 01             	test   $0x1,%dl
80107414:	0f 84 00 01 00 00    	je     8010751a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010741a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010741d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107423:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107424:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107429:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107430:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107432:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107437:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010743a:	05 00 00 00 80       	add    $0x80000000,%eax
8010743f:	83 fa 05             	cmp    $0x5,%edx
80107442:	ba 00 00 00 00       	mov    $0x0,%edx
80107447:	0f 45 c2             	cmovne %edx,%eax
}
8010744a:	c3                   	ret    
8010744b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop

80107450 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	8b 75 14             	mov    0x14(%ebp),%esi
8010745c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010745f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107462:	85 f6                	test   %esi,%esi
80107464:	75 51                	jne    801074b7 <copyout+0x67>
80107466:	e9 a5 00 00 00       	jmp    80107510 <copyout+0xc0>
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107470:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107476:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010747c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107482:	74 75                	je     801074f9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107484:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107486:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107489:	29 c3                	sub    %eax,%ebx
8010748b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107491:	39 f3                	cmp    %esi,%ebx
80107493:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107496:	29 f8                	sub    %edi,%eax
80107498:	83 ec 04             	sub    $0x4,%esp
8010749b:	01 c1                	add    %eax,%ecx
8010749d:	53                   	push   %ebx
8010749e:	52                   	push   %edx
8010749f:	51                   	push   %ecx
801074a0:	e8 fb d5 ff ff       	call   80104aa0 <memmove>
    len -= n;
    buf += n;
801074a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801074ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801074b3:	29 de                	sub    %ebx,%esi
801074b5:	74 59                	je     80107510 <copyout+0xc0>
  if(*pde & PTE_P){
801074b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801074be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801074ca:	f6 c1 01             	test   $0x1,%cl
801074cd:	0f 84 4e 00 00 00    	je     80107521 <copyout.cold>
  return &pgtab[PTX(va)];
801074d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801074db:	c1 eb 0c             	shr    $0xc,%ebx
801074de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801074e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801074eb:	89 d9                	mov    %ebx,%ecx
801074ed:	83 e1 05             	and    $0x5,%ecx
801074f0:	83 f9 05             	cmp    $0x5,%ecx
801074f3:	0f 84 77 ff ff ff    	je     80107470 <copyout+0x20>
  }
  return 0;
}
801074f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107501:	5b                   	pop    %ebx
80107502:	5e                   	pop    %esi
80107503:	5f                   	pop    %edi
80107504:	5d                   	pop    %ebp
80107505:	c3                   	ret    
80107506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750d:	8d 76 00             	lea    0x0(%esi),%esi
80107510:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107513:	31 c0                	xor    %eax,%eax
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret    

8010751a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010751a:	a1 00 00 00 00       	mov    0x0,%eax
8010751f:	0f 0b                	ud2    

80107521 <copyout.cold>:
80107521:	a1 00 00 00 00       	mov    0x0,%eax
80107526:	0f 0b                	ud2    
