import 'package:flutter/material.dart';
import '../../core/models/student_registration_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/password_strength_meter.dart';
import 'widgets/result_dialog.dart';

class FormDemoScreen extends StatefulWidget {
  const FormDemoScreen({super.key});

  @override
  State<FormDemoScreen> createState() => _FormDemoScreenState();
}

class _FormDemoScreenState extends State<FormDemoScreen> {
  // 1. Quản lý trạng thái form bằng GlobalKey<FormState>
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Quản lý TextEditingController cho từng trường nhập liệu
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _dobController;
  late final TextEditingController _bioController;

  // 3. Quản lý FocusNode để điều hướng tiêu điểm (Focus Management)
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _passwordFocus;
  late final FocusNode _confirmPasswordFocus;
  late final FocusNode _dobFocus;

  // 4. Các biến trạng thái bổ sung
  DateTime? _selectedDob;
  String? _selectedMajor = 'Công nghệ Thông tin';
  String _selectedGender = 'Nam';
  bool _agreedToTerms = false;
  bool _termsError = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Chế độ kiểm tra: disabled (chỉ khi bấm submit) hoặc onUserInteraction (khi gõ)
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final List<String> _majors = [
    'Công nghệ Thông tin',
    'Kỹ thuật Phần mềm',
    'Khoa học Dữ liệu & AI',
    'Hệ thống Thông tin',
    'An toàn Thông tin',
    'Thương mại Điện tử',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _dobController = TextEditingController();
    _bioController = TextEditingController();

    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _dobFocus = FocusNode();

    // Lắng nghe thay đổi password để vẽ lại thước đo độ mạnh
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Luôn giải phóng controllers và focus nodes để tránh rò rỉ bộ nhớ
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _bioController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _dobFocus.dispose();

    super.dispose();
  }

