import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetSelectorField extends StatefulWidget {
  final WidgetSelectorFieldModel model;

  const WidgetSelectorField({super.key, required this.model});

  @override
  State<WidgetSelectorField> createState() => _WidgetSelectorFieldState();
}

class _WidgetSelectorFieldState extends State<WidgetSelectorField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      title: Text(
        widget.model.headerText ?? '',
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
        child: DropdownButtonFormField<String>(
          value: widget.model.controller.text != ""
              ? widget.model.controller.text
              : null,
          isDense: true,
          isExpanded: true,
          items: widget.model.options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: AppTextStyle.size14(),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              widget.model.controller.text = newValue ?? '';
              if (widget.model.function != null) widget.model.function!();
            });
          },
          validator: widget.model.validator,
          style: AppTextStyle.size14(),
          dropdownColor: AppColor.colorPrimary,
          decoration: InputDecoration(
            hintText: widget.model.hintText ?? '',
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
    );
  }
}

class WidgetSelectorFieldModel {
  final TextEditingController controller;
  final String? headerText;
  final String? hintText;
  final List<String> options;
  final String? Function(String?)? validator;
  final Function()? function;

  WidgetSelectorFieldModel({
    required this.controller,
    this.headerText,
    this.hintText,
    required this.options,
    this.validator,
    this.function,
  });
}
