(ns lambda.core
  (:require [instaparse.core :as insta]
            [clojure.core.match :refer [match]]
            [clojure.core.logic])
  (:refer-clojure :exclude [==])
  (:use clojure.core.logic))

(def lambda-parser (insta/parser (clojure.java.io/resource "lambda.bnf")))

(defn debruinify
  ([term] (debruinify term ()))
  ([term bound]
   (match term
          [:expr a] (debruinify a bound)
          [:app a b] [:app (debruinify a bound) (debruinify b bound)]
          [:abs a b] [:abs (debruinify b (conj bound a))]
          [:var a] [:var (.indexOf bound [:var a])])))

(debruinify (lambda-parser "(λ.x x) (λ.y y)"))
(debruinify (lambda-parser "λ.x (λ.x x) x"))
(debruinify (lambda-parser "λ.x λ.y λ.z x y z"))
(debruinify (lambda-parser "λ.x y"))

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

(run 1 [q]
      (replace-in [:var "a"] [:var "a"] [:var "b"] q))

(run 1 [q]
     (evaluate (lambda-parser "(λ.x x) (λ.y y)") q))

(run 1 [q]
     (evaluate (lambda-parser "(λ.x x) ((λ.y y) (λ.z z))") q))
