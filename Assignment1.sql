use AdventureWorks2022;
SELECT * FROM Sales.Customer
SELECT * FROM Person.Address A
JOIN Sales.Customer C ON A.AddressID = C.CustomerID
WHERE City IN ('Berlin', 'London');
SELECT * FROM Person.Address A
JOIN Sales.Customer C ON A.AddressID = C.CustomerID
JOIN Person.StateProvince SP ON A.StateProvinceID = SP.StateProvinceID
JOIN Person.CountryRegion CR ON SP.CountryRegionCode = CR.CountryRegionCode
WHERE CR.Name IN ('United Kingdom', 'United States');
SELECT * FROM Production.Product
ORDER BY Name;

SELECT * FROM Production.Product
WHERE Name LIKE 'A%';

SELECT DISTINCT C.CustomerID, C.*
FROM Sales.Customer C
JOIN Sales.SalesOrderHeader OH ON C.CustomerID = OH.CustomerID;

SELECT DISTINCT C.CustomerID, C.*
FROM Sales.Customer C
JOIN Sales.SalesOrderHeader OH ON C.CustomerID = OH.CustomerID
JOIN Sales.SalesOrderDetail OD ON OH.SalesOrderID = OD.SalesOrderID
JOIN Production.Product P ON OD.ProductID = P.ProductID
JOIN Person.Address A ON C.CustomerID = A.AddressID
WHERE A.City = 'London' AND P.Name = 'Chai';


SELECT * FROM Sales.Customer
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader
);

SELECT DISTINCT C.*
FROM Sales.Customer C
JOIN Sales.SalesOrderHeader OH ON C.CustomerID = OH.CustomerID
JOIN Sales.SalesOrderDetail OD ON OH.SalesOrderID = OD.SalesOrderID
JOIN Production.Product P ON OD.ProductID = P.ProductID
WHERE P.Name = 'Tofu';

SELECT TOP 1 * FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;


SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

SELECT SalesOrderID, AVG(OrderQty) AS AverageQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

SELECT ManagerID, COUNT(*) AS TotalEmployees
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
GROUP BY ManagerID;

SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;


SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';


SELECT * FROM Sales.SalesOrderHeader
WHERE ShipToAddressID IN (
    SELECT AddressID FROM Person.Address
    WHERE StateProvinceID IN (
        SELECT StateProvinceID FROM Person.StateProvince
        WHERE CountryRegionCode = 'CA'
    )
);


SELECT * FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

SELECT CR.Name AS Country, SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Person.Address A ON SOH.BillToAddressID = A.AddressID
JOIN Person.StateProvince SP ON A.StateProvinceID = SP.StateProvinceID
JOIN Person.CountryRegion CR ON SP.CountryRegionCode = CR.CountryRegionCode
GROUP BY CR.Name;


SELECT C.CustomerID, P.FirstName + ' ' + P.LastName AS ContactName, COUNT(*) AS OrdersCount
FROM Sales.Customer C
JOIN Sales.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
JOIN Person.Person P ON C.PersonID = P.BusinessEntityID
GROUP BY C.CustomerID, P.FirstName, P.LastName
HAVING COUNT(*) > 3;


SELECT DISTINCT P.*
FROM Production.Product P
JOIN Sales.SalesOrderDetail OD ON P.ProductID = OD.ProductID
JOIN Sales.SalesOrderHeader OH ON OD.SalesOrderID = OH.SalesOrderID
WHERE OH.OrderDate BETWEEN '1997-01-01' AND '1998-01-01'
AND P.DiscontinuedDate IS NOT NULL;


SELECT E.BusinessEntityID, E1.FirstName, E1.LastName,
       M.BusinessEntityID AS ManagerID, E2.FirstName AS ManagerFirstName, E2.LastName AS ManagerLastName
