--1
select nombre p
from autor p
where nacionalidad like 'Argentina';
--2
select titulo p
from obra p 
where titulo like '%mundo%';
--3
select p.id_lib,count(distinct e.cod_ob)
from libro p, esta_en e
where p.id_lib=e.id_lib
and p.año<1990
and num_obras>1
group by p.id_lib;
--4
select count(id_lib)
from libro
where año is not null;
--5
select count(id_lib)
from libro
where num_obras>1;
--6
select id_lib
from libro
where año=1997
and titulo is null;
--7
select titulo
from libro
where titulo is not null
order by titulo desc;
--9
select count(distinct autor.autor_id)
from autor,escribir,obra
where autor.autor_id=escribir.autor_id
and escribir.cod_ob=obra.cod_ob
and obra.titulo like '%ciudad%';
--10
select p.titulo
from obra p,escribir,autor
where p.cod_ob=escribir.cod_ob
and escribir.autor_id=autor.autor_id
and nombre='Camús, Albert';
--11
select autor.nombre
from autor,escribir,obra
where autor.autor_id=escribir.autor_id
and escribir.cod_ob=obra.cod_ob
and obra.titulo='La tata';
--12
select distinct nombre
from amigo,leer,escribir
where amigo.num=leer.num
and leer.cod_ob=escribir.cod_ob
and escribir.autor_id='RUKI';
--13
select p.id_lib,p.titulo
from libro p
where p.titulo is not null
and 1<(
  select count(distinct cod_ob)
  from esta_en
  where id_lib=p.id_lib);
--14
select a.nombre,o.titulo
from autor a,obra o,escribir e
where o.cod_ob=e.cod_ob
and a.autor_id=e.autor_id
and a.nacionalidad='Francesa'
and 1=(
  select count(*)
  from escribir ee
  where ee.cod_ob=e.cod_ob
  );
--15
select count(autor_id) as sin_obra
from autor a
where 0=(
  select count(*)
  from escribir e
  where a.autor_id=e.autor_id);
--16
select a.nombre
from autor a
where 0=(
  select count(*)
  from escribir e
  where a.autor_id=e.autor_id);
--17
select a.nombre
from autor a
where a.nacionalidad='Española'
and 1<(
  select count(*)
  from escribir e
  where e.autor_id=a.autor_id
  );
--18
select a.nombre
from autor a,escribir e,obra o
where a.nacionalidad='Española'
and a.autor_id=e.autor_id
and e.cod_ob=o.cod_ob
and 1<(
  select count(*)
  from esta_en es
  where es.cod_ob=o.cod_ob
  );
--19
select o.titulo,o.cod_ob
from obra o
where 1<(
  select count(a.autor_id)
  from obra oo,escribir e,autor a
  where oo.cod_ob=o.cod_ob
  and e.cod_ob=o.cod_ob
  and a.autor_id=e.autor_id
  );
--20
select am.nombre
from amigo am
where not exists(
  select e.cod_ob
  from escribir e
  where e.autor_id = 'RUKI'
  and e.cod_ob not in
    (select l.cod_ob
    from leer l
    where l.num = am.num))
and exists(
  select *
  from escribir
  where autor_id='RUKI'
  );
--21
select am.nombre
from amigo am
where not exists(
  select e.cod_ob
  from escribir e
  where e.autor_id = 'GUAP'
  and e.cod_ob not in
    (select l.cod_ob
    from leer l
    where l.num = am.num)
)
and exists(
  select *
  from escribir
  where autor_id='GUAP'
  );
--22
select distinct am.nombre
from escribir e, amigo am,leer l
where l.cod_ob=e.cod_ob
and am.num=l.num
and not exists(
  select e2.cod_ob
  from escribir e2
  where e2.autor_id=e.autor_id
  and cod_ob not in(
    select l2.cod_ob
    from leer l2
    where l2.num=l.num
    )
    );
