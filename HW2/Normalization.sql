use tempdb
GO

CREATE TABLE Product( -- ������� ��� �������
	ProductID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id ������
	ProductName VARCHAR(100) NOT NULL UNIQUE, -- ������������ ������
	ProductUM VARCHAR(10), -- ������� ��������� ������ (��. ��.)
	ProductPrice MONEY NOT NULL -- ���� ������ index
);

CREATE TABLE SAddress( -- ������� ��� ������� ��������
	AddressID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id ������
	City VARCHAR(60) NOT NULL UNIQUE, --�����
	FullAddress VARCHAR(255) NOT NULL --������ �����
);

CREATE TABLE Customer( --������� ��������
	CustomerID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --id ����������
	CustomerName VARCHAR(255) NOT NULL, -- ������ ��� ����������
	Gender VARCHAR(1) NOT NULL, -- ��� ����������
	AddressID INT NULL -- id ����� ����������
		CONSTRAINT FK_Customer_Addres FOREIGN KEY
		REFERENCES dbo.SAddress(AddressID) 
);

CREATE NONCLUSTERED INDEX IX_Customer_CustomerName
	ON dbo.Customer(CustomerName);

CREATE NONCLUSTERED INDEX IX_Customer_Adress
	ON dbo.Customer(AddressID);

CREATE TABLE OrderHeader( -- ������� ��� �����
	OrderID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- id ����
	CustomerID INT NULL	-- id ����������
		CONSTRAINT FK_OrderHeader_Customer FOREIGN KEY
		REFERENCES dbo.Customer(CustomerID),
	TotalPrice MONEY 
		CONSTRAINT  DF_OrderHeader_TotalPrice
		DEFAULT (0.00) NOT NULL
);

CREATE NONCLUSTERED INDEX IX_OrderHeader_Customer
	ON dbo.OrderHeader(CustomerID);

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

)

CREATE NONCLUSTERED INDEX IX_OrderDetails_Order
	ON dbo.OrderDetails(OrderID);

CREATE NONCLUSTERED INDEX IX_OrderDetails_Product
	ON dbo.OrderDetails(ProductID);
