(deffacts bot
    (grid 5 4)
    (max-bulbs 3)
    (warehouse 2 3)
    (max-level 0)
    (robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 4 2 level 0))

;============================================================
;================== HEURISTIC FUNCTIONS =====================
;============================================================

(deffunction dist (?x ?y ?a ?bur)
    (+ (abs (- ?x ?a)) (abs (- ?y ?bur)))
)

(deffunction h (?x ?y ?bur ?lamplist ?wx ?wy)
    (bind ?i 1) (bind ?res 0)
    (bind ?x2 nil) (bind ?y2 nil) (bind ?bul nil)

    (while (<= ?i (length$ ?lamplist))
        (switch (mod ?i 4)
            (case 2 then (bind ?x2 (nth$ ?i ?lamplist)))
            (case 3 then (bind ?y2 (nth$ ?i ?lamplist)))
            (case 0 then (bind ?bul (nth$ ?i ?lamplist))
                (if (< ?bur ?bul) then
                    (bind ?res (+ ?res (dist ?x ?y ?wx ?wy) 1))
                    (bind ?x ?wx) (bind ?y ?wy)
                    (bind ?bur ?bul)
                )
                (bind ?res (+ ?res (dist ?x ?y ?x2 ?y2) 1))
                (bind ?x ?x2) (bind ?y ?y2)
                (bind ?bur (- ?bur ?bul))
            )
        )
        (bind ?i (+ ?i 1))
    )
    ?res
)

(defglobal ?*f* = 1)
(deffunction heur (?x ?y ?bur ?lamplist ?wx ?wy ?l)
    (bind ?*f* (+ 1 ?l (h ?x ?y ?bur ?lamplist ?wx ?wy))))

(defrule init
    (declare (salience 1000))
=>
    (printout t "Write the level of depth for the search: ")
    (bind ?num (read-number))
    (assert (max-level ?num)))

;==========================================================================
;============================ MOVEMENT FUNCTIONS ==========================
;==========================================================================

(defrule up
    (declare (salience (- 0 ?*f*)))
    (robot ?x ?y ?bur $?mid level ?l)
    (grid ?gx ?gy)
    (test (< ?y ?gy))
    (warehouse ?wx ?wy)
    (test (heur ?x (+ 1 ?y) ?bur (create$ $?mid) ?wx ?wy ?l))
=>
    (assert (robot ?x (+ 1 ?y) ?bur $?mid level (+ 1 ?l))))

(defrule down
    (declare (salience (- 0 ?*f*)))
    (robot ?x ?y ?bur $?mid level ?l)
    (test (> ?y 1))
    (warehouse ?wx ?wy)
    (test (heur ?x (- ?y 1) ?bur (create$ $?mid) ?wx ?wy ?l))
=>
    (assert (robot ?x (- ?y 1) ?bur $?mid level (+ 1 ?l))))

(defrule right
    (declare (salience (- 0 ?*f*)))
    (robot ?x ?y ?bur $?mid level ?l)
    (grid ?gx ?gy)
    (test (< ?x ?gx))
    (warehouse ?wx ?wy)
    (test (heur (+ 1 ?x) ?y ?bur (create$ $?mid) ?wx ?wy ?l))
=>
    (assert (robot (+ 1 ?x) ?y ?bur $?mid level (+ 1 ?l))))


(defrule left
    (declare (salience (- 0 ?*f*)))
    (robot ?x ?y ?bur $?mid level ?l)
    (test (> ?x 1))
    (warehouse ?wx ?wy)
    (test (heur (- ?x 1) ?y ?bur (create$ $?mid) ?wx ?wy ?l))
=>
    (assert (robot (- ?x 1) ?y ?bur $?mid level (+ 1 ?l))))

(defrule load
    (declare (salience (- 0 ?*f*)))
    (robot ?x ?y ?bur $?mid level ?l)
    (max-bulbs ?mb)
    (test (< ?bur ?mb))
    (warehouse ?x ?y)
    (test (heur ?x ?y ?mb (create$ $?mid) ?x ?y ?l))
=>
    (assert(robot ?x ?y ?mb $?mid level (+ 1 ?l))))

(defrule replace
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?bur $?mid1 lamp ?x ?y ?bul $?mid2 level ?l)
    (test (>= ?bur ?bul))
    (warehouse ?wx ?wy)
    (test (heur ?x ?y (- ?bur ?bul) (create$ $?mid1 $?mid2) ?wx ?wy ?l))
=>
    (assert (robot ?x ?y (- ?bur ?bul) $?mid1 $?mid2 level (+ 1 ?l))))

;=============================================================
;=============== GOAL AND LOSE FUNCTIONS =====================
;=============================================================


(defrule solution
    (declare (salience 20))
    (robot ?x ?y ?bur level ?l)
    (max-level ?ml)
    (test (< ?l ?ml))
=>
    (printout t "Solution found, all lamps with lamps at level: " ?l crlf)
    (halt)
)

(defrule nosolution
    (declare (salience -100))
    (robot $?mid level ?l)
    (max-level ?ml)
    (test (>= ?l ?ml))
=>
    (printout t "Maximum level reached, stoping" crlf)
    (halt)
)