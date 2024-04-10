import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/widgets/loader/widget_circular_loader.dart';

class WidgetSolidButton extends StatefulWidget {
  final WidgetSolidButtonModel model;

  const WidgetSolidButton({super.key, required this.model});

  @override
  State<WidgetSolidButton> createState() => _WidgetSolidButtonState();
}

class _WidgetSolidButtonState extends State<WidgetSolidButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.model.function,
      child: Container(
        width: AppResponsive.instance.getWidth(widget.model.width),
        height: AppResponsive.instance.getHeight(widget.model.height),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.model.color,
        ),
        child: widget.model.loading
            ? WidgetCircularLoader(
                model: WidgetCircularLoaderModel(
                  color: Colors.white,
                  size: 24,
                ),
              )
            : Text(
                widget.model.label,
                style: AppTextStyle.size16(),
              ),
      ),
    );
  }
}

class WidgetSolidButtonModel {
  final String label;
  final double width;
  final double height;
  final Color color;
  final bool loading;
  final Function() function;

  WidgetSolidButtonModel({
    required this.label,
    this.width = double.maxFinite,
    this.height = 50,
    this.color = AppColor.colorSecondary,
    required this.loading,
    required this.function,
  });
}
