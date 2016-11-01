(deffacts robot
    (grid 5 4)
    (warehouse 2 3)
    (robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 4 2 level 0)
    (max-bulbs 3)
)

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
    (robot ?x ?y ?bur $?mid level ?l)
    (max-level ?ml)
    (test (< ?l ?ml))
    (grid ?gx ?gy)
    (test (< ?y ?gy))
=>
    (assert (robot ?x (+ ?y 1) ?bur $?mid level (+ ?l 1)))
)

(defrule down
    (robot ?x ?y ?bur $?mid level ?l)
    (max-level ?ml)
	(test (< ?l ?ml))
    (grid ?gx ?gy)
    (test (> ?y 1))
    
=>
    (assert (robot ?x (- ?y 1) ?bur $?mid level (+ ?l 1)))
)

(defrule right
    (robot ?x ?y ?bur $?mid level ?l)
    (max-level ?ml)
	(test (< ?l ?ml))
    (grid ?gx ?gy)
    (test (< ?x ?gx))
=>
    (assert (robot (+ ?x 1) ?y ?bur $?mid level (+ ?l 1)))
)

(defrule left
    (robot ?x ?y ?bur $?mid level ?l)
    (max-level ?ml)
	(test (< ?l ?ml))
    (grid ?gx ?gy)
    (test (> ?x 1))
=>
    (assert (robot (- ?x 1) ?y ?bur $?mid level (+ ?l 1)))
)

(defrule load
    (robot ?x ?y ?bur $?mid level ?l)
    (max-level ?ml)
	(test (< ?l ?ml))
    (warehouse ?x ?y)
    (max-bulbs ?mb)
    (test (< ?bur ?mb))
=>
    (assert (robot ?x ?y ?mb $?mid level (+ ?l 1)))
)

(defrule replace
    (robot ?x ?y ?bur $?mid1 lamp ?x ?y ?bul $?mid2 level ?l)
    (max-level ?ml)
    (test (< ?l ?ml))
    (test (<= ?bul ?bur))
=>
    (assert (robot ?x ?y (- ?bur ?bul) $?mid1 $?mid2 level (+ ?l 1)))
)

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