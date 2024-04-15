import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/widgets/buttons/widget_solid_button.dart';
import 'package:project_x/view/widgets/textfield/widget_textfield.dart';

class WidgetFinanceBox extends StatefulWidget {
  final FinanceLogicalModel model;

  const WidgetFinanceBox({super.key, required this.model});

  @override
  State<WidgetFinanceBox> createState() => _WidgetFinanceBoxState();
}

class _WidgetFinanceBoxState extends State<WidgetFinanceBox> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 4,
      separatorBuilder: (context, typeIndex) {
        return SizedBox(
          height: AppResponsive.instance.getHeight(12),
        );
      },
      itemBuilder: (context, typeIndex) {
        List<FinanceOperationLogicalModel?> operations =
            widget.model.getType(type: typeIndex);
        return Container(
          height: AppResponsive.instance.getHeight(90),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: operations.length + 1,
            separatorBuilder: (context, operationIndex) {
              return SizedBox(
                width: AppResponsive.instance.getWidth(20),
              );
            },
            itemBuilder: (context, operationIndex) {
              bool hasInitial = widget.model.getType(type: 0).length > 0;
              if ((typeIndex != 0 && hasInitial) ||
                  (typeIndex == 0 && (!hasInitial || operationIndex == 0)))
                return button(
                  typeIndex: typeIndex,
                  finance: (operationIndex == operations.length)
                      ? null
                      : operations[operationIndex],
                );
            },
          ),
        );
      },
    );
  }

  Widget button({
    required int typeIndex,
    FinanceOperationLogicalModel? finance,
  }) {
    // Determine the base text for the button based on the typeIndex and whether it is the last button
    String buttonText;
    TextSpan? additionalTextSpan;

    if (finance == null) {
      // Determine the text for the "Adicionar" button based on typeIndex
      switch (typeIndex) {
        case 0:
          buttonText = "Adicionar valor inicial";
          break;
        case 1:
          buttonText = "Adicionar parcela";
          break;
        // Adicione mais casos aqui para outros tipos de operação conforme necessário
        case 2:
          buttonText = "Adicionar aditivo";
          break;
        case 3:
          buttonText = "Adicionar custo";
          break;
        default:
          buttonText = "Adicionar";
          break;
      }
    } else {
      // Use the description from finance model if provided
      buttonText = finance.model?.amount ?? "";

      // Add color text describing the type of the card already created
      switch (typeIndex) {
        case 0:
          additionalTextSpan = TextSpan(
            text: " (Valor Inicial)",
            style:
                AppTextStyle.size12().copyWith(color: AppColor.colorSecondary),
          );
          break;
        case 1:
          additionalTextSpan = TextSpan(
            text: " (Parcela)",
            style:
                AppTextStyle.size12().copyWith(color: AppColor.colorSecondary),
          );
          break;
        case 2:
          additionalTextSpan = TextSpan(
            text: " (Aditivo)",
            style:
                AppTextStyle.size12().copyWith(color: AppColor.colorSecondary),
          );
        case 3:
          additionalTextSpan = TextSpan(
            text: " (Custo)",
            style:
                AppTextStyle.size12().copyWith(color: AppColor.colorSecondary),
          );
        default:
          // Você pode adicionar um texto padrão se necessário para tipos não especificamente tratados
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        _showDialog(
          context,
          typeIndex: typeIndex,
          financeOperation: finance,
        );
      },
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
        child: Container(
          width: AppResponsive.instance.getWidth(150),
          height: AppResponsive.instance.getHeight(60),
          decoration: BoxDecoration(
            color: AppColor.colorWorkflowBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border(
              bottom: BorderSide(width: 2, color: AppColor.colorDivider),
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.instance.getWidth(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Use a RichText widget to combine buttonText and additionalTextSpan
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: buttonText,
                        style: AppTextStyle.size12(),
                      ),
                      if (additionalTextSpan != null) additionalTextSpan,
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (finance == null) ...[
                  SizedBox(
                    height: AppResponsive.instance.getHeight(4),
                  ),
                  Icon(
                    Icons.add,
                    size: AppResponsive.instance.getWidth(20),
                    color: AppColor.colorSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(
    BuildContext context, {
    required int typeIndex,
    FinanceOperationLogicalModel? financeOperation,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    if (financeOperation != null) {
      descriptionController.text = financeOperation.model?.description ?? "";
      amountController.text = financeOperation.model?.amount ?? "";
    }

    Future<void> saveFinanceOperation() async {
      FormState? form = formKey.currentState;
      if (form != null && form.validate()) {
        try {
          setState(() {
            if (financeOperation != null) {
              financeOperation.model = FinanceOperationDatabaseModel(
                type: typeIndex,
                description: descriptionController.text,
                amount: amountController.text,
              );
            } else {
              widget.model.operations!.add(
                FinanceOperationLogicalModel(
                  model: FinanceOperationDatabaseModel(
                    type: typeIndex,
                    description: descriptionController.text,
                    amount: amountController.text,
                  ),
                ),
              );
            }
          });

          Navigator.pop(context);
        } catch (error) {
          print("Erro: $error");
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                              SizedBox(
                                width: AppResponsive.instance.getWidth(24),
                              ),
                              Text(
                                "${financeOperation != null ? 'Editar' : 'Adicionar'} Operação",
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
                          WidgetTextField(
                            model: WidgetTextFieldModel(
                              controller: descriptionController,
                              headerText: "Descrição da Operação",
                              hintText: "Digite a descrição...",
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return "Preencha uma descrição válida...";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: AppResponsive.instance.getHeight(24),
                          ),
                          WidgetTextField(
                            model: WidgetTextFieldModel(
                              controller: amountController,
                              headerText: "Valor da Operação",
                              hintText: "Digite o valor...",
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return "Preencha um valor válido...";
                                } else if (double.tryParse(value) == null) {
                                  return "Valor inválido";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: AppResponsive.instance.getHeight(36),
                          ),
                          WidgetSolidButton(
                            model: WidgetSolidButtonModel(
                              label:
                                  "${financeOperation != null ? 'Editar' : 'Adicionar'}",
                              loading: false,
                              function: () async {
                                await saveFinanceOperation();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
