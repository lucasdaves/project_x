import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/home/home_view.dart';
import 'package:project_x/view/login/login_view.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';

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
    await SystemController.instance.mockSystem();
    await UserController.instance.mockUser();

    AppRoute(
      tag: hasLogin ? HomeView.tag : LoginView.tag,
      screen: hasLogin ? HomeView() : LoginView(),
    ).navigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(),
      body: _buildBody(),
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
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ProjectX",
            textAlign: TextAlign.center,
            style: AppTextStyle.size48(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: AppResponsive.instance.getHeight(24),
          ),
          Text(
            "gerencie seus clientes, projetos e financeiros",
            textAlign: TextAlign.center,
            style: AppTextStyle.size24(fontWeight: FontWeight.w300),
          ),
        ],
      );
    }

    Widget buildLoader() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: AppResponsive.instance.getHeight(32),
            width: AppResponsive.instance.getHeight(32),
            child: CircularProgressIndicator(
              color: AppColor.colorSecondary,
            ),
          ),
          SizedBox(
            height: AppResponsive.instance.getHeight(32),
          ),
          Text(
            "Validando sessão ...",
            textAlign: TextAlign.center,
            style: AppTextStyle.size20(
              color: AppColor.colorSecondary,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
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
              SizedBox(
                height: AppResponsive.instance.getHeight(64),
              ),
              buildLoader(),
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
