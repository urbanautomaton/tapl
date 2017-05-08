(ns lambda.core
  (:require [instaparse.core :as insta]
            [clojure.core.match :refer [match]]
            [clojure.core.logic])
  (:refer-clojure :exclude [==])
  (:use clojure.core.logic))

(def lambda-parser (insta/parser (clojure.java.io/resource "lambda.bnf")))

(defn free-variables 
  ([term] (free-variables term ()))
  ([term bound] 
   (match term
          [:expr a] (free-variables a bound)
          [:app a b] (concat (free-variables a bound) (free-variables b bound))
          [:abs a b] (free-variables b (conj bound a))
          [:var a] (if (some #{[:var a]} bound) '() (list [:var a])))))

(defn remove-names
  ([term] (let [naming (free-variables term)]
            (remove-names term () naming)))
  ([term bound naming]
   (match term
          [:expr a] (remove-names a bound naming)
          [:app a b] [:app (remove-names a bound naming) (remove-names b bound naming)]
          [:abs a b] [:abs (remove-names b (conj bound a) naming)]
          [:var a] (cond
                     (some #{[:var a]} bound) [:var (.indexOf bound [:var a])]
                     (some #{[:var a]} naming) [:var (+ (.indexOf naming [:var a]) (count bound))]
                     :else (throw (Exception. "variable encountered that's neither bound, nor in naming context"))))))

(defn string-to-codes [string]
  (map int (seq string)))

(defn codes-to-string [codes]
  (apply str (map char codes)))

(empty? '())

(seq 3)

(defn increment-codes [codes min max]
  (if (empty? codes) (list min)
    (let [[head & rest] codes
          head-inc (inc head)]
      (if (> head-inc max)
        (conj (increment-codes rest min max) min)
        (conj rest head-inc)))))

(increment-codes [10 10 10] 0 10)


(defn next-name [name]
  (codes-to-string (increment-codes (reverse (string-to-codes)) name 97 122)))

(int \z)

(next-name "a")

(split)

(int \a)

(str \a \b)
(seq "hello")

(str "a" "b")

(defn fresh-name
  ([taken] (fresh-name "a" taken))
  ([taken current] (if (some #{current} taken)
                     (fresh-name (next-name current) taken)
                     current)))

(defn restore-names [term naming]
  )

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