FROM HumanResources.Employee E
JOIN Person.Person E1 ON E.BusinessEntityID = E1.BusinessEntityID
LEFT JOIN HumanResources.Employee M ON E.ManagerID = M.BusinessEntityID
LEFT JOIN Person.Person E2 ON M.BusinessEntityID = E2.BusinessEntityID;


SELECT SalesPersonID, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID;

SELECT * FROM Person.Person
WHERE FirstName LIKE '%a%';

SELECT ManagerID, COUNT(*) AS Reportees
FROM HumanResources.Employee
GROUP BY ManagerID
HAVING COUNT(*) > 4;

SELECT FaxNumber FROM Person.Person;


SELECT BusinessEntityID, FirstName, FaxNumber  
FROM Person.Person;


SELECT OD.SalesOrderID, P.Name
FROM Sales.SalesOrderDetail OD
JOIN Production.Product P ON OD.ProductID = P.ProductID;

SELECT TOP 1 CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

SELECT * FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
    SELECT CustomerID FROM Sales.Customer
    WHERE PersonID IN (
        SELECT BusinessEntityID FROM Person.Person
        WHERE Faxnumber IS NULL
    )
);


SELECT DISTINCT A.PostalCode
FROM Sales.SalesOrderDetail OD
JOIN Production.Product P ON OD.ProductID = P.ProductID
JOIN Sales.SalesOrderHeader OH ON OD.SalesOrderID = OH.SalesOrderID
JOIN Person.Address A ON OH.ShipToAddressID = A.AddressID
WHERE P.Name = 'Tofu';


SELECT DISTINCT P.Name
FROM Sales.SalesOrderDetail OD
JOIN Sales.SalesOrderHeader OH ON OD.SalesOrderID = OH.SalesOrderID
JOIN Person.Address A ON OH.ShipToAddressID = A.AddressID
JOIN Production.Product P ON OD.ProductID = P.ProductID
JOIN Person.StateProvince SP ON A.StateProvinceID = SP.StateProvinceID
WHERE SP.CountryRegionCode = 'FR';


SELECT P.Name, PC.Name AS Category
FROM Production.Product P
JOIN Production.ProductSubcategory PSC ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PSC.ProductCategoryID = PC.ProductCategoryID
JOIN Purchasing.ProductVendor PV ON P.ProductID = PV.ProductID
JOIN Purchasing.Vendor V ON PV.BusinessEntityID = V.BusinessEntityID
WHERE V.Name = 'Specialty Biscuits, Ltd.';


SELECT * FROM Production.Product
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail
);


SELECT * FROM Production.ProductInventory
WHERE Quantity < 10 AND SafetyStockLevel = 0;


SELECT TOP 10 CR.Name AS Country, SUM(SOH.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SOH
JOIN Person.Address A ON SOH.BillToAddressID = A.AddressID
JOIN Person.StateProvince SP ON A.StateProvinceID = SP.StateProvinceID
JOIN Person.CountryRegion CR ON SP.CountryRegionCode = CR.CountryRegionCode
GROUP BY CR.Name
ORDER BY TotalSales DESC;


SELECT SalesPersonID, COUNT(*) AS OrdersTaken
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 'A' AND 'AO'
GROUP BY SalesPersonID;


SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;


SELECT P.Name, SUM(OD.LineTotal) AS Revenue
FROM Sales.SalesOrderDetail OD
JOIN Production.Product P ON OD.ProductID = P.ProductID
GROUP BY P.Name;



SELECT PV.BusinessEntityID AS SupplierID, COUNT(*) AS ProductCount
FROM Purchasing.ProductVendor PV
GROUP BY PV.BusinessEntityID;


SELECT TOP 10 CustomerID, SUM(TotalDue) AS TotalBusiness
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalBusiness DESC;


SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;




SELECT * FROM Sales.SalesOrderHeader
WHERE CustomerID IN (
    SELECT CustomerID FROM Sales.Customer
    WHERE PersonID IN (
        SELECT BusinessEntityID FROM Person.Person
        WHERE  IS NULL
    )
);









