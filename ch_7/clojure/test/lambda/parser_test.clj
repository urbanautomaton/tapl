(ns lambda.parser-test
  (:require [clojure.test :refer :all]
            [lambda.parser :refer :all]))

(defn assert-eq [x y] (is (= x y)))

(deftest test-parse
  (testing "lambda term:"
    (testing "variable"
      (assert-eq
        (parse "a")
        [:expr [:var "a"]]))

    (testing "long variable name"
      (assert-eq
        (parse "azazazaz")
        [:expr [:var "azazazaz"]]))

    (testing "parenthesised variable"
      (assert-eq
        (parse "(a)")
        [:expr [:var "a"]]))

    (testing "application"
      (assert-eq
        (parse "a b c")
        [:expr
         [:app
          [:app [:var "a"] [:var "b"]]
          [:var "c"]]] ))

    (testing "parenthesised application"
      (assert-eq
        (parse "a (b c)")
        [:expr
         [:app
          [:var "a"]
          [:app
           [:var "b"]
           [:var "c"]]]]))

    (testing "abstraction"
      (assert-eq
        (parse "λ.x x y")
        [:expr
         [:abs
          [:var "x"]
          [:app
           [:var "x"]
           [:var "y"]]]]))

    (testing "application of abstractions"
      (assert-eq
        (parse "(λ.x x) (λ.y y)")
        [:expr
         [:app
          [:abs
           [:var "x"]
           [:var "x"]]
          [:abs
           [:var "y"]
           [:var "y"]]]]))

    (testing "nested abstractions"
      (assert-eq
        (parse "λ.x λ.y λ.z x y z")
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
             [:var "z"]]]]]]))

    (testing "parenthesised abstractions"
      (assert-eq
        (parse "λ.x (λ.y x) y")
        [:expr
         [:abs
          [:var "x"]
          [:app
           [:abs
            [:var "y"]
            [:var "x"]]
           [:var "y"]]]]))))
