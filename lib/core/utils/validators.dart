class FormValidators {
  FormValidators._();

  /// Regex kiểm tra email chuẩn
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Regex kiểm tra số điện thoại Việt Nam (10 số, bắt đầu bằng 03, 05, 07, 08, 09)
  static final RegExp _vietnamPhoneRegExp = RegExp(
    r'^(03|05|07|08|09)[0-9]{8}$',
  );

  /// Regex kiểm tra họ tên chỉ bao gồm chữ cái và khoảng trắng (hỗ trợ tiếng Việt)
  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-ZÀ-ỹ\s]+$',
    unicode: true,
  );

  /// Kiểm tra Họ và Tên
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên.';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Họ và tên phải có ít nhất 3 ký tự.';
    }
    if (!_nameRegExp.hasMatch(trimmed)) {
      return 'Họ và tên chỉ được chứa chữ cái, không chứa số/ký tự đặc biệt.';
    }
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Vui lòng nhập cả họ và tên (ít nhất 2 từ).';
    }
    return null; // Hợp lệ
  }

  /// Kiểm tra Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập địa chỉ email.';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Email không hợp lệ (Ví dụ: sinhvien@dnt.edu.vn).';
    }
    return null; // Hợp lệ
  }

  /// Kiểm tra Số điện thoại
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại.';
    }
    final cleanPhone = value.replaceAll(RegExp(r'\s+'), '');
    if (!_vietnamPhoneRegExp.hasMatch(cleanPhone)) {
      return 'Số điện thoại VN không hợp lệ (10 số, đầu 03, 05, 07, 08, 09).';
    }
    return null; // Hợp lệ
  }

  /// Kiểm tra Mật khẩu
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải chứa ít nhất 8 ký tự.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ hoa (A-Z).';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ thường (a-z).';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 chữ số (0-9).';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt (!@#\$%...).';
    }
    return null; // Hợp lệ
  }

  /// Kiểm tra Xác nhận Mật khẩu
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu để xác nhận.';
    }
    if (value != originalPassword) {
      return 'Mật khẩu xác nhận không trùng khớp.';
    }
    return null; // Hợp lệ
  }

  /// Kiểm tra Ngày sinh (Phải từ 18 tuổi trở lên)
  static String? validateDateOfBirth(DateTime? date) {
    if (date == null) {
      return 'Vui lòng chọn ngày sinh.';
    }
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    if (age < 18) {
      return 'Người đăng ký phải từ đủ 18 tuổi trở lên (Hiện tại: $age tuổi).';
    }
    if (age > 100) {
      return 'Ngày sinh không hợp lý.';
    }
    return null; // Hợp lệ
  }

  /// Kiểm tra Dropdown bắt buộc chọn
  static String? validateDropdown(dynamic value, String fieldName) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return 'Vui lòng chọn $fieldName.';
    }
    return null;
  }

  /// Tính điểm độ mạnh mật khẩu (0 -> 4)
  static double getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score / 4.0;
  }

  /// Nhãn hiển thị độ mạnh mật khẩu
  static String getPasswordStrengthLabel(double strength) {
    if (strength <= 0.0) return 'Chưa nhập';
    if (strength <= 0.25) return 'Rất yếu (Cần thêm ký tự)';
    if (strength <= 0.50) return 'Yếu (Cần thêm hoa/số/ký tự)';
    if (strength <= 0.75) return 'Trung bình (Khá tốt)';
    return 'Mạnh (Tuyệt đối an toàn)';
  }
}
