import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetListEntityCard extends StatelessWidget {
  final String value1;
  final String value2;
  final String? value3;
  final String? value4;
  final Color color1;
  final Color color2;
  final Color? color3;
  final Color? color4;
  final bool isHeader;
  final Function()? function;

  const WidgetListEntityCard({
    super.key,
    required this.value1,
    required this.value2,
    this.value3,
    this.value4,
    this.color1 = AppColor.text_1,
    this.color2 = AppColor.text_1,
    this.color3 = AppColor.text_1,
    this.color4 = AppColor.text_1,
    this.isHeader = false,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: double.maxFinite,
        height: AppResponsive.instance.getHeight(50),
        decoration: BoxDecoration(
          border: Border(
            bottom: (isHeader)
                ? BorderSide.none
                : BorderSide(width: 2, color: AppColor.colorDivider),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                value1,
                style: AppTextStyle.size14(color: color1),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                value2,
                style: AppTextStyle.size14(color: color2),
              ),
            ),
            if (value3 != null) ...[
              Expanded(
                flex: 1,
                child: Text(
                  value3!,
                  style: AppTextStyle.size14(color: color3),
                ),
              ),
            ],
            if (value4 != null) ...[
              Expanded(
                flex: 1,
                child: Text(
                  value4!,
                  style: AppTextStyle.size14(color: color4),
                ),
              ),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: (!isHeader || function != null)
                  ? AppColor.colorSecondary
                  : Colors.transparent,
              size: AppResponsive.instance.getWidth(24),
            ),
          ],
        ),
      ),
    );
  }
}
