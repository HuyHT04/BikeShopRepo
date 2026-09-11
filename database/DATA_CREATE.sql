/* BikeShop SWP391 - SQL Server 2022 schema
   Run with an account allowed to create a database. The script is rerunnable.
   Account roles are Customer, Staff and Admin. Guest means unauthenticated and
   is therefore not stored in AspNetRoles. Role rows are seeded by DATA_INSERT.sql. */

IF DB_ID(N'BikeShopSWP391') IS NULL
    CREATE DATABASE BikeShopSWP391;
GO

USE BikeShopSWP391;
GO

IF OBJECT_ID(N'dbo.AspNetRoles', N'U') IS NULL
CREATE TABLE dbo.AspNetRoles (
    Id nvarchar(450) NOT NULL CONSTRAINT PK_AspNetRoles PRIMARY KEY,
    Name nvarchar(256) NULL,
    NormalizedName nvarchar(256) NULL,
    ConcurrencyStamp nvarchar(max) NULL
);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'RoleNameIndex')
    CREATE UNIQUE INDEX RoleNameIndex ON dbo.AspNetRoles(NormalizedName) WHERE NormalizedName IS NOT NULL;
GO

IF OBJECT_ID(N'dbo.AspNetUsers', N'U') IS NULL
CREATE TABLE dbo.AspNetUsers (
    Id nvarchar(450) NOT NULL CONSTRAINT PK_AspNetUsers PRIMARY KEY,
    FullName nvarchar(150) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_AspNetUsers_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_AspNetUsers_CreatedAt DEFAULT SYSUTCDATETIME(),
    UserName nvarchar(256) NULL,
    NormalizedUserName nvarchar(256) NULL,
    Email nvarchar(256) NULL,
    NormalizedEmail nvarchar(256) NULL,
    EmailConfirmed bit NOT NULL CONSTRAINT DF_AspNetUsers_EmailConfirmed DEFAULT 0,
    PasswordHash nvarchar(max) NULL,
    SecurityStamp nvarchar(max) NULL,
    ConcurrencyStamp nvarchar(max) NULL,
    PhoneNumber nvarchar(max) NULL,
    PhoneNumberConfirmed bit NOT NULL CONSTRAINT DF_AspNetUsers_PhoneConfirmed DEFAULT 0,
    TwoFactorEnabled bit NOT NULL CONSTRAINT DF_AspNetUsers_TwoFactor DEFAULT 0,
    LockoutEnd datetimeoffset NULL,
    LockoutEnabled bit NOT NULL CONSTRAINT DF_AspNetUsers_Lockout DEFAULT 0,
    AccessFailedCount int NOT NULL CONSTRAINT DF_AspNetUsers_AccessFailed DEFAULT 0
);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UserNameIndex')
    CREATE UNIQUE INDEX UserNameIndex ON dbo.AspNetUsers(NormalizedUserName) WHERE NormalizedUserName IS NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'EmailIndex')
    CREATE INDEX EmailIndex ON dbo.AspNetUsers(NormalizedEmail);
GO

