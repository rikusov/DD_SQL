USE AdventureWorks2016
GO

WITH CityStore AS (
	SELECT DISTINCT City 
	FROM Sales.Store as SS
		LEFT JOIN Person.BusinessEntityAddress AS PB 
			ON SS.BusinessEntityID = PB.BusinessEntityID
		LEFT JOIN Person.[Address] AS PA 
			ON PB.AddressID = PA.AddressID
)

SELECT TOP 10 City, COUNT(DISTINCT CustomerID) as [Priority]
FROM Sales.SalesOrderHeader AS SS
	LEFT JOIN Person.[Address] AS PA 
		ON SS.ShipToAddressID = PA.AddressID
WHERE City NOT IN (SELECT City FROM CityStore)
GROUP BY City
ORDER BY [Priority] DESC