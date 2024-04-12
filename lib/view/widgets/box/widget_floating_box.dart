import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetFloatingBox extends StatefulWidget {
  final WidgetFloatingBoxModel model;

  const WidgetFloatingBox({super.key, required this.model});

  @override
  State<WidgetFloatingBox> createState() => _WidgetFloatingBoxState();
}

class _WidgetFloatingBoxState extends State<WidgetFloatingBox> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.label != null) ...[
            Text(
              widget.model.label!,
              style: AppTextStyle.size20(),
            ),
            SizedBox(
              height: AppResponsive.instance.getHeight(16),
            )
          ],
          Container(
            width: double.maxFinite,
            padding: widget.model.padding ??
                EdgeInsets.all(
                  AppResponsive.instance.getWidth(12),
                ),
            decoration: BoxDecoration(
              color: AppColor.colorFloating,
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.model.widget,
          ),
        ],
      ),
    );
  }
}

class WidgetFloatingBoxModel {
  final String? label;
  final EdgeInsets? padding;
  final Widget widget;

  WidgetFloatingBoxModel({
    this.label,
    this.padding,
    required this.widget,
  });
}
