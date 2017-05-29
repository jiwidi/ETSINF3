debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_SOLDIER").





{ include("jgomas.asl") }




// Plans


/*******************************
*
* Actions definitions
*
*******************************/

/////////////////////////////////
//  GET AGENT TO AIM 
/////////////////////////////////  
/**
* Calculates if there is an enemy at sight.
* 
* This plan scans the list <tt> m_FOVObjects</tt> (objects in the Field
* Of View of the agent) looking for an enemy. If an enemy agent is found, a
* value of aimed("true") is returned. Note that there is no criterion (proximity, etc.) for the
* enemy found. Otherwise, the return value is aimed("false")
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!get_agent_to_aim
	<-  
    ?debug(Mode); if (Mode<=2) { .println("Looking for agents to aim."); }
		?fovObjects(FOVObjects);
		.length(FOVObjects, Length);
		?debug(Mode); if (Mode<=1) { .println("El numero de objetos es:", Length); }
		if (Length > 0) {
		  +buclea(0);
		  -+aimed("false");
		  while (aimed("false") & buclea(X) & (X < Length)) {
        //.println("En el bucle, y X vale:", X);
        .nth(X, FOVObjects, Object);
        // Object structure
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        .nth(2, Object, Type);
        ?debug(Mode); if (Mode<=2) { .println("Objeto Analizado: ", Object); }
        if (Type > 1000) {
          ?debug(Mode); if (Mode<=2) { .println("I found some object."); }
        } 
        else {
          // Object may be an enemy
          .nth(1, Object, Team);
          ?my_formattedTeam(MyTeam);
          if (Team == 200) {  // Only if I'm ALLIED
	          ?debug(Mode); 
            if (Mode<=2) { .println("Aiming an enemy. . .", MyTeam, " ", .number(MyTeam) , " ", Team, " ", .number(Team)); }
	          +aimed_agent(Object);
	          -+aimed("true");
          } 
        }
        -+buclea(X+1);   
		  }
		}
    //.println("inside get_agent_to_aim");
    -buclea(_) 
    .

/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////
+look_response(FOVObjects)[source(M)]
    <-  //-waiting_look_response;
        ?my_position(X, Y, Z);
        //.println("X = ", X , " Y = ", Y, " Z = ", Z);
        .length(FOVObjects, Length);
        if (Length > 0) {
        	+bucleb(0);
            ?debug(Mode); if (Mode<=1) { .println("HAY ", Length, " OBJETOS A MI ALREDEDOR:\n", FOVObjects); }
            while (bucleb(X) & (X < Length)) {
    			.nth(X, FOVObjects, Object);
        		// Object structure
        		// [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        		.nth(2, Object, Type);
        		.nth(1, Object, Team);
        		.nth(4, Object, Distance);


    			//.println("Veo un ",Type, " del equipo ",Team, " a una distancia de ", Distance, " length ", Length, " X", X);
    			-+bucleb(X+1);
    			bucleb(X);
    			//.println(X, "  ",FOVObjects);
    		}
    		-bucleb(_);
        }    
        //reordenar squad
        -look_response(_)[source(M)];
        -+fovObjects(FOVObjects);
        //.println("inside look_response");
        //.//;
        //?state(Estado);
		    //.println(Estado);
        ?boot(Bo);
      if(Bo == 1){
        ?spotted(Ss);
        if(Ss == 0){
        !formation;
      }
      }
        !look
        .

+!formation
  <-      
    ?my_position(Xx, Yy, Zz);
    .my_team("squad_ALLIED", Sl);
    .length(Sl, Lengthsl);
    //.println("LISTA DE AGENTES ", Sl);
    if (Lengthsl > 0) {
      +buclesl(0);
      +coordX(5);
      +coordZ(5);
      +bool(0);
      while (buclesl(Bsl) & (Bsl < Lengthsl)) {
        .nth(Bsl, Sl, Agent);
        ?coordX(Cx);
        ?coordZ(Cz);
        ?bool(B);
        if(B == 0){
          .concat("goto(",Xx + Cx, ", ", Yy, ", ", Zz - Cz, ")", Content1);
          .send_msg_with_conversation_id(Agent, tell, Content1, "INT");
          -+bool(1);
        }
        else{
          .concat("goto(",Xx - Cx, ", ", Yy, ", ", Zz + Cz, ")", Content1);
          .send_msg_with_conversation_id(Agent, tell, Content1, "INT");
          -+coordX(Cx+5);
          -+coordZ(Cz+5);
          -+bool(0);
        }
        -+buclesl(Bsl+1);
      }
      -buclesl(_);
      -coordZ(_);
      -coordX(_);
      ?checks(Jj);
    }
    .      
        
/////////////////////////////////
//  PERFORM ACTIONS
/////////////////////////////////
/**
* Action to do when agent has an enemy at sight.
* 
* This plan is called when agent has looked and has found an enemy,
* calculating (in agreement to the enemy position) the new direction where
* is aiming.
*
*  It's very useful to overload this plan.
* 
*/
+!perform_aim_action
    <-  // Aimed agents have the following format:
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        ?aimed_agent(AimedAgent);
        ?debug(Mode); if (Mode<=1) { .println("AimedAgent ", AimedAgent); }
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);             }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 200) {
          .nth(6, AimedAgent, NewDestination);
          ?debug(Mode); if (Mode<=1) { .println("NUEVO DESTINO DEBERIA SER: ", NewDestination); }
          
        }
        //.println("inside perform_aim_action");
        .

