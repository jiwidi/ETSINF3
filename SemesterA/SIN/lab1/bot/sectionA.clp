(deffacts bulb_robot
    (grid 5 4)
    (warehouse 2 3)
    (max-level 1000)
    (max-bulb 3)
    (robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 6 2 level 0 none))

(defrule left
    ?f <- (robot ?x $?m level ?l ?prev)
    (test (> ?x 1))
    (max-level ?max)
    (test (<= ?l ?max))
    (test (neq ?prev right))
=>
    (assert (robot (- ?x 1) $?m level (+ 1 ?l) left)))

(defrule right
    ?f <- (robot ?x $?m level ?l ?prev)
    (grid ?a ?)
    (test (< ?x ?a))
    (max-level ?max)
    (test (<= ?l ?max))
    (test (neq ?prev left))
=>
    (assert (robot (+ ?x 1) $?m level (+ 1 ?l) right)))

(defrule down
    ?f <- (robot ?x ?y $?m level ?l ?prev)
    (test (> ?y 1))
    (max-level ?max)
    (test (<= ?l ?max))
    (test (neq ?prev up))
=>
    (assert (robot ?x (- ?y 1) $?m level (+ 1 ?l) down)))

(defrule up
    ?f <- (robot ?x ?y $?m level ?l ?prev)
    (grid ? ?b)
    (test (< ?y ?b))
    (max-level ?max)
    (test (<= ?l ?max))
    (test (neq ?prev down))
=>
    (assert (robot ?x (+ ?y 1) $?m level (+ 1 ?l) up)))

(defrule load
    (declare (salience 5))
    ?f <- (robot ?x ?y ?a $?m level ?l ?)
    (warehouse ?x ?y)
    (max-bulb ?mb)
    (test (< ?a ?mb))
    (max-level ?max)
    (test (<= ?l ?max))
=>
    (assert (robot ?x ?y ?mb $?m level (+ 1 ?l) load)))

(defrule replace
    (declare (salience 5))
    ?f <- (robot ?x ?y ?a $?u lamp ?x ?y ?b $?v level ?l ?)
    (test (>= ?a ?b))
    (max-level ?max)
    (test (<= ?l ?max))
=>
    (assert (robot ?x ?y (- ?a ?b) $?u $?v level (+ 1 ?l) replace)))

(defrule goal
    (declare (salience 99))
    (robot ? ? ?a level ?l ?)
=>
    (printout t "Number of steps " ?l)
    (halt))

(defrule lost
    (declare (salience -99))
    (robot $? level ?l ?)
=>
    (printout t "Max level reached (" ?l ")" crlf)
    (halt))
