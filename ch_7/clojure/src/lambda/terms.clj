(ns lambda.terms
  (:require [lambda.names :refer [fresh-name]]
            [lambda.parser :refer [parse]]
            [clojure.set :refer [union]]))

(defprotocol FreeVariables
  (free-variables-in [this bound]))

(defprotocol DeBruijn
  (remove-names-in [this bound naming])
  (restore-names-in [this naming]))

(defrecord Var [name]
  Object
  (toString [_] (str name))
  
  FreeVariables
  (free-variables-in [this bound]
    (if (some #{this} bound) #{} #{this}))

  DeBruijn
  (remove-names-in [this bound naming]
    (cond
      (some #{this} bound) (Var. (.indexOf bound this))
      (some #{this} naming) (Var. (+ (.indexOf naming this) (count bound)))
      :else (throw (Exception. "variable encountered that's neither bound, nor in naming context"))))
  (restore-names-in [this naming] (Var. (nth naming name))))

(defrecord App [left right]
  Object
  (toString [_] (str "(" left " " right ")"))
  
  FreeVariables
  (free-variables-in [this bound]
    (union (free-variables-in left bound)
            (free-variables-in right bound)))
  
  DeBruijn
  (remove-names-in [this bound naming]
    (App. (remove-names-in left bound naming)
          (remove-names-in right bound naming)))
  (restore-names-in [this naming]
    (App. (restore-names-in left naming)
          (restore-names-in right naming))))

(defrecord Abs [param body]
  Object
  (toString [_] (str "λ." param " " (str body)))
  
  FreeVariables
  (free-variables-in [_ bound]
    (free-variables-in body (conj bound param)))

  DeBruijn
  (remove-names-in [_ bound naming]
    (Abs. nil (remove-names-in body (conj bound param) naming)))
  (restore-names-in [_ naming]
    (let [name (fresh-name (map :name naming))]
      (Abs. (Var. name) (restore-names-in body (conj naming name))))))

(defn free-variables [term]
  (free-variables-in term '()))

(defn remove-names [term]
  (remove-names-in term '() (seq (free-variables term))))

(defn restore-names [term]
  (restore-names-in term '()))

(restore-names (remove-names (parse "λ.w (λ.x x) (λ.y w)")))
