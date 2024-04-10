import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/view/widgets/header/widget_app_bar.dart';

class HomeView extends StatefulWidget {
  static const String tag = "/home_view";
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    return Container();
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }
}
