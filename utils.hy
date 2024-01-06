;;; -*- coding:utf-8; mode:hy; -*-

(import time [time sleep]
        pydoc [apropos]
        hy.core.hy-repr [hy-repr]
        toolz [first second last])

(require hyrule [loop
                 unless
                 defmacro/g!
                 assoc
                 ->])

(eval-and-compile
  ;;; Print utilities
  (defn p [#* objs]
    (print #*(lfor obj objs (hy-repr obj)))
    (last objs))

  ;;; debug-print
  (defreader >
    (setv code (.parse-one-form &reader))
    `(do (print (hy-repr '~code) " => " ~code) ~code))

  ;;; time macro
  (defmacro/g! timeit [#* body]
    `(do
       (setv g!start (time))
       ~@body
       (setv g!end (time))
       (print (+ (.format "Evaluation took: {0}" (- g!end g!start)) " seconds"))))

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

  (defmacro incf [n [delta 1]]
    `(setv ~n (+ ~n ~delta)))

  (defmacro decf [n [delta 1]]
    `(setv ~n (- ~n ~delta)))

  (defn 1+ [n]
    (+ n 1))

  (defn 1- [n]
    (- n 1))

;;; List functions

  (defn butlast [lst]
    (cut lst None -1))

  (defn apply [func #* args-last-elem-lst]
    (func #*(+ (list (butlast args-last-elem-lst))
               (last args-last-elem-lst))))

  (defn mapcar [func #* iterables]
    (list (map func #* iterables)))

  (defn remove-if-not [func iterable]
    (list (filter func iterable)))

  (setv nil (hy.models.Expression '()))

  (defn null [ls]
    (= nil ls))

  (defmacro nilf [x]
    `(setv ~x nil))

  (defn lst [#* args]
    (hy.models.Expression args))

  (defn cons [obj lst]
    `(~obj ~@lst))

  (defn car [lst]
    (if (null lst)
        nil
        (first lst)))

  (defn cdr [lst]
    (cut lst 1 None None))

  (defn caar [lst]
    (-> lst car car))

  (defn cddr [lst]
    (-> lst cdr cdr))

  (defn cadr [lst]
    (-> lst cdr car))

  (defn cdar [lst]
    (-> lst car cdr))

  (defmacro push [elem lst]
    `(setv ~lst (cons ~elem ~lst)))

  (defn append [ls1 ls2]
    (+ ls1 ls2))

  (defmacro subseq [sequence start [end None]]
    `(cut ~sequence ~start ~end))

  (defn nreverse [ls]
    (.reverse ls)
    ls)

  (defn nconc [x y]
    (.extend x y)
    x)

;;; Macros

  (defmacro progn [#* body]
    `(do ~@body))

  (defmacro/g! prog1 [#* body]
    `(progn
       (setv ~g!sexp-1 ~(car body))
       (progn
         ~@(cdr body)
         ~g!sexp-1)))

  (defmacro pop [lst]
    `(prog1
       (car ~lst)
       (setv ~lst (cdr ~lst))))
  )
