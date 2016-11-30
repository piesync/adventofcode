(aoc.core)
 
(def xf (map #(if (= % "(") -1 1)))
 
(defn santa-gps [ps]
  (transduce xf + 0 ps))

