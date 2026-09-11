# BikeShop SWP391

Website bán xe đạp và phụ kiện đơn giản cho môn SWP391. Hệ thống dùng ASP.NET Core MVC, Razor Views, .NET 10, Entity Framework Core, ASP.NET Core Identity và SQL Server.

## Phạm vi chính

- Khách xem, tìm kiếm, lọc sản phẩm và chọn biến thể.
- Thành viên quản lý địa chỉ, giỏ hàng, đặt hàng COD và theo dõi đơn.
- Staff xử lý đơn hàng, cập nhật trạng thái và điều chỉnh tồn kho.
- Admin quản lý catalog, tài khoản nhân viên, phân quyền và dashboard.

Guest là khách chưa đăng nhập nên không được lưu như một role. Ba role tài khoản là `Customer`, `Staff` và `Admin`.

## Chuẩn bị

- .NET SDK `10.0.401` hoặc bản patch tương thích theo `global.json`.
- Visual Studio 2026 Community stable với workload ASP.NET and web development.
- SQL Server 2022 Express và SQL Server Management Studio 21.

## Chạy lần đầu

1. Kết nối SSMS tới `.\SQLEXPRESS`.
2. Chạy `database/DATA_CREATE.sql`, sau đó `database/DATA_INSERT.sql`.
3. Nếu instance khác, sửa `DefaultConnection` bằng User Secrets hoặc cấu hình local không commit.
4. Chạy `dotnet restore`, `dotnet build` và `dotnet run --project src/BikeShop.Web`.
5. Mở `/` để xem MVC và `/ProjectInfo` để xem Razor Page mẫu.

## Cấu trúc

- `BikeShop.Web`: MVC controllers, Razor Views, Razor Pages của Identity và static assets.
- `BikeShop.Application`: use cases, service interfaces, DTO và validation.
- `BikeShop.Domain`: entity, enum và business rules độc lập.
- `BikeShop.Infrastructure`: EF Core, Identity, SQL Server và tích hợp ngoài.
- `BikeShop.Tests`: unit/integration tests.
- `database`: script tạo schema và dữ liệu mẫu; data dictionary nằm trong tài liệu dự án.
- `docs`: tài liệu dự án và quy ước làm việc.

## Git workflow

`main` giữ bản demo ổn định, `develop` dùng để tích hợp, mỗi chức năng phát triển trong `feature/<issue-id>-<ten-ngan>`. Không push trực tiếp vào `main`.

## Nhóm

| Mã sinh viên | Thành viên |
|---|---|---|
| CE180233 | Nguyễn Phước Hậu |
| CE181481 | Hà Thanh Huy |
| CE191113 | Trần Vũ Khang |
| CE170443 | Huỳnh Vương Khánh |
| CE181583 | Phạm Đình Đăng Khoa |
