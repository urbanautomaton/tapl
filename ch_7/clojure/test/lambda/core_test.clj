(ns lambda.core-test
  (:require [clojure.test :refer :all]
            [lambda.core :refer :all]))

(defn assert-eq [x y] (is (= x y)))

(deftest test-free-variables
  (testing "free-variables:"
    (testing "identity"
      (assert-eq
        (free-variables (lambda-parser "λ.x x"))
        '()))

    (testing "some free variables"
      (assert-eq
        (free-variables (lambda-parser "(λ.x x) y z"))
        '([:var "y"] [:var "z"])))))

(deftest test-remove-names
  (testing "remove-names:"
    (testing "identity"
      (assert-eq
        (remove-names (lambda-parser "λ.x x"))
        [:abs [:var 0]]))

    (testing "nested abstractions"
      (assert-eq
        (remove-names (lambda-parser "λ.x λ.y λ.z x y z"))
        [:abs
         [:abs
          [:abs
           [:app
            [:app [:var 2] [:var 1]]
            [:var 0]]]]]))

    (testing "free variable"
      (assert-eq
        (remove-names (lambda-parser "λ.x y"))
        [:abs [:var 1]]))

    (testing "explicit naming context"
      (assert-eq
        (remove-names (lambda-parser "λ.w y w") '() '([:var "b"] [:var "a"] [:var "z"] [:var "y"] [:var "x"]))
        [:abs [:app [:var 4] [:var 0]]]))))

(deftest test-restore-names
  (testing "restore-names:"
    (testing "identity"
      (assert-eq
        (restore-names [:abs [:var 0]] '())
        [:abs [:var "a"] [:var "a"]]))

    (testing "with naming context"
      (assert-eq
        (restore-names [:abs [:app [:var 0] [:var 1]]] '("w"))
        [:abs [:var "a"] [:app [:var "a"] [:var "w"]]]))

    (testing "avoiding a name collision"
      (assert-eq
        (restore-names [:abs [:var 0]] '("a"))
        [:abs [:var "b"] [:var "b"]]))))

(deftest test-lambda-parser
  (testing "lambda term:"
    (testing "variable"
      (assert-eq
        (lambda-parser "a")
        [:expr [:var "a"]]))

    (testing "long variable name"
      (assert-eq
        (lambda-parser "azazazaz")
        [:expr [:var "azazazaz"]]))

    (testing "parenthesised variable"
      (assert-eq
        (lambda-parser "(a)")
        [:expr [:var "a"]]))

    (testing "application"
      (assert-eq
        (lambda-parser "a b c")
        [:expr
         [:app
          [:app [:var "a"] [:var "b"]]
          [:var "c"]]] ))

    (testing "parenthesised application"
      (assert-eq
        (lambda-parser "a (b c)")
        [:expr
         [:app
          [:var "a"]
          [:app
           [:var "b"]
           [:var "c"]]]]))

    (testing "abstraction"
      (assert-eq
        (lambda-parser "λ.x x y")
        [:expr
         [:abs
          [:var "x"]
          [:app
           [:var "x"]
           [:var "y"]]]]))

    (testing "application of abstractions"
      (assert-eq
        (lambda-parser "(λ.x x) (λ.y y)")
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
             [:var "z"]]]]]]))

    (testing "parenthesised abstractions"
      (assert-eq
        (lambda-parser "λ.x (λ.y x) y")
        [:expr
         [:abs
          [:var "x"]
          [:app
           [:abs
            [:var "y"]
            [:var "x"]]
           [:var "y"]]]]))))
