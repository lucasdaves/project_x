import 'package:flutter/material.dart';
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
    return Container(
      height: AppResponsive.instance.getHeight(56),
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.dehaze_rounded,
              color: Colors.white,
              size: AppResponsive.instance.getWidth(32),
            ),
          ),
          SizedBox(width: AppResponsive.instance.getWidth(32)),
          Text(
            widget.model.title,
            style: AppTextStyle.size24(),
          )
        ],
      ),
    );
  }
}

class WidgetTitleHeaderModel {
  final String title;

  WidgetTitleHeaderModel({required this.title});
}
