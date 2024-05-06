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

  GlobalKey? dropdownButtonKey = GlobalKey();

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext? element) {
      element?.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
        } else {
          searchForGestureDetector(element);
        }
      });
    }

    searchForGestureDetector(dropdownButtonKey?.currentContext);
    assert(detector != null);

    detector?.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDropdown(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        title: Text(
          widget.model.headerText ?? '',
          style: AppTextStyle.size14(),
        ),
        subtitle: Container(
          height: AppResponsive.instance.getHeight(55),
          margin: EdgeInsets.only(top: AppResponsive.instance.getHeight(12)),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.instance.getWidth(12),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.colorDivider, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: AppColor.colorFieldBackground,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              DropdownButtonFormField<String>(
                key: dropdownButtonKey,
                value: widget.model.controller.text.isNotEmpty
                    ? widget.model.controller.text
                    : null,
                isDense: true,
                isExpanded: true,
                items: widget.model.options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.size14(
                        color: AppColor.colorFieldBackground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (widget.model.isDisabled)
                    ? null
                    : (newValue) {
                        setState(() {
                          widget.model.controller.text = newValue ?? '';
                          if (widget.model.function != null)
                            widget.model.function!();
                        });
                      },
                validator: widget.model.validator,
                dropdownColor: AppColor.text_1,
                style: TextStyle(color: Colors.transparent),
                iconEnabledColor: Colors.transparent,
                iconDisabledColor: Colors.transparent,
                focusColor: Colors.transparent,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.transparent),
                  hintText: null,
                  hintStyle: null,
                  errorStyle: AppTextStyle.size12(
                    color: AppColor.colorNegativeStatus,
                    fontWeight: FontWeight.w300,
                  ),
                  border: InputBorder.none,
                ),
              ),
              getText(),
            ],
          ),
        ),
      ),
    );
  }

  Row getText() {
    String text = "";
    TextStyle style = TextStyle();
    if (widget.model.controller.text != "") {
      text = widget.model.controller.text;
      style = AppTextStyle.size14();
    } else {
      text = widget.model.hintText ?? "";
      style = AppTextStyle.size12(
        color: AppColor.text_1,
        fontWeight: FontWeight.w300,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: Text(text, style: style)),
        if (!widget.model.isDisabled) ...[
          Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColor.colorSecondary,
            size: AppResponsive.instance.getWidth(24),
          ),
        ],
      ],
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
  final bool isDisabled;

  WidgetSelectorFieldModel({
    required this.controller,
    this.headerText,
    this.hintText,
    required this.options,
    this.validator,
    this.function,
    this.isDisabled = false,
  });
}
