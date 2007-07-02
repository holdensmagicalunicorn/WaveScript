

DEBUG = false;
DEBUGSYNC = DEBUG;

include "stdlib.ws";
include "matrix.ws";

// Takes Sigseg Complex
fun marmotscore2(freqs) { 
  result = 
    absC(freqs[[3]] +: 
	 freqs[[4]]);
  if DEBUG then 
   print("\nMarmot Score: "++show(result)++", \nBased on values "
	++ show(freqs[[3]]) ++ " "
	++ show(freqs[[4]]) ++ " \n");
  result
}


/* expects Zip2<SigSeg<float>,float>::Output */
fun detect(scorestrm) {
  // Constants:
  alpha = 0.999;
  hi_thresh = 16;
  startup_init = 300;
  refract_interval = 40;
  max_run_length = 48000;
  samples_padding = 2400;
  
  iterate((score,st,en) in scorestrm) {
    state {
      thresh_value = 0.0;
      trigger = false;
      smoothed_mean = 0.0;
      smoothed_var = 0.0;
      _start = 0; 
      trigger_value = 0.0;
      startup = 300;
      refract = 0;                 

      // private
      noise_lock = 0; // stats
    }

    fun reset() {
      thresh_value := 0.0;
      trigger := false;
      smoothed_mean := 0.0;
      smoothed_var := 0.0;
      _start := 0;
      trigger_value := 0.0;
      startup := startup_init;
      refract := 0;
    };

    if DEBUG then 
    print("Detector state: thresh_value " ++show(thresh_value)++ " trigger " ++show(trigger)++ 
	  " smoothed_mean " ++show(smoothed_mean)++ " smoothed_var " ++show(smoothed_var)++ "\n" ++
	  "        _start " ++show(_start)++ " trigger_value " ++show(trigger_value)++ 
	  " startup " ++show(startup)++ " refract " ++show(refract)++ " noise_lock " ++show(noise_lock)++"\n"
	  );
    
    
    /* if we are triggering.. */
    if trigger then {      

      /* check for 'noise lock' */
      if en - _start > max_run_length then {
	print("Detection length exceeded maximum of " ++ show(max_run_length)
	      ++", re-estimating noise");
	
	noise_lock := noise_lock + 1;
	reset();
	//goto done; GOTO GOTO GOTO 
      };

      /* over thresh.. set refractory */
      if score > thresh_value then {
	refract := refract_interval;
      } else if refract > 0 then {	
	/* refractory counting down */
	refract := refract - 1;
      }	else {
	/* untriggering! */
	trigger := false;
	
	/* emit power of 2 */
	p = en + samples_padding - _start;
	p2 = Mutable:ref(1);
	// RRN: GETTING RID OF FOR/BREAK:
	/*	for i = 0 to 24 {
	  if (p2 >= p) then break;
	  p2 := p2 * 2;
	  }*/

	//	ind = Mutable:ref(0);
	//        while i <= 24 && p2 < p {
        while p2 < p {
          p2 := p2 * 2;
	  //	  i := i + 1;  // Is this necessary?
	};

	emit (true,                               // yes, snapshot
	      _start - samples_padding,           // start sample
	      _start - samples_padding + p2 - 1); // end sample
	if DEBUG then
	print("KEEP message: "++show((true, _start - samples_padding, en + samples_padding))++
	      " just processed window "++show(st)++":"++show(en)++"\n");

	// ADD TIME! // Time(casted->_first.getTimebase()
	_start := 0;
      }
    } else { /* if we are not triggering... */      
      /* compute thresh */
      let thresh = i2f(hi_thresh) *. sqrtF(smoothed_var) +. smoothed_mean;

      if DEBUG then 
        print("Thresh to beat: "++show(thresh)++ ", Current Score: "++show(score)++"\n");

      /* over thresh and not in startup period (noise est period) */
      if startup == 0 && score > thresh then {
	if DEBUG then print("Switching trigger to ON state.\n");
	trigger := true;
	refract := refract_interval;
	thresh_value := thresh;
	_start := st;
	trigger_value := score;
      }	else {
	/* otherwise, update the smoothing filters */
	smoothed_mean := score *. (1.0 -. alpha) +. smoothed_mean *. alpha;
	delt = score -. smoothed_mean;
	smoothed_var := (delt *. delt) *. (1.0 -. alpha) +. smoothed_var *. alpha;
      };
	
      /* count down the startup phase */
      if startup > 0 then startup := startup - 1;
      
      /* ok, we can free from sync */
      /* rrn: here we lamely clear from the beginning of time. */
      /* but this seems to assume that the sample numbers start at zero?? */
      emit (false, 0, max(0, st - samples_padding - 1));
      if DEBUG then 
      print("DISCARD message: "++show((false, 0, max(0, en - samples_padding)))++
	    " just processed window "++show(st)++":"++show(en)++"\n");
      
    }
  }
}


