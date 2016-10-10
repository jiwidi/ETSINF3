;; =========================================================
;; ===    M  I S P L A C E D    H E U R I S T I C         ==
;; =========================================================

(defglobal ?*gen-nod* = 0)
(defglobal ?*f* = 1)



(deffunction misplaced (?state)
    (bind ?misp 0)
    (if (<> (nth$ 1 ?state)  1) then  (bind ?misp (+ ?misp 1)))
    (if (<> (nth$ 2 ?state)  2) then  (bind ?misp (+ ?misp 1)))
    (if (<> (nth$ 3 ?state)  3) then  (bind ?misp (+ ?misp 1)))
    (if (<> (nth$ 4 ?state)  8) then  (bind ?misp (+ ?misp 1)))
    ;; (if (<> (nth$ 5 ?state)  0) then  (bind ?misp (+ ?misp 1)));;
    (if (<> (nth$ 6 ?state)  4) then  (bind ?misp (+ ?misp 1)))
    (if (<> (nth$ 7 ?state)  7) then  (bind ?misp (+ ?misp 1)))
    (if (<> (nth$ 8 ?state)  6) then  (bind ?misp (+ ?misp 1)))
    (if (<> (nth$ 9 ?state)  5) then  (bind ?misp (+ ?misp 1)))
       ?misp)


(deffunction control (?state ?level)
    (bind ?*f* (misplaced ?state))
    (bind ?*f* (+ ?*f* ?level 1))
)


(defrule right
  (declare (salience (- 0 ?*f*)))
  ?f<-(puzzle $?x 0 ?y $?z level ?level movement ?mov fact ?)
  (max-depth ?prof)
  (test (and (<> (length$ $?x) 2) (<> (length$ $?x) 5)))
  (test (neq ?mov left))
  (test (< ?level ?prof))
  (test (control (create$ $?x ?y 0 $?z) ?level))

  =>
  (assert (puzzle $?x ?y 0 $?z level (+ ?level 1) movement right fact ?f))
  (bind ?*gen-nod* (+ ?*gen-nod* 1)))



(defrule left
  (declare (salience (- 0 ?*f*)))
  ?f<-(puzzle $?x ?y 0 $?z level ?level movement ?mov fact ?)
  (max-depth ?prof)
  (test (and (<> (length$ $?x) 2) (<> (length$ $?x) 5)))
  (test (neq ?mov right))
  (test (< ?level ?prof))
  (test (control (create$ $?x 0 ?y $?z) ?level))
  =>
  (assert (puzzle $?x 0 ?y $?z level (+ ?level 1) movement left fact ?f))
  (bind ?*gen-nod* (+ ?*gen-nod* 1)))


(defrule down
  (declare (salience (- 0 ?*f*)))
  ?f<-(puzzle $?x 0 ?a ?b ?c $?z level ?level movement ?mov fact ?)
  (max-depth ?prof)
  (test (neq ?mov up))
  (test (< ?level ?prof))
  (test (control (create$ $?x ?c ?a ?b 0 $?z) ?level))
  =>
  (assert (puzzle $?x ?c ?a ?b 0 $?z level (+ ?level 1) movement down fact ?f))
  (bind ?*gen-nod* (+ ?*gen-nod* 1)))


(defrule up
  (declare (salience (- 0 ?*f*)))
  ?f<-(puzzle $?x ?a ?b ?c 0 $?z level ?level movement ?mov fact ?)
  (max-depth ?prof)
  (test (neq ?mov down))
  (test (< ?level ?prof))
  (test (control (create$ $?x 0 ?b ?c ?a $?z) ?level))
  =>
  (assert (puzzle $?x 0 ?b ?c ?a $?z level (+ ?level 1) movement up fact ?f))
  (bind ?*gen-nod* (+ ?*gen-nod* 1)))





;; ========================================================
;; =========   S E A R C H       S T R A T E G Y   ========
;; ========================================================
;; The "goal" rule is used to detect when the goal state is reached

(defrule goal
    (declare (salience 100))
    ?f <- (puzzle 1 2 3 8 0 4 7 6 5 level ?n movement ?mov fact ?)

   =>
    (printout t "SOLUTION FOUND AT LEVEL " ?n crlf)
    (printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*gen-nod* crlf)
    (printout t "GOAL FACT " ?f crlf)

    (halt))

(defrule no_solution
    (declare (salience -99))
    (puzzle $? level ?n $?)

=>
    (printout t "SOLUTION NOT FOUND" crlf)
    (printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*gen-nod* crlf)

    (halt))


(deffunction start ()
      (set-salience-evaluation when-activated)
      (reset)
    (printout t "Maximum depth:= " )
    (bind ?prof (read))
    (printout t " Execute run to start the program " crlf)
    (assert (puzzle 2 8 3 1 6 4 7 0 5 level 0 movement null fact 0))
    (assert (max-depth ?prof))
)

(deffunction path
    (?f)
    (bind ?list (fact-slot-value ?f implied))
    (bind ?l2 (member$ level ?list))
    (bind ?n (nth (+ ?l2 1) ?list)) 
    ;;(printout t "Nivel=" ?n crlf)
    (bind ?dir (nth (length ?list) ?list))
    (bind ?mov (subseq$ ?list (+ ?l2 3) (- (length ?list) 2))) 
    (bind ?path (create$ ?dir ?mov))
    ;;(printout t ?dir "    " ?mov crlf)

    (loop-for-count (- ?n 1) 
        (bind ?list (fact-slot-value (fact-index ?dir) implied))
        (bind ?dir (nth (length ?list) ?list))
        (bind ?l2 (member$ level ?list))
        (bind ?mov (subseq$ ?list (+ ?l2 3) (- (length ?list) 2)))
        (bind ?path (create$ ?dir ?mov ?path)) 
    )

    (printout t "Path: " ?path crlf)
)

