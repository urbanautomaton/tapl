(ns lambda.parser
  (:require [instaparse.core :as insta]
            [lambda.terms :refer :all])
  (:import [lambda.terms Var App Abs]))

(defn- recordize [term]
  (case (first term)
    :var (Var. (last term))
    :app (apply ->App (map recordize (rest term)))
    :abs (apply ->Abs (map recordize (rest term)))))

(def parser (insta/parser (clojure.java.io/resource "lambda.bnf")))

(defn parse [input]
 (recordize (last (parser input))))
