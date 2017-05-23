#!/usr/bin/octave -qf

if(nargin!=1)printf("Usage: multinomial.m <data_filename>");
	exit(1);
end

%cargamos el archivo de datos
arglist=argv();
datafile=arglist{1};
disp("Loading data...");
load(datafile);
disp("Data load complete.")

%generamos una array con los valores de épsilon para el suavizado
laplacev =[];
k=1;
for i = 1:20
	k=k/10;
	laplacev = [laplacev,k];
endfor

%por cada uno de los valores que toma épsilon
for laplace = laplacev

    %aplicamos la semilla de randomizado
	[nrows,ncols]=size(data);
	rand("seed",23);
	errortotal = [];
    
    %realizaremos 30 iteraciones para conseguir un resultado preciso
	for ii = 1:30

	   	%realizamos el barajado y separamos los datos de entrenamiento con una relación 90/10
		perm=randperm(nrows);
		pdata=data(perm,:);
		trper=0.9;
		ntr=floor(nrows*trper);
		nte=nrows-ntr;
		%conjunto de entrenamiento
		tr=pdata(1:ntr,:);
		%conjunto de prueba
		te=pdata(ntr+1:nrows,:);

		%calculamos el tamaño de la matriz de prueba
		[trrows,trcols]=size(tr);
		%separamos en matriz y labels(que son la última columna)
		matrixtr = tr(:,1:end-1);
		labelstr = tr(:,end);

		%buscamos los correos que pertenezcan a ham (etiqueta = 0)
		hamv = find(tr(:,trcols)==0);
		[totalham,xd]=size(hamv);
		%creamos su matriz
		matrixham = tr(hamv,1:end-1);
		%sumamos todos los vectores
		sham = sum(matrixham);
		%sumamos el vector suma, que nos da un escalar
		slow = sum(sham);
		%creamos el vector de prototipos
		pham = (1/(slow))*sham;
		%sumamos a cada componente del vector la constante épsilon(laplace)
		phaml = pham + laplace;
		%normalizamos
		phamlfin = phaml/(sum(phaml));
		%aplicamos los logaritmos para utilizarlo como clasificador
		wcham = log(phamlfin);
		bcham = log(totalham/trrows);

		%buscamos los correos que pertenezcan a spam (etiqueta = 1)
		spamv = find(tr(:,trcols)==1);
		[totalspam,xd]=size(spamv);
		%creamos su matriz
		matrixspam = tr(spamv,1:end-1);
		%sumamos todos los vectores
		sspam = sum(matrixspam);
		%sumamos el vector suma, que nos da un escalar
		spamlow = sum(sspam);
		%creamos el vector de prototipos
		pspam = (1/(spamlow))*sspam;
		%sumamos a cada componente del vector la constante épsilon(laplace)
		pspaml = pspam + laplace;
		%normalizamos
		pspamlfin = pspaml/(sum(pspaml));
		%aplicamos los logaritmos para utilizarlo como clasificador
		wcspam = log(pspamlfin);
		bcspam = log(totalspam/trrows);

		%este bloque es irrelevante para esta funcionalidad
		%sacamos los valores de la matriz para cada clase
			    %ghtr = wcham*matrixtr' + bcham;
			    %gstr = wcspam*matrixtr' + bcspam;
		%clasificamos cada vector(como ham es 0, si ghtr es mayor que gstr se signa a 0,fallando el <)
			    %resulttr = ghtr<gstr;
		%calculamos el numero de errores viendo las que son diferentes
			    %trresult=resulttr'!=labelstr;

		%creamos la matriz y el vector de labels de prueba
		matrixte = te(:,1:end-1);
		labelste = te(:,end);
		[terows,tecols]=size(te);

		%sacamos los valores de la matriz para cada clase
		ghte = wcham*matrixte' + bcham;
		gste = wcspam*matrixte' + bcspam;
		%clasificamos cada vector(como ham es 0, si ghtr es mayor que gstr se signa a 0,fallando el <)
		resultte = ghte<gste;
		%calculamos el vector de errores viendo las que son diferentes de sus etiquetas
		teresult=resultte!=labelste';

        	%calculamos el error de cada iteración
		errorparcial = sum(teresult)/terows;
        	%lo añadimos a un vector para computar la media y la desviación típica
		errortotal = [errortotal, errorparcial];
		%printf ("iter %d error %f\n",ii,errorparcial);
	endfor
    	%calculamos la media y la desviación típica
	errormean = mean(errortotal);
	errordv = std(errortotal);
    	%imprimimos los resultados
	printf ("epsilon %f mean %f std %f\n",laplace,errormean,errordv);
endfor





