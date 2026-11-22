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

