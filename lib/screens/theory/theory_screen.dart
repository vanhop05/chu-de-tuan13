import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cơ Sở Lý Thuyết - Chủ Đề 6'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header giới thiệu chủ đề
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHỦ ĐỀ 6: BIỂU MẪU VÀ KIỂM TRA DỮ LIỆU ĐẦU VÀO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hệ thống lý thuyết trọng tâm phục vụ thuyết trình 15 phút, bao gồm kiến trúc Form, cơ chế Validation, quản lý Controller/Focus và chuẩn mực UX phản hồi người dùng trong Flutter.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Mục 1: TextField vs TextFormField
                _buildTheoryCard(
                  title: '1. So Sánh TextField vs TextFormField',
                  icon: Icons.compare_arrows_rounded,
                  iconColor: AppTheme.primaryColor,
                  children: [
                    const Text(
                      'Trong Flutter, có hai widget nhập văn bản phổ biến với mục đích sử dụng khác nhau:',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(color: const Color(0xFFCBD5E1), width: 1),
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(2.2),
                        2: FlexColumnWidth(2.2),
                      },
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Tiêu chí', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('TextField', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('TextFormField', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Bản chất'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Widget nhập liệu cơ bản, hoạt động độc lập.'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Bọc quanh TextField, kế thừa từ FormField<String>.'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Tích hợp Form'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Không kết nối tự động với widget cha Form.'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Tự động liên kết với Form qua context.'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Kiểm tra dữ liệu'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Phải tự viết logic và tự cập nhật giao diện lỗi qua state.'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Hỗ trợ thuộc tính `validator` và hiển thị lỗi tự động.'),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Hàm hỗ trợ'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('onChanged, onSubmitted.'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('validator, onSaved, autovalidateMode, reset.'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Mục 2: Form và GlobalKey
                _buildTheoryCard(
                  title: '2. Form và GlobalKey<FormState>',
                  icon: Icons.vpn_key_rounded,
                  iconColor: AppTheme.secondaryColor,
                  children: [
                    const Text(
                      '• Widget `Form`: Đóng vai trò là container quản lý tập trung nhiều FormField con (TextFormField, DropdownButtonFormField, v.v.).\n\n'
                      '• `GlobalKey<FormState>`: Định danh duy nhất cho Form trên toàn widget tree, cho phép truy cập đối tượng `FormState` để điều khiển form từ bất kỳ đâu:',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    _buildCodeSnippet(
                      '// 1. Khai báo key\n'
                      'final _formKey = GlobalKey<FormState>();\n\n'
                      '// 2. Gắn vào Form\n'
                      'Form(\n'
                      '  key: _formKey,\n'
                      '  child: ...\n'
                      ')\n\n'
                      '// 3. Các thao tác chính:\n'
                      'if (_formKey.currentState!.validate()) {\n'
                      '  // Trả về true nếu TOÀN BỘ validator con đều trả về null\n'
                      '  _formKey.currentState!.save();   // Kích hoạt onSaved của các trường\n'
                      '}\n'
                      '_formKey.currentState!.reset();    // Xóa sạch trạng thái và lỗi',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Mục 3: Validator và Thông báo lỗi
                _buildTheoryCard(
                  title: '3. Validator và Thông Báo Lỗi',
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppTheme.successColor,
                  children: [
                    const Text(
                      'Quy tắc của hàm `validator` trong Flutter:\n'
                      '• Nhận vào giá trị hiện tại của ô nhập: `String? value`\n'
                      '• Trả về `String` chứa nội dung câu thông báo nếu DỮ LIỆU SAI.\n'
                      '• Trả về `null` nếu DỮ LIỆU ĐÚNG.\n\n'
                      'Cơ chế AutovalidateMode:\n'
                      '• `disabled`: Chỉ kiểm tra khi gọi lệnh `validate()`.\n'
                      '• `always`: Liên tục kiểm tra ngay từ khi khởi dựng widget.\n'
                      '• `onUserInteraction`: Bắt đầu kiểm tra và cập nhật thông báo lỗi ngay khi người dùng bắt đầu tương tác với ô nhập liệu (khuyến nghị cho UX tối ưu).',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    _buildCodeSnippet(
                      'String? validateEmail(String? value) {\n'
                      '  if (value == null || value.trim().isEmpty) {\n'
                      '    return "Vui lòng nhập email.";\n'
                      '  }\n'
                      '  final regex = RegExp(r"^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$");\n'
                      '  if (!regex.hasMatch(value.trim())) {\n'
                      '    return "Email không đúng định dạng!";\n'
                      '  }\n'
                      '  return null; // Hợp lệ!\n'
                      '}',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Mục 4: Quản lý Controller và Focus
                _buildTheoryCard(
                  title: '4. Quản Lý Controller và Focus (FocusNode)',
                  icon: Icons.touch_app_rounded,
                  iconColor: AppTheme.accentColor,
                  children: [
                    const Text(
                      '• `TextEditingController`:\n'
                      '  - Đọc và thay đổi giá trị của text field qua code (`controller.text = ...`).\n'
                      '  - Lắng nghe sự kiện thay đổi ký tự qua `addListener`.\n'
                      '  - Xóa dữ liệu qua `controller.clear()`.\n\n'
                      '• `FocusNode` & `FocusScope`:\n'
                      '  - Quản lý trạng thái tiêu điểm (đang được focus hay không).\n'
                      '  - Tự động nhảy sang ô tiếp theo khi nhấn phím Next: `FocusScope.of(context).requestFocus(_nextFocusNode)`.\n'
                      '  - Tự động focus vào trường bị lỗi đầu tiên khi validate thất bại.\n\n'
                      '⚠️ NGUYÊN TẮC VÀNG: Luôn gọi `.dispose()` cho mọi Controller và FocusNode trong hàm `dispose()` của State để giải phóng tài nguyên và chống tràn RAM!',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Mục 5: Nguyên tắc kiểm tra và phản hồi người dùng
                _buildTheoryCard(
                  title: '5. Nguyên Tắc Thiết Kế Biểu Mẫu & Phản Hồi Người Dùng (UX)',
                  icon: Icons.lightbulb_outline_rounded,
                  iconColor: AppTheme.warningColor,
                  children: [
                    _buildPrincipleItem(
                      '1. Rõ ràng & Dễ hiểu',
                      'Thông báo lỗi phải chỉ rõ người dùng sai ở đâu và hướng dẫn cách khắc phục cụ thể (Ví dụ: thay vì báo "Lỗi", hãy báo "Mật khẩu cần tối thiểu 8 ký tự và 1 số").',
                    ),
                    _buildPrincipleItem(
                      '2. Thời điểm phản hồi hợp lý',
                      'Tránh báo lỗi khi người dùng chưa kịp gõ xong. Nên dùng `AutovalidateMode.onUserInteraction` hoặc kiểm tra sau khi người dùng rời focus (blur).',
                    ),
                    _buildPrincipleItem(
                      '3. Trực quan & Đa giác quan',
                      'Kết hợp màu sắc (viền đỏ), biểu tượng (icon cảnh báo) và văn bản rõ ràng. Hỗ trợ thanh đo mật khẩu trực quan.',
                    ),
                    _buildPrincipleItem(
                      '4. Dẫn đường tiêu điểm (Focus Guidance)',
                      'Khi nộp form có lỗi, tự động di chuyển màn hình và đặt con trỏ vào ô lỗi đầu tiên để người dùng xử lý ngay mà không phải tự tìm.',
                    ),
                    _buildPrincipleItem(
                      '5. Ngăn ngừa lỗi từ đầu',
                      'Sử dụng đúng loại bàn phím (`keyboardType`), định dạng ngày tháng qua `DatePicker`, hạn chế nhập tự do cho dữ liệu cố định bằng `Dropdown`.',
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTheoryCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildCodeSnippet(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12.5,
          color: Color(0xFF38BDF8),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildPrincipleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppTheme.successColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), height: 1.4),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
