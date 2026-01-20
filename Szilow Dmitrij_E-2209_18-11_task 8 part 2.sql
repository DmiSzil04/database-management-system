id|parent_id|name                      |
--+---------+--------------------------+
 1|         |Планета Земля             |
 2|        1|Континент Евразия         |
 3|        1|Континент Северная Америка|
 4|        2|Европа                    |
 5|        4|Россия                    |
 6|        4|Германия                  |
 7|        5|Москва                    |
 8|        5|Санкт-Петербург           |
 9|        6|Берлин                    |
 10|       5|Псков                     |
 
-- ЗАДАНИЕ 1. Вывести все строчки, которые относятся к Европе.
 
create table political_entities(id int primary key, parent_id int, "name" varchar)
 
 insert into political_entities (id, parent_id, "name") values (1, 0, 'Планета Земля')
 
 insert into political_entities (id, parent_id, "name") values (2, 1, 'Континент Евразия')
 
 insert into political_entities (id, parent_id, "name") values (3, 1, 'Континент Северная Америка')
 
 insert into political_entities (id, parent_id, "name") values (4, 2, 'Европа')
 
 insert into political_entities (id, parent_id, "name") values (5, 4, 'Россия')
 
 insert into political_entities (id, parent_id, "name") values (6, 4, 'Германия')
 
 insert into political_entities (id, parent_id, "name") values (7, 5, 'Москва')
 
 insert into political_entities (id, parent_id, "name") values (8, 5, 'Санкт-Петербург')
 
 insert into political_entities (id, parent_id, "name") values (9, 6, 'Берлин')
 
 insert into political_entities (id, parent_id, "name") values (10, 5, 'Псков')
 
 select *
 from political_entities
 
 with recursive submission(line, id) as 
(select "name", id
from political_entities
where parent_id = 0
union
select line || '->' || pe2."name", pe2.id
from political_entities pe2
join submission s on s.id = pe2.parent_id)
select *
from submission
where line like '%Европа%'
 
 
-- ЗАДАНИЕ 2. Дополнить запрос 1 столбоц с уровнем вложенности. 

 with recursive submission(line, id) as 
(select "name", id, 0 as depth
from political_entities
where parent_id = 0
union
select line || '->' || pe2."name", pe2.id, s.depth+1
from political_entities pe2
join submission s on s.id = pe2.parent_id)
select *
from submission
where line like '%Европа%'


 
-- ЗАДАНИЕ 3. Вывести первые 10 чисел Фибоначчи
 
 with recursive fib as 
 (select 0 as first_num, 1 as second_num, 0+1 as fib_num
 union
 select second_num, fib_num, fib_num+second_num
 from fib)
 select *
 from fib
 limit 10

 
 
-- ЗАДАНИЕ 4. Прочитать доп. материал, попробовать самостоятельно выполнить задание в нем.
