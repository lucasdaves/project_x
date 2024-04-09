import 'package:flutter/material.dart';

class AppRoute {
  final String tag;
  final dynamic screen;

  AppRoute({
    required this.tag,
    required this.screen,
  });

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(
          name: tag,
        ),
      ),
    );
  }
}
