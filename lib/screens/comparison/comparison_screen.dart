import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('So Sánh & Phân Tích Thực Hành Demo'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(
              icon: Icon(Icons.cancel_outlined, color: Colors.orangeAccent),
              text: 'TRƯỜNG HỢP KHÔNG HỢP LỆ (INVALID)',
            ),
            Tab(
              icon: Icon(Icons.check_circle_outline, color: Colors.greenAccent),
              text: 'TRƯỜNG HỢP HỢP LỆ (VALID)',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInvalidCaseTab(),
          _buildValidCaseTab(),
        ],
      ),
    );
  }

  // TAB 1: Dữ liệu Không Hợp Lệ
  Widget _buildInvalidCaseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryBanner(
                title: 'Kịch Bản Demo: Dữ Liệu Đầu Vào Bị Sai / Thiếu',
                subtitle:
                    'Khi người dùng nhập thiếu dữ liệu hoặc vi phạm các ràng buộc nghiệp vụ, validator sẽ phát hiện, chặn quá trình submit và hướng dẫn người dùng sửa chữa.',
                color: AppTheme.errorColor,
                icon: Icons.error_outline_rounded,
              ),
              const SizedBox(height: 20),

              _buildFieldAnalysisCard(
                fieldName: '1. Họ và tên',
                inputValue: '"An123" hoặc để trống ""',
                errorReason: 'Chứa chữ số và không đủ 2 từ cấu thành (họ + tên).',
                regexOrRule: r'Regex: ^[a-zA-ZÀ-ỹ\s]+$ và split(" ").length >= 2',
                feedbackMessage: 'Họ và tên chỉ được chứa chữ cái, không chứa số/ký tự đặc biệt.',
                solution:
                    'Validator trả về chuỗi lỗi. Viền ô chuyển màu đỏ. Con trỏ tự động nhảy về ô này.',
                isError: true,
              ),

              _buildFieldAnalysisCard(
                fieldName: '2. Địa chỉ Email',
                inputValue: '"an.nguyen_sai_dinh_dang"',
                errorReason: 'Thiếu ký tự "@" và tên miền cấp cao (Top Level Domain: .com, .vn).',
                regexOrRule: r'Regex RFC: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                feedbackMessage: 'Email không hợp lệ (Ví dụ: sinhvien@dnt.edu.vn).',
                solution: 'Hiển thị nhãn cảnh báo ngay bên dưới ô nhập kèm viền errorBorder đỏ.',
                isError: true,
              ),

              _buildFieldAnalysisCard(
                fieldName: '3. Số điện thoại',
                inputValue: '"0123456" (7 số)',
                errorReason: 'Độ dài không đủ 10 chữ số và đầu số 012 đã cũ, không còn tồn tại.',
                regexOrRule: r'Regex VN: ^(03|05|07|08|09)[0-9]{8}$',
                feedbackMessage: 'Số điện thoại VN không hợp lệ (10 số, đầu 03, 05, 07, 08, 09).',
                solution: 'Chỉ chấp nhận số điện thoại di động 10 số đang lưu hành tại Việt Nam.',
                isError: true,
              ),

              _buildFieldAnalysisCard(
                fieldName: '4. Mật khẩu & Độ mạnh',
                inputValue: '"123"',
                errorReason: 'Chỉ có 3 ký tự, thiếu chữ hoa, chữ thường, ký tự đặc biệt.',
                regexOrRule: 'Quy tắc: length ≥ 8, có [A-Z], [a-z], [0-9], [!@#\$%^&*...]',
                feedbackMessage: 'Mật khẩu phải chứa ít nhất 8 ký tự... Thước đo báo "Rất yếu".',
                solution:
                    'Thanh LinearProgressIndicator chuyển màu Đỏ (25%). Không cho phép nộp biểu mẫu.',
                isError: true,
              ),

              _buildFieldAnalysisCard(
                fieldName: '5. Xác nhận mật khẩu',
                inputValue: '"khong_khop"',
                errorReason: 'Giá trị khác hoàn toàn so với trường mật khẩu ở trên.',
                regexOrRule: 'So sánh: confirmPassword == passwordController.text',
                feedbackMessage: 'Mật khẩu xác nhận không trùng khớp.',
                solution: 'Ngăn ngừa người dùng gõ nhầm mật khẩu mà không hay biết.',
                isError: true,
              ),

              _buildFieldAnalysisCard(
                fieldName: '6. Ngày sinh & Độ tuổi',
                inputValue: 'Năm sinh 2011 (Hiện tại 15 tuổi)',
                errorReason: 'Hệ thống yêu cầu sinh viên nhập học từ đủ 18 tuổi trở lên.',
                regexOrRule: 'Tính toán: now.year - dob.year (có bù tháng/ngày) < 18',
                feedbackMessage: 'Người đăng ký phải từ đủ 18 tuổi trở lên (Hiện tại: 15 tuổi).',
                solution: 'Ngăn chặn hồ sơ chưa đủ tuổi dân sự theo quy định.',
                isError: true,
              ),

              _buildFieldAnalysisCard(
                fieldName: '7. Điều khoản cam kết',
                inputValue: 'Chưa đánh dấu Checkbox',
                errorReason: 'Người dùng bỏ qua việc đồng ý với nội quy và điều khoản bảo mật.',
                regexOrRule: 'Kiểm tra: _agreedToTerms == false',
                feedbackMessage: 'Vui lòng đánh dấu đồng ý trước khi gửi biểu mẫu.',
                solution: 'Hiển thị dòng chữ cảnh báo đỏ bên dưới Checkbox và hiện SnackBar.',
                isError: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 2: Dữ liệu Hợp Lệ
  Widget _buildValidCaseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryBanner(
                title: 'Kịch Bản Demo: Dữ Liệu Đầu Vào Hoàn Toàn Hợp Lệ',
                subtitle:
                    'Tất cả các trường đều vượt qua kiểm tra (100% validator trả về null). Hệ thống kích hoạt formKey.currentState.save() và đóng gói dữ liệu vào Model an toàn.',
                color: AppTheme.successColor,
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(height: 20),

              _buildFieldAnalysisCard(
                fieldName: '1. Họ và tên',
                inputValue: '"Nguyễn Văn An"',
                errorReason: 'Thỏa mãn đầy đủ họ và tên, chứa ký tự tiếng Việt hợp chuẩn.',
                regexOrRule: 'Số từ: 3 từ. Độ dài: 13 ký tự. Không chứa số hay ký hiệu.',
                feedbackMessage: 'Validator trả về `null` -> Viền xanh / xám chuẩn, không có lỗi.',
                solution: 'Dữ liệu được lưu trữ sạch sẽ vào bộ nhớ.',
                isError: false,
              ),

              _buildFieldAnalysisCard(
                fieldName: '2. Địa chỉ Email',
                inputValue: '"nguyenvanan.it@gmail.com"',
                errorReason: 'Đúng chuẩn cấu trúc tài khoản + @ + tên miền gmail.com.',
                regexOrRule: 'Khớp 100% biểu thức chính quy email.',
                feedbackMessage: 'Validator trả về `null`.',
                solution: 'Sẵn sàng gửi email xác thực tài khoản.',
                isError: false,
              ),

              _buildFieldAnalysisCard(
                fieldName: '3. Số điện thoại',
                inputValue: '"0988123456"',
                errorReason: 'Đủ 10 chữ số, thuộc dải đầu số di động Viettel (098).',
                regexOrRule: 'Khớp đầu số 09 và 8 chữ số tiếp theo.',
                feedbackMessage: 'Validator trả về `null`.',
                solution: 'Sẵn sàng gửi mã OTP kích hoạt.',
                isError: false,
              ),

              _buildFieldAnalysisCard(
                fieldName: '4. Mật khẩu & Thước đo',
                inputValue: '"AnNguyen@2026"',
                errorReason: 'Có chữ hoa (A, N), chữ thường, ký tự đặc biệt (@) và chữ số (2026).',
                regexOrRule: 'Độ dài 13 ký tự (> 8). Thỏa mãn cả 4 điều kiện bảo mật.',
                feedbackMessage: 'Thanh đo hiển thị 100% màu Xanh lá cây ("Mạnh").',
                solution: 'Đảm bảo tiêu chuẩn an toàn thông tin mật khẩu hiện đại.',
                isError: false,
              ),

              _buildFieldAnalysisCard(
                fieldName: '5. Xác nhận mật khẩu',
                inputValue: '"AnNguyen@2026"',
                errorReason: 'Trùng khớp 100% từng ký tự với mật khẩu đã nhập.',
                regexOrRule: 'confirmPassword == password',
                feedbackMessage: 'Validator trả về `null`.',
                solution: 'Xác nhận người dùng đã ghi nhớ chính xác mật khẩu của mình.',
                isError: false,
              ),

              _buildFieldAnalysisCard(
                fieldName: '6. Ngày sinh & Độ tuổi',
                inputValue: '"15/05/2003" (23 tuổi)',
                errorReason: 'Độ tuổi 23 >= 18 tuổi.',
                regexOrRule: 'Đạt điều kiện đăng ký theo quy chế tuyển sinh.',
                feedbackMessage: 'Validator trả về `null`.',
                solution: 'Hệ thống tự động tính ra tuổi để hiển thị lên phiếu kết quả.',
                isError: false,
              ),

              _buildFieldAnalysisCard(
                fieldName: '7. Quy trình Xử lý khi Submit',
                inputValue: 'Bấm nút "KIỂM TRA & GỬI BIỂU MẪU"',
                errorReason: 'Không có lỗi nào xảy ra.',
                regexOrRule: 'if (_formKey.currentState!.validate()) { ... }',
                feedbackMessage: 'Hiển thị ResultDialog kèm bảng tổng hợp dữ liệu chi tiết!',
                solution:
                    'Đóng gói thành công đối tượng `StudentRegistrationModel` để gửi lên backend API.',
                isError: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(70), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF334155),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldAnalysisCard({
    required String fieldName,
    required String inputValue,
    required String errorReason,
    required String regexOrRule,
    required String feedbackMessage,
    required String solution,
    required bool isError,
  }) {
    final statusColor = isError ? AppTheme.errorColor : AppTheme.successColor;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: statusColor.withAlpha(70), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isError ? Icons.cancel : Icons.check_circle,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  fieldName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isError ? 'Không hợp lệ' : 'Hợp lệ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildRowText('Giá trị nhập:', inputValue, isBold: true),
            _buildRowText('Lý do / Phân tích:', errorReason),
            _buildRowText('Quy tắc áp dụng:', regexOrRule),
            _buildRowText('Thông báo phản hồi:', feedbackMessage,
                highlightColor: isError ? AppTheme.errorColor : AppTheme.successColor),
            _buildRowText('Cách xử lý hệ thống:', solution),
          ],
        ),
      ),
    );
  }

  Widget _buildRowText(String label, String value,
      {bool isBold = false, Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: highlightColor ?? const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
