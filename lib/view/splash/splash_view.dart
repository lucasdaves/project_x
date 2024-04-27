import 'package:flutter/material.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/load/load_view.dart';
import 'package:project_x/view/login/login_view.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/drawer/widget_flow_drawer.dart';
import 'package:project_x/view/widgets/drawer/widget_user_drawer.dart';

class SplashView extends StatefulWidget {
  static const String tag = "/splash_view";
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    _initAppConfigs();
    super.initState();
  }

  Future<void> _initAppConfigs() async {
    bool hasLogin = await UserController.instance.hasLogin();
    await UserController.instance.mockUser();
    await Future.delayed(const Duration(milliseconds: 1000));

    AppRoute(
      tag: hasLogin ? LoadView.tag : LoginView.tag,
      screen: hasLogin ? LoadView() : LoginView(),
    ).navigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(),
      body: _buildBody(),
      drawer: WidgetStartDrawer(),
      endDrawer: WidgetEndDrawer(),
      backgroundColor: AppColor.colorPrimary,
    );
  }

  PreferredSizeWidget _buildBar() {
    return const WidgetAppBar();
  }

  Widget _buildBody() {
    return AppLayout(
      landscape: _buildLandscape(context),
      portrait: _buildPortrait(context),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    Widget buildTitle() {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Project",
              style: AppTextStyle.size48(
                color: AppColor.text_1,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: "X",
              style: AppTextStyle.size48(
                color: AppColor.text_1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        style: AppTextStyle.size48(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppResponsive.instance.getWidth(500),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTitle(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }
}
