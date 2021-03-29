use tempdb
GO

CREATE TABLE Product( -- таблица для товаров
	ProductID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id товара
	ProductName VARCHAR(100) NOT NULL UNIQUE, -- наименование товара
	ProductUM VARCHAR(10), -- единица измерения товара (шт. кг.)
	ProductPrice MONEY NOT NULL -- цена товара index
);
GO

CREATE TABLE SAddress( -- таблица для адресов клиентов
	AddressID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id адреса
	City VARCHAR(60) NOT NULL, --город
	FullAddress VARCHAR(255) NOT NULL --полный адрес
);
GO

CREATE NONCLUSTERED INDEX IX_SAddress_City
	ON dbo.SAddress(City);
GO

CREATE TABLE Customer( --таблица клиентов
	CustomerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id покупателя
	CustomerName VARCHAR(255) NOT NULL, -- Полное имя покупателя
	Gender VARCHAR(1) NOT NULL, -- Пол покупателя
	AddressID INT NULL -- id адрес покупателя
		CONSTRAINT FK_Customer_Addres FOREIGN KEY
		REFERENCES dbo.SAddress(AddressID) 
);
GO

CREATE NONCLUSTERED INDEX IX_Customer_CustomerName
	ON dbo.Customer(CustomerName);
GO

CREATE NONCLUSTERED INDEX IX_Customer_Adress
	ON dbo.Customer(AddressID);
GO

CREATE TABLE OrderHeader( -- таблица для чеков
	OrderID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- id чека
	CustomerID INT NULL	-- id покупателя
		CONSTRAINT FK_OrderHeader_Customer FOREIGN KEY
		REFERENCES dbo.Customer(CustomerID),
	TotalPrice MONEY 
		CONSTRAINT  DF_OrderHeader_TotalPrice
		DEFAULT (0.00) NOT NULL
);
GO

CREATE NONCLUSTERED INDEX IX_OrderHeader_Customer
	ON dbo.OrderHeader(CustomerID);
GO

CREATE TABLE OrderDetails( -- таблица для позиций в чеке
	OrderID INT NOT NULL -- id чека
		CONSTRAINT FK_OrderDetales_OrderHeader FOREIGN KEY
		REFERENCES dbo.OrderHeader(OrderID),
	OrderDetailsID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- id пункта в чеке	
	ProductID INT NOT NULL -- id товара
		CONSTRAINT FK_OrderDetails_Product FOREIGN KEY
		REFERENCES dbo.Product(ProductID), 
	CountProduct DECIMAL(10,5) NOT NULL, -- количество товара в чеке
	PriceForUnit MONEY NOT NULL, -- цена товара за единицу на момент покупки
	TotalPrice AS Cast((CountProduct*PriceForUnit) AS MONEY) PERSISTED, -- итого по сточке чека

);
GO

CREATE TRIGGER PriceOrderDetails ON dbo.OrderDetails
AFTER INSERT, DELETE, UPDATE AS 
BEGIN
	UPDATE dbo.OrderHeader 
		SET dbo.OrderHeader.TotalPrice =
			(SELECT SUM(OD.TotalPrice) FROM dbo.OrderDetails AS OD
				WHERE OD.OrderID = dbo.OrderHeader.OrderID)
		WHERE OrderHeader.OrderID IN (SELECT inserted.OrderID FROM inserted)
			OR OrderHeader.OrderID IN (SELECT deleted.OrderID From deleted)  
END;
GO

CREATE NONCLUSTERED INDEX IX_OrderDetails_Order
	ON dbo.OrderDetails(OrderID);
GO

CREATE NONCLUSTERED INDEX IX_OrderDetails_Product
	ON dbo.OrderDetails(ProductID);
GO
