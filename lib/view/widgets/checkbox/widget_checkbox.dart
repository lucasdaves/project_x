import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';

class WidgetCheckBox extends StatelessWidget {
  final WidgetCheckBoxModel model;

  const WidgetCheckBox({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.instance.getWidth(model.size),
      width: AppResponsive.instance.getWidth(model.size),
      child: FittedBox(
        fit: BoxFit.fill,
        child: model.checked
            ? Icon(
                Icons.check_box_rounded,
                color: model.color,
              )
            : Icon(
                Icons.check_box_outline_blank_rounded,
                color: model.color,
              ),
      ),
    );
  }
}

class WidgetCheckBoxModel {
  final double size;
  final Color color;
  final bool checked;

  WidgetCheckBoxModel({
    this.size = 20,
    this.color = AppColor.colorSecondary,
    this.checked = false,
  });
}
