import 'package:flutter/material.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/create/create_view.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/buttons/widget_text_button.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';

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
    return const WidgetAppBar();
  }

  Widget _buildBody() {
    return AppLayout(
      landscape: _buildLandscape(context),
      portrait: _buildPortrait(context),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return WidgetContainBox(
      model: WidgetContainModelBox(
        height: double.maxFinite,
        width: 900,
        widget: Column(
          children: [
            WidgetTitleHeader(
              model: WidgetTitleHeaderModel(title: "Dashboard"),
            ),
            SizedBox(height: AppResponsive.instance.getHeight(24)),
            WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                widget: Column(
                  children: [
                    WidgetTextButton(
                      model: WidgetTextButtonModel(
                        label: "Cadastrar cliente",
                        function: () {
                          AppRoute(
                            tag: CreateView.tag,
                            screen: CreateView(type: EntityType.Client),
                          ).navigate(context);
                        },
                      ),
                    ),
                    StreamBuilder(
                      stream: ClientController.instance.clientStream,
                      builder: (context, snapshot) {
                        return Text(
                          "${snapshot.data?.clients?.length}",
                          style: AppTextStyle.size20(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }
}
