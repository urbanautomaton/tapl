(ns lambda.parser
  (:require [instaparse.core :as insta]))

(def parse (insta/parser (clojure.java.io/resource "lambda.bnf")))
