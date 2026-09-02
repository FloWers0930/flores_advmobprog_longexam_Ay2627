import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CustomButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final CustomButtonType buttonType;
  final String buttonName;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    this.buttonType = CustomButtonType.filled,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: ScreenUtil().setWidth(30),
      vertical: ScreenUtil().setHeight(10),
    );

    switch (buttonType) {
      case CustomButtonType.filled:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF0F2F5),
            elevation: 0,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

      case CustomButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            side: const BorderSide(color: Color.fromARGB(255, 85, 85, 85)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

      case CustomButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(padding: padding),
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12),
              color: Colors.black,
            ),
          ),
        );
    }
  }
}
