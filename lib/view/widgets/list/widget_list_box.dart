import 'package:flutter/material.dart';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/model/association_controller_model.dart';
import 'package:project_x/model/client_controller_model.dart';
import 'package:project_x/model/finance_controller_model.dart';
import 'package:project_x/model/project_controller_model.dart';
import 'package:project_x/model/workflow_controller_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/project_finance_client_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/forms/form_view.dart';
import 'package:project_x/view/resume/resume_view.dart';
import 'package:project_x/view/widgets/list/widget_list_card.dart';
import 'package:project_x/view/widgets/loader/widget_circular_loader.dart';

class WidgetListEntity extends StatefulWidget {
  final bool isResume;
  final EntityType type;
  final int? clientAssociation;

  const WidgetListEntity({
    super.key,
    required this.isResume,
    required this.type,
    this.clientAssociation,
  });

  @override
  State<WidgetListEntity> createState() => _WidgetListEntityState();
}

class _WidgetListEntityState extends State<WidgetListEntity> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getList(snapshot.data);
        } else {
          return WidgetCircularLoader(
            model: WidgetCircularLoaderModel(),
          );
        }
      },
    );
  }

  getStream() {
    switch (widget.type) {
      case EntityType.Client:
        return ClientController.instance.stream;
      case EntityType.Project:
        return ProjectController.instance.stream;
      case EntityType.Finance:
        return FinanceController.instance.stream;
      case EntityType.Workflow:
        return WorkflowController.instance.stream;
      case EntityType.Association:
        return AssociationController.instance.stream;
      default:
        throw Exception("Tipo não suportado");
    }
  }

  getList(dynamic snapshot) {
    switch (widget.type) {
      case EntityType.Client:
        snapshot as ClientStreamModel;
        ClientStreamModel copy = snapshot.copy();
        List<ClientLogicalModel?>? clients;
        if (!widget.isResume) {
          clients = copy.getSearched();
        } else {
          clients = copy.getAll();
        }
        return (clients ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (clients ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return widget.isResume
                        ? WidgetListEntityCard(
                            value1: "Nome",
                            value2: "Telefone",
                            isHeader: true,
                          )
                        : WidgetListEntityCard(
                            value1: "Nome",
                            value2: "Telefone",
                            value3: "Documento",
                            isHeader: true,
                          );
                  }
                  ClientLogicalModel model = clients![index - 1]!;
                  return widget.isResume
                      ? WidgetListEntityCard(
                          value1:
                              model.personal?.model?.name ?? "Não informado",
                          value2:
                              model.personal?.model?.phone ?? "Não informado",
                          function: () {
                            function(model.model!.id!);
                          },
                        )
                      : WidgetListEntityCard(
                          value1:
                              model.personal?.model?.name ?? "Não informado",
                          value2:
                              model.personal?.model?.phone ?? "Não informado",
                          value3: model.personal?.model?.document ??
                              "Não informado",
                          function: () {
                            function(model.model!.id!);
                          },
                        );
                },
              );
      case EntityType.Project:
        snapshot as ProjectStreamModel;
        ProjectStreamModel copy = snapshot.copy();
        List<ProjectLogicalModel?>? projects;
        copy.filter();
        if (widget.clientAssociation != null) {
          projects = copy.getAssociated(widget.clientAssociation!);
        } else if (!widget.isResume) {
          projects = copy.getSearched();
        } else {
          projects = copy.getAll();
        }
        return (projects ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (projects ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return widget.isResume
                        ? WidgetListEntityCard(
                            value1: "Nome",
                            value2: "Situação",
                            isHeader: true,
                          )
                        : WidgetListEntityCard(
                            value1: "Nome",
                            value2: "Andamento",
                            value3: "Situação",
                            isHeader: true,
                          );
                  }
                  ProjectLogicalModel model = projects![index - 1]!;
                  var status = model.getStatus();
                  WorkflowLogicalModel wkModel = WorkflowController
                      .instance.stream.value
                      .getOne(id: model.model?.workflowId)!;
                  return widget.isResume
                      ? WidgetListEntityCard(
                          value1: model.model?.name ?? "",
                          value2: status.keys.first.values.first
                              ? wkModel.getStatus().entries.first.key
                              : status.keys.first.keys.first,
                          color2: status.keys.first.values.first
                              ? wkModel.getStatus().entries.first.value
                              : status.values.first,
                          function: () {
                            function(model.model!.id!);
                          },
                        )
                      : WidgetListEntityCard(
                          value1: model.model?.name ?? "",
                          value2:
                              "${wkModel.getRelationConcluded()} tarefas concluídas",
                          value3: status.keys.first.values.first
                              ? wkModel.getStatus().entries.first.key
                              : status.keys.first.keys.first,
                          color2: AppColor.colorNeutralStatus,
                          color3: status.keys.first.values.first
                              ? wkModel.getStatus().entries.first.value
                              : status.values.first,
                          function: () {
                            function(model.model!.id!);
                          },
                        );
                },
              );
      case EntityType.Finance:
        snapshot as FinanceStreamModel;
        FinanceStreamModel copy = snapshot.copy();
        List<FinanceLogicalModel?>? finances;
        copy.filter();
        if (widget.clientAssociation != null) {
          finances = copy.getAssociated(widget.clientAssociation!);
        } else if (!widget.isResume) {
          finances = copy.getSearched();
        } else {
          finances = copy.getAll();
        }
        return (finances ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (finances ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return widget.isResume
                        ? WidgetListEntityCard(
                            value1: "Nome",
                            value2: "Situação",
                            isHeader: true,
                          )
                        : WidgetListEntityCard(
                            value1: "Nome",
                            value2: "Andamento",
                            value3: "Situação",
                            isHeader: true,
                          );
                  }
                  FinanceLogicalModel model = finances![index - 1]!;
                  var status = model.getStatus();
                  return widget.isResume
                      ? WidgetListEntityCard(
                          value1: model.model?.name ?? "",
                          value2: status.keys.first.values.first
                              ? model.getOperationStatus().entries.first.key
                              : status.keys.first.keys.first,
                          color2: status.keys.first.values.first
                              ? model.getOperationStatus().entries.first.value
                              : status.values.first,
                          function: () {
                            function(model.model!.id!);
                          },
                        )
                      : WidgetListEntityCard(
                          value1: model.model?.name ?? "",
                          value2: "${model.getRelationPaid()} parcelas pagas",
                          value3: status.keys.first.values.first
                              ? model.getOperationStatus().entries.first.key
                              : status.keys.first.keys.first,
                          color2: AppColor.colorNeutralStatus,
                          color3: status.keys.first.values.first
                              ? model.getOperationStatus().entries.first.value
                              : status.values.first,
                          function: () {
                            function(model.model!.id!);
                          },
                        );
                },
              );
      case EntityType.Workflow:
        snapshot as WorkflowStreamModel;
        WorkflowStreamModel copy = snapshot.copy();
        return (copy.getAll(removeCopy: true)).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (copy.getAll(removeCopy: true)).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return WidgetListEntityCard(
                      value1: "Nome",
                      value2: "Descrição",
                      isHeader: true,
                    );
                  }
                  WorkflowLogicalModel model =
                      copy.getAll(removeCopy: true)[index - 1]!;
                  return WidgetListEntityCard(
                    value1: model.model?.name ?? "Não informado",
                    value2: model.model?.description ?? "Não informado",
                    function: () {
                      function(model.model!.id!);
                    },
                  );
                },
              );
      case EntityType.Association:
        snapshot as AssociationStreamModel;
        AssociationStreamModel copy = snapshot.copy();
        List<AssociationLogicalModel?>? associations;
        if (!widget.isResume) {
          associations = copy.getFiltered();
        } else {
          associations = copy.getAll();
        }
        return (associations ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (associations ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return WidgetListEntityCard(
                      value1: "Cliente",
                      value2: "Projeto",
                      value3: "Financeiro",
                      isHeader: true,
                    );
                  }
                  AssociationLogicalModel model = associations![index - 1]!;
                  return WidgetListEntityCard(
                    value1: ClientController.instance.stream.value
                            .getOne(id: model.model?.clientId)
                            ?.personal
                            ?.model
                            ?.name ??
                        "Não informado",
                    value2: ProjectController.instance.stream.value
                            .getOne(id: model.model?.projectId)
                            ?.model
                            ?.name ??
                        "Não informado",
                    value3: FinanceController.instance.stream.value
                            .getOne(id: model.model?.financeId)
                            ?.model
                            ?.name ??
                        "Não informado",
                    function: () {
                      function(model.model!.id!);
                    },
                  );
                },
              );
      default:
        throw Exception("Tipo não suportado");
    }
  }

  emptyWidget() {
    return Text(
      "Não há nada para exibir até o momento",
      textAlign: TextAlign.center,
      style: AppTextStyle.size16(fontWeight: FontWeight.w300),
    );
  }

  function(int entityIndex) {
    switch (widget.type) {
      case EntityType.Workflow:
      case EntityType.Association:
        AppRoute(
          tag: EntityFormView.tag,
          screen: EntityFormView(
            type: widget.type,
            entityIndex: entityIndex,
            operation: EntityOperation.Update,
          ),
        ).navigate(context);
        break;
      default:
        AppRoute(
          tag: EntityResumeView.tag,
          screen: EntityResumeView(
            type: widget.type,
            entityIndex: entityIndex,
          ),
        ).navigate(context);
        break;
    }
  }
}
