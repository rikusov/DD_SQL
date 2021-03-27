USE AdventureWorks2016
GO

SELECT 
	DATENAME(MONTH,MAX(OrderDate))+' '+CAST(YEAR(MAX(OrderDate)) as varchar(4)) as [OrderDate],
	SUM(SubTotal) as SubTotal 
FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
ORDER BY YEAR(OrderDate),MONTH(OrderDate);