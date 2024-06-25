create database if not exists salesdatawalmart;
CREATE TABLE IF NOT EXISTS walmart_sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_percentage FLOAT,
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT
);
use salesdatawalmart;
select * from walmart_sales;

-- features engineering

SELECT 
    time,
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END AS time_of_day
FROM walmart_sales;

alter table walmart_sales add column time_of_day varchar(30);

update walmart_sales 
set time_of_day=( CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END 
    );
-- day_name 
select date,
dayname(date) as day_name
from walmart_sales;

alter table walmart_sales add days_name varchar(10);

 update walmart_sales set days_name= dayname(date);
 
-- month_name
select date,monthname(date) from walmart_sales;
alter table walmart_sales add column month_name varchar(10);
update walmart_sales set month_name= monthname(date) ;

-- generic quetions ---
select * from walmart_sales;

-- How many unique cities does the data have?
select distinct city from walmart_sales;

-- In which city is each branch?
select distinct city,branch from walmart_sales;

-- product quetions --
select * from walmart_sales;

-- How many unique product lines does the data have?
select count(distinct product_line) from walmart_sales;

-- What is the most common payment method?
select payment_method,count(payment_method) as cnt from walmart_sales
group by payment_method order by cnt desc;

-- What is the most selling product line?
select product_line,count(product_line) as cnt from walmart_sales
group by product_line order by cnt desc;

-- what is the total revenue by month?
select month_name , sum(quantity * unit_price) as revenue from walmart_sales
group by month_name order by revenue desc;

-- What month had the largest COGS?
select month_name as month ,sum(cogs) as cogs from walmart_sales
group by month order by cogs desc;

-- What product line had the largest revenue?
select product_line as product , sum(total) as revenue from walmart_sales
group by product order by revenue limit 5;

-- What is the city with the largest revenue?
select branch,city , sum(total) as revenue  from walmart_sales
group by branch,city order by revenue desc;

-- What product line had the largest VAT?
select product_line, avg(vat) as avg_tax from walmart_sales
group by product_line order by avg_tax desc;

-- Which branch sold more products than average product sold?
select branch,sum(quantity) as qty from walmart_sales 
group by branch 
having sum(quantity) > ( Select avg(quantity) from walmart_sales);

-- What is the most common product line by gender?
select gender,product_line,count(product_line) as cnt from walmart_sales
group by gender,product_line 
order by cnt desc;

-- What is the average rating of each product line?
select product_line,avg(rating) as avg_rating from walmart_sales
group by product_line 
order by avg_rating desc;

-- sales---
use salesdatawalmart;
select * from walmart_sales;

-- Number of sales made in each time of the day per weekday
select time_of_day , count(*) as total_sales from walmart_sales 
where days_name = 'sunday'
group by time_of_day order by total_sales desc;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as revenue from walmart_sales
group by customer_type order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,avg(vat) as vat from walmart_sales
group by city order by vat desc;

-- Which customer type pays the most in VAT?
select customer_type,avg(vat) as vat from walmart_sales
group by customer_type order by vat desc;

-- customers--
select * from walmart_sales;
-- How many unique customer types does the data have?
select distinct customer_type from walmart_sales;

-- How many unique payment methods does the data have?
select distinct payment_method from walmart_sales;

-- Which customer type buys the most?
select customer_type,count(*) as cstm_cnt from walmart_sales
group by customer_type order by cstm_cnt desc;

-- What is the gender of most of the customers?
select gender,count(*) as gn from walmart_sales
group by gender order by gn desc;

-- What is the gender distribution per branch?
select gender,count(*) as gn from walmart_sales
where branch = "A"
group by gender order by gn desc;

-- Which time of the day do customers give most ratings?
select time_of_day , avg(rating) as avg_rating from walmart_sales 
group by time_of_day order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch?
select time_of_day , avg(rating) as avg_rating from walmart_sales 
where branch = "A"
group by time_of_day order by avg_rating desc;

-- Which day fo the week has the best avg ratings?
select days_name, avg(rating) as avg_rating from walmart_sales 
group by days_name order by avg_rating desc;



