CREATE TABLE Orders (
    ID INT PRIMARY KEY,                     -- Идентификатор (уникальный)
    Row_ID INT,                             -- Порядковый номер строки
    Order_ID VARCHAR(20),                   -- Идентификатор заказа
    Order_Date DATE,                        -- Дата заказа
    Ship_Date DATE,                         -- Дата отгрузки
    Ship_Mode VARCHAR(50),                  -- Режим доставки
    Customer_ID VARCHAR(20),                -- Идентификатор покупателя
    Customer_Name VARCHAR(100),             -- Имя покупателя
    Segment VARCHAR(50),                    -- Сегмент клиента
    Country VARCHAR(50),                    -- Страна
    City VARCHAR(50),                       -- Город
    City_Country VARCHAR(100),              -- Город, штат, страна
    State VARCHAR(50),                      -- Штат
    Postal_Code INT,                        -- Почтовый индекс
    Region VARCHAR(50),                     -- Регион
    Product_ID VARCHAR(20),                 -- Идентификатор продукта
    Category VARCHAR(50),                   -- Категория продукта
    Sub_Category VARCHAR(50),               -- Подкатегория продукта
    Product_Name TEXT,                      -- Название продукта
    Sales FLOAT,                            -- Продажи
    Quantity INT,                           -- Количество
    Discount FLOAT,                         -- Скидка
    Profit FLOAT,                           -- Прибыль
    Person VARCHAR(100),                    -- Ответственное лицо
    Returned VARCHAR(10),                   -- Возврат (Да/Нет)
    Sales_Target FLOAT                      -- Цель продаж
);
SELECT *FROM orders;
SELECT customer_name
FROM orders o
where customer_name like '_a%' and customer_name like '___d%';
SELECT
*
FROM orders
WHERE order_Date BETWEEN '2020-12-01' AND '2020-12-31'
order BY order_date ;
SELECT
    *
FROM
    orders
WHERE
    ship_mode NOT IN ('Standard Class', 'First Class')
    AND ship_date > '2020-11-30';
SELECT
*
FROM orders
WHERE profit<0;
SELECT
*
FROM orders
WHERE quantity < 3 OR profit = 0;
SELECT
*
FROM orders
WHERE category = 'Furniture'
order by sales desc
LIMIT 5;
UPDATE orders SET city = NULL WHERE
order_id IN ('CA-2020-161389' , 'US-2021-156909');
SELECT
*
FROM orders WHERE city IS NULL;
SELECT
category,
SUM(profit) AS profit,
MIN(order_date) AS first_order,
MAX(order_date) AS latest_order
FROM
orders
GROUP BY category;
SELECT
sub_category
FROM
orders
GROUP BY sub_category
HAVING AVG(profit) > MAX(profit) / 2;
SELECT
    category,
    COUNT(DISTINCT product_name) AS no_of_products
FROM
    orders
GROUP BY
    category;
SELECT
    sub_category,
    SUM(quantity) AS total_quantity
FROM
    orders
WHERE
    region = 'West'
GROUP BY
    sub_category
ORDER BY
    total_quantity DESC
LIMIT 5;
SELECT
region, SUM(sales) AS total_sales
FROM
orders
GROUP BY region;