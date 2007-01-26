


// This defines the WaveScript primitives that the code generated by
// the WaveScript compiler depends upon.
 class WSPrim {

   public:   

   //  We should keep a hash table of common plans.
   //static int fft(SigSeg<double> input) {
   static RawSeg fft(RawSeg input) {

      int len = input.length();
      int len_out = (len / 2) + 1;

      RawSignal out_sig = RawSignal(sizeof(wscomplex_t));
      //wscomplex_t* out_buf = (wscomplex_t*)out_sig.getBuffer(sizeof(wscomplex_t) * len_out);
      wscomplex_t* out_buf = (wscomplex_t*)out_sig.getBuffer(len_out);

      // Can't get the padding we need from getDirect!!
      Byte* temp;
      input.getDirect(0, input.length(), temp);
      float* in_buf = (float*)temp;

      // Real to complex:
      fftwf_plan plan = fftwf_plan_dft_r2c_1d(len, in_buf, (fftwf_complex*)out_buf, FFTW_ESTIMATE);
      
      for(int i=0; i<len; i++) in_buf[i] = 93.9;
      for(int i=0; i<len_out; i++) out_buf[i] = out_buf[i];      

      //      fftwf_execute(plan);
//       fftwf_destroy_plan(plan);
      
      //fftw_free(p->vec);

      /* return the sigseg */
      printf("About to do a commit.\n");
      // This causes a bad_weak_ptr exception:
      RawSeg out = out_sig.commit(len_out);
      printf("Finished commit.\n");
      
      return RawSeg();
      //return SigSeg<double>();
      //return *((SigSeg<wscomplex_t>*)0);
   }

   inline static wsbool_t wsnot(wsbool_t b) {
     return (wsbool_t)!b;
   }

   static wsint_t width(const RawSeg& w) {
     return (wsint_t)w.length();
   }
   static wsint_t start(const RawSeg& w) {
     return (wsint_t)w.start();
   }
   static wsint_t end(const RawSeg& w) {
     return (wsint_t)w.end();
   }

   static RawSeg joinsegs(const RawSeg& a, const RawSeg& b) {
     return RawSeg::append(a,b);
   }
   // Currently takes start sample number (inclusive) and length.
   // TODO: Need to take SeqNo for start!
   static RawSeg subseg(const RawSeg& ss, wsint_t start, wsint_t len) {
     uint32_t offset = (uint32_t)((SeqNo)start - ss.start());
     //return ss.subseg(offset, offset+len);
     return RawSeg::subseg(ss, offset, len); // INCONSISTENT DOCUMENTATION! FIXME!
   }
      
   static wsstring_t stringappend(const wsstring_t& A, const wsstring_t& B) {
     return A+B;
   }

   // Simple hash function, treat everything as a block of bits.
   static size_t generic_hash(unsigned char* ptr, int size) {
     size_t hash = 5381;
     int c;
     for(int i=0; i<size; i++) 
       hash = ((hash << 5) + hash) + ptr[i]; /* hash * 33 + c */	 	 
     return hash;
   }   
   
   // Optimized version, unfinished.
   /*
   static unsigned long hash(unsigned char* ptr, int size) {
     int stride = sizeof(unsigned long);
     unsigned long hash = 5381;
     unsigned long* chunked = (unsigned long*)ptr;
     int rem = size % stride;
     for (int i=0; i < size/stride; i++) {
       hash = ((hash << 5) + hash) + chunked[i];
     }
     for (int i=0; i < rem; i++) {
       //FINISH
     }
     return hash;
   }
   */

};



// These are built-in WSBoxes. 
// Most of these are intended to go away at some point.
class WSBuiltins {
   
public:

