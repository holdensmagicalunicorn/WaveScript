/*

 [2007.12.06]

    This is the header that goes with my new C backend.  It contains
    various macros that keep bloat from the emit-c2 pass itself.
 
   -Ryan

 Important preprocessor variables:
   LOAD_COMPLEX
   USE_BOEHM
   ALLOC_STATS 
   WS_THRADED

 */

// For some godawful reason sched.h won't work out of the box and I need to do this:
#define _GNU_SOURCE 
// And it has to be done *before* stdio.h is included...

// Headers that we need for the generated code:
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include <unistd.h>
#include<math.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>
#include<getopt.h>

#define LOAD_COMPLEX
//#define WS_THREADED
//#define ALLOC_STATS
//#define BLAST_PRINT

// For now, only use real-time timers in threaded mode:
#ifdef WS_THREADED
#define WS_REAL_TIMERS
#endif


#ifdef LOAD_COMPLEX
#include<complex.h>
#endif

#define TRUE  1
#define FALSE 0

//#define ws_unit_t char
//#define ws_char_t char
//#define ws_bool_t char
//#define uint8_t unsigned char

typedef char ws_char_t;
typedef char ws_bool_t;
typedef char ws_unit_t;
typedef char ws_timebase_t;

typedef unsigned char      uint8_t;
typedef unsigned short int uint16_t;
//typedef unsigned int16_t uint16_t;

#define ws_string_t char*

extern int stopalltimers;

//################################################################################//
//                 Matters of memory layout and GC                                //
//################################################################################//

//typedef unsigned int refcount_t;
// 64 bit is giving me annoying alignment problems.  Let's make this a whole word:
typedef unsigned long refcount_t;

// Arrays are the same size as RCs for now (see below):
#define ARRLENSIZE sizeof(refcount_t) 
#define PTRSIZE sizeof(void*)

#include <locale.h>
char* commaprint(unsigned long long n);

// ============================================================
// Names like BASEMALLOC abstract the allocater API.
#ifdef USE_BOEHM
  #include <gc/gc.h>
  #define BASEMALLOC GC_MALLOC
  #define BASEFREE   free
  #define BASEMALLOC_ATOMIC GC_MALLOC_ATOMIC
  inline void* BASECALLOC(size_t count, size_t size) {
    size_t bytes = count*size;
    void* ptr = GC_MALLOC(bytes);
    bzero(ptr, bytes);
    return ptr;
  }
  inline void* BASECALLOC_ATOMIC(size_t count, size_t size) {
    size_t bytes = count*size;
    void* ptr = GC_MALLOC_ATOMIC(bytes);
    bzero(ptr, bytes);
    return ptr;
  }
  // If we are using BOEHM we do not need refcounts:
  #define RCSIZE 0
  #define ARRLENOFFSET -1
#else
  #define BASEMALLOC        malloc
  #define BASECALLOC        calloc
  #define BASEMALLOC_ATOMIC malloc
  #define BASECALLOC_ATOMIC calloc
  #define BASEFREE   free
  #define RCSIZE sizeof(refcount_t)
  #define ARRLENOFFSET -2
#endif

// ============================================================
// Then on top of that "BASE" layer we define the "WS" variants.
// These macros allow us to monitor allocation rates if we wish:
#ifdef ALLOC_STATS
unsigned long long alloc_total = 0;
unsigned long long alloc_counter = 0;
unsigned long long free_counter = 0;
inline void* malloc_measured(size_t size) {
  alloc_total   += size;
  alloc_counter += 1;
  return BASEMALLOC(size);
}
inline void* calloc_measured(size_t count, size_t size) {
  alloc_total += size * count;
  alloc_counter += 1;
  return BASECALLOC(count,size);
}
inline void free_measured(void* object) {
  free_counter += 1;
  BASEFREE(object);
}
#define WSMALLOC        malloc_measured
#define WSMALLOC_SCALAR malloc_measured
#define WSCALLOC        calloc_measured
#define WSCALLOC_SCALAR calloc_measured
#define WSFREE   free_measured
#else
#define WSMALLOC        BASEMALLOC
#define WSCALLOC        BASECALLOC
#define WSMALLOC_SCALAR BASEMALLOC_ATOMIC
#define WSCALLOC_SCALAR BASECALLOC_ATOMIC
#define WSFREE   BASEFREE
#endif

