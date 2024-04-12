import 'package:flutter/material.dart';
import 'package:project_x/utils/app_text_style.dart';

class AppFeedback {
  final String text;
  final Color color;

  AppFeedback({
    required this.text,
    required this.color,
  });

  void showTopSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: color,
        content: SizedBox(
          width: double.maxFinite,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyle.size16(),
          ),
        ),
      ),
    );
  }
}
