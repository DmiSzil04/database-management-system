ЗАДАЧА 1
Используя функцию EXPLAIN ANALYZE сравните быстродействие запросов из последней задачи практики. Проанализируйте полученный результат и объясните, почему одни запросы выполняются быстрее других. 

-- Первый запрос
explain analyze 
select title
from film as f 
join film_category as fc using(film_id)
join category as c using(category_id)
where c."name" ilike 'C%' 

-- Второй запрос
explain analyze 
select title
from film as f 
join film_category as fc using(film_id)
join (select category_id, "name" from category where "name" ilike 'C%') as c using(category_id) 

--Первый запрос выполняется за 0,526 + 2,087 = 2,613 миллисекунд (от раза к разу время разное, взято случайное выпавшее время)
--Затрачивается 69 КБ ОЗУ
--Второй запрос выполняется за 0,842 + 1,657 = 2,499 миллисекунд
--Затрачивается 69 КБ ОЗУ
--В первом запросе присоединяются целые таблицы, а во втором - одна таблица целиком и два столбца из второй, причём сразу задаётся условие, по которому таблица обрезается

При выполнении задач ниже используйте подзапросы. 

ЗАДАЧА 2
С помощью SQL-запроса выведите адреса тех магазинов, у которых более 300 покупателей. Добавьте в запрос информацию о городе магазина, а также фамилию и имя продавца, который работает в этом магазине. 

select city.city as c_name, address, result.staff_name, sum(cnt) as cstms
from address
join (select st.address_id, sf.first_name || ' ' || sf.last_name as staff_name, count(customer_id) as cnt
from customer
inner join store as st using(store_id)
inner join staff as sf on st.manager_staff_id = sf.staff_id
group by st.address_id, staff_name
having count(customer_id) > 300) as result using(address_id)
inner join city using(city_id)
group by address, city.city, result.staff_name

ЗАДАЧА 3
Используя подзапросы, выведите ТОП-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов выведите фамилию и имя покупателя и количество фильмов, которые они взяли в аренду.

select first_name || ' ' || last_name as customer_name, count_films
from customer
inner join (select customer_id, count(rental_id) as count_films from rental group by customer_id order by count(rental_id) limit 5) as cl using(customer_id)

--select customer_id, count(rental_id) as count_films from rental group by customer_id order by count(rental_id) limit 5

ЗАДАЧА 4
Посчитайте количество продавцов, получивших премию: если количество продаж, выполненных каждым продавцом, превышает 7300, то он получает премию.

select count(staff.staff_id)
from staff
inner join (select staff_id, count(amount) as ttl_amnt, case when count(amount) > 7300 then 'Yes' else 'No' end as prem from payment group by staff_id having count(amount) > 7300) as r using(staff_id)

--Проверка
select staff.staff_id, ttl_amnt, prem
from staff
inner join (select staff_id, count(amount) as ttl_amnt, case when count(amount) > 7300 then 'Yes' else 'No' end as prem from payment group by staff_id) as r using(staff_id)


ЗАДАНИЕ 5
Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
В результирующую таблицу выведите:
    • название фильма;
    • рейтинг; 
    • жанр;
    • год выпуска;
    • язык;
    • количество раз, которое фильм брали в аренду;
    • общую стоимость аренды.
    
select film.title as film_name, film.rating as film_rating, genre_table.name as genre, 
film.release_year as release, language.name as lang, count(rental_count.rental_id) as rental_cnt, sum(rental_count.amount) as profit_sum
from film
inner join (select film_id, rental_id, amount from inventory inner join rental using(inventory_id) inner join payment using(rental_id)) as rental_count using(film_id)
inner join (select film_id, "name" from film_category inner join category using(category_id)) as genre_table using(film_id)
inner join language using(language_id)
group by film.title, film.rating, genre_table.name, film.release_year, language.name

ЗАДАЧА 6
Вывести все страны, в которых нет магазинов сети. 

select country.country
from country
inner join (select country_id, count(store_id) from city full join address using(city_id) full join store using(address_id) group by country_id having count(store_id) = 0) using(country_id)

--Расписан подзапрос
select city_id, count(store_id) 
from city 
full join address using(city_id) 
full join store using(address_id) 
group by city_id 
having count(store_id) = 0

--Проверка: страны, в которых есть магазины
select country.country
from country
inner join (select country_id, count(store_id) from city full join address using(city_id) full join store using(address_id) group by country_id having count(store_id) != 0) using(country_id)


ЗАДАЧА 7
Определить адрес магазина, в котором фильм «ACE GOLDFINGER» (film_id = 2) ни разу не брали в аренду. 

select address
from store
full join (select store_id, count(rental_id) as cnt_rental from film full join inventory using(film_id) inner join rental using(inventory_id) group by store_id, film_id having film_id = 2) using(store_id)
inner join address using(address_id)
where cnt_rental is null

-- Проверка
select store_id, address, cnt_rental
from store
full join (select store_id, count(rental_id) as cnt_rental from film full join inventory using(film_id) inner join rental using(inventory_id) group by store_id, film_id having film_id = 2) using(store_id)
inner join address using(address_id)
--where cnt_rental is null