// ============================================================
// Handle RCs on Arrays (and maybe the same for cons cells):
// CLEAR_ARR_RC is only called when the ptr is non-nil.
#define ARR_RC_DEREF(ptr)         (((refcount_t*)ptr)[-1])
#define GET_ARR_RC(ptr)           (ptr ? ARR_RC_DEREF(ptr) : 0)
#define SET_ARR_RC(ptr,val)       (ARR_RC_DEREF(ptr) = val)
#define CLEAR_ARR_RC(ptr)         SET_ARR_RC(ptr,0)

// TEMPORARY: For the moment we make all incr/decrs thread safe!!
// Instead we should be proactively copying on fan-out.
#ifdef WS_THREADED
  #include "atomic_incr_intel.h"
  #define INCR_ARR_RC(ptr)        if (ptr) atomic_increment( &ARR_RC_DEREF(ptr))
  #define DECR_ARR_RC_PRED(ptr)   (ptr ? atomic_exchange_and_add( &ARR_RC_DEREF(ptr), -1) == 1 : 0)
  #define INCR_ITERATE_DEPTH()    atomic_increment(&iterate_depth)
  #define DECR_ITERATE_DEPTH()    atomic_exchange_and_add(&iterate_depth, -1)
#else
  #define INCR_ARR_RC(ptr)        if (ptr) ARR_RC_DEREF(ptr)++
  #define DECR_ARR_RC_PRED(ptr)   (ptr ? (-- ARR_RC_DEREF(ptr) == 0) : 0)

//int foo2(int a, int b) {   return b; }
// #define DECR_RC_PRED(ptr) foo2(ptr ? printf("   Decr %p rc %d\n", ptr, GET_RC(ptr)) : 99, (ptr ? (--(((refcount_t*)ptr)[-1]) == 0) : 0))

  #define INCR_ITERATE_DEPTH()  iterate_depth++
  #define DECR_ITERATE_DEPTH()  iterate_depth--
#endif

//#define DECR_RC_PRED(ptr) (ptr ? (GET_RC(ptr) <=0 ? printf("ERROR: DECR BELOW ZERO\n") : (--(((refcount_t*)ptr)[-1]) == 0)) : 0)

// Handle Cons Cell memory layout:
// ------------------------------------------------------------
// Normally, the refcount routines are the same:
#define CLEAR_CONS_RC(ptr)    SET_CONS_RC(ptr,0)

#define GET_CONS_RC        GET_ARR_RC
#define SET_CONS_RC        SET_ARR_RC
#define INCR_CONS_RC       INCR_ARR_RC
#define DECR_CONS_RC_PRED  DECR_ARR_RC_PRED

// Here I'm testing different layouts:
// ------------------------------------------------------------
// Cell consists of [cdr] [RC] ->[car]
#define CONSCELL(ty)       (void*)((char*)WSMALLOC(PTRSIZE+RCSIZE + sizeof(ty)) + PTRSIZE+RCSIZE);
#define CAR(ptr,ty)        (*ptr)
#define SETCAR(ptr,hd,ty)  (CAR(ptr,ty) = hd)
#define CONSPTR(ptr)       ((void**)((char*)ptr - (PTRSIZE+RCSIZE)))
#define CDR(ptr,ty)        (*CONSPTR(ptr))
#define SETCDR(ptr,tl,ty)  (*CONSPTR(ptr)=tl)
#define FREECONS(ptr,ty)   WSFREE(CONSPTR(ptr))

// New layout to ameliorate alignment problems for the CDR field on 64 bit,  [RC], ->[CDR], [CAR]
// ------------------------------------------------------------
// (NOTE: Relative to the start of the malloc its still unaligned, but should make valgrind happy.)
// NOPE: it doesn't make valgrind happy.
/* #define CONSCELL(ty)      (void*)((char*)WSMALLOC(RCSIZE + PTRSIZE + sizeof(ty)) + RCSIZE); */
/* #define CAR(ptr,ty)       (*((ty*)(((void**)ptr)+1))) */
/* #define SETCAR(ptr,hd,ty) (CAR(ptr,ty) = hd) */
/* #define CDR(ptr,ty)       (*(void**)ptr) */
/* #define SETCDR(ptr,tl,ty) (CDR(ptr) = tl) */
/* #define FREECONS(ptr,ty)  WSFREE(((char*)ptr) - RCSIZE) */

