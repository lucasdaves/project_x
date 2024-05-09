import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_extension.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/forms/sections/widget_entity_sections.dart';
import 'package:project_x/view/widgets/buttons/widget_solid_button.dart';
import 'package:project_x/view/widgets/divider/widget_divider.dart';
import 'package:project_x/view/widgets/fields/widget_selectorfield.dart';
import 'package:project_x/view/widgets/fields/widget_textfield.dart';

class WidgetWorkflowBox extends StatefulWidget {
  final WorkflowLogicalModel model;
  final EntityOperation operation;

  const WidgetWorkflowBox({
    super.key,
    required this.model,
    required this.operation,
  });

  @override
  State<WidgetWorkflowBox> createState() => _WidgetWorkflowBoxState();
}

class _WidgetWorkflowBoxState extends State<WidgetWorkflowBox> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: (widget.model.steps?.length ?? 0) + 1,
      separatorBuilder: (context, stpIndex) {
        return SizedBox(
          width: AppResponsive.instance.getWidth(20),
        );
      },
      itemBuilder: (context, stpIndex) {
        bool isFinalStep = (stpIndex == widget.model.steps!.length);
        return (isFinalStep && widget.operation == EntityOperation.Read)
            ? SizedBox.shrink()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      width: AppResponsive.instance.getWidth(150),
                      padding: EdgeInsets.only(
                        bottom: AppResponsive.instance.getHeight(24),
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.colorPrimary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.colorPrimary,
                          width: AppResponsive.instance.getWidth(4),
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: (isFinalStep)
                          ? button(
                              type: WorkflowType.Step,
                              isFirst: true,
                              isLast: false,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                button(
                                  type: WorkflowType.Step,
                                  step: widget.model.steps![stpIndex]!,
                                  isFirst: true,
                                  isLast: false,
                                ),
                                Flexible(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: (widget.model.steps?[stpIndex]
                                            ?.substeps?.length ??
                                        0),
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          AppResponsive.instance.getHeight(12),
                                    ),
                                    separatorBuilder: (context, subIndex) {
                                      return SizedBox(
                                        height: AppResponsive.instance
                                            .getHeight(12),
                                      );
                                    },
                                    itemBuilder: (context, subIndex) {
                                      return button(
                                        type: WorkflowType.Substep,
                                        substep: widget.model.steps![stpIndex]!
                                            .substeps![subIndex],
                                        isFirst: false,
                                        isLast: false,
                                      );
                                    },
                                  ),
                                ),
                                if (widget.operation != EntityOperation.Read)
                                  button(
                                    type: WorkflowType.Substep,
                                    index: stpIndex,
                                    isFirst: false,
                                    isLast: true,
                                  ),
                              ],
                            ),
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
        if (widget.operation != EntityOperation.Read) {
          _showDialog(
            context,
            type: type,
            index: index,
            step: step,
            substep: substep,
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLast) ...[
            WidgetDivider(verticalSpace: 2, horizontalSpace: 0),
          ],
          Container(
            width: AppResponsive.instance.getWidth(150),
            constraints: BoxConstraints(
                minHeight: AppResponsive.instance.getHeight(60),
                maxHeight: AppResponsive.instance.getHeight(120)),
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.instance.getHeight(6),
              horizontal: AppResponsive.instance.getWidth(12),
            ),
            decoration: BoxDecoration(
              color: AppColor.colorWorkflowBackground,
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? Radius.circular(8) : Radius.zero,
                topRight: isFirst ? Radius.circular(8) : Radius.zero,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if ((isLast || isFirst) &&
                    (step == null && substep == null)) ...[
                  Text(
                    "Adicionar ${type == WorkflowType.Step ? "Etapa" : "Subetapa"}",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.size12(),
                  ),
                  SizedBox(
                    height: AppResponsive.instance.getHeight(4),
                  ),
                  Icon(
                    Icons.add,
                    size: AppResponsive.instance.getWidth(20),
                    color: AppColor.colorSecondary,
                  ),
                ] else ...[
                  Text.rich(
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      children: [
                        if ((widget.operation == EntityOperation.Read ||
                                widget.operation == EntityOperation.Update) &&
                            widget.model.model!.isCopy == true &&
                            substep != null) ...[
                          TextSpan(
                            text: "(${substep.getStatus().entries.first.key}) ",
                            style: AppTextStyle.size12(
                              color: substep.getStatus().entries.first.value,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${substep.model?.evolution != "0" ? "${substep.model?.evolution}%" : ""} ",
                            style: AppTextStyle.size12(
                              color: AppColor.colorSecondary,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                        TextSpan(
                          text: step?.model?.name ?? substep?.model?.name ?? "",
                          style: AppTextStyle.size12(),
                        ),
                      ],
                    ),
                    style: AppTextStyle.size48(),
                  ),
                ],
              ],
            ),
          ),
          if (isFirst) ...[
            WidgetDivider(verticalSpace: 2, horizontalSpace: 0),
          ],
        ],
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
    final WorkflowOperationSection section = WorkflowOperationSection();

    if (step != null) {
      section.titleController.text = step.model!.name;
      section.descriptionController.text = step.model!.description ?? "";
    } else if (substep != null) {
      section.titleController.text = substep.model!.name;
      section.descriptionController.text = substep.model!.description ?? "";
      section.dateController.text =
          substep.model!.expiresAt?.formatString() ?? "";
      section.statusController.text = substep.model!.status ?? "";
      section.evolutionController.text = substep.model!.evolution ?? "";
    }

    Future<void> buildFunction() async {
      FormState? form = formKey.currentState;
      if (form != null && form.validate()) {
        try {
          setState(() {
            if (step != null) {
              step.model!.name = section.titleController.text;
              step.model!.description = section.descriptionController.text;
            } else if (substep != null) {
              substep.model!.name = section.titleController.text;
              substep.model!.description = section.descriptionController.text;
              substep.model!.status = section.statusController.text;
              substep.model!.evolution = section.evolutionController.text;

              if (SubstepDatabaseModel.statusMap[2] == substep.model!.status!) {
                substep.model!.expiresAt = null;
                substep.model!.concludedAt =
                    section.dateController.text.formatDatetime();
              } else {
                substep.model!.expiresAt =
                    section.dateController.text.formatDatetime();
                substep.model!.concludedAt = null;
              }
            } else {
              if (type == WorkflowType.Step) {
                widget.model.steps!.add(
                  StepLogicalModel(
                    model: StepDatabaseModel(
                      name: section.titleController.text,
                      description: section.descriptionController.text,
                    ),
                    substeps: [],
                  ),
                );
              } else if (type == WorkflowType.Substep && index != null) {
                widget.model.steps![index]!.substeps!.add(
                  SubstepLogicalModel(
                    model: SubstepDatabaseModel(
                      name: section.titleController.text,
                      description: section.descriptionController.text,
                      status: SubstepDatabaseModel.statusMap[0],
                      evolution: section.evolutionController.text,
                    ),
                  ),
                );
              }
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
        controller: section.titleController,
        headerText: section.titleLabel,
        hintText: section.titleHint,
        validator: (value) => section.validateTitle(value),
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildDescriptionField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: section.descriptionController,
        headerText: section.descriptionLabel,
        hintText: section.descriptionHint,
        validator: (value) => section.validateDescription(value),
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildDateField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: section.dateController,
        headerText: section.dateLabel,
        hintText: section.dateHint,
        validator: (value) => section.validateDate(value),
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildEvolutionField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: section.evolutionController,
        headerText: section.evolutionLabel,
        hintText: section.evolutionHint,
        validator: (value) => section.validateEvolution(value),
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildStatusField(Function() function) {
      WidgetSelectorFieldModel model = WidgetSelectorFieldModel(
        controller: section.statusController,
        headerText: section.statusLabel,
        hintText: section.statusHint,
        validator: section.validateStatus,
        options: SubstepDatabaseModel.statusMap.values.toList(),
        function: function,
      );
      return WidgetSelectorField(
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
        return StatefulBuilder(
          builder: (context, state) {
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
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                          SizedBox(
                            width: AppResponsive.instance.getWidth(24),
                          ),
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
                      SizedBox(
                        height: AppResponsive.instance.getHeight(24),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.operation == EntityOperation.Update &&
                                  substep != null &&
                                  widget.model.model!.isCopy) ...[
                                buildStatusField(() => state(() {})),
                                SizedBox(
                                  height: AppResponsive.instance.getHeight(24),
                                ),
                                buildDateField(),
                                SizedBox(
                                  height: AppResponsive.instance.getHeight(24),
                                ),
                              ],
                              buildTitleField(),
                              SizedBox(
                                height: AppResponsive.instance.getHeight(24),
                              ),
                              buildDescriptionField(),
                              if (type == WorkflowType.Substep) ...[
                                SizedBox(
                                  height: AppResponsive.instance.getHeight(24),
                                ),
                                buildEvolutionField(),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppResponsive.instance.getHeight(36),
                      ),
                      buildWorkflowButton(false),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
