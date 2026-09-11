# Quy ước làm việc

1. Nhận issue và ghi rõ acceptance criteria trước khi code.
2. Tạo nhánh `feature/<issue-id>-<ten-ngan>` từ `develop`.
3. Không commit mật khẩu, file database hoặc file cấu hình cá nhân.
4. Chạy `dotnet build` và `dotnet test` trước khi mở pull request.
5. Pull request cần ít nhất một thành viên review trước khi merge.
6. Một thay đổi database phải kèm migration và cập nhật tài liệu liên quan.

## Commit message

```text
feat(catalog): add product filtering
fix(cart): prevent quantity above stock
docs(srs): update checkout exception flow
```
