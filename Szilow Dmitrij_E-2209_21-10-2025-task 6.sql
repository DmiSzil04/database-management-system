-- ЗАДАНИЕ 1
-- Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы 
-- в результате не было пар с одинаковыми названиями городов. Решение должно быть через Декартово произведение.

select c1.city, c2.city
from city as c1, city as c2
where c1.city != c2.city

 
-- ЗАДАНИЕ 2
-- Вывести все страны, в которых нет магазинов сети
 
select distinct cn.country, s.store_id
from country as cn
inner join city as ct using(country_id)
inner join address as a using(city_id)
left join store as s using(address_id)
where s.store_id is Null
order by cn.country

--Интересно, что среди стран есть Югославия (при отсутствии Хорватии, Боснии и Герцеговины и т.д.), Чехия и Словакия отдельно, 
--15 бывших Советских республик
--Если данные за 2005-2006 год, то к этому моменту Хорватия и Босния и Герцеговина уже были отдельно от СФРЮ
--Их отсутствие необычно, учитывая, что среди стран есть, например, Афганистан или Замбия
--А сама Югославия преобразована в Государственный союз Сербии и Черногории (распался 05 июня 2006)
 
 
-- ЗАДАНИЕ 3
-- Вывести наименования языков, на которых нет ни одного фильма прокатоной компании. 
 
select language.name
from film
right join language using(language_id)
where film_id is null
order by language.name

-- ЗАДАНИЕ 4 
-- Переписать предыдущий запрос, использовав симметричный вид JOIN. 
 
select language.name
from film
full join language using(language_id)
where film_id is null
order by language.name
 
-- ЗАДАНИЕ 5
-- Посчитать количество фильмов, для которых актерский состав неизвестен. 
 
select  film_id
from film_actor
right join film using(film_id)
where actor_id is Null
order by film_id
 
 
 -- ЗАДАНИЕ 6
 -- В каких магазинах был арендован фильм ACE GOLDFINGER (film_id = 2)? Выведите города, в котором располагатся эти магазины. 

select fl.title, ct.city
from inventory as nv
inner join film as fl using(film_id)
inner join rental as rn using(inventory_id)
inner join store as sr using(store_id)
inner join address as dr using(address_id)
inner join city as ct using(city_id)
where fl.film_id = 2
 
 
 
 -- ЗАДАНИЕ 7 
 -- Используя одностороннее присоединение (Left или right join) выведите адрес магазина, в котором фильм
 -- ACE GOLDFINGER (film_id = 2) ни разу не брали в аренду. 

select fl.title, dr.address, nv.inventory_id, rn.rental_id
from inventory as nv
inner join store as sr using(store_id)
inner join film as fl using(film_id)
inner join address as dr using(address_id)
left join rental as rn using(inventory_id)
where rn.rental_id is null
order by film_id

--странно, что единственный фильм, ни разу не взятый в аренду - Academy Dinosaurs, а не Ace Goldfinger
--Вывод: я нашёл, что диск с номером 5 ни разу не брали в аренду


