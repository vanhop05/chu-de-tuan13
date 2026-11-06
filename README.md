# CHỦ ĐỀ 6: BIỂU MẪU VÀ KIỂM TRA DỮ LIỆU ĐẦU VÀO TRONG FLUTTER
**Dự án môn học Lập Trình ĐNT - Tuần 13**  
**Thời lượng báo cáo đề xuất:** 15 phút/nhóm

---

## 📋 MỤC LỤC
1. [Giới thiệu dự án](#1-giới-thiệu-dự-án)
2. [Cấu trúc mã nguồn](#2-cấu-trúc-mã-nguồn)
3. [Cơ sở lý thuyết trọng tâm](#3-cơ-sở-lý-thuyết-trọng-tâm)
4. [Các quy tắc kiểm tra dữ liệu (Validators)](#4-các-quy-tắc-kiểm-tra-dữ-liệu-validators)
5. [Kịch bản thuyết trình & Demo 15 phút](#5-kịch-bản-thuyết-trình--demo-15-phút)
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

## 5. KỊCH BẢN THUYẾT TRÌNH & DEMO 15 PHÚT

Nhóm có thể phân chia thời lượng thuyết trình 15 phút theo bố cục chuẩn sau:

- **Phút 0 - 3 (Mở đầu & Đặt vấn đề):**
  - Giới thiệu tên nhóm, thành viên và tên đề tài: *Chủ đề 6 - Biểu mẫu và kiểm tra dữ liệu đầu vào*.
  - Tầm quan trọng của biểu mẫu trong ứng dụng di động: là cầu nối trao đổi dữ liệu giữa người dùng và máy chủ, nếu không kiểm tra chặt chẽ sẽ gây lỗi cơ sở dữ liệu, lỗi bảo mật và trải nghiệm người dùng kém.

- **Phút 3 - 7 (Trình bày Cơ sở lý thuyết):**
  - Mở tab **"Cơ Sở Lý Thuyết"** trên ứng dụng.
  - Trình bày sự khác biệt giữa `TextField` và `TextFormField`.
  - Giải thích cách `Form` và `GlobalKey<FormState>` phối hợp để quản lý trạng thái tập trung.
  - Phân tích cơ chế hoạt động của `validator`, các chế độ `AutovalidateMode` (`disabled` vs `onUserInteraction`).
  - Trình bày kỹ thuật quản lý `TextEditingController` và `FocusNode` kèm tầm quan trọng của việc gọi `.dispose()`.

- **Phút 7 - 12 (Thực hành Chạy Demo Trực Tiếp):**
  - Chuyển sang tab **"Demo Biểu Mẫu"**.
  - **Demo 1: Trường hợp Dữ liệu KHÔNG HỢP LỆ (2 phút):**
    - Nhấn nút màu đỏ `[Nạp Dữ liệu LỖI]`.
    - Bấm `[KIỂM TRA & GỬI BIỂU MẪU]`.
    - Chỉ cho thầy cô thấy các trường báo đỏ đồng loạt, giải thích từng thông báo lỗi chi tiết, thanh mật khẩu báo "Rất yếu", con trỏ tự động nhảy về ô Họ tên bị lỗi đầu tiên.
  - **Demo 2: Trường hợp Dữ liệu HỢP LỆ (2 phút):**
    - Nhấn nút màu xanh `[Nạp Dữ liệu HỢP LỆ]`.
    - Thanh đo độ mạnh mật khẩu lập tức hiển thị màu xanh lá 100% ("Mạnh").
    - Bấm `[KIỂM TRA & GỬI BIỂU MẪU]`.
    - Hộp thoại Dialog thành công bật lên, hiển thị toàn bộ thông tin đã được đóng gói an toàn vào `StudentRegistrationModel`.

- **Phút 12 - 14 (Tổng kết & Đối chiếu):**
  - Chuyển sang tab **"So Sánh & Phân Tích"** để tóm lược lại các quy tắc kiểm tra và cách hệ thống xử lý.

- **Phút 14 - 15 (Hỏi đáp & Kết luận):**
  - Trả lời các câu hỏi phản biện của Giảng viên và lớp học.

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
