(ns lambda.core-test
  (:require [clojure.test :refer :all]
            [lambda.parser :refer [parse]]
            [lambda.core :refer :all]))

(defn assert-eq [x y] (is (= x y)))

(deftest test-free-variables
  (testing "free-variables:"
    (testing "identity"
      (assert-eq
        (free-variables (parse "λ.x x"))
        '()))

    (testing "some free variables"
      (assert-eq
        (free-variables (parse "(λ.x x) y z"))
        '([:var "y"] [:var "z"])))))

(deftest test-remove-names
  (testing "remove-names:"
    (testing "identity"
      (assert-eq
        (remove-names (parse "λ.x x"))
        [:abs [:var 0]]))

    (testing "nested abstractions"
      (assert-eq
        (remove-names (parse "λ.x λ.y λ.z x y z"))
        [:abs
         [:abs
          [:abs
           [:app
            [:app [:var 2] [:var 1]]
            [:var 0]]]]]))

    (testing "free variable"
      (assert-eq
        (remove-names (parse "λ.x y"))
        [:abs [:var 1]]))

    (testing "explicit naming context"
      (assert-eq
        (remove-names (parse "λ.w y w") '() '([:var "b"] [:var "a"] [:var "z"] [:var "y"] [:var "x"]))
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

