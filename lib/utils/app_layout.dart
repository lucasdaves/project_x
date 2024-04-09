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
    bool isLandscape = AppResponsive.instance.isLandscape();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: AppResponsive.instance.getDeviceWidth(),
          height: AppResponsive.instance.getDeviceHeight(),
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(
                isLandscape
                    ? AppConst.imageBackgroundLandscape
                    : AppConst.imageBackgroundPortrait,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: isLandscape ? landscape : portrait,
        );
      },
    );
  }
}