// Now we'll try this: [CDR], [CAR], [RC] ->
// ------------------------------------------------------------
// WEIRD: still a valgrind problem, even though both cdr and car should be aligned relative to the malloc.
// But they are NOT aligned relative to the pointer.  Apparently valgrind needs both.
/* #define CONSCELL(ty)      (void*)((char*)WSMALLOC(RCSIZE + PTRSIZE + sizeof(ty)) + RCSIZE+PTRSIZE + sizeof(ty)); */
/* #define CAR(ptr,ty)       (*((ty*)(((char*)ptr) - RCSIZE - sizeof(ty)))) */
/* #define SETCAR(ptr,hd,ty) (CAR(ptr,ty) = hd) */
/* #define CDR(ptr,ty)       (*((void**)(((char*)ptr) - RCSIZE - PTRSIZE - sizeof(ty)))) */
/* #define SETCDR(ptr,tl,ty) (CDR(ptr,ty) = tl) */
/* #define FREECONS(ptr,ty)  WSFREE(((char*)ptr) - RCSIZE - PTRSIZE - sizeof(ty)) */

// Finally [CDR], [CAR], -> [RC]
// ------------------------------------------------------------


// How bout with a struct?
// ------------------------------------------------------------
// This makes valgrind happy.  Won't work with the ZCT though, unless we do the same trick for arrays.
/* struct cons_cell { */
/*   refcount_t rc; */
/*   void* cdr; */
/*   int car; // This is a lie. */
/* }; */
/* #define CONSCELL(ty)      ((struct cons_cell*)(WSMALLOC(sizeof(struct cons_cell) + sizeof(ty) - sizeof(int)))) */
/* #define CAR(ptr,ty)       (*(ty*)(&(((struct cons_cell*)ptr)->car))) */
/* #define SETCAR(ptr,hd,ty) (CAR(ptr,ty) = hd) */
/* #define CDR(ptr,ty)       (((struct cons_cell*)ptr)->cdr) */
/* #define SETCDR(ptr,tl,ty) (CDR(ptr) = tl) */
/* #define FREECONS(ptr,ty)  WSFREE(((char*)ptr) - RCSIZE - PTRSIZE - sizeof(ty)) */

/* #define CONS_RC(ptr)            (((struct cons_cell*)ptr)->rc) */
/* #define GET_CONS_RC(ptr)        (ptr ? CONS_RC(ptr) : 0) */
/* #define SET_CONS_RC(ptr,val)    (CONS_RC(ptr) = val) */
/* #define INCR_CONS_RC(ptr)       if (ptr) CONS_RC(ptr)++ */
/* #define DECR_CONS_RC_PRED(ptr)  (ptr ? ( -- CONS_RC(ptr) == 0) : 0) */


// Handle Array memory layout:
// ------------------------------------------------------------
// An array consists of [len] [RC] [elem*]
// Both len and RC are currently the same type (refcount_t)
// this makes the access uniform.
#define ARRLEN(ptr)        (ptr ? ((refcount_t*)ptr)[ARRLENOFFSET] : 0)
//#define ARRLEN(ptr)        ((int*)ptr)[-2]
// This should not be used on a null pointer:
#define SETARRLEN(ptr,len) (((refcount_t*)ptr)[ARRLENOFFSET]=len)

#define ARRLEN(ptr)        (ptr ? ((refcount_t*)ptr)[ARRLENOFFSET] : 0)
// Get a pointer to the *start* of the thing (the pointer to free)
#define ARRPTR(ptr)        (((refcount_t*)ptr) + ARRLENOFFSET)
#define FREEARR(ptr)       WSFREE(ARRPTR(ptr))

// This is not currently used by the code generator [2008.07.02], but can be used by C code.
//#define WSARRAYALLOC(len,ty) ((void*)((char*)calloc(ARRLENSIZE+RCSIZE + (len * sizeof(ty)), 1) + ARRLENSIZE+RCSIZE))
#define WSARRAYALLOC(len,ty) (ws_array_alloc(len, sizeof(ty)))
#define WSSTRINGALLOC(len)   (ws_array_alloc(len, sizeof(ws_char_t)))

inline void* ws_array_alloc(int len, int eltsize) {
  char* ptr = ((char*)WSMALLOC(ARRLENSIZE + RCSIZE + len*eltsize)) + ARRLENSIZE+RCSIZE;
  SETARRLEN(ptr, len);
#ifndef USE_BOEHM
  CLEAR_ARR_RC(ptr);
#endif
  return ptr;
}

