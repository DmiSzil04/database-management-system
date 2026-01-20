-- ЗАДАНИЕ №1
-- Посчитайте количество покупателей, присоединившихся в каждом месяце 

--select payment_date
--from payment
--order by payment_date

select date_trunc('month', payment_date), count(customer_id)
from payment
group by date_trunc('month', payment_date)
order by date_trunc('month', payment_date) desc

-- ЗАДАНИЕ №2
-- Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество платежей, которые он совершил
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select customer_id, count(rental_id) as cnt, sum(amount) as ttl, min(amount) as minim, max(amount) as maxim
from payment 
group by customer_id
order by customer_id

-- ЗАДАНИЕ №3
-- Выведите одним запросом информацию о том, сколько: 
-- фильмов на определенном языке заданного стоимости аренды есть в магазине,
-- фильмов на определенном языке есть в магазине,
-- фильмов с заданной стоимостью аренды есть в магазине,
-- при этом учитывать только фильмы, рейтинг которых включает значение PG. 



select language_id, rental_rate, count(film_id)
from film
where rating::text like '%PG%'
group by language_id, rental_rate
order by language_id, rental_rate


-- ЗАДАНИЕ №4
-- Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
-- Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".

select staff_id, count(rental_id), case when count(rental_id) > 7300 then 'YES' else 'NO' end as prem
from payment
group by staff_id
order by staff_id


-- ЗАДАНИЕ №5
-- Посчитать сколько есть повторов фамилий. 
-- Оставить только те фамилии, для которых есть однофамильцы. 
-- Вывести имена актеров для каждой фамилии.

select last_name, count(last_name), string_agg(distinct first_name, ', ' order by first_name) as names
from actor
group by last_name
having count(last_name) > 1
order by last_name


-- Например, с фамилией ALLEN есть 3 актера: Cuba Allen, Kim Allen, Meril Allen. 
-- Для имени ALLEN второй столбец должен быть {Cuba, Kim, Meril}
-- В первом столбце -- уникальные фамилии. 
