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
SELECT productLine, textDescription,  (totalInStock + totalOrdered) AS totalProducts
FROM (
    SELECT pl.productLine, pl.textDescription, 
        (SELECT SUM(quantityInStock) AS totalInStock
         FROM products p
         WHERE p.productLine = pl.productLine) AS totalInStock,
        (SELECT SUM(quantityOrdered)
         FROM orderdetails
         WHERE productCode IN (SELECT productCode
                               FROM products
                               WHERE productLine = pl.productLine)) AS totalOrdered
    FROM productlines pl
    GROUP BY pl.productLine
) AS subquery

//cau 4
select c.customerName, (select sum(amount) from payments
where customerNumber = c.customerNumber) as totalPaid, (select sum(quantityOrdered*priceEach)
from orderdetails where orderNumber in (select orderNumber
from orders where customerNumber = c.customerNumber)) as totalPurchase, (select (totalPurchase - totalPaid)) as debt
from customers c
group by c.customerNumber
having totalPurchase <= 100000
