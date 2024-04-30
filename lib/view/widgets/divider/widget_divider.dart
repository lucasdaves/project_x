import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';

class WidgetDivider extends StatefulWidget {
  final double verticalSpace;
  final double horizontalSpace;

  const WidgetDivider({
    super.key,
    required this.verticalSpace,
    required this.horizontalSpace,
  });

  @override
  State<WidgetDivider> createState() => _WidgetDividerState();
}

class _WidgetDividerState extends State<WidgetDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppResponsive.instance.getHeight(widget.verticalSpace),
        horizontal: AppResponsive.instance.getWidth(widget.horizontalSpace),
      ),
      child: DottedLine(
        dashLength: AppResponsive.instance.getWidth(6),
        dashGapLength: AppResponsive.instance.getWidth(6),
        lineThickness: AppResponsive.instance.getWidth(2),
        dashColor: AppColor.colorDivider,
        dashGapColor: AppColor.colorPrimary,
      ),
    );
  }
}
