import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime? formatDatetime() {
    try {
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(this);
      return dateTime;
    } catch (error) {
      return null;
    }
  }
}

extension DateTimeExtension on DateTime {
  String? formatString() {
    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      String formattedDate = dateFormat.format(this);
      return formattedDate;
    } catch (error) {
      return null;
    }
  }
}

class ObscuringTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      required bool withComposing,
      TextStyle? style}) {
    var displayValue = '•' * value.text.length;
    if (!value.composing.isValid || !withComposing) {
      return TextSpan(style: style, text: displayValue);
    }
    final TextStyle? composingStyle = style?.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: value.composing.textBefore(displayValue)),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(displayValue),
        ),
        TextSpan(text: value.composing.textAfter(displayValue)),
      ],
    );
  }
}
