import 'package:flutter/material.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/client/client_view.dart';

class WidgetEndDrawer extends StatelessWidget {
  const WidgetEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      width: AppResponsive.instance.getWidth(250),
      backgroundColor: AppColor.colorPrimary,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.instance.getHeight(24),
              horizontal: AppResponsive.instance.getWidth(24),
            ),
            decoration: const BoxDecoration(
              color: AppColor.colorFloating,
            ),
            alignment: Alignment.center,
            child: Text(
              UserController.instance.stream.value.user!.personal!.model!.name,
              style: AppTextStyle.size24(),
            ),
          ),
          SizedBox(
            height: AppResponsive.instance.getHeight(24),
          ),
          buildCard(context, type: EntityType.User),
          buildCard(context, type: EntityType.System),
        ],
      ),
    );
  }

  Widget buildCard(
    BuildContext context, {
    required EntityType type,
  }) {
    String label;
    Function() function;
    switch (type) {
      case EntityType.User:
        label = "Conta";
        function = () {
          AppRoute(
            tag: ClientView.tag,
            screen: ClientView(),
          ).navigate(context);
        };
        break;
      case EntityType.System:
        label = "Sistema";
        function = () {
          AppRoute(
            tag: ClientView.tag,
            screen: ClientView(),
          ).navigate(context);
        };
        break;

      default:
        label = "";
        function = () {};
        break;
    }

    return GestureDetector(
      onTap: function,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppResponsive.instance.getHeight(12),
          horizontal: AppResponsive.instance.getWidth(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: AppTextStyle.size20(),
              ),
            ),
            SizedBox(
              width: AppResponsive.instance.getWidth(12),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.colorSecondary,
              size: AppResponsive.instance.getWidth(32),
            ),
          ],
        ),
      ),
    );
  }
}
