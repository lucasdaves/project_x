import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/services/export/export_service.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_extension.dart';
import 'package:project_x/utils/app_feedback.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
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
import 'package:project_x/view/widgets/finances/widget_finance_report.dart';
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

  ScreenshotController viewController = ExportService.instance.getController();
  ScreenshotController listController = ExportService.instance.getController();

  @override
  void initState() {
    getEntityName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: viewController,
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
      case EntityType.FinanceReport:
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
                ExportService.instance.print(viewController).then((value) {
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
                ExportService.instance.print(viewController).then((value) {
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
                ExportService.instance.print(viewController).then((value) {
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
      case EntityType.FinanceReport:
        actions = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: Icons.picture_in_picture_rounded,
              label: "Exportar",
              function: () async {
                ExportService.instance.print(listController).then((value) {
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
              icon: Icons.date_range,
              label: "Selecionar Data",
              function: () async {
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: AppResponsive.instance.getWidth(800),
                          constraints: BoxConstraints(
                            minHeight: AppResponsive.instance.getHeight(100),
                            maxHeight: AppResponsive.instance.getHeight(500),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: AppResponsive.instance.getHeight(24),
                            horizontal: AppResponsive.instance.getWidth(24),
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.colorFloating,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RangeDatePicker(
                                  key: UniqueKey(),
                                  minDate: DateTime(2000),
                                  maxDate: DateTime(2050),
                                  selectedRange: DateTimeRange(
                                    start:
                                        FinanceController.instance.getDate()[0],
                                    end:
                                        FinanceController.instance.getDate()[1],
                                  ),
                                  selectedCellsDecoration: BoxDecoration(
                                    color: AppColor.colorSecondary,
                                  ),
                                  selectedCellsTextStyle: AppTextStyle.size12(
                                    color: AppColor.text_1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  singelSelectedCellDecoration: BoxDecoration(
                                    color: AppColor.colorPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  singelSelectedCellTextStyle:
                                      AppTextStyle.size12(
                                    color: AppColor.colorSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  currentDateDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                  currentDateTextStyle: AppTextStyle.size12(
                                    color: AppColor.text_1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  daysOfTheWeekTextStyle: AppTextStyle.size12(
                                    color: AppColor.text_1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledCellsDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                  disabledCellsTextStyle: AppTextStyle.size12(
                                    color: AppColor.text_1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  enabledCellsDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                  enabledCellsTextStyle: AppTextStyle.size12(
                                    color: AppColor.text_1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  leadingDateTextStyle: AppTextStyle.size16(
                                    color: AppColor.text_1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  slidersColor: AppColor.colorSecondary,
                                  highlightColor: Colors.transparent,
                                  slidersSize:
                                      AppResponsive.instance.getWidth(24),
                                  splashColor: AppColor.colorSecondary,
                                  initialPickerType: PickerType.days,
                                  centerLeadingDate: true,
                                  padding: EdgeInsets.zero,
                                  onRangeSelected: (value) async {
                                    setState(() {
                                      FinanceController.instance
                                          .setDate(value.start, value.end);
                                    });

                                    await Future.delayed(
                                        Duration(milliseconds: 200));
                                    if (mounted) Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
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
      case EntityType.FinanceReport:
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
                  clientAssociation: widget.entityIndex,
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
                  clientAssociation: widget.entityIndex,
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
                      WidgetDivider(verticalSpace: 12, horizontalSpace: 8),
                      WidgetProjectSituation(
                        key: UniqueKey(),
                        model: WorkflowController.instance.stream.value.getOne(
                            id: ProjectController.instance.stream.value
                                .getOne(id: widget.entityIndex)!
                                .model!
                                .workflowId!)!,
                      ),
                      WidgetDivider(verticalSpace: 12, horizontalSpace: 8),
                      WidgetProjectBalance(
                        key: UniqueKey(),
                        model: ProjectController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                        wkModel: WorkflowController.instance.stream.value
                            .getOne(
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
                      .getOne(projectId: widget.entityIndex)
                      ?.model
                      ?.financeId) !=
              null) ...[
            SizedBox(width: AppResponsive.instance.getWidth(20)),
            StreamBuilder(
              stream: FinanceController.instance.stream,
              builder: (context, snapshot) {
                return Expanded(
                  flex: 3,
                  child: WidgetFloatingBox(
                    model: WidgetFloatingBoxModel(
                      label: "Financeiro",
                      actionWidget: GestureDetector(
                        onTap: () {
                          AppRoute(
                            tag: EntityResumeView.tag,
                            screen: EntityResumeView(
                              type: EntityType.Finance,
                              entityIndex: AssociationController
                                  .instance.stream.value
                                  .getOne(projectId: widget.entityIndex)!
                                  .model!
                                  .financeId!,
                            ),
                          ).navigate(context);
                        },
                        child: Text(
                          "Ver mais",
                          style: AppTextStyle.size20(
                              color: AppColor.colorSecondary),
                        ),
                      ),
                      widget: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetFinanceSituation(
                              key: UniqueKey(),
                              model: FinanceController.instance.stream.value
                                  .getOne(
                                      id: AssociationController
                                          .instance.stream.value
                                          .getOne(projectId: widget.entityIndex)
                                          ?.model
                                          ?.financeId)!,
                            ),
                            WidgetDivider(
                                verticalSpace: 12, horizontalSpace: 8),
                            WidgetFinancePayment(
                              key: UniqueKey(),
                              model: FinanceController.instance.stream.value
                                  .getOne(
                                      id: AssociationController
                                          .instance.stream.value
                                          .getOne(projectId: widget.entityIndex)
                                          ?.model
                                          ?.financeId)!,
                            ),
                            WidgetDivider(
                                verticalSpace: 12, horizontalSpace: 8),
                            WidgetFinanceBalance(
                              key: UniqueKey(),
                              model: FinanceController.instance.stream.value
                                  .getOne(
                                      id: AssociationController
                                          .instance.stream.value
                                          .getOne(projectId: widget.entityIndex)
                                          ?.model
                                          ?.financeId)!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                padding: EdgeInsets.symmetric(
                  vertical: AppResponsive.instance.getHeight(12),
                  horizontal: AppResponsive.instance.getWidth(24),
                ),
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
                      WidgetDivider(verticalSpace: 12, horizontalSpace: 8),
                      WidgetFinancePayment(
                        key: UniqueKey(),
                        model: FinanceController.instance.stream.value
                            .getOne(id: widget.entityIndex)!,
                      ),
                      WidgetDivider(verticalSpace: 12, horizontalSpace: 8),
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
      case EntityType.FinanceReport:
        widgets = [
          Spacer(flex: 3),
          Expanded(
            flex: 7,
            child: Screenshot(
              controller: listController,
              child: WidgetFloatingBox(
                model: WidgetFloatingBoxModel(
                  label:
                      "Relatório de pagamentos - ${FinanceController.instance.getDate()[0].formatString()} até ${FinanceController.instance.getDate()[1].formatString()}",
                  widget: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetFinanceReport(
                          key: UniqueKey(),
                          model: FinanceController.instance.stream.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(flex: 3),
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
