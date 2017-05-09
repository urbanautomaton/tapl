(ns lambda.core
  (:require [clojure.core.logic :refer :all]
            [clojure.core.match :refer [match]]
            [lambda.parser :refer [parse]])
  (:refer-clojure :exclude [==]))

(defmulti free-variables-mm (fn [term bound] (first term)))
(defmethod free-variables-mm :expr
  [[_ a] bound]
  (free-variables-mm a bound))
(defmethod free-variables-mm :app
  [[_ a b] bound]
  (concat (free-variables-mm a bound) (free-variables-mm b bound)))
(defmethod free-variables-mm :abs
  [[_ a b] bound]
  (free-variables-mm b (conj bound a)))
(defmethod free-variables-mm :var
  [[_ a] bound]
  (if (some #{[:var a]} bound) '() (list [:var a])))

(defn free-variables [term] (free-variables-mm term ()))

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

(defn increment-codes [codes min max]
  (if (empty? codes) (list min)
    (let [[head & rest] codes
          head-inc (inc head)]
      (if (> head-inc max)
        (conj (increment-codes rest min max) min)
        (conj rest head-inc)))))

(defn next-name [name]
  (codes-to-string
    (increment-codes
      (reverse (string-to-codes name))
      (int \a)
      (int \z))))

(defn fresh-name
  ([taken] (fresh-name taken "a"))
  ([taken current] (if (some #{current} taken)
                     (fresh-name taken (next-name current))
                     current)))

(defn restore-names [term naming]
  (match term
         [:expr a] (restore-names a naming)
         [:app a b] [:app (restore-names a naming) (restore-names b naming)]
         [:abs b] (let [name (fresh-name naming)]
                    [:abs [:var name] (restore-names b (conj naming name))])
         [:var a] [:var (nth naming a)]))

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