#ifdef ALLOC_STATS
unsigned long long last_alloc_printed = 0;
void ws_alloc_stats() {
  printf("  Malloc calls: %s\n", commaprint(alloc_counter));
  printf("  Free   calls: %s", commaprint(free_counter));
  printf("\t\t Unfreed objs: %s\n", commaprint(alloc_counter-free_counter));
  printf("  Total bytes allocated: %s\n",  commaprint(alloc_total));
  printf("  Bytes since last stats: %s\n", commaprint(alloc_total - last_alloc_printed));
  last_alloc_printed = alloc_total;
}
#endif

// ZCT handling for deferred reference counting:
// ============================================================

//#ifdef USE_ZCT

typedef unsigned char typetag_t;

// 80 (64+16) KB for now:
//#define ZCT_SIZE (1024*16)
// Testing: 16mb
#define ZCT_SIZE (1024 * 1048 * 4)

// These will need to be per-thread in the future:
extern typetag_t zct_tags[];
extern void*     zct_ptrs[];
extern int       zct_count;
extern int       iterate_depth;

#ifdef WS_THREADED
// This locks all the zct_* above:
extern pthread_mutex_t zct_lock;
#endif

void free_by_numbers(typetag_t, void*);

// This needs to be the high-bit in a refcount_t
#define PUSHED_MASK (1 << (sizeof(refcount_t) * 8 - 1))

// NOTE: THIS ASSUMES IDENTICAL RC METHOD FOR ARRAYS AND CONS CELLS!!
static inline void MARK_AS_PUSHED(void* ptr) {
  //SET_RC(ptr, GET_RC(ptr) | PUSHED_MASK);
  ARR_RC_DEREF(ptr) |= PUSHED_MASK;
}
// NOTE: THIS ASSUMES IDENTICAL RC METHOD FOR ARRAYS AND CONS CELLS!!
static inline void UNMARK_AS_PUSHED(void* ptr) {
  //SET_RC(ptr, GET_RC(ptr) | PUSHED_MASK);
  ARR_RC_DEREF(ptr) &= ~PUSHED_MASK;
}
// NOTE: THIS ASSUMES IDENTICAL RC METHOD FOR ARRAYS AND CONS CELLS!!
static inline void PUSH_ZCT(typetag_t tag, void* ptr) {  
  //printf("pushing %p tag %d, rc %u, (mask %u)\n", ptr, tag, GET_RC(ptr), PUSHED_MASK);
  // TEMPORARILY LOCKING FOR ACCESS TO CENTRALIZED ZCT:
#ifdef WS_THREADED
    pthread_mutex_lock(&zct_lock);
#endif 
  if (ptr == NULL) return;
  if (GET_ARR_RC(ptr) & PUSHED_MASK) { 
    //printf("ALREADY PUSHED %p, tag %d\n", ptr, tag);
    return; // Already pushed.
  }
  MARK_AS_PUSHED(ptr);
  zct_tags[zct_count] = tag;
  zct_ptrs[zct_count] = ptr;
  zct_count++;
#ifdef WS_THREADED
    pthread_mutex_unlock(&zct_lock);
#endif
}

#ifdef BLAST_PRINT
#define histo_len 20
unsigned long tag_histo[histo_len];
#endif

// The depth argument to BLAST_ZCT is PRIOR to decrement (iterate_depth--). 
// So we're looking for depth==1 not depth==0.
static inline void BLAST_ZCT(int depth) {
  int i;
  int freed = 0;
  int max_tag = 0;
  if (depth > 1) {
    //printf("Not blasting, depth %d\n", iterate_depth);
    return;
  }

#ifdef WS_THREADED
    pthread_mutex_lock(&zct_lock);
#endif
#ifdef BLAST_PRINT
      if (zct_count==0) return; printf(" ** BLASTING:" ); fflush(stdout);
      for(i=0; i<histo_len; i++) tag_histo[i]=0;
#endif
  for(i=zct_count-1; i>=0; i--) {
    // Wipe off the mask bit before checking:
    if (0 == (GET_ARR_RC(zct_ptrs[i]) & ~PUSHED_MASK)) {
        #ifdef BLASTING 
          if (zct_tags[i] < histo_len) tag_histo[zct_tags[i]]++;
          max_tag = (max_tag > zct_tags[i]) ? max_tag : zct_tags[i];
        #endif
      free_by_numbers(zct_tags[i], zct_ptrs[i]);
      freed++;
    } else UNMARK_AS_PUSHED(zct_ptrs[i]);
  }  
#ifdef BLAST_PRINT
      printf(" killed %d/%d, tag histo: [ ", freed, zct_count); 
      for(i=0; (i<max_tag+1) && (i<histo_len); i++) printf("%d ", tag_histo[i]);
      printf("]\n");fflush(stdout);
      #ifdef ALLOC_STATS
        ws_alloc_stats();
      #endif
#endif
  zct_count = 0;
#ifdef WS_THREADED
    pthread_mutex_unlock(&zct_lock);
#endif
}

