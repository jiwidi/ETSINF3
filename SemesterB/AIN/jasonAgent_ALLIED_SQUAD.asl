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
		?fovObjects(FOVObjectso);
		.length(FOVObjectso, Lengtho);
		if (Lengtho > 0) {
		    +buclea(0);
		    
		    -+aimed("false");
		    
		    while (aimed("false") & buclea(Xo) & (Xo < Lengtho)) {
		        
		        //.println("En el bucle, y X vale:", X);
		        
		        .nth(Xo, FOVObjectso, Objecto);
		        // Object structure
		        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
		        .nth(2, Objecto, Typeo);
		        
		        if (Typeo > 1000) {
		        } else {
		            // Object may be an enemy
		            .nth(1, Objecto, Teamo);
		            ?my_formattedTeam(MyTeam);
		            
		            if (Teamo == 200) {  // Only if I'm ALLIED
		                +aimed_agent(Objecto);
		                -+aimed("true");
		                
		            }
		            
		        }
		        
		        -+buclea(Xo+1);
		        
		    }
		    
		    
		}
//.println("inside get_agent_to_aim");

-buclea(_).

/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////
+look_response(FOVObjectse)[source(M)]
    <-  //-waiting_look_response;
        ?my_position(X, Y, Z);
        //.println("X = ", X , " Y = ", Y, " Z = ", Z);
        .length(FOVObjectse, Lengthe);
        if (Lengthe > 0) {
        	+bucleb(0);
            while (bucleb(Xe) & (Xe < Lengthe)) {
    			.nth(Xe, FOVObjectse, Objecte);
        		// Object structure
        		// [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        		.nth(2, Objecte, Typee);
        		.nth(1, Objecte, Teame);
        		.nth(4, Objecte, Distancee);


    			//.println("Veo un ",Type, " del equipo ",Team, " a una distancia de ", Distance, " length ", Length, " X", X);
    			-+bucleb(Xe+1);
    			bucleb(Xe);
    			//.println(X, "  ",FOVObjects);
    		}
    		-bucleb(_);
        };    
        -look_response(_)[source(M)];
        -+fovObjects(FOVObjectse);
        //.println("inside look_response");
        //.//;
        //?state(Estado);
		//.println(Estado);
        !look.

