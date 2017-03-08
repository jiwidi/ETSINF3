--9
select min(altura),max(altura)
from puerto;
--10
select p.nompuerto,p.categoria
from puerto p,ciclista c
where p.dorsal=c.dorsal
and c.nomeq='Banesto';
--11
select p.nompuerto,p.netapa,e.km
from puerto p,etapa e
where e.netapa=p.netapa;
--12
select distinct eq.nomeq,eq.director
from equipo eq,ciclista c
where eq.nomeq=c.nomeq
and c.edad>33;
--13
select distinct c.nombre,m.color
from ciclista c,llevar l,maillot m
where c.dorsal=l.dorsal
and l.codigo=m.codigo;
--14
select distinct c.nombre,e.netapa
from ciclista c, llevar l,etapa e,maillot m
where c.dorsal=e.dorsal
and c.dorsal=l.dorsal
and m.codigo=l.codigo
and m.color='Amarillo';
--15
select et.netapa
from etapa et,etapa et2
where et.netapa=et2.netapa+1
and et.salida <> et2.llegada;
--16
select netapa,salida
from etapa
where netapa not in(
  select netapa 
  from puerto
  );
--17
select avg(edad)
from ciclista
where dorsal in(
  select dorsal
  from etapa
  );
--18
select nompuerto
from puerto
where altura>(
  select avg(altura)
  from puerto
  );
--19
select salida,llegada
from etapa
where netapa=(
  select netapa
  from puerto
  where pendiente in(
    select max(pendiente)
    from puerto
    )
    );
--20
select dorsal,nombre
from ciclista
where dorsal in (
  select dorsal
  from puerto
  where altura in(
    select max(altura)
    from puerto
    )
    );
--21
select nombre
from ciclista
where edad=(
  select min(edad)
  from ciclista
  );
--22
select nombre
from ciclista,etapa h
where edad=(
  select min(edad)
  from ciclista,etapa e
  where e.dorsal=ciclista.dorsal
  )
and ciclista.dorsal=h.dorsal;
--23
select distinct nombre
from ciclista c
where 1<(
  select count(c1.dorsal)
  from ciclista c1,puerto p
  where c1.dorsal=p.dorsal
  and c.dorsal=c1.dorsal
  );
--24
select netapa
from etapa et
where not exists(
  select nompuerto
  from puerto
  where puerto.netapa=et.netapa
  and puerto.altura<700
  )
and exists(
  select nompuerto
  from puerto
  where puerto.netapa=et.netapa
  and puerto.altura>700);
--25
select nomeq,director
from equipo
where not exists(
  select *
  from ciclista
  where ciclista.nomeq=equipo.nomeq
  and ciclista.edad<=25
  )
and exists(
  select *
  from ciclista
  where ciclista.nomeq=equipo.nomeq
  and ciclista.edad>25
  );
--26
select c.dorsal,c.nombre
from ciclista c
where not exists(
  select netapa
  from etapa
  where etapa.dorsal=c.dorsal
  and km<=170)
and exists(select netapa
  from etapa
  where etapa.dorsal=c.dorsal
  and km>170);
--27
select c.nombre
from ciclista c
where not exists(
  select ne.netapa
  from etapa ne
  where ne.dorsal=c.dorsal
  and not exists(
    select nompuerto
    from puerto
    where puerto.netapa=ne.netapa
    and puerto.dorsal=c.dorsal)
    )
and exists(
  select ne.netapa
  from etapa ne
  where ne.dorsal=c.dorsal
  and not exists(
    select nompuerto
    from puerto
    where puerto.netapa=ne.netapa
    and puerto.dorsal <> c.dorsal)
    );
--28
select e.nomeq
from equipo e
where not exists(
  select c.dorsal
  from ciclista c 
  where c.dorsal not in(
    select dorsal
    from llevar
    )
  and c.nomeq=e.nomeq
  and c.dorsal not in(
    select dorsal
    from puerto
    )
  )
and exists(
  select c.dorsal
  from ciclista c
  where c.nomeq=e.nomeq
  );
