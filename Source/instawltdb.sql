CREATE TABLE [ErrorLog](
    [ErrorLogID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [ErrorTime] DATETIME NOT NULL DEFAULT (datetime('now')),
    [UserName] TEXT NOT NULL, 
    [ErrorNumber] INTEGER NOT NULL, 
    [ErrorSeverity] INTEGER NULL, 
    [ErrorState] INTEGER NULL, 
    [ErrorProcedure] TEXT NULL, 
    [ErrorLine] INTEGER NULL, 
    [ErrorMessage] TEXT NOT NULL
);

CREATE TABLE [BuildVersion](
    [SystemInformationID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [Database Version] TEXT NOT NULL, 
    [VersionDate] DATETIME NOT NULL, 
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE [Address](
    [AddressID] INTEGER PRIMARY KEY,
    [AddressLine1] TEXT NOT NULL, 
    [AddressLine2] TEXT NULL, 
    [City] TEXT NOT NULL, 
    [StateProvince] TEXT NOT NULL,
	[CountryRegion] TEXT NOT NULL,
    [PostalCode] TEXT NOT NULL, 
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE [Customer](
    [CustomerID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [NameStyle] INTEGER NOT NULL DEFAULT (0),
    [Title] TEXT NULL, 
    [FirstName] TEXT NOT NULL,
    [MiddleName] TEXT NULL,
    [LastName] TEXT NOT NULL,
    [Suffix] TEXT NULL, 
	[CompanyName] TEXT NULL,
	[SalesPerson] TEXT,
    [EmailAddress] TEXT NULL, 
    [Phone] TEXT NULL, 
    [PasswordHash] TEXT NOT NULL, 
    [PasswordSalt] TEXT NOT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE [CustomerAddress](
	[CustomerID] INTEGER  NOT NULL,
	[AddressID] INTEGER NOT NULL,
	[AddressType] TEXT NOT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')),
	PRIMARY KEY ([CustomerID], [AddressID]),
    FOREIGN KEY ([CustomerID]) REFERENCES [Customer](CustomerID),
    FOREIGN KEY ([AddressID]) REFERENCES [Address](AddressID)
);

CREATE TABLE [Product](
    [ProductID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [Name] TEXT UNIQUE NOT NULL,
    [ProductNumber] TEXT UNIQUE NOT NULL, 
    [Color] TEXT NULL, 
    [StandardCost] INTEGER NOT NULL,
    [ListPrice] INTEGER NOT NULL,
    [Size] TEXT NULL, 
    [Weight] INTEGER NULL,
    [ProductCategoryID] INTEGER NULL,
    [ProductModelID] INTEGER NULL,
    [SellStartDate] DATETIME NOT NULL,
    [SellEndDate] DATETIME NULL,
    [DiscontinuedDate] DATETIME NULL,
    [ThumbNailPhoto] BLOB NULL,
    [ThumbnailPhotoFileName] TEXT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY ([ProductModelID]) REFERENCES [ProductModel](ProductModelID),
    FOREIGN KEY ([ProductCategoryID]) REFERENCES [ProductCategory](ProductCategoryID)
);

CREATE TABLE [ProductCategory](
    [ProductCategoryID] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ParentProductCategoryID] INTEGER NULL,
    [Name] TEXT UNIQUE NOT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY ([ParentProductCategoryID]) REFERENCES [ProductCategory](ProductCategoryID)
);

CREATE TABLE [ProductDescription](
    [ProductDescriptionID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [Description] TEXT NOT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')) 
);

CREATE TABLE [ProductModel](
    [ProductModelID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [Name] TEXT UNIQUE NOT NULL,
    [CatalogDescription] TEXT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')) 
);

CREATE TABLE [ProductModelProductDescription](
    [ProductModelID] INTEGER NOT NULL,
    [ProductDescriptionID] INTEGER NOT NULL,
    [Culture] TEXT NOT NULL, 
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')),
	PRIMARY KEY ([ProductModelID], [ProductDescriptionID], [Culture]),
    FOREIGN KEY ([ProductDescriptionID]) REFERENCES [ProductDescription](ProductDescriptionID),
    FOREIGN KEY ([ProductModelID]) REFERENCES [ProductModel](ProductModelID)
);

CREATE TABLE [SalesOrderDetail](
    [SalesOrderID] INTEGER NOT NULL,
    [SalesOrderDetailID] INTEGER IDENTITY (1, 1) NOT NULL,
    [OrderQty] INTEGER NOT NULL,
    [ProductID] INTEGER NOT NULL,
    [UnitPrice] INTEGER NOT NULL,
    [UnitPriceDiscount] INTEGER NOT NULL DEFAULT (0.0),
    [LineTotal] INTEGER NOT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')),
	PRIMARY KEY ([SalesOrderID], [SalesOrderDetailID]),
    FOREIGN KEY ([SalesOrderID]) REFERENCES [SalesOrderHeader](SalesOrderID),
    FOREIGN KEY ([ProductID]) REFERENCES [Product](ProductID)
);

CREATE TABLE [SalesOrderHeader](
    [SalesOrderID] INTEGER PRIMARY KEY AUTOINCREMENT,
    [RevisionNumber] INTEGER NOT NULL DEFAULT (0),
    [OrderDate] DATETIME NOT NULL CONSTRAINT [DF_SalesOrderHeader_OrderDate] DEFAULT (datetime('now')),
    [DueDate] DATETIME NOT NULL,
    [ShipDate] DATETIME NULL,
    [Status] INTEGER NOT NULL DEFAULT (1),
    [OnlineOrderFlag] INTEGER NOT NULL DEFAULT (1),
    [SalesOrderNumber] TEXT UNIQUE NOT NULL, 
    [PurchaseOrderNumber] INTEGER NULL,
    [AccountNumber] TEXT NULL,
    [CustomerID] INTEGER NOT NULL,
	[ShipToAddressID] int,
	[BillToAddressID] int,
    [ShipMethod] TEXT NOT NULL,
    [CreditCardApprovalCode] TEXT NULL,    
    [SubTotal] INTEGER NOT NULL DEFAULT (0.00),
    [TaxAmt] INTEGER NOT NULL DEFAULT (0.00),
    [Freight] INTEGER NOT NULL DEFAULT (0.00),
    [TotalDue] INTEGER NOT NULL,
    [Comment] TEXT NULL,
    [rowguid] TEXT UNIQUE NOT NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY ([CustomerID]) REFERENCES [Customer](CustomerID),
    FOREIGN KEY ([ShipToAddressID]) REFERENCES [Address](AddressID),
    FOREIGN KEY ([BillToAddressID]) REFERENCES [Address](AddressID)
);

.separator \t 
.import Address.csv Address
.import BuildVersion.csv BuildVersion
.import Customer.csv Customer
.import CustomerAddress.csv CustomerAddress
.import Product.csv Product
.import ProductCategory.csv ProductCategory
.import ProductDescription.csv ProductDescription
.import ProductModel.csv ProductModel
.import ProductModelProductDescription.csv ProductModelProductDescription
.import SalesOrderDetail.csv SalesOrderDetail
.import SalesOrderHeader.csv SalesOrderHeader

CREATE INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion] 
	ON [Address] ([AddressLine1], [AddressLine2], [City], [StateProvince], [PostalCode], [CountryRegion]);
CREATE INDEX [IX_Address_StateProvince] ON [Address]([StateProvince]);

CREATE INDEX [IX_Customer_EmailAddress] ON [Customer]([EmailAddress]);

CREATE INDEX [IX_SalesOrderDetail_ProductID] ON [SalesOrderDetail]([ProductID]);

CREATE INDEX [IX_SalesOrderHeader_CustomerID] ON [SalesOrderHeader]([CustomerID]);

PRAGMA foreign_keys=true;

VACUUM;