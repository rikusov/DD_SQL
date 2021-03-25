USE AdventureWorks2016
GO

SELECT  
	DATENAME(MONTH,Max(OrderDate)) as [Month],
	SUM(SubTotal) as SubTotal 
FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate)
ORDER BY MONTH(OrderDate);