// ================================================================================

//flag = GETENV("WSARCH") == "ENSBox";
flag = false;
//flag = true;

//marmotfile = "/archive/4/marmots/brief.raw";
//marmotfile = "/archive/4/marmots/real_100.raw";
marmotfile =
  if FILE_EXISTS("15min_marmot_sample.raw") then "15min_marmot_sample.raw" else
  if FILE_EXISTS("3min_marmot_sample.raw") then "3min_marmot_sample.raw" else
  if FILE_EXISTS("6sec_marmot_sample.raw") then "6sec_marmot_sample.raw" else
  //  if FILE_EXISTS("~/archive/4/marmots/brief.raw") then "~/archive/4/marmots/brief.raw" else
  wserror("Couldn't find sample marmot data, run the download scripts to get some.\n");

fun readone(mode) 
  (readFile(marmotfile, "mode: binary window: 4096 rate: 24000 "++ mode) 
   :: Stream Sigseg (Int16))

     //_ch1 = if flag then ensBoxAudio(0,4096,0,24000) else readone("offset: 0");
     //_ch2 = if flag then ensBoxAudio(1,4096,0,24000) else readone("offset: 2");
     //_ch3 = if flag then ensBoxAudio(2,4096,0,24000) else readone("offset: 4");
     //_ch4 = if flag then ensBoxAudio(3,4096,0,24000) else readone("offset: 6");

_ch1 = if flag then ensBoxAudio(0) else readone("offset: 0");
_ch2 = if flag then ensBoxAudio(1) else readone("offset: 2");
_ch3 = if flag then ensBoxAudio(2) else readone("offset: 4");
_ch4 = if flag then ensBoxAudio(3) else readone("offset: 6");

ch1 = deep_stream_map(int16ToFloat, _ch1)
ch2 = deep_stream_map(int16ToFloat, _ch2)
ch3 = deep_stream_map(int16ToFloat, _ch3)
ch4 = deep_stream_map(int16ToFloat, _ch4)

/* chans = (dataFile(marmotfile, "binary", 24000, 0) :: Stream (Int16 * Int16 * Int16 * Int16)); */
/* _ch1 = if flag then ENSBoxAudio(0,4096,0,24000) else window(sm(fun((a,_,_,_)) int16ToFloat(a), chans), 4096); */
/* _ch2 = if flag then ENSBoxAudio(1,4096,0,24000) else window(sm(fun((_,b,_,_)) int16ToFloat(b), chans), 4096); */
/* _ch3 = if flag then ENSBoxAudio(2,4096,0,24000) else window(sm(fun((_,_,c,_)) int16ToFloat(c), chans), 4096); */
/* _ch4 = if flag then ENSBoxAudio(3,4096,0,24000) else window(sm(fun((_,_,_,d)) int16ToFloat(d), chans), 4096); */


// 96 samples are ignored between each 32 used:
rw1 = rewindow(ch1, 32, 96);

//hn = smap(hanning, rw1);
hn = hanning(rw1);

wscores = stream_map(fun(x) (marmotscore2( sigseg_fftR2C(x) ), x.start, x.end),
		     hn);

detections = detect(wscores);

d2 = iterate (d in detections) {
  let (flag,_,_) = d;
  if flag then print("detected at "++show(d)++"\n");
  emit d;
};

synced = syncN(d2, [ch1, ch2, ch3, ch4]);





