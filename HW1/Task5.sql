USE AdventureWorks2016
GO

WITH FirstOrder AS(
	SELECT 
		CustomerID, 
		MIN(OrderDate) AS OrderDate,
		(
			SELECT TOP 1 SS_V.SalesOrderID 
			FROM Sales.SalesOrderHeader AS SS_V 
			WHERE SS_V.CustomerID = SS.CustomerID and SS_V.OrderDate = MIN(SS.OrderDate) 
			ORDER BY SS_V.SalesOrderID
		) AS SalesOrderID
	FROM Sales.SalesOrderHeader as SS
	GROUP BY CustomerID
)

SELECT 
	Cast(FO.OrderDate AS DATE) AS OrderDate,
	PP.LastName,
	PP.FirstName,
	REPLACE(
			(SELECT PRP.Name +  N' Количество: ' + Cast(SSD.OrderQty as varchar(5)) + N' .шт@'
			FROM Sales.SalesOrderDetail AS SSD
				LEFT JOIN Production.Product as PRP
					ON  PRP.ProductID = SSD.ProductID
			WHERE FO.SalesOrderID = SSD.SalesOrderID
			FOR XML PATH('')),
		'@',CHAR(13)+CHAR(10)
		) AS ContentOrder
FROM FirstOrder as FO
	INNER JOIN Sales.Customer SC
		ON FO.CustomerID = SC.CustomerID AND SC.PersonID is not NULL
	LEFT JOIN Person.Person as PP
		ON PP.BusinessEntityID = SC.PersonID
ORDER BY OrderDate DESC