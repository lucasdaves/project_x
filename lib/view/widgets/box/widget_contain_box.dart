import 'package:flutter/material.dart';
import 'package:project_x/utils/app_responsive.dart';

class WidgetContainBox extends StatefulWidget {
  final WidgetContainModelBox model;

  const WidgetContainBox({super.key, required this.model});

  @override
  State<WidgetContainBox> createState() => _WidgetContainBoxState();
}

class _WidgetContainBoxState extends State<WidgetContainBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: AppResponsive.instance.getHeight(widget.model.height),
            width: AppResponsive.instance.getWidth(widget.model.width),
            margin: EdgeInsets.only(
              top: AppResponsive.instance.getHeight(24),
              bottom: AppResponsive.instance.getHeight(42),
            ),
            child: widget.model.widget,
          ),
        ),
      ],
    );
  }
}

class WidgetContainModelBox {
  final double height;
  final double width;
  final Widget widget;

  WidgetContainModelBox({
    required this.height,
    required this.width,
    required this.widget,
  });
}
