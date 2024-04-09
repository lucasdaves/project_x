import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetTextField extends StatelessWidget {
  final WidgetTextFieldModel model;

  const WidgetTextField({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      title: Text(
        model.headerText!,
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
          validator: (controller) {
            if (controller == null || controller.isEmpty) {
              return model.feedbackText;
            }
            return null;
          },
          initialValue: null,
          maxLines: null,
          controller: model.controller,
          expands: true,
          style: AppTextStyle.size14(),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: model.hintText,
            hintStyle: AppTextStyle.size12(fontWeight: FontWeight.w300),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppResponsive.instance.getWidth(12),
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetTextFieldModel {
  final TextEditingController controller;
  final String? headerText;
  final String? hintText;
  final String? feedbackText;
  final bool Function(String)? validator;

  WidgetTextFieldModel({
    required this.controller,
    this.headerText,
    this.hintText,
    this.feedbackText,
    this.validator,
  });
}
