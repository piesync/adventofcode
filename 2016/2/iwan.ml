(ns adventofcodeclj.core
  (:require [clojure.string :as str]))

(def plan [[1 2 3]
           [4 5 6]
           [7 8 9]])

(def start [1 1])

(defn move [[x y] direction]
  (case direction
      :up [(dec x) y]
      :down [(inc x) y]
      :right [x (inc y)]
      :left [x (dec y)]))

(defn valid? [[x y]]
  (and (> x -1) (> y -1) (< x 3) (< y 3)))

(defn parse-rule [rule]
  (map #(case %
          \U :up
          \L :left
          \D :down
          \R :right) rule))

(defn walk [pos rule]
  (loop [pos pos
         steps (parse-rule rule)
         res []]
    (if-not (empty? steps)
      (let [direction (first steps)
            next-pos (move pos direction)]
        (if (valid? next-pos)
          (recur next-pos (rest steps) (conj res next-pos))
          (recur pos (rest steps) res)))
      (last res))))

(defn crack [code]
  (let [rules (str/split code #"\n")]
    (loop [position start
           rules rules
           res []]
      (let [_ (println res)] (if-not (empty? rules)
                (let [next (walk position (first rules))]
                  (recur next (into [] (rest rules)) (conj res next)))
                (->> res
                     (map #(get-in plan %))
                     (apply str)))))))
