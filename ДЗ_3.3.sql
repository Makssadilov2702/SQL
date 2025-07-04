--добавление наборов данных
--drop table salestarget;
create table salestarget(row_id int, Category varchar(30), Order_Date date, Segment varchar(30), Sales_Target int);
select * from salestarget;

--drop table returns;
create table returns (row_id int, Returned nchar(3), Order_ID varchar(30));
select * from returns;
--alter table returns drop column row_id;


--drop table people;
create table people (id_row int, person varchar(20), region varchar(15));
select  * from people;

select * from orders;

------------------------------------------с таблицей returns----------------------------------------------------
--1--вывести заказы, по которым был осуществлён возврат с указанием их состава (сегмент, категория товара и кол-во)
select o.order_id, o.customer_name, o.segment, o.category, o.sub_category, o.product_name, o.quantity
from orders o inner join returns r on r.order_id=o.order_id
order by o.segment;

--1a--вывести заказы, по которым был осуществлён возврат в разрезе сегмента 
select o.segment, sum(o.quantity) as count_return_segm
from orders o inner join returns r on r.order_id=o.order_id
group by o.segment
order by o.segment;

--1b--вывести заказы, по которым был осуществлён возврат в разрезе подкатегории товара 
select o.category, o.sub_category, sum(o.quantity) as count_return_subcat
from orders o inner join returns r on r.order_id=o.order_id
group by o.category, o.sub_category
order by o.category;

--1с--вывести заказы, по которым был осуществлён возврат в разрезе клиента
select o.customer_id, o.customer_name, sum(o.quantity) as count_return_cust
from orders o inner join returns r on r.order_id=o.order_id
group by o.customer_id, o.customer_name
order by o.customer_name;

--1d--вывести первых 10 клиентов, имеющих набольший возврат
select o.customer_id, o.customer_name, sum(o.quantity) as count_return_cust
from orders o inner join returns r on r.order_id=o.order_id
group by o.customer_id, o.customer_name
order by count_return_cust desc
limit 10;

------------------------------------------с таблицей people----------------------------------------------------
--2--Вывести данные для руководителя каждого региона по объёму продаж, средней выручке 
select o.region, p.person, to_char(sum(o.sales),'FM9999999.000') as sum_sales, round(avg(profit)::numeric,2) as avg_profit
--select o.region, p.person, sum(o.sales) as sum_sales, avg(profit) as avg_profit
from orders o inner join people p on p.region=o.region
group by o.region, p.person;


------------------------------------------с таблицей salestarget----------------------------------------------------
--Вывести данные по суммарной численности товаров за каждый день, отгруженных в период с мая 2018 г по август 2019г
select ship_date as ship_date, product_name, sum(quantity) as sum_quant
from orders where ship_date between '2018-05-01' and '2019-08-31'
group by ship_date, product_name
order by ship_date;

--3--Вывести данные по суммарной численности товара по каждому сегменту в 2020 году, в сравнении фактического и планируемого ежедневного объема продаж 
select s.order_date order_date, s.segment, sum(o.quantity) sum_quant, round(sum(o.sales)::numeric,3) fact_sales, sum(s.sales_target) target_sales 
from orders o inner join salestarget s on s.segment=o.segment
group by s.segment, s.order_date
having date_part('year',s.order_date)=2020
order by s.order_date;

--3a--Вычислить отклонения между ожидаемыми и реальными результатами ежедневного объёма продаж каждой категории товара в 2020 году 
select s.order_date order_date, s.category, round(sum(o.sales)::numeric,3) fact_sales, sum(s.sales_target) target_sales, 
round((sum(o.sales)-sum(s.sales_target))::numeric,2) as diff
from orders o inner join salestarget s on s.category=o.category
group by s.category, s.order_date
having date_part('year',s.order_date)=2020
order by s.order_date;

--3b--Вычислить отклонения между ожидаемыми и реальными результатами объёма продаж конкретной категории товара
select s.category, round(sum(o.sales)::numeric,3) fact_sales, sum(s.sales_target) target_sales, 
round((sum(o.sales)-sum(s.sales_target))::numeric,2) as diff
from orders o inner join salestarget s on s.category=o.category
where o.category='Technology'
group by s.category
order by fact_sales;

--3b--Вычислить фактический объём продаж конкретной категории товара с учётом возвратов
select r.order_id rord, o.order_id oord, s.category, sum(o.sales)
from returns r 
right join orders o on r.order_id=o.order_id 
join salestarget s on s.category=o.category
where r.order_id is null and s.category='Technology' 
group by rord, oord, s.category
order by s.category;

select * from returns where order_id='CA-2014-151995'
select * from orders where order_id='CA-2014-151995'


--все заказы
select category, sum(sales) sf
from orders --where category='Technology'
group by category;

--заказы без возврата
select o.category, sum(o.sales) sf
from returns r right join orders o on r.order_id=o.order_id 
where o.category='Technology' and r.order_id is null 
group by o.category;

