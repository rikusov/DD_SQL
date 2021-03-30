-- Задача 1
-------------Для ускорения запроса 1-----------------
CREATE NONCLUSTERED INDEX IX_WebLog_SessionStart_ServerID
	ON Marketing.WebLog(SessionStart,ServerID)
		INCLUDE(SessionID,UserName);
GO
--------------------------------------------------

DECLARE @StartTime datetime2 = '2010-08-30 16:27';

SELECT TOP(5000) wl.SessionID, wl.ServerID, wl.UserName 
FROM Marketing.WebLog AS wl
WHERE wl.SessionStart >= @StartTime
ORDER BY wl.SessionStart, wl.ServerID;
GO

-- Задача 2
-------------Для ускорения запроса 2-----------------
CREATE NONCLUSTERED INDEX IX_PostalCode_StateCode_PostalCode
	ON Marketing.PostalCode(StateCode,PostalCode)
		INCLUDE(Country);
GO
--------------------------------------------------

SELECT PostalCode, Country
FROM Marketing.PostalCode 
WHERE StateCode = 'KY'
ORDER BY StateCode, PostalCode;
GO

-- Задача 3
-------------Для ускорения запроса 3-----------------
CREATE NONCLUSTERED INDEX IX_Prospect_LastName_FirstName
	ON Marketing.Prospect(LastName,FirstName);
GO

CREATE NONCLUSTERED INDEX IX_Prospect_LastName
	ON Marketing.Prospect(LastName)
		INCLUDE(ProspectID,FirstName,MiddleName,CellPhoneNumber,HomePhoneNumber,WorkPhoneNumber,Demographics,LatestContact,EmailAddress);
	--Мне кажется бредом хранить таблицу еще раз в некластерном индексе, но так прирост в скорости довольно неплохой 
GO

CREATE NONCLUSTERED INDEX IX_Salesperson_LastName
	ON Marketing.Salesperson(LastName);
GO
--------------------------------------------------

DECLARE @Counter INT = 0;
WHILE @Counter < 350
BEGIN
  SELECT p.LastName, p.FirstName 
  FROM Marketing.Prospect AS p
  WHERE p.LastName IN (SELECT LastName FROM Marketing.Salesperson)
  ORDER BY p.LastName, p.FirstName;
  
  SELECT * 
  FROM Marketing.Prospect AS p
  WHERE p.LastName = 'Smith';
  SET @Counter += 1;
END;


-- Задача 4
-------------Для ускорения запроса 4-----------------
CREATE NONCLUSTERED INDEX IX_Product_ProductModelID
	ON Marketing.Product(SubcategoryID)
		INCLUDE(ProductModelID,ProductID);

GO

CREATE NONCLUSTERED INDEX IX_ProductModel_ProductModelID
	ON Marketing.ProductModel(ProductModelID)
		INCLUDE(ProductModel);
GO
-----------------------------------------------------

SELECT
	(SELECT CategoryName FROM Marketing.Category WHERE CategoryID = sc.CategoryID) AS CategoryName,
	sc.SubcategoryName,
	(SELECT ProductModel FROM Marketing.ProductModel WHERE ProductModelID = p.ProductModelID) AS ProductModel,
	COUNT(p.ProductID) AS ModelCount
FROM Marketing.Product p
	JOIN Marketing.Subcategory sc
		ON sc.SubcategoryID = p.SubcategoryID
GROUP BY sc.CategoryID,
	sc.SubcategoryName,
	p.ProductModelID
HAVING COUNT(p.ProductID) > 1