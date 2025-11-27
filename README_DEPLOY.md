# Hướng dẫn triển khai (Netlify + Render)

Tài liệu này hướng dẫn cách triển khai frontend lên Netlify (miễn phí) và backend Flask lên Render (miễn phí với giới hạn).

## Tổng quan
- Backend: Flask app, entrypoint `app:app`, start bằng `gunicorn app:app`.
- Frontend: trang tĩnh (`index.html` trong repo root) — deploy lên Netlify.

## Thay đổi đã thực hiện trong repo
- Thêm `_redirects` để Netlify phục vụ `index.html` cho SPA routes (`/* /index.html 200`).
- Thêm `netlify.toml` (minimal) để cấu hình publish dir.
- Thêm `Procfile` chứa `web: gunicorn app:app` để tiện chạy trên dịch vụ khác.
- Cập nhật `render.yaml` để thêm biến môi trường `DATABASE_URL` (người dùng cần điền giá trị).

## Chuẩn bị môi trường local (PowerShell)
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

Chạy bằng gunicorn (local):
```powershell
gunicorn app:app
```

## Triển khai backend lên Render
1. Đăng nhập vào https://render.com và kết nối GitHub/GitLab/Bitbucket.
2. Tạo một **New Web Service**:
   - Environment: `Python`
   - Build command: `pip install -r requirements.txt` (render.yaml có sẵn)
   - Start command: `gunicorn app:app` (render.yaml có sẵn)
3. Trong phần Environment Variables của service, thêm:
   - `JWT_SECRET_KEY`: đặt một chuỗi bí mật (hoặc để Render generate nếu bật).
   - `DATABASE_URL`: Set giá trị của Postgres managed DB nếu bạn muốn dữ liệu bền.

### Lưu ý về database
- **Không dùng SQLite cho production trên Render.** Filesystem của instance có thể ephemeral (bị reset khi redeploy hoặc khi instance tắt).
- Tạo một **Managed Postgres** trên Render (Dashboard → Databases → Create PostgreSQL) và copy `DATABASE_URL` vào biến môi trường `DATABASE_URL` của backend service.

## Triển khai frontend lên Netlify
1. Đăng nhập vào https://app.netlify.com/ và chọn `New site from Git`.
2. Chọn repository và branch muốn deploy.
3. Build command: để trống (nếu project chỉ là static HTML). Nếu bạn dùng React/Vue, điền `npm run build`.
4. Publish directory: `/` (project root) hoặc `dist/` nếu bạn có build step.
5. Netlify sẽ deploy; nếu site là SPA, file `_redirects` đã được thêm để xử lý client-side routes.

### Runtime configuration (đóng vai trò quan trọng khi frontend tĩnh)

Để frontend gọi đúng backend sau khi deploy (domain Render), bạn nên tạo một file runtime `runtime-config.js` chứa:

```js
window.__API_URL__ = "https://your-backend.onrender.com";
```

Netlify: bạn có 2 cách để làm điều này:

- Cách 1 (recommended): **Tạo file động từ biến môi trường trong Netlify build**. Trong `Site settings > Build & deploy > Environment` thêm biến `RENDER_BACKEND_URL` với giá trị URL backend của bạn (ví dụ `https://expense-tracker-backend.onrender.com`). Rồi trong `Build settings` đặt `Build command` (hoặc prepend) một lệnh tạo file trước khi build:

```bash
sh -lc "echo \"window.__API_URL__='${RENDER_BACKEND_URL:-https://your-backend.onrender.com}'\" > runtime-config.js"
```

Lệnh này tạo `runtime-config.js` ở thư mục project root trước bước build, và Netlify sẽ include file đó trong site. Đảm bảo `runtime-config.js` được bao gồm trong `publish` directory (mặc định là root cho repo này).

- Cách 2 (ít tự động hơn): **Commit** một file `runtime-config.js` vào repo (không an toàn cho production secrets) hoặc dùng Netlify UI để thêm file thủ công.

Khuyến nghị: dùng cách 1 để không commit URL vào mã nguồn và dễ thay đổi giữa các environment (staging/production).

