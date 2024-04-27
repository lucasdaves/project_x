import 'package:flutter/material.dart';

class AppRoute {
  final String tag;
  final dynamic screen;
  final String? reset;

  AppRoute({
    required this.tag,
    required this.screen,
    this.reset,
  });

  void navigate(BuildContext context) {
    if (context.mounted) {
      if (reset != null) {
        Navigator.of(context).popUntil(
          ModalRoute.withName(reset!),
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