+!flag
  <-      
    .my_team("ALLIED", Eee);
    .println("MANDANDO BANDERA");
    ?bandera(pos(Xxx,Yyy,Zzz));
    .concat("bandera(",Xxx, ", ", Yyy, ", ", Zzz, ")", Content2);
    .send_msg_with_conversation_id(Eee, tell, Content2, "INT");
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
        .nth(1, AimedAgent, AimedAgentTeam);
        ?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);             }
        ?my_formattedTeam(MyTeam);


        if (AimedAgentTeam == 200) {
                .nth(6, AimedAgent, NewDestination);
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
    	?fovObjects(FOVObjectsb);
		.length(FOVObjectsb, Lengthb);
    //.println("veo ",FOVObjects);
    ?tasks(Tasklistb);
    //.println(Tasklistb);
		if (Lengthb > 0) {
    	+buclec(0);
    	while ( buclec(Xb) & (Xb < Lengthb)) {
        .nth(Xb, FOVObjectsb, Objectb);
        // Object structure
        // [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
        .nth(2, Objectb, Typeb);
        if (Typeb == 1003) {
        	.nth(6,Objectb,Possb);
        	check_position(Possb);
          //.println("HE VISTO LA BANDERA", Possb);
          ?position(Pb);
        	if(Pb == valid){
            ?spotted(Spb);
            //.println("DENTRO DE BANDERA", Spb);
            if(Spb == 0){
              -+spotted(1);
              -+confirmed(1);
              -+tasks([]);
  			  !add_task(task(5000,"TASK_GET_OBJECTIVE", M,Possb, ""));
              -+bandera(Possb);
              !flag;
              //-+state(standing);
            }
				  }	
        	} 
        	-+buclec(Xb+1); 
   		}   
	}
	-buclec(_).

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
    <-  +task_priority("TASK_NONE",0);
        +task_priority("TASK_GIVE_MEDICPAKS", 2000);
        +task_priority("TASK_GIVE_AMMOPAKS", 0);
        +task_priority("TASK_GIVE_BACKUP", 0);
        +task_priority("TASK_GET_OBJECTIVE",0);
        +task_priority("TASK_ATTACK", 1000);
        +task_priority("TASK_RUN_AWAY", 1500);
        +task_priority("TASK_GOTO_POSITION", 5000);
        +task_priority("TASK_PATROLLING", 500);
        +task_priority("TASK_WALKING_PATH", 1750).   



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
		?my_position(Xc, Yc, Zc);
		//.println("X = ", X , " Y = ", Y, " Z = ", Z);
		//.println("inside update_targets");
        //!add_task(task(100,"TASK_PATROLLING", M,pos(X,Y,Z), ""));
        ?tasks(Tasklistc);
        ?current_task(Curr);
        //.println("ejecutando atm ",Curr);
        .length(Tasklistc, Lengthc);
        if(Lengthc < 1)  {
          ?confirmed(Kc);
          //.println("confirmed ", Kc);
          if(Kc == 0){
            ?executed(Ec);
            if(Ec == 1){
              .my_team("commander_ALLIED", Cc);
              Formed = "confirm(1)";
              .send_msg_with_conversation_id(Cc,tell,Formed,"INT");
            }
            else{
              !perform_look_action;
            }
          }
          else{
          	?spotted(Spot);
          	?captured(Cap);
          	println("spot, cap ",Spot, " ", Cap);
          	if(Spot == 1 & Cap == 0){
          		println("TENGO LA BANDERA");
          		-+captured(1);
          	}
          	else{
        	 !add_task(task(100,"TASK_GOTO_POSITION", M,pos(25,0,25), ""));	
        	}
          	}
           //-+state(standing);
        //.println(Tasklist)
      }
      !look
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
       
       
       ?my_ammo_threshold(At);
       ?my_ammo(Ar);
       
       if (Ar <= At) { 
          ?my_position(Xd, Yd, Zd);
          
         .my_team("fieldops_ALLIED", E1);
         //.println("Mi equipo intendencia: ", E1 );
         .concat("cfa(",Xd, ", ", Yd, ", ", Zd, ", ", Ar, ")", Content1d);
         .send_msg_with_conversation_id(E1, tell, Content1d, "CFA");
       
       
       }
       
       ?my_health_threshold(Ht);
       ?my_health(Hr);
       
       if (Hr <= Ht) { 
          ?my_position(Xd, Yd, Zd);
          
         .my_team("medic_ALLIED", E2);
         //.println("Mi equipo medico: ", E2 );
         .concat("cfm(",Xd, ", ", Yd, ", ", Zd, ", ", Hr, ")", Content2);
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

+goto(Xe,Ye,Ze)[source(A)]
<-
        //.println("Recibido un mensaje de tipo goto de ", A);
        check_position(pos(Xe,Ye,Ze));
        ?position(Pe);
        if(Pe == valid){
          ?tasks(Taskliste);
          .length(Taskliste, Lengthe);
          if( Lengthe < 1)  {
            //.println(" no problem ", Taskliste);
            !add_task(task(1000,"TASK_GOTO_POSITION", M,pos(Xe,Ye,Ze), ""));
          }
          else{
            //.println("list deleted", Taskliste);
            -+tasks([]);
            !add_task(task(1000,"TASK_GOTO_POSITION", M,pos(Xe,Ye,Ze), ""));
          }
          -+executed(1);
          ?current_task(Tasklista);
          //.println("lista ",Tasklista);
          
        }
        !perform_look_action 
        .

+bandera(Xf,Yf,Zf)[source(A)]
<-
        .println("Recibido un mensaje de tipo bandera de ", A, " coordenadas " , Xf ," ", Yf, " ", Zf);
        check_position(pos(X,Y,Z));
        ?position(Pf);
        if(Pf == valid){
          -+spotted(1);
          -+confirmed(1);
          -+tasks([]);
          !add_task(task(5000,"TASK_GET_OBJECTIVE", M,pos(Xf,Yf,Zf), ""));
          ?tasks(Tasklistf);
          .println("ejecutando bandera ",Tasklistf);
          -+state(standing);
          }
        .

/////////////////////////////////
//  Initialize variables
/////////////////////////////////

+!init
   <- 
      .register( "JGOMAS","squad_ALLIED");
      -+tasks([]);
      .wait(500);
      +confirmed(0);
      +executed(0);
      +bandera(pos(0,0,0));
      +spotted(0);
      +captured(0)
  . 


