(ns lambda.core
  (:require [instaparse.core :as insta]))

(def lambda-parser (insta/parser (clojure.java.io/resource "lambda.bnf")))

(defn assert-eq [x y] (assert (= x y)))

(assert-eq
  (lambda-parser "a b c")
  [:expr
   [:app
    [:app [:var "a"] [:var "b"]]
    [:var "c"]]] )

(assert-eq
  (lambda-parser "a (b c)")
  [:expr
   [:app
    [:var "a"]
    [:app
     [:var "b"]
     [:var "c"]]]])

(assert-eq
  (lambda-parser "λ.x x y")
  [:expr
   [:abs
    [:var "x"]
    [:app
     [:var "x"]
     [:var "y"]]]])

(assert-eq
  (lambda-parser "(λ.x x) (λ.y y)")
  [:expr
   [:app
    [:abs
     [:var "x"]
     [:var "x"]]
    [:abs
     [:var "y"]
     [:var "y"]]]])

(assert-eq
  (lambda-parser "λ.x λ.y λ.z x y z")
  [:expr
   [:abs
    [:var "x"]
    [:abs
     [:var "y"]
     [:abs
      [:var "z"]
      [:app
       [:app
        [:var "x"]
        [:var "y"]]
       [:var "z"]]]]]])
