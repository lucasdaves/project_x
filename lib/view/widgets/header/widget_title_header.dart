import 'package:flutter/material.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';

class WidgetTitleHeader extends StatefulWidget {
  final WidgetTitleHeaderModel model;

  const WidgetTitleHeader({super.key, required this.model});

  @override
  State<WidgetTitleHeader> createState() => _WidgetTitleHeaderState();
}

class _WidgetTitleHeaderState extends State<WidgetTitleHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserController.instance.stream,
      builder: (context, snapshot) {
        return Container(
          height: AppResponsive.instance.getHeight(56),
          width: double.maxFinite,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.dehaze_rounded,
                      color: AppColor.colorSecondary,
                      size: AppResponsive.instance.getWidth(32),
                    ),
                    SizedBox(width: AppResponsive.instance.getWidth(24)),
                    Text(
                      widget.model.title,
                      style: AppTextStyle.size24(),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      UserController.instance.stream.value.user?.personal?.model
                              ?.name ??
                          "",
                      style: AppTextStyle.size24(),
                    ),
                    SizedBox(
                      width: AppResponsive.instance.getWidth(12),
                    ),
                    Icon(
                      Icons.person_rounded,
                      color: AppColor.colorSecondary,
                      size: AppResponsive.instance.getWidth(32),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class WidgetTitleHeaderModel {
  final String title;

  WidgetTitleHeaderModel({required this.title});
}
