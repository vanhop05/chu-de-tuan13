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

Nhóm có thể phân chia thời lượng thuyết trình 15 phút theo bố cục tối ưu sau:

- **Phút 0 - 3 (Mở đầu & Đặt vấn đề):**
  - Giới thiệu tên nhóm, thành viên và tên đề tài: *Chủ đề 6 - Biểu mẫu và kiểm tra dữ liệu đầu vào*.
  - Tầm quan trọng của biểu mẫu: Là thành phần cốt lõi thu thập thông tin người dùng. Nếu thiếu kiểm tra dữ liệu (validation), ứng dụng dễ gặp lỗi runtime, dữ liệu rác trên cơ sở dữ liệu và trải nghiệm người dùng kém.

- **Phút 3 - 6 (Trình bày Cơ sở lý thuyết & Kiến trúc Code):**
  - Phân biệt sự khác nhau giữa `TextField` và `TextFormField` (liên kết Form, cơ chế hiển thị lỗi tự động).
  - Giải thích vai trò của `Form` và `GlobalKey<FormState>` trong việc điều khiển toàn bộ biểu mẫu qua các phương thức `validate()`, `save()`, `reset()`.
  - Phân tích cơ chế `TextEditingController` (đọc/xóa dữ liệu) và `FocusNode` (điều hướng con trỏ, tự động chuyển trường bằng phím Next).
  - Giải thích 2 chế độ `AutovalidateMode`: `disabled` (kiểm tra khi Submit) và `onUserInteraction` (kiểm tra tức thì khi tương tác).

- **Phút 6 - 12 (Thực hành Demo Trực Tiếp Trên Ứng Dụng):**
  - **Demo 1: Trường hợp Dữ liệu KHÔNG HỢP LỆ (3 phút):**
    - Nhấn nút màu đỏ `[Nạp Dữ liệu LỖI]`.
    - Nhấn `[KIỂM TRA & GỬI BIỂU MẪU]`.
    - Trình diễn cho thầy cô thấy các trường báo đỏ đồng loạt:
      + *Họ tên*: Báo lỗi do có chữ số và không đủ 2 từ.
      + *Email*: Báo lỗi do thiếu định dạng `@` và tên miền.
      + *Số điện thoại*: Báo lỗi do sai đầu số VN và thiếu 10 số.
      + *Mật khẩu*: Quá ngắn, thiếu hoa/số/ký tự đặc biệt, thanh đo hiển thị "Rất yếu" (màu đỏ).
      + *Xác nhận mật khẩu*: Báo lỗi không trùng khớp.
      + *Ngày sinh*: Báo lỗi chưa đủ 18 tuổi.
      + *Chuyên ngành & Điều khoản*: Báo lỗi bắt buộc chọn và đồng ý.
    - Chỉ rõ hiệu ứng UX: Con trỏ tự động nhảy về ô Họ tên bị lỗi đầu tiên để hỗ trợ người dùng sửa nhanh.
  - **Demo 2: Trường hợp Dữ liệu HỢP LỆ (3 phút):**
    - Nhấn nút màu xanh `[Nạp Dữ liệu HỢP LỆ]`.
    - Thanh đo độ mạnh mật khẩu lập tức chuyển sang màu xanh lá 100% ("Mạnh").
    - Nhấn `[KIỂM TRA & GỬI BIỂU MẪU]`.
    - Hộp thoại `ResultDialog` xuất hiện thành công, hiển thị toàn bộ thông tin đã được đóng gói an toàn vào đối tượng `StudentRegistrationModel`.
  - **Demo 3: Thử nghiệm Chuyển chế độ Kiểm tra (AutovalidateMode):**
    - Bấm icon cài đặt trên góc phải AppBar để chuyển đổi giữa `disabled` và `onUserInteraction` để minh họa sự khác biệt về thời điểm hiển thị thông báo lỗi cho người dùng.

- **Phút 12 - 14 (Tổng kết & Giải thích Cách Xử Lý):**
  - Tóm tắt lại nguyên tắc kiểm tra: Kiểm tra chặt chẽ phía Client giúp giảm tải cho Server và tăng tốc độ phản hồi.
  - Giải thích cách xử lý khi dữ liệu hợp lệ: Gọi `_formKey.currentState!.save()` và đóng gói vào Model để gửi qua API.

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
