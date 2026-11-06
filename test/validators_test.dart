import 'package:chu_de_tuan13/core/utils/validators.dart';

void main() {
  int passed = 0;
  int failed = 0;

  void expectTrue(bool condition, String message) {
    if (condition) {
      passed++;
      // print('  ✓ $message');
    } else {
      failed++;
      print('  ✗ FAILED: $message');
    }
  }

  print('=== CHẠY KIỂM THỬ TỰ ĐỘNG CHO CÁC HÀM VALIDATOR ===');

  // 1. Kiểm tra Họ và Tên
  print('\n[1] Kiểm tra Họ và Tên:');
  expectTrue(FormValidators.validateFullName(null) != null, 'Null trả về lỗi');
  expectTrue(FormValidators.validateFullName('') != null, 'Chuỗi rỗng trả về lỗi');
  expectTrue(FormValidators.validateFullName('An123') != null, 'Chứa số trả về lỗi');
  expectTrue(FormValidators.validateFullName('An') != null, '1 từ trả về lỗi');
  expectTrue(FormValidators.validateFullName('Nguyễn Văn An') == null, 'Nguyễn Văn An hợp lệ');
  expectTrue(FormValidators.validateFullName('Trần Thị Mai') == null, 'Trần Thị Mai hợp lệ');

  // 2. Kiểm tra Email
  print('\n[2] Kiểm tra Email:');
  expectTrue(FormValidators.validateEmail('') != null, 'Rỗng trả về lỗi');
  expectTrue(FormValidators.validateEmail('an.nguyen') != null, 'Thiếu @ và domain trả về lỗi');
  expectTrue(FormValidators.validateEmail('an@gmail') != null, 'Thiếu TLD .com trả về lỗi');
  expectTrue(FormValidators.validateEmail('nguyenvanan.it@gmail.com') == null, 'nguyenvanan.it@gmail.com hợp lệ');
  expectTrue(FormValidators.validateEmail('sinhvien@dnt.edu.vn') == null, 'sinhvien@dnt.edu.vn hợp lệ');

  // 3. Kiểm tra Số điện thoại
  print('\n[3] Kiểm tra Số điện thoại VN:');
  expectTrue(FormValidators.validatePhone('') != null, 'Rỗng trả về lỗi');
  expectTrue(FormValidators.validatePhone('0123456') != null, '7 số trả về lỗi');
  expectTrue(FormValidators.validatePhone('1234567890') != null, 'Không có đầu số VN 03,05,07,08,09 trả về lỗi');
  expectTrue(FormValidators.validatePhone('0988123456') == null, '0988123456 hợp lệ');
  expectTrue(FormValidators.validatePhone('0391234567') == null, '0391234567 hợp lệ');

  // 4. Kiểm tra Mật khẩu & Độ mạnh
  print('\n[4] Kiểm tra Mật khẩu & Thước đo:');
  expectTrue(FormValidators.validatePassword('123') != null, 'Quá ngắn trả về lỗi');
  expectTrue(FormValidators.validatePassword('abcdefgh') != null, 'Thiếu hoa/số/ký tự đặc biệt trả về lỗi');
  expectTrue(FormValidators.validatePassword('Abcdefgh1') != null, 'Thiếu ký tự đặc biệt trả về lỗi');
  expectTrue(FormValidators.validatePassword('AnNguyen@2026') == null, 'AnNguyen@2026 hợp lệ');
  expectTrue(FormValidators.getPasswordStrength('AnNguyen@2026') == 1.0, 'Độ mạnh AnNguyen@2026 là 100% (1.0)');

  // 5. Kiểm tra Xác nhận mật khẩu
  print('\n[5] Kiểm tra Xác nhận mật khẩu:');
  expectTrue(FormValidators.validateConfirmPassword('abc', 'xyz') != null, 'Không khớp trả về lỗi');
  expectTrue(FormValidators.validateConfirmPassword('AnNguyen@2026', 'AnNguyen@2026') == null, 'Trùng khớp hợp lệ');

  // 6. Kiểm tra Độ tuổi
  print('\n[6] Kiểm tra Độ tuổi (>= 18 tuổi):');
  expectTrue(FormValidators.validateDateOfBirth(null) != null, 'Chưa chọn ngày sinh trả về lỗi');
  final underage = DateTime.now().subtract(const Duration(days: 365 * 15));
  expectTrue(FormValidators.validateDateOfBirth(underage) != null, '15 tuổi trả về lỗi chưa đủ tuổi');
  final adult = DateTime(2003, 5, 15);
  expectTrue(FormValidators.validateDateOfBirth(adult) == null, 'Sinh năm 2003 hợp lệ');

  print('\n==================================================');
  print('KẾT QUẢ KIỂM THỬ: ĐÃ VƯỢT QUA $passed KIỂM TRA, THẤT BẠI: $failed');
  if (failed == 0) {
    print('TẤT CẢ CÁC QUY TẮC VALIDATOR ĐÃ VƯỢT QUA THÀNH CÔNG 100%!');
  }
  print('==================================================');
}