/**
* Action to do when the agent is looking at.
*
* This plan is called just after Look method has ended.
* 
* <em> It's very useful to overload this plan. </em>
* 
*/
+!perform_look_action 
    <- 
      ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_LOOK_ACTION GOES HERE.") } 
    	?fovObjects(FOVObjects);
  		.length(FOVObjects, Length);
  		if (Length > 0) {
      	+buclec(0);
      	-+following("false");
      	while (following("false") & buclec(X) & (X < Length)) {
          .nth(X, FOVObjects, Object);
          // Object structure
          // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
          .nth(1, Object, Team);
          if (Team = 100) {
          	.nth(6,Object,Poss);
          	check_position(Poss);
            ?position(P);
          	if(P == valid){
      				//!add_task(task(100,"TASK_GOTO_POSITION", M,Poss, ""));
          		-+following("true");
          		?tasks(Tasklist);
          		?current_task(Ct);
  				    .println("SIGUIENDO ", Ct);
              //?state(Estado);
              //.println(Estado);
  				  }	
          } 
          -+buclec(X+1); 
     		} 
        -buclec(_); 
	     }
      .

/**
* Action to do if this agent cannot shoot.
* 
* This plan is called when the agent try to shoot, but has no ammo. The
* agent will spit enemies out. :-)
* 
* <em> It's very useful to overload this plan. </em>
* 
*/  
+!perform_no_ammo_action . 
   /// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_NO_AMMO_ACTION GOES HERE.") }.
    
/**
     * Action to do when an agent is being shot.
     * 
     * This plan is called every time this agent receives a messager from
     * agent Manager informing it is being shot.
     * 
     * <em> It's very useful to overload this plan. </em>
     * 
     */
+!perform_injury_action .
    ///<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_INJURY_ACTION GOES HERE.") }. 
        

/////////////////////////////////
//  SETUP PRIORITIES
/////////////////////////////////
/**  You can change initial priorities if you want to change the behaviour of each agent  **/
+!setup_priorities
    <- 
      +task_priority("TASK_NONE",0);
      +task_priority("TASK_GIVE_MEDICPAKS", 2000);
      +task_priority("TASK_GIVE_AMMOPAKS", 0);
      +task_priority("TASK_GIVE_BACKUP", 0);
      +task_priority("TASK_GET_OBJECTIVE",0);
      +task_priority("TASK_ATTACK", 1000);
      +task_priority("TASK_RUN_AWAY", 1500);
      +task_priority("TASK_GOTO_POSITION", 5000);
      +task_priority("TASK_PATROLLING", 500);
      +task_priority("TASK_WALKING_PATH", 1750)
      .   



