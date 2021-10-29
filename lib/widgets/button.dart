import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///扁平圆角按钮
Widget globalFlatButton({
  required VoidCallback onPressed,
  double width = 180,
  double height = 50,
  String title = "button",
  double fontSize = 12,
}) {
  return Container(
    width: width.w,
    height: height.h,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: fontSize.sp,
          ),
        ),
      ),
    ),
  );
}
