# CHỦ ĐỀ 6: BIỂU MẪU VÀ KIỂM TRA DỮ LIỆU ĐẦU VÀO TRONG FLUTTER
**Dự án môn học Lập Trình ĐNT - Tuần 13**  


---

## 📋 MỤC LỤC
1. [Giới thiệu dự án](#1-giới-thiệu-dự-án)
2. [Cấu trúc mã nguồn](#2-cấu-trúc-mã-nguồn)
3. [Cơ sở lý thuyết trọng tâm](#3-cơ-sở-lý-thuyết-trọng-tâm)
4. [Các quy tắc kiểm tra dữ liệu (Validators)](#4-các-quy-tắc-kiểm-tra-dữ-liệu-validators)
5. [Demo trường hợp dữ liệu hợp lệ và không hợp lệ](#5-demo-trường-hợp-dữ-liệu-hợp-lệ-và-không-hợp-lệ)
6. [Hướng dẫn cài đặt & Chạy ứng dụng](#6-hướng-dẫn-cài-đặt--chạy-ứng-dụng)

---

## 1. GIỚI THIỆU DỰ ÁN
Ứng dụng minh họa chuyên sâu cho **Chủ đề 6: Biểu mẫu và kiểm tra dữ liệu đầu vào**, giải quyết bài toán nhập liệu hồ sơ sinh viên với đầy đủ các nghiệp vụ thực tế, bao gồm:
- **Biểu mẫu đăng ký đa trường:** Họ tên, Email, Số điện thoại Việt Nam, Mật khẩu đa cấp độ kèm thanh đo độ mạnh (Password Strength Meter), Xác nhận mật khẩu, Ngày sinh (DatePicker & kiểm tra độ tuổi ≥ 18), Chọn chuyên ngành (Dropdown), Giới tính (SegmentedButton Material 3) và Cam kết điều khoản (Checkbox).
- **Hệ thống nút bấm hỗ trợ thuyết trình 1-click:**
  - 🟢 **Nạp dữ liệu HỢP LỆ**: Tự động điền dữ liệu chuẩn để kiểm tra luồng thành công.
  - 🔴 **Nạp dữ liệu LỖI**: Tự động kích hoạt toàn bộ lỗi trên form để phân tích vi phạm.
  - 🔄 **Làm mới Form**: Xóa sạch trạng thái form.
- **Tập trung hoàn toàn vào biểu mẫu thực hành:** Giao diện trực tiếp, gọn gàng, không có thanh tab điều hướng bên dưới, giúp tập trung tối đa vào phần demo tương tác biểu mẫu.

---

## 2. CẤU TRÚC MÃ NGUỒN
Dự án được tổ chức theo kiến trúc phân tầng sạch (Clean Architecture), tách bạch giữa giao diện, logic kiểm tra và mô hình dữ liệu:

```
D:\Lập Trình ĐNT\chu-de-tuan13\
├── lib/
│   ├── core/
│   │   ├── models/
│   │   │   └── student_registration_model.dart  # Data Model đóng gói dữ liệu sau khi validate thành công
│   │   ├── theme/
│   │   │   └── app_theme.dart                   # Cấu hình giao diện Material 3, màu sắc & viền input
│   │   └── utils/
│   │       └── validators.dart                  # Toàn bộ hàm Regex & logic kiểm tra tính hợp lệ
│   ├── screens/
│   │   └── form_demo/
│   │       ├── form_demo_screen.dart            # Màn hình chính xử lý Form, Controller & FocusNode
│   │       └── widgets/
│   │           ├── custom_text_field.dart       # Widget tái sử dụng bọc TextFormField
│   │           ├── password_strength_meter.dart # Thanh đo độ mạnh mật khẩu theo thời gian thực
│   │           └── result_dialog.dart           # Hộp thoại tổng kết dữ liệu khi submit thành công
│   └── main.dart                                # Điểm khởi chạy ứng dụng (Entry point)
├── test/
│   └── validators_test.dart                     # 26 bài test tự động cho toàn bộ các hàm kiểm tra
└── pubspec.yaml                                 # Cấu hình gói và metadata dự án
```

---

## 3. CƠ SỞ LÝ THUYẾT TRỌNG TÂM

### 3.1. So sánh `TextField` vs `TextFormField`
- **TextField**: Là widget nhập văn bản độc lập cơ bản. Không tự động kết nối với widget cha `Form`. Nếu muốn kiểm tra lỗi, lập trình viên phải tự quản lý state và tự vẽ thông báo lỗi thủ công.
- **TextFormField**: Bọc quanh `TextField` và kế thừa từ `FormField<String>`. Tích hợp sẵn thuộc tính `validator`, `onSaved`, `autovalidateMode`, tự động tương tác với `FormState` khi gọi `formKey.currentState!.validate()`.

### 3.2. Quản lý trạng thái bằng `Form` và `GlobalKey<FormState>`
- `final _formKey = GlobalKey<FormState>();`
- **`validate()`**: Kích hoạt hàm `validator` của tất cả các `FormField` con. Trả về `true` khi tất cả đều trả về `null`.
- **`save()`**: Kích hoạt `onSaved` của tất cả các trường để gom dữ liệu.
- **`reset()`**: Xóa sạch toàn bộ thông báo lỗi và đưa các trường về giá trị mặc định.

### 3.3. Quản lý `TextEditingController` & `FocusNode`
- **TextEditingController**: Đọc/ghi giá trị của ô nhập liệu (`controller.text`), lắng nghe sự kiện gõ (`addListener`), xóa nội dung (`clear()`).
- **FocusNode**: Quản lý con trỏ soạn thảo. Tự động chuyển tiêu điểm sang ô kế tiếp khi nhấn Enter/Next trên bàn phím (`FocusScope.of(context).requestFocus(_nextFocus)`).
- **Tự động định vị lỗi (Error Focus Guidance)**: Khi bấm Submit thất bại, hệ thống tự động request focus vào ô lỗi đầu tiên để người dùng chỉnh sửa ngay lập tức.
- **Giải phóng bộ nhớ**: Toàn bộ controllers và focus nodes đều được gọi `.dispose()` trong `State.dispose()`.

---

## 4. CÁC QUY TẮC KIỂM TRA DỮ LIỆU (VALIDATORS)

| Trường dữ liệu | Quy tắc kiểm tra kỹ thuật | Trường hợp Không Hợp Lệ (Invalid) | Trường hợp Hợp Lệ (Valid) |
| :--- | :--- | :--- | :--- |
| **Họ và tên** | Regex `^[a-zA-ZÀ-ỹ\s]+$`, độ dài ≥ 3, tối thiểu 2 từ | `"An123"` (có số), `"An"` (1 từ) | `"Nguyễn Văn An"` |
| **Email** | Regex chuẩn RFC `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$` | `"an.nguyen_sai"` (thiếu @/domain) | `"nguyenvanan.it@gmail.com"` |
| **Số điện thoại** | 10 chữ số, thuộc các đầu số di động VN: `03, 05, 07, 08, 09` | `"0123456"` (7 số, sai đầu số) | `"0988123456"` |
| **Mật khẩu** | Độ dài ≥ 8, ít nhất 1 chữ hoa, 1 chữ thường, 1 số, 1 ký tự đặc biệt | `"123"` (quá ngắn, thiếu thành phần) | `"AnNguyen@2026"` |
| **Xác nhận MK** | `confirmPassword == passwordController.text` | `"khong_khop"` | `"AnNguyen@2026"` |
| **Ngày sinh** | `now.year - dob.year >= 18` (bù tháng/ngày) | Sinh năm 2011 (15 tuổi < 18) | `15/05/2003` (23 tuổi) |
| **Chuyên ngành** | Không được để trống (Dropdown selection) | `null` (chưa chọn) | `"Công nghệ Thông tin"` |
| **Điều khoản** | Bắt buộc đánh dấu đồng ý | Chưa tích Checkbox | Đã tích đồng ý |

---

## 5. DEMO TRƯỜNG HỢP DỮ LIỆU HỢP LỆ VÀ KHÔNG HỢP LỆ

Ứng dụng tích hợp bảng điều khiển nhanh ở đầu màn hình với 3 nút chức năng (`Nạp Dữ liệu HỢP LỆ`, `Nạp Dữ liệu LỖI`, `Làm mới Form`) để trực tiếp kiểm thử hai trường hợp theo yêu cầu của chủ đề:

### 5.1. Trường hợp Dữ liệu KHÔNG HỢP LỆ (Invalid Data)
- **Thao tác:** Bấm nút màu đỏ `[Nạp Dữ liệu LỖI]` và nhấn `[KIỂM TRA & GỬI BIỂU MẪU (SUBMIT)]`.
- **Dữ liệu giả lập vi phạm quy tắc:**
  1. *Họ và tên:* `"An123"` ➔ Vi phạm: Chứa chữ số và không đủ cấu trúc tối thiểu 2 từ (họ + tên).
  2. *Email:* `"an.nguyen_sai_dinh_dang"` ➔ Vi phạm: Thiếu ký tự `@` và tên miền hợp lệ.
  3. *Số điện thoại:* `"0123456"` ➔ Vi phạm: Độ dài chỉ có 7 số (cần 10 số) và không thuộc dải đầu số di động Việt Nam.
  4. *Mật khẩu:* `"123"` ➔ Vi phạm: Độ dài < 8 ký tự, thiếu chữ hoa, số và ký tự đặc biệt. Thước đo hiển thị màu đỏ báo "Rất yếu".
  5. *Xác nhận mật khẩu:* `"khong_khop"` ➔ Vi phạm: Không trùng khớp với mật khẩu đã nhập.
  6. *Ngày sinh:* Chọn năm sinh 2011 (15 tuổi) ➔ Vi phạm: Chưa đủ điều kiện từ 18 tuổi trở lên.
  7. *Chuyên ngành:* Giá trị `null` ➔ Vi phạm: Bắt buộc chọn một ngành học.
  8. *Điều khoản sử dụng:* Chưa tích chọn Checkbox ➔ Vi phạm: Bắt buộc đồng ý điều khoản trước khi gửi.
- **Cách xử lý kỹ thuật trong mã nguồn:**
  - Khi gọi `_formKey.currentState!.validate()`, Flutter duyệt qua toàn bộ các `TextFormField` con. Do các hàm trong `FormValidators` trả về chuỗi thông báo lỗi (khác `null`), hàm `validate()` trả về `false`.
  - Biểu mẫu tự động bật chế độ `_autovalidateMode = AutovalidateMode.onUserInteraction`, giúp thông báo lỗi cập nhật tức thì khi người dùng gõ sửa lại.
  - Sử dụng cơ chế FocusNode: Hệ thống kiểm tra trường lỗi đầu tiên và kích hoạt `_nameFocus.requestFocus()`, tự động đặt con trỏ vào ô Họ và tên để người dùng chỉnh sửa ngay mà không cần cuộn trang tìm lỗi.
  - Hiển thị SnackBar cảnh báo màu đỏ thông báo người dùng kiểm tra lại thông tin.

---

### 5.2. Trường hợp Dữ liệu HỢP LỆ (Valid Data)
- **Thao tác:** Bấm nút màu xanh `[Nạp Dữ liệu HỢP LỆ]` và nhấn `[KIỂM TRA & GỬI BIỂU MẪU (SUBMIT)]`.
- **Dữ liệu mẫu thỏa mãn chuẩn:**
  1. *Họ và tên:* `"Nguyễn Văn An"` ➔ Thỏa mãn: Chữ cái tiếng Việt có dấu, độ dài 13 ký tự, gồm 3 từ.
  2. *Email:* `"nguyenvanan.it@gmail.com"` ➔ Thỏa mãn: Khớp 100% regex RFC email.
  3. *Số điện thoại:* `"0988123456"` ➔ Thỏa mãn: Đủ 10 chữ số, đúng đầu số 09 mạng Viettel.
  4. *Mật khẩu:* `"AnNguyen@2026"` ➔ Thỏa mãn: Đủ 13 ký tự, có chữ hoa, thường, số, ký tự đặc biệt. Thước đo hiển thị màu xanh lá 100% ("Mạnh").
  5. *Xác nhận mật khẩu:* `"AnNguyen@2026"` ➔ Thỏa mãn: Trùng khớp từng ký tự với mật khẩu.
  6. *Ngày sinh:* `"15/05/2003"` (23 tuổi) ➔ Thỏa mãn: Độ tuổi $\ge 18$.
  7. *Chuyên ngành:* `"Công nghệ Thông tin"` ➔ Thỏa mãn: Đã chọn chuyên ngành.
  8. *Điều khoản sử dụng:* Đã tích chọn Checkbox cam kết.
- **Cách xử lý kỹ thuật trong mã nguồn:**
  - `_formKey.currentState!.validate()` trả về `true` vì tất cả hàm `validator` đều trả về `null`.
  - Hệ thống gọi `_formKey.currentState!.save()` để hoàn tất việc lưu trữ trạng thái biểu mẫu.
  - Đóng gói toàn bộ thông tin người dùng vào đối tượng dữ liệu `StudentRegistrationModel`.
  - Mở hộp thoại `ResultDialog` hiển thị bảng tổng hợp thông tin đăng ký thành công kèm lời chúc mừng và thông báo xác thực an toàn.

---

### 5.3. Thử nghiệm Chế độ Kiểm tra (AutovalidateMode)
- Trên góc phải `AppBar` có menu cài đặt cho phép chuyển đổi linh hoạt:
  - **Chỉ kiểm tra khi Submit (`AutovalidateMode.disabled`):** Chỉ hiển thị lỗi khi người dùng bấm nút Gửi biểu mẫu.
  - **Kiểm tra trực tiếp (`AutovalidateMode.onUserInteraction`):** Tự động kiểm tra và phản hồi lỗi ngay trong quá trình người dùng nhập liệu hoặc rời khỏi ô nhập.

---

## 6. HƯỚNG DẪN CÀI ĐẶT & CHẠY ỨNG DỤNG

### Bước 1: Mở thư mục dự án trong terminal / VS Code
```powershell
cd "D:\Lập Trình ĐNT\chu-de-tuan13"
```

### Bước 2: Chạy kiểm thử tự động (Unit Test) cho các validator
```powershell
flutter test test/validators_test.dart
# Hoặc chạy trực tiếp qua Dart SDK:
dart run test/validators_test.dart
```

### Bước 3: Chạy ứng dụng trên thiết bị (Windows, Web Chrome hoặc Điện thoại/Giả lập)
- Chạy trên máy tính Windows (Nhanh nhất):
```powershell
flutter run -d windows
```
- Chạy trên trình duyệt Web (Chrome):
```powershell
flutter run -d chrome
```
- Chạy trên thiết bị di động / giả lập Android:
```powershell
flutter run
```
