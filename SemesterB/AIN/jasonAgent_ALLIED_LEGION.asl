debug(3).

// Name of the manager
manager("Manager").

// Team of troop.
team("ALLIED").
// Type of troop.
type("CLASS_SOLDIER").


{ include("jgomas.asl") }


/////////////////////////////////
//  GET_AGENT_TO_AIM
/////////////////////////////////

//No he modificado este plan  

+!get_agent_to_aim
<- 
	?fovObjects(FOVObjectso);
	.length(FOVObjectso, Lengtho);
	if (Lengtho > 0) {
		+buclea(0);
		-+aimed("false");
		while (aimed("false") & buclea(Xo) & (Xo < Lengtho)) { 
			.nth(Xo, FOVObjectso, Objecto);
			// Object structure
			// [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
			.nth(2, Objecto, Typeo);
			if (Typeo > 1000) {
			} 
			else {
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
	-buclea(_)
.


/////////////////////////////////
//  LOOK RESPONSE
/////////////////////////////////

//Utilizaba este método para ver lo que veían los agentes. No hace nada ahora mismo

+look_response(FOVObjectse)[source(M)]
<-  
	?my_position(X, Y, Z);
	//.println("X = ", X , " Y = ", Y, " Z = ", Z);
	.length(FOVObjectse, Lengthe);
	//si hay mas de un objeto en el campo de visión
	if (Lengthe > 0) {
		+bucleb(0);
		//recorremos la lista de todos los objetos
		while (bucleb(Xe) & (Xe < Lengthe)) {
			.nth(Xe, FOVObjectse, Objecte);
			//extraemos el tipo, equipo y distancia
			.nth(2, Objecte, Typee);
			.nth(1, Objecte, Teame);
			.nth(4, Objecte, Distancee);
			//.println("Veo un ",Type, " del equipo ",Team, " a una distancia de ", Distance, " length ", Length, " X", X);
			-+bucleb(Xe+1);
			bucleb(Xe);
		}
		-bucleb(_);
	};
	//borramos el belief y sobreescribimos la lista de objetos  
	-look_response(_)[source(M)];
	-+fovObjects(FOVObjectse);
	!look
.


/////////////////////////////////
//  FLAG
/////////////////////////////////

//Se llama a este método cuando un agente ve la bandera. Es el propio agente el que lo llama

+!flag
<-
	//mando un mensaje del tipo spot(1) a todos los miembros de mi equipo      
	.my_team("ALLIED", Eee);
	.println("MANDANDO BANDERA");
	?bandera(pos(Xxx,Yyy,Zzz));
	.concat("spot(1)", Content3);
	.send_msg_with_conversation_id(Eee, tell, Content3, "INT");
	//ejecuto el método split, que indicará a los agentes que se separen, para no entrar juntos  a por la bandera
	!split;
	//Hace una espera y manda el mensaje bandera
	.wait(1000);
	.concat("bandera(",Xxx, ", ", Yyy, ", ", Zzz, ")", Content2);
	.send_msg_with_conversation_id(Eee, tell, Content2, "INT");
.            
        
/////////////////////////////////
//  PERFORM ACTIONS
/////////////////////////////////

//No he modificado este plan

+!perform_aim_action
<-
	// Aimed agents have the following format:
	// [#, TEAM, TYPE, ANGLE, DISTANCE, HEALTH, POSITION ]
	?aimed_agent(AimedAgent);
	.nth(1, AimedAgent, AimedAgentTeam);
	?debug(Mode); if (Mode<=2) { .println("BAJO EL PUNTO DE MIRA TENGO A ALGUIEN DEL EQUIPO ", AimedAgentTeam);}             
	?my_formattedTeam(MyTeam);


	if (AimedAgentTeam == 200) {
		.nth(6, AimedAgent, NewDestination);
	}
	//.println("inside perform_aim_action");
.


//Gasto este plan para indicar que la bandera está a la vista

+!perform_look_action 
<- 
	?fovObjects(FOVObjectsb);
	.length(FOVObjectsb, Lengthb);
	//si hay algo a la vista
	if (Lengthb > 0) {
		+buclec(0);
		//recorro la lista de objetos que hay a la vista
		while ( buclec(Xb) & (Xb < Lengthb)) {
			.nth(Xb, FOVObjectsb, Objectb);
			//Miro el tipo de cada objeto
			.nth(2, Objectb, Typeb);
			//si es la bandera
			if (Typeb == 1003) {
				//miro su posición y compruebo que es válida
				.nth(6,Objectb,Possb);
				check_position(Possb);
				?position(Pb);
				if(Pb == valid){
					//si soy el primero en verla (tengo el belief de spotted a 0)
					?spotted(Spb);
					if(Spb == 0){
						//marco que la he visto
						-+spotted(1);
						//actualizo el belief de bandera
						-+bandera(Possb);
						//lanzo el plan flag, que controlará la entrada de todos los agentes hacia la bandera
						!flag;
						//voy a por la bandera
						!add_task(task(1500,"TASK_GET_OBJECTIVE", M,Possb, ""));
					}
				}	
			} 
			-+buclec(Xb+1); 
		}   
	}
	-buclec(_);
	!look
.


//No he modificado este plan

+!perform_no_ammo_action . 
	/// <- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_NO_AMMO_ACTION GOES HERE.") }.


//No he modificado este plan

+!perform_injury_action .
	///<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR PERFORM_INJURY_ACTION GOES HERE.") }. 
        

/////////////////////////////////
//  SETUP PRIORITIES
/////////////////////////////////

//Paso las prioridades cada vez que llamo a una tarea, no utilizo prioridades default

+!setup_priorities
<-  
	+task_priority("TASK_NONE",0);
	+task_priority("TASK_GIVE_MEDICPAKS", 0);
	+task_priority("TASK_GIVE_AMMOPAKS", 0);
	+task_priority("TASK_GIVE_BACKUP", 0);
	+task_priority("TASK_GET_OBJECTIVE",0);
	+task_priority("TASK_ATTACK", 0);
	+task_priority("TASK_RUN_AWAY", 0);
	+task_priority("TASK_GOTO_POSITION", 0);
	+task_priority("TASK_PATROLLING", 0);
	+task_priority("TASK_WALKING_PATH", 0)
.   


/////////////////////////////////
//  UPDATE TARGETS
/////////////////////////////////

//bloque de código que se ejecuta cuando se actualizan los objetivos

+!update_targets
<-
	//si la lista de tareas está vacía
	?tasks(Tasklistc);
	.length(Tasklistc, Lengthc);
	if(Lengthc < 1)  {
		//si soy el capitán
		?capitan(Cap);
		if(Cap == 1){
			//si no han formado en base aún
			?boot(Bo);
			if(Bo == 0){
				//mando que formen y actualizo el belief boot, para saber que ya están formando
				.println("mandando formation 0");
				!formation(0);
				-+boot(1);
			}
		}
		//si no soy el capitán
		else{
			//si nos estamos retirando
			?retiring(Ret);
			if(Ret == 1){
				//espero en la base enemiga para que el que lleve la bandera salga delante de mí
				.wait(6000);
				.println("back to base");
				//vuelvo a base
				!add_task(task(500,"TASK_GOTO_POSITION", M,pos(30,0,30), ""));
			}
			//si no he confirmado mi posición
			?confirmed(Kc);
			if(Kc == 0){
				//vemos si el agente ha ido a la posición inicial asignada por el capitán
				?executed(Ec);
				//si es así
				if(Ec == 1){
					//el agente manda un mensaje al capitán diciendo que que ya está formado(en el sitio)
					.my_team("capitan_ALLIED", Cc);
					Formed = "confirm(1)";
					.send_msg_with_conversation_id(Cc,tell,Formed,"INT");
				}
			}
		}
	}
.
		
	
/////////////////////////////////
//  CHECK MEDIC ACTION (ONLY MEDICS)
/////////////////////////////////

//No he modificado este plan

+!checkMedicAction
<-  
	-+medicAction(on)
.

      
      
/////////////////////////////////
//  CHECK FIELDOPS ACTION (ONLY FIELDOPS)
/////////////////////////////////

//No he modificado este plan

+!checkAmmoAction
<-  
	-+fieldopsAction(on)
.


/////////////////////////////////
//  PERFORM_TRESHOLD_ACTION
/////////////////////////////////

//Utilizo este plan para que si el portador de la bandera está bajo de vida que el equipo vaya en su ayuda 

+!performThresholdAction
<-
	//No he modificado el bloque de la munición
	?my_ammo_threshold(At);
	?my_ammo(Ar);
	if (Ar <= At) { 
		?my_position(Xd, Yd, Zd);
		.my_team("fieldops_ALLIED", E1);
		//.println("Mi equipo intendencia: ", E1 );
		.concat("cfa(",Xd, ", ", Yd, ", ", Zd, ", ", Ar, ")", Content1d);
		.send_msg_with_conversation_id(E1, tell, Content1d, "CFA");
	}
	//Si mi vida está por debajo del umbral
	?my_health_threshold(Ht);
	?my_health(Hr);
	if (Hr <= Ht) {
		//Si soy el portador de la bandera
		?carrier(Ca);
		if(Ca == 1){
			//Mando un mensaje del tipo spot(2) a todos los miembros de mi equipo
			?my_position(Xd, Yd, Zd);
			.my_team("ALLIED", E2);
			.concat("spot(2)", Contente);
			.send_msg_with_conversation_id(E2, tell, Contente, "INT");
			.println("I'm low on health");
		}
	}
.

       
/////////////////////////////////
//  ANSWER_ACTION_CFM_OR_CFA
/////////////////////////////////

//bloque no modificado

+cfm_agree[source(M)]
<- 
	?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_agree GOES HERE.")};
	-cfm_agree
.  

+cfa_agree[source(M)]
	<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_agree GOES HERE.")};
	-cfa_agree
.  

+cfm_refuse[source(M)]
	<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfm_refuse GOES HERE.")};
	-cfm_refuse
.  

+cfa_refuse[source(M)]
	<- ?debug(Mode); if (Mode<=1) { .println("YOUR CODE FOR cfa_refuse GOES HERE.")};
	-cfa_refuse
.  


/////////////////////////////////
//  RECIBIDO GOTO
/////////////////////////////////

//código a ejecutar cuando se recibe el mensaje de formación, mandado por el capitán

+goto(Xe,Ye,Ze,Xm,Ym,Zm)[source(A)]
<-
	.println("Recibido un mensaje de tipo goto de ", A, " x " , Xe, " Z ", Ze );
	//comprobamos que la posicion mandada por el capitán sea válida
	check_position(pos(Xe,Ye,Ze));
	?position(Pe);
	//en caso de que lo sea
	if(Pe == valid){
		//vacíamos la lista de tareas
		-+tasks([]);
		//vamos a la posicion indicada en el mensaje
		!add_task(task(1000,"TASK_GOTO_POSITION", M,pos(Xe,Ye,Ze), ""));
		//ponemos el belief de executed a 1
		-+executed(1);
	}
	//si la posicion no es válida
	else{
		//vaciamos la lista de tareas
		-+tasks([]);
		.println("no valida");
		//vamos a la posición a la que va el capitán
		!add_task(task(1000,"TASK_GOTO_POSITION", M,pos(Xm,Ym,Zm), ""));
	}
.


/////////////////////////////////
//  RECIBIDO SPLIT
/////////////////////////////////

//split es parecido a goto pero no vacía la lista de tareas y tiene más prioridad

+split(Xe,Ye,Ze,Xm,Ym,Zm)[source(A)]
<-
	.println("Recibido un mensaje de tipo split de ", A, " x " , Xe, " Z ", Ze );
	//comprobamos que la posicion mandada por el capitán sea válida
	check_position(pos(Xe,Ye,Ze));
	?position(Pe);
	//en caso de que lo sea
	if(Pe == valid){
		//vamos a la posicion indicada en el mensaje
		!add_task(task(2500,"TASK_GOTO_POSITION", M,pos(Xe,Ye,Ze), ""));
	}
	//si la posición no es válida
	else{
		.println("no valida");
		//vamos a la posición del capitán
		!add_task(task(2500,"TASK_GOTO_POSITION", M,pos(Xm,Ym,Zm), ""));
	}
.


/////////////////////////////////
//  RECIBIDO BANDERA
/////////////////////////////////

//un agente ha visto la bandera y avisa a todos los aliados para ir a buscarla

+bandera(Xf,Yf,Zf)[source(A)]
<-
	.wait(100);
	.println("Recibido un mensaje de tipo bandera de ", A, " coordenadas " , Xf ," ", Yf, " ", Zf);
	//comprobamos que la posición donde se encuentra la bandera sea válida
	check_position(pos(X,Y,Z));
	?position(Pf);
	//en el caso de que lo sea (que siempre lo va a ser, pues la bandera tiene que estar dentro del mapa)
	if(Pf == valid){
		//actualizamos la creencias confirmed
		-+confirmed(1);
		//hacemos que vaya a por la bandera
		!add_task(task(1500,"TASK_GET_OBJECTIVE", M,pos(Xf,Yf,Zf), ""));
	}
.


/////////////////////////////////
//  RECIBIDO SPOT
/////////////////////////////////

//Spot sirve para modificar creencias en base a mensajes 

+spot(Ss)[source(A)]
<-
	//spot(1) se recibe cuando un agente ha visto la bandera
	if(Ss == 1){
		//pone el belief de todos los demas a (1) para que no notifiquen que ellos tambien han visto la bandera
		-+spotted(Ss);
		.println("Agent ", A, "spotted the flag ");
	}
	//spot(0) se recibe cuando un agente coge la bandera
	if(Ss == 0){
		//activa el belief retiring, que marca la retirada
		.println("Agent ", A, "took the flag ");
		-+retiring(1);
		//ya no tiene sentido tener un capitan en este punto, pues mandará quien tenga la bandera
		-+capitan(0);
	}
	//spot(2) se recibe cuando el portador de la bandera tiene poca vida
	if(Ss == 2){
		//pone el belief spotted a 0 para que se vuelva a notificar y coger la bandera en el caso de que esta cayera
		.println("Agent ", A, "has the flag and he's low on health");
		-+spotted(0);
	}
.


/////////////////////////////////
//  HOWFAR
/////////////////////////////////

//Este plan sirve para mandar la distancia desde mi posicion hasta el punto de formado

+!howfar
<-
	//compruebo el belief de mi distancia
	?my_dis(Dis);
	//mando un mensaje distancia a todos mis compañeros     
	.my_team("ALLIED", Team);
	.println("Mandando mi distancia ",Dis);
	.concat("distancia(",Dis,")", Content);
	.send_msg_with_conversation_id(Team, tell, Content, "INT");
. 


/////////////////////////////////
//  FORMATION
/////////////////////////////////

//Este plan se utiliza para que el capitan o coordinador forme a los soldados, lo uso para el movimiento coordinado

+!formation(Ty)
<-
	//si el argumento es 0 se forma respecto al capitán (o el que llama al plan)
	if(Ty == 0){     
		?my_position(Xx, Yy, Zz);
	}
	//si es 1 se irá a por la bandera (llegando allí formados)
	if(Ty == 1){     
		?objective(Xx, Yy, Zz);
	}
	// si es 2 se volverá a base (llegando formados)
	if(Ty == 2){     
		+base(30, 0, 30);
		?base(Xx, Yy, Zz);
	}
	//si hay agentes de mi equipo vivos
	.my_team("ALLIED", Sl);
	.length(Sl, Lengthsl);
	if (Lengthsl > 0) {
		//coordx y coordz es la distancia en cada eje que va a separar a los agentes
		+buclesl(0);
		+coordX(4);
		+coordZ(4);
		+bool(0);
		//para cada uno de los agentes en mi equipo
		while (buclesl(Bsl) & (Bsl < Lengthsl)) {
			//compruebo su id
			.nth(Bsl, Sl, Agent);
			?coordX(Cx);
			?coordZ(Cz);
			//bool es una variable que va alterandose para que el capitan se quede en medio
			?bool(B);
			//si bool es 0
			if(B == 0){
				//mando al agente a un lado
				.concat("goto(",Xx + Cx, ", ", Yy, ", ", Zz - Cz, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content1);
				.send_msg_with_conversation_id(Agent, tell, Content1, "INT");
				//pongo bool a 1
				-+bool(1);
			}
			//si bool es 1
			else{
				//pongo al agente al oro lado
				.concat("goto(",Xx - Cx, ", ", Yy, ", ", Zz + Cz, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content1);
				.send_msg_with_conversation_id(Agent, tell, Content1, "INT");
				//actualizo las diferencias
				-+coordX(Cx+4);
				-+coordZ(Cz+4);
				//pongo bool a 0
				-+bool(0);
			}
			-+buclesl(Bsl+1);
		}
		-buclesl(_);
		-coordZ(_);
		-coordX(_);
	}
. 


/////////////////////////////////
//  SPLIT
/////////////////////////////////

//Split separa a los agentes para que no se amontonen cuando van a por la bandera
//es parecido a formation, pero como no los pongo en línea tengo que mandar a cada agente una posicion personalizada  

+!split [ATOM]
<- 
	//comprobamos la posicion de la bandera  
	?objective(Xx, Yy, Zz);
	//miramos cuantos agentes hay en el equipo
	.my_team("ALLIED", Teaml);
	.length(Teaml, Lengthsteam);
	//creamos beliefs para la lista de agentes y su longitud
	+ltee(Lengthsteam);
	+teamm(Teaml);
	//consultamos los beliefs de la lista y la longitud
	?ltee(Lengthsteam0);
	?teamm(Teaml0);
	//mandamos a cada agente a su posicion con esta serie de ifs
	//si hay por lo menos un agente
	if (Lengthsteam0 > 0) {
		//comprobamos el id del agente
		.nth(0, Teaml0, Agent0);
		//mandamos el mensaje split con posiciones relativas respecto a la bandera
		.concat("split(",Xx - 15, ", ", Yy, ", ", Zz, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content0);
		.send_msg_with_conversation_id(Agent0, tell, Content0, "INT");
	}
	//si hay por lo menos dos agentes
	?ltee(Lengthsteam1);
	?teamm(Teaml1);
	if (Lengthsteam1 > 1) {
		.nth(1, Teaml1, Agent1);
		.concat("split(",Xx - 10, ", ", Yy, ", ", Zz - 5, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content1);
		.send_msg_with_conversation_id(Agent1, tell, Content1, "INT");
	}
	//si hay por lo menos tres agentes
	?ltee(Lengthsteam2);
	?teamm(Teaml2);
	if (Lengthsteam2 > 2) {
		.nth(2, Teaml2, Agent2);
		.concat("split(",Xx - 5, ", ", Yy, ", ", Zz - 10, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content2);
		.send_msg_with_conversation_id(Agent2, tell, Content2, "INT");
	}
	//si hay por lo menos cuatro agentes
	?ltee(Lengthsteam3);
	?teamm(Teaml3);
	if (Lengthsteam3 > 3) {
		.nth(3, Teaml3, Agent3);
		.concat("split(",Xx , ", ", Yy, ", ", Zz - 15, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content3);
		.send_msg_with_conversation_id(Agent3, tell, Content3, "INT");
	}
	//si hay por lo menos cinco agentes
	?ltee(Lengthsteam4);
	?teamm(Teaml4);
	if (Lengthsteam4 > 4) {
		.nth(4, Teaml4, Agent4);
		.concat("split(",Xx + 5, ", ", Yy, ", ", Zz - 10, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content4);
		.send_msg_with_conversation_id(Agent4, tell, Content4, "INT");
	}
	//si hay por lo menos cinco agentes
	?ltee(Lengthsteam5);
	?teamm(Teaml5);
	if (Lengthsteam5 > 5) {
		.nth(5, Teaml5, Agent5);
		.concat("split(",Xx + 10, ", ", Yy, ", ", Zz - 5, ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content5);
		.send_msg_with_conversation_id(Agent5, tell, Content5, "INT");
	}
	//si hay por lo menos seis agentes
	?ltee(Lengthsteam6);
	?teamm(Teaml6);
	if (Lengthsteam6 > 6) {
		.nth(6, Teaml6, Agent6);
		.concat("split(",Xx + 15, ", ", Yy, ", ", Zz , ", ", Xx, ", ", Yy, ", ", Zz,  ")", Content6);
		.send_msg_with_conversation_id(Agent6, tell, Content6, "INT");
	}    
.               


/////////////////////////////////
//  RECIBIDO DISTANCIA
/////////////////////////////////

//Es el plan utilizado para designar al capitán que coordinará el ataque

+distancia(D)[source(A)]
<-
	//si mi distancia al punto es menor que la que recibo
	.println("Recibido un mensaje de tipo distancia de ", A, " dist " , D);
	?my_dis(Midis);
	if(Midis < D){
		//sumo 1 a mi belief closerthan
		?closerthan(Ct);
		-+closerthan(Ct+1);
		.println("mas cerca que", Ct+1);
		//si estoy ams creca que 7 personas del punto de formado quiere decir que soy el que mas cerca está
		if((Ct+1) == 7){
			//me autoproclamo capitán, me registro como tal y voy a la posición de formado
			.println("SOY EL CAPITAN");
			-+capitan(1);
			.register( "JGOMAS","capitan_ALLIED");
			!add_task(task(2000,"TASK_GOTO_POSITION", M,pos(35,0,35), ""));
			.println("FORMACION");
		}
	}
	//para secuencializar el envio de distancias y hacerlo consistente, cada agente manda su distancia cuando recibe la del agente anterior
	.concat("",A, As);
	?name_string(Names);
	if(Names == "A2" & As == "A1"){
		!howfar;
	}
	if(Names == "A3" & As == "A2"){
		!howfar;
	}
	if(Names == "A4" & As == "A3"){
		!howfar;
	}
	if(Names == "A5" & As == "A4"){
		!howfar;
	}
	if(Names == "A6" & As == "A5"){
		!howfar;
	}
	if(Names == "A7" & As == "A6"){
		!howfar;
	}
	if(Names == "A8" & As == "A7"){
		!howfar;
	}
.


/////////////////////////////////
//  RECIBIDO CONFIRM
/////////////////////////////////

//Este bloque sirve para que el capitan sepa que todos los agentes estan formados en la base, y así poder salir en formación

+confirm(K)[source(A)]
<-
	//por cada confirm recibido, aumenta en 1 el belief checks
	.println("Recibido un mensaje de tipo confirm de ", A);
	if(K == 1){
		?checks(J);
		-+checks(J+1);
	}
	//si checks es igual a 7, quiere decir que todos los agentes estan formados
	?checks(Jj);
	if(Jj == 7){
		.println("todo chequeado ");
		?objective(Xo,Yo,Zo);
		.wait(500);
		.println("Al ataque!");
		//se ejecuta el plan formation(1) para ir formados a por la bandera 
		!formation(1);
		//cambia el belief boot a 1, pues ya estan atacando
		-+boot(1);
		//el propio capitán va a por la bandera
		!add_task(task(1500,"TASK_GET_OBJECTIVE", M,pos(Xo,Yo,Zo), ""));
	}
.


/////////////////////////////////
//  OBJECTIVEPACKTAKEN
/////////////////////////////////

//Este bloque lo ejecuta un agente cuando ha cogido la bandera

+objectivePackTaken(On)
<-
	if(On == on){
		.println("tengo la bandera!!!");
		.my_team("ALLIED", Eee);
		.concat("spot(0)", Content3);
		//hace que todos los soldados formen respecto a la bandera, para salir formados de la base enemiga
		!formation(0);
		.wait(100);
		//manda spot(0), diciendo que ha cogido la bandera
		.send_msg_with_conversation_id(Eee, tell, Content3, "INT");
		-+carrier(1);
	}
.


/////////////////////////////////
//  Initialize variables
/////////////////////////////////


+!init
<- 
	//registro el agente como squad
	.register( "JGOMAS","squad_ALLIED");
	//vacío su lista de tareas, para que no vaya directamente a por la bandera
	-+tasks([]);
	.wait(500);
	//inicializo algunas creencias a cero, que servirán para controlar al agente
	//confirmed dice si el agente ha confirmado su posicion al formar en base
	+confirmed(0);
	//executed es si ha recibido la orden de formar
	+executed(0);
	//spotted es si ha visto la bandera
	+spotted(0);
	//closerthan es para saber si es el que mas cerca se encuentra del punto de formado
	+closerthan(0);
	//capita es para saber si es capitan
	+capitan(0);
	//checks dice cuantos agentes han confirmado su posicion al formar
	+checks(0);
	//boot dice si se ha salido de la base
	+boot(0);
	//retiring dice si se ha empezado la retirada
	+retiring(0);
	//carrier es para saber si llevo la bandera
	+carrier(0);
	//pomgo el threshold de vida a 10
	-+my_health_threshold(10);
	//calculo mi distancia respecto al punto de formado
	?my_position(X,Y,Z);
	Dis = math.sqrt(((35-X)*(35-X))+((35-Z)*(35-Z)));
	+my_dis(Dis);
	//compruebo mi nombre
	.my_name(Name);
	.println(Name);
	.concat("",Name, Names);
	+name_string(Names);
	//si soy A1 empiezo la secuencia de mandado de distancias
	//el código funciona con los nombre de agentes [A1,A2,A3,A4,A5,A6,A7,A8]
	//si se les llama de otra forma habría que cambiarlo en el código
	if(Names == "A1"){
		.wait(1000);
		.println(Name);
		!howfar;
	}
. 


