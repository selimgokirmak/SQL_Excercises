--20 Categories, and the total products in each category
/*
select c.categoryname, count(productname) totalproducts
from Categories c
join Products p
on c.CategoryID = p.CategoryID
group by c.categoryname
order by totalproducts desc
*/


--21 Total customers per country/city
/*
select Country, City, count(*) totalcustomer
from Customers
group by country, city
order by totalcustomer desc
*/


--22 Products that need reordering
/*
select productid, productname, unitsinstock, reorderlevel
from products
where ReorderLevel > UnitsInStock
order by ProductID
*/


--23 Products that need reordering, continued
/*
select ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from products
where UnitsInStock + UnitsOnOrder <= ReorderLevel
and Discontinued = 0
*/


--24 Customer list by region
/*
select CustomerID, CompanyName, Region,
case when region is null then 1
else 0 end region_null
from Customers
order by region_null, region, CustomerID
*/


--25 High freight charges
/*
select top 3 ShipCountry, avg(freight) avgfreight
from orders
group by ShipCountry
order by avgfreight desc
*/


--26 High freight charges - 2015
/*
select top 3 ShipCountry, avg(freight) avgfreight
from orders
where year(OrderDate) = 2015
group by ShipCountry
order by avgfreight desc
*/


--27 High freight charges with between
/*
select top 3 ShipCountry, avg(freight) avgfreight
from orders
where orderdate between '1/1/2015' and '1/1/2016'
group by ShipCountry
order by avgfreight desc
*/


--28 High freight charges - last year
/*
select top 3 ShipCountry, avg(freight) avgfreight
from orders
where orderdate > (select dateadd(yy, -1, (select max(orderdate) from orders)))
group by ShipCountry
order by avgfreight desc
*/


--29 Inventory list
/*
select e.EmployeeID, e.lastname, o.OrderID, p.ProductName, od.Quantity
from Employees e
join orders o on e.EmployeeID = o.employeeid
join OrderDetails od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
*/


--30.1 Customers with no orders
/*
select CustomerID from Customers
except
select CustomerID from orders
*/

--30.2
/*
select c.CustomerID, o.OrderID
from Customers c
left join orders o on c.CustomerID = o.CustomerID
where o.OrderID is null
*/


--31 Customers with no orders for EmployeeID 4
/*
select CustomerID
from Customers
except
select CustomerID
from orders
where EmployeeID = 4
*/

