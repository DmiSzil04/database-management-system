--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате платежа
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате платежа

select customer_id, payment_id, payment_date, row_number() over(order by customer_id, payment_date) as gen_num, row_number() over(partition by customer_id order by payment_date) as cust_num
from payment
order by customer_id

--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по размеру платежа от наименьшей к большей

select customer_id, payment_date, amount, sum(amount) over(partition by customer_id order by payment_date) as date_cumul
from payment

select customer_id, payment_date, amount, sum(amount) over(partition by customer_id order by customer_id, amount) as amount_cumul
from payment

--Пронумеруйте платежи для каждого покупателя по размеру платежа от наибольшего к
--меньшему так, чтобы платежи с одинаковым значением имели одинаковое значение номера.

select customer_id, payment_date, amount, dense_rank() over(partition by customer_id order by customer_id, amount) as nmb, sum(amount) over(partition by customer_id order by customer_id, amount) as amount_cumul
from payment

--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.



--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате платежа.

select customer_id, amount, lag(amount, 1, 0) over(partition by customer_id order by payment_date)
from payment
order by customer_id

--ЗАДАНИЕ №3
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку

with date_group as (
select payment_date, customer_id, amount
from payment
where payment_date::date = '2005-08-20'
order by payment_date
),
numerate as (
select *, row_number() over() as cust_num
from date_group
)
select *
from numerate
where cust_num % 100 = 0

--ЗАДАНИЕ №4
--Для каждой страны определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
-- 1. покупатель, арендовавший наибольшее количество фильмов
-- 2. покупатель, арендовавший фильмов на самую большую сумму
-- 3. покупатель, который последним арендовал фильм

with raise_country as (
select customer_id, country_id, concat(first_name, ' ', last_name) as full_name, country
from customer
inner join address using(address_id)
inner join city using(city_id)
inner join country using(country_id)),
sum_amount as (
select distinct customer_id, sum(amount) over(partition by customer_id order by payment_date) as ttl
from payment),
count_films as (
select customer_id, count(inventory_id) as cnt
from rental
group by customer_id
)
select distinct country_id, country, 
first_value(full_name) over(partition by country_id order by rental_date desc) as lv, 
first_value(full_name) over(partition by country_id order by ttl desc) as max_amount, 
first_value(full_name) over(partition by country_id order by cnt desc) as max_count
from rental
inner join raise_country using(customer_id)
inner join sum_amount using(customer_id)
inner join count_films using(customer_id)


--ЗАДАНИЕ №5
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.

select customer_id, payment_date, amount as current, 
lead(amount) over(partition by customer_id order by payment_date) as next, 
amount - lead(amount) over(partition by customer_id order by payment_date) as delt
from payment
