SELECT P.COD_PELI, P.TITULO
FROM CS_PELICULA P
WHERE P.COD_PELI IN (SELECT AT.COD_PELI
                     FROM CS_ACTUA AC
                     WHERE AT.COD_ACT IN (SELECT A.COD_ACT
                                          FROM CS_ACTOR A
                                          WHERE A.NOMBRE = P.DIRECTOR));


