--1 Which shippers do we have?
--select * from shippers


--2 Certain fields from Categories
--select CategoryName, Description from Categories


--3 Sales Representatives
--select FirstName, LastName, HireDate from Employees where Title='Sales Representative'


--4 Sales Representatives in the United States
--select FirstName, LastName, HireDate from Employees where Title='Sales Representative' and Country='USA'


--5 Orders placed by specific EmployeeID
--select orderid, orderdate from orders where EmployeeID=5


--6 Suppliers and ContactTitles
--select supplierid, contactname, contacttitle from Suppliers where contacttitle <> 'Marketing Manager'


--7 Products with “queso” in ProductName
--select ProductID, ProductName from Products where ProductName like '%queso%'


--8 Orders shipping to France or Belgium
--select OrderID, CustomerID, ShipCountry from orders where ShipCountry in ('France', 'Belgium')


--9 Orders shipping to any country in Latin America
--select OrderID, CustomerID, ShipCountry from orders where ShipCountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')


--10 Employees, in order of age
--select FirstName, LastName, Title, Birthdate from Employees order by BirthDate 


--11 Showing only the Date with a DateTime field
--select FirstName, LastName, Title, convert(date, BirthDate) Birthdate from Employees order by BirthDate 


--12 Employees full name
--select firstname, lastname, concat_ws(' ',firstname,lastname) fullname from Employees


--13 OrderDetails amount per line item
--select orderid, ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) totalprice from OrderDetails order by OrderID, ProductID


--14 How many customers?
--select count(*) from Customers


--15 When was the first order?
--select min(orderdate) from orders


--16.1 Countries where there are customers
--select distinct ShipCountry from orders order by ShipCountry

--16.2
--select ShipCountry from orders group by ShipCountry order by ShipCountry


--17 Contact titles for customers
--select ContactTitle, count(*) totalcontacttitle from customers group by ContactTitle order by totalcontacttitle desc


--18 Products with associated supplier names
/*
select p.ProductID, p.ProductName, s.CompanyName 
from Products p
join Suppliers s 
on p.SupplierID = s.SupplierID
order by p.ProductID
*/


--19 Orders and the Shipper that was used
/*
select OrderID, convert(date, OrderDate) orderdate, companyname 
from orders o
join Shippers s
on o.ShipVia = s.ShipperID
where orderid < 10300
order by OrderID
*/

