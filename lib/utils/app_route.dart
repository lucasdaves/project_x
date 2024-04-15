import 'package:flutter/material.dart';

class AppRoute {
  final String tag;
  final dynamic screen;
  final bool reset;

  AppRoute({
    required this.tag,
    required this.screen,
    this.reset = false,
  });

  void navigate(BuildContext context) {
    if (context.mounted) {
      if (reset) {
        Navigator.of(context).popUntil(
          ModalRoute.withName("/home_view"),
        );
      }
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
}
