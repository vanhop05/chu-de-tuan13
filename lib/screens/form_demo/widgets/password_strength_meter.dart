import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({
    super.key,
    required this.password,
  });

  Color _getColor(double strength) {
    if (strength <= 0.25) return Colors.red;
    if (strength <= 0.50) return Colors.orange;
    if (strength <= 0.75) return Colors.amber.shade700;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final strength = FormValidators.getPasswordStrength(password);
    final color = _getColor(strength);
    final label = FormValidators.getPasswordStrengthLabel(strength);

    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: strength,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Yêu cầu: ≥8 ký tự, 1 hoa, 1 thường, 1 số, 1 ký tự đặc biệt (!@#\$%...)',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