### Bổ sung HTML
Đã thêm `runtime-config.example.js` vào repo như một ví dụ. Frontend đã được cập nhật để đọc `window.__API_URL__` nếu có. Đảm bảo file `runtime-config.js` (được tạo trong bước build) được load trước các script nội bộ: một thẻ `<script src="/runtime-config.js"></script>` đã được chèn vào các trang HTML chính.


## Cấu hình API endpoint trên frontend
- Nếu frontend gọi API bằng đường dẫn tương đối `/api/...`, khi deploy ở domain khác (Netlify), bạn cần thay bằng absolute URL backend, ví dụ `https://your-backend.onrender.com/api/...`.
- Thay vào code frontend hoặc sử dụng biến môi trường build-time (ví dụ `REACT_APP_API_URL`) để inject URL backend.

## CORS
- Backend đã bật `Flask-CORS` với cấu hình mặc định (cho phép mọi origin). Nếu muốn giới hạn, chỉnh trong `app.py`:
```py
from flask_cors import CORS
CORS(app, origins=["https://your-netlify-site.netlify.app"])
```

## Bảo mật & vận hành
- Sử dụng `JWT_SECRET_KEY` mạnh.
- Đảm bảo `DATABASE_URL` không nằm trong mã nguồn.
- Backup database (Render managed Postgres có tùy chọn snapshot/backup).

## Muốn tôi làm tiếp? (Chọn)
- 1) Tôi có thể giúp bạn cập nhật các endpoint trong HTML/JS để dùng `RENDER_BACKEND_URL`.
- 2) Tôi có thể tạo một mẫu `.env.example` hoặc script deploy.
- 3) Hướng dẫn từng bước kết nối repo với Render/Netlify (với screenshot/chi tiết).

---
> Ghi chú: Tôi không thể tự động tạo service trên Render/Netlify thay bạn vì cần xác thực vào tài khoản của bạn — nhưng đã chuẩn bị mọi file cần thiết để bạn chỉ việc push repo lên Git và kết nối.
# Hướng dẫn Deploy lên Render

## 1. Chuẩn bị

- Tạo tài khoản GitHub (nếu chưa có)
- Tạo tài khoản Render tại https://render.com

## 2. Push code lên GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/expense-tracker.git
git push -u origin main
```

## 3. Deploy Backend lên Render

1. Đăng nhập vào https://render.com
2. Click "New +" → "Web Service"
3. Connect GitHub repository của bạn
4. Cấu hình:
   - **Name**: expense-tracker-backend
   - **Environment**: Python 3
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app:app`
   - **Plan**: Free
5. Click "Create Web Service"
6. Đợi deploy xong, copy URL (ví dụ: https://expense-tracker-backend.onrender.com)

## 4. Deploy Frontend lên Render (Static Site)

1. Click "New +" → "Static Site"
2. Connect cùng GitHub repository
3. Cấu hình:
   - **Name**: expense-tracker-frontend
   - **Build Command**: (để trống)
   - **Publish Directory**: `.`
4. Click "Create Static Site"
5. Copy URL frontend (ví dụ: https://expense-tracker-frontend.onrender.com)

## 5. Cập nhật API URL trong Frontend

Thay tất cả `http://localhost:5000` trong các file HTML thành URL backend từ Render:

- `index.html`
- `admin.html`
- `ocr_hoadon.html`

Ví dụ:
```javascript
// Thay đổi từ:
const API_URL = 'http://localhost:5000/api';

// Thành:
const API_URL = 'https://expense-tracker-backend.onrender.com/api';
```

## 6. Commit và Push lại

```bash
git add .
git commit -m "Update API URL for production"
git push
```

Render sẽ tự động deploy lại!

## 7. Truy cập ứng dụng

- Frontend: https://expense-tracker-frontend.onrender.com
- Backend API: https://expense-tracker-backend.onrender.com/api

## Lưu ý

- Free tier của Render sẽ sleep sau 15 phút không hoạt động
- Lần đầu truy cập sau khi sleep sẽ mất ~30 giây để wake up
- Database SQLite sẽ bị reset mỗi khi deploy lại (nên dùng PostgreSQL cho production)
