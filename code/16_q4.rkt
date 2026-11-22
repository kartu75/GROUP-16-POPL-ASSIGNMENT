#lang racket/base

;; (my-length lst): returns the number of top-level elements in lst using tail recursion with an accumulator (base case: empty list returns acc; recursive case: increments acc and recurses on cdr).
(define (my-length lst)
  (let loop ([remaining lst]
             [acc 0])
    (if (null? remaining)
        acc
        (loop (cdr remaining) (+ acc 1)))))
