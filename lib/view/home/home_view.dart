import 'package:flutter/material.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/forms/forms/widget_client_form.dart';
import 'package:project_x/view/forms/forms/widget_finance_form.dart';
import 'package:project_x/view/forms/forms/widget_workflow_form.dart';
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
                    Row(
                      children: [
                        WidgetTextButton(
                          model: WidgetTextButtonModel(
                            label: "Cadastrar cliente",
                            function: () {
                              AppRoute(
                                tag: WidgetClientForm.tag,
                                screen: WidgetClientForm(
                                  operation: EntityOperation.Create,
                                ),
                              ).navigate(context);
                            },
                          ),
                        ),
                        SizedBox(width: AppResponsive.instance.getWidth(24)),
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
                    Row(
                      children: [
                        WidgetTextButton(
                          model: WidgetTextButtonModel(
                            label: "Cadastrar financeiro",
                            function: () {
                              AppRoute(
                                tag: WidgetFinanceForm.tag,
                                screen: WidgetFinanceForm(
                                  operation: EntityOperation.Create,
                                ),
                              ).navigate(context);
                            },
                          ),
                        ),
                        SizedBox(width: AppResponsive.instance.getWidth(24)),
                        StreamBuilder(
                          stream: FinanceController.instance.financeStream,
                          builder: (context, snapshot) {
                            return Text(
                              "${snapshot.data?.finances?.length}",
                              style: AppTextStyle.size20(),
                            );
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        WidgetTextButton(
                          model: WidgetTextButtonModel(
                            label: "Cadastrar workflow",
                            function: () {
                              AppRoute(
                                tag: WidgetWorkflowForm.tag,
                                screen: WidgetWorkflowForm(
                                  operation: EntityOperation.Create,
                                ),
                              ).navigate(context);
                            },
                          ),
                        ),
                        SizedBox(width: AppResponsive.instance.getWidth(24)),
                        StreamBuilder(
                          stream: WorkflowController.instance.workflowStream,
                          builder: (context, snapshot) {
                            return Text(
                              "${snapshot.data?.workflows?.length}",
                              style: AppTextStyle.size20(),
                            );
                          },
                        )
                      ],
                    ),
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
