import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_feedback.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/forms/controller/forms_controller.dart';
import 'package:project_x/view/forms/sections/widget_entity_sections.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';

class WidgetFinanceForm extends StatefulWidget {
  static const String tag = "/finance_form_view";
  final EntityOperation operation;

  const WidgetFinanceForm({super.key, required this.operation});

  @override
  State<WidgetFinanceForm> createState() => _WidgetFinanceFormState();
}

class _WidgetFinanceFormState extends State<WidgetFinanceForm> {
  final descriptionSection = DescriptionSection();
  final operationSection = OperationSection();
  final formKey = GlobalKey<FormState>();
  final controller = FormsController();
  final entity = "Financeiro";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.setType(EntityType.Finance);
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    cards: [
                      WidgetActionIcon(
                        model: WidgetActionIconModel(
                          icon: getActionIcon(),
                          label: getActionText(),
                          function: () async {
                            await getFunction();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: AppResponsive.instance.getHeight(24)),
            Expanded(
              child: Form(
                key: formKey,
                child: Container(),
              ), //IMPLEMENTAR
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

  String getTitle() {
    return "${entity}s";
  }

  String getActionHeaderText() {
    String value = "";
    switch (widget.operation) {
      case EntityOperation.Create:
        value = "Cadastrar um";
      case EntityOperation.Read:
        value = "Ler um";
      case EntityOperation.Update:
        value = "Atualizar um";
      case EntityOperation.Delete:
        value = "Deletar um";
    }
    return "$value $entity";
  }

  String getActionText() {
    String value = "";
    switch (widget.operation) {
      case EntityOperation.Create:
        value = "Cadastrar";
      case EntityOperation.Read:
        value = "Ler";
      case EntityOperation.Update:
        value = "Atualizar";
      case EntityOperation.Delete:
        value = "Deletar";
    }
    return value;
  }

  IconData getActionIcon() {
    late IconData value;
    switch (widget.operation) {
      case EntityOperation.Create:
        value = Icons.add;
      case EntityOperation.Read:
        value = Icons.read_more;
      case EntityOperation.Update:
        value = Icons.update;
      case EntityOperation.Delete:
        value = Icons.delete;
    }
    return value;
  }

  Future<void> getFunction() async {
    try {
      bool formValidation = (formKey.currentState?.validate() ?? false);
      bool controllerResult = false;
      if (formValidation) {
        controller.setModel(getModel());
        switch (widget.operation) {
          case EntityOperation.Create:
            controllerResult = await controller.createEntity();
            break;
          case EntityOperation.Read:
            break;
          case EntityOperation.Update:
            break;
          case EntityOperation.Delete:
            break;
        }
        if (controllerResult) {
          AppFeedback(
            text: "Sucesso",
            color: AppColor.colorPositiveStatus,
          ).showSnackbar(context);
          Navigator.pop(context);
        } else {
          AppFeedback(
            text: "Erro",
            color: AppColor.colorNegativeStatus,
          ).showSnackbar(context);
        }
      }
    } catch (error) {
      log(error.toString());
    }
  }

  FinanceLogicalModel getModel() {
    FinanceLogicalModel model = FinanceLogicalModel(
      model: FinanceDatabaseModel(
        status: false,
        name: descriptionSection.titleController.text,
        description: descriptionSection.descriptionController.text,
      ),
      operations: [
        FinanceOperationLogicalModel(
          model: FinanceOperationDatabaseModel(
            type: 0,
            description: "Valor inicial",
            amount: operationSection.amountController.text,
          ),
        ),
      ],
    );
    return model;
  }
}
