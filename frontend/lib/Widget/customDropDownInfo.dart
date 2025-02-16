import 'package:flutter/material.dart';

class customDropDownInfo<T> extends StatefulWidget {
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final IconData icon;
  final int iconColor;
  final int textColor;
  final double screenW;
  final double screenH;
  final String hintText;
  final List<DropdownMenuItem<T>> items;

  const customDropDownInfo({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.screenW,
    required this.screenH,
    required this.hintText,
    required this.items,
  });

  @override
  State<customDropDownInfo<T>> createState() => _customDropDownInfoState<T>();
}

class _customDropDownInfoState<T> extends State<customDropDownInfo<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.screenW * 0.01,
        vertical: widget.screenH * 0.001,
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(widget.textColor).withOpacity(0.5),
          ),
          prefixIcon: Icon(
            widget.icon,
            color: Color(widget.iconColor),
            size: widget.screenW * 0.075,
          ),
          border: InputBorder.none,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            hint: Text(
              widget.hintText,
              style: TextStyle(
                color: Color(widget.textColor).withOpacity(1),
                fontSize: widget.screenW * 0.045,
              ),
            ),
            value: widget.selectedValue,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Color(widget.iconColor),
            ),
            isExpanded: true,
            onChanged: widget.onChanged,
            items: widget.items,
          ),
        ),
      ),
    );
  }
}

