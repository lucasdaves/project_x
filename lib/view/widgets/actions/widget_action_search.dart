import 'package:flutter/material.dart';
import 'package:project_x/view/widgets/fields/widget_search.dart';

class WidgetActionSearch extends StatelessWidget {
  final WidgetActionSearchModel model;

  const WidgetActionSearch({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return WidgetSearchField(
      model: WidgetSearchFieldModel(
        controller: model.controller,
        hintText: model.hintText,
        changed:
            model.changed != null ? (value) => model.changed!(value) : null,
      ),
    );
  }
}

class WidgetActionSearchModel {
  final TextEditingController controller;

  final String? hintText;
  final String? Function(String?)? validator;
  final Function(String?)? changed;
  final Function(String?)? function;

  WidgetActionSearchModel({
    required this.controller,
    this.hintText,
    this.validator,
    this.changed,
    this.function,
  });
}
