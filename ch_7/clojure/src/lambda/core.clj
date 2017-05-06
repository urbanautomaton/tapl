(ns lambda.core
  (:require [instaparse.core :as insta]))

(def lambda-parser (insta/parser (clojure.java.io/resource "lambda.bnf")))
