
#define ARRLEN(ptr)        (ptr ? ((uint16_t*)ptr)[-1] : 0)
#define SETARRLEN(ptr,len) ((uint16_t*)ptr)[-1]=len 

// Get a pointer to the *start* of the thing (the pointer to free)
#define ARRPTR(ptr)        (((uint16_t*)ptr)-1)

#define wserror(str) call Leds.led0On()

// This seems insane to me, but the memcpy implementation on Telos
// doesn't work for unaligned addresses!  Here's a hack:
void my_memcpy(void* dst, const void* src, size_t num) {
  int s = (int)src;
  int d = (int)dst;
  //ASSERT num > 0

  // Alligned version:  
  if (!(d & 1) && !(s & 1)) 
    memcpy(dst,src,num);
  // Both unaligned:
  else if ((d & 1) && (s & 1)) {
    ((char*)dst)[0] = ((char*)src)[0];
    memcpy(dst+1,src+1,num-1);
    // Do we need to handle the tail specially also?
  } else {
    int i;  
    for (i=0; i<num; i++) ((char*)dst)[i] = ((char*)src)[i];
  }
}

/* // [2007.12.06] This is the header that goes with my new C backend. -Ryan */

/* // Headers that we need for the generated code: */
/* #include<stdio.h> */
/* #include<stdlib.h> */
/* #include<string.h> */
/* #include<complex.h> */
/* #include<math.h> */
/* #include <time.h> */
/* #include <sys/time.h> */
/* #include <sys/resource.h> */


/* //int* arrayMake(size_t size, int len, ) { } */

/* #define TRUE  1 */
/* #define FALSE 0 */

/* // Handle Cons Cell memory layout: */
/* #define CONSCELL(ty)   ((int*)malloc(2 * sizeof(void*) + sizeof(ty)) + 2); */
/* #define CAR(ptr)       (*ptr) */
/* #define CDR(ptr)       (((void**)ptr)[-2]) */
/* #define SETCDR(ptr,tl) (((void**)ptr)[-2])=tl */
/* #define SETCAR(ptr,hd) ptr[0]=hd */

/* // Handle Array memory layout: */
/* #define ARRLEN(ptr)        (ptr ? ((int*)ptr)[-2] : 0) */
/* //#define ARRLEN(ptr)        ((int*)ptr)[-2] */
/* // This should not be used on a null pointer: */

/* // Handle RCs on Cons Cells and Arrays: */
/* #define CLEAR_RC(ptr)                ((int*)ptr)[-1] = 0 */
/* #define INCR_RC(ptr)        if (ptr) ((int*)ptr)[-1]++ */
/* #define DECR_RC_PRED(ptr) (ptr && --(((int*)ptr)[-1]) == 0) */

/* int outputcount = 0; */
/* int tuplimit = 10; */

/* void BASE(char x) {  */
/*   outputcount++; */
/*   if (outputcount >= tuplimit) exit(0); */
/* } */

/* void wserror(char* msg) { */
/*   //error(msg); */
/*   printf("Failed with error: %s\n", msg); */
/*   exit(-1); */
/* } */


/* /\* */
/* // TODO: */
/* int Listlength(void* list) { */
/*   int acc = 0; */
/*   printf("List len... %p\n", list); */
/*   while (list != 0) { */
/*     list = CDR(list); */
/*     acc++; */
/*   } */
/*   return acc;  */
/* } */
/* *\/ */

/* /\* */
/* // TODO: */
/* void* Listappend(void* ls1, void* ls2) { */
/*   printf("List append... %p and %p\n", ls1, ls2); */
/*   return ls1; */
/* } */

/* // TODO: */
/* void* Listreverse(void* ls) { */
/*   printf("List reverse... %p\n", ls); */
/*   return ls; */
/* } */
/* *\/ */


/* // This won't work: */
/* /\* */
/* int Listref(void* list, int n) { */
/*   return 0;  */
/* } */
/* *\/ */


/* inline static float cNorm(complex c) { */
/*    float re =  __real__ (c); */
/*    float im =  __imag__ (c); */
/*    return sqrt ((re*re) + (im*im)); */
/* } */

