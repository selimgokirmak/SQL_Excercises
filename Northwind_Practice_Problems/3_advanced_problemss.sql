--32 High-value customers
/*
select c.CustomerID, c.CompanyName, o.OrderID, sum(od.UnitPrice * od.Quantity) TotalOrderAmount
from Customers c
join orders o on c.CustomerID = o.CustomerID
join OrderDetails od on o.orderid = od.OrderID
where year(o.OrderDate) = 2016
group by c.CustomerID, c.CompanyName, o.OrderID
having sum(od.UnitPrice * od.Quantity) >= 10000
order by TotalOrderAmount desc
*/


--33 High-value customers - total orders
/*
select c.CustomerID, c.CompanyName, sum(od.UnitPrice * od.Quantity) TotalOrderAmount
from Customers c
join orders o on c.CustomerID = o.CustomerID
join OrderDetails od on o.orderid = od.OrderID
where year(o.OrderDate) = 2016
group by c.CustomerID, c.CompanyName
having sum(od.UnitPrice * od.Quantity) >= 15000
order by TotalOrderAmount desc
*/


--34 High-value customers - with discount
/*
select c.CustomerID, c.CompanyName, 
sum(od.UnitPrice * od.Quantity) TotalWithoutDiscount, sum(od.UnitPrice * od.Quantity * (1- od.Discount)) TotalWithDiscount
from Customers c
join orders o on c.CustomerID = o.CustomerID
join OrderDetails od on o.orderid = od.OrderID
where year(o.OrderDate) = 2016
group by c.CustomerID, c.CompanyName
having sum(od.UnitPrice * od.Quantity * (1- od.Discount)) >= 10000
order by TotalWithDiscount desc
*/


--35 Month-end orders
/*
select EmployeeID, OrderID, OrderDate
from orders
where OrderDate = eomonth(orderdate)
order by EmployeeID, OrderID
*/


--36 Orders with many line items
/*
select top 10 orderid, count(*) TotalOrderDetail
from OrderDetails
group by orderid
order by TotalOrderDetail desc
*/


--37 Orders - random assortment
/*
select top 2 percent orderid
from orders
order by NEWID()
*/


--38 Orders - accidental double-entry
/*
select od.orderid, od.Quantity, count(*)
from OrderDetails od
join orders o on od.OrderID = o.OrderID
where od.Quantity >= 60
group by od.OrderID, od.Quantity
having count(*) > 1
order by od.OrderID
*/


--39 Orders - accidental double-entry details
/*
select OrderID, ProductID, UnitPrice, Quantity, Discount
from OrderDetails
where orderid in (select od.orderid
				  from OrderDetails od
				  join orders o on od.OrderID = o.OrderID
				  where od.Quantity >= 60
				  group by od.OrderID, od.Quantity
				  having count(*) > 1)
*/


--40 Orders - accidental double-entry details, derived table
/*
Select OrderDetails.OrderID ,ProductID ,UnitPrice ,Quantity ,Discount 
From OrderDetails 
Join ( Select distinct OrderID From OrderDetails Where Quantity >= 60 Group By OrderID, Quantity Having Count(*) > 1 ) PotentialProblemOrders 
on PotentialProblemOrders.OrderID = OrderDetails.OrderID 
Order by OrderID, ProductID
*/


--41 Late orders
/*
select OrderID, OrderDate, RequiredDate, ShippedDate
from orders
where ShippedDate >= RequiredDate
*/


--42 Late orders - which employees?
/*
select o.EmployeeID, e.LastName, count(*) TotalLateOrders
from orders o
join Employees e on o.EmployeeID=e.EmployeeID
where ShippedDate >= RequiredDate
group by o.EmployeeID, e.LastName
order by TotalLateOrders desc
*/


--43.1 Late orders vs. total orders
/*
select o.EmployeeID, e.LastName, 
 (select count(*)
  from orders
  where EmployeeID=o.EmployeeID
  group by EmployeeID) AllOrders, 
count(*) TotalLateOrders
from orders o
join Employees e on o.EmployeeID=e.EmployeeID
where ShippedDate >= RequiredDate
group by o.EmployeeID, e.LastName
*/
--43.2
/*
with allorders_cte (EmployeeID, allorders) as
(select EmployeeId, count(*) 
 from orders 
 group by EmployeeId),

lateorders_cte (EmployeeID, lateorders) as
(select EmployeeID, COUNT(*)
 from orders
 where ShippedDate >= RequiredDate
 group by EmployeeID)

select ao.EmployeeID, ao.allorders, lo.lateorders
from allorders_cte ao
join lateorders_cte lo on ao.EmployeeID=lo.EmployeeID
*/


--44 Late orders vs. total orders - missing employee
/*
with allorders_cte (EmployeeID, allorders) as
(select EmployeeId, count(*) 
 from orders 
 group by EmployeeId),

lateorders_cte (EmployeeID, lateorders) as
(select EmployeeID, COUNT(*)
 from orders
 where ShippedDate >= RequiredDate
 group by EmployeeID)

select ao.EmployeeID, ao.allorders, lo.lateorders
from allorders_cte ao
left join lateorders_cte lo on ao.EmployeeID=lo.EmployeeID
*/


--45 Late orders vs. total orders - fix null
/*
with allorders_cte (EmployeeID, allorders) as
(select EmployeeId, count(*) 
 from orders 
 group by EmployeeId),

lateorders_cte (EmployeeID, lateorders) as
(select EmployeeID, COUNT(*)
 from orders
 where ShippedDate >= RequiredDate
 group by EmployeeID)

select ao.EmployeeID, ao.allorders, isnull(lo.lateorders,0) lateorders
from allorders_cte ao
left join lateorders_cte lo on ao.EmployeeID=lo.EmployeeID
*/