//#endif // USE_ZCT

// ============================================================
int outputcount = 0;
int wsc2_tuplimit = 10;

#define moduloI(a,b) (a % b)

//################################################################################//
//                           Scheduler and data passing
//################################################################################//

#ifdef WS_REAL_TIMERS
unsigned long tick_counter;
#define VIRTTICK() tick_counter++
// Should use nanosleep:
#define WAIT_TICKS(delta) { \
  usleep(1000 * delta * tick_counter); \
  tick_counter = 0; }
#else
#define VIRTTICK()                   {}
#define WAIT_TICKS(delta)            {}
#endif


// Single threaded version:
// ============================================================
// For one thread, these macros do nothing.  We don't use realtime for timers.
#ifndef WS_THREADED
#define EMIT(val, ty, fn) fn(val)
#define TOTAL_WORKERS(count)         {}
#define REGISTER_WORKER(ind, ty, fp) {}
#define DECLARE_WORKER(ind, ty, fp) 
#define START_WORKERS()              {}
unsigned long print_queue_status() { return 0; }

#else

// Thread-per-operator version, midishare FIFO implementation:
// ============================================================

// For now I'm hacking this to be blocking, which involves adding
// locks to a lock-free fifo implementation!

#ifdef USE_BOEHM
//#include <gc/gc_pthread_redirects.h>
#include <pthread.h>
#else
#include <pthread.h>
#endif

//#include "midishare_fifo/wsfifo.c"
#include "simple_wsfifo.c"
#define FIFO_CONST_SIZE 100
#define ANY_CPU -1

void (**worker_table) (void*);   // Should we pad this to prevent false sharing?
wsfifo** queue_table;            // Should we pad this to prevent false sharing?
int* cpu_affinity_table;
int total_workers;

//#include <sys/types.h>
#include <sched.h>
void pin2cpu(int cpuId) {
      // Get the number of CPUs
   if (cpuId != ANY_CPU) {
      cpu_set_t mask;
      unsigned int len = sizeof(mask);
      CPU_ZERO(&mask);
      CPU_SET(cpuId, &mask);

      //printf("Process id %u, thread id %u\n", getpid(), pthread_self());
      //printf("The ID of this of this thread is: %ld\n", (long int)syscall(224));
      //printf("The ID of this of this thread is: %ld\n", (long int)syscall(__NR_gettid));
      long int tid = syscall(224); // No idea how portable this is...

      //int retval = sched_setaffinity(gettid(), len, &mask);
      int retval = sched_setaffinity(tid, len, &mask);
      if (retval != 0) {
	perror("sched_setaffinity");
	exit(-1);
      }
   }
}

pthread_mutex_t print_lock = PTHREAD_MUTEX_INITIALIZER;

// Declare the existence of each operator.
#define DECLARE_WORKER(ind, ty, fp) wsfifo fp##_queue;  \
  void fp##_wrapper(void* x) { \
    fp(*(ty*)x); \
  }
// Declare number of worker threads.
// This uses plain old malloc... tables are allocated once.
#define TOTAL_WORKERS(count) { \
   worker_table  = malloc(sizeof(void*) * count);  \
   queue_table   = malloc(sizeof(wsfifo*) * count);  \
   cpu_affinity_table = malloc(sizeof(int) * count);  \
   total_workers = count; \
}
// Register a function pointer for each worker.
#define REGISTER_WORKER(ind, ty, fp) { \
   wsfifoinit(& fp##_queue, FIFO_CONST_SIZE, sizeof(ty));   \
   worker_table[ind] = & fp##_wrapper;  \
   queue_table[ind]  = & fp##_queue; \
   cpu_affinity_table[ind]  = ANY_CPU; \
}
// Start the scheduler.
#define START_WORKERS() {                    \
  int i;  \
  for (i=0; i<total_workers; i++)  { \
    pthread_t threadID; \
    pthread_create(&threadID, NULL, &worker_thread, (void*)i); \
  } \
}
// Enqueue a datum in another thread's queue.
#define EMIT(val, ty, fn) WSFIFOPUT(& fn##_queue, val, ty);

