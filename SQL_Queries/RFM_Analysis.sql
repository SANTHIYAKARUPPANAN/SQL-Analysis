/*=================================================================================================================================================
                                           RECENCY,FREQUENCY AND MONETARY(RFM)
===================================================================================================================================================*/
with rfm as(select 
s.customerkey,
((select max(orderdate) from sales )-max(s.orderdate)) as recency,
count(distinct s.ordernumber) as frequency,
round(sum(s.orderquantity*p.productprice),2) as monetary 
from sales s join products p 
on s.productkey=p.productkey 
group by s.customerkey order by recency asc,frequency desc,monetary desc),
score as(select 
customerkey,
ntile(5) over(order by recency desc) as recency_score,
ntile(5) over(order by frequency desc) as frequency_score,
ntile(5) over(order by monetary desc) as monetary_score 
from rfm)
select customerkey,CONCAT(recency_score, frequency_score, monetary_score) AS rfm_score from score;
