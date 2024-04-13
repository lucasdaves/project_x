import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/view/forms/forms/widget_client_form.dart';
import 'package:project_x/view/forms/forms/widget_finance_form.dart';
import 'package:project_x/view/forms/forms/widget_project_form.dart';
import 'package:project_x/view/forms/forms/widget_workflow_form.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';
import 'package:project_x/view/widgets/list/widget_list_box.dart';

class EntityListView extends StatefulWidget {
  static const String tag = "/list_view";

  final EntityType type;

  const EntityListView({super.key, required this.type});

  @override
  State<EntityListView> createState() => _EntityListViewState();
}

class _EntityListViewState extends State<EntityListView> {
  String entity = "";

  @override
  void initState() {
    getEntityName();
    super.initState();
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
    return WidgetContainBox(
      model: WidgetContainModelBox(
        height: double.maxFinite,
        width: 900,
        widget: Column(
          children: [
            WidgetTitleHeader(
              model: WidgetTitleHeaderModel(title: getTitle()),
            ),
            SizedBox(height: AppResponsive.instance.getHeight(24)),
            WidgetActionHeader(
              model: WidgetActionHeaderModel(
                backAction: WidgetActionBack(
                  model: WidgetActionBackModel(
                    icon: Icons.chevron_left_rounded,
                    label: getActionHeaderText(),
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                cardAction: WidgetActionCard(
                  model: WidgetActionCardModel(
                    label: "Ações",
                    cards: getActions(),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppResponsive.instance.getHeight(24)),
            getList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }

  //* FUNCTIONS *//

  String getTitle() {
    return "${entity}s";
  }

  String getActionHeaderText() {
    String value = "Listagem de ${entity}s";
    return value;
  }

  List<WidgetActionIcon> getActions() {
    List<WidgetActionIcon> actions = [];
    switch (widget.type) {
      case EntityType.Client:
        actions = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.add,
              label: "+ Cliente",
              function: () async {
                AppRoute(
                  tag: WidgetClientForm.tag,
                  screen: WidgetClientForm(
                    operation: EntityOperation.Create,
                  ),
                ).navigate(context);
              },
            ),
          ),
        ];
        break;
      case EntityType.Project:
        actions = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.add,
              label: "+ Workflow",
              function: () async {
                AppRoute(
                  tag: WidgetWorkflowForm.tag,
                  screen: WidgetWorkflowForm(
                    operation: EntityOperation.Create,
                  ),
                ).navigate(context);
              },
            ),
          ),
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.add,
              label: "+ Projeto",
              function: () async {
                AppRoute(
                  tag: WidgetProjectForm.tag,
                  screen: WidgetProjectForm(
                    operation: EntityOperation.Create,
                  ),
                ).navigate(context);
              },
            ),
          ),
        ];

        break;
      case EntityType.Finance:
        actions = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.add,
              label: "+ Financeiro",
              function: () async {
                AppRoute(
                  tag: WidgetFinanceForm.tag,
                  screen: WidgetFinanceForm(
                    operation: EntityOperation.Create,
                  ),
                ).navigate(context);
              },
            ),
          ),
        ];
        break;
      default:
        throw Exception("Unsuported Type");
    }
    return actions;
  }

  void getEntityName() {
    switch (widget.type) {
      case EntityType.Client:
        entity = "Cliente";
      case EntityType.Project:
        entity = "Projeto";
      case EntityType.Finance:
        entity = "Financeiro";
      default:
        throw Exception("Unsuported Type");
    }
  }

  Widget getList() {
    List<Widget> widgets = [];

    switch (widget.type) {
      case EntityType.Client:
        widgets = [
          Expanded(
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Clientes",
                widget: WidgetListEntity(
                  isResume: false,
                  type: EntityType.Client,
                ),
              ),
            ),
          ),
        ];
        break;
      case EntityType.Project:
        widgets = [
          Expanded(
            flex: 2,
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Projetos",
                widget: WidgetListEntity(
                  isResume: false,
                  type: EntityType.Project,
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppResponsive.instance.getWidth(20),
          ),
          Expanded(
            flex: 1,
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Workflows",
                widget: WidgetListEntity(
                  isResume: false,
                  type: EntityType.Workflow,
                ),
              ),
            ),
          ),
        ];
        break;
      case EntityType.Finance:
        widgets = [
          Expanded(
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Financeiros",
                widget: WidgetListEntity(
                  isResume: false,
                  type: EntityType.Finance,
                ),
              ),
            ),
          ),
        ];
        break;
      default:
        throw Exception("Unsuported Type");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
