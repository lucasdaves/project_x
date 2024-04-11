import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetActionBack extends StatelessWidget {
  final WidgetActionBackModel model;

  const WidgetActionBack({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.function,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            model.icon,
            color: model.iconColor,
            size: AppResponsive.instance.getWidth(32),
          ),
          SizedBox(
            width: AppResponsive.instance.getWidth(16),
          ),
          Text(
            model.label,
            style: AppTextStyle.size20(
              color: model.textColor,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}

class WidgetActionBackModel {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color textColor;
  final Function() function;

  WidgetActionBackModel({
    required this.icon,
    this.iconColor = AppColor.colorSecondary,
    required this.label,
    this.textColor = AppColor.text_1,
    required this.function,
  });
}
