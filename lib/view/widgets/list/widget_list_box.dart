import 'package:flutter/material.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/model/client_controller_model.dart';
import 'package:project_x/model/finance_controller_model.dart';
import 'package:project_x/model/project_controller_model.dart';
import 'package:project_x/model/workflow_controller_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/widgets/list/widget_list_card.dart';
import 'package:project_x/view/widgets/loader/widget_circular_loader.dart';

class WidgetListEntity extends StatefulWidget {
  final bool isResume;
  final EntityType type;

  const WidgetListEntity({
    super.key,
    required this.isResume,
    required this.type,
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
      default:
        throw Exception("Tipo não suportado");
    }
  }

  getList(dynamic snapshot) {
    switch (widget.type) {
      case EntityType.Client:
        snapshot as ClientStreamModel;
        return (snapshot.clients ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.clients ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return WidgetListEntityCard(
                      value1: "Nome",
                      value2: "Telefone",
                      value3: widget.isResume ? null : "Documento",
                      isHeader: true,
                    );
                  }
                  ClientLogicalModel model = snapshot.clients![index - 1]!;
                  return WidgetListEntityCard(
                    value1: model.personal?.model?.name ?? "Não informado",
                    value2: model.personal?.model?.phone ?? "Não informado",
                    value3: widget.isResume
                        ? null
                        : model.personal?.model?.document ?? "Não informado",
                  );
                },
              );
      case EntityType.Project:
        snapshot as ProjectStreamModel;
        return (snapshot.projects ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.projects ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return WidgetListEntityCard(
                      value1: "Nome",
                      value2: "Telefone",
                      value3: widget.isResume ? null : "Documento",
                      isHeader: true,
                    );
                  }
                  ProjectLogicalModel model = snapshot.projects![index - 1]!;
                  return WidgetListEntityCard(
                    value1: model.model?.name ?? "",
                    value2: model.model?.name ?? "Não informado",
                  );
                },
              );
      case EntityType.Finance:
        snapshot as FinanceStreamModel;
        return (snapshot.finances ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.finances ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return WidgetListEntityCard(
                      value1: "Nome",
                      value2: "Valor",
                      isHeader: true,
                    );
                  }
                  FinanceLogicalModel model = snapshot.finances![index - 1]!;
                  return WidgetListEntityCard(
                    value1: model.model?.name ?? "",
                    value2: model.getType(type: 0).first?.model?.amount ??
                        "Não informado",
                  );
                },
              );
      case EntityType.Workflow:
        snapshot as WorkflowStreamModel;
        return (snapshot.workflows ?? []).isEmpty
            ? emptyWidget()
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.workflows ?? []).length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return WidgetListEntityCard(
                      value1: "Nome",
                      value2: "Descrição",
                      isHeader: true,
                    );
                  }
                  WorkflowLogicalModel model = snapshot.workflows![index - 1]!;
                  return WidgetListEntityCard(
                    value1: model.model?.name ?? "Não informado",
                    value2: model.model?.description ?? "Não informado",
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
}
