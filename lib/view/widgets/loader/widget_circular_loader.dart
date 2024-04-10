import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';

class WidgetCircularLoader extends StatelessWidget {
  final WidgetCircularLoaderModel model;

  const WidgetCircularLoader({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppResponsive.instance.getWidth(model.size),
      width: AppResponsive.instance.getHeight(model.size),
      child: CircularProgressIndicator(
        color: model.color,
        strokeWidth: 2,
      ),
    );
  }
}

class WidgetCircularLoaderModel {
  final double size;
  final Color color;

  WidgetCircularLoaderModel({
    this.size = 50,
    this.color = AppColor.colorSecondary,
  });
}