--29
select m.codigo,m.color
from maillot m
where not exists(
  select c.dorsal
  from ciclista c,ciclista c2,llevar l,llevar l2
  where c.dorsal=l.dorsal
  and c2.dorsal=l2.dorsal
  and c.dorsal <> c2.dorsal
  and l.codigo=m.codigo
  and l2.codigo=m.codigo
  and c.nomeq <> c2.nomeq
 )
and exists(
  select *
  from ciclista c,llevar l
  where c.dorsal=l.dorsal
  and l.codigo=m.codigo
  );
--30
select e.nomeq
from equipo e
where not exists(
  select c.dorsal
  from ciclista c,puerto p
  where c.nomeq=e.nomeq
  and p.dorsal=c.dorsal
  and p.categoria <> '1'
  )
and exists(
  select c.dorsal
  from ciclista c,puerto p
  where c.nomeq=e.nomeq
  and p.dorsal=c.dorsal
  and p.categoria ='1'
  );
--31
select e.netapa,count(p.nompuerto)
from etapa e,puerto p
where p.netapa=e.netapa
group by e.netapa;
--32
select e.nomeq,count(c.dorsal)
from equipo e, ciclista c
where e.nomeq=c.nomeq
group by e.nomeq;
--33
select nomeq,count(nomeq)
from equipo left join ciclista c using(nomeq)
group by nomeq;
--34
select e.director,e.nomeq
from equipo e
where 4>(
  select count(c.dorsal)
  from ciclista c
  where c.nomeq=e.nomeq)
and 30>=(
  select avg(edad)
  from ciclista c
  where c.nomeq=e.nomeq);
--35
select c.nombre
from ciclista c,equipo e,etapa p
where c.nomeq=e.nomeq
and c.dorsal=p.dorsal
and (select count(*) from ciclista c2 where c2.nomeq=e.nomeq)>5
group by c.nombre;
--36
select c.nomeq,avg(c.edad)
from  ciclista c
group by c.nomeq
having avg(c.edad)>=ALL(
  select avg(c.edad)
  from  ciclista c
  group by c.nomeq);
--37
select e.director
from equipo e
where (
  select count(*) from llevar l, ciclista c where c.nomeq=e.nomeq and l.dorsal=c.dorsal)>=ALL(
  select count(*) from llevar ,ciclista where llevar.dorsal=ciclista.dorsal group by nomeq);
--38
select distinct m.color,m.codigo
from maillot m,ciclista c,llevar l,etapa e
where m.codigo=l.codigo
and l.dorsal <> e.dorsal;
--39
select e.netapa,e.salida,e.llegada
from etapa e
where km>190
and 1<(
  select count(*)
  from puerto p
  where p.netapa=e.netapa
  );
--40
select c.dorsal,c.nombre
from ciclista c
where exists(
  select codigo
  from llevar l
  where l.dorsal=20
  and l.codigo not in(
    select l2.codigo
    from llevar l2
    where l2.dorsal=c.dorsal
    )
    );
--41
select distinct c.dorsal,c.nombre
from ciclista c
where exists(
  select l.codigo
  from llevar l
  where c.dorsal=l.dorsal
  and l.codigo in(
    select l2.codigo
    from llevar l2
    where l2.dorsal=20
    )
    );
--42
select c.dorsal,c.nombre
from ciclista c
where not exists(
  select l.codigo
  from llevar l
  where l.dorsal=c.dorsal
  and l.codigo in(
    select l2.codigo
    from llevar l2
    where l2.dorsal=20
    )
    );
--43
select c.dorsal,c.nombre
from ciclista c
where not exists(
    select l.codigo
    from llevar l
    where l.dorsal=20
    and l.codigo not in
    (
      select l2.codigo
      from llevar l2
      where l2.dorsal=c.dorsal
    )
    );
--44
select c.dorsal,c.nombre
from ciclista c
where not exists(
    select l.codigo
    from llevar l
    where l.dorsal=20
    and l.codigo not in
    (
      select l2.codigo
      from llevar l2
      where l2.dorsal=c.dorsal
    )
    )
and not exists(
  select l.codigo
  from llevar l
  where l.dorsal=c.dorsal
  and l.codigo in(
    select l2.codigo
    from llevar l2
    where l2.dorsal=20
    )
    );
--45
select c.nombre,c.dorsal
from 
