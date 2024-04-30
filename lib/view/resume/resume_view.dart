import 'package:flutter/material.dart';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/services/export/export_service.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_feedback.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/view/forms/form_view.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/clients/widget_client_details.dart';
import 'package:project_x/view/widgets/divider/widget_divider.dart';
import 'package:project_x/view/widgets/drawer/widget_flow_drawer.dart';
import 'package:project_x/view/widgets/drawer/widget_user_drawer.dart';
import 'package:project_x/view/widgets/finances/widget_finance_balance.dart';
import 'package:project_x/view/widgets/finances/widget_finance_box.dart';
import 'package:project_x/view/widgets/finances/widget_finance_details.dart';
import 'package:project_x/view/widgets/finances/widget_finance_payment.dart';
import 'package:project_x/view/widgets/finances/widget_finance_situation.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';
import 'package:project_x/view/widgets/list/widget_list_box.dart';
import 'package:project_x/view/widgets/projects/widget_project_balance.dart';
import 'package:project_x/view/widgets/projects/widget_project_details.dart';
import 'package:project_x/view/widgets/projects/widget_project_situation.dart';
import 'package:project_x/view/widgets/workflows/widget_workflow_box.dart';
import 'package:screenshot/screenshot.dart';

class EntityResumeView extends StatefulWidget {
  static const String tag = "/resume_view";

  final EntityType type;
  final int entityIndex;

  const EntityResumeView({
    super.key,
    required this.type,
    required this.entityIndex,
  });

  @override
  State<EntityResumeView> createState() => _EntityResumeViewState();
}

class _EntityResumeViewState extends State<EntityResumeView> {
  String entity = "";

  ScreenshotController controller = ExportService.instance.getController();