--возвраты
select o.category, sum(o.sales)
from orders o inner join returns r on r.order_id=o.order_id
where o.category='Technology'
group by o.category;


-- union/ intersect/ exept -- объединение/ пересечение/ разность эквивалентые запросы
--пересечение
select o.* from orders o, returns r
intersect
select o.* from orders o, returns r where o.order_id is not null
intersect
select o.* from orders o where order_id in (select order_id from returns); --800стр

select * from orders o inner join returns r on r.order_id=o.order_id; --800стр
select * from orders o where o.order_id in (select order_id from returns); --800стр



--разность
select * from orders o  left join returns r on r.order_id=o.order_id 
where r.order_id is null; --9194стр

select * from orders o  
except
select * from orders o   where o.order_id in (select r.order_id from returns r); --9194стр

select order_date, product_name, quantity from orders;
--over()---
select order_date, product_name, quantity,
sum(quantity) OVER() as sum_quant
from orders;

--с определением разделения набора данных на окна по product_name
select order_date, product_name, quantity,
sum(quantity) OVER(partition by product_name) as sum_quant1
from orders;

-- с нарастающим итогом
select order_date, product_name, quantity,
sum(quantity) OVER(partition by order_date order by product_name) as sum_quant2
from orders;

-- строка или диапазон
select order_date, product_name, quantity,
sum(quantity) OVER(partition by order_date order by product_name rows between current row and 1 following) as sum_quant3
from orders;

--агрегатные функции
select order_date, product_name, quantity,
sum(quantity) OVER(partition by product_name) as sum_prod,
count(quantity) OVER(partition by product_name) as count_prod,
avg(quantity) OVER(partition by product_name) as avg_prod,
min(quantity) OVER(partition by product_name) as min_prod,
max(quantity) OVER(partition by product_name) as max_prod
from orders;

select order_date, product_name, quantity,
sum(quantity) OVER(agr_func) as sum_prod,
count(quantity) OVER(agr_func) as count_prod,
avg(quantity) OVER(agr_func) as avg_prod,
min(quantity) OVER(agr_func) as min_prod,
max(quantity) OVER(agr_func) as max_prod
from orders
window agr_func as (partition by order_date);

--ранжирующие функции
select order_date, product_name, quantity,
row_number() over(partition by order_date order by quantity) as row_number,
rank() over(partition by order_date order by quantity) as rank,
dense_rank() over(partition by order_date order by quantity) as dense_rank,
ntile(3) over(partition by order_date order by quantity) as ntile
from orders;


select order_date, product_name, quantity,
row_number() over(ord_qnt) as row_number,
rank() over(ord_qnt) as rank,
dense_rank() over(ord_qnt) as dense_rank,
ntile(3) over(ord_qnt) as ntile
from orders
window ord_qnt as (partition by order_date order by quantity);


--функции смещения
select order_date, product_name, quantity,
lag(quantity) over(partition by order_date order by order_date ) as lag,
lead(quantity) over(partition by order_date order by order_date ) as lead,
first_value(quantity) over(partition by order_date order by order_date ) as first_value,
last_value(quantity) over(partition by order_date order by order_date ) as last_value
from orders;

--аналитические функции
select order_date, product_name, quantity,
cume_dist() over(partition by order_date order by quantity) as cume_dist,
percent_rank() over(partition by order_date order by quantity) as percent_rank
from orders;

--select order_date, product_name percentile_cont(0.5) 
--within group (order by sales) over() as median_sales from orders;


SELECT order_date, product_id, 
-- Присваиваем ранг в зависимости от близости к дате 
DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date) as ranks, quantity
FROM orders;


SELECT order_date, product_id, 
-- Делим ранг определенной строки на сумму рангов по продукту
  CAST(DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date) AS FLOAT) / CAST(SUM(ranks) OVER(PARTITION BY product_id ) AS FLOAT) time_decay, quantity
FROM 
 	(SELECT order_date, product_id, 
	-- Присваиваем ранг в зависимости от близости к дате 
	DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date) as ranks, quantity
	FROM orders) rank_table

--распределение ценности по продуктам
WITH Ranks AS (
SELECT order_date, product_id, 
-- Делим ранг определенной строки на сумму рангов по продукту
  CAST(DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date) AS FLOAT) / CAST(SUM(ranks) OVER(PARTITION BY product_id ) AS FLOAT) time_decay, quantity
FROM 
 	(SELECT order_date, product_id, 
	-- Присваиваем ранг в зависимости от близости к дате 
	DENSE_RANK() OVER(PARTITION BY product_id ORDER BY order_date) as ranks, quantity
	FROM orders) rank_table
)
SELECT product_id, SUM(time_Decay) AS Val, SUM(quantity) AS quantity
FROM Ranks
GROUP BY product_id
ORDER BY Val DESC


SELECT distinct product_name from orders where product_id='TEC-PH-10004977'

select * from orders;

