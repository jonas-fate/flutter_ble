import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 输入框
Widget inputTextEdit({
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  required String hintText,
  bool isPassword = false,
  double marginTop = 15,
  List<TextInputFormatter>? inputFormatters,
  ValueChanged<String>? onChangedHandler,
}) {
  // return Container(
  //   width: 200.w,
  //   height: 44.h,
  //   margin: EdgeInsets.only(top: marginTop.h),
  //   child: Column(
  //     children: [
  //       Container(
  //         width: 200.w,
  //         height: 44.h,
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             border: Border.all(
  //               width: 1.5,
  //               color: Colors.black26,
  //             ),
  //             borderRadius: BorderRadius.all(Radius.circular(6))),
  //         child: TextField(
  //           controller: controller,
  //           keyboardType: keyboardType,
  //           decoration: InputDecoration(
  //             hintText: hintText,
  //             hintStyle: TextStyle(fontSize: 18),
  //             contentPadding: EdgeInsets.only(left: 20),
  //             border: InputBorder.none,
  //           ),
  //           style: TextStyle(
  //             color: Colors.black,
  //             // fontFamily: "Avenir",
  //             fontWeight: FontWeight.w400,
  //             fontSize: 18.sp,
  //             textBaseline: TextBaseline.alphabetic,
  //           ),
  //           maxLines: 1,
  //           autocorrect: false,
  //           obscureText: isPassword,
  //           inputFormatters: inputFormatters,
  //           onChanged: onChangedHandler,
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  return Container(
    // width: 120.w,
    // height: 44.h,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.5,
          color: Colors.black26,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6))),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 18),
        contentPadding: EdgeInsets.only(left: 10),
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black,
        // fontFamily: "Avenir",
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
        textBaseline: TextBaseline.alphabetic,
      ),
      maxLines: 1,
      autocorrect: false,
      obscureText: isPassword,
      inputFormatters: inputFormatters,
      onChanged: onChangedHandler,
    ),
  );
}