void* worker_thread(void* i) {
  int index = (int)i;
  pthread_mutex_lock(&print_lock);
  if (cpu_affinity_table[index] == ANY_CPU)
    fprintf(stderr, "** Spawning worker thread %d\n", index);
  else fprintf(stderr, "** Spawning worker thread %d, cpu %d\n", index, cpu_affinity_table[index]);

  //pin2cpu(1) pin2cpu(0);  
  pin2cpu(cpu_affinity_table[index]);
  pthread_mutex_unlock(&print_lock);  
  while (1) 
  {
    // Accesses to these two tables are read-only:
    void* ptr = wsfifoget(queue_table[index]);
    (*worker_table[index])(ptr);
    wsfifoget_cleanup(queue_table[index]);
  }
  return 0;
}

// Returns the sum of the sizes of all queues.
unsigned long print_queue_status() {
  int i;
  unsigned long total = 0;
  printf("Status of %d queues:", total_workers);
  fflush(stdout);
  for(i=0; i<total_workers; i++) {
    //printf("Queue #%d: \t%d\n", i, wsfifosize(queue_table[i]));
    int size = wsfifosize(queue_table[i]);
    total += size;
    printf(" %d", size);
    fflush(stdout);
  }
  printf(" total %d\n", total);
  return total;
}
#endif

//################################################################################//
//               Startup, Shutdown, Errors, Final output values                   //
//################################################################################//

void wsShutdown() {
  #ifdef ALLOC_STATS
    ws_alloc_stats();
  #endif
    stopalltimers = 1;
    printf("Stopped all timers.\n");
  #ifdef WS_THREADED
    print_queue_status();
  #endif
}

void BASE(char x) {
  outputcount++;
  if (outputcount == wsc2_tuplimit) { 
    printf("Enough tuples.  Shutting down.\n");
    wsShutdown(); 
    exit(0);     
  }
#ifdef ALLOC_STATS
  ws_alloc_stats();
#endif
  fflush(stdout);
}

void ws_parse_options(int argc, char** argv) {
  int i, c;
  while ((c = getopt(argc, argv, "n:")) != -1) {
    //printf("Parsing option character: %c\n", c);
	switch (c) {
	case 'n':
	        wsc2_tuplimit = atoi(optarg);
		break;
	// case 's': // Do not print main stream output tuples.
	default:
	  //		usage();
	  //		return 1;
		break;
	}
  }
}

// FIXME: When driven by foreign source we don't use this:
void wserror_fun(char* msg) {
  //error(msg);
  printf("Failed with error: %s\n", msg);
  exit(-1);
}
#define wserror_wsc2(str) wserror_fun(str);

//################################################################################//
//                                    Misc                                        //
//################################################################################//

#define WSNULLTIMEBASE ((char)0)
#define TIMEBASE(n)    ((char)n)

/*
// TODO:
int Listlength(void* list) {
  int acc = 0;
  printf("List len... %p\n", list);
  while (list != 0) {
    list = CDR(list);
    acc++;
  }
  return acc; 
}
*/

/*
// TODO:
void* Listappend(void* ls1, void* ls2) {
  printf("List append... %p and %p\n", ls1, ls2);
  return ls1;
}

// TODO:
void* Listreverse(void* ls) {
  printf("List reverse... %p\n", ls);
  return ls;
}
*/


// This won't work:
/*
int Listref(void* list, int n) {
  return 0; 
}
*/


char *commaprint(unsigned long long n)
{
	static int comma = '\0';
	static char retbuf[30];
	char *p = &retbuf[sizeof(retbuf)-1];
	int i = 0;

	if(comma == '\0') {
		struct lconv *lcp = localeconv();
		if(lcp != NULL) {
			if(lcp->thousands_sep != NULL &&
				*lcp->thousands_sep != '\0')
				comma = *lcp->thousands_sep;
			else	comma = ',';
		}
	}

	*p = '\0';

	do {
		if(i%3 == 0 && i != 0)
			*--p = comma;
		*--p = '0' + n % 10;
		n /= 10;
		i++;
	} while(n != 0);

	return p;
}


#ifdef LOAD_COMPLEX
inline static float cNorm(complex float c) {
   float re =  __real__ (c);
   float im =  __imag__ (c);
   return sqrt ((re*re) + (im*im));
}
#endif

