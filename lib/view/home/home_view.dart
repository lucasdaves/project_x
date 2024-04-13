import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/list/list_view.dart';
import 'package:project_x/view/widgets/drawer/widget_flow_drawer.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/drawer/widget_user_drawer.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';
import 'package:project_x/view/widgets/list/widget_list_box.dart';

class HomeView extends StatefulWidget {
  static const String tag = "/home_view";
  static GlobalKey<ScaffoldState> homeKey = GlobalKey();

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomeView.homeKey,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: WidgetFloatingBox(
                    model: WidgetFloatingBoxModel(
                      label: "Clientes",
                      actionWidget: GestureDetector(
                        onTap: () {
                          AppRoute(
                            tag: EntityListView.tag,
                            screen: EntityListView(
                              type: EntityType.Client,
                            ),
                          ).navigate(context);
                        },
                        child: Text(
                          "Ver mais",
                          style: AppTextStyle.size20(
                              color: AppColor.colorSecondary),
                        ),
                      ),
                      widget: WidgetListEntity(
                        isResume: true,
                        type: EntityType.Client,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppResponsive.instance.getWidth(20),
                ),
                Expanded(
                  child: WidgetFloatingBox(
                    model: WidgetFloatingBoxModel(
                      label: "Projetos",
                      actionWidget: GestureDetector(
                        onTap: () {
                          AppRoute(
                            tag: EntityListView.tag,
                            screen: EntityListView(
                              type: EntityType.Project,
                            ),
                          ).navigate(context);
                        },
                        child: Text(
                          "Ver mais",
                          style: AppTextStyle.size20(
                              color: AppColor.colorSecondary),
                        ),
                      ),
                      widget: WidgetListEntity(
                        isResume: true,
                        type: EntityType.Project,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppResponsive.instance.getWidth(20),
                ),
                Expanded(
                  child: WidgetFloatingBox(
                    model: WidgetFloatingBoxModel(
                      label: "Financeiros",
                      actionWidget: GestureDetector(
                        onTap: () {
                          AppRoute(
                            tag: EntityListView.tag,
                            screen: EntityListView(
                              type: EntityType.Finance,
                            ),
                          ).navigate(context);
                        },
                        child: Text(
                          "Ver mais",
                          style: AppTextStyle.size20(
                              color: AppColor.colorSecondary),
                        ),
                      ),
                      widget: WidgetListEntity(
                        isResume: true,
                        type: EntityType.Finance,
                      ),
                    ),
                  ),
                ),
              ],
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
