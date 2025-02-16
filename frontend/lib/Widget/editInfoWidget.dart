import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class editInfoWidget extends StatefulWidget {
  final String selectedData;
  final IconData selectedI;
  final int selectediconColor;
  final int selectedtextColor;
  final double screenW;
  final double screenH;
  final TextEditingController dataController;
  final bool isNumeric;

  const editInfoWidget({
    super.key,
    required this.selectedData,
    required this.selectedI,
    required this.selectediconColor,
    required this.selectedtextColor,
    required this.screenW,
    required this.screenH,
    required this.dataController,
    required this.isNumeric,
  });

  @override
  State<StatefulWidget> createState() => _editInfoWidgetState();
}

class _editInfoWidgetState extends State<editInfoWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = widget.screenW;
    double screenHeight = widget.screenH;
    TextEditingController dataController = widget.dataController;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.015,
        vertical: screenHeight * 0.005,
      ),
      child: TextField(
        controller: dataController,
        keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: widget.isNumeric
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        decoration: InputDecoration(
          hintText: widget.selectedData,
          hintStyle: TextStyle(
            color: Color(widget.selectedtextColor).withOpacity(0.5),
          ),

          prefixIcon: Icon(
            widget.selectedI,
            color: Color(widget.selectediconColor),
            size: screenWidth * 0.08,
          ),
        ),
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          color: Color(widget.selectedtextColor),
        ),
      ),
    );
  }
}
