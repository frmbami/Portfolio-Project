# SQL Personal Project :

# 1 - calculating the average order amount (value) for each country 
 
SELECT avg(quantityOrdered*priceEach) as average_order_amount,country  FROM orderdetails od
INNER JOIN orders o
ON od.orderNumber=o.orderNumber 
INNER JOIN customers C ON
o.customerNumber=C.customerNumber
group by country 
order by average_order_amount asc;

# 2 calculating the total sales amount for each product line #
select productLine, sum(quantityOrdered*priceEach) as total_sales from products p
inner join orderdetails od
on p.productCode=od.productCode
group by productLine
order by total_sales desc;

-- 3 List the top 10 best selling product based on total quantity sold 
select productName,sum(quantityOrdered) as Total_quantity_sold from products p 
INNER JOIN orderdetails od
on p.productCode=od.productCode
group by productName
order by Total_quantity_sold desc
limit 10;

-- 4 List the top 10 worst selling product based on total quantity sold 
select productName,sum(quantityOrdered) as Total_quantity_sold from products p 
INNER JOIN orderdetails od
on p.productCode=od.productCode
group by productName
order by Total_quantity_sold 
limit 10;


-- Evaluate the sales perfomance of each sales representatives
select e.firstName,e.lastName,e.jobTitle ,sum(amount) as employee_total_sales from customers c
INNER JOIN employees e
on c.salesRepEmployeeNumber=e.employeeNumber
INNER JOIN payments p
on c.customerNumber=p.customerNumber
group by e.firstName,e.lastName,e.jobTitle ;

select e.firstName,e.lastName,sum(quantityOrdered*priceEach) as total_sales  from customers c
INNER JOIN employees e
on c.salesRepEmployeeNumber=e.employeeNumber and e.jobTitle='Sales Rep'
LEFT JOIN orders o
on c.customerNumber=o.customerNumber
LEFT JOIN orderdetails od
on o.orderNumber=od.orderNumber
group by e.firstName,e.lastName;

-- Calculating the average number of orders place by each customer

select count(o.orderNumber)/count(distinct c.customerNumber) as average_order FROM customers c # using distinct for the unique customer 
left JOIN orders o # left join because we also need to count the customer that didnt place any orders
on c.customerNumber=o.customerNumber;

-- Calculate the percent of orders shipped on time
select sum(
CASE WHEN shippedDate <= requiredDate THEN 1
ELSE 0 END) /count(orderNumber)*100 AS Percent_on_time
from orders;

-- Calculating the profit margin of each product by subtracting  the cost of goods sold from the sales revenue
select productName,sum((od.priceEach*od.quantityOrdered)-(p.buyPrice*od.quantityOrdered)) as profit_margin
From products p
INNER JOIN orderdetails od
on p.productCode=od.productCode
group by productName;

-- Segment customer base on their total amount purchase --
select *,
case when total_amount<25000 then 'low value customer'
when total_amount between 25000 and 50000 then 'medium value customer'
when total_amount between 50000 and 100000 then 'high value customer'
else 'Premium value customer' end as customer_value
from
(select customerNumber, sum(amount) as total_amount
from payments
group by customerNumber)t1;

-- addding the customer name associatte to their customer --
select c.customerName, t2.customer_value
from customers c
left join
(select *,
case when total_amount<25000 then 'low value customer'
when total_amount between 25000 and 50000 then 'medium value customer'
when total_amount between 50000 and 100000 then 'high value customer'
else 'Premium value customer' end as customer_value
from
(select customerNumber, sum(amount) as total_amount
from payments
group by customerNumber)t1
)t2
on c.customerNumber=t2.customerNumber;
-- identify frequently co-purcharsed product to understand cross-selling opportunity 
select od.productCode,p.productName,o.productCode,p2.productName,count(*) as Purchased_together
 from orderdetails od
inner join orderdetails o
on od.orderNumber=o.orderNumber and od.productCode <> o.productCode
inner join products p
on o.productCode=p.productCode
inner join products p2
on o.productCode=p2.productCode
group by od.productCode,p.productName,o.productCode,p2.productName
order by Purchased_together desc;






