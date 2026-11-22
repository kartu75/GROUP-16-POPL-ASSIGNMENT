#lang racket/base

;; (my-length lst): returns the number of top-level elements in lst using tail recursion with an accumulator (base case: empty list returns acc; recursive case: increments acc and recurses on cdr).
(define (my-length lst)
  (let loop ([remaining lst]
             [acc 0])
    (if (null? remaining)
        acc
        (loop (cdr remaining) (+ acc 1)))))

;; (my-map f lst): applies the one-argument function f to every element of lst and returns the list of results in the same order (base case: empty list returns '(); recursive case: conses (f (car lst)) onto (my-map f (cdr lst))).
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

;; (insert-if-short x lst n): inserts x at the front of every list (at all nesting levels) whose original length is less than n, defined via make-inserter.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (k) (< k n))) lst))

;; (print-insert-result): reads x, lst, and n in order from standard input, applies insert-if-short, and outputs the result with display followed by a newline.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)]
         [res (insert-if-short x lst n)])
    (display res)
    (newline)))

;; (make-inserter x len-ok?): returns a function of one argument (lst) that inserts x at the front of every list (at all nesting levels) whose original length satisfies predicate len-ok?.
(define (make-inserter x len-ok?)
  (letrec ([insert
            (lambda (lst)
              (let* ([orig-len (my-length lst)]
                     [processed (my-map (lambda (elem)
                                          (if (or (pair? elem) (null? elem))
                                              (insert elem)
                                              elem))
                                        lst)])
                (if (len-ok? orig-len)
                    (cons x processed)
                    processed)))])
    insert))




