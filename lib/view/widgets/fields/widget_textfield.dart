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
              validator: widget.model.validator,
              initialValue: null,
              minLines: null,
              maxLines: null,
              expands: true,
              style: AppTextStyle.size14(),
              cursorColor: AppColor.colorSecondary,
              cursorErrorColor: AppColor.colorNegativeStatus,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                if (widget.model.changed != null) {
                  widget.model.changed!(value);
                }
              },
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
      ],
    );
  }
}

class WidgetTextFieldModel {
  final TextEditingController controller;
  final String? headerText;
  final String? hintText;
  final String? Function(String?)? validator;
  final Function(String?)? changed;

  WidgetTextFieldModel({
    required this.controller,
    this.headerText,
    this.hintText,
    this.validator,
    this.changed,
  });
}