IF OBJECT_ID(N'dbo.AspNetRoleClaims', N'U') IS NULL
CREATE TABLE dbo.AspNetRoleClaims (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_AspNetRoleClaims PRIMARY KEY,
    RoleId nvarchar(450) NOT NULL,
    ClaimType nvarchar(max) NULL,
    ClaimValue nvarchar(max) NULL,
    CONSTRAINT FK_AspNetRoleClaims_Roles FOREIGN KEY (RoleId) REFERENCES dbo.AspNetRoles(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.AspNetUserClaims', N'U') IS NULL
CREATE TABLE dbo.AspNetUserClaims (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_AspNetUserClaims PRIMARY KEY,
    UserId nvarchar(450) NOT NULL,
    ClaimType nvarchar(max) NULL,
    ClaimValue nvarchar(max) NULL,
    CONSTRAINT FK_AspNetUserClaims_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.AspNetUserLogins', N'U') IS NULL
CREATE TABLE dbo.AspNetUserLogins (
    LoginProvider nvarchar(450) NOT NULL,
    ProviderKey nvarchar(450) NOT NULL,
    ProviderDisplayName nvarchar(max) NULL,
    UserId nvarchar(450) NOT NULL,
    CONSTRAINT PK_AspNetUserLogins PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_AspNetUserLogins_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.AspNetUserRoles', N'U') IS NULL
CREATE TABLE dbo.AspNetUserRoles (
    UserId nvarchar(450) NOT NULL,
    RoleId nvarchar(450) NOT NULL,
    CONSTRAINT PK_AspNetUserRoles PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_AspNetUserRoles_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_AspNetUserRoles_Roles FOREIGN KEY (RoleId) REFERENCES dbo.AspNetRoles(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.AspNetUserTokens', N'U') IS NULL
CREATE TABLE dbo.AspNetUserTokens (
    UserId nvarchar(450) NOT NULL,
    LoginProvider nvarchar(450) NOT NULL,
    Name nvarchar(450) NOT NULL,
    Value nvarchar(max) NULL,
    CONSTRAINT PK_AspNetUserTokens PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT FK_AspNetUserTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
CREATE TABLE dbo.Categories (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Slug varchar(120) NOT NULL,
    Description nvarchar(500) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Categories_IsActive DEFAULT 1,
    CONSTRAINT UQ_Categories_Slug UNIQUE (Slug)
);
GO

IF OBJECT_ID(N'dbo.Brands', N'U') IS NULL
CREATE TABLE dbo.Brands (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Brands PRIMARY KEY,
    Name nvarchar(100) NOT NULL,
    Slug varchar(120) NOT NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Brands_IsActive DEFAULT 1,
    CONSTRAINT UQ_Brands_Slug UNIQUE (Slug)
);
GO

IF OBJECT_ID(N'dbo.Products', N'U') IS NULL
CREATE TABLE dbo.Products (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Products PRIMARY KEY,
    CategoryId int NOT NULL,
    BrandId int NOT NULL,
    Name nvarchar(200) NOT NULL,
    Slug varchar(220) NOT NULL,
    Description nvarchar(max) NULL,
    IsActive bit NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Products_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Products_Slug UNIQUE (Slug),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(Id),
    CONSTRAINT FK_Products_Brands FOREIGN KEY (BrandId) REFERENCES dbo.Brands(Id)
);
GO

IF OBJECT_ID(N'dbo.ProductVariants', N'U') IS NULL
CREATE TABLE dbo.ProductVariants (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductVariants PRIMARY KEY,
    ProductId int NOT NULL,
    Sku varchar(50) NOT NULL,
    Color nvarchar(50) NULL,
    Size nvarchar(30) NULL,
    Price decimal(18,2) NOT NULL,
    StockQuantity int NOT NULL CONSTRAINT DF_ProductVariants_Stock DEFAULT 0,
    IsActive bit NOT NULL CONSTRAINT DF_ProductVariants_IsActive DEFAULT 1,
    RowVersion rowversion NOT NULL,
    CONSTRAINT UQ_ProductVariants_Sku UNIQUE (Sku),
    CONSTRAINT CK_ProductVariants_Price CHECK (Price >= 0),
    CONSTRAINT CK_ProductVariants_Stock CHECK (StockQuantity >= 0),
    CONSTRAINT FK_ProductVariants_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(Id)
);
GO

IF OBJECT_ID(N'dbo.ProductImages', N'U') IS NULL
CREATE TABLE dbo.ProductImages (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductImages PRIMARY KEY,
    ProductId int NOT NULL,
    ImageUrl nvarchar(500) NOT NULL,
    AltText nvarchar(200) NULL,
    SortOrder int NOT NULL CONSTRAINT DF_ProductImages_Sort DEFAULT 0,
    CONSTRAINT FK_ProductImages_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.InventoryTransactions', N'U') IS NULL
CREATE TABLE dbo.InventoryTransactions (
    Id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_InventoryTransactions PRIMARY KEY,
    ProductVariantId int NOT NULL,
    QuantityChange int NOT NULL,
    Reason nvarchar(100) NOT NULL,
    ReferenceCode nvarchar(50) NULL,
    CreatedByUserId nvarchar(450) NULL,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_InventoryTransactions_CreatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_InventoryTransactions_Quantity CHECK (QuantityChange <> 0),
    CONSTRAINT FK_InventoryTransactions_Variants FOREIGN KEY (ProductVariantId) REFERENCES dbo.ProductVariants(Id),
    CONSTRAINT FK_InventoryTransactions_Users FOREIGN KEY (CreatedByUserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

IF OBJECT_ID(N'dbo.Addresses', N'U') IS NULL
CREATE TABLE dbo.Addresses (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Addresses PRIMARY KEY,
    UserId nvarchar(450) NOT NULL,
    RecipientName nvarchar(120) NOT NULL,
    PhoneNumber varchar(20) NOT NULL,
    AddressLine nvarchar(250) NOT NULL,
    Ward nvarchar(100) NOT NULL,
    District nvarchar(100) NOT NULL,
    Province nvarchar(100) NOT NULL,
    IsDefault bit NOT NULL CONSTRAINT DF_Addresses_IsDefault DEFAULT 0,
    CONSTRAINT FK_Addresses_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.Carts', N'U') IS NULL
CREATE TABLE dbo.Carts (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Carts PRIMARY KEY,
    UserId nvarchar(450) NOT NULL,
    UpdatedAt datetime2 NOT NULL CONSTRAINT DF_Carts_UpdatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Carts_User UNIQUE (UserId),
    CONSTRAINT FK_Carts_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id) ON DELETE CASCADE
);
GO

IF OBJECT_ID(N'dbo.CartItems', N'U') IS NULL
CREATE TABLE dbo.CartItems (
    Id int IDENTITY(1,1) NOT NULL CONSTRAINT PK_CartItems PRIMARY KEY,
    CartId int NOT NULL,
    ProductVariantId int NOT NULL,
    Quantity int NOT NULL,
    CONSTRAINT UQ_CartItems_CartVariant UNIQUE (CartId, ProductVariantId),
    CONSTRAINT CK_CartItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT FK_CartItems_Carts FOREIGN KEY (CartId) REFERENCES dbo.Carts(Id) ON DELETE CASCADE,
    CONSTRAINT FK_CartItems_Variants FOREIGN KEY (ProductVariantId) REFERENCES dbo.ProductVariants(Id)
);
GO

IF OBJECT_ID(N'dbo.Orders', N'U') IS NULL
CREATE TABLE dbo.Orders (
    Id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_Orders PRIMARY KEY,
    OrderCode varchar(30) NOT NULL,
    UserId nvarchar(450) NOT NULL,
    Status int NOT NULL CONSTRAINT DF_Orders_Status DEFAULT 0,
    RecipientName nvarchar(120) NOT NULL,
    PhoneNumber varchar(20) NOT NULL,
    ShippingAddress nvarchar(600) NOT NULL,
    Subtotal decimal(18,2) NOT NULL,
    ShippingFee decimal(18,2) NOT NULL CONSTRAINT DF_Orders_ShippingFee DEFAULT 0,
    TotalAmount decimal(18,2) NOT NULL,
    CustomerNote nvarchar(500) NULL,
    CreatedAt datetime2 NOT NULL CONSTRAINT DF_Orders_CreatedAt DEFAULT SYSUTCDATETIME(),
    UpdatedAt datetime2 NOT NULL CONSTRAINT DF_Orders_UpdatedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Orders_OrderCode UNIQUE (OrderCode),
    CONSTRAINT CK_Orders_Status CHECK (Status BETWEEN 0 AND 5),
    CONSTRAINT CK_Orders_Amounts CHECK (Subtotal >= 0 AND ShippingFee >= 0 AND TotalAmount = Subtotal + ShippingFee),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

IF OBJECT_ID(N'dbo.OrderItems', N'U') IS NULL
CREATE TABLE dbo.OrderItems (
    Id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderId bigint NOT NULL,
    ProductVariantId int NOT NULL,
    ProductName nvarchar(200) NOT NULL,
    Sku varchar(50) NOT NULL,
    VariantDescription nvarchar(120) NULL,
    UnitPrice decimal(18,2) NOT NULL,
    Quantity int NOT NULL,
    LineTotal decimal(18,2) NOT NULL,
    CONSTRAINT CK_OrderItems_Value CHECK (UnitPrice >= 0 AND Quantity > 0 AND LineTotal = UnitPrice * Quantity),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(Id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_Variants FOREIGN KEY (ProductVariantId) REFERENCES dbo.ProductVariants(Id)
);
GO

IF OBJECT_ID(N'dbo.OrderStatusHistories', N'U') IS NULL
CREATE TABLE dbo.OrderStatusHistories (
    Id bigint IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderStatusHistories PRIMARY KEY,
    OrderId bigint NOT NULL,
    OldStatus int NOT NULL,
    NewStatus int NOT NULL,
    Note nvarchar(500) NULL,
    ChangedByUserId nvarchar(450) NULL,
    ChangedAt datetime2 NOT NULL CONSTRAINT DF_OrderStatusHistories_ChangedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_OrderStatusHistories_OldStatus CHECK (OldStatus BETWEEN 0 AND 5),
    CONSTRAINT CK_OrderStatusHistories_NewStatus CHECK (NewStatus BETWEEN 0 AND 5),
    CONSTRAINT FK_OrderStatusHistories_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(Id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderStatusHistories_Users FOREIGN KEY (ChangedByUserId) REFERENCES dbo.AspNetUsers(Id)
);
GO

CREATE OR ALTER VIEW dbo.vw_LowStockProducts AS
SELECT p.Id AS ProductId, p.Name AS ProductName, v.Id AS VariantId, v.Sku, v.Color, v.Size, v.StockQuantity
FROM dbo.Products p
JOIN dbo.ProductVariants v ON v.ProductId = p.Id
WHERE p.IsActive = 1 AND v.IsActive = 1 AND v.StockQuantity <= 5;
GO

PRINT N'BikeShopSWP391 schema is ready for Customer, Staff and Admin accounts. Run DATA_INSERT.sql to seed the roles.';
GO
