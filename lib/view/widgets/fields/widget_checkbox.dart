import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetCheckBox extends StatelessWidget {
  final WidgetCheckBoxModel model;

  const WidgetCheckBox({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.function,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (model.title != null) ...[
            Text(
              model.title!,
              style: AppTextStyle.size12(),
            ),
            SizedBox(
              width: AppResponsive.instance.getWidth(12),
            ),
          ],
          Container(
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
          ),
        ],
      ),
    );
  }
}

class WidgetCheckBoxModel {
  final String? title;
  final double size;
  final Color color;
  final bool checked;
  final Function()? function;

  WidgetCheckBoxModel({
    this.title,
    this.size = 20,
    this.color = AppColor.colorSecondary,
    this.checked = false,
    this.function,
  });
}