/////////////////////////////////
//  UPDATE TARGETS
/////////////////////////////////
/**
 * Action to do when an agent is thinking about what to do.
 *
 * This plan is called at the beginning of the state "standing"
 * The user can add or eliminate targets adding or removing tasks or changing priorities
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */

+!update_targets
	<-	
    ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR UPDATE_TARGETS GOES HERE.") }
		?my_position(X, Y, Z);
		//.println("X = ", X , " Y = ", Y, " Z = ", Z);
		//.println("inside update_targets");
        //!add_task(task(100,"TASK_PATROLLING", M,pos(X,Y,Z), ""));
    ?tasks(Tasklist);
    .length(Tasklist, Length);
    //.println(Tasklist, " ", Length);
    if (Length < 1) {
      ?boot(Bo);
      if(Bo == 0){
        .wait(100);
        !formation;
      }
      else{
    	!add_task(task(100,"TASK_GOTO_POSITION", M,pos(25,0,25), ""));
      }
    }
		.
		
	
/////////////////////////////////
//  CHECK MEDIC ACTION (ONLY MEDICS)
/////////////////////////////////
/**
 * Action to do when a medic agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkMedicAction
     <-  -+medicAction(on).
      // go to help
      
      
/////////////////////////////////
//  CHECK FIELDOPS ACTION (ONLY FIELDOPS)
/////////////////////////////////
/**
 * Action to do when a fieldops agent is thinking about what to do if other agent needs help.
 *
 * By default always go to help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
 +!checkAmmoAction
     <-  -+fieldopsAction(on).
      //  go to help



/////////////////////////////////
//  PERFORM_TRESHOLD_ACTION
/////////////////////////////////
/**
 * Action to do when an agent has a problem with its ammo or health.
 *
 * By default always calls for help
 *
 * <em> It's very useful to overload this plan. </em>
 *
 */
+!performThresholdAction
       <-
       
       ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_TRESHOLD_ACTION GOES HERE.") }
       
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(X, Y, Z);
          
         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",X, ", ", Y, ", ", Z, ", ", Ar, ")", Content1);
         .send_msg_with_conversation_id(E1, tell, Content1, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) { 
          ?my_position(X, Y, Z);
          
         .my_team("medic_ALLIED", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",X, ", ", Y, ", ", Z, ", ", Hr, ")", Content2);
         .send_msg_with_conversation_id(E2, tell, Content2, "CFM");

       }
       //.println("inside PERFORM_TRESHOLD_ACTION");
       .
       
/////////////////////////////////
//  ANSWER_ACTION_CFM_OR_CFA
/////////////////////////////////

     

    
+cfm_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
      -cfm_agree.  

+cfa_agree[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_agree GOES HERE.")};
      -cfa_agree.  

+cfm_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_refuse GOES HERE.")};
      -cfm_refuse.  

+cfa_refuse[source(M)]
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_refuse GOES HERE.")};
      -cfa_refuse.  

+confirm(K)[source(A)]
  <-
        .println("Recibido un mensaje de tipo confirm de ", A);
        if(K == 1){
          ?checks(J);
          -+checks(J+1);
        }
        ?checks(Jj);
        if(Jj == 7){
          ?objective(Xo,Yo,Zo);
          !add_task(task(5000,"TASK_GET_OBJECTIVE", M,pos(Xo,Yo,Zo), ""));
          -+boot(1);
        }
.

+bandera(X,Y,Z)[source(A)]
<-
        .println("Recibido un mensaje de tipo bandera de ", A);
        -+spotted(1);
        check_position(pos(X,Y,Z));
        ?position(Pp);
        if(Pp == valid){
          -+tasks([]);
          !add_task(task(9000,"TASK_GET_OBJECTIVE", M,pos(X,Y,Z), ""));
          ?current_task(Tasklista);
          //.println("lista ",Tasklista);
          }
        !perform_look_action 
        .

/////////////////////////////////
//  Initialize variables
/////////////////////////////////

+!init
   <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR init GOES HERE.")}
   .register( "JGOMAS","commander_ALLIED");
   +checks(0);
   +boot(0);
   +spotted(0);
   -+tasks([]);
   .wait(500);
   !add_task(task(1005,"TASK_GOTO_POSITION", M,pos(50,0,50), ""));
  . 