   /* Zip2 operator: takes 2 input streams of types T1 and T2 and emits zipped
      tuples, each containing exactly one element from each input stream. */
   template <class T1, class T2> class Zip2: public WSBox {
   public:
     Zip2< T1, T2 >() : WSBox("zip2") {}
  
     /* Zip2 output type */
     struct Output
     {
       T1 _first;
       T2 _second;
    
       Output(T1 first, T2 second) : _first(first), _second(second) {}
       friend ostream& operator << (ostream& o, const Output& output) { 
	 cout << "< " << output._first << ", " << output._second << " >"; return o; 
       }
     };

   private:
     DEFINE_OUTPUT_TYPE(Output);
  
     bool iterate(uint32_t port, void *item)
     {
       m_inputs[port]->requeue(item);

       bool _e1, _e2; /* indicates if elements available on input streams */
       _e1 = (m_inputs[0]->peek() != NULL); _e2 = (m_inputs[1]->peek() != NULL);
    
       while(_e1 && _e2) {
	 T1* _t1 = (T1*)(m_inputs[0]->dequeue()); 
	 T2* _t2 = (T2*)(m_inputs[1]->dequeue()); 
	 emit(Output(*_t1, *_t2)); /* emit zipped tuple */
	 delete _t1; delete _t2;
	 _e1 = (m_inputs[0]->peek() != NULL); _e2 = (m_inputs[1]->peek() != NULL);
       }
       return true;
     }
   };



  /* This takes Signal(T) to Signal(SigSeg(T)) */

  // THIS GETS THE SAME BAD_WEAK_PTR EXCEPTION AS ABOVE:
/* 
  class Window : public WSBox{    
    public:
    Window(int winsize, size_t bitsize) : WSBox("Window"),      
					  out_sig(new RawSignal(bitsize))
    {      
      window_size = winsize;
      elem_size = bitsize;
      ind = 0;
      current_buf = out_sig->getBuffer(bitsize * winsize);
    }
    ~Window() {
      delete out_sig;
      //delete current_buf;
    }

    private:
    DEFINE_OUTPUT_TYPE(RawSeg);
    
    int window_size;
    size_t elem_size;
    RawSignal* out_sig;

    void* current_buf;
    int ind;
    
    bool iterate(uint32_t port, void *item)
    {
      memcpy(((unsigned char*)current_buf + (ind*elem_size)), 
	     item, 
	     elem_size);
      ind++;
      if (ind == window_size) {
	emit(out_sig->commit(window_size));
	ind = 0;
	//current_buf = out_sig->getBuffer(window_size * elem_size);
	current_buf = out_sig->getBuffer(window_size);
      }
      return true;
    }
  };
*/

  class Window : public WSBox{    
   
    public:
    Window(int winsize, size_t bitsize) : WSBox("Window"),
      //rs(new RawSeg(RawSignalPtr(new RawSignal(0)),(SeqNo)0,winsize))
      rs(new RawSeg((SeqNo)0,winsize,DataSeg,0,bitsize,Unitless,true))      
      //RawSeg(const RawSignalPtr parent, SeqNo start, uint32_t length, GapType isGap = DataSeg);
    {      
      window_size = winsize;
      elem_size = bitsize;
      ind = 0;      
      sampnum = 0;      
      assert(rs->getDirect(0,winsize,current_buf));
    }

    private:
    DEFINE_OUTPUT_TYPE(RawSeg);
    
    int window_size;
    size_t elem_size;

    SeqNo sampnum;
    RawSeg* rs;
    Byte* current_buf;
    int ind;
        
    bool iterate(uint32_t port, void *item)
    {
      memcpy((current_buf + (ind*elem_size)),
	     item,
	     elem_size);
      ind++;
      sampnum++;
      if (ind == window_size) {
	rs->release(current_buf);
	emit(*rs);
	ind = 0;
	rs = new RawSeg(sampnum,window_size,DataSeg,0,elem_size,Unitless,true);
	//rs = new RawSeg(RawSignalPtr(new RawSignal(0)), sampnum, window_size);
	assert(rs->getDirect(0,window_size,current_buf));
      }
      return true;
    }
  };


  
};
