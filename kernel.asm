
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
8010002d:	b8 b0 33 10 80       	mov    $0x801033b0,%eax
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
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 c5 46 00 00       	call   80104720 <initlock>
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
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 53 45 00 00       	call   801045f0 <initsleeplock>
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
801000e4:	e8 07 48 00 00       	call   801048f0 <acquire>
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
80100162:	e8 29 47 00 00       	call   80104890 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 44 00 00       	call   80104630 <acquiresleep>
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
8010018c:	e8 9f 24 00 00       	call   80102630 <iderw>
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
801001a1:	68 ee 74 10 80       	push   $0x801074ee
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
801001be:	e8 0d 45 00 00       	call   801046d0 <holdingsleep>
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
801001d4:	e9 57 24 00 00       	jmp    80102630 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 74 10 80       	push   $0x801074ff
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
801001ff:	e8 cc 44 00 00       	call   801046d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 44 00 00       	call   80104690 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 d0 46 00 00       	call   801048f0 <acquire>
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
8010026c:	e9 1f 46 00 00       	jmp    80104890 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 75 10 80       	push   $0x80107506
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
80100294:	e8 17 19 00 00       	call   80101bb0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 f4 10 80 	movl   $0x8010f440,(%esp)
801002a0:	e8 4b 46 00 00       	call   801048f0 <acquire>
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
801002cd:	e8 be 40 00 00       	call   80104390 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 d9 39 00 00       	call   80103cc0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 f4 10 80       	push   $0x8010f440
801002f6:	e8 95 45 00 00       	call   80104890 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 17 00 00       	call   80101ad0 <ilock>
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
8010034c:	e8 3f 45 00 00       	call   80104890 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 17 00 00       	call   80101ad0 <ilock>
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
80100399:	e8 a2 28 00 00       	call   80102c40 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 75 10 80       	push   $0x8010750d
801003a7:	e8 04 04 00 00       	call   801007b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 03 00 00       	call   801007b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 37 7e 10 80 	movl   $0x80107e37,(%esp)
801003bc:	e8 ef 03 00 00       	call   801007b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 43 00 00       	call   80104740 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 75 10 80       	push   $0x80107521
801003dd:	e8 ce 03 00 00       	call   801007b0 <cprintf>
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
  if(c == '\n'){
80100436:	83 fb 0a             	cmp    $0xa,%ebx
80100439:	0f 84 f1 00 00 00    	je     80100530 <cgaputc+0x130>
  else if(c == BACKSPACE){
8010043f:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100445:	0f 84 cd 00 00 00    	je     80100518 <cgaputc+0x118>
  } else if (c == LEFT_ARROW) {
8010044b:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100451:	0f 84 69 01 00 00    	je     801005c0 <cgaputc+0x1c0>
    if(back_counter > 0) {
80100457:	a1 24 f4 10 80       	mov    0x8010f424,%eax
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
801004f7:	03 35 24 f4 10 80    	add    0x8010f424,%esi
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
80100565:	e8 e6 44 00 00       	call   80104a50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010056a:	b8 80 07 00 00       	mov    $0x780,%eax
8010056f:	83 c4 0c             	add    $0xc,%esp
80100572:	29 f0                	sub    %esi,%eax
80100574:	01 c0                	add    %eax,%eax
80100576:	50                   	push   %eax
80100577:	8d 84 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%eax
8010057e:	6a 00                	push   $0x0
80100580:	50                   	push   %eax
80100581:	e8 2a 44 00 00       	call   801049b0 <memset>
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
801005b0:	a3 24 f4 10 80       	mov    %eax,0x8010f424
801005b5:	e9 e5 fe ff ff       	jmp    8010049f <cgaputc+0x9f>
801005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(back_counter < (strlen(input.buf) - backspaces)) {
801005c0:	83 ec 0c             	sub    $0xc,%esp
  pos |= inb(CRTPORT+1);
801005c3:	89 fe                	mov    %edi,%esi
    if(back_counter < (strlen(input.buf) - backspaces)) {
801005c5:	68 80 ee 10 80       	push   $0x8010ee80
801005ca:	e8 e1 45 00 00       	call   80104bb0 <strlen>
801005cf:	8b 15 24 f4 10 80    	mov    0x8010f424,%edx
801005d5:	2b 05 20 f4 10 80    	sub    0x8010f420,%eax
801005db:	83 c4 10             	add    $0x10,%esp
801005de:	39 d0                	cmp    %edx,%eax
801005e0:	0f 8e b9 fe ff ff    	jle    8010049f <cgaputc+0x9f>
      back_counter++;
801005e6:	83 c2 01             	add    $0x1,%edx
      --pos;
801005e9:	83 ee 01             	sub    $0x1,%esi
      back_counter++;
801005ec:	89 15 24 f4 10 80    	mov    %edx,0x8010f424
801005f2:	e9 a8 fe ff ff       	jmp    8010049f <cgaputc+0x9f>
    panic("pos under/overflow");
801005f7:	83 ec 0c             	sub    $0xc,%esp
801005fa:	68 25 75 10 80       	push   $0x80107525
801005ff:	e8 7c fd ff ff       	call   80100380 <panic>
80100604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010060b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010060f:	90                   	nop

80100610 <consputc>:
  if(panicked){
80100610:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
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
80100634:	e8 c7 59 00 00       	call   80106000 <uartputc>
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
8010064a:	83 05 20 f4 10 80 01 	addl   $0x1,0x8010f420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100651:	6a 08                	push   $0x8
80100653:	e8 a8 59 00 00       	call   80106000 <uartputc>
80100658:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010065f:	e8 9c 59 00 00       	call   80106000 <uartputc>
80100664:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010066b:	e8 90 59 00 00       	call   80106000 <uartputc>
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
8010068f:	e8 1c 15 00 00       	call   80101bb0 <iunlock>
  acquire(&cons.lock);
80100694:	c7 04 24 40 f4 10 80 	movl   $0x8010f440,(%esp)
8010069b:	e8 50 42 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++)
801006a0:	83 c4 10             	add    $0x10,%esp
801006a3:	85 f6                	test   %esi,%esi
801006a5:	7e 37                	jle    801006de <consolewrite+0x5e>
801006a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801006aa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801006ad:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
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
801006ca:	e8 31 59 00 00       	call   80106000 <uartputc>
  cgaputc(c);
801006cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006d2:	e8 29 fd ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
801006d7:	83 c4 10             	add    $0x10,%esp
801006da:	39 df                	cmp    %ebx,%edi
801006dc:	75 cf                	jne    801006ad <consolewrite+0x2d>
  release(&cons.lock);
801006de:	83 ec 0c             	sub    $0xc,%esp
801006e1:	68 40 f4 10 80       	push   $0x8010f440
801006e6:	e8 a5 41 00 00       	call   80104890 <release>
  ilock(ip);
801006eb:	58                   	pop    %eax
801006ec:	ff 75 08             	push   0x8(%ebp)
801006ef:	e8 dc 13 00 00       	call   80101ad0 <ilock>

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
80100736:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
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
8010075f:	a1 78 f4 10 80       	mov    0x8010f478,%eax
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
80100777:	e8 84 58 00 00       	call   80106000 <uartputc>
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
801007b9:	a1 74 f4 10 80       	mov    0x8010f474,%eax
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
80100865:	bf 38 75 10 80       	mov    $0x80107538,%edi
      for(; *s; s++)
8010086a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010086d:	b8 28 00 00 00       	mov    $0x28,%eax
80100872:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100874:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
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
801008c0:	8b 0d 78 f4 10 80    	mov    0x8010f478,%ecx
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
801008da:	e8 21 57 00 00       	call   80106000 <uartputc>
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
80100903:	68 40 f4 10 80       	push   $0x8010f440
80100908:	e8 e3 3f 00 00       	call   801048f0 <acquire>
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	e9 b4 fe ff ff       	jmp    801007c9 <cprintf+0x19>
80100915:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100918:	a1 78 f4 10 80       	mov    0x8010f478,%eax
8010091d:	85 c0                	test   %eax,%eax
8010091f:	74 4f                	je     80100970 <cprintf+0x1c0>
80100921:	fa                   	cli    
    for(;;)
80100922:	eb fe                	jmp    80100922 <cprintf+0x172>
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100928:	8b 0d 78 f4 10 80    	mov    0x8010f478,%ecx
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
80100943:	e8 b8 56 00 00       	call   80106000 <uartputc>
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
80100978:	e8 83 56 00 00       	call   80106000 <uartputc>
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
801009a7:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
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
801009c4:	e8 37 56 00 00       	call   80106000 <uartputc>
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
801009ec:	68 40 f4 10 80       	push   $0x8010f440
801009f1:	e8 9a 3e 00 00       	call   80104890 <release>
801009f6:	83 c4 10             	add    $0x10,%esp
}
801009f9:	e9 43 fe ff ff       	jmp    80100841 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801009fe:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100a01:	e9 25 fe ff ff       	jmp    8010082b <cprintf+0x7b>
    panic("null fmt");
80100a06:	83 ec 0c             	sub    $0xc,%esp
80100a09:	68 3f 75 10 80       	push   $0x8010753f
80100a0e:	e8 6d f9 ff ff       	call   80100380 <panic>
80100a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a20 <for_str>:
void for_str(char a[],char b[],int size){
80100a20:	55                   	push   %ebp
  for(int i=0;i<127;i++){
80100a21:	31 c0                	xor    %eax,%eax
void for_str(char a[],char b[],int size){
80100a23:	89 e5                	mov    %esp,%ebp
80100a25:	53                   	push   %ebx
80100a26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    b[i]=a[i];
80100a30:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80100a34:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  for(int i=0;i<127;i++){
80100a37:	83 c0 01             	add    $0x1,%eax
80100a3a:	83 f8 7f             	cmp    $0x7f,%eax
80100a3d:	75 f1                	jne    80100a30 <for_str+0x10>
}
80100a3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a42:	c9                   	leave  
80100a43:	c3                   	ret    
80100a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a4f:	90                   	nop

80100a50 <consoleintr>:
{
80100a50:	55                   	push   %ebp
80100a51:	89 e5                	mov    %esp,%ebp
80100a53:	57                   	push   %edi
80100a54:	56                   	push   %esi
  int c, doprocdump = 0;
80100a55:	31 f6                	xor    %esi,%esi
{
80100a57:	53                   	push   %ebx
80100a58:	83 ec 28             	sub    $0x28,%esp
80100a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100a5e:	68 40 f4 10 80       	push   $0x8010f440
80100a63:	e8 88 3e 00 00       	call   801048f0 <acquire>
  while((c = getc()) >= 0){
80100a68:	83 c4 10             	add    $0x10,%esp
80100a6b:	ff d3                	call   *%ebx
80100a6d:	85 c0                	test   %eax,%eax
80100a6f:	78 31                	js     80100aa2 <consoleintr+0x52>
    switch(c){
80100a71:	83 f8 7f             	cmp    $0x7f,%eax
80100a74:	0f 84 9f 00 00 00    	je     80100b19 <consoleintr+0xc9>
80100a7a:	7e 4c                	jle    80100ac8 <consoleintr+0x78>
80100a7c:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100a81:	0f 84 b9 01 00 00    	je     80100c40 <consoleintr+0x1f0>
80100a87:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100a8c:	0f 85 de 00 00 00    	jne    80100b70 <consoleintr+0x120>
      cgaputc(c);
80100a92:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100a97:	e8 64 f9 ff ff       	call   80100400 <cgaputc>
  while((c = getc()) >= 0){
80100a9c:	ff d3                	call   *%ebx
80100a9e:	85 c0                	test   %eax,%eax
80100aa0:	79 cf                	jns    80100a71 <consoleintr+0x21>
  release(&cons.lock);
80100aa2:	83 ec 0c             	sub    $0xc,%esp
80100aa5:	68 40 f4 10 80       	push   $0x8010f440
80100aaa:	e8 e1 3d 00 00       	call   80104890 <release>
  if(doprocdump) {
80100aaf:	83 c4 10             	add    $0x10,%esp
80100ab2:	85 f6                	test   %esi,%esi
80100ab4:	0f 85 8a 02 00 00    	jne    80100d44 <consoleintr+0x2f4>
}
80100aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100abd:	5b                   	pop    %ebx
80100abe:	5e                   	pop    %esi
80100abf:	5f                   	pop    %edi
80100ac0:	5d                   	pop    %ebp
80100ac1:	c3                   	ret    
80100ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100ac8:	83 f8 10             	cmp    $0x10,%eax
80100acb:	0f 84 ef 00 00 00    	je     80100bc0 <consoleintr+0x170>
80100ad1:	83 f8 15             	cmp    $0x15,%eax
80100ad4:	75 3a                	jne    80100b10 <consoleintr+0xc0>
      while(input.e != input.w &&
80100ad6:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100adb:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100ae1:	74 88                	je     80100a6b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ae3:	83 e8 01             	sub    $0x1,%eax
80100ae6:	89 c2                	mov    %eax,%edx
80100ae8:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100aeb:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100af2:	0f 84 73 ff ff ff    	je     80100a6b <consoleintr+0x1b>
  if(panicked){
80100af8:	8b 3d 78 f4 10 80    	mov    0x8010f478,%edi
        input.e--;
80100afe:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100b03:	85 ff                	test   %edi,%edi
80100b05:	0f 84 bf 00 00 00    	je     80100bca <consoleintr+0x17a>
80100b0b:	fa                   	cli    
    for(;;)
80100b0c:	eb fe                	jmp    80100b0c <consoleintr+0xbc>
80100b0e:	66 90                	xchg   %ax,%ax
    switch(c){
80100b10:	83 f8 08             	cmp    $0x8,%eax
80100b13:	0f 85 37 01 00 00    	jne    80100c50 <consoleintr+0x200>
      if(input.e != input.w && back_counter < (strlen(input.buf) - backspaces)){
80100b19:	a1 04 ef 10 80       	mov    0x8010ef04,%eax
80100b1e:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100b24:	0f 84 41 ff ff ff    	je     80100a6b <consoleintr+0x1b>
80100b2a:	83 ec 0c             	sub    $0xc,%esp
80100b2d:	68 80 ee 10 80       	push   $0x8010ee80
80100b32:	e8 79 40 00 00       	call   80104bb0 <strlen>
80100b37:	8b 15 20 f4 10 80    	mov    0x8010f420,%edx
80100b3d:	83 c4 10             	add    $0x10,%esp
80100b40:	29 d0                	sub    %edx,%eax
80100b42:	3b 05 24 f4 10 80    	cmp    0x8010f424,%eax
80100b48:	0f 8e 1d ff ff ff    	jle    80100a6b <consoleintr+0x1b>
  if(panicked){
80100b4e:	8b 0d 78 f4 10 80    	mov    0x8010f478,%ecx
        input.e--;
80100b54:	83 2d 08 ef 10 80 01 	subl   $0x1,0x8010ef08
  if(panicked){
80100b5b:	85 c9                	test   %ecx,%ecx
80100b5d:	0f 84 f9 01 00 00    	je     80100d5c <consoleintr+0x30c>
80100b63:	fa                   	cli    
    for(;;)
80100b64:	eb fe                	jmp    80100b64 <consoleintr+0x114>
80100b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100b70:	31 ff                	xor    %edi,%edi
80100b72:	3d e2 00 00 00       	cmp    $0xe2,%eax
80100b77:	0f 85 e3 00 00 00    	jne    80100c60 <consoleintr+0x210>
      for(int i=0; i < strlen(history[curr_index])-1; i++){
80100b7d:	a1 0c ef 10 80       	mov    0x8010ef0c,%eax
80100b82:	83 ec 0c             	sub    $0xc,%esp
80100b85:	c1 e0 07             	shl    $0x7,%eax
80100b88:	05 20 ef 10 80       	add    $0x8010ef20,%eax
80100b8d:	50                   	push   %eax
80100b8e:	e8 1d 40 00 00       	call   80104bb0 <strlen>
80100b93:	83 c4 10             	add    $0x10,%esp
80100b96:	83 e8 01             	sub    $0x1,%eax
80100b99:	39 f8                	cmp    %edi,%eax
80100b9b:	0f 8e af 01 00 00    	jle    80100d50 <consoleintr+0x300>
          x = history[curr_index][i];
80100ba1:	a1 0c ef 10 80       	mov    0x8010ef0c,%eax
  if(panicked){
80100ba6:	8b 15 78 f4 10 80    	mov    0x8010f478,%edx
          x = history[curr_index][i];
80100bac:	c1 e0 07             	shl    $0x7,%eax
80100baf:	0f be 84 07 20 ef 10 	movsbl -0x7fef10e0(%edi,%eax,1),%eax
80100bb6:	80 
  if(panicked){
80100bb7:	85 d2                	test   %edx,%edx
80100bb9:	74 65                	je     80100c20 <consoleintr+0x1d0>
80100bbb:	fa                   	cli    
    for(;;)
80100bbc:	eb fe                	jmp    80100bbc <consoleintr+0x16c>
80100bbe:	66 90                	xchg   %ax,%ax
    switch(c){
80100bc0:	be 01 00 00 00       	mov    $0x1,%esi
80100bc5:	e9 a1 fe ff ff       	jmp    80100a6b <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100bca:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100bcd:	83 05 20 f4 10 80 01 	addl   $0x1,0x8010f420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100bd4:	6a 08                	push   $0x8
80100bd6:	e8 25 54 00 00       	call   80106000 <uartputc>
80100bdb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100be2:	e8 19 54 00 00       	call   80106000 <uartputc>
80100be7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100bee:	e8 0d 54 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100bf3:	b8 00 01 00 00       	mov    $0x100,%eax
80100bf8:	e8 03 f8 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100bfd:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100c02:	83 c4 10             	add    $0x10,%esp
80100c05:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100c0b:	0f 85 d2 fe ff ff    	jne    80100ae3 <consoleintr+0x93>
80100c11:	e9 55 fe ff ff       	jmp    80100a6b <consoleintr+0x1b>
80100c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c1d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100c20:	83 ec 0c             	sub    $0xc,%esp
80100c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      for(int i=0; i < strlen(history[curr_index])-1; i++){
80100c26:	83 c7 01             	add    $0x1,%edi
    uartputc(c);
80100c29:	50                   	push   %eax
80100c2a:	e8 d1 53 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c32:	e8 c9 f7 ff ff       	call   80100400 <cgaputc>
      for(int i=0; i < strlen(history[curr_index])-1; i++){
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	e9 3e ff ff ff       	jmp    80100b7d <consoleintr+0x12d>
80100c3f:	90                   	nop
      cgaputc(c);
80100c40:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100c45:	e8 b6 f7 ff ff       	call   80100400 <cgaputc>
      break;
80100c4a:	e9 1c fe ff ff       	jmp    80100a6b <consoleintr+0x1b>
80100c4f:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100c50:	85 c0                	test   %eax,%eax
80100c52:	0f 84 13 fe ff ff    	je     80100a6b <consoleintr+0x1b>
80100c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c5f:	90                   	nop
80100c60:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100c66:	89 ca                	mov    %ecx,%edx
80100c68:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100c6e:	83 fa 7f             	cmp    $0x7f,%edx
80100c71:	0f 87 f4 fd ff ff    	ja     80100a6b <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c77:	8d 51 01             	lea    0x1(%ecx),%edx
80100c7a:	83 e1 7f             	and    $0x7f,%ecx
80100c7d:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100c83:	83 f8 0d             	cmp    $0xd,%eax
80100c86:	0f 84 0d 01 00 00    	je     80100d99 <consoleintr+0x349>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c8c:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
        consputc(c);
80100c92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c95:	e8 76 f9 ff ff       	call   80100610 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c9d:	83 f8 0a             	cmp    $0xa,%eax
80100ca0:	74 19                	je     80100cbb <consoleintr+0x26b>
80100ca2:	83 f8 04             	cmp    $0x4,%eax
80100ca5:	74 14                	je     80100cbb <consoleintr+0x26b>
80100ca7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100cac:	83 e8 80             	sub    $0xffffff80,%eax
80100caf:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100cb5:	0f 85 b0 fd ff ff    	jne    80100a6b <consoleintr+0x1b>
80100cbb:	bf 20 ef 10 80       	mov    $0x8010ef20,%edi
            for_str(history[i],history[i+1],strlen(history[i]));
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80100cc6:	57                   	push   %edi
80100cc7:	83 ef 80             	sub    $0xffffff80,%edi
80100cca:	e8 e1 3e 00 00       	call   80104bb0 <strlen>
  for(int i=0;i<127;i++){
80100ccf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100cd2:	83 c4 10             	add    $0x10,%esp
80100cd5:	31 c9                	xor    %ecx,%ecx
80100cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cde:	66 90                	xchg   %ax,%ax
    b[i]=a[i];
80100ce0:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
80100ce4:	88 04 0f             	mov    %al,(%edi,%ecx,1)
  for(int i=0;i<127;i++){
80100ce7:	83 c1 01             	add    $0x1,%ecx
80100cea:	83 f9 7f             	cmp    $0x7f,%ecx
80100ced:	75 f1                	jne    80100ce0 <consoleintr+0x290>
          for(int i = 0 ; i < 9 ; i++){
80100cef:	81 ff a0 f3 10 80    	cmp    $0x8010f3a0,%edi
80100cf5:	75 c9                	jne    80100cc0 <consoleintr+0x270>
            for_str(input.buf,history[0],strlen(history[0]));
80100cf7:	83 ec 0c             	sub    $0xc,%esp
80100cfa:	68 20 ef 10 80       	push   $0x8010ef20
80100cff:	e8 ac 3e 00 00       	call   80104bb0 <strlen>
80100d04:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<127;i++){
80100d07:	31 c0                	xor    %eax,%eax
80100d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    b[i]=a[i];
80100d10:	0f b6 90 80 ee 10 80 	movzbl -0x7fef1180(%eax),%edx
  for(int i=0;i<127;i++){
80100d17:	83 c0 01             	add    $0x1,%eax
    b[i]=a[i];
80100d1a:	88 90 1f ef 10 80    	mov    %dl,-0x7fef10e1(%eax)
  for(int i=0;i<127;i++){
80100d20:	83 f8 7f             	cmp    $0x7f,%eax
80100d23:	75 eb                	jne    80100d10 <consoleintr+0x2c0>
          wakeup(&input.r);
80100d25:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100d28:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100d2d:	68 00 ef 10 80       	push   $0x8010ef00
          input.w = input.e;
80100d32:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100d37:	e8 14 37 00 00       	call   80104450 <wakeup>
80100d3c:	83 c4 10             	add    $0x10,%esp
80100d3f:	e9 27 fd ff ff       	jmp    80100a6b <consoleintr+0x1b>
}
80100d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d47:	5b                   	pop    %ebx
80100d48:	5e                   	pop    %esi
80100d49:	5f                   	pop    %edi
80100d4a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100d4b:	e9 e0 37 00 00       	jmp    80104530 <procdump>
        curr_index --;
80100d50:	83 2d 0c ef 10 80 01 	subl   $0x1,0x8010ef0c
      break;
80100d57:	e9 0f fd ff ff       	jmp    80100a6b <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100d5c:	83 ec 0c             	sub    $0xc,%esp
    backspaces++;
80100d5f:	83 c2 01             	add    $0x1,%edx
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100d62:	6a 08                	push   $0x8
    backspaces++;
80100d64:	89 15 20 f4 10 80    	mov    %edx,0x8010f420
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100d6a:	e8 91 52 00 00       	call   80106000 <uartputc>
80100d6f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100d76:	e8 85 52 00 00       	call   80106000 <uartputc>
80100d7b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100d82:	e8 79 52 00 00       	call   80106000 <uartputc>
  cgaputc(c);
80100d87:	b8 00 01 00 00       	mov    $0x100,%eax
80100d8c:	e8 6f f6 ff ff       	call   80100400 <cgaputc>
}
80100d91:	83 c4 10             	add    $0x10,%esp
80100d94:	e9 d2 fc ff ff       	jmp    80100a6b <consoleintr+0x1b>
        consputc(c);
80100d99:	b8 0a 00 00 00       	mov    $0xa,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100d9e:	c6 81 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ecx)
        consputc(c);
80100da5:	e8 66 f8 ff ff       	call   80100610 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100daa:	e9 0c ff ff ff       	jmp    80100cbb <consoleintr+0x26b>
80100daf:	90                   	nop

80100db0 <consoleinit>:

void
consoleinit(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100db6:	68 48 75 10 80       	push   $0x80107548
80100dbb:	68 40 f4 10 80       	push   $0x8010f440
80100dc0:	e8 5b 39 00 00       	call   80104720 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100dc5:	58                   	pop    %eax
80100dc6:	5a                   	pop    %edx
80100dc7:	6a 00                	push   $0x0
80100dc9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100dcb:	c7 05 2c fe 10 80 80 	movl   $0x80100680,0x8010fe2c
80100dd2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100dd5:	c7 05 28 fe 10 80 80 	movl   $0x80100280,0x8010fe28
80100ddc:	02 10 80 
  cons.locking = 1;
80100ddf:	c7 05 74 f4 10 80 01 	movl   $0x1,0x8010f474
80100de6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100de9:	e8 e2 19 00 00       	call   801027d0 <ioapicenable>
}
80100dee:	83 c4 10             	add    $0x10,%esp
80100df1:	c9                   	leave  
80100df2:	c3                   	ret    
80100df3:	66 90                	xchg   %ax,%ax
80100df5:	66 90                	xchg   %ax,%ax
80100df7:	66 90                	xchg   %ax,%ax
80100df9:	66 90                	xchg   %ax,%ax
80100dfb:	66 90                	xchg   %ax,%ax
80100dfd:	66 90                	xchg   %ax,%ax
80100dff:	90                   	nop

80100e00 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	57                   	push   %edi
80100e04:	56                   	push   %esi
80100e05:	53                   	push   %ebx
80100e06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100e0c:	e8 af 2e 00 00       	call   80103cc0 <myproc>
80100e11:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100e17:	e8 94 22 00 00       	call   801030b0 <begin_op>

  if((ip = namei(path)) == 0){
80100e1c:	83 ec 0c             	sub    $0xc,%esp
80100e1f:	ff 75 08             	push   0x8(%ebp)
80100e22:	e8 c9 15 00 00       	call   801023f0 <namei>
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	0f 84 02 03 00 00    	je     80101134 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100e32:	83 ec 0c             	sub    $0xc,%esp
80100e35:	89 c3                	mov    %eax,%ebx
80100e37:	50                   	push   %eax
80100e38:	e8 93 0c 00 00       	call   80101ad0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e3d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100e43:	6a 34                	push   $0x34
80100e45:	6a 00                	push   $0x0
80100e47:	50                   	push   %eax
80100e48:	53                   	push   %ebx
80100e49:	e8 92 0f 00 00       	call   80101de0 <readi>
80100e4e:	83 c4 20             	add    $0x20,%esp
80100e51:	83 f8 34             	cmp    $0x34,%eax
80100e54:	74 22                	je     80100e78 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100e56:	83 ec 0c             	sub    $0xc,%esp
80100e59:	53                   	push   %ebx
80100e5a:	e8 01 0f 00 00       	call   80101d60 <iunlockput>
    end_op();
80100e5f:	e8 bc 22 00 00       	call   80103120 <end_op>
80100e64:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e6f:	5b                   	pop    %ebx
80100e70:	5e                   	pop    %esi
80100e71:	5f                   	pop    %edi
80100e72:	5d                   	pop    %ebp
80100e73:	c3                   	ret    
80100e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100e78:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e7f:	45 4c 46 
80100e82:	75 d2                	jne    80100e56 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100e84:	e8 07 63 00 00       	call   80107190 <setupkvm>
80100e89:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e8f:	85 c0                	test   %eax,%eax
80100e91:	74 c3                	je     80100e56 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e93:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e9a:	00 
80100e9b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100ea1:	0f 84 ac 02 00 00    	je     80101153 <exec+0x353>
  sz = 0;
80100ea7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100eae:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100eb1:	31 ff                	xor    %edi,%edi
80100eb3:	e9 8e 00 00 00       	jmp    80100f46 <exec+0x146>
80100eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100ec0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ec7:	75 6c                	jne    80100f35 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100ec9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ecf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ed5:	0f 82 87 00 00 00    	jb     80100f62 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100edb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ee1:	72 7f                	jb     80100f62 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ee3:	83 ec 04             	sub    $0x4,%esp
80100ee6:	50                   	push   %eax
80100ee7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100eed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ef3:	e8 b8 60 00 00       	call   80106fb0 <allocuvm>
80100ef8:	83 c4 10             	add    $0x10,%esp
80100efb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f01:	85 c0                	test   %eax,%eax
80100f03:	74 5d                	je     80100f62 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100f05:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f0b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f10:	75 50                	jne    80100f62 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f12:	83 ec 0c             	sub    $0xc,%esp
80100f15:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100f1b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100f21:	53                   	push   %ebx
80100f22:	50                   	push   %eax
80100f23:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f29:	e8 92 5f 00 00       	call   80106ec0 <loaduvm>
80100f2e:	83 c4 20             	add    $0x20,%esp
80100f31:	85 c0                	test   %eax,%eax
80100f33:	78 2d                	js     80100f62 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f35:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f3c:	83 c7 01             	add    $0x1,%edi
80100f3f:	83 c6 20             	add    $0x20,%esi
80100f42:	39 f8                	cmp    %edi,%eax
80100f44:	7e 3a                	jle    80100f80 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100f46:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100f4c:	6a 20                	push   $0x20
80100f4e:	56                   	push   %esi
80100f4f:	50                   	push   %eax
80100f50:	53                   	push   %ebx
80100f51:	e8 8a 0e 00 00       	call   80101de0 <readi>
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	83 f8 20             	cmp    $0x20,%eax
80100f5c:	0f 84 5e ff ff ff    	je     80100ec0 <exec+0xc0>
    freevm(pgdir);
80100f62:	83 ec 0c             	sub    $0xc,%esp
80100f65:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f6b:	e8 a0 61 00 00       	call   80107110 <freevm>
  if(ip){
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	e9 de fe ff ff       	jmp    80100e56 <exec+0x56>
80100f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7f:	90                   	nop
  sz = PGROUNDUP(sz);
80100f80:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100f86:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100f8c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f92:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	53                   	push   %ebx
80100f9c:	e8 bf 0d 00 00       	call   80101d60 <iunlockput>
  end_op();
80100fa1:	e8 7a 21 00 00       	call   80103120 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100fa6:	83 c4 0c             	add    $0xc,%esp
80100fa9:	56                   	push   %esi
80100faa:	57                   	push   %edi
80100fab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100fb1:	57                   	push   %edi
80100fb2:	e8 f9 5f 00 00       	call   80106fb0 <allocuvm>
80100fb7:	83 c4 10             	add    $0x10,%esp
80100fba:	89 c6                	mov    %eax,%esi
80100fbc:	85 c0                	test   %eax,%eax
80100fbe:	0f 84 94 00 00 00    	je     80101058 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100fcd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fcf:	50                   	push   %eax
80100fd0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100fd1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fd3:	e8 58 62 00 00       	call   80107230 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdb:	83 c4 10             	add    $0x10,%esp
80100fde:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100fe4:	8b 00                	mov    (%eax),%eax
80100fe6:	85 c0                	test   %eax,%eax
80100fe8:	0f 84 8b 00 00 00    	je     80101079 <exec+0x279>
80100fee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ff4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ffa:	eb 23                	jmp    8010101f <exec+0x21f>
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101000:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101003:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010100a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010100d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101013:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101016:	85 c0                	test   %eax,%eax
80101018:	74 59                	je     80101073 <exec+0x273>
    if(argc >= MAXARG)
8010101a:	83 ff 20             	cmp    $0x20,%edi
8010101d:	74 39                	je     80101058 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	50                   	push   %eax
80101023:	e8 88 3b 00 00       	call   80104bb0 <strlen>
80101028:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010102a:	58                   	pop    %eax
8010102b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010102e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101031:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101034:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101037:	e8 74 3b 00 00       	call   80104bb0 <strlen>
8010103c:	83 c0 01             	add    $0x1,%eax
8010103f:	50                   	push   %eax
80101040:	8b 45 0c             	mov    0xc(%ebp),%eax
80101043:	ff 34 b8             	push   (%eax,%edi,4)
80101046:	53                   	push   %ebx
80101047:	56                   	push   %esi
80101048:	e8 b3 63 00 00       	call   80107400 <copyout>
8010104d:	83 c4 20             	add    $0x20,%esp
80101050:	85 c0                	test   %eax,%eax
80101052:	79 ac                	jns    80101000 <exec+0x200>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101061:	e8 aa 60 00 00       	call   80107110 <freevm>
80101066:	83 c4 10             	add    $0x10,%esp
  return -1;
80101069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010106e:	e9 f9 fd ff ff       	jmp    80100e6c <exec+0x6c>
80101073:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101079:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101080:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101082:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101089:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010108d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010108f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101092:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101098:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010109a:	50                   	push   %eax
8010109b:	52                   	push   %edx
8010109c:	53                   	push   %ebx
8010109d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801010a3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801010aa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010ad:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010b3:	e8 48 63 00 00       	call   80107400 <copyout>
801010b8:	83 c4 10             	add    $0x10,%esp
801010bb:	85 c0                	test   %eax,%eax
801010bd:	78 99                	js     80101058 <exec+0x258>
  for(last=s=path; *s; s++)
801010bf:	8b 45 08             	mov    0x8(%ebp),%eax
801010c2:	8b 55 08             	mov    0x8(%ebp),%edx
801010c5:	0f b6 00             	movzbl (%eax),%eax
801010c8:	84 c0                	test   %al,%al
801010ca:	74 13                	je     801010df <exec+0x2df>
801010cc:	89 d1                	mov    %edx,%ecx
801010ce:	66 90                	xchg   %ax,%ax
      last = s+1;
801010d0:	83 c1 01             	add    $0x1,%ecx
801010d3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801010d5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
801010d8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801010db:	84 c0                	test   %al,%al
801010dd:	75 f1                	jne    801010d0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010df:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801010e5:	83 ec 04             	sub    $0x4,%esp
801010e8:	6a 10                	push   $0x10
801010ea:	89 f8                	mov    %edi,%eax
801010ec:	52                   	push   %edx
801010ed:	83 c0 6c             	add    $0x6c,%eax
801010f0:	50                   	push   %eax
801010f1:	e8 7a 3a 00 00       	call   80104b70 <safestrcpy>
  curproc->pgdir = pgdir;
801010f6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801010fc:	89 f8                	mov    %edi,%eax
801010fe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101101:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101103:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101106:	89 c1                	mov    %eax,%ecx
80101108:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010110e:	8b 40 18             	mov    0x18(%eax),%eax
80101111:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101114:	8b 41 18             	mov    0x18(%ecx),%eax
80101117:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010111a:	89 0c 24             	mov    %ecx,(%esp)
8010111d:	e8 0e 5c 00 00       	call   80106d30 <switchuvm>
  freevm(oldpgdir);
80101122:	89 3c 24             	mov    %edi,(%esp)
80101125:	e8 e6 5f 00 00       	call   80107110 <freevm>
  return 0;
8010112a:	83 c4 10             	add    $0x10,%esp
8010112d:	31 c0                	xor    %eax,%eax
8010112f:	e9 38 fd ff ff       	jmp    80100e6c <exec+0x6c>
    end_op();
80101134:	e8 e7 1f 00 00       	call   80103120 <end_op>
    cprintf("exec: fail\n");
80101139:	83 ec 0c             	sub    $0xc,%esp
8010113c:	68 61 75 10 80       	push   $0x80107561
80101141:	e8 6a f6 ff ff       	call   801007b0 <cprintf>
    return -1;
80101146:	83 c4 10             	add    $0x10,%esp
80101149:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010114e:	e9 19 fd ff ff       	jmp    80100e6c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101153:	be 00 20 00 00       	mov    $0x2000,%esi
80101158:	31 ff                	xor    %edi,%edi
8010115a:	e9 39 fe ff ff       	jmp    80100f98 <exec+0x198>
8010115f:	90                   	nop

80101160 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101166:	68 6d 75 10 80       	push   $0x8010756d
8010116b:	68 80 f4 10 80       	push   $0x8010f480
80101170:	e8 ab 35 00 00       	call   80104720 <initlock>
}
80101175:	83 c4 10             	add    $0x10,%esp
80101178:	c9                   	leave  
80101179:	c3                   	ret    
8010117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101180 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101184:	bb b4 f4 10 80       	mov    $0x8010f4b4,%ebx
{
80101189:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010118c:	68 80 f4 10 80       	push   $0x8010f480
80101191:	e8 5a 37 00 00       	call   801048f0 <acquire>
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	eb 10                	jmp    801011ab <filealloc+0x2b>
8010119b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010119f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011a0:	83 c3 18             	add    $0x18,%ebx
801011a3:	81 fb 14 fe 10 80    	cmp    $0x8010fe14,%ebx
801011a9:	74 25                	je     801011d0 <filealloc+0x50>
    if(f->ref == 0){
801011ab:	8b 43 04             	mov    0x4(%ebx),%eax
801011ae:	85 c0                	test   %eax,%eax
801011b0:	75 ee                	jne    801011a0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801011b2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801011b5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801011bc:	68 80 f4 10 80       	push   $0x8010f480
801011c1:	e8 ca 36 00 00       	call   80104890 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801011c6:	89 d8                	mov    %ebx,%eax
      return f;
801011c8:	83 c4 10             	add    $0x10,%esp
}
801011cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011ce:	c9                   	leave  
801011cf:	c3                   	ret    
  release(&ftable.lock);
801011d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801011d3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801011d5:	68 80 f4 10 80       	push   $0x8010f480
801011da:	e8 b1 36 00 00       	call   80104890 <release>
}
801011df:	89 d8                	mov    %ebx,%eax
  return 0;
801011e1:	83 c4 10             	add    $0x10,%esp
}
801011e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011e7:	c9                   	leave  
801011e8:	c3                   	ret    
801011e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	53                   	push   %ebx
801011f4:	83 ec 10             	sub    $0x10,%esp
801011f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011fa:	68 80 f4 10 80       	push   $0x8010f480
801011ff:	e8 ec 36 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80101204:	8b 43 04             	mov    0x4(%ebx),%eax
80101207:	83 c4 10             	add    $0x10,%esp
8010120a:	85 c0                	test   %eax,%eax
8010120c:	7e 1a                	jle    80101228 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010120e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101211:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101214:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101217:	68 80 f4 10 80       	push   $0x8010f480
8010121c:	e8 6f 36 00 00       	call   80104890 <release>
  return f;
}
80101221:	89 d8                	mov    %ebx,%eax
80101223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101226:	c9                   	leave  
80101227:	c3                   	ret    
    panic("filedup");
80101228:	83 ec 0c             	sub    $0xc,%esp
8010122b:	68 74 75 10 80       	push   $0x80107574
80101230:	e8 4b f1 ff ff       	call   80100380 <panic>
80101235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101240 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 28             	sub    $0x28,%esp
80101249:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010124c:	68 80 f4 10 80       	push   $0x8010f480
80101251:	e8 9a 36 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80101256:	8b 53 04             	mov    0x4(%ebx),%edx
80101259:	83 c4 10             	add    $0x10,%esp
8010125c:	85 d2                	test   %edx,%edx
8010125e:	0f 8e a5 00 00 00    	jle    80101309 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101264:	83 ea 01             	sub    $0x1,%edx
80101267:	89 53 04             	mov    %edx,0x4(%ebx)
8010126a:	75 44                	jne    801012b0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010126c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101270:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101273:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010127b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010127e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101281:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101284:	68 80 f4 10 80       	push   $0x8010f480
  ff = *f;
80101289:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010128c:	e8 ff 35 00 00       	call   80104890 <release>

  if(ff.type == FD_PIPE)
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	83 ff 01             	cmp    $0x1,%edi
80101297:	74 57                	je     801012f0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101299:	83 ff 02             	cmp    $0x2,%edi
8010129c:	74 2a                	je     801012c8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010129e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a1:	5b                   	pop    %ebx
801012a2:	5e                   	pop    %esi
801012a3:	5f                   	pop    %edi
801012a4:	5d                   	pop    %ebp
801012a5:	c3                   	ret    
801012a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801012b0:	c7 45 08 80 f4 10 80 	movl   $0x8010f480,0x8(%ebp)
}
801012b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ba:	5b                   	pop    %ebx
801012bb:	5e                   	pop    %esi
801012bc:	5f                   	pop    %edi
801012bd:	5d                   	pop    %ebp
    release(&ftable.lock);
801012be:	e9 cd 35 00 00       	jmp    80104890 <release>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
    begin_op();
801012c8:	e8 e3 1d 00 00       	call   801030b0 <begin_op>
    iput(ff.ip);
801012cd:	83 ec 0c             	sub    $0xc,%esp
801012d0:	ff 75 e0             	push   -0x20(%ebp)
801012d3:	e8 28 09 00 00       	call   80101c00 <iput>
    end_op();
801012d8:	83 c4 10             	add    $0x10,%esp
}
801012db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012de:	5b                   	pop    %ebx
801012df:	5e                   	pop    %esi
801012e0:	5f                   	pop    %edi
801012e1:	5d                   	pop    %ebp
    end_op();
801012e2:	e9 39 1e 00 00       	jmp    80103120 <end_op>
801012e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801012f0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012f4:	83 ec 08             	sub    $0x8,%esp
801012f7:	53                   	push   %ebx
801012f8:	56                   	push   %esi
801012f9:	e8 82 25 00 00       	call   80103880 <pipeclose>
801012fe:	83 c4 10             	add    $0x10,%esp
}
80101301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101304:	5b                   	pop    %ebx
80101305:	5e                   	pop    %esi
80101306:	5f                   	pop    %edi
80101307:	5d                   	pop    %ebp
80101308:	c3                   	ret    
    panic("fileclose");
80101309:	83 ec 0c             	sub    $0xc,%esp
8010130c:	68 7c 75 10 80       	push   $0x8010757c
80101311:	e8 6a f0 ff ff       	call   80100380 <panic>
80101316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010131d:	8d 76 00             	lea    0x0(%esi),%esi

80101320 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	53                   	push   %ebx
80101324:	83 ec 04             	sub    $0x4,%esp
80101327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010132a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010132d:	75 31                	jne    80101360 <filestat+0x40>
    ilock(f->ip);
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	ff 73 10             	push   0x10(%ebx)
80101335:	e8 96 07 00 00       	call   80101ad0 <ilock>
    stati(f->ip, st);
8010133a:	58                   	pop    %eax
8010133b:	5a                   	pop    %edx
8010133c:	ff 75 0c             	push   0xc(%ebp)
8010133f:	ff 73 10             	push   0x10(%ebx)
80101342:	e8 69 0a 00 00       	call   80101db0 <stati>
    iunlock(f->ip);
80101347:	59                   	pop    %ecx
80101348:	ff 73 10             	push   0x10(%ebx)
8010134b:	e8 60 08 00 00       	call   80101bb0 <iunlock>
    return 0;
  }
  return -1;
}
80101350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101353:	83 c4 10             	add    $0x10,%esp
80101356:	31 c0                	xor    %eax,%eax
}
80101358:	c9                   	leave  
80101359:	c3                   	ret    
8010135a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101368:	c9                   	leave  
80101369:	c3                   	ret    
8010136a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101370 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010137c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010137f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101382:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101386:	74 60                	je     801013e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101388:	8b 03                	mov    (%ebx),%eax
8010138a:	83 f8 01             	cmp    $0x1,%eax
8010138d:	74 41                	je     801013d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010138f:	83 f8 02             	cmp    $0x2,%eax
80101392:	75 5b                	jne    801013ef <fileread+0x7f>
    ilock(f->ip);
80101394:	83 ec 0c             	sub    $0xc,%esp
80101397:	ff 73 10             	push   0x10(%ebx)
8010139a:	e8 31 07 00 00       	call   80101ad0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010139f:	57                   	push   %edi
801013a0:	ff 73 14             	push   0x14(%ebx)
801013a3:	56                   	push   %esi
801013a4:	ff 73 10             	push   0x10(%ebx)
801013a7:	e8 34 0a 00 00       	call   80101de0 <readi>
801013ac:	83 c4 20             	add    $0x20,%esp
801013af:	89 c6                	mov    %eax,%esi
801013b1:	85 c0                	test   %eax,%eax
801013b3:	7e 03                	jle    801013b8 <fileread+0x48>
      f->off += r;
801013b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013b8:	83 ec 0c             	sub    $0xc,%esp
801013bb:	ff 73 10             	push   0x10(%ebx)
801013be:	e8 ed 07 00 00       	call   80101bb0 <iunlock>
    return r;
801013c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801013c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c9:	89 f0                	mov    %esi,%eax
801013cb:	5b                   	pop    %ebx
801013cc:	5e                   	pop    %esi
801013cd:	5f                   	pop    %edi
801013ce:	5d                   	pop    %ebp
801013cf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801013d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801013d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d9:	5b                   	pop    %ebx
801013da:	5e                   	pop    %esi
801013db:	5f                   	pop    %edi
801013dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801013dd:	e9 3e 26 00 00       	jmp    80103a20 <piperead>
801013e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801013e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801013ed:	eb d7                	jmp    801013c6 <fileread+0x56>
  panic("fileread");
801013ef:	83 ec 0c             	sub    $0xc,%esp
801013f2:	68 86 75 10 80       	push   $0x80107586
801013f7:	e8 84 ef ff ff       	call   80100380 <panic>
801013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101400 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	56                   	push   %esi
80101405:	53                   	push   %ebx
80101406:	83 ec 1c             	sub    $0x1c,%esp
80101409:	8b 45 0c             	mov    0xc(%ebp),%eax
8010140c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010140f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101412:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101415:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010141c:	0f 84 bd 00 00 00    	je     801014df <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101422:	8b 03                	mov    (%ebx),%eax
80101424:	83 f8 01             	cmp    $0x1,%eax
80101427:	0f 84 bf 00 00 00    	je     801014ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010142d:	83 f8 02             	cmp    $0x2,%eax
80101430:	0f 85 c8 00 00 00    	jne    801014fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101439:	31 f6                	xor    %esi,%esi
    while(i < n){
8010143b:	85 c0                	test   %eax,%eax
8010143d:	7f 30                	jg     8010146f <filewrite+0x6f>
8010143f:	e9 94 00 00 00       	jmp    801014d8 <filewrite+0xd8>
80101444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101448:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010144b:	83 ec 0c             	sub    $0xc,%esp
8010144e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101451:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101454:	e8 57 07 00 00       	call   80101bb0 <iunlock>
      end_op();
80101459:	e8 c2 1c 00 00       	call   80103120 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010145e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101461:	83 c4 10             	add    $0x10,%esp
80101464:	39 c7                	cmp    %eax,%edi
80101466:	75 5c                	jne    801014c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101468:	01 fe                	add    %edi,%esi
    while(i < n){
8010146a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010146d:	7e 69                	jle    801014d8 <filewrite+0xd8>
      int n1 = n - i;
8010146f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101472:	b8 00 06 00 00       	mov    $0x600,%eax
80101477:	29 f7                	sub    %esi,%edi
80101479:	39 c7                	cmp    %eax,%edi
8010147b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010147e:	e8 2d 1c 00 00       	call   801030b0 <begin_op>
      ilock(f->ip);
80101483:	83 ec 0c             	sub    $0xc,%esp
80101486:	ff 73 10             	push   0x10(%ebx)
80101489:	e8 42 06 00 00       	call   80101ad0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010148e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101491:	57                   	push   %edi
80101492:	ff 73 14             	push   0x14(%ebx)
80101495:	01 f0                	add    %esi,%eax
80101497:	50                   	push   %eax
80101498:	ff 73 10             	push   0x10(%ebx)
8010149b:	e8 40 0a 00 00       	call   80101ee0 <writei>
801014a0:	83 c4 20             	add    $0x20,%esp
801014a3:	85 c0                	test   %eax,%eax
801014a5:	7f a1                	jg     80101448 <filewrite+0x48>
      iunlock(f->ip);
801014a7:	83 ec 0c             	sub    $0xc,%esp
801014aa:	ff 73 10             	push   0x10(%ebx)
801014ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014b0:	e8 fb 06 00 00       	call   80101bb0 <iunlock>
      end_op();
801014b5:	e8 66 1c 00 00       	call   80103120 <end_op>
      if(r < 0)
801014ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014bd:	83 c4 10             	add    $0x10,%esp
801014c0:	85 c0                	test   %eax,%eax
801014c2:	75 1b                	jne    801014df <filewrite+0xdf>
        panic("short filewrite");
801014c4:	83 ec 0c             	sub    $0xc,%esp
801014c7:	68 8f 75 10 80       	push   $0x8010758f
801014cc:	e8 af ee ff ff       	call   80100380 <panic>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801014d8:	89 f0                	mov    %esi,%eax
801014da:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801014dd:	74 05                	je     801014e4 <filewrite+0xe4>
801014df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801014e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e7:	5b                   	pop    %ebx
801014e8:	5e                   	pop    %esi
801014e9:	5f                   	pop    %edi
801014ea:	5d                   	pop    %ebp
801014eb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801014ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801014ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801014f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801014f9:	e9 22 24 00 00       	jmp    80103920 <pipewrite>
  panic("filewrite");
801014fe:	83 ec 0c             	sub    $0xc,%esp
80101501:	68 95 75 10 80       	push   $0x80107595
80101506:	e8 75 ee ff ff       	call   80100380 <panic>
8010150b:	66 90                	xchg   %ax,%ax
8010150d:	66 90                	xchg   %ax,%ax
8010150f:	90                   	nop

80101510 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101510:	55                   	push   %ebp
80101511:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101513:	89 d0                	mov    %edx,%eax
80101515:	c1 e8 0c             	shr    $0xc,%eax
80101518:	03 05 ec 1a 11 80    	add    0x80111aec,%eax
{
8010151e:	89 e5                	mov    %esp,%ebp
80101520:	56                   	push   %esi
80101521:	53                   	push   %ebx
80101522:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101524:	83 ec 08             	sub    $0x8,%esp
80101527:	50                   	push   %eax
80101528:	51                   	push   %ecx
80101529:	e8 a2 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010152e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101530:	c1 fb 03             	sar    $0x3,%ebx
80101533:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101536:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101538:	83 e1 07             	and    $0x7,%ecx
8010153b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101540:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101546:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101548:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010154d:	85 c1                	test   %eax,%ecx
8010154f:	74 23                	je     80101574 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101551:	f7 d0                	not    %eax
  log_write(bp);
80101553:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101556:	21 c8                	and    %ecx,%eax
80101558:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010155c:	56                   	push   %esi
8010155d:	e8 2e 1d 00 00       	call   80103290 <log_write>
  brelse(bp);
80101562:	89 34 24             	mov    %esi,(%esp)
80101565:	e8 86 ec ff ff       	call   801001f0 <brelse>
}
8010156a:	83 c4 10             	add    $0x10,%esp
8010156d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101570:	5b                   	pop    %ebx
80101571:	5e                   	pop    %esi
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
    panic("freeing free block");
80101574:	83 ec 0c             	sub    $0xc,%esp
80101577:	68 9f 75 10 80       	push   $0x8010759f
8010157c:	e8 ff ed ff ff       	call   80100380 <panic>
80101581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010158f:	90                   	nop

80101590 <balloc>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101599:	8b 0d d4 1a 11 80    	mov    0x80111ad4,%ecx
{
8010159f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015a2:	85 c9                	test   %ecx,%ecx
801015a4:	0f 84 87 00 00 00    	je     80101631 <balloc+0xa1>
801015aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015b4:	83 ec 08             	sub    $0x8,%esp
801015b7:	89 f0                	mov    %esi,%eax
801015b9:	c1 f8 0c             	sar    $0xc,%eax
801015bc:	03 05 ec 1a 11 80    	add    0x80111aec,%eax
801015c2:	50                   	push   %eax
801015c3:	ff 75 d8             	push   -0x28(%ebp)
801015c6:	e8 05 eb ff ff       	call   801000d0 <bread>
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015d1:	a1 d4 1a 11 80       	mov    0x80111ad4,%eax
801015d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801015d9:	31 c0                	xor    %eax,%eax
801015db:	eb 2f                	jmp    8010160c <balloc+0x7c>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801015e0:	89 c1                	mov    %eax,%ecx
801015e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801015ea:	83 e1 07             	and    $0x7,%ecx
801015ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015ef:	89 c1                	mov    %eax,%ecx
801015f1:	c1 f9 03             	sar    $0x3,%ecx
801015f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801015f9:	89 fa                	mov    %edi,%edx
801015fb:	85 df                	test   %ebx,%edi
801015fd:	74 41                	je     80101640 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ff:	83 c0 01             	add    $0x1,%eax
80101602:	83 c6 01             	add    $0x1,%esi
80101605:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010160a:	74 05                	je     80101611 <balloc+0x81>
8010160c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010160f:	77 cf                	ja     801015e0 <balloc+0x50>
    brelse(bp);
80101611:	83 ec 0c             	sub    $0xc,%esp
80101614:	ff 75 e4             	push   -0x1c(%ebp)
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010161c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101623:	83 c4 10             	add    $0x10,%esp
80101626:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101629:	39 05 d4 1a 11 80    	cmp    %eax,0x80111ad4
8010162f:	77 80                	ja     801015b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101631:	83 ec 0c             	sub    $0xc,%esp
80101634:	68 b2 75 10 80       	push   $0x801075b2
80101639:	e8 42 ed ff ff       	call   80100380 <panic>
8010163e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101643:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101646:	09 da                	or     %ebx,%edx
80101648:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010164c:	57                   	push   %edi
8010164d:	e8 3e 1c 00 00       	call   80103290 <log_write>
        brelse(bp);
80101652:	89 3c 24             	mov    %edi,(%esp)
80101655:	e8 96 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010165a:	58                   	pop    %eax
8010165b:	5a                   	pop    %edx
8010165c:	56                   	push   %esi
8010165d:	ff 75 d8             	push   -0x28(%ebp)
80101660:	e8 6b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101665:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101668:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010166a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010166d:	68 00 02 00 00       	push   $0x200
80101672:	6a 00                	push   $0x0
80101674:	50                   	push   %eax
80101675:	e8 36 33 00 00       	call   801049b0 <memset>
  log_write(bp);
8010167a:	89 1c 24             	mov    %ebx,(%esp)
8010167d:	e8 0e 1c 00 00       	call   80103290 <log_write>
  brelse(bp);
80101682:	89 1c 24             	mov    %ebx,(%esp)
80101685:	e8 66 eb ff ff       	call   801001f0 <brelse>
}
8010168a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010168d:	89 f0                	mov    %esi,%eax
8010168f:	5b                   	pop    %ebx
80101690:	5e                   	pop    %esi
80101691:	5f                   	pop    %edi
80101692:	5d                   	pop    %ebp
80101693:	c3                   	ret    
80101694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010169b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010169f:	90                   	nop

801016a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	89 c7                	mov    %eax,%edi
801016a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016a7:	31 f6                	xor    %esi,%esi
{
801016a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016aa:	bb b4 fe 10 80       	mov    $0x8010feb4,%ebx
{
801016af:	83 ec 28             	sub    $0x28,%esp
801016b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801016b5:	68 80 fe 10 80       	push   $0x8010fe80
801016ba:	e8 31 32 00 00       	call   801048f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801016c2:	83 c4 10             	add    $0x10,%esp
801016c5:	eb 1b                	jmp    801016e2 <iget+0x42>
801016c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016d0:	39 3b                	cmp    %edi,(%ebx)
801016d2:	74 6c                	je     80101740 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016da:	81 fb d4 1a 11 80    	cmp    $0x80111ad4,%ebx
801016e0:	73 26                	jae    80101708 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016e2:	8b 43 08             	mov    0x8(%ebx),%eax
801016e5:	85 c0                	test   %eax,%eax
801016e7:	7f e7                	jg     801016d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016e9:	85 f6                	test   %esi,%esi
801016eb:	75 e7                	jne    801016d4 <iget+0x34>
801016ed:	85 c0                	test   %eax,%eax
801016ef:	75 76                	jne    80101767 <iget+0xc7>
801016f1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016f3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016f9:	81 fb d4 1a 11 80    	cmp    $0x80111ad4,%ebx
801016ff:	72 e1                	jb     801016e2 <iget+0x42>
80101701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101708:	85 f6                	test   %esi,%esi
8010170a:	74 79                	je     80101785 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010170c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010170f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101711:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101714:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010171b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101722:	68 80 fe 10 80       	push   $0x8010fe80
80101727:	e8 64 31 00 00       	call   80104890 <release>

  return ip;
8010172c:	83 c4 10             	add    $0x10,%esp
}
8010172f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101732:	89 f0                	mov    %esi,%eax
80101734:	5b                   	pop    %ebx
80101735:	5e                   	pop    %esi
80101736:	5f                   	pop    %edi
80101737:	5d                   	pop    %ebp
80101738:	c3                   	ret    
80101739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101740:	39 53 04             	cmp    %edx,0x4(%ebx)
80101743:	75 8f                	jne    801016d4 <iget+0x34>
      release(&icache.lock);
80101745:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101748:	83 c0 01             	add    $0x1,%eax
      return ip;
8010174b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010174d:	68 80 fe 10 80       	push   $0x8010fe80
      ip->ref++;
80101752:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101755:	e8 36 31 00 00       	call   80104890 <release>
      return ip;
8010175a:	83 c4 10             	add    $0x10,%esp
}
8010175d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101760:	89 f0                	mov    %esi,%eax
80101762:	5b                   	pop    %ebx
80101763:	5e                   	pop    %esi
80101764:	5f                   	pop    %edi
80101765:	5d                   	pop    %ebp
80101766:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101767:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010176d:	81 fb d4 1a 11 80    	cmp    $0x80111ad4,%ebx
80101773:	73 10                	jae    80101785 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101775:	8b 43 08             	mov    0x8(%ebx),%eax
80101778:	85 c0                	test   %eax,%eax
8010177a:	0f 8f 50 ff ff ff    	jg     801016d0 <iget+0x30>
80101780:	e9 68 ff ff ff       	jmp    801016ed <iget+0x4d>
    panic("iget: no inodes");
80101785:	83 ec 0c             	sub    $0xc,%esp
80101788:	68 c8 75 10 80       	push   $0x801075c8
8010178d:	e8 ee eb ff ff       	call   80100380 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801017a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	89 c6                	mov    %eax,%esi
801017a7:	53                   	push   %ebx
801017a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017ab:	83 fa 0b             	cmp    $0xb,%edx
801017ae:	0f 86 8c 00 00 00    	jbe    80101840 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801017b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801017b7:	83 fb 7f             	cmp    $0x7f,%ebx
801017ba:	0f 87 a2 00 00 00    	ja     80101862 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801017c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801017c6:	85 c0                	test   %eax,%eax
801017c8:	74 5e                	je     80101828 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801017ca:	83 ec 08             	sub    $0x8,%esp
801017cd:	50                   	push   %eax
801017ce:	ff 36                	push   (%esi)
801017d0:	e8 fb e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801017dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801017de:	8b 3b                	mov    (%ebx),%edi
801017e0:	85 ff                	test   %edi,%edi
801017e2:	74 1c                	je     80101800 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801017e4:	83 ec 0c             	sub    $0xc,%esp
801017e7:	52                   	push   %edx
801017e8:	e8 03 ea ff ff       	call   801001f0 <brelse>
801017ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f3:	89 f8                	mov    %edi,%eax
801017f5:	5b                   	pop    %ebx
801017f6:	5e                   	pop    %esi
801017f7:	5f                   	pop    %edi
801017f8:	5d                   	pop    %ebp
801017f9:	c3                   	ret    
801017fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101800:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101803:	8b 06                	mov    (%esi),%eax
80101805:	e8 86 fd ff ff       	call   80101590 <balloc>
      log_write(bp);
8010180a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010180d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101810:	89 03                	mov    %eax,(%ebx)
80101812:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101814:	52                   	push   %edx
80101815:	e8 76 1a 00 00       	call   80103290 <log_write>
8010181a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010181d:	83 c4 10             	add    $0x10,%esp
80101820:	eb c2                	jmp    801017e4 <bmap+0x44>
80101822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101828:	8b 06                	mov    (%esi),%eax
8010182a:	e8 61 fd ff ff       	call   80101590 <balloc>
8010182f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101835:	eb 93                	jmp    801017ca <bmap+0x2a>
80101837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101840:	8d 5a 14             	lea    0x14(%edx),%ebx
80101843:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101847:	85 ff                	test   %edi,%edi
80101849:	75 a5                	jne    801017f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010184b:	8b 00                	mov    (%eax),%eax
8010184d:	e8 3e fd ff ff       	call   80101590 <balloc>
80101852:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101856:	89 c7                	mov    %eax,%edi
}
80101858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010185b:	5b                   	pop    %ebx
8010185c:	89 f8                	mov    %edi,%eax
8010185e:	5e                   	pop    %esi
8010185f:	5f                   	pop    %edi
80101860:	5d                   	pop    %ebp
80101861:	c3                   	ret    
  panic("bmap: out of range");
80101862:	83 ec 0c             	sub    $0xc,%esp
80101865:	68 d8 75 10 80       	push   $0x801075d8
8010186a:	e8 11 eb ff ff       	call   80100380 <panic>
8010186f:	90                   	nop

80101870 <readsb>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101878:	83 ec 08             	sub    $0x8,%esp
8010187b:	6a 01                	push   $0x1
8010187d:	ff 75 08             	push   0x8(%ebp)
80101880:	e8 4b e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101885:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101888:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010188a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010188d:	6a 1c                	push   $0x1c
8010188f:	50                   	push   %eax
80101890:	56                   	push   %esi
80101891:	e8 ba 31 00 00       	call   80104a50 <memmove>
  brelse(bp);
80101896:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101899:	83 c4 10             	add    $0x10,%esp
}
8010189c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010189f:	5b                   	pop    %ebx
801018a0:	5e                   	pop    %esi
801018a1:	5d                   	pop    %ebp
  brelse(bp);
801018a2:	e9 49 e9 ff ff       	jmp    801001f0 <brelse>
801018a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ae:	66 90                	xchg   %ax,%ax

801018b0 <iinit>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	53                   	push   %ebx
801018b4:	bb c0 fe 10 80       	mov    $0x8010fec0,%ebx
801018b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018bc:	68 eb 75 10 80       	push   $0x801075eb
801018c1:	68 80 fe 10 80       	push   $0x8010fe80
801018c6:	e8 55 2e 00 00       	call   80104720 <initlock>
  for(i = 0; i < NINODE; i++) {
801018cb:	83 c4 10             	add    $0x10,%esp
801018ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	68 f2 75 10 80       	push   $0x801075f2
801018d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801018d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801018df:	e8 0c 2d 00 00       	call   801045f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801018e4:	83 c4 10             	add    $0x10,%esp
801018e7:	81 fb e0 1a 11 80    	cmp    $0x80111ae0,%ebx
801018ed:	75 e1                	jne    801018d0 <iinit+0x20>
  bp = bread(dev, 1);
801018ef:	83 ec 08             	sub    $0x8,%esp
801018f2:	6a 01                	push   $0x1
801018f4:	ff 75 08             	push   0x8(%ebp)
801018f7:	e8 d4 e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101901:	8d 40 5c             	lea    0x5c(%eax),%eax
80101904:	6a 1c                	push   $0x1c
80101906:	50                   	push   %eax
80101907:	68 d4 1a 11 80       	push   $0x80111ad4
8010190c:	e8 3f 31 00 00       	call   80104a50 <memmove>
  brelse(bp);
80101911:	89 1c 24             	mov    %ebx,(%esp)
80101914:	e8 d7 e8 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101919:	ff 35 ec 1a 11 80    	push   0x80111aec
8010191f:	ff 35 e8 1a 11 80    	push   0x80111ae8
80101925:	ff 35 e4 1a 11 80    	push   0x80111ae4
8010192b:	ff 35 e0 1a 11 80    	push   0x80111ae0
80101931:	ff 35 dc 1a 11 80    	push   0x80111adc
80101937:	ff 35 d8 1a 11 80    	push   0x80111ad8
8010193d:	ff 35 d4 1a 11 80    	push   0x80111ad4
80101943:	68 58 76 10 80       	push   $0x80107658
80101948:	e8 63 ee ff ff       	call   801007b0 <cprintf>
}
8010194d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101950:	83 c4 30             	add    $0x30,%esp
80101953:	c9                   	leave  
80101954:	c3                   	ret    
80101955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <ialloc>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010196c:	83 3d dc 1a 11 80 01 	cmpl   $0x1,0x80111adc
{
80101973:	8b 75 08             	mov    0x8(%ebp),%esi
80101976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101979:	0f 86 91 00 00 00    	jbe    80101a10 <ialloc+0xb0>
8010197f:	bf 01 00 00 00       	mov    $0x1,%edi
80101984:	eb 21                	jmp    801019a7 <ialloc+0x47>
80101986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101990:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101993:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101996:	53                   	push   %ebx
80101997:	e8 54 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010199c:	83 c4 10             	add    $0x10,%esp
8010199f:	3b 3d dc 1a 11 80    	cmp    0x80111adc,%edi
801019a5:	73 69                	jae    80101a10 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019a7:	89 f8                	mov    %edi,%eax
801019a9:	83 ec 08             	sub    $0x8,%esp
801019ac:	c1 e8 03             	shr    $0x3,%eax
801019af:	03 05 e8 1a 11 80    	add    0x80111ae8,%eax
801019b5:	50                   	push   %eax
801019b6:	56                   	push   %esi
801019b7:	e8 14 e7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801019bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801019bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801019c1:	89 f8                	mov    %edi,%eax
801019c3:	83 e0 07             	and    $0x7,%eax
801019c6:	c1 e0 06             	shl    $0x6,%eax
801019c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801019cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019d1:	75 bd                	jne    80101990 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801019d3:	83 ec 04             	sub    $0x4,%esp
801019d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019d9:	6a 40                	push   $0x40
801019db:	6a 00                	push   $0x0
801019dd:	51                   	push   %ecx
801019de:	e8 cd 2f 00 00       	call   801049b0 <memset>
      dip->type = type;
801019e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019ed:	89 1c 24             	mov    %ebx,(%esp)
801019f0:	e8 9b 18 00 00       	call   80103290 <log_write>
      brelse(bp);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 f3 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801019fd:	83 c4 10             	add    $0x10,%esp
}
80101a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a03:	89 fa                	mov    %edi,%edx
}
80101a05:	5b                   	pop    %ebx
      return iget(dev, inum);
80101a06:	89 f0                	mov    %esi,%eax
}
80101a08:	5e                   	pop    %esi
80101a09:	5f                   	pop    %edi
80101a0a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a0b:	e9 90 fc ff ff       	jmp    801016a0 <iget>
  panic("ialloc: no inodes");
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	68 f8 75 10 80       	push   $0x801075f8
80101a18:	e8 63 e9 ff ff       	call   80100380 <panic>
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi

80101a20 <iupdate>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a28:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a2b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a2e:	83 ec 08             	sub    $0x8,%esp
80101a31:	c1 e8 03             	shr    $0x3,%eax
80101a34:	03 05 e8 1a 11 80    	add    0x80111ae8,%eax
80101a3a:	50                   	push   %eax
80101a3b:	ff 73 a4             	push   -0x5c(%ebx)
80101a3e:	e8 8d e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a43:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a47:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a4a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a4c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101a4f:	83 e0 07             	and    $0x7,%eax
80101a52:	c1 e0 06             	shl    $0x6,%eax
80101a55:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a59:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a5c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a60:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a63:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a67:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a6b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a6f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a73:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a77:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a7a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a7d:	6a 34                	push   $0x34
80101a7f:	53                   	push   %ebx
80101a80:	50                   	push   %eax
80101a81:	e8 ca 2f 00 00       	call   80104a50 <memmove>
  log_write(bp);
80101a86:	89 34 24             	mov    %esi,(%esp)
80101a89:	e8 02 18 00 00       	call   80103290 <log_write>
  brelse(bp);
80101a8e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a91:	83 c4 10             	add    $0x10,%esp
}
80101a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a97:	5b                   	pop    %ebx
80101a98:	5e                   	pop    %esi
80101a99:	5d                   	pop    %ebp
  brelse(bp);
80101a9a:	e9 51 e7 ff ff       	jmp    801001f0 <brelse>
80101a9f:	90                   	nop

80101aa0 <idup>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 10             	sub    $0x10,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101aaa:	68 80 fe 10 80       	push   $0x8010fe80
80101aaf:	e8 3c 2e 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101ab4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ab8:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
80101abf:	e8 cc 2d 00 00       	call   80104890 <release>
}
80101ac4:	89 d8                	mov    %ebx,%eax
80101ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ac9:	c9                   	leave  
80101aca:	c3                   	ret    
80101acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101acf:	90                   	nop

80101ad0 <ilock>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	56                   	push   %esi
80101ad4:	53                   	push   %ebx
80101ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101ad8:	85 db                	test   %ebx,%ebx
80101ada:	0f 84 b7 00 00 00    	je     80101b97 <ilock+0xc7>
80101ae0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ae3:	85 d2                	test   %edx,%edx
80101ae5:	0f 8e ac 00 00 00    	jle    80101b97 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101aeb:	83 ec 0c             	sub    $0xc,%esp
80101aee:	8d 43 0c             	lea    0xc(%ebx),%eax
80101af1:	50                   	push   %eax
80101af2:	e8 39 2b 00 00       	call   80104630 <acquiresleep>
  if(ip->valid == 0){
80101af7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	85 c0                	test   %eax,%eax
80101aff:	74 0f                	je     80101b10 <ilock+0x40>
}
80101b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b04:	5b                   	pop    %ebx
80101b05:	5e                   	pop    %esi
80101b06:	5d                   	pop    %ebp
80101b07:	c3                   	ret    
80101b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b10:	8b 43 04             	mov    0x4(%ebx),%eax
80101b13:	83 ec 08             	sub    $0x8,%esp
80101b16:	c1 e8 03             	shr    $0x3,%eax
80101b19:	03 05 e8 1a 11 80    	add    0x80111ae8,%eax
80101b1f:	50                   	push   %eax
80101b20:	ff 33                	push   (%ebx)
80101b22:	e8 a9 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b27:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b2a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b2c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b2f:	83 e0 07             	and    $0x7,%eax
80101b32:	c1 e0 06             	shl    $0x6,%eax
80101b35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b61:	6a 34                	push   $0x34
80101b63:	50                   	push   %eax
80101b64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b67:	50                   	push   %eax
80101b68:	e8 e3 2e 00 00       	call   80104a50 <memmove>
    brelse(bp);
80101b6d:	89 34 24             	mov    %esi,(%esp)
80101b70:	e8 7b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101b75:	83 c4 10             	add    $0x10,%esp
80101b78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b84:	0f 85 77 ff ff ff    	jne    80101b01 <ilock+0x31>
      panic("ilock: no type");
80101b8a:	83 ec 0c             	sub    $0xc,%esp
80101b8d:	68 10 76 10 80       	push   $0x80107610
80101b92:	e8 e9 e7 ff ff       	call   80100380 <panic>
    panic("ilock");
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	68 0a 76 10 80       	push   $0x8010760a
80101b9f:	e8 dc e7 ff ff       	call   80100380 <panic>
80101ba4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <iunlock>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bb8:	85 db                	test   %ebx,%ebx
80101bba:	74 28                	je     80101be4 <iunlock+0x34>
80101bbc:	83 ec 0c             	sub    $0xc,%esp
80101bbf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101bc2:	56                   	push   %esi
80101bc3:	e8 08 2b 00 00       	call   801046d0 <holdingsleep>
80101bc8:	83 c4 10             	add    $0x10,%esp
80101bcb:	85 c0                	test   %eax,%eax
80101bcd:	74 15                	je     80101be4 <iunlock+0x34>
80101bcf:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd2:	85 c0                	test   %eax,%eax
80101bd4:	7e 0e                	jle    80101be4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101bd6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bdc:	5b                   	pop    %ebx
80101bdd:	5e                   	pop    %esi
80101bde:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101bdf:	e9 ac 2a 00 00       	jmp    80104690 <releasesleep>
    panic("iunlock");
80101be4:	83 ec 0c             	sub    $0xc,%esp
80101be7:	68 1f 76 10 80       	push   $0x8010761f
80101bec:	e8 8f e7 ff ff       	call   80100380 <panic>
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <iput>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 28             	sub    $0x28,%esp
80101c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c0c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c0f:	57                   	push   %edi
80101c10:	e8 1b 2a 00 00       	call   80104630 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c15:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c18:	83 c4 10             	add    $0x10,%esp
80101c1b:	85 d2                	test   %edx,%edx
80101c1d:	74 07                	je     80101c26 <iput+0x26>
80101c1f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c24:	74 32                	je     80101c58 <iput+0x58>
  releasesleep(&ip->lock);
80101c26:	83 ec 0c             	sub    $0xc,%esp
80101c29:	57                   	push   %edi
80101c2a:	e8 61 2a 00 00       	call   80104690 <releasesleep>
  acquire(&icache.lock);
80101c2f:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
80101c36:	e8 b5 2c 00 00       	call   801048f0 <acquire>
  ip->ref--;
80101c3b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c3f:	83 c4 10             	add    $0x10,%esp
80101c42:	c7 45 08 80 fe 10 80 	movl   $0x8010fe80,0x8(%ebp)
}
80101c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
  release(&icache.lock);
80101c50:	e9 3b 2c 00 00       	jmp    80104890 <release>
80101c55:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101c58:	83 ec 0c             	sub    $0xc,%esp
80101c5b:	68 80 fe 10 80       	push   $0x8010fe80
80101c60:	e8 8b 2c 00 00       	call   801048f0 <acquire>
    int r = ip->ref;
80101c65:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c68:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
80101c6f:	e8 1c 2c 00 00       	call   80104890 <release>
    if(r == 1){
80101c74:	83 c4 10             	add    $0x10,%esp
80101c77:	83 fe 01             	cmp    $0x1,%esi
80101c7a:	75 aa                	jne    80101c26 <iput+0x26>
80101c7c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c82:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c85:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c88:	89 cf                	mov    %ecx,%edi
80101c8a:	eb 0b                	jmp    80101c97 <iput+0x97>
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c90:	83 c6 04             	add    $0x4,%esi
80101c93:	39 fe                	cmp    %edi,%esi
80101c95:	74 19                	je     80101cb0 <iput+0xb0>
    if(ip->addrs[i]){
80101c97:	8b 16                	mov    (%esi),%edx
80101c99:	85 d2                	test   %edx,%edx
80101c9b:	74 f3                	je     80101c90 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c9d:	8b 03                	mov    (%ebx),%eax
80101c9f:	e8 6c f8 ff ff       	call   80101510 <bfree>
      ip->addrs[i] = 0;
80101ca4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101caa:	eb e4                	jmp    80101c90 <iput+0x90>
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101cb0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101cb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101cb9:	85 c0                	test   %eax,%eax
80101cbb:	75 2d                	jne    80101cea <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101cbd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101cc0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101cc7:	53                   	push   %ebx
80101cc8:	e8 53 fd ff ff       	call   80101a20 <iupdate>
      ip->type = 0;
80101ccd:	31 c0                	xor    %eax,%eax
80101ccf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101cd3:	89 1c 24             	mov    %ebx,(%esp)
80101cd6:	e8 45 fd ff ff       	call   80101a20 <iupdate>
      ip->valid = 0;
80101cdb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ce2:	83 c4 10             	add    $0x10,%esp
80101ce5:	e9 3c ff ff ff       	jmp    80101c26 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cea:	83 ec 08             	sub    $0x8,%esp
80101ced:	50                   	push   %eax
80101cee:	ff 33                	push   (%ebx)
80101cf0:	e8 db e3 ff ff       	call   801000d0 <bread>
80101cf5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101cf8:	83 c4 10             	add    $0x10,%esp
80101cfb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d04:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d07:	89 cf                	mov    %ecx,%edi
80101d09:	eb 0c                	jmp    80101d17 <iput+0x117>
80101d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d0f:	90                   	nop
80101d10:	83 c6 04             	add    $0x4,%esi
80101d13:	39 f7                	cmp    %esi,%edi
80101d15:	74 0f                	je     80101d26 <iput+0x126>
      if(a[j])
80101d17:	8b 16                	mov    (%esi),%edx
80101d19:	85 d2                	test   %edx,%edx
80101d1b:	74 f3                	je     80101d10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101d1d:	8b 03                	mov    (%ebx),%eax
80101d1f:	e8 ec f7 ff ff       	call   80101510 <bfree>
80101d24:	eb ea                	jmp    80101d10 <iput+0x110>
    brelse(bp);
80101d26:	83 ec 0c             	sub    $0xc,%esp
80101d29:	ff 75 e4             	push   -0x1c(%ebp)
80101d2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d2f:	e8 bc e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d34:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d3a:	8b 03                	mov    (%ebx),%eax
80101d3c:	e8 cf f7 ff ff       	call   80101510 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d4b:	00 00 00 
80101d4e:	e9 6a ff ff ff       	jmp    80101cbd <iput+0xbd>
80101d53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d60 <iunlockput>:
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	56                   	push   %esi
80101d64:	53                   	push   %ebx
80101d65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d68:	85 db                	test   %ebx,%ebx
80101d6a:	74 34                	je     80101da0 <iunlockput+0x40>
80101d6c:	83 ec 0c             	sub    $0xc,%esp
80101d6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d72:	56                   	push   %esi
80101d73:	e8 58 29 00 00       	call   801046d0 <holdingsleep>
80101d78:	83 c4 10             	add    $0x10,%esp
80101d7b:	85 c0                	test   %eax,%eax
80101d7d:	74 21                	je     80101da0 <iunlockput+0x40>
80101d7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d82:	85 c0                	test   %eax,%eax
80101d84:	7e 1a                	jle    80101da0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101d86:	83 ec 0c             	sub    $0xc,%esp
80101d89:	56                   	push   %esi
80101d8a:	e8 01 29 00 00       	call   80104690 <releasesleep>
  iput(ip);
80101d8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d92:	83 c4 10             	add    $0x10,%esp
}
80101d95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d98:	5b                   	pop    %ebx
80101d99:	5e                   	pop    %esi
80101d9a:	5d                   	pop    %ebp
  iput(ip);
80101d9b:	e9 60 fe ff ff       	jmp    80101c00 <iput>
    panic("iunlock");
80101da0:	83 ec 0c             	sub    $0xc,%esp
80101da3:	68 1f 76 10 80       	push   $0x8010761f
80101da8:	e8 d3 e5 ff ff       	call   80100380 <panic>
80101dad:	8d 76 00             	lea    0x0(%esi),%esi

80101db0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	8b 55 08             	mov    0x8(%ebp),%edx
80101db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101db9:	8b 0a                	mov    (%edx),%ecx
80101dbb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101dbe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101dc1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101dc4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101dc8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101dcb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101dcf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101dd3:	8b 52 58             	mov    0x58(%edx),%edx
80101dd6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dd9:	5d                   	pop    %ebp
80101dda:	c3                   	ret    
80101ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ddf:	90                   	nop

80101de0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	83 ec 1c             	sub    $0x1c,%esp
80101de9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 75 10             	mov    0x10(%ebp),%esi
80101df2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101df5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101df8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101dfd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e03:	0f 84 a7 00 00 00    	je     80101eb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e0c:	8b 40 58             	mov    0x58(%eax),%eax
80101e0f:	39 c6                	cmp    %eax,%esi
80101e11:	0f 87 ba 00 00 00    	ja     80101ed1 <readi+0xf1>
80101e17:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e1a:	31 c9                	xor    %ecx,%ecx
80101e1c:	89 da                	mov    %ebx,%edx
80101e1e:	01 f2                	add    %esi,%edx
80101e20:	0f 92 c1             	setb   %cl
80101e23:	89 cf                	mov    %ecx,%edi
80101e25:	0f 82 a6 00 00 00    	jb     80101ed1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e2b:	89 c1                	mov    %eax,%ecx
80101e2d:	29 f1                	sub    %esi,%ecx
80101e2f:	39 d0                	cmp    %edx,%eax
80101e31:	0f 43 cb             	cmovae %ebx,%ecx
80101e34:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e37:	85 c9                	test   %ecx,%ecx
80101e39:	74 67                	je     80101ea2 <readi+0xc2>
80101e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e43:	89 f2                	mov    %esi,%edx
80101e45:	c1 ea 09             	shr    $0x9,%edx
80101e48:	89 d8                	mov    %ebx,%eax
80101e4a:	e8 51 f9 ff ff       	call   801017a0 <bmap>
80101e4f:	83 ec 08             	sub    $0x8,%esp
80101e52:	50                   	push   %eax
80101e53:	ff 33                	push   (%ebx)
80101e55:	e8 76 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e64:	89 f0                	mov    %esi,%eax
80101e66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e6b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e70:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101e72:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e76:	39 d9                	cmp    %ebx,%ecx
80101e78:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e7b:	83 c4 0c             	add    $0xc,%esp
80101e7e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e7f:	01 df                	add    %ebx,%edi
80101e81:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101e83:	50                   	push   %eax
80101e84:	ff 75 e0             	push   -0x20(%ebp)
80101e87:	e8 c4 2b 00 00       	call   80104a50 <memmove>
    brelse(bp);
80101e8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e8f:	89 14 24             	mov    %edx,(%esp)
80101e92:	e8 59 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e9a:	83 c4 10             	add    $0x10,%esp
80101e9d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ea0:	77 9e                	ja     80101e40 <readi+0x60>
  }
  return n;
80101ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea8:	5b                   	pop    %ebx
80101ea9:	5e                   	pop    %esi
80101eaa:	5f                   	pop    %edi
80101eab:	5d                   	pop    %ebp
80101eac:	c3                   	ret    
80101ead:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101eb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101eb4:	66 83 f8 09          	cmp    $0x9,%ax
80101eb8:	77 17                	ja     80101ed1 <readi+0xf1>
80101eba:	8b 04 c5 20 fe 10 80 	mov    -0x7fef01e0(,%eax,8),%eax
80101ec1:	85 c0                	test   %eax,%eax
80101ec3:	74 0c                	je     80101ed1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ec5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecb:	5b                   	pop    %ebx
80101ecc:	5e                   	pop    %esi
80101ecd:	5f                   	pop    %edi
80101ece:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101ecf:	ff e0                	jmp    *%eax
      return -1;
80101ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed6:	eb cd                	jmp    80101ea5 <readi+0xc5>
80101ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edf:	90                   	nop

80101ee0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 1c             	sub    $0x1c,%esp
80101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101eef:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ef2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ef7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101efa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101efd:	8b 75 10             	mov    0x10(%ebp),%esi
80101f00:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f03:	0f 84 b7 00 00 00    	je     80101fc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f0f:	0f 87 e7 00 00 00    	ja     80101ffc <writei+0x11c>
80101f15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f18:	31 d2                	xor    %edx,%edx
80101f1a:	89 f8                	mov    %edi,%eax
80101f1c:	01 f0                	add    %esi,%eax
80101f1e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f21:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f26:	0f 87 d0 00 00 00    	ja     80101ffc <writei+0x11c>
80101f2c:	85 d2                	test   %edx,%edx
80101f2e:	0f 85 c8 00 00 00    	jne    80101ffc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f3b:	85 ff                	test   %edi,%edi
80101f3d:	74 72                	je     80101fb1 <writei+0xd1>
80101f3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f43:	89 f2                	mov    %esi,%edx
80101f45:	c1 ea 09             	shr    $0x9,%edx
80101f48:	89 f8                	mov    %edi,%eax
80101f4a:	e8 51 f8 ff ff       	call   801017a0 <bmap>
80101f4f:	83 ec 08             	sub    $0x8,%esp
80101f52:	50                   	push   %eax
80101f53:	ff 37                	push   (%edi)
80101f55:	e8 76 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f5a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f5f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f62:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f65:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f67:	89 f0                	mov    %esi,%eax
80101f69:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f6e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101f70:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f74:	39 d9                	cmp    %ebx,%ecx
80101f76:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f79:	83 c4 0c             	add    $0xc,%esp
80101f7c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f7d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101f7f:	ff 75 dc             	push   -0x24(%ebp)
80101f82:	50                   	push   %eax
80101f83:	e8 c8 2a 00 00       	call   80104a50 <memmove>
    log_write(bp);
80101f88:	89 3c 24             	mov    %edi,(%esp)
80101f8b:	e8 00 13 00 00       	call   80103290 <log_write>
    brelse(bp);
80101f90:	89 3c 24             	mov    %edi,(%esp)
80101f93:	e8 58 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f98:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fa1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101fa4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101fa7:	77 97                	ja     80101f40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101fa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fac:	3b 70 58             	cmp    0x58(%eax),%esi
80101faf:	77 37                	ja     80101fe8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101fb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb7:	5b                   	pop    %ebx
80101fb8:	5e                   	pop    %esi
80101fb9:	5f                   	pop    %edi
80101fba:	5d                   	pop    %ebp
80101fbb:	c3                   	ret    
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101fc4:	66 83 f8 09          	cmp    $0x9,%ax
80101fc8:	77 32                	ja     80101ffc <writei+0x11c>
80101fca:	8b 04 c5 24 fe 10 80 	mov    -0x7fef01dc(,%eax,8),%eax
80101fd1:	85 c0                	test   %eax,%eax
80101fd3:	74 27                	je     80101ffc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101fd5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5f                   	pop    %edi
80101fde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101fdf:	ff e0                	jmp    *%eax
80101fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101fe8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101feb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101fee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ff1:	50                   	push   %eax
80101ff2:	e8 29 fa ff ff       	call   80101a20 <iupdate>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	eb b5                	jmp    80101fb1 <writei+0xd1>
      return -1;
80101ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102001:	eb b1                	jmp    80101fb4 <writei+0xd4>
80102003:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010200a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102010 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102016:	6a 0e                	push   $0xe
80102018:	ff 75 0c             	push   0xc(%ebp)
8010201b:	ff 75 08             	push   0x8(%ebp)
8010201e:	e8 9d 2a 00 00       	call   80104ac0 <strncmp>
}
80102023:	c9                   	leave  
80102024:	c3                   	ret    
80102025:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102030 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 1c             	sub    $0x1c,%esp
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010203c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102041:	0f 85 85 00 00 00    	jne    801020cc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102047:	8b 53 58             	mov    0x58(%ebx),%edx
8010204a:	31 ff                	xor    %edi,%edi
8010204c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010204f:	85 d2                	test   %edx,%edx
80102051:	74 3e                	je     80102091 <dirlookup+0x61>
80102053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102057:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102058:	6a 10                	push   $0x10
8010205a:	57                   	push   %edi
8010205b:	56                   	push   %esi
8010205c:	53                   	push   %ebx
8010205d:	e8 7e fd ff ff       	call   80101de0 <readi>
80102062:	83 c4 10             	add    $0x10,%esp
80102065:	83 f8 10             	cmp    $0x10,%eax
80102068:	75 55                	jne    801020bf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010206a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010206f:	74 18                	je     80102089 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102071:	83 ec 04             	sub    $0x4,%esp
80102074:	8d 45 da             	lea    -0x26(%ebp),%eax
80102077:	6a 0e                	push   $0xe
80102079:	50                   	push   %eax
8010207a:	ff 75 0c             	push   0xc(%ebp)
8010207d:	e8 3e 2a 00 00       	call   80104ac0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	85 c0                	test   %eax,%eax
80102087:	74 17                	je     801020a0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102089:	83 c7 10             	add    $0x10,%edi
8010208c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010208f:	72 c7                	jb     80102058 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102091:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102094:	31 c0                	xor    %eax,%eax
}
80102096:	5b                   	pop    %ebx
80102097:	5e                   	pop    %esi
80102098:	5f                   	pop    %edi
80102099:	5d                   	pop    %ebp
8010209a:	c3                   	ret    
8010209b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010209f:	90                   	nop
      if(poff)
801020a0:	8b 45 10             	mov    0x10(%ebp),%eax
801020a3:	85 c0                	test   %eax,%eax
801020a5:	74 05                	je     801020ac <dirlookup+0x7c>
        *poff = off;
801020a7:	8b 45 10             	mov    0x10(%ebp),%eax
801020aa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801020ac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801020b0:	8b 03                	mov    (%ebx),%eax
801020b2:	e8 e9 f5 ff ff       	call   801016a0 <iget>
}
801020b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ba:	5b                   	pop    %ebx
801020bb:	5e                   	pop    %esi
801020bc:	5f                   	pop    %edi
801020bd:	5d                   	pop    %ebp
801020be:	c3                   	ret    
      panic("dirlookup read");
801020bf:	83 ec 0c             	sub    $0xc,%esp
801020c2:	68 39 76 10 80       	push   $0x80107639
801020c7:	e8 b4 e2 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
801020cc:	83 ec 0c             	sub    $0xc,%esp
801020cf:	68 27 76 10 80       	push   $0x80107627
801020d4:	e8 a7 e2 ff ff       	call   80100380 <panic>
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	89 c3                	mov    %eax,%ebx
801020e8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801020eb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801020ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801020f4:	0f 84 64 01 00 00    	je     8010225e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801020fa:	e8 c1 1b 00 00       	call   80103cc0 <myproc>
  acquire(&icache.lock);
801020ff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102102:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102105:	68 80 fe 10 80       	push   $0x8010fe80
8010210a:	e8 e1 27 00 00       	call   801048f0 <acquire>
  ip->ref++;
8010210f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102113:	c7 04 24 80 fe 10 80 	movl   $0x8010fe80,(%esp)
8010211a:	e8 71 27 00 00       	call   80104890 <release>
8010211f:	83 c4 10             	add    $0x10,%esp
80102122:	eb 07                	jmp    8010212b <namex+0x4b>
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102128:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010212b:	0f b6 03             	movzbl (%ebx),%eax
8010212e:	3c 2f                	cmp    $0x2f,%al
80102130:	74 f6                	je     80102128 <namex+0x48>
  if(*path == 0)
80102132:	84 c0                	test   %al,%al
80102134:	0f 84 06 01 00 00    	je     80102240 <namex+0x160>
  while(*path != '/' && *path != 0)
8010213a:	0f b6 03             	movzbl (%ebx),%eax
8010213d:	84 c0                	test   %al,%al
8010213f:	0f 84 10 01 00 00    	je     80102255 <namex+0x175>
80102145:	89 df                	mov    %ebx,%edi
80102147:	3c 2f                	cmp    $0x2f,%al
80102149:	0f 84 06 01 00 00    	je     80102255 <namex+0x175>
8010214f:	90                   	nop
80102150:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102154:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102157:	3c 2f                	cmp    $0x2f,%al
80102159:	74 04                	je     8010215f <namex+0x7f>
8010215b:	84 c0                	test   %al,%al
8010215d:	75 f1                	jne    80102150 <namex+0x70>
  len = path - s;
8010215f:	89 f8                	mov    %edi,%eax
80102161:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102163:	83 f8 0d             	cmp    $0xd,%eax
80102166:	0f 8e ac 00 00 00    	jle    80102218 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010216c:	83 ec 04             	sub    $0x4,%esp
8010216f:	6a 0e                	push   $0xe
80102171:	53                   	push   %ebx
    path++;
80102172:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102174:	ff 75 e4             	push   -0x1c(%ebp)
80102177:	e8 d4 28 00 00       	call   80104a50 <memmove>
8010217c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010217f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102182:	75 0c                	jne    80102190 <namex+0xb0>
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102188:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010218b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010218e:	74 f8                	je     80102188 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	56                   	push   %esi
80102194:	e8 37 f9 ff ff       	call   80101ad0 <ilock>
    if(ip->type != T_DIR){
80102199:	83 c4 10             	add    $0x10,%esp
8010219c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801021a1:	0f 85 cd 00 00 00    	jne    80102274 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801021a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801021aa:	85 c0                	test   %eax,%eax
801021ac:	74 09                	je     801021b7 <namex+0xd7>
801021ae:	80 3b 00             	cmpb   $0x0,(%ebx)
801021b1:	0f 84 22 01 00 00    	je     801022d9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801021b7:	83 ec 04             	sub    $0x4,%esp
801021ba:	6a 00                	push   $0x0
801021bc:	ff 75 e4             	push   -0x1c(%ebp)
801021bf:	56                   	push   %esi
801021c0:	e8 6b fe ff ff       	call   80102030 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021c5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
801021c8:	83 c4 10             	add    $0x10,%esp
801021cb:	89 c7                	mov    %eax,%edi
801021cd:	85 c0                	test   %eax,%eax
801021cf:	0f 84 e1 00 00 00    	je     801022b6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801021db:	52                   	push   %edx
801021dc:	e8 ef 24 00 00       	call   801046d0 <holdingsleep>
801021e1:	83 c4 10             	add    $0x10,%esp
801021e4:	85 c0                	test   %eax,%eax
801021e6:	0f 84 30 01 00 00    	je     8010231c <namex+0x23c>
801021ec:	8b 56 08             	mov    0x8(%esi),%edx
801021ef:	85 d2                	test   %edx,%edx
801021f1:	0f 8e 25 01 00 00    	jle    8010231c <namex+0x23c>
  releasesleep(&ip->lock);
801021f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801021fa:	83 ec 0c             	sub    $0xc,%esp
801021fd:	52                   	push   %edx
801021fe:	e8 8d 24 00 00       	call   80104690 <releasesleep>
  iput(ip);
80102203:	89 34 24             	mov    %esi,(%esp)
80102206:	89 fe                	mov    %edi,%esi
80102208:	e8 f3 f9 ff ff       	call   80101c00 <iput>
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	e9 16 ff ff ff       	jmp    8010212b <namex+0x4b>
80102215:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102218:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010221b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010221e:	83 ec 04             	sub    $0x4,%esp
80102221:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102224:	50                   	push   %eax
80102225:	53                   	push   %ebx
    name[len] = 0;
80102226:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102228:	ff 75 e4             	push   -0x1c(%ebp)
8010222b:	e8 20 28 00 00       	call   80104a50 <memmove>
    name[len] = 0;
80102230:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102233:	83 c4 10             	add    $0x10,%esp
80102236:	c6 02 00             	movb   $0x0,(%edx)
80102239:	e9 41 ff ff ff       	jmp    8010217f <namex+0x9f>
8010223e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102240:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102243:	85 c0                	test   %eax,%eax
80102245:	0f 85 be 00 00 00    	jne    80102309 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010224b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224e:	89 f0                	mov    %esi,%eax
80102250:	5b                   	pop    %ebx
80102251:	5e                   	pop    %esi
80102252:	5f                   	pop    %edi
80102253:	5d                   	pop    %ebp
80102254:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102255:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102258:	89 df                	mov    %ebx,%edi
8010225a:	31 c0                	xor    %eax,%eax
8010225c:	eb c0                	jmp    8010221e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010225e:	ba 01 00 00 00       	mov    $0x1,%edx
80102263:	b8 01 00 00 00       	mov    $0x1,%eax
80102268:	e8 33 f4 ff ff       	call   801016a0 <iget>
8010226d:	89 c6                	mov    %eax,%esi
8010226f:	e9 b7 fe ff ff       	jmp    8010212b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010227a:	53                   	push   %ebx
8010227b:	e8 50 24 00 00       	call   801046d0 <holdingsleep>
80102280:	83 c4 10             	add    $0x10,%esp
80102283:	85 c0                	test   %eax,%eax
80102285:	0f 84 91 00 00 00    	je     8010231c <namex+0x23c>
8010228b:	8b 46 08             	mov    0x8(%esi),%eax
8010228e:	85 c0                	test   %eax,%eax
80102290:	0f 8e 86 00 00 00    	jle    8010231c <namex+0x23c>
  releasesleep(&ip->lock);
80102296:	83 ec 0c             	sub    $0xc,%esp
80102299:	53                   	push   %ebx
8010229a:	e8 f1 23 00 00       	call   80104690 <releasesleep>
  iput(ip);
8010229f:	89 34 24             	mov    %esi,(%esp)
      return 0;
801022a2:	31 f6                	xor    %esi,%esi
  iput(ip);
801022a4:	e8 57 f9 ff ff       	call   80101c00 <iput>
      return 0;
801022a9:	83 c4 10             	add    $0x10,%esp
}
801022ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022af:	89 f0                	mov    %esi,%eax
801022b1:	5b                   	pop    %ebx
801022b2:	5e                   	pop    %esi
801022b3:	5f                   	pop    %edi
801022b4:	5d                   	pop    %ebp
801022b5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801022b6:	83 ec 0c             	sub    $0xc,%esp
801022b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801022bc:	52                   	push   %edx
801022bd:	e8 0e 24 00 00       	call   801046d0 <holdingsleep>
801022c2:	83 c4 10             	add    $0x10,%esp
801022c5:	85 c0                	test   %eax,%eax
801022c7:	74 53                	je     8010231c <namex+0x23c>
801022c9:	8b 4e 08             	mov    0x8(%esi),%ecx
801022cc:	85 c9                	test   %ecx,%ecx
801022ce:	7e 4c                	jle    8010231c <namex+0x23c>
  releasesleep(&ip->lock);
801022d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801022d3:	83 ec 0c             	sub    $0xc,%esp
801022d6:	52                   	push   %edx
801022d7:	eb c1                	jmp    8010229a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801022d9:	83 ec 0c             	sub    $0xc,%esp
801022dc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801022df:	53                   	push   %ebx
801022e0:	e8 eb 23 00 00       	call   801046d0 <holdingsleep>
801022e5:	83 c4 10             	add    $0x10,%esp
801022e8:	85 c0                	test   %eax,%eax
801022ea:	74 30                	je     8010231c <namex+0x23c>
801022ec:	8b 7e 08             	mov    0x8(%esi),%edi
801022ef:	85 ff                	test   %edi,%edi
801022f1:	7e 29                	jle    8010231c <namex+0x23c>
  releasesleep(&ip->lock);
801022f3:	83 ec 0c             	sub    $0xc,%esp
801022f6:	53                   	push   %ebx
801022f7:	e8 94 23 00 00       	call   80104690 <releasesleep>
}
801022fc:	83 c4 10             	add    $0x10,%esp
}
801022ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102302:	89 f0                	mov    %esi,%eax
80102304:	5b                   	pop    %ebx
80102305:	5e                   	pop    %esi
80102306:	5f                   	pop    %edi
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret    
    iput(ip);
80102309:	83 ec 0c             	sub    $0xc,%esp
8010230c:	56                   	push   %esi
    return 0;
8010230d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010230f:	e8 ec f8 ff ff       	call   80101c00 <iput>
    return 0;
80102314:	83 c4 10             	add    $0x10,%esp
80102317:	e9 2f ff ff ff       	jmp    8010224b <namex+0x16b>
    panic("iunlock");
8010231c:	83 ec 0c             	sub    $0xc,%esp
8010231f:	68 1f 76 10 80       	push   $0x8010761f
80102324:	e8 57 e0 ff ff       	call   80100380 <panic>
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102330 <dirlink>:
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	83 ec 20             	sub    $0x20,%esp
80102339:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010233c:	6a 00                	push   $0x0
8010233e:	ff 75 0c             	push   0xc(%ebp)
80102341:	53                   	push   %ebx
80102342:	e8 e9 fc ff ff       	call   80102030 <dirlookup>
80102347:	83 c4 10             	add    $0x10,%esp
8010234a:	85 c0                	test   %eax,%eax
8010234c:	75 67                	jne    801023b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010234e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102351:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102354:	85 ff                	test   %edi,%edi
80102356:	74 29                	je     80102381 <dirlink+0x51>
80102358:	31 ff                	xor    %edi,%edi
8010235a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010235d:	eb 09                	jmp    80102368 <dirlink+0x38>
8010235f:	90                   	nop
80102360:	83 c7 10             	add    $0x10,%edi
80102363:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102366:	73 19                	jae    80102381 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102368:	6a 10                	push   $0x10
8010236a:	57                   	push   %edi
8010236b:	56                   	push   %esi
8010236c:	53                   	push   %ebx
8010236d:	e8 6e fa ff ff       	call   80101de0 <readi>
80102372:	83 c4 10             	add    $0x10,%esp
80102375:	83 f8 10             	cmp    $0x10,%eax
80102378:	75 4e                	jne    801023c8 <dirlink+0x98>
    if(de.inum == 0)
8010237a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010237f:	75 df                	jne    80102360 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102381:	83 ec 04             	sub    $0x4,%esp
80102384:	8d 45 da             	lea    -0x26(%ebp),%eax
80102387:	6a 0e                	push   $0xe
80102389:	ff 75 0c             	push   0xc(%ebp)
8010238c:	50                   	push   %eax
8010238d:	e8 7e 27 00 00       	call   80104b10 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102392:	6a 10                	push   $0x10
  de.inum = inum;
80102394:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102397:	57                   	push   %edi
80102398:	56                   	push   %esi
80102399:	53                   	push   %ebx
  de.inum = inum;
8010239a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010239e:	e8 3d fb ff ff       	call   80101ee0 <writei>
801023a3:	83 c4 20             	add    $0x20,%esp
801023a6:	83 f8 10             	cmp    $0x10,%eax
801023a9:	75 2a                	jne    801023d5 <dirlink+0xa5>
  return 0;
801023ab:	31 c0                	xor    %eax,%eax
}
801023ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b0:	5b                   	pop    %ebx
801023b1:	5e                   	pop    %esi
801023b2:	5f                   	pop    %edi
801023b3:	5d                   	pop    %ebp
801023b4:	c3                   	ret    
    iput(ip);
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	50                   	push   %eax
801023b9:	e8 42 f8 ff ff       	call   80101c00 <iput>
    return -1;
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023c6:	eb e5                	jmp    801023ad <dirlink+0x7d>
      panic("dirlink read");
801023c8:	83 ec 0c             	sub    $0xc,%esp
801023cb:	68 48 76 10 80       	push   $0x80107648
801023d0:	e8 ab df ff ff       	call   80100380 <panic>
    panic("dirlink");
801023d5:	83 ec 0c             	sub    $0xc,%esp
801023d8:	68 1e 7c 10 80       	push   $0x80107c1e
801023dd:	e8 9e df ff ff       	call   80100380 <panic>
801023e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023f0 <namei>:

struct inode*
namei(char *path)
{
801023f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023f1:	31 d2                	xor    %edx,%edx
{
801023f3:	89 e5                	mov    %esp,%ebp
801023f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801023f8:	8b 45 08             	mov    0x8(%ebp),%eax
801023fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801023fe:	e8 dd fc ff ff       	call   801020e0 <namex>
}
80102403:	c9                   	leave  
80102404:	c3                   	ret    
80102405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102410:	55                   	push   %ebp
  return namex(path, 1, name);
80102411:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102416:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102418:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010241b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010241e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010241f:	e9 bc fc ff ff       	jmp    801020e0 <namex>
80102424:	66 90                	xchg   %ax,%ax
80102426:	66 90                	xchg   %ax,%ax
80102428:	66 90                	xchg   %ax,%ax
8010242a:	66 90                	xchg   %ax,%ax
8010242c:	66 90                	xchg   %ax,%ax
8010242e:	66 90                	xchg   %ax,%ax

80102430 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102439:	85 c0                	test   %eax,%eax
8010243b:	0f 84 b4 00 00 00    	je     801024f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102441:	8b 70 08             	mov    0x8(%eax),%esi
80102444:	89 c3                	mov    %eax,%ebx
80102446:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010244c:	0f 87 96 00 00 00    	ja     801024e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245e:	66 90                	xchg   %ax,%ax
80102460:	89 ca                	mov    %ecx,%edx
80102462:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102463:	83 e0 c0             	and    $0xffffffc0,%eax
80102466:	3c 40                	cmp    $0x40,%al
80102468:	75 f6                	jne    80102460 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010246a:	31 ff                	xor    %edi,%edi
8010246c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102471:	89 f8                	mov    %edi,%eax
80102473:	ee                   	out    %al,(%dx)
80102474:	b8 01 00 00 00       	mov    $0x1,%eax
80102479:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010247e:	ee                   	out    %al,(%dx)
8010247f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102484:	89 f0                	mov    %esi,%eax
80102486:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102487:	89 f0                	mov    %esi,%eax
80102489:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010248e:	c1 f8 08             	sar    $0x8,%eax
80102491:	ee                   	out    %al,(%dx)
80102492:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102497:	89 f8                	mov    %edi,%eax
80102499:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010249a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010249e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024a3:	c1 e0 04             	shl    $0x4,%eax
801024a6:	83 e0 10             	and    $0x10,%eax
801024a9:	83 c8 e0             	or     $0xffffffe0,%eax
801024ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024ad:	f6 03 04             	testb  $0x4,(%ebx)
801024b0:	75 16                	jne    801024c8 <idestart+0x98>
801024b2:	b8 20 00 00 00       	mov    $0x20,%eax
801024b7:	89 ca                	mov    %ecx,%edx
801024b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801024ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024bd:	5b                   	pop    %ebx
801024be:	5e                   	pop    %esi
801024bf:	5f                   	pop    %edi
801024c0:	5d                   	pop    %ebp
801024c1:	c3                   	ret    
801024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024c8:	b8 30 00 00 00       	mov    $0x30,%eax
801024cd:	89 ca                	mov    %ecx,%edx
801024cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801024d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801024d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801024d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024dd:	fc                   	cld    
801024de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801024e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e3:	5b                   	pop    %ebx
801024e4:	5e                   	pop    %esi
801024e5:	5f                   	pop    %edi
801024e6:	5d                   	pop    %ebp
801024e7:	c3                   	ret    
    panic("incorrect blockno");
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 b4 76 10 80       	push   $0x801076b4
801024f0:	e8 8b de ff ff       	call   80100380 <panic>
    panic("idestart");
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	68 ab 76 10 80       	push   $0x801076ab
801024fd:	e8 7e de ff ff       	call   80100380 <panic>
80102502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102510 <ideinit>:
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102516:	68 c6 76 10 80       	push   $0x801076c6
8010251b:	68 20 1b 11 80       	push   $0x80111b20
80102520:	e8 fb 21 00 00       	call   80104720 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102525:	58                   	pop    %eax
80102526:	a1 a4 1c 11 80       	mov    0x80111ca4,%eax
8010252b:	5a                   	pop    %edx
8010252c:	83 e8 01             	sub    $0x1,%eax
8010252f:	50                   	push   %eax
80102530:	6a 0e                	push   $0xe
80102532:	e8 99 02 00 00       	call   801027d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102537:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010253a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010253f:	90                   	nop
80102540:	ec                   	in     (%dx),%al
80102541:	83 e0 c0             	and    $0xffffffc0,%eax
80102544:	3c 40                	cmp    $0x40,%al
80102546:	75 f8                	jne    80102540 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102548:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010254d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102552:	ee                   	out    %al,(%dx)
80102553:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102558:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010255d:	eb 06                	jmp    80102565 <ideinit+0x55>
8010255f:	90                   	nop
  for(i=0; i<1000; i++){
80102560:	83 e9 01             	sub    $0x1,%ecx
80102563:	74 0f                	je     80102574 <ideinit+0x64>
80102565:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102566:	84 c0                	test   %al,%al
80102568:	74 f6                	je     80102560 <ideinit+0x50>
      havedisk1 = 1;
8010256a:	c7 05 00 1b 11 80 01 	movl   $0x1,0x80111b00
80102571:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102574:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102579:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010257e:	ee                   	out    %al,(%dx)
}
8010257f:	c9                   	leave  
80102580:	c3                   	ret    
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop

80102590 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	56                   	push   %esi
80102595:	53                   	push   %ebx
80102596:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102599:	68 20 1b 11 80       	push   $0x80111b20
8010259e:	e8 4d 23 00 00       	call   801048f0 <acquire>

  if((b = idequeue) == 0){
801025a3:	8b 1d 04 1b 11 80    	mov    0x80111b04,%ebx
801025a9:	83 c4 10             	add    $0x10,%esp
801025ac:	85 db                	test   %ebx,%ebx
801025ae:	74 63                	je     80102613 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801025b0:	8b 43 58             	mov    0x58(%ebx),%eax
801025b3:	a3 04 1b 11 80       	mov    %eax,0x80111b04

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801025b8:	8b 33                	mov    (%ebx),%esi
801025ba:	f7 c6 04 00 00 00    	test   $0x4,%esi
801025c0:	75 2f                	jne    801025f1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ce:	66 90                	xchg   %ax,%ax
801025d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025d1:	89 c1                	mov    %eax,%ecx
801025d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801025d6:	80 f9 40             	cmp    $0x40,%cl
801025d9:	75 f5                	jne    801025d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025db:	a8 21                	test   $0x21,%al
801025dd:	75 12                	jne    801025f1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801025df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801025e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025ec:	fc                   	cld    
801025ed:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801025ef:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801025f1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801025f4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025f7:	83 ce 02             	or     $0x2,%esi
801025fa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801025fc:	53                   	push   %ebx
801025fd:	e8 4e 1e 00 00       	call   80104450 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102602:	a1 04 1b 11 80       	mov    0x80111b04,%eax
80102607:	83 c4 10             	add    $0x10,%esp
8010260a:	85 c0                	test   %eax,%eax
8010260c:	74 05                	je     80102613 <ideintr+0x83>
    idestart(idequeue);
8010260e:	e8 1d fe ff ff       	call   80102430 <idestart>
    release(&idelock);
80102613:	83 ec 0c             	sub    $0xc,%esp
80102616:	68 20 1b 11 80       	push   $0x80111b20
8010261b:	e8 70 22 00 00       	call   80104890 <release>

  release(&idelock);
}
80102620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102623:	5b                   	pop    %ebx
80102624:	5e                   	pop    %esi
80102625:	5f                   	pop    %edi
80102626:	5d                   	pop    %ebp
80102627:	c3                   	ret    
80102628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	53                   	push   %ebx
80102634:	83 ec 10             	sub    $0x10,%esp
80102637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010263a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010263d:	50                   	push   %eax
8010263e:	e8 8d 20 00 00       	call   801046d0 <holdingsleep>
80102643:	83 c4 10             	add    $0x10,%esp
80102646:	85 c0                	test   %eax,%eax
80102648:	0f 84 c3 00 00 00    	je     80102711 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010264e:	8b 03                	mov    (%ebx),%eax
80102650:	83 e0 06             	and    $0x6,%eax
80102653:	83 f8 02             	cmp    $0x2,%eax
80102656:	0f 84 a8 00 00 00    	je     80102704 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010265c:	8b 53 04             	mov    0x4(%ebx),%edx
8010265f:	85 d2                	test   %edx,%edx
80102661:	74 0d                	je     80102670 <iderw+0x40>
80102663:	a1 00 1b 11 80       	mov    0x80111b00,%eax
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 87 00 00 00    	je     801026f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	68 20 1b 11 80       	push   $0x80111b20
80102678:	e8 73 22 00 00       	call   801048f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010267d:	a1 04 1b 11 80       	mov    0x80111b04,%eax
  b->qnext = 0;
80102682:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102689:	83 c4 10             	add    $0x10,%esp
8010268c:	85 c0                	test   %eax,%eax
8010268e:	74 60                	je     801026f0 <iderw+0xc0>
80102690:	89 c2                	mov    %eax,%edx
80102692:	8b 40 58             	mov    0x58(%eax),%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 f7                	jne    80102690 <iderw+0x60>
80102699:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010269c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010269e:	39 1d 04 1b 11 80    	cmp    %ebx,0x80111b04
801026a4:	74 3a                	je     801026e0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026a6:	8b 03                	mov    (%ebx),%eax
801026a8:	83 e0 06             	and    $0x6,%eax
801026ab:	83 f8 02             	cmp    $0x2,%eax
801026ae:	74 1b                	je     801026cb <iderw+0x9b>
    sleep(b, &idelock);
801026b0:	83 ec 08             	sub    $0x8,%esp
801026b3:	68 20 1b 11 80       	push   $0x80111b20
801026b8:	53                   	push   %ebx
801026b9:	e8 d2 1c 00 00       	call   80104390 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026be:	8b 03                	mov    (%ebx),%eax
801026c0:	83 c4 10             	add    $0x10,%esp
801026c3:	83 e0 06             	and    $0x6,%eax
801026c6:	83 f8 02             	cmp    $0x2,%eax
801026c9:	75 e5                	jne    801026b0 <iderw+0x80>
  }


  release(&idelock);
801026cb:	c7 45 08 20 1b 11 80 	movl   $0x80111b20,0x8(%ebp)
}
801026d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d5:	c9                   	leave  
  release(&idelock);
801026d6:	e9 b5 21 00 00       	jmp    80104890 <release>
801026db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026df:	90                   	nop
    idestart(b);
801026e0:	89 d8                	mov    %ebx,%eax
801026e2:	e8 49 fd ff ff       	call   80102430 <idestart>
801026e7:	eb bd                	jmp    801026a6 <iderw+0x76>
801026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026f0:	ba 04 1b 11 80       	mov    $0x80111b04,%edx
801026f5:	eb a5                	jmp    8010269c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801026f7:	83 ec 0c             	sub    $0xc,%esp
801026fa:	68 f5 76 10 80       	push   $0x801076f5
801026ff:	e8 7c dc ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102704:	83 ec 0c             	sub    $0xc,%esp
80102707:	68 e0 76 10 80       	push   $0x801076e0
8010270c:	e8 6f dc ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102711:	83 ec 0c             	sub    $0xc,%esp
80102714:	68 ca 76 10 80       	push   $0x801076ca
80102719:	e8 62 dc ff ff       	call   80100380 <panic>
8010271e:	66 90                	xchg   %ax,%ax

80102720 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102720:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102721:	c7 05 54 1b 11 80 00 	movl   $0xfec00000,0x80111b54
80102728:	00 c0 fe 
{
8010272b:	89 e5                	mov    %esp,%ebp
8010272d:	56                   	push   %esi
8010272e:	53                   	push   %ebx
  ioapic->reg = reg;
8010272f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102736:	00 00 00 
  return ioapic->data;
80102739:	8b 15 54 1b 11 80    	mov    0x80111b54,%edx
8010273f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102742:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102748:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010274e:	0f b6 15 a0 1c 11 80 	movzbl 0x80111ca0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102755:	c1 ee 10             	shr    $0x10,%esi
80102758:	89 f0                	mov    %esi,%eax
8010275a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010275d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102760:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102763:	39 c2                	cmp    %eax,%edx
80102765:	74 16                	je     8010277d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102767:	83 ec 0c             	sub    $0xc,%esp
8010276a:	68 14 77 10 80       	push   $0x80107714
8010276f:	e8 3c e0 ff ff       	call   801007b0 <cprintf>
  ioapic->reg = reg;
80102774:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
8010277a:	83 c4 10             	add    $0x10,%esp
8010277d:	83 c6 21             	add    $0x21,%esi
{
80102780:	ba 10 00 00 00       	mov    $0x10,%edx
80102785:	b8 20 00 00 00       	mov    $0x20,%eax
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102790:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102792:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102794:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
  for(i = 0; i <= maxintr; i++){
8010279a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010279d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801027a3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801027a6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801027a9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801027ac:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801027ae:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
801027b4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801027bb:	39 f0                	cmp    %esi,%eax
801027bd:	75 d1                	jne    80102790 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801027bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027c2:	5b                   	pop    %ebx
801027c3:	5e                   	pop    %esi
801027c4:	5d                   	pop    %ebp
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027d0:	55                   	push   %ebp
  ioapic->reg = reg;
801027d1:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
{
801027d7:	89 e5                	mov    %esp,%ebp
801027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801027dc:	8d 50 20             	lea    0x20(%eax),%edx
801027df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027e5:	8b 0d 54 1b 11 80    	mov    0x80111b54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027f6:	a1 54 1b 11 80       	mov    0x80111b54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102801:	5d                   	pop    %ebp
80102802:	c3                   	ret    
80102803:	66 90                	xchg   %ax,%ax
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	53                   	push   %ebx
80102814:	83 ec 04             	sub    $0x4,%esp
80102817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010281a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102820:	75 76                	jne    80102898 <kfree+0x88>
80102822:	81 fb f0 59 11 80    	cmp    $0x801159f0,%ebx
80102828:	72 6e                	jb     80102898 <kfree+0x88>
8010282a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102830:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102835:	77 61                	ja     80102898 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102837:	83 ec 04             	sub    $0x4,%esp
8010283a:	68 00 10 00 00       	push   $0x1000
8010283f:	6a 01                	push   $0x1
80102841:	53                   	push   %ebx
80102842:	e8 69 21 00 00       	call   801049b0 <memset>

  if(kmem.use_lock)
80102847:	8b 15 94 1b 11 80    	mov    0x80111b94,%edx
8010284d:	83 c4 10             	add    $0x10,%esp
80102850:	85 d2                	test   %edx,%edx
80102852:	75 1c                	jne    80102870 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102854:	a1 98 1b 11 80       	mov    0x80111b98,%eax
80102859:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010285b:	a1 94 1b 11 80       	mov    0x80111b94,%eax
  kmem.freelist = r;
80102860:	89 1d 98 1b 11 80    	mov    %ebx,0x80111b98
  if(kmem.use_lock)
80102866:	85 c0                	test   %eax,%eax
80102868:	75 1e                	jne    80102888 <kfree+0x78>
    release(&kmem.lock);
}
8010286a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286d:	c9                   	leave  
8010286e:	c3                   	ret    
8010286f:	90                   	nop
    acquire(&kmem.lock);
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 60 1b 11 80       	push   $0x80111b60
80102878:	e8 73 20 00 00       	call   801048f0 <acquire>
8010287d:	83 c4 10             	add    $0x10,%esp
80102880:	eb d2                	jmp    80102854 <kfree+0x44>
80102882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102888:	c7 45 08 60 1b 11 80 	movl   $0x80111b60,0x8(%ebp)
}
8010288f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102892:	c9                   	leave  
    release(&kmem.lock);
80102893:	e9 f8 1f 00 00       	jmp    80104890 <release>
    panic("kfree");
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	68 46 77 10 80       	push   $0x80107746
801028a0:	e8 db da ff ff       	call   80100380 <panic>
801028a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028b0 <freerange>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801028b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801028ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cd:	39 de                	cmp    %ebx,%esi
801028cf:	72 23                	jb     801028f4 <freerange+0x44>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028d8:	83 ec 0c             	sub    $0xc,%esp
801028db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028e7:	50                   	push   %eax
801028e8:	e8 23 ff ff ff       	call   80102810 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	39 f3                	cmp    %esi,%ebx
801028f2:	76 e4                	jbe    801028d8 <freerange+0x28>
}
801028f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f7:	5b                   	pop    %ebx
801028f8:	5e                   	pop    %esi
801028f9:	5d                   	pop    %ebp
801028fa:	c3                   	ret    
801028fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop

80102900 <kinit2>:
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
8010291f:	72 23                	jb     80102944 <kinit2+0x44>
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102937:	50                   	push   %eax
80102938:	e8 d3 fe ff ff       	call   80102810 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	39 de                	cmp    %ebx,%esi
80102942:	73 e4                	jae    80102928 <kinit2+0x28>
  kmem.use_lock = 1;
80102944:	c7 05 94 1b 11 80 01 	movl   $0x1,0x80111b94
8010294b:	00 00 00 
}
8010294e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102951:	5b                   	pop    %ebx
80102952:	5e                   	pop    %esi
80102953:	5d                   	pop    %ebp
80102954:	c3                   	ret    
80102955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102960 <kinit1>:
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	56                   	push   %esi
80102964:	53                   	push   %ebx
80102965:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102968:	83 ec 08             	sub    $0x8,%esp
8010296b:	68 4c 77 10 80       	push   $0x8010774c
80102970:	68 60 1b 11 80       	push   $0x80111b60
80102975:	e8 a6 1d 00 00       	call   80104720 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010297a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010297d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102980:	c7 05 94 1b 11 80 00 	movl   $0x0,0x80111b94
80102987:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010298a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102990:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102996:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010299c:	39 de                	cmp    %ebx,%esi
8010299e:	72 1c                	jb     801029bc <kinit1+0x5c>
    kfree(p);
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029af:	50                   	push   %eax
801029b0:	e8 5b fe ff ff       	call   80102810 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029b5:	83 c4 10             	add    $0x10,%esp
801029b8:	39 de                	cmp    %ebx,%esi
801029ba:	73 e4                	jae    801029a0 <kinit1+0x40>
}
801029bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029bf:	5b                   	pop    %ebx
801029c0:	5e                   	pop    %esi
801029c1:	5d                   	pop    %ebp
801029c2:	c3                   	ret    
801029c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801029d0:	a1 94 1b 11 80       	mov    0x80111b94,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	75 1f                	jne    801029f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029d9:	a1 98 1b 11 80       	mov    0x80111b98,%eax
  if(r)
801029de:	85 c0                	test   %eax,%eax
801029e0:	74 0e                	je     801029f0 <kalloc+0x20>
    kmem.freelist = r->next;
801029e2:	8b 10                	mov    (%eax),%edx
801029e4:	89 15 98 1b 11 80    	mov    %edx,0x80111b98
  if(kmem.use_lock)
801029ea:	c3                   	ret    
801029eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801029f0:	c3                   	ret    
801029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801029f8:	55                   	push   %ebp
801029f9:	89 e5                	mov    %esp,%ebp
801029fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029fe:	68 60 1b 11 80       	push   $0x80111b60
80102a03:	e8 e8 1e 00 00       	call   801048f0 <acquire>
  r = kmem.freelist;
80102a08:	a1 98 1b 11 80       	mov    0x80111b98,%eax
  if(kmem.use_lock)
80102a0d:	8b 15 94 1b 11 80    	mov    0x80111b94,%edx
  if(r)
80102a13:	83 c4 10             	add    $0x10,%esp
80102a16:	85 c0                	test   %eax,%eax
80102a18:	74 08                	je     80102a22 <kalloc+0x52>
    kmem.freelist = r->next;
80102a1a:	8b 08                	mov    (%eax),%ecx
80102a1c:	89 0d 98 1b 11 80    	mov    %ecx,0x80111b98
  if(kmem.use_lock)
80102a22:	85 d2                	test   %edx,%edx
80102a24:	74 16                	je     80102a3c <kalloc+0x6c>
    release(&kmem.lock);
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a2c:	68 60 1b 11 80       	push   $0x80111b60
80102a31:	e8 5a 1e 00 00       	call   80104890 <release>
  return (char*)r;
80102a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a39:	83 c4 10             	add    $0x10,%esp
}
80102a3c:	c9                   	leave  
80102a3d:	c3                   	ret    
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	ba 64 00 00 00       	mov    $0x64,%edx
80102a45:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a46:	a8 01                	test   $0x1,%al
80102a48:	0f 84 c2 00 00 00    	je     80102b10 <kbdgetc+0xd0>
{
80102a4e:	55                   	push   %ebp
80102a4f:	ba 60 00 00 00       	mov    $0x60,%edx
80102a54:	89 e5                	mov    %esp,%ebp
80102a56:	53                   	push   %ebx
80102a57:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102a58:	8b 1d 9c 1b 11 80    	mov    0x80111b9c,%ebx
  data = inb(KBDATAP);
80102a5e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102a61:	3c e0                	cmp    $0xe0,%al
80102a63:	74 5b                	je     80102ac0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102a65:	89 da                	mov    %ebx,%edx
80102a67:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102a6a:	84 c0                	test   %al,%al
80102a6c:	78 62                	js     80102ad0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a6e:	85 d2                	test   %edx,%edx
80102a70:	74 09                	je     80102a7b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a72:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a75:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a78:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102a7b:	0f b6 91 80 78 10 80 	movzbl -0x7fef8780(%ecx),%edx
  shift ^= togglecode[data];
80102a82:	0f b6 81 80 77 10 80 	movzbl -0x7fef8880(%ecx),%eax
  shift |= shiftcode[data];
80102a89:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102a8b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a8d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102a8f:	89 15 9c 1b 11 80    	mov    %edx,0x80111b9c
  c = charcode[shift & (CTL | SHIFT)][data];
80102a95:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a98:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a9b:	8b 04 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%eax
80102aa2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102aa6:	74 0b                	je     80102ab3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102aa8:	8d 50 9f             	lea    -0x61(%eax),%edx
80102aab:	83 fa 19             	cmp    $0x19,%edx
80102aae:	77 48                	ja     80102af8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ab0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ab6:	c9                   	leave  
80102ab7:	c3                   	ret    
80102ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abf:	90                   	nop
    shift |= E0ESC;
80102ac0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102ac3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102ac5:	89 1d 9c 1b 11 80    	mov    %ebx,0x80111b9c
}
80102acb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ace:	c9                   	leave  
80102acf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102ad0:	83 e0 7f             	and    $0x7f,%eax
80102ad3:	85 d2                	test   %edx,%edx
80102ad5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102ad8:	0f b6 81 80 78 10 80 	movzbl -0x7fef8780(%ecx),%eax
80102adf:	83 c8 40             	or     $0x40,%eax
80102ae2:	0f b6 c0             	movzbl %al,%eax
80102ae5:	f7 d0                	not    %eax
80102ae7:	21 d8                	and    %ebx,%eax
}
80102ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102aec:	a3 9c 1b 11 80       	mov    %eax,0x80111b9c
    return 0;
80102af1:	31 c0                	xor    %eax,%eax
}
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    
80102af5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102af8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102afb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b01:	c9                   	leave  
      c += 'a' - 'A';
80102b02:	83 f9 1a             	cmp    $0x1a,%ecx
80102b05:	0f 42 c2             	cmovb  %edx,%eax
}
80102b08:	c3                   	ret    
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b15:	c3                   	ret    
80102b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <kbdintr>:

void
kbdintr(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b26:	68 40 2a 10 80       	push   $0x80102a40
80102b2b:	e8 20 df ff ff       	call   80100a50 <consoleintr>
}
80102b30:	83 c4 10             	add    $0x10,%esp
80102b33:	c9                   	leave  
80102b34:	c3                   	ret    
80102b35:	66 90                	xchg   %ax,%ax
80102b37:	66 90                	xchg   %ax,%ax
80102b39:	66 90                	xchg   %ax,%ax
80102b3b:	66 90                	xchg   %ax,%ax
80102b3d:	66 90                	xchg   %ax,%ax
80102b3f:	90                   	nop

80102b40 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b40:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102b45:	85 c0                	test   %eax,%eax
80102b47:	0f 84 cb 00 00 00    	je     80102c18 <lapicinit+0xd8>
  lapic[index] = value;
80102b4d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b54:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b5a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b61:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b67:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b6e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b74:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b7b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b81:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b88:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b95:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b98:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b9b:	8b 50 30             	mov    0x30(%eax),%edx
80102b9e:	c1 ea 10             	shr    $0x10,%edx
80102ba1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102ba7:	75 77                	jne    80102c20 <lapicinit+0xe0>
  lapic[index] = value;
80102ba9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102bb0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bbd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bcd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bd7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bda:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bdd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102be4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bf1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf4:	8b 50 20             	mov    0x20(%eax),%edx
80102bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bfe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c00:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c06:	80 e6 10             	and    $0x10,%dh
80102c09:	75 f5                	jne    80102c00 <lapicinit+0xc0>
  lapic[index] = value;
80102c0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c12:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c15:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c18:	c3                   	ret    
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c20:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c27:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c2a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102c2d:	e9 77 ff ff ff       	jmp    80102ba9 <lapicinit+0x69>
80102c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c40:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	74 07                	je     80102c50 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102c49:	8b 40 20             	mov    0x20(%eax),%eax
80102c4c:	c1 e8 18             	shr    $0x18,%eax
80102c4f:	c3                   	ret    
    return 0;
80102c50:	31 c0                	xor    %eax,%eax
}
80102c52:	c3                   	ret    
80102c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c60 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c60:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102c65:	85 c0                	test   %eax,%eax
80102c67:	74 0d                	je     80102c76 <lapiceoi+0x16>
  lapic[index] = value;
80102c69:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c73:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c76:	c3                   	ret    
80102c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c7e:	66 90                	xchg   %ax,%ax

80102c80 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102c80:	c3                   	ret    
80102c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c91:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c96:	ba 70 00 00 00       	mov    $0x70,%edx
80102c9b:	89 e5                	mov    %esp,%ebp
80102c9d:	53                   	push   %ebx
80102c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ca1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ca4:	ee                   	out    %al,(%dx)
80102ca5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102caa:	ba 71 00 00 00       	mov    $0x71,%edx
80102caf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102cb0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102cb2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102cb5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102cbb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cbd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102cc0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102cc2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cc5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102cc8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102cce:	a1 a0 1b 11 80       	mov    0x80111ba0,%eax
80102cd3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cd9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cdc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ce3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ce9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cf0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cf6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cfc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d1d:	c9                   	leave  
80102d1e:	c3                   	ret    
80102d1f:	90                   	nop

80102d20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d20:	55                   	push   %ebp
80102d21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d26:	ba 70 00 00 00       	mov    $0x70,%edx
80102d2b:	89 e5                	mov    %esp,%ebp
80102d2d:	57                   	push   %edi
80102d2e:	56                   	push   %esi
80102d2f:	53                   	push   %ebx
80102d30:	83 ec 4c             	sub    $0x4c,%esp
80102d33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d34:	ba 71 00 00 00       	mov    $0x71,%edx
80102d39:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d45:	8d 76 00             	lea    0x0(%esi),%esi
80102d48:	31 c0                	xor    %eax,%eax
80102d4a:	89 da                	mov    %ebx,%edx
80102d4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d52:	89 ca                	mov    %ecx,%edx
80102d54:	ec                   	in     (%dx),%al
80102d55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d58:	89 da                	mov    %ebx,%edx
80102d5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d60:	89 ca                	mov    %ecx,%edx
80102d62:	ec                   	in     (%dx),%al
80102d63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d66:	89 da                	mov    %ebx,%edx
80102d68:	b8 04 00 00 00       	mov    $0x4,%eax
80102d6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6e:	89 ca                	mov    %ecx,%edx
80102d70:	ec                   	in     (%dx),%al
80102d71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d74:	89 da                	mov    %ebx,%edx
80102d76:	b8 07 00 00 00       	mov    $0x7,%eax
80102d7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7c:	89 ca                	mov    %ecx,%edx
80102d7e:	ec                   	in     (%dx),%al
80102d7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d82:	89 da                	mov    %ebx,%edx
80102d84:	b8 08 00 00 00       	mov    $0x8,%eax
80102d89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8a:	89 ca                	mov    %ecx,%edx
80102d8c:	ec                   	in     (%dx),%al
80102d8d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d8f:	89 da                	mov    %ebx,%edx
80102d91:	b8 09 00 00 00       	mov    $0x9,%eax
80102d96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d97:	89 ca                	mov    %ecx,%edx
80102d99:	ec                   	in     (%dx),%al
80102d9a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9c:	89 da                	mov    %ebx,%edx
80102d9e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102da3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da4:	89 ca                	mov    %ecx,%edx
80102da6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102da7:	84 c0                	test   %al,%al
80102da9:	78 9d                	js     80102d48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102dab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102daf:	89 fa                	mov    %edi,%edx
80102db1:	0f b6 fa             	movzbl %dl,%edi
80102db4:	89 f2                	mov    %esi,%edx
80102db6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102db9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102dbd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc0:	89 da                	mov    %ebx,%edx
80102dc2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102dc5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102dc8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102dcc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102dcf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102dd2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102dd6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102dd9:	31 c0                	xor    %eax,%eax
80102ddb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddc:	89 ca                	mov    %ecx,%edx
80102dde:	ec                   	in     (%dx),%al
80102ddf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de2:	89 da                	mov    %ebx,%edx
80102de4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102de7:	b8 02 00 00 00       	mov    $0x2,%eax
80102dec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ded:	89 ca                	mov    %ecx,%edx
80102def:	ec                   	in     (%dx),%al
80102df0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df3:	89 da                	mov    %ebx,%edx
80102df5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102df8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dfe:	89 ca                	mov    %ecx,%edx
80102e00:	ec                   	in     (%dx),%al
80102e01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e04:	89 da                	mov    %ebx,%edx
80102e06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e09:	b8 07 00 00 00       	mov    $0x7,%eax
80102e0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e0f:	89 ca                	mov    %ecx,%edx
80102e11:	ec                   	in     (%dx),%al
80102e12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e15:	89 da                	mov    %ebx,%edx
80102e17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e20:	89 ca                	mov    %ecx,%edx
80102e22:	ec                   	in     (%dx),%al
80102e23:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e26:	89 da                	mov    %ebx,%edx
80102e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e31:	89 ca                	mov    %ecx,%edx
80102e33:	ec                   	in     (%dx),%al
80102e34:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e37:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e3d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e40:	6a 18                	push   $0x18
80102e42:	50                   	push   %eax
80102e43:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e46:	50                   	push   %eax
80102e47:	e8 b4 1b 00 00       	call   80104a00 <memcmp>
80102e4c:	83 c4 10             	add    $0x10,%esp
80102e4f:	85 c0                	test   %eax,%eax
80102e51:	0f 85 f1 fe ff ff    	jne    80102d48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e57:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e5b:	75 78                	jne    80102ed5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e60:	89 c2                	mov    %eax,%edx
80102e62:	83 e0 0f             	and    $0xf,%eax
80102e65:	c1 ea 04             	shr    $0x4,%edx
80102e68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e71:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e74:	89 c2                	mov    %eax,%edx
80102e76:	83 e0 0f             	and    $0xf,%eax
80102e79:	c1 ea 04             	shr    $0x4,%edx
80102e7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e82:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e85:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e88:	89 c2                	mov    %eax,%edx
80102e8a:	83 e0 0f             	and    $0xf,%eax
80102e8d:	c1 ea 04             	shr    $0x4,%edx
80102e90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e9c:	89 c2                	mov    %eax,%edx
80102e9e:	83 e0 0f             	and    $0xf,%eax
80102ea1:	c1 ea 04             	shr    $0x4,%edx
80102ea4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ea7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eaa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ead:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eb0:	89 c2                	mov    %eax,%edx
80102eb2:	83 e0 0f             	and    $0xf,%eax
80102eb5:	c1 ea 04             	shr    $0x4,%edx
80102eb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ebb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ebe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ec1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ec4:	89 c2                	mov    %eax,%edx
80102ec6:	83 e0 0f             	and    $0xf,%eax
80102ec9:	c1 ea 04             	shr    $0x4,%edx
80102ecc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ecf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ed2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ed5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ed8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102edb:	89 06                	mov    %eax,(%esi)
80102edd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ee0:	89 46 04             	mov    %eax,0x4(%esi)
80102ee3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ee6:	89 46 08             	mov    %eax,0x8(%esi)
80102ee9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102eec:	89 46 0c             	mov    %eax,0xc(%esi)
80102eef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ef2:	89 46 10             	mov    %eax,0x10(%esi)
80102ef5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ef8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102efb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f05:	5b                   	pop    %ebx
80102f06:	5e                   	pop    %esi
80102f07:	5f                   	pop    %edi
80102f08:	5d                   	pop    %ebp
80102f09:	c3                   	ret    
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f10:	8b 0d 08 1c 11 80    	mov    0x80111c08,%ecx
80102f16:	85 c9                	test   %ecx,%ecx
80102f18:	0f 8e 8a 00 00 00    	jle    80102fa8 <install_trans+0x98>
{
80102f1e:	55                   	push   %ebp
80102f1f:	89 e5                	mov    %esp,%ebp
80102f21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102f22:	31 ff                	xor    %edi,%edi
{
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 0c             	sub    $0xc,%esp
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f30:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	01 f8                	add    %edi,%eax
80102f3a:	83 c0 01             	add    $0x1,%eax
80102f3d:	50                   	push   %eax
80102f3e:	ff 35 04 1c 11 80    	push   0x80111c04
80102f44:	e8 87 d1 ff ff       	call   801000d0 <bread>
80102f49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f4b:	58                   	pop    %eax
80102f4c:	5a                   	pop    %edx
80102f4d:	ff 34 bd 0c 1c 11 80 	push   -0x7feee3f4(,%edi,4)
80102f54:	ff 35 04 1c 11 80    	push   0x80111c04
  for (tail = 0; tail < log.lh.n; tail++) {
80102f5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f5d:	e8 6e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f6a:	68 00 02 00 00       	push   $0x200
80102f6f:	50                   	push   %eax
80102f70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f73:	50                   	push   %eax
80102f74:	e8 d7 1a 00 00       	call   80104a50 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f79:	89 1c 24             	mov    %ebx,(%esp)
80102f7c:	e8 2f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f81:	89 34 24             	mov    %esi,(%esp)
80102f84:	e8 67 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f89:	89 1c 24             	mov    %ebx,(%esp)
80102f8c:	e8 5f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	39 3d 08 1c 11 80    	cmp    %edi,0x80111c08
80102f9a:	7f 94                	jg     80102f30 <install_trans+0x20>
  }
}
80102f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5f                   	pop    %edi
80102fa2:	5d                   	pop    %ebp
80102fa3:	c3                   	ret    
80102fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	c3                   	ret    
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fb7:	ff 35 f4 1b 11 80    	push   0x80111bf4
80102fbd:	ff 35 04 1c 11 80    	push   0x80111c04
80102fc3:	e8 08 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102fc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fcb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102fcd:	a1 08 1c 11 80       	mov    0x80111c08,%eax
80102fd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fd5:	85 c0                	test   %eax,%eax
80102fd7:	7e 19                	jle    80102ff2 <write_head+0x42>
80102fd9:	31 d2                	xor    %edx,%edx
80102fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fe0:	8b 0c 95 0c 1c 11 80 	mov    -0x7feee3f4(,%edx,4),%ecx
80102fe7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102feb:	83 c2 01             	add    $0x1,%edx
80102fee:	39 d0                	cmp    %edx,%eax
80102ff0:	75 ee                	jne    80102fe0 <write_head+0x30>
  }
  bwrite(buf);
80102ff2:	83 ec 0c             	sub    $0xc,%esp
80102ff5:	53                   	push   %ebx
80102ff6:	e8 b5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ffb:	89 1c 24             	mov    %ebx,(%esp)
80102ffe:	e8 ed d1 ff ff       	call   801001f0 <brelse>
}
80103003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103006:	83 c4 10             	add    $0x10,%esp
80103009:	c9                   	leave  
8010300a:	c3                   	ret    
8010300b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010300f:	90                   	nop

80103010 <initlog>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 2c             	sub    $0x2c,%esp
80103017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010301a:	68 80 79 10 80       	push   $0x80107980
8010301f:	68 c0 1b 11 80       	push   $0x80111bc0
80103024:	e8 f7 16 00 00       	call   80104720 <initlock>
  readsb(dev, &sb);
80103029:	58                   	pop    %eax
8010302a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010302d:	5a                   	pop    %edx
8010302e:	50                   	push   %eax
8010302f:	53                   	push   %ebx
80103030:	e8 3b e8 ff ff       	call   80101870 <readsb>
  log.start = sb.logstart;
80103035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103038:	59                   	pop    %ecx
  log.dev = dev;
80103039:	89 1d 04 1c 11 80    	mov    %ebx,0x80111c04
  log.size = sb.nlog;
8010303f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103042:	a3 f4 1b 11 80       	mov    %eax,0x80111bf4
  log.size = sb.nlog;
80103047:	89 15 f8 1b 11 80    	mov    %edx,0x80111bf8
  struct buf *buf = bread(log.dev, log.start);
8010304d:	5a                   	pop    %edx
8010304e:	50                   	push   %eax
8010304f:	53                   	push   %ebx
80103050:	e8 7b d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103055:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103058:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010305b:	89 1d 08 1c 11 80    	mov    %ebx,0x80111c08
  for (i = 0; i < log.lh.n; i++) {
80103061:	85 db                	test   %ebx,%ebx
80103063:	7e 1d                	jle    80103082 <initlog+0x72>
80103065:	31 d2                	xor    %edx,%edx
80103067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103070:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103074:	89 0c 95 0c 1c 11 80 	mov    %ecx,-0x7feee3f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010307b:	83 c2 01             	add    $0x1,%edx
8010307e:	39 d3                	cmp    %edx,%ebx
80103080:	75 ee                	jne    80103070 <initlog+0x60>
  brelse(buf);
80103082:	83 ec 0c             	sub    $0xc,%esp
80103085:	50                   	push   %eax
80103086:	e8 65 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010308b:	e8 80 fe ff ff       	call   80102f10 <install_trans>
  log.lh.n = 0;
80103090:	c7 05 08 1c 11 80 00 	movl   $0x0,0x80111c08
80103097:	00 00 00 
  write_head(); // clear the log
8010309a:	e8 11 ff ff ff       	call   80102fb0 <write_head>
}
8010309f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030a2:	83 c4 10             	add    $0x10,%esp
801030a5:	c9                   	leave  
801030a6:	c3                   	ret    
801030a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030b6:	68 c0 1b 11 80       	push   $0x80111bc0
801030bb:	e8 30 18 00 00       	call   801048f0 <acquire>
801030c0:	83 c4 10             	add    $0x10,%esp
801030c3:	eb 18                	jmp    801030dd <begin_op+0x2d>
801030c5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030c8:	83 ec 08             	sub    $0x8,%esp
801030cb:	68 c0 1b 11 80       	push   $0x80111bc0
801030d0:	68 c0 1b 11 80       	push   $0x80111bc0
801030d5:	e8 b6 12 00 00       	call   80104390 <sleep>
801030da:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030dd:	a1 00 1c 11 80       	mov    0x80111c00,%eax
801030e2:	85 c0                	test   %eax,%eax
801030e4:	75 e2                	jne    801030c8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030e6:	a1 fc 1b 11 80       	mov    0x80111bfc,%eax
801030eb:	8b 15 08 1c 11 80    	mov    0x80111c08,%edx
801030f1:	83 c0 01             	add    $0x1,%eax
801030f4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030f7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030fa:	83 fa 1e             	cmp    $0x1e,%edx
801030fd:	7f c9                	jg     801030c8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030ff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103102:	a3 fc 1b 11 80       	mov    %eax,0x80111bfc
      release(&log.lock);
80103107:	68 c0 1b 11 80       	push   $0x80111bc0
8010310c:	e8 7f 17 00 00       	call   80104890 <release>
      break;
    }
  }
}
80103111:	83 c4 10             	add    $0x10,%esp
80103114:	c9                   	leave  
80103115:	c3                   	ret    
80103116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010311d:	8d 76 00             	lea    0x0(%esi),%esi

80103120 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103129:	68 c0 1b 11 80       	push   $0x80111bc0
8010312e:	e8 bd 17 00 00       	call   801048f0 <acquire>
  log.outstanding -= 1;
80103133:	a1 fc 1b 11 80       	mov    0x80111bfc,%eax
  if(log.committing)
80103138:	8b 35 00 1c 11 80    	mov    0x80111c00,%esi
8010313e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103141:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103144:	89 1d fc 1b 11 80    	mov    %ebx,0x80111bfc
  if(log.committing)
8010314a:	85 f6                	test   %esi,%esi
8010314c:	0f 85 22 01 00 00    	jne    80103274 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103152:	85 db                	test   %ebx,%ebx
80103154:	0f 85 f6 00 00 00    	jne    80103250 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010315a:	c7 05 00 1c 11 80 01 	movl   $0x1,0x80111c00
80103161:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103164:	83 ec 0c             	sub    $0xc,%esp
80103167:	68 c0 1b 11 80       	push   $0x80111bc0
8010316c:	e8 1f 17 00 00       	call   80104890 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103171:	8b 0d 08 1c 11 80    	mov    0x80111c08,%ecx
80103177:	83 c4 10             	add    $0x10,%esp
8010317a:	85 c9                	test   %ecx,%ecx
8010317c:	7f 42                	jg     801031c0 <end_op+0xa0>
    acquire(&log.lock);
8010317e:	83 ec 0c             	sub    $0xc,%esp
80103181:	68 c0 1b 11 80       	push   $0x80111bc0
80103186:	e8 65 17 00 00       	call   801048f0 <acquire>
    wakeup(&log);
8010318b:	c7 04 24 c0 1b 11 80 	movl   $0x80111bc0,(%esp)
    log.committing = 0;
80103192:	c7 05 00 1c 11 80 00 	movl   $0x0,0x80111c00
80103199:	00 00 00 
    wakeup(&log);
8010319c:	e8 af 12 00 00       	call   80104450 <wakeup>
    release(&log.lock);
801031a1:	c7 04 24 c0 1b 11 80 	movl   $0x80111bc0,(%esp)
801031a8:	e8 e3 16 00 00       	call   80104890 <release>
801031ad:	83 c4 10             	add    $0x10,%esp
}
801031b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b3:	5b                   	pop    %ebx
801031b4:	5e                   	pop    %esi
801031b5:	5f                   	pop    %edi
801031b6:	5d                   	pop    %ebp
801031b7:	c3                   	ret    
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031c0:	a1 f4 1b 11 80       	mov    0x80111bf4,%eax
801031c5:	83 ec 08             	sub    $0x8,%esp
801031c8:	01 d8                	add    %ebx,%eax
801031ca:	83 c0 01             	add    $0x1,%eax
801031cd:	50                   	push   %eax
801031ce:	ff 35 04 1c 11 80    	push   0x80111c04
801031d4:	e8 f7 ce ff ff       	call   801000d0 <bread>
801031d9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031db:	58                   	pop    %eax
801031dc:	5a                   	pop    %edx
801031dd:	ff 34 9d 0c 1c 11 80 	push   -0x7feee3f4(,%ebx,4)
801031e4:	ff 35 04 1c 11 80    	push   0x80111c04
  for (tail = 0; tail < log.lh.n; tail++) {
801031ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ed:	e8 de ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031f5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031fa:	68 00 02 00 00       	push   $0x200
801031ff:	50                   	push   %eax
80103200:	8d 46 5c             	lea    0x5c(%esi),%eax
80103203:	50                   	push   %eax
80103204:	e8 47 18 00 00       	call   80104a50 <memmove>
    bwrite(to);  // write the log
80103209:	89 34 24             	mov    %esi,(%esp)
8010320c:	e8 9f cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103211:	89 3c 24             	mov    %edi,(%esp)
80103214:	e8 d7 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103219:	89 34 24             	mov    %esi,(%esp)
8010321c:	e8 cf cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103221:	83 c4 10             	add    $0x10,%esp
80103224:	3b 1d 08 1c 11 80    	cmp    0x80111c08,%ebx
8010322a:	7c 94                	jl     801031c0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010322c:	e8 7f fd ff ff       	call   80102fb0 <write_head>
    install_trans(); // Now install writes to home locations
80103231:	e8 da fc ff ff       	call   80102f10 <install_trans>
    log.lh.n = 0;
80103236:	c7 05 08 1c 11 80 00 	movl   $0x0,0x80111c08
8010323d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103240:	e8 6b fd ff ff       	call   80102fb0 <write_head>
80103245:	e9 34 ff ff ff       	jmp    8010317e <end_op+0x5e>
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	68 c0 1b 11 80       	push   $0x80111bc0
80103258:	e8 f3 11 00 00       	call   80104450 <wakeup>
  release(&log.lock);
8010325d:	c7 04 24 c0 1b 11 80 	movl   $0x80111bc0,(%esp)
80103264:	e8 27 16 00 00       	call   80104890 <release>
80103269:	83 c4 10             	add    $0x10,%esp
}
8010326c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326f:	5b                   	pop    %ebx
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
    panic("log.committing");
80103274:	83 ec 0c             	sub    $0xc,%esp
80103277:	68 84 79 10 80       	push   $0x80107984
8010327c:	e8 ff d0 ff ff       	call   80100380 <panic>
80103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop

80103290 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	53                   	push   %ebx
80103294:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103297:	8b 15 08 1c 11 80    	mov    0x80111c08,%edx
{
8010329d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032a0:	83 fa 1d             	cmp    $0x1d,%edx
801032a3:	0f 8f 85 00 00 00    	jg     8010332e <log_write+0x9e>
801032a9:	a1 f8 1b 11 80       	mov    0x80111bf8,%eax
801032ae:	83 e8 01             	sub    $0x1,%eax
801032b1:	39 c2                	cmp    %eax,%edx
801032b3:	7d 79                	jge    8010332e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032b5:	a1 fc 1b 11 80       	mov    0x80111bfc,%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	7e 7d                	jle    8010333b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032be:	83 ec 0c             	sub    $0xc,%esp
801032c1:	68 c0 1b 11 80       	push   $0x80111bc0
801032c6:	e8 25 16 00 00       	call   801048f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032cb:	8b 15 08 1c 11 80    	mov    0x80111c08,%edx
801032d1:	83 c4 10             	add    $0x10,%esp
801032d4:	85 d2                	test   %edx,%edx
801032d6:	7e 4a                	jle    80103322 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032db:	31 c0                	xor    %eax,%eax
801032dd:	eb 08                	jmp    801032e7 <log_write+0x57>
801032df:	90                   	nop
801032e0:	83 c0 01             	add    $0x1,%eax
801032e3:	39 c2                	cmp    %eax,%edx
801032e5:	74 29                	je     80103310 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032e7:	39 0c 85 0c 1c 11 80 	cmp    %ecx,-0x7feee3f4(,%eax,4)
801032ee:	75 f0                	jne    801032e0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801032f0:	89 0c 85 0c 1c 11 80 	mov    %ecx,-0x7feee3f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032fd:	c7 45 08 c0 1b 11 80 	movl   $0x80111bc0,0x8(%ebp)
}
80103304:	c9                   	leave  
  release(&log.lock);
80103305:	e9 86 15 00 00       	jmp    80104890 <release>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103310:	89 0c 95 0c 1c 11 80 	mov    %ecx,-0x7feee3f4(,%edx,4)
    log.lh.n++;
80103317:	83 c2 01             	add    $0x1,%edx
8010331a:	89 15 08 1c 11 80    	mov    %edx,0x80111c08
80103320:	eb d5                	jmp    801032f7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103322:	8b 43 08             	mov    0x8(%ebx),%eax
80103325:	a3 0c 1c 11 80       	mov    %eax,0x80111c0c
  if (i == log.lh.n)
8010332a:	75 cb                	jne    801032f7 <log_write+0x67>
8010332c:	eb e9                	jmp    80103317 <log_write+0x87>
    panic("too big a transaction");
8010332e:	83 ec 0c             	sub    $0xc,%esp
80103331:	68 93 79 10 80       	push   $0x80107993
80103336:	e8 45 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010333b:	83 ec 0c             	sub    $0xc,%esp
8010333e:	68 a9 79 10 80       	push   $0x801079a9
80103343:	e8 38 d0 ff ff       	call   80100380 <panic>
80103348:	66 90                	xchg   %ax,%ax
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	53                   	push   %ebx
80103354:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103357:	e8 44 09 00 00       	call   80103ca0 <cpuid>
8010335c:	89 c3                	mov    %eax,%ebx
8010335e:	e8 3d 09 00 00       	call   80103ca0 <cpuid>
80103363:	83 ec 04             	sub    $0x4,%esp
80103366:	53                   	push   %ebx
80103367:	50                   	push   %eax
80103368:	68 c4 79 10 80       	push   $0x801079c4
8010336d:	e8 3e d4 ff ff       	call   801007b0 <cprintf>
  idtinit();       // load idt register
80103372:	e8 b9 28 00 00       	call   80105c30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103377:	e8 c4 08 00 00       	call   80103c40 <mycpu>
8010337c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010337e:	b8 01 00 00 00       	mov    $0x1,%eax
80103383:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010338a:	e8 f1 0b 00 00       	call   80103f80 <scheduler>
8010338f:	90                   	nop

80103390 <mpenter>:
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103396:	e8 85 39 00 00       	call   80106d20 <switchkvm>
  seginit();
8010339b:	e8 f0 38 00 00       	call   80106c90 <seginit>
  lapicinit();
801033a0:	e8 9b f7 ff ff       	call   80102b40 <lapicinit>
  mpmain();
801033a5:	e8 a6 ff ff ff       	call   80103350 <mpmain>
801033aa:	66 90                	xchg   %ax,%ax
801033ac:	66 90                	xchg   %ax,%ax
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <main>:
{
801033b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033b4:	83 e4 f0             	and    $0xfffffff0,%esp
801033b7:	ff 71 fc             	push   -0x4(%ecx)
801033ba:	55                   	push   %ebp
801033bb:	89 e5                	mov    %esp,%ebp
801033bd:	53                   	push   %ebx
801033be:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033bf:	83 ec 08             	sub    $0x8,%esp
801033c2:	68 00 00 40 80       	push   $0x80400000
801033c7:	68 f0 59 11 80       	push   $0x801159f0
801033cc:	e8 8f f5 ff ff       	call   80102960 <kinit1>
  kvmalloc();      // kernel page table
801033d1:	e8 3a 3e 00 00       	call   80107210 <kvmalloc>
  mpinit();        // detect other processors
801033d6:	e8 85 01 00 00       	call   80103560 <mpinit>
  lapicinit();     // interrupt controller
801033db:	e8 60 f7 ff ff       	call   80102b40 <lapicinit>
  seginit();       // segment descriptors
801033e0:	e8 ab 38 00 00       	call   80106c90 <seginit>
  picinit();       // disable pic
801033e5:	e8 76 03 00 00       	call   80103760 <picinit>
  ioapicinit();    // another interrupt controller
801033ea:	e8 31 f3 ff ff       	call   80102720 <ioapicinit>
  consoleinit();   // console hardware
801033ef:	e8 bc d9 ff ff       	call   80100db0 <consoleinit>
  uartinit();      // serial port
801033f4:	e8 27 2b 00 00       	call   80105f20 <uartinit>
  pinit();         // process table
801033f9:	e8 22 08 00 00       	call   80103c20 <pinit>
  tvinit();        // trap vectors
801033fe:	e8 ad 27 00 00       	call   80105bb0 <tvinit>
  binit();         // buffer cache
80103403:	e8 38 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103408:	e8 53 dd ff ff       	call   80101160 <fileinit>
  ideinit();       // disk 
8010340d:	e8 fe f0 ff ff       	call   80102510 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103412:	83 c4 0c             	add    $0xc,%esp
80103415:	68 8a 00 00 00       	push   $0x8a
8010341a:	68 8c a4 10 80       	push   $0x8010a48c
8010341f:	68 00 70 00 80       	push   $0x80007000
80103424:	e8 27 16 00 00       	call   80104a50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	69 05 a4 1c 11 80 b0 	imul   $0xb0,0x80111ca4,%eax
80103433:	00 00 00 
80103436:	05 c0 1c 11 80       	add    $0x80111cc0,%eax
8010343b:	3d c0 1c 11 80       	cmp    $0x80111cc0,%eax
80103440:	76 7e                	jbe    801034c0 <main+0x110>
80103442:	bb c0 1c 11 80       	mov    $0x80111cc0,%ebx
80103447:	eb 20                	jmp    80103469 <main+0xb9>
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103450:	69 05 a4 1c 11 80 b0 	imul   $0xb0,0x80111ca4,%eax
80103457:	00 00 00 
8010345a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103460:	05 c0 1c 11 80       	add    $0x80111cc0,%eax
80103465:	39 c3                	cmp    %eax,%ebx
80103467:	73 57                	jae    801034c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103469:	e8 d2 07 00 00       	call   80103c40 <mycpu>
8010346e:	39 c3                	cmp    %eax,%ebx
80103470:	74 de                	je     80103450 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103472:	e8 59 f5 ff ff       	call   801029d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103477:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010347a:	c7 05 f8 6f 00 80 90 	movl   $0x80103390,0x80006ff8
80103481:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103484:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010348b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010348e:	05 00 10 00 00       	add    $0x1000,%eax
80103493:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103498:	0f b6 03             	movzbl (%ebx),%eax
8010349b:	68 00 70 00 00       	push   $0x7000
801034a0:	50                   	push   %eax
801034a1:	e8 ea f7 ff ff       	call   80102c90 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034a6:	83 c4 10             	add    $0x10,%esp
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034b6:	85 c0                	test   %eax,%eax
801034b8:	74 f6                	je     801034b0 <main+0x100>
801034ba:	eb 94                	jmp    80103450 <main+0xa0>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034c0:	83 ec 08             	sub    $0x8,%esp
801034c3:	68 00 00 00 8e       	push   $0x8e000000
801034c8:	68 00 00 40 80       	push   $0x80400000
801034cd:	e8 2e f4 ff ff       	call   80102900 <kinit2>
  userinit();      // first user process
801034d2:	e8 19 08 00 00       	call   80103cf0 <userinit>
  mpmain();        // finish this processor's setup
801034d7:	e8 74 fe ff ff       	call   80103350 <mpmain>
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034eb:	53                   	push   %ebx
  e = addr+len;
801034ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034f2:	39 de                	cmp    %ebx,%esi
801034f4:	72 10                	jb     80103506 <mpsearch1+0x26>
801034f6:	eb 50                	jmp    80103548 <mpsearch1+0x68>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop
80103500:	89 fe                	mov    %edi,%esi
80103502:	39 fb                	cmp    %edi,%ebx
80103504:	76 42                	jbe    80103548 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103506:	83 ec 04             	sub    $0x4,%esp
80103509:	8d 7e 10             	lea    0x10(%esi),%edi
8010350c:	6a 04                	push   $0x4
8010350e:	68 d8 79 10 80       	push   $0x801079d8
80103513:	56                   	push   %esi
80103514:	e8 e7 14 00 00       	call   80104a00 <memcmp>
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	85 c0                	test   %eax,%eax
8010351e:	75 e0                	jne    80103500 <mpsearch1+0x20>
80103520:	89 f2                	mov    %esi,%edx
80103522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103528:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010352b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010352e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103530:	39 fa                	cmp    %edi,%edx
80103532:	75 f4                	jne    80103528 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103534:	84 c0                	test   %al,%al
80103536:	75 c8                	jne    80103500 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103538:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010353b:	89 f0                	mov    %esi,%eax
8010353d:	5b                   	pop    %ebx
8010353e:	5e                   	pop    %esi
8010353f:	5f                   	pop    %edi
80103540:	5d                   	pop    %ebp
80103541:	c3                   	ret    
80103542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103548:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010354b:	31 f6                	xor    %esi,%esi
}
8010354d:	5b                   	pop    %ebx
8010354e:	89 f0                	mov    %esi,%eax
80103550:	5e                   	pop    %esi
80103551:	5f                   	pop    %edi
80103552:	5d                   	pop    %ebp
80103553:	c3                   	ret    
80103554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop

80103560 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103569:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103570:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103577:	c1 e0 08             	shl    $0x8,%eax
8010357a:	09 d0                	or     %edx,%eax
8010357c:	c1 e0 04             	shl    $0x4,%eax
8010357f:	75 1b                	jne    8010359c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103581:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103588:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010358f:	c1 e0 08             	shl    $0x8,%eax
80103592:	09 d0                	or     %edx,%eax
80103594:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103597:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010359c:	ba 00 04 00 00       	mov    $0x400,%edx
801035a1:	e8 3a ff ff ff       	call   801034e0 <mpsearch1>
801035a6:	89 c3                	mov    %eax,%ebx
801035a8:	85 c0                	test   %eax,%eax
801035aa:	0f 84 40 01 00 00    	je     801036f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035b0:	8b 73 04             	mov    0x4(%ebx),%esi
801035b3:	85 f6                	test   %esi,%esi
801035b5:	0f 84 25 01 00 00    	je     801036e0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801035bb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035be:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801035c4:	6a 04                	push   $0x4
801035c6:	68 dd 79 10 80       	push   $0x801079dd
801035cb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801035cf:	e8 2c 14 00 00       	call   80104a00 <memcmp>
801035d4:	83 c4 10             	add    $0x10,%esp
801035d7:	85 c0                	test   %eax,%eax
801035d9:	0f 85 01 01 00 00    	jne    801036e0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801035df:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801035e6:	3c 01                	cmp    $0x1,%al
801035e8:	74 08                	je     801035f2 <mpinit+0x92>
801035ea:	3c 04                	cmp    $0x4,%al
801035ec:	0f 85 ee 00 00 00    	jne    801036e0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801035f2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801035f9:	66 85 d2             	test   %dx,%dx
801035fc:	74 22                	je     80103620 <mpinit+0xc0>
801035fe:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103601:	89 f0                	mov    %esi,%eax
  sum = 0;
80103603:	31 d2                	xor    %edx,%edx
80103605:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103608:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010360f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103612:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103614:	39 c7                	cmp    %eax,%edi
80103616:	75 f0                	jne    80103608 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103618:	84 d2                	test   %dl,%dl
8010361a:	0f 85 c0 00 00 00    	jne    801036e0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103620:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103626:	a3 a0 1b 11 80       	mov    %eax,0x80111ba0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010362b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103632:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103638:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010363d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103640:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103647:	90                   	nop
80103648:	39 d0                	cmp    %edx,%eax
8010364a:	73 15                	jae    80103661 <mpinit+0x101>
    switch(*p){
8010364c:	0f b6 08             	movzbl (%eax),%ecx
8010364f:	80 f9 02             	cmp    $0x2,%cl
80103652:	74 4c                	je     801036a0 <mpinit+0x140>
80103654:	77 3a                	ja     80103690 <mpinit+0x130>
80103656:	84 c9                	test   %cl,%cl
80103658:	74 56                	je     801036b0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010365a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010365d:	39 d0                	cmp    %edx,%eax
8010365f:	72 eb                	jb     8010364c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103661:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103664:	85 f6                	test   %esi,%esi
80103666:	0f 84 d9 00 00 00    	je     80103745 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010366c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103670:	74 15                	je     80103687 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103672:	b8 70 00 00 00       	mov    $0x70,%eax
80103677:	ba 22 00 00 00       	mov    $0x22,%edx
8010367c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010367d:	ba 23 00 00 00       	mov    $0x23,%edx
80103682:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103683:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103686:	ee                   	out    %al,(%dx)
  }
}
80103687:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368a:	5b                   	pop    %ebx
8010368b:	5e                   	pop    %esi
8010368c:	5f                   	pop    %edi
8010368d:	5d                   	pop    %ebp
8010368e:	c3                   	ret    
8010368f:	90                   	nop
    switch(*p){
80103690:	83 e9 03             	sub    $0x3,%ecx
80103693:	80 f9 01             	cmp    $0x1,%cl
80103696:	76 c2                	jbe    8010365a <mpinit+0xfa>
80103698:	31 f6                	xor    %esi,%esi
8010369a:	eb ac                	jmp    80103648 <mpinit+0xe8>
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036a0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801036a4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036a7:	88 0d a0 1c 11 80    	mov    %cl,0x80111ca0
      continue;
801036ad:	eb 99                	jmp    80103648 <mpinit+0xe8>
801036af:	90                   	nop
      if(ncpu < NCPU) {
801036b0:	8b 0d a4 1c 11 80    	mov    0x80111ca4,%ecx
801036b6:	83 f9 07             	cmp    $0x7,%ecx
801036b9:	7f 19                	jg     801036d4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801036c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801036c5:	83 c1 01             	add    $0x1,%ecx
801036c8:	89 0d a4 1c 11 80    	mov    %ecx,0x80111ca4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036ce:	88 9f c0 1c 11 80    	mov    %bl,-0x7feee340(%edi)
      p += sizeof(struct mpproc);
801036d4:	83 c0 14             	add    $0x14,%eax
      continue;
801036d7:	e9 6c ff ff ff       	jmp    80103648 <mpinit+0xe8>
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	68 e2 79 10 80       	push   $0x801079e2
801036e8:	e8 93 cc ff ff       	call   80100380 <panic>
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801036f0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801036f5:	eb 13                	jmp    8010370a <mpinit+0x1aa>
801036f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036fe:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103700:	89 f3                	mov    %esi,%ebx
80103702:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103708:	74 d6                	je     801036e0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010370a:	83 ec 04             	sub    $0x4,%esp
8010370d:	8d 73 10             	lea    0x10(%ebx),%esi
80103710:	6a 04                	push   $0x4
80103712:	68 d8 79 10 80       	push   $0x801079d8
80103717:	53                   	push   %ebx
80103718:	e8 e3 12 00 00       	call   80104a00 <memcmp>
8010371d:	83 c4 10             	add    $0x10,%esp
80103720:	85 c0                	test   %eax,%eax
80103722:	75 dc                	jne    80103700 <mpinit+0x1a0>
80103724:	89 da                	mov    %ebx,%edx
80103726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103730:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103733:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103736:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103738:	39 d6                	cmp    %edx,%esi
8010373a:	75 f4                	jne    80103730 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010373c:	84 c0                	test   %al,%al
8010373e:	75 c0                	jne    80103700 <mpinit+0x1a0>
80103740:	e9 6b fe ff ff       	jmp    801035b0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103745:	83 ec 0c             	sub    $0xc,%esp
80103748:	68 fc 79 10 80       	push   $0x801079fc
8010374d:	e8 2e cc ff ff       	call   80100380 <panic>
80103752:	66 90                	xchg   %ax,%ax
80103754:	66 90                	xchg   %ax,%ax
80103756:	66 90                	xchg   %ax,%ax
80103758:	66 90                	xchg   %ax,%ax
8010375a:	66 90                	xchg   %ax,%ax
8010375c:	66 90                	xchg   %ax,%ax
8010375e:	66 90                	xchg   %ax,%ax

80103760 <picinit>:
80103760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103765:	ba 21 00 00 00       	mov    $0x21,%edx
8010376a:	ee                   	out    %al,(%dx)
8010376b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103770:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103771:	c3                   	ret    
80103772:	66 90                	xchg   %ax,%ax
80103774:	66 90                	xchg   %ax,%ax
80103776:	66 90                	xchg   %ax,%ax
80103778:	66 90                	xchg   %ax,%ax
8010377a:	66 90                	xchg   %ax,%ax
8010377c:	66 90                	xchg   %ax,%ax
8010377e:	66 90                	xchg   %ax,%ax

80103780 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 0c             	sub    $0xc,%esp
80103789:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010378c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010378f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103795:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010379b:	e8 e0 d9 ff ff       	call   80101180 <filealloc>
801037a0:	89 03                	mov    %eax,(%ebx)
801037a2:	85 c0                	test   %eax,%eax
801037a4:	0f 84 a8 00 00 00    	je     80103852 <pipealloc+0xd2>
801037aa:	e8 d1 d9 ff ff       	call   80101180 <filealloc>
801037af:	89 06                	mov    %eax,(%esi)
801037b1:	85 c0                	test   %eax,%eax
801037b3:	0f 84 87 00 00 00    	je     80103840 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037b9:	e8 12 f2 ff ff       	call   801029d0 <kalloc>
801037be:	89 c7                	mov    %eax,%edi
801037c0:	85 c0                	test   %eax,%eax
801037c2:	0f 84 b0 00 00 00    	je     80103878 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801037c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801037d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801037d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037dc:	00 00 00 
  p->nwrite = 0;
801037df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037e6:	00 00 00 
  p->nread = 0;
801037e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037f0:	00 00 00 
  initlock(&p->lock, "pipe");
801037f3:	68 1b 7a 10 80       	push   $0x80107a1b
801037f8:	50                   	push   %eax
801037f9:	e8 22 0f 00 00       	call   80104720 <initlock>
  (*f0)->type = FD_PIPE;
801037fe:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103800:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103803:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103809:	8b 03                	mov    (%ebx),%eax
8010380b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010380f:	8b 03                	mov    (%ebx),%eax
80103811:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103815:	8b 03                	mov    (%ebx),%eax
80103817:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010381a:	8b 06                	mov    (%esi),%eax
8010381c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103822:	8b 06                	mov    (%esi),%eax
80103824:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103828:	8b 06                	mov    (%esi),%eax
8010382a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010382e:	8b 06                	mov    (%esi),%eax
80103830:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103833:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103836:	31 c0                	xor    %eax,%eax
}
80103838:	5b                   	pop    %ebx
80103839:	5e                   	pop    %esi
8010383a:	5f                   	pop    %edi
8010383b:	5d                   	pop    %ebp
8010383c:	c3                   	ret    
8010383d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103840:	8b 03                	mov    (%ebx),%eax
80103842:	85 c0                	test   %eax,%eax
80103844:	74 1e                	je     80103864 <pipealloc+0xe4>
    fileclose(*f0);
80103846:	83 ec 0c             	sub    $0xc,%esp
80103849:	50                   	push   %eax
8010384a:	e8 f1 d9 ff ff       	call   80101240 <fileclose>
8010384f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103852:	8b 06                	mov    (%esi),%eax
80103854:	85 c0                	test   %eax,%eax
80103856:	74 0c                	je     80103864 <pipealloc+0xe4>
    fileclose(*f1);
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 df d9 ff ff       	call   80101240 <fileclose>
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103867:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010386c:	5b                   	pop    %ebx
8010386d:	5e                   	pop    %esi
8010386e:	5f                   	pop    %edi
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103878:	8b 03                	mov    (%ebx),%eax
8010387a:	85 c0                	test   %eax,%eax
8010387c:	75 c8                	jne    80103846 <pipealloc+0xc6>
8010387e:	eb d2                	jmp    80103852 <pipealloc+0xd2>

80103880 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103888:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010388b:	83 ec 0c             	sub    $0xc,%esp
8010388e:	53                   	push   %ebx
8010388f:	e8 5c 10 00 00       	call   801048f0 <acquire>
  if(writable){
80103894:	83 c4 10             	add    $0x10,%esp
80103897:	85 f6                	test   %esi,%esi
80103899:	74 65                	je     80103900 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010389b:	83 ec 0c             	sub    $0xc,%esp
8010389e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801038a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038ab:	00 00 00 
    wakeup(&p->nread);
801038ae:	50                   	push   %eax
801038af:	e8 9c 0b 00 00       	call   80104450 <wakeup>
801038b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038bd:	85 d2                	test   %edx,%edx
801038bf:	75 0a                	jne    801038cb <pipeclose+0x4b>
801038c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038c7:	85 c0                	test   %eax,%eax
801038c9:	74 15                	je     801038e0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038d1:	5b                   	pop    %ebx
801038d2:	5e                   	pop    %esi
801038d3:	5d                   	pop    %ebp
    release(&p->lock);
801038d4:	e9 b7 0f 00 00       	jmp    80104890 <release>
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	53                   	push   %ebx
801038e4:	e8 a7 0f 00 00       	call   80104890 <release>
    kfree((char*)p);
801038e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038ec:	83 c4 10             	add    $0x10,%esp
}
801038ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f2:	5b                   	pop    %ebx
801038f3:	5e                   	pop    %esi
801038f4:	5d                   	pop    %ebp
    kfree((char*)p);
801038f5:	e9 16 ef ff ff       	jmp    80102810 <kfree>
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103909:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103910:	00 00 00 
    wakeup(&p->nwrite);
80103913:	50                   	push   %eax
80103914:	e8 37 0b 00 00       	call   80104450 <wakeup>
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	eb 99                	jmp    801038b7 <pipeclose+0x37>
8010391e:	66 90                	xchg   %ax,%ax

80103920 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	57                   	push   %edi
80103924:	56                   	push   %esi
80103925:	53                   	push   %ebx
80103926:	83 ec 28             	sub    $0x28,%esp
80103929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010392c:	53                   	push   %ebx
8010392d:	e8 be 0f 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++){
80103932:	8b 45 10             	mov    0x10(%ebp),%eax
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	85 c0                	test   %eax,%eax
8010393a:	0f 8e c0 00 00 00    	jle    80103a00 <pipewrite+0xe0>
80103940:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103943:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103949:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010394f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103952:	03 45 10             	add    0x10(%ebp),%eax
80103955:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103958:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010395e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103964:	89 ca                	mov    %ecx,%edx
80103966:	05 00 02 00 00       	add    $0x200,%eax
8010396b:	39 c1                	cmp    %eax,%ecx
8010396d:	74 3f                	je     801039ae <pipewrite+0x8e>
8010396f:	eb 67                	jmp    801039d8 <pipewrite+0xb8>
80103971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103978:	e8 43 03 00 00       	call   80103cc0 <myproc>
8010397d:	8b 48 24             	mov    0x24(%eax),%ecx
80103980:	85 c9                	test   %ecx,%ecx
80103982:	75 34                	jne    801039b8 <pipewrite+0x98>
      wakeup(&p->nread);
80103984:	83 ec 0c             	sub    $0xc,%esp
80103987:	57                   	push   %edi
80103988:	e8 c3 0a 00 00       	call   80104450 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010398d:	58                   	pop    %eax
8010398e:	5a                   	pop    %edx
8010398f:	53                   	push   %ebx
80103990:	56                   	push   %esi
80103991:	e8 fa 09 00 00       	call   80104390 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103996:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010399c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039a2:	83 c4 10             	add    $0x10,%esp
801039a5:	05 00 02 00 00       	add    $0x200,%eax
801039aa:	39 c2                	cmp    %eax,%edx
801039ac:	75 2a                	jne    801039d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801039ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	75 c0                	jne    80103978 <pipewrite+0x58>
        release(&p->lock);
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	53                   	push   %ebx
801039bc:	e8 cf 0e 00 00       	call   80104890 <release>
        return -1;
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039cc:	5b                   	pop    %ebx
801039cd:	5e                   	pop    %esi
801039ce:	5f                   	pop    %edi
801039cf:	5d                   	pop    %ebp
801039d0:	c3                   	ret    
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039db:	8d 4a 01             	lea    0x1(%edx),%ecx
801039de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039ea:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801039ed:	83 c6 01             	add    $0x1,%esi
801039f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039fa:	0f 85 58 ff ff ff    	jne    80103958 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a09:	50                   	push   %eax
80103a0a:	e8 41 0a 00 00       	call   80104450 <wakeup>
  release(&p->lock);
80103a0f:	89 1c 24             	mov    %ebx,(%esp)
80103a12:	e8 79 0e 00 00       	call   80104890 <release>
  return n;
80103a17:	8b 45 10             	mov    0x10(%ebp),%eax
80103a1a:	83 c4 10             	add    $0x10,%esp
80103a1d:	eb aa                	jmp    801039c9 <pipewrite+0xa9>
80103a1f:	90                   	nop

80103a20 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 18             	sub    $0x18,%esp
80103a29:	8b 75 08             	mov    0x8(%ebp),%esi
80103a2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a2f:	56                   	push   %esi
80103a30:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a36:	e8 b5 0e 00 00       	call   801048f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a3b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a41:	83 c4 10             	add    $0x10,%esp
80103a44:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a4a:	74 2f                	je     80103a7b <piperead+0x5b>
80103a4c:	eb 37                	jmp    80103a85 <piperead+0x65>
80103a4e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103a50:	e8 6b 02 00 00       	call   80103cc0 <myproc>
80103a55:	8b 48 24             	mov    0x24(%eax),%ecx
80103a58:	85 c9                	test   %ecx,%ecx
80103a5a:	0f 85 80 00 00 00    	jne    80103ae0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a60:	83 ec 08             	sub    $0x8,%esp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
80103a65:	e8 26 09 00 00       	call   80104390 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a6a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a79:	75 0a                	jne    80103a85 <piperead+0x65>
80103a7b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a81:	85 c0                	test   %eax,%eax
80103a83:	75 cb                	jne    80103a50 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a85:	8b 55 10             	mov    0x10(%ebp),%edx
80103a88:	31 db                	xor    %ebx,%ebx
80103a8a:	85 d2                	test   %edx,%edx
80103a8c:	7f 20                	jg     80103aae <piperead+0x8e>
80103a8e:	eb 2c                	jmp    80103abc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a90:	8d 48 01             	lea    0x1(%eax),%ecx
80103a93:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a98:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a9e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103aa3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103aa6:	83 c3 01             	add    $0x1,%ebx
80103aa9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103aac:	74 0e                	je     80103abc <piperead+0x9c>
    if(p->nread == p->nwrite)
80103aae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ab4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103aba:	75 d4                	jne    80103a90 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103abc:	83 ec 0c             	sub    $0xc,%esp
80103abf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ac5:	50                   	push   %eax
80103ac6:	e8 85 09 00 00       	call   80104450 <wakeup>
  release(&p->lock);
80103acb:	89 34 24             	mov    %esi,(%esp)
80103ace:	e8 bd 0d 00 00       	call   80104890 <release>
  return i;
80103ad3:	83 c4 10             	add    $0x10,%esp
}
80103ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad9:	89 d8                	mov    %ebx,%eax
80103adb:	5b                   	pop    %ebx
80103adc:	5e                   	pop    %esi
80103add:	5f                   	pop    %edi
80103ade:	5d                   	pop    %ebp
80103adf:	c3                   	ret    
      release(&p->lock);
80103ae0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ae3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ae8:	56                   	push   %esi
80103ae9:	e8 a2 0d 00 00       	call   80104890 <release>
      return -1;
80103aee:	83 c4 10             	add    $0x10,%esp
}
80103af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103af4:	89 d8                	mov    %ebx,%eax
80103af6:	5b                   	pop    %ebx
80103af7:	5e                   	pop    %esi
80103af8:	5f                   	pop    %edi
80103af9:	5d                   	pop    %ebp
80103afa:	c3                   	ret    
80103afb:	66 90                	xchg   %ax,%ax
80103afd:	66 90                	xchg   %ax,%ax
80103aff:	90                   	nop

80103b00 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b04:	bb 74 22 11 80       	mov    $0x80112274,%ebx
{
80103b09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b0c:	68 40 22 11 80       	push   $0x80112240
80103b11:	e8 da 0d 00 00       	call   801048f0 <acquire>
80103b16:	83 c4 10             	add    $0x10,%esp
80103b19:	eb 10                	jmp    80103b2b <allocproc+0x2b>
80103b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b20:	83 c3 7c             	add    $0x7c,%ebx
80103b23:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
80103b29:	74 75                	je     80103ba0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b2b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b2e:	85 c0                	test   %eax,%eax
80103b30:	75 ee                	jne    80103b20 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b32:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103b37:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b3a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b41:	89 43 10             	mov    %eax,0x10(%ebx)
80103b44:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b47:	68 40 22 11 80       	push   $0x80112240
  p->pid = nextpid++;
80103b4c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103b52:	e8 39 0d 00 00       	call   80104890 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b57:	e8 74 ee ff ff       	call   801029d0 <kalloc>
80103b5c:	83 c4 10             	add    $0x10,%esp
80103b5f:	89 43 08             	mov    %eax,0x8(%ebx)
80103b62:	85 c0                	test   %eax,%eax
80103b64:	74 53                	je     80103bb9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b66:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b6c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b6f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b74:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b77:	c7 40 14 a2 5b 10 80 	movl   $0x80105ba2,0x14(%eax)
  p->context = (struct context*)sp;
80103b7e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b81:	6a 14                	push   $0x14
80103b83:	6a 00                	push   $0x0
80103b85:	50                   	push   %eax
80103b86:	e8 25 0e 00 00       	call   801049b0 <memset>
  p->context->eip = (uint)forkret;
80103b8b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103b8e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b91:	c7 40 10 d0 3b 10 80 	movl   $0x80103bd0,0x10(%eax)
}
80103b98:	89 d8                	mov    %ebx,%eax
80103b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b9d:	c9                   	leave  
80103b9e:	c3                   	ret    
80103b9f:	90                   	nop
  release(&ptable.lock);
80103ba0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ba3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ba5:	68 40 22 11 80       	push   $0x80112240
80103baa:	e8 e1 0c 00 00       	call   80104890 <release>
}
80103baf:	89 d8                	mov    %ebx,%eax
  return 0;
80103bb1:	83 c4 10             	add    $0x10,%esp
}
80103bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb7:	c9                   	leave  
80103bb8:	c3                   	ret    
    p->state = UNUSED;
80103bb9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103bc0:	31 db                	xor    %ebx,%ebx
}
80103bc2:	89 d8                	mov    %ebx,%eax
80103bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc7:	c9                   	leave  
80103bc8:	c3                   	ret    
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bd0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103bd6:	68 40 22 11 80       	push   $0x80112240
80103bdb:	e8 b0 0c 00 00       	call   80104890 <release>

  if (first) {
80103be0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	85 c0                	test   %eax,%eax
80103bea:	75 04                	jne    80103bf0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103bec:	c9                   	leave  
80103bed:	c3                   	ret    
80103bee:	66 90                	xchg   %ax,%ax
    first = 0;
80103bf0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103bf7:	00 00 00 
    iinit(ROOTDEV);
80103bfa:	83 ec 0c             	sub    $0xc,%esp
80103bfd:	6a 01                	push   $0x1
80103bff:	e8 ac dc ff ff       	call   801018b0 <iinit>
    initlog(ROOTDEV);
80103c04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c0b:	e8 00 f4 ff ff       	call   80103010 <initlog>
}
80103c10:	83 c4 10             	add    $0x10,%esp
80103c13:	c9                   	leave  
80103c14:	c3                   	ret    
80103c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c20 <pinit>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c26:	68 20 7a 10 80       	push   $0x80107a20
80103c2b:	68 40 22 11 80       	push   $0x80112240
80103c30:	e8 eb 0a 00 00       	call   80104720 <initlock>
}
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	c9                   	leave  
80103c39:	c3                   	ret    
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c40 <mycpu>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c45:	9c                   	pushf  
80103c46:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c47:	f6 c4 02             	test   $0x2,%ah
80103c4a:	75 46                	jne    80103c92 <mycpu+0x52>
  apicid = lapicid();
80103c4c:	e8 ef ef ff ff       	call   80102c40 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c51:	8b 35 a4 1c 11 80    	mov    0x80111ca4,%esi
80103c57:	85 f6                	test   %esi,%esi
80103c59:	7e 2a                	jle    80103c85 <mycpu+0x45>
80103c5b:	31 d2                	xor    %edx,%edx
80103c5d:	eb 08                	jmp    80103c67 <mycpu+0x27>
80103c5f:	90                   	nop
80103c60:	83 c2 01             	add    $0x1,%edx
80103c63:	39 f2                	cmp    %esi,%edx
80103c65:	74 1e                	je     80103c85 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103c67:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c6d:	0f b6 99 c0 1c 11 80 	movzbl -0x7feee340(%ecx),%ebx
80103c74:	39 c3                	cmp    %eax,%ebx
80103c76:	75 e8                	jne    80103c60 <mycpu+0x20>
}
80103c78:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c7b:	8d 81 c0 1c 11 80    	lea    -0x7feee340(%ecx),%eax
}
80103c81:	5b                   	pop    %ebx
80103c82:	5e                   	pop    %esi
80103c83:	5d                   	pop    %ebp
80103c84:	c3                   	ret    
  panic("unknown apicid\n");
80103c85:	83 ec 0c             	sub    $0xc,%esp
80103c88:	68 27 7a 10 80       	push   $0x80107a27
80103c8d:	e8 ee c6 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c92:	83 ec 0c             	sub    $0xc,%esp
80103c95:	68 04 7b 10 80       	push   $0x80107b04
80103c9a:	e8 e1 c6 ff ff       	call   80100380 <panic>
80103c9f:	90                   	nop

80103ca0 <cpuid>:
cpuid() {
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ca6:	e8 95 ff ff ff       	call   80103c40 <mycpu>
}
80103cab:	c9                   	leave  
  return mycpu()-cpus;
80103cac:	2d c0 1c 11 80       	sub    $0x80111cc0,%eax
80103cb1:	c1 f8 04             	sar    $0x4,%eax
80103cb4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103cba:	c3                   	ret    
80103cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cbf:	90                   	nop

80103cc0 <myproc>:
myproc(void) {
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
80103cc4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103cc7:	e8 d4 0a 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103ccc:	e8 6f ff ff ff       	call   80103c40 <mycpu>
  p = c->proc;
80103cd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd7:	e8 14 0b 00 00       	call   801047f0 <popcli>
}
80103cdc:	89 d8                	mov    %ebx,%eax
80103cde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ce1:	c9                   	leave  
80103ce2:	c3                   	ret    
80103ce3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cf0 <userinit>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	53                   	push   %ebx
80103cf4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103cf7:	e8 04 fe ff ff       	call   80103b00 <allocproc>
80103cfc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cfe:	a3 74 41 11 80       	mov    %eax,0x80114174
  if((p->pgdir = setupkvm()) == 0)
80103d03:	e8 88 34 00 00       	call   80107190 <setupkvm>
80103d08:	89 43 04             	mov    %eax,0x4(%ebx)
80103d0b:	85 c0                	test   %eax,%eax
80103d0d:	0f 84 bd 00 00 00    	je     80103dd0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d13:	83 ec 04             	sub    $0x4,%esp
80103d16:	68 2c 00 00 00       	push   $0x2c
80103d1b:	68 60 a4 10 80       	push   $0x8010a460
80103d20:	50                   	push   %eax
80103d21:	e8 1a 31 00 00       	call   80106e40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d2f:	6a 4c                	push   $0x4c
80103d31:	6a 00                	push   $0x0
80103d33:	ff 73 18             	push   0x18(%ebx)
80103d36:	e8 75 0c 00 00       	call   801049b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d43:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d46:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d56:	8b 43 18             	mov    0x18(%ebx),%eax
80103d59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d61:	8b 43 18             	mov    0x18(%ebx),%eax
80103d64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d76:	8b 43 18             	mov    0x18(%ebx),%eax
80103d79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d80:	8b 43 18             	mov    0x18(%ebx),%eax
80103d83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	68 50 7a 10 80       	push   $0x80107a50
80103d94:	50                   	push   %eax
80103d95:	e8 d6 0d 00 00       	call   80104b70 <safestrcpy>
  p->cwd = namei("/");
80103d9a:	c7 04 24 59 7a 10 80 	movl   $0x80107a59,(%esp)
80103da1:	e8 4a e6 ff ff       	call   801023f0 <namei>
80103da6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103da9:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103db0:	e8 3b 0b 00 00       	call   801048f0 <acquire>
  p->state = RUNNABLE;
80103db5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103dbc:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103dc3:	e8 c8 0a 00 00       	call   80104890 <release>
}
80103dc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dcb:	83 c4 10             	add    $0x10,%esp
80103dce:	c9                   	leave  
80103dcf:	c3                   	ret    
    panic("userinit: out of memory?");
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	68 37 7a 10 80       	push   $0x80107a37
80103dd8:	e8 a3 c5 ff ff       	call   80100380 <panic>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi

80103de0 <growproc>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	56                   	push   %esi
80103de4:	53                   	push   %ebx
80103de5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103de8:	e8 b3 09 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103ded:	e8 4e fe ff ff       	call   80103c40 <mycpu>
  p = c->proc;
80103df2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103df8:	e8 f3 09 00 00       	call   801047f0 <popcli>
  sz = curproc->sz;
80103dfd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103dff:	85 f6                	test   %esi,%esi
80103e01:	7f 1d                	jg     80103e20 <growproc+0x40>
  } else if(n < 0){
80103e03:	75 3b                	jne    80103e40 <growproc+0x60>
  switchuvm(curproc);
80103e05:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e08:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e0a:	53                   	push   %ebx
80103e0b:	e8 20 2f 00 00       	call   80106d30 <switchuvm>
  return 0;
80103e10:	83 c4 10             	add    $0x10,%esp
80103e13:	31 c0                	xor    %eax,%eax
}
80103e15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e18:	5b                   	pop    %ebx
80103e19:	5e                   	pop    %esi
80103e1a:	5d                   	pop    %ebp
80103e1b:	c3                   	ret    
80103e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e20:	83 ec 04             	sub    $0x4,%esp
80103e23:	01 c6                	add    %eax,%esi
80103e25:	56                   	push   %esi
80103e26:	50                   	push   %eax
80103e27:	ff 73 04             	push   0x4(%ebx)
80103e2a:	e8 81 31 00 00       	call   80106fb0 <allocuvm>
80103e2f:	83 c4 10             	add    $0x10,%esp
80103e32:	85 c0                	test   %eax,%eax
80103e34:	75 cf                	jne    80103e05 <growproc+0x25>
      return -1;
80103e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e3b:	eb d8                	jmp    80103e15 <growproc+0x35>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e40:	83 ec 04             	sub    $0x4,%esp
80103e43:	01 c6                	add    %eax,%esi
80103e45:	56                   	push   %esi
80103e46:	50                   	push   %eax
80103e47:	ff 73 04             	push   0x4(%ebx)
80103e4a:	e8 91 32 00 00       	call   801070e0 <deallocuvm>
80103e4f:	83 c4 10             	add    $0x10,%esp
80103e52:	85 c0                	test   %eax,%eax
80103e54:	75 af                	jne    80103e05 <growproc+0x25>
80103e56:	eb de                	jmp    80103e36 <growproc+0x56>
80103e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <fork>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e69:	e8 32 09 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103e6e:	e8 cd fd ff ff       	call   80103c40 <mycpu>
  p = c->proc;
80103e73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e79:	e8 72 09 00 00       	call   801047f0 <popcli>
  if((np = allocproc()) == 0){
80103e7e:	e8 7d fc ff ff       	call   80103b00 <allocproc>
80103e83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e86:	85 c0                	test   %eax,%eax
80103e88:	0f 84 b7 00 00 00    	je     80103f45 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e8e:	83 ec 08             	sub    $0x8,%esp
80103e91:	ff 33                	push   (%ebx)
80103e93:	89 c7                	mov    %eax,%edi
80103e95:	ff 73 04             	push   0x4(%ebx)
80103e98:	e8 e3 33 00 00       	call   80107280 <copyuvm>
80103e9d:	83 c4 10             	add    $0x10,%esp
80103ea0:	89 47 04             	mov    %eax,0x4(%edi)
80103ea3:	85 c0                	test   %eax,%eax
80103ea5:	0f 84 a1 00 00 00    	je     80103f4c <fork+0xec>
  np->sz = curproc->sz;
80103eab:	8b 03                	mov    (%ebx),%eax
80103ead:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103eb0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103eb2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103eb5:	89 c8                	mov    %ecx,%eax
80103eb7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103eba:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ebf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ec2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ec4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ec6:	8b 40 18             	mov    0x18(%eax),%eax
80103ec9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ed0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ed4:	85 c0                	test   %eax,%eax
80103ed6:	74 13                	je     80103eeb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ed8:	83 ec 0c             	sub    $0xc,%esp
80103edb:	50                   	push   %eax
80103edc:	e8 0f d3 ff ff       	call   801011f0 <filedup>
80103ee1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ee4:	83 c4 10             	add    $0x10,%esp
80103ee7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103eeb:	83 c6 01             	add    $0x1,%esi
80103eee:	83 fe 10             	cmp    $0x10,%esi
80103ef1:	75 dd                	jne    80103ed0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ef3:	83 ec 0c             	sub    $0xc,%esp
80103ef6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ef9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103efc:	e8 9f db ff ff       	call   80101aa0 <idup>
80103f01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f0d:	6a 10                	push   $0x10
80103f0f:	53                   	push   %ebx
80103f10:	50                   	push   %eax
80103f11:	e8 5a 0c 00 00       	call   80104b70 <safestrcpy>
  pid = np->pid;
80103f16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f19:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103f20:	e8 cb 09 00 00       	call   801048f0 <acquire>
  np->state = RUNNABLE;
80103f25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f2c:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80103f33:	e8 58 09 00 00       	call   80104890 <release>
  return pid;
80103f38:	83 c4 10             	add    $0x10,%esp
}
80103f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f3e:	89 d8                	mov    %ebx,%eax
80103f40:	5b                   	pop    %ebx
80103f41:	5e                   	pop    %esi
80103f42:	5f                   	pop    %edi
80103f43:	5d                   	pop    %ebp
80103f44:	c3                   	ret    
    return -1;
80103f45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f4a:	eb ef                	jmp    80103f3b <fork+0xdb>
    kfree(np->kstack);
80103f4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f4f:	83 ec 0c             	sub    $0xc,%esp
80103f52:	ff 73 08             	push   0x8(%ebx)
80103f55:	e8 b6 e8 ff ff       	call   80102810 <kfree>
    np->kstack = 0;
80103f5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f61:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f64:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f70:	eb c9                	jmp    80103f3b <fork+0xdb>
80103f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f80 <scheduler>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f89:	e8 b2 fc ff ff       	call   80103c40 <mycpu>
  c->proc = 0;
80103f8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f95:	00 00 00 
  struct cpu *c = mycpu();
80103f98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f9a:	8d 78 04             	lea    0x4(%eax),%edi
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103fa0:	fb                   	sti    
    acquire(&ptable.lock);
80103fa1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa4:	bb 74 22 11 80       	mov    $0x80112274,%ebx
    acquire(&ptable.lock);
80103fa9:	68 40 22 11 80       	push   $0x80112240
80103fae:	e8 3d 09 00 00       	call   801048f0 <acquire>
80103fb3:	83 c4 10             	add    $0x10,%esp
80103fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103fc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fc4:	75 33                	jne    80103ff9 <scheduler+0x79>
      switchuvm(p);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103fc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fcf:	53                   	push   %ebx
80103fd0:	e8 5b 2d 00 00       	call   80106d30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103fd5:	58                   	pop    %eax
80103fd6:	5a                   	pop    %edx
80103fd7:	ff 73 1c             	push   0x1c(%ebx)
80103fda:	57                   	push   %edi
      p->state = RUNNING;
80103fdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103fe2:	e8 e4 0b 00 00       	call   80104bcb <swtch>
      switchkvm();
80103fe7:	e8 34 2d 00 00       	call   80106d20 <switchkvm>
      c->proc = 0;
80103fec:	83 c4 10             	add    $0x10,%esp
80103fef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ff6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff9:	83 c3 7c             	add    $0x7c,%ebx
80103ffc:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
80104002:	75 bc                	jne    80103fc0 <scheduler+0x40>
    release(&ptable.lock);
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 40 22 11 80       	push   $0x80112240
8010400c:	e8 7f 08 00 00       	call   80104890 <release>
    sti();
80104011:	83 c4 10             	add    $0x10,%esp
80104014:	eb 8a                	jmp    80103fa0 <scheduler+0x20>
80104016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401d:	8d 76 00             	lea    0x0(%esi),%esi

80104020 <sched>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
  pushcli();
80104025:	e8 76 07 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010402a:	e8 11 fc ff ff       	call   80103c40 <mycpu>
  p = c->proc;
8010402f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104035:	e8 b6 07 00 00       	call   801047f0 <popcli>
  if(!holding(&ptable.lock))
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 40 22 11 80       	push   $0x80112240
80104042:	e8 09 08 00 00       	call   80104850 <holding>
80104047:	83 c4 10             	add    $0x10,%esp
8010404a:	85 c0                	test   %eax,%eax
8010404c:	74 4f                	je     8010409d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010404e:	e8 ed fb ff ff       	call   80103c40 <mycpu>
80104053:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010405a:	75 68                	jne    801040c4 <sched+0xa4>
  if(p->state == RUNNING)
8010405c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104060:	74 55                	je     801040b7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104062:	9c                   	pushf  
80104063:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104064:	f6 c4 02             	test   $0x2,%ah
80104067:	75 41                	jne    801040aa <sched+0x8a>
  intena = mycpu()->intena;
80104069:	e8 d2 fb ff ff       	call   80103c40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010406e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104071:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104077:	e8 c4 fb ff ff       	call   80103c40 <mycpu>
8010407c:	83 ec 08             	sub    $0x8,%esp
8010407f:	ff 70 04             	push   0x4(%eax)
80104082:	53                   	push   %ebx
80104083:	e8 43 0b 00 00       	call   80104bcb <swtch>
  mycpu()->intena = intena;
80104088:	e8 b3 fb ff ff       	call   80103c40 <mycpu>
}
8010408d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104090:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104096:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104099:	5b                   	pop    %ebx
8010409a:	5e                   	pop    %esi
8010409b:	5d                   	pop    %ebp
8010409c:	c3                   	ret    
    panic("sched ptable.lock");
8010409d:	83 ec 0c             	sub    $0xc,%esp
801040a0:	68 5b 7a 10 80       	push   $0x80107a5b
801040a5:	e8 d6 c2 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 87 7a 10 80       	push   $0x80107a87
801040b2:	e8 c9 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 79 7a 10 80       	push   $0x80107a79
801040bf:	e8 bc c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	68 6d 7a 10 80       	push   $0x80107a6d
801040cc:	e8 af c2 ff ff       	call   80100380 <panic>
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040df:	90                   	nop

801040e0 <exit>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801040e9:	e8 d2 fb ff ff       	call   80103cc0 <myproc>
  if(curproc == initproc)
801040ee:	39 05 74 41 11 80    	cmp    %eax,0x80114174
801040f4:	0f 84 fd 00 00 00    	je     801041f7 <exit+0x117>
801040fa:	89 c3                	mov    %eax,%ebx
801040fc:	8d 70 28             	lea    0x28(%eax),%esi
801040ff:	8d 78 68             	lea    0x68(%eax),%edi
80104102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104108:	8b 06                	mov    (%esi),%eax
8010410a:	85 c0                	test   %eax,%eax
8010410c:	74 12                	je     80104120 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	50                   	push   %eax
80104112:	e8 29 d1 ff ff       	call   80101240 <fileclose>
      curproc->ofile[fd] = 0;
80104117:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010411d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104120:	83 c6 04             	add    $0x4,%esi
80104123:	39 f7                	cmp    %esi,%edi
80104125:	75 e1                	jne    80104108 <exit+0x28>
  begin_op();
80104127:	e8 84 ef ff ff       	call   801030b0 <begin_op>
  iput(curproc->cwd);
8010412c:	83 ec 0c             	sub    $0xc,%esp
8010412f:	ff 73 68             	push   0x68(%ebx)
80104132:	e8 c9 da ff ff       	call   80101c00 <iput>
  end_op();
80104137:	e8 e4 ef ff ff       	call   80103120 <end_op>
  curproc->cwd = 0;
8010413c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104143:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
8010414a:	e8 a1 07 00 00       	call   801048f0 <acquire>
  wakeup1(curproc->parent);
8010414f:	8b 53 14             	mov    0x14(%ebx),%edx
80104152:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104155:	b8 74 22 11 80       	mov    $0x80112274,%eax
8010415a:	eb 0e                	jmp    8010416a <exit+0x8a>
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104160:	83 c0 7c             	add    $0x7c,%eax
80104163:	3d 74 41 11 80       	cmp    $0x80114174,%eax
80104168:	74 1c                	je     80104186 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010416a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010416e:	75 f0                	jne    80104160 <exit+0x80>
80104170:	3b 50 20             	cmp    0x20(%eax),%edx
80104173:	75 eb                	jne    80104160 <exit+0x80>
      p->state = RUNNABLE;
80104175:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417c:	83 c0 7c             	add    $0x7c,%eax
8010417f:	3d 74 41 11 80       	cmp    $0x80114174,%eax
80104184:	75 e4                	jne    8010416a <exit+0x8a>
      p->parent = initproc;
80104186:	8b 0d 74 41 11 80    	mov    0x80114174,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418c:	ba 74 22 11 80       	mov    $0x80112274,%edx
80104191:	eb 10                	jmp    801041a3 <exit+0xc3>
80104193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104197:	90                   	nop
80104198:	83 c2 7c             	add    $0x7c,%edx
8010419b:	81 fa 74 41 11 80    	cmp    $0x80114174,%edx
801041a1:	74 3b                	je     801041de <exit+0xfe>
    if(p->parent == curproc){
801041a3:	39 5a 14             	cmp    %ebx,0x14(%edx)
801041a6:	75 f0                	jne    80104198 <exit+0xb8>
      if(p->state == ZOMBIE)
801041a8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041ac:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041af:	75 e7                	jne    80104198 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b1:	b8 74 22 11 80       	mov    $0x80112274,%eax
801041b6:	eb 12                	jmp    801041ca <exit+0xea>
801041b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop
801041c0:	83 c0 7c             	add    $0x7c,%eax
801041c3:	3d 74 41 11 80       	cmp    $0x80114174,%eax
801041c8:	74 ce                	je     80104198 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801041ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041ce:	75 f0                	jne    801041c0 <exit+0xe0>
801041d0:	3b 48 20             	cmp    0x20(%eax),%ecx
801041d3:	75 eb                	jne    801041c0 <exit+0xe0>
      p->state = RUNNABLE;
801041d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041dc:	eb e2                	jmp    801041c0 <exit+0xe0>
  curproc->state = ZOMBIE;
801041de:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801041e5:	e8 36 fe ff ff       	call   80104020 <sched>
  panic("zombie exit");
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	68 a8 7a 10 80       	push   $0x80107aa8
801041f2:	e8 89 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	68 9b 7a 10 80       	push   $0x80107a9b
801041ff:	e8 7c c1 ff ff       	call   80100380 <panic>
80104204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010420f:	90                   	nop

80104210 <wait>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
  pushcli();
80104215:	e8 86 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010421a:	e8 21 fa ff ff       	call   80103c40 <mycpu>
  p = c->proc;
8010421f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104225:	e8 c6 05 00 00       	call   801047f0 <popcli>
  acquire(&ptable.lock);
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 40 22 11 80       	push   $0x80112240
80104232:	e8 b9 06 00 00       	call   801048f0 <acquire>
80104237:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010423a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423c:	bb 74 22 11 80       	mov    $0x80112274,%ebx
80104241:	eb 10                	jmp    80104253 <wait+0x43>
80104243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104247:	90                   	nop
80104248:	83 c3 7c             	add    $0x7c,%ebx
8010424b:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
80104251:	74 1b                	je     8010426e <wait+0x5e>
      if(p->parent != curproc)
80104253:	39 73 14             	cmp    %esi,0x14(%ebx)
80104256:	75 f0                	jne    80104248 <wait+0x38>
      if(p->state == ZOMBIE){
80104258:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010425c:	74 62                	je     801042c0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010425e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104261:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104266:	81 fb 74 41 11 80    	cmp    $0x80114174,%ebx
8010426c:	75 e5                	jne    80104253 <wait+0x43>
    if(!havekids || curproc->killed){
8010426e:	85 c0                	test   %eax,%eax
80104270:	0f 84 a0 00 00 00    	je     80104316 <wait+0x106>
80104276:	8b 46 24             	mov    0x24(%esi),%eax
80104279:	85 c0                	test   %eax,%eax
8010427b:	0f 85 95 00 00 00    	jne    80104316 <wait+0x106>
  pushcli();
80104281:	e8 1a 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80104286:	e8 b5 f9 ff ff       	call   80103c40 <mycpu>
  p = c->proc;
8010428b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104291:	e8 5a 05 00 00       	call   801047f0 <popcli>
  if(p == 0)
80104296:	85 db                	test   %ebx,%ebx
80104298:	0f 84 8f 00 00 00    	je     8010432d <wait+0x11d>
  p->chan = chan;
8010429e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801042a1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042a8:	e8 73 fd ff ff       	call   80104020 <sched>
  p->chan = 0;
801042ad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042b4:	eb 84                	jmp    8010423a <wait+0x2a>
801042b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042c3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042c6:	ff 73 08             	push   0x8(%ebx)
801042c9:	e8 42 e5 ff ff       	call   80102810 <kfree>
        p->kstack = 0;
801042ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042d5:	5a                   	pop    %edx
801042d6:	ff 73 04             	push   0x4(%ebx)
801042d9:	e8 32 2e 00 00       	call   80107110 <freevm>
        p->pid = 0;
801042de:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042e5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042ec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042f0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042fe:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80104305:	e8 86 05 00 00       	call   80104890 <release>
        return pid;
8010430a:	83 c4 10             	add    $0x10,%esp
}
8010430d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104310:	89 f0                	mov    %esi,%eax
80104312:	5b                   	pop    %ebx
80104313:	5e                   	pop    %esi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
      release(&ptable.lock);
80104316:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104319:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010431e:	68 40 22 11 80       	push   $0x80112240
80104323:	e8 68 05 00 00       	call   80104890 <release>
      return -1;
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	eb e0                	jmp    8010430d <wait+0xfd>
    panic("sleep");
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	68 b4 7a 10 80       	push   $0x80107ab4
80104335:	e8 46 c0 ff ff       	call   80100380 <panic>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <yield>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104347:	68 40 22 11 80       	push   $0x80112240
8010434c:	e8 9f 05 00 00       	call   801048f0 <acquire>
  pushcli();
80104351:	e8 4a 04 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80104356:	e8 e5 f8 ff ff       	call   80103c40 <mycpu>
  p = c->proc;
8010435b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104361:	e8 8a 04 00 00       	call   801047f0 <popcli>
  myproc()->state = RUNNABLE;
80104366:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010436d:	e8 ae fc ff ff       	call   80104020 <sched>
  release(&ptable.lock);
80104372:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80104379:	e8 12 05 00 00       	call   80104890 <release>
}
8010437e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104381:	83 c4 10             	add    $0x10,%esp
80104384:	c9                   	leave  
80104385:	c3                   	ret    
80104386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <sleep>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	56                   	push   %esi
80104395:	53                   	push   %ebx
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	8b 7d 08             	mov    0x8(%ebp),%edi
8010439c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010439f:	e8 fc 03 00 00       	call   801047a0 <pushcli>
  c = mycpu();
801043a4:	e8 97 f8 ff ff       	call   80103c40 <mycpu>
  p = c->proc;
801043a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043af:	e8 3c 04 00 00       	call   801047f0 <popcli>
  if(p == 0)
801043b4:	85 db                	test   %ebx,%ebx
801043b6:	0f 84 87 00 00 00    	je     80104443 <sleep+0xb3>
  if(lk == 0)
801043bc:	85 f6                	test   %esi,%esi
801043be:	74 76                	je     80104436 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043c0:	81 fe 40 22 11 80    	cmp    $0x80112240,%esi
801043c6:	74 50                	je     80104418 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	68 40 22 11 80       	push   $0x80112240
801043d0:	e8 1b 05 00 00       	call   801048f0 <acquire>
    release(lk);
801043d5:	89 34 24             	mov    %esi,(%esp)
801043d8:	e8 b3 04 00 00       	call   80104890 <release>
  p->chan = chan;
801043dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043e7:	e8 34 fc ff ff       	call   80104020 <sched>
  p->chan = 0;
801043ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043f3:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801043fa:	e8 91 04 00 00       	call   80104890 <release>
    acquire(lk);
801043ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104402:	83 c4 10             	add    $0x10,%esp
}
80104405:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104408:	5b                   	pop    %ebx
80104409:	5e                   	pop    %esi
8010440a:	5f                   	pop    %edi
8010440b:	5d                   	pop    %ebp
    acquire(lk);
8010440c:	e9 df 04 00 00       	jmp    801048f0 <acquire>
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104418:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010441b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104422:	e8 f9 fb ff ff       	call   80104020 <sched>
  p->chan = 0;
80104427:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010442e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104431:	5b                   	pop    %ebx
80104432:	5e                   	pop    %esi
80104433:	5f                   	pop    %edi
80104434:	5d                   	pop    %ebp
80104435:	c3                   	ret    
    panic("sleep without lk");
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	68 ba 7a 10 80       	push   $0x80107aba
8010443e:	e8 3d bf ff ff       	call   80100380 <panic>
    panic("sleep");
80104443:	83 ec 0c             	sub    $0xc,%esp
80104446:	68 b4 7a 10 80       	push   $0x80107ab4
8010444b:	e8 30 bf ff ff       	call   80100380 <panic>

80104450 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010445a:	68 40 22 11 80       	push   $0x80112240
8010445f:	e8 8c 04 00 00       	call   801048f0 <acquire>
80104464:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104467:	b8 74 22 11 80       	mov    $0x80112274,%eax
8010446c:	eb 0c                	jmp    8010447a <wakeup+0x2a>
8010446e:	66 90                	xchg   %ax,%ax
80104470:	83 c0 7c             	add    $0x7c,%eax
80104473:	3d 74 41 11 80       	cmp    $0x80114174,%eax
80104478:	74 1c                	je     80104496 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010447a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010447e:	75 f0                	jne    80104470 <wakeup+0x20>
80104480:	3b 58 20             	cmp    0x20(%eax),%ebx
80104483:	75 eb                	jne    80104470 <wakeup+0x20>
      p->state = RUNNABLE;
80104485:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010448c:	83 c0 7c             	add    $0x7c,%eax
8010448f:	3d 74 41 11 80       	cmp    $0x80114174,%eax
80104494:	75 e4                	jne    8010447a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104496:	c7 45 08 40 22 11 80 	movl   $0x80112240,0x8(%ebp)
}
8010449d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a0:	c9                   	leave  
  release(&ptable.lock);
801044a1:	e9 ea 03 00 00       	jmp    80104890 <release>
801044a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ad:	8d 76 00             	lea    0x0(%esi),%esi

801044b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
801044b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ba:	68 40 22 11 80       	push   $0x80112240
801044bf:	e8 2c 04 00 00       	call   801048f0 <acquire>
801044c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c7:	b8 74 22 11 80       	mov    $0x80112274,%eax
801044cc:	eb 0c                	jmp    801044da <kill+0x2a>
801044ce:	66 90                	xchg   %ax,%ax
801044d0:	83 c0 7c             	add    $0x7c,%eax
801044d3:	3d 74 41 11 80       	cmp    $0x80114174,%eax
801044d8:	74 36                	je     80104510 <kill+0x60>
    if(p->pid == pid){
801044da:	39 58 10             	cmp    %ebx,0x10(%eax)
801044dd:	75 f1                	jne    801044d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044ea:	75 07                	jne    801044f3 <kill+0x43>
        p->state = RUNNABLE;
801044ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044f3:	83 ec 0c             	sub    $0xc,%esp
801044f6:	68 40 22 11 80       	push   $0x80112240
801044fb:	e8 90 03 00 00       	call   80104890 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104503:	83 c4 10             	add    $0x10,%esp
80104506:	31 c0                	xor    %eax,%eax
}
80104508:	c9                   	leave  
80104509:	c3                   	ret    
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	68 40 22 11 80       	push   $0x80112240
80104518:	e8 73 03 00 00       	call   80104890 <release>
}
8010451d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104520:	83 c4 10             	add    $0x10,%esp
80104523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104528:	c9                   	leave  
80104529:	c3                   	ret    
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104538:	53                   	push   %ebx
80104539:	bb e0 22 11 80       	mov    $0x801122e0,%ebx
8010453e:	83 ec 3c             	sub    $0x3c,%esp
80104541:	eb 24                	jmp    80104567 <procdump+0x37>
80104543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104547:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104548:	83 ec 0c             	sub    $0xc,%esp
8010454b:	68 37 7e 10 80       	push   $0x80107e37
80104550:	e8 5b c2 ff ff       	call   801007b0 <cprintf>
80104555:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104558:	83 c3 7c             	add    $0x7c,%ebx
8010455b:	81 fb e0 41 11 80    	cmp    $0x801141e0,%ebx
80104561:	0f 84 81 00 00 00    	je     801045e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104567:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010456a:	85 c0                	test   %eax,%eax
8010456c:	74 ea                	je     80104558 <procdump+0x28>
      state = "???";
8010456e:	ba cb 7a 10 80       	mov    $0x80107acb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104573:	83 f8 05             	cmp    $0x5,%eax
80104576:	77 11                	ja     80104589 <procdump+0x59>
80104578:	8b 14 85 2c 7b 10 80 	mov    -0x7fef84d4(,%eax,4),%edx
      state = "???";
8010457f:	b8 cb 7a 10 80       	mov    $0x80107acb,%eax
80104584:	85 d2                	test   %edx,%edx
80104586:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104589:	53                   	push   %ebx
8010458a:	52                   	push   %edx
8010458b:	ff 73 a4             	push   -0x5c(%ebx)
8010458e:	68 cf 7a 10 80       	push   $0x80107acf
80104593:	e8 18 c2 ff ff       	call   801007b0 <cprintf>
    if(p->state == SLEEPING){
80104598:	83 c4 10             	add    $0x10,%esp
8010459b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010459f:	75 a7                	jne    80104548 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045a1:	83 ec 08             	sub    $0x8,%esp
801045a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045aa:	50                   	push   %eax
801045ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045ae:	8b 40 0c             	mov    0xc(%eax),%eax
801045b1:	83 c0 08             	add    $0x8,%eax
801045b4:	50                   	push   %eax
801045b5:	e8 86 01 00 00       	call   80104740 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045ba:	83 c4 10             	add    $0x10,%esp
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
801045c0:	8b 17                	mov    (%edi),%edx
801045c2:	85 d2                	test   %edx,%edx
801045c4:	74 82                	je     80104548 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801045cc:	52                   	push   %edx
801045cd:	68 21 75 10 80       	push   $0x80107521
801045d2:	e8 d9 c1 ff ff       	call   801007b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045d7:	83 c4 10             	add    $0x10,%esp
801045da:	39 fe                	cmp    %edi,%esi
801045dc:	75 e2                	jne    801045c0 <procdump+0x90>
801045de:	e9 65 ff ff ff       	jmp    80104548 <procdump+0x18>
801045e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e7:	90                   	nop
  }
}
801045e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045eb:	5b                   	pop    %ebx
801045ec:	5e                   	pop    %esi
801045ed:	5f                   	pop    %edi
801045ee:	5d                   	pop    %ebp
801045ef:	c3                   	ret    

801045f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045fa:	68 44 7b 10 80       	push   $0x80107b44
801045ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104602:	50                   	push   %eax
80104603:	e8 18 01 00 00       	call   80104720 <initlock>
  lk->name = name;
80104608:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010460b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104611:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104614:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010461b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010461e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104621:	c9                   	leave  
80104622:	c3                   	ret    
80104623:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	8d 73 04             	lea    0x4(%ebx),%esi
8010463b:	83 ec 0c             	sub    $0xc,%esp
8010463e:	56                   	push   %esi
8010463f:	e8 ac 02 00 00       	call   801048f0 <acquire>
  while (lk->locked) {
80104644:	8b 13                	mov    (%ebx),%edx
80104646:	83 c4 10             	add    $0x10,%esp
80104649:	85 d2                	test   %edx,%edx
8010464b:	74 16                	je     80104663 <acquiresleep+0x33>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104650:	83 ec 08             	sub    $0x8,%esp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	e8 36 fd ff ff       	call   80104390 <sleep>
  while (lk->locked) {
8010465a:	8b 03                	mov    (%ebx),%eax
8010465c:	83 c4 10             	add    $0x10,%esp
8010465f:	85 c0                	test   %eax,%eax
80104661:	75 ed                	jne    80104650 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104663:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104669:	e8 52 f6 ff ff       	call   80103cc0 <myproc>
8010466e:	8b 40 10             	mov    0x10(%eax),%eax
80104671:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104674:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104677:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010467a:	5b                   	pop    %ebx
8010467b:	5e                   	pop    %esi
8010467c:	5d                   	pop    %ebp
  release(&lk->lk);
8010467d:	e9 0e 02 00 00       	jmp    80104890 <release>
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104698:	8d 73 04             	lea    0x4(%ebx),%esi
8010469b:	83 ec 0c             	sub    $0xc,%esp
8010469e:	56                   	push   %esi
8010469f:	e8 4c 02 00 00       	call   801048f0 <acquire>
  lk->locked = 0;
801046a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046b1:	89 1c 24             	mov    %ebx,(%esp)
801046b4:	e8 97 fd ff ff       	call   80104450 <wakeup>
  release(&lk->lk);
801046b9:	89 75 08             	mov    %esi,0x8(%ebp)
801046bc:	83 c4 10             	add    $0x10,%esp
}
801046bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
  release(&lk->lk);
801046c5:	e9 c6 01 00 00       	jmp    80104890 <release>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	31 ff                	xor    %edi,%edi
801046d6:	56                   	push   %esi
801046d7:	53                   	push   %ebx
801046d8:	83 ec 18             	sub    $0x18,%esp
801046db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046de:	8d 73 04             	lea    0x4(%ebx),%esi
801046e1:	56                   	push   %esi
801046e2:	e8 09 02 00 00       	call   801048f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046e7:	8b 03                	mov    (%ebx),%eax
801046e9:	83 c4 10             	add    $0x10,%esp
801046ec:	85 c0                	test   %eax,%eax
801046ee:	75 18                	jne    80104708 <holdingsleep+0x38>
  release(&lk->lk);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	56                   	push   %esi
801046f4:	e8 97 01 00 00       	call   80104890 <release>
  return r;
}
801046f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046fc:	89 f8                	mov    %edi,%eax
801046fe:	5b                   	pop    %ebx
801046ff:	5e                   	pop    %esi
80104700:	5f                   	pop    %edi
80104701:	5d                   	pop    %ebp
80104702:	c3                   	ret    
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104708:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010470b:	e8 b0 f5 ff ff       	call   80103cc0 <myproc>
80104710:	39 58 10             	cmp    %ebx,0x10(%eax)
80104713:	0f 94 c0             	sete   %al
80104716:	0f b6 c0             	movzbl %al,%eax
80104719:	89 c7                	mov    %eax,%edi
8010471b:	eb d3                	jmp    801046f0 <holdingsleep+0x20>
8010471d:	66 90                	xchg   %ax,%ax
8010471f:	90                   	nop

80104720 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104726:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010472f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop

80104740 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104740:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104741:	31 d2                	xor    %edx,%edx
{
80104743:	89 e5                	mov    %esp,%ebp
80104745:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104746:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010474c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010474f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104750:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104756:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010475c:	77 1a                	ja     80104778 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010475e:	8b 58 04             	mov    0x4(%eax),%ebx
80104761:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104764:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104767:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104769:	83 fa 0a             	cmp    $0xa,%edx
8010476c:	75 e2                	jne    80104750 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010476e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104771:	c9                   	leave  
80104772:	c3                   	ret    
80104773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104777:	90                   	nop
  for(; i < 10; i++)
80104778:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010477b:	8d 51 28             	lea    0x28(%ecx),%edx
8010477e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104786:	83 c0 04             	add    $0x4,%eax
80104789:	39 d0                	cmp    %edx,%eax
8010478b:	75 f3                	jne    80104780 <getcallerpcs+0x40>
}
8010478d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104790:	c9                   	leave  
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
801047a7:	9c                   	pushf  
801047a8:	5b                   	pop    %ebx
  asm volatile("cli");
801047a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047aa:	e8 91 f4 ff ff       	call   80103c40 <mycpu>
801047af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047b5:	85 c0                	test   %eax,%eax
801047b7:	74 17                	je     801047d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047b9:	e8 82 f4 ff ff       	call   80103c40 <mycpu>
801047be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c8:	c9                   	leave  
801047c9:	c3                   	ret    
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801047d0:	e8 6b f4 ff ff       	call   80103c40 <mycpu>
801047d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047e1:	eb d6                	jmp    801047b9 <pushcli+0x19>
801047e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <popcli>:

void
popcli(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047f6:	9c                   	pushf  
801047f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047f8:	f6 c4 02             	test   $0x2,%ah
801047fb:	75 35                	jne    80104832 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047fd:	e8 3e f4 ff ff       	call   80103c40 <mycpu>
80104802:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104809:	78 34                	js     8010483f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010480b:	e8 30 f4 ff ff       	call   80103c40 <mycpu>
80104810:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104816:	85 d2                	test   %edx,%edx
80104818:	74 06                	je     80104820 <popcli+0x30>
    sti();
}
8010481a:	c9                   	leave  
8010481b:	c3                   	ret    
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104820:	e8 1b f4 ff ff       	call   80103c40 <mycpu>
80104825:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010482b:	85 c0                	test   %eax,%eax
8010482d:	74 eb                	je     8010481a <popcli+0x2a>
  asm volatile("sti");
8010482f:	fb                   	sti    
}
80104830:	c9                   	leave  
80104831:	c3                   	ret    
    panic("popcli - interruptible");
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 4f 7b 10 80       	push   $0x80107b4f
8010483a:	e8 41 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010483f:	83 ec 0c             	sub    $0xc,%esp
80104842:	68 66 7b 10 80       	push   $0x80107b66
80104847:	e8 34 bb ff ff       	call   80100380 <panic>
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <holding>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 75 08             	mov    0x8(%ebp),%esi
80104858:	31 db                	xor    %ebx,%ebx
  pushcli();
8010485a:	e8 41 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010485f:	8b 06                	mov    (%esi),%eax
80104861:	85 c0                	test   %eax,%eax
80104863:	75 0b                	jne    80104870 <holding+0x20>
  popcli();
80104865:	e8 86 ff ff ff       	call   801047f0 <popcli>
}
8010486a:	89 d8                	mov    %ebx,%eax
8010486c:	5b                   	pop    %ebx
8010486d:	5e                   	pop    %esi
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104870:	8b 5e 08             	mov    0x8(%esi),%ebx
80104873:	e8 c8 f3 ff ff       	call   80103c40 <mycpu>
80104878:	39 c3                	cmp    %eax,%ebx
8010487a:	0f 94 c3             	sete   %bl
  popcli();
8010487d:	e8 6e ff ff ff       	call   801047f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104882:	0f b6 db             	movzbl %bl,%ebx
}
80104885:	89 d8                	mov    %ebx,%eax
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <release>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104898:	e8 03 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010489d:	8b 03                	mov    (%ebx),%eax
8010489f:	85 c0                	test   %eax,%eax
801048a1:	75 15                	jne    801048b8 <release+0x28>
  popcli();
801048a3:	e8 48 ff ff ff       	call   801047f0 <popcli>
    panic("release");
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 6d 7b 10 80       	push   $0x80107b6d
801048b0:	e8 cb ba ff ff       	call   80100380 <panic>
801048b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048b8:	8b 73 08             	mov    0x8(%ebx),%esi
801048bb:	e8 80 f3 ff ff       	call   80103c40 <mycpu>
801048c0:	39 c6                	cmp    %eax,%esi
801048c2:	75 df                	jne    801048a3 <release+0x13>
  popcli();
801048c4:	e8 27 ff ff ff       	call   801047f0 <popcli>
  lk->pcs[0] = 0;
801048c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5d                   	pop    %ebp
  popcli();
801048e8:	e9 03 ff ff ff       	jmp    801047f0 <popcli>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <acquire>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048f7:	e8 a4 fe ff ff       	call   801047a0 <pushcli>
  if(holding(lk))
801048fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048ff:	e8 9c fe ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104904:	8b 03                	mov    (%ebx),%eax
80104906:	85 c0                	test   %eax,%eax
80104908:	75 7e                	jne    80104988 <acquire+0x98>
  popcli();
8010490a:	e8 e1 fe ff ff       	call   801047f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010490f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104918:	8b 55 08             	mov    0x8(%ebp),%edx
8010491b:	89 c8                	mov    %ecx,%eax
8010491d:	f0 87 02             	lock xchg %eax,(%edx)
80104920:	85 c0                	test   %eax,%eax
80104922:	75 f4                	jne    80104918 <acquire+0x28>
  __sync_synchronize();
80104924:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104929:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010492c:	e8 0f f3 ff ff       	call   80103c40 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104931:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104934:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104936:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104939:	31 c0                	xor    %eax,%eax
8010493b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010493f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104940:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104946:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010494c:	77 1a                	ja     80104968 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010494e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104951:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104955:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104958:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010495a:	83 f8 0a             	cmp    $0xa,%eax
8010495d:	75 e1                	jne    80104940 <acquire+0x50>
}
8010495f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104962:	c9                   	leave  
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104968:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010496c:	8d 51 34             	lea    0x34(%ecx),%edx
8010496f:	90                   	nop
    pcs[i] = 0;
80104970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104976:	83 c0 04             	add    $0x4,%eax
80104979:	39 c2                	cmp    %eax,%edx
8010497b:	75 f3                	jne    80104970 <acquire+0x80>
}
8010497d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104980:	c9                   	leave  
80104981:	c3                   	ret    
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104988:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010498b:	e8 b0 f2 ff ff       	call   80103c40 <mycpu>
80104990:	39 c3                	cmp    %eax,%ebx
80104992:	0f 85 72 ff ff ff    	jne    8010490a <acquire+0x1a>
  popcli();
80104998:	e8 53 fe ff ff       	call   801047f0 <popcli>
    panic("acquire");
8010499d:	83 ec 0c             	sub    $0xc,%esp
801049a0:	68 75 7b 10 80       	push   $0x80107b75
801049a5:	e8 d6 b9 ff ff       	call   80100380 <panic>
801049aa:	66 90                	xchg   %ax,%ax
801049ac:	66 90                	xchg   %ax,%ax
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	8b 55 08             	mov    0x8(%ebp),%edx
801049b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ba:	53                   	push   %ebx
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801049be:	89 d7                	mov    %edx,%edi
801049c0:	09 cf                	or     %ecx,%edi
801049c2:	83 e7 03             	and    $0x3,%edi
801049c5:	75 29                	jne    801049f0 <memset+0x40>
    c &= 0xFF;
801049c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049ca:	c1 e0 18             	shl    $0x18,%eax
801049cd:	89 fb                	mov    %edi,%ebx
801049cf:	c1 e9 02             	shr    $0x2,%ecx
801049d2:	c1 e3 10             	shl    $0x10,%ebx
801049d5:	09 d8                	or     %ebx,%eax
801049d7:	09 f8                	or     %edi,%eax
801049d9:	c1 e7 08             	shl    $0x8,%edi
801049dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049de:	89 d7                	mov    %edx,%edi
801049e0:	fc                   	cld    
801049e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049e3:	5b                   	pop    %ebx
801049e4:	89 d0                	mov    %edx,%eax
801049e6:	5f                   	pop    %edi
801049e7:	5d                   	pop    %ebp
801049e8:	c3                   	ret    
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049f0:	89 d7                	mov    %edx,%edi
801049f2:	fc                   	cld    
801049f3:	f3 aa                	rep stos %al,%es:(%edi)
801049f5:	5b                   	pop    %ebx
801049f6:	89 d0                	mov    %edx,%eax
801049f8:	5f                   	pop    %edi
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049ff:	90                   	nop

80104a00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	8b 75 10             	mov    0x10(%ebp),%esi
80104a07:	8b 55 08             	mov    0x8(%ebp),%edx
80104a0a:	53                   	push   %ebx
80104a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a0e:	85 f6                	test   %esi,%esi
80104a10:	74 2e                	je     80104a40 <memcmp+0x40>
80104a12:	01 c6                	add    %eax,%esi
80104a14:	eb 14                	jmp    80104a2a <memcmp+0x2a>
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a26:	39 f0                	cmp    %esi,%eax
80104a28:	74 16                	je     80104a40 <memcmp+0x40>
    if(*s1 != *s2)
80104a2a:	0f b6 0a             	movzbl (%edx),%ecx
80104a2d:	0f b6 18             	movzbl (%eax),%ebx
80104a30:	38 d9                	cmp    %bl,%cl
80104a32:	74 ec                	je     80104a20 <memcmp+0x20>
      return *s1 - *s2;
80104a34:	0f b6 c1             	movzbl %cl,%eax
80104a37:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	5b                   	pop    %ebx
  return 0;
80104a41:	31 c0                	xor    %eax,%eax
}
80104a43:	5e                   	pop    %esi
80104a44:	5d                   	pop    %ebp
80104a45:	c3                   	ret    
80104a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	8b 55 08             	mov    0x8(%ebp),%edx
80104a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a5a:	56                   	push   %esi
80104a5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a5e:	39 d6                	cmp    %edx,%esi
80104a60:	73 26                	jae    80104a88 <memmove+0x38>
80104a62:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a65:	39 fa                	cmp    %edi,%edx
80104a67:	73 1f                	jae    80104a88 <memmove+0x38>
80104a69:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a6c:	85 c9                	test   %ecx,%ecx
80104a6e:	74 0c                	je     80104a7c <memmove+0x2c>
      *--d = *--s;
80104a70:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a74:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a77:	83 e8 01             	sub    $0x1,%eax
80104a7a:	73 f4                	jae    80104a70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a7c:	5e                   	pop    %esi
80104a7d:	89 d0                	mov    %edx,%eax
80104a7f:	5f                   	pop    %edi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a88:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a8b:	89 d7                	mov    %edx,%edi
80104a8d:	85 c9                	test   %ecx,%ecx
80104a8f:	74 eb                	je     80104a7c <memmove+0x2c>
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a98:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a99:	39 c6                	cmp    %eax,%esi
80104a9b:	75 fb                	jne    80104a98 <memmove+0x48>
}
80104a9d:	5e                   	pop    %esi
80104a9e:	89 d0                	mov    %edx,%eax
80104aa0:	5f                   	pop    %edi
80104aa1:	5d                   	pop    %ebp
80104aa2:	c3                   	ret    
80104aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ab0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ab0:	eb 9e                	jmp    80104a50 <memmove>
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aca:	53                   	push   %ebx
80104acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104ace:	85 f6                	test   %esi,%esi
80104ad0:	74 2e                	je     80104b00 <strncmp+0x40>
80104ad2:	01 d6                	add    %edx,%esi
80104ad4:	eb 18                	jmp    80104aee <strncmp+0x2e>
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi
80104ae0:	38 d8                	cmp    %bl,%al
80104ae2:	75 14                	jne    80104af8 <strncmp+0x38>
    n--, p++, q++;
80104ae4:	83 c2 01             	add    $0x1,%edx
80104ae7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104aea:	39 f2                	cmp    %esi,%edx
80104aec:	74 12                	je     80104b00 <strncmp+0x40>
80104aee:	0f b6 01             	movzbl (%ecx),%eax
80104af1:	0f b6 1a             	movzbl (%edx),%ebx
80104af4:	84 c0                	test   %al,%al
80104af6:	75 e8                	jne    80104ae0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104af8:	29 d8                	sub    %ebx,%eax
}
80104afa:	5b                   	pop    %ebx
80104afb:	5e                   	pop    %esi
80104afc:	5d                   	pop    %ebp
80104afd:	c3                   	ret    
80104afe:	66 90                	xchg   %ax,%ax
80104b00:	5b                   	pop    %ebx
    return 0;
80104b01:	31 c0                	xor    %eax,%eax
}
80104b03:	5e                   	pop    %esi
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	8b 75 08             	mov    0x8(%ebp),%esi
80104b18:	53                   	push   %ebx
80104b19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b1c:	89 f0                	mov    %esi,%eax
80104b1e:	eb 15                	jmp    80104b35 <strncpy+0x25>
80104b20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b24:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b27:	83 c0 01             	add    $0x1,%eax
80104b2a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104b2e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b31:	84 d2                	test   %dl,%dl
80104b33:	74 09                	je     80104b3e <strncpy+0x2e>
80104b35:	89 cb                	mov    %ecx,%ebx
80104b37:	83 e9 01             	sub    $0x1,%ecx
80104b3a:	85 db                	test   %ebx,%ebx
80104b3c:	7f e2                	jg     80104b20 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b3e:	89 c2                	mov    %eax,%edx
80104b40:	85 c9                	test   %ecx,%ecx
80104b42:	7e 17                	jle    80104b5b <strncpy+0x4b>
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b48:	83 c2 01             	add    $0x1,%edx
80104b4b:	89 c1                	mov    %eax,%ecx
80104b4d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104b51:	29 d1                	sub    %edx,%ecx
80104b53:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104b57:	85 c9                	test   %ecx,%ecx
80104b59:	7f ed                	jg     80104b48 <strncpy+0x38>
  return os;
}
80104b5b:	5b                   	pop    %ebx
80104b5c:	89 f0                	mov    %esi,%eax
80104b5e:	5e                   	pop    %esi
80104b5f:	5f                   	pop    %edi
80104b60:	5d                   	pop    %ebp
80104b61:	c3                   	ret    
80104b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	8b 55 10             	mov    0x10(%ebp),%edx
80104b77:	8b 75 08             	mov    0x8(%ebp),%esi
80104b7a:	53                   	push   %ebx
80104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b7e:	85 d2                	test   %edx,%edx
80104b80:	7e 25                	jle    80104ba7 <safestrcpy+0x37>
80104b82:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b86:	89 f2                	mov    %esi,%edx
80104b88:	eb 16                	jmp    80104ba0 <safestrcpy+0x30>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b90:	0f b6 08             	movzbl (%eax),%ecx
80104b93:	83 c0 01             	add    $0x1,%eax
80104b96:	83 c2 01             	add    $0x1,%edx
80104b99:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b9c:	84 c9                	test   %cl,%cl
80104b9e:	74 04                	je     80104ba4 <safestrcpy+0x34>
80104ba0:	39 d8                	cmp    %ebx,%eax
80104ba2:	75 ec                	jne    80104b90 <safestrcpy+0x20>
    ;
  *s = 0;
80104ba4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ba7:	89 f0                	mov    %esi,%eax
80104ba9:	5b                   	pop    %ebx
80104baa:	5e                   	pop    %esi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret    
80104bad:	8d 76 00             	lea    0x0(%esi),%esi

80104bb0 <strlen>:

int
strlen(const char *s)
{
80104bb0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bb1:	31 c0                	xor    %eax,%eax
{
80104bb3:	89 e5                	mov    %esp,%ebp
80104bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104bb8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bbb:	74 0c                	je     80104bc9 <strlen+0x19>
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
80104bc0:	83 c0 01             	add    $0x1,%eax
80104bc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bc7:	75 f7                	jne    80104bc0 <strlen+0x10>
    ;
  return n;
}
80104bc9:	5d                   	pop    %ebp
80104bca:	c3                   	ret    

80104bcb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bcb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bcf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bd3:	55                   	push   %ebp
  pushl %ebx
80104bd4:	53                   	push   %ebx
  pushl %esi
80104bd5:	56                   	push   %esi
  pushl %edi
80104bd6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bd7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bd9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bdb:	5f                   	pop    %edi
  popl %esi
80104bdc:	5e                   	pop    %esi
  popl %ebx
80104bdd:	5b                   	pop    %ebx
  popl %ebp
80104bde:	5d                   	pop    %ebp
  ret
80104bdf:	c3                   	ret    

80104be0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	83 ec 04             	sub    $0x4,%esp
80104be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bea:	e8 d1 f0 ff ff       	call   80103cc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bef:	8b 00                	mov    (%eax),%eax
80104bf1:	39 d8                	cmp    %ebx,%eax
80104bf3:	76 1b                	jbe    80104c10 <fetchint+0x30>
80104bf5:	8d 53 04             	lea    0x4(%ebx),%edx
80104bf8:	39 d0                	cmp    %edx,%eax
80104bfa:	72 14                	jb     80104c10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bff:	8b 13                	mov    (%ebx),%edx
80104c01:	89 10                	mov    %edx,(%eax)
  return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c08:	c9                   	leave  
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb ee                	jmp    80104c05 <fetchint+0x25>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 04             	sub    $0x4,%esp
80104c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c2a:	e8 91 f0 ff ff       	call   80103cc0 <myproc>

  if(addr >= curproc->sz)
80104c2f:	39 18                	cmp    %ebx,(%eax)
80104c31:	76 2d                	jbe    80104c60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c3a:	39 d3                	cmp    %edx,%ebx
80104c3c:	73 22                	jae    80104c60 <fetchstr+0x40>
80104c3e:	89 d8                	mov    %ebx,%eax
80104c40:	eb 0d                	jmp    80104c4f <fetchstr+0x2f>
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	83 c0 01             	add    $0x1,%eax
80104c4b:	39 c2                	cmp    %eax,%edx
80104c4d:	76 11                	jbe    80104c60 <fetchstr+0x40>
    if(*s == 0)
80104c4f:	80 38 00             	cmpb   $0x0,(%eax)
80104c52:	75 f4                	jne    80104c48 <fetchstr+0x28>
      return s - *pp;
80104c54:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c59:	c9                   	leave  
80104c5a:	c3                   	ret    
80104c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop
80104c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	e8 46 f0 ff ff       	call   80103cc0 <myproc>
80104c7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7d:	8b 40 18             	mov    0x18(%eax),%eax
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c86:	e8 35 f0 ff ff       	call   80103cc0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8e:	8b 00                	mov    (%eax),%eax
80104c90:	39 c6                	cmp    %eax,%esi
80104c92:	73 1c                	jae    80104cb0 <argint+0x40>
80104c94:	8d 53 08             	lea    0x8(%ebx),%edx
80104c97:	39 d0                	cmp    %edx,%eax
80104c99:	72 15                	jb     80104cb0 <argint+0x40>
  *ip = *(int*)(addr);
80104c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb5:	eb ee                	jmp    80104ca5 <argint+0x35>
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
80104cc6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104cc9:	e8 f2 ef ff ff       	call   80103cc0 <myproc>
80104cce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd0:	e8 eb ef ff ff       	call   80103cc0 <myproc>
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd8:	8b 40 18             	mov    0x18(%eax),%eax
80104cdb:	8b 40 44             	mov    0x44(%eax),%eax
80104cde:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ce1:	e8 da ef ff ff       	call   80103cc0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ce9:	8b 00                	mov    (%eax),%eax
80104ceb:	39 c7                	cmp    %eax,%edi
80104ced:	73 31                	jae    80104d20 <argptr+0x60>
80104cef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104cf2:	39 c8                	cmp    %ecx,%eax
80104cf4:	72 2a                	jb     80104d20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cf6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104cf9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cfc:	85 d2                	test   %edx,%edx
80104cfe:	78 20                	js     80104d20 <argptr+0x60>
80104d00:	8b 16                	mov    (%esi),%edx
80104d02:	39 c2                	cmp    %eax,%edx
80104d04:	76 1a                	jbe    80104d20 <argptr+0x60>
80104d06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d09:	01 c3                	add    %eax,%ebx
80104d0b:	39 da                	cmp    %ebx,%edx
80104d0d:	72 11                	jb     80104d20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d12:	89 02                	mov    %eax,(%edx)
  return 0;
80104d14:	31 c0                	xor    %eax,%eax
}
80104d16:	83 c4 0c             	add    $0xc,%esp
80104d19:	5b                   	pop    %ebx
80104d1a:	5e                   	pop    %esi
80104d1b:	5f                   	pop    %edi
80104d1c:	5d                   	pop    %ebp
80104d1d:	c3                   	ret    
80104d1e:	66 90                	xchg   %ax,%ax
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	eb ef                	jmp    80104d16 <argptr+0x56>
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d35:	e8 86 ef ff ff       	call   80103cc0 <myproc>
80104d3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d3d:	8b 40 18             	mov    0x18(%eax),%eax
80104d40:	8b 40 44             	mov    0x44(%eax),%eax
80104d43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d46:	e8 75 ef ff ff       	call   80103cc0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d4e:	8b 00                	mov    (%eax),%eax
80104d50:	39 c6                	cmp    %eax,%esi
80104d52:	73 44                	jae    80104d98 <argstr+0x68>
80104d54:	8d 53 08             	lea    0x8(%ebx),%edx
80104d57:	39 d0                	cmp    %edx,%eax
80104d59:	72 3d                	jb     80104d98 <argstr+0x68>
  *ip = *(int*)(addr);
80104d5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d5e:	e8 5d ef ff ff       	call   80103cc0 <myproc>
  if(addr >= curproc->sz)
80104d63:	3b 18                	cmp    (%eax),%ebx
80104d65:	73 31                	jae    80104d98 <argstr+0x68>
  *pp = (char*)addr;
80104d67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d6e:	39 d3                	cmp    %edx,%ebx
80104d70:	73 26                	jae    80104d98 <argstr+0x68>
80104d72:	89 d8                	mov    %ebx,%eax
80104d74:	eb 11                	jmp    80104d87 <argstr+0x57>
80104d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	83 c0 01             	add    $0x1,%eax
80104d83:	39 c2                	cmp    %eax,%edx
80104d85:	76 11                	jbe    80104d98 <argstr+0x68>
    if(*s == 0)
80104d87:	80 38 00             	cmpb   $0x0,(%eax)
80104d8a:	75 f4                	jne    80104d80 <argstr+0x50>
      return s - *pp;
80104d8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d8e:	5b                   	pop    %ebx
80104d8f:	5e                   	pop    %esi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	5b                   	pop    %ebx
    return -1;
80104d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d9e:	5e                   	pop    %esi
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret    
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop

80104db0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104db7:	e8 04 ef ff ff       	call   80103cc0 <myproc>
80104dbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dbe:	8b 40 18             	mov    0x18(%eax),%eax
80104dc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dc7:	83 fa 14             	cmp    $0x14,%edx
80104dca:	77 24                	ja     80104df0 <syscall+0x40>
80104dcc:	8b 14 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%edx
80104dd3:	85 d2                	test   %edx,%edx
80104dd5:	74 19                	je     80104df0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104dd7:	ff d2                	call   *%edx
80104dd9:	89 c2                	mov    %eax,%edx
80104ddb:	8b 43 18             	mov    0x18(%ebx),%eax
80104dde:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de4:	c9                   	leave  
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104df0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104df1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104df4:	50                   	push   %eax
80104df5:	ff 73 10             	push   0x10(%ebx)
80104df8:	68 7d 7b 10 80       	push   $0x80107b7d
80104dfd:	e8 ae b9 ff ff       	call   801007b0 <cprintf>
    curproc->tf->eax = -1;
80104e02:	8b 43 18             	mov    0x18(%ebx),%eax
80104e05:	83 c4 10             	add    $0x10,%esp
80104e08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e12:	c9                   	leave  
80104e13:	c3                   	ret    
80104e14:	66 90                	xchg   %ax,%ax
80104e16:	66 90                	xchg   %ax,%ax
80104e18:	66 90                	xchg   %ax,%ax
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e28:	53                   	push   %ebx
80104e29:	83 ec 34             	sub    $0x34,%esp
80104e2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e32:	57                   	push   %edi
80104e33:	50                   	push   %eax
{
80104e34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e3a:	e8 d1 d5 ff ff       	call   80102410 <nameiparent>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	0f 84 46 01 00 00    	je     80104f90 <create+0x170>
    return 0;
  ilock(dp);
80104e4a:	83 ec 0c             	sub    $0xc,%esp
80104e4d:	89 c3                	mov    %eax,%ebx
80104e4f:	50                   	push   %eax
80104e50:	e8 7b cc ff ff       	call   80101ad0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e55:	83 c4 0c             	add    $0xc,%esp
80104e58:	6a 00                	push   $0x0
80104e5a:	57                   	push   %edi
80104e5b:	53                   	push   %ebx
80104e5c:	e8 cf d1 ff ff       	call   80102030 <dirlookup>
80104e61:	83 c4 10             	add    $0x10,%esp
80104e64:	89 c6                	mov    %eax,%esi
80104e66:	85 c0                	test   %eax,%eax
80104e68:	74 56                	je     80104ec0 <create+0xa0>
    iunlockput(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	53                   	push   %ebx
80104e6e:	e8 ed ce ff ff       	call   80101d60 <iunlockput>
    ilock(ip);
80104e73:	89 34 24             	mov    %esi,(%esp)
80104e76:	e8 55 cc ff ff       	call   80101ad0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e7b:	83 c4 10             	add    $0x10,%esp
80104e7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e83:	75 1b                	jne    80104ea0 <create+0x80>
80104e85:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e8a:	75 14                	jne    80104ea0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e8f:	89 f0                	mov    %esi,%eax
80104e91:	5b                   	pop    %ebx
80104e92:	5e                   	pop    %esi
80104e93:	5f                   	pop    %edi
80104e94:	5d                   	pop    %ebp
80104e95:	c3                   	ret    
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
80104ea3:	56                   	push   %esi
    return 0;
80104ea4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ea6:	e8 b5 ce ff ff       	call   80101d60 <iunlockput>
    return 0;
80104eab:	83 c4 10             	add    $0x10,%esp
}
80104eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb1:	89 f0                	mov    %esi,%eax
80104eb3:	5b                   	pop    %ebx
80104eb4:	5e                   	pop    %esi
80104eb5:	5f                   	pop    %edi
80104eb6:	5d                   	pop    %ebp
80104eb7:	c3                   	ret    
80104eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ec0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ec4:	83 ec 08             	sub    $0x8,%esp
80104ec7:	50                   	push   %eax
80104ec8:	ff 33                	push   (%ebx)
80104eca:	e8 91 ca ff ff       	call   80101960 <ialloc>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	89 c6                	mov    %eax,%esi
80104ed4:	85 c0                	test   %eax,%eax
80104ed6:	0f 84 cd 00 00 00    	je     80104fa9 <create+0x189>
  ilock(ip);
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	50                   	push   %eax
80104ee0:	e8 eb cb ff ff       	call   80101ad0 <ilock>
  ip->major = major;
80104ee5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ee9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104eed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ef1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ef5:	b8 01 00 00 00       	mov    $0x1,%eax
80104efa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104efe:	89 34 24             	mov    %esi,(%esp)
80104f01:	e8 1a cb ff ff       	call   80101a20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f0e:	74 30                	je     80104f40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f10:	83 ec 04             	sub    $0x4,%esp
80104f13:	ff 76 04             	push   0x4(%esi)
80104f16:	57                   	push   %edi
80104f17:	53                   	push   %ebx
80104f18:	e8 13 d4 ff ff       	call   80102330 <dirlink>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 78                	js     80104f9c <create+0x17c>
  iunlockput(dp);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	53                   	push   %ebx
80104f28:	e8 33 ce ff ff       	call   80101d60 <iunlockput>
  return ip;
80104f2d:	83 c4 10             	add    $0x10,%esp
}
80104f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f33:	89 f0                	mov    %esi,%eax
80104f35:	5b                   	pop    %ebx
80104f36:	5e                   	pop    %esi
80104f37:	5f                   	pop    %edi
80104f38:	5d                   	pop    %ebp
80104f39:	c3                   	ret    
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f48:	53                   	push   %ebx
80104f49:	e8 d2 ca ff ff       	call   80101a20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f4e:	83 c4 0c             	add    $0xc,%esp
80104f51:	ff 76 04             	push   0x4(%esi)
80104f54:	68 14 7c 10 80       	push   $0x80107c14
80104f59:	56                   	push   %esi
80104f5a:	e8 d1 d3 ff ff       	call   80102330 <dirlink>
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	85 c0                	test   %eax,%eax
80104f64:	78 18                	js     80104f7e <create+0x15e>
80104f66:	83 ec 04             	sub    $0x4,%esp
80104f69:	ff 73 04             	push   0x4(%ebx)
80104f6c:	68 13 7c 10 80       	push   $0x80107c13
80104f71:	56                   	push   %esi
80104f72:	e8 b9 d3 ff ff       	call   80102330 <dirlink>
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	79 92                	jns    80104f10 <create+0xf0>
      panic("create dots");
80104f7e:	83 ec 0c             	sub    $0xc,%esp
80104f81:	68 07 7c 10 80       	push   $0x80107c07
80104f86:	e8 f5 b3 ff ff       	call   80100380 <panic>
80104f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f8f:	90                   	nop
}
80104f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f93:	31 f6                	xor    %esi,%esi
}
80104f95:	5b                   	pop    %ebx
80104f96:	89 f0                	mov    %esi,%eax
80104f98:	5e                   	pop    %esi
80104f99:	5f                   	pop    %edi
80104f9a:	5d                   	pop    %ebp
80104f9b:	c3                   	ret    
    panic("create: dirlink");
80104f9c:	83 ec 0c             	sub    $0xc,%esp
80104f9f:	68 16 7c 10 80       	push   $0x80107c16
80104fa4:	e8 d7 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104fa9:	83 ec 0c             	sub    $0xc,%esp
80104fac:	68 f8 7b 10 80       	push   $0x80107bf8
80104fb1:	e8 ca b3 ff ff       	call   80100380 <panic>
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi

80104fc0 <sys_dup>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fcb:	50                   	push   %eax
80104fcc:	6a 00                	push   $0x0
80104fce:	e8 9d fc ff ff       	call   80104c70 <argint>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 36                	js     80105010 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fde:	77 30                	ja     80105010 <sys_dup+0x50>
80104fe0:	e8 db ec ff ff       	call   80103cc0 <myproc>
80104fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fec:	85 f6                	test   %esi,%esi
80104fee:	74 20                	je     80105010 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ff0:	e8 cb ec ff ff       	call   80103cc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ff5:	31 db                	xor    %ebx,%ebx
80104ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105000:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105004:	85 d2                	test   %edx,%edx
80105006:	74 18                	je     80105020 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105008:	83 c3 01             	add    $0x1,%ebx
8010500b:	83 fb 10             	cmp    $0x10,%ebx
8010500e:	75 f0                	jne    80105000 <sys_dup+0x40>
}
80105010:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105013:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105018:	89 d8                	mov    %ebx,%eax
8010501a:	5b                   	pop    %ebx
8010501b:	5e                   	pop    %esi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105020:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105023:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105027:	56                   	push   %esi
80105028:	e8 c3 c1 ff ff       	call   801011f0 <filedup>
  return fd;
8010502d:	83 c4 10             	add    $0x10,%esp
}
80105030:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105033:	89 d8                	mov    %ebx,%eax
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret    
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105040 <sys_read>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105045:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105048:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504b:	53                   	push   %ebx
8010504c:	6a 00                	push   $0x0
8010504e:	e8 1d fc ff ff       	call   80104c70 <argint>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 5e                	js     801050b8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505e:	77 58                	ja     801050b8 <sys_read+0x78>
80105060:	e8 5b ec ff ff       	call   80103cc0 <myproc>
80105065:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105068:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010506c:	85 f6                	test   %esi,%esi
8010506e:	74 48                	je     801050b8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105070:	83 ec 08             	sub    $0x8,%esp
80105073:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105076:	50                   	push   %eax
80105077:	6a 02                	push   $0x2
80105079:	e8 f2 fb ff ff       	call   80104c70 <argint>
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	85 c0                	test   %eax,%eax
80105083:	78 33                	js     801050b8 <sys_read+0x78>
80105085:	83 ec 04             	sub    $0x4,%esp
80105088:	ff 75 f0             	push   -0x10(%ebp)
8010508b:	53                   	push   %ebx
8010508c:	6a 01                	push   $0x1
8010508e:	e8 2d fc ff ff       	call   80104cc0 <argptr>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 1e                	js     801050b8 <sys_read+0x78>
  return fileread(f, p, n);
8010509a:	83 ec 04             	sub    $0x4,%esp
8010509d:	ff 75 f0             	push   -0x10(%ebp)
801050a0:	ff 75 f4             	push   -0xc(%ebp)
801050a3:	56                   	push   %esi
801050a4:	e8 c7 c2 ff ff       	call   80101370 <fileread>
801050a9:	83 c4 10             	add    $0x10,%esp
}
801050ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050af:	5b                   	pop    %ebx
801050b0:	5e                   	pop    %esi
801050b1:	5d                   	pop    %ebp
801050b2:	c3                   	ret    
801050b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b7:	90                   	nop
    return -1;
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb ed                	jmp    801050ac <sys_read+0x6c>
801050bf:	90                   	nop

801050c0 <sys_write>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cb:	53                   	push   %ebx
801050cc:	6a 00                	push   $0x0
801050ce:	e8 9d fb ff ff       	call   80104c70 <argint>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 5e                	js     80105138 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050de:	77 58                	ja     80105138 <sys_write+0x78>
801050e0:	e8 db eb ff ff       	call   80103cc0 <myproc>
801050e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ec:	85 f6                	test   %esi,%esi
801050ee:	74 48                	je     80105138 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050f0:	83 ec 08             	sub    $0x8,%esp
801050f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050f6:	50                   	push   %eax
801050f7:	6a 02                	push   $0x2
801050f9:	e8 72 fb ff ff       	call   80104c70 <argint>
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	85 c0                	test   %eax,%eax
80105103:	78 33                	js     80105138 <sys_write+0x78>
80105105:	83 ec 04             	sub    $0x4,%esp
80105108:	ff 75 f0             	push   -0x10(%ebp)
8010510b:	53                   	push   %ebx
8010510c:	6a 01                	push   $0x1
8010510e:	e8 ad fb ff ff       	call   80104cc0 <argptr>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 1e                	js     80105138 <sys_write+0x78>
  return filewrite(f, p, n);
8010511a:	83 ec 04             	sub    $0x4,%esp
8010511d:	ff 75 f0             	push   -0x10(%ebp)
80105120:	ff 75 f4             	push   -0xc(%ebp)
80105123:	56                   	push   %esi
80105124:	e8 d7 c2 ff ff       	call   80101400 <filewrite>
80105129:	83 c4 10             	add    $0x10,%esp
}
8010512c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010512f:	5b                   	pop    %ebx
80105130:	5e                   	pop    %esi
80105131:	5d                   	pop    %ebp
80105132:	c3                   	ret    
80105133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105137:	90                   	nop
    return -1;
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb ed                	jmp    8010512c <sys_write+0x6c>
8010513f:	90                   	nop

80105140 <sys_close>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105145:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105148:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514b:	50                   	push   %eax
8010514c:	6a 00                	push   $0x0
8010514e:	e8 1d fb ff ff       	call   80104c70 <argint>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	78 3e                	js     80105198 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010515e:	77 38                	ja     80105198 <sys_close+0x58>
80105160:	e8 5b eb ff ff       	call   80103cc0 <myproc>
80105165:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105168:	8d 5a 08             	lea    0x8(%edx),%ebx
8010516b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010516f:	85 f6                	test   %esi,%esi
80105171:	74 25                	je     80105198 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105173:	e8 48 eb ff ff       	call   80103cc0 <myproc>
  fileclose(f);
80105178:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010517b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105182:	00 
  fileclose(f);
80105183:	56                   	push   %esi
80105184:	e8 b7 c0 ff ff       	call   80101240 <fileclose>
  return 0;
80105189:	83 c4 10             	add    $0x10,%esp
8010518c:	31 c0                	xor    %eax,%eax
}
8010518e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105191:	5b                   	pop    %ebx
80105192:	5e                   	pop    %esi
80105193:	5d                   	pop    %ebp
80105194:	c3                   	ret    
80105195:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519d:	eb ef                	jmp    8010518e <sys_close+0x4e>
8010519f:	90                   	nop

801051a0 <sys_fstat>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051ab:	53                   	push   %ebx
801051ac:	6a 00                	push   $0x0
801051ae:	e8 bd fa ff ff       	call   80104c70 <argint>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	78 46                	js     80105200 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051be:	77 40                	ja     80105200 <sys_fstat+0x60>
801051c0:	e8 fb ea ff ff       	call   80103cc0 <myproc>
801051c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051cc:	85 f6                	test   %esi,%esi
801051ce:	74 30                	je     80105200 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d0:	83 ec 04             	sub    $0x4,%esp
801051d3:	6a 14                	push   $0x14
801051d5:	53                   	push   %ebx
801051d6:	6a 01                	push   $0x1
801051d8:	e8 e3 fa ff ff       	call   80104cc0 <argptr>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 1c                	js     80105200 <sys_fstat+0x60>
  return filestat(f, st);
801051e4:	83 ec 08             	sub    $0x8,%esp
801051e7:	ff 75 f4             	push   -0xc(%ebp)
801051ea:	56                   	push   %esi
801051eb:	e8 30 c1 ff ff       	call   80101320 <filestat>
801051f0:	83 c4 10             	add    $0x10,%esp
}
801051f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f6:	5b                   	pop    %ebx
801051f7:	5e                   	pop    %esi
801051f8:	5d                   	pop    %ebp
801051f9:	c3                   	ret    
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105205:	eb ec                	jmp    801051f3 <sys_fstat+0x53>
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <sys_link>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105215:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105218:	53                   	push   %ebx
80105219:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 0c fb ff ff       	call   80104d30 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 fb 00 00 00    	js     8010532a <sys_link+0x11a>
8010522f:	83 ec 08             	sub    $0x8,%esp
80105232:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105235:	50                   	push   %eax
80105236:	6a 01                	push   $0x1
80105238:	e8 f3 fa ff ff       	call   80104d30 <argstr>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	0f 88 e2 00 00 00    	js     8010532a <sys_link+0x11a>
  begin_op();
80105248:	e8 63 de ff ff       	call   801030b0 <begin_op>
  if((ip = namei(old)) == 0){
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	ff 75 d4             	push   -0x2c(%ebp)
80105253:	e8 98 d1 ff ff       	call   801023f0 <namei>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	89 c3                	mov    %eax,%ebx
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 e4 00 00 00    	je     80105349 <sys_link+0x139>
  ilock(ip);
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	50                   	push   %eax
80105269:	e8 62 c8 ff ff       	call   80101ad0 <ilock>
  if(ip->type == T_DIR){
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105276:	0f 84 b5 00 00 00    	je     80105331 <sys_link+0x121>
  iupdate(ip);
8010527c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010527f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105284:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105287:	53                   	push   %ebx
80105288:	e8 93 c7 ff ff       	call   80101a20 <iupdate>
  iunlock(ip);
8010528d:	89 1c 24             	mov    %ebx,(%esp)
80105290:	e8 1b c9 ff ff       	call   80101bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105295:	58                   	pop    %eax
80105296:	5a                   	pop    %edx
80105297:	57                   	push   %edi
80105298:	ff 75 d0             	push   -0x30(%ebp)
8010529b:	e8 70 d1 ff ff       	call   80102410 <nameiparent>
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	89 c6                	mov    %eax,%esi
801052a5:	85 c0                	test   %eax,%eax
801052a7:	74 5b                	je     80105304 <sys_link+0xf4>
  ilock(dp);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 1e c8 ff ff       	call   80101ad0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052b2:	8b 03                	mov    (%ebx),%eax
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	39 06                	cmp    %eax,(%esi)
801052b9:	75 3d                	jne    801052f8 <sys_link+0xe8>
801052bb:	83 ec 04             	sub    $0x4,%esp
801052be:	ff 73 04             	push   0x4(%ebx)
801052c1:	57                   	push   %edi
801052c2:	56                   	push   %esi
801052c3:	e8 68 d0 ff ff       	call   80102330 <dirlink>
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	85 c0                	test   %eax,%eax
801052cd:	78 29                	js     801052f8 <sys_link+0xe8>
  iunlockput(dp);
801052cf:	83 ec 0c             	sub    $0xc,%esp
801052d2:	56                   	push   %esi
801052d3:	e8 88 ca ff ff       	call   80101d60 <iunlockput>
  iput(ip);
801052d8:	89 1c 24             	mov    %ebx,(%esp)
801052db:	e8 20 c9 ff ff       	call   80101c00 <iput>
  end_op();
801052e0:	e8 3b de ff ff       	call   80103120 <end_op>
  return 0;
801052e5:	83 c4 10             	add    $0x10,%esp
801052e8:	31 c0                	xor    %eax,%eax
}
801052ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ed:	5b                   	pop    %ebx
801052ee:	5e                   	pop    %esi
801052ef:	5f                   	pop    %edi
801052f0:	5d                   	pop    %ebp
801052f1:	c3                   	ret    
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	56                   	push   %esi
801052fc:	e8 5f ca ff ff       	call   80101d60 <iunlockput>
    goto bad;
80105301:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	53                   	push   %ebx
80105308:	e8 c3 c7 ff ff       	call   80101ad0 <ilock>
  ip->nlink--;
8010530d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105312:	89 1c 24             	mov    %ebx,(%esp)
80105315:	e8 06 c7 ff ff       	call   80101a20 <iupdate>
  iunlockput(ip);
8010531a:	89 1c 24             	mov    %ebx,(%esp)
8010531d:	e8 3e ca ff ff       	call   80101d60 <iunlockput>
  end_op();
80105322:	e8 f9 dd ff ff       	call   80103120 <end_op>
  return -1;
80105327:	83 c4 10             	add    $0x10,%esp
8010532a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532f:	eb b9                	jmp    801052ea <sys_link+0xda>
    iunlockput(ip);
80105331:	83 ec 0c             	sub    $0xc,%esp
80105334:	53                   	push   %ebx
80105335:	e8 26 ca ff ff       	call   80101d60 <iunlockput>
    end_op();
8010533a:	e8 e1 dd ff ff       	call   80103120 <end_op>
    return -1;
8010533f:	83 c4 10             	add    $0x10,%esp
80105342:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105347:	eb a1                	jmp    801052ea <sys_link+0xda>
    end_op();
80105349:	e8 d2 dd ff ff       	call   80103120 <end_op>
    return -1;
8010534e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105353:	eb 95                	jmp    801052ea <sys_link+0xda>
80105355:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_unlink>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105365:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105368:	53                   	push   %ebx
80105369:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 bc f9 ff ff       	call   80104d30 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 7a 01 00 00    	js     801054f9 <sys_unlink+0x199>
  begin_op();
8010537f:	e8 2c dd ff ff       	call   801030b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105384:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	53                   	push   %ebx
8010538b:	ff 75 c0             	push   -0x40(%ebp)
8010538e:	e8 7d d0 ff ff       	call   80102410 <nameiparent>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105399:	85 c0                	test   %eax,%eax
8010539b:	0f 84 62 01 00 00    	je     80105503 <sys_unlink+0x1a3>
  ilock(dp);
801053a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	57                   	push   %edi
801053a8:	e8 23 c7 ff ff       	call   80101ad0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053ad:	58                   	pop    %eax
801053ae:	5a                   	pop    %edx
801053af:	68 14 7c 10 80       	push   $0x80107c14
801053b4:	53                   	push   %ebx
801053b5:	e8 56 cc ff ff       	call   80102010 <namecmp>
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	85 c0                	test   %eax,%eax
801053bf:	0f 84 fb 00 00 00    	je     801054c0 <sys_unlink+0x160>
801053c5:	83 ec 08             	sub    $0x8,%esp
801053c8:	68 13 7c 10 80       	push   $0x80107c13
801053cd:	53                   	push   %ebx
801053ce:	e8 3d cc ff ff       	call   80102010 <namecmp>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	0f 84 e2 00 00 00    	je     801054c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053de:	83 ec 04             	sub    $0x4,%esp
801053e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053e4:	50                   	push   %eax
801053e5:	53                   	push   %ebx
801053e6:	57                   	push   %edi
801053e7:	e8 44 cc ff ff       	call   80102030 <dirlookup>
801053ec:	83 c4 10             	add    $0x10,%esp
801053ef:	89 c3                	mov    %eax,%ebx
801053f1:	85 c0                	test   %eax,%eax
801053f3:	0f 84 c7 00 00 00    	je     801054c0 <sys_unlink+0x160>
  ilock(ip);
801053f9:	83 ec 0c             	sub    $0xc,%esp
801053fc:	50                   	push   %eax
801053fd:	e8 ce c6 ff ff       	call   80101ad0 <ilock>
  if(ip->nlink < 1)
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010540a:	0f 8e 1c 01 00 00    	jle    8010552c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105410:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105415:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105418:	74 66                	je     80105480 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010541a:	83 ec 04             	sub    $0x4,%esp
8010541d:	6a 10                	push   $0x10
8010541f:	6a 00                	push   $0x0
80105421:	57                   	push   %edi
80105422:	e8 89 f5 ff ff       	call   801049b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105427:	6a 10                	push   $0x10
80105429:	ff 75 c4             	push   -0x3c(%ebp)
8010542c:	57                   	push   %edi
8010542d:	ff 75 b4             	push   -0x4c(%ebp)
80105430:	e8 ab ca ff ff       	call   80101ee0 <writei>
80105435:	83 c4 20             	add    $0x20,%esp
80105438:	83 f8 10             	cmp    $0x10,%eax
8010543b:	0f 85 de 00 00 00    	jne    8010551f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105441:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105446:	0f 84 94 00 00 00    	je     801054e0 <sys_unlink+0x180>
  iunlockput(dp);
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	ff 75 b4             	push   -0x4c(%ebp)
80105452:	e8 09 c9 ff ff       	call   80101d60 <iunlockput>
  ip->nlink--;
80105457:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010545c:	89 1c 24             	mov    %ebx,(%esp)
8010545f:	e8 bc c5 ff ff       	call   80101a20 <iupdate>
  iunlockput(ip);
80105464:	89 1c 24             	mov    %ebx,(%esp)
80105467:	e8 f4 c8 ff ff       	call   80101d60 <iunlockput>
  end_op();
8010546c:	e8 af dc ff ff       	call   80103120 <end_op>
  return 0;
80105471:	83 c4 10             	add    $0x10,%esp
80105474:	31 c0                	xor    %eax,%eax
}
80105476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105479:	5b                   	pop    %ebx
8010547a:	5e                   	pop    %esi
8010547b:	5f                   	pop    %edi
8010547c:	5d                   	pop    %ebp
8010547d:	c3                   	ret    
8010547e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105480:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105484:	76 94                	jbe    8010541a <sys_unlink+0xba>
80105486:	be 20 00 00 00       	mov    $0x20,%esi
8010548b:	eb 0b                	jmp    80105498 <sys_unlink+0x138>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
80105490:	83 c6 10             	add    $0x10,%esi
80105493:	3b 73 58             	cmp    0x58(%ebx),%esi
80105496:	73 82                	jae    8010541a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105498:	6a 10                	push   $0x10
8010549a:	56                   	push   %esi
8010549b:	57                   	push   %edi
8010549c:	53                   	push   %ebx
8010549d:	e8 3e c9 ff ff       	call   80101de0 <readi>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	83 f8 10             	cmp    $0x10,%eax
801054a8:	75 68                	jne    80105512 <sys_unlink+0x1b2>
    if(de.inum != 0)
801054aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054af:	74 df                	je     80105490 <sys_unlink+0x130>
    iunlockput(ip);
801054b1:	83 ec 0c             	sub    $0xc,%esp
801054b4:	53                   	push   %ebx
801054b5:	e8 a6 c8 ff ff       	call   80101d60 <iunlockput>
    goto bad;
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	ff 75 b4             	push   -0x4c(%ebp)
801054c6:	e8 95 c8 ff ff       	call   80101d60 <iunlockput>
  end_op();
801054cb:	e8 50 dc ff ff       	call   80103120 <end_op>
  return -1;
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d8:	eb 9c                	jmp    80105476 <sys_unlink+0x116>
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801054e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801054e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801054eb:	50                   	push   %eax
801054ec:	e8 2f c5 ff ff       	call   80101a20 <iupdate>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	e9 53 ff ff ff       	jmp    8010544c <sys_unlink+0xec>
    return -1;
801054f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fe:	e9 73 ff ff ff       	jmp    80105476 <sys_unlink+0x116>
    end_op();
80105503:	e8 18 dc ff ff       	call   80103120 <end_op>
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	e9 64 ff ff ff       	jmp    80105476 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105512:	83 ec 0c             	sub    $0xc,%esp
80105515:	68 38 7c 10 80       	push   $0x80107c38
8010551a:	e8 61 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	68 4a 7c 10 80       	push   $0x80107c4a
80105527:	e8 54 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	68 26 7c 10 80       	push   $0x80107c26
80105534:	e8 47 ae ff ff       	call   80100380 <panic>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_open>:

int
sys_open(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105545:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105548:	53                   	push   %ebx
80105549:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 dc f7 ff ff       	call   80104d30 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 8e 00 00 00    	js     801055ed <sys_open+0xad>
8010555f:	83 ec 08             	sub    $0x8,%esp
80105562:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105565:	50                   	push   %eax
80105566:	6a 01                	push   $0x1
80105568:	e8 03 f7 ff ff       	call   80104c70 <argint>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	78 79                	js     801055ed <sys_open+0xad>
    return -1;

  begin_op();
80105574:	e8 37 db ff ff       	call   801030b0 <begin_op>

  if(omode & O_CREATE){
80105579:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010557d:	75 79                	jne    801055f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010557f:	83 ec 0c             	sub    $0xc,%esp
80105582:	ff 75 e0             	push   -0x20(%ebp)
80105585:	e8 66 ce ff ff       	call   801023f0 <namei>
8010558a:	83 c4 10             	add    $0x10,%esp
8010558d:	89 c6                	mov    %eax,%esi
8010558f:	85 c0                	test   %eax,%eax
80105591:	0f 84 7e 00 00 00    	je     80105615 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	50                   	push   %eax
8010559b:	e8 30 c5 ff ff       	call   80101ad0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a0:	83 c4 10             	add    $0x10,%esp
801055a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055a8:	0f 84 c2 00 00 00    	je     80105670 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055ae:	e8 cd bb ff ff       	call   80101180 <filealloc>
801055b3:	89 c7                	mov    %eax,%edi
801055b5:	85 c0                	test   %eax,%eax
801055b7:	74 23                	je     801055dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801055b9:	e8 02 e7 ff ff       	call   80103cc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801055c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055c4:	85 d2                	test   %edx,%edx
801055c6:	74 60                	je     80105628 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801055c8:	83 c3 01             	add    $0x1,%ebx
801055cb:	83 fb 10             	cmp    $0x10,%ebx
801055ce:	75 f0                	jne    801055c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	57                   	push   %edi
801055d4:	e8 67 bc ff ff       	call   80101240 <fileclose>
801055d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	56                   	push   %esi
801055e0:	e8 7b c7 ff ff       	call   80101d60 <iunlockput>
    end_op();
801055e5:	e8 36 db ff ff       	call   80103120 <end_op>
    return -1;
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055f2:	eb 6d                	jmp    80105661 <sys_open+0x121>
801055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055fe:	31 c9                	xor    %ecx,%ecx
80105600:	ba 02 00 00 00       	mov    $0x2,%edx
80105605:	6a 00                	push   $0x0
80105607:	e8 14 f8 ff ff       	call   80104e20 <create>
    if(ip == 0){
8010560c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010560f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105611:	85 c0                	test   %eax,%eax
80105613:	75 99                	jne    801055ae <sys_open+0x6e>
      end_op();
80105615:	e8 06 db ff ff       	call   80103120 <end_op>
      return -1;
8010561a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010561f:	eb 40                	jmp    80105661 <sys_open+0x121>
80105621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010562b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010562f:	56                   	push   %esi
80105630:	e8 7b c5 ff ff       	call   80101bb0 <iunlock>
  end_op();
80105635:	e8 e6 da ff ff       	call   80103120 <end_op>

  f->type = FD_INODE;
8010563a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105643:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105646:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105649:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010564b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105652:	f7 d0                	not    %eax
80105654:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105657:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010565a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010565d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105661:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105664:	89 d8                	mov    %ebx,%eax
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105670:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105673:	85 c9                	test   %ecx,%ecx
80105675:	0f 84 33 ff ff ff    	je     801055ae <sys_open+0x6e>
8010567b:	e9 5c ff ff ff       	jmp    801055dc <sys_open+0x9c>

80105680 <sys_mkdir>:

int
sys_mkdir(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105686:	e8 25 da ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010568b:	83 ec 08             	sub    $0x8,%esp
8010568e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105691:	50                   	push   %eax
80105692:	6a 00                	push   $0x0
80105694:	e8 97 f6 ff ff       	call   80104d30 <argstr>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	78 30                	js     801056d0 <sys_mkdir+0x50>
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a6:	31 c9                	xor    %ecx,%ecx
801056a8:	ba 01 00 00 00       	mov    $0x1,%edx
801056ad:	6a 00                	push   $0x0
801056af:	e8 6c f7 ff ff       	call   80104e20 <create>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	74 15                	je     801056d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056bb:	83 ec 0c             	sub    $0xc,%esp
801056be:	50                   	push   %eax
801056bf:	e8 9c c6 ff ff       	call   80101d60 <iunlockput>
  end_op();
801056c4:	e8 57 da ff ff       	call   80103120 <end_op>
  return 0;
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	31 c0                	xor    %eax,%eax
}
801056ce:	c9                   	leave  
801056cf:	c3                   	ret    
    end_op();
801056d0:	e8 4b da ff ff       	call   80103120 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_mknod>:

int
sys_mknod(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056e6:	e8 c5 d9 ff ff       	call   801030b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056f1:	50                   	push   %eax
801056f2:	6a 00                	push   $0x0
801056f4:	e8 37 f6 ff ff       	call   80104d30 <argstr>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	85 c0                	test   %eax,%eax
801056fe:	78 60                	js     80105760 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105700:	83 ec 08             	sub    $0x8,%esp
80105703:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105706:	50                   	push   %eax
80105707:	6a 01                	push   $0x1
80105709:	e8 62 f5 ff ff       	call   80104c70 <argint>
  if((argstr(0, &path)) < 0 ||
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	85 c0                	test   %eax,%eax
80105713:	78 4b                	js     80105760 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105715:	83 ec 08             	sub    $0x8,%esp
80105718:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010571b:	50                   	push   %eax
8010571c:	6a 02                	push   $0x2
8010571e:	e8 4d f5 ff ff       	call   80104c70 <argint>
     argint(1, &major) < 0 ||
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	85 c0                	test   %eax,%eax
80105728:	78 36                	js     80105760 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010572a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010572e:	83 ec 0c             	sub    $0xc,%esp
80105731:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105735:	ba 03 00 00 00       	mov    $0x3,%edx
8010573a:	50                   	push   %eax
8010573b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010573e:	e8 dd f6 ff ff       	call   80104e20 <create>
     argint(2, &minor) < 0 ||
80105743:	83 c4 10             	add    $0x10,%esp
80105746:	85 c0                	test   %eax,%eax
80105748:	74 16                	je     80105760 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010574a:	83 ec 0c             	sub    $0xc,%esp
8010574d:	50                   	push   %eax
8010574e:	e8 0d c6 ff ff       	call   80101d60 <iunlockput>
  end_op();
80105753:	e8 c8 d9 ff ff       	call   80103120 <end_op>
  return 0;
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	31 c0                	xor    %eax,%eax
}
8010575d:	c9                   	leave  
8010575e:	c3                   	ret    
8010575f:	90                   	nop
    end_op();
80105760:	e8 bb d9 ff ff       	call   80103120 <end_op>
    return -1;
80105765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010576a:	c9                   	leave  
8010576b:	c3                   	ret    
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_chdir>:

int
sys_chdir(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	56                   	push   %esi
80105774:	53                   	push   %ebx
80105775:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105778:	e8 43 e5 ff ff       	call   80103cc0 <myproc>
8010577d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010577f:	e8 2c d9 ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105784:	83 ec 08             	sub    $0x8,%esp
80105787:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010578a:	50                   	push   %eax
8010578b:	6a 00                	push   $0x0
8010578d:	e8 9e f5 ff ff       	call   80104d30 <argstr>
80105792:	83 c4 10             	add    $0x10,%esp
80105795:	85 c0                	test   %eax,%eax
80105797:	78 77                	js     80105810 <sys_chdir+0xa0>
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	ff 75 f4             	push   -0xc(%ebp)
8010579f:	e8 4c cc ff ff       	call   801023f0 <namei>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	89 c3                	mov    %eax,%ebx
801057a9:	85 c0                	test   %eax,%eax
801057ab:	74 63                	je     80105810 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	50                   	push   %eax
801057b1:	e8 1a c3 ff ff       	call   80101ad0 <ilock>
  if(ip->type != T_DIR){
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057be:	75 30                	jne    801057f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	53                   	push   %ebx
801057c4:	e8 e7 c3 ff ff       	call   80101bb0 <iunlock>
  iput(curproc->cwd);
801057c9:	58                   	pop    %eax
801057ca:	ff 76 68             	push   0x68(%esi)
801057cd:	e8 2e c4 ff ff       	call   80101c00 <iput>
  end_op();
801057d2:	e8 49 d9 ff ff       	call   80103120 <end_op>
  curproc->cwd = ip;
801057d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	31 c0                	xor    %eax,%eax
}
801057df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057e2:	5b                   	pop    %ebx
801057e3:	5e                   	pop    %esi
801057e4:	5d                   	pop    %ebp
801057e5:	c3                   	ret    
801057e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	53                   	push   %ebx
801057f4:	e8 67 c5 ff ff       	call   80101d60 <iunlockput>
    end_op();
801057f9:	e8 22 d9 ff ff       	call   80103120 <end_op>
    return -1;
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105806:	eb d7                	jmp    801057df <sys_chdir+0x6f>
80105808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580f:	90                   	nop
    end_op();
80105810:	e8 0b d9 ff ff       	call   80103120 <end_op>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581a:	eb c3                	jmp    801057df <sys_chdir+0x6f>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_exec>:

int
sys_exec(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105825:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010582b:	53                   	push   %ebx
8010582c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105832:	50                   	push   %eax
80105833:	6a 00                	push   $0x0
80105835:	e8 f6 f4 ff ff       	call   80104d30 <argstr>
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	85 c0                	test   %eax,%eax
8010583f:	0f 88 87 00 00 00    	js     801058cc <sys_exec+0xac>
80105845:	83 ec 08             	sub    $0x8,%esp
80105848:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010584e:	50                   	push   %eax
8010584f:	6a 01                	push   $0x1
80105851:	e8 1a f4 ff ff       	call   80104c70 <argint>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	78 6f                	js     801058cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010585d:	83 ec 04             	sub    $0x4,%esp
80105860:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105866:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105868:	68 80 00 00 00       	push   $0x80
8010586d:	6a 00                	push   $0x0
8010586f:	56                   	push   %esi
80105870:	e8 3b f1 ff ff       	call   801049b0 <memset>
80105875:	83 c4 10             	add    $0x10,%esp
80105878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105889:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105890:	50                   	push   %eax
80105891:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105897:	01 f8                	add    %edi,%eax
80105899:	50                   	push   %eax
8010589a:	e8 41 f3 ff ff       	call   80104be0 <fetchint>
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	85 c0                	test   %eax,%eax
801058a4:	78 26                	js     801058cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058ac:	85 c0                	test   %eax,%eax
801058ae:	74 30                	je     801058e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058b0:	83 ec 08             	sub    $0x8,%esp
801058b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801058b6:	52                   	push   %edx
801058b7:	50                   	push   %eax
801058b8:	e8 63 f3 ff ff       	call   80104c20 <fetchstr>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 08                	js     801058cc <sys_exec+0xac>
  for(i=0;; i++){
801058c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058c7:	83 fb 20             	cmp    $0x20,%ebx
801058ca:	75 b4                	jne    80105880 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d4:	5b                   	pop    %ebx
801058d5:	5e                   	pop    %esi
801058d6:	5f                   	pop    %edi
801058d7:	5d                   	pop    %ebp
801058d8:	c3                   	ret    
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801058e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058e7:	00 00 00 00 
  return exec(path, argv);
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	56                   	push   %esi
801058ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058f5:	e8 06 b5 ff ff       	call   80100e00 <exec>
801058fa:	83 c4 10             	add    $0x10,%esp
}
801058fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105900:	5b                   	pop    %ebx
80105901:	5e                   	pop    %esi
80105902:	5f                   	pop    %edi
80105903:	5d                   	pop    %ebp
80105904:	c3                   	ret    
80105905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_pipe>:

int
sys_pipe(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105915:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105918:	53                   	push   %ebx
80105919:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010591c:	6a 08                	push   $0x8
8010591e:	50                   	push   %eax
8010591f:	6a 00                	push   $0x0
80105921:	e8 9a f3 ff ff       	call   80104cc0 <argptr>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	85 c0                	test   %eax,%eax
8010592b:	78 4a                	js     80105977 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010592d:	83 ec 08             	sub    $0x8,%esp
80105930:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105933:	50                   	push   %eax
80105934:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	e8 43 de ff ff       	call   80103780 <pipealloc>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 33                	js     80105977 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105944:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105947:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105949:	e8 72 e3 ff ff       	call   80103cc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010594e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105950:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105954:	85 f6                	test   %esi,%esi
80105956:	74 28                	je     80105980 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105958:	83 c3 01             	add    $0x1,%ebx
8010595b:	83 fb 10             	cmp    $0x10,%ebx
8010595e:	75 f0                	jne    80105950 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	ff 75 e0             	push   -0x20(%ebp)
80105966:	e8 d5 b8 ff ff       	call   80101240 <fileclose>
    fileclose(wf);
8010596b:	58                   	pop    %eax
8010596c:	ff 75 e4             	push   -0x1c(%ebp)
8010596f:	e8 cc b8 ff ff       	call   80101240 <fileclose>
    return -1;
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597c:	eb 53                	jmp    801059d1 <sys_pipe+0xc1>
8010597e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105980:	8d 73 08             	lea    0x8(%ebx),%esi
80105983:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010598a:	e8 31 e3 ff ff       	call   80103cc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010598f:	31 d2                	xor    %edx,%edx
80105991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105998:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010599c:	85 c9                	test   %ecx,%ecx
8010599e:	74 20                	je     801059c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801059a0:	83 c2 01             	add    $0x1,%edx
801059a3:	83 fa 10             	cmp    $0x10,%edx
801059a6:	75 f0                	jne    80105998 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801059a8:	e8 13 e3 ff ff       	call   80103cc0 <myproc>
801059ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059b4:	00 
801059b5:	eb a9                	jmp    80105960 <sys_pipe+0x50>
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801059c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059cf:	31 c0                	xor    %eax,%eax
}
801059d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    
801059d9:	66 90                	xchg   %ax,%ax
801059db:	66 90                	xchg   %ax,%ax
801059dd:	66 90                	xchg   %ax,%ax
801059df:	90                   	nop

801059e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801059e0:	e9 7b e4 ff ff       	jmp    80103e60 <fork>
801059e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exit>:
}

int
sys_exit(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059f6:	e8 e5 e6 ff ff       	call   801040e0 <exit>
  return 0;  // not reached
}
801059fb:	31 c0                	xor    %eax,%eax
801059fd:	c9                   	leave  
801059fe:	c3                   	ret    
801059ff:	90                   	nop

80105a00 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a00:	e9 0b e8 ff ff       	jmp    80104210 <wait>
80105a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_kill>:
}

int
sys_kill(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a19:	50                   	push   %eax
80105a1a:	6a 00                	push   $0x0
80105a1c:	e8 4f f2 ff ff       	call   80104c70 <argint>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	85 c0                	test   %eax,%eax
80105a26:	78 18                	js     80105a40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	ff 75 f4             	push   -0xc(%ebp)
80105a2e:	e8 7d ea ff ff       	call   801044b0 <kill>
80105a33:	83 c4 10             	add    $0x10,%esp
}
80105a36:	c9                   	leave  
80105a37:	c3                   	ret    
80105a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop
80105a40:	c9                   	leave  
    return -1;
80105a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a46:	c3                   	ret    
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_getpid>:

int
sys_getpid(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a56:	e8 65 e2 ff ff       	call   80103cc0 <myproc>
80105a5b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a6a:	50                   	push   %eax
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 fe f1 ff ff       	call   80104c70 <argint>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	78 27                	js     80105aa0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a79:	e8 42 e2 ff ff       	call   80103cc0 <myproc>
  if(growproc(n) < 0)
80105a7e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a81:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a83:	ff 75 f4             	push   -0xc(%ebp)
80105a86:	e8 55 e3 ff ff       	call   80103de0 <growproc>
80105a8b:	83 c4 10             	add    $0x10,%esp
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	78 0e                	js     80105aa0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a92:	89 d8                	mov    %ebx,%eax
80105a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a97:	c9                   	leave  
80105a98:	c3                   	ret    
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105aa0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aa5:	eb eb                	jmp    80105a92 <sys_sbrk+0x32>
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_sleep>:

int
sys_sleep(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ab7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aba:	50                   	push   %eax
80105abb:	6a 00                	push   $0x0
80105abd:	e8 ae f1 ff ff       	call   80104c70 <argint>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	0f 88 8a 00 00 00    	js     80105b57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 a0 41 11 80       	push   $0x801141a0
80105ad5:	e8 16 ee ff ff       	call   801048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105add:	8b 1d 80 41 11 80    	mov    0x80114180,%ebx
  while(ticks - ticks0 < n){
80105ae3:	83 c4 10             	add    $0x10,%esp
80105ae6:	85 d2                	test   %edx,%edx
80105ae8:	75 27                	jne    80105b11 <sys_sleep+0x61>
80105aea:	eb 54                	jmp    80105b40 <sys_sleep+0x90>
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	68 a0 41 11 80       	push   $0x801141a0
80105af8:	68 80 41 11 80       	push   $0x80114180
80105afd:	e8 8e e8 ff ff       	call   80104390 <sleep>
  while(ticks - ticks0 < n){
80105b02:	a1 80 41 11 80       	mov    0x80114180,%eax
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	29 d8                	sub    %ebx,%eax
80105b0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b0f:	73 2f                	jae    80105b40 <sys_sleep+0x90>
    if(myproc()->killed){
80105b11:	e8 aa e1 ff ff       	call   80103cc0 <myproc>
80105b16:	8b 40 24             	mov    0x24(%eax),%eax
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	74 d3                	je     80105af0 <sys_sleep+0x40>
      release(&tickslock);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	68 a0 41 11 80       	push   $0x801141a0
80105b25:	e8 66 ed ff ff       	call   80104890 <release>
  }
  release(&tickslock);
  return 0;
}
80105b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	68 a0 41 11 80       	push   $0x801141a0
80105b48:	e8 43 ed ff ff       	call   80104890 <release>
  return 0;
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	31 c0                	xor    %eax,%eax
}
80105b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
    return -1;
80105b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5c:	eb f4                	jmp    80105b52 <sys_sleep+0xa2>
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
80105b64:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b67:	68 a0 41 11 80       	push   $0x801141a0
80105b6c:	e8 7f ed ff ff       	call   801048f0 <acquire>
  xticks = ticks;
80105b71:	8b 1d 80 41 11 80    	mov    0x80114180,%ebx
  release(&tickslock);
80105b77:	c7 04 24 a0 41 11 80 	movl   $0x801141a0,(%esp)
80105b7e:	e8 0d ed ff ff       	call   80104890 <release>
  return xticks;
}
80105b83:	89 d8                	mov    %ebx,%eax
80105b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b88:	c9                   	leave  
80105b89:	c3                   	ret    

80105b8a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b8a:	1e                   	push   %ds
  pushl %es
80105b8b:	06                   	push   %es
  pushl %fs
80105b8c:	0f a0                	push   %fs
  pushl %gs
80105b8e:	0f a8                	push   %gs
  pushal
80105b90:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b91:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b95:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b97:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b99:	54                   	push   %esp
  call trap
80105b9a:	e8 c1 00 00 00       	call   80105c60 <trap>
  addl $4, %esp
80105b9f:	83 c4 04             	add    $0x4,%esp

80105ba2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ba2:	61                   	popa   
  popl %gs
80105ba3:	0f a9                	pop    %gs
  popl %fs
80105ba5:	0f a1                	pop    %fs
  popl %es
80105ba7:	07                   	pop    %es
  popl %ds
80105ba8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ba9:	83 c4 08             	add    $0x8,%esp
  iret
80105bac:	cf                   	iret   
80105bad:	66 90                	xchg   %ax,%ax
80105baf:	90                   	nop

80105bb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bb1:	31 c0                	xor    %eax,%eax
{
80105bb3:	89 e5                	mov    %esp,%ebp
80105bb5:	83 ec 08             	sub    $0x8,%esp
80105bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bc0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bc7:	c7 04 c5 e2 41 11 80 	movl   $0x8e000008,-0x7feebe1e(,%eax,8)
80105bce:	08 00 00 8e 
80105bd2:	66 89 14 c5 e0 41 11 	mov    %dx,-0x7feebe20(,%eax,8)
80105bd9:	80 
80105bda:	c1 ea 10             	shr    $0x10,%edx
80105bdd:	66 89 14 c5 e6 41 11 	mov    %dx,-0x7feebe1a(,%eax,8)
80105be4:	80 
  for(i = 0; i < 256; i++)
80105be5:	83 c0 01             	add    $0x1,%eax
80105be8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bed:	75 d1                	jne    80105bc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bf2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105bf7:	c7 05 e2 43 11 80 08 	movl   $0xef000008,0x801143e2
80105bfe:	00 00 ef 
  initlock(&tickslock, "time");
80105c01:	68 59 7c 10 80       	push   $0x80107c59
80105c06:	68 a0 41 11 80       	push   $0x801141a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c0b:	66 a3 e0 43 11 80    	mov    %ax,0x801143e0
80105c11:	c1 e8 10             	shr    $0x10,%eax
80105c14:	66 a3 e6 43 11 80    	mov    %ax,0x801143e6
  initlock(&tickslock, "time");
80105c1a:	e8 01 eb ff ff       	call   80104720 <initlock>
}
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	c9                   	leave  
80105c23:	c3                   	ret    
80105c24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop

80105c30 <idtinit>:

void
idtinit(void)
{
80105c30:	55                   	push   %ebp
  pd[0] = size-1;
80105c31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c36:	89 e5                	mov    %esp,%ebp
80105c38:	83 ec 10             	sub    $0x10,%esp
80105c3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c3f:	b8 e0 41 11 80       	mov    $0x801141e0,%eax
80105c44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c48:	c1 e8 10             	shr    $0x10,%eax
80105c4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	83 ec 1c             	sub    $0x1c,%esp
80105c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c6f:	83 f8 40             	cmp    $0x40,%eax
80105c72:	0f 84 68 01 00 00    	je     80105de0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c78:	83 e8 20             	sub    $0x20,%eax
80105c7b:	83 f8 1f             	cmp    $0x1f,%eax
80105c7e:	0f 87 8c 00 00 00    	ja     80105d10 <trap+0xb0>
80105c84:	ff 24 85 00 7d 10 80 	jmp    *-0x7fef8300(,%eax,4)
80105c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c90:	e8 fb c8 ff ff       	call   80102590 <ideintr>
    lapiceoi();
80105c95:	e8 c6 cf ff ff       	call   80102c60 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9a:	e8 21 e0 ff ff       	call   80103cc0 <myproc>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	74 1d                	je     80105cc0 <trap+0x60>
80105ca3:	e8 18 e0 ff ff       	call   80103cc0 <myproc>
80105ca8:	8b 50 24             	mov    0x24(%eax),%edx
80105cab:	85 d2                	test   %edx,%edx
80105cad:	74 11                	je     80105cc0 <trap+0x60>
80105caf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cb3:	83 e0 03             	and    $0x3,%eax
80105cb6:	66 83 f8 03          	cmp    $0x3,%ax
80105cba:	0f 84 e8 01 00 00    	je     80105ea8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cc0:	e8 fb df ff ff       	call   80103cc0 <myproc>
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	74 0f                	je     80105cd8 <trap+0x78>
80105cc9:	e8 f2 df ff ff       	call   80103cc0 <myproc>
80105cce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cd2:	0f 84 b8 00 00 00    	je     80105d90 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cd8:	e8 e3 df ff ff       	call   80103cc0 <myproc>
80105cdd:	85 c0                	test   %eax,%eax
80105cdf:	74 1d                	je     80105cfe <trap+0x9e>
80105ce1:	e8 da df ff ff       	call   80103cc0 <myproc>
80105ce6:	8b 40 24             	mov    0x24(%eax),%eax
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	74 11                	je     80105cfe <trap+0x9e>
80105ced:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cf1:	83 e0 03             	and    $0x3,%eax
80105cf4:	66 83 f8 03          	cmp    $0x3,%ax
80105cf8:	0f 84 0f 01 00 00    	je     80105e0d <trap+0x1ad>
    exit();
}
80105cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d01:	5b                   	pop    %ebx
80105d02:	5e                   	pop    %esi
80105d03:	5f                   	pop    %edi
80105d04:	5d                   	pop    %ebp
80105d05:	c3                   	ret    
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d10:	e8 ab df ff ff       	call   80103cc0 <myproc>
80105d15:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d18:	85 c0                	test   %eax,%eax
80105d1a:	0f 84 a2 01 00 00    	je     80105ec2 <trap+0x262>
80105d20:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d24:	0f 84 98 01 00 00    	je     80105ec2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d2a:	0f 20 d1             	mov    %cr2,%ecx
80105d2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d30:	e8 6b df ff ff       	call   80103ca0 <cpuid>
80105d35:	8b 73 30             	mov    0x30(%ebx),%esi
80105d38:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d3b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d41:	e8 7a df ff ff       	call   80103cc0 <myproc>
80105d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d49:	e8 72 df ff ff       	call   80103cc0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d54:	51                   	push   %ecx
80105d55:	57                   	push   %edi
80105d56:	52                   	push   %edx
80105d57:	ff 75 e4             	push   -0x1c(%ebp)
80105d5a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d5b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d5e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d61:	56                   	push   %esi
80105d62:	ff 70 10             	push   0x10(%eax)
80105d65:	68 bc 7c 10 80       	push   $0x80107cbc
80105d6a:	e8 41 aa ff ff       	call   801007b0 <cprintf>
    myproc()->killed = 1;
80105d6f:	83 c4 20             	add    $0x20,%esp
80105d72:	e8 49 df ff ff       	call   80103cc0 <myproc>
80105d77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d7e:	e8 3d df ff ff       	call   80103cc0 <myproc>
80105d83:	85 c0                	test   %eax,%eax
80105d85:	0f 85 18 ff ff ff    	jne    80105ca3 <trap+0x43>
80105d8b:	e9 30 ff ff ff       	jmp    80105cc0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105d90:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d94:	0f 85 3e ff ff ff    	jne    80105cd8 <trap+0x78>
    yield();
80105d9a:	e8 a1 e5 ff ff       	call   80104340 <yield>
80105d9f:	e9 34 ff ff ff       	jmp    80105cd8 <trap+0x78>
80105da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105da8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105daf:	e8 ec de ff ff       	call   80103ca0 <cpuid>
80105db4:	57                   	push   %edi
80105db5:	56                   	push   %esi
80105db6:	50                   	push   %eax
80105db7:	68 64 7c 10 80       	push   $0x80107c64
80105dbc:	e8 ef a9 ff ff       	call   801007b0 <cprintf>
    lapiceoi();
80105dc1:	e8 9a ce ff ff       	call   80102c60 <lapiceoi>
    break;
80105dc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dc9:	e8 f2 de ff ff       	call   80103cc0 <myproc>
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	0f 85 cd fe ff ff    	jne    80105ca3 <trap+0x43>
80105dd6:	e9 e5 fe ff ff       	jmp    80105cc0 <trap+0x60>
80105ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop
    if(myproc()->killed)
80105de0:	e8 db de ff ff       	call   80103cc0 <myproc>
80105de5:	8b 70 24             	mov    0x24(%eax),%esi
80105de8:	85 f6                	test   %esi,%esi
80105dea:	0f 85 c8 00 00 00    	jne    80105eb8 <trap+0x258>
    myproc()->tf = tf;
80105df0:	e8 cb de ff ff       	call   80103cc0 <myproc>
80105df5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105df8:	e8 b3 ef ff ff       	call   80104db0 <syscall>
    if(myproc()->killed)
80105dfd:	e8 be de ff ff       	call   80103cc0 <myproc>
80105e02:	8b 48 24             	mov    0x24(%eax),%ecx
80105e05:	85 c9                	test   %ecx,%ecx
80105e07:	0f 84 f1 fe ff ff    	je     80105cfe <trap+0x9e>
}
80105e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e10:	5b                   	pop    %ebx
80105e11:	5e                   	pop    %esi
80105e12:	5f                   	pop    %edi
80105e13:	5d                   	pop    %ebp
      exit();
80105e14:	e9 c7 e2 ff ff       	jmp    801040e0 <exit>
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e20:	e8 3b 02 00 00       	call   80106060 <uartintr>
    lapiceoi();
80105e25:	e8 36 ce ff ff       	call   80102c60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2a:	e8 91 de ff ff       	call   80103cc0 <myproc>
80105e2f:	85 c0                	test   %eax,%eax
80105e31:	0f 85 6c fe ff ff    	jne    80105ca3 <trap+0x43>
80105e37:	e9 84 fe ff ff       	jmp    80105cc0 <trap+0x60>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e40:	e8 db cc ff ff       	call   80102b20 <kbdintr>
    lapiceoi();
80105e45:	e8 16 ce ff ff       	call   80102c60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e4a:	e8 71 de ff ff       	call   80103cc0 <myproc>
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	0f 85 4c fe ff ff    	jne    80105ca3 <trap+0x43>
80105e57:	e9 64 fe ff ff       	jmp    80105cc0 <trap+0x60>
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105e60:	e8 3b de ff ff       	call   80103ca0 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 85 28 fe ff ff    	jne    80105c95 <trap+0x35>
      acquire(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 a0 41 11 80       	push   $0x801141a0
80105e75:	e8 76 ea ff ff       	call   801048f0 <acquire>
      wakeup(&ticks);
80105e7a:	c7 04 24 80 41 11 80 	movl   $0x80114180,(%esp)
      ticks++;
80105e81:	83 05 80 41 11 80 01 	addl   $0x1,0x80114180
      wakeup(&ticks);
80105e88:	e8 c3 e5 ff ff       	call   80104450 <wakeup>
      release(&tickslock);
80105e8d:	c7 04 24 a0 41 11 80 	movl   $0x801141a0,(%esp)
80105e94:	e8 f7 e9 ff ff       	call   80104890 <release>
80105e99:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e9c:	e9 f4 fd ff ff       	jmp    80105c95 <trap+0x35>
80105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ea8:	e8 33 e2 ff ff       	call   801040e0 <exit>
80105ead:	e9 0e fe ff ff       	jmp    80105cc0 <trap+0x60>
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105eb8:	e8 23 e2 ff ff       	call   801040e0 <exit>
80105ebd:	e9 2e ff ff ff       	jmp    80105df0 <trap+0x190>
80105ec2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ec5:	e8 d6 dd ff ff       	call   80103ca0 <cpuid>
80105eca:	83 ec 0c             	sub    $0xc,%esp
80105ecd:	56                   	push   %esi
80105ece:	57                   	push   %edi
80105ecf:	50                   	push   %eax
80105ed0:	ff 73 30             	push   0x30(%ebx)
80105ed3:	68 88 7c 10 80       	push   $0x80107c88
80105ed8:	e8 d3 a8 ff ff       	call   801007b0 <cprintf>
      panic("trap");
80105edd:	83 c4 14             	add    $0x14,%esp
80105ee0:	68 5e 7c 10 80       	push   $0x80107c5e
80105ee5:	e8 96 a4 ff ff       	call   80100380 <panic>
80105eea:	66 90                	xchg   %ax,%ax
80105eec:	66 90                	xchg   %ax,%ax
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ef0:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 17                	je     80105f10 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ef9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105efe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eff:	a8 01                	test   $0x1,%al
80105f01:	74 0d                	je     80105f10 <uartgetc+0x20>
80105f03:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f09:	0f b6 c0             	movzbl %al,%eax
80105f0c:	c3                   	ret    
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f15:	c3                   	ret    
80105f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1d:	8d 76 00             	lea    0x0(%esi),%esi

80105f20 <uartinit>:
{
80105f20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f21:	31 c9                	xor    %ecx,%ecx
80105f23:	89 c8                	mov    %ecx,%eax
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	57                   	push   %edi
80105f28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f2d:	56                   	push   %esi
80105f2e:	89 fa                	mov    %edi,%edx
80105f30:	53                   	push   %ebx
80105f31:	83 ec 1c             	sub    $0x1c,%esp
80105f34:	ee                   	out    %al,(%dx)
80105f35:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f3f:	89 f2                	mov    %esi,%edx
80105f41:	ee                   	out    %al,(%dx)
80105f42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4c:	ee                   	out    %al,(%dx)
80105f4d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f52:	89 c8                	mov    %ecx,%eax
80105f54:	89 da                	mov    %ebx,%edx
80105f56:	ee                   	out    %al,(%dx)
80105f57:	b8 03 00 00 00       	mov    $0x3,%eax
80105f5c:	89 f2                	mov    %esi,%edx
80105f5e:	ee                   	out    %al,(%dx)
80105f5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f64:	89 c8                	mov    %ecx,%eax
80105f66:	ee                   	out    %al,(%dx)
80105f67:	b8 01 00 00 00       	mov    $0x1,%eax
80105f6c:	89 da                	mov    %ebx,%edx
80105f6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f75:	3c ff                	cmp    $0xff,%al
80105f77:	74 78                	je     80105ff1 <uartinit+0xd1>
  uart = 1;
80105f79:	c7 05 e0 49 11 80 01 	movl   $0x1,0x801149e0
80105f80:	00 00 00 
80105f83:	89 fa                	mov    %edi,%edx
80105f85:	ec                   	in     (%dx),%al
80105f86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f8c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f8f:	bf 80 7d 10 80       	mov    $0x80107d80,%edi
80105f94:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f99:	6a 00                	push   $0x0
80105f9b:	6a 04                	push   $0x4
80105f9d:	e8 2e c8 ff ff       	call   801027d0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105fa2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105fa6:	83 c4 10             	add    $0x10,%esp
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105fb0:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80105fb5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fba:	85 c0                	test   %eax,%eax
80105fbc:	75 14                	jne    80105fd2 <uartinit+0xb2>
80105fbe:	eb 23                	jmp    80105fe3 <uartinit+0xc3>
    microdelay(10);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	6a 0a                	push   $0xa
80105fc5:	e8 b6 cc ff ff       	call   80102c80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	83 eb 01             	sub    $0x1,%ebx
80105fd0:	74 07                	je     80105fd9 <uartinit+0xb9>
80105fd2:	89 f2                	mov    %esi,%edx
80105fd4:	ec                   	in     (%dx),%al
80105fd5:	a8 20                	test   $0x20,%al
80105fd7:	74 e7                	je     80105fc0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fd9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105fdd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fe2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105fe3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105fe7:	83 c7 01             	add    $0x1,%edi
80105fea:	88 45 e7             	mov    %al,-0x19(%ebp)
80105fed:	84 c0                	test   %al,%al
80105fef:	75 bf                	jne    80105fb0 <uartinit+0x90>
}
80105ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff4:	5b                   	pop    %ebx
80105ff5:	5e                   	pop    %esi
80105ff6:	5f                   	pop    %edi
80105ff7:	5d                   	pop    %ebp
80105ff8:	c3                   	ret    
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <uartputc>:
  if(!uart)
80106000:	a1 e0 49 11 80       	mov    0x801149e0,%eax
80106005:	85 c0                	test   %eax,%eax
80106007:	74 47                	je     80106050 <uartputc+0x50>
{
80106009:	55                   	push   %ebp
8010600a:	89 e5                	mov    %esp,%ebp
8010600c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010600d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106012:	53                   	push   %ebx
80106013:	bb 80 00 00 00       	mov    $0x80,%ebx
80106018:	eb 18                	jmp    80106032 <uartputc+0x32>
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	6a 0a                	push   $0xa
80106025:	e8 56 cc ff ff       	call   80102c80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	83 eb 01             	sub    $0x1,%ebx
80106030:	74 07                	je     80106039 <uartputc+0x39>
80106032:	89 f2                	mov    %esi,%edx
80106034:	ec                   	in     (%dx),%al
80106035:	a8 20                	test   $0x20,%al
80106037:	74 e7                	je     80106020 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106039:	8b 45 08             	mov    0x8(%ebp),%eax
8010603c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106041:	ee                   	out    %al,(%dx)
}
80106042:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106045:	5b                   	pop    %ebx
80106046:	5e                   	pop    %esi
80106047:	5d                   	pop    %ebp
80106048:	c3                   	ret    
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106050:	c3                   	ret    
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop

80106060 <uartintr>:

void
uartintr(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106066:	68 f0 5e 10 80       	push   $0x80105ef0
8010606b:	e8 e0 a9 ff ff       	call   80100a50 <consoleintr>
}
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	c9                   	leave  
80106074:	c3                   	ret    

80106075 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $0
80106077:	6a 00                	push   $0x0
  jmp alltraps
80106079:	e9 0c fb ff ff       	jmp    80105b8a <alltraps>

8010607e <vector1>:
.globl vector1
vector1:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $1
80106080:	6a 01                	push   $0x1
  jmp alltraps
80106082:	e9 03 fb ff ff       	jmp    80105b8a <alltraps>

80106087 <vector2>:
.globl vector2
vector2:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $2
80106089:	6a 02                	push   $0x2
  jmp alltraps
8010608b:	e9 fa fa ff ff       	jmp    80105b8a <alltraps>

80106090 <vector3>:
.globl vector3
vector3:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $3
80106092:	6a 03                	push   $0x3
  jmp alltraps
80106094:	e9 f1 fa ff ff       	jmp    80105b8a <alltraps>

80106099 <vector4>:
.globl vector4
vector4:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $4
8010609b:	6a 04                	push   $0x4
  jmp alltraps
8010609d:	e9 e8 fa ff ff       	jmp    80105b8a <alltraps>

801060a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $5
801060a4:	6a 05                	push   $0x5
  jmp alltraps
801060a6:	e9 df fa ff ff       	jmp    80105b8a <alltraps>

801060ab <vector6>:
.globl vector6
vector6:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $6
801060ad:	6a 06                	push   $0x6
  jmp alltraps
801060af:	e9 d6 fa ff ff       	jmp    80105b8a <alltraps>

801060b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $7
801060b6:	6a 07                	push   $0x7
  jmp alltraps
801060b8:	e9 cd fa ff ff       	jmp    80105b8a <alltraps>

801060bd <vector8>:
.globl vector8
vector8:
  pushl $8
801060bd:	6a 08                	push   $0x8
  jmp alltraps
801060bf:	e9 c6 fa ff ff       	jmp    80105b8a <alltraps>

801060c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $9
801060c6:	6a 09                	push   $0x9
  jmp alltraps
801060c8:	e9 bd fa ff ff       	jmp    80105b8a <alltraps>

801060cd <vector10>:
.globl vector10
vector10:
  pushl $10
801060cd:	6a 0a                	push   $0xa
  jmp alltraps
801060cf:	e9 b6 fa ff ff       	jmp    80105b8a <alltraps>

801060d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060d4:	6a 0b                	push   $0xb
  jmp alltraps
801060d6:	e9 af fa ff ff       	jmp    80105b8a <alltraps>

801060db <vector12>:
.globl vector12
vector12:
  pushl $12
801060db:	6a 0c                	push   $0xc
  jmp alltraps
801060dd:	e9 a8 fa ff ff       	jmp    80105b8a <alltraps>

801060e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060e2:	6a 0d                	push   $0xd
  jmp alltraps
801060e4:	e9 a1 fa ff ff       	jmp    80105b8a <alltraps>

801060e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060e9:	6a 0e                	push   $0xe
  jmp alltraps
801060eb:	e9 9a fa ff ff       	jmp    80105b8a <alltraps>

801060f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $15
801060f2:	6a 0f                	push   $0xf
  jmp alltraps
801060f4:	e9 91 fa ff ff       	jmp    80105b8a <alltraps>

801060f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $16
801060fb:	6a 10                	push   $0x10
  jmp alltraps
801060fd:	e9 88 fa ff ff       	jmp    80105b8a <alltraps>

80106102 <vector17>:
.globl vector17
vector17:
  pushl $17
80106102:	6a 11                	push   $0x11
  jmp alltraps
80106104:	e9 81 fa ff ff       	jmp    80105b8a <alltraps>

80106109 <vector18>:
.globl vector18
vector18:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $18
8010610b:	6a 12                	push   $0x12
  jmp alltraps
8010610d:	e9 78 fa ff ff       	jmp    80105b8a <alltraps>

80106112 <vector19>:
.globl vector19
vector19:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $19
80106114:	6a 13                	push   $0x13
  jmp alltraps
80106116:	e9 6f fa ff ff       	jmp    80105b8a <alltraps>

8010611b <vector20>:
.globl vector20
vector20:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $20
8010611d:	6a 14                	push   $0x14
  jmp alltraps
8010611f:	e9 66 fa ff ff       	jmp    80105b8a <alltraps>

80106124 <vector21>:
.globl vector21
vector21:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $21
80106126:	6a 15                	push   $0x15
  jmp alltraps
80106128:	e9 5d fa ff ff       	jmp    80105b8a <alltraps>

8010612d <vector22>:
.globl vector22
vector22:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $22
8010612f:	6a 16                	push   $0x16
  jmp alltraps
80106131:	e9 54 fa ff ff       	jmp    80105b8a <alltraps>

80106136 <vector23>:
.globl vector23
vector23:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $23
80106138:	6a 17                	push   $0x17
  jmp alltraps
8010613a:	e9 4b fa ff ff       	jmp    80105b8a <alltraps>

8010613f <vector24>:
.globl vector24
vector24:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $24
80106141:	6a 18                	push   $0x18
  jmp alltraps
80106143:	e9 42 fa ff ff       	jmp    80105b8a <alltraps>

80106148 <vector25>:
.globl vector25
vector25:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $25
8010614a:	6a 19                	push   $0x19
  jmp alltraps
8010614c:	e9 39 fa ff ff       	jmp    80105b8a <alltraps>

80106151 <vector26>:
.globl vector26
vector26:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $26
80106153:	6a 1a                	push   $0x1a
  jmp alltraps
80106155:	e9 30 fa ff ff       	jmp    80105b8a <alltraps>

8010615a <vector27>:
.globl vector27
vector27:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $27
8010615c:	6a 1b                	push   $0x1b
  jmp alltraps
8010615e:	e9 27 fa ff ff       	jmp    80105b8a <alltraps>

80106163 <vector28>:
.globl vector28
vector28:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $28
80106165:	6a 1c                	push   $0x1c
  jmp alltraps
80106167:	e9 1e fa ff ff       	jmp    80105b8a <alltraps>

8010616c <vector29>:
.globl vector29
vector29:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $29
8010616e:	6a 1d                	push   $0x1d
  jmp alltraps
80106170:	e9 15 fa ff ff       	jmp    80105b8a <alltraps>

80106175 <vector30>:
.globl vector30
vector30:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $30
80106177:	6a 1e                	push   $0x1e
  jmp alltraps
80106179:	e9 0c fa ff ff       	jmp    80105b8a <alltraps>

8010617e <vector31>:
.globl vector31
vector31:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $31
80106180:	6a 1f                	push   $0x1f
  jmp alltraps
80106182:	e9 03 fa ff ff       	jmp    80105b8a <alltraps>

80106187 <vector32>:
.globl vector32
vector32:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $32
80106189:	6a 20                	push   $0x20
  jmp alltraps
8010618b:	e9 fa f9 ff ff       	jmp    80105b8a <alltraps>

80106190 <vector33>:
.globl vector33
vector33:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $33
80106192:	6a 21                	push   $0x21
  jmp alltraps
80106194:	e9 f1 f9 ff ff       	jmp    80105b8a <alltraps>

80106199 <vector34>:
.globl vector34
vector34:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $34
8010619b:	6a 22                	push   $0x22
  jmp alltraps
8010619d:	e9 e8 f9 ff ff       	jmp    80105b8a <alltraps>

801061a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $35
801061a4:	6a 23                	push   $0x23
  jmp alltraps
801061a6:	e9 df f9 ff ff       	jmp    80105b8a <alltraps>

801061ab <vector36>:
.globl vector36
vector36:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $36
801061ad:	6a 24                	push   $0x24
  jmp alltraps
801061af:	e9 d6 f9 ff ff       	jmp    80105b8a <alltraps>

801061b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $37
801061b6:	6a 25                	push   $0x25
  jmp alltraps
801061b8:	e9 cd f9 ff ff       	jmp    80105b8a <alltraps>

801061bd <vector38>:
.globl vector38
vector38:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $38
801061bf:	6a 26                	push   $0x26
  jmp alltraps
801061c1:	e9 c4 f9 ff ff       	jmp    80105b8a <alltraps>

801061c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $39
801061c8:	6a 27                	push   $0x27
  jmp alltraps
801061ca:	e9 bb f9 ff ff       	jmp    80105b8a <alltraps>

801061cf <vector40>:
.globl vector40
vector40:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $40
801061d1:	6a 28                	push   $0x28
  jmp alltraps
801061d3:	e9 b2 f9 ff ff       	jmp    80105b8a <alltraps>

801061d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $41
801061da:	6a 29                	push   $0x29
  jmp alltraps
801061dc:	e9 a9 f9 ff ff       	jmp    80105b8a <alltraps>

801061e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $42
801061e3:	6a 2a                	push   $0x2a
  jmp alltraps
801061e5:	e9 a0 f9 ff ff       	jmp    80105b8a <alltraps>

801061ea <vector43>:
.globl vector43
vector43:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $43
801061ec:	6a 2b                	push   $0x2b
  jmp alltraps
801061ee:	e9 97 f9 ff ff       	jmp    80105b8a <alltraps>

801061f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $44
801061f5:	6a 2c                	push   $0x2c
  jmp alltraps
801061f7:	e9 8e f9 ff ff       	jmp    80105b8a <alltraps>

801061fc <vector45>:
.globl vector45
vector45:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $45
801061fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106200:	e9 85 f9 ff ff       	jmp    80105b8a <alltraps>

80106205 <vector46>:
.globl vector46
vector46:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $46
80106207:	6a 2e                	push   $0x2e
  jmp alltraps
80106209:	e9 7c f9 ff ff       	jmp    80105b8a <alltraps>

8010620e <vector47>:
.globl vector47
vector47:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $47
80106210:	6a 2f                	push   $0x2f
  jmp alltraps
80106212:	e9 73 f9 ff ff       	jmp    80105b8a <alltraps>

80106217 <vector48>:
.globl vector48
vector48:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $48
80106219:	6a 30                	push   $0x30
  jmp alltraps
8010621b:	e9 6a f9 ff ff       	jmp    80105b8a <alltraps>

80106220 <vector49>:
.globl vector49
vector49:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $49
80106222:	6a 31                	push   $0x31
  jmp alltraps
80106224:	e9 61 f9 ff ff       	jmp    80105b8a <alltraps>

80106229 <vector50>:
.globl vector50
vector50:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $50
8010622b:	6a 32                	push   $0x32
  jmp alltraps
8010622d:	e9 58 f9 ff ff       	jmp    80105b8a <alltraps>

80106232 <vector51>:
.globl vector51
vector51:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $51
80106234:	6a 33                	push   $0x33
  jmp alltraps
80106236:	e9 4f f9 ff ff       	jmp    80105b8a <alltraps>

8010623b <vector52>:
.globl vector52
vector52:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $52
8010623d:	6a 34                	push   $0x34
  jmp alltraps
8010623f:	e9 46 f9 ff ff       	jmp    80105b8a <alltraps>

80106244 <vector53>:
.globl vector53
vector53:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $53
80106246:	6a 35                	push   $0x35
  jmp alltraps
80106248:	e9 3d f9 ff ff       	jmp    80105b8a <alltraps>

8010624d <vector54>:
.globl vector54
vector54:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $54
8010624f:	6a 36                	push   $0x36
  jmp alltraps
80106251:	e9 34 f9 ff ff       	jmp    80105b8a <alltraps>

80106256 <vector55>:
.globl vector55
vector55:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $55
80106258:	6a 37                	push   $0x37
  jmp alltraps
8010625a:	e9 2b f9 ff ff       	jmp    80105b8a <alltraps>

8010625f <vector56>:
.globl vector56
vector56:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $56
80106261:	6a 38                	push   $0x38
  jmp alltraps
80106263:	e9 22 f9 ff ff       	jmp    80105b8a <alltraps>

80106268 <vector57>:
.globl vector57
vector57:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $57
8010626a:	6a 39                	push   $0x39
  jmp alltraps
8010626c:	e9 19 f9 ff ff       	jmp    80105b8a <alltraps>

80106271 <vector58>:
.globl vector58
vector58:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $58
80106273:	6a 3a                	push   $0x3a
  jmp alltraps
80106275:	e9 10 f9 ff ff       	jmp    80105b8a <alltraps>

8010627a <vector59>:
.globl vector59
vector59:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $59
8010627c:	6a 3b                	push   $0x3b
  jmp alltraps
8010627e:	e9 07 f9 ff ff       	jmp    80105b8a <alltraps>

80106283 <vector60>:
.globl vector60
vector60:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $60
80106285:	6a 3c                	push   $0x3c
  jmp alltraps
80106287:	e9 fe f8 ff ff       	jmp    80105b8a <alltraps>

8010628c <vector61>:
.globl vector61
vector61:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $61
8010628e:	6a 3d                	push   $0x3d
  jmp alltraps
80106290:	e9 f5 f8 ff ff       	jmp    80105b8a <alltraps>

80106295 <vector62>:
.globl vector62
vector62:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $62
80106297:	6a 3e                	push   $0x3e
  jmp alltraps
80106299:	e9 ec f8 ff ff       	jmp    80105b8a <alltraps>

8010629e <vector63>:
.globl vector63
vector63:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $63
801062a0:	6a 3f                	push   $0x3f
  jmp alltraps
801062a2:	e9 e3 f8 ff ff       	jmp    80105b8a <alltraps>

801062a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $64
801062a9:	6a 40                	push   $0x40
  jmp alltraps
801062ab:	e9 da f8 ff ff       	jmp    80105b8a <alltraps>

801062b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $65
801062b2:	6a 41                	push   $0x41
  jmp alltraps
801062b4:	e9 d1 f8 ff ff       	jmp    80105b8a <alltraps>

801062b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $66
801062bb:	6a 42                	push   $0x42
  jmp alltraps
801062bd:	e9 c8 f8 ff ff       	jmp    80105b8a <alltraps>

801062c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $67
801062c4:	6a 43                	push   $0x43
  jmp alltraps
801062c6:	e9 bf f8 ff ff       	jmp    80105b8a <alltraps>

801062cb <vector68>:
.globl vector68
vector68:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $68
801062cd:	6a 44                	push   $0x44
  jmp alltraps
801062cf:	e9 b6 f8 ff ff       	jmp    80105b8a <alltraps>

801062d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $69
801062d6:	6a 45                	push   $0x45
  jmp alltraps
801062d8:	e9 ad f8 ff ff       	jmp    80105b8a <alltraps>

801062dd <vector70>:
.globl vector70
vector70:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $70
801062df:	6a 46                	push   $0x46
  jmp alltraps
801062e1:	e9 a4 f8 ff ff       	jmp    80105b8a <alltraps>

801062e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $71
801062e8:	6a 47                	push   $0x47
  jmp alltraps
801062ea:	e9 9b f8 ff ff       	jmp    80105b8a <alltraps>

801062ef <vector72>:
.globl vector72
vector72:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $72
801062f1:	6a 48                	push   $0x48
  jmp alltraps
801062f3:	e9 92 f8 ff ff       	jmp    80105b8a <alltraps>

801062f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $73
801062fa:	6a 49                	push   $0x49
  jmp alltraps
801062fc:	e9 89 f8 ff ff       	jmp    80105b8a <alltraps>

80106301 <vector74>:
.globl vector74
vector74:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $74
80106303:	6a 4a                	push   $0x4a
  jmp alltraps
80106305:	e9 80 f8 ff ff       	jmp    80105b8a <alltraps>

8010630a <vector75>:
.globl vector75
vector75:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $75
8010630c:	6a 4b                	push   $0x4b
  jmp alltraps
8010630e:	e9 77 f8 ff ff       	jmp    80105b8a <alltraps>

80106313 <vector76>:
.globl vector76
vector76:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $76
80106315:	6a 4c                	push   $0x4c
  jmp alltraps
80106317:	e9 6e f8 ff ff       	jmp    80105b8a <alltraps>

8010631c <vector77>:
.globl vector77
vector77:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $77
8010631e:	6a 4d                	push   $0x4d
  jmp alltraps
80106320:	e9 65 f8 ff ff       	jmp    80105b8a <alltraps>

80106325 <vector78>:
.globl vector78
vector78:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $78
80106327:	6a 4e                	push   $0x4e
  jmp alltraps
80106329:	e9 5c f8 ff ff       	jmp    80105b8a <alltraps>

8010632e <vector79>:
.globl vector79
vector79:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $79
80106330:	6a 4f                	push   $0x4f
  jmp alltraps
80106332:	e9 53 f8 ff ff       	jmp    80105b8a <alltraps>

80106337 <vector80>:
.globl vector80
vector80:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $80
80106339:	6a 50                	push   $0x50
  jmp alltraps
8010633b:	e9 4a f8 ff ff       	jmp    80105b8a <alltraps>

80106340 <vector81>:
.globl vector81
vector81:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $81
80106342:	6a 51                	push   $0x51
  jmp alltraps
80106344:	e9 41 f8 ff ff       	jmp    80105b8a <alltraps>

80106349 <vector82>:
.globl vector82
vector82:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $82
8010634b:	6a 52                	push   $0x52
  jmp alltraps
8010634d:	e9 38 f8 ff ff       	jmp    80105b8a <alltraps>

80106352 <vector83>:
.globl vector83
vector83:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $83
80106354:	6a 53                	push   $0x53
  jmp alltraps
80106356:	e9 2f f8 ff ff       	jmp    80105b8a <alltraps>

8010635b <vector84>:
.globl vector84
vector84:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $84
8010635d:	6a 54                	push   $0x54
  jmp alltraps
8010635f:	e9 26 f8 ff ff       	jmp    80105b8a <alltraps>

80106364 <vector85>:
.globl vector85
vector85:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $85
80106366:	6a 55                	push   $0x55
  jmp alltraps
80106368:	e9 1d f8 ff ff       	jmp    80105b8a <alltraps>

8010636d <vector86>:
.globl vector86
vector86:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $86
8010636f:	6a 56                	push   $0x56
  jmp alltraps
80106371:	e9 14 f8 ff ff       	jmp    80105b8a <alltraps>

80106376 <vector87>:
.globl vector87
vector87:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $87
80106378:	6a 57                	push   $0x57
  jmp alltraps
8010637a:	e9 0b f8 ff ff       	jmp    80105b8a <alltraps>

8010637f <vector88>:
.globl vector88
vector88:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $88
80106381:	6a 58                	push   $0x58
  jmp alltraps
80106383:	e9 02 f8 ff ff       	jmp    80105b8a <alltraps>

80106388 <vector89>:
.globl vector89
vector89:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $89
8010638a:	6a 59                	push   $0x59
  jmp alltraps
8010638c:	e9 f9 f7 ff ff       	jmp    80105b8a <alltraps>

80106391 <vector90>:
.globl vector90
vector90:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $90
80106393:	6a 5a                	push   $0x5a
  jmp alltraps
80106395:	e9 f0 f7 ff ff       	jmp    80105b8a <alltraps>

8010639a <vector91>:
.globl vector91
vector91:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $91
8010639c:	6a 5b                	push   $0x5b
  jmp alltraps
8010639e:	e9 e7 f7 ff ff       	jmp    80105b8a <alltraps>

801063a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $92
801063a5:	6a 5c                	push   $0x5c
  jmp alltraps
801063a7:	e9 de f7 ff ff       	jmp    80105b8a <alltraps>

801063ac <vector93>:
.globl vector93
vector93:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $93
801063ae:	6a 5d                	push   $0x5d
  jmp alltraps
801063b0:	e9 d5 f7 ff ff       	jmp    80105b8a <alltraps>

801063b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $94
801063b7:	6a 5e                	push   $0x5e
  jmp alltraps
801063b9:	e9 cc f7 ff ff       	jmp    80105b8a <alltraps>

801063be <vector95>:
.globl vector95
vector95:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $95
801063c0:	6a 5f                	push   $0x5f
  jmp alltraps
801063c2:	e9 c3 f7 ff ff       	jmp    80105b8a <alltraps>

801063c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $96
801063c9:	6a 60                	push   $0x60
  jmp alltraps
801063cb:	e9 ba f7 ff ff       	jmp    80105b8a <alltraps>

801063d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $97
801063d2:	6a 61                	push   $0x61
  jmp alltraps
801063d4:	e9 b1 f7 ff ff       	jmp    80105b8a <alltraps>

801063d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $98
801063db:	6a 62                	push   $0x62
  jmp alltraps
801063dd:	e9 a8 f7 ff ff       	jmp    80105b8a <alltraps>

801063e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $99
801063e4:	6a 63                	push   $0x63
  jmp alltraps
801063e6:	e9 9f f7 ff ff       	jmp    80105b8a <alltraps>

801063eb <vector100>:
.globl vector100
vector100:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $100
801063ed:	6a 64                	push   $0x64
  jmp alltraps
801063ef:	e9 96 f7 ff ff       	jmp    80105b8a <alltraps>

801063f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $101
801063f6:	6a 65                	push   $0x65
  jmp alltraps
801063f8:	e9 8d f7 ff ff       	jmp    80105b8a <alltraps>

801063fd <vector102>:
.globl vector102
vector102:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $102
801063ff:	6a 66                	push   $0x66
  jmp alltraps
80106401:	e9 84 f7 ff ff       	jmp    80105b8a <alltraps>

80106406 <vector103>:
.globl vector103
vector103:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $103
80106408:	6a 67                	push   $0x67
  jmp alltraps
8010640a:	e9 7b f7 ff ff       	jmp    80105b8a <alltraps>

8010640f <vector104>:
.globl vector104
vector104:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $104
80106411:	6a 68                	push   $0x68
  jmp alltraps
80106413:	e9 72 f7 ff ff       	jmp    80105b8a <alltraps>

80106418 <vector105>:
.globl vector105
vector105:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $105
8010641a:	6a 69                	push   $0x69
  jmp alltraps
8010641c:	e9 69 f7 ff ff       	jmp    80105b8a <alltraps>

80106421 <vector106>:
.globl vector106
vector106:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $106
80106423:	6a 6a                	push   $0x6a
  jmp alltraps
80106425:	e9 60 f7 ff ff       	jmp    80105b8a <alltraps>

8010642a <vector107>:
.globl vector107
vector107:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $107
8010642c:	6a 6b                	push   $0x6b
  jmp alltraps
8010642e:	e9 57 f7 ff ff       	jmp    80105b8a <alltraps>

80106433 <vector108>:
.globl vector108
vector108:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $108
80106435:	6a 6c                	push   $0x6c
  jmp alltraps
80106437:	e9 4e f7 ff ff       	jmp    80105b8a <alltraps>

8010643c <vector109>:
.globl vector109
vector109:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $109
8010643e:	6a 6d                	push   $0x6d
  jmp alltraps
80106440:	e9 45 f7 ff ff       	jmp    80105b8a <alltraps>

80106445 <vector110>:
.globl vector110
vector110:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $110
80106447:	6a 6e                	push   $0x6e
  jmp alltraps
80106449:	e9 3c f7 ff ff       	jmp    80105b8a <alltraps>

8010644e <vector111>:
.globl vector111
vector111:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $111
80106450:	6a 6f                	push   $0x6f
  jmp alltraps
80106452:	e9 33 f7 ff ff       	jmp    80105b8a <alltraps>

80106457 <vector112>:
.globl vector112
vector112:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $112
80106459:	6a 70                	push   $0x70
  jmp alltraps
8010645b:	e9 2a f7 ff ff       	jmp    80105b8a <alltraps>

80106460 <vector113>:
.globl vector113
vector113:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $113
80106462:	6a 71                	push   $0x71
  jmp alltraps
80106464:	e9 21 f7 ff ff       	jmp    80105b8a <alltraps>

80106469 <vector114>:
.globl vector114
vector114:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $114
8010646b:	6a 72                	push   $0x72
  jmp alltraps
8010646d:	e9 18 f7 ff ff       	jmp    80105b8a <alltraps>

80106472 <vector115>:
.globl vector115
vector115:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $115
80106474:	6a 73                	push   $0x73
  jmp alltraps
80106476:	e9 0f f7 ff ff       	jmp    80105b8a <alltraps>

8010647b <vector116>:
.globl vector116
vector116:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $116
8010647d:	6a 74                	push   $0x74
  jmp alltraps
8010647f:	e9 06 f7 ff ff       	jmp    80105b8a <alltraps>

80106484 <vector117>:
.globl vector117
vector117:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $117
80106486:	6a 75                	push   $0x75
  jmp alltraps
80106488:	e9 fd f6 ff ff       	jmp    80105b8a <alltraps>

8010648d <vector118>:
.globl vector118
vector118:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $118
8010648f:	6a 76                	push   $0x76
  jmp alltraps
80106491:	e9 f4 f6 ff ff       	jmp    80105b8a <alltraps>

80106496 <vector119>:
.globl vector119
vector119:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $119
80106498:	6a 77                	push   $0x77
  jmp alltraps
8010649a:	e9 eb f6 ff ff       	jmp    80105b8a <alltraps>

8010649f <vector120>:
.globl vector120
vector120:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $120
801064a1:	6a 78                	push   $0x78
  jmp alltraps
801064a3:	e9 e2 f6 ff ff       	jmp    80105b8a <alltraps>

801064a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $121
801064aa:	6a 79                	push   $0x79
  jmp alltraps
801064ac:	e9 d9 f6 ff ff       	jmp    80105b8a <alltraps>

801064b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $122
801064b3:	6a 7a                	push   $0x7a
  jmp alltraps
801064b5:	e9 d0 f6 ff ff       	jmp    80105b8a <alltraps>

801064ba <vector123>:
.globl vector123
vector123:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $123
801064bc:	6a 7b                	push   $0x7b
  jmp alltraps
801064be:	e9 c7 f6 ff ff       	jmp    80105b8a <alltraps>

801064c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $124
801064c5:	6a 7c                	push   $0x7c
  jmp alltraps
801064c7:	e9 be f6 ff ff       	jmp    80105b8a <alltraps>

801064cc <vector125>:
.globl vector125
vector125:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $125
801064ce:	6a 7d                	push   $0x7d
  jmp alltraps
801064d0:	e9 b5 f6 ff ff       	jmp    80105b8a <alltraps>

801064d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $126
801064d7:	6a 7e                	push   $0x7e
  jmp alltraps
801064d9:	e9 ac f6 ff ff       	jmp    80105b8a <alltraps>

801064de <vector127>:
.globl vector127
vector127:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $127
801064e0:	6a 7f                	push   $0x7f
  jmp alltraps
801064e2:	e9 a3 f6 ff ff       	jmp    80105b8a <alltraps>

801064e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $128
801064e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ee:	e9 97 f6 ff ff       	jmp    80105b8a <alltraps>

801064f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $129
801064f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064fa:	e9 8b f6 ff ff       	jmp    80105b8a <alltraps>

801064ff <vector130>:
.globl vector130
vector130:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $130
80106501:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106506:	e9 7f f6 ff ff       	jmp    80105b8a <alltraps>

8010650b <vector131>:
.globl vector131
vector131:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $131
8010650d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106512:	e9 73 f6 ff ff       	jmp    80105b8a <alltraps>

80106517 <vector132>:
.globl vector132
vector132:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $132
80106519:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010651e:	e9 67 f6 ff ff       	jmp    80105b8a <alltraps>

80106523 <vector133>:
.globl vector133
vector133:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $133
80106525:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010652a:	e9 5b f6 ff ff       	jmp    80105b8a <alltraps>

8010652f <vector134>:
.globl vector134
vector134:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $134
80106531:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106536:	e9 4f f6 ff ff       	jmp    80105b8a <alltraps>

8010653b <vector135>:
.globl vector135
vector135:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $135
8010653d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106542:	e9 43 f6 ff ff       	jmp    80105b8a <alltraps>

80106547 <vector136>:
.globl vector136
vector136:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $136
80106549:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010654e:	e9 37 f6 ff ff       	jmp    80105b8a <alltraps>

80106553 <vector137>:
.globl vector137
vector137:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $137
80106555:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010655a:	e9 2b f6 ff ff       	jmp    80105b8a <alltraps>

8010655f <vector138>:
.globl vector138
vector138:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $138
80106561:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106566:	e9 1f f6 ff ff       	jmp    80105b8a <alltraps>

8010656b <vector139>:
.globl vector139
vector139:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $139
8010656d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106572:	e9 13 f6 ff ff       	jmp    80105b8a <alltraps>

80106577 <vector140>:
.globl vector140
vector140:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $140
80106579:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010657e:	e9 07 f6 ff ff       	jmp    80105b8a <alltraps>

80106583 <vector141>:
.globl vector141
vector141:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $141
80106585:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010658a:	e9 fb f5 ff ff       	jmp    80105b8a <alltraps>

8010658f <vector142>:
.globl vector142
vector142:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $142
80106591:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106596:	e9 ef f5 ff ff       	jmp    80105b8a <alltraps>

8010659b <vector143>:
.globl vector143
vector143:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $143
8010659d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065a2:	e9 e3 f5 ff ff       	jmp    80105b8a <alltraps>

801065a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $144
801065a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ae:	e9 d7 f5 ff ff       	jmp    80105b8a <alltraps>

801065b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $145
801065b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ba:	e9 cb f5 ff ff       	jmp    80105b8a <alltraps>

801065bf <vector146>:
.globl vector146
vector146:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $146
801065c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065c6:	e9 bf f5 ff ff       	jmp    80105b8a <alltraps>

801065cb <vector147>:
.globl vector147
vector147:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $147
801065cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065d2:	e9 b3 f5 ff ff       	jmp    80105b8a <alltraps>

801065d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $148
801065d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065de:	e9 a7 f5 ff ff       	jmp    80105b8a <alltraps>

801065e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $149
801065e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ea:	e9 9b f5 ff ff       	jmp    80105b8a <alltraps>

801065ef <vector150>:
.globl vector150
vector150:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $150
801065f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065f6:	e9 8f f5 ff ff       	jmp    80105b8a <alltraps>

801065fb <vector151>:
.globl vector151
vector151:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $151
801065fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106602:	e9 83 f5 ff ff       	jmp    80105b8a <alltraps>

80106607 <vector152>:
.globl vector152
vector152:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $152
80106609:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010660e:	e9 77 f5 ff ff       	jmp    80105b8a <alltraps>

80106613 <vector153>:
.globl vector153
vector153:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $153
80106615:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010661a:	e9 6b f5 ff ff       	jmp    80105b8a <alltraps>

8010661f <vector154>:
.globl vector154
vector154:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $154
80106621:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106626:	e9 5f f5 ff ff       	jmp    80105b8a <alltraps>

8010662b <vector155>:
.globl vector155
vector155:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $155
8010662d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106632:	e9 53 f5 ff ff       	jmp    80105b8a <alltraps>

80106637 <vector156>:
.globl vector156
vector156:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $156
80106639:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010663e:	e9 47 f5 ff ff       	jmp    80105b8a <alltraps>

80106643 <vector157>:
.globl vector157
vector157:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $157
80106645:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010664a:	e9 3b f5 ff ff       	jmp    80105b8a <alltraps>

8010664f <vector158>:
.globl vector158
vector158:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $158
80106651:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106656:	e9 2f f5 ff ff       	jmp    80105b8a <alltraps>

8010665b <vector159>:
.globl vector159
vector159:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $159
8010665d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106662:	e9 23 f5 ff ff       	jmp    80105b8a <alltraps>

80106667 <vector160>:
.globl vector160
vector160:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $160
80106669:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010666e:	e9 17 f5 ff ff       	jmp    80105b8a <alltraps>

80106673 <vector161>:
.globl vector161
vector161:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $161
80106675:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010667a:	e9 0b f5 ff ff       	jmp    80105b8a <alltraps>

8010667f <vector162>:
.globl vector162
vector162:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $162
80106681:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106686:	e9 ff f4 ff ff       	jmp    80105b8a <alltraps>

8010668b <vector163>:
.globl vector163
vector163:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $163
8010668d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106692:	e9 f3 f4 ff ff       	jmp    80105b8a <alltraps>

80106697 <vector164>:
.globl vector164
vector164:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $164
80106699:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010669e:	e9 e7 f4 ff ff       	jmp    80105b8a <alltraps>

801066a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $165
801066a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066aa:	e9 db f4 ff ff       	jmp    80105b8a <alltraps>

801066af <vector166>:
.globl vector166
vector166:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $166
801066b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066b6:	e9 cf f4 ff ff       	jmp    80105b8a <alltraps>

801066bb <vector167>:
.globl vector167
vector167:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $167
801066bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066c2:	e9 c3 f4 ff ff       	jmp    80105b8a <alltraps>

801066c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $168
801066c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ce:	e9 b7 f4 ff ff       	jmp    80105b8a <alltraps>

801066d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $169
801066d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066da:	e9 ab f4 ff ff       	jmp    80105b8a <alltraps>

801066df <vector170>:
.globl vector170
vector170:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $170
801066e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066e6:	e9 9f f4 ff ff       	jmp    80105b8a <alltraps>

801066eb <vector171>:
.globl vector171
vector171:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $171
801066ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066f2:	e9 93 f4 ff ff       	jmp    80105b8a <alltraps>

801066f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $172
801066f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066fe:	e9 87 f4 ff ff       	jmp    80105b8a <alltraps>

80106703 <vector173>:
.globl vector173
vector173:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $173
80106705:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010670a:	e9 7b f4 ff ff       	jmp    80105b8a <alltraps>

8010670f <vector174>:
.globl vector174
vector174:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $174
80106711:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106716:	e9 6f f4 ff ff       	jmp    80105b8a <alltraps>

8010671b <vector175>:
.globl vector175
vector175:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $175
8010671d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106722:	e9 63 f4 ff ff       	jmp    80105b8a <alltraps>

80106727 <vector176>:
.globl vector176
vector176:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $176
80106729:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010672e:	e9 57 f4 ff ff       	jmp    80105b8a <alltraps>

80106733 <vector177>:
.globl vector177
vector177:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $177
80106735:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010673a:	e9 4b f4 ff ff       	jmp    80105b8a <alltraps>

8010673f <vector178>:
.globl vector178
vector178:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $178
80106741:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106746:	e9 3f f4 ff ff       	jmp    80105b8a <alltraps>

8010674b <vector179>:
.globl vector179
vector179:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $179
8010674d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106752:	e9 33 f4 ff ff       	jmp    80105b8a <alltraps>

80106757 <vector180>:
.globl vector180
vector180:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $180
80106759:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010675e:	e9 27 f4 ff ff       	jmp    80105b8a <alltraps>

80106763 <vector181>:
.globl vector181
vector181:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $181
80106765:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010676a:	e9 1b f4 ff ff       	jmp    80105b8a <alltraps>

8010676f <vector182>:
.globl vector182
vector182:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $182
80106771:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106776:	e9 0f f4 ff ff       	jmp    80105b8a <alltraps>

8010677b <vector183>:
.globl vector183
vector183:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $183
8010677d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106782:	e9 03 f4 ff ff       	jmp    80105b8a <alltraps>

80106787 <vector184>:
.globl vector184
vector184:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $184
80106789:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010678e:	e9 f7 f3 ff ff       	jmp    80105b8a <alltraps>

80106793 <vector185>:
.globl vector185
vector185:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $185
80106795:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010679a:	e9 eb f3 ff ff       	jmp    80105b8a <alltraps>

8010679f <vector186>:
.globl vector186
vector186:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $186
801067a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067a6:	e9 df f3 ff ff       	jmp    80105b8a <alltraps>

801067ab <vector187>:
.globl vector187
vector187:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $187
801067ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067b2:	e9 d3 f3 ff ff       	jmp    80105b8a <alltraps>

801067b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $188
801067b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067be:	e9 c7 f3 ff ff       	jmp    80105b8a <alltraps>

801067c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $189
801067c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ca:	e9 bb f3 ff ff       	jmp    80105b8a <alltraps>

801067cf <vector190>:
.globl vector190
vector190:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $190
801067d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067d6:	e9 af f3 ff ff       	jmp    80105b8a <alltraps>

801067db <vector191>:
.globl vector191
vector191:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $191
801067dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067e2:	e9 a3 f3 ff ff       	jmp    80105b8a <alltraps>

801067e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $192
801067e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ee:	e9 97 f3 ff ff       	jmp    80105b8a <alltraps>

801067f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $193
801067f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067fa:	e9 8b f3 ff ff       	jmp    80105b8a <alltraps>

801067ff <vector194>:
.globl vector194
vector194:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $194
80106801:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106806:	e9 7f f3 ff ff       	jmp    80105b8a <alltraps>

8010680b <vector195>:
.globl vector195
vector195:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $195
8010680d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106812:	e9 73 f3 ff ff       	jmp    80105b8a <alltraps>

80106817 <vector196>:
.globl vector196
vector196:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $196
80106819:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010681e:	e9 67 f3 ff ff       	jmp    80105b8a <alltraps>

80106823 <vector197>:
.globl vector197
vector197:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $197
80106825:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010682a:	e9 5b f3 ff ff       	jmp    80105b8a <alltraps>

8010682f <vector198>:
.globl vector198
vector198:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $198
80106831:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106836:	e9 4f f3 ff ff       	jmp    80105b8a <alltraps>

8010683b <vector199>:
.globl vector199
vector199:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $199
8010683d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106842:	e9 43 f3 ff ff       	jmp    80105b8a <alltraps>

80106847 <vector200>:
.globl vector200
vector200:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $200
80106849:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010684e:	e9 37 f3 ff ff       	jmp    80105b8a <alltraps>

80106853 <vector201>:
.globl vector201
vector201:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $201
80106855:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010685a:	e9 2b f3 ff ff       	jmp    80105b8a <alltraps>

8010685f <vector202>:
.globl vector202
vector202:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $202
80106861:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106866:	e9 1f f3 ff ff       	jmp    80105b8a <alltraps>

8010686b <vector203>:
.globl vector203
vector203:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $203
8010686d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106872:	e9 13 f3 ff ff       	jmp    80105b8a <alltraps>

80106877 <vector204>:
.globl vector204
vector204:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $204
80106879:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010687e:	e9 07 f3 ff ff       	jmp    80105b8a <alltraps>

80106883 <vector205>:
.globl vector205
vector205:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $205
80106885:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010688a:	e9 fb f2 ff ff       	jmp    80105b8a <alltraps>

8010688f <vector206>:
.globl vector206
vector206:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $206
80106891:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106896:	e9 ef f2 ff ff       	jmp    80105b8a <alltraps>

8010689b <vector207>:
.globl vector207
vector207:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $207
8010689d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068a2:	e9 e3 f2 ff ff       	jmp    80105b8a <alltraps>

801068a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $208
801068a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ae:	e9 d7 f2 ff ff       	jmp    80105b8a <alltraps>

801068b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $209
801068b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ba:	e9 cb f2 ff ff       	jmp    80105b8a <alltraps>

801068bf <vector210>:
.globl vector210
vector210:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $210
801068c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068c6:	e9 bf f2 ff ff       	jmp    80105b8a <alltraps>

801068cb <vector211>:
.globl vector211
vector211:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $211
801068cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068d2:	e9 b3 f2 ff ff       	jmp    80105b8a <alltraps>

801068d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $212
801068d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068de:	e9 a7 f2 ff ff       	jmp    80105b8a <alltraps>

801068e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $213
801068e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ea:	e9 9b f2 ff ff       	jmp    80105b8a <alltraps>

801068ef <vector214>:
.globl vector214
vector214:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $214
801068f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068f6:	e9 8f f2 ff ff       	jmp    80105b8a <alltraps>

801068fb <vector215>:
.globl vector215
vector215:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $215
801068fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106902:	e9 83 f2 ff ff       	jmp    80105b8a <alltraps>

80106907 <vector216>:
.globl vector216
vector216:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $216
80106909:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010690e:	e9 77 f2 ff ff       	jmp    80105b8a <alltraps>

80106913 <vector217>:
.globl vector217
vector217:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $217
80106915:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010691a:	e9 6b f2 ff ff       	jmp    80105b8a <alltraps>

8010691f <vector218>:
.globl vector218
vector218:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $218
80106921:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106926:	e9 5f f2 ff ff       	jmp    80105b8a <alltraps>

8010692b <vector219>:
.globl vector219
vector219:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $219
8010692d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106932:	e9 53 f2 ff ff       	jmp    80105b8a <alltraps>

80106937 <vector220>:
.globl vector220
vector220:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $220
80106939:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010693e:	e9 47 f2 ff ff       	jmp    80105b8a <alltraps>

80106943 <vector221>:
.globl vector221
vector221:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $221
80106945:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010694a:	e9 3b f2 ff ff       	jmp    80105b8a <alltraps>

8010694f <vector222>:
.globl vector222
vector222:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $222
80106951:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106956:	e9 2f f2 ff ff       	jmp    80105b8a <alltraps>

8010695b <vector223>:
.globl vector223
vector223:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $223
8010695d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106962:	e9 23 f2 ff ff       	jmp    80105b8a <alltraps>

80106967 <vector224>:
.globl vector224
vector224:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $224
80106969:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010696e:	e9 17 f2 ff ff       	jmp    80105b8a <alltraps>

80106973 <vector225>:
.globl vector225
vector225:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $225
80106975:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010697a:	e9 0b f2 ff ff       	jmp    80105b8a <alltraps>

8010697f <vector226>:
.globl vector226
vector226:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $226
80106981:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106986:	e9 ff f1 ff ff       	jmp    80105b8a <alltraps>

8010698b <vector227>:
.globl vector227
vector227:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $227
8010698d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106992:	e9 f3 f1 ff ff       	jmp    80105b8a <alltraps>

80106997 <vector228>:
.globl vector228
vector228:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $228
80106999:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010699e:	e9 e7 f1 ff ff       	jmp    80105b8a <alltraps>

801069a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $229
801069a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069aa:	e9 db f1 ff ff       	jmp    80105b8a <alltraps>

801069af <vector230>:
.globl vector230
vector230:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $230
801069b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069b6:	e9 cf f1 ff ff       	jmp    80105b8a <alltraps>

801069bb <vector231>:
.globl vector231
vector231:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $231
801069bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069c2:	e9 c3 f1 ff ff       	jmp    80105b8a <alltraps>

801069c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $232
801069c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ce:	e9 b7 f1 ff ff       	jmp    80105b8a <alltraps>

801069d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $233
801069d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069da:	e9 ab f1 ff ff       	jmp    80105b8a <alltraps>

801069df <vector234>:
.globl vector234
vector234:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $234
801069e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069e6:	e9 9f f1 ff ff       	jmp    80105b8a <alltraps>

801069eb <vector235>:
.globl vector235
vector235:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $235
801069ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069f2:	e9 93 f1 ff ff       	jmp    80105b8a <alltraps>

801069f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $236
801069f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069fe:	e9 87 f1 ff ff       	jmp    80105b8a <alltraps>

80106a03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $237
80106a05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a0a:	e9 7b f1 ff ff       	jmp    80105b8a <alltraps>

80106a0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $238
80106a11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a16:	e9 6f f1 ff ff       	jmp    80105b8a <alltraps>

80106a1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $239
80106a1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a22:	e9 63 f1 ff ff       	jmp    80105b8a <alltraps>

80106a27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $240
80106a29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a2e:	e9 57 f1 ff ff       	jmp    80105b8a <alltraps>

80106a33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $241
80106a35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a3a:	e9 4b f1 ff ff       	jmp    80105b8a <alltraps>

80106a3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $242
80106a41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a46:	e9 3f f1 ff ff       	jmp    80105b8a <alltraps>

80106a4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $243
80106a4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a52:	e9 33 f1 ff ff       	jmp    80105b8a <alltraps>

80106a57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $244
80106a59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a5e:	e9 27 f1 ff ff       	jmp    80105b8a <alltraps>

80106a63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $245
80106a65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a6a:	e9 1b f1 ff ff       	jmp    80105b8a <alltraps>

80106a6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $246
80106a71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a76:	e9 0f f1 ff ff       	jmp    80105b8a <alltraps>

80106a7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $247
80106a7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a82:	e9 03 f1 ff ff       	jmp    80105b8a <alltraps>

80106a87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $248
80106a89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a8e:	e9 f7 f0 ff ff       	jmp    80105b8a <alltraps>

80106a93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $249
80106a95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a9a:	e9 eb f0 ff ff       	jmp    80105b8a <alltraps>

80106a9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $250
80106aa1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106aa6:	e9 df f0 ff ff       	jmp    80105b8a <alltraps>

80106aab <vector251>:
.globl vector251
vector251:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $251
80106aad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ab2:	e9 d3 f0 ff ff       	jmp    80105b8a <alltraps>

80106ab7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $252
80106ab9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106abe:	e9 c7 f0 ff ff       	jmp    80105b8a <alltraps>

80106ac3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $253
80106ac5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aca:	e9 bb f0 ff ff       	jmp    80105b8a <alltraps>

80106acf <vector254>:
.globl vector254
vector254:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $254
80106ad1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ad6:	e9 af f0 ff ff       	jmp    80105b8a <alltraps>

80106adb <vector255>:
.globl vector255
vector255:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $255
80106add:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ae2:	e9 a3 f0 ff ff       	jmp    80105b8a <alltraps>
80106ae7:	66 90                	xchg   %ax,%ax
80106ae9:	66 90                	xchg   %ax,%ax
80106aeb:	66 90                	xchg   %ax,%ax
80106aed:	66 90                	xchg   %ax,%ax
80106aef:	90                   	nop

80106af0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106af6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106afc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b02:	83 ec 1c             	sub    $0x1c,%esp
80106b05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b08:	39 d3                	cmp    %edx,%ebx
80106b0a:	73 49                	jae    80106b55 <deallocuvm.part.0+0x65>
80106b0c:	89 c7                	mov    %eax,%edi
80106b0e:	eb 0c                	jmp    80106b1c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b10:	83 c0 01             	add    $0x1,%eax
80106b13:	c1 e0 16             	shl    $0x16,%eax
80106b16:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b18:	39 da                	cmp    %ebx,%edx
80106b1a:	76 39                	jbe    80106b55 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b1c:	89 d8                	mov    %ebx,%eax
80106b1e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b21:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106b24:	f6 c1 01             	test   $0x1,%cl
80106b27:	74 e7                	je     80106b10 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b29:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106b31:	c1 ee 0a             	shr    $0xa,%esi
80106b34:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b3a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106b41:	85 f6                	test   %esi,%esi
80106b43:	74 cb                	je     80106b10 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106b45:	8b 06                	mov    (%esi),%eax
80106b47:	a8 01                	test   $0x1,%al
80106b49:	75 15                	jne    80106b60 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106b4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b51:	39 da                	cmp    %ebx,%edx
80106b53:	77 c7                	ja     80106b1c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b5b:	5b                   	pop    %ebx
80106b5c:	5e                   	pop    %esi
80106b5d:	5f                   	pop    %edi
80106b5e:	5d                   	pop    %ebp
80106b5f:	c3                   	ret    
      if(pa == 0)
80106b60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b65:	74 25                	je     80106b8c <deallocuvm.part.0+0x9c>
      kfree(v);
80106b67:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b6a:	05 00 00 00 80       	add    $0x80000000,%eax
80106b6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106b78:	50                   	push   %eax
80106b79:	e8 92 bc ff ff       	call   80102810 <kfree>
      *pte = 0;
80106b7e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106b84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b87:	83 c4 10             	add    $0x10,%esp
80106b8a:	eb 8c                	jmp    80106b18 <deallocuvm.part.0+0x28>
        panic("kfree");
80106b8c:	83 ec 0c             	sub    $0xc,%esp
80106b8f:	68 46 77 10 80       	push   $0x80107746
80106b94:	e8 e7 97 ff ff       	call   80100380 <panic>
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ba0 <mappages>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ba6:	89 d3                	mov    %edx,%ebx
80106ba8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bae:	83 ec 1c             	sub    $0x1c,%esp
80106bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106bb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106bb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc3:	29 d8                	sub    %ebx,%eax
80106bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bc8:	eb 3d                	jmp    80106c07 <mappages+0x67>
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bd7:	c1 ea 0a             	shr    $0xa,%edx
80106bda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106be0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106be7:	85 c0                	test   %eax,%eax
80106be9:	74 75                	je     80106c60 <mappages+0xc0>
    if(*pte & PTE_P)
80106beb:	f6 00 01             	testb  $0x1,(%eax)
80106bee:	0f 85 86 00 00 00    	jne    80106c7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106bf4:	0b 75 0c             	or     0xc(%ebp),%esi
80106bf7:	83 ce 01             	or     $0x1,%esi
80106bfa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bfc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106bff:	74 6f                	je     80106c70 <mappages+0xd0>
    a += PGSIZE;
80106c01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c10:	89 d8                	mov    %ebx,%eax
80106c12:	c1 e8 16             	shr    $0x16,%eax
80106c15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c18:	8b 07                	mov    (%edi),%eax
80106c1a:	a8 01                	test   $0x1,%al
80106c1c:	75 b2                	jne    80106bd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c1e:	e8 ad bd ff ff       	call   801029d0 <kalloc>
80106c23:	85 c0                	test   %eax,%eax
80106c25:	74 39                	je     80106c60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c27:	83 ec 04             	sub    $0x4,%esp
80106c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c2d:	68 00 10 00 00       	push   $0x1000
80106c32:	6a 00                	push   $0x0
80106c34:	50                   	push   %eax
80106c35:	e8 76 dd ff ff       	call   801049b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c46:	83 c8 07             	or     $0x7,%eax
80106c49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c4b:	89 d8                	mov    %ebx,%eax
80106c4d:	c1 e8 0a             	shr    $0xa,%eax
80106c50:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c55:	01 d0                	add    %edx,%eax
80106c57:	eb 92                	jmp    80106beb <mappages+0x4b>
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
80106c6c:	c3                   	ret    
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c73:	31 c0                	xor    %eax,%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
      panic("remap");
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	68 88 7d 10 80       	push   $0x80107d88
80106c82:	e8 f9 96 ff ff       	call   80100380 <panic>
80106c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8e:	66 90                	xchg   %ax,%ax

80106c90 <seginit>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c96:	e8 05 d0 ff ff       	call   80103ca0 <cpuid>
  pd[0] = size-1;
80106c9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ca0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ca6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106caa:	c7 80 38 1d 11 80 ff 	movl   $0xffff,-0x7feee2c8(%eax)
80106cb1:	ff 00 00 
80106cb4:	c7 80 3c 1d 11 80 00 	movl   $0xcf9a00,-0x7feee2c4(%eax)
80106cbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cbe:	c7 80 40 1d 11 80 ff 	movl   $0xffff,-0x7feee2c0(%eax)
80106cc5:	ff 00 00 
80106cc8:	c7 80 44 1d 11 80 00 	movl   $0xcf9200,-0x7feee2bc(%eax)
80106ccf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cd2:	c7 80 48 1d 11 80 ff 	movl   $0xffff,-0x7feee2b8(%eax)
80106cd9:	ff 00 00 
80106cdc:	c7 80 4c 1d 11 80 00 	movl   $0xcffa00,-0x7feee2b4(%eax)
80106ce3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ce6:	c7 80 50 1d 11 80 ff 	movl   $0xffff,-0x7feee2b0(%eax)
80106ced:	ff 00 00 
80106cf0:	c7 80 54 1d 11 80 00 	movl   $0xcff200,-0x7feee2ac(%eax)
80106cf7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cfa:	05 30 1d 11 80       	add    $0x80111d30,%eax
  pd[1] = (uint)p;
80106cff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d03:	c1 e8 10             	shr    $0x10,%eax
80106d06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d0d:	0f 01 10             	lgdtl  (%eax)
}
80106d10:	c9                   	leave  
80106d11:	c3                   	ret    
80106d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d20:	a1 e4 49 11 80       	mov    0x801149e4,%eax
80106d25:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d2a:	0f 22 d8             	mov    %eax,%cr3
}
80106d2d:	c3                   	ret    
80106d2e:	66 90                	xchg   %ax,%ax

80106d30 <switchuvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d3c:	85 f6                	test   %esi,%esi
80106d3e:	0f 84 cb 00 00 00    	je     80106e0f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d44:	8b 46 08             	mov    0x8(%esi),%eax
80106d47:	85 c0                	test   %eax,%eax
80106d49:	0f 84 da 00 00 00    	je     80106e29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d4f:	8b 46 04             	mov    0x4(%esi),%eax
80106d52:	85 c0                	test   %eax,%eax
80106d54:	0f 84 c2 00 00 00    	je     80106e1c <switchuvm+0xec>
  pushcli();
80106d5a:	e8 41 da ff ff       	call   801047a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d5f:	e8 dc ce ff ff       	call   80103c40 <mycpu>
80106d64:	89 c3                	mov    %eax,%ebx
80106d66:	e8 d5 ce ff ff       	call   80103c40 <mycpu>
80106d6b:	89 c7                	mov    %eax,%edi
80106d6d:	e8 ce ce ff ff       	call   80103c40 <mycpu>
80106d72:	83 c7 08             	add    $0x8,%edi
80106d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d78:	e8 c3 ce ff ff       	call   80103c40 <mycpu>
80106d7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d80:	ba 67 00 00 00       	mov    $0x67,%edx
80106d85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d8c:	83 c0 08             	add    $0x8,%eax
80106d8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d9b:	83 c1 08             	add    $0x8,%ecx
80106d9e:	c1 e8 18             	shr    $0x18,%eax
80106da1:	c1 e9 10             	shr    $0x10,%ecx
80106da4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106daa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106db0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106db5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106dc1:	e8 7a ce ff ff       	call   80103c40 <mycpu>
80106dc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dcd:	e8 6e ce ff ff       	call   80103c40 <mycpu>
80106dd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dd6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ddf:	e8 5c ce ff ff       	call   80103c40 <mycpu>
80106de4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106de7:	e8 54 ce ff ff       	call   80103c40 <mycpu>
80106dec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106df0:	b8 28 00 00 00       	mov    $0x28,%eax
80106df5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106df8:	8b 46 04             	mov    0x4(%esi),%eax
80106dfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e00:	0f 22 d8             	mov    %eax,%cr3
}
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	5b                   	pop    %ebx
80106e07:	5e                   	pop    %esi
80106e08:	5f                   	pop    %edi
80106e09:	5d                   	pop    %ebp
  popcli();
80106e0a:	e9 e1 d9 ff ff       	jmp    801047f0 <popcli>
    panic("switchuvm: no process");
80106e0f:	83 ec 0c             	sub    $0xc,%esp
80106e12:	68 8e 7d 10 80       	push   $0x80107d8e
80106e17:	e8 64 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 b9 7d 10 80       	push   $0x80107db9
80106e24:	e8 57 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e29:	83 ec 0c             	sub    $0xc,%esp
80106e2c:	68 a4 7d 10 80       	push   $0x80107da4
80106e31:	e8 4a 95 ff ff       	call   80100380 <panic>
80106e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi

80106e40 <inituvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e4c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e4f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e55:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e5b:	77 4b                	ja     80106ea8 <inituvm+0x68>
  mem = kalloc();
80106e5d:	e8 6e bb ff ff       	call   801029d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e62:	83 ec 04             	sub    $0x4,%esp
80106e65:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e6a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e6c:	6a 00                	push   $0x0
80106e6e:	50                   	push   %eax
80106e6f:	e8 3c db ff ff       	call   801049b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e74:	58                   	pop    %eax
80106e75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e7b:	5a                   	pop    %edx
80106e7c:	6a 06                	push   $0x6
80106e7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e83:	31 d2                	xor    %edx,%edx
80106e85:	50                   	push   %eax
80106e86:	89 f8                	mov    %edi,%eax
80106e88:	e8 13 fd ff ff       	call   80106ba0 <mappages>
  memmove(mem, init, sz);
80106e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e90:	89 75 10             	mov    %esi,0x10(%ebp)
80106e93:	83 c4 10             	add    $0x10,%esp
80106e96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e99:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9f:	5b                   	pop    %ebx
80106ea0:	5e                   	pop    %esi
80106ea1:	5f                   	pop    %edi
80106ea2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ea3:	e9 a8 db ff ff       	jmp    80104a50 <memmove>
    panic("inituvm: more than a page");
80106ea8:	83 ec 0c             	sub    $0xc,%esp
80106eab:	68 cd 7d 10 80       	push   $0x80107dcd
80106eb0:	e8 cb 94 ff ff       	call   80100380 <panic>
80106eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <loaduvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ecc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ecf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ed4:	0f 85 bb 00 00 00    	jne    80106f95 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eda:	01 f0                	add    %esi,%eax
80106edc:	89 f3                	mov    %esi,%ebx
80106ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ee1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ee4:	01 f0                	add    %esi,%eax
80106ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ee9:	85 f6                	test   %esi,%esi
80106eeb:	0f 84 87 00 00 00    	je     80106f78 <loaduvm+0xb8>
80106ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106efb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106efe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f00:	89 c2                	mov    %eax,%edx
80106f02:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f05:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f08:	f6 c2 01             	test   $0x1,%dl
80106f0b:	75 13                	jne    80106f20 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f0d:	83 ec 0c             	sub    $0xc,%esp
80106f10:	68 e7 7d 10 80       	push   $0x80107de7
80106f15:	e8 66 94 ff ff       	call   80100380 <panic>
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f29:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f35:	85 c0                	test   %eax,%eax
80106f37:	74 d4                	je     80106f0d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f51:	29 d9                	sub    %ebx,%ecx
80106f53:	05 00 00 00 80       	add    $0x80000000,%eax
80106f58:	57                   	push   %edi
80106f59:	51                   	push   %ecx
80106f5a:	50                   	push   %eax
80106f5b:	ff 75 10             	push   0x10(%ebp)
80106f5e:	e8 7d ae ff ff       	call   80101de0 <readi>
80106f63:	83 c4 10             	add    $0x10,%esp
80106f66:	39 f8                	cmp    %edi,%eax
80106f68:	75 1e                	jne    80106f88 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f6a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f70:	89 f0                	mov    %esi,%eax
80106f72:	29 d8                	sub    %ebx,%eax
80106f74:	39 c6                	cmp    %eax,%esi
80106f76:	77 80                	ja     80106ef8 <loaduvm+0x38>
}
80106f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f7b:	31 c0                	xor    %eax,%eax
}
80106f7d:	5b                   	pop    %ebx
80106f7e:	5e                   	pop    %esi
80106f7f:	5f                   	pop    %edi
80106f80:	5d                   	pop    %ebp
80106f81:	c3                   	ret    
80106f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f90:	5b                   	pop    %ebx
80106f91:	5e                   	pop    %esi
80106f92:	5f                   	pop    %edi
80106f93:	5d                   	pop    %ebp
80106f94:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f95:	83 ec 0c             	sub    $0xc,%esp
80106f98:	68 88 7e 10 80       	push   $0x80107e88
80106f9d:	e8 de 93 ff ff       	call   80100380 <panic>
80106fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fb0 <allocuvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fb9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fc2:	85 c0                	test   %eax,%eax
80106fc4:	0f 88 b6 00 00 00    	js     80107080 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fd0:	0f 82 9a 00 00 00    	jb     80107070 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fd6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fdc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fe2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fe5:	77 44                	ja     8010702b <allocuvm+0x7b>
80106fe7:	e9 87 00 00 00       	jmp    80107073 <allocuvm+0xc3>
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
80106ff3:	68 00 10 00 00       	push   $0x1000
80106ff8:	6a 00                	push   $0x0
80106ffa:	50                   	push   %eax
80106ffb:	e8 b0 d9 ff ff       	call   801049b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107000:	58                   	pop    %eax
80107001:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107007:	5a                   	pop    %edx
80107008:	6a 06                	push   $0x6
8010700a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010700f:	89 f2                	mov    %esi,%edx
80107011:	50                   	push   %eax
80107012:	89 f8                	mov    %edi,%eax
80107014:	e8 87 fb ff ff       	call   80106ba0 <mappages>
80107019:	83 c4 10             	add    $0x10,%esp
8010701c:	85 c0                	test   %eax,%eax
8010701e:	78 78                	js     80107098 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107020:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107026:	39 75 10             	cmp    %esi,0x10(%ebp)
80107029:	76 48                	jbe    80107073 <allocuvm+0xc3>
    mem = kalloc();
8010702b:	e8 a0 b9 ff ff       	call   801029d0 <kalloc>
80107030:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107032:	85 c0                	test   %eax,%eax
80107034:	75 ba                	jne    80106ff0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	68 05 7e 10 80       	push   $0x80107e05
8010703e:	e8 6d 97 ff ff       	call   801007b0 <cprintf>
  if(newsz >= oldsz)
80107043:	8b 45 0c             	mov    0xc(%ebp),%eax
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	39 45 10             	cmp    %eax,0x10(%ebp)
8010704c:	74 32                	je     80107080 <allocuvm+0xd0>
8010704e:	8b 55 10             	mov    0x10(%ebp),%edx
80107051:	89 c1                	mov    %eax,%ecx
80107053:	89 f8                	mov    %edi,%eax
80107055:	e8 96 fa ff ff       	call   80106af0 <deallocuvm.part.0>
      return 0;
8010705a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107067:	5b                   	pop    %ebx
80107068:	5e                   	pop    %esi
80107069:	5f                   	pop    %edi
8010706a:	5d                   	pop    %ebp
8010706b:	c3                   	ret    
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107070:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107079:	5b                   	pop    %ebx
8010707a:	5e                   	pop    %esi
8010707b:	5f                   	pop    %edi
8010707c:	5d                   	pop    %ebp
8010707d:	c3                   	ret    
8010707e:	66 90                	xchg   %ax,%ax
    return 0;
80107080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010708d:	5b                   	pop    %ebx
8010708e:	5e                   	pop    %esi
8010708f:	5f                   	pop    %edi
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret    
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	68 1d 7e 10 80       	push   $0x80107e1d
801070a0:	e8 0b 97 ff ff       	call   801007b0 <cprintf>
  if(newsz >= oldsz)
801070a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a8:	83 c4 10             	add    $0x10,%esp
801070ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ae:	74 0c                	je     801070bc <allocuvm+0x10c>
801070b0:	8b 55 10             	mov    0x10(%ebp),%edx
801070b3:	89 c1                	mov    %eax,%ecx
801070b5:	89 f8                	mov    %edi,%eax
801070b7:	e8 34 fa ff ff       	call   80106af0 <deallocuvm.part.0>
      kfree(mem);
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	53                   	push   %ebx
801070c0:	e8 4b b7 ff ff       	call   80102810 <kfree>
      return 0;
801070c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070cc:	83 c4 10             	add    $0x10,%esp
}
801070cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <deallocuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070ec:	39 d1                	cmp    %edx,%ecx
801070ee:	73 10                	jae    80107100 <deallocuvm+0x20>
}
801070f0:	5d                   	pop    %ebp
801070f1:	e9 fa f9 ff ff       	jmp    80106af0 <deallocuvm.part.0>
801070f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
80107100:	89 d0                	mov    %edx,%eax
80107102:	5d                   	pop    %ebp
80107103:	c3                   	ret    
80107104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop

80107110 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 0c             	sub    $0xc,%esp
80107119:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010711c:	85 f6                	test   %esi,%esi
8010711e:	74 59                	je     80107179 <freevm+0x69>
  if(newsz >= oldsz)
80107120:	31 c9                	xor    %ecx,%ecx
80107122:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107127:	89 f0                	mov    %esi,%eax
80107129:	89 f3                	mov    %esi,%ebx
8010712b:	e8 c0 f9 ff ff       	call   80106af0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107130:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107136:	eb 0f                	jmp    80107147 <freevm+0x37>
80107138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
80107140:	83 c3 04             	add    $0x4,%ebx
80107143:	39 df                	cmp    %ebx,%edi
80107145:	74 23                	je     8010716a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107147:	8b 03                	mov    (%ebx),%eax
80107149:	a8 01                	test   $0x1,%al
8010714b:	74 f3                	je     80107140 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010714d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107152:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107155:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107158:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010715d:	50                   	push   %eax
8010715e:	e8 ad b6 ff ff       	call   80102810 <kfree>
80107163:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107166:	39 df                	cmp    %ebx,%edi
80107168:	75 dd                	jne    80107147 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010716a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010716d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107170:	5b                   	pop    %ebx
80107171:	5e                   	pop    %esi
80107172:	5f                   	pop    %edi
80107173:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107174:	e9 97 b6 ff ff       	jmp    80102810 <kfree>
    panic("freevm: no pgdir");
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	68 39 7e 10 80       	push   $0x80107e39
80107181:	e8 fa 91 ff ff       	call   80100380 <panic>
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi

80107190 <setupkvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	56                   	push   %esi
80107194:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107195:	e8 36 b8 ff ff       	call   801029d0 <kalloc>
8010719a:	89 c6                	mov    %eax,%esi
8010719c:	85 c0                	test   %eax,%eax
8010719e:	74 42                	je     801071e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801071a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071a3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801071a8:	68 00 10 00 00       	push   $0x1000
801071ad:	6a 00                	push   $0x0
801071af:	50                   	push   %eax
801071b0:	e8 fb d7 ff ff       	call   801049b0 <memset>
801071b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071bb:	83 ec 08             	sub    $0x8,%esp
801071be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071c1:	ff 73 0c             	push   0xc(%ebx)
801071c4:	8b 13                	mov    (%ebx),%edx
801071c6:	50                   	push   %eax
801071c7:	29 c1                	sub    %eax,%ecx
801071c9:	89 f0                	mov    %esi,%eax
801071cb:	e8 d0 f9 ff ff       	call   80106ba0 <mappages>
801071d0:	83 c4 10             	add    $0x10,%esp
801071d3:	85 c0                	test   %eax,%eax
801071d5:	78 19                	js     801071f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071d7:	83 c3 10             	add    $0x10,%ebx
801071da:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071e0:	75 d6                	jne    801071b8 <setupkvm+0x28>
}
801071e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071e5:	89 f0                	mov    %esi,%eax
801071e7:	5b                   	pop    %ebx
801071e8:	5e                   	pop    %esi
801071e9:	5d                   	pop    %ebp
801071ea:	c3                   	ret    
801071eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071ef:	90                   	nop
      freevm(pgdir);
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	56                   	push   %esi
      return 0;
801071f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071f6:	e8 15 ff ff ff       	call   80107110 <freevm>
      return 0;
801071fb:	83 c4 10             	add    $0x10,%esp
}
801071fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107201:	89 f0                	mov    %esi,%eax
80107203:	5b                   	pop    %ebx
80107204:	5e                   	pop    %esi
80107205:	5d                   	pop    %ebp
80107206:	c3                   	ret    
80107207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720e:	66 90                	xchg   %ax,%ax

80107210 <kvmalloc>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107216:	e8 75 ff ff ff       	call   80107190 <setupkvm>
8010721b:	a3 e4 49 11 80       	mov    %eax,0x801149e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107220:	05 00 00 00 80       	add    $0x80000000,%eax
80107225:	0f 22 d8             	mov    %eax,%cr3
}
80107228:	c9                   	leave  
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107230 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 08             	sub    $0x8,%esp
80107236:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107239:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010723c:	89 c1                	mov    %eax,%ecx
8010723e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107241:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107244:	f6 c2 01             	test   $0x1,%dl
80107247:	75 17                	jne    80107260 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107249:	83 ec 0c             	sub    $0xc,%esp
8010724c:	68 4a 7e 10 80       	push   $0x80107e4a
80107251:	e8 2a 91 ff ff       	call   80100380 <panic>
80107256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107260:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107263:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107269:	25 fc 0f 00 00       	and    $0xffc,%eax
8010726e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107275:	85 c0                	test   %eax,%eax
80107277:	74 d0                	je     80107249 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107279:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010727c:	c9                   	leave  
8010727d:	c3                   	ret    
8010727e:	66 90                	xchg   %ax,%ax

80107280 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107289:	e8 02 ff ff ff       	call   80107190 <setupkvm>
8010728e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107291:	85 c0                	test   %eax,%eax
80107293:	0f 84 bd 00 00 00    	je     80107356 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010729c:	85 c9                	test   %ecx,%ecx
8010729e:	0f 84 b2 00 00 00    	je     80107356 <copyuvm+0xd6>
801072a4:	31 f6                	xor    %esi,%esi
801072a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801072b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801072b3:	89 f0                	mov    %esi,%eax
801072b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801072bb:	a8 01                	test   $0x1,%al
801072bd:	75 11                	jne    801072d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072bf:	83 ec 0c             	sub    $0xc,%esp
801072c2:	68 54 7e 10 80       	push   $0x80107e54
801072c7:	e8 b4 90 ff ff       	call   80100380 <panic>
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072d7:	c1 ea 0a             	shr    $0xa,%edx
801072da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072e7:	85 c0                	test   %eax,%eax
801072e9:	74 d4                	je     801072bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072eb:	8b 00                	mov    (%eax),%eax
801072ed:	a8 01                	test   $0x1,%al
801072ef:	0f 84 9f 00 00 00    	je     80107394 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801072f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801072f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801072fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107305:	e8 c6 b6 ff ff       	call   801029d0 <kalloc>
8010730a:	89 c3                	mov    %eax,%ebx
8010730c:	85 c0                	test   %eax,%eax
8010730e:	74 64                	je     80107374 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107310:	83 ec 04             	sub    $0x4,%esp
80107313:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107319:	68 00 10 00 00       	push   $0x1000
8010731e:	57                   	push   %edi
8010731f:	50                   	push   %eax
80107320:	e8 2b d7 ff ff       	call   80104a50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107325:	58                   	pop    %eax
80107326:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010732c:	5a                   	pop    %edx
8010732d:	ff 75 e4             	push   -0x1c(%ebp)
80107330:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107335:	89 f2                	mov    %esi,%edx
80107337:	50                   	push   %eax
80107338:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010733b:	e8 60 f8 ff ff       	call   80106ba0 <mappages>
80107340:	83 c4 10             	add    $0x10,%esp
80107343:	85 c0                	test   %eax,%eax
80107345:	78 21                	js     80107368 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107347:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010734d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107350:	0f 87 5a ff ff ff    	ja     801072b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107356:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010735c:	5b                   	pop    %ebx
8010735d:	5e                   	pop    %esi
8010735e:	5f                   	pop    %edi
8010735f:	5d                   	pop    %ebp
80107360:	c3                   	ret    
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107368:	83 ec 0c             	sub    $0xc,%esp
8010736b:	53                   	push   %ebx
8010736c:	e8 9f b4 ff ff       	call   80102810 <kfree>
      goto bad;
80107371:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107374:	83 ec 0c             	sub    $0xc,%esp
80107377:	ff 75 e0             	push   -0x20(%ebp)
8010737a:	e8 91 fd ff ff       	call   80107110 <freevm>
  return 0;
8010737f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107386:	83 c4 10             	add    $0x10,%esp
}
80107389:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010738c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010738f:	5b                   	pop    %ebx
80107390:	5e                   	pop    %esi
80107391:	5f                   	pop    %edi
80107392:	5d                   	pop    %ebp
80107393:	c3                   	ret    
      panic("copyuvm: page not present");
80107394:	83 ec 0c             	sub    $0xc,%esp
80107397:	68 6e 7e 10 80       	push   $0x80107e6e
8010739c:	e8 df 8f ff ff       	call   80100380 <panic>
801073a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop

801073b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073b9:	89 c1                	mov    %eax,%ecx
801073bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073c1:	f6 c2 01             	test   $0x1,%dl
801073c4:	0f 84 00 01 00 00    	je     801074ca <uva2ka.cold>
  return &pgtab[PTX(va)];
801073ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801073d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801073d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801073e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073ea:	05 00 00 00 80       	add    $0x80000000,%eax
801073ef:	83 fa 05             	cmp    $0x5,%edx
801073f2:	ba 00 00 00 00       	mov    $0x0,%edx
801073f7:	0f 45 c2             	cmovne %edx,%eax
}
801073fa:	c3                   	ret    
801073fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop

80107400 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 0c             	sub    $0xc,%esp
80107409:	8b 75 14             	mov    0x14(%ebp),%esi
8010740c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010740f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107412:	85 f6                	test   %esi,%esi
80107414:	75 51                	jne    80107467 <copyout+0x67>
80107416:	e9 a5 00 00 00       	jmp    801074c0 <copyout+0xc0>
8010741b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010741f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107426:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010742c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107432:	74 75                	je     801074a9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107434:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107436:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107439:	29 c3                	sub    %eax,%ebx
8010743b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107441:	39 f3                	cmp    %esi,%ebx
80107443:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107446:	29 f8                	sub    %edi,%eax
80107448:	83 ec 04             	sub    $0x4,%esp
8010744b:	01 c1                	add    %eax,%ecx
8010744d:	53                   	push   %ebx
8010744e:	52                   	push   %edx
8010744f:	51                   	push   %ecx
80107450:	e8 fb d5 ff ff       	call   80104a50 <memmove>
    len -= n;
    buf += n;
80107455:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107458:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010745e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107461:	01 da                	add    %ebx,%edx
  while(len > 0){
80107463:	29 de                	sub    %ebx,%esi
80107465:	74 59                	je     801074c0 <copyout+0xc0>
  if(*pde & PTE_P){
80107467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010746a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010746c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010746e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107471:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107477:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010747a:	f6 c1 01             	test   $0x1,%cl
8010747d:	0f 84 4e 00 00 00    	je     801074d1 <copyout.cold>
  return &pgtab[PTX(va)];
80107483:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107485:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010748b:	c1 eb 0c             	shr    $0xc,%ebx
8010748e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107494:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010749b:	89 d9                	mov    %ebx,%ecx
8010749d:	83 e1 05             	and    $0x5,%ecx
801074a0:	83 f9 05             	cmp    $0x5,%ecx
801074a3:	0f 84 77 ff ff ff    	je     80107420 <copyout+0x20>
  }
  return 0;
}
801074a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074b1:	5b                   	pop    %ebx
801074b2:	5e                   	pop    %esi
801074b3:	5f                   	pop    %edi
801074b4:	5d                   	pop    %ebp
801074b5:	c3                   	ret    
801074b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bd:	8d 76 00             	lea    0x0(%esi),%esi
801074c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074c3:	31 c0                	xor    %eax,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    

801074ca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801074ca:	a1 00 00 00 00       	mov    0x0,%eax
801074cf:	0f 0b                	ud2    

801074d1 <copyout.cold>:
801074d1:	a1 00 00 00 00       	mov    0x0,%eax
801074d6:	0f 0b                	ud2    
