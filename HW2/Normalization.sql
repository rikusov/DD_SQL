use tempdb
GO

CREATE TABLE Product( -- ������� ��� �������
	ProductID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id ������
	ProductName VARCHAR(100) NOT NULL UNIQUE, -- ������������ ������
	ProductUM VARCHAR(10), -- ������� ��������� ������ (��. ��.)
	ProductPrice MONEY NOT NULL -- ���� ������ index
);
GO

CREATE TABLE SAddress( -- ������� ��� ������� ��������
	AddressID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id ������
	City VARCHAR(60) NOT NULL, --�����
	FullAddress VARCHAR(255) NOT NULL --������ �����
);
GO

CREATE NONCLUSTERED INDEX IX_SAddress_City
	ON dbo.SAddress(City);
GO

CREATE TABLE Customer( --������� ��������
	CustomerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id ����������
	CustomerName VARCHAR(255) NOT NULL, -- ������ ��� ����������
	Gender VARCHAR(1) NOT NULL, -- ��� ����������
	AddressID INT NULL -- id ����� ����������
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

CREATE TABLE OrderHeader( -- ������� ��� �����
	OrderID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- id ����
	CustomerID INT NULL	-- id ����������
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

CREATE TABLE OrderDetails( -- ������� ��� ������� � ����
	OrderID INT NOT NULL -- id ����
		CONSTRAINT FK_OrderDetales_OrderHeader FOREIGN KEY
		REFERENCES dbo.OrderHeader(OrderID),
	OrderDetailsID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- id ������ � ����	
	ProductID INT NOT NULL -- id ������
		CONSTRAINT FK_OrderDetails_Product FOREIGN KEY
		REFERENCES dbo.Product(ProductID), 
	CountProduct DECIMAL(10,5) NOT NULL, -- ���������� ������ � ����
	PriceForUnit MONEY NOT NULL, -- ���� ������ �� ������� �� ������ �������
	TotalPrice AS Cast((CountProduct*PriceForUnit) AS MONEY) PERSISTED, -- ����� �� ������ ����

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
