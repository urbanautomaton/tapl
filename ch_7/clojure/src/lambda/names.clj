(ns lambda.names)

(defn- string-to-codes [string]
  (map int (seq string)))

(defn- codes-to-string [codes]
  (apply str (map char codes)))

(defn- increment-codes [codes min max]
  (if (empty? codes) (list min)
    (let [[head & rest] codes
          head-inc (inc head)]
      (if (> head-inc max)
        (conj (increment-codes rest min max) min)
        (conj rest head-inc)))))

(defn- next-name [name]
  (codes-to-string
    (increment-codes
      (reverse (string-to-codes name))
      (int \a)
      (int \z))))

(defn fresh-name
  ([] fresh-name '())
  ([taken] (fresh-name taken "a"))
  ([taken current] (if (some #{current} taken)
                     (fresh-name taken (next-name current))
                     current)))

