/*====================================================================================================
                                REVENUE BY PRODUCT CATEGORY
======================================================================================================*/
 select 
 pc.CategoryName,
 round(sum(p.productprice*s.orderquantity),2) as revenue 
 from sales s join products p 
 on p.productkey=s.productkey 
 join product_subcategories psc 
 on psc.ProductSubcategoryKey=p.ProductSubcategoryKey 
 join product_categories pc 
 on pc.ProductCategoryKey=psc.ProductCategoryKey
 group by pc.CategoryName
 order by revenue desc;
/*===================================================================================================
                   WHICH PRODUCT SUBCATEGORY MAKES THE HIGHER REVENUE
======================================================================================================*/
 select
 psc.subcategoryname,
 round(sum(p.productprice*s.orderquantity),2) as revenue 
 from sales s join products p 
 on s.productkey=p.productkey 
 join product_subcategories psc 
 on psc.ProductSubcategoryKey=p.ProductSubcategoryKey 
 group by psc.SubcategoryName 
 order by revenue desc;
/*=======================================================================================================
              WHICH PRODUCTS GENERATE THE LEAST REVENUE
=========================================================================================================*/
 select 
 p.productname,
 round(sum(p.productprice*s.orderquantity),2) as revenue 
 from sales s join products p 
 on s.productkey=p.productkey 
 group by p.productname 
 order by revenue asc limit 10;
/*========================================================================================================
                          PRODUCT REVENUE CONTRIBUTION(%)
===========================================================================================================*/
 with categorywise_revenue as 
 (select pc.categoryname,round(sum(p.productprice*s.OrderQuantity),2) as revenue
 from sales s join products p 
 on p.productkey=s.productkey 
 join product_subcategories psc 
 on psc.ProductSubcategoryKey=p.ProductSubcategoryKey 
 join product_categories pc 
 on pc.ProductCategoryKey=psc.ProductCategoryKey 
 group by pc.categoryname)
 select 
 categoryname,
 round((revenue/(select sum(p.productprice*s.orderquantity) 
 from sales s 
 join products p 
 on s.productkey=p.productkey))*100,2) as product_contribution
 from categorywise_revenue 
 order by product_contribution desc;
/*=========================================================================================================
      WHICH PRODUCT  SUBCATEGORIES CONTRIBUT THE MOST TO TOATL REVENUE
============================================================================================================*/
 with subcategory_wiserevenue as 
 (select psc.subcategoryname,sum(s.orderquantity*p.productprice) as revenue 
 from sales s 
 join products p
 on s.productkey=p.productkey 
 join product_subcategories psc 
 on p.ProductSubcategoryKey=psc.ProductSubcategoryKey
 group by psc.SubcategoryName)
 select 
 subcategoryname,
 round((revenue/(select sum(s.orderquantity*p.productprice)
 from sales s 
 join products p 
 on s.productkey=p.ProductKey))*100,2) as 
 subcategory_contribution
 from subcategory_wiserevenue 
 group by subcategoryname 
 order by subcategory_contribution desc;



