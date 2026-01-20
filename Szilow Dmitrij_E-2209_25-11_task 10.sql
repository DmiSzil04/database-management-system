ЗАДАНИЕ №1
Выведите таблицу с тремя полями: название
фильма, имя актера и количество фильмов,
в которых он снимался

select concat(first_name, ' ', last_name) as actor_name, title, count(title) over(partition by actor_id)
from film
join film_actor using(film_id)
join actor using(actor_id)
group by actor_id, title


ЗАДАНИЕ №2
С помощью оконной функции выведите для каждого клиента фильм, который он берет в аренду и предыдущий арендованный фильм. 

with film_inv as
(select inventory_id, title
from film
join inventory using(film_id))
select customer_id, title as current, lag(title) over(partition by customer_id) as previous
from rental
join film_inv using(inventory_id)


ЗАДАНИЕ №3
С помощью оконной функции для каждого покупателя выведите информацию о его последней оплате аренды: дату аренды и стоимость аренды.


select distinct customer_id, 
last_value(payment_date) over(partition by customer_id) as last_payment_date, 
last_value(amount) over(partition by customer_id) as last_payment_amount
from payment
order by customer_id

ЗАДАНИЕ №4
С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
с сортировкой по дате.

select distinct staff_id, date_trunc('day', payment_date), sum(amount) over(partition by staff_id order by payment_date::date)
from payment
where payment_date::date > '2005-07-31' and payment_date::date <= '2005-08-31'