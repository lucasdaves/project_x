import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_extension.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/forms/sections/widget_entity_sections.dart';
import 'package:project_x/view/widgets/buttons/widget_solid_button.dart';
import 'package:project_x/view/widgets/fields/widget_selectorfield.dart';
import 'package:project_x/view/widgets/list/widget_list_card.dart';
import 'package:project_x/view/widgets/fields/widget_textfield.dart';

class WidgetFinanceBox extends StatefulWidget {
  final FinanceLogicalModel model;
  final EntityOperation operation;

  WidgetFinanceBox({
    super.key,
    required this.model,
    required this.operation,
  });

  @override
  _WidgetFinanceBoxState createState() => _WidgetFinanceBoxState();
}

class _WidgetFinanceBoxState extends State<WidgetFinanceBox> {
  static String initialOperationText = "(Inicial)";
  static String parcelOperationText = "(Parcela)";
  static String aditiveOperationText = "(Aditivo)";
  static String costOperationText = "(Custo)";
  static String addOperationText = "Adicionar";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: 4,
            separatorBuilder: (context, index) => _buildSeparator(),
            itemBuilder: (context, typeIndex) => _buildOperationList(typeIndex),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return WidgetListEntityCard(
      value1: "Descrição",
      value2: "Valor",
      value3: "Data de Pagamento",
      value4: "Tipo",
      isHeader: true,
    );
  }

  Widget _buildSeparator() {
    return SizedBox(
      height: AppResponsive.instance.getHeight(0),
    );
  }

  Widget _buildOperationList(int typeIndex) {
    List<FinanceOperationLogicalModel?> operations = widget.model.getType(
      type: typeIndex,
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: operations.length + 1,
      itemBuilder: (context, operationIndex) {
        if (_shouldDisplayButton(typeIndex, operationIndex)) {
          return _buildOperationButton(
            context: context,
            typeIndex: typeIndex,
            finance: operationIndex == operations.length
                ? null
                : operations[operationIndex],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  bool _shouldDisplayButton(int typeIndex, int operationIndex) {
    bool hasInitialOperation = widget.model.getType(type: 0).isNotEmpty;
    if (typeIndex == 0 && operationIndex == 0) {
      return true;
    } else if (typeIndex != 0 && hasInitialOperation) {
      return true;
    }
    return (typeIndex != 0 && hasInitialOperation);
  }

  Widget _buildOperationButton({
    required BuildContext context,
    required int typeIndex,
    FinanceOperationLogicalModel? finance,
  }) {
    String description = finance?.model?.description ?? addOperationText;
    String amount = finance?.model?.amount ?? "";
    String date = finance?.model?.expiresAt?.formatString() ??
        ((finance != null)
            ? FinanceOperationDatabaseModel.statusMap.values
                        .toList()
                        .indexWhere((e) => e == finance.model?.status) ==
                    1
                ? "Pago"
                : "Não Informado"
            : "");
    String typeText = _getTypeText(typeIndex);
    Color typeColor = _getTypeColor(typeIndex);

    return GestureDetector(
      onTap: () =>
          _showDialog(context, typeIndex: typeIndex, financeOperation: finance),
      child: WidgetListEntityCard(
        value1: description,
        value2: amount,
        value3: date,
        value4: typeText,
        color1: finance != null ? AppColor.text_1 : typeColor,
        color4: typeColor,
      ),
    );
  }

  String _getTypeText(int typeIndex) {
    switch (typeIndex) {
      case 0:
        return initialOperationText;
      case 1:
        return parcelOperationText;
      case 2:
        return aditiveOperationText;
      case 3:
        return costOperationText;
      default:
        return "";
    }
  }

  Color _getTypeColor(int typeIndex) {
    switch (typeIndex) {
      case 0:
        return AppColor.colorOpcionalStatus;
      case 1:
        return AppColor.colorNeutralStatus;
      case 2:
        return AppColor.colorPositiveStatus;
      case 3:
        return AppColor.colorNegativeStatus;
      default:
        return Colors.transparent;
    }
  }

  void _showDialog(
    BuildContext context, {
    required int typeIndex,
    FinanceOperationLogicalModel? financeOperation,
  }) {
    final formKey = GlobalKey<FormState>();
    final operationSection = OperationSection();

    _initializeFormControllers(operationSection, financeOperation);

    Future<void> saveOperation() async {
      final form = formKey.currentState;

      if (form != null && form.validate()) {
        if (typeIndex == 1 &&
            !_isParcelValueValid(operationSection, financeOperation)) {
          _showInvalidParcelValueMessage(context);
          return;
        }

        _saveOperation(typeIndex, financeOperation, operationSection);
        Navigator.pop(context);
      }
    }

    _showDialogContent(
      context: context,
      formKey: formKey,
      saveOperation: saveOperation,
      operationSection: operationSection,
      financeOperation: financeOperation,
      typeIndex: typeIndex,
    );
  }

  void _initializeFormControllers(OperationSection operationSection,
      FinanceOperationLogicalModel? financeOperation) {
    if (financeOperation != null) {
      operationSection.descriptionController.text =
          financeOperation.model?.description ?? "";
      operationSection.amountController.text =
          financeOperation.model?.amount ?? "";
      operationSection.dateController.text =
          financeOperation.model?.expiresAt?.formatString() ?? "";
      operationSection.statusController.text =
          financeOperation.model?.status ?? "";
    }
  }

  bool _isParcelValueValid(OperationSection operationSection,
      FinanceOperationLogicalModel? financeOperation) {
    final newAmount = double.parse(operationSection.amountController.text);
    final oldAmount = financeOperation != null
        ? double.parse(financeOperation.model?.amount ?? "0.0")
        : 0.0;

    return widget.model.canIncreaseParcel(
      plus: newAmount,
      minus: oldAmount,
    );
  }

  void _showInvalidParcelValueMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Valor de parcela excede o inicial')),
    );
  }

  void _saveOperation(
    int typeIndex,
    FinanceOperationLogicalModel? financeOperation,
    OperationSection operationSection,
  ) {
    setState(() {
      final operation = FinanceOperationLogicalModel(
        model: FinanceOperationDatabaseModel(
          type: typeIndex,
          description: operationSection.descriptionController.text,
          amount: operationSection.amountController.text,
          status: operationSection.statusController.text,
          expiresAt: operationSection.dateController.text.formatDatetime(),
        ),
      );

      if (financeOperation != null) {
        operation.model?.financeId = financeOperation.model?.financeId;
        operation.model?.id = financeOperation.model?.id;
        if (FinanceOperationDatabaseModel.statusMap.values
                .toList()
                .indexWhere((e) => e == operation.model?.status!) ==
            1) {
          operation.model?.expiresAt = null;
        }
        if (typeIndex == 0 && widget.operation == EntityOperation.Create) {
          widget.model.operations?.removeWhere(
            (operation) => operation?.model?.type != 0,
          );
        }
        financeOperation.model = operation.model;
      } else {
        widget.model.operations!.add(operation);
      }

      if (typeIndex != 0) {
        widget.model.getType(type: 0).first?.model?.expiresAt =
            widget.model.getParcelDate(isLast: true);
      }
    });
  }

  void _showDialogContent({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Future<void> Function() saveOperation,
    required OperationSection operationSection,
    FinanceOperationLogicalModel? financeOperation,
    required int typeIndex,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
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
              child: _buildDialogForm(
                context: context,
                formKey: formKey,
                saveOperation: saveOperation,
                operationSection: operationSection,
                financeOperation: financeOperation,
                typeIndex: typeIndex,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialogForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Future<void> Function() saveOperation,
    required OperationSection operationSection,
    FinanceOperationLogicalModel? financeOperation,
    required int typeIndex,
  }) {
    return StatefulBuilder(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(context, financeOperation),
              SizedBox(height: AppResponsive.instance.getHeight(24)),
              if (typeIndex == 1) ...[
                _buildSelectorField(
                    controller: operationSection.statusController,
                    headerText: operationSection.statusLabel,
                    hintText: operationSection.statusHint,
                    validator: operationSection.validateStatus,
                    options:
                        FinanceOperationDatabaseModel.statusMap.values.toList(),
                    function: () {
                      state(
                        () {
                          print("oi");
                        },
                      );
                    }),
                SizedBox(height: AppResponsive.instance.getHeight(24)),
                if (FinanceOperationDatabaseModel.statusMap.values
                        .toList()
                        .indexWhere((e) =>
                            e == operationSection.statusController.text) ==
                    0) ...[
                  _buildTextField(
                    controller: operationSection.dateController,
                    headerText: operationSection.dateLabel,
                    hintText: operationSection.dateHint,
                    validator: operationSection.validateDate,
                  ),
                  SizedBox(height: AppResponsive.instance.getHeight(24)),
                ],
              ],
              _buildTextField(
                controller: operationSection.descriptionController,
                headerText: operationSection.descriptionLabel,
                hintText: operationSection.descriptionLabel,
                validator: operationSection.validateDescription,
              ),
              SizedBox(height: AppResponsive.instance.getHeight(24)),
              if ((typeIndex == 0 &&
                      widget.operation != EntityOperation.Update) ||
                  typeIndex != 0) ...[
                _buildTextField(
                  controller: operationSection.amountController,
                  headerText: operationSection.amountLabel,
                  hintText: operationSection.amountHint,
                  validator: operationSection.validateAmount,
                ),
                SizedBox(height: AppResponsive.instance.getHeight(24)),
              ],
              if (typeIndex == 0 &&
                  widget.operation != EntityOperation.Update &&
                  financeOperation != null) ...[
                _buildWarningText(),
                SizedBox(
                  height: AppResponsive.instance.getHeight(24),
                ),
              ],
              _buildSaveButton(saveOperation, financeOperation),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(
      BuildContext context, FinanceOperationLogicalModel? financeOperation) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close_rounded, color: AppColor.colorSecondary),
        ),
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Text(
          "${financeOperation != null ? 'Editar' : 'Adicionar'} Operação",
          textAlign: TextAlign.center,
          style: AppTextStyle.size16(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String headerText,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return WidgetTextField(
      model: WidgetTextFieldModel(
        controller: controller,
        headerText: headerText,
        hintText: hintText,
        validator: validator,
      ),
    );
  }

  Widget _buildSelectorField({
    required TextEditingController controller,
    required String headerText,
    required String hintText,
    required String? Function(String?) validator,
    required List<String> options,
    required Function() function,
  }) {
    return WidgetSelectorField(
      model: WidgetSelectorFieldModel(
        controller: controller,
        headerText: headerText,
        hintText: hintText,
        validator: validator,
        options: options,
        function: function,
      ),
    );
  }

  Widget _buildWarningText() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.instance.getHeight(16)),
      child: Text(
        "Editar o valor inicial irá redefinir todas as operações existentes neste financeiro.",
        style: AppTextStyle.size12(
          color: AppColor.colorAlertStatus,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildSaveButton(Future<void> Function() saveOperation,
      FinanceOperationLogicalModel? financeOperation) {
    return WidgetSolidButton(
      model: WidgetSolidButtonModel(
        label: financeOperation != null ? "Editar" : "Adicionar",
        loading: false,
        function: saveOperation,
      ),
    );
  }
}
