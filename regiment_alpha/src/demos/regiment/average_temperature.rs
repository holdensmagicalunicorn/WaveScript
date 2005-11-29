;; This performs the ever-popular "average temperature" query.
;; It uses default sampling rates.

(parameters [sim-timeout 3000]
	    [simalpha-channel-model 'lossless]
	    [simalpha-failure-model  'none]
	    [simalpha-zeropad-args #t];'warning] ;; Sync-sensing necessitates continuations.
	    [simalpha-sense-function sense-sine-wave])

;; Main program:

(letrec ([readings (rmap (lambda (n) (cons (sense n) 1))
			 world)]
	 [aggr (lambda (x y)
		 (cons (+ (car x)
			  (car y))
		       (+ (cdr x)
			  (cdr y))))]
	 [div (lambda (v) 
		(if (= (cdr v) 0) 0 ;; Just return zero if there are no samples to avg.
		    (/ (car v) (cdr v))))]
	 [sums (rfold aggr (cons 0 0) readings)]
	 [result (smap div sums)])
  result)
