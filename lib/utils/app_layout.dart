import 'package:flutter/material.dart';
import 'package:project_x/utils/app_responsive.dart';

class AppLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

  const AppLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppResponsive.instance.isLandscape()) {
          return landscape;
        } else {
          return portrait;
        }
      },
    );
  }
}
