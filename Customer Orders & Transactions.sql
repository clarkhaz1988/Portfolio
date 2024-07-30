use portfolio2
;

select*
from customers
;

Select *
from transactions
;

-- 1. Lowest order count
select count(*),state
from customers
group by state
order by order_count asc
;

-- 2. Highest order count
select state,count(state)
from customers
group by state
order by count(state)desc
limit 10
;

 -- 3. Most popular shipment method by state
 
 With shipmoderank as(
 select State, count(shipmode), shipmode,
 dense_rank() over (partition by state order by count(shipmode)desc)as shipmoderank
 From customers
 group by state, shipmode
 order by state asc)

 Select state, shipmode,shipmoderank
 From shipmoderank
 Where shipmoderank = 1
 ;
 
-- 4. Number of orders by Region
Select region,count(Region)as order_count
From customers
group by region
order by order_count desc
;

-- 5. average profit per state
select c.state, avg(t.profit)
From customers as c join transactions as t on c.rowid= t.rowid
where profit > 0.00
group by c.state
order by avg(t.profit) desc
;

-- 6. average profit by region
select c.region, avg(t.profit)
From customers as c join transactions as t on c.rowid= t.rowid
where t.profit > 0.00
group by c.region
order by avg(t.profit) desc
;

-- 7. items with negative profit 
select t.profit as negative_profit,t.subcategory,t.category,productname
From customers as c join transactions as t on c.rowid= t.rowid
where t.profit < 0.00
order by negative_profit asc
limit 10
;


-- 8. items with profit
select t.profit as _profit,t.subcategory,t.category,productname
From customers as c join transactions as t on c.rowid= t.rowid
where t.profit > 0.00
order by _profit desc
;

-- 9. percentage of products with negative pofit
select 
(select count(profit) as negative_profit
From customers as c join transactions as t on c.rowid= t.rowid
where t.profit < 0.00
)
/
(select count(profit)
From transactions
)*100 as neg_profit
;

-- 10. percentage of products that make profit
select 
(select count(profit) as_profit
From customers as c join transactions as t on c.rowid= t.rowid
where t.profit >0.00
)
/
(select count(profit)
From transactions
)*100 as pos_profit
;

-- 11. Total profit

Select sum(profit)
From transactions
;

-- 12. Profit by year
select t.profit as _profit,t.subcategory,t.category,year(c.orderdate)
From customers as c join transactions as t on c.rowid= t.rowid
;

 -- 13. profit margin
 
 select Category, productname,round(profit/sales,1)*100 as profit_margin
 from transactions
 ;