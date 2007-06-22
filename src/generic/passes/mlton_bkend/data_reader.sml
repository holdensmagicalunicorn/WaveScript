


(* Will this be inefficient? *)
(* This produces a LargeWord... There's no Word16. *)
(* Wow, look how verbose this SML is compared to the Caml: *)
fun read_uint16 vec (i : int) = 
  let val lower : LargeWord.word = Word8.toLarge (Word8Vector.sub(vec,i))
      val upper : LargeWord.word = LargeWord.<< (Word8.toLarge (Word8Vector.sub(vec,i+1)), 
                                                 Word.fromInt 8)
  in
     LargeWord.+ (lower, upper)
  end 

(* read_int16 : string -> int -> int *)
fun read_int16 vec i : Int16.int =
  let val unsigned = read_uint16 vec i in
    if 0 = LargeWord.toInt (LargeWord.andb (unsigned, LargeWord.fromInt 32768))
    then Int16.fromInt (LargeWord.toInt unsigned)
    else Int16.fromInt (LargeWord.toInt (LargeWord.- (unsigned, LargeWord.fromInt 65536)))
  end 


(* MLton seems to have a bug *)
(*
fun read_int32 vec i =
  Int32.fromLarge(Word32.toLargeInt(PackWord32Big.subVec(vec,0)))
*)

exception WSError
fun wserror str = raise WSError


(* Binary reading, produces a scheduler entry, "SE" *)
(* mode & Textreader parameter are unused  and should be removed *)
fun dataFile (file:string,  mode:string,  repeats:int,  period:int)
             (textreader, binreader,  bytesize:int,  skipbytes:int,  offset:int)
	     (outchan : (Int16.int -> unit))
  =
	  let               
	      val hndl = BinIO.openIn file 
	      val timestamp = ref 0
	      val st = ref 0  (* Inclusive *) 
	      val en = ref 0  (* Exclusive *)	      
	      (* Produce a scheduler function *)
	      fun f () =
	        (	          
		  let val dat = binreader (BinIO.inputN(hndl, bytesize)) 0
                  in 
		   outchan dat
		  end;
		 (* Now skip some bytes: *)
		 BinIO.inputN(hndl, skipbytes);
		 timestamp := !timestamp + period;
		 SE (!timestamp, f))
	   in 	  
	     (* First we need to skip ahead by the offset. *)
	     (BinIO.inputN(hndl, offset);
	      SE (0, f))
	   end


(* This simply constructs a reader function that reads a whole window. 
   Thus it can reuse dataFile above. *)
fun dataFileWindowed config 
    (textreader,binreader, bytesize, skipbytes, offset)

    outchan (winsize:int) 
    (arrcreateUnsafe, arrset, tosigseg)
=
  let
      val sampnum = ref 0 
      val wordsize : int = bytesize+skipbytes 
      fun block_bread vec baseind = 
      (* Array.init might not be the most efficient: *)
       let val arr = arrcreateUnsafe winsize 
           val i = ref 0
       in        
	  (while !i < winsize do 
	     arrset arr i (binreader vec (baseind + !i * wordsize));
           let val result = tosigseg arr !sampnum 3339 
           in
	   (sampnum := !sampnum + winsize;
	    result)
           end)
       end
  in
    dataFile config (38383, block_bread, wordsize * winsize, 0, offset) outchan
  end
