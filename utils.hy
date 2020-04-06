;;; -*- coding:utf-8; mode:hy; -*-

(import [time [time sleep]]
        [pydoc [apropos]]
        [hy.contrib.hy-repr [hy-repr]])

(require [hy.contrib.loop [*]])

(eval-and-compile
;;; Print utilities
  (defn p [&rest objs] 
    (print #*(lfor obj objs (hy.contrib.hy-repr.hy-repr obj))))

  (deftag ? [code]
    `(do (print (hy.contrib.hy-repr.hy-repr '~code) " => " ~code) ~code))

  (defmacro timeit [&rest body]
    (setv start (gensym 'start)
          end   (gensym 'end))
    `(do
       (setv ~start (time))
       ~@body
       (setv ~end (time))
       (print (+ (.format "Evaluation took: {0}" (- ~end ~start)) " seconds"))))

  (defn typep [obj objtype]
    (= (name (type obj))
       (name objtype)))

;;; Identical functions

  (defn eq [x y]
    (is x y))

  (defn equal [x y]
    (= x y))

;;; Numerical functions

  (defn mod [n m]
    (% n m))

  (defn zerop [n]
    (= n 0))

  (defn plusp [n]
    (> n 0))

  (defn minusp [n]
    (< n 0))

  (defn evenp [n]
    (zerop (mod n 2)))

  (defn oddp [n]
    (not (evenp n)))

  (defn divisible [n m]
    (zerop (mod n m)))

  (defmacro incf [n &optional [delta 1]]
    `(setv ~n (+ ~n ~delta)))

  (defmacro decf [n &optional [delta 1]]
    `(setv ~n (- ~n ~delta)))

;;; List functions

  (defn apply [func &rest args-last-elem-lst]
    (func #*(+ (list (butlast args-last-elem-lst)) (last args-last-elem-lst))))

  (defn mapcar [func &rest iterables]
    (list (map func #*iterables)))

  (defn remove-if-not [func iterable]
    (list (filter func iterable)))

  (setv nil (HyExpression '()))

  (defn null [ls]
    (= nil ls))

  (defmacro nilf [x]
    `(setv ~x nil))

  (defn lst [&rest args]
    (HyExpression args))

  (defn cons [obj lst]
    `(~obj ~@lst))

  (defn car [lst]
    (if (null lst)
        nil
        (first lst)))

  (defn cdr [lst]
    (cut lst 1))

  (defn caar [lst]
    (-> lst car car))

  (defn cddr [lst]
    (-> lst cdr cdr))

  (defn cadr [lst]
    (-> lst cdr car))

  (defn cdar [lst]
    (-> lst car cdr))

  (defmacro push (elem lst)
    `(setv ~lst (cons ~elem ~lst)))

  (defn append [ls1 ls2]
    (+ ls1 ls2))

  (defmacro subseq [sequence start &optional end]
    `(cut ~sequence ~start ~end))

  (defn nreverse [ls]
    (.reverse ls)
    ls)

  (defn nconc [x y]
    (.extend x y)
    x)

;;; Macros

  (defmacro progn [&rest body]
    `(do ~@body))

  (defmacro! prog1 [&rest body]
    `(progn
       (setv ~g!sexp-1 ~(car body))
       (progn
         ~@(cdr body)
         ~g!sexp-1)))

  (defmacro pop (lst)
    `(prog1
       (car ~lst)
       (setv ~lst (cdr ~lst))))

  (defmacro let [var-pairs &rest body]
    (setv var-names (list (map first  var-pairs))
          var-vals  (list (map second var-pairs)))
    `((fn [~@var-names] ~@body) ~@var-vals))

  (defmacro let* [var-pairs &rest body]
    (defn flatten-var-pairs [ls]
      (import itertools)
      (for [el ls]
        (unless (= (len el) 2)
          (raise SyntaxError)))
      (itertools.chain.from-iterable ls))
    `((fn []
        (setv ~@(flatten-var-pairs var-pairs))
        ~@body)))
)
