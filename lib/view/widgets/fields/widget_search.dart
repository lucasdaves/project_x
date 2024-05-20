import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetSearchField extends StatefulWidget {
  final WidgetSearchFieldModel model;

  const WidgetSearchField({super.key, required this.model});

  @override
  State<WidgetSearchField> createState() => _WidgetSearchFieldState();
}

class _WidgetSearchFieldState extends State<WidgetSearchField> {
  late double height;

  @override
  void initState() {
    super.initState();
    getHeight();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: AppResponsive.instance.getHeight(height),
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.instance.getHeight(6),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.colorFloating,
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              Expanded(
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
                    setState(() {
                      if (widget.model.changed != null) {
                        widget.model.changed!(value);
                      }
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(150),
                  ],
                  decoration: InputDecoration(
                    hintText: widget.model.hintText,
                    hintStyle: AppTextStyle.size12(
                      color: AppColor.text_2,
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.model.controller.text.isNotEmpty) {
                      widget.model.controller.text = "";
                      if (widget.model.changed != null) {
                        widget.model.changed!(widget.model.controller.text);
                      }
                    }
                  });
                },
                child: Container(
                  width: AppResponsive.instance.getHeight(36),
                  height: AppResponsive.instance.getHeight(36),
                  margin: EdgeInsets.symmetric(
                    horizontal: AppResponsive.instance.getWidth(8),
                  ),
                  padding: EdgeInsets.all(AppResponsive.instance.getWidth(8)),
                  decoration: BoxDecoration(
                    color: AppColor.colorSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      widget.model.controller.text.isEmpty
                          ? Icons.search_rounded
                          : Icons.close_rounded,
                      color: AppColor.text_1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void getHeight() {
    setState(() {
      height = 55;
    });
  }
}

class WidgetSearchFieldModel {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final Function(String?)? changed;

  WidgetSearchFieldModel({
    required this.controller,
    this.hintText,
    this.validator,
    this.changed,
  });
}
