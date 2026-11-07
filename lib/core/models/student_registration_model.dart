class StudentRegistrationModel {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final DateTime dateOfBirth;
  final String major;
  final String gender;
  final bool agreedToTerms;
  final String? bio;

  /// Khởi tạo thông tin đăng ký của sinh viên.
  const StudentRegistrationModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.dateOfBirth,
    required this.major,
    required this.gender,
    required this.agreedToTerms,
    this.bio,
  });

  /// Tính tuổi hiện tại dựa trên ngày sinh của sinh viên.
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Trả về ngày sinh theo định dạng ngày/tháng/năm.
  String get formattedDob {
    final d = dateOfBirth.day.toString().padLeft(2, '0');
    final m = dateOfBirth.month.toString().padLeft(2, '0');
    final y = dateOfBirth.year.toString();
    return '$d/$m/$y';
  }

  /// Chuyển thông tin đăng ký thành một map để hiển thị trên giao diện.
  Map<String, String> toDisplayMap() {
    return {
      'Họ và tên': fullName,
      'Email': email,
      'Số điện thoại': phone,
      'Ngày sinh': '$formattedDob ($age tuổi)',
      'Giới tính': gender,
      'Chuyên ngành': major,
      'Độ dài mật khẩu': '${password.length} ký tự (Đã mã hóa)',
      'Điều khoản sử dụng': agreedToTerms ? 'Đã chấp thuận' : 'Chưa chấp thuận',
      'Giới thiệu bản thân': (bio != null && bio!.isNotEmpty) ? bio! : 'Không có',
    };
  }
}
