
// UNFINISHED...

#include <stdlib.h>
#include <stdio.h>
#include "wsq_runtime.h"


int main(int argc, char* argv[]) {
  WSQ_Init("7B_MergeFiles.out");
  WSQ_SetQueryName("generated_query_8");

  printf("PAUSING WSQ engine, run compiled query manually...\n");

  WSQ_BeginTransaction(1001);
    WSQ_BeginSubgraph(101);

      // Tuples, 100Hz
      // Should be EXACTLY 10 tuples from this file:
      WSQ_AddOp(1, "ASCIIFileSource", "", "100", "-1 |foobar.schema|./example_distributed/taq_10lines.dat"); 

      WSQ_AddOp(2, "ASCIIFileSource", "", "200", "-1 |foobar.schema|./example_distributed/taq_10lines.dat"); 

      WSQ_AddOp(3, "MergeMonotonic", "100 200", "300", "RECEIVEDTIME");

      WSQ_AddOp(4, "Printer", "300", "", "Merged file sources:");

    WSQ_EndSubgraph();
  WSQ_EndTransaction();

  sleep(2);
  printf("Done Sleeping.  Shutting down WSQ Engine...\n");
  WSQ_Shutdown();
  return 0;
}
