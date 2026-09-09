import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textLight,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Focus(
            onFocusChange: (hasFocus) {
              setState(() => _isFocused = hasFocus);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isFocused ? Colors.white : AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isFocused ? AppColors.pink : Colors.transparent,
                  width: 2,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.pink.withOpacity(0.15),
                          blurRadius: 16,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.isPassword && _obscureText,
                validator: widget.validator,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFFBFA8CC),
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: AnimatedScale(
                    scale: _isFocused ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      widget.icon,
                      color: _isFocused
                          ? AppColors.pink
                          : AppColors.textLight.withOpacity(0.55),
                      size: 22,
                    ),
                  ),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: _isFocused
                                ? AppColors.textLight
                                : AppColors.textLight.withOpacity(0.35),
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() => _obscureText = !_obscureText);
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
