#!r6rs

;; To have a monomorphic program, it is necessary that we replicate
;; the union-type declarations for each type they are instantiated at.

;; FIXME [2007.10.11] UNFINISHED

;; CURRENTLY THIS ONLY PRUNES OUT UNUSED UNION TYPE DECLS!

(library (ws passes static_elaborate split-union-types)
  (export split-union-types)
  (import (except (rnrs (6)) error) (ws common)
	  (ws util tsort)
	  (ws passes normalize_source typecheck)
	  (ws passes static_elaborate static-elaborate)
	   )

  (define instancetable 'uninit) ;; Counts instances of each type.
  (define varianttable  'uninit) ;; Maps constructor name to type name.
  (define counter       'uninit)

  (define (symappendcntr sym n)
    (string->symbol (string-append (symbol->string sym) "_" (number->string n))))
  
  (define (instance->number type)
    (match type
      [(Sum ,typename . ,t*)
       (let* ([existing-instances (hashtab-get instancetable typename)]
	      [entry (assoc type existing-instances)])
	 (match entry
	   [#f 
	    (set! counter (fx+ 1 counter))
	    (hashtab-set! instancetable typename
			  (cons (list type counter)
				existing-instances))
	    counter]
	   [(,ty ,cntr) cntr]))
       ]))


  (define (type->allsums ty)
    (match ty
      [(Sum ,name ,t* ...) (ASSERT symbol? name) (list name)]
      [,s (guard (symbol? s)) '()]
      [,s (guard (string? s)) '()]
      [(,qt ,v) (guard (memq qt '(quote NUM)) (symbol? v)) '()]
      [#(,[t*] ...) (apply append t*)]
      ;[(,[arg*] ... -> ,[ret]) (apply append ret arg*)]
      [(,C ,[t*] ...) (guard (symbol? C)) (apply append t*)]))

  ;; Do a topological sort of the unions so that declaration precedes use.
  ;; This makes it easier on subsequent backends.
  (define (sortunions unions)
    (let ([ordering (apply append
		      (map (lambda (entry)
			     (match entry
			       [((,tyname) (,tag* ,ty** ...) ...)
				(cons (list tyname) ;; Throw in a dummy edge to ensure we keep it.
				(map (lambda (used) (list used tyname))				  
				 (apply append 
					(map (lambda (ty*) (apply append (map type->allsums ty*)))
					  ty**))))]))
			unions))]
	  [lookup (map (lambda (entry) (cons (caar entry) (cdr entry))) unions)])
      (let ([new (map (lambda (name)
			(let ([entry (assq name lookup)])
			  (cons (list (car entry)) (cdr entry))))
		   (topological-sort ordering))])
	(when (>= (regiment-verbosity) 2)
	  (printf "Split and sorted union types into:\n")
	  (pretty-print new))
	new)))

  (define-pass split-union-types
    (define (Type ty)
      (match ty
	[(Sum ,name ,t* ...)
;	 (printf "CONVERTING TYPE: Sum ~a ~a\n" name t*)
	 `(Sum ,(symappendcntr name (instance->number (depoly `(Sum ,name ,@t*)))))]
	[,s (guard (symbol? s)) s]
	[,s (guard (string? s)) s]
	[#(,[t*] ...) (list->vector t*)]
	[(,[arg] ... -> ,[ret]) `(,@arg -> ,ret)]
	[(,qt ,v) (guard (memq qt '(quote NUM)) (symbol? v)) `(,qt ,v)]
	[(,C ,[t*] ...) (guard (symbol? C)) (cons C t*)])
      )
    (define (depoly urty)
      (if (polymorphic-type? urty)
	  ;; [2007.10.27] Doing this for now.   It's easy (and legal) to have under-constrained Sums.
	  (begin (printf "WARNING: squishing out unresolved polymorphism in sum type: ~s\n" urty)
		 (type-replace-polymorphic urty '#()))
	  urty))
    
    [Bindings 
     (lambda (vars types exprs reconstr exprfun)
       (reconstr vars (map Type types) (map exprfun exprs)))]
    [Expr (lambda (x fallthru)
	    (match x 
	      [(assert-type ,urty (construct-data ,tc ,[args] ...))
;	       (printf "GOT CONSTRUCTDATA: ~a ~a\n" tc ty)
	       ;(ASSERT (not (polymorphic-type? ty)))
	       (define ty (depoly urty))
	       (let* (;[typename (hashtab-get varianttable tc)]
		      [cntr (instance->number ty)])
		 `(construct-data ,(symappendcntr tc cntr) ,@args))]
	      [(wscase (assert-type ,ursumty ,[x]) (,tag* ,[fun*]) ...)
	       ;(ASSERT (not (polymorphic-type? sumty)))
	       (define sumty (depoly ursumty))
	       (let ([cntr (instance->number sumty)])
		 `(wscase ,x ,@(map list (map (lambda (s) (symappendcntr s cntr)) tag*) fun*)))]

	      [(construct-data . ,_) (error 'split-union-types "construct-data without type assertion")]
	      [(wscase . ,_)         (error 'split-union-types "wscase without type assertion")]

	      ;; FIXME:: WE JUST DONT TOUCH THE ASCRIPTIONS:
	      [(assert-type ,ty ,[e])  
	       (let ([converted (Type ty)])
		 #;
		 (unless (equal? ty converted)
		   (inspect (vector "Converted ascription: " converted)))
		 `(assert-type ,converted ,e)
		 )]
	      [,other (fallthru other)]))]
    [Program 
     (lambda(prog Expr)	  
       (match prog
	 [(,inputlang '(program ,bod ,meta* ... ,type))
	  (let* ([union-types (cdr (or (assq 'union-types meta*) '(union-types)))]
		 [union-lookup (map (lambda (pr) (cons (caar pr) (cdr pr))) union-types)]
		 [tenv (sumdecls->tenv union-types)])
;	    (inspect union-types)
	    (fluid-let ([varianttable (make-default-hash-table (* 5 (length union-types)))]
			[instancetable (make-default-hash-table (* 5 (length union-types)))]
			[counter 0])
	      (for-each (match-lambda (((,name . ,_) . ,variants))		
		(hashtab-set! instancetable name '())
		(for-each (match-lambda ((,tc ,ty))			    
			    (hashtab-set! varianttable tc name)
			    ) variants))
		union-types)
	      ;; Now process the body:
	      (let ([newty (Type type)] [newbod (Expr bod)])
		(define newunions
		  (apply append
			 (map (lambda (entry)
				(map (match-lambda (((Sum ,tyname . ,tyargs) ,cntr))
;				       (printf "OUTPUTTING: ~a ~a\n" tyname cntr)
				       `((,(symappendcntr tyname cntr))
					 ,@(map (match-lambda ((,vartname . ,_))
						  (cons (symappendcntr vartname cntr)
							(map export-type
							  (sum-instance! tenv 
									(instantiate-type `(Sum ,tyname ,@(map Type tyargs)))
									vartname))))
					     (cdr (assq tyname union-lookup)))
					 ))
				  (hashtab-get instancetable (caar entry))))
			   union-types)))
;		(inspect newunions)
		`(,inputlang '(program ,newbod 
				(union-types ,@(sortunions newunions))
				,(remq (assq 'union-types meta*) meta*) ... ,newty))))
	    )]))]
    ) ;; End pass

#;
  (define-pass rename-constructors
    [Expr ])



) ;; End module
