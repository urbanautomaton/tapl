(ns lambda.parser
  (:require [instaparse.core :as insta]
            [lambda.terms :refer :all]))

(def parse
 (recordize (insta/parser (clojure.java.io/resource "lambda.bnf"))))

(rest [1 2 3])
(last [1 2 3])

(defn- recordize [term]
  (case (first term)
    :var (Var. (last term))
    :app (apply App. (map recordize (rest term)))
    :abs (Abs. (recordize (last term)))))
