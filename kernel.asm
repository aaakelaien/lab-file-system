
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	14010113          	addi	sp,sp,320 # 80019140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	175050ef          	jal	ra,8000598a <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	21078793          	addi	a5,a5,528 # 80021240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	316080e7          	jalr	790(ra) # 80006370 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3b6080e7          	jalr	950(ra) # 80006424 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	daa080e7          	jalr	-598(ra) # 80005e34 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	1ec080e7          	jalr	492(ra) # 800062e0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00021517          	auipc	a0,0x21
    80000104:	14050513          	addi	a0,a0,320 # 80021240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	244080e7          	jalr	580(ra) # 80006370 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2e0080e7          	jalr	736(ra) # 80006424 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2b6080e7          	jalr	694(ra) # 80006424 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	af0080e7          	jalr	-1296(ra) # 80000e16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00009717          	auipc	a4,0x9
    80000332:	cd270713          	addi	a4,a4,-814 # 80009000 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ad4080e7          	jalr	-1324(ra) # 80000e16 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	b2a080e7          	jalr	-1238(ra) # 80005e7e <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	72e080e7          	jalr	1838(ra) # 80001a92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	ff4080e7          	jalr	-12(ra) # 80005360 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fdc080e7          	jalr	-36(ra) # 80001350 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	9ca080e7          	jalr	-1590(ra) # 80005d46 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	cda080e7          	jalr	-806(ra) # 8000605e <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	aea080e7          	jalr	-1302(ra) # 80005e7e <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	ada080e7          	jalr	-1318(ra) # 80005e7e <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	aca080e7          	jalr	-1334(ra) # 80005e7e <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	322080e7          	jalr	802(ra) # 800006e6 <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	992080e7          	jalr	-1646(ra) # 80000d66 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	68e080e7          	jalr	1678(ra) # 80001a6a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6ae080e7          	jalr	1710(ra) # 80001a92 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	f5e080e7          	jalr	-162(ra) # 8000534a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f6c080e7          	jalr	-148(ra) # 80005360 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	dd6080e7          	jalr	-554(ra) # 800021d2 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	528080e7          	jalr	1320(ra) # 8000292c <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	57a080e7          	jalr	1402(ra) # 80003986 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	06e080e7          	jalr	110(ra) # 80005482 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	cfe080e7          	jalr	-770(ra) # 8000111a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00009717          	auipc	a4,0x9
    8000042e:	bcf72b23          	sw	a5,-1066(a4) # 80009000 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043a:	00009797          	auipc	a5,0x9
    8000043e:	bce7b783          	ld	a5,-1074(a5) # 80009008 <kernel_pagetable>
    80000442:	83b1                	srli	a5,a5,0xc
    80000444:	577d                	li	a4,-1
    80000446:	177e                	slli	a4,a4,0x3f
    80000448:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000044e:	12000073          	sfence.vma
  sfence_vma();
}
    80000452:	6422                	ld	s0,8(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret

0000000080000458 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000458:	7139                	addi	sp,sp,-64
    8000045a:	fc06                	sd	ra,56(sp)
    8000045c:	f822                	sd	s0,48(sp)
    8000045e:	f426                	sd	s1,40(sp)
    80000460:	f04a                	sd	s2,32(sp)
    80000462:	ec4e                	sd	s3,24(sp)
    80000464:	e852                	sd	s4,16(sp)
    80000466:	e456                	sd	s5,8(sp)
    80000468:	e05a                	sd	s6,0(sp)
    8000046a:	0080                	addi	s0,sp,64
    8000046c:	84aa                	mv	s1,a0
    8000046e:	89ae                	mv	s3,a1
    80000470:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000472:	57fd                	li	a5,-1
    80000474:	83e9                	srli	a5,a5,0x1a
    80000476:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000478:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047a:	04b7f263          	bgeu	a5,a1,800004be <walk+0x66>
    panic("walk");
    8000047e:	00008517          	auipc	a0,0x8
    80000482:	bd250513          	addi	a0,a0,-1070 # 80008050 <etext+0x50>
    80000486:	00006097          	auipc	ra,0x6
    8000048a:	9ae080e7          	jalr	-1618(ra) # 80005e34 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048e:	060a8663          	beqz	s5,800004fa <walk+0xa2>
    80000492:	00000097          	auipc	ra,0x0
    80000496:	c86080e7          	jalr	-890(ra) # 80000118 <kalloc>
    8000049a:	84aa                	mv	s1,a0
    8000049c:	c529                	beqz	a0,800004e6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049e:	6605                	lui	a2,0x1
    800004a0:	4581                	li	a1,0
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	cd6080e7          	jalr	-810(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004aa:	00c4d793          	srli	a5,s1,0xc
    800004ae:	07aa                	slli	a5,a5,0xa
    800004b0:	0017e793          	ori	a5,a5,1
    800004b4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b8:	3a5d                	addiw	s4,s4,-9
    800004ba:	036a0063          	beq	s4,s6,800004da <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004be:	0149d933          	srl	s2,s3,s4
    800004c2:	1ff97913          	andi	s2,s2,511
    800004c6:	090e                	slli	s2,s2,0x3
    800004c8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ca:	00093483          	ld	s1,0(s2)
    800004ce:	0014f793          	andi	a5,s1,1
    800004d2:	dfd5                	beqz	a5,8000048e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d4:	80a9                	srli	s1,s1,0xa
    800004d6:	04b2                	slli	s1,s1,0xc
    800004d8:	b7c5                	j	800004b8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004da:	00c9d513          	srli	a0,s3,0xc
    800004de:	1ff57513          	andi	a0,a0,511
    800004e2:	050e                	slli	a0,a0,0x3
    800004e4:	9526                	add	a0,a0,s1
}
    800004e6:	70e2                	ld	ra,56(sp)
    800004e8:	7442                	ld	s0,48(sp)
    800004ea:	74a2                	ld	s1,40(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	69e2                	ld	s3,24(sp)
    800004f0:	6a42                	ld	s4,16(sp)
    800004f2:	6aa2                	ld	s5,8(sp)
    800004f4:	6b02                	ld	s6,0(sp)
    800004f6:	6121                	addi	sp,sp,64
    800004f8:	8082                	ret
        return 0;
    800004fa:	4501                	li	a0,0
    800004fc:	b7ed                	j	800004e6 <walk+0x8e>

00000000800004fe <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fe:	57fd                	li	a5,-1
    80000500:	83e9                	srli	a5,a5,0x1a
    80000502:	00b7f463          	bgeu	a5,a1,8000050a <walkaddr+0xc>
    return 0;
    80000506:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000508:	8082                	ret
{
    8000050a:	1141                	addi	sp,sp,-16
    8000050c:	e406                	sd	ra,8(sp)
    8000050e:	e022                	sd	s0,0(sp)
    80000510:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000512:	4601                	li	a2,0
    80000514:	00000097          	auipc	ra,0x0
    80000518:	f44080e7          	jalr	-188(ra) # 80000458 <walk>
  if(pte == 0)
    8000051c:	c105                	beqz	a0,8000053c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000520:	0117f693          	andi	a3,a5,17
    80000524:	4745                	li	a4,17
    return 0;
    80000526:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000528:	00e68663          	beq	a3,a4,80000534 <walkaddr+0x36>
}
    8000052c:	60a2                	ld	ra,8(sp)
    8000052e:	6402                	ld	s0,0(sp)
    80000530:	0141                	addi	sp,sp,16
    80000532:	8082                	ret
  pa = PTE2PA(*pte);
    80000534:	00a7d513          	srli	a0,a5,0xa
    80000538:	0532                	slli	a0,a0,0xc
  return pa;
    8000053a:	bfcd                	j	8000052c <walkaddr+0x2e>
    return 0;
    8000053c:	4501                	li	a0,0
    8000053e:	b7fd                	j	8000052c <walkaddr+0x2e>

0000000080000540 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000540:	715d                	addi	sp,sp,-80
    80000542:	e486                	sd	ra,72(sp)
    80000544:	e0a2                	sd	s0,64(sp)
    80000546:	fc26                	sd	s1,56(sp)
    80000548:	f84a                	sd	s2,48(sp)
    8000054a:	f44e                	sd	s3,40(sp)
    8000054c:	f052                	sd	s4,32(sp)
    8000054e:	ec56                	sd	s5,24(sp)
    80000550:	e85a                	sd	s6,16(sp)
    80000552:	e45e                	sd	s7,8(sp)
    80000554:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000556:	c639                	beqz	a2,800005a4 <mappages+0x64>
    80000558:	8aaa                	mv	s5,a0
    8000055a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055c:	77fd                	lui	a5,0xfffff
    8000055e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000562:	15fd                	addi	a1,a1,-1
    80000564:	00c589b3          	add	s3,a1,a2
    80000568:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000056c:	8952                	mv	s2,s4
    8000056e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000572:	6b85                	lui	s7,0x1
    80000574:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000578:	4605                	li	a2,1
    8000057a:	85ca                	mv	a1,s2
    8000057c:	8556                	mv	a0,s5
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	eda080e7          	jalr	-294(ra) # 80000458 <walk>
    80000586:	cd1d                	beqz	a0,800005c4 <mappages+0x84>
    if(*pte & PTE_V)
    80000588:	611c                	ld	a5,0(a0)
    8000058a:	8b85                	andi	a5,a5,1
    8000058c:	e785                	bnez	a5,800005b4 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000058e:	80b1                	srli	s1,s1,0xc
    80000590:	04aa                	slli	s1,s1,0xa
    80000592:	0164e4b3          	or	s1,s1,s6
    80000596:	0014e493          	ori	s1,s1,1
    8000059a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059c:	05390063          	beq	s2,s3,800005dc <mappages+0x9c>
    a += PGSIZE;
    800005a0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a2:	bfc9                	j	80000574 <mappages+0x34>
    panic("mappages: size");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ab450513          	addi	a0,a0,-1356 # 80008058 <etext+0x58>
    800005ac:	00006097          	auipc	ra,0x6
    800005b0:	888080e7          	jalr	-1912(ra) # 80005e34 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ab450513          	addi	a0,a0,-1356 # 80008068 <etext+0x68>
    800005bc:	00006097          	auipc	ra,0x6
    800005c0:	878080e7          	jalr	-1928(ra) # 80005e34 <panic>
      return -1;
    800005c4:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c6:	60a6                	ld	ra,72(sp)
    800005c8:	6406                	ld	s0,64(sp)
    800005ca:	74e2                	ld	s1,56(sp)
    800005cc:	7942                	ld	s2,48(sp)
    800005ce:	79a2                	ld	s3,40(sp)
    800005d0:	7a02                	ld	s4,32(sp)
    800005d2:	6ae2                	ld	s5,24(sp)
    800005d4:	6b42                	ld	s6,16(sp)
    800005d6:	6ba2                	ld	s7,8(sp)
    800005d8:	6161                	addi	sp,sp,80
    800005da:	8082                	ret
  return 0;
    800005dc:	4501                	li	a0,0
    800005de:	b7e5                	j	800005c6 <mappages+0x86>

00000000800005e0 <kvmmap>:
{
    800005e0:	1141                	addi	sp,sp,-16
    800005e2:	e406                	sd	ra,8(sp)
    800005e4:	e022                	sd	s0,0(sp)
    800005e6:	0800                	addi	s0,sp,16
    800005e8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ea:	86b2                	mv	a3,a2
    800005ec:	863e                	mv	a2,a5
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	f52080e7          	jalr	-174(ra) # 80000540 <mappages>
    800005f6:	e509                	bnez	a0,80000600 <kvmmap+0x20>
}
    800005f8:	60a2                	ld	ra,8(sp)
    800005fa:	6402                	ld	s0,0(sp)
    800005fc:	0141                	addi	sp,sp,16
    800005fe:	8082                	ret
    panic("kvmmap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a7850513          	addi	a0,a0,-1416 # 80008078 <etext+0x78>
    80000608:	00006097          	auipc	ra,0x6
    8000060c:	82c080e7          	jalr	-2004(ra) # 80005e34 <panic>

0000000080000610 <kvmmake>:
{
    80000610:	1101                	addi	sp,sp,-32
    80000612:	ec06                	sd	ra,24(sp)
    80000614:	e822                	sd	s0,16(sp)
    80000616:	e426                	sd	s1,8(sp)
    80000618:	e04a                	sd	s2,0(sp)
    8000061a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	afc080e7          	jalr	-1284(ra) # 80000118 <kalloc>
    80000624:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000626:	6605                	lui	a2,0x1
    80000628:	4581                	li	a1,0
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	b4e080e7          	jalr	-1202(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000632:	4719                	li	a4,6
    80000634:	6685                	lui	a3,0x1
    80000636:	10000637          	lui	a2,0x10000
    8000063a:	100005b7          	lui	a1,0x10000
    8000063e:	8526                	mv	a0,s1
    80000640:	00000097          	auipc	ra,0x0
    80000644:	fa0080e7          	jalr	-96(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000648:	4719                	li	a4,6
    8000064a:	6685                	lui	a3,0x1
    8000064c:	10001637          	lui	a2,0x10001
    80000650:	100015b7          	lui	a1,0x10001
    80000654:	8526                	mv	a0,s1
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	f8a080e7          	jalr	-118(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000065e:	4719                	li	a4,6
    80000660:	004006b7          	lui	a3,0x400
    80000664:	0c000637          	lui	a2,0xc000
    80000668:	0c0005b7          	lui	a1,0xc000
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	f72080e7          	jalr	-142(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000676:	00008917          	auipc	s2,0x8
    8000067a:	98a90913          	addi	s2,s2,-1654 # 80008000 <etext>
    8000067e:	4729                	li	a4,10
    80000680:	80008697          	auipc	a3,0x80008
    80000684:	98068693          	addi	a3,a3,-1664 # 8000 <_entry-0x7fff8000>
    80000688:	4605                	li	a2,1
    8000068a:	067e                	slli	a2,a2,0x1f
    8000068c:	85b2                	mv	a1,a2
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f50080e7          	jalr	-176(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000698:	4719                	li	a4,6
    8000069a:	46c5                	li	a3,17
    8000069c:	06ee                	slli	a3,a3,0x1b
    8000069e:	412686b3          	sub	a3,a3,s2
    800006a2:	864a                	mv	a2,s2
    800006a4:	85ca                	mv	a1,s2
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f38080e7          	jalr	-200(ra) # 800005e0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b0:	4729                	li	a4,10
    800006b2:	6685                	lui	a3,0x1
    800006b4:	00007617          	auipc	a2,0x7
    800006b8:	94c60613          	addi	a2,a2,-1716 # 80007000 <_trampoline>
    800006bc:	040005b7          	lui	a1,0x4000
    800006c0:	15fd                	addi	a1,a1,-1
    800006c2:	05b2                	slli	a1,a1,0xc
    800006c4:	8526                	mv	a0,s1
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f1a080e7          	jalr	-230(ra) # 800005e0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006ce:	8526                	mv	a0,s1
    800006d0:	00000097          	auipc	ra,0x0
    800006d4:	600080e7          	jalr	1536(ra) # 80000cd0 <proc_mapstacks>
}
    800006d8:	8526                	mv	a0,s1
    800006da:	60e2                	ld	ra,24(sp)
    800006dc:	6442                	ld	s0,16(sp)
    800006de:	64a2                	ld	s1,8(sp)
    800006e0:	6902                	ld	s2,0(sp)
    800006e2:	6105                	addi	sp,sp,32
    800006e4:	8082                	ret

00000000800006e6 <kvminit>:
{
    800006e6:	1141                	addi	sp,sp,-16
    800006e8:	e406                	sd	ra,8(sp)
    800006ea:	e022                	sd	s0,0(sp)
    800006ec:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	f22080e7          	jalr	-222(ra) # 80000610 <kvmmake>
    800006f6:	00009797          	auipc	a5,0x9
    800006fa:	90a7b923          	sd	a0,-1774(a5) # 80009008 <kernel_pagetable>
}
    800006fe:	60a2                	ld	ra,8(sp)
    80000700:	6402                	ld	s0,0(sp)
    80000702:	0141                	addi	sp,sp,16
    80000704:	8082                	ret

0000000080000706 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000706:	715d                	addi	sp,sp,-80
    80000708:	e486                	sd	ra,72(sp)
    8000070a:	e0a2                	sd	s0,64(sp)
    8000070c:	fc26                	sd	s1,56(sp)
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071c:	03459793          	slli	a5,a1,0x34
    80000720:	e795                	bnez	a5,8000074c <uvmunmap+0x46>
    80000722:	8a2a                	mv	s4,a0
    80000724:	892e                	mv	s2,a1
    80000726:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	0632                	slli	a2,a2,0xc
    8000072a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000072e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	6b05                	lui	s6,0x1
    80000732:	0735e263          	bltu	a1,s3,80000796 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	74e2                	ld	s1,56(sp)
    8000073c:	7942                	ld	s2,48(sp)
    8000073e:	79a2                	ld	s3,40(sp)
    80000740:	7a02                	ld	s4,32(sp)
    80000742:	6ae2                	ld	s5,24(sp)
    80000744:	6b42                	ld	s6,16(sp)
    80000746:	6ba2                	ld	s7,8(sp)
    80000748:	6161                	addi	sp,sp,80
    8000074a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074c:	00008517          	auipc	a0,0x8
    80000750:	93450513          	addi	a0,a0,-1740 # 80008080 <etext+0x80>
    80000754:	00005097          	auipc	ra,0x5
    80000758:	6e0080e7          	jalr	1760(ra) # 80005e34 <panic>
      panic("uvmunmap: walk");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	93c50513          	addi	a0,a0,-1732 # 80008098 <etext+0x98>
    80000764:	00005097          	auipc	ra,0x5
    80000768:	6d0080e7          	jalr	1744(ra) # 80005e34 <panic>
      panic("uvmunmap: not mapped");
    8000076c:	00008517          	auipc	a0,0x8
    80000770:	93c50513          	addi	a0,a0,-1732 # 800080a8 <etext+0xa8>
    80000774:	00005097          	auipc	ra,0x5
    80000778:	6c0080e7          	jalr	1728(ra) # 80005e34 <panic>
      panic("uvmunmap: not a leaf");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	6b0080e7          	jalr	1712(ra) # 80005e34 <panic>
    *pte = 0;
    8000078c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000790:	995a                	add	s2,s2,s6
    80000792:	fb3972e3          	bgeu	s2,s3,80000736 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000796:	4601                	li	a2,0
    80000798:	85ca                	mv	a1,s2
    8000079a:	8552                	mv	a0,s4
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	cbc080e7          	jalr	-836(ra) # 80000458 <walk>
    800007a4:	84aa                	mv	s1,a0
    800007a6:	d95d                	beqz	a0,8000075c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007a8:	6108                	ld	a0,0(a0)
    800007aa:	00157793          	andi	a5,a0,1
    800007ae:	dfdd                	beqz	a5,8000076c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b0:	3ff57793          	andi	a5,a0,1023
    800007b4:	fd7784e3          	beq	a5,s7,8000077c <uvmunmap+0x76>
    if(do_free){
    800007b8:	fc0a8ae3          	beqz	s5,8000078c <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    800007c8:	b7d1                	j	8000078c <uvmunmap+0x86>

00000000800007ca <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ca:	1101                	addi	sp,sp,-32
    800007cc:	ec06                	sd	ra,24(sp)
    800007ce:	e822                	sd	s0,16(sp)
    800007d0:	e426                	sd	s1,8(sp)
    800007d2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	944080e7          	jalr	-1724(ra) # 80000118 <kalloc>
    800007dc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007de:	c519                	beqz	a0,800007ec <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e0:	6605                	lui	a2,0x1
    800007e2:	4581                	li	a1,0
    800007e4:	00000097          	auipc	ra,0x0
    800007e8:	994080e7          	jalr	-1644(ra) # 80000178 <memset>
  return pagetable;
}
    800007ec:	8526                	mv	a0,s1
    800007ee:	60e2                	ld	ra,24(sp)
    800007f0:	6442                	ld	s0,16(sp)
    800007f2:	64a2                	ld	s1,8(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f8:	7179                	addi	sp,sp,-48
    800007fa:	f406                	sd	ra,40(sp)
    800007fc:	f022                	sd	s0,32(sp)
    800007fe:	ec26                	sd	s1,24(sp)
    80000800:	e84a                	sd	s2,16(sp)
    80000802:	e44e                	sd	s3,8(sp)
    80000804:	e052                	sd	s4,0(sp)
    80000806:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000808:	6785                	lui	a5,0x1
    8000080a:	04f67863          	bgeu	a2,a5,8000085a <uvminit+0x62>
    8000080e:	8a2a                	mv	s4,a0
    80000810:	89ae                	mv	s3,a1
    80000812:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	904080e7          	jalr	-1788(ra) # 80000118 <kalloc>
    8000081c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000081e:	6605                	lui	a2,0x1
    80000820:	4581                	li	a1,0
    80000822:	00000097          	auipc	ra,0x0
    80000826:	956080e7          	jalr	-1706(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082a:	4779                	li	a4,30
    8000082c:	86ca                	mv	a3,s2
    8000082e:	6605                	lui	a2,0x1
    80000830:	4581                	li	a1,0
    80000832:	8552                	mv	a0,s4
    80000834:	00000097          	auipc	ra,0x0
    80000838:	d0c080e7          	jalr	-756(ra) # 80000540 <mappages>
  memmove(mem, src, sz);
    8000083c:	8626                	mv	a2,s1
    8000083e:	85ce                	mv	a1,s3
    80000840:	854a                	mv	a0,s2
    80000842:	00000097          	auipc	ra,0x0
    80000846:	992080e7          	jalr	-1646(ra) # 800001d4 <memmove>
}
    8000084a:	70a2                	ld	ra,40(sp)
    8000084c:	7402                	ld	s0,32(sp)
    8000084e:	64e2                	ld	s1,24(sp)
    80000850:	6942                	ld	s2,16(sp)
    80000852:	69a2                	ld	s3,8(sp)
    80000854:	6a02                	ld	s4,0(sp)
    80000856:	6145                	addi	sp,sp,48
    80000858:	8082                	ret
    panic("inituvm: more than a page");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	87e50513          	addi	a0,a0,-1922 # 800080d8 <etext+0xd8>
    80000862:	00005097          	auipc	ra,0x5
    80000866:	5d2080e7          	jalr	1490(ra) # 80005e34 <panic>

000000008000086a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086a:	1101                	addi	sp,sp,-32
    8000086c:	ec06                	sd	ra,24(sp)
    8000086e:	e822                	sd	s0,16(sp)
    80000870:	e426                	sd	s1,8(sp)
    80000872:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000874:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000876:	00b67d63          	bgeu	a2,a1,80000890 <uvmdealloc+0x26>
    8000087a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087c:	6785                	lui	a5,0x1
    8000087e:	17fd                	addi	a5,a5,-1
    80000880:	00f60733          	add	a4,a2,a5
    80000884:	767d                	lui	a2,0xfffff
    80000886:	8f71                	and	a4,a4,a2
    80000888:	97ae                	add	a5,a5,a1
    8000088a:	8ff1                	and	a5,a5,a2
    8000088c:	00f76863          	bltu	a4,a5,8000089c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000890:	8526                	mv	a0,s1
    80000892:	60e2                	ld	ra,24(sp)
    80000894:	6442                	ld	s0,16(sp)
    80000896:	64a2                	ld	s1,8(sp)
    80000898:	6105                	addi	sp,sp,32
    8000089a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089c:	8f99                	sub	a5,a5,a4
    8000089e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a0:	4685                	li	a3,1
    800008a2:	0007861b          	sext.w	a2,a5
    800008a6:	85ba                	mv	a1,a4
    800008a8:	00000097          	auipc	ra,0x0
    800008ac:	e5e080e7          	jalr	-418(ra) # 80000706 <uvmunmap>
    800008b0:	b7c5                	j	80000890 <uvmdealloc+0x26>

00000000800008b2 <uvmalloc>:
  if(newsz < oldsz)
    800008b2:	0ab66163          	bltu	a2,a1,80000954 <uvmalloc+0xa2>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f063          	bgeu	s3,a2,80000958 <uvmalloc+0xa6>
    800008dc:	894e                	mv	s2,s3
    mem = kalloc();
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	83a080e7          	jalr	-1990(ra) # 80000118 <kalloc>
    800008e6:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e8:	c51d                	beqz	a0,80000916 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ea:	6605                	lui	a2,0x1
    800008ec:	4581                	li	a1,0
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	88a080e7          	jalr	-1910(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f6:	4779                	li	a4,30
    800008f8:	86a6                	mv	a3,s1
    800008fa:	6605                	lui	a2,0x1
    800008fc:	85ca                	mv	a1,s2
    800008fe:	8556                	mv	a0,s5
    80000900:	00000097          	auipc	ra,0x0
    80000904:	c40080e7          	jalr	-960(ra) # 80000540 <mappages>
    80000908:	e905                	bnez	a0,80000938 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	6785                	lui	a5,0x1
    8000090c:	993e                	add	s2,s2,a5
    8000090e:	fd4968e3          	bltu	s2,s4,800008de <uvmalloc+0x2c>
  return newsz;
    80000912:	8552                	mv	a0,s4
    80000914:	a809                	j	80000926 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000916:	864e                	mv	a2,s3
    80000918:	85ca                	mv	a1,s2
    8000091a:	8556                	mv	a0,s5
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	f4e080e7          	jalr	-178(ra) # 8000086a <uvmdealloc>
      return 0;
    80000924:	4501                	li	a0,0
}
    80000926:	70e2                	ld	ra,56(sp)
    80000928:	7442                	ld	s0,48(sp)
    8000092a:	74a2                	ld	s1,40(sp)
    8000092c:	7902                	ld	s2,32(sp)
    8000092e:	69e2                	ld	s3,24(sp)
    80000930:	6a42                	ld	s4,16(sp)
    80000932:	6aa2                	ld	s5,8(sp)
    80000934:	6121                	addi	sp,sp,64
    80000936:	8082                	ret
      kfree(mem);
    80000938:	8526                	mv	a0,s1
    8000093a:	fffff097          	auipc	ra,0xfffff
    8000093e:	6e2080e7          	jalr	1762(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f22080e7          	jalr	-222(ra) # 8000086a <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
    80000952:	bfd1                	j	80000926 <uvmalloc+0x74>
    return oldsz;
    80000954:	852e                	mv	a0,a1
}
    80000956:	8082                	ret
  return newsz;
    80000958:	8532                	mv	a0,a2
    8000095a:	b7f1                	j	80000926 <uvmalloc+0x74>

000000008000095c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095c:	7179                	addi	sp,sp,-48
    8000095e:	f406                	sd	ra,40(sp)
    80000960:	f022                	sd	s0,32(sp)
    80000962:	ec26                	sd	s1,24(sp)
    80000964:	e84a                	sd	s2,16(sp)
    80000966:	e44e                	sd	s3,8(sp)
    80000968:	e052                	sd	s4,0(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096e:	84aa                	mv	s1,a0
    80000970:	6905                	lui	s2,0x1
    80000972:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000974:	4985                	li	s3,1
    80000976:	a821                	j	8000098e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000978:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000097a:	0532                	slli	a0,a0,0xc
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	fe0080e7          	jalr	-32(ra) # 8000095c <freewalk>
      pagetable[i] = 0;
    80000984:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000988:	04a1                	addi	s1,s1,8
    8000098a:	03248163          	beq	s1,s2,800009ac <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000098e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000990:	00f57793          	andi	a5,a0,15
    80000994:	ff3782e3          	beq	a5,s3,80000978 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000998:	8905                	andi	a0,a0,1
    8000099a:	d57d                	beqz	a0,80000988 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099c:	00007517          	auipc	a0,0x7
    800009a0:	75c50513          	addi	a0,a0,1884 # 800080f8 <etext+0xf8>
    800009a4:	00005097          	auipc	ra,0x5
    800009a8:	490080e7          	jalr	1168(ra) # 80005e34 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ac:	8552                	mv	a0,s4
    800009ae:	fffff097          	auipc	ra,0xfffff
    800009b2:	66e080e7          	jalr	1646(ra) # 8000001c <kfree>
}
    800009b6:	70a2                	ld	ra,40(sp)
    800009b8:	7402                	ld	s0,32(sp)
    800009ba:	64e2                	ld	s1,24(sp)
    800009bc:	6942                	ld	s2,16(sp)
    800009be:	69a2                	ld	s3,8(sp)
    800009c0:	6a02                	ld	s4,0(sp)
    800009c2:	6145                	addi	sp,sp,48
    800009c4:	8082                	ret

00000000800009c6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c6:	1101                	addi	sp,sp,-32
    800009c8:	ec06                	sd	ra,24(sp)
    800009ca:	e822                	sd	s0,16(sp)
    800009cc:	e426                	sd	s1,8(sp)
    800009ce:	1000                	addi	s0,sp,32
    800009d0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d2:	e999                	bnez	a1,800009e8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f86080e7          	jalr	-122(ra) # 8000095c <freewalk>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e8:	6605                	lui	a2,0x1
    800009ea:	167d                	addi	a2,a2,-1
    800009ec:	962e                	add	a2,a2,a1
    800009ee:	4685                	li	a3,1
    800009f0:	8231                	srli	a2,a2,0xc
    800009f2:	4581                	li	a1,0
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	d12080e7          	jalr	-750(ra) # 80000706 <uvmunmap>
    800009fc:	bfe1                	j	800009d4 <uvmfree+0xe>

00000000800009fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009fe:	c679                	beqz	a2,80000acc <uvmcopy+0xce>
{
    80000a00:	715d                	addi	sp,sp,-80
    80000a02:	e486                	sd	ra,72(sp)
    80000a04:	e0a2                	sd	s0,64(sp)
    80000a06:	fc26                	sd	s1,56(sp)
    80000a08:	f84a                	sd	s2,48(sp)
    80000a0a:	f44e                	sd	s3,40(sp)
    80000a0c:	f052                	sd	s4,32(sp)
    80000a0e:	ec56                	sd	s5,24(sp)
    80000a10:	e85a                	sd	s6,16(sp)
    80000a12:	e45e                	sd	s7,8(sp)
    80000a14:	0880                	addi	s0,sp,80
    80000a16:	8b2a                	mv	s6,a0
    80000a18:	8aae                	mv	s5,a1
    80000a1a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a1e:	4601                	li	a2,0
    80000a20:	85ce                	mv	a1,s3
    80000a22:	855a                	mv	a0,s6
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	a34080e7          	jalr	-1484(ra) # 80000458 <walk>
    80000a2c:	c531                	beqz	a0,80000a78 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a2e:	6118                	ld	a4,0(a0)
    80000a30:	00177793          	andi	a5,a4,1
    80000a34:	cbb1                	beqz	a5,80000a88 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a36:	00a75593          	srli	a1,a4,0xa
    80000a3a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a3e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	6d6080e7          	jalr	1750(ra) # 80000118 <kalloc>
    80000a4a:	892a                	mv	s2,a0
    80000a4c:	c939                	beqz	a0,80000aa2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a4e:	6605                	lui	a2,0x1
    80000a50:	85de                	mv	a1,s7
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	782080e7          	jalr	1922(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a5a:	8726                	mv	a4,s1
    80000a5c:	86ca                	mv	a3,s2
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85ce                	mv	a1,s3
    80000a62:	8556                	mv	a0,s5
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	adc080e7          	jalr	-1316(ra) # 80000540 <mappages>
    80000a6c:	e515                	bnez	a0,80000a98 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	99be                	add	s3,s3,a5
    80000a72:	fb49e6e3          	bltu	s3,s4,80000a1e <uvmcopy+0x20>
    80000a76:	a081                	j	80000ab6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	69050513          	addi	a0,a0,1680 # 80008108 <etext+0x108>
    80000a80:	00005097          	auipc	ra,0x5
    80000a84:	3b4080e7          	jalr	948(ra) # 80005e34 <panic>
      panic("uvmcopy: page not present");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	6a050513          	addi	a0,a0,1696 # 80008128 <etext+0x128>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	3a4080e7          	jalr	932(ra) # 80005e34 <panic>
      kfree(mem);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	00c9d613          	srli	a2,s3,0xc
    80000aa8:	4581                	li	a1,0
    80000aaa:	8556                	mv	a0,s5
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	c5a080e7          	jalr	-934(ra) # 80000706 <uvmunmap>
  return -1;
    80000ab4:	557d                	li	a0,-1
}
    80000ab6:	60a6                	ld	ra,72(sp)
    80000ab8:	6406                	ld	s0,64(sp)
    80000aba:	74e2                	ld	s1,56(sp)
    80000abc:	7942                	ld	s2,48(sp)
    80000abe:	79a2                	ld	s3,40(sp)
    80000ac0:	7a02                	ld	s4,32(sp)
    80000ac2:	6ae2                	ld	s5,24(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	6ba2                	ld	s7,8(sp)
    80000ac8:	6161                	addi	sp,sp,80
    80000aca:	8082                	ret
  return 0;
    80000acc:	4501                	li	a0,0
}
    80000ace:	8082                	ret

0000000080000ad0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad0:	1141                	addi	sp,sp,-16
    80000ad2:	e406                	sd	ra,8(sp)
    80000ad4:	e022                	sd	s0,0(sp)
    80000ad6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad8:	4601                	li	a2,0
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	97e080e7          	jalr	-1666(ra) # 80000458 <walk>
  if(pte == 0)
    80000ae2:	c901                	beqz	a0,80000af2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae4:	611c                	ld	a5,0(a0)
    80000ae6:	9bbd                	andi	a5,a5,-17
    80000ae8:	e11c                	sd	a5,0(a0)
}
    80000aea:	60a2                	ld	ra,8(sp)
    80000aec:	6402                	ld	s0,0(sp)
    80000aee:	0141                	addi	sp,sp,16
    80000af0:	8082                	ret
    panic("uvmclear");
    80000af2:	00007517          	auipc	a0,0x7
    80000af6:	65650513          	addi	a0,a0,1622 # 80008148 <etext+0x148>
    80000afa:	00005097          	auipc	ra,0x5
    80000afe:	33a080e7          	jalr	826(ra) # 80005e34 <panic>

0000000080000b02 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b02:	c6bd                	beqz	a3,80000b70 <copyout+0x6e>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	e062                	sd	s8,0(sp)
    80000b1a:	0880                	addi	s0,sp,80
    80000b1c:	8b2a                	mv	s6,a0
    80000b1e:	8c2e                	mv	s8,a1
    80000b20:	8a32                	mv	s4,a2
    80000b22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b26:	6a85                	lui	s5,0x1
    80000b28:	a015                	j	80000b4c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b2a:	9562                	add	a0,a0,s8
    80000b2c:	0004861b          	sext.w	a2,s1
    80000b30:	85d2                	mv	a1,s4
    80000b32:	41250533          	sub	a0,a0,s2
    80000b36:	fffff097          	auipc	ra,0xfffff
    80000b3a:	69e080e7          	jalr	1694(ra) # 800001d4 <memmove>

    len -= n;
    80000b3e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b42:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b48:	02098263          	beqz	s3,80000b6c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b50:	85ca                	mv	a1,s2
    80000b52:	855a                	mv	a0,s6
    80000b54:	00000097          	auipc	ra,0x0
    80000b58:	9aa080e7          	jalr	-1622(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000b5c:	cd01                	beqz	a0,80000b74 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b5e:	418904b3          	sub	s1,s2,s8
    80000b62:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b64:	fc99f3e3          	bgeu	s3,s1,80000b2a <copyout+0x28>
    80000b68:	84ce                	mv	s1,s3
    80000b6a:	b7c1                	j	80000b2a <copyout+0x28>
  }
  return 0;
    80000b6c:	4501                	li	a0,0
    80000b6e:	a021                	j	80000b76 <copyout+0x74>
    80000b70:	4501                	li	a0,0
}
    80000b72:	8082                	ret
      return -1;
    80000b74:	557d                	li	a0,-1
}
    80000b76:	60a6                	ld	ra,72(sp)
    80000b78:	6406                	ld	s0,64(sp)
    80000b7a:	74e2                	ld	s1,56(sp)
    80000b7c:	7942                	ld	s2,48(sp)
    80000b7e:	79a2                	ld	s3,40(sp)
    80000b80:	7a02                	ld	s4,32(sp)
    80000b82:	6ae2                	ld	s5,24(sp)
    80000b84:	6b42                	ld	s6,16(sp)
    80000b86:	6ba2                	ld	s7,8(sp)
    80000b88:	6c02                	ld	s8,0(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret

0000000080000b8e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b8e:	caa5                	beqz	a3,80000bfe <copyin+0x70>
{
    80000b90:	715d                	addi	sp,sp,-80
    80000b92:	e486                	sd	ra,72(sp)
    80000b94:	e0a2                	sd	s0,64(sp)
    80000b96:	fc26                	sd	s1,56(sp)
    80000b98:	f84a                	sd	s2,48(sp)
    80000b9a:	f44e                	sd	s3,40(sp)
    80000b9c:	f052                	sd	s4,32(sp)
    80000b9e:	ec56                	sd	s5,24(sp)
    80000ba0:	e85a                	sd	s6,16(sp)
    80000ba2:	e45e                	sd	s7,8(sp)
    80000ba4:	e062                	sd	s8,0(sp)
    80000ba6:	0880                	addi	s0,sp,80
    80000ba8:	8b2a                	mv	s6,a0
    80000baa:	8a2e                	mv	s4,a1
    80000bac:	8c32                	mv	s8,a2
    80000bae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb2:	6a85                	lui	s5,0x1
    80000bb4:	a01d                	j	80000bda <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb6:	018505b3          	add	a1,a0,s8
    80000bba:	0004861b          	sext.w	a2,s1
    80000bbe:	412585b3          	sub	a1,a1,s2
    80000bc2:	8552                	mv	a0,s4
    80000bc4:	fffff097          	auipc	ra,0xfffff
    80000bc8:	610080e7          	jalr	1552(ra) # 800001d4 <memmove>

    len -= n;
    80000bcc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bd6:	02098263          	beqz	s3,80000bfa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bda:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bde:	85ca                	mv	a1,s2
    80000be0:	855a                	mv	a0,s6
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	91c080e7          	jalr	-1764(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000bea:	cd01                	beqz	a0,80000c02 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bec:	418904b3          	sub	s1,s2,s8
    80000bf0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf2:	fc99f2e3          	bgeu	s3,s1,80000bb6 <copyin+0x28>
    80000bf6:	84ce                	mv	s1,s3
    80000bf8:	bf7d                	j	80000bb6 <copyin+0x28>
  }
  return 0;
    80000bfa:	4501                	li	a0,0
    80000bfc:	a021                	j	80000c04 <copyin+0x76>
    80000bfe:	4501                	li	a0,0
}
    80000c00:	8082                	ret
      return -1;
    80000c02:	557d                	li	a0,-1
}
    80000c04:	60a6                	ld	ra,72(sp)
    80000c06:	6406                	ld	s0,64(sp)
    80000c08:	74e2                	ld	s1,56(sp)
    80000c0a:	7942                	ld	s2,48(sp)
    80000c0c:	79a2                	ld	s3,40(sp)
    80000c0e:	7a02                	ld	s4,32(sp)
    80000c10:	6ae2                	ld	s5,24(sp)
    80000c12:	6b42                	ld	s6,16(sp)
    80000c14:	6ba2                	ld	s7,8(sp)
    80000c16:	6c02                	ld	s8,0(sp)
    80000c18:	6161                	addi	sp,sp,80
    80000c1a:	8082                	ret

0000000080000c1c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c1c:	c6c5                	beqz	a3,80000cc4 <copyinstr+0xa8>
{
    80000c1e:	715d                	addi	sp,sp,-80
    80000c20:	e486                	sd	ra,72(sp)
    80000c22:	e0a2                	sd	s0,64(sp)
    80000c24:	fc26                	sd	s1,56(sp)
    80000c26:	f84a                	sd	s2,48(sp)
    80000c28:	f44e                	sd	s3,40(sp)
    80000c2a:	f052                	sd	s4,32(sp)
    80000c2c:	ec56                	sd	s5,24(sp)
    80000c2e:	e85a                	sd	s6,16(sp)
    80000c30:	e45e                	sd	s7,8(sp)
    80000c32:	0880                	addi	s0,sp,80
    80000c34:	8a2a                	mv	s4,a0
    80000c36:	8b2e                	mv	s6,a1
    80000c38:	8bb2                	mv	s7,a2
    80000c3a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c3e:	6985                	lui	s3,0x1
    80000c40:	a035                	j	80000c6c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c42:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c46:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c48:	0017b793          	seqz	a5,a5
    80000c4c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c50:	60a6                	ld	ra,72(sp)
    80000c52:	6406                	ld	s0,64(sp)
    80000c54:	74e2                	ld	s1,56(sp)
    80000c56:	7942                	ld	s2,48(sp)
    80000c58:	79a2                	ld	s3,40(sp)
    80000c5a:	7a02                	ld	s4,32(sp)
    80000c5c:	6ae2                	ld	s5,24(sp)
    80000c5e:	6b42                	ld	s6,16(sp)
    80000c60:	6ba2                	ld	s7,8(sp)
    80000c62:	6161                	addi	sp,sp,80
    80000c64:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c66:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6a:	c8a9                	beqz	s1,80000cbc <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c6c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c70:	85ca                	mv	a1,s2
    80000c72:	8552                	mv	a0,s4
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	88a080e7          	jalr	-1910(ra) # 800004fe <walkaddr>
    if(pa0 == 0)
    80000c7c:	c131                	beqz	a0,80000cc0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c7e:	41790833          	sub	a6,s2,s7
    80000c82:	984e                	add	a6,a6,s3
    if(n > max)
    80000c84:	0104f363          	bgeu	s1,a6,80000c8a <copyinstr+0x6e>
    80000c88:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8a:	955e                	add	a0,a0,s7
    80000c8c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c90:	fc080be3          	beqz	a6,80000c66 <copyinstr+0x4a>
    80000c94:	985a                	add	a6,a6,s6
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	14fd                	addi	s1,s1,-1
    80000c9e:	9b26                	add	s6,s6,s1
    80000ca0:	00f60733          	add	a4,a2,a5
    80000ca4:	00074703          	lbu	a4,0(a4)
    80000ca8:	df49                	beqz	a4,80000c42 <copyinstr+0x26>
        *dst = *p;
    80000caa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cae:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb4:	ff0796e3          	bne	a5,a6,80000ca0 <copyinstr+0x84>
      dst++;
    80000cb8:	8b42                	mv	s6,a6
    80000cba:	b775                	j	80000c66 <copyinstr+0x4a>
    80000cbc:	4781                	li	a5,0
    80000cbe:	b769                	j	80000c48 <copyinstr+0x2c>
      return -1;
    80000cc0:	557d                	li	a0,-1
    80000cc2:	b779                	j	80000c50 <copyinstr+0x34>
  int got_null = 0;
    80000cc4:	4781                	li	a5,0
  if(got_null){
    80000cc6:	0017b793          	seqz	a5,a5
    80000cca:	40f00533          	neg	a0,a5
}
    80000cce:	8082                	ret

0000000080000cd0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd0:	7139                	addi	sp,sp,-64
    80000cd2:	fc06                	sd	ra,56(sp)
    80000cd4:	f822                	sd	s0,48(sp)
    80000cd6:	f426                	sd	s1,40(sp)
    80000cd8:	f04a                	sd	s2,32(sp)
    80000cda:	ec4e                	sd	s3,24(sp)
    80000cdc:	e852                	sd	s4,16(sp)
    80000cde:	e456                	sd	s5,8(sp)
    80000ce0:	e05a                	sd	s6,0(sp)
    80000ce2:	0080                	addi	s0,sp,64
    80000ce4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce6:	00008497          	auipc	s1,0x8
    80000cea:	79a48493          	addi	s1,s1,1946 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cee:	8b26                	mv	s6,s1
    80000cf0:	00007a97          	auipc	s5,0x7
    80000cf4:	310a8a93          	addi	s5,s5,784 # 80008000 <etext>
    80000cf8:	04000937          	lui	s2,0x4000
    80000cfc:	197d                	addi	s2,s2,-1
    80000cfe:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d00:	00009a17          	auipc	s4,0x9
    80000d04:	590a0a13          	addi	s4,s4,1424 # 8000a290 <tickslock>
    char *pa = kalloc();
    80000d08:	fffff097          	auipc	ra,0xfffff
    80000d0c:	410080e7          	jalr	1040(ra) # 80000118 <kalloc>
    80000d10:	862a                	mv	a2,a0
    if(pa == 0)
    80000d12:	c131                	beqz	a0,80000d56 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d14:	416485b3          	sub	a1,s1,s6
    80000d18:	858d                	srai	a1,a1,0x3
    80000d1a:	000ab783          	ld	a5,0(s5)
    80000d1e:	02f585b3          	mul	a1,a1,a5
    80000d22:	2585                	addiw	a1,a1,1
    80000d24:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d28:	4719                	li	a4,6
    80000d2a:	6685                	lui	a3,0x1
    80000d2c:	40b905b3          	sub	a1,s2,a1
    80000d30:	854e                	mv	a0,s3
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	8ae080e7          	jalr	-1874(ra) # 800005e0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3a:	16848493          	addi	s1,s1,360
    80000d3e:	fd4495e3          	bne	s1,s4,80000d08 <proc_mapstacks+0x38>
  }
}
    80000d42:	70e2                	ld	ra,56(sp)
    80000d44:	7442                	ld	s0,48(sp)
    80000d46:	74a2                	ld	s1,40(sp)
    80000d48:	7902                	ld	s2,32(sp)
    80000d4a:	69e2                	ld	s3,24(sp)
    80000d4c:	6a42                	ld	s4,16(sp)
    80000d4e:	6aa2                	ld	s5,8(sp)
    80000d50:	6b02                	ld	s6,0(sp)
    80000d52:	6121                	addi	sp,sp,64
    80000d54:	8082                	ret
      panic("kalloc");
    80000d56:	00007517          	auipc	a0,0x7
    80000d5a:	40250513          	addi	a0,a0,1026 # 80008158 <etext+0x158>
    80000d5e:	00005097          	auipc	ra,0x5
    80000d62:	0d6080e7          	jalr	214(ra) # 80005e34 <panic>

0000000080000d66 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d66:	7139                	addi	sp,sp,-64
    80000d68:	fc06                	sd	ra,56(sp)
    80000d6a:	f822                	sd	s0,48(sp)
    80000d6c:	f426                	sd	s1,40(sp)
    80000d6e:	f04a                	sd	s2,32(sp)
    80000d70:	ec4e                	sd	s3,24(sp)
    80000d72:	e852                	sd	s4,16(sp)
    80000d74:	e456                	sd	s5,8(sp)
    80000d76:	e05a                	sd	s6,0(sp)
    80000d78:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3e658593          	addi	a1,a1,998 # 80008160 <etext+0x160>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2ce50513          	addi	a0,a0,718 # 80009050 <pid_lock>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	556080e7          	jalr	1366(ra) # 800062e0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d92:	00007597          	auipc	a1,0x7
    80000d96:	3d658593          	addi	a1,a1,982 # 80008168 <etext+0x168>
    80000d9a:	00008517          	auipc	a0,0x8
    80000d9e:	2ce50513          	addi	a0,a0,718 # 80009068 <wait_lock>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	53e080e7          	jalr	1342(ra) # 800062e0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000daa:	00008497          	auipc	s1,0x8
    80000dae:	6d648493          	addi	s1,s1,1750 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db2:	00007b17          	auipc	s6,0x7
    80000db6:	3c6b0b13          	addi	s6,s6,966 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dba:	8aa6                	mv	s5,s1
    80000dbc:	00007a17          	auipc	s4,0x7
    80000dc0:	244a0a13          	addi	s4,s4,580 # 80008000 <etext>
    80000dc4:	04000937          	lui	s2,0x4000
    80000dc8:	197d                	addi	s2,s2,-1
    80000dca:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dcc:	00009997          	auipc	s3,0x9
    80000dd0:	4c498993          	addi	s3,s3,1220 # 8000a290 <tickslock>
      initlock(&p->lock, "proc");
    80000dd4:	85da                	mv	a1,s6
    80000dd6:	8526                	mv	a0,s1
    80000dd8:	00005097          	auipc	ra,0x5
    80000ddc:	508080e7          	jalr	1288(ra) # 800062e0 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de0:	415487b3          	sub	a5,s1,s5
    80000de4:	878d                	srai	a5,a5,0x3
    80000de6:	000a3703          	ld	a4,0(s4)
    80000dea:	02e787b3          	mul	a5,a5,a4
    80000dee:	2785                	addiw	a5,a5,1
    80000df0:	00d7979b          	slliw	a5,a5,0xd
    80000df4:	40f907b3          	sub	a5,s2,a5
    80000df8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	16848493          	addi	s1,s1,360
    80000dfe:	fd349be3          	bne	s1,s3,80000dd4 <procinit+0x6e>
  }
}
    80000e02:	70e2                	ld	ra,56(sp)
    80000e04:	7442                	ld	s0,48(sp)
    80000e06:	74a2                	ld	s1,40(sp)
    80000e08:	7902                	ld	s2,32(sp)
    80000e0a:	69e2                	ld	s3,24(sp)
    80000e0c:	6a42                	ld	s4,16(sp)
    80000e0e:	6aa2                	ld	s5,8(sp)
    80000e10:	6b02                	ld	s6,0(sp)
    80000e12:	6121                	addi	sp,sp,64
    80000e14:	8082                	ret

0000000080000e16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e16:	1141                	addi	sp,sp,-16
    80000e18:	e422                	sd	s0,8(sp)
    80000e1a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e1e:	2501                	sext.w	a0,a0
    80000e20:	6422                	ld	s0,8(sp)
    80000e22:	0141                	addi	sp,sp,16
    80000e24:	8082                	ret

0000000080000e26 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
    80000e2c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e2e:	2781                	sext.w	a5,a5
    80000e30:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e32:	00008517          	auipc	a0,0x8
    80000e36:	24e50513          	addi	a0,a0,590 # 80009080 <cpus>
    80000e3a:	953e                	add	a0,a0,a5
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	1000                	addi	s0,sp,32
  push_off();
    80000e4c:	00005097          	auipc	ra,0x5
    80000e50:	4d8080e7          	jalr	1240(ra) # 80006324 <push_off>
    80000e54:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e56:	2781                	sext.w	a5,a5
    80000e58:	079e                	slli	a5,a5,0x7
    80000e5a:	00008717          	auipc	a4,0x8
    80000e5e:	1f670713          	addi	a4,a4,502 # 80009050 <pid_lock>
    80000e62:	97ba                	add	a5,a5,a4
    80000e64:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e66:	00005097          	auipc	ra,0x5
    80000e6a:	55e080e7          	jalr	1374(ra) # 800063c4 <pop_off>
  return p;
}
    80000e6e:	8526                	mv	a0,s1
    80000e70:	60e2                	ld	ra,24(sp)
    80000e72:	6442                	ld	s0,16(sp)
    80000e74:	64a2                	ld	s1,8(sp)
    80000e76:	6105                	addi	sp,sp,32
    80000e78:	8082                	ret

0000000080000e7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7a:	1141                	addi	sp,sp,-16
    80000e7c:	e406                	sd	ra,8(sp)
    80000e7e:	e022                	sd	s0,0(sp)
    80000e80:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e82:	00000097          	auipc	ra,0x0
    80000e86:	fc0080e7          	jalr	-64(ra) # 80000e42 <myproc>
    80000e8a:	00005097          	auipc	ra,0x5
    80000e8e:	59a080e7          	jalr	1434(ra) # 80006424 <release>

  if (first) {
    80000e92:	00008797          	auipc	a5,0x8
    80000e96:	98e7a783          	lw	a5,-1650(a5) # 80008820 <first.1>
    80000e9a:	eb89                	bnez	a5,80000eac <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	c0e080e7          	jalr	-1010(ra) # 80001aaa <usertrapret>
}
    80000ea4:	60a2                	ld	ra,8(sp)
    80000ea6:	6402                	ld	s0,0(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret
    first = 0;
    80000eac:	00008797          	auipc	a5,0x8
    80000eb0:	9607aa23          	sw	zero,-1676(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80000eb4:	4505                	li	a0,1
    80000eb6:	00002097          	auipc	ra,0x2
    80000eba:	9f6080e7          	jalr	-1546(ra) # 800028ac <fsinit>
    80000ebe:	bff9                	j	80000e9c <forkret+0x22>

0000000080000ec0 <allocpid>:
allocpid() {
    80000ec0:	1101                	addi	sp,sp,-32
    80000ec2:	ec06                	sd	ra,24(sp)
    80000ec4:	e822                	sd	s0,16(sp)
    80000ec6:	e426                	sd	s1,8(sp)
    80000ec8:	e04a                	sd	s2,0(sp)
    80000eca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ecc:	00008917          	auipc	s2,0x8
    80000ed0:	18490913          	addi	s2,s2,388 # 80009050 <pid_lock>
    80000ed4:	854a                	mv	a0,s2
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	49a080e7          	jalr	1178(ra) # 80006370 <acquire>
  pid = nextpid;
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	94678793          	addi	a5,a5,-1722 # 80008824 <nextpid>
    80000ee6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ee8:	0014871b          	addiw	a4,s1,1
    80000eec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eee:	854a                	mv	a0,s2
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	534080e7          	jalr	1332(ra) # 80006424 <release>
}
    80000ef8:	8526                	mv	a0,s1
    80000efa:	60e2                	ld	ra,24(sp)
    80000efc:	6442                	ld	s0,16(sp)
    80000efe:	64a2                	ld	s1,8(sp)
    80000f00:	6902                	ld	s2,0(sp)
    80000f02:	6105                	addi	sp,sp,32
    80000f04:	8082                	ret

0000000080000f06 <proc_pagetable>:
{
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	e04a                	sd	s2,0(sp)
    80000f10:	1000                	addi	s0,sp,32
    80000f12:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	8b6080e7          	jalr	-1866(ra) # 800007ca <uvmcreate>
    80000f1c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f1e:	c121                	beqz	a0,80000f5e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f20:	4729                	li	a4,10
    80000f22:	00006697          	auipc	a3,0x6
    80000f26:	0de68693          	addi	a3,a3,222 # 80007000 <_trampoline>
    80000f2a:	6605                	lui	a2,0x1
    80000f2c:	040005b7          	lui	a1,0x4000
    80000f30:	15fd                	addi	a1,a1,-1
    80000f32:	05b2                	slli	a1,a1,0xc
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	60c080e7          	jalr	1548(ra) # 80000540 <mappages>
    80000f3c:	02054863          	bltz	a0,80000f6c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f40:	4719                	li	a4,6
    80000f42:	05893683          	ld	a3,88(s2)
    80000f46:	6605                	lui	a2,0x1
    80000f48:	020005b7          	lui	a1,0x2000
    80000f4c:	15fd                	addi	a1,a1,-1
    80000f4e:	05b6                	slli	a1,a1,0xd
    80000f50:	8526                	mv	a0,s1
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	5ee080e7          	jalr	1518(ra) # 80000540 <mappages>
    80000f5a:	02054163          	bltz	a0,80000f7c <proc_pagetable+0x76>
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6c:	4581                	li	a1,0
    80000f6e:	8526                	mv	a0,s1
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	a56080e7          	jalr	-1450(ra) # 800009c6 <uvmfree>
    return 0;
    80000f78:	4481                	li	s1,0
    80000f7a:	b7d5                	j	80000f5e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7c:	4681                	li	a3,0
    80000f7e:	4605                	li	a2,1
    80000f80:	040005b7          	lui	a1,0x4000
    80000f84:	15fd                	addi	a1,a1,-1
    80000f86:	05b2                	slli	a1,a1,0xc
    80000f88:	8526                	mv	a0,s1
    80000f8a:	fffff097          	auipc	ra,0xfffff
    80000f8e:	77c080e7          	jalr	1916(ra) # 80000706 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f92:	4581                	li	a1,0
    80000f94:	8526                	mv	a0,s1
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	a30080e7          	jalr	-1488(ra) # 800009c6 <uvmfree>
    return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	bf7d                	j	80000f5e <proc_pagetable+0x58>

0000000080000fa2 <proc_freepagetable>:
{
    80000fa2:	1101                	addi	sp,sp,-32
    80000fa4:	ec06                	sd	ra,24(sp)
    80000fa6:	e822                	sd	s0,16(sp)
    80000fa8:	e426                	sd	s1,8(sp)
    80000faa:	e04a                	sd	s2,0(sp)
    80000fac:	1000                	addi	s0,sp,32
    80000fae:	84aa                	mv	s1,a0
    80000fb0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	040005b7          	lui	a1,0x4000
    80000fba:	15fd                	addi	a1,a1,-1
    80000fbc:	05b2                	slli	a1,a1,0xc
    80000fbe:	fffff097          	auipc	ra,0xfffff
    80000fc2:	748080e7          	jalr	1864(ra) # 80000706 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc6:	4681                	li	a3,0
    80000fc8:	4605                	li	a2,1
    80000fca:	020005b7          	lui	a1,0x2000
    80000fce:	15fd                	addi	a1,a1,-1
    80000fd0:	05b6                	slli	a1,a1,0xd
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	732080e7          	jalr	1842(ra) # 80000706 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fdc:	85ca                	mv	a1,s2
    80000fde:	8526                	mv	a0,s1
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	9e6080e7          	jalr	-1562(ra) # 800009c6 <uvmfree>
}
    80000fe8:	60e2                	ld	ra,24(sp)
    80000fea:	6442                	ld	s0,16(sp)
    80000fec:	64a2                	ld	s1,8(sp)
    80000fee:	6902                	ld	s2,0(sp)
    80000ff0:	6105                	addi	sp,sp,32
    80000ff2:	8082                	ret

0000000080000ff4 <freeproc>:
{
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001000:	6d28                	ld	a0,88(a0)
    80001002:	c509                	beqz	a0,8000100c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	018080e7          	jalr	24(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001010:	68a8                	ld	a0,80(s1)
    80001012:	c511                	beqz	a0,8000101e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001014:	64ac                	ld	a1,72(s1)
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	f8c080e7          	jalr	-116(ra) # 80000fa2 <proc_freepagetable>
  p->pagetable = 0;
    8000101e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001022:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001026:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000102e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001032:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001036:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000103e:	0004ac23          	sw	zero,24(s1)
}
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret

000000008000104c <allocproc>:
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	e04a                	sd	s2,0(sp)
    80001056:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001058:	00008497          	auipc	s1,0x8
    8000105c:	42848493          	addi	s1,s1,1064 # 80009480 <proc>
    80001060:	00009917          	auipc	s2,0x9
    80001064:	23090913          	addi	s2,s2,560 # 8000a290 <tickslock>
    acquire(&p->lock);
    80001068:	8526                	mv	a0,s1
    8000106a:	00005097          	auipc	ra,0x5
    8000106e:	306080e7          	jalr	774(ra) # 80006370 <acquire>
    if(p->state == UNUSED) {
    80001072:	4c9c                	lw	a5,24(s1)
    80001074:	c395                	beqz	a5,80001098 <allocproc+0x4c>
      release(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	00005097          	auipc	ra,0x5
    8000107c:	3ac080e7          	jalr	940(ra) # 80006424 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	16848493          	addi	s1,s1,360
    80001084:	ff2492e3          	bne	s1,s2,80001068 <allocproc+0x1c>
  return 0;
    80001088:	4481                	li	s1,0
}
    8000108a:	8526                	mv	a0,s1
    8000108c:	60e2                	ld	ra,24(sp)
    8000108e:	6442                	ld	s0,16(sp)
    80001090:	64a2                	ld	s1,8(sp)
    80001092:	6902                	ld	s2,0(sp)
    80001094:	6105                	addi	sp,sp,32
    80001096:	8082                	ret
  p->pid = allocpid();
    80001098:	00000097          	auipc	ra,0x0
    8000109c:	e28080e7          	jalr	-472(ra) # 80000ec0 <allocpid>
    800010a0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a2:	4785                	li	a5,1
    800010a4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a6:	fffff097          	auipc	ra,0xfffff
    800010aa:	072080e7          	jalr	114(ra) # 80000118 <kalloc>
    800010ae:	892a                	mv	s2,a0
    800010b0:	eca8                	sd	a0,88(s1)
    800010b2:	cd05                	beqz	a0,800010ea <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b4:	8526                	mv	a0,s1
    800010b6:	00000097          	auipc	ra,0x0
    800010ba:	e50080e7          	jalr	-432(ra) # 80000f06 <proc_pagetable>
    800010be:	892a                	mv	s2,a0
    800010c0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c2:	c121                	beqz	a0,80001102 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c4:	07000613          	li	a2,112
    800010c8:	4581                	li	a1,0
    800010ca:	06048513          	addi	a0,s1,96
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	0aa080e7          	jalr	170(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d6:	00000797          	auipc	a5,0x0
    800010da:	da478793          	addi	a5,a5,-604 # 80000e7a <forkret>
    800010de:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e0:	60bc                	ld	a5,64(s1)
    800010e2:	6705                	lui	a4,0x1
    800010e4:	97ba                	add	a5,a5,a4
    800010e6:	f4bc                	sd	a5,104(s1)
  return p;
    800010e8:	b74d                	j	8000108a <allocproc+0x3e>
    freeproc(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	f08080e7          	jalr	-248(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	32e080e7          	jalr	814(ra) # 80006424 <release>
    return 0;
    800010fe:	84ca                	mv	s1,s2
    80001100:	b769                	j	8000108a <allocproc+0x3e>
    freeproc(p);
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	ef0080e7          	jalr	-272(ra) # 80000ff4 <freeproc>
    release(&p->lock);
    8000110c:	8526                	mv	a0,s1
    8000110e:	00005097          	auipc	ra,0x5
    80001112:	316080e7          	jalr	790(ra) # 80006424 <release>
    return 0;
    80001116:	84ca                	mv	s1,s2
    80001118:	bf8d                	j	8000108a <allocproc+0x3e>

000000008000111a <userinit>:
{
    8000111a:	1101                	addi	sp,sp,-32
    8000111c:	ec06                	sd	ra,24(sp)
    8000111e:	e822                	sd	s0,16(sp)
    80001120:	e426                	sd	s1,8(sp)
    80001122:	1000                	addi	s0,sp,32
  p = allocproc();
    80001124:	00000097          	auipc	ra,0x0
    80001128:	f28080e7          	jalr	-216(ra) # 8000104c <allocproc>
    8000112c:	84aa                	mv	s1,a0
  initproc = p;
    8000112e:	00008797          	auipc	a5,0x8
    80001132:	eea7b123          	sd	a0,-286(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001136:	03400613          	li	a2,52
    8000113a:	00007597          	auipc	a1,0x7
    8000113e:	6f658593          	addi	a1,a1,1782 # 80008830 <initcode>
    80001142:	6928                	ld	a0,80(a0)
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	6b4080e7          	jalr	1716(ra) # 800007f8 <uvminit>
  p->sz = PGSIZE;
    8000114c:	6785                	lui	a5,0x1
    8000114e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001150:	6cb8                	ld	a4,88(s1)
    80001152:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115a:	4641                	li	a2,16
    8000115c:	00007597          	auipc	a1,0x7
    80001160:	02458593          	addi	a1,a1,36 # 80008180 <etext+0x180>
    80001164:	15848513          	addi	a0,s1,344
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	15a080e7          	jalr	346(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001170:	00007517          	auipc	a0,0x7
    80001174:	02050513          	addi	a0,a0,32 # 80008190 <etext+0x190>
    80001178:	00002097          	auipc	ra,0x2
    8000117c:	20a080e7          	jalr	522(ra) # 80003382 <namei>
    80001180:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001184:	478d                	li	a5,3
    80001186:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001188:	8526                	mv	a0,s1
    8000118a:	00005097          	auipc	ra,0x5
    8000118e:	29a080e7          	jalr	666(ra) # 80006424 <release>
}
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret

000000008000119c <growproc>:
{
    8000119c:	1101                	addi	sp,sp,-32
    8000119e:	ec06                	sd	ra,24(sp)
    800011a0:	e822                	sd	s0,16(sp)
    800011a2:	e426                	sd	s1,8(sp)
    800011a4:	e04a                	sd	s2,0(sp)
    800011a6:	1000                	addi	s0,sp,32
    800011a8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	c98080e7          	jalr	-872(ra) # 80000e42 <myproc>
    800011b2:	892a                	mv	s2,a0
  sz = p->sz;
    800011b4:	652c                	ld	a1,72(a0)
    800011b6:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011ba:	00904f63          	bgtz	s1,800011d8 <growproc+0x3c>
  } else if(n < 0){
    800011be:	0204cc63          	bltz	s1,800011f6 <growproc+0x5a>
  p->sz = sz;
    800011c2:	1602                	slli	a2,a2,0x20
    800011c4:	9201                	srli	a2,a2,0x20
    800011c6:	04c93423          	sd	a2,72(s2)
  return 0;
    800011ca:	4501                	li	a0,0
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6902                	ld	s2,0(sp)
    800011d4:	6105                	addi	sp,sp,32
    800011d6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011d8:	9e25                	addw	a2,a2,s1
    800011da:	1602                	slli	a2,a2,0x20
    800011dc:	9201                	srli	a2,a2,0x20
    800011de:	1582                	slli	a1,a1,0x20
    800011e0:	9181                	srli	a1,a1,0x20
    800011e2:	6928                	ld	a0,80(a0)
    800011e4:	fffff097          	auipc	ra,0xfffff
    800011e8:	6ce080e7          	jalr	1742(ra) # 800008b2 <uvmalloc>
    800011ec:	0005061b          	sext.w	a2,a0
    800011f0:	fa69                	bnez	a2,800011c2 <growproc+0x26>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bfe1                	j	800011cc <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	9e25                	addw	a2,a2,s1
    800011f8:	1602                	slli	a2,a2,0x20
    800011fa:	9201                	srli	a2,a2,0x20
    800011fc:	1582                	slli	a1,a1,0x20
    800011fe:	9181                	srli	a1,a1,0x20
    80001200:	6928                	ld	a0,80(a0)
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	668080e7          	jalr	1640(ra) # 8000086a <uvmdealloc>
    8000120a:	0005061b          	sext.w	a2,a0
    8000120e:	bf55                	j	800011c2 <growproc+0x26>

0000000080001210 <fork>:
{
    80001210:	7139                	addi	sp,sp,-64
    80001212:	fc06                	sd	ra,56(sp)
    80001214:	f822                	sd	s0,48(sp)
    80001216:	f426                	sd	s1,40(sp)
    80001218:	f04a                	sd	s2,32(sp)
    8000121a:	ec4e                	sd	s3,24(sp)
    8000121c:	e852                	sd	s4,16(sp)
    8000121e:	e456                	sd	s5,8(sp)
    80001220:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001222:	00000097          	auipc	ra,0x0
    80001226:	c20080e7          	jalr	-992(ra) # 80000e42 <myproc>
    8000122a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	e20080e7          	jalr	-480(ra) # 8000104c <allocproc>
    80001234:	10050c63          	beqz	a0,8000134c <fork+0x13c>
    80001238:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123a:	048ab603          	ld	a2,72(s5)
    8000123e:	692c                	ld	a1,80(a0)
    80001240:	050ab503          	ld	a0,80(s5)
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	7ba080e7          	jalr	1978(ra) # 800009fe <uvmcopy>
    8000124c:	04054863          	bltz	a0,8000129c <fork+0x8c>
  np->sz = p->sz;
    80001250:	048ab783          	ld	a5,72(s5)
    80001254:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001258:	058ab683          	ld	a3,88(s5)
    8000125c:	87b6                	mv	a5,a3
    8000125e:	058a3703          	ld	a4,88(s4)
    80001262:	12068693          	addi	a3,a3,288
    80001266:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126a:	6788                	ld	a0,8(a5)
    8000126c:	6b8c                	ld	a1,16(a5)
    8000126e:	6f90                	ld	a2,24(a5)
    80001270:	01073023          	sd	a6,0(a4)
    80001274:	e708                	sd	a0,8(a4)
    80001276:	eb0c                	sd	a1,16(a4)
    80001278:	ef10                	sd	a2,24(a4)
    8000127a:	02078793          	addi	a5,a5,32
    8000127e:	02070713          	addi	a4,a4,32
    80001282:	fed792e3          	bne	a5,a3,80001266 <fork+0x56>
  np->trapframe->a0 = 0;
    80001286:	058a3783          	ld	a5,88(s4)
    8000128a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000128e:	0d0a8493          	addi	s1,s5,208
    80001292:	0d0a0913          	addi	s2,s4,208
    80001296:	150a8993          	addi	s3,s5,336
    8000129a:	a00d                	j	800012bc <fork+0xac>
    freeproc(np);
    8000129c:	8552                	mv	a0,s4
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	d56080e7          	jalr	-682(ra) # 80000ff4 <freeproc>
    release(&np->lock);
    800012a6:	8552                	mv	a0,s4
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	17c080e7          	jalr	380(ra) # 80006424 <release>
    return -1;
    800012b0:	597d                	li	s2,-1
    800012b2:	a059                	j	80001338 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012b4:	04a1                	addi	s1,s1,8
    800012b6:	0921                	addi	s2,s2,8
    800012b8:	01348b63          	beq	s1,s3,800012ce <fork+0xbe>
    if(p->ofile[i])
    800012bc:	6088                	ld	a0,0(s1)
    800012be:	d97d                	beqz	a0,800012b4 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c0:	00002097          	auipc	ra,0x2
    800012c4:	758080e7          	jalr	1880(ra) # 80003a18 <filedup>
    800012c8:	00a93023          	sd	a0,0(s2)
    800012cc:	b7e5                	j	800012b4 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ce:	150ab503          	ld	a0,336(s5)
    800012d2:	00002097          	auipc	ra,0x2
    800012d6:	814080e7          	jalr	-2028(ra) # 80002ae6 <idup>
    800012da:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012de:	4641                	li	a2,16
    800012e0:	158a8593          	addi	a1,s5,344
    800012e4:	158a0513          	addi	a0,s4,344
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	fda080e7          	jalr	-38(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012f0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012f4:	8552                	mv	a0,s4
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	12e080e7          	jalr	302(ra) # 80006424 <release>
  acquire(&wait_lock);
    800012fe:	00008497          	auipc	s1,0x8
    80001302:	d6a48493          	addi	s1,s1,-662 # 80009068 <wait_lock>
    80001306:	8526                	mv	a0,s1
    80001308:	00005097          	auipc	ra,0x5
    8000130c:	068080e7          	jalr	104(ra) # 80006370 <acquire>
  np->parent = p;
    80001310:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001314:	8526                	mv	a0,s1
    80001316:	00005097          	auipc	ra,0x5
    8000131a:	10e080e7          	jalr	270(ra) # 80006424 <release>
  acquire(&np->lock);
    8000131e:	8552                	mv	a0,s4
    80001320:	00005097          	auipc	ra,0x5
    80001324:	050080e7          	jalr	80(ra) # 80006370 <acquire>
  np->state = RUNNABLE;
    80001328:	478d                	li	a5,3
    8000132a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000132e:	8552                	mv	a0,s4
    80001330:	00005097          	auipc	ra,0x5
    80001334:	0f4080e7          	jalr	244(ra) # 80006424 <release>
}
    80001338:	854a                	mv	a0,s2
    8000133a:	70e2                	ld	ra,56(sp)
    8000133c:	7442                	ld	s0,48(sp)
    8000133e:	74a2                	ld	s1,40(sp)
    80001340:	7902                	ld	s2,32(sp)
    80001342:	69e2                	ld	s3,24(sp)
    80001344:	6a42                	ld	s4,16(sp)
    80001346:	6aa2                	ld	s5,8(sp)
    80001348:	6121                	addi	sp,sp,64
    8000134a:	8082                	ret
    return -1;
    8000134c:	597d                	li	s2,-1
    8000134e:	b7ed                	j	80001338 <fork+0x128>

0000000080001350 <scheduler>:
{
    80001350:	7139                	addi	sp,sp,-64
    80001352:	fc06                	sd	ra,56(sp)
    80001354:	f822                	sd	s0,48(sp)
    80001356:	f426                	sd	s1,40(sp)
    80001358:	f04a                	sd	s2,32(sp)
    8000135a:	ec4e                	sd	s3,24(sp)
    8000135c:	e852                	sd	s4,16(sp)
    8000135e:	e456                	sd	s5,8(sp)
    80001360:	e05a                	sd	s6,0(sp)
    80001362:	0080                	addi	s0,sp,64
    80001364:	8792                	mv	a5,tp
  int id = r_tp();
    80001366:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001368:	00779a93          	slli	s5,a5,0x7
    8000136c:	00008717          	auipc	a4,0x8
    80001370:	ce470713          	addi	a4,a4,-796 # 80009050 <pid_lock>
    80001374:	9756                	add	a4,a4,s5
    80001376:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137a:	00008717          	auipc	a4,0x8
    8000137e:	d0e70713          	addi	a4,a4,-754 # 80009088 <cpus+0x8>
    80001382:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001384:	498d                	li	s3,3
        p->state = RUNNING;
    80001386:	4b11                	li	s6,4
        c->proc = p;
    80001388:	079e                	slli	a5,a5,0x7
    8000138a:	00008a17          	auipc	s4,0x8
    8000138e:	cc6a0a13          	addi	s4,s4,-826 # 80009050 <pid_lock>
    80001392:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001394:	00009917          	auipc	s2,0x9
    80001398:	efc90913          	addi	s2,s2,-260 # 8000a290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a4:	10079073          	csrw	sstatus,a5
    800013a8:	00008497          	auipc	s1,0x8
    800013ac:	0d848493          	addi	s1,s1,216 # 80009480 <proc>
    800013b0:	a811                	j	800013c4 <scheduler+0x74>
      release(&p->lock);
    800013b2:	8526                	mv	a0,s1
    800013b4:	00005097          	auipc	ra,0x5
    800013b8:	070080e7          	jalr	112(ra) # 80006424 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013bc:	16848493          	addi	s1,s1,360
    800013c0:	fd248ee3          	beq	s1,s2,8000139c <scheduler+0x4c>
      acquire(&p->lock);
    800013c4:	8526                	mv	a0,s1
    800013c6:	00005097          	auipc	ra,0x5
    800013ca:	faa080e7          	jalr	-86(ra) # 80006370 <acquire>
      if(p->state == RUNNABLE) {
    800013ce:	4c9c                	lw	a5,24(s1)
    800013d0:	ff3791e3          	bne	a5,s3,800013b2 <scheduler+0x62>
        p->state = RUNNING;
    800013d4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013dc:	06048593          	addi	a1,s1,96
    800013e0:	8556                	mv	a0,s5
    800013e2:	00000097          	auipc	ra,0x0
    800013e6:	61e080e7          	jalr	1566(ra) # 80001a00 <swtch>
        c->proc = 0;
    800013ea:	020a3823          	sd	zero,48(s4)
    800013ee:	b7d1                	j	800013b2 <scheduler+0x62>

00000000800013f0 <sched>:
{
    800013f0:	7179                	addi	sp,sp,-48
    800013f2:	f406                	sd	ra,40(sp)
    800013f4:	f022                	sd	s0,32(sp)
    800013f6:	ec26                	sd	s1,24(sp)
    800013f8:	e84a                	sd	s2,16(sp)
    800013fa:	e44e                	sd	s3,8(sp)
    800013fc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	a44080e7          	jalr	-1468(ra) # 80000e42 <myproc>
    80001406:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	eee080e7          	jalr	-274(ra) # 800062f6 <holding>
    80001410:	c93d                	beqz	a0,80001486 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001412:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001414:	2781                	sext.w	a5,a5
    80001416:	079e                	slli	a5,a5,0x7
    80001418:	00008717          	auipc	a4,0x8
    8000141c:	c3870713          	addi	a4,a4,-968 # 80009050 <pid_lock>
    80001420:	97ba                	add	a5,a5,a4
    80001422:	0a87a703          	lw	a4,168(a5)
    80001426:	4785                	li	a5,1
    80001428:	06f71763          	bne	a4,a5,80001496 <sched+0xa6>
  if(p->state == RUNNING)
    8000142c:	4c98                	lw	a4,24(s1)
    8000142e:	4791                	li	a5,4
    80001430:	06f70b63          	beq	a4,a5,800014a6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001434:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001438:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143a:	efb5                	bnez	a5,800014b6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000143e:	00008917          	auipc	s2,0x8
    80001442:	c1290913          	addi	s2,s2,-1006 # 80009050 <pid_lock>
    80001446:	2781                	sext.w	a5,a5
    80001448:	079e                	slli	a5,a5,0x7
    8000144a:	97ca                	add	a5,a5,s2
    8000144c:	0ac7a983          	lw	s3,172(a5)
    80001450:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001452:	2781                	sext.w	a5,a5
    80001454:	079e                	slli	a5,a5,0x7
    80001456:	00008597          	auipc	a1,0x8
    8000145a:	c3258593          	addi	a1,a1,-974 # 80009088 <cpus+0x8>
    8000145e:	95be                	add	a1,a1,a5
    80001460:	06048513          	addi	a0,s1,96
    80001464:	00000097          	auipc	ra,0x0
    80001468:	59c080e7          	jalr	1436(ra) # 80001a00 <swtch>
    8000146c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	97ca                	add	a5,a5,s2
    80001474:	0b37a623          	sw	s3,172(a5)
}
    80001478:	70a2                	ld	ra,40(sp)
    8000147a:	7402                	ld	s0,32(sp)
    8000147c:	64e2                	ld	s1,24(sp)
    8000147e:	6942                	ld	s2,16(sp)
    80001480:	69a2                	ld	s3,8(sp)
    80001482:	6145                	addi	sp,sp,48
    80001484:	8082                	ret
    panic("sched p->lock");
    80001486:	00007517          	auipc	a0,0x7
    8000148a:	d1250513          	addi	a0,a0,-750 # 80008198 <etext+0x198>
    8000148e:	00005097          	auipc	ra,0x5
    80001492:	9a6080e7          	jalr	-1626(ra) # 80005e34 <panic>
    panic("sched locks");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	d1250513          	addi	a0,a0,-750 # 800081a8 <etext+0x1a8>
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	996080e7          	jalr	-1642(ra) # 80005e34 <panic>
    panic("sched running");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	d1250513          	addi	a0,a0,-750 # 800081b8 <etext+0x1b8>
    800014ae:	00005097          	auipc	ra,0x5
    800014b2:	986080e7          	jalr	-1658(ra) # 80005e34 <panic>
    panic("sched interruptible");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	d1250513          	addi	a0,a0,-750 # 800081c8 <etext+0x1c8>
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	976080e7          	jalr	-1674(ra) # 80005e34 <panic>

00000000800014c6 <yield>:
{
    800014c6:	1101                	addi	sp,sp,-32
    800014c8:	ec06                	sd	ra,24(sp)
    800014ca:	e822                	sd	s0,16(sp)
    800014cc:	e426                	sd	s1,8(sp)
    800014ce:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d0:	00000097          	auipc	ra,0x0
    800014d4:	972080e7          	jalr	-1678(ra) # 80000e42 <myproc>
    800014d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014da:	00005097          	auipc	ra,0x5
    800014de:	e96080e7          	jalr	-362(ra) # 80006370 <acquire>
  p->state = RUNNABLE;
    800014e2:	478d                	li	a5,3
    800014e4:	cc9c                	sw	a5,24(s1)
  sched();
    800014e6:	00000097          	auipc	ra,0x0
    800014ea:	f0a080e7          	jalr	-246(ra) # 800013f0 <sched>
  release(&p->lock);
    800014ee:	8526                	mv	a0,s1
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	f34080e7          	jalr	-204(ra) # 80006424 <release>
}
    800014f8:	60e2                	ld	ra,24(sp)
    800014fa:	6442                	ld	s0,16(sp)
    800014fc:	64a2                	ld	s1,8(sp)
    800014fe:	6105                	addi	sp,sp,32
    80001500:	8082                	ret

0000000080001502 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001502:	7179                	addi	sp,sp,-48
    80001504:	f406                	sd	ra,40(sp)
    80001506:	f022                	sd	s0,32(sp)
    80001508:	ec26                	sd	s1,24(sp)
    8000150a:	e84a                	sd	s2,16(sp)
    8000150c:	e44e                	sd	s3,8(sp)
    8000150e:	1800                	addi	s0,sp,48
    80001510:	89aa                	mv	s3,a0
    80001512:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001514:	00000097          	auipc	ra,0x0
    80001518:	92e080e7          	jalr	-1746(ra) # 80000e42 <myproc>
    8000151c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	e52080e7          	jalr	-430(ra) # 80006370 <acquire>
  release(lk);
    80001526:	854a                	mv	a0,s2
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	efc080e7          	jalr	-260(ra) # 80006424 <release>

  // Go to sleep.
  p->chan = chan;
    80001530:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001534:	4789                	li	a5,2
    80001536:	cc9c                	sw	a5,24(s1)

  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	eb8080e7          	jalr	-328(ra) # 800013f0 <sched>

  // Tidy up.
  p->chan = 0;
    80001540:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	ede080e7          	jalr	-290(ra) # 80006424 <release>
  acquire(lk);
    8000154e:	854a                	mv	a0,s2
    80001550:	00005097          	auipc	ra,0x5
    80001554:	e20080e7          	jalr	-480(ra) # 80006370 <acquire>
}
    80001558:	70a2                	ld	ra,40(sp)
    8000155a:	7402                	ld	s0,32(sp)
    8000155c:	64e2                	ld	s1,24(sp)
    8000155e:	6942                	ld	s2,16(sp)
    80001560:	69a2                	ld	s3,8(sp)
    80001562:	6145                	addi	sp,sp,48
    80001564:	8082                	ret

0000000080001566 <wait>:
{
    80001566:	715d                	addi	sp,sp,-80
    80001568:	e486                	sd	ra,72(sp)
    8000156a:	e0a2                	sd	s0,64(sp)
    8000156c:	fc26                	sd	s1,56(sp)
    8000156e:	f84a                	sd	s2,48(sp)
    80001570:	f44e                	sd	s3,40(sp)
    80001572:	f052                	sd	s4,32(sp)
    80001574:	ec56                	sd	s5,24(sp)
    80001576:	e85a                	sd	s6,16(sp)
    80001578:	e45e                	sd	s7,8(sp)
    8000157a:	e062                	sd	s8,0(sp)
    8000157c:	0880                	addi	s0,sp,80
    8000157e:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	8c2080e7          	jalr	-1854(ra) # 80000e42 <myproc>
    80001588:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158a:	00008517          	auipc	a0,0x8
    8000158e:	ade50513          	addi	a0,a0,-1314 # 80009068 <wait_lock>
    80001592:	00005097          	auipc	ra,0x5
    80001596:	dde080e7          	jalr	-546(ra) # 80006370 <acquire>
    havekids = 0;
    8000159a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159c:	4a15                	li	s4,5
        havekids = 1;
    8000159e:	4b05                	li	s6,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015a0:	00009997          	auipc	s3,0x9
    800015a4:	cf098993          	addi	s3,s3,-784 # 8000a290 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015a8:	00008c17          	auipc	s8,0x8
    800015ac:	ac0c0c13          	addi	s8,s8,-1344 # 80009068 <wait_lock>
    havekids = 0;
    800015b0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b2:	00008497          	auipc	s1,0x8
    800015b6:	ece48493          	addi	s1,s1,-306 # 80009480 <proc>
    800015ba:	a0bd                	j	80001628 <wait+0xc2>
          pid = np->pid;
    800015bc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c0:	000a8e63          	beqz	s5,800015dc <wait+0x76>
    800015c4:	4691                	li	a3,4
    800015c6:	02c48613          	addi	a2,s1,44
    800015ca:	85d6                	mv	a1,s5
    800015cc:	05093503          	ld	a0,80(s2)
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	532080e7          	jalr	1330(ra) # 80000b02 <copyout>
    800015d8:	02054563          	bltz	a0,80001602 <wait+0x9c>
          freeproc(np);
    800015dc:	8526                	mv	a0,s1
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	a16080e7          	jalr	-1514(ra) # 80000ff4 <freeproc>
          release(&np->lock);
    800015e6:	8526                	mv	a0,s1
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	e3c080e7          	jalr	-452(ra) # 80006424 <release>
          release(&wait_lock);
    800015f0:	00008517          	auipc	a0,0x8
    800015f4:	a7850513          	addi	a0,a0,-1416 # 80009068 <wait_lock>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	e2c080e7          	jalr	-468(ra) # 80006424 <release>
          return pid;
    80001600:	a09d                	j	80001666 <wait+0x100>
            release(&np->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	e20080e7          	jalr	-480(ra) # 80006424 <release>
            release(&wait_lock);
    8000160c:	00008517          	auipc	a0,0x8
    80001610:	a5c50513          	addi	a0,a0,-1444 # 80009068 <wait_lock>
    80001614:	00005097          	auipc	ra,0x5
    80001618:	e10080e7          	jalr	-496(ra) # 80006424 <release>
            return -1;
    8000161c:	59fd                	li	s3,-1
    8000161e:	a0a1                	j	80001666 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001620:	16848493          	addi	s1,s1,360
    80001624:	03348463          	beq	s1,s3,8000164c <wait+0xe6>
      if(np->parent == p){
    80001628:	7c9c                	ld	a5,56(s1)
    8000162a:	ff279be3          	bne	a5,s2,80001620 <wait+0xba>
        acquire(&np->lock);
    8000162e:	8526                	mv	a0,s1
    80001630:	00005097          	auipc	ra,0x5
    80001634:	d40080e7          	jalr	-704(ra) # 80006370 <acquire>
        if(np->state == ZOMBIE){
    80001638:	4c9c                	lw	a5,24(s1)
    8000163a:	f94781e3          	beq	a5,s4,800015bc <wait+0x56>
        release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	de4080e7          	jalr	-540(ra) # 80006424 <release>
        havekids = 1;
    80001648:	875a                	mv	a4,s6
    8000164a:	bfd9                	j	80001620 <wait+0xba>
    if(!havekids || p->killed){
    8000164c:	c701                	beqz	a4,80001654 <wait+0xee>
    8000164e:	02892783          	lw	a5,40(s2)
    80001652:	c79d                	beqz	a5,80001680 <wait+0x11a>
      release(&wait_lock);
    80001654:	00008517          	auipc	a0,0x8
    80001658:	a1450513          	addi	a0,a0,-1516 # 80009068 <wait_lock>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	dc8080e7          	jalr	-568(ra) # 80006424 <release>
      return -1;
    80001664:	59fd                	li	s3,-1
}
    80001666:	854e                	mv	a0,s3
    80001668:	60a6                	ld	ra,72(sp)
    8000166a:	6406                	ld	s0,64(sp)
    8000166c:	74e2                	ld	s1,56(sp)
    8000166e:	7942                	ld	s2,48(sp)
    80001670:	79a2                	ld	s3,40(sp)
    80001672:	7a02                	ld	s4,32(sp)
    80001674:	6ae2                	ld	s5,24(sp)
    80001676:	6b42                	ld	s6,16(sp)
    80001678:	6ba2                	ld	s7,8(sp)
    8000167a:	6c02                	ld	s8,0(sp)
    8000167c:	6161                	addi	sp,sp,80
    8000167e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001680:	85e2                	mv	a1,s8
    80001682:	854a                	mv	a0,s2
    80001684:	00000097          	auipc	ra,0x0
    80001688:	e7e080e7          	jalr	-386(ra) # 80001502 <sleep>
    havekids = 0;
    8000168c:	b715                	j	800015b0 <wait+0x4a>

000000008000168e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000168e:	7139                	addi	sp,sp,-64
    80001690:	fc06                	sd	ra,56(sp)
    80001692:	f822                	sd	s0,48(sp)
    80001694:	f426                	sd	s1,40(sp)
    80001696:	f04a                	sd	s2,32(sp)
    80001698:	ec4e                	sd	s3,24(sp)
    8000169a:	e852                	sd	s4,16(sp)
    8000169c:	e456                	sd	s5,8(sp)
    8000169e:	0080                	addi	s0,sp,64
    800016a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a2:	00008497          	auipc	s1,0x8
    800016a6:	dde48493          	addi	s1,s1,-546 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ae:	00009917          	auipc	s2,0x9
    800016b2:	be290913          	addi	s2,s2,-1054 # 8000a290 <tickslock>
    800016b6:	a811                	j	800016ca <wakeup+0x3c>
      }
      release(&p->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	d6a080e7          	jalr	-662(ra) # 80006424 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c2:	16848493          	addi	s1,s1,360
    800016c6:	03248663          	beq	s1,s2,800016f2 <wakeup+0x64>
    if(p != myproc()){
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	778080e7          	jalr	1912(ra) # 80000e42 <myproc>
    800016d2:	fea488e3          	beq	s1,a0,800016c2 <wakeup+0x34>
      acquire(&p->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	c98080e7          	jalr	-872(ra) # 80006370 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e0:	4c9c                	lw	a5,24(s1)
    800016e2:	fd379be3          	bne	a5,s3,800016b8 <wakeup+0x2a>
    800016e6:	709c                	ld	a5,32(s1)
    800016e8:	fd4798e3          	bne	a5,s4,800016b8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016ec:	0154ac23          	sw	s5,24(s1)
    800016f0:	b7e1                	j	800016b8 <wakeup+0x2a>
    }
  }
}
    800016f2:	70e2                	ld	ra,56(sp)
    800016f4:	7442                	ld	s0,48(sp)
    800016f6:	74a2                	ld	s1,40(sp)
    800016f8:	7902                	ld	s2,32(sp)
    800016fa:	69e2                	ld	s3,24(sp)
    800016fc:	6a42                	ld	s4,16(sp)
    800016fe:	6aa2                	ld	s5,8(sp)
    80001700:	6121                	addi	sp,sp,64
    80001702:	8082                	ret

0000000080001704 <reparent>:
{
    80001704:	7179                	addi	sp,sp,-48
    80001706:	f406                	sd	ra,40(sp)
    80001708:	f022                	sd	s0,32(sp)
    8000170a:	ec26                	sd	s1,24(sp)
    8000170c:	e84a                	sd	s2,16(sp)
    8000170e:	e44e                	sd	s3,8(sp)
    80001710:	e052                	sd	s4,0(sp)
    80001712:	1800                	addi	s0,sp,48
    80001714:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001716:	00008497          	auipc	s1,0x8
    8000171a:	d6a48493          	addi	s1,s1,-662 # 80009480 <proc>
      pp->parent = initproc;
    8000171e:	00008a17          	auipc	s4,0x8
    80001722:	8f2a0a13          	addi	s4,s4,-1806 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001726:	00009997          	auipc	s3,0x9
    8000172a:	b6a98993          	addi	s3,s3,-1174 # 8000a290 <tickslock>
    8000172e:	a029                	j	80001738 <reparent+0x34>
    80001730:	16848493          	addi	s1,s1,360
    80001734:	01348d63          	beq	s1,s3,8000174e <reparent+0x4a>
    if(pp->parent == p){
    80001738:	7c9c                	ld	a5,56(s1)
    8000173a:	ff279be3          	bne	a5,s2,80001730 <reparent+0x2c>
      pp->parent = initproc;
    8000173e:	000a3503          	ld	a0,0(s4)
    80001742:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001744:	00000097          	auipc	ra,0x0
    80001748:	f4a080e7          	jalr	-182(ra) # 8000168e <wakeup>
    8000174c:	b7d5                	j	80001730 <reparent+0x2c>
}
    8000174e:	70a2                	ld	ra,40(sp)
    80001750:	7402                	ld	s0,32(sp)
    80001752:	64e2                	ld	s1,24(sp)
    80001754:	6942                	ld	s2,16(sp)
    80001756:	69a2                	ld	s3,8(sp)
    80001758:	6a02                	ld	s4,0(sp)
    8000175a:	6145                	addi	sp,sp,48
    8000175c:	8082                	ret

000000008000175e <exit>:
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	e052                	sd	s4,0(sp)
    8000176c:	1800                	addi	s0,sp,48
    8000176e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001770:	fffff097          	auipc	ra,0xfffff
    80001774:	6d2080e7          	jalr	1746(ra) # 80000e42 <myproc>
    80001778:	89aa                	mv	s3,a0
  if(p == initproc)
    8000177a:	00008797          	auipc	a5,0x8
    8000177e:	8967b783          	ld	a5,-1898(a5) # 80009010 <initproc>
    80001782:	0d050493          	addi	s1,a0,208
    80001786:	15050913          	addi	s2,a0,336
    8000178a:	02a79363          	bne	a5,a0,800017b0 <exit+0x52>
    panic("init exiting");
    8000178e:	00007517          	auipc	a0,0x7
    80001792:	a5250513          	addi	a0,a0,-1454 # 800081e0 <etext+0x1e0>
    80001796:	00004097          	auipc	ra,0x4
    8000179a:	69e080e7          	jalr	1694(ra) # 80005e34 <panic>
      fileclose(f);
    8000179e:	00002097          	auipc	ra,0x2
    800017a2:	2cc080e7          	jalr	716(ra) # 80003a6a <fileclose>
      p->ofile[fd] = 0;
    800017a6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017aa:	04a1                	addi	s1,s1,8
    800017ac:	01248563          	beq	s1,s2,800017b6 <exit+0x58>
    if(p->ofile[fd]){
    800017b0:	6088                	ld	a0,0(s1)
    800017b2:	f575                	bnez	a0,8000179e <exit+0x40>
    800017b4:	bfdd                	j	800017aa <exit+0x4c>
  begin_op();
    800017b6:	00002097          	auipc	ra,0x2
    800017ba:	de8080e7          	jalr	-536(ra) # 8000359e <begin_op>
  iput(p->cwd);
    800017be:	1509b503          	ld	a0,336(s3)
    800017c2:	00001097          	auipc	ra,0x1
    800017c6:	5c2080e7          	jalr	1474(ra) # 80002d84 <iput>
  end_op();
    800017ca:	00002097          	auipc	ra,0x2
    800017ce:	e54080e7          	jalr	-428(ra) # 8000361e <end_op>
  p->cwd = 0;
    800017d2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d6:	00008497          	auipc	s1,0x8
    800017da:	89248493          	addi	s1,s1,-1902 # 80009068 <wait_lock>
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	b90080e7          	jalr	-1136(ra) # 80006370 <acquire>
  reparent(p);
    800017e8:	854e                	mv	a0,s3
    800017ea:	00000097          	auipc	ra,0x0
    800017ee:	f1a080e7          	jalr	-230(ra) # 80001704 <reparent>
  wakeup(p->parent);
    800017f2:	0389b503          	ld	a0,56(s3)
    800017f6:	00000097          	auipc	ra,0x0
    800017fa:	e98080e7          	jalr	-360(ra) # 8000168e <wakeup>
  acquire(&p->lock);
    800017fe:	854e                	mv	a0,s3
    80001800:	00005097          	auipc	ra,0x5
    80001804:	b70080e7          	jalr	-1168(ra) # 80006370 <acquire>
  p->xstate = status;
    80001808:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180c:	4795                	li	a5,5
    8000180e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001812:	8526                	mv	a0,s1
    80001814:	00005097          	auipc	ra,0x5
    80001818:	c10080e7          	jalr	-1008(ra) # 80006424 <release>
  sched();
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	bd4080e7          	jalr	-1068(ra) # 800013f0 <sched>
  panic("zombie exit");
    80001824:	00007517          	auipc	a0,0x7
    80001828:	9cc50513          	addi	a0,a0,-1588 # 800081f0 <etext+0x1f0>
    8000182c:	00004097          	auipc	ra,0x4
    80001830:	608080e7          	jalr	1544(ra) # 80005e34 <panic>

0000000080001834 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001834:	7179                	addi	sp,sp,-48
    80001836:	f406                	sd	ra,40(sp)
    80001838:	f022                	sd	s0,32(sp)
    8000183a:	ec26                	sd	s1,24(sp)
    8000183c:	e84a                	sd	s2,16(sp)
    8000183e:	e44e                	sd	s3,8(sp)
    80001840:	1800                	addi	s0,sp,48
    80001842:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001844:	00008497          	auipc	s1,0x8
    80001848:	c3c48493          	addi	s1,s1,-964 # 80009480 <proc>
    8000184c:	00009997          	auipc	s3,0x9
    80001850:	a4498993          	addi	s3,s3,-1468 # 8000a290 <tickslock>
    acquire(&p->lock);
    80001854:	8526                	mv	a0,s1
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	b1a080e7          	jalr	-1254(ra) # 80006370 <acquire>
    if(p->pid == pid){
    8000185e:	589c                	lw	a5,48(s1)
    80001860:	03278363          	beq	a5,s2,80001886 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	bbe080e7          	jalr	-1090(ra) # 80006424 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000186e:	16848493          	addi	s1,s1,360
    80001872:	ff3491e3          	bne	s1,s3,80001854 <kill+0x20>
  }
  return -1;
    80001876:	557d                	li	a0,-1
}
    80001878:	70a2                	ld	ra,40(sp)
    8000187a:	7402                	ld	s0,32(sp)
    8000187c:	64e2                	ld	s1,24(sp)
    8000187e:	6942                	ld	s2,16(sp)
    80001880:	69a2                	ld	s3,8(sp)
    80001882:	6145                	addi	sp,sp,48
    80001884:	8082                	ret
      p->killed = 1;
    80001886:	4785                	li	a5,1
    80001888:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188a:	4c98                	lw	a4,24(s1)
    8000188c:	4789                	li	a5,2
    8000188e:	00f70963          	beq	a4,a5,800018a0 <kill+0x6c>
      release(&p->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	b90080e7          	jalr	-1136(ra) # 80006424 <release>
      return 0;
    8000189c:	4501                	li	a0,0
    8000189e:	bfe9                	j	80001878 <kill+0x44>
        p->state = RUNNABLE;
    800018a0:	478d                	li	a5,3
    800018a2:	cc9c                	sw	a5,24(s1)
    800018a4:	b7fd                	j	80001892 <kill+0x5e>

00000000800018a6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a6:	7179                	addi	sp,sp,-48
    800018a8:	f406                	sd	ra,40(sp)
    800018aa:	f022                	sd	s0,32(sp)
    800018ac:	ec26                	sd	s1,24(sp)
    800018ae:	e84a                	sd	s2,16(sp)
    800018b0:	e44e                	sd	s3,8(sp)
    800018b2:	e052                	sd	s4,0(sp)
    800018b4:	1800                	addi	s0,sp,48
    800018b6:	84aa                	mv	s1,a0
    800018b8:	892e                	mv	s2,a1
    800018ba:	89b2                	mv	s3,a2
    800018bc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018be:	fffff097          	auipc	ra,0xfffff
    800018c2:	584080e7          	jalr	1412(ra) # 80000e42 <myproc>
  if(user_dst){
    800018c6:	c08d                	beqz	s1,800018e8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018c8:	86d2                	mv	a3,s4
    800018ca:	864e                	mv	a2,s3
    800018cc:	85ca                	mv	a1,s2
    800018ce:	6928                	ld	a0,80(a0)
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	232080e7          	jalr	562(ra) # 80000b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018d8:	70a2                	ld	ra,40(sp)
    800018da:	7402                	ld	s0,32(sp)
    800018dc:	64e2                	ld	s1,24(sp)
    800018de:	6942                	ld	s2,16(sp)
    800018e0:	69a2                	ld	s3,8(sp)
    800018e2:	6a02                	ld	s4,0(sp)
    800018e4:	6145                	addi	sp,sp,48
    800018e6:	8082                	ret
    memmove((char *)dst, src, len);
    800018e8:	000a061b          	sext.w	a2,s4
    800018ec:	85ce                	mv	a1,s3
    800018ee:	854a                	mv	a0,s2
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	8e4080e7          	jalr	-1820(ra) # 800001d4 <memmove>
    return 0;
    800018f8:	8526                	mv	a0,s1
    800018fa:	bff9                	j	800018d8 <either_copyout+0x32>

00000000800018fc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	addi	s0,sp,48
    8000190c:	892a                	mv	s2,a0
    8000190e:	84ae                	mv	s1,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	52e080e7          	jalr	1326(ra) # 80000e42 <myproc>
  if(user_src){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	268080e7          	jalr	616(ra) # 80000b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	addi	sp,sp,48
    8000193c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	88e080e7          	jalr	-1906(ra) # 800001d4 <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyin+0x32>

0000000080001952 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001952:	715d                	addi	sp,sp,-80
    80001954:	e486                	sd	ra,72(sp)
    80001956:	e0a2                	sd	s0,64(sp)
    80001958:	fc26                	sd	s1,56(sp)
    8000195a:	f84a                	sd	s2,48(sp)
    8000195c:	f44e                	sd	s3,40(sp)
    8000195e:	f052                	sd	s4,32(sp)
    80001960:	ec56                	sd	s5,24(sp)
    80001962:	e85a                	sd	s6,16(sp)
    80001964:	e45e                	sd	s7,8(sp)
    80001966:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001968:	00006517          	auipc	a0,0x6
    8000196c:	6e050513          	addi	a0,a0,1760 # 80008048 <etext+0x48>
    80001970:	00004097          	auipc	ra,0x4
    80001974:	50e080e7          	jalr	1294(ra) # 80005e7e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001978:	00008497          	auipc	s1,0x8
    8000197c:	c6048493          	addi	s1,s1,-928 # 800095d8 <proc+0x158>
    80001980:	00009917          	auipc	s2,0x9
    80001984:	a6890913          	addi	s2,s2,-1432 # 8000a3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001988:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000198a:	00007997          	auipc	s3,0x7
    8000198e:	87698993          	addi	s3,s3,-1930 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001992:	00007a97          	auipc	s5,0x7
    80001996:	876a8a93          	addi	s5,s5,-1930 # 80008208 <etext+0x208>
    printf("\n");
    8000199a:	00006a17          	auipc	s4,0x6
    8000199e:	6aea0a13          	addi	s4,s4,1710 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a2:	00007b97          	auipc	s7,0x7
    800019a6:	89eb8b93          	addi	s7,s7,-1890 # 80008240 <states.0>
    800019aa:	a00d                	j	800019cc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ac:	ed86a583          	lw	a1,-296(a3)
    800019b0:	8556                	mv	a0,s5
    800019b2:	00004097          	auipc	ra,0x4
    800019b6:	4cc080e7          	jalr	1228(ra) # 80005e7e <printf>
    printf("\n");
    800019ba:	8552                	mv	a0,s4
    800019bc:	00004097          	auipc	ra,0x4
    800019c0:	4c2080e7          	jalr	1218(ra) # 80005e7e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c4:	16848493          	addi	s1,s1,360
    800019c8:	03248163          	beq	s1,s2,800019ea <procdump+0x98>
    if(p->state == UNUSED)
    800019cc:	86a6                	mv	a3,s1
    800019ce:	ec04a783          	lw	a5,-320(s1)
    800019d2:	dbed                	beqz	a5,800019c4 <procdump+0x72>
      state = "???";
    800019d4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d6:	fcfb6be3          	bltu	s6,a5,800019ac <procdump+0x5a>
    800019da:	1782                	slli	a5,a5,0x20
    800019dc:	9381                	srli	a5,a5,0x20
    800019de:	078e                	slli	a5,a5,0x3
    800019e0:	97de                	add	a5,a5,s7
    800019e2:	6390                	ld	a2,0(a5)
    800019e4:	f661                	bnez	a2,800019ac <procdump+0x5a>
      state = "???";
    800019e6:	864e                	mv	a2,s3
    800019e8:	b7d1                	j	800019ac <procdump+0x5a>
  }
}
    800019ea:	60a6                	ld	ra,72(sp)
    800019ec:	6406                	ld	s0,64(sp)
    800019ee:	74e2                	ld	s1,56(sp)
    800019f0:	7942                	ld	s2,48(sp)
    800019f2:	79a2                	ld	s3,40(sp)
    800019f4:	7a02                	ld	s4,32(sp)
    800019f6:	6ae2                	ld	s5,24(sp)
    800019f8:	6b42                	ld	s6,16(sp)
    800019fa:	6ba2                	ld	s7,8(sp)
    800019fc:	6161                	addi	sp,sp,80
    800019fe:	8082                	ret

0000000080001a00 <swtch>:
    80001a00:	00153023          	sd	ra,0(a0)
    80001a04:	00253423          	sd	sp,8(a0)
    80001a08:	e900                	sd	s0,16(a0)
    80001a0a:	ed04                	sd	s1,24(a0)
    80001a0c:	03253023          	sd	s2,32(a0)
    80001a10:	03353423          	sd	s3,40(a0)
    80001a14:	03453823          	sd	s4,48(a0)
    80001a18:	03553c23          	sd	s5,56(a0)
    80001a1c:	05653023          	sd	s6,64(a0)
    80001a20:	05753423          	sd	s7,72(a0)
    80001a24:	05853823          	sd	s8,80(a0)
    80001a28:	05953c23          	sd	s9,88(a0)
    80001a2c:	07a53023          	sd	s10,96(a0)
    80001a30:	07b53423          	sd	s11,104(a0)
    80001a34:	0005b083          	ld	ra,0(a1)
    80001a38:	0085b103          	ld	sp,8(a1)
    80001a3c:	6980                	ld	s0,16(a1)
    80001a3e:	6d84                	ld	s1,24(a1)
    80001a40:	0205b903          	ld	s2,32(a1)
    80001a44:	0285b983          	ld	s3,40(a1)
    80001a48:	0305ba03          	ld	s4,48(a1)
    80001a4c:	0385ba83          	ld	s5,56(a1)
    80001a50:	0405bb03          	ld	s6,64(a1)
    80001a54:	0485bb83          	ld	s7,72(a1)
    80001a58:	0505bc03          	ld	s8,80(a1)
    80001a5c:	0585bc83          	ld	s9,88(a1)
    80001a60:	0605bd03          	ld	s10,96(a1)
    80001a64:	0685bd83          	ld	s11,104(a1)
    80001a68:	8082                	ret

0000000080001a6a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a6a:	1141                	addi	sp,sp,-16
    80001a6c:	e406                	sd	ra,8(sp)
    80001a6e:	e022                	sd	s0,0(sp)
    80001a70:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a72:	00006597          	auipc	a1,0x6
    80001a76:	7fe58593          	addi	a1,a1,2046 # 80008270 <states.0+0x30>
    80001a7a:	00009517          	auipc	a0,0x9
    80001a7e:	81650513          	addi	a0,a0,-2026 # 8000a290 <tickslock>
    80001a82:	00005097          	auipc	ra,0x5
    80001a86:	85e080e7          	jalr	-1954(ra) # 800062e0 <initlock>
}
    80001a8a:	60a2                	ld	ra,8(sp)
    80001a8c:	6402                	ld	s0,0(sp)
    80001a8e:	0141                	addi	sp,sp,16
    80001a90:	8082                	ret

0000000080001a92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a92:	1141                	addi	sp,sp,-16
    80001a94:	e422                	sd	s0,8(sp)
    80001a96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a98:	00003797          	auipc	a5,0x3
    80001a9c:	7f878793          	addi	a5,a5,2040 # 80005290 <kernelvec>
    80001aa0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa4:	6422                	ld	s0,8(sp)
    80001aa6:	0141                	addi	sp,sp,16
    80001aa8:	8082                	ret

0000000080001aaa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aaa:	1141                	addi	sp,sp,-16
    80001aac:	e406                	sd	ra,8(sp)
    80001aae:	e022                	sd	s0,0(sp)
    80001ab0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab2:	fffff097          	auipc	ra,0xfffff
    80001ab6:	390080e7          	jalr	912(ra) # 80000e42 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001abe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac4:	00005617          	auipc	a2,0x5
    80001ac8:	53c60613          	addi	a2,a2,1340 # 80007000 <_trampoline>
    80001acc:	00005697          	auipc	a3,0x5
    80001ad0:	53468693          	addi	a3,a3,1332 # 80007000 <_trampoline>
    80001ad4:	8e91                	sub	a3,a3,a2
    80001ad6:	040007b7          	lui	a5,0x4000
    80001ada:	17fd                	addi	a5,a5,-1
    80001adc:	07b2                	slli	a5,a5,0xc
    80001ade:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae6:	180026f3          	csrr	a3,satp
    80001aea:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aec:	6d38                	ld	a4,88(a0)
    80001aee:	6134                	ld	a3,64(a0)
    80001af0:	6585                	lui	a1,0x1
    80001af2:	96ae                	add	a3,a3,a1
    80001af4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af6:	6d38                	ld	a4,88(a0)
    80001af8:	00000697          	auipc	a3,0x0
    80001afc:	13868693          	addi	a3,a3,312 # 80001c30 <usertrap>
    80001b00:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b02:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b04:	8692                	mv	a3,tp
    80001b06:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b08:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b10:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b14:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b18:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1a:	6f18                	ld	a4,24(a4)
    80001b1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b20:	692c                	ld	a1,80(a0)
    80001b22:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b24:	00005717          	auipc	a4,0x5
    80001b28:	56c70713          	addi	a4,a4,1388 # 80007090 <userret>
    80001b2c:	8f11                	sub	a4,a4,a2
    80001b2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b30:	577d                	li	a4,-1
    80001b32:	177e                	slli	a4,a4,0x3f
    80001b34:	8dd9                	or	a1,a1,a4
    80001b36:	02000537          	lui	a0,0x2000
    80001b3a:	157d                	addi	a0,a0,-1
    80001b3c:	0536                	slli	a0,a0,0xd
    80001b3e:	9782                	jalr	a5
}
    80001b40:	60a2                	ld	ra,8(sp)
    80001b42:	6402                	ld	s0,0(sp)
    80001b44:	0141                	addi	sp,sp,16
    80001b46:	8082                	ret

0000000080001b48 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b48:	1101                	addi	sp,sp,-32
    80001b4a:	ec06                	sd	ra,24(sp)
    80001b4c:	e822                	sd	s0,16(sp)
    80001b4e:	e426                	sd	s1,8(sp)
    80001b50:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b52:	00008497          	auipc	s1,0x8
    80001b56:	73e48493          	addi	s1,s1,1854 # 8000a290 <tickslock>
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	00005097          	auipc	ra,0x5
    80001b60:	814080e7          	jalr	-2028(ra) # 80006370 <acquire>
  ticks++;
    80001b64:	00007517          	auipc	a0,0x7
    80001b68:	4b450513          	addi	a0,a0,1204 # 80009018 <ticks>
    80001b6c:	411c                	lw	a5,0(a0)
    80001b6e:	2785                	addiw	a5,a5,1
    80001b70:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b72:	00000097          	auipc	ra,0x0
    80001b76:	b1c080e7          	jalr	-1252(ra) # 8000168e <wakeup>
  release(&tickslock);
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	00005097          	auipc	ra,0x5
    80001b80:	8a8080e7          	jalr	-1880(ra) # 80006424 <release>
}
    80001b84:	60e2                	ld	ra,24(sp)
    80001b86:	6442                	ld	s0,16(sp)
    80001b88:	64a2                	ld	s1,8(sp)
    80001b8a:	6105                	addi	sp,sp,32
    80001b8c:	8082                	ret

0000000080001b8e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b8e:	1101                	addi	sp,sp,-32
    80001b90:	ec06                	sd	ra,24(sp)
    80001b92:	e822                	sd	s0,16(sp)
    80001b94:	e426                	sd	s1,8(sp)
    80001b96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b98:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9c:	00074d63          	bltz	a4,80001bb6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba0:	57fd                	li	a5,-1
    80001ba2:	17fe                	slli	a5,a5,0x3f
    80001ba4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ba8:	06f70363          	beq	a4,a5,80001c0e <devintr+0x80>
  }
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret
     (scause & 0xff) == 9){
    80001bb6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bba:	46a5                	li	a3,9
    80001bbc:	fed792e3          	bne	a5,a3,80001ba0 <devintr+0x12>
    int irq = plic_claim();
    80001bc0:	00003097          	auipc	ra,0x3
    80001bc4:	7d8080e7          	jalr	2008(ra) # 80005398 <plic_claim>
    80001bc8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bca:	47a9                	li	a5,10
    80001bcc:	02f50763          	beq	a0,a5,80001bfa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd0:	4785                	li	a5,1
    80001bd2:	02f50963          	beq	a0,a5,80001c04 <devintr+0x76>
    return 1;
    80001bd6:	4505                	li	a0,1
    } else if(irq){
    80001bd8:	d8f1                	beqz	s1,80001bac <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bda:	85a6                	mv	a1,s1
    80001bdc:	00006517          	auipc	a0,0x6
    80001be0:	69c50513          	addi	a0,a0,1692 # 80008278 <states.0+0x38>
    80001be4:	00004097          	auipc	ra,0x4
    80001be8:	29a080e7          	jalr	666(ra) # 80005e7e <printf>
      plic_complete(irq);
    80001bec:	8526                	mv	a0,s1
    80001bee:	00003097          	auipc	ra,0x3
    80001bf2:	7ce080e7          	jalr	1998(ra) # 800053bc <plic_complete>
    return 1;
    80001bf6:	4505                	li	a0,1
    80001bf8:	bf55                	j	80001bac <devintr+0x1e>
      uartintr();
    80001bfa:	00004097          	auipc	ra,0x4
    80001bfe:	696080e7          	jalr	1686(ra) # 80006290 <uartintr>
    80001c02:	b7ed                	j	80001bec <devintr+0x5e>
      virtio_disk_intr();
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	c4a080e7          	jalr	-950(ra) # 8000584e <virtio_disk_intr>
    80001c0c:	b7c5                	j	80001bec <devintr+0x5e>
    if(cpuid() == 0){
    80001c0e:	fffff097          	auipc	ra,0xfffff
    80001c12:	208080e7          	jalr	520(ra) # 80000e16 <cpuid>
    80001c16:	c901                	beqz	a0,80001c26 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c18:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c1e:	14479073          	csrw	sip,a5
    return 2;
    80001c22:	4509                	li	a0,2
    80001c24:	b761                	j	80001bac <devintr+0x1e>
      clockintr();
    80001c26:	00000097          	auipc	ra,0x0
    80001c2a:	f22080e7          	jalr	-222(ra) # 80001b48 <clockintr>
    80001c2e:	b7ed                	j	80001c18 <devintr+0x8a>

0000000080001c30 <usertrap>:
{
    80001c30:	1101                	addi	sp,sp,-32
    80001c32:	ec06                	sd	ra,24(sp)
    80001c34:	e822                	sd	s0,16(sp)
    80001c36:	e426                	sd	s1,8(sp)
    80001c38:	e04a                	sd	s2,0(sp)
    80001c3a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c40:	1007f793          	andi	a5,a5,256
    80001c44:	e3ad                	bnez	a5,80001ca6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c46:	00003797          	auipc	a5,0x3
    80001c4a:	64a78793          	addi	a5,a5,1610 # 80005290 <kernelvec>
    80001c4e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c52:	fffff097          	auipc	ra,0xfffff
    80001c56:	1f0080e7          	jalr	496(ra) # 80000e42 <myproc>
    80001c5a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c5e:	14102773          	csrr	a4,sepc
    80001c62:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c64:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c68:	47a1                	li	a5,8
    80001c6a:	04f71c63          	bne	a4,a5,80001cc2 <usertrap+0x92>
    if(p->killed)
    80001c6e:	551c                	lw	a5,40(a0)
    80001c70:	e3b9                	bnez	a5,80001cb6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c72:	6cb8                	ld	a4,88(s1)
    80001c74:	6f1c                	ld	a5,24(a4)
    80001c76:	0791                	addi	a5,a5,4
    80001c78:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c82:	10079073          	csrw	sstatus,a5
    syscall();
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	2e0080e7          	jalr	736(ra) # 80001f66 <syscall>
  if(p->killed)
    80001c8e:	549c                	lw	a5,40(s1)
    80001c90:	ebc1                	bnez	a5,80001d20 <usertrap+0xf0>
  usertrapret();
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	e18080e7          	jalr	-488(ra) # 80001aaa <usertrapret>
}
    80001c9a:	60e2                	ld	ra,24(sp)
    80001c9c:	6442                	ld	s0,16(sp)
    80001c9e:	64a2                	ld	s1,8(sp)
    80001ca0:	6902                	ld	s2,0(sp)
    80001ca2:	6105                	addi	sp,sp,32
    80001ca4:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca6:	00006517          	auipc	a0,0x6
    80001caa:	5f250513          	addi	a0,a0,1522 # 80008298 <states.0+0x58>
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	186080e7          	jalr	390(ra) # 80005e34 <panic>
      exit(-1);
    80001cb6:	557d                	li	a0,-1
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	aa6080e7          	jalr	-1370(ra) # 8000175e <exit>
    80001cc0:	bf4d                	j	80001c72 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	ecc080e7          	jalr	-308(ra) # 80001b8e <devintr>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	c501                	beqz	a0,80001cd4 <usertrap+0xa4>
  if(p->killed)
    80001cce:	549c                	lw	a5,40(s1)
    80001cd0:	c3a1                	beqz	a5,80001d10 <usertrap+0xe0>
    80001cd2:	a815                	j	80001d06 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cd8:	5890                	lw	a2,48(s1)
    80001cda:	00006517          	auipc	a0,0x6
    80001cde:	5de50513          	addi	a0,a0,1502 # 800082b8 <states.0+0x78>
    80001ce2:	00004097          	auipc	ra,0x4
    80001ce6:	19c080e7          	jalr	412(ra) # 80005e7e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cee:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf2:	00006517          	auipc	a0,0x6
    80001cf6:	5f650513          	addi	a0,a0,1526 # 800082e8 <states.0+0xa8>
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	184080e7          	jalr	388(ra) # 80005e7e <printf>
    p->killed = 1;
    80001d02:	4785                	li	a5,1
    80001d04:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d06:	557d                	li	a0,-1
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	a56080e7          	jalr	-1450(ra) # 8000175e <exit>
  if(which_dev == 2)
    80001d10:	4789                	li	a5,2
    80001d12:	f8f910e3          	bne	s2,a5,80001c92 <usertrap+0x62>
    yield();
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	7b0080e7          	jalr	1968(ra) # 800014c6 <yield>
    80001d1e:	bf95                	j	80001c92 <usertrap+0x62>
  int which_dev = 0;
    80001d20:	4901                	li	s2,0
    80001d22:	b7d5                	j	80001d06 <usertrap+0xd6>

0000000080001d24 <kerneltrap>:
{
    80001d24:	7179                	addi	sp,sp,-48
    80001d26:	f406                	sd	ra,40(sp)
    80001d28:	f022                	sd	s0,32(sp)
    80001d2a:	ec26                	sd	s1,24(sp)
    80001d2c:	e84a                	sd	s2,16(sp)
    80001d2e:	e44e                	sd	s3,8(sp)
    80001d30:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d32:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d36:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d3e:	1004f793          	andi	a5,s1,256
    80001d42:	cb85                	beqz	a5,80001d72 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d48:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d4a:	ef85                	bnez	a5,80001d82 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	e42080e7          	jalr	-446(ra) # 80001b8e <devintr>
    80001d54:	cd1d                	beqz	a0,80001d92 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d56:	4789                	li	a5,2
    80001d58:	06f50a63          	beq	a0,a5,80001dcc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d60:	10049073          	csrw	sstatus,s1
}
    80001d64:	70a2                	ld	ra,40(sp)
    80001d66:	7402                	ld	s0,32(sp)
    80001d68:	64e2                	ld	s1,24(sp)
    80001d6a:	6942                	ld	s2,16(sp)
    80001d6c:	69a2                	ld	s3,8(sp)
    80001d6e:	6145                	addi	sp,sp,48
    80001d70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	59650513          	addi	a0,a0,1430 # 80008308 <states.0+0xc8>
    80001d7a:	00004097          	auipc	ra,0x4
    80001d7e:	0ba080e7          	jalr	186(ra) # 80005e34 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	5ae50513          	addi	a0,a0,1454 # 80008330 <states.0+0xf0>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	0aa080e7          	jalr	170(ra) # 80005e34 <panic>
    printf("scause %p\n", scause);
    80001d92:	85ce                	mv	a1,s3
    80001d94:	00006517          	auipc	a0,0x6
    80001d98:	5bc50513          	addi	a0,a0,1468 # 80008350 <states.0+0x110>
    80001d9c:	00004097          	auipc	ra,0x4
    80001da0:	0e2080e7          	jalr	226(ra) # 80005e7e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dac:	00006517          	auipc	a0,0x6
    80001db0:	5b450513          	addi	a0,a0,1460 # 80008360 <states.0+0x120>
    80001db4:	00004097          	auipc	ra,0x4
    80001db8:	0ca080e7          	jalr	202(ra) # 80005e7e <printf>
    panic("kerneltrap");
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	5bc50513          	addi	a0,a0,1468 # 80008378 <states.0+0x138>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	070080e7          	jalr	112(ra) # 80005e34 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dcc:	fffff097          	auipc	ra,0xfffff
    80001dd0:	076080e7          	jalr	118(ra) # 80000e42 <myproc>
    80001dd4:	d541                	beqz	a0,80001d5c <kerneltrap+0x38>
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	06c080e7          	jalr	108(ra) # 80000e42 <myproc>
    80001dde:	4d18                	lw	a4,24(a0)
    80001de0:	4791                	li	a5,4
    80001de2:	f6f71de3          	bne	a4,a5,80001d5c <kerneltrap+0x38>
    yield();
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	6e0080e7          	jalr	1760(ra) # 800014c6 <yield>
    80001dee:	b7bd                	j	80001d5c <kerneltrap+0x38>

0000000080001df0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	1000                	addi	s0,sp,32
    80001dfa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	046080e7          	jalr	70(ra) # 80000e42 <myproc>
  switch (n) {
    80001e04:	4795                	li	a5,5
    80001e06:	0497e163          	bltu	a5,s1,80001e48 <argraw+0x58>
    80001e0a:	048a                	slli	s1,s1,0x2
    80001e0c:	00006717          	auipc	a4,0x6
    80001e10:	5a470713          	addi	a4,a4,1444 # 800083b0 <states.0+0x170>
    80001e14:	94ba                	add	s1,s1,a4
    80001e16:	409c                	lw	a5,0(s1)
    80001e18:	97ba                	add	a5,a5,a4
    80001e1a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1c:	6d3c                	ld	a5,88(a0)
    80001e1e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e20:	60e2                	ld	ra,24(sp)
    80001e22:	6442                	ld	s0,16(sp)
    80001e24:	64a2                	ld	s1,8(sp)
    80001e26:	6105                	addi	sp,sp,32
    80001e28:	8082                	ret
    return p->trapframe->a1;
    80001e2a:	6d3c                	ld	a5,88(a0)
    80001e2c:	7fa8                	ld	a0,120(a5)
    80001e2e:	bfcd                	j	80001e20 <argraw+0x30>
    return p->trapframe->a2;
    80001e30:	6d3c                	ld	a5,88(a0)
    80001e32:	63c8                	ld	a0,128(a5)
    80001e34:	b7f5                	j	80001e20 <argraw+0x30>
    return p->trapframe->a3;
    80001e36:	6d3c                	ld	a5,88(a0)
    80001e38:	67c8                	ld	a0,136(a5)
    80001e3a:	b7dd                	j	80001e20 <argraw+0x30>
    return p->trapframe->a4;
    80001e3c:	6d3c                	ld	a5,88(a0)
    80001e3e:	6bc8                	ld	a0,144(a5)
    80001e40:	b7c5                	j	80001e20 <argraw+0x30>
    return p->trapframe->a5;
    80001e42:	6d3c                	ld	a5,88(a0)
    80001e44:	6fc8                	ld	a0,152(a5)
    80001e46:	bfe9                	j	80001e20 <argraw+0x30>
  panic("argraw");
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	54050513          	addi	a0,a0,1344 # 80008388 <states.0+0x148>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	fe4080e7          	jalr	-28(ra) # 80005e34 <panic>

0000000080001e58 <fetchaddr>:
{
    80001e58:	1101                	addi	sp,sp,-32
    80001e5a:	ec06                	sd	ra,24(sp)
    80001e5c:	e822                	sd	s0,16(sp)
    80001e5e:	e426                	sd	s1,8(sp)
    80001e60:	e04a                	sd	s2,0(sp)
    80001e62:	1000                	addi	s0,sp,32
    80001e64:	84aa                	mv	s1,a0
    80001e66:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	fda080e7          	jalr	-38(ra) # 80000e42 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e70:	653c                	ld	a5,72(a0)
    80001e72:	02f4f863          	bgeu	s1,a5,80001ea2 <fetchaddr+0x4a>
    80001e76:	00848713          	addi	a4,s1,8
    80001e7a:	02e7e663          	bltu	a5,a4,80001ea6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e7e:	46a1                	li	a3,8
    80001e80:	8626                	mv	a2,s1
    80001e82:	85ca                	mv	a1,s2
    80001e84:	6928                	ld	a0,80(a0)
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	d08080e7          	jalr	-760(ra) # 80000b8e <copyin>
    80001e8e:	00a03533          	snez	a0,a0
    80001e92:	40a00533          	neg	a0,a0
}
    80001e96:	60e2                	ld	ra,24(sp)
    80001e98:	6442                	ld	s0,16(sp)
    80001e9a:	64a2                	ld	s1,8(sp)
    80001e9c:	6902                	ld	s2,0(sp)
    80001e9e:	6105                	addi	sp,sp,32
    80001ea0:	8082                	ret
    return -1;
    80001ea2:	557d                	li	a0,-1
    80001ea4:	bfcd                	j	80001e96 <fetchaddr+0x3e>
    80001ea6:	557d                	li	a0,-1
    80001ea8:	b7fd                	j	80001e96 <fetchaddr+0x3e>

0000000080001eaa <fetchstr>:
{
    80001eaa:	7179                	addi	sp,sp,-48
    80001eac:	f406                	sd	ra,40(sp)
    80001eae:	f022                	sd	s0,32(sp)
    80001eb0:	ec26                	sd	s1,24(sp)
    80001eb2:	e84a                	sd	s2,16(sp)
    80001eb4:	e44e                	sd	s3,8(sp)
    80001eb6:	1800                	addi	s0,sp,48
    80001eb8:	892a                	mv	s2,a0
    80001eba:	84ae                	mv	s1,a1
    80001ebc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	f84080e7          	jalr	-124(ra) # 80000e42 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec6:	86ce                	mv	a3,s3
    80001ec8:	864a                	mv	a2,s2
    80001eca:	85a6                	mv	a1,s1
    80001ecc:	6928                	ld	a0,80(a0)
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	d4e080e7          	jalr	-690(ra) # 80000c1c <copyinstr>
  if(err < 0)
    80001ed6:	00054763          	bltz	a0,80001ee4 <fetchstr+0x3a>
  return strlen(buf);
    80001eda:	8526                	mv	a0,s1
    80001edc:	ffffe097          	auipc	ra,0xffffe
    80001ee0:	418080e7          	jalr	1048(ra) # 800002f4 <strlen>
}
    80001ee4:	70a2                	ld	ra,40(sp)
    80001ee6:	7402                	ld	s0,32(sp)
    80001ee8:	64e2                	ld	s1,24(sp)
    80001eea:	6942                	ld	s2,16(sp)
    80001eec:	69a2                	ld	s3,8(sp)
    80001eee:	6145                	addi	sp,sp,48
    80001ef0:	8082                	ret

0000000080001ef2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	1000                	addi	s0,sp,32
    80001efc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	ef2080e7          	jalr	-270(ra) # 80001df0 <argraw>
    80001f06:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f08:	4501                	li	a0,0
    80001f0a:	60e2                	ld	ra,24(sp)
    80001f0c:	6442                	ld	s0,16(sp)
    80001f0e:	64a2                	ld	s1,8(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret

0000000080001f14 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f14:	1101                	addi	sp,sp,-32
    80001f16:	ec06                	sd	ra,24(sp)
    80001f18:	e822                	sd	s0,16(sp)
    80001f1a:	e426                	sd	s1,8(sp)
    80001f1c:	1000                	addi	s0,sp,32
    80001f1e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	ed0080e7          	jalr	-304(ra) # 80001df0 <argraw>
    80001f28:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f2a:	4501                	li	a0,0
    80001f2c:	60e2                	ld	ra,24(sp)
    80001f2e:	6442                	ld	s0,16(sp)
    80001f30:	64a2                	ld	s1,8(sp)
    80001f32:	6105                	addi	sp,sp,32
    80001f34:	8082                	ret

0000000080001f36 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f36:	1101                	addi	sp,sp,-32
    80001f38:	ec06                	sd	ra,24(sp)
    80001f3a:	e822                	sd	s0,16(sp)
    80001f3c:	e426                	sd	s1,8(sp)
    80001f3e:	e04a                	sd	s2,0(sp)
    80001f40:	1000                	addi	s0,sp,32
    80001f42:	84ae                	mv	s1,a1
    80001f44:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f46:	00000097          	auipc	ra,0x0
    80001f4a:	eaa080e7          	jalr	-342(ra) # 80001df0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f4e:	864a                	mv	a2,s2
    80001f50:	85a6                	mv	a1,s1
    80001f52:	00000097          	auipc	ra,0x0
    80001f56:	f58080e7          	jalr	-168(ra) # 80001eaa <fetchstr>
}
    80001f5a:	60e2                	ld	ra,24(sp)
    80001f5c:	6442                	ld	s0,16(sp)
    80001f5e:	64a2                	ld	s1,8(sp)
    80001f60:	6902                	ld	s2,0(sp)
    80001f62:	6105                	addi	sp,sp,32
    80001f64:	8082                	ret

0000000080001f66 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	e04a                	sd	s2,0(sp)
    80001f70:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	ed0080e7          	jalr	-304(ra) # 80000e42 <myproc>
    80001f7a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7c:	05853903          	ld	s2,88(a0)
    80001f80:	0a893783          	ld	a5,168(s2)
    80001f84:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f88:	37fd                	addiw	a5,a5,-1
    80001f8a:	4755                	li	a4,21
    80001f8c:	00f76f63          	bltu	a4,a5,80001faa <syscall+0x44>
    80001f90:	00369713          	slli	a4,a3,0x3
    80001f94:	00006797          	auipc	a5,0x6
    80001f98:	43478793          	addi	a5,a5,1076 # 800083c8 <syscalls>
    80001f9c:	97ba                	add	a5,a5,a4
    80001f9e:	639c                	ld	a5,0(a5)
    80001fa0:	c789                	beqz	a5,80001faa <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa2:	9782                	jalr	a5
    80001fa4:	06a93823          	sd	a0,112(s2)
    80001fa8:	a839                	j	80001fc6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001faa:	15848613          	addi	a2,s1,344
    80001fae:	588c                	lw	a1,48(s1)
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	3e050513          	addi	a0,a0,992 # 80008390 <states.0+0x150>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	ec6080e7          	jalr	-314(ra) # 80005e7e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc0:	6cbc                	ld	a5,88(s1)
    80001fc2:	577d                	li	a4,-1
    80001fc4:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc6:	60e2                	ld	ra,24(sp)
    80001fc8:	6442                	ld	s0,16(sp)
    80001fca:	64a2                	ld	s1,8(sp)
    80001fcc:	6902                	ld	s2,0(sp)
    80001fce:	6105                	addi	sp,sp,32
    80001fd0:	8082                	ret

0000000080001fd2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd2:	1101                	addi	sp,sp,-32
    80001fd4:	ec06                	sd	ra,24(sp)
    80001fd6:	e822                	sd	s0,16(sp)
    80001fd8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fda:	fec40593          	addi	a1,s0,-20
    80001fde:	4501                	li	a0,0
    80001fe0:	00000097          	auipc	ra,0x0
    80001fe4:	f12080e7          	jalr	-238(ra) # 80001ef2 <argint>
    return -1;
    80001fe8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fea:	00054963          	bltz	a0,80001ffc <sys_exit+0x2a>
  exit(n);
    80001fee:	fec42503          	lw	a0,-20(s0)
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	76c080e7          	jalr	1900(ra) # 8000175e <exit>
  return 0;  // not reached
    80001ffa:	4781                	li	a5,0
}
    80001ffc:	853e                	mv	a0,a5
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	6105                	addi	sp,sp,32
    80002004:	8082                	ret

0000000080002006 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002006:	1141                	addi	sp,sp,-16
    80002008:	e406                	sd	ra,8(sp)
    8000200a:	e022                	sd	s0,0(sp)
    8000200c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	e34080e7          	jalr	-460(ra) # 80000e42 <myproc>
}
    80002016:	5908                	lw	a0,48(a0)
    80002018:	60a2                	ld	ra,8(sp)
    8000201a:	6402                	ld	s0,0(sp)
    8000201c:	0141                	addi	sp,sp,16
    8000201e:	8082                	ret

0000000080002020 <sys_fork>:

uint64
sys_fork(void)
{
    80002020:	1141                	addi	sp,sp,-16
    80002022:	e406                	sd	ra,8(sp)
    80002024:	e022                	sd	s0,0(sp)
    80002026:	0800                	addi	s0,sp,16
  return fork();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	1e8080e7          	jalr	488(ra) # 80001210 <fork>
}
    80002030:	60a2                	ld	ra,8(sp)
    80002032:	6402                	ld	s0,0(sp)
    80002034:	0141                	addi	sp,sp,16
    80002036:	8082                	ret

0000000080002038 <sys_wait>:

uint64
sys_wait(void)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002040:	fe840593          	addi	a1,s0,-24
    80002044:	4501                	li	a0,0
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	ece080e7          	jalr	-306(ra) # 80001f14 <argaddr>
    8000204e:	87aa                	mv	a5,a0
    return -1;
    80002050:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002052:	0007c863          	bltz	a5,80002062 <sys_wait+0x2a>
  return wait(p);
    80002056:	fe843503          	ld	a0,-24(s0)
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	50c080e7          	jalr	1292(ra) # 80001566 <wait>
}
    80002062:	60e2                	ld	ra,24(sp)
    80002064:	6442                	ld	s0,16(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002074:	fdc40593          	addi	a1,s0,-36
    80002078:	4501                	li	a0,0
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	e78080e7          	jalr	-392(ra) # 80001ef2 <argint>
    return -1;
    80002082:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002084:	00054f63          	bltz	a0,800020a2 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	dba080e7          	jalr	-582(ra) # 80000e42 <myproc>
    80002090:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002092:	fdc42503          	lw	a0,-36(s0)
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	106080e7          	jalr	262(ra) # 8000119c <growproc>
    8000209e:	00054863          	bltz	a0,800020ae <sys_sbrk+0x44>
    return -1;
  return addr;
}
    800020a2:	8526                	mv	a0,s1
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6145                	addi	sp,sp,48
    800020ac:	8082                	ret
    return -1;
    800020ae:	54fd                	li	s1,-1
    800020b0:	bfcd                	j	800020a2 <sys_sbrk+0x38>

00000000800020b2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b2:	7139                	addi	sp,sp,-64
    800020b4:	fc06                	sd	ra,56(sp)
    800020b6:	f822                	sd	s0,48(sp)
    800020b8:	f426                	sd	s1,40(sp)
    800020ba:	f04a                	sd	s2,32(sp)
    800020bc:	ec4e                	sd	s3,24(sp)
    800020be:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020c0:	fcc40593          	addi	a1,s0,-52
    800020c4:	4501                	li	a0,0
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	e2c080e7          	jalr	-468(ra) # 80001ef2 <argint>
    return -1;
    800020ce:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d0:	06054563          	bltz	a0,8000213a <sys_sleep+0x88>
  acquire(&tickslock);
    800020d4:	00008517          	auipc	a0,0x8
    800020d8:	1bc50513          	addi	a0,a0,444 # 8000a290 <tickslock>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	294080e7          	jalr	660(ra) # 80006370 <acquire>
  ticks0 = ticks;
    800020e4:	00007917          	auipc	s2,0x7
    800020e8:	f3492903          	lw	s2,-204(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020ec:	fcc42783          	lw	a5,-52(s0)
    800020f0:	cf85                	beqz	a5,80002128 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f2:	00008997          	auipc	s3,0x8
    800020f6:	19e98993          	addi	s3,s3,414 # 8000a290 <tickslock>
    800020fa:	00007497          	auipc	s1,0x7
    800020fe:	f1e48493          	addi	s1,s1,-226 # 80009018 <ticks>
    if(myproc()->killed){
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	d40080e7          	jalr	-704(ra) # 80000e42 <myproc>
    8000210a:	551c                	lw	a5,40(a0)
    8000210c:	ef9d                	bnez	a5,8000214a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000210e:	85ce                	mv	a1,s3
    80002110:	8526                	mv	a0,s1
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	3f0080e7          	jalr	1008(ra) # 80001502 <sleep>
  while(ticks - ticks0 < n){
    8000211a:	409c                	lw	a5,0(s1)
    8000211c:	412787bb          	subw	a5,a5,s2
    80002120:	fcc42703          	lw	a4,-52(s0)
    80002124:	fce7efe3          	bltu	a5,a4,80002102 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002128:	00008517          	auipc	a0,0x8
    8000212c:	16850513          	addi	a0,a0,360 # 8000a290 <tickslock>
    80002130:	00004097          	auipc	ra,0x4
    80002134:	2f4080e7          	jalr	756(ra) # 80006424 <release>
  return 0;
    80002138:	4781                	li	a5,0
}
    8000213a:	853e                	mv	a0,a5
    8000213c:	70e2                	ld	ra,56(sp)
    8000213e:	7442                	ld	s0,48(sp)
    80002140:	74a2                	ld	s1,40(sp)
    80002142:	7902                	ld	s2,32(sp)
    80002144:	69e2                	ld	s3,24(sp)
    80002146:	6121                	addi	sp,sp,64
    80002148:	8082                	ret
      release(&tickslock);
    8000214a:	00008517          	auipc	a0,0x8
    8000214e:	14650513          	addi	a0,a0,326 # 8000a290 <tickslock>
    80002152:	00004097          	auipc	ra,0x4
    80002156:	2d2080e7          	jalr	722(ra) # 80006424 <release>
      return -1;
    8000215a:	57fd                	li	a5,-1
    8000215c:	bff9                	j	8000213a <sys_sleep+0x88>

000000008000215e <sys_kill>:

uint64
sys_kill(void)
{
    8000215e:	1101                	addi	sp,sp,-32
    80002160:	ec06                	sd	ra,24(sp)
    80002162:	e822                	sd	s0,16(sp)
    80002164:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002166:	fec40593          	addi	a1,s0,-20
    8000216a:	4501                	li	a0,0
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	d86080e7          	jalr	-634(ra) # 80001ef2 <argint>
    80002174:	87aa                	mv	a5,a0
    return -1;
    80002176:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002178:	0007c863          	bltz	a5,80002188 <sys_kill+0x2a>
  return kill(pid);
    8000217c:	fec42503          	lw	a0,-20(s0)
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	6b4080e7          	jalr	1716(ra) # 80001834 <kill>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	6105                	addi	sp,sp,32
    8000218e:	8082                	ret

0000000080002190 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002190:	1101                	addi	sp,sp,-32
    80002192:	ec06                	sd	ra,24(sp)
    80002194:	e822                	sd	s0,16(sp)
    80002196:	e426                	sd	s1,8(sp)
    80002198:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000219a:	00008517          	auipc	a0,0x8
    8000219e:	0f650513          	addi	a0,a0,246 # 8000a290 <tickslock>
    800021a2:	00004097          	auipc	ra,0x4
    800021a6:	1ce080e7          	jalr	462(ra) # 80006370 <acquire>
  xticks = ticks;
    800021aa:	00007497          	auipc	s1,0x7
    800021ae:	e6e4a483          	lw	s1,-402(s1) # 80009018 <ticks>
  release(&tickslock);
    800021b2:	00008517          	auipc	a0,0x8
    800021b6:	0de50513          	addi	a0,a0,222 # 8000a290 <tickslock>
    800021ba:	00004097          	auipc	ra,0x4
    800021be:	26a080e7          	jalr	618(ra) # 80006424 <release>
  return xticks;
}
    800021c2:	02049513          	slli	a0,s1,0x20
    800021c6:	9101                	srli	a0,a0,0x20
    800021c8:	60e2                	ld	ra,24(sp)
    800021ca:	6442                	ld	s0,16(sp)
    800021cc:	64a2                	ld	s1,8(sp)
    800021ce:	6105                	addi	sp,sp,32
    800021d0:	8082                	ret

00000000800021d2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021d2:	7179                	addi	sp,sp,-48
    800021d4:	f406                	sd	ra,40(sp)
    800021d6:	f022                	sd	s0,32(sp)
    800021d8:	ec26                	sd	s1,24(sp)
    800021da:	e84a                	sd	s2,16(sp)
    800021dc:	e44e                	sd	s3,8(sp)
    800021de:	e052                	sd	s4,0(sp)
    800021e0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021e2:	00006597          	auipc	a1,0x6
    800021e6:	29e58593          	addi	a1,a1,670 # 80008480 <syscalls+0xb8>
    800021ea:	00008517          	auipc	a0,0x8
    800021ee:	0be50513          	addi	a0,a0,190 # 8000a2a8 <bcache>
    800021f2:	00004097          	auipc	ra,0x4
    800021f6:	0ee080e7          	jalr	238(ra) # 800062e0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021fa:	00010797          	auipc	a5,0x10
    800021fe:	0ae78793          	addi	a5,a5,174 # 800122a8 <bcache+0x8000>
    80002202:	00010717          	auipc	a4,0x10
    80002206:	30e70713          	addi	a4,a4,782 # 80012510 <bcache+0x8268>
    8000220a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000220e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002212:	00008497          	auipc	s1,0x8
    80002216:	0ae48493          	addi	s1,s1,174 # 8000a2c0 <bcache+0x18>
    b->next = bcache.head.next;
    8000221a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000221c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000221e:	00006a17          	auipc	s4,0x6
    80002222:	26aa0a13          	addi	s4,s4,618 # 80008488 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002226:	2b893783          	ld	a5,696(s2)
    8000222a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000222c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002230:	85d2                	mv	a1,s4
    80002232:	01048513          	addi	a0,s1,16
    80002236:	00001097          	auipc	ra,0x1
    8000223a:	626080e7          	jalr	1574(ra) # 8000385c <initsleeplock>
    bcache.head.next->prev = b;
    8000223e:	2b893783          	ld	a5,696(s2)
    80002242:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002244:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002248:	45848493          	addi	s1,s1,1112
    8000224c:	fd349de3          	bne	s1,s3,80002226 <binit+0x54>
  }
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6942                	ld	s2,16(sp)
    80002258:	69a2                	ld	s3,8(sp)
    8000225a:	6a02                	ld	s4,0(sp)
    8000225c:	6145                	addi	sp,sp,48
    8000225e:	8082                	ret

0000000080002260 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002260:	7179                	addi	sp,sp,-48
    80002262:	f406                	sd	ra,40(sp)
    80002264:	f022                	sd	s0,32(sp)
    80002266:	ec26                	sd	s1,24(sp)
    80002268:	e84a                	sd	s2,16(sp)
    8000226a:	e44e                	sd	s3,8(sp)
    8000226c:	1800                	addi	s0,sp,48
    8000226e:	892a                	mv	s2,a0
    80002270:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002272:	00008517          	auipc	a0,0x8
    80002276:	03650513          	addi	a0,a0,54 # 8000a2a8 <bcache>
    8000227a:	00004097          	auipc	ra,0x4
    8000227e:	0f6080e7          	jalr	246(ra) # 80006370 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002282:	00010497          	auipc	s1,0x10
    80002286:	2de4b483          	ld	s1,734(s1) # 80012560 <bcache+0x82b8>
    8000228a:	00010797          	auipc	a5,0x10
    8000228e:	28678793          	addi	a5,a5,646 # 80012510 <bcache+0x8268>
    80002292:	02f48f63          	beq	s1,a5,800022d0 <bread+0x70>
    80002296:	873e                	mv	a4,a5
    80002298:	a021                	j	800022a0 <bread+0x40>
    8000229a:	68a4                	ld	s1,80(s1)
    8000229c:	02e48a63          	beq	s1,a4,800022d0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022a0:	449c                	lw	a5,8(s1)
    800022a2:	ff279ce3          	bne	a5,s2,8000229a <bread+0x3a>
    800022a6:	44dc                	lw	a5,12(s1)
    800022a8:	ff3799e3          	bne	a5,s3,8000229a <bread+0x3a>
      b->refcnt++;
    800022ac:	40bc                	lw	a5,64(s1)
    800022ae:	2785                	addiw	a5,a5,1
    800022b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022b2:	00008517          	auipc	a0,0x8
    800022b6:	ff650513          	addi	a0,a0,-10 # 8000a2a8 <bcache>
    800022ba:	00004097          	auipc	ra,0x4
    800022be:	16a080e7          	jalr	362(ra) # 80006424 <release>
      acquiresleep(&b->lock);
    800022c2:	01048513          	addi	a0,s1,16
    800022c6:	00001097          	auipc	ra,0x1
    800022ca:	5d0080e7          	jalr	1488(ra) # 80003896 <acquiresleep>
      return b;
    800022ce:	a8b9                	j	8000232c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d0:	00010497          	auipc	s1,0x10
    800022d4:	2884b483          	ld	s1,648(s1) # 80012558 <bcache+0x82b0>
    800022d8:	00010797          	auipc	a5,0x10
    800022dc:	23878793          	addi	a5,a5,568 # 80012510 <bcache+0x8268>
    800022e0:	00f48863          	beq	s1,a5,800022f0 <bread+0x90>
    800022e4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022e6:	40bc                	lw	a5,64(s1)
    800022e8:	cf81                	beqz	a5,80002300 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ea:	64a4                	ld	s1,72(s1)
    800022ec:	fee49de3          	bne	s1,a4,800022e6 <bread+0x86>
  panic("bget: no buffers");
    800022f0:	00006517          	auipc	a0,0x6
    800022f4:	1a050513          	addi	a0,a0,416 # 80008490 <syscalls+0xc8>
    800022f8:	00004097          	auipc	ra,0x4
    800022fc:	b3c080e7          	jalr	-1220(ra) # 80005e34 <panic>
      b->dev = dev;
    80002300:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002304:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002308:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000230c:	4785                	li	a5,1
    8000230e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002310:	00008517          	auipc	a0,0x8
    80002314:	f9850513          	addi	a0,a0,-104 # 8000a2a8 <bcache>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	10c080e7          	jalr	268(ra) # 80006424 <release>
      acquiresleep(&b->lock);
    80002320:	01048513          	addi	a0,s1,16
    80002324:	00001097          	auipc	ra,0x1
    80002328:	572080e7          	jalr	1394(ra) # 80003896 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000232c:	409c                	lw	a5,0(s1)
    8000232e:	cb89                	beqz	a5,80002340 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002330:	8526                	mv	a0,s1
    80002332:	70a2                	ld	ra,40(sp)
    80002334:	7402                	ld	s0,32(sp)
    80002336:	64e2                	ld	s1,24(sp)
    80002338:	6942                	ld	s2,16(sp)
    8000233a:	69a2                	ld	s3,8(sp)
    8000233c:	6145                	addi	sp,sp,48
    8000233e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002340:	4581                	li	a1,0
    80002342:	8526                	mv	a0,s1
    80002344:	00003097          	auipc	ra,0x3
    80002348:	282080e7          	jalr	642(ra) # 800055c6 <virtio_disk_rw>
    b->valid = 1;
    8000234c:	4785                	li	a5,1
    8000234e:	c09c                	sw	a5,0(s1)
  return b;
    80002350:	b7c5                	j	80002330 <bread+0xd0>

0000000080002352 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002352:	1101                	addi	sp,sp,-32
    80002354:	ec06                	sd	ra,24(sp)
    80002356:	e822                	sd	s0,16(sp)
    80002358:	e426                	sd	s1,8(sp)
    8000235a:	1000                	addi	s0,sp,32
    8000235c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000235e:	0541                	addi	a0,a0,16
    80002360:	00001097          	auipc	ra,0x1
    80002364:	5d0080e7          	jalr	1488(ra) # 80003930 <holdingsleep>
    80002368:	cd01                	beqz	a0,80002380 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000236a:	4585                	li	a1,1
    8000236c:	8526                	mv	a0,s1
    8000236e:	00003097          	auipc	ra,0x3
    80002372:	258080e7          	jalr	600(ra) # 800055c6 <virtio_disk_rw>
}
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	64a2                	ld	s1,8(sp)
    8000237c:	6105                	addi	sp,sp,32
    8000237e:	8082                	ret
    panic("bwrite");
    80002380:	00006517          	auipc	a0,0x6
    80002384:	12850513          	addi	a0,a0,296 # 800084a8 <syscalls+0xe0>
    80002388:	00004097          	auipc	ra,0x4
    8000238c:	aac080e7          	jalr	-1364(ra) # 80005e34 <panic>

0000000080002390 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002390:	1101                	addi	sp,sp,-32
    80002392:	ec06                	sd	ra,24(sp)
    80002394:	e822                	sd	s0,16(sp)
    80002396:	e426                	sd	s1,8(sp)
    80002398:	e04a                	sd	s2,0(sp)
    8000239a:	1000                	addi	s0,sp,32
    8000239c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000239e:	01050913          	addi	s2,a0,16
    800023a2:	854a                	mv	a0,s2
    800023a4:	00001097          	auipc	ra,0x1
    800023a8:	58c080e7          	jalr	1420(ra) # 80003930 <holdingsleep>
    800023ac:	c92d                	beqz	a0,8000241e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023ae:	854a                	mv	a0,s2
    800023b0:	00001097          	auipc	ra,0x1
    800023b4:	53c080e7          	jalr	1340(ra) # 800038ec <releasesleep>

  acquire(&bcache.lock);
    800023b8:	00008517          	auipc	a0,0x8
    800023bc:	ef050513          	addi	a0,a0,-272 # 8000a2a8 <bcache>
    800023c0:	00004097          	auipc	ra,0x4
    800023c4:	fb0080e7          	jalr	-80(ra) # 80006370 <acquire>
  b->refcnt--;
    800023c8:	40bc                	lw	a5,64(s1)
    800023ca:	37fd                	addiw	a5,a5,-1
    800023cc:	0007871b          	sext.w	a4,a5
    800023d0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023d2:	eb05                	bnez	a4,80002402 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023d4:	68bc                	ld	a5,80(s1)
    800023d6:	64b8                	ld	a4,72(s1)
    800023d8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023da:	64bc                	ld	a5,72(s1)
    800023dc:	68b8                	ld	a4,80(s1)
    800023de:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023e0:	00010797          	auipc	a5,0x10
    800023e4:	ec878793          	addi	a5,a5,-312 # 800122a8 <bcache+0x8000>
    800023e8:	2b87b703          	ld	a4,696(a5)
    800023ec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023ee:	00010717          	auipc	a4,0x10
    800023f2:	12270713          	addi	a4,a4,290 # 80012510 <bcache+0x8268>
    800023f6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023f8:	2b87b703          	ld	a4,696(a5)
    800023fc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800023fe:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002402:	00008517          	auipc	a0,0x8
    80002406:	ea650513          	addi	a0,a0,-346 # 8000a2a8 <bcache>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	01a080e7          	jalr	26(ra) # 80006424 <release>
}
    80002412:	60e2                	ld	ra,24(sp)
    80002414:	6442                	ld	s0,16(sp)
    80002416:	64a2                	ld	s1,8(sp)
    80002418:	6902                	ld	s2,0(sp)
    8000241a:	6105                	addi	sp,sp,32
    8000241c:	8082                	ret
    panic("brelse");
    8000241e:	00006517          	auipc	a0,0x6
    80002422:	09250513          	addi	a0,a0,146 # 800084b0 <syscalls+0xe8>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	a0e080e7          	jalr	-1522(ra) # 80005e34 <panic>

000000008000242e <bpin>:

void
bpin(struct buf *b) {
    8000242e:	1101                	addi	sp,sp,-32
    80002430:	ec06                	sd	ra,24(sp)
    80002432:	e822                	sd	s0,16(sp)
    80002434:	e426                	sd	s1,8(sp)
    80002436:	1000                	addi	s0,sp,32
    80002438:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243a:	00008517          	auipc	a0,0x8
    8000243e:	e6e50513          	addi	a0,a0,-402 # 8000a2a8 <bcache>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	f2e080e7          	jalr	-210(ra) # 80006370 <acquire>
  b->refcnt++;
    8000244a:	40bc                	lw	a5,64(s1)
    8000244c:	2785                	addiw	a5,a5,1
    8000244e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002450:	00008517          	auipc	a0,0x8
    80002454:	e5850513          	addi	a0,a0,-424 # 8000a2a8 <bcache>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	fcc080e7          	jalr	-52(ra) # 80006424 <release>
}
    80002460:	60e2                	ld	ra,24(sp)
    80002462:	6442                	ld	s0,16(sp)
    80002464:	64a2                	ld	s1,8(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret

000000008000246a <bunpin>:

void
bunpin(struct buf *b) {
    8000246a:	1101                	addi	sp,sp,-32
    8000246c:	ec06                	sd	ra,24(sp)
    8000246e:	e822                	sd	s0,16(sp)
    80002470:	e426                	sd	s1,8(sp)
    80002472:	1000                	addi	s0,sp,32
    80002474:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002476:	00008517          	auipc	a0,0x8
    8000247a:	e3250513          	addi	a0,a0,-462 # 8000a2a8 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	ef2080e7          	jalr	-270(ra) # 80006370 <acquire>
  b->refcnt--;
    80002486:	40bc                	lw	a5,64(s1)
    80002488:	37fd                	addiw	a5,a5,-1
    8000248a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000248c:	00008517          	auipc	a0,0x8
    80002490:	e1c50513          	addi	a0,a0,-484 # 8000a2a8 <bcache>
    80002494:	00004097          	auipc	ra,0x4
    80002498:	f90080e7          	jalr	-112(ra) # 80006424 <release>
}
    8000249c:	60e2                	ld	ra,24(sp)
    8000249e:	6442                	ld	s0,16(sp)
    800024a0:	64a2                	ld	s1,8(sp)
    800024a2:	6105                	addi	sp,sp,32
    800024a4:	8082                	ret

00000000800024a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	e426                	sd	s1,8(sp)
    800024ae:	e04a                	sd	s2,0(sp)
    800024b0:	1000                	addi	s0,sp,32
    800024b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b4:	00d5d59b          	srliw	a1,a1,0xd
    800024b8:	00010797          	auipc	a5,0x10
    800024bc:	4cc7a783          	lw	a5,1228(a5) # 80012984 <sb+0x1c>
    800024c0:	9dbd                	addw	a1,a1,a5
    800024c2:	00000097          	auipc	ra,0x0
    800024c6:	d9e080e7          	jalr	-610(ra) # 80002260 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ca:	0074f713          	andi	a4,s1,7
    800024ce:	4785                	li	a5,1
    800024d0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d4:	14ce                	slli	s1,s1,0x33
    800024d6:	90d9                	srli	s1,s1,0x36
    800024d8:	00950733          	add	a4,a0,s1
    800024dc:	05874703          	lbu	a4,88(a4)
    800024e0:	00e7f6b3          	and	a3,a5,a4
    800024e4:	c69d                	beqz	a3,80002512 <bfree+0x6c>
    800024e6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024e8:	94aa                	add	s1,s1,a0
    800024ea:	fff7c793          	not	a5,a5
    800024ee:	8ff9                	and	a5,a5,a4
    800024f0:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800024f4:	00001097          	auipc	ra,0x1
    800024f8:	282080e7          	jalr	642(ra) # 80003776 <log_write>
  brelse(bp);
    800024fc:	854a                	mv	a0,s2
    800024fe:	00000097          	auipc	ra,0x0
    80002502:	e92080e7          	jalr	-366(ra) # 80002390 <brelse>
}
    80002506:	60e2                	ld	ra,24(sp)
    80002508:	6442                	ld	s0,16(sp)
    8000250a:	64a2                	ld	s1,8(sp)
    8000250c:	6902                	ld	s2,0(sp)
    8000250e:	6105                	addi	sp,sp,32
    80002510:	8082                	ret
    panic("freeing free block");
    80002512:	00006517          	auipc	a0,0x6
    80002516:	fa650513          	addi	a0,a0,-90 # 800084b8 <syscalls+0xf0>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	91a080e7          	jalr	-1766(ra) # 80005e34 <panic>

0000000080002522 <balloc>:
{
    80002522:	711d                	addi	sp,sp,-96
    80002524:	ec86                	sd	ra,88(sp)
    80002526:	e8a2                	sd	s0,80(sp)
    80002528:	e4a6                	sd	s1,72(sp)
    8000252a:	e0ca                	sd	s2,64(sp)
    8000252c:	fc4e                	sd	s3,56(sp)
    8000252e:	f852                	sd	s4,48(sp)
    80002530:	f456                	sd	s5,40(sp)
    80002532:	f05a                	sd	s6,32(sp)
    80002534:	ec5e                	sd	s7,24(sp)
    80002536:	e862                	sd	s8,16(sp)
    80002538:	e466                	sd	s9,8(sp)
    8000253a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000253c:	00010797          	auipc	a5,0x10
    80002540:	4307a783          	lw	a5,1072(a5) # 8001296c <sb+0x4>
    80002544:	cbd1                	beqz	a5,800025d8 <balloc+0xb6>
    80002546:	8baa                	mv	s7,a0
    80002548:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000254a:	00010b17          	auipc	s6,0x10
    8000254e:	41eb0b13          	addi	s6,s6,1054 # 80012968 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002552:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002554:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002556:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002558:	6c89                	lui	s9,0x2
    8000255a:	a831                	j	80002576 <balloc+0x54>
    brelse(bp);
    8000255c:	854a                	mv	a0,s2
    8000255e:	00000097          	auipc	ra,0x0
    80002562:	e32080e7          	jalr	-462(ra) # 80002390 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002566:	015c87bb          	addw	a5,s9,s5
    8000256a:	00078a9b          	sext.w	s5,a5
    8000256e:	004b2703          	lw	a4,4(s6)
    80002572:	06eaf363          	bgeu	s5,a4,800025d8 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002576:	41fad79b          	sraiw	a5,s5,0x1f
    8000257a:	0137d79b          	srliw	a5,a5,0x13
    8000257e:	015787bb          	addw	a5,a5,s5
    80002582:	40d7d79b          	sraiw	a5,a5,0xd
    80002586:	01cb2583          	lw	a1,28(s6)
    8000258a:	9dbd                	addw	a1,a1,a5
    8000258c:	855e                	mv	a0,s7
    8000258e:	00000097          	auipc	ra,0x0
    80002592:	cd2080e7          	jalr	-814(ra) # 80002260 <bread>
    80002596:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002598:	004b2503          	lw	a0,4(s6)
    8000259c:	000a849b          	sext.w	s1,s5
    800025a0:	8662                	mv	a2,s8
    800025a2:	faa4fde3          	bgeu	s1,a0,8000255c <balloc+0x3a>
      m = 1 << (bi % 8);
    800025a6:	41f6579b          	sraiw	a5,a2,0x1f
    800025aa:	01d7d69b          	srliw	a3,a5,0x1d
    800025ae:	00c6873b          	addw	a4,a3,a2
    800025b2:	00777793          	andi	a5,a4,7
    800025b6:	9f95                	subw	a5,a5,a3
    800025b8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025bc:	4037571b          	sraiw	a4,a4,0x3
    800025c0:	00e906b3          	add	a3,s2,a4
    800025c4:	0586c683          	lbu	a3,88(a3)
    800025c8:	00d7f5b3          	and	a1,a5,a3
    800025cc:	cd91                	beqz	a1,800025e8 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ce:	2605                	addiw	a2,a2,1
    800025d0:	2485                	addiw	s1,s1,1
    800025d2:	fd4618e3          	bne	a2,s4,800025a2 <balloc+0x80>
    800025d6:	b759                	j	8000255c <balloc+0x3a>
  panic("balloc: out of blocks");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	ef850513          	addi	a0,a0,-264 # 800084d0 <syscalls+0x108>
    800025e0:	00004097          	auipc	ra,0x4
    800025e4:	854080e7          	jalr	-1964(ra) # 80005e34 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025e8:	974a                	add	a4,a4,s2
    800025ea:	8fd5                	or	a5,a5,a3
    800025ec:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025f0:	854a                	mv	a0,s2
    800025f2:	00001097          	auipc	ra,0x1
    800025f6:	184080e7          	jalr	388(ra) # 80003776 <log_write>
        brelse(bp);
    800025fa:	854a                	mv	a0,s2
    800025fc:	00000097          	auipc	ra,0x0
    80002600:	d94080e7          	jalr	-620(ra) # 80002390 <brelse>
  bp = bread(dev, bno);
    80002604:	85a6                	mv	a1,s1
    80002606:	855e                	mv	a0,s7
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	c58080e7          	jalr	-936(ra) # 80002260 <bread>
    80002610:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002612:	40000613          	li	a2,1024
    80002616:	4581                	li	a1,0
    80002618:	05850513          	addi	a0,a0,88
    8000261c:	ffffe097          	auipc	ra,0xffffe
    80002620:	b5c080e7          	jalr	-1188(ra) # 80000178 <memset>
  log_write(bp);
    80002624:	854a                	mv	a0,s2
    80002626:	00001097          	auipc	ra,0x1
    8000262a:	150080e7          	jalr	336(ra) # 80003776 <log_write>
  brelse(bp);
    8000262e:	854a                	mv	a0,s2
    80002630:	00000097          	auipc	ra,0x0
    80002634:	d60080e7          	jalr	-672(ra) # 80002390 <brelse>
}
    80002638:	8526                	mv	a0,s1
    8000263a:	60e6                	ld	ra,88(sp)
    8000263c:	6446                	ld	s0,80(sp)
    8000263e:	64a6                	ld	s1,72(sp)
    80002640:	6906                	ld	s2,64(sp)
    80002642:	79e2                	ld	s3,56(sp)
    80002644:	7a42                	ld	s4,48(sp)
    80002646:	7aa2                	ld	s5,40(sp)
    80002648:	7b02                	ld	s6,32(sp)
    8000264a:	6be2                	ld	s7,24(sp)
    8000264c:	6c42                	ld	s8,16(sp)
    8000264e:	6ca2                	ld	s9,8(sp)
    80002650:	6125                	addi	sp,sp,96
    80002652:	8082                	ret

0000000080002654 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002654:	7139                	addi	sp,sp,-64
    80002656:	fc06                	sd	ra,56(sp)
    80002658:	f822                	sd	s0,48(sp)
    8000265a:	f426                	sd	s1,40(sp)
    8000265c:	f04a                	sd	s2,32(sp)
    8000265e:	ec4e                	sd	s3,24(sp)
    80002660:	e852                	sd	s4,16(sp)
    80002662:	e456                	sd	s5,8(sp)
    80002664:	0080                	addi	s0,sp,64
    80002666:	892a                	mv	s2,a0
  uint addr, *a,*a2;
  struct buf *bp,*bp2;

  if(bn < NDIRECT){
    80002668:	47a9                	li	a5,10
    8000266a:	08b7fb63          	bgeu	a5,a1,80002700 <bmap+0xac>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000266e:	ff55849b          	addiw	s1,a1,-11
    80002672:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002676:	0ff00793          	li	a5,255
    8000267a:	0ae7f663          	bgeu	a5,a4,80002726 <bmap+0xd2>
    }
    brelse(bp);
    return addr;
  }
   
 bn -= NINDIRECT;
    8000267e:	ef55859b          	addiw	a1,a1,-267
    80002682:	0005871b          	sext.w	a4,a1
if(bn < NINDIRECT*NINDIRECT){
    80002686:	67c1                	lui	a5,0x10
    80002688:	14f77c63          	bgeu	a4,a5,800027e0 <bmap+0x18c>
int geshu = bn / NINDIRECT;
    8000268c:	0085da9b          	srliw	s5,a1,0x8
int xuhao = bn % NINDIRECT;
    80002690:	0ff5f493          	andi	s1,a1,255
if((addr = ip->addrs[NDIRECT+1]) == 0)
    80002694:	08052583          	lw	a1,128(a0)
    80002698:	c9f5                	beqz	a1,8000278c <bmap+0x138>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);


  //第一次查找，得到了a[geshu]的地址
 bp = bread(ip->dev, addr);
    8000269a:	00092503          	lw	a0,0(s2)
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	bc2080e7          	jalr	-1086(ra) # 80002260 <bread>
    800026a6:	89aa                	mv	s3,a0
  a = (uint*)bp->data;
    800026a8:	05850a13          	addi	s4,a0,88
   if((addr = a[geshu]) == 0){
    800026ac:	0a8a                	slli	s5,s5,0x2
    800026ae:	9a56                	add	s4,s4,s5
    800026b0:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800026b4:	0e0a8663          	beqz	s5,800027a0 <bmap+0x14c>
      a[geshu] = addr = balloc(ip->dev);
      log_write(bp);
    }
 brelse(bp);
    800026b8:	854e                	mv	a0,s3
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	cd6080e7          	jalr	-810(ra) # 80002390 <brelse>




//第二次查找，得到的真正的地址
  bp2 = bread(ip->dev, addr);
    800026c2:	85d6                	mv	a1,s5
    800026c4:	00092503          	lw	a0,0(s2)
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	b98080e7          	jalr	-1128(ra) # 80002260 <bread>
    800026d0:	8a2a                	mv	s4,a0
  a2 = (uint*)bp2->data;
    800026d2:	05850793          	addi	a5,a0,88
   if((addr = a2[xuhao]) == 0){
    800026d6:	048a                	slli	s1,s1,0x2
    800026d8:	94be                	add	s1,s1,a5
    800026da:	0004a983          	lw	s3,0(s1)
    800026de:	0e098163          	beqz	s3,800027c0 <bmap+0x16c>
      a2[xuhao] = addr = balloc(ip->dev);
      log_write(bp2);
    }
 brelse(bp2);
    800026e2:	8552                	mv	a0,s4
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	cac080e7          	jalr	-852(ra) # 80002390 <brelse>

return addr;
}

  panic("bmap: out of range");
}
    800026ec:	854e                	mv	a0,s3
    800026ee:	70e2                	ld	ra,56(sp)
    800026f0:	7442                	ld	s0,48(sp)
    800026f2:	74a2                	ld	s1,40(sp)
    800026f4:	7902                	ld	s2,32(sp)
    800026f6:	69e2                	ld	s3,24(sp)
    800026f8:	6a42                	ld	s4,16(sp)
    800026fa:	6aa2                	ld	s5,8(sp)
    800026fc:	6121                	addi	sp,sp,64
    800026fe:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002700:	02059493          	slli	s1,a1,0x20
    80002704:	9081                	srli	s1,s1,0x20
    80002706:	048a                	slli	s1,s1,0x2
    80002708:	94aa                	add	s1,s1,a0
    8000270a:	0504a983          	lw	s3,80(s1)
    8000270e:	fc099fe3          	bnez	s3,800026ec <bmap+0x98>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002712:	4108                	lw	a0,0(a0)
    80002714:	00000097          	auipc	ra,0x0
    80002718:	e0e080e7          	jalr	-498(ra) # 80002522 <balloc>
    8000271c:	0005099b          	sext.w	s3,a0
    80002720:	0534a823          	sw	s3,80(s1)
    80002724:	b7e1                	j	800026ec <bmap+0x98>
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002726:	5d6c                	lw	a1,124(a0)
    80002728:	c985                	beqz	a1,80002758 <bmap+0x104>
    bp = bread(ip->dev, addr);
    8000272a:	00092503          	lw	a0,0(s2)
    8000272e:	00000097          	auipc	ra,0x0
    80002732:	b32080e7          	jalr	-1230(ra) # 80002260 <bread>
    80002736:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002738:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000273c:	1482                	slli	s1,s1,0x20
    8000273e:	9081                	srli	s1,s1,0x20
    80002740:	048a                	slli	s1,s1,0x2
    80002742:	94be                	add	s1,s1,a5
    80002744:	0004a983          	lw	s3,0(s1)
    80002748:	02098263          	beqz	s3,8000276c <bmap+0x118>
    brelse(bp);
    8000274c:	8552                	mv	a0,s4
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	c42080e7          	jalr	-958(ra) # 80002390 <brelse>
    return addr;
    80002756:	bf59                	j	800026ec <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002758:	4108                	lw	a0,0(a0)
    8000275a:	00000097          	auipc	ra,0x0
    8000275e:	dc8080e7          	jalr	-568(ra) # 80002522 <balloc>
    80002762:	0005059b          	sext.w	a1,a0
    80002766:	06b92e23          	sw	a1,124(s2)
    8000276a:	b7c1                	j	8000272a <bmap+0xd6>
      a[bn] = addr = balloc(ip->dev);
    8000276c:	00092503          	lw	a0,0(s2)
    80002770:	00000097          	auipc	ra,0x0
    80002774:	db2080e7          	jalr	-590(ra) # 80002522 <balloc>
    80002778:	0005099b          	sext.w	s3,a0
    8000277c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002780:	8552                	mv	a0,s4
    80002782:	00001097          	auipc	ra,0x1
    80002786:	ff4080e7          	jalr	-12(ra) # 80003776 <log_write>
    8000278a:	b7c9                	j	8000274c <bmap+0xf8>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    8000278c:	4108                	lw	a0,0(a0)
    8000278e:	00000097          	auipc	ra,0x0
    80002792:	d94080e7          	jalr	-620(ra) # 80002522 <balloc>
    80002796:	0005059b          	sext.w	a1,a0
    8000279a:	08b92023          	sw	a1,128(s2)
    8000279e:	bdf5                	j	8000269a <bmap+0x46>
      a[geshu] = addr = balloc(ip->dev);
    800027a0:	00092503          	lw	a0,0(s2)
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	d7e080e7          	jalr	-642(ra) # 80002522 <balloc>
    800027ac:	00050a9b          	sext.w	s5,a0
    800027b0:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    800027b4:	854e                	mv	a0,s3
    800027b6:	00001097          	auipc	ra,0x1
    800027ba:	fc0080e7          	jalr	-64(ra) # 80003776 <log_write>
    800027be:	bded                	j	800026b8 <bmap+0x64>
      a2[xuhao] = addr = balloc(ip->dev);
    800027c0:	00092503          	lw	a0,0(s2)
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	d5e080e7          	jalr	-674(ra) # 80002522 <balloc>
    800027cc:	0005099b          	sext.w	s3,a0
    800027d0:	0134a023          	sw	s3,0(s1)
      log_write(bp2);
    800027d4:	8552                	mv	a0,s4
    800027d6:	00001097          	auipc	ra,0x1
    800027da:	fa0080e7          	jalr	-96(ra) # 80003776 <log_write>
    800027de:	b711                	j	800026e2 <bmap+0x8e>
  panic("bmap: out of range");
    800027e0:	00006517          	auipc	a0,0x6
    800027e4:	d0850513          	addi	a0,a0,-760 # 800084e8 <syscalls+0x120>
    800027e8:	00003097          	auipc	ra,0x3
    800027ec:	64c080e7          	jalr	1612(ra) # 80005e34 <panic>

00000000800027f0 <iget>:
{
    800027f0:	7179                	addi	sp,sp,-48
    800027f2:	f406                	sd	ra,40(sp)
    800027f4:	f022                	sd	s0,32(sp)
    800027f6:	ec26                	sd	s1,24(sp)
    800027f8:	e84a                	sd	s2,16(sp)
    800027fa:	e44e                	sd	s3,8(sp)
    800027fc:	e052                	sd	s4,0(sp)
    800027fe:	1800                	addi	s0,sp,48
    80002800:	89aa                	mv	s3,a0
    80002802:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002804:	00010517          	auipc	a0,0x10
    80002808:	18450513          	addi	a0,a0,388 # 80012988 <itable>
    8000280c:	00004097          	auipc	ra,0x4
    80002810:	b64080e7          	jalr	-1180(ra) # 80006370 <acquire>
  empty = 0;
    80002814:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002816:	00010497          	auipc	s1,0x10
    8000281a:	18a48493          	addi	s1,s1,394 # 800129a0 <itable+0x18>
    8000281e:	00012697          	auipc	a3,0x12
    80002822:	c1268693          	addi	a3,a3,-1006 # 80014430 <log>
    80002826:	a039                	j	80002834 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002828:	02090b63          	beqz	s2,8000285e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000282c:	08848493          	addi	s1,s1,136
    80002830:	02d48a63          	beq	s1,a3,80002864 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002834:	449c                	lw	a5,8(s1)
    80002836:	fef059e3          	blez	a5,80002828 <iget+0x38>
    8000283a:	4098                	lw	a4,0(s1)
    8000283c:	ff3716e3          	bne	a4,s3,80002828 <iget+0x38>
    80002840:	40d8                	lw	a4,4(s1)
    80002842:	ff4713e3          	bne	a4,s4,80002828 <iget+0x38>
      ip->ref++;
    80002846:	2785                	addiw	a5,a5,1
    80002848:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000284a:	00010517          	auipc	a0,0x10
    8000284e:	13e50513          	addi	a0,a0,318 # 80012988 <itable>
    80002852:	00004097          	auipc	ra,0x4
    80002856:	bd2080e7          	jalr	-1070(ra) # 80006424 <release>
      return ip;
    8000285a:	8926                	mv	s2,s1
    8000285c:	a03d                	j	8000288a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000285e:	f7f9                	bnez	a5,8000282c <iget+0x3c>
    80002860:	8926                	mv	s2,s1
    80002862:	b7e9                	j	8000282c <iget+0x3c>
  if(empty == 0)
    80002864:	02090c63          	beqz	s2,8000289c <iget+0xac>
  ip->dev = dev;
    80002868:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000286c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002870:	4785                	li	a5,1
    80002872:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002876:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000287a:	00010517          	auipc	a0,0x10
    8000287e:	10e50513          	addi	a0,a0,270 # 80012988 <itable>
    80002882:	00004097          	auipc	ra,0x4
    80002886:	ba2080e7          	jalr	-1118(ra) # 80006424 <release>
}
    8000288a:	854a                	mv	a0,s2
    8000288c:	70a2                	ld	ra,40(sp)
    8000288e:	7402                	ld	s0,32(sp)
    80002890:	64e2                	ld	s1,24(sp)
    80002892:	6942                	ld	s2,16(sp)
    80002894:	69a2                	ld	s3,8(sp)
    80002896:	6a02                	ld	s4,0(sp)
    80002898:	6145                	addi	sp,sp,48
    8000289a:	8082                	ret
    panic("iget: no inodes");
    8000289c:	00006517          	auipc	a0,0x6
    800028a0:	c6450513          	addi	a0,a0,-924 # 80008500 <syscalls+0x138>
    800028a4:	00003097          	auipc	ra,0x3
    800028a8:	590080e7          	jalr	1424(ra) # 80005e34 <panic>

00000000800028ac <fsinit>:
fsinit(int dev) {
    800028ac:	7179                	addi	sp,sp,-48
    800028ae:	f406                	sd	ra,40(sp)
    800028b0:	f022                	sd	s0,32(sp)
    800028b2:	ec26                	sd	s1,24(sp)
    800028b4:	e84a                	sd	s2,16(sp)
    800028b6:	e44e                	sd	s3,8(sp)
    800028b8:	1800                	addi	s0,sp,48
    800028ba:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028bc:	4585                	li	a1,1
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	9a2080e7          	jalr	-1630(ra) # 80002260 <bread>
    800028c6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));  //从bp->data上复制sizeof（*sb）个字符到sb
    800028c8:	00010997          	auipc	s3,0x10
    800028cc:	0a098993          	addi	s3,s3,160 # 80012968 <sb>
    800028d0:	02000613          	li	a2,32
    800028d4:	05850593          	addi	a1,a0,88
    800028d8:	854e                	mv	a0,s3
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	8fa080e7          	jalr	-1798(ra) # 800001d4 <memmove>
  brelse(bp);
    800028e2:	8526                	mv	a0,s1
    800028e4:	00000097          	auipc	ra,0x0
    800028e8:	aac080e7          	jalr	-1364(ra) # 80002390 <brelse>
  if(sb.magic != FSMAGIC)
    800028ec:	0009a703          	lw	a4,0(s3)
    800028f0:	102037b7          	lui	a5,0x10203
    800028f4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028f8:	02f71263          	bne	a4,a5,8000291c <fsinit+0x70>
  initlog(dev, &sb);
    800028fc:	00010597          	auipc	a1,0x10
    80002900:	06c58593          	addi	a1,a1,108 # 80012968 <sb>
    80002904:	854a                	mv	a0,s2
    80002906:	00001097          	auipc	ra,0x1
    8000290a:	bf4080e7          	jalr	-1036(ra) # 800034fa <initlog>
}
    8000290e:	70a2                	ld	ra,40(sp)
    80002910:	7402                	ld	s0,32(sp)
    80002912:	64e2                	ld	s1,24(sp)
    80002914:	6942                	ld	s2,16(sp)
    80002916:	69a2                	ld	s3,8(sp)
    80002918:	6145                	addi	sp,sp,48
    8000291a:	8082                	ret
    panic("invalid file system");
    8000291c:	00006517          	auipc	a0,0x6
    80002920:	bf450513          	addi	a0,a0,-1036 # 80008510 <syscalls+0x148>
    80002924:	00003097          	auipc	ra,0x3
    80002928:	510080e7          	jalr	1296(ra) # 80005e34 <panic>

000000008000292c <iinit>:
{
    8000292c:	7179                	addi	sp,sp,-48
    8000292e:	f406                	sd	ra,40(sp)
    80002930:	f022                	sd	s0,32(sp)
    80002932:	ec26                	sd	s1,24(sp)
    80002934:	e84a                	sd	s2,16(sp)
    80002936:	e44e                	sd	s3,8(sp)
    80002938:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000293a:	00006597          	auipc	a1,0x6
    8000293e:	bee58593          	addi	a1,a1,-1042 # 80008528 <syscalls+0x160>
    80002942:	00010517          	auipc	a0,0x10
    80002946:	04650513          	addi	a0,a0,70 # 80012988 <itable>
    8000294a:	00004097          	auipc	ra,0x4
    8000294e:	996080e7          	jalr	-1642(ra) # 800062e0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002952:	00010497          	auipc	s1,0x10
    80002956:	05e48493          	addi	s1,s1,94 # 800129b0 <itable+0x28>
    8000295a:	00012997          	auipc	s3,0x12
    8000295e:	ae698993          	addi	s3,s3,-1306 # 80014440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002962:	00006917          	auipc	s2,0x6
    80002966:	bce90913          	addi	s2,s2,-1074 # 80008530 <syscalls+0x168>
    8000296a:	85ca                	mv	a1,s2
    8000296c:	8526                	mv	a0,s1
    8000296e:	00001097          	auipc	ra,0x1
    80002972:	eee080e7          	jalr	-274(ra) # 8000385c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002976:	08848493          	addi	s1,s1,136
    8000297a:	ff3498e3          	bne	s1,s3,8000296a <iinit+0x3e>
}
    8000297e:	70a2                	ld	ra,40(sp)
    80002980:	7402                	ld	s0,32(sp)
    80002982:	64e2                	ld	s1,24(sp)
    80002984:	6942                	ld	s2,16(sp)
    80002986:	69a2                	ld	s3,8(sp)
    80002988:	6145                	addi	sp,sp,48
    8000298a:	8082                	ret

000000008000298c <ialloc>:
{
    8000298c:	715d                	addi	sp,sp,-80
    8000298e:	e486                	sd	ra,72(sp)
    80002990:	e0a2                	sd	s0,64(sp)
    80002992:	fc26                	sd	s1,56(sp)
    80002994:	f84a                	sd	s2,48(sp)
    80002996:	f44e                	sd	s3,40(sp)
    80002998:	f052                	sd	s4,32(sp)
    8000299a:	ec56                	sd	s5,24(sp)
    8000299c:	e85a                	sd	s6,16(sp)
    8000299e:	e45e                	sd	s7,8(sp)
    800029a0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a2:	00010717          	auipc	a4,0x10
    800029a6:	fd272703          	lw	a4,-46(a4) # 80012974 <sb+0xc>
    800029aa:	4785                	li	a5,1
    800029ac:	04e7fa63          	bgeu	a5,a4,80002a00 <ialloc+0x74>
    800029b0:	8aaa                	mv	s5,a0
    800029b2:	8bae                	mv	s7,a1
    800029b4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029b6:	00010a17          	auipc	s4,0x10
    800029ba:	fb2a0a13          	addi	s4,s4,-78 # 80012968 <sb>
    800029be:	00048b1b          	sext.w	s6,s1
    800029c2:	0044d793          	srli	a5,s1,0x4
    800029c6:	018a2583          	lw	a1,24(s4)
    800029ca:	9dbd                	addw	a1,a1,a5
    800029cc:	8556                	mv	a0,s5
    800029ce:	00000097          	auipc	ra,0x0
    800029d2:	892080e7          	jalr	-1902(ra) # 80002260 <bread>
    800029d6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029d8:	05850993          	addi	s3,a0,88
    800029dc:	00f4f793          	andi	a5,s1,15
    800029e0:	079a                	slli	a5,a5,0x6
    800029e2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029e4:	00099783          	lh	a5,0(s3)
    800029e8:	c785                	beqz	a5,80002a10 <ialloc+0x84>
    brelse(bp);
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	9a6080e7          	jalr	-1626(ra) # 80002390 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f2:	0485                	addi	s1,s1,1
    800029f4:	00ca2703          	lw	a4,12(s4)
    800029f8:	0004879b          	sext.w	a5,s1
    800029fc:	fce7e1e3          	bltu	a5,a4,800029be <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	b3850513          	addi	a0,a0,-1224 # 80008538 <syscalls+0x170>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	42c080e7          	jalr	1068(ra) # 80005e34 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a10:	04000613          	li	a2,64
    80002a14:	4581                	li	a1,0
    80002a16:	854e                	mv	a0,s3
    80002a18:	ffffd097          	auipc	ra,0xffffd
    80002a1c:	760080e7          	jalr	1888(ra) # 80000178 <memset>
      dip->type = type;
    80002a20:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a24:	854a                	mv	a0,s2
    80002a26:	00001097          	auipc	ra,0x1
    80002a2a:	d50080e7          	jalr	-688(ra) # 80003776 <log_write>
      brelse(bp);
    80002a2e:	854a                	mv	a0,s2
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	960080e7          	jalr	-1696(ra) # 80002390 <brelse>
      return iget(dev, inum);
    80002a38:	85da                	mv	a1,s6
    80002a3a:	8556                	mv	a0,s5
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	db4080e7          	jalr	-588(ra) # 800027f0 <iget>
}
    80002a44:	60a6                	ld	ra,72(sp)
    80002a46:	6406                	ld	s0,64(sp)
    80002a48:	74e2                	ld	s1,56(sp)
    80002a4a:	7942                	ld	s2,48(sp)
    80002a4c:	79a2                	ld	s3,40(sp)
    80002a4e:	7a02                	ld	s4,32(sp)
    80002a50:	6ae2                	ld	s5,24(sp)
    80002a52:	6b42                	ld	s6,16(sp)
    80002a54:	6ba2                	ld	s7,8(sp)
    80002a56:	6161                	addi	sp,sp,80
    80002a58:	8082                	ret

0000000080002a5a <iupdate>:
{
    80002a5a:	1101                	addi	sp,sp,-32
    80002a5c:	ec06                	sd	ra,24(sp)
    80002a5e:	e822                	sd	s0,16(sp)
    80002a60:	e426                	sd	s1,8(sp)
    80002a62:	e04a                	sd	s2,0(sp)
    80002a64:	1000                	addi	s0,sp,32
    80002a66:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a68:	415c                	lw	a5,4(a0)
    80002a6a:	0047d79b          	srliw	a5,a5,0x4
    80002a6e:	00010597          	auipc	a1,0x10
    80002a72:	f125a583          	lw	a1,-238(a1) # 80012980 <sb+0x18>
    80002a76:	9dbd                	addw	a1,a1,a5
    80002a78:	4108                	lw	a0,0(a0)
    80002a7a:	fffff097          	auipc	ra,0xfffff
    80002a7e:	7e6080e7          	jalr	2022(ra) # 80002260 <bread>
    80002a82:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a84:	05850793          	addi	a5,a0,88
    80002a88:	40c8                	lw	a0,4(s1)
    80002a8a:	893d                	andi	a0,a0,15
    80002a8c:	051a                	slli	a0,a0,0x6
    80002a8e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a90:	04449703          	lh	a4,68(s1)
    80002a94:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a98:	04649703          	lh	a4,70(s1)
    80002a9c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002aa0:	04849703          	lh	a4,72(s1)
    80002aa4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002aa8:	04a49703          	lh	a4,74(s1)
    80002aac:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ab0:	44f8                	lw	a4,76(s1)
    80002ab2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ab4:	03400613          	li	a2,52
    80002ab8:	05048593          	addi	a1,s1,80
    80002abc:	0531                	addi	a0,a0,12
    80002abe:	ffffd097          	auipc	ra,0xffffd
    80002ac2:	716080e7          	jalr	1814(ra) # 800001d4 <memmove>
  log_write(bp);
    80002ac6:	854a                	mv	a0,s2
    80002ac8:	00001097          	auipc	ra,0x1
    80002acc:	cae080e7          	jalr	-850(ra) # 80003776 <log_write>
  brelse(bp);
    80002ad0:	854a                	mv	a0,s2
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	8be080e7          	jalr	-1858(ra) # 80002390 <brelse>
}
    80002ada:	60e2                	ld	ra,24(sp)
    80002adc:	6442                	ld	s0,16(sp)
    80002ade:	64a2                	ld	s1,8(sp)
    80002ae0:	6902                	ld	s2,0(sp)
    80002ae2:	6105                	addi	sp,sp,32
    80002ae4:	8082                	ret

0000000080002ae6 <idup>:
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	1000                	addi	s0,sp,32
    80002af0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002af2:	00010517          	auipc	a0,0x10
    80002af6:	e9650513          	addi	a0,a0,-362 # 80012988 <itable>
    80002afa:	00004097          	auipc	ra,0x4
    80002afe:	876080e7          	jalr	-1930(ra) # 80006370 <acquire>
  ip->ref++;
    80002b02:	449c                	lw	a5,8(s1)
    80002b04:	2785                	addiw	a5,a5,1
    80002b06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b08:	00010517          	auipc	a0,0x10
    80002b0c:	e8050513          	addi	a0,a0,-384 # 80012988 <itable>
    80002b10:	00004097          	auipc	ra,0x4
    80002b14:	914080e7          	jalr	-1772(ra) # 80006424 <release>
}
    80002b18:	8526                	mv	a0,s1
    80002b1a:	60e2                	ld	ra,24(sp)
    80002b1c:	6442                	ld	s0,16(sp)
    80002b1e:	64a2                	ld	s1,8(sp)
    80002b20:	6105                	addi	sp,sp,32
    80002b22:	8082                	ret

0000000080002b24 <ilock>:
{
    80002b24:	1101                	addi	sp,sp,-32
    80002b26:	ec06                	sd	ra,24(sp)
    80002b28:	e822                	sd	s0,16(sp)
    80002b2a:	e426                	sd	s1,8(sp)
    80002b2c:	e04a                	sd	s2,0(sp)
    80002b2e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b30:	c115                	beqz	a0,80002b54 <ilock+0x30>
    80002b32:	84aa                	mv	s1,a0
    80002b34:	451c                	lw	a5,8(a0)
    80002b36:	00f05f63          	blez	a5,80002b54 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b3a:	0541                	addi	a0,a0,16
    80002b3c:	00001097          	auipc	ra,0x1
    80002b40:	d5a080e7          	jalr	-678(ra) # 80003896 <acquiresleep>
  if(ip->valid == 0){
    80002b44:	40bc                	lw	a5,64(s1)
    80002b46:	cf99                	beqz	a5,80002b64 <ilock+0x40>
}
    80002b48:	60e2                	ld	ra,24(sp)
    80002b4a:	6442                	ld	s0,16(sp)
    80002b4c:	64a2                	ld	s1,8(sp)
    80002b4e:	6902                	ld	s2,0(sp)
    80002b50:	6105                	addi	sp,sp,32
    80002b52:	8082                	ret
    panic("ilock");
    80002b54:	00006517          	auipc	a0,0x6
    80002b58:	9fc50513          	addi	a0,a0,-1540 # 80008550 <syscalls+0x188>
    80002b5c:	00003097          	auipc	ra,0x3
    80002b60:	2d8080e7          	jalr	728(ra) # 80005e34 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b64:	40dc                	lw	a5,4(s1)
    80002b66:	0047d79b          	srliw	a5,a5,0x4
    80002b6a:	00010597          	auipc	a1,0x10
    80002b6e:	e165a583          	lw	a1,-490(a1) # 80012980 <sb+0x18>
    80002b72:	9dbd                	addw	a1,a1,a5
    80002b74:	4088                	lw	a0,0(s1)
    80002b76:	fffff097          	auipc	ra,0xfffff
    80002b7a:	6ea080e7          	jalr	1770(ra) # 80002260 <bread>
    80002b7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b80:	05850593          	addi	a1,a0,88
    80002b84:	40dc                	lw	a5,4(s1)
    80002b86:	8bbd                	andi	a5,a5,15
    80002b88:	079a                	slli	a5,a5,0x6
    80002b8a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b8c:	00059783          	lh	a5,0(a1)
    80002b90:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b94:	00259783          	lh	a5,2(a1)
    80002b98:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b9c:	00459783          	lh	a5,4(a1)
    80002ba0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ba4:	00659783          	lh	a5,6(a1)
    80002ba8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bac:	459c                	lw	a5,8(a1)
    80002bae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bb0:	03400613          	li	a2,52
    80002bb4:	05b1                	addi	a1,a1,12
    80002bb6:	05048513          	addi	a0,s1,80
    80002bba:	ffffd097          	auipc	ra,0xffffd
    80002bbe:	61a080e7          	jalr	1562(ra) # 800001d4 <memmove>
    brelse(bp);
    80002bc2:	854a                	mv	a0,s2
    80002bc4:	fffff097          	auipc	ra,0xfffff
    80002bc8:	7cc080e7          	jalr	1996(ra) # 80002390 <brelse>
    ip->valid = 1;
    80002bcc:	4785                	li	a5,1
    80002bce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bd0:	04449783          	lh	a5,68(s1)
    80002bd4:	fbb5                	bnez	a5,80002b48 <ilock+0x24>
      panic("ilock: no type");
    80002bd6:	00006517          	auipc	a0,0x6
    80002bda:	98250513          	addi	a0,a0,-1662 # 80008558 <syscalls+0x190>
    80002bde:	00003097          	auipc	ra,0x3
    80002be2:	256080e7          	jalr	598(ra) # 80005e34 <panic>

0000000080002be6 <iunlock>:
{
    80002be6:	1101                	addi	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	e04a                	sd	s2,0(sp)
    80002bf0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bf2:	c905                	beqz	a0,80002c22 <iunlock+0x3c>
    80002bf4:	84aa                	mv	s1,a0
    80002bf6:	01050913          	addi	s2,a0,16
    80002bfa:	854a                	mv	a0,s2
    80002bfc:	00001097          	auipc	ra,0x1
    80002c00:	d34080e7          	jalr	-716(ra) # 80003930 <holdingsleep>
    80002c04:	cd19                	beqz	a0,80002c22 <iunlock+0x3c>
    80002c06:	449c                	lw	a5,8(s1)
    80002c08:	00f05d63          	blez	a5,80002c22 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c0c:	854a                	mv	a0,s2
    80002c0e:	00001097          	auipc	ra,0x1
    80002c12:	cde080e7          	jalr	-802(ra) # 800038ec <releasesleep>
}
    80002c16:	60e2                	ld	ra,24(sp)
    80002c18:	6442                	ld	s0,16(sp)
    80002c1a:	64a2                	ld	s1,8(sp)
    80002c1c:	6902                	ld	s2,0(sp)
    80002c1e:	6105                	addi	sp,sp,32
    80002c20:	8082                	ret
    panic("iunlock");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	94650513          	addi	a0,a0,-1722 # 80008568 <syscalls+0x1a0>
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	20a080e7          	jalr	522(ra) # 80005e34 <panic>

0000000080002c32 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c32:	715d                	addi	sp,sp,-80
    80002c34:	e486                	sd	ra,72(sp)
    80002c36:	e0a2                	sd	s0,64(sp)
    80002c38:	fc26                	sd	s1,56(sp)
    80002c3a:	f84a                	sd	s2,48(sp)
    80002c3c:	f44e                	sd	s3,40(sp)
    80002c3e:	f052                	sd	s4,32(sp)
    80002c40:	ec56                	sd	s5,24(sp)
    80002c42:	e85a                	sd	s6,16(sp)
    80002c44:	e45e                	sd	s7,8(sp)
    80002c46:	e062                	sd	s8,0(sp)
    80002c48:	0880                	addi	s0,sp,80
    80002c4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c4c:	05050493          	addi	s1,a0,80
    80002c50:	07c50913          	addi	s2,a0,124
    80002c54:	a021                	j	80002c5c <itrunc+0x2a>
    80002c56:	0491                	addi	s1,s1,4
    80002c58:	01248d63          	beq	s1,s2,80002c72 <itrunc+0x40>
    if(ip->addrs[i]){
    80002c5c:	408c                	lw	a1,0(s1)
    80002c5e:	dde5                	beqz	a1,80002c56 <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    80002c60:	0009a503          	lw	a0,0(s3)
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	842080e7          	jalr	-1982(ra) # 800024a6 <bfree>
      ip->addrs[i] = 0;
    80002c6c:	0004a023          	sw	zero,0(s1)
    80002c70:	b7dd                	j	80002c56 <itrunc+0x24>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c72:	07c9a583          	lw	a1,124(s3)
    80002c76:	e59d                	bnez	a1,80002ca4 <itrunc+0x72>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }


if(ip->addrs[NDIRECT + 1]){
    80002c78:	0809a583          	lw	a1,128(s3)
    80002c7c:	eda5                	bnez	a1,80002cf4 <itrunc+0xc2>





  ip->size = 0;
    80002c7e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c82:	854e                	mv	a0,s3
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	dd6080e7          	jalr	-554(ra) # 80002a5a <iupdate>



}
    80002c8c:	60a6                	ld	ra,72(sp)
    80002c8e:	6406                	ld	s0,64(sp)
    80002c90:	74e2                	ld	s1,56(sp)
    80002c92:	7942                	ld	s2,48(sp)
    80002c94:	79a2                	ld	s3,40(sp)
    80002c96:	7a02                	ld	s4,32(sp)
    80002c98:	6ae2                	ld	s5,24(sp)
    80002c9a:	6b42                	ld	s6,16(sp)
    80002c9c:	6ba2                	ld	s7,8(sp)
    80002c9e:	6c02                	ld	s8,0(sp)
    80002ca0:	6161                	addi	sp,sp,80
    80002ca2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca4:	0009a503          	lw	a0,0(s3)
    80002ca8:	fffff097          	auipc	ra,0xfffff
    80002cac:	5b8080e7          	jalr	1464(ra) # 80002260 <bread>
    80002cb0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb2:	05850493          	addi	s1,a0,88
    80002cb6:	45850913          	addi	s2,a0,1112
    80002cba:	a021                	j	80002cc2 <itrunc+0x90>
    80002cbc:	0491                	addi	s1,s1,4
    80002cbe:	01248b63          	beq	s1,s2,80002cd4 <itrunc+0xa2>
      if(a[j])
    80002cc2:	408c                	lw	a1,0(s1)
    80002cc4:	dde5                	beqz	a1,80002cbc <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80002cc6:	0009a503          	lw	a0,0(s3)
    80002cca:	fffff097          	auipc	ra,0xfffff
    80002cce:	7dc080e7          	jalr	2012(ra) # 800024a6 <bfree>
    80002cd2:	b7ed                	j	80002cbc <itrunc+0x8a>
    brelse(bp);
    80002cd4:	8552                	mv	a0,s4
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	6ba080e7          	jalr	1722(ra) # 80002390 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cde:	07c9a583          	lw	a1,124(s3)
    80002ce2:	0009a503          	lw	a0,0(s3)
    80002ce6:	fffff097          	auipc	ra,0xfffff
    80002cea:	7c0080e7          	jalr	1984(ra) # 800024a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cee:	0609ae23          	sw	zero,124(s3)
    80002cf2:	b759                	j	80002c78 <itrunc+0x46>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002cf4:	0009a503          	lw	a0,0(s3)
    80002cf8:	fffff097          	auipc	ra,0xfffff
    80002cfc:	568080e7          	jalr	1384(ra) # 80002260 <bread>
    80002d00:	8c2a                	mv	s8,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d02:	05850a13          	addi	s4,a0,88
    80002d06:	45850b13          	addi	s6,a0,1112
    80002d0a:	a82d                	j	80002d44 <itrunc+0x112>
        for(int k = 0; k < NINDIRECT; k++){
    80002d0c:	0491                	addi	s1,s1,4
    80002d0e:	00990b63          	beq	s2,s1,80002d24 <itrunc+0xf2>
          if(b[k])
    80002d12:	408c                	lw	a1,0(s1)
    80002d14:	dde5                	beqz	a1,80002d0c <itrunc+0xda>
            bfree(ip->dev, b[k]);
    80002d16:	0009a503          	lw	a0,0(s3)
    80002d1a:	fffff097          	auipc	ra,0xfffff
    80002d1e:	78c080e7          	jalr	1932(ra) # 800024a6 <bfree>
    80002d22:	b7ed                	j	80002d0c <itrunc+0xda>
        brelse(bpd);
    80002d24:	855e                	mv	a0,s7
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	66a080e7          	jalr	1642(ra) # 80002390 <brelse>
        bfree(ip->dev, a[j]);
    80002d2e:	000aa583          	lw	a1,0(s5)
    80002d32:	0009a503          	lw	a0,0(s3)
    80002d36:	fffff097          	auipc	ra,0xfffff
    80002d3a:	770080e7          	jalr	1904(ra) # 800024a6 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d3e:	0a11                	addi	s4,s4,4
    80002d40:	034b0263          	beq	s6,s4,80002d64 <itrunc+0x132>
      if(a[j]){
    80002d44:	8ad2                	mv	s5,s4
    80002d46:	000a2583          	lw	a1,0(s4)
    80002d4a:	d9f5                	beqz	a1,80002d3e <itrunc+0x10c>
        bpd = bread(ip->dev, a[j]);
    80002d4c:	0009a503          	lw	a0,0(s3)
    80002d50:	fffff097          	auipc	ra,0xfffff
    80002d54:	510080e7          	jalr	1296(ra) # 80002260 <bread>
    80002d58:	8baa                	mv	s7,a0
        for(int k = 0; k < NINDIRECT; k++){
    80002d5a:	05850493          	addi	s1,a0,88
    80002d5e:	45850913          	addi	s2,a0,1112
    80002d62:	bf45                	j	80002d12 <itrunc+0xe0>
    brelse(bp);
    80002d64:	8562                	mv	a0,s8
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	62a080e7          	jalr	1578(ra) # 80002390 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d6e:	0809a583          	lw	a1,128(s3)
    80002d72:	0009a503          	lw	a0,0(s3)
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	730080e7          	jalr	1840(ra) # 800024a6 <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    80002d7e:	0809a023          	sw	zero,128(s3)
    80002d82:	bdf5                	j	80002c7e <itrunc+0x4c>

0000000080002d84 <iput>:
{
    80002d84:	1101                	addi	sp,sp,-32
    80002d86:	ec06                	sd	ra,24(sp)
    80002d88:	e822                	sd	s0,16(sp)
    80002d8a:	e426                	sd	s1,8(sp)
    80002d8c:	e04a                	sd	s2,0(sp)
    80002d8e:	1000                	addi	s0,sp,32
    80002d90:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d92:	00010517          	auipc	a0,0x10
    80002d96:	bf650513          	addi	a0,a0,-1034 # 80012988 <itable>
    80002d9a:	00003097          	auipc	ra,0x3
    80002d9e:	5d6080e7          	jalr	1494(ra) # 80006370 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da2:	4498                	lw	a4,8(s1)
    80002da4:	4785                	li	a5,1
    80002da6:	02f70363          	beq	a4,a5,80002dcc <iput+0x48>
  ip->ref--;
    80002daa:	449c                	lw	a5,8(s1)
    80002dac:	37fd                	addiw	a5,a5,-1
    80002dae:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002db0:	00010517          	auipc	a0,0x10
    80002db4:	bd850513          	addi	a0,a0,-1064 # 80012988 <itable>
    80002db8:	00003097          	auipc	ra,0x3
    80002dbc:	66c080e7          	jalr	1644(ra) # 80006424 <release>
}
    80002dc0:	60e2                	ld	ra,24(sp)
    80002dc2:	6442                	ld	s0,16(sp)
    80002dc4:	64a2                	ld	s1,8(sp)
    80002dc6:	6902                	ld	s2,0(sp)
    80002dc8:	6105                	addi	sp,sp,32
    80002dca:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dcc:	40bc                	lw	a5,64(s1)
    80002dce:	dff1                	beqz	a5,80002daa <iput+0x26>
    80002dd0:	04a49783          	lh	a5,74(s1)
    80002dd4:	fbf9                	bnez	a5,80002daa <iput+0x26>
    acquiresleep(&ip->lock);
    80002dd6:	01048913          	addi	s2,s1,16
    80002dda:	854a                	mv	a0,s2
    80002ddc:	00001097          	auipc	ra,0x1
    80002de0:	aba080e7          	jalr	-1350(ra) # 80003896 <acquiresleep>
    release(&itable.lock);
    80002de4:	00010517          	auipc	a0,0x10
    80002de8:	ba450513          	addi	a0,a0,-1116 # 80012988 <itable>
    80002dec:	00003097          	auipc	ra,0x3
    80002df0:	638080e7          	jalr	1592(ra) # 80006424 <release>
    itrunc(ip);
    80002df4:	8526                	mv	a0,s1
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	e3c080e7          	jalr	-452(ra) # 80002c32 <itrunc>
    ip->type = 0;
    80002dfe:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e02:	8526                	mv	a0,s1
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	c56080e7          	jalr	-938(ra) # 80002a5a <iupdate>
    ip->valid = 0;
    80002e0c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e10:	854a                	mv	a0,s2
    80002e12:	00001097          	auipc	ra,0x1
    80002e16:	ada080e7          	jalr	-1318(ra) # 800038ec <releasesleep>
    acquire(&itable.lock);
    80002e1a:	00010517          	auipc	a0,0x10
    80002e1e:	b6e50513          	addi	a0,a0,-1170 # 80012988 <itable>
    80002e22:	00003097          	auipc	ra,0x3
    80002e26:	54e080e7          	jalr	1358(ra) # 80006370 <acquire>
    80002e2a:	b741                	j	80002daa <iput+0x26>

0000000080002e2c <iunlockput>:
{
    80002e2c:	1101                	addi	sp,sp,-32
    80002e2e:	ec06                	sd	ra,24(sp)
    80002e30:	e822                	sd	s0,16(sp)
    80002e32:	e426                	sd	s1,8(sp)
    80002e34:	1000                	addi	s0,sp,32
    80002e36:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	dae080e7          	jalr	-594(ra) # 80002be6 <iunlock>
  iput(ip);
    80002e40:	8526                	mv	a0,s1
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	f42080e7          	jalr	-190(ra) # 80002d84 <iput>
}
    80002e4a:	60e2                	ld	ra,24(sp)
    80002e4c:	6442                	ld	s0,16(sp)
    80002e4e:	64a2                	ld	s1,8(sp)
    80002e50:	6105                	addi	sp,sp,32
    80002e52:	8082                	ret

0000000080002e54 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e54:	1141                	addi	sp,sp,-16
    80002e56:	e422                	sd	s0,8(sp)
    80002e58:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e5a:	411c                	lw	a5,0(a0)
    80002e5c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e5e:	415c                	lw	a5,4(a0)
    80002e60:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e62:	04451783          	lh	a5,68(a0)
    80002e66:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e6a:	04a51783          	lh	a5,74(a0)
    80002e6e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e72:	04c56783          	lwu	a5,76(a0)
    80002e76:	e99c                	sd	a5,16(a1)
}
    80002e78:	6422                	ld	s0,8(sp)
    80002e7a:	0141                	addi	sp,sp,16
    80002e7c:	8082                	ret

0000000080002e7e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7e:	457c                	lw	a5,76(a0)
    80002e80:	0ed7e963          	bltu	a5,a3,80002f72 <readi+0xf4>
{
    80002e84:	7159                	addi	sp,sp,-112
    80002e86:	f486                	sd	ra,104(sp)
    80002e88:	f0a2                	sd	s0,96(sp)
    80002e8a:	eca6                	sd	s1,88(sp)
    80002e8c:	e8ca                	sd	s2,80(sp)
    80002e8e:	e4ce                	sd	s3,72(sp)
    80002e90:	e0d2                	sd	s4,64(sp)
    80002e92:	fc56                	sd	s5,56(sp)
    80002e94:	f85a                	sd	s6,48(sp)
    80002e96:	f45e                	sd	s7,40(sp)
    80002e98:	f062                	sd	s8,32(sp)
    80002e9a:	ec66                	sd	s9,24(sp)
    80002e9c:	e86a                	sd	s10,16(sp)
    80002e9e:	e46e                	sd	s11,8(sp)
    80002ea0:	1880                	addi	s0,sp,112
    80002ea2:	8baa                	mv	s7,a0
    80002ea4:	8c2e                	mv	s8,a1
    80002ea6:	8ab2                	mv	s5,a2
    80002ea8:	84b6                	mv	s1,a3
    80002eaa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eac:	9f35                	addw	a4,a4,a3
    return 0;
    80002eae:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eb0:	0ad76063          	bltu	a4,a3,80002f50 <readi+0xd2>
  if(off + n > ip->size)
    80002eb4:	00e7f463          	bgeu	a5,a4,80002ebc <readi+0x3e>
    n = ip->size - off;
    80002eb8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ebc:	0a0b0963          	beqz	s6,80002f6e <readi+0xf0>
    80002ec0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ec6:	5cfd                	li	s9,-1
    80002ec8:	a82d                	j	80002f02 <readi+0x84>
    80002eca:	020a1d93          	slli	s11,s4,0x20
    80002ece:	020ddd93          	srli	s11,s11,0x20
    80002ed2:	05890793          	addi	a5,s2,88
    80002ed6:	86ee                	mv	a3,s11
    80002ed8:	963e                	add	a2,a2,a5
    80002eda:	85d6                	mv	a1,s5
    80002edc:	8562                	mv	a0,s8
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	9c8080e7          	jalr	-1592(ra) # 800018a6 <either_copyout>
    80002ee6:	05950d63          	beq	a0,s9,80002f40 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eea:	854a                	mv	a0,s2
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	4a4080e7          	jalr	1188(ra) # 80002390 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef4:	013a09bb          	addw	s3,s4,s3
    80002ef8:	009a04bb          	addw	s1,s4,s1
    80002efc:	9aee                	add	s5,s5,s11
    80002efe:	0569f763          	bgeu	s3,s6,80002f4c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f02:	000ba903          	lw	s2,0(s7)
    80002f06:	00a4d59b          	srliw	a1,s1,0xa
    80002f0a:	855e                	mv	a0,s7
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	748080e7          	jalr	1864(ra) # 80002654 <bmap>
    80002f14:	0005059b          	sext.w	a1,a0
    80002f18:	854a                	mv	a0,s2
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	346080e7          	jalr	838(ra) # 80002260 <bread>
    80002f22:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f24:	3ff4f613          	andi	a2,s1,1023
    80002f28:	40cd07bb          	subw	a5,s10,a2
    80002f2c:	413b073b          	subw	a4,s6,s3
    80002f30:	8a3e                	mv	s4,a5
    80002f32:	2781                	sext.w	a5,a5
    80002f34:	0007069b          	sext.w	a3,a4
    80002f38:	f8f6f9e3          	bgeu	a3,a5,80002eca <readi+0x4c>
    80002f3c:	8a3a                	mv	s4,a4
    80002f3e:	b771                	j	80002eca <readi+0x4c>
      brelse(bp);
    80002f40:	854a                	mv	a0,s2
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	44e080e7          	jalr	1102(ra) # 80002390 <brelse>
      tot = -1;
    80002f4a:	59fd                	li	s3,-1
  }
  return tot;
    80002f4c:	0009851b          	sext.w	a0,s3
}
    80002f50:	70a6                	ld	ra,104(sp)
    80002f52:	7406                	ld	s0,96(sp)
    80002f54:	64e6                	ld	s1,88(sp)
    80002f56:	6946                	ld	s2,80(sp)
    80002f58:	69a6                	ld	s3,72(sp)
    80002f5a:	6a06                	ld	s4,64(sp)
    80002f5c:	7ae2                	ld	s5,56(sp)
    80002f5e:	7b42                	ld	s6,48(sp)
    80002f60:	7ba2                	ld	s7,40(sp)
    80002f62:	7c02                	ld	s8,32(sp)
    80002f64:	6ce2                	ld	s9,24(sp)
    80002f66:	6d42                	ld	s10,16(sp)
    80002f68:	6da2                	ld	s11,8(sp)
    80002f6a:	6165                	addi	sp,sp,112
    80002f6c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f6e:	89da                	mv	s3,s6
    80002f70:	bff1                	j	80002f4c <readi+0xce>
    return 0;
    80002f72:	4501                	li	a0,0
}
    80002f74:	8082                	ret

0000000080002f76 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f76:	457c                	lw	a5,76(a0)
    80002f78:	10d7e963          	bltu	a5,a3,8000308a <writei+0x114>
{
    80002f7c:	7159                	addi	sp,sp,-112
    80002f7e:	f486                	sd	ra,104(sp)
    80002f80:	f0a2                	sd	s0,96(sp)
    80002f82:	eca6                	sd	s1,88(sp)
    80002f84:	e8ca                	sd	s2,80(sp)
    80002f86:	e4ce                	sd	s3,72(sp)
    80002f88:	e0d2                	sd	s4,64(sp)
    80002f8a:	fc56                	sd	s5,56(sp)
    80002f8c:	f85a                	sd	s6,48(sp)
    80002f8e:	f45e                	sd	s7,40(sp)
    80002f90:	f062                	sd	s8,32(sp)
    80002f92:	ec66                	sd	s9,24(sp)
    80002f94:	e86a                	sd	s10,16(sp)
    80002f96:	e46e                	sd	s11,8(sp)
    80002f98:	1880                	addi	s0,sp,112
    80002f9a:	8b2a                	mv	s6,a0
    80002f9c:	8c2e                	mv	s8,a1
    80002f9e:	8ab2                	mv	s5,a2
    80002fa0:	8936                	mv	s2,a3
    80002fa2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fa4:	9f35                	addw	a4,a4,a3
    80002fa6:	0ed76463          	bltu	a4,a3,8000308e <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002faa:	040437b7          	lui	a5,0x4043
    80002fae:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002fb2:	0ee7e063          	bltu	a5,a4,80003092 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fb6:	0c0b8863          	beqz	s7,80003086 <writei+0x110>
    80002fba:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fbc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fc0:	5cfd                	li	s9,-1
    80002fc2:	a091                	j	80003006 <writei+0x90>
    80002fc4:	02099d93          	slli	s11,s3,0x20
    80002fc8:	020ddd93          	srli	s11,s11,0x20
    80002fcc:	05848793          	addi	a5,s1,88
    80002fd0:	86ee                	mv	a3,s11
    80002fd2:	8656                	mv	a2,s5
    80002fd4:	85e2                	mv	a1,s8
    80002fd6:	953e                	add	a0,a0,a5
    80002fd8:	fffff097          	auipc	ra,0xfffff
    80002fdc:	924080e7          	jalr	-1756(ra) # 800018fc <either_copyin>
    80002fe0:	07950263          	beq	a0,s9,80003044 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	790080e7          	jalr	1936(ra) # 80003776 <log_write>
    brelse(bp);
    80002fee:	8526                	mv	a0,s1
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	3a0080e7          	jalr	928(ra) # 80002390 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff8:	01498a3b          	addw	s4,s3,s4
    80002ffc:	0129893b          	addw	s2,s3,s2
    80003000:	9aee                	add	s5,s5,s11
    80003002:	057a7663          	bgeu	s4,s7,8000304e <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003006:	000b2483          	lw	s1,0(s6)
    8000300a:	00a9559b          	srliw	a1,s2,0xa
    8000300e:	855a                	mv	a0,s6
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	644080e7          	jalr	1604(ra) # 80002654 <bmap>
    80003018:	0005059b          	sext.w	a1,a0
    8000301c:	8526                	mv	a0,s1
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	242080e7          	jalr	578(ra) # 80002260 <bread>
    80003026:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003028:	3ff97513          	andi	a0,s2,1023
    8000302c:	40ad07bb          	subw	a5,s10,a0
    80003030:	414b873b          	subw	a4,s7,s4
    80003034:	89be                	mv	s3,a5
    80003036:	2781                	sext.w	a5,a5
    80003038:	0007069b          	sext.w	a3,a4
    8000303c:	f8f6f4e3          	bgeu	a3,a5,80002fc4 <writei+0x4e>
    80003040:	89ba                	mv	s3,a4
    80003042:	b749                	j	80002fc4 <writei+0x4e>
      brelse(bp);
    80003044:	8526                	mv	a0,s1
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	34a080e7          	jalr	842(ra) # 80002390 <brelse>
  }

  if(off > ip->size)
    8000304e:	04cb2783          	lw	a5,76(s6)
    80003052:	0127f463          	bgeu	a5,s2,8000305a <writei+0xe4>
    ip->size = off;
    80003056:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000305a:	855a                	mv	a0,s6
    8000305c:	00000097          	auipc	ra,0x0
    80003060:	9fe080e7          	jalr	-1538(ra) # 80002a5a <iupdate>

  return tot;
    80003064:	000a051b          	sext.w	a0,s4
}
    80003068:	70a6                	ld	ra,104(sp)
    8000306a:	7406                	ld	s0,96(sp)
    8000306c:	64e6                	ld	s1,88(sp)
    8000306e:	6946                	ld	s2,80(sp)
    80003070:	69a6                	ld	s3,72(sp)
    80003072:	6a06                	ld	s4,64(sp)
    80003074:	7ae2                	ld	s5,56(sp)
    80003076:	7b42                	ld	s6,48(sp)
    80003078:	7ba2                	ld	s7,40(sp)
    8000307a:	7c02                	ld	s8,32(sp)
    8000307c:	6ce2                	ld	s9,24(sp)
    8000307e:	6d42                	ld	s10,16(sp)
    80003080:	6da2                	ld	s11,8(sp)
    80003082:	6165                	addi	sp,sp,112
    80003084:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003086:	8a5e                	mv	s4,s7
    80003088:	bfc9                	j	8000305a <writei+0xe4>
    return -1;
    8000308a:	557d                	li	a0,-1
}
    8000308c:	8082                	ret
    return -1;
    8000308e:	557d                	li	a0,-1
    80003090:	bfe1                	j	80003068 <writei+0xf2>
    return -1;
    80003092:	557d                	li	a0,-1
    80003094:	bfd1                	j	80003068 <writei+0xf2>

0000000080003096 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003096:	1141                	addi	sp,sp,-16
    80003098:	e406                	sd	ra,8(sp)
    8000309a:	e022                	sd	s0,0(sp)
    8000309c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000309e:	4639                	li	a2,14
    800030a0:	ffffd097          	auipc	ra,0xffffd
    800030a4:	1a8080e7          	jalr	424(ra) # 80000248 <strncmp>
}
    800030a8:	60a2                	ld	ra,8(sp)
    800030aa:	6402                	ld	s0,0(sp)
    800030ac:	0141                	addi	sp,sp,16
    800030ae:	8082                	ret

00000000800030b0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030b0:	7139                	addi	sp,sp,-64
    800030b2:	fc06                	sd	ra,56(sp)
    800030b4:	f822                	sd	s0,48(sp)
    800030b6:	f426                	sd	s1,40(sp)
    800030b8:	f04a                	sd	s2,32(sp)
    800030ba:	ec4e                	sd	s3,24(sp)
    800030bc:	e852                	sd	s4,16(sp)
    800030be:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030c0:	04451703          	lh	a4,68(a0)
    800030c4:	4785                	li	a5,1
    800030c6:	00f71a63          	bne	a4,a5,800030da <dirlookup+0x2a>
    800030ca:	892a                	mv	s2,a0
    800030cc:	89ae                	mv	s3,a1
    800030ce:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d0:	457c                	lw	a5,76(a0)
    800030d2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030d4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d6:	e79d                	bnez	a5,80003104 <dirlookup+0x54>
    800030d8:	a8a5                	j	80003150 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030da:	00005517          	auipc	a0,0x5
    800030de:	49650513          	addi	a0,a0,1174 # 80008570 <syscalls+0x1a8>
    800030e2:	00003097          	auipc	ra,0x3
    800030e6:	d52080e7          	jalr	-686(ra) # 80005e34 <panic>
      panic("dirlookup read");
    800030ea:	00005517          	auipc	a0,0x5
    800030ee:	49e50513          	addi	a0,a0,1182 # 80008588 <syscalls+0x1c0>
    800030f2:	00003097          	auipc	ra,0x3
    800030f6:	d42080e7          	jalr	-702(ra) # 80005e34 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fa:	24c1                	addiw	s1,s1,16
    800030fc:	04c92783          	lw	a5,76(s2)
    80003100:	04f4f763          	bgeu	s1,a5,8000314e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003104:	4741                	li	a4,16
    80003106:	86a6                	mv	a3,s1
    80003108:	fc040613          	addi	a2,s0,-64
    8000310c:	4581                	li	a1,0
    8000310e:	854a                	mv	a0,s2
    80003110:	00000097          	auipc	ra,0x0
    80003114:	d6e080e7          	jalr	-658(ra) # 80002e7e <readi>
    80003118:	47c1                	li	a5,16
    8000311a:	fcf518e3          	bne	a0,a5,800030ea <dirlookup+0x3a>
    if(de.inum == 0)
    8000311e:	fc045783          	lhu	a5,-64(s0)
    80003122:	dfe1                	beqz	a5,800030fa <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003124:	fc240593          	addi	a1,s0,-62
    80003128:	854e                	mv	a0,s3
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	f6c080e7          	jalr	-148(ra) # 80003096 <namecmp>
    80003132:	f561                	bnez	a0,800030fa <dirlookup+0x4a>
      if(poff)
    80003134:	000a0463          	beqz	s4,8000313c <dirlookup+0x8c>
        *poff = off;
    80003138:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000313c:	fc045583          	lhu	a1,-64(s0)
    80003140:	00092503          	lw	a0,0(s2)
    80003144:	fffff097          	auipc	ra,0xfffff
    80003148:	6ac080e7          	jalr	1708(ra) # 800027f0 <iget>
    8000314c:	a011                	j	80003150 <dirlookup+0xa0>
  return 0;
    8000314e:	4501                	li	a0,0
}
    80003150:	70e2                	ld	ra,56(sp)
    80003152:	7442                	ld	s0,48(sp)
    80003154:	74a2                	ld	s1,40(sp)
    80003156:	7902                	ld	s2,32(sp)
    80003158:	69e2                	ld	s3,24(sp)
    8000315a:	6a42                	ld	s4,16(sp)
    8000315c:	6121                	addi	sp,sp,64
    8000315e:	8082                	ret

0000000080003160 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003160:	711d                	addi	sp,sp,-96
    80003162:	ec86                	sd	ra,88(sp)
    80003164:	e8a2                	sd	s0,80(sp)
    80003166:	e4a6                	sd	s1,72(sp)
    80003168:	e0ca                	sd	s2,64(sp)
    8000316a:	fc4e                	sd	s3,56(sp)
    8000316c:	f852                	sd	s4,48(sp)
    8000316e:	f456                	sd	s5,40(sp)
    80003170:	f05a                	sd	s6,32(sp)
    80003172:	ec5e                	sd	s7,24(sp)
    80003174:	e862                	sd	s8,16(sp)
    80003176:	e466                	sd	s9,8(sp)
    80003178:	1080                	addi	s0,sp,96
    8000317a:	84aa                	mv	s1,a0
    8000317c:	8aae                	mv	s5,a1
    8000317e:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003180:	00054703          	lbu	a4,0(a0)
    80003184:	02f00793          	li	a5,47
    80003188:	02f70363          	beq	a4,a5,800031ae <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000318c:	ffffe097          	auipc	ra,0xffffe
    80003190:	cb6080e7          	jalr	-842(ra) # 80000e42 <myproc>
    80003194:	15053503          	ld	a0,336(a0)
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	94e080e7          	jalr	-1714(ra) # 80002ae6 <idup>
    800031a0:	89aa                	mv	s3,a0
  while(*path == '/')
    800031a2:	02f00913          	li	s2,47
  len = path - s;
    800031a6:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800031a8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031aa:	4b85                	li	s7,1
    800031ac:	a865                	j	80003264 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031ae:	4585                	li	a1,1
    800031b0:	4505                	li	a0,1
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	63e080e7          	jalr	1598(ra) # 800027f0 <iget>
    800031ba:	89aa                	mv	s3,a0
    800031bc:	b7dd                	j	800031a2 <namex+0x42>
      iunlockput(ip);
    800031be:	854e                	mv	a0,s3
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	c6c080e7          	jalr	-916(ra) # 80002e2c <iunlockput>
      return 0;
    800031c8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ca:	854e                	mv	a0,s3
    800031cc:	60e6                	ld	ra,88(sp)
    800031ce:	6446                	ld	s0,80(sp)
    800031d0:	64a6                	ld	s1,72(sp)
    800031d2:	6906                	ld	s2,64(sp)
    800031d4:	79e2                	ld	s3,56(sp)
    800031d6:	7a42                	ld	s4,48(sp)
    800031d8:	7aa2                	ld	s5,40(sp)
    800031da:	7b02                	ld	s6,32(sp)
    800031dc:	6be2                	ld	s7,24(sp)
    800031de:	6c42                	ld	s8,16(sp)
    800031e0:	6ca2                	ld	s9,8(sp)
    800031e2:	6125                	addi	sp,sp,96
    800031e4:	8082                	ret
      iunlock(ip);
    800031e6:	854e                	mv	a0,s3
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	9fe080e7          	jalr	-1538(ra) # 80002be6 <iunlock>
      return ip;
    800031f0:	bfe9                	j	800031ca <namex+0x6a>
      iunlockput(ip);
    800031f2:	854e                	mv	a0,s3
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	c38080e7          	jalr	-968(ra) # 80002e2c <iunlockput>
      return 0;
    800031fc:	89e6                	mv	s3,s9
    800031fe:	b7f1                	j	800031ca <namex+0x6a>
  len = path - s;
    80003200:	40b48633          	sub	a2,s1,a1
    80003204:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003208:	099c5463          	bge	s8,s9,80003290 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000320c:	4639                	li	a2,14
    8000320e:	8552                	mv	a0,s4
    80003210:	ffffd097          	auipc	ra,0xffffd
    80003214:	fc4080e7          	jalr	-60(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003218:	0004c783          	lbu	a5,0(s1)
    8000321c:	01279763          	bne	a5,s2,8000322a <namex+0xca>
    path++;
    80003220:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003222:	0004c783          	lbu	a5,0(s1)
    80003226:	ff278de3          	beq	a5,s2,80003220 <namex+0xc0>
    ilock(ip);
    8000322a:	854e                	mv	a0,s3
    8000322c:	00000097          	auipc	ra,0x0
    80003230:	8f8080e7          	jalr	-1800(ra) # 80002b24 <ilock>
    if(ip->type != T_DIR){
    80003234:	04499783          	lh	a5,68(s3)
    80003238:	f97793e3          	bne	a5,s7,800031be <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000323c:	000a8563          	beqz	s5,80003246 <namex+0xe6>
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	d3cd                	beqz	a5,800031e6 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003246:	865a                	mv	a2,s6
    80003248:	85d2                	mv	a1,s4
    8000324a:	854e                	mv	a0,s3
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	e64080e7          	jalr	-412(ra) # 800030b0 <dirlookup>
    80003254:	8caa                	mv	s9,a0
    80003256:	dd51                	beqz	a0,800031f2 <namex+0x92>
    iunlockput(ip);
    80003258:	854e                	mv	a0,s3
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	bd2080e7          	jalr	-1070(ra) # 80002e2c <iunlockput>
    ip = next;
    80003262:	89e6                	mv	s3,s9
  while(*path == '/')
    80003264:	0004c783          	lbu	a5,0(s1)
    80003268:	05279763          	bne	a5,s2,800032b6 <namex+0x156>
    path++;
    8000326c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000326e:	0004c783          	lbu	a5,0(s1)
    80003272:	ff278de3          	beq	a5,s2,8000326c <namex+0x10c>
  if(*path == 0)
    80003276:	c79d                	beqz	a5,800032a4 <namex+0x144>
    path++;
    80003278:	85a6                	mv	a1,s1
  len = path - s;
    8000327a:	8cda                	mv	s9,s6
    8000327c:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000327e:	01278963          	beq	a5,s2,80003290 <namex+0x130>
    80003282:	dfbd                	beqz	a5,80003200 <namex+0xa0>
    path++;
    80003284:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	ff279ce3          	bne	a5,s2,80003282 <namex+0x122>
    8000328e:	bf8d                	j	80003200 <namex+0xa0>
    memmove(name, s, len);
    80003290:	2601                	sext.w	a2,a2
    80003292:	8552                	mv	a0,s4
    80003294:	ffffd097          	auipc	ra,0xffffd
    80003298:	f40080e7          	jalr	-192(ra) # 800001d4 <memmove>
    name[len] = 0;
    8000329c:	9cd2                	add	s9,s9,s4
    8000329e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032a2:	bf9d                	j	80003218 <namex+0xb8>
  if(nameiparent){
    800032a4:	f20a83e3          	beqz	s5,800031ca <namex+0x6a>
    iput(ip);
    800032a8:	854e                	mv	a0,s3
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	ada080e7          	jalr	-1318(ra) # 80002d84 <iput>
    return 0;
    800032b2:	4981                	li	s3,0
    800032b4:	bf19                	j	800031ca <namex+0x6a>
  if(*path == 0)
    800032b6:	d7fd                	beqz	a5,800032a4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032b8:	0004c783          	lbu	a5,0(s1)
    800032bc:	85a6                	mv	a1,s1
    800032be:	b7d1                	j	80003282 <namex+0x122>

00000000800032c0 <dirlink>:
{
    800032c0:	7139                	addi	sp,sp,-64
    800032c2:	fc06                	sd	ra,56(sp)
    800032c4:	f822                	sd	s0,48(sp)
    800032c6:	f426                	sd	s1,40(sp)
    800032c8:	f04a                	sd	s2,32(sp)
    800032ca:	ec4e                	sd	s3,24(sp)
    800032cc:	e852                	sd	s4,16(sp)
    800032ce:	0080                	addi	s0,sp,64
    800032d0:	892a                	mv	s2,a0
    800032d2:	8a2e                	mv	s4,a1
    800032d4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032d6:	4601                	li	a2,0
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	dd8080e7          	jalr	-552(ra) # 800030b0 <dirlookup>
    800032e0:	e93d                	bnez	a0,80003356 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e2:	04c92483          	lw	s1,76(s2)
    800032e6:	c49d                	beqz	s1,80003314 <dirlink+0x54>
    800032e8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ea:	4741                	li	a4,16
    800032ec:	86a6                	mv	a3,s1
    800032ee:	fc040613          	addi	a2,s0,-64
    800032f2:	4581                	li	a1,0
    800032f4:	854a                	mv	a0,s2
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	b88080e7          	jalr	-1144(ra) # 80002e7e <readi>
    800032fe:	47c1                	li	a5,16
    80003300:	06f51163          	bne	a0,a5,80003362 <dirlink+0xa2>
    if(de.inum == 0)
    80003304:	fc045783          	lhu	a5,-64(s0)
    80003308:	c791                	beqz	a5,80003314 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000330a:	24c1                	addiw	s1,s1,16
    8000330c:	04c92783          	lw	a5,76(s2)
    80003310:	fcf4ede3          	bltu	s1,a5,800032ea <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003314:	4639                	li	a2,14
    80003316:	85d2                	mv	a1,s4
    80003318:	fc240513          	addi	a0,s0,-62
    8000331c:	ffffd097          	auipc	ra,0xffffd
    80003320:	f68080e7          	jalr	-152(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003324:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003328:	4741                	li	a4,16
    8000332a:	86a6                	mv	a3,s1
    8000332c:	fc040613          	addi	a2,s0,-64
    80003330:	4581                	li	a1,0
    80003332:	854a                	mv	a0,s2
    80003334:	00000097          	auipc	ra,0x0
    80003338:	c42080e7          	jalr	-958(ra) # 80002f76 <writei>
    8000333c:	872a                	mv	a4,a0
    8000333e:	47c1                	li	a5,16
  return 0;
    80003340:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003342:	02f71863          	bne	a4,a5,80003372 <dirlink+0xb2>
}
    80003346:	70e2                	ld	ra,56(sp)
    80003348:	7442                	ld	s0,48(sp)
    8000334a:	74a2                	ld	s1,40(sp)
    8000334c:	7902                	ld	s2,32(sp)
    8000334e:	69e2                	ld	s3,24(sp)
    80003350:	6a42                	ld	s4,16(sp)
    80003352:	6121                	addi	sp,sp,64
    80003354:	8082                	ret
    iput(ip);
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	a2e080e7          	jalr	-1490(ra) # 80002d84 <iput>
    return -1;
    8000335e:	557d                	li	a0,-1
    80003360:	b7dd                	j	80003346 <dirlink+0x86>
      panic("dirlink read");
    80003362:	00005517          	auipc	a0,0x5
    80003366:	23650513          	addi	a0,a0,566 # 80008598 <syscalls+0x1d0>
    8000336a:	00003097          	auipc	ra,0x3
    8000336e:	aca080e7          	jalr	-1334(ra) # 80005e34 <panic>
    panic("dirlink");
    80003372:	00005517          	auipc	a0,0x5
    80003376:	33650513          	addi	a0,a0,822 # 800086a8 <syscalls+0x2e0>
    8000337a:	00003097          	auipc	ra,0x3
    8000337e:	aba080e7          	jalr	-1350(ra) # 80005e34 <panic>

0000000080003382 <namei>:

struct inode*
namei(char *path)
{
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000338a:	fe040613          	addi	a2,s0,-32
    8000338e:	4581                	li	a1,0
    80003390:	00000097          	auipc	ra,0x0
    80003394:	dd0080e7          	jalr	-560(ra) # 80003160 <namex>
}
    80003398:	60e2                	ld	ra,24(sp)
    8000339a:	6442                	ld	s0,16(sp)
    8000339c:	6105                	addi	sp,sp,32
    8000339e:	8082                	ret

00000000800033a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033a0:	1141                	addi	sp,sp,-16
    800033a2:	e406                	sd	ra,8(sp)
    800033a4:	e022                	sd	s0,0(sp)
    800033a6:	0800                	addi	s0,sp,16
    800033a8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033aa:	4585                	li	a1,1
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	db4080e7          	jalr	-588(ra) # 80003160 <namex>
}
    800033b4:	60a2                	ld	ra,8(sp)
    800033b6:	6402                	ld	s0,0(sp)
    800033b8:	0141                	addi	sp,sp,16
    800033ba:	8082                	ret

00000000800033bc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033bc:	1101                	addi	sp,sp,-32
    800033be:	ec06                	sd	ra,24(sp)
    800033c0:	e822                	sd	s0,16(sp)
    800033c2:	e426                	sd	s1,8(sp)
    800033c4:	e04a                	sd	s2,0(sp)
    800033c6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033c8:	00011917          	auipc	s2,0x11
    800033cc:	06890913          	addi	s2,s2,104 # 80014430 <log>
    800033d0:	01892583          	lw	a1,24(s2)
    800033d4:	02892503          	lw	a0,40(s2)
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	e88080e7          	jalr	-376(ra) # 80002260 <bread>
    800033e0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033e2:	02c92683          	lw	a3,44(s2)
    800033e6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033e8:	02d05763          	blez	a3,80003416 <write_head+0x5a>
    800033ec:	00011797          	auipc	a5,0x11
    800033f0:	07478793          	addi	a5,a5,116 # 80014460 <log+0x30>
    800033f4:	05c50713          	addi	a4,a0,92
    800033f8:	36fd                	addiw	a3,a3,-1
    800033fa:	1682                	slli	a3,a3,0x20
    800033fc:	9281                	srli	a3,a3,0x20
    800033fe:	068a                	slli	a3,a3,0x2
    80003400:	00011617          	auipc	a2,0x11
    80003404:	06460613          	addi	a2,a2,100 # 80014464 <log+0x34>
    80003408:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000340a:	4390                	lw	a2,0(a5)
    8000340c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000340e:	0791                	addi	a5,a5,4
    80003410:	0711                	addi	a4,a4,4
    80003412:	fed79ce3          	bne	a5,a3,8000340a <write_head+0x4e>
  }
  bwrite(buf);
    80003416:	8526                	mv	a0,s1
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	f3a080e7          	jalr	-198(ra) # 80002352 <bwrite>
  brelse(buf);
    80003420:	8526                	mv	a0,s1
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	f6e080e7          	jalr	-146(ra) # 80002390 <brelse>
}
    8000342a:	60e2                	ld	ra,24(sp)
    8000342c:	6442                	ld	s0,16(sp)
    8000342e:	64a2                	ld	s1,8(sp)
    80003430:	6902                	ld	s2,0(sp)
    80003432:	6105                	addi	sp,sp,32
    80003434:	8082                	ret

0000000080003436 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003436:	00011797          	auipc	a5,0x11
    8000343a:	0267a783          	lw	a5,38(a5) # 8001445c <log+0x2c>
    8000343e:	0af05d63          	blez	a5,800034f8 <install_trans+0xc2>
{
    80003442:	7139                	addi	sp,sp,-64
    80003444:	fc06                	sd	ra,56(sp)
    80003446:	f822                	sd	s0,48(sp)
    80003448:	f426                	sd	s1,40(sp)
    8000344a:	f04a                	sd	s2,32(sp)
    8000344c:	ec4e                	sd	s3,24(sp)
    8000344e:	e852                	sd	s4,16(sp)
    80003450:	e456                	sd	s5,8(sp)
    80003452:	e05a                	sd	s6,0(sp)
    80003454:	0080                	addi	s0,sp,64
    80003456:	8b2a                	mv	s6,a0
    80003458:	00011a97          	auipc	s5,0x11
    8000345c:	008a8a93          	addi	s5,s5,8 # 80014460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003460:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003462:	00011997          	auipc	s3,0x11
    80003466:	fce98993          	addi	s3,s3,-50 # 80014430 <log>
    8000346a:	a00d                	j	8000348c <install_trans+0x56>
    brelse(lbuf);
    8000346c:	854a                	mv	a0,s2
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	f22080e7          	jalr	-222(ra) # 80002390 <brelse>
    brelse(dbuf);
    80003476:	8526                	mv	a0,s1
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	f18080e7          	jalr	-232(ra) # 80002390 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003480:	2a05                	addiw	s4,s4,1
    80003482:	0a91                	addi	s5,s5,4
    80003484:	02c9a783          	lw	a5,44(s3)
    80003488:	04fa5e63          	bge	s4,a5,800034e4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000348c:	0189a583          	lw	a1,24(s3)
    80003490:	014585bb          	addw	a1,a1,s4
    80003494:	2585                	addiw	a1,a1,1
    80003496:	0289a503          	lw	a0,40(s3)
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	dc6080e7          	jalr	-570(ra) # 80002260 <bread>
    800034a2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034a4:	000aa583          	lw	a1,0(s5)
    800034a8:	0289a503          	lw	a0,40(s3)
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	db4080e7          	jalr	-588(ra) # 80002260 <bread>
    800034b4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b6:	40000613          	li	a2,1024
    800034ba:	05890593          	addi	a1,s2,88
    800034be:	05850513          	addi	a0,a0,88
    800034c2:	ffffd097          	auipc	ra,0xffffd
    800034c6:	d12080e7          	jalr	-750(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ca:	8526                	mv	a0,s1
    800034cc:	fffff097          	auipc	ra,0xfffff
    800034d0:	e86080e7          	jalr	-378(ra) # 80002352 <bwrite>
    if(recovering == 0)
    800034d4:	f80b1ce3          	bnez	s6,8000346c <install_trans+0x36>
      bunpin(dbuf);
    800034d8:	8526                	mv	a0,s1
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	f90080e7          	jalr	-112(ra) # 8000246a <bunpin>
    800034e2:	b769                	j	8000346c <install_trans+0x36>
}
    800034e4:	70e2                	ld	ra,56(sp)
    800034e6:	7442                	ld	s0,48(sp)
    800034e8:	74a2                	ld	s1,40(sp)
    800034ea:	7902                	ld	s2,32(sp)
    800034ec:	69e2                	ld	s3,24(sp)
    800034ee:	6a42                	ld	s4,16(sp)
    800034f0:	6aa2                	ld	s5,8(sp)
    800034f2:	6b02                	ld	s6,0(sp)
    800034f4:	6121                	addi	sp,sp,64
    800034f6:	8082                	ret
    800034f8:	8082                	ret

00000000800034fa <initlog>:
{
    800034fa:	7179                	addi	sp,sp,-48
    800034fc:	f406                	sd	ra,40(sp)
    800034fe:	f022                	sd	s0,32(sp)
    80003500:	ec26                	sd	s1,24(sp)
    80003502:	e84a                	sd	s2,16(sp)
    80003504:	e44e                	sd	s3,8(sp)
    80003506:	1800                	addi	s0,sp,48
    80003508:	892a                	mv	s2,a0
    8000350a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000350c:	00011497          	auipc	s1,0x11
    80003510:	f2448493          	addi	s1,s1,-220 # 80014430 <log>
    80003514:	00005597          	auipc	a1,0x5
    80003518:	09458593          	addi	a1,a1,148 # 800085a8 <syscalls+0x1e0>
    8000351c:	8526                	mv	a0,s1
    8000351e:	00003097          	auipc	ra,0x3
    80003522:	dc2080e7          	jalr	-574(ra) # 800062e0 <initlock>
  log.start = sb->logstart;
    80003526:	0149a583          	lw	a1,20(s3)
    8000352a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000352c:	0109a783          	lw	a5,16(s3)
    80003530:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003532:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003536:	854a                	mv	a0,s2
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	d28080e7          	jalr	-728(ra) # 80002260 <bread>
  log.lh.n = lh->n;
    80003540:	4d34                	lw	a3,88(a0)
    80003542:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003544:	02d05563          	blez	a3,8000356e <initlog+0x74>
    80003548:	05c50793          	addi	a5,a0,92
    8000354c:	00011717          	auipc	a4,0x11
    80003550:	f1470713          	addi	a4,a4,-236 # 80014460 <log+0x30>
    80003554:	36fd                	addiw	a3,a3,-1
    80003556:	1682                	slli	a3,a3,0x20
    80003558:	9281                	srli	a3,a3,0x20
    8000355a:	068a                	slli	a3,a3,0x2
    8000355c:	06050613          	addi	a2,a0,96
    80003560:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003562:	4390                	lw	a2,0(a5)
    80003564:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	0791                	addi	a5,a5,4
    80003568:	0711                	addi	a4,a4,4
    8000356a:	fed79ce3          	bne	a5,a3,80003562 <initlog+0x68>
  brelse(buf);
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	e22080e7          	jalr	-478(ra) # 80002390 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003576:	4505                	li	a0,1
    80003578:	00000097          	auipc	ra,0x0
    8000357c:	ebe080e7          	jalr	-322(ra) # 80003436 <install_trans>
  log.lh.n = 0;
    80003580:	00011797          	auipc	a5,0x11
    80003584:	ec07ae23          	sw	zero,-292(a5) # 8001445c <log+0x2c>
  write_head(); // clear the log
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	e34080e7          	jalr	-460(ra) # 800033bc <write_head>
}
    80003590:	70a2                	ld	ra,40(sp)
    80003592:	7402                	ld	s0,32(sp)
    80003594:	64e2                	ld	s1,24(sp)
    80003596:	6942                	ld	s2,16(sp)
    80003598:	69a2                	ld	s3,8(sp)
    8000359a:	6145                	addi	sp,sp,48
    8000359c:	8082                	ret

000000008000359e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	e426                	sd	s1,8(sp)
    800035a6:	e04a                	sd	s2,0(sp)
    800035a8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035aa:	00011517          	auipc	a0,0x11
    800035ae:	e8650513          	addi	a0,a0,-378 # 80014430 <log>
    800035b2:	00003097          	auipc	ra,0x3
    800035b6:	dbe080e7          	jalr	-578(ra) # 80006370 <acquire>
  while(1){
    if(log.committing){
    800035ba:	00011497          	auipc	s1,0x11
    800035be:	e7648493          	addi	s1,s1,-394 # 80014430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c2:	4979                	li	s2,30
    800035c4:	a039                	j	800035d2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c6:	85a6                	mv	a1,s1
    800035c8:	8526                	mv	a0,s1
    800035ca:	ffffe097          	auipc	ra,0xffffe
    800035ce:	f38080e7          	jalr	-200(ra) # 80001502 <sleep>
    if(log.committing){
    800035d2:	50dc                	lw	a5,36(s1)
    800035d4:	fbed                	bnez	a5,800035c6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d6:	509c                	lw	a5,32(s1)
    800035d8:	0017871b          	addiw	a4,a5,1
    800035dc:	0007069b          	sext.w	a3,a4
    800035e0:	0027179b          	slliw	a5,a4,0x2
    800035e4:	9fb9                	addw	a5,a5,a4
    800035e6:	0017979b          	slliw	a5,a5,0x1
    800035ea:	54d8                	lw	a4,44(s1)
    800035ec:	9fb9                	addw	a5,a5,a4
    800035ee:	00f95963          	bge	s2,a5,80003600 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035f2:	85a6                	mv	a1,s1
    800035f4:	8526                	mv	a0,s1
    800035f6:	ffffe097          	auipc	ra,0xffffe
    800035fa:	f0c080e7          	jalr	-244(ra) # 80001502 <sleep>
    800035fe:	bfd1                	j	800035d2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003600:	00011517          	auipc	a0,0x11
    80003604:	e3050513          	addi	a0,a0,-464 # 80014430 <log>
    80003608:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	e1a080e7          	jalr	-486(ra) # 80006424 <release>
      break;
    }
  }
}
    80003612:	60e2                	ld	ra,24(sp)
    80003614:	6442                	ld	s0,16(sp)
    80003616:	64a2                	ld	s1,8(sp)
    80003618:	6902                	ld	s2,0(sp)
    8000361a:	6105                	addi	sp,sp,32
    8000361c:	8082                	ret

000000008000361e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000361e:	7139                	addi	sp,sp,-64
    80003620:	fc06                	sd	ra,56(sp)
    80003622:	f822                	sd	s0,48(sp)
    80003624:	f426                	sd	s1,40(sp)
    80003626:	f04a                	sd	s2,32(sp)
    80003628:	ec4e                	sd	s3,24(sp)
    8000362a:	e852                	sd	s4,16(sp)
    8000362c:	e456                	sd	s5,8(sp)
    8000362e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003630:	00011497          	auipc	s1,0x11
    80003634:	e0048493          	addi	s1,s1,-512 # 80014430 <log>
    80003638:	8526                	mv	a0,s1
    8000363a:	00003097          	auipc	ra,0x3
    8000363e:	d36080e7          	jalr	-714(ra) # 80006370 <acquire>
  log.outstanding -= 1;
    80003642:	509c                	lw	a5,32(s1)
    80003644:	37fd                	addiw	a5,a5,-1
    80003646:	0007891b          	sext.w	s2,a5
    8000364a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000364c:	50dc                	lw	a5,36(s1)
    8000364e:	e7b9                	bnez	a5,8000369c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003650:	04091e63          	bnez	s2,800036ac <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003654:	00011497          	auipc	s1,0x11
    80003658:	ddc48493          	addi	s1,s1,-548 # 80014430 <log>
    8000365c:	4785                	li	a5,1
    8000365e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003660:	8526                	mv	a0,s1
    80003662:	00003097          	auipc	ra,0x3
    80003666:	dc2080e7          	jalr	-574(ra) # 80006424 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000366a:	54dc                	lw	a5,44(s1)
    8000366c:	06f04763          	bgtz	a5,800036da <end_op+0xbc>
    acquire(&log.lock);
    80003670:	00011497          	auipc	s1,0x11
    80003674:	dc048493          	addi	s1,s1,-576 # 80014430 <log>
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	cf6080e7          	jalr	-778(ra) # 80006370 <acquire>
    log.committing = 0;
    80003682:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003686:	8526                	mv	a0,s1
    80003688:	ffffe097          	auipc	ra,0xffffe
    8000368c:	006080e7          	jalr	6(ra) # 8000168e <wakeup>
    release(&log.lock);
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	d92080e7          	jalr	-622(ra) # 80006424 <release>
}
    8000369a:	a03d                	j	800036c8 <end_op+0xaa>
    panic("log.committing");
    8000369c:	00005517          	auipc	a0,0x5
    800036a0:	f1450513          	addi	a0,a0,-236 # 800085b0 <syscalls+0x1e8>
    800036a4:	00002097          	auipc	ra,0x2
    800036a8:	790080e7          	jalr	1936(ra) # 80005e34 <panic>
    wakeup(&log);
    800036ac:	00011497          	auipc	s1,0x11
    800036b0:	d8448493          	addi	s1,s1,-636 # 80014430 <log>
    800036b4:	8526                	mv	a0,s1
    800036b6:	ffffe097          	auipc	ra,0xffffe
    800036ba:	fd8080e7          	jalr	-40(ra) # 8000168e <wakeup>
  release(&log.lock);
    800036be:	8526                	mv	a0,s1
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	d64080e7          	jalr	-668(ra) # 80006424 <release>
}
    800036c8:	70e2                	ld	ra,56(sp)
    800036ca:	7442                	ld	s0,48(sp)
    800036cc:	74a2                	ld	s1,40(sp)
    800036ce:	7902                	ld	s2,32(sp)
    800036d0:	69e2                	ld	s3,24(sp)
    800036d2:	6a42                	ld	s4,16(sp)
    800036d4:	6aa2                	ld	s5,8(sp)
    800036d6:	6121                	addi	sp,sp,64
    800036d8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036da:	00011a97          	auipc	s5,0x11
    800036de:	d86a8a93          	addi	s5,s5,-634 # 80014460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036e2:	00011a17          	auipc	s4,0x11
    800036e6:	d4ea0a13          	addi	s4,s4,-690 # 80014430 <log>
    800036ea:	018a2583          	lw	a1,24(s4)
    800036ee:	012585bb          	addw	a1,a1,s2
    800036f2:	2585                	addiw	a1,a1,1
    800036f4:	028a2503          	lw	a0,40(s4)
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	b68080e7          	jalr	-1176(ra) # 80002260 <bread>
    80003700:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003702:	000aa583          	lw	a1,0(s5)
    80003706:	028a2503          	lw	a0,40(s4)
    8000370a:	fffff097          	auipc	ra,0xfffff
    8000370e:	b56080e7          	jalr	-1194(ra) # 80002260 <bread>
    80003712:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003714:	40000613          	li	a2,1024
    80003718:	05850593          	addi	a1,a0,88
    8000371c:	05848513          	addi	a0,s1,88
    80003720:	ffffd097          	auipc	ra,0xffffd
    80003724:	ab4080e7          	jalr	-1356(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003728:	8526                	mv	a0,s1
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	c28080e7          	jalr	-984(ra) # 80002352 <bwrite>
    brelse(from);
    80003732:	854e                	mv	a0,s3
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	c5c080e7          	jalr	-932(ra) # 80002390 <brelse>
    brelse(to);
    8000373c:	8526                	mv	a0,s1
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	c52080e7          	jalr	-942(ra) # 80002390 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003746:	2905                	addiw	s2,s2,1
    80003748:	0a91                	addi	s5,s5,4
    8000374a:	02ca2783          	lw	a5,44(s4)
    8000374e:	f8f94ee3          	blt	s2,a5,800036ea <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003752:	00000097          	auipc	ra,0x0
    80003756:	c6a080e7          	jalr	-918(ra) # 800033bc <write_head>
    install_trans(0); // Now install writes to home locations
    8000375a:	4501                	li	a0,0
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	cda080e7          	jalr	-806(ra) # 80003436 <install_trans>
    log.lh.n = 0;
    80003764:	00011797          	auipc	a5,0x11
    80003768:	ce07ac23          	sw	zero,-776(a5) # 8001445c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000376c:	00000097          	auipc	ra,0x0
    80003770:	c50080e7          	jalr	-944(ra) # 800033bc <write_head>
    80003774:	bdf5                	j	80003670 <end_op+0x52>

0000000080003776 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003776:	1101                	addi	sp,sp,-32
    80003778:	ec06                	sd	ra,24(sp)
    8000377a:	e822                	sd	s0,16(sp)
    8000377c:	e426                	sd	s1,8(sp)
    8000377e:	e04a                	sd	s2,0(sp)
    80003780:	1000                	addi	s0,sp,32
    80003782:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003784:	00011917          	auipc	s2,0x11
    80003788:	cac90913          	addi	s2,s2,-852 # 80014430 <log>
    8000378c:	854a                	mv	a0,s2
    8000378e:	00003097          	auipc	ra,0x3
    80003792:	be2080e7          	jalr	-1054(ra) # 80006370 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003796:	02c92603          	lw	a2,44(s2)
    8000379a:	47f5                	li	a5,29
    8000379c:	06c7c563          	blt	a5,a2,80003806 <log_write+0x90>
    800037a0:	00011797          	auipc	a5,0x11
    800037a4:	cac7a783          	lw	a5,-852(a5) # 8001444c <log+0x1c>
    800037a8:	37fd                	addiw	a5,a5,-1
    800037aa:	04f65e63          	bge	a2,a5,80003806 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ae:	00011797          	auipc	a5,0x11
    800037b2:	ca27a783          	lw	a5,-862(a5) # 80014450 <log+0x20>
    800037b6:	06f05063          	blez	a5,80003816 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ba:	4781                	li	a5,0
    800037bc:	06c05563          	blez	a2,80003826 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c0:	44cc                	lw	a1,12(s1)
    800037c2:	00011717          	auipc	a4,0x11
    800037c6:	c9e70713          	addi	a4,a4,-866 # 80014460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037cc:	4314                	lw	a3,0(a4)
    800037ce:	04b68c63          	beq	a3,a1,80003826 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037d2:	2785                	addiw	a5,a5,1
    800037d4:	0711                	addi	a4,a4,4
    800037d6:	fef61be3          	bne	a2,a5,800037cc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037da:	0621                	addi	a2,a2,8
    800037dc:	060a                	slli	a2,a2,0x2
    800037de:	00011797          	auipc	a5,0x11
    800037e2:	c5278793          	addi	a5,a5,-942 # 80014430 <log>
    800037e6:	963e                	add	a2,a2,a5
    800037e8:	44dc                	lw	a5,12(s1)
    800037ea:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ec:	8526                	mv	a0,s1
    800037ee:	fffff097          	auipc	ra,0xfffff
    800037f2:	c40080e7          	jalr	-960(ra) # 8000242e <bpin>
    log.lh.n++;
    800037f6:	00011717          	auipc	a4,0x11
    800037fa:	c3a70713          	addi	a4,a4,-966 # 80014430 <log>
    800037fe:	575c                	lw	a5,44(a4)
    80003800:	2785                	addiw	a5,a5,1
    80003802:	d75c                	sw	a5,44(a4)
    80003804:	a835                	j	80003840 <log_write+0xca>
    panic("too big a transaction");
    80003806:	00005517          	auipc	a0,0x5
    8000380a:	dba50513          	addi	a0,a0,-582 # 800085c0 <syscalls+0x1f8>
    8000380e:	00002097          	auipc	ra,0x2
    80003812:	626080e7          	jalr	1574(ra) # 80005e34 <panic>
    panic("log_write outside of trans");
    80003816:	00005517          	auipc	a0,0x5
    8000381a:	dc250513          	addi	a0,a0,-574 # 800085d8 <syscalls+0x210>
    8000381e:	00002097          	auipc	ra,0x2
    80003822:	616080e7          	jalr	1558(ra) # 80005e34 <panic>
  log.lh.block[i] = b->blockno;
    80003826:	00878713          	addi	a4,a5,8
    8000382a:	00271693          	slli	a3,a4,0x2
    8000382e:	00011717          	auipc	a4,0x11
    80003832:	c0270713          	addi	a4,a4,-1022 # 80014430 <log>
    80003836:	9736                	add	a4,a4,a3
    80003838:	44d4                	lw	a3,12(s1)
    8000383a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000383c:	faf608e3          	beq	a2,a5,800037ec <log_write+0x76>
  }
  release(&log.lock);
    80003840:	00011517          	auipc	a0,0x11
    80003844:	bf050513          	addi	a0,a0,-1040 # 80014430 <log>
    80003848:	00003097          	auipc	ra,0x3
    8000384c:	bdc080e7          	jalr	-1060(ra) # 80006424 <release>
}
    80003850:	60e2                	ld	ra,24(sp)
    80003852:	6442                	ld	s0,16(sp)
    80003854:	64a2                	ld	s1,8(sp)
    80003856:	6902                	ld	s2,0(sp)
    80003858:	6105                	addi	sp,sp,32
    8000385a:	8082                	ret

000000008000385c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000385c:	1101                	addi	sp,sp,-32
    8000385e:	ec06                	sd	ra,24(sp)
    80003860:	e822                	sd	s0,16(sp)
    80003862:	e426                	sd	s1,8(sp)
    80003864:	e04a                	sd	s2,0(sp)
    80003866:	1000                	addi	s0,sp,32
    80003868:	84aa                	mv	s1,a0
    8000386a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000386c:	00005597          	auipc	a1,0x5
    80003870:	d8c58593          	addi	a1,a1,-628 # 800085f8 <syscalls+0x230>
    80003874:	0521                	addi	a0,a0,8
    80003876:	00003097          	auipc	ra,0x3
    8000387a:	a6a080e7          	jalr	-1430(ra) # 800062e0 <initlock>
  lk->name = name;
    8000387e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003882:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003886:	0204a423          	sw	zero,40(s1)
}
    8000388a:	60e2                	ld	ra,24(sp)
    8000388c:	6442                	ld	s0,16(sp)
    8000388e:	64a2                	ld	s1,8(sp)
    80003890:	6902                	ld	s2,0(sp)
    80003892:	6105                	addi	sp,sp,32
    80003894:	8082                	ret

0000000080003896 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003896:	1101                	addi	sp,sp,-32
    80003898:	ec06                	sd	ra,24(sp)
    8000389a:	e822                	sd	s0,16(sp)
    8000389c:	e426                	sd	s1,8(sp)
    8000389e:	e04a                	sd	s2,0(sp)
    800038a0:	1000                	addi	s0,sp,32
    800038a2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038a4:	00850913          	addi	s2,a0,8
    800038a8:	854a                	mv	a0,s2
    800038aa:	00003097          	auipc	ra,0x3
    800038ae:	ac6080e7          	jalr	-1338(ra) # 80006370 <acquire>
  while (lk->locked) {
    800038b2:	409c                	lw	a5,0(s1)
    800038b4:	cb89                	beqz	a5,800038c6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038b6:	85ca                	mv	a1,s2
    800038b8:	8526                	mv	a0,s1
    800038ba:	ffffe097          	auipc	ra,0xffffe
    800038be:	c48080e7          	jalr	-952(ra) # 80001502 <sleep>
  while (lk->locked) {
    800038c2:	409c                	lw	a5,0(s1)
    800038c4:	fbed                	bnez	a5,800038b6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038c6:	4785                	li	a5,1
    800038c8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ca:	ffffd097          	auipc	ra,0xffffd
    800038ce:	578080e7          	jalr	1400(ra) # 80000e42 <myproc>
    800038d2:	591c                	lw	a5,48(a0)
    800038d4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038d6:	854a                	mv	a0,s2
    800038d8:	00003097          	auipc	ra,0x3
    800038dc:	b4c080e7          	jalr	-1204(ra) # 80006424 <release>
}
    800038e0:	60e2                	ld	ra,24(sp)
    800038e2:	6442                	ld	s0,16(sp)
    800038e4:	64a2                	ld	s1,8(sp)
    800038e6:	6902                	ld	s2,0(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret

00000000800038ec <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038ec:	1101                	addi	sp,sp,-32
    800038ee:	ec06                	sd	ra,24(sp)
    800038f0:	e822                	sd	s0,16(sp)
    800038f2:	e426                	sd	s1,8(sp)
    800038f4:	e04a                	sd	s2,0(sp)
    800038f6:	1000                	addi	s0,sp,32
    800038f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038fa:	00850913          	addi	s2,a0,8
    800038fe:	854a                	mv	a0,s2
    80003900:	00003097          	auipc	ra,0x3
    80003904:	a70080e7          	jalr	-1424(ra) # 80006370 <acquire>
  lk->locked = 0;
    80003908:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000390c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003910:	8526                	mv	a0,s1
    80003912:	ffffe097          	auipc	ra,0xffffe
    80003916:	d7c080e7          	jalr	-644(ra) # 8000168e <wakeup>
  release(&lk->lk);
    8000391a:	854a                	mv	a0,s2
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	b08080e7          	jalr	-1272(ra) # 80006424 <release>
}
    80003924:	60e2                	ld	ra,24(sp)
    80003926:	6442                	ld	s0,16(sp)
    80003928:	64a2                	ld	s1,8(sp)
    8000392a:	6902                	ld	s2,0(sp)
    8000392c:	6105                	addi	sp,sp,32
    8000392e:	8082                	ret

0000000080003930 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003930:	7179                	addi	sp,sp,-48
    80003932:	f406                	sd	ra,40(sp)
    80003934:	f022                	sd	s0,32(sp)
    80003936:	ec26                	sd	s1,24(sp)
    80003938:	e84a                	sd	s2,16(sp)
    8000393a:	e44e                	sd	s3,8(sp)
    8000393c:	1800                	addi	s0,sp,48
    8000393e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003940:	00850913          	addi	s2,a0,8
    80003944:	854a                	mv	a0,s2
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	a2a080e7          	jalr	-1494(ra) # 80006370 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000394e:	409c                	lw	a5,0(s1)
    80003950:	ef99                	bnez	a5,8000396e <holdingsleep+0x3e>
    80003952:	4481                	li	s1,0
  release(&lk->lk);
    80003954:	854a                	mv	a0,s2
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	ace080e7          	jalr	-1330(ra) # 80006424 <release>
  return r;
}
    8000395e:	8526                	mv	a0,s1
    80003960:	70a2                	ld	ra,40(sp)
    80003962:	7402                	ld	s0,32(sp)
    80003964:	64e2                	ld	s1,24(sp)
    80003966:	6942                	ld	s2,16(sp)
    80003968:	69a2                	ld	s3,8(sp)
    8000396a:	6145                	addi	sp,sp,48
    8000396c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000396e:	0284a983          	lw	s3,40(s1)
    80003972:	ffffd097          	auipc	ra,0xffffd
    80003976:	4d0080e7          	jalr	1232(ra) # 80000e42 <myproc>
    8000397a:	5904                	lw	s1,48(a0)
    8000397c:	413484b3          	sub	s1,s1,s3
    80003980:	0014b493          	seqz	s1,s1
    80003984:	bfc1                	j	80003954 <holdingsleep+0x24>

0000000080003986 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003986:	1141                	addi	sp,sp,-16
    80003988:	e406                	sd	ra,8(sp)
    8000398a:	e022                	sd	s0,0(sp)
    8000398c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000398e:	00005597          	auipc	a1,0x5
    80003992:	c7a58593          	addi	a1,a1,-902 # 80008608 <syscalls+0x240>
    80003996:	00011517          	auipc	a0,0x11
    8000399a:	be250513          	addi	a0,a0,-1054 # 80014578 <ftable>
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	942080e7          	jalr	-1726(ra) # 800062e0 <initlock>
}
    800039a6:	60a2                	ld	ra,8(sp)
    800039a8:	6402                	ld	s0,0(sp)
    800039aa:	0141                	addi	sp,sp,16
    800039ac:	8082                	ret

00000000800039ae <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039ae:	1101                	addi	sp,sp,-32
    800039b0:	ec06                	sd	ra,24(sp)
    800039b2:	e822                	sd	s0,16(sp)
    800039b4:	e426                	sd	s1,8(sp)
    800039b6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039b8:	00011517          	auipc	a0,0x11
    800039bc:	bc050513          	addi	a0,a0,-1088 # 80014578 <ftable>
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	9b0080e7          	jalr	-1616(ra) # 80006370 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c8:	00011497          	auipc	s1,0x11
    800039cc:	bc848493          	addi	s1,s1,-1080 # 80014590 <ftable+0x18>
    800039d0:	00012717          	auipc	a4,0x12
    800039d4:	b6070713          	addi	a4,a4,-1184 # 80015530 <ftable+0xfb8>
    if(f->ref == 0){
    800039d8:	40dc                	lw	a5,4(s1)
    800039da:	cf99                	beqz	a5,800039f8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039dc:	02848493          	addi	s1,s1,40
    800039e0:	fee49ce3          	bne	s1,a4,800039d8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039e4:	00011517          	auipc	a0,0x11
    800039e8:	b9450513          	addi	a0,a0,-1132 # 80014578 <ftable>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	a38080e7          	jalr	-1480(ra) # 80006424 <release>
  return 0;
    800039f4:	4481                	li	s1,0
    800039f6:	a819                	j	80003a0c <filealloc+0x5e>
      f->ref = 1;
    800039f8:	4785                	li	a5,1
    800039fa:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039fc:	00011517          	auipc	a0,0x11
    80003a00:	b7c50513          	addi	a0,a0,-1156 # 80014578 <ftable>
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	a20080e7          	jalr	-1504(ra) # 80006424 <release>
}
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	60e2                	ld	ra,24(sp)
    80003a10:	6442                	ld	s0,16(sp)
    80003a12:	64a2                	ld	s1,8(sp)
    80003a14:	6105                	addi	sp,sp,32
    80003a16:	8082                	ret

0000000080003a18 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a18:	1101                	addi	sp,sp,-32
    80003a1a:	ec06                	sd	ra,24(sp)
    80003a1c:	e822                	sd	s0,16(sp)
    80003a1e:	e426                	sd	s1,8(sp)
    80003a20:	1000                	addi	s0,sp,32
    80003a22:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a24:	00011517          	auipc	a0,0x11
    80003a28:	b5450513          	addi	a0,a0,-1196 # 80014578 <ftable>
    80003a2c:	00003097          	auipc	ra,0x3
    80003a30:	944080e7          	jalr	-1724(ra) # 80006370 <acquire>
  if(f->ref < 1)
    80003a34:	40dc                	lw	a5,4(s1)
    80003a36:	02f05263          	blez	a5,80003a5a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a3a:	2785                	addiw	a5,a5,1
    80003a3c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a3e:	00011517          	auipc	a0,0x11
    80003a42:	b3a50513          	addi	a0,a0,-1222 # 80014578 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	9de080e7          	jalr	-1570(ra) # 80006424 <release>
  return f;
}
    80003a4e:	8526                	mv	a0,s1
    80003a50:	60e2                	ld	ra,24(sp)
    80003a52:	6442                	ld	s0,16(sp)
    80003a54:	64a2                	ld	s1,8(sp)
    80003a56:	6105                	addi	sp,sp,32
    80003a58:	8082                	ret
    panic("filedup");
    80003a5a:	00005517          	auipc	a0,0x5
    80003a5e:	bb650513          	addi	a0,a0,-1098 # 80008610 <syscalls+0x248>
    80003a62:	00002097          	auipc	ra,0x2
    80003a66:	3d2080e7          	jalr	978(ra) # 80005e34 <panic>

0000000080003a6a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a6a:	7139                	addi	sp,sp,-64
    80003a6c:	fc06                	sd	ra,56(sp)
    80003a6e:	f822                	sd	s0,48(sp)
    80003a70:	f426                	sd	s1,40(sp)
    80003a72:	f04a                	sd	s2,32(sp)
    80003a74:	ec4e                	sd	s3,24(sp)
    80003a76:	e852                	sd	s4,16(sp)
    80003a78:	e456                	sd	s5,8(sp)
    80003a7a:	0080                	addi	s0,sp,64
    80003a7c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a7e:	00011517          	auipc	a0,0x11
    80003a82:	afa50513          	addi	a0,a0,-1286 # 80014578 <ftable>
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	8ea080e7          	jalr	-1814(ra) # 80006370 <acquire>
  if(f->ref < 1)
    80003a8e:	40dc                	lw	a5,4(s1)
    80003a90:	06f05163          	blez	a5,80003af2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a94:	37fd                	addiw	a5,a5,-1
    80003a96:	0007871b          	sext.w	a4,a5
    80003a9a:	c0dc                	sw	a5,4(s1)
    80003a9c:	06e04363          	bgtz	a4,80003b02 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aa0:	0004a903          	lw	s2,0(s1)
    80003aa4:	0094ca83          	lbu	s5,9(s1)
    80003aa8:	0104ba03          	ld	s4,16(s1)
    80003aac:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ab0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ab4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ab8:	00011517          	auipc	a0,0x11
    80003abc:	ac050513          	addi	a0,a0,-1344 # 80014578 <ftable>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	964080e7          	jalr	-1692(ra) # 80006424 <release>

  if(ff.type == FD_PIPE){
    80003ac8:	4785                	li	a5,1
    80003aca:	04f90d63          	beq	s2,a5,80003b24 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ace:	3979                	addiw	s2,s2,-2
    80003ad0:	4785                	li	a5,1
    80003ad2:	0527e063          	bltu	a5,s2,80003b12 <fileclose+0xa8>
    begin_op();
    80003ad6:	00000097          	auipc	ra,0x0
    80003ada:	ac8080e7          	jalr	-1336(ra) # 8000359e <begin_op>
    iput(ff.ip);
    80003ade:	854e                	mv	a0,s3
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	2a4080e7          	jalr	676(ra) # 80002d84 <iput>
    end_op();
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	b36080e7          	jalr	-1226(ra) # 8000361e <end_op>
    80003af0:	a00d                	j	80003b12 <fileclose+0xa8>
    panic("fileclose");
    80003af2:	00005517          	auipc	a0,0x5
    80003af6:	b2650513          	addi	a0,a0,-1242 # 80008618 <syscalls+0x250>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	33a080e7          	jalr	826(ra) # 80005e34 <panic>
    release(&ftable.lock);
    80003b02:	00011517          	auipc	a0,0x11
    80003b06:	a7650513          	addi	a0,a0,-1418 # 80014578 <ftable>
    80003b0a:	00003097          	auipc	ra,0x3
    80003b0e:	91a080e7          	jalr	-1766(ra) # 80006424 <release>
  }
}
    80003b12:	70e2                	ld	ra,56(sp)
    80003b14:	7442                	ld	s0,48(sp)
    80003b16:	74a2                	ld	s1,40(sp)
    80003b18:	7902                	ld	s2,32(sp)
    80003b1a:	69e2                	ld	s3,24(sp)
    80003b1c:	6a42                	ld	s4,16(sp)
    80003b1e:	6aa2                	ld	s5,8(sp)
    80003b20:	6121                	addi	sp,sp,64
    80003b22:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b24:	85d6                	mv	a1,s5
    80003b26:	8552                	mv	a0,s4
    80003b28:	00000097          	auipc	ra,0x0
    80003b2c:	34c080e7          	jalr	844(ra) # 80003e74 <pipeclose>
    80003b30:	b7cd                	j	80003b12 <fileclose+0xa8>

0000000080003b32 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b32:	715d                	addi	sp,sp,-80
    80003b34:	e486                	sd	ra,72(sp)
    80003b36:	e0a2                	sd	s0,64(sp)
    80003b38:	fc26                	sd	s1,56(sp)
    80003b3a:	f84a                	sd	s2,48(sp)
    80003b3c:	f44e                	sd	s3,40(sp)
    80003b3e:	0880                	addi	s0,sp,80
    80003b40:	84aa                	mv	s1,a0
    80003b42:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b44:	ffffd097          	auipc	ra,0xffffd
    80003b48:	2fe080e7          	jalr	766(ra) # 80000e42 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b4c:	409c                	lw	a5,0(s1)
    80003b4e:	37f9                	addiw	a5,a5,-2
    80003b50:	4705                	li	a4,1
    80003b52:	04f76763          	bltu	a4,a5,80003ba0 <filestat+0x6e>
    80003b56:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b58:	6c88                	ld	a0,24(s1)
    80003b5a:	fffff097          	auipc	ra,0xfffff
    80003b5e:	fca080e7          	jalr	-54(ra) # 80002b24 <ilock>
    stati(f->ip, &st);
    80003b62:	fb840593          	addi	a1,s0,-72
    80003b66:	6c88                	ld	a0,24(s1)
    80003b68:	fffff097          	auipc	ra,0xfffff
    80003b6c:	2ec080e7          	jalr	748(ra) # 80002e54 <stati>
    iunlock(f->ip);
    80003b70:	6c88                	ld	a0,24(s1)
    80003b72:	fffff097          	auipc	ra,0xfffff
    80003b76:	074080e7          	jalr	116(ra) # 80002be6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b7a:	46e1                	li	a3,24
    80003b7c:	fb840613          	addi	a2,s0,-72
    80003b80:	85ce                	mv	a1,s3
    80003b82:	05093503          	ld	a0,80(s2)
    80003b86:	ffffd097          	auipc	ra,0xffffd
    80003b8a:	f7c080e7          	jalr	-132(ra) # 80000b02 <copyout>
    80003b8e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b92:	60a6                	ld	ra,72(sp)
    80003b94:	6406                	ld	s0,64(sp)
    80003b96:	74e2                	ld	s1,56(sp)
    80003b98:	7942                	ld	s2,48(sp)
    80003b9a:	79a2                	ld	s3,40(sp)
    80003b9c:	6161                	addi	sp,sp,80
    80003b9e:	8082                	ret
  return -1;
    80003ba0:	557d                	li	a0,-1
    80003ba2:	bfc5                	j	80003b92 <filestat+0x60>

0000000080003ba4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ba4:	7179                	addi	sp,sp,-48
    80003ba6:	f406                	sd	ra,40(sp)
    80003ba8:	f022                	sd	s0,32(sp)
    80003baa:	ec26                	sd	s1,24(sp)
    80003bac:	e84a                	sd	s2,16(sp)
    80003bae:	e44e                	sd	s3,8(sp)
    80003bb0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bb2:	00854783          	lbu	a5,8(a0)
    80003bb6:	c3d5                	beqz	a5,80003c5a <fileread+0xb6>
    80003bb8:	84aa                	mv	s1,a0
    80003bba:	89ae                	mv	s3,a1
    80003bbc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bbe:	411c                	lw	a5,0(a0)
    80003bc0:	4705                	li	a4,1
    80003bc2:	04e78963          	beq	a5,a4,80003c14 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bc6:	470d                	li	a4,3
    80003bc8:	04e78d63          	beq	a5,a4,80003c22 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bcc:	4709                	li	a4,2
    80003bce:	06e79e63          	bne	a5,a4,80003c4a <fileread+0xa6>
    ilock(f->ip);
    80003bd2:	6d08                	ld	a0,24(a0)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	f50080e7          	jalr	-176(ra) # 80002b24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bdc:	874a                	mv	a4,s2
    80003bde:	5094                	lw	a3,32(s1)
    80003be0:	864e                	mv	a2,s3
    80003be2:	4585                	li	a1,1
    80003be4:	6c88                	ld	a0,24(s1)
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	298080e7          	jalr	664(ra) # 80002e7e <readi>
    80003bee:	892a                	mv	s2,a0
    80003bf0:	00a05563          	blez	a0,80003bfa <fileread+0x56>
      f->off += r;
    80003bf4:	509c                	lw	a5,32(s1)
    80003bf6:	9fa9                	addw	a5,a5,a0
    80003bf8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	fea080e7          	jalr	-22(ra) # 80002be6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c04:	854a                	mv	a0,s2
    80003c06:	70a2                	ld	ra,40(sp)
    80003c08:	7402                	ld	s0,32(sp)
    80003c0a:	64e2                	ld	s1,24(sp)
    80003c0c:	6942                	ld	s2,16(sp)
    80003c0e:	69a2                	ld	s3,8(sp)
    80003c10:	6145                	addi	sp,sp,48
    80003c12:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c14:	6908                	ld	a0,16(a0)
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	3c0080e7          	jalr	960(ra) # 80003fd6 <piperead>
    80003c1e:	892a                	mv	s2,a0
    80003c20:	b7d5                	j	80003c04 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c22:	02451783          	lh	a5,36(a0)
    80003c26:	03079693          	slli	a3,a5,0x30
    80003c2a:	92c1                	srli	a3,a3,0x30
    80003c2c:	4725                	li	a4,9
    80003c2e:	02d76863          	bltu	a4,a3,80003c5e <fileread+0xba>
    80003c32:	0792                	slli	a5,a5,0x4
    80003c34:	00011717          	auipc	a4,0x11
    80003c38:	8a470713          	addi	a4,a4,-1884 # 800144d8 <devsw>
    80003c3c:	97ba                	add	a5,a5,a4
    80003c3e:	639c                	ld	a5,0(a5)
    80003c40:	c38d                	beqz	a5,80003c62 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c42:	4505                	li	a0,1
    80003c44:	9782                	jalr	a5
    80003c46:	892a                	mv	s2,a0
    80003c48:	bf75                	j	80003c04 <fileread+0x60>
    panic("fileread");
    80003c4a:	00005517          	auipc	a0,0x5
    80003c4e:	9de50513          	addi	a0,a0,-1570 # 80008628 <syscalls+0x260>
    80003c52:	00002097          	auipc	ra,0x2
    80003c56:	1e2080e7          	jalr	482(ra) # 80005e34 <panic>
    return -1;
    80003c5a:	597d                	li	s2,-1
    80003c5c:	b765                	j	80003c04 <fileread+0x60>
      return -1;
    80003c5e:	597d                	li	s2,-1
    80003c60:	b755                	j	80003c04 <fileread+0x60>
    80003c62:	597d                	li	s2,-1
    80003c64:	b745                	j	80003c04 <fileread+0x60>

0000000080003c66 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c66:	715d                	addi	sp,sp,-80
    80003c68:	e486                	sd	ra,72(sp)
    80003c6a:	e0a2                	sd	s0,64(sp)
    80003c6c:	fc26                	sd	s1,56(sp)
    80003c6e:	f84a                	sd	s2,48(sp)
    80003c70:	f44e                	sd	s3,40(sp)
    80003c72:	f052                	sd	s4,32(sp)
    80003c74:	ec56                	sd	s5,24(sp)
    80003c76:	e85a                	sd	s6,16(sp)
    80003c78:	e45e                	sd	s7,8(sp)
    80003c7a:	e062                	sd	s8,0(sp)
    80003c7c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c7e:	00954783          	lbu	a5,9(a0)
    80003c82:	10078663          	beqz	a5,80003d8e <filewrite+0x128>
    80003c86:	892a                	mv	s2,a0
    80003c88:	8aae                	mv	s5,a1
    80003c8a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c8c:	411c                	lw	a5,0(a0)
    80003c8e:	4705                	li	a4,1
    80003c90:	02e78263          	beq	a5,a4,80003cb4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c94:	470d                	li	a4,3
    80003c96:	02e78663          	beq	a5,a4,80003cc2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c9a:	4709                	li	a4,2
    80003c9c:	0ee79163          	bne	a5,a4,80003d7e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ca0:	0ac05d63          	blez	a2,80003d5a <filewrite+0xf4>
    int i = 0;
    80003ca4:	4981                	li	s3,0
    80003ca6:	6b05                	lui	s6,0x1
    80003ca8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cac:	6b85                	lui	s7,0x1
    80003cae:	c00b8b9b          	addiw	s7,s7,-1024
    80003cb2:	a861                	j	80003d4a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cb4:	6908                	ld	a0,16(a0)
    80003cb6:	00000097          	auipc	ra,0x0
    80003cba:	22e080e7          	jalr	558(ra) # 80003ee4 <pipewrite>
    80003cbe:	8a2a                	mv	s4,a0
    80003cc0:	a045                	j	80003d60 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cc2:	02451783          	lh	a5,36(a0)
    80003cc6:	03079693          	slli	a3,a5,0x30
    80003cca:	92c1                	srli	a3,a3,0x30
    80003ccc:	4725                	li	a4,9
    80003cce:	0cd76263          	bltu	a4,a3,80003d92 <filewrite+0x12c>
    80003cd2:	0792                	slli	a5,a5,0x4
    80003cd4:	00011717          	auipc	a4,0x11
    80003cd8:	80470713          	addi	a4,a4,-2044 # 800144d8 <devsw>
    80003cdc:	97ba                	add	a5,a5,a4
    80003cde:	679c                	ld	a5,8(a5)
    80003ce0:	cbdd                	beqz	a5,80003d96 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ce2:	4505                	li	a0,1
    80003ce4:	9782                	jalr	a5
    80003ce6:	8a2a                	mv	s4,a0
    80003ce8:	a8a5                	j	80003d60 <filewrite+0xfa>
    80003cea:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	8b0080e7          	jalr	-1872(ra) # 8000359e <begin_op>
      ilock(f->ip);
    80003cf6:	01893503          	ld	a0,24(s2)
    80003cfa:	fffff097          	auipc	ra,0xfffff
    80003cfe:	e2a080e7          	jalr	-470(ra) # 80002b24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d02:	8762                	mv	a4,s8
    80003d04:	02092683          	lw	a3,32(s2)
    80003d08:	01598633          	add	a2,s3,s5
    80003d0c:	4585                	li	a1,1
    80003d0e:	01893503          	ld	a0,24(s2)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	264080e7          	jalr	612(ra) # 80002f76 <writei>
    80003d1a:	84aa                	mv	s1,a0
    80003d1c:	00a05763          	blez	a0,80003d2a <filewrite+0xc4>
        f->off += r;
    80003d20:	02092783          	lw	a5,32(s2)
    80003d24:	9fa9                	addw	a5,a5,a0
    80003d26:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d2a:	01893503          	ld	a0,24(s2)
    80003d2e:	fffff097          	auipc	ra,0xfffff
    80003d32:	eb8080e7          	jalr	-328(ra) # 80002be6 <iunlock>
      end_op();
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	8e8080e7          	jalr	-1816(ra) # 8000361e <end_op>

      if(r != n1){
    80003d3e:	009c1f63          	bne	s8,s1,80003d5c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d42:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d46:	0149db63          	bge	s3,s4,80003d5c <filewrite+0xf6>
      int n1 = n - i;
    80003d4a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d4e:	84be                	mv	s1,a5
    80003d50:	2781                	sext.w	a5,a5
    80003d52:	f8fb5ce3          	bge	s6,a5,80003cea <filewrite+0x84>
    80003d56:	84de                	mv	s1,s7
    80003d58:	bf49                	j	80003cea <filewrite+0x84>
    int i = 0;
    80003d5a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d5c:	013a1f63          	bne	s4,s3,80003d7a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d60:	8552                	mv	a0,s4
    80003d62:	60a6                	ld	ra,72(sp)
    80003d64:	6406                	ld	s0,64(sp)
    80003d66:	74e2                	ld	s1,56(sp)
    80003d68:	7942                	ld	s2,48(sp)
    80003d6a:	79a2                	ld	s3,40(sp)
    80003d6c:	7a02                	ld	s4,32(sp)
    80003d6e:	6ae2                	ld	s5,24(sp)
    80003d70:	6b42                	ld	s6,16(sp)
    80003d72:	6ba2                	ld	s7,8(sp)
    80003d74:	6c02                	ld	s8,0(sp)
    80003d76:	6161                	addi	sp,sp,80
    80003d78:	8082                	ret
    ret = (i == n ? n : -1);
    80003d7a:	5a7d                	li	s4,-1
    80003d7c:	b7d5                	j	80003d60 <filewrite+0xfa>
    panic("filewrite");
    80003d7e:	00005517          	auipc	a0,0x5
    80003d82:	8ba50513          	addi	a0,a0,-1862 # 80008638 <syscalls+0x270>
    80003d86:	00002097          	auipc	ra,0x2
    80003d8a:	0ae080e7          	jalr	174(ra) # 80005e34 <panic>
    return -1;
    80003d8e:	5a7d                	li	s4,-1
    80003d90:	bfc1                	j	80003d60 <filewrite+0xfa>
      return -1;
    80003d92:	5a7d                	li	s4,-1
    80003d94:	b7f1                	j	80003d60 <filewrite+0xfa>
    80003d96:	5a7d                	li	s4,-1
    80003d98:	b7e1                	j	80003d60 <filewrite+0xfa>

0000000080003d9a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d9a:	7179                	addi	sp,sp,-48
    80003d9c:	f406                	sd	ra,40(sp)
    80003d9e:	f022                	sd	s0,32(sp)
    80003da0:	ec26                	sd	s1,24(sp)
    80003da2:	e84a                	sd	s2,16(sp)
    80003da4:	e44e                	sd	s3,8(sp)
    80003da6:	e052                	sd	s4,0(sp)
    80003da8:	1800                	addi	s0,sp,48
    80003daa:	84aa                	mv	s1,a0
    80003dac:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dae:	0005b023          	sd	zero,0(a1)
    80003db2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	bf8080e7          	jalr	-1032(ra) # 800039ae <filealloc>
    80003dbe:	e088                	sd	a0,0(s1)
    80003dc0:	c551                	beqz	a0,80003e4c <pipealloc+0xb2>
    80003dc2:	00000097          	auipc	ra,0x0
    80003dc6:	bec080e7          	jalr	-1044(ra) # 800039ae <filealloc>
    80003dca:	00aa3023          	sd	a0,0(s4)
    80003dce:	c92d                	beqz	a0,80003e40 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd0:	ffffc097          	auipc	ra,0xffffc
    80003dd4:	348080e7          	jalr	840(ra) # 80000118 <kalloc>
    80003dd8:	892a                	mv	s2,a0
    80003dda:	c125                	beqz	a0,80003e3a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ddc:	4985                	li	s3,1
    80003dde:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003de2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003de6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dea:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dee:	00005597          	auipc	a1,0x5
    80003df2:	85a58593          	addi	a1,a1,-1958 # 80008648 <syscalls+0x280>
    80003df6:	00002097          	auipc	ra,0x2
    80003dfa:	4ea080e7          	jalr	1258(ra) # 800062e0 <initlock>
  (*f0)->type = FD_PIPE;
    80003dfe:	609c                	ld	a5,0(s1)
    80003e00:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e04:	609c                	ld	a5,0(s1)
    80003e06:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e0a:	609c                	ld	a5,0(s1)
    80003e0c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e10:	609c                	ld	a5,0(s1)
    80003e12:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e16:	000a3783          	ld	a5,0(s4)
    80003e1a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e1e:	000a3783          	ld	a5,0(s4)
    80003e22:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e26:	000a3783          	ld	a5,0(s4)
    80003e2a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e2e:	000a3783          	ld	a5,0(s4)
    80003e32:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e36:	4501                	li	a0,0
    80003e38:	a025                	j	80003e60 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e3a:	6088                	ld	a0,0(s1)
    80003e3c:	e501                	bnez	a0,80003e44 <pipealloc+0xaa>
    80003e3e:	a039                	j	80003e4c <pipealloc+0xb2>
    80003e40:	6088                	ld	a0,0(s1)
    80003e42:	c51d                	beqz	a0,80003e70 <pipealloc+0xd6>
    fileclose(*f0);
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	c26080e7          	jalr	-986(ra) # 80003a6a <fileclose>
  if(*f1)
    80003e4c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e50:	557d                	li	a0,-1
  if(*f1)
    80003e52:	c799                	beqz	a5,80003e60 <pipealloc+0xc6>
    fileclose(*f1);
    80003e54:	853e                	mv	a0,a5
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	c14080e7          	jalr	-1004(ra) # 80003a6a <fileclose>
  return -1;
    80003e5e:	557d                	li	a0,-1
}
    80003e60:	70a2                	ld	ra,40(sp)
    80003e62:	7402                	ld	s0,32(sp)
    80003e64:	64e2                	ld	s1,24(sp)
    80003e66:	6942                	ld	s2,16(sp)
    80003e68:	69a2                	ld	s3,8(sp)
    80003e6a:	6a02                	ld	s4,0(sp)
    80003e6c:	6145                	addi	sp,sp,48
    80003e6e:	8082                	ret
  return -1;
    80003e70:	557d                	li	a0,-1
    80003e72:	b7fd                	j	80003e60 <pipealloc+0xc6>

0000000080003e74 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e74:	1101                	addi	sp,sp,-32
    80003e76:	ec06                	sd	ra,24(sp)
    80003e78:	e822                	sd	s0,16(sp)
    80003e7a:	e426                	sd	s1,8(sp)
    80003e7c:	e04a                	sd	s2,0(sp)
    80003e7e:	1000                	addi	s0,sp,32
    80003e80:	84aa                	mv	s1,a0
    80003e82:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e84:	00002097          	auipc	ra,0x2
    80003e88:	4ec080e7          	jalr	1260(ra) # 80006370 <acquire>
  if(writable){
    80003e8c:	02090d63          	beqz	s2,80003ec6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e90:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e94:	21848513          	addi	a0,s1,536
    80003e98:	ffffd097          	auipc	ra,0xffffd
    80003e9c:	7f6080e7          	jalr	2038(ra) # 8000168e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ea0:	2204b783          	ld	a5,544(s1)
    80003ea4:	eb95                	bnez	a5,80003ed8 <pipeclose+0x64>
    release(&pi->lock);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	00002097          	auipc	ra,0x2
    80003eac:	57c080e7          	jalr	1404(ra) # 80006424 <release>
    kfree((char*)pi);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	ffffc097          	auipc	ra,0xffffc
    80003eb6:	16a080e7          	jalr	362(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eba:	60e2                	ld	ra,24(sp)
    80003ebc:	6442                	ld	s0,16(sp)
    80003ebe:	64a2                	ld	s1,8(sp)
    80003ec0:	6902                	ld	s2,0(sp)
    80003ec2:	6105                	addi	sp,sp,32
    80003ec4:	8082                	ret
    pi->readopen = 0;
    80003ec6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eca:	21c48513          	addi	a0,s1,540
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	7c0080e7          	jalr	1984(ra) # 8000168e <wakeup>
    80003ed6:	b7e9                	j	80003ea0 <pipeclose+0x2c>
    release(&pi->lock);
    80003ed8:	8526                	mv	a0,s1
    80003eda:	00002097          	auipc	ra,0x2
    80003ede:	54a080e7          	jalr	1354(ra) # 80006424 <release>
}
    80003ee2:	bfe1                	j	80003eba <pipeclose+0x46>

0000000080003ee4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ee4:	711d                	addi	sp,sp,-96
    80003ee6:	ec86                	sd	ra,88(sp)
    80003ee8:	e8a2                	sd	s0,80(sp)
    80003eea:	e4a6                	sd	s1,72(sp)
    80003eec:	e0ca                	sd	s2,64(sp)
    80003eee:	fc4e                	sd	s3,56(sp)
    80003ef0:	f852                	sd	s4,48(sp)
    80003ef2:	f456                	sd	s5,40(sp)
    80003ef4:	f05a                	sd	s6,32(sp)
    80003ef6:	ec5e                	sd	s7,24(sp)
    80003ef8:	e862                	sd	s8,16(sp)
    80003efa:	1080                	addi	s0,sp,96
    80003efc:	84aa                	mv	s1,a0
    80003efe:	8aae                	mv	s5,a1
    80003f00:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	f40080e7          	jalr	-192(ra) # 80000e42 <myproc>
    80003f0a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	462080e7          	jalr	1122(ra) # 80006370 <acquire>
  while(i < n){
    80003f16:	0b405363          	blez	s4,80003fbc <pipewrite+0xd8>
  int i = 0;
    80003f1a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f1c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f1e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f22:	21c48b93          	addi	s7,s1,540
    80003f26:	a089                	j	80003f68 <pipewrite+0x84>
      release(&pi->lock);
    80003f28:	8526                	mv	a0,s1
    80003f2a:	00002097          	auipc	ra,0x2
    80003f2e:	4fa080e7          	jalr	1274(ra) # 80006424 <release>
      return -1;
    80003f32:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f34:	854a                	mv	a0,s2
    80003f36:	60e6                	ld	ra,88(sp)
    80003f38:	6446                	ld	s0,80(sp)
    80003f3a:	64a6                	ld	s1,72(sp)
    80003f3c:	6906                	ld	s2,64(sp)
    80003f3e:	79e2                	ld	s3,56(sp)
    80003f40:	7a42                	ld	s4,48(sp)
    80003f42:	7aa2                	ld	s5,40(sp)
    80003f44:	7b02                	ld	s6,32(sp)
    80003f46:	6be2                	ld	s7,24(sp)
    80003f48:	6c42                	ld	s8,16(sp)
    80003f4a:	6125                	addi	sp,sp,96
    80003f4c:	8082                	ret
      wakeup(&pi->nread);
    80003f4e:	8562                	mv	a0,s8
    80003f50:	ffffd097          	auipc	ra,0xffffd
    80003f54:	73e080e7          	jalr	1854(ra) # 8000168e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f58:	85a6                	mv	a1,s1
    80003f5a:	855e                	mv	a0,s7
    80003f5c:	ffffd097          	auipc	ra,0xffffd
    80003f60:	5a6080e7          	jalr	1446(ra) # 80001502 <sleep>
  while(i < n){
    80003f64:	05495d63          	bge	s2,s4,80003fbe <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f68:	2204a783          	lw	a5,544(s1)
    80003f6c:	dfd5                	beqz	a5,80003f28 <pipewrite+0x44>
    80003f6e:	0289a783          	lw	a5,40(s3)
    80003f72:	fbdd                	bnez	a5,80003f28 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f74:	2184a783          	lw	a5,536(s1)
    80003f78:	21c4a703          	lw	a4,540(s1)
    80003f7c:	2007879b          	addiw	a5,a5,512
    80003f80:	fcf707e3          	beq	a4,a5,80003f4e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f84:	4685                	li	a3,1
    80003f86:	01590633          	add	a2,s2,s5
    80003f8a:	faf40593          	addi	a1,s0,-81
    80003f8e:	0509b503          	ld	a0,80(s3)
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	bfc080e7          	jalr	-1028(ra) # 80000b8e <copyin>
    80003f9a:	03650263          	beq	a0,s6,80003fbe <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f9e:	21c4a783          	lw	a5,540(s1)
    80003fa2:	0017871b          	addiw	a4,a5,1
    80003fa6:	20e4ae23          	sw	a4,540(s1)
    80003faa:	1ff7f793          	andi	a5,a5,511
    80003fae:	97a6                	add	a5,a5,s1
    80003fb0:	faf44703          	lbu	a4,-81(s0)
    80003fb4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fb8:	2905                	addiw	s2,s2,1
    80003fba:	b76d                	j	80003f64 <pipewrite+0x80>
  int i = 0;
    80003fbc:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fbe:	21848513          	addi	a0,s1,536
    80003fc2:	ffffd097          	auipc	ra,0xffffd
    80003fc6:	6cc080e7          	jalr	1740(ra) # 8000168e <wakeup>
  release(&pi->lock);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	00002097          	auipc	ra,0x2
    80003fd0:	458080e7          	jalr	1112(ra) # 80006424 <release>
  return i;
    80003fd4:	b785                	j	80003f34 <pipewrite+0x50>

0000000080003fd6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fd6:	715d                	addi	sp,sp,-80
    80003fd8:	e486                	sd	ra,72(sp)
    80003fda:	e0a2                	sd	s0,64(sp)
    80003fdc:	fc26                	sd	s1,56(sp)
    80003fde:	f84a                	sd	s2,48(sp)
    80003fe0:	f44e                	sd	s3,40(sp)
    80003fe2:	f052                	sd	s4,32(sp)
    80003fe4:	ec56                	sd	s5,24(sp)
    80003fe6:	e85a                	sd	s6,16(sp)
    80003fe8:	0880                	addi	s0,sp,80
    80003fea:	84aa                	mv	s1,a0
    80003fec:	892e                	mv	s2,a1
    80003fee:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	e52080e7          	jalr	-430(ra) # 80000e42 <myproc>
    80003ff8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00002097          	auipc	ra,0x2
    80004000:	374080e7          	jalr	884(ra) # 80006370 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004004:	2184a703          	lw	a4,536(s1)
    80004008:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000400c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004010:	02f71463          	bne	a4,a5,80004038 <piperead+0x62>
    80004014:	2244a783          	lw	a5,548(s1)
    80004018:	c385                	beqz	a5,80004038 <piperead+0x62>
    if(pr->killed){
    8000401a:	028a2783          	lw	a5,40(s4)
    8000401e:	ebc1                	bnez	a5,800040ae <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004020:	85a6                	mv	a1,s1
    80004022:	854e                	mv	a0,s3
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	4de080e7          	jalr	1246(ra) # 80001502 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402c:	2184a703          	lw	a4,536(s1)
    80004030:	21c4a783          	lw	a5,540(s1)
    80004034:	fef700e3          	beq	a4,a5,80004014 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004038:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000403c:	05505363          	blez	s5,80004082 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004040:	2184a783          	lw	a5,536(s1)
    80004044:	21c4a703          	lw	a4,540(s1)
    80004048:	02f70d63          	beq	a4,a5,80004082 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000404c:	0017871b          	addiw	a4,a5,1
    80004050:	20e4ac23          	sw	a4,536(s1)
    80004054:	1ff7f793          	andi	a5,a5,511
    80004058:	97a6                	add	a5,a5,s1
    8000405a:	0187c783          	lbu	a5,24(a5)
    8000405e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004062:	4685                	li	a3,1
    80004064:	fbf40613          	addi	a2,s0,-65
    80004068:	85ca                	mv	a1,s2
    8000406a:	050a3503          	ld	a0,80(s4)
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	a94080e7          	jalr	-1388(ra) # 80000b02 <copyout>
    80004076:	01650663          	beq	a0,s6,80004082 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000407a:	2985                	addiw	s3,s3,1
    8000407c:	0905                	addi	s2,s2,1
    8000407e:	fd3a91e3          	bne	s5,s3,80004040 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004082:	21c48513          	addi	a0,s1,540
    80004086:	ffffd097          	auipc	ra,0xffffd
    8000408a:	608080e7          	jalr	1544(ra) # 8000168e <wakeup>
  release(&pi->lock);
    8000408e:	8526                	mv	a0,s1
    80004090:	00002097          	auipc	ra,0x2
    80004094:	394080e7          	jalr	916(ra) # 80006424 <release>
  return i;
}
    80004098:	854e                	mv	a0,s3
    8000409a:	60a6                	ld	ra,72(sp)
    8000409c:	6406                	ld	s0,64(sp)
    8000409e:	74e2                	ld	s1,56(sp)
    800040a0:	7942                	ld	s2,48(sp)
    800040a2:	79a2                	ld	s3,40(sp)
    800040a4:	7a02                	ld	s4,32(sp)
    800040a6:	6ae2                	ld	s5,24(sp)
    800040a8:	6b42                	ld	s6,16(sp)
    800040aa:	6161                	addi	sp,sp,80
    800040ac:	8082                	ret
      release(&pi->lock);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	374080e7          	jalr	884(ra) # 80006424 <release>
      return -1;
    800040b8:	59fd                	li	s3,-1
    800040ba:	bff9                	j	80004098 <piperead+0xc2>

00000000800040bc <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040bc:	de010113          	addi	sp,sp,-544
    800040c0:	20113c23          	sd	ra,536(sp)
    800040c4:	20813823          	sd	s0,528(sp)
    800040c8:	20913423          	sd	s1,520(sp)
    800040cc:	21213023          	sd	s2,512(sp)
    800040d0:	ffce                	sd	s3,504(sp)
    800040d2:	fbd2                	sd	s4,496(sp)
    800040d4:	f7d6                	sd	s5,488(sp)
    800040d6:	f3da                	sd	s6,480(sp)
    800040d8:	efde                	sd	s7,472(sp)
    800040da:	ebe2                	sd	s8,464(sp)
    800040dc:	e7e6                	sd	s9,456(sp)
    800040de:	e3ea                	sd	s10,448(sp)
    800040e0:	ff6e                	sd	s11,440(sp)
    800040e2:	1400                	addi	s0,sp,544
    800040e4:	892a                	mv	s2,a0
    800040e6:	dea43423          	sd	a0,-536(s0)
    800040ea:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	d54080e7          	jalr	-684(ra) # 80000e42 <myproc>
    800040f6:	84aa                	mv	s1,a0

  begin_op();
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	4a6080e7          	jalr	1190(ra) # 8000359e <begin_op>

  if((ip = namei(path)) == 0){
    80004100:	854a                	mv	a0,s2
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	280080e7          	jalr	640(ra) # 80003382 <namei>
    8000410a:	c93d                	beqz	a0,80004180 <exec+0xc4>
    8000410c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	a16080e7          	jalr	-1514(ra) # 80002b24 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004116:	04000713          	li	a4,64
    8000411a:	4681                	li	a3,0
    8000411c:	e5040613          	addi	a2,s0,-432
    80004120:	4581                	li	a1,0
    80004122:	8556                	mv	a0,s5
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	d5a080e7          	jalr	-678(ra) # 80002e7e <readi>
    8000412c:	04000793          	li	a5,64
    80004130:	00f51a63          	bne	a0,a5,80004144 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004134:	e5042703          	lw	a4,-432(s0)
    80004138:	464c47b7          	lui	a5,0x464c4
    8000413c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004140:	04f70663          	beq	a4,a5,8000418c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004144:	8556                	mv	a0,s5
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	ce6080e7          	jalr	-794(ra) # 80002e2c <iunlockput>
    end_op();
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	4d0080e7          	jalr	1232(ra) # 8000361e <end_op>
  }
  return -1;
    80004156:	557d                	li	a0,-1
}
    80004158:	21813083          	ld	ra,536(sp)
    8000415c:	21013403          	ld	s0,528(sp)
    80004160:	20813483          	ld	s1,520(sp)
    80004164:	20013903          	ld	s2,512(sp)
    80004168:	79fe                	ld	s3,504(sp)
    8000416a:	7a5e                	ld	s4,496(sp)
    8000416c:	7abe                	ld	s5,488(sp)
    8000416e:	7b1e                	ld	s6,480(sp)
    80004170:	6bfe                	ld	s7,472(sp)
    80004172:	6c5e                	ld	s8,464(sp)
    80004174:	6cbe                	ld	s9,456(sp)
    80004176:	6d1e                	ld	s10,448(sp)
    80004178:	7dfa                	ld	s11,440(sp)
    8000417a:	22010113          	addi	sp,sp,544
    8000417e:	8082                	ret
    end_op();
    80004180:	fffff097          	auipc	ra,0xfffff
    80004184:	49e080e7          	jalr	1182(ra) # 8000361e <end_op>
    return -1;
    80004188:	557d                	li	a0,-1
    8000418a:	b7f9                	j	80004158 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000418c:	8526                	mv	a0,s1
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	d78080e7          	jalr	-648(ra) # 80000f06 <proc_pagetable>
    80004196:	8b2a                	mv	s6,a0
    80004198:	d555                	beqz	a0,80004144 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000419a:	e7042783          	lw	a5,-400(s0)
    8000419e:	e8845703          	lhu	a4,-376(s0)
    800041a2:	c735                	beqz	a4,8000420e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a4:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a6:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041aa:	6a05                	lui	s4,0x1
    800041ac:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041b0:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041b4:	6d85                	lui	s11,0x1
    800041b6:	7d7d                	lui	s10,0xfffff
    800041b8:	ac1d                	j	800043ee <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041ba:	00004517          	auipc	a0,0x4
    800041be:	49650513          	addi	a0,a0,1174 # 80008650 <syscalls+0x288>
    800041c2:	00002097          	auipc	ra,0x2
    800041c6:	c72080e7          	jalr	-910(ra) # 80005e34 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ca:	874a                	mv	a4,s2
    800041cc:	009c86bb          	addw	a3,s9,s1
    800041d0:	4581                	li	a1,0
    800041d2:	8556                	mv	a0,s5
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	caa080e7          	jalr	-854(ra) # 80002e7e <readi>
    800041dc:	2501                	sext.w	a0,a0
    800041de:	1aa91863          	bne	s2,a0,8000438e <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041e2:	009d84bb          	addw	s1,s11,s1
    800041e6:	013d09bb          	addw	s3,s10,s3
    800041ea:	1f74f263          	bgeu	s1,s7,800043ce <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041ee:	02049593          	slli	a1,s1,0x20
    800041f2:	9181                	srli	a1,a1,0x20
    800041f4:	95e2                	add	a1,a1,s8
    800041f6:	855a                	mv	a0,s6
    800041f8:	ffffc097          	auipc	ra,0xffffc
    800041fc:	306080e7          	jalr	774(ra) # 800004fe <walkaddr>
    80004200:	862a                	mv	a2,a0
    if(pa == 0)
    80004202:	dd45                	beqz	a0,800041ba <exec+0xfe>
      n = PGSIZE;
    80004204:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004206:	fd49f2e3          	bgeu	s3,s4,800041ca <exec+0x10e>
      n = sz - i;
    8000420a:	894e                	mv	s2,s3
    8000420c:	bf7d                	j	800041ca <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000420e:	4481                	li	s1,0
  iunlockput(ip);
    80004210:	8556                	mv	a0,s5
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	c1a080e7          	jalr	-998(ra) # 80002e2c <iunlockput>
  end_op();
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	404080e7          	jalr	1028(ra) # 8000361e <end_op>
  p = myproc();
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	c20080e7          	jalr	-992(ra) # 80000e42 <myproc>
    8000422a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000422c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004230:	6785                	lui	a5,0x1
    80004232:	17fd                	addi	a5,a5,-1
    80004234:	94be                	add	s1,s1,a5
    80004236:	77fd                	lui	a5,0xfffff
    80004238:	8fe5                	and	a5,a5,s1
    8000423a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000423e:	6609                	lui	a2,0x2
    80004240:	963e                	add	a2,a2,a5
    80004242:	85be                	mv	a1,a5
    80004244:	855a                	mv	a0,s6
    80004246:	ffffc097          	auipc	ra,0xffffc
    8000424a:	66c080e7          	jalr	1644(ra) # 800008b2 <uvmalloc>
    8000424e:	8c2a                	mv	s8,a0
  ip = 0;
    80004250:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004252:	12050e63          	beqz	a0,8000438e <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004256:	75f9                	lui	a1,0xffffe
    80004258:	95aa                	add	a1,a1,a0
    8000425a:	855a                	mv	a0,s6
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	874080e7          	jalr	-1932(ra) # 80000ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004264:	7afd                	lui	s5,0xfffff
    80004266:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004268:	df043783          	ld	a5,-528(s0)
    8000426c:	6388                	ld	a0,0(a5)
    8000426e:	c925                	beqz	a0,800042de <exec+0x222>
    80004270:	e9040993          	addi	s3,s0,-368
    80004274:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004278:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000427a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000427c:	ffffc097          	auipc	ra,0xffffc
    80004280:	078080e7          	jalr	120(ra) # 800002f4 <strlen>
    80004284:	0015079b          	addiw	a5,a0,1
    80004288:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000428c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004290:	13596363          	bltu	s2,s5,800043b6 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004294:	df043d83          	ld	s11,-528(s0)
    80004298:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000429c:	8552                	mv	a0,s4
    8000429e:	ffffc097          	auipc	ra,0xffffc
    800042a2:	056080e7          	jalr	86(ra) # 800002f4 <strlen>
    800042a6:	0015069b          	addiw	a3,a0,1
    800042aa:	8652                	mv	a2,s4
    800042ac:	85ca                	mv	a1,s2
    800042ae:	855a                	mv	a0,s6
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	852080e7          	jalr	-1966(ra) # 80000b02 <copyout>
    800042b8:	10054363          	bltz	a0,800043be <exec+0x302>
    ustack[argc] = sp;
    800042bc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042c0:	0485                	addi	s1,s1,1
    800042c2:	008d8793          	addi	a5,s11,8
    800042c6:	def43823          	sd	a5,-528(s0)
    800042ca:	008db503          	ld	a0,8(s11)
    800042ce:	c911                	beqz	a0,800042e2 <exec+0x226>
    if(argc >= MAXARG)
    800042d0:	09a1                	addi	s3,s3,8
    800042d2:	fb3c95e3          	bne	s9,s3,8000427c <exec+0x1c0>
  sz = sz1;
    800042d6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042da:	4a81                	li	s5,0
    800042dc:	a84d                	j	8000438e <exec+0x2d2>
  sp = sz;
    800042de:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042e0:	4481                	li	s1,0
  ustack[argc] = 0;
    800042e2:	00349793          	slli	a5,s1,0x3
    800042e6:	f9040713          	addi	a4,s0,-112
    800042ea:	97ba                	add	a5,a5,a4
    800042ec:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffddcc0>
  sp -= (argc+1) * sizeof(uint64);
    800042f0:	00148693          	addi	a3,s1,1
    800042f4:	068e                	slli	a3,a3,0x3
    800042f6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042fa:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042fe:	01597663          	bgeu	s2,s5,8000430a <exec+0x24e>
  sz = sz1;
    80004302:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004306:	4a81                	li	s5,0
    80004308:	a059                	j	8000438e <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000430a:	e9040613          	addi	a2,s0,-368
    8000430e:	85ca                	mv	a1,s2
    80004310:	855a                	mv	a0,s6
    80004312:	ffffc097          	auipc	ra,0xffffc
    80004316:	7f0080e7          	jalr	2032(ra) # 80000b02 <copyout>
    8000431a:	0a054663          	bltz	a0,800043c6 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000431e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004322:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004326:	de843783          	ld	a5,-536(s0)
    8000432a:	0007c703          	lbu	a4,0(a5)
    8000432e:	cf11                	beqz	a4,8000434a <exec+0x28e>
    80004330:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004332:	02f00693          	li	a3,47
    80004336:	a039                	j	80004344 <exec+0x288>
      last = s+1;
    80004338:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000433c:	0785                	addi	a5,a5,1
    8000433e:	fff7c703          	lbu	a4,-1(a5)
    80004342:	c701                	beqz	a4,8000434a <exec+0x28e>
    if(*s == '/')
    80004344:	fed71ce3          	bne	a4,a3,8000433c <exec+0x280>
    80004348:	bfc5                	j	80004338 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000434a:	4641                	li	a2,16
    8000434c:	de843583          	ld	a1,-536(s0)
    80004350:	158b8513          	addi	a0,s7,344
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	f6e080e7          	jalr	-146(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000435c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004360:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004364:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004368:	058bb783          	ld	a5,88(s7)
    8000436c:	e6843703          	ld	a4,-408(s0)
    80004370:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004372:	058bb783          	ld	a5,88(s7)
    80004376:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000437a:	85ea                	mv	a1,s10
    8000437c:	ffffd097          	auipc	ra,0xffffd
    80004380:	c26080e7          	jalr	-986(ra) # 80000fa2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004384:	0004851b          	sext.w	a0,s1
    80004388:	bbc1                	j	80004158 <exec+0x9c>
    8000438a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000438e:	df843583          	ld	a1,-520(s0)
    80004392:	855a                	mv	a0,s6
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	c0e080e7          	jalr	-1010(ra) # 80000fa2 <proc_freepagetable>
  if(ip){
    8000439c:	da0a94e3          	bnez	s5,80004144 <exec+0x88>
  return -1;
    800043a0:	557d                	li	a0,-1
    800043a2:	bb5d                	j	80004158 <exec+0x9c>
    800043a4:	de943c23          	sd	s1,-520(s0)
    800043a8:	b7dd                	j	8000438e <exec+0x2d2>
    800043aa:	de943c23          	sd	s1,-520(s0)
    800043ae:	b7c5                	j	8000438e <exec+0x2d2>
    800043b0:	de943c23          	sd	s1,-520(s0)
    800043b4:	bfe9                	j	8000438e <exec+0x2d2>
  sz = sz1;
    800043b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ba:	4a81                	li	s5,0
    800043bc:	bfc9                	j	8000438e <exec+0x2d2>
  sz = sz1;
    800043be:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c2:	4a81                	li	s5,0
    800043c4:	b7e9                	j	8000438e <exec+0x2d2>
  sz = sz1;
    800043c6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ca:	4a81                	li	s5,0
    800043cc:	b7c9                	j	8000438e <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043ce:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d2:	e0843783          	ld	a5,-504(s0)
    800043d6:	0017869b          	addiw	a3,a5,1
    800043da:	e0d43423          	sd	a3,-504(s0)
    800043de:	e0043783          	ld	a5,-512(s0)
    800043e2:	0387879b          	addiw	a5,a5,56
    800043e6:	e8845703          	lhu	a4,-376(s0)
    800043ea:	e2e6d3e3          	bge	a3,a4,80004210 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043ee:	2781                	sext.w	a5,a5
    800043f0:	e0f43023          	sd	a5,-512(s0)
    800043f4:	03800713          	li	a4,56
    800043f8:	86be                	mv	a3,a5
    800043fa:	e1840613          	addi	a2,s0,-488
    800043fe:	4581                	li	a1,0
    80004400:	8556                	mv	a0,s5
    80004402:	fffff097          	auipc	ra,0xfffff
    80004406:	a7c080e7          	jalr	-1412(ra) # 80002e7e <readi>
    8000440a:	03800793          	li	a5,56
    8000440e:	f6f51ee3          	bne	a0,a5,8000438a <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004412:	e1842783          	lw	a5,-488(s0)
    80004416:	4705                	li	a4,1
    80004418:	fae79de3          	bne	a5,a4,800043d2 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000441c:	e4043603          	ld	a2,-448(s0)
    80004420:	e3843783          	ld	a5,-456(s0)
    80004424:	f8f660e3          	bltu	a2,a5,800043a4 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004428:	e2843783          	ld	a5,-472(s0)
    8000442c:	963e                	add	a2,a2,a5
    8000442e:	f6f66ee3          	bltu	a2,a5,800043aa <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004432:	85a6                	mv	a1,s1
    80004434:	855a                	mv	a0,s6
    80004436:	ffffc097          	auipc	ra,0xffffc
    8000443a:	47c080e7          	jalr	1148(ra) # 800008b2 <uvmalloc>
    8000443e:	dea43c23          	sd	a0,-520(s0)
    80004442:	d53d                	beqz	a0,800043b0 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004444:	e2843c03          	ld	s8,-472(s0)
    80004448:	de043783          	ld	a5,-544(s0)
    8000444c:	00fc77b3          	and	a5,s8,a5
    80004450:	ff9d                	bnez	a5,8000438e <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004452:	e2042c83          	lw	s9,-480(s0)
    80004456:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000445a:	f60b8ae3          	beqz	s7,800043ce <exec+0x312>
    8000445e:	89de                	mv	s3,s7
    80004460:	4481                	li	s1,0
    80004462:	b371                	j	800041ee <exec+0x132>

0000000080004464 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004464:	7179                	addi	sp,sp,-48
    80004466:	f406                	sd	ra,40(sp)
    80004468:	f022                	sd	s0,32(sp)
    8000446a:	ec26                	sd	s1,24(sp)
    8000446c:	e84a                	sd	s2,16(sp)
    8000446e:	1800                	addi	s0,sp,48
    80004470:	892e                	mv	s2,a1
    80004472:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004474:	fdc40593          	addi	a1,s0,-36
    80004478:	ffffe097          	auipc	ra,0xffffe
    8000447c:	a7a080e7          	jalr	-1414(ra) # 80001ef2 <argint>
    80004480:	04054063          	bltz	a0,800044c0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004484:	fdc42703          	lw	a4,-36(s0)
    80004488:	47bd                	li	a5,15
    8000448a:	02e7ed63          	bltu	a5,a4,800044c4 <argfd+0x60>
    8000448e:	ffffd097          	auipc	ra,0xffffd
    80004492:	9b4080e7          	jalr	-1612(ra) # 80000e42 <myproc>
    80004496:	fdc42703          	lw	a4,-36(s0)
    8000449a:	01a70793          	addi	a5,a4,26
    8000449e:	078e                	slli	a5,a5,0x3
    800044a0:	953e                	add	a0,a0,a5
    800044a2:	611c                	ld	a5,0(a0)
    800044a4:	c395                	beqz	a5,800044c8 <argfd+0x64>
    return -1;
  if(pfd)
    800044a6:	00090463          	beqz	s2,800044ae <argfd+0x4a>
    *pfd = fd;
    800044aa:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044ae:	4501                	li	a0,0
  if(pf)
    800044b0:	c091                	beqz	s1,800044b4 <argfd+0x50>
    *pf = f;
    800044b2:	e09c                	sd	a5,0(s1)
}
    800044b4:	70a2                	ld	ra,40(sp)
    800044b6:	7402                	ld	s0,32(sp)
    800044b8:	64e2                	ld	s1,24(sp)
    800044ba:	6942                	ld	s2,16(sp)
    800044bc:	6145                	addi	sp,sp,48
    800044be:	8082                	ret
    return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	bfcd                	j	800044b4 <argfd+0x50>
    return -1;
    800044c4:	557d                	li	a0,-1
    800044c6:	b7fd                	j	800044b4 <argfd+0x50>
    800044c8:	557d                	li	a0,-1
    800044ca:	b7ed                	j	800044b4 <argfd+0x50>

00000000800044cc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044cc:	1101                	addi	sp,sp,-32
    800044ce:	ec06                	sd	ra,24(sp)
    800044d0:	e822                	sd	s0,16(sp)
    800044d2:	e426                	sd	s1,8(sp)
    800044d4:	1000                	addi	s0,sp,32
    800044d6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044d8:	ffffd097          	auipc	ra,0xffffd
    800044dc:	96a080e7          	jalr	-1686(ra) # 80000e42 <myproc>
    800044e0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044e2:	0d050793          	addi	a5,a0,208
    800044e6:	4501                	li	a0,0
    800044e8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044ea:	6398                	ld	a4,0(a5)
    800044ec:	cb19                	beqz	a4,80004502 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044ee:	2505                	addiw	a0,a0,1
    800044f0:	07a1                	addi	a5,a5,8
    800044f2:	fed51ce3          	bne	a0,a3,800044ea <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044f6:	557d                	li	a0,-1
}
    800044f8:	60e2                	ld	ra,24(sp)
    800044fa:	6442                	ld	s0,16(sp)
    800044fc:	64a2                	ld	s1,8(sp)
    800044fe:	6105                	addi	sp,sp,32
    80004500:	8082                	ret
      p->ofile[fd] = f;
    80004502:	01a50793          	addi	a5,a0,26
    80004506:	078e                	slli	a5,a5,0x3
    80004508:	963e                	add	a2,a2,a5
    8000450a:	e204                	sd	s1,0(a2)
      return fd;
    8000450c:	b7f5                	j	800044f8 <fdalloc+0x2c>

000000008000450e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000450e:	715d                	addi	sp,sp,-80
    80004510:	e486                	sd	ra,72(sp)
    80004512:	e0a2                	sd	s0,64(sp)
    80004514:	fc26                	sd	s1,56(sp)
    80004516:	f84a                	sd	s2,48(sp)
    80004518:	f44e                	sd	s3,40(sp)
    8000451a:	f052                	sd	s4,32(sp)
    8000451c:	ec56                	sd	s5,24(sp)
    8000451e:	0880                	addi	s0,sp,80
    80004520:	89ae                	mv	s3,a1
    80004522:	8ab2                	mv	s5,a2
    80004524:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004526:	fb040593          	addi	a1,s0,-80
    8000452a:	fffff097          	auipc	ra,0xfffff
    8000452e:	e76080e7          	jalr	-394(ra) # 800033a0 <nameiparent>
    80004532:	892a                	mv	s2,a0
    80004534:	12050e63          	beqz	a0,80004670 <create+0x162>
    return 0;

  ilock(dp);
    80004538:	ffffe097          	auipc	ra,0xffffe
    8000453c:	5ec080e7          	jalr	1516(ra) # 80002b24 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004540:	4601                	li	a2,0
    80004542:	fb040593          	addi	a1,s0,-80
    80004546:	854a                	mv	a0,s2
    80004548:	fffff097          	auipc	ra,0xfffff
    8000454c:	b68080e7          	jalr	-1176(ra) # 800030b0 <dirlookup>
    80004550:	84aa                	mv	s1,a0
    80004552:	c921                	beqz	a0,800045a2 <create+0x94>
    iunlockput(dp);
    80004554:	854a                	mv	a0,s2
    80004556:	fffff097          	auipc	ra,0xfffff
    8000455a:	8d6080e7          	jalr	-1834(ra) # 80002e2c <iunlockput>
    ilock(ip);
    8000455e:	8526                	mv	a0,s1
    80004560:	ffffe097          	auipc	ra,0xffffe
    80004564:	5c4080e7          	jalr	1476(ra) # 80002b24 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004568:	2981                	sext.w	s3,s3
    8000456a:	4789                	li	a5,2
    8000456c:	02f99463          	bne	s3,a5,80004594 <create+0x86>
    80004570:	0444d783          	lhu	a5,68(s1)
    80004574:	37f9                	addiw	a5,a5,-2
    80004576:	17c2                	slli	a5,a5,0x30
    80004578:	93c1                	srli	a5,a5,0x30
    8000457a:	4705                	li	a4,1
    8000457c:	00f76c63          	bltu	a4,a5,80004594 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004580:	8526                	mv	a0,s1
    80004582:	60a6                	ld	ra,72(sp)
    80004584:	6406                	ld	s0,64(sp)
    80004586:	74e2                	ld	s1,56(sp)
    80004588:	7942                	ld	s2,48(sp)
    8000458a:	79a2                	ld	s3,40(sp)
    8000458c:	7a02                	ld	s4,32(sp)
    8000458e:	6ae2                	ld	s5,24(sp)
    80004590:	6161                	addi	sp,sp,80
    80004592:	8082                	ret
    iunlockput(ip);
    80004594:	8526                	mv	a0,s1
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	896080e7          	jalr	-1898(ra) # 80002e2c <iunlockput>
    return 0;
    8000459e:	4481                	li	s1,0
    800045a0:	b7c5                	j	80004580 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045a2:	85ce                	mv	a1,s3
    800045a4:	00092503          	lw	a0,0(s2)
    800045a8:	ffffe097          	auipc	ra,0xffffe
    800045ac:	3e4080e7          	jalr	996(ra) # 8000298c <ialloc>
    800045b0:	84aa                	mv	s1,a0
    800045b2:	c521                	beqz	a0,800045fa <create+0xec>
  ilock(ip);
    800045b4:	ffffe097          	auipc	ra,0xffffe
    800045b8:	570080e7          	jalr	1392(ra) # 80002b24 <ilock>
  ip->major = major;
    800045bc:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045c0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045c4:	4a05                	li	s4,1
    800045c6:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045ca:	8526                	mv	a0,s1
    800045cc:	ffffe097          	auipc	ra,0xffffe
    800045d0:	48e080e7          	jalr	1166(ra) # 80002a5a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045d4:	2981                	sext.w	s3,s3
    800045d6:	03498a63          	beq	s3,s4,8000460a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045da:	40d0                	lw	a2,4(s1)
    800045dc:	fb040593          	addi	a1,s0,-80
    800045e0:	854a                	mv	a0,s2
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	cde080e7          	jalr	-802(ra) # 800032c0 <dirlink>
    800045ea:	06054b63          	bltz	a0,80004660 <create+0x152>
  iunlockput(dp);
    800045ee:	854a                	mv	a0,s2
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	83c080e7          	jalr	-1988(ra) # 80002e2c <iunlockput>
  return ip;
    800045f8:	b761                	j	80004580 <create+0x72>
    panic("create: ialloc");
    800045fa:	00004517          	auipc	a0,0x4
    800045fe:	07650513          	addi	a0,a0,118 # 80008670 <syscalls+0x2a8>
    80004602:	00002097          	auipc	ra,0x2
    80004606:	832080e7          	jalr	-1998(ra) # 80005e34 <panic>
    dp->nlink++;  // for ".."
    8000460a:	04a95783          	lhu	a5,74(s2)
    8000460e:	2785                	addiw	a5,a5,1
    80004610:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004614:	854a                	mv	a0,s2
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	444080e7          	jalr	1092(ra) # 80002a5a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000461e:	40d0                	lw	a2,4(s1)
    80004620:	00004597          	auipc	a1,0x4
    80004624:	06058593          	addi	a1,a1,96 # 80008680 <syscalls+0x2b8>
    80004628:	8526                	mv	a0,s1
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	c96080e7          	jalr	-874(ra) # 800032c0 <dirlink>
    80004632:	00054f63          	bltz	a0,80004650 <create+0x142>
    80004636:	00492603          	lw	a2,4(s2)
    8000463a:	00004597          	auipc	a1,0x4
    8000463e:	04e58593          	addi	a1,a1,78 # 80008688 <syscalls+0x2c0>
    80004642:	8526                	mv	a0,s1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	c7c080e7          	jalr	-900(ra) # 800032c0 <dirlink>
    8000464c:	f80557e3          	bgez	a0,800045da <create+0xcc>
      panic("create dots");
    80004650:	00004517          	auipc	a0,0x4
    80004654:	04050513          	addi	a0,a0,64 # 80008690 <syscalls+0x2c8>
    80004658:	00001097          	auipc	ra,0x1
    8000465c:	7dc080e7          	jalr	2012(ra) # 80005e34 <panic>
    panic("create: dirlink");
    80004660:	00004517          	auipc	a0,0x4
    80004664:	04050513          	addi	a0,a0,64 # 800086a0 <syscalls+0x2d8>
    80004668:	00001097          	auipc	ra,0x1
    8000466c:	7cc080e7          	jalr	1996(ra) # 80005e34 <panic>
    return 0;
    80004670:	84aa                	mv	s1,a0
    80004672:	b739                	j	80004580 <create+0x72>

0000000080004674 <sys_dup>:
{
    80004674:	7179                	addi	sp,sp,-48
    80004676:	f406                	sd	ra,40(sp)
    80004678:	f022                	sd	s0,32(sp)
    8000467a:	ec26                	sd	s1,24(sp)
    8000467c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000467e:	fd840613          	addi	a2,s0,-40
    80004682:	4581                	li	a1,0
    80004684:	4501                	li	a0,0
    80004686:	00000097          	auipc	ra,0x0
    8000468a:	dde080e7          	jalr	-546(ra) # 80004464 <argfd>
    return -1;
    8000468e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004690:	02054363          	bltz	a0,800046b6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004694:	fd843503          	ld	a0,-40(s0)
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	e34080e7          	jalr	-460(ra) # 800044cc <fdalloc>
    800046a0:	84aa                	mv	s1,a0
    return -1;
    800046a2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046a4:	00054963          	bltz	a0,800046b6 <sys_dup+0x42>
  filedup(f);
    800046a8:	fd843503          	ld	a0,-40(s0)
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	36c080e7          	jalr	876(ra) # 80003a18 <filedup>
  return fd;
    800046b4:	87a6                	mv	a5,s1
}
    800046b6:	853e                	mv	a0,a5
    800046b8:	70a2                	ld	ra,40(sp)
    800046ba:	7402                	ld	s0,32(sp)
    800046bc:	64e2                	ld	s1,24(sp)
    800046be:	6145                	addi	sp,sp,48
    800046c0:	8082                	ret

00000000800046c2 <sys_read>:
{
    800046c2:	7179                	addi	sp,sp,-48
    800046c4:	f406                	sd	ra,40(sp)
    800046c6:	f022                	sd	s0,32(sp)
    800046c8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ca:	fe840613          	addi	a2,s0,-24
    800046ce:	4581                	li	a1,0
    800046d0:	4501                	li	a0,0
    800046d2:	00000097          	auipc	ra,0x0
    800046d6:	d92080e7          	jalr	-622(ra) # 80004464 <argfd>
    return -1;
    800046da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046dc:	04054163          	bltz	a0,8000471e <sys_read+0x5c>
    800046e0:	fe440593          	addi	a1,s0,-28
    800046e4:	4509                	li	a0,2
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	80c080e7          	jalr	-2036(ra) # 80001ef2 <argint>
    return -1;
    800046ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f0:	02054763          	bltz	a0,8000471e <sys_read+0x5c>
    800046f4:	fd840593          	addi	a1,s0,-40
    800046f8:	4505                	li	a0,1
    800046fa:	ffffe097          	auipc	ra,0xffffe
    800046fe:	81a080e7          	jalr	-2022(ra) # 80001f14 <argaddr>
    return -1;
    80004702:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004704:	00054d63          	bltz	a0,8000471e <sys_read+0x5c>
  return fileread(f, p, n);
    80004708:	fe442603          	lw	a2,-28(s0)
    8000470c:	fd843583          	ld	a1,-40(s0)
    80004710:	fe843503          	ld	a0,-24(s0)
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	490080e7          	jalr	1168(ra) # 80003ba4 <fileread>
    8000471c:	87aa                	mv	a5,a0
}
    8000471e:	853e                	mv	a0,a5
    80004720:	70a2                	ld	ra,40(sp)
    80004722:	7402                	ld	s0,32(sp)
    80004724:	6145                	addi	sp,sp,48
    80004726:	8082                	ret

0000000080004728 <sys_write>:
{
    80004728:	7179                	addi	sp,sp,-48
    8000472a:	f406                	sd	ra,40(sp)
    8000472c:	f022                	sd	s0,32(sp)
    8000472e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004730:	fe840613          	addi	a2,s0,-24
    80004734:	4581                	li	a1,0
    80004736:	4501                	li	a0,0
    80004738:	00000097          	auipc	ra,0x0
    8000473c:	d2c080e7          	jalr	-724(ra) # 80004464 <argfd>
    return -1;
    80004740:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004742:	04054163          	bltz	a0,80004784 <sys_write+0x5c>
    80004746:	fe440593          	addi	a1,s0,-28
    8000474a:	4509                	li	a0,2
    8000474c:	ffffd097          	auipc	ra,0xffffd
    80004750:	7a6080e7          	jalr	1958(ra) # 80001ef2 <argint>
    return -1;
    80004754:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004756:	02054763          	bltz	a0,80004784 <sys_write+0x5c>
    8000475a:	fd840593          	addi	a1,s0,-40
    8000475e:	4505                	li	a0,1
    80004760:	ffffd097          	auipc	ra,0xffffd
    80004764:	7b4080e7          	jalr	1972(ra) # 80001f14 <argaddr>
    return -1;
    80004768:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476a:	00054d63          	bltz	a0,80004784 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000476e:	fe442603          	lw	a2,-28(s0)
    80004772:	fd843583          	ld	a1,-40(s0)
    80004776:	fe843503          	ld	a0,-24(s0)
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	4ec080e7          	jalr	1260(ra) # 80003c66 <filewrite>
    80004782:	87aa                	mv	a5,a0
}
    80004784:	853e                	mv	a0,a5
    80004786:	70a2                	ld	ra,40(sp)
    80004788:	7402                	ld	s0,32(sp)
    8000478a:	6145                	addi	sp,sp,48
    8000478c:	8082                	ret

000000008000478e <sys_close>:
{
    8000478e:	1101                	addi	sp,sp,-32
    80004790:	ec06                	sd	ra,24(sp)
    80004792:	e822                	sd	s0,16(sp)
    80004794:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004796:	fe040613          	addi	a2,s0,-32
    8000479a:	fec40593          	addi	a1,s0,-20
    8000479e:	4501                	li	a0,0
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	cc4080e7          	jalr	-828(ra) # 80004464 <argfd>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047aa:	02054463          	bltz	a0,800047d2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	694080e7          	jalr	1684(ra) # 80000e42 <myproc>
    800047b6:	fec42783          	lw	a5,-20(s0)
    800047ba:	07e9                	addi	a5,a5,26
    800047bc:	078e                	slli	a5,a5,0x3
    800047be:	97aa                	add	a5,a5,a0
    800047c0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047c4:	fe043503          	ld	a0,-32(s0)
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	2a2080e7          	jalr	674(ra) # 80003a6a <fileclose>
  return 0;
    800047d0:	4781                	li	a5,0
}
    800047d2:	853e                	mv	a0,a5
    800047d4:	60e2                	ld	ra,24(sp)
    800047d6:	6442                	ld	s0,16(sp)
    800047d8:	6105                	addi	sp,sp,32
    800047da:	8082                	ret

00000000800047dc <sys_fstat>:
{
    800047dc:	1101                	addi	sp,sp,-32
    800047de:	ec06                	sd	ra,24(sp)
    800047e0:	e822                	sd	s0,16(sp)
    800047e2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047e4:	fe840613          	addi	a2,s0,-24
    800047e8:	4581                	li	a1,0
    800047ea:	4501                	li	a0,0
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	c78080e7          	jalr	-904(ra) # 80004464 <argfd>
    return -1;
    800047f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f6:	02054563          	bltz	a0,80004820 <sys_fstat+0x44>
    800047fa:	fe040593          	addi	a1,s0,-32
    800047fe:	4505                	li	a0,1
    80004800:	ffffd097          	auipc	ra,0xffffd
    80004804:	714080e7          	jalr	1812(ra) # 80001f14 <argaddr>
    return -1;
    80004808:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480a:	00054b63          	bltz	a0,80004820 <sys_fstat+0x44>
  return filestat(f, st);
    8000480e:	fe043583          	ld	a1,-32(s0)
    80004812:	fe843503          	ld	a0,-24(s0)
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	31c080e7          	jalr	796(ra) # 80003b32 <filestat>
    8000481e:	87aa                	mv	a5,a0
}
    80004820:	853e                	mv	a0,a5
    80004822:	60e2                	ld	ra,24(sp)
    80004824:	6442                	ld	s0,16(sp)
    80004826:	6105                	addi	sp,sp,32
    80004828:	8082                	ret

000000008000482a <sys_link>:
{
    8000482a:	7169                	addi	sp,sp,-304
    8000482c:	f606                	sd	ra,296(sp)
    8000482e:	f222                	sd	s0,288(sp)
    80004830:	ee26                	sd	s1,280(sp)
    80004832:	ea4a                	sd	s2,272(sp)
    80004834:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004836:	08000613          	li	a2,128
    8000483a:	ed040593          	addi	a1,s0,-304
    8000483e:	4501                	li	a0,0
    80004840:	ffffd097          	auipc	ra,0xffffd
    80004844:	6f6080e7          	jalr	1782(ra) # 80001f36 <argstr>
    return -1;
    80004848:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484a:	10054e63          	bltz	a0,80004966 <sys_link+0x13c>
    8000484e:	08000613          	li	a2,128
    80004852:	f5040593          	addi	a1,s0,-176
    80004856:	4505                	li	a0,1
    80004858:	ffffd097          	auipc	ra,0xffffd
    8000485c:	6de080e7          	jalr	1758(ra) # 80001f36 <argstr>
    return -1;
    80004860:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004862:	10054263          	bltz	a0,80004966 <sys_link+0x13c>
  begin_op();
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	d38080e7          	jalr	-712(ra) # 8000359e <begin_op>
  if((ip = namei(old)) == 0){
    8000486e:	ed040513          	addi	a0,s0,-304
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	b10080e7          	jalr	-1264(ra) # 80003382 <namei>
    8000487a:	84aa                	mv	s1,a0
    8000487c:	c551                	beqz	a0,80004908 <sys_link+0xde>
  ilock(ip);
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	2a6080e7          	jalr	678(ra) # 80002b24 <ilock>
  if(ip->type == T_DIR){
    80004886:	04449703          	lh	a4,68(s1)
    8000488a:	4785                	li	a5,1
    8000488c:	08f70463          	beq	a4,a5,80004914 <sys_link+0xea>
  ip->nlink++;
    80004890:	04a4d783          	lhu	a5,74(s1)
    80004894:	2785                	addiw	a5,a5,1
    80004896:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	1be080e7          	jalr	446(ra) # 80002a5a <iupdate>
  iunlock(ip);
    800048a4:	8526                	mv	a0,s1
    800048a6:	ffffe097          	auipc	ra,0xffffe
    800048aa:	340080e7          	jalr	832(ra) # 80002be6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048ae:	fd040593          	addi	a1,s0,-48
    800048b2:	f5040513          	addi	a0,s0,-176
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	aea080e7          	jalr	-1302(ra) # 800033a0 <nameiparent>
    800048be:	892a                	mv	s2,a0
    800048c0:	c935                	beqz	a0,80004934 <sys_link+0x10a>
  ilock(dp);
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	262080e7          	jalr	610(ra) # 80002b24 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048ca:	00092703          	lw	a4,0(s2)
    800048ce:	409c                	lw	a5,0(s1)
    800048d0:	04f71d63          	bne	a4,a5,8000492a <sys_link+0x100>
    800048d4:	40d0                	lw	a2,4(s1)
    800048d6:	fd040593          	addi	a1,s0,-48
    800048da:	854a                	mv	a0,s2
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	9e4080e7          	jalr	-1564(ra) # 800032c0 <dirlink>
    800048e4:	04054363          	bltz	a0,8000492a <sys_link+0x100>
  iunlockput(dp);
    800048e8:	854a                	mv	a0,s2
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	542080e7          	jalr	1346(ra) # 80002e2c <iunlockput>
  iput(ip);
    800048f2:	8526                	mv	a0,s1
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	490080e7          	jalr	1168(ra) # 80002d84 <iput>
  end_op();
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	d22080e7          	jalr	-734(ra) # 8000361e <end_op>
  return 0;
    80004904:	4781                	li	a5,0
    80004906:	a085                	j	80004966 <sys_link+0x13c>
    end_op();
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	d16080e7          	jalr	-746(ra) # 8000361e <end_op>
    return -1;
    80004910:	57fd                	li	a5,-1
    80004912:	a891                	j	80004966 <sys_link+0x13c>
    iunlockput(ip);
    80004914:	8526                	mv	a0,s1
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	516080e7          	jalr	1302(ra) # 80002e2c <iunlockput>
    end_op();
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	d00080e7          	jalr	-768(ra) # 8000361e <end_op>
    return -1;
    80004926:	57fd                	li	a5,-1
    80004928:	a83d                	j	80004966 <sys_link+0x13c>
    iunlockput(dp);
    8000492a:	854a                	mv	a0,s2
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	500080e7          	jalr	1280(ra) # 80002e2c <iunlockput>
  ilock(ip);
    80004934:	8526                	mv	a0,s1
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	1ee080e7          	jalr	494(ra) # 80002b24 <ilock>
  ip->nlink--;
    8000493e:	04a4d783          	lhu	a5,74(s1)
    80004942:	37fd                	addiw	a5,a5,-1
    80004944:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	110080e7          	jalr	272(ra) # 80002a5a <iupdate>
  iunlockput(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	4d8080e7          	jalr	1240(ra) # 80002e2c <iunlockput>
  end_op();
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	cc2080e7          	jalr	-830(ra) # 8000361e <end_op>
  return -1;
    80004964:	57fd                	li	a5,-1
}
    80004966:	853e                	mv	a0,a5
    80004968:	70b2                	ld	ra,296(sp)
    8000496a:	7412                	ld	s0,288(sp)
    8000496c:	64f2                	ld	s1,280(sp)
    8000496e:	6952                	ld	s2,272(sp)
    80004970:	6155                	addi	sp,sp,304
    80004972:	8082                	ret

0000000080004974 <sys_unlink>:
{
    80004974:	7151                	addi	sp,sp,-240
    80004976:	f586                	sd	ra,232(sp)
    80004978:	f1a2                	sd	s0,224(sp)
    8000497a:	eda6                	sd	s1,216(sp)
    8000497c:	e9ca                	sd	s2,208(sp)
    8000497e:	e5ce                	sd	s3,200(sp)
    80004980:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004982:	08000613          	li	a2,128
    80004986:	f3040593          	addi	a1,s0,-208
    8000498a:	4501                	li	a0,0
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	5aa080e7          	jalr	1450(ra) # 80001f36 <argstr>
    80004994:	18054163          	bltz	a0,80004b16 <sys_unlink+0x1a2>
  begin_op();
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	c06080e7          	jalr	-1018(ra) # 8000359e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049a0:	fb040593          	addi	a1,s0,-80
    800049a4:	f3040513          	addi	a0,s0,-208
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	9f8080e7          	jalr	-1544(ra) # 800033a0 <nameiparent>
    800049b0:	84aa                	mv	s1,a0
    800049b2:	c979                	beqz	a0,80004a88 <sys_unlink+0x114>
  ilock(dp);
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	170080e7          	jalr	368(ra) # 80002b24 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049bc:	00004597          	auipc	a1,0x4
    800049c0:	cc458593          	addi	a1,a1,-828 # 80008680 <syscalls+0x2b8>
    800049c4:	fb040513          	addi	a0,s0,-80
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	6ce080e7          	jalr	1742(ra) # 80003096 <namecmp>
    800049d0:	14050a63          	beqz	a0,80004b24 <sys_unlink+0x1b0>
    800049d4:	00004597          	auipc	a1,0x4
    800049d8:	cb458593          	addi	a1,a1,-844 # 80008688 <syscalls+0x2c0>
    800049dc:	fb040513          	addi	a0,s0,-80
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	6b6080e7          	jalr	1718(ra) # 80003096 <namecmp>
    800049e8:	12050e63          	beqz	a0,80004b24 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049ec:	f2c40613          	addi	a2,s0,-212
    800049f0:	fb040593          	addi	a1,s0,-80
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	6ba080e7          	jalr	1722(ra) # 800030b0 <dirlookup>
    800049fe:	892a                	mv	s2,a0
    80004a00:	12050263          	beqz	a0,80004b24 <sys_unlink+0x1b0>
  ilock(ip);
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	120080e7          	jalr	288(ra) # 80002b24 <ilock>
  if(ip->nlink < 1)
    80004a0c:	04a91783          	lh	a5,74(s2)
    80004a10:	08f05263          	blez	a5,80004a94 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a14:	04491703          	lh	a4,68(s2)
    80004a18:	4785                	li	a5,1
    80004a1a:	08f70563          	beq	a4,a5,80004aa4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a1e:	4641                	li	a2,16
    80004a20:	4581                	li	a1,0
    80004a22:	fc040513          	addi	a0,s0,-64
    80004a26:	ffffb097          	auipc	ra,0xffffb
    80004a2a:	752080e7          	jalr	1874(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2e:	4741                	li	a4,16
    80004a30:	f2c42683          	lw	a3,-212(s0)
    80004a34:	fc040613          	addi	a2,s0,-64
    80004a38:	4581                	li	a1,0
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	53a080e7          	jalr	1338(ra) # 80002f76 <writei>
    80004a44:	47c1                	li	a5,16
    80004a46:	0af51563          	bne	a0,a5,80004af0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a4a:	04491703          	lh	a4,68(s2)
    80004a4e:	4785                	li	a5,1
    80004a50:	0af70863          	beq	a4,a5,80004b00 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a54:	8526                	mv	a0,s1
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	3d6080e7          	jalr	982(ra) # 80002e2c <iunlockput>
  ip->nlink--;
    80004a5e:	04a95783          	lhu	a5,74(s2)
    80004a62:	37fd                	addiw	a5,a5,-1
    80004a64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	ff0080e7          	jalr	-16(ra) # 80002a5a <iupdate>
  iunlockput(ip);
    80004a72:	854a                	mv	a0,s2
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	3b8080e7          	jalr	952(ra) # 80002e2c <iunlockput>
  end_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	ba2080e7          	jalr	-1118(ra) # 8000361e <end_op>
  return 0;
    80004a84:	4501                	li	a0,0
    80004a86:	a84d                	j	80004b38 <sys_unlink+0x1c4>
    end_op();
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	b96080e7          	jalr	-1130(ra) # 8000361e <end_op>
    return -1;
    80004a90:	557d                	li	a0,-1
    80004a92:	a05d                	j	80004b38 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a94:	00004517          	auipc	a0,0x4
    80004a98:	c1c50513          	addi	a0,a0,-996 # 800086b0 <syscalls+0x2e8>
    80004a9c:	00001097          	auipc	ra,0x1
    80004aa0:	398080e7          	jalr	920(ra) # 80005e34 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa4:	04c92703          	lw	a4,76(s2)
    80004aa8:	02000793          	li	a5,32
    80004aac:	f6e7f9e3          	bgeu	a5,a4,80004a1e <sys_unlink+0xaa>
    80004ab0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab4:	4741                	li	a4,16
    80004ab6:	86ce                	mv	a3,s3
    80004ab8:	f1840613          	addi	a2,s0,-232
    80004abc:	4581                	li	a1,0
    80004abe:	854a                	mv	a0,s2
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	3be080e7          	jalr	958(ra) # 80002e7e <readi>
    80004ac8:	47c1                	li	a5,16
    80004aca:	00f51b63          	bne	a0,a5,80004ae0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ace:	f1845783          	lhu	a5,-232(s0)
    80004ad2:	e7a1                	bnez	a5,80004b1a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ad4:	29c1                	addiw	s3,s3,16
    80004ad6:	04c92783          	lw	a5,76(s2)
    80004ada:	fcf9ede3          	bltu	s3,a5,80004ab4 <sys_unlink+0x140>
    80004ade:	b781                	j	80004a1e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ae0:	00004517          	auipc	a0,0x4
    80004ae4:	be850513          	addi	a0,a0,-1048 # 800086c8 <syscalls+0x300>
    80004ae8:	00001097          	auipc	ra,0x1
    80004aec:	34c080e7          	jalr	844(ra) # 80005e34 <panic>
    panic("unlink: writei");
    80004af0:	00004517          	auipc	a0,0x4
    80004af4:	bf050513          	addi	a0,a0,-1040 # 800086e0 <syscalls+0x318>
    80004af8:	00001097          	auipc	ra,0x1
    80004afc:	33c080e7          	jalr	828(ra) # 80005e34 <panic>
    dp->nlink--;
    80004b00:	04a4d783          	lhu	a5,74(s1)
    80004b04:	37fd                	addiw	a5,a5,-1
    80004b06:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	f4e080e7          	jalr	-178(ra) # 80002a5a <iupdate>
    80004b14:	b781                	j	80004a54 <sys_unlink+0xe0>
    return -1;
    80004b16:	557d                	li	a0,-1
    80004b18:	a005                	j	80004b38 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b1a:	854a                	mv	a0,s2
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	310080e7          	jalr	784(ra) # 80002e2c <iunlockput>
  iunlockput(dp);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	306080e7          	jalr	774(ra) # 80002e2c <iunlockput>
  end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	af0080e7          	jalr	-1296(ra) # 8000361e <end_op>
  return -1;
    80004b36:	557d                	li	a0,-1
}
    80004b38:	70ae                	ld	ra,232(sp)
    80004b3a:	740e                	ld	s0,224(sp)
    80004b3c:	64ee                	ld	s1,216(sp)
    80004b3e:	694e                	ld	s2,208(sp)
    80004b40:	69ae                	ld	s3,200(sp)
    80004b42:	616d                	addi	sp,sp,240
    80004b44:	8082                	ret

0000000080004b46 <getsymlink>:




uint64
getsymlink(struct inode *ip,struct inode **res){
    80004b46:	7131                	addi	sp,sp,-192
    80004b48:	fd06                	sd	ra,184(sp)
    80004b4a:	f922                	sd	s0,176(sp)
    80004b4c:	f526                	sd	s1,168(sp)
    80004b4e:	f14a                	sd	s2,160(sp)
    80004b50:	ed4e                	sd	s3,152(sp)
    80004b52:	e952                	sd	s4,144(sp)
    80004b54:	e556                	sd	s5,136(sp)
    80004b56:	0180                	addi	s0,sp,192
    80004b58:	84aa                	mv	s1,a0
    80004b5a:	8aae                	mv	s5,a1
  struct inode *p=ip;
  int cnt=0;
    80004b5c:	4901                	li	s2,0
    if((p=namei(target))==0){
      return -1;
    }	    
    cnt++;
    ilock(p);
  }while(cnt<10 && p->type==T_SYMLINK);
    80004b5e:	49a9                	li	s3,10
    80004b60:	4a11                	li	s4,4
    readi(p,0,(uint64)target,0,MAXPATH);
    80004b62:	08000713          	li	a4,128
    80004b66:	4681                	li	a3,0
    80004b68:	f4040613          	addi	a2,s0,-192
    80004b6c:	4581                	li	a1,0
    80004b6e:	8526                	mv	a0,s1
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	30e080e7          	jalr	782(ra) # 80002e7e <readi>
    iunlockput(p);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	2b2080e7          	jalr	690(ra) # 80002e2c <iunlockput>
    if((p=namei(target))==0){
    80004b82:	f4040513          	addi	a0,s0,-192
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	7fc080e7          	jalr	2044(ra) # 80003382 <namei>
    80004b8e:	84aa                	mv	s1,a0
    80004b90:	c905                	beqz	a0,80004bc0 <getsymlink+0x7a>
    cnt++;
    80004b92:	2905                	addiw	s2,s2,1
    ilock(p);
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	f90080e7          	jalr	-112(ra) # 80002b24 <ilock>
  }while(cnt<10 && p->type==T_SYMLINK);
    80004b9c:	03390463          	beq	s2,s3,80004bc4 <getsymlink+0x7e>
    80004ba0:	04449783          	lh	a5,68(s1)
    80004ba4:	fb478fe3          	beq	a5,s4,80004b62 <getsymlink+0x1c>
  if(cnt==10) return -1;
  *res=p;
    80004ba8:	009ab023          	sd	s1,0(s5) # fffffffffffff000 <end+0xffffffff7ffdddc0>
  return 0;
    80004bac:	4501                	li	a0,0
}
    80004bae:	70ea                	ld	ra,184(sp)
    80004bb0:	744a                	ld	s0,176(sp)
    80004bb2:	74aa                	ld	s1,168(sp)
    80004bb4:	790a                	ld	s2,160(sp)
    80004bb6:	69ea                	ld	s3,152(sp)
    80004bb8:	6a4a                	ld	s4,144(sp)
    80004bba:	6aaa                	ld	s5,136(sp)
    80004bbc:	6129                	addi	sp,sp,192
    80004bbe:	8082                	ret
      return -1;
    80004bc0:	557d                	li	a0,-1
    80004bc2:	b7f5                	j	80004bae <getsymlink+0x68>
  if(cnt==10) return -1;
    80004bc4:	557d                	li	a0,-1
    80004bc6:	b7e5                	j	80004bae <getsymlink+0x68>

0000000080004bc8 <sys_open>:
 
uint64
sys_open(void)
{
    80004bc8:	7171                	addi	sp,sp,-176
    80004bca:	f506                	sd	ra,168(sp)
    80004bcc:	f122                	sd	s0,160(sp)
    80004bce:	ed26                	sd	s1,152(sp)
    80004bd0:	e94a                	sd	s2,144(sp)
    80004bd2:	1900                	addi	s0,sp,176
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;
 
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bd4:	08000613          	li	a2,128
    80004bd8:	f6040593          	addi	a1,s0,-160
    80004bdc:	4501                	li	a0,0
    80004bde:	ffffd097          	auipc	ra,0xffffd
    80004be2:	358080e7          	jalr	856(ra) # 80001f36 <argstr>
    return -1;
    80004be6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004be8:	0c054963          	bltz	a0,80004cba <sys_open+0xf2>
    80004bec:	f5c40593          	addi	a1,s0,-164
    80004bf0:	4505                	li	a0,1
    80004bf2:	ffffd097          	auipc	ra,0xffffd
    80004bf6:	300080e7          	jalr	768(ra) # 80001ef2 <argint>
    80004bfa:	0c054063          	bltz	a0,80004cba <sys_open+0xf2>
 
  begin_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	9a0080e7          	jalr	-1632(ra) # 8000359e <begin_op>
 
  if(omode & O_CREATE){
    80004c06:	f5c42783          	lw	a5,-164(s0)
    80004c0a:	2007f793          	andi	a5,a5,512
    80004c0e:	c3f1                	beqz	a5,80004cd2 <sys_open+0x10a>
    ip = create(path, T_FILE, 0, 0);
    80004c10:	4681                	li	a3,0
    80004c12:	4601                	li	a2,0
    80004c14:	4589                	li	a1,2
    80004c16:	f6040513          	addi	a0,s0,-160
    80004c1a:	00000097          	auipc	ra,0x0
    80004c1e:	8f4080e7          	jalr	-1804(ra) # 8000450e <create>
    80004c22:	f4a43823          	sd	a0,-176(s0)
    if(ip == 0){
    80004c26:	c14d                	beqz	a0,80004cc8 <sys_open+0x100>
      }
      
    }
  }
 
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c28:	f5043503          	ld	a0,-176(s0)
    80004c2c:	04451703          	lh	a4,68(a0)
    80004c30:	478d                	li	a5,3
    80004c32:	00f71763          	bne	a4,a5,80004c40 <sys_open+0x78>
    80004c36:	04655703          	lhu	a4,70(a0)
    80004c3a:	47a5                	li	a5,9
    80004c3c:	10e7ea63          	bltu	a5,a4,80004d50 <sys_open+0x188>
    iunlockput(ip);
    end_op();
    return -1;
  }
 
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	d6e080e7          	jalr	-658(ra) # 800039ae <filealloc>
    80004c48:	892a                	mv	s2,a0
    80004c4a:	14050063          	beqz	a0,80004d8a <sys_open+0x1c2>
    80004c4e:	00000097          	auipc	ra,0x0
    80004c52:	87e080e7          	jalr	-1922(ra) # 800044cc <fdalloc>
    80004c56:	84aa                	mv	s1,a0
    80004c58:	12054463          	bltz	a0,80004d80 <sys_open+0x1b8>
    end_op();
    return -1;
  }
 
 
  if(ip->type == T_DEVICE){
    80004c5c:	f5043783          	ld	a5,-176(s0)
    80004c60:	04479703          	lh	a4,68(a5)
    80004c64:	478d                	li	a5,3
    80004c66:	0ef70f63          	beq	a4,a5,80004d64 <sys_open+0x19c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c6a:	4789                	li	a5,2
    80004c6c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c70:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c74:	f5043503          	ld	a0,-176(s0)
    80004c78:	00a93c23          	sd	a0,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c7c:	f5c42783          	lw	a5,-164(s0)
    80004c80:	0017c713          	xori	a4,a5,1
    80004c84:	8b05                	andi	a4,a4,1
    80004c86:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c8a:	0037f713          	andi	a4,a5,3
    80004c8e:	00e03733          	snez	a4,a4
    80004c92:	00e904a3          	sb	a4,9(s2)
 
  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c96:	4007f793          	andi	a5,a5,1024
    80004c9a:	c791                	beqz	a5,80004ca6 <sys_open+0xde>
    80004c9c:	04451703          	lh	a4,68(a0)
    80004ca0:	4789                	li	a5,2
    80004ca2:	0cf70a63          	beq	a4,a5,80004d76 <sys_open+0x1ae>
    itrunc(ip);
  }
 
  iunlock(ip);
    80004ca6:	f5043503          	ld	a0,-176(s0)
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	f3c080e7          	jalr	-196(ra) # 80002be6 <iunlock>
  end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	96c080e7          	jalr	-1684(ra) # 8000361e <end_op>
 
  return fd;
}
    80004cba:	8526                	mv	a0,s1
    80004cbc:	70aa                	ld	ra,168(sp)
    80004cbe:	740a                	ld	s0,160(sp)
    80004cc0:	64ea                	ld	s1,152(sp)
    80004cc2:	694a                	ld	s2,144(sp)
    80004cc4:	614d                	addi	sp,sp,176
    80004cc6:	8082                	ret
      end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	956080e7          	jalr	-1706(ra) # 8000361e <end_op>
      return -1;
    80004cd0:	b7ed                	j	80004cba <sys_open+0xf2>
    if((ip = namei(path)) == 0){
    80004cd2:	f6040513          	addi	a0,s0,-160
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	6ac080e7          	jalr	1708(ra) # 80003382 <namei>
    80004cde:	f4a43823          	sd	a0,-176(s0)
    80004ce2:	c521                	beqz	a0,80004d2a <sys_open+0x162>
    ilock(ip);
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	e40080e7          	jalr	-448(ra) # 80002b24 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cec:	f5043503          	ld	a0,-176(s0)
    80004cf0:	04451783          	lh	a5,68(a0)
    80004cf4:	0007869b          	sext.w	a3,a5
    80004cf8:	4705                	li	a4,1
    80004cfa:	02e68e63          	beq	a3,a4,80004d36 <sys_open+0x16e>
    if(ip->type==T_SYMLINK && omode!=O_NOFOLLOW){
    80004cfe:	2781                	sext.w	a5,a5
    80004d00:	4711                	li	a4,4
    80004d02:	f2e793e3          	bne	a5,a4,80004c28 <sys_open+0x60>
    80004d06:	f5c42783          	lw	a5,-164(s0)
    80004d0a:	8007879b          	addiw	a5,a5,-2048
    80004d0e:	db8d                	beqz	a5,80004c40 <sys_open+0x78>
      if(getsymlink(ip2,&ip)!=0){
    80004d10:	f5040593          	addi	a1,s0,-176
    80004d14:	00000097          	auipc	ra,0x0
    80004d18:	e32080e7          	jalr	-462(ra) # 80004b46 <getsymlink>
    80004d1c:	d511                	beqz	a0,80004c28 <sys_open+0x60>
	    end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	900080e7          	jalr	-1792(ra) # 8000361e <end_op>
	    return -1;
    80004d26:	54fd                	li	s1,-1
    80004d28:	bf49                	j	80004cba <sys_open+0xf2>
      end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	8f4080e7          	jalr	-1804(ra) # 8000361e <end_op>
      return -1;
    80004d32:	54fd                	li	s1,-1
    80004d34:	b759                	j	80004cba <sys_open+0xf2>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d36:	f5c42783          	lw	a5,-164(s0)
    80004d3a:	d399                	beqz	a5,80004c40 <sys_open+0x78>
      iunlockput(ip);
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	0f0080e7          	jalr	240(ra) # 80002e2c <iunlockput>
      end_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	8da080e7          	jalr	-1830(ra) # 8000361e <end_op>
      return -1;
    80004d4c:	54fd                	li	s1,-1
    80004d4e:	b7b5                	j	80004cba <sys_open+0xf2>
    iunlockput(ip);
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	0dc080e7          	jalr	220(ra) # 80002e2c <iunlockput>
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	8c6080e7          	jalr	-1850(ra) # 8000361e <end_op>
    return -1;
    80004d60:	54fd                	li	s1,-1
    80004d62:	bfa1                	j	80004cba <sys_open+0xf2>
    f->type = FD_DEVICE;
    80004d64:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d68:	f5043783          	ld	a5,-176(s0)
    80004d6c:	04679783          	lh	a5,70(a5)
    80004d70:	02f91223          	sh	a5,36(s2)
    80004d74:	b701                	j	80004c74 <sys_open+0xac>
    itrunc(ip);
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	ebc080e7          	jalr	-324(ra) # 80002c32 <itrunc>
    80004d7e:	b725                	j	80004ca6 <sys_open+0xde>
      fileclose(f);
    80004d80:	854a                	mv	a0,s2
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	ce8080e7          	jalr	-792(ra) # 80003a6a <fileclose>
    iunlockput(ip);
    80004d8a:	f5043503          	ld	a0,-176(s0)
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	09e080e7          	jalr	158(ra) # 80002e2c <iunlockput>
    end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	888080e7          	jalr	-1912(ra) # 8000361e <end_op>
    return -1;
    80004d9e:	54fd                	li	s1,-1
    80004da0:	bf29                	j	80004cba <sys_open+0xf2>

0000000080004da2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004da2:	7175                	addi	sp,sp,-144
    80004da4:	e506                	sd	ra,136(sp)
    80004da6:	e122                	sd	s0,128(sp)
    80004da8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	7f4080e7          	jalr	2036(ra) # 8000359e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004db2:	08000613          	li	a2,128
    80004db6:	f7040593          	addi	a1,s0,-144
    80004dba:	4501                	li	a0,0
    80004dbc:	ffffd097          	auipc	ra,0xffffd
    80004dc0:	17a080e7          	jalr	378(ra) # 80001f36 <argstr>
    80004dc4:	02054963          	bltz	a0,80004df6 <sys_mkdir+0x54>
    80004dc8:	4681                	li	a3,0
    80004dca:	4601                	li	a2,0
    80004dcc:	4585                	li	a1,1
    80004dce:	f7040513          	addi	a0,s0,-144
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	73c080e7          	jalr	1852(ra) # 8000450e <create>
    80004dda:	cd11                	beqz	a0,80004df6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	050080e7          	jalr	80(ra) # 80002e2c <iunlockput>
  end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	83a080e7          	jalr	-1990(ra) # 8000361e <end_op>
  return 0;
    80004dec:	4501                	li	a0,0
}
    80004dee:	60aa                	ld	ra,136(sp)
    80004df0:	640a                	ld	s0,128(sp)
    80004df2:	6149                	addi	sp,sp,144
    80004df4:	8082                	ret
    end_op();
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	828080e7          	jalr	-2008(ra) # 8000361e <end_op>
    return -1;
    80004dfe:	557d                	li	a0,-1
    80004e00:	b7fd                	j	80004dee <sys_mkdir+0x4c>

0000000080004e02 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e02:	7135                	addi	sp,sp,-160
    80004e04:	ed06                	sd	ra,152(sp)
    80004e06:	e922                	sd	s0,144(sp)
    80004e08:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	794080e7          	jalr	1940(ra) # 8000359e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e12:	08000613          	li	a2,128
    80004e16:	f7040593          	addi	a1,s0,-144
    80004e1a:	4501                	li	a0,0
    80004e1c:	ffffd097          	auipc	ra,0xffffd
    80004e20:	11a080e7          	jalr	282(ra) # 80001f36 <argstr>
    80004e24:	04054a63          	bltz	a0,80004e78 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e28:	f6c40593          	addi	a1,s0,-148
    80004e2c:	4505                	li	a0,1
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	0c4080e7          	jalr	196(ra) # 80001ef2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e36:	04054163          	bltz	a0,80004e78 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e3a:	f6840593          	addi	a1,s0,-152
    80004e3e:	4509                	li	a0,2
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	0b2080e7          	jalr	178(ra) # 80001ef2 <argint>
     argint(1, &major) < 0 ||
    80004e48:	02054863          	bltz	a0,80004e78 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e4c:	f6841683          	lh	a3,-152(s0)
    80004e50:	f6c41603          	lh	a2,-148(s0)
    80004e54:	458d                	li	a1,3
    80004e56:	f7040513          	addi	a0,s0,-144
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	6b4080e7          	jalr	1716(ra) # 8000450e <create>
     argint(2, &minor) < 0 ||
    80004e62:	c919                	beqz	a0,80004e78 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	fc8080e7          	jalr	-56(ra) # 80002e2c <iunlockput>
  end_op();
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	7b2080e7          	jalr	1970(ra) # 8000361e <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
    80004e76:	a031                	j	80004e82 <sys_mknod+0x80>
    end_op();
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	7a6080e7          	jalr	1958(ra) # 8000361e <end_op>
    return -1;
    80004e80:	557d                	li	a0,-1
}
    80004e82:	60ea                	ld	ra,152(sp)
    80004e84:	644a                	ld	s0,144(sp)
    80004e86:	610d                	addi	sp,sp,160
    80004e88:	8082                	ret

0000000080004e8a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e8a:	7135                	addi	sp,sp,-160
    80004e8c:	ed06                	sd	ra,152(sp)
    80004e8e:	e922                	sd	s0,144(sp)
    80004e90:	e526                	sd	s1,136(sp)
    80004e92:	e14a                	sd	s2,128(sp)
    80004e94:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e96:	ffffc097          	auipc	ra,0xffffc
    80004e9a:	fac080e7          	jalr	-84(ra) # 80000e42 <myproc>
    80004e9e:	892a                	mv	s2,a0
  
  begin_op();
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	6fe080e7          	jalr	1790(ra) # 8000359e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ea8:	08000613          	li	a2,128
    80004eac:	f6040593          	addi	a1,s0,-160
    80004eb0:	4501                	li	a0,0
    80004eb2:	ffffd097          	auipc	ra,0xffffd
    80004eb6:	084080e7          	jalr	132(ra) # 80001f36 <argstr>
    80004eba:	04054b63          	bltz	a0,80004f10 <sys_chdir+0x86>
    80004ebe:	f6040513          	addi	a0,s0,-160
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	4c0080e7          	jalr	1216(ra) # 80003382 <namei>
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	c131                	beqz	a0,80004f10 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	c56080e7          	jalr	-938(ra) # 80002b24 <ilock>
  if(ip->type != T_DIR){
    80004ed6:	04449703          	lh	a4,68(s1)
    80004eda:	4785                	li	a5,1
    80004edc:	04f71063          	bne	a4,a5,80004f1c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ee0:	8526                	mv	a0,s1
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	d04080e7          	jalr	-764(ra) # 80002be6 <iunlock>
  iput(p->cwd);
    80004eea:	15093503          	ld	a0,336(s2)
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	e96080e7          	jalr	-362(ra) # 80002d84 <iput>
  end_op();
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	728080e7          	jalr	1832(ra) # 8000361e <end_op>
  p->cwd = ip;
    80004efe:	14993823          	sd	s1,336(s2)
  return 0;
    80004f02:	4501                	li	a0,0
}
    80004f04:	60ea                	ld	ra,152(sp)
    80004f06:	644a                	ld	s0,144(sp)
    80004f08:	64aa                	ld	s1,136(sp)
    80004f0a:	690a                	ld	s2,128(sp)
    80004f0c:	610d                	addi	sp,sp,160
    80004f0e:	8082                	ret
    end_op();
    80004f10:	ffffe097          	auipc	ra,0xffffe
    80004f14:	70e080e7          	jalr	1806(ra) # 8000361e <end_op>
    return -1;
    80004f18:	557d                	li	a0,-1
    80004f1a:	b7ed                	j	80004f04 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	f0e080e7          	jalr	-242(ra) # 80002e2c <iunlockput>
    end_op();
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	6f8080e7          	jalr	1784(ra) # 8000361e <end_op>
    return -1;
    80004f2e:	557d                	li	a0,-1
    80004f30:	bfd1                	j	80004f04 <sys_chdir+0x7a>

0000000080004f32 <sys_exec>:

uint64
sys_exec(void)
{
    80004f32:	7145                	addi	sp,sp,-464
    80004f34:	e786                	sd	ra,456(sp)
    80004f36:	e3a2                	sd	s0,448(sp)
    80004f38:	ff26                	sd	s1,440(sp)
    80004f3a:	fb4a                	sd	s2,432(sp)
    80004f3c:	f74e                	sd	s3,424(sp)
    80004f3e:	f352                	sd	s4,416(sp)
    80004f40:	ef56                	sd	s5,408(sp)
    80004f42:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f44:	08000613          	li	a2,128
    80004f48:	f4040593          	addi	a1,s0,-192
    80004f4c:	4501                	li	a0,0
    80004f4e:	ffffd097          	auipc	ra,0xffffd
    80004f52:	fe8080e7          	jalr	-24(ra) # 80001f36 <argstr>
    return -1;
    80004f56:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f58:	0c054a63          	bltz	a0,8000502c <sys_exec+0xfa>
    80004f5c:	e3840593          	addi	a1,s0,-456
    80004f60:	4505                	li	a0,1
    80004f62:	ffffd097          	auipc	ra,0xffffd
    80004f66:	fb2080e7          	jalr	-78(ra) # 80001f14 <argaddr>
    80004f6a:	0c054163          	bltz	a0,8000502c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f6e:	10000613          	li	a2,256
    80004f72:	4581                	li	a1,0
    80004f74:	e4040513          	addi	a0,s0,-448
    80004f78:	ffffb097          	auipc	ra,0xffffb
    80004f7c:	200080e7          	jalr	512(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f80:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f84:	89a6                	mv	s3,s1
    80004f86:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f88:	02000a13          	li	s4,32
    80004f8c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f90:	00391793          	slli	a5,s2,0x3
    80004f94:	e3040593          	addi	a1,s0,-464
    80004f98:	e3843503          	ld	a0,-456(s0)
    80004f9c:	953e                	add	a0,a0,a5
    80004f9e:	ffffd097          	auipc	ra,0xffffd
    80004fa2:	eba080e7          	jalr	-326(ra) # 80001e58 <fetchaddr>
    80004fa6:	02054a63          	bltz	a0,80004fda <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004faa:	e3043783          	ld	a5,-464(s0)
    80004fae:	c3b9                	beqz	a5,80004ff4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fb0:	ffffb097          	auipc	ra,0xffffb
    80004fb4:	168080e7          	jalr	360(ra) # 80000118 <kalloc>
    80004fb8:	85aa                	mv	a1,a0
    80004fba:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fbe:	cd11                	beqz	a0,80004fda <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fc0:	6605                	lui	a2,0x1
    80004fc2:	e3043503          	ld	a0,-464(s0)
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	ee4080e7          	jalr	-284(ra) # 80001eaa <fetchstr>
    80004fce:	00054663          	bltz	a0,80004fda <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fd2:	0905                	addi	s2,s2,1
    80004fd4:	09a1                	addi	s3,s3,8
    80004fd6:	fb491be3          	bne	s2,s4,80004f8c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fda:	10048913          	addi	s2,s1,256
    80004fde:	6088                	ld	a0,0(s1)
    80004fe0:	c529                	beqz	a0,8000502a <sys_exec+0xf8>
    kfree(argv[i]);
    80004fe2:	ffffb097          	auipc	ra,0xffffb
    80004fe6:	03a080e7          	jalr	58(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fea:	04a1                	addi	s1,s1,8
    80004fec:	ff2499e3          	bne	s1,s2,80004fde <sys_exec+0xac>
  return -1;
    80004ff0:	597d                	li	s2,-1
    80004ff2:	a82d                	j	8000502c <sys_exec+0xfa>
      argv[i] = 0;
    80004ff4:	0a8e                	slli	s5,s5,0x3
    80004ff6:	fc040793          	addi	a5,s0,-64
    80004ffa:	9abe                	add	s5,s5,a5
    80004ffc:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005000:	e4040593          	addi	a1,s0,-448
    80005004:	f4040513          	addi	a0,s0,-192
    80005008:	fffff097          	auipc	ra,0xfffff
    8000500c:	0b4080e7          	jalr	180(ra) # 800040bc <exec>
    80005010:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005012:	10048993          	addi	s3,s1,256
    80005016:	6088                	ld	a0,0(s1)
    80005018:	c911                	beqz	a0,8000502c <sys_exec+0xfa>
    kfree(argv[i]);
    8000501a:	ffffb097          	auipc	ra,0xffffb
    8000501e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005022:	04a1                	addi	s1,s1,8
    80005024:	ff3499e3          	bne	s1,s3,80005016 <sys_exec+0xe4>
    80005028:	a011                	j	8000502c <sys_exec+0xfa>
  return -1;
    8000502a:	597d                	li	s2,-1
}
    8000502c:	854a                	mv	a0,s2
    8000502e:	60be                	ld	ra,456(sp)
    80005030:	641e                	ld	s0,448(sp)
    80005032:	74fa                	ld	s1,440(sp)
    80005034:	795a                	ld	s2,432(sp)
    80005036:	79ba                	ld	s3,424(sp)
    80005038:	7a1a                	ld	s4,416(sp)
    8000503a:	6afa                	ld	s5,408(sp)
    8000503c:	6179                	addi	sp,sp,464
    8000503e:	8082                	ret

0000000080005040 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005040:	7139                	addi	sp,sp,-64
    80005042:	fc06                	sd	ra,56(sp)
    80005044:	f822                	sd	s0,48(sp)
    80005046:	f426                	sd	s1,40(sp)
    80005048:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	df8080e7          	jalr	-520(ra) # 80000e42 <myproc>
    80005052:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005054:	fd840593          	addi	a1,s0,-40
    80005058:	4501                	li	a0,0
    8000505a:	ffffd097          	auipc	ra,0xffffd
    8000505e:	eba080e7          	jalr	-326(ra) # 80001f14 <argaddr>
    return -1;
    80005062:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005064:	0e054063          	bltz	a0,80005144 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005068:	fc840593          	addi	a1,s0,-56
    8000506c:	fd040513          	addi	a0,s0,-48
    80005070:	fffff097          	auipc	ra,0xfffff
    80005074:	d2a080e7          	jalr	-726(ra) # 80003d9a <pipealloc>
    return -1;
    80005078:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000507a:	0c054563          	bltz	a0,80005144 <sys_pipe+0x104>
  fd0 = -1;
    8000507e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005082:	fd043503          	ld	a0,-48(s0)
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	446080e7          	jalr	1094(ra) # 800044cc <fdalloc>
    8000508e:	fca42223          	sw	a0,-60(s0)
    80005092:	08054c63          	bltz	a0,8000512a <sys_pipe+0xea>
    80005096:	fc843503          	ld	a0,-56(s0)
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	432080e7          	jalr	1074(ra) # 800044cc <fdalloc>
    800050a2:	fca42023          	sw	a0,-64(s0)
    800050a6:	06054863          	bltz	a0,80005116 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050aa:	4691                	li	a3,4
    800050ac:	fc440613          	addi	a2,s0,-60
    800050b0:	fd843583          	ld	a1,-40(s0)
    800050b4:	68a8                	ld	a0,80(s1)
    800050b6:	ffffc097          	auipc	ra,0xffffc
    800050ba:	a4c080e7          	jalr	-1460(ra) # 80000b02 <copyout>
    800050be:	02054063          	bltz	a0,800050de <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050c2:	4691                	li	a3,4
    800050c4:	fc040613          	addi	a2,s0,-64
    800050c8:	fd843583          	ld	a1,-40(s0)
    800050cc:	0591                	addi	a1,a1,4
    800050ce:	68a8                	ld	a0,80(s1)
    800050d0:	ffffc097          	auipc	ra,0xffffc
    800050d4:	a32080e7          	jalr	-1486(ra) # 80000b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050d8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050da:	06055563          	bgez	a0,80005144 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050de:	fc442783          	lw	a5,-60(s0)
    800050e2:	07e9                	addi	a5,a5,26
    800050e4:	078e                	slli	a5,a5,0x3
    800050e6:	97a6                	add	a5,a5,s1
    800050e8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050ec:	fc042503          	lw	a0,-64(s0)
    800050f0:	0569                	addi	a0,a0,26
    800050f2:	050e                	slli	a0,a0,0x3
    800050f4:	9526                	add	a0,a0,s1
    800050f6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050fa:	fd043503          	ld	a0,-48(s0)
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	96c080e7          	jalr	-1684(ra) # 80003a6a <fileclose>
    fileclose(wf);
    80005106:	fc843503          	ld	a0,-56(s0)
    8000510a:	fffff097          	auipc	ra,0xfffff
    8000510e:	960080e7          	jalr	-1696(ra) # 80003a6a <fileclose>
    return -1;
    80005112:	57fd                	li	a5,-1
    80005114:	a805                	j	80005144 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005116:	fc442783          	lw	a5,-60(s0)
    8000511a:	0007c863          	bltz	a5,8000512a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000511e:	01a78513          	addi	a0,a5,26
    80005122:	050e                	slli	a0,a0,0x3
    80005124:	9526                	add	a0,a0,s1
    80005126:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000512a:	fd043503          	ld	a0,-48(s0)
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	93c080e7          	jalr	-1732(ra) # 80003a6a <fileclose>
    fileclose(wf);
    80005136:	fc843503          	ld	a0,-56(s0)
    8000513a:	fffff097          	auipc	ra,0xfffff
    8000513e:	930080e7          	jalr	-1744(ra) # 80003a6a <fileclose>
    return -1;
    80005142:	57fd                	li	a5,-1
}
    80005144:	853e                	mv	a0,a5
    80005146:	70e2                	ld	ra,56(sp)
    80005148:	7442                	ld	s0,48(sp)
    8000514a:	74a2                	ld	s1,40(sp)
    8000514c:	6121                	addi	sp,sp,64
    8000514e:	8082                	ret

0000000080005150 <sys_symlink>:

uint64
sys_symlink(void){
    80005150:	7169                	addi	sp,sp,-304
    80005152:	f606                	sd	ra,296(sp)
    80005154:	f222                	sd	s0,288(sp)
    80005156:	ee26                	sd	s1,280(sp)
    80005158:	ea4a                	sd	s2,272(sp)
    8000515a:	1a00                	addi	s0,sp,304
  char target[MAXPATH],path[MAXPATH],name[DIRSIZ];
  struct inode *dp,*sp;
  if(argstr(0,target,MAXPATH)<0 || argstr(1,path,MAXPATH)<0)
    8000515c:	08000613          	li	a2,128
    80005160:	f6040593          	addi	a1,s0,-160
    80005164:	4501                	li	a0,0
    80005166:	ffffd097          	auipc	ra,0xffffd
    8000516a:	dd0080e7          	jalr	-560(ra) # 80001f36 <argstr>
    return -1;
    8000516e:	57fd                	li	a5,-1
  if(argstr(0,target,MAXPATH)<0 || argstr(1,path,MAXPATH)<0)
    80005170:	0a054f63          	bltz	a0,8000522e <sys_symlink+0xde>
    80005174:	08000613          	li	a2,128
    80005178:	ee040593          	addi	a1,s0,-288
    8000517c:	4505                	li	a0,1
    8000517e:	ffffd097          	auipc	ra,0xffffd
    80005182:	db8080e7          	jalr	-584(ra) # 80001f36 <argstr>
    return -1;
    80005186:	57fd                	li	a5,-1
  if(argstr(0,target,MAXPATH)<0 || argstr(1,path,MAXPATH)<0)
    80005188:	0a054363          	bltz	a0,8000522e <sys_symlink+0xde>
  begin_op();
    8000518c:	ffffe097          	auipc	ra,0xffffe
    80005190:	412080e7          	jalr	1042(ra) # 8000359e <begin_op>
  if((dp=nameiparent(path,name))==0){
    80005194:	ed040593          	addi	a1,s0,-304
    80005198:	ee040513          	addi	a0,s0,-288
    8000519c:	ffffe097          	auipc	ra,0xffffe
    800051a0:	204080e7          	jalr	516(ra) # 800033a0 <nameiparent>
    800051a4:	84aa                	mv	s1,a0
    800051a6:	c959                	beqz	a0,8000523c <sys_symlink+0xec>
    end_op();
    return -1;
  }
  sp=ialloc(dp->dev,T_SYMLINK);
    800051a8:	4591                	li	a1,4
    800051aa:	4108                	lw	a0,0(a0)
    800051ac:	ffffd097          	auipc	ra,0xffffd
    800051b0:	7e0080e7          	jalr	2016(ra) # 8000298c <ialloc>
    800051b4:	892a                	mv	s2,a0
  ilock(sp);
    800051b6:	ffffe097          	auipc	ra,0xffffe
    800051ba:	96e080e7          	jalr	-1682(ra) # 80002b24 <ilock>
  if(writei(sp,0,(uint64)target,0,sizeof(target))!=sizeof(target)){
    800051be:	08000713          	li	a4,128
    800051c2:	4681                	li	a3,0
    800051c4:	f6040613          	addi	a2,s0,-160
    800051c8:	4581                	li	a1,0
    800051ca:	854a                	mv	a0,s2
    800051cc:	ffffe097          	auipc	ra,0xffffe
    800051d0:	daa080e7          	jalr	-598(ra) # 80002f76 <writei>
    800051d4:	08000793          	li	a5,128
    800051d8:	06f51863          	bne	a0,a5,80005248 <sys_symlink+0xf8>
    iunlockput(sp);
    iput(dp);
    end_op();
    return -1;
  }
  ilock(dp);
    800051dc:	8526                	mv	a0,s1
    800051de:	ffffe097          	auipc	ra,0xffffe
    800051e2:	946080e7          	jalr	-1722(ra) # 80002b24 <ilock>
  if(dirlink(dp,name,sp->inum)<0){
    800051e6:	00492603          	lw	a2,4(s2)
    800051ea:	ed040593          	addi	a1,s0,-304
    800051ee:	8526                	mv	a0,s1
    800051f0:	ffffe097          	auipc	ra,0xffffe
    800051f4:	0d0080e7          	jalr	208(ra) # 800032c0 <dirlink>
    800051f8:	06054863          	bltz	a0,80005268 <sys_symlink+0x118>
    iunlockput(dp);
    iunlockput(sp);
    end_op();
    return -1;
  }
  iunlockput(dp);
    800051fc:	8526                	mv	a0,s1
    800051fe:	ffffe097          	auipc	ra,0xffffe
    80005202:	c2e080e7          	jalr	-978(ra) # 80002e2c <iunlockput>
  sp->nlink++;
    80005206:	04a95783          	lhu	a5,74(s2)
    8000520a:	2785                	addiw	a5,a5,1
    8000520c:	04f91523          	sh	a5,74(s2)
  iupdate(sp);
    80005210:	854a                	mv	a0,s2
    80005212:	ffffe097          	auipc	ra,0xffffe
    80005216:	848080e7          	jalr	-1976(ra) # 80002a5a <iupdate>
  iunlockput(sp);
    8000521a:	854a                	mv	a0,s2
    8000521c:	ffffe097          	auipc	ra,0xffffe
    80005220:	c10080e7          	jalr	-1008(ra) # 80002e2c <iunlockput>
  end_op();
    80005224:	ffffe097          	auipc	ra,0xffffe
    80005228:	3fa080e7          	jalr	1018(ra) # 8000361e <end_op>
  return 0;
    8000522c:	4781                	li	a5,0
}
    8000522e:	853e                	mv	a0,a5
    80005230:	70b2                	ld	ra,296(sp)
    80005232:	7412                	ld	s0,288(sp)
    80005234:	64f2                	ld	s1,280(sp)
    80005236:	6952                	ld	s2,272(sp)
    80005238:	6155                	addi	sp,sp,304
    8000523a:	8082                	ret
    end_op();
    8000523c:	ffffe097          	auipc	ra,0xffffe
    80005240:	3e2080e7          	jalr	994(ra) # 8000361e <end_op>
    return -1;
    80005244:	57fd                	li	a5,-1
    80005246:	b7e5                	j	8000522e <sys_symlink+0xde>
    iunlockput(sp);
    80005248:	854a                	mv	a0,s2
    8000524a:	ffffe097          	auipc	ra,0xffffe
    8000524e:	be2080e7          	jalr	-1054(ra) # 80002e2c <iunlockput>
    iput(dp);
    80005252:	8526                	mv	a0,s1
    80005254:	ffffe097          	auipc	ra,0xffffe
    80005258:	b30080e7          	jalr	-1232(ra) # 80002d84 <iput>
    end_op();
    8000525c:	ffffe097          	auipc	ra,0xffffe
    80005260:	3c2080e7          	jalr	962(ra) # 8000361e <end_op>
    return -1;
    80005264:	57fd                	li	a5,-1
    80005266:	b7e1                	j	8000522e <sys_symlink+0xde>
    iunlockput(dp);
    80005268:	8526                	mv	a0,s1
    8000526a:	ffffe097          	auipc	ra,0xffffe
    8000526e:	bc2080e7          	jalr	-1086(ra) # 80002e2c <iunlockput>
    iunlockput(sp);
    80005272:	854a                	mv	a0,s2
    80005274:	ffffe097          	auipc	ra,0xffffe
    80005278:	bb8080e7          	jalr	-1096(ra) # 80002e2c <iunlockput>
    end_op();
    8000527c:	ffffe097          	auipc	ra,0xffffe
    80005280:	3a2080e7          	jalr	930(ra) # 8000361e <end_op>
    return -1;
    80005284:	57fd                	li	a5,-1
    80005286:	b765                	j	8000522e <sys_symlink+0xde>
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	a55fc0ef          	jal	ra,80001d24 <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005358:	c3d8                	sw	a4,4(a5)
}
    8000535a:	6422                	ld	s0,8(sp)
    8000535c:	0141                	addi	sp,sp,16
    8000535e:	8082                	ret

0000000080005360 <plicinithart>:

void
plicinithart(void)
{
    80005360:	1141                	addi	sp,sp,-16
    80005362:	e406                	sd	ra,8(sp)
    80005364:	e022                	sd	s0,0(sp)
    80005366:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	aae080e7          	jalr	-1362(ra) # 80000e16 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	slliw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	slliw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	953e                	add	a0,a0,a5
    8000538c:	00052023          	sw	zero,0(a0)
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	a76080e7          	jalr	-1418(ra) # 80000e16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a8:	00d5179b          	slliw	a5,a0,0xd
    800053ac:	0c201537          	lui	a0,0xc201
    800053b0:	953e                	add	a0,a0,a5
  return irq;
}
    800053b2:	4148                	lw	a0,4(a0)
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053bc:	1101                	addi	sp,sp,-32
    800053be:	ec06                	sd	ra,24(sp)
    800053c0:	e822                	sd	s0,16(sp)
    800053c2:	e426                	sd	s1,8(sp)
    800053c4:	1000                	addi	s0,sp,32
    800053c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	a4e080e7          	jalr	-1458(ra) # 80000e16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d0:	00d5151b          	slliw	a0,a0,0xd
    800053d4:	0c2017b7          	lui	a5,0xc201
    800053d8:	97aa                	add	a5,a5,a0
    800053da:	c3c4                	sw	s1,4(a5)
}
    800053dc:	60e2                	ld	ra,24(sp)
    800053de:	6442                	ld	s0,16(sp)
    800053e0:	64a2                	ld	s1,8(sp)
    800053e2:	6105                	addi	sp,sp,32
    800053e4:	8082                	ret

00000000800053e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053e6:	1141                	addi	sp,sp,-16
    800053e8:	e406                	sd	ra,8(sp)
    800053ea:	e022                	sd	s0,0(sp)
    800053ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ee:	479d                	li	a5,7
    800053f0:	06a7c963          	blt	a5,a0,80005462 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800053f4:	00011797          	auipc	a5,0x11
    800053f8:	c0c78793          	addi	a5,a5,-1012 # 80016000 <disk>
    800053fc:	00a78733          	add	a4,a5,a0
    80005400:	6789                	lui	a5,0x2
    80005402:	97ba                	add	a5,a5,a4
    80005404:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005408:	e7ad                	bnez	a5,80005472 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000540a:	00451793          	slli	a5,a0,0x4
    8000540e:	00013717          	auipc	a4,0x13
    80005412:	bf270713          	addi	a4,a4,-1038 # 80018000 <disk+0x2000>
    80005416:	6314                	ld	a3,0(a4)
    80005418:	96be                	add	a3,a3,a5
    8000541a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000541e:	6314                	ld	a3,0(a4)
    80005420:	96be                	add	a3,a3,a5
    80005422:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005426:	6314                	ld	a3,0(a4)
    80005428:	96be                	add	a3,a3,a5
    8000542a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000542e:	6318                	ld	a4,0(a4)
    80005430:	97ba                	add	a5,a5,a4
    80005432:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005436:	00011797          	auipc	a5,0x11
    8000543a:	bca78793          	addi	a5,a5,-1078 # 80016000 <disk>
    8000543e:	97aa                	add	a5,a5,a0
    80005440:	6509                	lui	a0,0x2
    80005442:	953e                	add	a0,a0,a5
    80005444:	4785                	li	a5,1
    80005446:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000544a:	00013517          	auipc	a0,0x13
    8000544e:	bce50513          	addi	a0,a0,-1074 # 80018018 <disk+0x2018>
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	23c080e7          	jalr	572(ra) # 8000168e <wakeup>
}
    8000545a:	60a2                	ld	ra,8(sp)
    8000545c:	6402                	ld	s0,0(sp)
    8000545e:	0141                	addi	sp,sp,16
    80005460:	8082                	ret
    panic("free_desc 1");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	28e50513          	addi	a0,a0,654 # 800086f0 <syscalls+0x328>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	9ca080e7          	jalr	-1590(ra) # 80005e34 <panic>
    panic("free_desc 2");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	28e50513          	addi	a0,a0,654 # 80008700 <syscalls+0x338>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	9ba080e7          	jalr	-1606(ra) # 80005e34 <panic>

0000000080005482 <virtio_disk_init>:
{
    80005482:	1101                	addi	sp,sp,-32
    80005484:	ec06                	sd	ra,24(sp)
    80005486:	e822                	sd	s0,16(sp)
    80005488:	e426                	sd	s1,8(sp)
    8000548a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000548c:	00003597          	auipc	a1,0x3
    80005490:	28458593          	addi	a1,a1,644 # 80008710 <syscalls+0x348>
    80005494:	00013517          	auipc	a0,0x13
    80005498:	c9450513          	addi	a0,a0,-876 # 80018128 <disk+0x2128>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	e44080e7          	jalr	-444(ra) # 800062e0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	4398                	lw	a4,0(a5)
    800054aa:	2701                	sext.w	a4,a4
    800054ac:	747277b7          	lui	a5,0x74727
    800054b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054b4:	0ef71163          	bne	a4,a5,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054b8:	100017b7          	lui	a5,0x10001
    800054bc:	43dc                	lw	a5,4(a5)
    800054be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c0:	4705                	li	a4,1
    800054c2:	0ce79a63          	bne	a5,a4,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054c6:	100017b7          	lui	a5,0x10001
    800054ca:	479c                	lw	a5,8(a5)
    800054cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054ce:	4709                	li	a4,2
    800054d0:	0ce79363          	bne	a5,a4,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054d4:	100017b7          	lui	a5,0x10001
    800054d8:	47d8                	lw	a4,12(a5)
    800054da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054dc:	554d47b7          	lui	a5,0x554d4
    800054e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054e4:	0af71963          	bne	a4,a5,80005596 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	4705                	li	a4,1
    800054ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f0:	470d                	li	a4,3
    800054f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054f6:	c7ffe737          	lui	a4,0xc7ffe
    800054fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd51f>
    800054fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005500:	2701                	sext.w	a4,a4
    80005502:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005504:	472d                	li	a4,11
    80005506:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005508:	473d                	li	a4,15
    8000550a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000550c:	6705                	lui	a4,0x1
    8000550e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005510:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005514:	5bdc                	lw	a5,52(a5)
    80005516:	2781                	sext.w	a5,a5
  if(max == 0)
    80005518:	c7d9                	beqz	a5,800055a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000551a:	471d                	li	a4,7
    8000551c:	08f77d63          	bgeu	a4,a5,800055b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005520:	100014b7          	lui	s1,0x10001
    80005524:	47a1                	li	a5,8
    80005526:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005528:	6609                	lui	a2,0x2
    8000552a:	4581                	li	a1,0
    8000552c:	00011517          	auipc	a0,0x11
    80005530:	ad450513          	addi	a0,a0,-1324 # 80016000 <disk>
    80005534:	ffffb097          	auipc	ra,0xffffb
    80005538:	c44080e7          	jalr	-956(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000553c:	00011717          	auipc	a4,0x11
    80005540:	ac470713          	addi	a4,a4,-1340 # 80016000 <disk>
    80005544:	00c75793          	srli	a5,a4,0xc
    80005548:	2781                	sext.w	a5,a5
    8000554a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000554c:	00013797          	auipc	a5,0x13
    80005550:	ab478793          	addi	a5,a5,-1356 # 80018000 <disk+0x2000>
    80005554:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005556:	00011717          	auipc	a4,0x11
    8000555a:	b2a70713          	addi	a4,a4,-1238 # 80016080 <disk+0x80>
    8000555e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005560:	00012717          	auipc	a4,0x12
    80005564:	aa070713          	addi	a4,a4,-1376 # 80017000 <disk+0x1000>
    80005568:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000556a:	4705                	li	a4,1
    8000556c:	00e78c23          	sb	a4,24(a5)
    80005570:	00e78ca3          	sb	a4,25(a5)
    80005574:	00e78d23          	sb	a4,26(a5)
    80005578:	00e78da3          	sb	a4,27(a5)
    8000557c:	00e78e23          	sb	a4,28(a5)
    80005580:	00e78ea3          	sb	a4,29(a5)
    80005584:	00e78f23          	sb	a4,30(a5)
    80005588:	00e78fa3          	sb	a4,31(a5)
}
    8000558c:	60e2                	ld	ra,24(sp)
    8000558e:	6442                	ld	s0,16(sp)
    80005590:	64a2                	ld	s1,8(sp)
    80005592:	6105                	addi	sp,sp,32
    80005594:	8082                	ret
    panic("could not find virtio disk");
    80005596:	00003517          	auipc	a0,0x3
    8000559a:	18a50513          	addi	a0,a0,394 # 80008720 <syscalls+0x358>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	896080e7          	jalr	-1898(ra) # 80005e34 <panic>
    panic("virtio disk has no queue 0");
    800055a6:	00003517          	auipc	a0,0x3
    800055aa:	19a50513          	addi	a0,a0,410 # 80008740 <syscalls+0x378>
    800055ae:	00001097          	auipc	ra,0x1
    800055b2:	886080e7          	jalr	-1914(ra) # 80005e34 <panic>
    panic("virtio disk max queue too short");
    800055b6:	00003517          	auipc	a0,0x3
    800055ba:	1aa50513          	addi	a0,a0,426 # 80008760 <syscalls+0x398>
    800055be:	00001097          	auipc	ra,0x1
    800055c2:	876080e7          	jalr	-1930(ra) # 80005e34 <panic>

00000000800055c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055c6:	7119                	addi	sp,sp,-128
    800055c8:	fc86                	sd	ra,120(sp)
    800055ca:	f8a2                	sd	s0,112(sp)
    800055cc:	f4a6                	sd	s1,104(sp)
    800055ce:	f0ca                	sd	s2,96(sp)
    800055d0:	ecce                	sd	s3,88(sp)
    800055d2:	e8d2                	sd	s4,80(sp)
    800055d4:	e4d6                	sd	s5,72(sp)
    800055d6:	e0da                	sd	s6,64(sp)
    800055d8:	fc5e                	sd	s7,56(sp)
    800055da:	f862                	sd	s8,48(sp)
    800055dc:	f466                	sd	s9,40(sp)
    800055de:	f06a                	sd	s10,32(sp)
    800055e0:	ec6e                	sd	s11,24(sp)
    800055e2:	0100                	addi	s0,sp,128
    800055e4:	8aaa                	mv	s5,a0
    800055e6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055e8:	00c52c83          	lw	s9,12(a0)
    800055ec:	001c9c9b          	slliw	s9,s9,0x1
    800055f0:	1c82                	slli	s9,s9,0x20
    800055f2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055f6:	00013517          	auipc	a0,0x13
    800055fa:	b3250513          	addi	a0,a0,-1230 # 80018128 <disk+0x2128>
    800055fe:	00001097          	auipc	ra,0x1
    80005602:	d72080e7          	jalr	-654(ra) # 80006370 <acquire>
  for(int i = 0; i < 3; i++){
    80005606:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005608:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000560a:	00011c17          	auipc	s8,0x11
    8000560e:	9f6c0c13          	addi	s8,s8,-1546 # 80016000 <disk>
    80005612:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005614:	4b0d                	li	s6,3
    80005616:	a0ad                	j	80005680 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005618:	00fc0733          	add	a4,s8,a5
    8000561c:	975e                	add	a4,a4,s7
    8000561e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005622:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005624:	0207c563          	bltz	a5,8000564e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005628:	2905                	addiw	s2,s2,1
    8000562a:	0611                	addi	a2,a2,4
    8000562c:	19690d63          	beq	s2,s6,800057c6 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005630:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005632:	00013717          	auipc	a4,0x13
    80005636:	9e670713          	addi	a4,a4,-1562 # 80018018 <disk+0x2018>
    8000563a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000563c:	00074683          	lbu	a3,0(a4)
    80005640:	fee1                	bnez	a3,80005618 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005642:	2785                	addiw	a5,a5,1
    80005644:	0705                	addi	a4,a4,1
    80005646:	fe979be3          	bne	a5,s1,8000563c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000564a:	57fd                	li	a5,-1
    8000564c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000564e:	01205d63          	blez	s2,80005668 <virtio_disk_rw+0xa2>
    80005652:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005654:	000a2503          	lw	a0,0(s4)
    80005658:	00000097          	auipc	ra,0x0
    8000565c:	d8e080e7          	jalr	-626(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005660:	2d85                	addiw	s11,s11,1
    80005662:	0a11                	addi	s4,s4,4
    80005664:	ffb918e3          	bne	s2,s11,80005654 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005668:	00013597          	auipc	a1,0x13
    8000566c:	ac058593          	addi	a1,a1,-1344 # 80018128 <disk+0x2128>
    80005670:	00013517          	auipc	a0,0x13
    80005674:	9a850513          	addi	a0,a0,-1624 # 80018018 <disk+0x2018>
    80005678:	ffffc097          	auipc	ra,0xffffc
    8000567c:	e8a080e7          	jalr	-374(ra) # 80001502 <sleep>
  for(int i = 0; i < 3; i++){
    80005680:	f8040a13          	addi	s4,s0,-128
{
    80005684:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005686:	894e                	mv	s2,s3
    80005688:	b765                	j	80005630 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000568a:	00013697          	auipc	a3,0x13
    8000568e:	9766b683          	ld	a3,-1674(a3) # 80018000 <disk+0x2000>
    80005692:	96ba                	add	a3,a3,a4
    80005694:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005698:	00011817          	auipc	a6,0x11
    8000569c:	96880813          	addi	a6,a6,-1688 # 80016000 <disk>
    800056a0:	00013697          	auipc	a3,0x13
    800056a4:	96068693          	addi	a3,a3,-1696 # 80018000 <disk+0x2000>
    800056a8:	6290                	ld	a2,0(a3)
    800056aa:	963a                	add	a2,a2,a4
    800056ac:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800056b0:	0015e593          	ori	a1,a1,1
    800056b4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800056b8:	f8842603          	lw	a2,-120(s0)
    800056bc:	628c                	ld	a1,0(a3)
    800056be:	972e                	add	a4,a4,a1
    800056c0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056c4:	20050593          	addi	a1,a0,512
    800056c8:	0592                	slli	a1,a1,0x4
    800056ca:	95c2                	add	a1,a1,a6
    800056cc:	577d                	li	a4,-1
    800056ce:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056d2:	00461713          	slli	a4,a2,0x4
    800056d6:	6290                	ld	a2,0(a3)
    800056d8:	963a                	add	a2,a2,a4
    800056da:	03078793          	addi	a5,a5,48
    800056de:	97c2                	add	a5,a5,a6
    800056e0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800056e2:	629c                	ld	a5,0(a3)
    800056e4:	97ba                	add	a5,a5,a4
    800056e6:	4605                	li	a2,1
    800056e8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056ea:	629c                	ld	a5,0(a3)
    800056ec:	97ba                	add	a5,a5,a4
    800056ee:	4809                	li	a6,2
    800056f0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056f4:	629c                	ld	a5,0(a3)
    800056f6:	973e                	add	a4,a4,a5
    800056f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056fc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005700:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005704:	6698                	ld	a4,8(a3)
    80005706:	00275783          	lhu	a5,2(a4)
    8000570a:	8b9d                	andi	a5,a5,7
    8000570c:	0786                	slli	a5,a5,0x1
    8000570e:	97ba                	add	a5,a5,a4
    80005710:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80005714:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005718:	6698                	ld	a4,8(a3)
    8000571a:	00275783          	lhu	a5,2(a4)
    8000571e:	2785                	addiw	a5,a5,1
    80005720:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005724:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005728:	100017b7          	lui	a5,0x10001
    8000572c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005730:	004aa783          	lw	a5,4(s5)
    80005734:	02c79163          	bne	a5,a2,80005756 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005738:	00013917          	auipc	s2,0x13
    8000573c:	9f090913          	addi	s2,s2,-1552 # 80018128 <disk+0x2128>
  while(b->disk == 1) {
    80005740:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005742:	85ca                	mv	a1,s2
    80005744:	8556                	mv	a0,s5
    80005746:	ffffc097          	auipc	ra,0xffffc
    8000574a:	dbc080e7          	jalr	-580(ra) # 80001502 <sleep>
  while(b->disk == 1) {
    8000574e:	004aa783          	lw	a5,4(s5)
    80005752:	fe9788e3          	beq	a5,s1,80005742 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005756:	f8042903          	lw	s2,-128(s0)
    8000575a:	20090793          	addi	a5,s2,512
    8000575e:	00479713          	slli	a4,a5,0x4
    80005762:	00011797          	auipc	a5,0x11
    80005766:	89e78793          	addi	a5,a5,-1890 # 80016000 <disk>
    8000576a:	97ba                	add	a5,a5,a4
    8000576c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005770:	00013997          	auipc	s3,0x13
    80005774:	89098993          	addi	s3,s3,-1904 # 80018000 <disk+0x2000>
    80005778:	00491713          	slli	a4,s2,0x4
    8000577c:	0009b783          	ld	a5,0(s3)
    80005780:	97ba                	add	a5,a5,a4
    80005782:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005786:	854a                	mv	a0,s2
    80005788:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000578c:	00000097          	auipc	ra,0x0
    80005790:	c5a080e7          	jalr	-934(ra) # 800053e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005794:	8885                	andi	s1,s1,1
    80005796:	f0ed                	bnez	s1,80005778 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005798:	00013517          	auipc	a0,0x13
    8000579c:	99050513          	addi	a0,a0,-1648 # 80018128 <disk+0x2128>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	c84080e7          	jalr	-892(ra) # 80006424 <release>
}
    800057a8:	70e6                	ld	ra,120(sp)
    800057aa:	7446                	ld	s0,112(sp)
    800057ac:	74a6                	ld	s1,104(sp)
    800057ae:	7906                	ld	s2,96(sp)
    800057b0:	69e6                	ld	s3,88(sp)
    800057b2:	6a46                	ld	s4,80(sp)
    800057b4:	6aa6                	ld	s5,72(sp)
    800057b6:	6b06                	ld	s6,64(sp)
    800057b8:	7be2                	ld	s7,56(sp)
    800057ba:	7c42                	ld	s8,48(sp)
    800057bc:	7ca2                	ld	s9,40(sp)
    800057be:	7d02                	ld	s10,32(sp)
    800057c0:	6de2                	ld	s11,24(sp)
    800057c2:	6109                	addi	sp,sp,128
    800057c4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057c6:	f8042503          	lw	a0,-128(s0)
    800057ca:	20050793          	addi	a5,a0,512
    800057ce:	0792                	slli	a5,a5,0x4
  if(write)
    800057d0:	00011817          	auipc	a6,0x11
    800057d4:	83080813          	addi	a6,a6,-2000 # 80016000 <disk>
    800057d8:	00f80733          	add	a4,a6,a5
    800057dc:	01a036b3          	snez	a3,s10
    800057e0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800057e4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800057e8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057ec:	7679                	lui	a2,0xffffe
    800057ee:	963e                	add	a2,a2,a5
    800057f0:	00013697          	auipc	a3,0x13
    800057f4:	81068693          	addi	a3,a3,-2032 # 80018000 <disk+0x2000>
    800057f8:	6298                	ld	a4,0(a3)
    800057fa:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057fc:	0a878593          	addi	a1,a5,168
    80005800:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005802:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005804:	6298                	ld	a4,0(a3)
    80005806:	9732                	add	a4,a4,a2
    80005808:	45c1                	li	a1,16
    8000580a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000580c:	6298                	ld	a4,0(a3)
    8000580e:	9732                	add	a4,a4,a2
    80005810:	4585                	li	a1,1
    80005812:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005816:	f8442703          	lw	a4,-124(s0)
    8000581a:	628c                	ld	a1,0(a3)
    8000581c:	962e                	add	a2,a2,a1
    8000581e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdcdce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005822:	0712                	slli	a4,a4,0x4
    80005824:	6290                	ld	a2,0(a3)
    80005826:	963a                	add	a2,a2,a4
    80005828:	058a8593          	addi	a1,s5,88
    8000582c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000582e:	6294                	ld	a3,0(a3)
    80005830:	96ba                	add	a3,a3,a4
    80005832:	40000613          	li	a2,1024
    80005836:	c690                	sw	a2,8(a3)
  if(write)
    80005838:	e40d19e3          	bnez	s10,8000568a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000583c:	00012697          	auipc	a3,0x12
    80005840:	7c46b683          	ld	a3,1988(a3) # 80018000 <disk+0x2000>
    80005844:	96ba                	add	a3,a3,a4
    80005846:	4609                	li	a2,2
    80005848:	00c69623          	sh	a2,12(a3)
    8000584c:	b5b1                	j	80005698 <virtio_disk_rw+0xd2>

000000008000584e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000584e:	1101                	addi	sp,sp,-32
    80005850:	ec06                	sd	ra,24(sp)
    80005852:	e822                	sd	s0,16(sp)
    80005854:	e426                	sd	s1,8(sp)
    80005856:	e04a                	sd	s2,0(sp)
    80005858:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000585a:	00013517          	auipc	a0,0x13
    8000585e:	8ce50513          	addi	a0,a0,-1842 # 80018128 <disk+0x2128>
    80005862:	00001097          	auipc	ra,0x1
    80005866:	b0e080e7          	jalr	-1266(ra) # 80006370 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000586a:	10001737          	lui	a4,0x10001
    8000586e:	533c                	lw	a5,96(a4)
    80005870:	8b8d                	andi	a5,a5,3
    80005872:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005874:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005878:	00012797          	auipc	a5,0x12
    8000587c:	78878793          	addi	a5,a5,1928 # 80018000 <disk+0x2000>
    80005880:	6b94                	ld	a3,16(a5)
    80005882:	0207d703          	lhu	a4,32(a5)
    80005886:	0026d783          	lhu	a5,2(a3)
    8000588a:	06f70163          	beq	a4,a5,800058ec <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000588e:	00010917          	auipc	s2,0x10
    80005892:	77290913          	addi	s2,s2,1906 # 80016000 <disk>
    80005896:	00012497          	auipc	s1,0x12
    8000589a:	76a48493          	addi	s1,s1,1898 # 80018000 <disk+0x2000>
    __sync_synchronize();
    8000589e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058a2:	6898                	ld	a4,16(s1)
    800058a4:	0204d783          	lhu	a5,32(s1)
    800058a8:	8b9d                	andi	a5,a5,7
    800058aa:	078e                	slli	a5,a5,0x3
    800058ac:	97ba                	add	a5,a5,a4
    800058ae:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058b0:	20078713          	addi	a4,a5,512
    800058b4:	0712                	slli	a4,a4,0x4
    800058b6:	974a                	add	a4,a4,s2
    800058b8:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800058bc:	e731                	bnez	a4,80005908 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058be:	20078793          	addi	a5,a5,512
    800058c2:	0792                	slli	a5,a5,0x4
    800058c4:	97ca                	add	a5,a5,s2
    800058c6:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058c8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058cc:	ffffc097          	auipc	ra,0xffffc
    800058d0:	dc2080e7          	jalr	-574(ra) # 8000168e <wakeup>

    disk.used_idx += 1;
    800058d4:	0204d783          	lhu	a5,32(s1)
    800058d8:	2785                	addiw	a5,a5,1
    800058da:	17c2                	slli	a5,a5,0x30
    800058dc:	93c1                	srli	a5,a5,0x30
    800058de:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058e2:	6898                	ld	a4,16(s1)
    800058e4:	00275703          	lhu	a4,2(a4)
    800058e8:	faf71be3          	bne	a4,a5,8000589e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058ec:	00013517          	auipc	a0,0x13
    800058f0:	83c50513          	addi	a0,a0,-1988 # 80018128 <disk+0x2128>
    800058f4:	00001097          	auipc	ra,0x1
    800058f8:	b30080e7          	jalr	-1232(ra) # 80006424 <release>
}
    800058fc:	60e2                	ld	ra,24(sp)
    800058fe:	6442                	ld	s0,16(sp)
    80005900:	64a2                	ld	s1,8(sp)
    80005902:	6902                	ld	s2,0(sp)
    80005904:	6105                	addi	sp,sp,32
    80005906:	8082                	ret
      panic("virtio_disk_intr status");
    80005908:	00003517          	auipc	a0,0x3
    8000590c:	e7850513          	addi	a0,a0,-392 # 80008780 <syscalls+0x3b8>
    80005910:	00000097          	auipc	ra,0x0
    80005914:	524080e7          	jalr	1316(ra) # 80005e34 <panic>

0000000080005918 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005918:	1141                	addi	sp,sp,-16
    8000591a:	e422                	sd	s0,8(sp)
    8000591c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000591e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005922:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005926:	0037979b          	slliw	a5,a5,0x3
    8000592a:	02004737          	lui	a4,0x2004
    8000592e:	97ba                	add	a5,a5,a4
    80005930:	0200c737          	lui	a4,0x200c
    80005934:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005938:	000f4637          	lui	a2,0xf4
    8000593c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005940:	95b2                	add	a1,a1,a2
    80005942:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005944:	00269713          	slli	a4,a3,0x2
    80005948:	9736                	add	a4,a4,a3
    8000594a:	00371693          	slli	a3,a4,0x3
    8000594e:	00013717          	auipc	a4,0x13
    80005952:	6b270713          	addi	a4,a4,1714 # 80019000 <timer_scratch>
    80005956:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005958:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000595a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000595c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005960:	00000797          	auipc	a5,0x0
    80005964:	9c078793          	addi	a5,a5,-1600 # 80005320 <timervec>
    80005968:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000596c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005970:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005974:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005978:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000597c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005980:	30479073          	csrw	mie,a5
}
    80005984:	6422                	ld	s0,8(sp)
    80005986:	0141                	addi	sp,sp,16
    80005988:	8082                	ret

000000008000598a <start>:
{
    8000598a:	1141                	addi	sp,sp,-16
    8000598c:	e406                	sd	ra,8(sp)
    8000598e:	e022                	sd	s0,0(sp)
    80005990:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005992:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005996:	7779                	lui	a4,0xffffe
    80005998:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd5bf>
    8000599c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000599e:	6705                	lui	a4,0x1
    800059a0:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059a4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059a6:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059aa:	ffffb797          	auipc	a5,0xffffb
    800059ae:	97478793          	addi	a5,a5,-1676 # 8000031e <main>
    800059b2:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059b6:	4781                	li	a5,0
    800059b8:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059bc:	67c1                	lui	a5,0x10
    800059be:	17fd                	addi	a5,a5,-1
    800059c0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059c4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059c8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059cc:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059d0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059d4:	57fd                	li	a5,-1
    800059d6:	83a9                	srli	a5,a5,0xa
    800059d8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059dc:	47bd                	li	a5,15
    800059de:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059e2:	00000097          	auipc	ra,0x0
    800059e6:	f36080e7          	jalr	-202(ra) # 80005918 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059ea:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059ee:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059f0:	823e                	mv	tp,a5
  asm volatile("mret");
    800059f2:	30200073          	mret
}
    800059f6:	60a2                	ld	ra,8(sp)
    800059f8:	6402                	ld	s0,0(sp)
    800059fa:	0141                	addi	sp,sp,16
    800059fc:	8082                	ret

00000000800059fe <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059fe:	715d                	addi	sp,sp,-80
    80005a00:	e486                	sd	ra,72(sp)
    80005a02:	e0a2                	sd	s0,64(sp)
    80005a04:	fc26                	sd	s1,56(sp)
    80005a06:	f84a                	sd	s2,48(sp)
    80005a08:	f44e                	sd	s3,40(sp)
    80005a0a:	f052                	sd	s4,32(sp)
    80005a0c:	ec56                	sd	s5,24(sp)
    80005a0e:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a10:	04c05663          	blez	a2,80005a5c <consolewrite+0x5e>
    80005a14:	8a2a                	mv	s4,a0
    80005a16:	84ae                	mv	s1,a1
    80005a18:	89b2                	mv	s3,a2
    80005a1a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a1c:	5afd                	li	s5,-1
    80005a1e:	4685                	li	a3,1
    80005a20:	8626                	mv	a2,s1
    80005a22:	85d2                	mv	a1,s4
    80005a24:	fbf40513          	addi	a0,s0,-65
    80005a28:	ffffc097          	auipc	ra,0xffffc
    80005a2c:	ed4080e7          	jalr	-300(ra) # 800018fc <either_copyin>
    80005a30:	01550c63          	beq	a0,s5,80005a48 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a34:	fbf44503          	lbu	a0,-65(s0)
    80005a38:	00000097          	auipc	ra,0x0
    80005a3c:	77a080e7          	jalr	1914(ra) # 800061b2 <uartputc>
  for(i = 0; i < n; i++){
    80005a40:	2905                	addiw	s2,s2,1
    80005a42:	0485                	addi	s1,s1,1
    80005a44:	fd299de3          	bne	s3,s2,80005a1e <consolewrite+0x20>
  }

  return i;
}
    80005a48:	854a                	mv	a0,s2
    80005a4a:	60a6                	ld	ra,72(sp)
    80005a4c:	6406                	ld	s0,64(sp)
    80005a4e:	74e2                	ld	s1,56(sp)
    80005a50:	7942                	ld	s2,48(sp)
    80005a52:	79a2                	ld	s3,40(sp)
    80005a54:	7a02                	ld	s4,32(sp)
    80005a56:	6ae2                	ld	s5,24(sp)
    80005a58:	6161                	addi	sp,sp,80
    80005a5a:	8082                	ret
  for(i = 0; i < n; i++){
    80005a5c:	4901                	li	s2,0
    80005a5e:	b7ed                	j	80005a48 <consolewrite+0x4a>

0000000080005a60 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a60:	7159                	addi	sp,sp,-112
    80005a62:	f486                	sd	ra,104(sp)
    80005a64:	f0a2                	sd	s0,96(sp)
    80005a66:	eca6                	sd	s1,88(sp)
    80005a68:	e8ca                	sd	s2,80(sp)
    80005a6a:	e4ce                	sd	s3,72(sp)
    80005a6c:	e0d2                	sd	s4,64(sp)
    80005a6e:	fc56                	sd	s5,56(sp)
    80005a70:	f85a                	sd	s6,48(sp)
    80005a72:	f45e                	sd	s7,40(sp)
    80005a74:	f062                	sd	s8,32(sp)
    80005a76:	ec66                	sd	s9,24(sp)
    80005a78:	e86a                	sd	s10,16(sp)
    80005a7a:	1880                	addi	s0,sp,112
    80005a7c:	8aaa                	mv	s5,a0
    80005a7e:	8a2e                	mv	s4,a1
    80005a80:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a82:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a86:	0001b517          	auipc	a0,0x1b
    80005a8a:	6ba50513          	addi	a0,a0,1722 # 80021140 <cons>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	8e2080e7          	jalr	-1822(ra) # 80006370 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a96:	0001b497          	auipc	s1,0x1b
    80005a9a:	6aa48493          	addi	s1,s1,1706 # 80021140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a9e:	0001b917          	auipc	s2,0x1b
    80005aa2:	73a90913          	addi	s2,s2,1850 # 800211d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005aa6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aa8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005aaa:	4ca9                	li	s9,10
  while(n > 0){
    80005aac:	07305863          	blez	s3,80005b1c <consoleread+0xbc>
    while(cons.r == cons.w){
    80005ab0:	0984a783          	lw	a5,152(s1)
    80005ab4:	09c4a703          	lw	a4,156(s1)
    80005ab8:	02f71463          	bne	a4,a5,80005ae0 <consoleread+0x80>
      if(myproc()->killed){
    80005abc:	ffffb097          	auipc	ra,0xffffb
    80005ac0:	386080e7          	jalr	902(ra) # 80000e42 <myproc>
    80005ac4:	551c                	lw	a5,40(a0)
    80005ac6:	e7b5                	bnez	a5,80005b32 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005ac8:	85a6                	mv	a1,s1
    80005aca:	854a                	mv	a0,s2
    80005acc:	ffffc097          	auipc	ra,0xffffc
    80005ad0:	a36080e7          	jalr	-1482(ra) # 80001502 <sleep>
    while(cons.r == cons.w){
    80005ad4:	0984a783          	lw	a5,152(s1)
    80005ad8:	09c4a703          	lw	a4,156(s1)
    80005adc:	fef700e3          	beq	a4,a5,80005abc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005ae0:	0017871b          	addiw	a4,a5,1
    80005ae4:	08e4ac23          	sw	a4,152(s1)
    80005ae8:	07f7f713          	andi	a4,a5,127
    80005aec:	9726                	add	a4,a4,s1
    80005aee:	01874703          	lbu	a4,24(a4)
    80005af2:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005af6:	077d0563          	beq	s10,s7,80005b60 <consoleread+0x100>
    cbuf = c;
    80005afa:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005afe:	4685                	li	a3,1
    80005b00:	f9f40613          	addi	a2,s0,-97
    80005b04:	85d2                	mv	a1,s4
    80005b06:	8556                	mv	a0,s5
    80005b08:	ffffc097          	auipc	ra,0xffffc
    80005b0c:	d9e080e7          	jalr	-610(ra) # 800018a6 <either_copyout>
    80005b10:	01850663          	beq	a0,s8,80005b1c <consoleread+0xbc>
    dst++;
    80005b14:	0a05                	addi	s4,s4,1
    --n;
    80005b16:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005b18:	f99d1ae3          	bne	s10,s9,80005aac <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b1c:	0001b517          	auipc	a0,0x1b
    80005b20:	62450513          	addi	a0,a0,1572 # 80021140 <cons>
    80005b24:	00001097          	auipc	ra,0x1
    80005b28:	900080e7          	jalr	-1792(ra) # 80006424 <release>

  return target - n;
    80005b2c:	413b053b          	subw	a0,s6,s3
    80005b30:	a811                	j	80005b44 <consoleread+0xe4>
        release(&cons.lock);
    80005b32:	0001b517          	auipc	a0,0x1b
    80005b36:	60e50513          	addi	a0,a0,1550 # 80021140 <cons>
    80005b3a:	00001097          	auipc	ra,0x1
    80005b3e:	8ea080e7          	jalr	-1814(ra) # 80006424 <release>
        return -1;
    80005b42:	557d                	li	a0,-1
}
    80005b44:	70a6                	ld	ra,104(sp)
    80005b46:	7406                	ld	s0,96(sp)
    80005b48:	64e6                	ld	s1,88(sp)
    80005b4a:	6946                	ld	s2,80(sp)
    80005b4c:	69a6                	ld	s3,72(sp)
    80005b4e:	6a06                	ld	s4,64(sp)
    80005b50:	7ae2                	ld	s5,56(sp)
    80005b52:	7b42                	ld	s6,48(sp)
    80005b54:	7ba2                	ld	s7,40(sp)
    80005b56:	7c02                	ld	s8,32(sp)
    80005b58:	6ce2                	ld	s9,24(sp)
    80005b5a:	6d42                	ld	s10,16(sp)
    80005b5c:	6165                	addi	sp,sp,112
    80005b5e:	8082                	ret
      if(n < target){
    80005b60:	0009871b          	sext.w	a4,s3
    80005b64:	fb677ce3          	bgeu	a4,s6,80005b1c <consoleread+0xbc>
        cons.r--;
    80005b68:	0001b717          	auipc	a4,0x1b
    80005b6c:	66f72823          	sw	a5,1648(a4) # 800211d8 <cons+0x98>
    80005b70:	b775                	j	80005b1c <consoleread+0xbc>

0000000080005b72 <consputc>:
{
    80005b72:	1141                	addi	sp,sp,-16
    80005b74:	e406                	sd	ra,8(sp)
    80005b76:	e022                	sd	s0,0(sp)
    80005b78:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b7a:	10000793          	li	a5,256
    80005b7e:	00f50a63          	beq	a0,a5,80005b92 <consputc+0x20>
    uartputc_sync(c);
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	55e080e7          	jalr	1374(ra) # 800060e0 <uartputc_sync>
}
    80005b8a:	60a2                	ld	ra,8(sp)
    80005b8c:	6402                	ld	s0,0(sp)
    80005b8e:	0141                	addi	sp,sp,16
    80005b90:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b92:	4521                	li	a0,8
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	54c080e7          	jalr	1356(ra) # 800060e0 <uartputc_sync>
    80005b9c:	02000513          	li	a0,32
    80005ba0:	00000097          	auipc	ra,0x0
    80005ba4:	540080e7          	jalr	1344(ra) # 800060e0 <uartputc_sync>
    80005ba8:	4521                	li	a0,8
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	536080e7          	jalr	1334(ra) # 800060e0 <uartputc_sync>
    80005bb2:	bfe1                	j	80005b8a <consputc+0x18>

0000000080005bb4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bb4:	1101                	addi	sp,sp,-32
    80005bb6:	ec06                	sd	ra,24(sp)
    80005bb8:	e822                	sd	s0,16(sp)
    80005bba:	e426                	sd	s1,8(sp)
    80005bbc:	e04a                	sd	s2,0(sp)
    80005bbe:	1000                	addi	s0,sp,32
    80005bc0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bc2:	0001b517          	auipc	a0,0x1b
    80005bc6:	57e50513          	addi	a0,a0,1406 # 80021140 <cons>
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	7a6080e7          	jalr	1958(ra) # 80006370 <acquire>

  switch(c){
    80005bd2:	47d5                	li	a5,21
    80005bd4:	0af48663          	beq	s1,a5,80005c80 <consoleintr+0xcc>
    80005bd8:	0297ca63          	blt	a5,s1,80005c0c <consoleintr+0x58>
    80005bdc:	47a1                	li	a5,8
    80005bde:	0ef48763          	beq	s1,a5,80005ccc <consoleintr+0x118>
    80005be2:	47c1                	li	a5,16
    80005be4:	10f49a63          	bne	s1,a5,80005cf8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005be8:	ffffc097          	auipc	ra,0xffffc
    80005bec:	d6a080e7          	jalr	-662(ra) # 80001952 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bf0:	0001b517          	auipc	a0,0x1b
    80005bf4:	55050513          	addi	a0,a0,1360 # 80021140 <cons>
    80005bf8:	00001097          	auipc	ra,0x1
    80005bfc:	82c080e7          	jalr	-2004(ra) # 80006424 <release>
}
    80005c00:	60e2                	ld	ra,24(sp)
    80005c02:	6442                	ld	s0,16(sp)
    80005c04:	64a2                	ld	s1,8(sp)
    80005c06:	6902                	ld	s2,0(sp)
    80005c08:	6105                	addi	sp,sp,32
    80005c0a:	8082                	ret
  switch(c){
    80005c0c:	07f00793          	li	a5,127
    80005c10:	0af48e63          	beq	s1,a5,80005ccc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c14:	0001b717          	auipc	a4,0x1b
    80005c18:	52c70713          	addi	a4,a4,1324 # 80021140 <cons>
    80005c1c:	0a072783          	lw	a5,160(a4)
    80005c20:	09872703          	lw	a4,152(a4)
    80005c24:	9f99                	subw	a5,a5,a4
    80005c26:	07f00713          	li	a4,127
    80005c2a:	fcf763e3          	bltu	a4,a5,80005bf0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c2e:	47b5                	li	a5,13
    80005c30:	0cf48763          	beq	s1,a5,80005cfe <consoleintr+0x14a>
      consputc(c);
    80005c34:	8526                	mv	a0,s1
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	f3c080e7          	jalr	-196(ra) # 80005b72 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c3e:	0001b797          	auipc	a5,0x1b
    80005c42:	50278793          	addi	a5,a5,1282 # 80021140 <cons>
    80005c46:	0a07a703          	lw	a4,160(a5)
    80005c4a:	0017069b          	addiw	a3,a4,1
    80005c4e:	0006861b          	sext.w	a2,a3
    80005c52:	0ad7a023          	sw	a3,160(a5)
    80005c56:	07f77713          	andi	a4,a4,127
    80005c5a:	97ba                	add	a5,a5,a4
    80005c5c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c60:	47a9                	li	a5,10
    80005c62:	0cf48563          	beq	s1,a5,80005d2c <consoleintr+0x178>
    80005c66:	4791                	li	a5,4
    80005c68:	0cf48263          	beq	s1,a5,80005d2c <consoleintr+0x178>
    80005c6c:	0001b797          	auipc	a5,0x1b
    80005c70:	56c7a783          	lw	a5,1388(a5) # 800211d8 <cons+0x98>
    80005c74:	0807879b          	addiw	a5,a5,128
    80005c78:	f6f61ce3          	bne	a2,a5,80005bf0 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c7c:	863e                	mv	a2,a5
    80005c7e:	a07d                	j	80005d2c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c80:	0001b717          	auipc	a4,0x1b
    80005c84:	4c070713          	addi	a4,a4,1216 # 80021140 <cons>
    80005c88:	0a072783          	lw	a5,160(a4)
    80005c8c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c90:	0001b497          	auipc	s1,0x1b
    80005c94:	4b048493          	addi	s1,s1,1200 # 80021140 <cons>
    while(cons.e != cons.w &&
    80005c98:	4929                	li	s2,10
    80005c9a:	f4f70be3          	beq	a4,a5,80005bf0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c9e:	37fd                	addiw	a5,a5,-1
    80005ca0:	07f7f713          	andi	a4,a5,127
    80005ca4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ca6:	01874703          	lbu	a4,24(a4)
    80005caa:	f52703e3          	beq	a4,s2,80005bf0 <consoleintr+0x3c>
      cons.e--;
    80005cae:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cb2:	10000513          	li	a0,256
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	ebc080e7          	jalr	-324(ra) # 80005b72 <consputc>
    while(cons.e != cons.w &&
    80005cbe:	0a04a783          	lw	a5,160(s1)
    80005cc2:	09c4a703          	lw	a4,156(s1)
    80005cc6:	fcf71ce3          	bne	a4,a5,80005c9e <consoleintr+0xea>
    80005cca:	b71d                	j	80005bf0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ccc:	0001b717          	auipc	a4,0x1b
    80005cd0:	47470713          	addi	a4,a4,1140 # 80021140 <cons>
    80005cd4:	0a072783          	lw	a5,160(a4)
    80005cd8:	09c72703          	lw	a4,156(a4)
    80005cdc:	f0f70ae3          	beq	a4,a5,80005bf0 <consoleintr+0x3c>
      cons.e--;
    80005ce0:	37fd                	addiw	a5,a5,-1
    80005ce2:	0001b717          	auipc	a4,0x1b
    80005ce6:	4ef72f23          	sw	a5,1278(a4) # 800211e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cea:	10000513          	li	a0,256
    80005cee:	00000097          	auipc	ra,0x0
    80005cf2:	e84080e7          	jalr	-380(ra) # 80005b72 <consputc>
    80005cf6:	bded                	j	80005bf0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cf8:	ee048ce3          	beqz	s1,80005bf0 <consoleintr+0x3c>
    80005cfc:	bf21                	j	80005c14 <consoleintr+0x60>
      consputc(c);
    80005cfe:	4529                	li	a0,10
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	e72080e7          	jalr	-398(ra) # 80005b72 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d08:	0001b797          	auipc	a5,0x1b
    80005d0c:	43878793          	addi	a5,a5,1080 # 80021140 <cons>
    80005d10:	0a07a703          	lw	a4,160(a5)
    80005d14:	0017069b          	addiw	a3,a4,1
    80005d18:	0006861b          	sext.w	a2,a3
    80005d1c:	0ad7a023          	sw	a3,160(a5)
    80005d20:	07f77713          	andi	a4,a4,127
    80005d24:	97ba                	add	a5,a5,a4
    80005d26:	4729                	li	a4,10
    80005d28:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d2c:	0001b797          	auipc	a5,0x1b
    80005d30:	4ac7a823          	sw	a2,1200(a5) # 800211dc <cons+0x9c>
        wakeup(&cons.r);
    80005d34:	0001b517          	auipc	a0,0x1b
    80005d38:	4a450513          	addi	a0,a0,1188 # 800211d8 <cons+0x98>
    80005d3c:	ffffc097          	auipc	ra,0xffffc
    80005d40:	952080e7          	jalr	-1710(ra) # 8000168e <wakeup>
    80005d44:	b575                	j	80005bf0 <consoleintr+0x3c>

0000000080005d46 <consoleinit>:

void
consoleinit(void)
{
    80005d46:	1141                	addi	sp,sp,-16
    80005d48:	e406                	sd	ra,8(sp)
    80005d4a:	e022                	sd	s0,0(sp)
    80005d4c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d4e:	00003597          	auipc	a1,0x3
    80005d52:	a4a58593          	addi	a1,a1,-1462 # 80008798 <syscalls+0x3d0>
    80005d56:	0001b517          	auipc	a0,0x1b
    80005d5a:	3ea50513          	addi	a0,a0,1002 # 80021140 <cons>
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	582080e7          	jalr	1410(ra) # 800062e0 <initlock>

  uartinit();
    80005d66:	00000097          	auipc	ra,0x0
    80005d6a:	32a080e7          	jalr	810(ra) # 80006090 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d6e:	0000e797          	auipc	a5,0xe
    80005d72:	76a78793          	addi	a5,a5,1898 # 800144d8 <devsw>
    80005d76:	00000717          	auipc	a4,0x0
    80005d7a:	cea70713          	addi	a4,a4,-790 # 80005a60 <consoleread>
    80005d7e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d80:	00000717          	auipc	a4,0x0
    80005d84:	c7e70713          	addi	a4,a4,-898 # 800059fe <consolewrite>
    80005d88:	ef98                	sd	a4,24(a5)
}
    80005d8a:	60a2                	ld	ra,8(sp)
    80005d8c:	6402                	ld	s0,0(sp)
    80005d8e:	0141                	addi	sp,sp,16
    80005d90:	8082                	ret

0000000080005d92 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d92:	7179                	addi	sp,sp,-48
    80005d94:	f406                	sd	ra,40(sp)
    80005d96:	f022                	sd	s0,32(sp)
    80005d98:	ec26                	sd	s1,24(sp)
    80005d9a:	e84a                	sd	s2,16(sp)
    80005d9c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d9e:	c219                	beqz	a2,80005da4 <printint+0x12>
    80005da0:	08054663          	bltz	a0,80005e2c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005da4:	2501                	sext.w	a0,a0
    80005da6:	4881                	li	a7,0
    80005da8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dac:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dae:	2581                	sext.w	a1,a1
    80005db0:	00003617          	auipc	a2,0x3
    80005db4:	a1860613          	addi	a2,a2,-1512 # 800087c8 <digits>
    80005db8:	883a                	mv	a6,a4
    80005dba:	2705                	addiw	a4,a4,1
    80005dbc:	02b577bb          	remuw	a5,a0,a1
    80005dc0:	1782                	slli	a5,a5,0x20
    80005dc2:	9381                	srli	a5,a5,0x20
    80005dc4:	97b2                	add	a5,a5,a2
    80005dc6:	0007c783          	lbu	a5,0(a5)
    80005dca:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dce:	0005079b          	sext.w	a5,a0
    80005dd2:	02b5553b          	divuw	a0,a0,a1
    80005dd6:	0685                	addi	a3,a3,1
    80005dd8:	feb7f0e3          	bgeu	a5,a1,80005db8 <printint+0x26>

  if(sign)
    80005ddc:	00088b63          	beqz	a7,80005df2 <printint+0x60>
    buf[i++] = '-';
    80005de0:	fe040793          	addi	a5,s0,-32
    80005de4:	973e                	add	a4,a4,a5
    80005de6:	02d00793          	li	a5,45
    80005dea:	fef70823          	sb	a5,-16(a4)
    80005dee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005df2:	02e05763          	blez	a4,80005e20 <printint+0x8e>
    80005df6:	fd040793          	addi	a5,s0,-48
    80005dfa:	00e784b3          	add	s1,a5,a4
    80005dfe:	fff78913          	addi	s2,a5,-1
    80005e02:	993a                	add	s2,s2,a4
    80005e04:	377d                	addiw	a4,a4,-1
    80005e06:	1702                	slli	a4,a4,0x20
    80005e08:	9301                	srli	a4,a4,0x20
    80005e0a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e0e:	fff4c503          	lbu	a0,-1(s1)
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	d60080e7          	jalr	-672(ra) # 80005b72 <consputc>
  while(--i >= 0)
    80005e1a:	14fd                	addi	s1,s1,-1
    80005e1c:	ff2499e3          	bne	s1,s2,80005e0e <printint+0x7c>
}
    80005e20:	70a2                	ld	ra,40(sp)
    80005e22:	7402                	ld	s0,32(sp)
    80005e24:	64e2                	ld	s1,24(sp)
    80005e26:	6942                	ld	s2,16(sp)
    80005e28:	6145                	addi	sp,sp,48
    80005e2a:	8082                	ret
    x = -xx;
    80005e2c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e30:	4885                	li	a7,1
    x = -xx;
    80005e32:	bf9d                	j	80005da8 <printint+0x16>

0000000080005e34 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e34:	1101                	addi	sp,sp,-32
    80005e36:	ec06                	sd	ra,24(sp)
    80005e38:	e822                	sd	s0,16(sp)
    80005e3a:	e426                	sd	s1,8(sp)
    80005e3c:	1000                	addi	s0,sp,32
    80005e3e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e40:	0001b797          	auipc	a5,0x1b
    80005e44:	3c07a023          	sw	zero,960(a5) # 80021200 <pr+0x18>
  printf("panic: ");
    80005e48:	00003517          	auipc	a0,0x3
    80005e4c:	95850513          	addi	a0,a0,-1704 # 800087a0 <syscalls+0x3d8>
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	02e080e7          	jalr	46(ra) # 80005e7e <printf>
  printf(s);
    80005e58:	8526                	mv	a0,s1
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	024080e7          	jalr	36(ra) # 80005e7e <printf>
  printf("\n");
    80005e62:	00002517          	auipc	a0,0x2
    80005e66:	1e650513          	addi	a0,a0,486 # 80008048 <etext+0x48>
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	014080e7          	jalr	20(ra) # 80005e7e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e72:	4785                	li	a5,1
    80005e74:	00003717          	auipc	a4,0x3
    80005e78:	1af72423          	sw	a5,424(a4) # 8000901c <panicked>
  for(;;)
    80005e7c:	a001                	j	80005e7c <panic+0x48>

0000000080005e7e <printf>:
{
    80005e7e:	7131                	addi	sp,sp,-192
    80005e80:	fc86                	sd	ra,120(sp)
    80005e82:	f8a2                	sd	s0,112(sp)
    80005e84:	f4a6                	sd	s1,104(sp)
    80005e86:	f0ca                	sd	s2,96(sp)
    80005e88:	ecce                	sd	s3,88(sp)
    80005e8a:	e8d2                	sd	s4,80(sp)
    80005e8c:	e4d6                	sd	s5,72(sp)
    80005e8e:	e0da                	sd	s6,64(sp)
    80005e90:	fc5e                	sd	s7,56(sp)
    80005e92:	f862                	sd	s8,48(sp)
    80005e94:	f466                	sd	s9,40(sp)
    80005e96:	f06a                	sd	s10,32(sp)
    80005e98:	ec6e                	sd	s11,24(sp)
    80005e9a:	0100                	addi	s0,sp,128
    80005e9c:	8a2a                	mv	s4,a0
    80005e9e:	e40c                	sd	a1,8(s0)
    80005ea0:	e810                	sd	a2,16(s0)
    80005ea2:	ec14                	sd	a3,24(s0)
    80005ea4:	f018                	sd	a4,32(s0)
    80005ea6:	f41c                	sd	a5,40(s0)
    80005ea8:	03043823          	sd	a6,48(s0)
    80005eac:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005eb0:	0001bd97          	auipc	s11,0x1b
    80005eb4:	350dad83          	lw	s11,848(s11) # 80021200 <pr+0x18>
  if(locking)
    80005eb8:	020d9b63          	bnez	s11,80005eee <printf+0x70>
  if (fmt == 0)
    80005ebc:	040a0263          	beqz	s4,80005f00 <printf+0x82>
  va_start(ap, fmt);
    80005ec0:	00840793          	addi	a5,s0,8
    80005ec4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ec8:	000a4503          	lbu	a0,0(s4)
    80005ecc:	14050f63          	beqz	a0,8000602a <printf+0x1ac>
    80005ed0:	4981                	li	s3,0
    if(c != '%'){
    80005ed2:	02500a93          	li	s5,37
    switch(c){
    80005ed6:	07000b93          	li	s7,112
  consputc('x');
    80005eda:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005edc:	00003b17          	auipc	s6,0x3
    80005ee0:	8ecb0b13          	addi	s6,s6,-1812 # 800087c8 <digits>
    switch(c){
    80005ee4:	07300c93          	li	s9,115
    80005ee8:	06400c13          	li	s8,100
    80005eec:	a82d                	j	80005f26 <printf+0xa8>
    acquire(&pr.lock);
    80005eee:	0001b517          	auipc	a0,0x1b
    80005ef2:	2fa50513          	addi	a0,a0,762 # 800211e8 <pr>
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	47a080e7          	jalr	1146(ra) # 80006370 <acquire>
    80005efe:	bf7d                	j	80005ebc <printf+0x3e>
    panic("null fmt");
    80005f00:	00003517          	auipc	a0,0x3
    80005f04:	8b050513          	addi	a0,a0,-1872 # 800087b0 <syscalls+0x3e8>
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	f2c080e7          	jalr	-212(ra) # 80005e34 <panic>
      consputc(c);
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	c62080e7          	jalr	-926(ra) # 80005b72 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f18:	2985                	addiw	s3,s3,1
    80005f1a:	013a07b3          	add	a5,s4,s3
    80005f1e:	0007c503          	lbu	a0,0(a5)
    80005f22:	10050463          	beqz	a0,8000602a <printf+0x1ac>
    if(c != '%'){
    80005f26:	ff5515e3          	bne	a0,s5,80005f10 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f2a:	2985                	addiw	s3,s3,1
    80005f2c:	013a07b3          	add	a5,s4,s3
    80005f30:	0007c783          	lbu	a5,0(a5)
    80005f34:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f38:	cbed                	beqz	a5,8000602a <printf+0x1ac>
    switch(c){
    80005f3a:	05778a63          	beq	a5,s7,80005f8e <printf+0x110>
    80005f3e:	02fbf663          	bgeu	s7,a5,80005f6a <printf+0xec>
    80005f42:	09978863          	beq	a5,s9,80005fd2 <printf+0x154>
    80005f46:	07800713          	li	a4,120
    80005f4a:	0ce79563          	bne	a5,a4,80006014 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f4e:	f8843783          	ld	a5,-120(s0)
    80005f52:	00878713          	addi	a4,a5,8
    80005f56:	f8e43423          	sd	a4,-120(s0)
    80005f5a:	4605                	li	a2,1
    80005f5c:	85ea                	mv	a1,s10
    80005f5e:	4388                	lw	a0,0(a5)
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	e32080e7          	jalr	-462(ra) # 80005d92 <printint>
      break;
    80005f68:	bf45                	j	80005f18 <printf+0x9a>
    switch(c){
    80005f6a:	09578f63          	beq	a5,s5,80006008 <printf+0x18a>
    80005f6e:	0b879363          	bne	a5,s8,80006014 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f72:	f8843783          	ld	a5,-120(s0)
    80005f76:	00878713          	addi	a4,a5,8
    80005f7a:	f8e43423          	sd	a4,-120(s0)
    80005f7e:	4605                	li	a2,1
    80005f80:	45a9                	li	a1,10
    80005f82:	4388                	lw	a0,0(a5)
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	e0e080e7          	jalr	-498(ra) # 80005d92 <printint>
      break;
    80005f8c:	b771                	j	80005f18 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f8e:	f8843783          	ld	a5,-120(s0)
    80005f92:	00878713          	addi	a4,a5,8
    80005f96:	f8e43423          	sd	a4,-120(s0)
    80005f9a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f9e:	03000513          	li	a0,48
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	bd0080e7          	jalr	-1072(ra) # 80005b72 <consputc>
  consputc('x');
    80005faa:	07800513          	li	a0,120
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	bc4080e7          	jalr	-1084(ra) # 80005b72 <consputc>
    80005fb6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fb8:	03c95793          	srli	a5,s2,0x3c
    80005fbc:	97da                	add	a5,a5,s6
    80005fbe:	0007c503          	lbu	a0,0(a5)
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	bb0080e7          	jalr	-1104(ra) # 80005b72 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fca:	0912                	slli	s2,s2,0x4
    80005fcc:	34fd                	addiw	s1,s1,-1
    80005fce:	f4ed                	bnez	s1,80005fb8 <printf+0x13a>
    80005fd0:	b7a1                	j	80005f18 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fd2:	f8843783          	ld	a5,-120(s0)
    80005fd6:	00878713          	addi	a4,a5,8
    80005fda:	f8e43423          	sd	a4,-120(s0)
    80005fde:	6384                	ld	s1,0(a5)
    80005fe0:	cc89                	beqz	s1,80005ffa <printf+0x17c>
      for(; *s; s++)
    80005fe2:	0004c503          	lbu	a0,0(s1)
    80005fe6:	d90d                	beqz	a0,80005f18 <printf+0x9a>
        consputc(*s);
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	b8a080e7          	jalr	-1142(ra) # 80005b72 <consputc>
      for(; *s; s++)
    80005ff0:	0485                	addi	s1,s1,1
    80005ff2:	0004c503          	lbu	a0,0(s1)
    80005ff6:	f96d                	bnez	a0,80005fe8 <printf+0x16a>
    80005ff8:	b705                	j	80005f18 <printf+0x9a>
        s = "(null)";
    80005ffa:	00002497          	auipc	s1,0x2
    80005ffe:	7ae48493          	addi	s1,s1,1966 # 800087a8 <syscalls+0x3e0>
      for(; *s; s++)
    80006002:	02800513          	li	a0,40
    80006006:	b7cd                	j	80005fe8 <printf+0x16a>
      consputc('%');
    80006008:	8556                	mv	a0,s5
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	b68080e7          	jalr	-1176(ra) # 80005b72 <consputc>
      break;
    80006012:	b719                	j	80005f18 <printf+0x9a>
      consputc('%');
    80006014:	8556                	mv	a0,s5
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	b5c080e7          	jalr	-1188(ra) # 80005b72 <consputc>
      consputc(c);
    8000601e:	8526                	mv	a0,s1
    80006020:	00000097          	auipc	ra,0x0
    80006024:	b52080e7          	jalr	-1198(ra) # 80005b72 <consputc>
      break;
    80006028:	bdc5                	j	80005f18 <printf+0x9a>
  if(locking)
    8000602a:	020d9163          	bnez	s11,8000604c <printf+0x1ce>
}
    8000602e:	70e6                	ld	ra,120(sp)
    80006030:	7446                	ld	s0,112(sp)
    80006032:	74a6                	ld	s1,104(sp)
    80006034:	7906                	ld	s2,96(sp)
    80006036:	69e6                	ld	s3,88(sp)
    80006038:	6a46                	ld	s4,80(sp)
    8000603a:	6aa6                	ld	s5,72(sp)
    8000603c:	6b06                	ld	s6,64(sp)
    8000603e:	7be2                	ld	s7,56(sp)
    80006040:	7c42                	ld	s8,48(sp)
    80006042:	7ca2                	ld	s9,40(sp)
    80006044:	7d02                	ld	s10,32(sp)
    80006046:	6de2                	ld	s11,24(sp)
    80006048:	6129                	addi	sp,sp,192
    8000604a:	8082                	ret
    release(&pr.lock);
    8000604c:	0001b517          	auipc	a0,0x1b
    80006050:	19c50513          	addi	a0,a0,412 # 800211e8 <pr>
    80006054:	00000097          	auipc	ra,0x0
    80006058:	3d0080e7          	jalr	976(ra) # 80006424 <release>
}
    8000605c:	bfc9                	j	8000602e <printf+0x1b0>

000000008000605e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000605e:	1101                	addi	sp,sp,-32
    80006060:	ec06                	sd	ra,24(sp)
    80006062:	e822                	sd	s0,16(sp)
    80006064:	e426                	sd	s1,8(sp)
    80006066:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006068:	0001b497          	auipc	s1,0x1b
    8000606c:	18048493          	addi	s1,s1,384 # 800211e8 <pr>
    80006070:	00002597          	auipc	a1,0x2
    80006074:	75058593          	addi	a1,a1,1872 # 800087c0 <syscalls+0x3f8>
    80006078:	8526                	mv	a0,s1
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	266080e7          	jalr	614(ra) # 800062e0 <initlock>
  pr.locking = 1;
    80006082:	4785                	li	a5,1
    80006084:	cc9c                	sw	a5,24(s1)
}
    80006086:	60e2                	ld	ra,24(sp)
    80006088:	6442                	ld	s0,16(sp)
    8000608a:	64a2                	ld	s1,8(sp)
    8000608c:	6105                	addi	sp,sp,32
    8000608e:	8082                	ret

0000000080006090 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006090:	1141                	addi	sp,sp,-16
    80006092:	e406                	sd	ra,8(sp)
    80006094:	e022                	sd	s0,0(sp)
    80006096:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006098:	100007b7          	lui	a5,0x10000
    8000609c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060a0:	f8000713          	li	a4,-128
    800060a4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060a8:	470d                	li	a4,3
    800060aa:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060ae:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060b2:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060b6:	469d                	li	a3,7
    800060b8:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060bc:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060c0:	00002597          	auipc	a1,0x2
    800060c4:	72058593          	addi	a1,a1,1824 # 800087e0 <digits+0x18>
    800060c8:	0001b517          	auipc	a0,0x1b
    800060cc:	14050513          	addi	a0,a0,320 # 80021208 <uart_tx_lock>
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	210080e7          	jalr	528(ra) # 800062e0 <initlock>
}
    800060d8:	60a2                	ld	ra,8(sp)
    800060da:	6402                	ld	s0,0(sp)
    800060dc:	0141                	addi	sp,sp,16
    800060de:	8082                	ret

00000000800060e0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060e0:	1101                	addi	sp,sp,-32
    800060e2:	ec06                	sd	ra,24(sp)
    800060e4:	e822                	sd	s0,16(sp)
    800060e6:	e426                	sd	s1,8(sp)
    800060e8:	1000                	addi	s0,sp,32
    800060ea:	84aa                	mv	s1,a0
  push_off();
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	238080e7          	jalr	568(ra) # 80006324 <push_off>

  if(panicked){
    800060f4:	00003797          	auipc	a5,0x3
    800060f8:	f287a783          	lw	a5,-216(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060fc:	10000737          	lui	a4,0x10000
  if(panicked){
    80006100:	c391                	beqz	a5,80006104 <uartputc_sync+0x24>
    for(;;)
    80006102:	a001                	j	80006102 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006104:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006108:	0207f793          	andi	a5,a5,32
    8000610c:	dfe5                	beqz	a5,80006104 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000610e:	0ff4f513          	andi	a0,s1,255
    80006112:	100007b7          	lui	a5,0x10000
    80006116:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	2aa080e7          	jalr	682(ra) # 800063c4 <pop_off>
}
    80006122:	60e2                	ld	ra,24(sp)
    80006124:	6442                	ld	s0,16(sp)
    80006126:	64a2                	ld	s1,8(sp)
    80006128:	6105                	addi	sp,sp,32
    8000612a:	8082                	ret

000000008000612c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000612c:	00003797          	auipc	a5,0x3
    80006130:	ef47b783          	ld	a5,-268(a5) # 80009020 <uart_tx_r>
    80006134:	00003717          	auipc	a4,0x3
    80006138:	ef473703          	ld	a4,-268(a4) # 80009028 <uart_tx_w>
    8000613c:	06f70a63          	beq	a4,a5,800061b0 <uartstart+0x84>
{
    80006140:	7139                	addi	sp,sp,-64
    80006142:	fc06                	sd	ra,56(sp)
    80006144:	f822                	sd	s0,48(sp)
    80006146:	f426                	sd	s1,40(sp)
    80006148:	f04a                	sd	s2,32(sp)
    8000614a:	ec4e                	sd	s3,24(sp)
    8000614c:	e852                	sd	s4,16(sp)
    8000614e:	e456                	sd	s5,8(sp)
    80006150:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006152:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006156:	0001ba17          	auipc	s4,0x1b
    8000615a:	0b2a0a13          	addi	s4,s4,178 # 80021208 <uart_tx_lock>
    uart_tx_r += 1;
    8000615e:	00003497          	auipc	s1,0x3
    80006162:	ec248493          	addi	s1,s1,-318 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006166:	00003997          	auipc	s3,0x3
    8000616a:	ec298993          	addi	s3,s3,-318 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000616e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006172:	02077713          	andi	a4,a4,32
    80006176:	c705                	beqz	a4,8000619e <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006178:	01f7f713          	andi	a4,a5,31
    8000617c:	9752                	add	a4,a4,s4
    8000617e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006182:	0785                	addi	a5,a5,1
    80006184:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006186:	8526                	mv	a0,s1
    80006188:	ffffb097          	auipc	ra,0xffffb
    8000618c:	506080e7          	jalr	1286(ra) # 8000168e <wakeup>
    
    WriteReg(THR, c);
    80006190:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006194:	609c                	ld	a5,0(s1)
    80006196:	0009b703          	ld	a4,0(s3)
    8000619a:	fcf71ae3          	bne	a4,a5,8000616e <uartstart+0x42>
  }
}
    8000619e:	70e2                	ld	ra,56(sp)
    800061a0:	7442                	ld	s0,48(sp)
    800061a2:	74a2                	ld	s1,40(sp)
    800061a4:	7902                	ld	s2,32(sp)
    800061a6:	69e2                	ld	s3,24(sp)
    800061a8:	6a42                	ld	s4,16(sp)
    800061aa:	6aa2                	ld	s5,8(sp)
    800061ac:	6121                	addi	sp,sp,64
    800061ae:	8082                	ret
    800061b0:	8082                	ret

00000000800061b2 <uartputc>:
{
    800061b2:	7179                	addi	sp,sp,-48
    800061b4:	f406                	sd	ra,40(sp)
    800061b6:	f022                	sd	s0,32(sp)
    800061b8:	ec26                	sd	s1,24(sp)
    800061ba:	e84a                	sd	s2,16(sp)
    800061bc:	e44e                	sd	s3,8(sp)
    800061be:	e052                	sd	s4,0(sp)
    800061c0:	1800                	addi	s0,sp,48
    800061c2:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061c4:	0001b517          	auipc	a0,0x1b
    800061c8:	04450513          	addi	a0,a0,68 # 80021208 <uart_tx_lock>
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	1a4080e7          	jalr	420(ra) # 80006370 <acquire>
  if(panicked){
    800061d4:	00003797          	auipc	a5,0x3
    800061d8:	e487a783          	lw	a5,-440(a5) # 8000901c <panicked>
    800061dc:	c391                	beqz	a5,800061e0 <uartputc+0x2e>
    for(;;)
    800061de:	a001                	j	800061de <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e0:	00003717          	auipc	a4,0x3
    800061e4:	e4873703          	ld	a4,-440(a4) # 80009028 <uart_tx_w>
    800061e8:	00003797          	auipc	a5,0x3
    800061ec:	e387b783          	ld	a5,-456(a5) # 80009020 <uart_tx_r>
    800061f0:	02078793          	addi	a5,a5,32
    800061f4:	02e79b63          	bne	a5,a4,8000622a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061f8:	0001b997          	auipc	s3,0x1b
    800061fc:	01098993          	addi	s3,s3,16 # 80021208 <uart_tx_lock>
    80006200:	00003497          	auipc	s1,0x3
    80006204:	e2048493          	addi	s1,s1,-480 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006208:	00003917          	auipc	s2,0x3
    8000620c:	e2090913          	addi	s2,s2,-480 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006210:	85ce                	mv	a1,s3
    80006212:	8526                	mv	a0,s1
    80006214:	ffffb097          	auipc	ra,0xffffb
    80006218:	2ee080e7          	jalr	750(ra) # 80001502 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000621c:	00093703          	ld	a4,0(s2)
    80006220:	609c                	ld	a5,0(s1)
    80006222:	02078793          	addi	a5,a5,32
    80006226:	fee785e3          	beq	a5,a4,80006210 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000622a:	0001b497          	auipc	s1,0x1b
    8000622e:	fde48493          	addi	s1,s1,-34 # 80021208 <uart_tx_lock>
    80006232:	01f77793          	andi	a5,a4,31
    80006236:	97a6                	add	a5,a5,s1
    80006238:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000623c:	0705                	addi	a4,a4,1
    8000623e:	00003797          	auipc	a5,0x3
    80006242:	dee7b523          	sd	a4,-534(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006246:	00000097          	auipc	ra,0x0
    8000624a:	ee6080e7          	jalr	-282(ra) # 8000612c <uartstart>
      release(&uart_tx_lock);
    8000624e:	8526                	mv	a0,s1
    80006250:	00000097          	auipc	ra,0x0
    80006254:	1d4080e7          	jalr	468(ra) # 80006424 <release>
}
    80006258:	70a2                	ld	ra,40(sp)
    8000625a:	7402                	ld	s0,32(sp)
    8000625c:	64e2                	ld	s1,24(sp)
    8000625e:	6942                	ld	s2,16(sp)
    80006260:	69a2                	ld	s3,8(sp)
    80006262:	6a02                	ld	s4,0(sp)
    80006264:	6145                	addi	sp,sp,48
    80006266:	8082                	ret

0000000080006268 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006268:	1141                	addi	sp,sp,-16
    8000626a:	e422                	sd	s0,8(sp)
    8000626c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000626e:	100007b7          	lui	a5,0x10000
    80006272:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006276:	8b85                	andi	a5,a5,1
    80006278:	cb91                	beqz	a5,8000628c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000627a:	100007b7          	lui	a5,0x10000
    8000627e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006282:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006286:	6422                	ld	s0,8(sp)
    80006288:	0141                	addi	sp,sp,16
    8000628a:	8082                	ret
    return -1;
    8000628c:	557d                	li	a0,-1
    8000628e:	bfe5                	j	80006286 <uartgetc+0x1e>

0000000080006290 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006290:	1101                	addi	sp,sp,-32
    80006292:	ec06                	sd	ra,24(sp)
    80006294:	e822                	sd	s0,16(sp)
    80006296:	e426                	sd	s1,8(sp)
    80006298:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000629a:	54fd                	li	s1,-1
    8000629c:	a029                	j	800062a6 <uartintr+0x16>
      break;
    consoleintr(c);
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	916080e7          	jalr	-1770(ra) # 80005bb4 <consoleintr>
    int c = uartgetc();
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	fc2080e7          	jalr	-62(ra) # 80006268 <uartgetc>
    if(c == -1)
    800062ae:	fe9518e3          	bne	a0,s1,8000629e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062b2:	0001b497          	auipc	s1,0x1b
    800062b6:	f5648493          	addi	s1,s1,-170 # 80021208 <uart_tx_lock>
    800062ba:	8526                	mv	a0,s1
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	0b4080e7          	jalr	180(ra) # 80006370 <acquire>
  uartstart();
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	e68080e7          	jalr	-408(ra) # 8000612c <uartstart>
  release(&uart_tx_lock);
    800062cc:	8526                	mv	a0,s1
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	156080e7          	jalr	342(ra) # 80006424 <release>
}
    800062d6:	60e2                	ld	ra,24(sp)
    800062d8:	6442                	ld	s0,16(sp)
    800062da:	64a2                	ld	s1,8(sp)
    800062dc:	6105                	addi	sp,sp,32
    800062de:	8082                	ret

00000000800062e0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062e0:	1141                	addi	sp,sp,-16
    800062e2:	e422                	sd	s0,8(sp)
    800062e4:	0800                	addi	s0,sp,16
  lk->name = name;
    800062e6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062e8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062ec:	00053823          	sd	zero,16(a0)
}
    800062f0:	6422                	ld	s0,8(sp)
    800062f2:	0141                	addi	sp,sp,16
    800062f4:	8082                	ret

00000000800062f6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062f6:	411c                	lw	a5,0(a0)
    800062f8:	e399                	bnez	a5,800062fe <holding+0x8>
    800062fa:	4501                	li	a0,0
  return r;
}
    800062fc:	8082                	ret
{
    800062fe:	1101                	addi	sp,sp,-32
    80006300:	ec06                	sd	ra,24(sp)
    80006302:	e822                	sd	s0,16(sp)
    80006304:	e426                	sd	s1,8(sp)
    80006306:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006308:	6904                	ld	s1,16(a0)
    8000630a:	ffffb097          	auipc	ra,0xffffb
    8000630e:	b1c080e7          	jalr	-1252(ra) # 80000e26 <mycpu>
    80006312:	40a48533          	sub	a0,s1,a0
    80006316:	00153513          	seqz	a0,a0
}
    8000631a:	60e2                	ld	ra,24(sp)
    8000631c:	6442                	ld	s0,16(sp)
    8000631e:	64a2                	ld	s1,8(sp)
    80006320:	6105                	addi	sp,sp,32
    80006322:	8082                	ret

0000000080006324 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006324:	1101                	addi	sp,sp,-32
    80006326:	ec06                	sd	ra,24(sp)
    80006328:	e822                	sd	s0,16(sp)
    8000632a:	e426                	sd	s1,8(sp)
    8000632c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000632e:	100024f3          	csrr	s1,sstatus
    80006332:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006336:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006338:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000633c:	ffffb097          	auipc	ra,0xffffb
    80006340:	aea080e7          	jalr	-1302(ra) # 80000e26 <mycpu>
    80006344:	5d3c                	lw	a5,120(a0)
    80006346:	cf89                	beqz	a5,80006360 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006348:	ffffb097          	auipc	ra,0xffffb
    8000634c:	ade080e7          	jalr	-1314(ra) # 80000e26 <mycpu>
    80006350:	5d3c                	lw	a5,120(a0)
    80006352:	2785                	addiw	a5,a5,1
    80006354:	dd3c                	sw	a5,120(a0)
}
    80006356:	60e2                	ld	ra,24(sp)
    80006358:	6442                	ld	s0,16(sp)
    8000635a:	64a2                	ld	s1,8(sp)
    8000635c:	6105                	addi	sp,sp,32
    8000635e:	8082                	ret
    mycpu()->intena = old;
    80006360:	ffffb097          	auipc	ra,0xffffb
    80006364:	ac6080e7          	jalr	-1338(ra) # 80000e26 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006368:	8085                	srli	s1,s1,0x1
    8000636a:	8885                	andi	s1,s1,1
    8000636c:	dd64                	sw	s1,124(a0)
    8000636e:	bfe9                	j	80006348 <push_off+0x24>

0000000080006370 <acquire>:
{
    80006370:	1101                	addi	sp,sp,-32
    80006372:	ec06                	sd	ra,24(sp)
    80006374:	e822                	sd	s0,16(sp)
    80006376:	e426                	sd	s1,8(sp)
    80006378:	1000                	addi	s0,sp,32
    8000637a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	fa8080e7          	jalr	-88(ra) # 80006324 <push_off>
  if(holding(lk))
    80006384:	8526                	mv	a0,s1
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	f70080e7          	jalr	-144(ra) # 800062f6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000638e:	4705                	li	a4,1
  if(holding(lk))
    80006390:	e115                	bnez	a0,800063b4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006392:	87ba                	mv	a5,a4
    80006394:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006398:	2781                	sext.w	a5,a5
    8000639a:	ffe5                	bnez	a5,80006392 <acquire+0x22>
  __sync_synchronize();
    8000639c:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063a0:	ffffb097          	auipc	ra,0xffffb
    800063a4:	a86080e7          	jalr	-1402(ra) # 80000e26 <mycpu>
    800063a8:	e888                	sd	a0,16(s1)
}
    800063aa:	60e2                	ld	ra,24(sp)
    800063ac:	6442                	ld	s0,16(sp)
    800063ae:	64a2                	ld	s1,8(sp)
    800063b0:	6105                	addi	sp,sp,32
    800063b2:	8082                	ret
    panic("acquire");
    800063b4:	00002517          	auipc	a0,0x2
    800063b8:	43450513          	addi	a0,a0,1076 # 800087e8 <digits+0x20>
    800063bc:	00000097          	auipc	ra,0x0
    800063c0:	a78080e7          	jalr	-1416(ra) # 80005e34 <panic>

00000000800063c4 <pop_off>:

void
pop_off(void)
{
    800063c4:	1141                	addi	sp,sp,-16
    800063c6:	e406                	sd	ra,8(sp)
    800063c8:	e022                	sd	s0,0(sp)
    800063ca:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	a5a080e7          	jalr	-1446(ra) # 80000e26 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063d8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063da:	e78d                	bnez	a5,80006404 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063dc:	5d3c                	lw	a5,120(a0)
    800063de:	02f05b63          	blez	a5,80006414 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063e2:	37fd                	addiw	a5,a5,-1
    800063e4:	0007871b          	sext.w	a4,a5
    800063e8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063ea:	eb09                	bnez	a4,800063fc <pop_off+0x38>
    800063ec:	5d7c                	lw	a5,124(a0)
    800063ee:	c799                	beqz	a5,800063fc <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063f8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063fc:	60a2                	ld	ra,8(sp)
    800063fe:	6402                	ld	s0,0(sp)
    80006400:	0141                	addi	sp,sp,16
    80006402:	8082                	ret
    panic("pop_off - interruptible");
    80006404:	00002517          	auipc	a0,0x2
    80006408:	3ec50513          	addi	a0,a0,1004 # 800087f0 <digits+0x28>
    8000640c:	00000097          	auipc	ra,0x0
    80006410:	a28080e7          	jalr	-1496(ra) # 80005e34 <panic>
    panic("pop_off");
    80006414:	00002517          	auipc	a0,0x2
    80006418:	3f450513          	addi	a0,a0,1012 # 80008808 <digits+0x40>
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	a18080e7          	jalr	-1512(ra) # 80005e34 <panic>

0000000080006424 <release>:
{
    80006424:	1101                	addi	sp,sp,-32
    80006426:	ec06                	sd	ra,24(sp)
    80006428:	e822                	sd	s0,16(sp)
    8000642a:	e426                	sd	s1,8(sp)
    8000642c:	1000                	addi	s0,sp,32
    8000642e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006430:	00000097          	auipc	ra,0x0
    80006434:	ec6080e7          	jalr	-314(ra) # 800062f6 <holding>
    80006438:	c115                	beqz	a0,8000645c <release+0x38>
  lk->cpu = 0;
    8000643a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000643e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006442:	0f50000f          	fence	iorw,ow
    80006446:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	f7a080e7          	jalr	-134(ra) # 800063c4 <pop_off>
}
    80006452:	60e2                	ld	ra,24(sp)
    80006454:	6442                	ld	s0,16(sp)
    80006456:	64a2                	ld	s1,8(sp)
    80006458:	6105                	addi	sp,sp,32
    8000645a:	8082                	ret
    panic("release");
    8000645c:	00002517          	auipc	a0,0x2
    80006460:	3b450513          	addi	a0,a0,948 # 80008810 <digits+0x48>
    80006464:	00000097          	auipc	ra,0x0
    80006468:	9d0080e7          	jalr	-1584(ra) # 80005e34 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
