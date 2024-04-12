import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/create/create_controller.dart';
import 'package:project_x/view/widgets/buttons/widget_solid_button.dart';
import 'package:project_x/view/widgets/textfield/widget_textfield.dart';

class WidgetWorkflowBox extends StatefulWidget {
  final CreateController controller;

  const WidgetWorkflowBox({super.key, required this.controller});

  @override
  State<WidgetWorkflowBox> createState() => _WidgetWorkflowBoxState();
}

class _WidgetWorkflowBoxState extends State<WidgetWorkflowBox> {
  WorkflowLogicalModel model = WorkflowLogicalModel();

  @override
  void initState() {
    model.model = WorkflowDatabaseModel(
      name: "",
      description: "",
    );
    model.steps = [];
    super.initState();
  }

  bool validate() {
    if (model.steps?.isNotEmpty ?? false) {
      widget.controller.stream.value.model = model;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: model.steps!.length + 1,
      separatorBuilder: (context, stpIndex) {
        return SizedBox(
          width: AppResponsive.instance.getWidth(20),
        );
      },
      itemBuilder: (context, stpIndex) {
        bool isFinalStep = (stpIndex == model.steps!.length);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppResponsive.instance.getWidth(150),
              decoration: BoxDecoration(
                color: AppColor.colorPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.only(
                top: AppResponsive.instance.getHeight(4),
                right: AppResponsive.instance.getWidth(4),
                left: AppResponsive.instance.getWidth(4),
                bottom: AppResponsive.instance.getHeight(4),
              ),
              clipBehavior: Clip.hardEdge,
              child: isFinalStep
                  ? button(
                      type: WorkflowType.Step,
                      isFirst: true,
                      isLast: true,
                    )
                  : Column(
                      children: [
                        button(
                          type: WorkflowType.Step,
                          step: model.steps![stpIndex]!,
                          isFirst: true,
                          isLast: false,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: model.steps![stpIndex]!.substeps!.length,
                          separatorBuilder: (context, subIndex) {
                            return SizedBox(
                              height: AppResponsive.instance.getHeight(24),
                            );
                          },
                          itemBuilder: (context, subIndex) {
                            return button(
                              type: WorkflowType.Substep,
                              substep:
                                  model.steps![stpIndex]!.substeps![subIndex],
                              isFirst: false,
                              isLast: false,
                            );
                          },
                        ),
                        button(
                          type: WorkflowType.Substep,
                          index: stpIndex,
                          isFirst: false,
                          isLast: true,
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget button({
    required WorkflowType type,
    int? index,
    StepLogicalModel? step,
    SubstepLogicalModel? substep,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () {
        _showDialog(
          context,
          type: type,
          index: index,
          step: step,
          substep: substep,
        );
      },
      child: Container(
        width: AppResponsive.instance.getWidth(150),
        height: AppResponsive.instance.getHeight(53),
        margin: EdgeInsets.only(
          bottom: AppResponsive.instance.getHeight(24),
        ),
        decoration: BoxDecoration(
          color: AppColor.colorSelected,
          borderRadius: isFirst
              ? BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )
              : null,
          border: isFirst
              ? Border(
                  bottom: BorderSide(width: 2, color: AppColor.colorDivider),
                )
              : null,
        ),
        alignment: Alignment.center,
        child: isLast
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Adicionar ${type == WorkflowType.Step ? "Etapa" : "Subetapa"}",
                    style: AppTextStyle.size12(),
                  ),
                  Icon(
                    Icons.add,
                    size: AppResponsive.instance.getWidth(20),
                    color: Colors.white,
                  ),
                ],
              )
            : Text(
                step?.model?.name ?? substep?.model?.name ?? "",
                style: AppTextStyle.size12(),
              ),
      ),
    );
  }

  void _showDialog(
    BuildContext context, {
    required WorkflowType type,
    int? index,
    StepLogicalModel? step,
    SubstepLogicalModel? substep,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    bool isMandatory = false;

    if (step != null) {
      titleController.text = step.model!.name;
      descriptionController.text = step.model!.description ?? "";
      isMandatory = step.model!.mandatory;
    } else if (substep != null) {
      titleController.text = substep.model!.name;
      descriptionController.text = substep.model!.description ?? "";
      isMandatory = substep.model!.mandatory;
    }

    Future<void> buildFunction() async {
      FormState? form = formKey.currentState;
      if (form != null && form.validate()) {
        try {
          setState(() {
            print("Sucesso");
            if (step != null) {
              step.model!.name = titleController.text;
              step.model!.description = descriptionController.text;
              step.model!.mandatory = isMandatory;
            } else if (substep != null) {
              substep.model!.name = titleController.text;
              substep.model!.description = descriptionController.text;
              substep.model!.mandatory = isMandatory;
            } else {
              if (type == WorkflowType.Step) {
                model.steps!.add(
                  StepLogicalModel(
                    model: StepDatabaseModel(
                      name: titleController.text,
                      description: descriptionController.text,
                      mandatory: isMandatory,
                      status: false,
                    ),
                    substeps: [],
                  ),
                );
              } else if (type == WorkflowType.Substep && index != null) {
                model.steps![index]!.substeps!.add(
                  SubstepLogicalModel(
                    model: SubstepDatabaseModel(
                      name: titleController.text,
                      description: descriptionController.text,
                      mandatory: isMandatory,
                      status: false,
                    ),
                  ),
                );
              }
              widget.controller.setValidator(validate);
            }
          });
          Navigator.pop(context);
        } catch (error) {
          print("Erro: $error");
        }
      }
    }

    Widget buildTitleField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: titleController,
        headerText:
            "Nome da ${(type == WorkflowType.Step) ? "Etapa" : "Subetapa"}",
        hintText: "Digite o titulo ...",
        validator: (value) {
          if ((value == null || value == "")) {
            return "Preencha um titulo valido...";
          }
          return null;
        },
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildDescriptionField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: descriptionController,
        headerText:
            "Descrição da ${(type == WorkflowType.Step) ? "Etapa" : "Subetapa"}",
        hintText: "Digite a descrição ...",
        validator: (value) {
          return null;
        },
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildWorkflowButton(bool loading) {
      WidgetSolidButtonModel model = WidgetSolidButtonModel(
        label: "${(step != null || substep != null) ? "Editar" : "Adicionar"}",
        loading: loading,
        function: () async {
          buildFunction();
        },
      );
      return WidgetSolidButton(
        model: model,
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: AppResponsive.instance.getWidth(300),
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.instance.getHeight(24),
              horizontal: AppResponsive.instance.getWidth(24),
            ),
            decoration: BoxDecoration(
              color: AppColor.colorFloating,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColor.colorSecondary,
                            ),
                          ),
                          SizedBox(width: AppResponsive.instance.getWidth(24)),
                          Text(
                            "${(step != null || substep != null) ? "Editar" : "Adicionar"} ${(type == WorkflowType.Step) ? "Etapa" : "Subetapa"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.text_1,
                              fontSize: AppResponsive.instance.getWidth(16),
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppResponsive.instance.getHeight(24)),
                      buildTitleField(),
                      SizedBox(height: AppResponsive.instance.getHeight(24)),
                      buildDescriptionField(),
                      SizedBox(height: AppResponsive.instance.getHeight(36)),
                      buildWorkflowButton(false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
