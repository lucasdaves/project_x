import 'package:flutter/material.dart';
import 'package:project_x/utils/app_const.dart';
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
        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(AppConst.imageBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: AppResponsive.instance.isLandscape() ? landscape : portrait,
        );
      },
    );
  }
}
