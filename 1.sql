//cau 1 & 2
select c.customerName, c.customerNumber, (select datediff('2005-06-02',max(orderDate))
from orders where customerNumber = c.customerNumber) as recency,
(select count(*) from orders where customerNumber = c.customerNumber) as frequency,
(select sum(quantityOrdered*priceEach) from orderdetails 
where orderNumber in (select orderNumber
from orders where customerNumber = c.customerNumber)) as monetary
from customers c
group by c.customerNumber
having (recency <= 5 and frequency >=5) or monetary >= 500000

//cau 3
select pl.productLine, pl.textDescription, (select sum(quantityInStock +(select sum(quantityOrdered)
from orderdetails where productCode = p.productCode))
from products p where p.productLine =pl.productLine) as totalProducts
from productlines pl
group by pl.productLine