--46 Late orders vs. total orders - percentage
/*
with allorders_cte (EmployeeID, allorders) as
(select EmployeeId, count(*) 
 from orders 
 group by EmployeeId),

lateorders_cte (EmployeeID, lateorders) as
(select EmployeeID, COUNT(*)
 from orders
 where ShippedDate >= RequiredDate
 group by EmployeeID)

select ao.EmployeeID, ao.allorders, isnull(lo.lateorders,0) lateorders,
	(isnull(lo.lateorders,0) * 1.00 / ao.allorders) * 100 PercentLateOrders
from allorders_cte ao
left join lateorders_cte lo on ao.EmployeeID=lo.EmployeeID
*/


--47 Late orders vs. total orders - fix decimal
/*
with allorders_cte (EmployeeID, allorders) as
(select EmployeeId, count(*) 
 from orders 
 group by EmployeeId),

lateorders_cte (EmployeeID, lateorders) as
(select EmployeeID, COUNT(*)
 from orders
 where ShippedDate >= RequiredDate
 group by EmployeeID)

select ao.EmployeeID, ao.allorders, isnull(lo.lateorders,0) lateorders,
	convert(decimal(10,2), (isnull(lo.lateorders,0) * 1.00 / ao.allorders) * 100) PercentLateOrders
from allorders_cte ao
left join lateorders_cte lo on ao.EmployeeID=lo.EmployeeID
*/


--48 Customer grouping
/*
with totalorderamount_cte (CustomerId, CompanyName, TotalOrderAmount) as
(select o.CustomerID, c.CompanyName, sum(od.UnitPrice * od.Quantity) TotalOrderAmount
from orders o
join Customers c on o.CustomerID=c.CustomerID
join OrderDetails od on o.OrderID=od.OrderID
where year(o.OrderDate) = 2016
group by o.CustomerID, c.CompanyName)

select *,
case
when TotalOrderAmount < 1000 then 'low'
when TotalOrderAmount < 5000 then 'medium'
when TotalOrderAmount < 10000 then 'high'
when TotalOrderAmount > 10000 then 'very high'
end as CustomerGroup
from totalorderamount_cte
*/


--49 Customer grouping - fix null
-- same query as the previous question because we didn't use between there


--50 Customer grouping with percentage
/*
with totalorderamount_cte (CustomerId, CompanyName, TotalOrderAmount) as
(select o.CustomerID, c.CompanyName, sum(od.UnitPrice * od.Quantity) TotalOrderAmount
from orders o
join Customers c on o.CustomerID=c.CustomerID
join OrderDetails od on o.OrderID=od.OrderID
where year(o.OrderDate) = 2016
group by o.CustomerID, c.CompanyName),

new_table (CustomerId, CompanyName, TotalOrderAmount, CustomerGroup) as
(select *,
case
when TotalOrderAmount < 1000 then 'low'
when TotalOrderAmount < 5000 then 'medium'
when TotalOrderAmount < 10000 then 'high'
when TotalOrderAmount > 10000 then 'very high'
end as CustomerGroup
from totalorderamount_cte),

last_cte (CustomerGroup, TotalInGroup) as 
(select CustomerGroup, COUNT(*) TotalInGroup
from new_table
group by CustomerGroup)

select *, (TotalInGroup * 1.00 / (select sum(TotalInGroup) from last_cte)) * 100 PercentageInGroup
from last_cte
order by TotalInGroup desc
*/


--51 Customer grouping - flexible
/*
with totalorderamount_cte (CustomerId, CompanyName, TotalOrderAmount) as
(select o.CustomerID, c.CompanyName, sum(od.UnitPrice * od.Quantity) TotalOrderAmount
from orders o
join Customers c on o.CustomerID=c.CustomerID
join OrderDetails od on o.OrderID=od.OrderID
where year(o.OrderDate) = 2016
group by o.CustomerID, c.CompanyName)

select toa.*, CustomerGroupName
from totalorderamount_cte toa
join CustomerGroupThresholds cgt on toa.TotalOrderAmount >= cgt.RangeBottom and toa.TotalOrderAmount <= cgt.RangeTop
*/


--52 Countries with suppliers or customers
/*
select distinct country
from Customers
union
select distinct country
from Suppliers
*/


--53 Countries with suppliers or customers, version 2
/*
select distinct s.country SupplierCountry, c.country CustomerCountry
from Suppliers s
full join Customers c on s.Country= c.Country
order by SupplierCountry
*/


--54 Countries with suppliers or customers - version 3
/*
with totalsuppliers (country, total) as
(select country, count(*) from Suppliers group by Country),

totalcustomers (country, total) as 
(select country, count(*) from Customers group by Country),

base_cte (country) as
(select distinct country
 from Customers
union
select distinct country
 from Suppliers)

select b.country, isnull(ts.total, 0) TotalSuppliers, isnull(tc.total,0) TotalCustomers
from base_cte b
left join totalsuppliers ts on b.country = ts.country
left join totalcustomers tc on b.country = tc.country
*/


--55 First order in each country
/*
select ShipCountry, CustomerID, OrderID, convert(date,OrderDate) OrderDate
from orders 
where orderid in (select min(OrderID) orderid
				  from orders
				  group by ShipCountry )
order by ShipCountry
*/


--56 Customers with multiple orders in 5 day period


--57 Customers with multiple orders in 5 day period, version 2