  @override
  void initState() {
    getEntityName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: _buildBar(),
        body: _buildBody(),
        drawer: WidgetStartDrawer(),
        endDrawer: WidgetEndDrawer(),
        backgroundColor: AppColor.colorPrimary,
      ),
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
        width: 1200,
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
            Expanded(
              child: StreamBuilder(
                stream: getStream(),
                builder: (context, snapshot) {
                  return getList();
                },
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

  //* FUNCTIONS *//

  getStream() {
    switch (widget.type) {
      case EntityType.Client:
        return ClientController.instance.stream;
      case EntityType.Project:
        return ProjectController.instance.stream;
      case EntityType.Finance:
        return FinanceController.instance.stream;
      default:
        throw Exception("Tipo não suportado");
    }
  }

  String getTitle() {
    return "${entity}s";
  }

  String getActionHeaderText() {
    String value = "Resumo de ${entity}s";
    return value;
  }

  List<WidgetActionIcon> getActions() {
    List<WidgetActionIcon> actions = [];

    switch (widget.type) {
      case EntityType.Client:
        actions = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.picture_in_picture_rounded,
              label: "Exportar",
              function: () async {
                ExportService.instance.print(controller).then((value) {
                  AppFeedback(
                    text: "${value.values.first}",
                    color: value.keys.first
                        ? AppColor.colorPositiveStatus
                        : AppColor.colorNegativeStatus,
                  ).showSnackbar(context);
                });
              },
            ),
          ),
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.edit,
              label: "Editar",
              function: () async {
                AppRoute(
                  tag: EntityFormView.tag,
                  screen: EntityFormView(
                    type: EntityType.Client,
                    operation: EntityOperation.Update,
                    entityIndex: widget.entityIndex,
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
              icon: Icons.picture_in_picture_rounded,
              label: "Exportar",
              function: () async {
                ExportService.instance.print(controller).then((value) {
                  AppFeedback(
                    text: "${value.values.first}",
                    color: value.keys.first
                        ? AppColor.colorPositiveStatus
                        : AppColor.colorNegativeStatus,
                  ).showSnackbar(context);
                });
              },
            ),
          ),
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.edit,
              label: "Editar",
              function: () async {
                AppRoute(
                  tag: EntityFormView.tag,
                  screen: EntityFormView(
                    type: EntityType.Project,
                    operation: EntityOperation.Update,
                    entityIndex: widget.entityIndex,
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
              icon: Icons.picture_in_picture_rounded,
              label: "Exportar",
              function: () async {
                ExportService.instance.print(controller).then((value) {
                  AppFeedback(
                    text: "${value.values.first}",
                    color: value.keys.first
                        ? AppColor.colorPositiveStatus
                        : AppColor.colorNegativeStatus,
                  ).showSnackbar(context);
                });
              },
            ),
          ),
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.edit,
              label: "Editar",
              function: () async {
                AppRoute(
                  tag: EntityFormView.tag,
                  screen: EntityFormView(
                    type: EntityType.Finance,
                    operation: EntityOperation.Update,
                    entityIndex: widget.entityIndex,
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
                label: "Dados do Cliente",
                widget: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetClientDetails(
                        key: UniqueKey(),
                        model: ClientController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                    ],
                  ),
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
                widget: WidgetListEntity(
                  isResume: false,
                  type: EntityType.Project,
                  clientAssociation: ProjectController.instance.stream.value
                          .getOne(
                              id: AssociationController.instance.stream.value
                                  .getOne(clientId: widget.entityIndex)
                                  ?.model
                                  ?.projectId)
                          ?.model
                          ?.id ??
                      -1,
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
                widget: WidgetListEntity(
                  isResume: false,
                  type: EntityType.Finance,
                  clientAssociation: FinanceController.instance.stream.value
                          .getOne(
                              id: AssociationController.instance.stream.value
                                  .getOne(clientId: widget.entityIndex)
                                  ?.model
                                  ?.financeId)
                          ?.model
                          ?.id ??
                      -1,
                ),
              ),
            ),
          ),
        ];
        break;
      case EntityType.Project:
        widgets = [
          Expanded(
            flex: 3,
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Dados do Projeto",
                widget: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetProjectDetails(
                        key: UniqueKey(),
                        model: ProjectController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                      WidgetDivider(space: 12),
                      WidgetProjectSituation(
                        key: UniqueKey(),
                        model: WorkflowController.instance.stream.value.getOne(
                            id: ProjectController.instance.stream.value
                                .getOne(id: widget.entityIndex)!
                                .model!
                                .workflowId!)!,
                      ),
                      WidgetDivider(space: 12),
                      WidgetProjectBalance(
                        key: UniqueKey(),
                        model: WorkflowController.instance.stream.value.getOne(
                            id: ProjectController.instance.stream.value
                                .getOne(id: widget.entityIndex)!
                                .model!
                                .workflowId!)!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (WorkflowController.instance.stream.value.getOne(
                id: ProjectController.instance.stream.value
                    .getOne(id: widget.entityIndex)
                    ?.model
                    ?.workflowId,
              ) !=
              null) ...[
            SizedBox(width: AppResponsive.instance.getWidth(20)),
            Expanded(
              flex: 4,
              child: WidgetFloatingBox(
                model: WidgetFloatingBoxModel(
                  label: "Fluxo de trabalho",
                  padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: WidgetWorkflowBox(
                          model: WorkflowController.instance.stream.value
                              .getOne(
                                  id: ProjectController.instance.stream.value
                                      .getOne(id: widget.entityIndex)!
                                      .model!
                                      .workflowId!)!,
                          operation: EntityOperation.Read,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (FinanceController.instance.stream.value.getOne(
                  id: AssociationController.instance.stream.value
                      .getOne(clientId: widget.entityIndex)
                      ?.model
                      ?.clientId) !=
              null) ...[
            SizedBox(width: AppResponsive.instance.getWidth(20)),
            Expanded(
              flex: 3,
              child: WidgetFloatingBox(
                model: WidgetFloatingBoxModel(
                  label: "Financeiro",
                  widget: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetFinanceSituation(
                          key: UniqueKey(),
                          model: FinanceController.instance.stream.value.getOne(
                              id: AssociationController.instance.stream.value
                                  .getOne(clientId: widget.entityIndex)
                                  ?.model
                                  ?.clientId)!,
                        ),
                        WidgetDivider(space: 12),
                        WidgetFinancePayment(
                          key: UniqueKey(),
                          model: FinanceController.instance.stream.value.getOne(
                              id: AssociationController.instance.stream.value
                                  .getOne(clientId: widget.entityIndex)
                                  ?.model
                                  ?.clientId)!,
                        ),
                        WidgetDivider(space: 12),
                        WidgetFinanceBalance(
                          key: UniqueKey(),
                          model: FinanceController.instance.stream.value.getOne(
                              id: AssociationController.instance.stream.value
                                  .getOne(clientId: widget.entityIndex)
                                  ?.model
                                  ?.clientId)!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ];
        break;
      case EntityType.Finance:
        widgets = [
          Expanded(
            flex: 3,
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Dados do Financeiro",
                widget: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetFinanceDetails(
                        key: UniqueKey(),
                        model: FinanceController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppResponsive.instance.getWidth(20),
          ),
          Expanded(
            flex: 4,
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Histórico de Pagamentos",
                padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: WidgetFinanceBox(
                        model: FinanceController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                        operation: EntityOperation.Read,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppResponsive.instance.getWidth(20),
          ),
          Expanded(
            flex: 3,
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Métricas",
                widget: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetFinanceSituation(
                        key: UniqueKey(),
                        model: FinanceController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                      WidgetDivider(space: 12),
                      WidgetFinancePayment(
                        key: UniqueKey(),
                        model: FinanceController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                      WidgetDivider(space: 12),
                      WidgetFinanceBalance(
                        key: UniqueKey(),
                        model: FinanceController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                    ],
                  ),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
