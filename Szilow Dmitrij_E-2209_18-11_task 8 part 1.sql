--ЗАДАЧА 2
--С помощью SQL-запроса выведите адреса тех магазинов, у которых более 300 покупателей. 
--Добавьте в запрос информацию о городе магазина, а также фамилию и имя продавца, который работает в этом магазине.

with temp_table as 
(select store_id, count(customer_id) as dist_cust, store.address_id
from store
inner join customer using(store_id)
group by store_id
having count(customer_id) > 300),
temp_city as
(select address_id, city.city, address.address 
from address
inner join city using(city_id)
)
select city, address, dist_cust, first_name || ' ' || last_name as full_name
from temp_table
inner join temp_city using(address_id)
inner join staff using(store_id)

--ЗАДАЧА 3
--Используя подзапросы, выведите ТОП-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов 
--Выведите фамилию и имя покупателя и количество фильмов, которые они взяли в аренду.

with temp_table as
(select customer_id, count(rental_id) as count_films 
from rental 
group by customer_id 
order by count(rental_id) 
limit 5
)
select first_name || ' ' || last_name as customer_name, count_films
from customer
inner join temp_table using(customer_id)

--ЗАДАЧА 4
--Посчитайте количество продавцов, получивших премию: если количество продаж, выполненных каждым продавцом, превышает 7300, то он получает премию.

with temp_table as 
(select staff_id, count(amount) as ttl_amnt, case when count(amount) > 7300 then 'Yes' else 'No' end as prem 
from payment 
group by staff_id 
having count(amount) > 7300)
select count(staff.staff_id)
from staff
inner join temp_table using(staff_id)

--ЗАДАНИЕ 5
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
--В результирующую таблицу выведите:
--    • название фильма;
--    • рейтинг; 
--    • жанр;
--    • год выпуска;
--    • язык;
--    • количество раз, которое фильм брали в аренду;
--    • общую стоимость аренды.
    
with temp_rental_count as 
(select film_id, count(rental_id) as rental_cnt, sum(amount) as profit
from inventory 
inner join rental using(inventory_id) 
inner join payment using(rental_id)
group by film_id),
temp_genre as 
(select film_id, "name" as genre
from film_category 
inner join category using(category_id))
select title as film_name, rating as film_rating, genre, 
release_year as release, language.name as lang, rental_cnt as rental_cnt, profit
from film
inner join temp_rental_count using(film_id)
inner join temp_genre using(film_id)
inner join language using(language_id)


--ЗАДАЧА 6
--Вывести все страны, в которых нет магазинов сети. 

with temp_country as 
(select country_id, count(store_id) 
from city 
full join address using(city_id) 
full join store using(address_id) 
group by country_id 
having count(store_id) = 0)
select country.country
from country
inner join temp_country using(country_id)


--ЗАДАЧА 7
--Определить адрес магазина, в котором фильм «ACE GOLDFINGER» (film_id = 2) ни разу не брали в аренду. 

with temp_norental as 
(select store_id, count(rental_id) as cnt_rental 
from film 
full join inventory using(film_id) 
inner join rental using(inventory_id) 
group by store_id, film_id 
having film_id = 2)
select address
from store
full join temp_norental using(store_id)
inner join address using(address_id)
where cnt_rental is null
