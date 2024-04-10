import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetTextButton extends StatefulWidget {
  final WidgetTextButtonModel model;

  const WidgetTextButton({super.key, required this.model});

  @override
  State<WidgetTextButton> createState() => _WidgetTextButtonState();
}

class _WidgetTextButtonState extends State<WidgetTextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.model.function,
      child: Text.rich(
        TextSpan(
          children: [
            if (widget.model.preLabel != null) ...[
              TextSpan(
                text: "${widget.model.preLabel} ",
                style: AppTextStyle.size16(
                  color: widget.model.preLabelcolor,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
            TextSpan(
              text: widget.model.label,
              style: AppTextStyle.size16(
                color: widget.model.labelColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        style: AppTextStyle.size16(),
      ),
    );
  }
}

class WidgetTextButtonModel {
  final String label;
  final String? preLabel;
  final Color labelColor;
  final Color preLabelcolor;
  final Function() function;

  WidgetTextButtonModel({
    required this.label,
    this.preLabel,
    this.preLabelcolor = AppColor.text_1,
    this.labelColor = AppColor.colorSecondary,
    required this.function,
  });
}
