import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/widgets/widget_app_bar.dart';

class SplashView extends StatefulWidget {
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

  void _initAppConfigs() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(),
      body: _buildBody(),
      backgroundColor: AppColor.colorPrimary,
    );
  }

  PreferredSizeWidget _buildBar() {
    return const CustomAppBar();
  }

  Widget _buildBody() {
    return AppLayout(
      landscape: _buildLandscape(context),
      portrait: _buildPortrait(context),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Container(
      height: AppResponsive.instance.getDeviceHeight(),
      width: AppResponsive.instance.getDeviceWidth(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppResponsive.instance.getWidth(302),
            height: AppResponsive.instance.getHeight(492),
            color: Colors.white,
            child: Column(
              children: [
                Text("ProjectX"),
                Text("Gerencie seus clientes, projetos e financeiro"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container(
      height: AppResponsive.instance.getDeviceHeight(),
      width: AppResponsive.instance.getDeviceWidth(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppResponsive.instance.getWidth(200),
            height: AppResponsive.instance.getHeight(500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text("ProjectX"),
                Text("Gerencie seus clientes, projetos e financeiro"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
