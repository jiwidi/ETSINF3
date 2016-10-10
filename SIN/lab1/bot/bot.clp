(deffacts bot
    (grid 5 4)
    (max-bulbs 3)
    (warehouse 2 3)
    (max-level 0)
    (robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 4 2 level 0 fact -1))

(defrule init
    (declare (salience 100))
    ?f <- (max-level 0)
=>
    (printout t "Input the maximum level: ")
    (bind ?s (read-number))
    (retract ?f)
    (assert (max-level ?s)))

(defrule right
    ?f <- (robot ?x ?y $?z level ?l fact ?)
    (grid ?mx ?my)
    (test (< ?x ?mx))
=>
    (assert (robot (+ 1 ?x) ?y $?z level (+ 1 ?l) fact (fact-index ?f))))

(defrule left
    ?f <- (robot ?x ?y $?z level ?l fact ?)
    (test (> ?x 1))
=>
    (assert (robot (- ?x 1) ?y $?z level (+ 1 ?l) fact (fact-index ?f))))

(defrule up
    ?f <- (robot ?x ?y $?z level ?l fact ?)
    (grid ?mx ?my)
    (test (< ?y ?my))
=>
    (assert (robot ?x (+ 1 ?y) $?z level (+ 1 ?l) fact (fact-index ?f))))

(defrule down
    ?f <- (robot ?x ?y $?z level ?l fact ?)
    (test (> ?y 1))
=>
    (assert (robot ?x (- ?y 1) $?z level (+ 1 ?l) fact (fact-index ?f))))


(defrule load
    (declare (salience 10))
    ?f <- (robot ?x ?y ?b $?z level ?l fact ?)
    (warehouse ?x ?y)
    (max-bulbs ?mb)
    (test (< ?b ?mb))
=>
    (assert(robot ?x ?y ?mb $?z level (+ 1 ?l) fact (fact-index ?f))))

(defrule replace
    (declare (salience 10))
    ?f <- (robot ?x ?y ?b1 $?rest1 lamp ?x ?y ?b2 $?rest2 level ?l fact ?)
    (test (>= ?b1 ?b2))
=>
    (assert (robot ?x ?y (- ?b1 ?b2) $?rest1 $?rest2 level (+ 1 ?l) fact (fact-index ?f))))

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
    (declare (salience -10))
    (max-level ?ml)
    (robot $? level ?l $?)
    (test (>= ?l ?ml))
=>
    (printout t "Reached max level" crlf)
    (halt))
