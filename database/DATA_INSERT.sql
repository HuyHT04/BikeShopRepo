/* BikeShop SWP391 - reference data and demo catalog
   Run after DATA_CREATE.sql. This script is rerunnable. */

USE BikeShopSWP391;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.AspNetRoles WHERE NormalizedName = N'ADMIN')
    INSERT dbo.AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (N'ROLE-ADMIN', N'Admin', N'ADMIN', NEWID());
IF NOT EXISTS (SELECT 1 FROM dbo.AspNetRoles WHERE NormalizedName = N'STAFF')
    INSERT dbo.AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (N'ROLE-STAFF', N'Staff', N'STAFF', NEWID());
IF NOT EXISTS (SELECT 1 FROM dbo.AspNetRoles WHERE NormalizedName = N'CUSTOMER')
    INSERT dbo.AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (N'ROLE-CUSTOMER', N'Customer', N'CUSTOMER', NEWID());
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE Slug = 'xe-dap-dia-hinh')
    INSERT dbo.Categories (Name, Slug, Description) VALUES
    (N'Xe đạp địa hình', 'xe-dap-dia-hinh', N'Xe đạp MTB dùng cho đường hỗn hợp.'),
    (N'Xe đạp đường phố', 'xe-dap-duong-pho', N'Xe đạp tiện dụng cho đi học và đi làm.'),
    (N'Phụ kiện', 'phu-kien', N'Mũ bảo hiểm, đèn, khóa và phụ kiện cơ bản.');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Brands WHERE Slug = 'giant')
    INSERT dbo.Brands (Name, Slug) VALUES
    (N'Giant', 'giant'),
    (N'Liv', 'liv'),
    (N'BikeShop', 'bikeshop');
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE Slug = 'giant-talon-demo')
BEGIN
    INSERT dbo.Products (CategoryId, BrandId, Name, Slug, Description)
    SELECT c.Id, b.Id, N'Giant Talon Demo', 'giant-talon-demo', N'Mẫu xe địa hình dùng làm dữ liệu demo.'
    FROM dbo.Categories c CROSS JOIN dbo.Brands b
    WHERE c.Slug = 'xe-dap-dia-hinh' AND b.Slug = 'giant';

    INSERT dbo.Products (CategoryId, BrandId, Name, Slug, Description)
    SELECT c.Id, b.Id, N'Liv Alight Demo', 'liv-alight-demo', N'Mẫu xe đường phố dùng làm dữ liệu demo.'
    FROM dbo.Categories c CROSS JOIN dbo.Brands b
    WHERE c.Slug = 'xe-dap-duong-pho' AND b.Slug = 'liv';

    INSERT dbo.Products (CategoryId, BrandId, Name, Slug, Description)
    SELECT c.Id, b.Id, N'Mũ bảo hiểm Urban', 'mu-bao-hiem-urban', N'Mũ bảo hiểm cơ bản dùng làm dữ liệu demo.'
    FROM dbo.Categories c CROSS JOIN dbo.Brands b
    WHERE c.Slug = 'phu-kien' AND b.Slug = 'bikeshop';
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.ProductVariants WHERE Sku = 'TALON-BLK-M')
BEGIN
    INSERT dbo.ProductVariants (ProductId, Sku, Color, Size, Price, StockQuantity)
    SELECT Id, 'TALON-BLK-M', N'Đen', 'M', 12500000, 8 FROM dbo.Products WHERE Slug = 'giant-talon-demo';
    INSERT dbo.ProductVariants (ProductId, Sku, Color, Size, Price, StockQuantity)
    SELECT Id, 'TALON-BLU-L', N'Xanh', 'L', 12900000, 4 FROM dbo.Products WHERE Slug = 'giant-talon-demo';
    INSERT dbo.ProductVariants (ProductId, Sku, Color, Size, Price, StockQuantity)
    SELECT Id, 'ALIGHT-WHT-S', N'Trắng', 'S', 8900000, 6 FROM dbo.Products WHERE Slug = 'liv-alight-demo';
    INSERT dbo.ProductVariants (ProductId, Sku, Color, Size, Price, StockQuantity)
    SELECT Id, 'HELMET-BLK-M', N'Đen', 'M', 650000, 20 FROM dbo.Products WHERE Slug = 'mu-bao-hiem-urban';
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.ProductImages)
BEGIN
    INSERT dbo.ProductImages (ProductId, ImageUrl, AltText, SortOrder)
    SELECT Id, '/images/products/talon-demo.webp', N'Giant Talon Demo', 1 FROM dbo.Products WHERE Slug = 'giant-talon-demo';
    INSERT dbo.ProductImages (ProductId, ImageUrl, AltText, SortOrder)
    SELECT Id, '/images/products/alight-demo.webp', N'Liv Alight Demo', 1 FROM dbo.Products WHERE Slug = 'liv-alight-demo';
    INSERT dbo.ProductImages (ProductId, ImageUrl, AltText, SortOrder)
    SELECT Id, '/images/products/helmet-demo.webp', N'Mũ bảo hiểm Urban', 1 FROM dbo.Products WHERE Slug = 'mu-bao-hiem-urban';
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.InventoryTransactions WHERE Reason = N'INITIAL_STOCK')
    INSERT dbo.InventoryTransactions (ProductVariantId, QuantityChange, Reason, ReferenceCode)
    SELECT Id, StockQuantity, N'INITIAL_STOCK', N'SEED-001' FROM dbo.ProductVariants WHERE StockQuantity > 0;
GO

PRINT N'Admin, Staff, Customer roles and demo catalog data inserted. Guest is an unauthenticated visitor, not a database role. Create users through ASP.NET Core Identity so passwords are hashed correctly.';
GO