  // Chọn ngày sinh từ DatePicker
  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _selectedDob ?? DateTime(now.year - 20, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'CHỌN NGÀY SINH CỦA BẠN',
      cancelText: 'HỦY BỎ',
      confirmText: 'CHỌN',
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDob = pickedDate;
        final d = pickedDate.day.toString().padLeft(2, '0');
        final m = pickedDate.month.toString().padLeft(2, '0');
        final y = pickedDate.year.toString();
        _dobController.text = '$d/$m/$y';
      });
      // Tự động kiểm tra lại trường ngày sinh
      _formKey.currentState?.validate();
    }
  }

  // Demo: Nạp dữ liệu HỢP LỆ (Tất cả quy tắc đều thỏa mãn)
  void _fillValidData() {
    setState(() {
      _nameController.text = 'Nguyễn Văn An';
      _emailController.text = 'nguyenvanan.it@gmail.com';
      _phoneController.text = '0988123456';
      _passwordController.text = 'AnNguyen@2026';
      _confirmPasswordController.text = 'AnNguyen@2026';
      _selectedDob = DateTime(2003, 5, 15);
      _dobController.text = '15/05/2003';
      _selectedMajor = 'Công nghệ Thông tin';
      _selectedGender = 'Nam';
      _agreedToTerms = true;
      _termsError = false;
      _bioController.text = 'Sinh viên đam mê lập trình di động Flutter và phát triển phần mềm.';
      _autovalidateMode = AutovalidateMode.disabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Đã nạp dữ liệu HỢP LỆ mẫu! Bấm "Kiểm tra & Gửi" để xem kết quả.'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Demo: Nạp dữ liệu LỖI (Mỗi trường vi phạm 1 quy tắc kiểm tra)
  void _fillInvalidData() {
    setState(() {
      _nameController.text = 'An123'; // Lỗi: chứa số, không đủ 2 từ
      _emailController.text = 'an.nguyen_sai_dinh_dang'; // Lỗi: thiếu @ và domain
      _phoneController.text = '0123456'; // Lỗi: sai đầu số và không đủ 10 số
      _passwordController.text = '123'; // Lỗi: quá ngắn, thiếu hoa, ký tự đặc biệt
      _confirmPasswordController.text = 'khong_khop'; // Lỗi: không khớp mật khẩu
      _selectedDob = DateTime(DateTime.now().year - 15, 1, 1); // Lỗi: mới 15 tuổi (< 18)
      final d = _selectedDob!.day.toString().padLeft(2, '0');
      final m = _selectedDob!.month.toString().padLeft(2, '0');
      final y = _selectedDob!.year.toString();
      _dobController.text = '$d/$m/$y';
      _selectedMajor = null; // Lỗi: chưa chọn ngành
      _agreedToTerms = false; // Lỗi: chưa đồng ý điều khoản
      _termsError = true;
      _bioController.clear();
      _autovalidateMode = AutovalidateMode.onUserInteraction; // Hiện lỗi ngay
    });

    // Kích hoạt kiểm tra ngay để hiển thị thông báo lỗi trực quan
    _formKey.currentState?.validate();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Đã nạp dữ liệu KHÔNG HỢP LỆ! Xem các thông báo lỗi bên dưới từng ô.'),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Xóa trắng form (Reset)
  void _resetForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _dobController.clear();
      _bioController.clear();
      _selectedDob = null;
      _selectedMajor = 'Công nghệ Thông tin';
      _selectedGender = 'Nam';
      _agreedToTerms = false;
      _termsError = false;
      _autovalidateMode = AutovalidateMode.disabled;
    });

    _formKey.currentState?.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Đã làm mới toàn bộ biểu mẫu!'),
        backgroundColor: Color(0xFF475569),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Xử lý Kiểm tra & Gửi Biểu mẫu (Validate & Submit)
  void _handleSubmit() {
    // 1. Kiểm tra điều khoản trước
    setState(() {
      _termsError = !_agreedToTerms;
    });

    // 2. Kích hoạt toàn bộ hàm validator thông qua _formKey.currentState!.validate()
    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid || !_agreedToTerms) {
      // Chuyển sang chế độ onUserInteraction để người dùng sửa đến đâu mất lỗi đến đó
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });

      // Tự động tìm trường lỗi đầu tiên để request focus (Trải nghiệm người dùng tốt nhất)
      if (FormValidators.validateFullName(_nameController.text) != null) {
        _nameFocus.requestFocus();
      } else if (FormValidators.validateEmail(_emailController.text) != null) {
        _emailFocus.requestFocus();
      } else if (FormValidators.validatePhone(_phoneController.text) != null) {
        _phoneFocus.requestFocus();
      } else if (FormValidators.validatePassword(_passwordController.text) != null) {
        _passwordFocus.requestFocus();
      } else if (FormValidators.validateConfirmPassword(
              _confirmPasswordController.text, _passwordController.text) !=
          null) {
        _confirmPasswordFocus.requestFocus();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(!_agreedToTerms
              ? '⚠️ Vui lòng chấp thuận điều khoản sử dụng và sửa các lỗi trên form!'
              : '⚠️ Dữ liệu chưa hợp lệ! Vui lòng kiểm tra lại các trường được báo đỏ.'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 3. Nếu dữ liệu hợp lệ: Gọi save() và tạo model kết quả
    _formKey.currentState?.save();

    final resultData = StudentRegistrationModel(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      dateOfBirth: _selectedDob!,
      major: _selectedMajor ?? 'Chưa xác định',
      gender: _selectedGender,
      agreedToTerms: _agreedToTerms,
      bio: _bioController.text.trim(),
    );

    // Hiển thị Dialog thông báo thành công
    showDialog(
      context: context,
      builder: (context) => ResultDialog(data: resultData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Biểu Mẫu & Kiểm Tra Dữ Liệu'),
        actions: [
          // Nút chuyển chế độ autovalidateMode
          PopupMenuButton<AutovalidateMode>(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Chế độ kiểm tra (AutovalidateMode)',
            onSelected: (mode) {
              setState(() {
                _autovalidateMode = mode;
              });
              _formKey.currentState?.validate();
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: AutovalidateMode.disabled,
                checked: _autovalidateMode == AutovalidateMode.disabled,
                child: const Text('Chỉ kiểm tra khi Submit (Disabled)'),
              ),
              CheckedPopupMenuItem(
                value: AutovalidateMode.onUserInteraction,
                checked: _autovalidateMode == AutovalidateMode.onUserInteraction,
                child: const Text('Kiểm tra ngay khi nhập (onUserInteraction)'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thanh điều khiển nhanh phục vụ thuyết trình 15 phút
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.play_circle_fill_rounded,
                                color: AppTheme.accentColor, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Bảng Điều Khiển Nhanh (Trực tiếp cho Thuyết trình)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _fillValidData,
                              icon: const Icon(Icons.check_circle_outline, size: 18),
                              label: const Text('Nạp Dữ liệu HỢP LỆ'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.successColor,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _fillInvalidData,
                              icon: const Icon(Icons.error_outline, size: 18),
                              label: const Text('Nạp Dữ liệu LỖI'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.errorColor,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _resetForm,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Làm mới Form'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chế độ kiểm tra hiện tại: ${_autovalidateMode == AutovalidateMode.onUserInteraction ? "Kiểm tra trực tiếp khi gõ (onUserInteraction)" : "Chỉ kiểm tra khi bấm Nộp (Disabled)"}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Biểu mẫu chính nằm trong Widget Form
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'PHIẾU ĐĂNG KÝ THÔNG TIN SINH VIÊN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Minh họa toàn diện: TextField, TextFormField, Form, GlobalKey, Validator & FocusNode',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 1. Họ và tên
                          CustomTextField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            nextFocusNode: _emailFocus,
                            label: 'Họ và tên sinh viên',
                            hint: 'Nhập đầy đủ họ và tên (VD: Nguyễn Văn An)',
                            prefixIcon: Icons.person_outline_rounded,
                            validator: FormValidators.validateFullName,
                            suffixIcon: _nameController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () => setState(() => _nameController.clear()),
                                  )
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),

                          // 2. Email
                          CustomTextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocusNode: _phoneFocus,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Địa chỉ Email',
                            hint: 'sinhvien@dnt.edu.vn',
                            prefixIcon: Icons.email_outlined,
                            validator: FormValidators.validateEmail,
                            suffixIcon: _emailController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () => setState(() => _emailController.clear()),
                                  )
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),

                          // 3. Số điện thoại
                          CustomTextField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            nextFocusNode: _passwordFocus,
                            keyboardType: TextInputType.phone,
                            label: 'Số điện thoại liên lạc',
                            hint: '10 chữ số (VD: 0988123456)',
                            prefixIcon: Icons.phone_android_rounded,
                            validator: FormValidators.validatePhone,
                            suffixIcon: _phoneController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () => setState(() => _phoneController.clear()),
                                  )
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),

                          // 4. Mật khẩu & Thước đo độ mạnh
                          CustomTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocusNode: _confirmPasswordFocus,
                            obscureText: _obscurePassword,
                            label: 'Mật khẩu tài khoản',
                            hint: 'Tối thiểu 8 ký tự, gồm chữ hoa, thường, số, ký tự đặc biệt',
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: FormValidators.validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          PasswordStrengthMeter(password: _passwordController.text),
                          const SizedBox(height: 12),

                          // 5. Xác nhận mật khẩu
                          CustomTextField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            nextFocusNode: _dobFocus,
                            obscureText: _obscureConfirmPassword,
                            label: 'Xác nhận lại mật khẩu',
                            hint: 'Nhập lại chính xác mật khẩu ở trên',
                            prefixIcon: Icons.lock_clock_outlined,
                            validator: (val) => FormValidators.validateConfirmPassword(
                              val,
                              _passwordController.text,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () => setState(() =>
                                  _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                          ),

                          // 6. Ngày sinh 
                          CustomTextField(
                            controller: _dobController,
                            focusNode: _dobFocus,
                            readOnly: true,
                            label: 'Ngày tháng năm sinh',
                            hint: 'Bấm để chọn ngày sinh (Yêu cầu ≥ 18 tuổi)',
                            prefixIcon: Icons.calendar_today_rounded,
                            validator: (_) => FormValidators.validateDateOfBirth(_selectedDob),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range_rounded),
                              onPressed: _selectDateOfBirth,
                            ),
                            onTap: _selectDateOfBirth,
                          ),

                          // 7. Chuyên ngành 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Chuyên ngành đào tạo',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedMajor,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.school_outlined, size: 20),
                                  hintText: 'Chọn chuyên ngành của bạn',
                                ),
                                items: _majors.map((major) {
                                  return DropdownMenuItem<String>(
                                    value: major,
                                    child: Text(major),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMajor = value;
                                  });
                                },
                                validator: (val) =>
                                    FormValidators.validateDropdown(val, 'chuyên ngành'),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                          // 8. Giới tính 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Giới tính',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: SegmentedButton<String>(
                                  segments: const [
                                    ButtonSegment<String>(
                                      value: 'Nam',
                                      label: Text('Nam'),
                                      icon: Icon(Icons.male_rounded),
                                    ),
                                    ButtonSegment<String>(
                                      value: 'Nữ',
                                      label: Text('Nữ'),
                                      icon: Icon(Icons.female_rounded),
                                    ),
                                    ButtonSegment<String>(
                                      value: 'Khác',
                                      label: Text('Khác'),
                                      icon: Icon(Icons.transgender_rounded),
                                    ),
                                  ],
                                  selected: {_selectedGender},
                                  onSelectionChanged: (newSelection) {
                                    setState(() {
                                      _selectedGender = newSelection.first;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                          // 9. Giới thiệu bản thân 
                          CustomTextField(
                            controller: _bioController,
                            label: 'Giới thiệu bản thân (Tùy chọn)',
                            hint: 'Sở thích, định hướng công việc hoặc mục tiêu học tập...',
                            prefixIcon: Icons.description_outlined,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),

                          // 10. Điều khoản sử dụng 
                          FormField<bool>(
                            initialValue: _agreedToTerms,
                            validator: (_) => !_agreedToTerms
                                ? 'Bạn phải đồng ý với điều khoản sử dụng.'
                                : null,
                            builder: (formFieldState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: _agreedToTerms,
                                        activeColor: AppTheme.primaryColor,
                                        onChanged: (val) {
                                          setState(() {
                                            _agreedToTerms = val ?? false;
                                            _termsError = !_agreedToTerms;
                                          });
                                          formFieldState.didChange(val);
                                        },
                                      ),
                                      const Expanded(
                                        child: Text(
                                          'Tôi cam kết các thông tin đã khai trên là hoàn toàn chính xác và tuân thủ nội quy nhà trường.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF334155),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_termsError)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 12, top: 4),
                                      child: Text(
                                        'Vui lòng đánh dấu đồng ý trước khi gửi biểu mẫu.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.errorColor,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                ],
                              );
                            },
                          ),

                          // 11. Nút Submit chính
                          ElevatedButton.icon(
                            onPressed: _handleSubmit,
                            icon: const Icon(Icons.send_rounded, size: 20),
                            label: const Text(
                              'KIỂM TRA & GỬI BIỂU MẪU (SUBMIT)',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
