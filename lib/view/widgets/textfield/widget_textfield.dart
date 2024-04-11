import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetTextField extends StatefulWidget {
  final WidgetTextFieldModel model;

  const WidgetTextField({super.key, required this.model});

  @override
  State<WidgetTextField> createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          title: Text(
            widget.model.headerText!,
            style: AppTextStyle.size14(),
          ),
          subtitle: Container(
            height: AppResponsive.instance.getHeight(50),
            margin: EdgeInsets.only(top: AppResponsive.instance.getHeight(12)),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.colorDivider, width: 2),
              borderRadius: BorderRadius.circular(8),
              color: AppColor.colorFieldBackground,
            ),
            child: TextFormField(
              controller: widget.model.controller,
              validator: (value) {
                if (widget.model.validator != null &&
                    widget.model.validator!(value)) {
                  return widget.model.feedbackText;
                } else {
                  return null;
                }
              },
              initialValue: null,
              maxLines: null,
              expands: true,
              style: AppTextStyle.size14(),
              cursorColor: AppColor.colorSecondary,
              cursorErrorColor: AppColor.colorNegativeStatus,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: widget.model.hintText,
                hintStyle: AppTextStyle.size12(
                  color: AppColor.text_1,
                  fontWeight: FontWeight.w300,
                ),
                errorStyle: AppTextStyle.size12(
                  color: AppColor.colorNegativeStatus,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.instance.getWidth(12),
                ),
              ),
            ),
          ),
        ),
        if (hasError && widget.model.feedbackText != null) ...[
          Padding(
            padding: EdgeInsets.only(top: AppResponsive.instance.getHeight(4)),
            child: Text(
              widget.model.feedbackText!,
              style: AppTextStyle.size12(
                color: AppColor.colorNegativeStatus,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class WidgetTextFieldModel {
  final TextEditingController controller;
  final String? headerText;
  final String? hintText;
  final String? feedbackText;
  final bool Function(String?)? validator;

  WidgetTextFieldModel({
    required this.controller,
    this.headerText,
    this.hintText,
    this.feedbackText,
    this.validator,
  });
}
