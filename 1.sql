select c.customerName, c.customerNumber, (select datediff('2005-06-02',max(orderDate))
from orders where customerNumber = c.customerNumber) as recency,
(select count(*) from orders where customerNumber = c.customerNumber) as frequency,
(select sum(quantityOrdered*priceEach) from orderdetails 
where orderNumber in (select orderNumber
from orders where customerNumber = c.customerNumber)) as monetary
from customers c
group by c.customerNumber
having (recency <= 5 and frequency >=5) or monetary >= 500000
