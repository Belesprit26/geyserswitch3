import 'package:flutter/material.dart';
import 'package:blx/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customButton(String buttonText, onPressed) {
  return SizedBox(
    width: 1.sw,
    height: 56.h,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.black, fontSize: 18.sp),
      ),
      style: ElevatedButton.styleFrom(
        primary: AppColors.yellow_accent,
        elevation: 3,
      ),
    ),
  );
}
