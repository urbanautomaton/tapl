(ns lambda.core
  (:require [clojure.core.logic :refer :all]
            [clojure.core.match :refer [match]]
            [lambda.parser :refer [parse]]
            [lambda.terms :refer :all]
            [lambda.names :refer [fresh-name]])
  (:import [lambda.terms Var App Abs])
  (:refer-clojure :exclude [==]))

(defne replace-in [in name with result]
  ([[:var a] [:var a] with with])
  ([[:var a] [:var b] _ [:var a]] (!= a b))
  ([[:app t1 t2] _ with _] (fresh [t1r t2r]
                                  (replace-in t1 name with t1r)
                                  (replace-in t2 name with t2r)
                                  (== result [:app t1r t2r])))
  ([[:abs a b] a _ [:abs a b]])
  ([[:abs a t1] name with _] (fresh [t1r]
                                    (replace-in t1 name with t1r)
                                    (== result [:abs a t1r]))))

(defne evaluate [expr result]
  ([[:expr a] _]
   (evaluate a result))
  ([[:app t1 t2] _]
   (fresh [t1r]
          (evaluate t1 t1r)
          (== result [:app t1r t2])))
  ([[:app [:abs a b] t2] _]
   (fresh [t2r]
          (evaluate t2 t2r)
          (== result [:app [:abs a b] t2r])))
  ([[:app [:abs a b] [:abs x y]] _]
   (replace-in b a [:abs x y] result)))
