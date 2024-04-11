import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetActionIcon extends StatelessWidget {
  final WidgetActionIconModel model;

  const WidgetActionIcon({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.function,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            model.icon,
            color: model.iconColor,
            size: AppResponsive.instance.getWidth(20),
          ),
          Text(
            model.label,
            style: AppTextStyle.size12(
              color: model.textColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetActionIconModel {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color textColor;
  final Function() function;

  WidgetActionIconModel({
    required this.icon,
    this.iconColor = AppColor.colorSecondary,
    required this.label,
    this.textColor = AppColor.text_1,
    required this.function,
  });
}
