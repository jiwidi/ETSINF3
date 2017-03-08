(deffacts bot
    (grid 5 4)
    (max-bulbs 3)
    (warehouse 2 3)
    (max-level 0)
    (robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 4 2 level 0 fact -1))

;============================================================
;================== HEURISTIC FUNCTIONS =====================
;============================================================

(deffunction dist (?x ?y ?a ?b)
    (+ (abs (- ?x ?a)) (abs (- ?y ?b)))
)

(deffunction h (?x ?y ?b ?lamplist ?wx ?wy)
    (bind ?i 1) (bind ?res 0)
    (bind ?x2 nil) (bind ?y2 nil) (bind ?b2 nil)

    (while (<= ?i (length$ ?lamplist))
        (switch (mod ?i 4)
            (case 2 then (bind ?x2 (nth$ ?i ?lamplist)))
            (case 3 then (bind ?y2 (nth$ ?i ?lamplist)))
            (case 0 then (bind ?b2 (nth$ ?i ?lamplist))
                (if (< ?b ?b2) then
                    (bind ?res (+ ?res (dist ?x ?y ?wx ?wy) 1))
                    (bind ?x ?wx) (bind ?y ?wy)
                    (bind ?b ?b2)
                )
                (bind ?res (+ ?res (dist ?x ?y ?x2 ?y2) 1))
                (bind ?x ?x2) (bind ?y ?y2)
                (bind ?b (- ?b ?b2))
            )
        )
        (bind ?i (+ ?i 1))
    )
    ?res
)

(defglobal ?*f* = 1)
(deffunction heur (?x ?y ?b ?lamplist ?wx ?wy ?l)
    (bind ?*f* (+ 1 ?l (h ?x ?y ?b ?lamplist ?wx ?wy))))

(defrule init
    (declare (salience 100))
    ?f <- (max-level 0)
=>
    (set-salience-evaluation when-activated)
    (printout t "Input the maximum level: ")
    (bind ?s (read-number))
    (retract ?f)
    (assert (max-level ?s)))

;==========================================================================
;============================ MOVEMENT FUNCTIONS ==========================
;==========================================================================

(defrule right
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?b $?lamps level ?l fact ?)
    (grid ?mx ?my)
    (warehouse ?wx ?wy)
    (test (< ?x ?mx))
    (test (heur (+ 1 ?x) ?y ?b (create$ $?lamps) ?wx ?wy ?l))
=>
    (assert (robot (+ 1 ?x) ?y ?b $?lamps level (+ 1 ?l) fact (fact-index ?f))))

(defrule left
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?b $?lamps level ?l fact ?)
    (warehouse ?wx ?wy)
    (test (> ?x 1))
    (test (heur (- ?x 1) ?y ?b (create$ $?lamps) ?wx ?wy ?l))
=>
    (assert (robot (- ?x 1) ?y ?b $?lamps level (+ 1 ?l) fact (fact-index ?f))))

(defrule up
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?b $?lamps level ?l fact ?)
    (grid ?mx ?my)
    (warehouse ?wx ?wy)
    (test (< ?y ?my))
    (test (heur ?x (+ 1 ?y) ?b (create$ $?lamps) ?wx ?wy ?l))
=>
    (assert (robot ?x (+ 1 ?y) ?b $?lamps level (+ 1 ?l) fact (fact-index ?f))))

(defrule down
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?b $?lamps level ?l fact ?)
    (warehouse ?wx ?wy)
    (test (> ?y 1))
    (test (heur ?x (- ?y 1) ?b (create$ $?lamps) ?wx ?wy ?l))
=>
    (assert (robot ?x (- ?y 1) ?b $?lamps level (+ 1 ?l) fact (fact-index ?f))))


(defrule load
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?b $?lamps level ?l fact ?)
    (warehouse ?x ?y)
    (max-bulbs ?mb)
    (test (< ?b ?mb))
    (test (heur ?x ?y ?mb (create$ $?lamps) ?x ?y ?l))
=>
    (assert(robot ?x ?y ?mb $?lamps level (+ 1 ?l) fact (fact-index ?f))))

(defrule replace
    (declare (salience (- 0 ?*f*)))
    ?f <- (robot ?x ?y ?b1 $?rest1 lamp ?x ?y ?b2 $?rest2 level ?l fact ?)
    (warehouse ?wx ?wy)
    (test (>= ?b1 ?b2))
    (test (heur ?x ?y (- ?b1 ?b2) (create$ $?rest1 $?rest2) ?wx ?wy ?l))
=>
    (assert (robot ?x ?y (- ?b1 ?b2) $?rest1 $?rest2 level (+ 1 ?l) fact (fact-index ?f))))

;=============================================================
;=============== DUPLICATE AND GOAL CONTROL ==================
;=============================================================

(defrule duplicate
    (declare (salience 30))
    ?f <- (robot $?rest level ?l1 $?)
    ?g <- (robot $?rest level ?l2 $?)
    (test (!= ?l1 ?l2))
=>
    (if (< ?l1 ?l2) then
        (retract ?g)
    else
        (retract ?f)))

(defrule duplicateprev
    (declare (salience 30))
    ?f <- (robot $?rest fact ?f1)
    ?g <- (robot $?rest fact ?f2)
    (test (!= ?f1 ?f2))
=>
    (if (< ?f1 ?f2) then
        (retract ?g)
    else
        (retract ?f)))

(defrule goal
    (declare (salience 20))
    (robot ?x ?y ? level ?l fact ?)
=>
    (printout t "All lamps fixed! At level " ?l crlf)
    (halt))

(defrule lose
    (declare (salience -99))
    (max-level ?ml)
    (robot $? level ?l $?)
    (test (>= ?l ?ml))
=>
    (printout t "Reached max level" crlf)
    (halt))