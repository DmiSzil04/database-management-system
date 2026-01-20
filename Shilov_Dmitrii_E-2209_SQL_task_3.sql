--======== СОРТИРОВКА ==============
-- ЗАДАНИЕ №1
-- Выбрать все заказы, отсортировать по идентификатору сотрудника и отсортировать по дате возврата. 

select staff_id, return_date, customer_id, rental_id, rental_date
from rental
order by staff_id, return_date

-- ЗАДАНИЕ №2
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.

select *
from payment p 
order by payment_date desc
limit 10

-- ЗАДАНИЕ №3
-- Получите информацию о трёх фильмах с самым длинным описанием фильма.

select *
from film
order by length(description) desc
limit 3

-- ЗАДАНИЕ №4 
-- Получить первую аренду каждого пользователя 

select customer_id, min(rental_date::date) as first_rental
from rental
group by customer_id
order by min(rental_date::date)

-- ЗАДАНИЕ №5
-- Вывести минимальную и максимальную дату возвращения аренды в двух отдельных запросах

select min(return_date::date)
from rental

select max(return_date::date)
from rental

-- ЗАДАНИЕ №6
-- Вывести все платежи, которые были осуществлены в феврале 

select payment_id, payment_date
from payment
where extract(month from payment_date) = 2


-- ЗАДАНИЕ №7
-- Вывести топ 5 пользователей с самым коротким именем почтового ящика (часть до домена)
-- Вывести топ 5 пользователей, пропустив первые 10 

select initcap(first_name) || ' ' || initcap(last_name) as Имя_Фамилия, initcap(split_part(email::text, '@'::text, 1)) as Имя_Ящика, length(initcap(split_part(email::text, '@'::text, 1))) as Длина_Ящика
from customer
order by length(initcap(split_part(email::text, '@'::text, 1))) desc
limit 5

-- ЗАДАНИЕ №8
-- Какие покупатели и когда совершили первые 15 платежей в таблице payment 

select c.customer_id, initcap(c.first_name) || ' ' || initcap(c.last_name) as Имя_Фамилия, p.payment_date
from payment as p
inner join customer as c on p.customer_id = c.customer_id
order by p.payment_date
limit 15

-- ФИЛЬТРАЦИЯ 5 --

-- ЗАДАНИЕ №1
-- Вывести все платежи, которые были осуществлены в феврале

select payment_id, payment_date
from payment
where payment_date::date between '2006-02-01' and '2006-03-01'

-- ЗАДАНИЕ №2
--Получить информацию по покупателям с именем, содержащим подстроку 'jam' (независимо от регистра написания),
--в виде: "имя фамилия" - одной строкой.

select initcap(first_name) || ' ' || initcap(last_name) as Имя_Фамилия
from customer
where lower(first_name) like '%jam%'
order by first_name


-- ЗАДАНИЕ №3
--Выведите уникальные названия городов из таблицы городов, которые 
-- начинаются на “L” и заканчиваются на “a”, и не содержат пробелов.

select city
from city
where city like 'L%a' and city not like '% %'

-- ЗАДАНИЕ №4
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.

select payment_id, amount, payment_date
from payment
where payment_date between '2005-06-17 00:00:00' and '2005-06-19 23:59:59' and amount > 1.0
order by payment_date

-- ЗАДАНИЕ №5
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.

select lower(first_name) || ' ' || lower(last_name) as Имя_Фамилия
from customer
where activebool and (first_name ilike 'Kelly' or first_name ilike 'Willie')
order by first_name, last_name


-- ЗАДАНИЕ №6
--Выведите информацию о фильмах, у которых рейтинг “R” и стоимость аренды указана от 
--0.00 до 3.00 включительно, а также фильмы c рейтингом “PG-13” и стоимостью аренды больше или равной 4.00.

select title, description, rating, rental_rate, rental_duration, length
from film
where (rating::text ilike 'R' and rental_rate between 0 and 3) or (rating::text ilike 'PG-13' and rental_rate >= 4)


-- ЗАДАНИЕ №7
-- a) Выведите записи об аренде, в которых покупатели не вернули взятый в аренду фильм. 
-- - Использовать конструкцию IS NULL

select c.customer_id, initcap(c.first_name) || ' ' || initcap(c.last_name) as Имя_Фамилия, r.rental_id, r.rental_date
from rental as r
inner join customer as c on r.customer_id = c.customer_id
where r.return_date is null
order by c.first_name, c.last_name

-- б) Посчитайте количество записей об аренде аренды, в которых указана дата возврата. 

select count(rental_id)
from rental
where return_date is not null


-- ЗАДАНИЕ №8 
-- Вывести те записи об аренде, для которых длительность аренды составляет боле 5 дней. 

select rental_id, customer_id, rental_date, return_date
from rental
where extract(days from age(return_date, rental_date)) >= 5
order by extract(days from age(return_date, rental_date)) desc