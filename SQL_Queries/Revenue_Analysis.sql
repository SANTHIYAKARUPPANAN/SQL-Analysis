/*==============================================================================================
                                TOTAL REVENUE
=================================================================================================*/
select 
round(sum(s.OrderQuantity*p.ProductPrice),2) 
as total_revenue 
from sales s join products p 
on s.ProductKey=p.ProductKey ;
/*===============================================================================================
                               TOTAL ORDER COUNT
=================================================================================================*/
select 
count(distinct ordernumber) as orders 
from sales ;
/*===============================================================================================
                        AVERAGE ORDER VALUE(AOV)
===============================================================================================*/
select 
s.CustomerKey,
round((sum(p.productprice*s.orderquantity)/count(distinct s.ordernumber)),2) as aov 
from sales s join products p 
on s.productKey=p.productkey 
group by s.customerkey;
/*===============================================================================================
                                       MONTH WISE REVENUE
================================================================================================*/
select 
year(s.orderdate) as year,
month(s.orderdate) as month,
monthname(s.orderdate) as monthname,
round(sum(s.orderquantity*p.productprice),2) as revenue 
from sales s join products p 
on p.productkey=s.productkey 
group by year(s.orderdate),month(s.orderdate),monthname(s.orderdate) 
order by year,month asc;
/*===============================================================================================
                                      YEAR WISE REVENUE
=================================================================================================*/
select 
year(s.orderdate) as year,
round(sum(s.orderquantity*p.productprice),2) as revenue 
from sales s join products p 
on s.productkey=p.productkey 
group by year(s.orderdate) 
order by year asc;
/*===================================================================================================
								QUARTER WISE REVNUE
=====================================================================================================*/
select
 year(s.orderdate) as year,
 quarter(s.orderdate) as quarter ,
 round(sum(s.orderquantity*p.productprice),2) as revenue 
 from sales s join products p 
 on s.productkey=p.productkey 
 group by year(s.orderdate),quarter(s.orderdate) 
 order by year,quarter asc;

