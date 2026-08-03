/*======================================================================================================================================================
                              TERRITORY ANALYSIS
=======================================================================================================================================================*/
select 
t.country,
round(sum(s.orderquantity*p.productprice),2) as revenue 
from products p 
join sales s 
on p.productkey=s.productkey 
join territories t 
on s.territorykey=t.salesterritorykey 
group by t.country 
order by revenue desc;
