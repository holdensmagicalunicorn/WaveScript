include "stdlib.ws";

// [2007.04.09] Hmm... having a problem with this not elaborating
// properly if I do a using rather than Array:fold.

// OH! This has to do with the source positions.

// [2007.06.29] Disabling this till it works in more backends.
//src = union2(timer(3.0), timer(4.0))
src = COUNTUP(30);

fun assert_prnt(str,a,b) {
  assert_eq(str,a,b);
  print("Assert passed: "++ str ++ "\n");
}

// This has to be lifted to top level because of limitations in static-elaborate:
s1 = window(src, 10);
ls = deinterleaveSS(2, 10, s1);
ch1 = dewindow$  ls`List:ref(0);
ch2 = dewindow$  ls`List:ref(1);

ch1b = deinterleave(2, src) ` List:ref(0);

zipped = zipN_sametype(0, [ch1,ch1b]);

zipped2 = zip4_sametype(0, ch1,ch1b, ch1,ch1b);

BASE <- iterate (x in zipped) {
  state { first = true }
  
  //println(x++" \n");
  assert_prnt("deinterlaces the same", List:ref(x,0), List:ref(x,1));
  emit x;

  if first then {
    println("\n");

    {
      println("  FIFO ADT ");
      println("=====================");
      using FIFO;
      q = make(10);
      enqueue(q,1);
      enqueue(q,2);
      enqueue(q,3);
      x = dequeue(q);
      y = dequeue(q);
      enqueue(q,4);
      z = dequeue(q);
      w = dequeue(q);
      assert_prnt("fifo", [1,2,3,4], [x,y,z,w]);
    };

    {
      println("  Array primitives: ");
      println("=====================");

      using Array;
      arr = build(10, fun(x) x);
      f1 = Array:fold((+), 0, arr);
      f2 = Array:fold1((+), arr);
      println("Fold:  " ++ f1);
      println("Fold1: " ++ f2 ++ "  (should be same as previous)");
      assert_prnt("folds equal", f1,f2);

      //flipped = fun(x,y) (y:::x); 
      //      println("FoldCons:  " ++ Array:fold(fun(x,y)(y:::x), [], arr));

      //      println("FoldRange: " ++ Array:foldRange(3, 4, 0, (+)));
      //      println("FoldRange: " ++ Array:foldRange(3, 7, [], fun(x,y)(y:::x)));
    };

    first := false;
    println("");

    /*
    print("Type Unions: ");
    case x {
      Oneof2(x): println("Got left! ")
      Twoof2(y): println("Got right! ")
    };
    */

    {
       using List;
       println("  List primitives: ");
       println("====================");
       ls1 = [1,2,3];
       ls2 = [4,5,6];        
       summed = List:map2((+),ls1,ls2);
       assert_prnt("List:map2", [5,7,9], summed);

       assert_prnt("List:mapi", 6, List:fold1((+), List:mapi(fun(i,x) i, [0,0,0,0])));

       assert_prnt("choplast", (4,[1,2,3]), choplast([1,2,3,4]));

    };
    
    
  };
  
  //  emit true;
}
