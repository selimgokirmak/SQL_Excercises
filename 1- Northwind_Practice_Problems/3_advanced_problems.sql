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
select OrderID
from OrderDetails
where Quantity >= 60
group by OrderID, Quantity
having count(*) > 1
*/


--39 Orders - accidental double-entry details
/*
select *
from OrderDetails
where OrderID in (select OrderID
					from OrderDetails
					where Quantity >= 60
					group by OrderID, Quantity
					having count(*) > 1)
*/


--40 Orders - accidental double-entry details, derived table
/*
Select OrderDetails.OrderID ,ProductID ,UnitPrice ,Quantity ,Discount 
From OrderDetails 
Join ( Select Distinct OrderID 
		From OrderDetails 
		Where Quantity >= 60 
		Group By OrderID, Quantity 
		Having Count(*) > 1 ) PotentialProblemOrders 
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
with all_orders as
( select EmployeeID, count(*) AllOrders
from Orders 
group by EmployeeID ),

late_orders as
( select EmployeeID, count(*) LateOrders
from Orders 
where ShippedDate >= RequiredDate
group by EmployeeID )

select ao.EmployeeID, e.LastName, ao.AllOrders, lo.LateOrders
from all_orders ao
join late_orders lo on ao.EmployeeID = lo.EmployeeID
join Employees e on ao.EmployeeID = e.EmployeeID
*/


--44 Late orders vs. total orders - missing employee
/*
with all_orders as
( select EmployeeID, count(*) AllOrders
from Orders 
group by EmployeeID ),

late_orders as
( select EmployeeID, count(*) LateOrders
from Orders 
where ShippedDate >= RequiredDate
group by EmployeeID )

select ao.EmployeeID, e.LastName, ao.AllOrders, lo.LateOrders
from all_orders ao
left join late_orders lo on ao.EmployeeID = lo.EmployeeID
join Employees e on ao.EmployeeID = e.EmployeeID
*/


--45 Late orders vs. total orders - fix null
/*
with all_orders as
( select EmployeeID, count(*) AllOrders
from Orders 
group by EmployeeID ),

late_orders as
( select EmployeeID, count(*) LateOrders
from Orders 
where ShippedDate >= RequiredDate
group by EmployeeID )

select ao.EmployeeID, e.LastName, ao.AllOrders, isnull(lo.LateOrders, 0)
from all_orders ao
left join late_orders lo on ao.EmployeeID = lo.EmployeeID
join Employees e on ao.EmployeeID = e.EmployeeID
*/


--46 Late orders vs. total orders - percentage
/*
with all_orders as
( select EmployeeID, count(*) AllOrders
from Orders 
group by EmployeeID ),

late_orders as
( select EmployeeID, count(*) LateOrders
from Orders 
where ShippedDate >= RequiredDate
group by EmployeeID )

select ao.EmployeeID, e.LastName, ao.AllOrders, isnull(lo.LateOrders, 0), 
(convert(float, isnull(lo.LateOrders, 0)) / ao.AllOrders) * 100 PercentLateOrders
from all_orders ao
left join late_orders lo on ao.EmployeeID = lo.EmployeeID
join Employees e on ao.EmployeeID = e.EmployeeID
*/


--47 Late orders vs. total orders - fix decimal
/*
with all_orders as
( select EmployeeID, count(*) AllOrders
from Orders 
group by EmployeeID ),

late_orders as
( select EmployeeID, count(*) LateOrders
from Orders 
where ShippedDate >= RequiredDate
group by EmployeeID )

select ao.EmployeeID, e.LastName, ao.AllOrders, isnull(lo.LateOrders, 0), 
convert(decimal(10,2), (convert(float, isnull(lo.LateOrders, 0)) / ao.AllOrders) * 100) PercentLateOrders
from all_orders ao
left join late_orders lo on ao.EmployeeID = lo.EmployeeID
join Employees e on ao.EmployeeID = e.EmployeeID
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
/*
select o1.CustomerID, o1.OrderID InitialOrderID, convert(date, o1.OrderDate) InitialOrderDate,
	o2.OrderID NextOrderID, CONVERT(date, o2.OrderDate) NextOrderDate
from Orders o1
	join Orders o2 on o1.CustomerID = o2.CustomerID
where o1.OrderID < o2.OrderID 
	and DATEDIFF(dd, o1.OrderDate, o2.OrderDate) <= 5
order by o1.CustomerID, o1.OrderID
*/


--57 Customers with multiple orders in 5 day period, version 2
/*
with orders_cte as (
select CustomerID, OrderDate,
	LEAD(Orderdate) over(partition by customerid order by CustomerID, OrderDate) NextOrderDate
from Orders )

select CustomerID, OrderDate, NextOrderDate,
	DATEDIFF(dd, OrderDate, NextOrderDate) DaysBetweenOrders
from orders_cte
where DATEDIFF(dd, OrderDate, NextOrderDate) <= 5
*/