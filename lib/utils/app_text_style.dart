import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';

class AppTextStyle {
  static TextStyle size12({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? AppColor.text_1,
      fontSize: AppResponsive.instance.getWidth(12),
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1,
    );
  }

  static TextStyle size14({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? AppColor.text_1,
      fontSize: AppResponsive.instance.getWidth(14),
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.1,
    );
  }

  static TextStyle size16({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? AppColor.text_1,
      fontSize: AppResponsive.instance.getWidth(16),
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.1,
    );
  }

  static TextStyle size20({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? AppColor.text_1,
      fontSize: AppResponsive.instance.getWidth(20),
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.1,
    );
  }

  static TextStyle size24({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? AppColor.text_1,
      fontSize: AppResponsive.instance.getWidth(24),
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.1,
    );
  }

  static TextStyle size48({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? AppColor.text_1,
      fontSize: AppResponsive.instance.getWidth(48),
      fontWeight: fontWeight ?? FontWeight.w400,
      height: 1.1,
    );
  }
}
