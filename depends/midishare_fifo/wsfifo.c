
#include "lffifo.c"

//################################################################################//
//         Extend the lffifo with a mutex for blocking dequeues.
//################################################################################//

typedef struct wsfifo {
  fifo ff;
  pthread_cond_t cond;
  pthread_mutex_t mut;  
  void* last_cell;
} wsfifo;

#define FIFOMALLOC BASEMALLOC
#define FIFOFREE   BASEFREE

void wsfifoinit(wsfifo* ff, int optional_size_limit, int elemsize) {
  fifoinit(& ff->ff);
  pthread_cond_init (& ff->cond, NULL); 
  pthread_mutex_init(& ff->mut, NULL); 
}

#define WSFIFOPUT(ff, val, ty) {  \
  void** cell = FIFOMALLOC(sizeof(void*) + sizeof(ty)); \
  cell[0] = (void*)0; /* don't know if this is required */ \
  *(ty*)(cell+1) = val; /* copy it over */ \
  int size = fifosize((fifo*)(ff)); \
  if (size==0) { \
     pthread_mutex_lock(& (ff)->mut); \
     fifoput((fifo*)(ff), (fifocell*)cell);  \
     printf("*WAKEUP %p*\n", & (ff)->mut); \
     pthread_cond_signal(& (ff)->cond); \
     pthread_mutex_unlock(& (ff)->mut); \
  } else { \
    printf("."); \
    fifoput((fifo*)(ff), (fifocell*)cell);  \
  } \
}

// We dequeue in two stages.  First we get the element, and then we
// "cleanup" to free the element we got.
void* wsfifoget(wsfifo* ff) {
    void* ptr = fifoget(& ff->ff);
    if (! ptr) { // Doesn't need to be while.
      //sleep(1); printf(".");
      pthread_mutex_lock(& ff->mut);
      ptr = fifoget(& ff->ff);
      // If there is STILL nothing while we have the lock then we need to block.
      if (!ptr) {
        printf("<WAITING %p>\n", & ff->mut);
        pthread_cond_wait(& ff->cond, & ff->mut);
        printf(" =========== WOKE UP ============ %p\n", & ff->mut);
        ptr = fifoget(& ff->ff); // Now we better get something.
      }
      // Do this before we unlock?
      pthread_mutex_unlock(& ff->mut);
    }
    //printf("  got val off queue #%d, %p : %p %p %d %d\n", 
    //       index, queue_table[index], ptr, (void**)ptr+1, *((int*)((void**)ptr+1)), *((char*)((void**)ptr+1)));
    ff->last_cell = ptr;
    return ((void**)ptr)+1;
}

// This doesn't check to make sure that last_cell is set!  It should!
void wsfifoget_cleanup(wsfifo* ff) {
    FIFOFREE(ff->last_cell);  
}
