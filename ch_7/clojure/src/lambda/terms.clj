(ns lambda.terms)

(defprotocol LambdaTerm
  (free-variables-in [this bound]))

(defrecord Var [name]
  Object
  (toString [_] name)
  
  LambdaTerm
  (free-variables-in [this bound]
    (if (some #{this} bound) '() (list this))))

(defrecord App [left right]
  Object
  (toString [_] (str "(" left " " right ")"))
  
  LambdaTerm
  (free-variables-in [this bound]
    (concat (free-variables-in left bound) (free-variables-in right bound))))

(defrecord Abs [param body]
  Object
  (toString [_] (str "λ." param " " body))
  
  LambdaTerm
  (free-variables-in [this bound]
    (free-variables-in body (conj bound param))))

(defn free-variables [term]
  (free-variables-in term '()))
