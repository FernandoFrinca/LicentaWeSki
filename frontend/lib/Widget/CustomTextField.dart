import 'package:flutter/material.dart';

import '../Assets/Colors.dart';


class CustomTextFormField extends StatefulWidget {
  final IconData icon;
  final String label;
  final int borderColor;
  final int fillColor;
  final int iconColor;
  final int texColor;
  final double borderRadius;
  final bool errorState;
  final bool isPasswordField;

  CustomTextFormField({
    super.key,
    required this.icon,
    required this.label,
    required this.borderColor,
    required this.fillColor,
    required this.texColor,
    required this.iconColor,
    required this.borderRadius,
    required this.errorState,
    this.isPasswordField = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      obscureText: widget.isPasswordField && !_passwordVisible,
      style: TextStyle(color: Color(licentaColors.opacity | widget.texColor)),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(licentaColors.opacity | widget.borderColor)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius),
            bottomRight: Radius.circular(widget.borderRadius),
            bottomLeft: Radius.circular(widget.borderRadius),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(licentaColors.opacity | widget.borderColor)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius),
            bottomRight: Radius.circular(widget.borderRadius),
            bottomLeft: Radius.circular(widget.borderRadius),
          ),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Color(licentaColors.opacity | widget.iconColor),
        ),
        suffixIcon: widget.isPasswordField
            ? IconButton(
          icon: Icon(
            color: Color(widget.fillColor == theme.colorScheme.primary.value ? licentaColors.opacity | theme.colorScheme.secondary.value: licentaColors.opacity | theme.colorScheme.primary.value),
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ) : null,
        hintText: widget.label,
        hintStyle: TextStyle(color: Color(licentaColors.opacity | widget.texColor)),
        filled: true,
        fillColor: Color(licentaColors.opacity | widget.fillColor),
        errorText: widget.errorState ? "Error" : null,
      ),
    );
  }
}
