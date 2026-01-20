--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

select title, special_features
from film
where special_features @> array['Behind the Scenes']

--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select title, special_features
from film
where 'Behind the Scenes' = any(special_features)

select title, special_features
from film
where special_features && array['Behind the Scenes']

--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

with select_film as (
select film_id, inventory_id, title, special_features
from film
inner join inventory using(film_id)
where special_features @> array['Behind the Scenes']
)
select distinct customer_id, count(inventory_id) over(partition by customer_id order by customer_id) as film_count
from rental
inner join select_film using(inventory_id)
order by customer_id

--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.


select distinct customer_id, count(inventory_id) over(partition by customer_id order by customer_id) as film_count
from rental
where inventory_id in (
select inventory_id
from film
inner join inventory using(film_id)
where special_features @> array['Behind the Scenes'])
order by customer_id

--ЗАДАНИЕ №5
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания: 
--поиск значения в массиве затрачивает меньше ресурсов системы;
--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.

explain analyze 
with select_film as (
select film_id, inventory_id, title, special_features
from film
inner join inventory using(film_id)
where special_features @> array['Behind the Scenes']
)
select distinct customer_id, count(inventory_id) over(partition by customer_id order by customer_id) as film_count
from rental
inner join select_film using(inventory_id)
order by customer_id

explain analyze
select distinct customer_id, count(inventory_id) over(partition by customer_id order by customer_id) as film_count
from rental
where inventory_id in (
select inventory_id
from film
inner join inventory using(film_id)
where special_features @> array['Behind the Scenes'])
order by customer_id

--Запрос из задаиня 4 выполняется быстрее запроса из задания 3

--ЗАДАНИЕ №6
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.

select distinct staff_id, first_value(rental_id) over(partition by staff_id) as rent_id, 
first_value(rental_date::date) over(partition by staff_id) as data, 
first_value(inventory_id) over(partition by staff_id) as inv_id
from rental


--ЗАДАНИЕ №7

--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день

(select distinct rental_date::date, count(rental_id) over(partition by rental_date::date) as cnt
from rental
order by cnt desc
limit 1)
union
(select distinct payment_date::date, sum(amount) over(partition by payment_date::date) as sm
from payment
order by sm
limit 1)

