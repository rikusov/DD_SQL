USE AdventureWorks2016
GO

WITH CountSalesProduct AS (
	SELECT SSD.ProductID, SC.PersonID , SUM(OrderQty) as CountBuy
	FROM Sales.SalesOrderDetail AS SSD
		INNER JOIN Sales.SalesOrderHeader AS SSH
			ON SSD.SalesOrderID = SSH.SalesOrderID
		INNER JOIN Sales.Customer AS SC 
			ON SSH.CustomerID = SC.CustomerID AND SC.PersonID IS NOT NULL
	GROUP BY SSD.ProductID, SC.PersonID
	HAVING SUM(OrderQty) > 5
)

SELECT PEP.LastName, PEP.FirstName, PRP.[Name] as NameProduct, CountBuy
FROM CountSalesProduct AS CSP
	LEFT JOIN Person.Person AS PEP
		ON CSP.PersonID = PEP.BusinessEntityID
	LEFT JOIN Production.Product AS PRP
		ON CSP.ProductID = PRP.ProductID
ORDER BY LastName ASC, CountBuy DESC








