#lang racket/base

;; tree-value: returns the value of the root node of the binary tree
(define (tree-value tree) (car tree))

;; tree-left: returns the left subtree of the binary tree
(define (tree-left tree) (cadr tree))

;; tree-right: returns the right subtree of the binary tree
(define (tree-right tree) (caddr tree))

;; inorder-acc: returns acc if tree is empty; otherwise recurses on left subtree with cons of value and right traversal as accumulator
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (tree-left tree)
                   (cons (tree-value tree)
                         (inorder-acc (tree-right tree) acc)))))

;; print-inorder: prints the inorder list of tree values followed by a newline
(define (print-inorder tree)
  (begin
    (display (inorder-acc tree '()))
    (newline)))

;; preorder-acc: returns acc if tree is empty; otherwise conses root value onto preorder traversal of left and right subtrees with acc
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (tree-value tree)
            (preorder-acc (tree-left tree)
                          (preorder-acc (tree-right tree) acc)))))

;; postorder-acc: returns acc if tree is empty; otherwise traverses left subtree with postorder traversal of right subtree and consed root value as accumulator
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (tree-left tree)
                     (postorder-acc (tree-right tree)
                                    (cons (tree-value tree) acc)))))

;; print-all-traversals: prints inorder, preorder, and postorder traversals of tree, each on a new line
(define (print-all-traversals tree)
  (begin
    (display (inorder-acc tree '()))
    (newline)
    (display (preorder-acc tree '()))
    (newline)
    (display (postorder-acc tree '()))
    (newline)))

;; tree-height: returns 0 if tree is empty; otherwise 1 plus the maximum of left and right subtree heights
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (tree-left tree))
                (tree-height (tree-right tree))))))

;; leaf-count: returns 0 for empty tree, 1 for a leaf node, or sum of leaf counts of left and right subtrees
(define (leaf-count tree)
  (cond
    ((null? tree) 0)
    ((and (null? (tree-left tree)) (null? (tree-right tree))) 1)
    (else (+ (leaf-count (tree-left tree))
             (leaf-count (tree-right tree))))))

;; print-height-and-leaves: prints the two-element list of height and leaf-count followed by a newline
(define (print-height-and-leaves tree)
  (begin
    (display (list (tree-height tree) (leaf-count tree)))
    (newline)))
