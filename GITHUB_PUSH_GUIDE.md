# Hướng dẫn Push Code lên GitHub

## Cách 1: Chạy Script Tự Động (DỄ NHẤT)

### Bước 1: Chạy file batch
```
1. Mở File Explorer
2. Vào D:\LTM_FINALQ
3. Double-click: push_to_github.bat
```

### Bước 2: Nhập GitHub credentials
Khi hỏi:
- **Username**: MinhAnh248
- **Password**: Dùng Personal Access Token (xem bên dưới)

### Bước 3: Chờ hoàn thành
Script sẽ tự động:
- ✅ Khởi tạo git repository
- ✅ Thêm tất cả file
- ✅ Commit với message
- ✅ Thêm remote repository
- ✅ Push lên GitHub

---

## Cách 2: Chạy Command Thủ Công

### Bước 1: Mở Command Prompt
```cmd
Win + R
Gõ: cmd
Nhấn Enter
```

### Bước 2: Vào thư mục dự án
```cmd
cd D:\LTM_FINALQ
```

### Bước 3: Chạy các lệnh sau lần lượt

```cmd
# Khởi tạo git
git init

# Thêm tất cả file
git add .

# Commit
git commit -m "Initial commit - Expense Tracker System"

# Thêm remote
git remote add origin https://github.com/MinhAnh248/LTM_FINALQ2.git

# Đổi branch
git branch -M main

# Push lên GitHub
git push -u origin main
```

---

## Tạo Personal Access Token (Nếu cần)

### Bước 1: Vào GitHub Settings
```
https://github.com/settings/tokens
```

### Bước 2: Click "Generate new token" → "Generate new token (classic)"

### Bước 3: Điền thông tin
- **Token name**: git-push-token
- **Expiration**: 90 days
- **Scopes**: ✅ Tick "repo"

### Bước 4: Click "Generate token"

### Bước 5: Copy token
⚠️ Chỉ hiển thị 1 lần! Copy ngay!

### Bước 6: Dùng token làm password
Khi git hỏi password, paste token này

---

## Kiểm Tra Kết Quả

Vào: https://github.com/MinhAnh248/LTM_FINALQ2

Bạn sẽ thấy:
- ✅ Tất cả file đã được push
- ✅ Commit message
- ✅ Branch main

---

## Lần Sau (Cập Nhật Code)

```cmd
cd D:\LTM_FINALQ
git add .
git commit -m "Update: [mô tả thay đổi]"
git push
```

---

## Troubleshooting

### Lỗi: "fatal: not a git repository"
```cmd
git init
```

### Lỗi: "remote origin already exists"
```cmd
git remote remove origin
git remote add origin https://github.com/MinhAnh248/LTM_FINALQ2.git
```

### Lỗi: "Authentication failed"
- Dùng Personal Access Token thay vì password
- Hoặc setup SSH key

### Lỗi: "branch 'main' does not exist"
```cmd
git branch -M main
```

---

## Xóa Repository Cũ (Nếu cần)

Nếu muốn xóa và tạo lại:

```cmd
# Xóa .git folder
rmdir /s /q .git

# Khởi tạo lại
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/MinhAnh248/LTM_FINALQ2.git
git branch -M main
git push -u origin main
```

---

## Cần Giúp?

Nếu gặp lỗi, chạy lệnh này để xem chi tiết:
```cmd
git status
```

Hoặc liên hệ support GitHub: https://github.com/contact
