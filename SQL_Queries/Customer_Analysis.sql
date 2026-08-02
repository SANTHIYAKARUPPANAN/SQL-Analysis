 /*==============================================================================================================
                     HOW LARGE IS THE CUSTOMER BASE?
================================================================================================================*/
select 
 count(distinct customerkey) as total_customers 
 from sales;
/*=============================================================================================================
                       WHO ARE OUR MOST VALUABLE CUSTOMERS?
================================================================================================================*/
 select 
 s.customerkey,
 round(sum(s.orderquantity*p.productprice),2) as total_spent
 from sales s 
 join products p 
 on p.productkey=s.productkey 
 group by s.customerkey 
 order by total_spent desc;
/*=============================================================================================================
                            WHICH CUSTOMER GENERATE THE LEAST REVENUE?
================================================================================================================*/
 select 
 s.customerkey,
 round(sum(s.orderquantity*p.productprice),2) as total_spent
 from sales s 
 join products p 
 on p.productkey=s.productkey 
 group by s.customerkey 
 order by total_spent asc limit 10;
/*===============================================================================================================
                               WHICH CUSTOMERS HAVE PLACED THE HIGHEST NUMBER OF ORDERS?
==================================================================================================================*/
select 
customerkey,
count(distinct ordernumber) as order_count
from sales  
group by customerkey 
order by order_count desc limit 10;
 /*=================================================================================================================
                WHICH CUSTOMERS HAVE BOUGHT THE HIGHEST NUMBER OF ORDERS
====================================================================================================================*/
select 
customerkey,
sum(orderquantity) as quantity_count  
from sales 
group by customerkey 
order by quantity_count desc limit 10;
/*==================================================================================================================
                    WHO ARE THE REPEAT CUSTOMERS?
====================================================================================================================*/
select 
customerkey,
count(distinct ordernumber) as order_count 
from sales 
group by customerkey
 having count(distinct ordernumber)>1 
 order by order_count desc limit 20;
/*===================================================================================================================
                      CATEGORIZE CUSTOMER BASED ON NUMBER OF VISITS
======================================================================================================================*/
with customer_category as 
(select 
customerkey,
count(distinct ordernumber) as order_count 
from sales 
group by customerkey )
select 
sum(case when order_count>1 then 1 else 0 end) as repeat_customers,
sum(case when order_count<=1 then 1 else 0 end)as singlevisit_customers 
from customer_category;
/*======================================================================================================================
                       AVERAGE ORDER VALUE OF EACH CUSTOMER(AOV)
========================================================================================================================*/
select
 s.customerkey,
 count(distinct s.ordernumber) as ordercount,
 round((sum(s.orderquantity*p.productprice)/count(distinct s.ordernumber)),2)  as aov 
 from sales s join products p 
 on s.productkey=p.productkey 
 group by s.customerkey 
 order by aov desc;
/*========================================================================================================================
                              TOP 10% CUSTOMERS BY REVENUE
==========================================================================================================================*/
CREATE VIEW customerrevenue AS
SELECT
s.CustomerKey,
ROUND(SUM(s.OrderQuantity * p.ProductPrice), 2) AS TotalRevenue,
COUNT(DISTINCT s.OrderNumber) AS TotalOrders,
ROUND(SUM(s.OrderQuantity * p.ProductPrice) /COUNT(DISTINCT s.OrderNumber),2) AS AOV
FROM sales s JOIN products p
ON s.ProductKey = p.ProductKey
GROUP BY s.CustomerKey order by totalrevenue desc;
select customerkey,round(totalrevenue,2) as revenue,ntile(10) over(order by totalrevenue desc) as top_clusters from customerrevenue ;
/*========================================================================================================================
     WHAT % OF TOTAL REVENUE IS CONTRIBUTED BY TOP 10% OF CUSTOMERS
==========================================================================================================================*/
with ntile_revenue as 
(select customerkey,
round(totalrevenue,2) as revenue,
ntile(10) over(order by totalrevenue desc) as top_clusters 
from customerrevenue)
select 
round((sum(revenue)/(select sum(revenue) from ntile_revenue))*100.0,2) as top10revenue 
from ntile_revenue 
where top_clusters=1 
group by top_clusters ;   
/*==========================================================================================================================
                          HOW MANY CUSTOMERS ARE ACTUALLY NEEDED TO GENERATE 80% OF REVENUE
                                             (PARETO ANALYSIS)
============================================================================================================================*/
 with cummulative_revenue as 
 (select customerkey,totalrevenue,
 sum(totalrevenue) over(order by totalrevenue desc) 
 as cummulative_revenue,
 round((sum(totalrevenue) over(order by  totalrevenue desc)/(select sum(totalrevenue) from customerrevenue))*100.0,2)
 as cummulative_percentage
 from customerrevenue)
 select 
 round((count(customerkey)/(select count(distinct customerkey) from sales))*100.0,2) as valuablecustomers 
 from cummulative_revenue
 where cummulative_percentage<=80;
/*============================================================================================================================================
                    WHEN DID EACH CUSTOMER LAST PURCHASE?
==============================================================================================================================================*/
with recentorder_date as(
select
 max(orderdate) as recent_order from sales),
recency as 
(select 
customerkey,
datediff((select recent_order from recentorder_date),max(orderdate)) as recency 
from sales  
group by customerkey 
order by recency desc)
select
 customerkey,
 recency,
 (case 
 when recency<=30 then 'Active' 
 when recency>30 and recency<=90 then 'Warm'
 when recency>90 and recency<=180 then 'Needs Attention' 
 else 'At Risk' end)as CustomerStatus 
 from recency;
/*=============================================================================================================================================
                                                CUSTOMER LIFETIME VALUE(LTV)
================================================================================================================================================*/
select 
s.customerkey,
round(sum(s.orderquantity*p.productprice),2) as ltv ,
count(distinct s.ordernumber) as ordercount
from sales s join products p 
on s.productkey=p.productkey 
group by s.customerkey 
order by ltv desc limit 15;