--23
select distinct am.nombre,ata.nombre
from escribir e, amigo am,leer l,autor ata
where l.cod_ob=e.cod_ob
and ata.autor_id=e.autor_id
and am.num=l.num
and not exists(
  select e2.cod_ob
  from escribir e2
  where e2.autor_id=e.autor_id
  and cod_ob not in(
    select l2.cod_ob
    from leer l2
    where l2.num=l.num
    )
    );
--24
select distinct am.nombre
from amigo am,leer l
where l.num=am.num
and not exists(
  select l2.cod_ob
  from leer l2,escribir e2
  where e2.cod_ob=l2.cod_ob
  and e2.autor_id!='CAMA'
  and l2.num=l.num
  )
and exists(
  select l3.cod_ob
  from leer l3,escribir e3
  where l3.num=am.num
  and e3.cod_ob=l3.cod_ob
  and e3.autor_id='CAMA'
  );
--25
select distinct am.nombre
from amigo am,leer l
where l.num=am.num
and not exists(
  select l2.cod_ob
  from leer l2,escribir e2
  where e2.cod_ob=l2.cod_ob
  and e2.autor_id!='GUAP'
  and l2.num=l.num
  )
and exists(
  select l3.cod_ob
  from leer l3,escribir e3
  where l3.num=am.num
  and e3.autor_id='GUAP'
  );
--26
select distinct am.nombre
from amigo am,leer l,escribir e
where l.num=am.num
and e.cod_ob=l.cod_ob
and not exists(
  select l2.cod_ob
  from leer l2,escribir e2
  where e2.cod_ob=l2.cod_ob
  and e2.autor_id!=e.autor_id
  and l2.num=l.num
  )
and exists(
  select l3.cod_ob
  from leer l3,escribir e3
  where l3.num=am.num
  and e3.autor_id=e.autor_id
  );
--27
select distinct am.nombre, aa.nombre
from amigo am,leer l,escribir e,autor aa
where l.num=am.num
and aa.autor_id=e.autor_id
and e.cod_ob=l.cod_ob
and not exists(
  select l2.cod_ob
  from leer l2,escribir e2
  where e2.cod_ob=l2.cod_ob
  and e2.autor_id!=e.autor_id
  and l2.num=l.num
  )
and exists(
  select l3.cod_ob
  from leer l3,escribir e3
  where l3.num=am.num
  and e3.autor_id=e.autor_id
  );
--28
select distinct am.nombre
from amigo am, leer l,escribir e
where l.num=am.num
and e.cod_ob=l.cod_ob
and not exists(
  select e2.cod_ob
  from escribir e2
  where e2.autor_id=e.autor_id
  and cod_ob not in(
    select l2.cod_ob
    from leer l2
    where l2.num=l.num
    )
  )
and not exists(
  select l3.cod_ob
  from leer l3, escribir e3
  where l3.num=l.num
  and l3.cod_ob=e3.cod_ob
  and e3.autor_id <> e.autor_id
  );
--29
select li.titulo,li.id_lib
from libro li
where li.num_obras>1
and li.titulo is not null
group by li.titulo,li.id_lib;
--30
select am.nombre,count(l.cod_ob)
from amigo am, leer l
where am.num=l.num
group by am.nombre
having count(l.cod_ob)>3;
--30
select o.tematica,count(o.cod_ob)
from obra o
where o.tematica is not null
group by o.tematica;
--31
--39
select distinct nombre
from amigo left join leer l using (num)
where cod_ob in(
  select cod_ob
  from escribir e
  where e.autor_id='CAMA'
  );
—40
select am.nombre
from amigo am
where not exists(
  select l.num
  from leer l,escribir e
  where l.cod_ob=e.cod_ob
  and e.autor_id='CAMA'
  and l.num=am.num
  )
and exists(
  select l2.num
  from leer l2 
  where l2.num=am.num
  );
—41
select am.nombre
from amigo am,leer l
where am.num=l.num
and count(l.num)=MAX(
  select count(l2.num)
  from amigo am2,leer l2
  where am2.num=l2.num
  ):

