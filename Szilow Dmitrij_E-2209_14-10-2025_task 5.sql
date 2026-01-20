--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select initcap(c.first_name) || ' ' || initcap(c.last_name) as name_surname, ct.city as city, cn.country as country, a.address as main_address, a.address2 as second_address
from customer as c
inner join address as a using(address_id)
inner join city as ct using(city_id)
inner join country as cn using(country_id)
--where ct.city = 'Pskov'
order by name_surname


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select s.store_id, count(c.customer_id)
from store as s
inner join customer as c on c.store_id = s.store_id
group by s.store_id


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select s.store_id, count(c.customer_id)
from store as s
inner join customer as c on c.store_id = s.store_id
group by s.store_id
having count(c.customer_id) > 300


--ЗАДАНИЕ №3
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и 
--дате возврата (поле return_date), вычислите для каждого покупателя среднее количество 
--дней, за которые он возвращает фильмы. В результате должны быть дробные значения, а не интервал.

select initcap(c.first_name) || ' ' || initcap(c.last_name) as name_surname, round(avg(extract(day from age(return_date::date, rental_date::date))), 2) as ret_per
from rental as r
inner join customer as c using(customer_id)
group by initcap(c.first_name) || ' ' || initcap(c.last_name)

--ЗАДАНИЕ №4
-- Выведите список категорий фильмов, средняя продолжительность аренды которых более 5 дней

select c."name", round(avg(extract(day from age(return_date::date, rental_date::date))), 2) as ret_per
from rental as r
inner join inventory as i using(inventory_id)
inner join film as f using(film_id)
inner join film_category as fc using(film_id)
inner join category as c using(category_id)
group by c."name"
having avg(extract(day from age(return_date::date, rental_date::date))) > 5
order by c."name"

-- ЗАДАНИЕ №5
-- Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select f.title, count(rental_date) as rent_num, sum(amount) as paym_tot
from rental as r
inner join inventory as i on i.inventory_id = r.inventory_id
inner join film as f on f.film_id = i.film_id
inner join payment as p on p.rental_id = r.rental_id
group by f.title
order by f.title