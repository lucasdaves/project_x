import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/create/create_controller.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/textfield/widget_textfield.dart';
import 'package:project_x/view/widgets/workflows/widget_workflow_box.dart';

class WidgetEntityForm extends StatefulWidget {
  final CreateController controller;

  const WidgetEntityForm({
    super.key,
    required this.controller,
  });

  @override
  State<WidgetEntityForm> createState() => _WidgetEntityFormState();
}

class _WidgetEntityFormState extends State<WidgetEntityForm> {
  late PersonalDataSection personalDataSection;
  late AddressSection addressSection;
  late ContactSection contactSection;
  late DescriptionSection descriptionSection;
  late OperationSection operationSection;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    personalDataSection = PersonalDataSection();
    addressSection = AddressSection();
    contactSection = ContactSection();
    descriptionSection = DescriptionSection();
    operationSection = OperationSection();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Widget formWidget;

    switch (widget.controller.getType()) {
      case EntityType.Client:
        formWidget = ClientForm(
          controller: widget.controller,
          personalDataSection: personalDataSection,
          addressSection: addressSection,
          contactSection: contactSection,
          formKey: formKey,
        );
        break;
      case EntityType.Finance:
        formWidget = FinanceForm(
          controller: widget.controller,
          descriptionSection: descriptionSection,
          operationSection: operationSection,
          formKey: formKey,
        );
      case EntityType.Workflow:
        formWidget = WorkflowForm(
          controller: widget.controller,
          descriptionSection: descriptionSection,
          operationSection: operationSection,
          formKey: formKey,
        );
      default:
        formWidget = const SizedBox.shrink();
        break;
    }

    return formWidget;
  }
}

//* FORMS * //

class ClientForm extends StatelessWidget {
  final CreateController controller;
  final PersonalDataSection personalDataSection;
  final AddressSection addressSection;
  final ContactSection contactSection;
  final GlobalKey<FormState> formKey;

  const ClientForm({
    super.key,
    required this.controller,
    required this.personalDataSection,
    required this.addressSection,
    required this.contactSection,
    required this.formKey,
  });

  ClientLogicalModel getModel() {
    ClientLogicalModel model = ClientLogicalModel(
      personal: PersonalLogicalModel(
        model: PersonalDatabaseModel(
          name: personalDataSection.nameController.text,
          document: personalDataSection.documentController.text,
          email: contactSection.emailController.text,
          phone: contactSection.phoneController.text,
          annotation: contactSection.noteController.text,
        ),
        address: AddressLogicalModel(
          model: AddressDatabaseModel(
            country: addressSection.countryController.text,
            state: addressSection.stateController.text,
            city: addressSection.cityController.text,
            postalCode: addressSection.cepController.text,
            street: addressSection.streetController.text,
            number: addressSection.numberController.text,
            complement: addressSection.complementController.text,
          ),
        ),
      ),
    );
    return model;
  }

  bool validate() {
    if (formKey.currentState?.validate() ?? false) {
      controller.stream.value.model = getModel();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.setValidator(validate);
    return Form(
      key: formKey,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Dados Pessoais",
                padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextfield(
                      controller: personalDataSection.nameController,
                      headerText: personalDataSection.nameLabel,
                      hintText: personalDataSection.nameHint,
                      validator: (value) =>
                          personalDataSection.validateName(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: personalDataSection.documentController,
                      headerText: personalDataSection.documentLabel,
                      hintText: personalDataSection.documentHint,
                      validator: (value) =>
                          personalDataSection.validateDocument(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: personalDataSection.dobController,
                      headerText: personalDataSection.dobLabel,
                      hintText: personalDataSection.dobHint,
                      validator: (value) =>
                          personalDataSection.validateDob(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: personalDataSection.genderController,
                      headerText: personalDataSection.genderLabel,
                      hintText: personalDataSection.genderHint,
                      validator: (value) =>
                          personalDataSection.validateGender(value),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: AppResponsive.instance.getWidth(24)),
          Expanded(
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Endereço",
                padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextfield(
                      controller: addressSection.countryController,
                      headerText: addressSection.countryLabel,
                      hintText: addressSection.countryHint,
                      validator: (value) =>
                          addressSection.validateCountry(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.cepController,
                      headerText: addressSection.cepLabel,
                      hintText: addressSection.cepHint,
                      validator: (value) => addressSection.validateCep(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.stateController,
                      headerText: addressSection.stateLabel,
                      hintText: addressSection.stateHint,
                      validator: (value) => addressSection.validateState(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.cityController,
                      headerText: addressSection.cityLabel,
                      hintText: addressSection.cityHint,
                      validator: (value) => addressSection.validateCity(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.streetController,
                      headerText: addressSection.streetLabel,
                      hintText: addressSection.streetHint,
                      validator: (value) =>
                          addressSection.validateStreet(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.numberController,
                      headerText: addressSection.numberLabel,
                      hintText: addressSection.numberHint,
                      validator: (value) =>
                          addressSection.validateNumber(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.complementController,
                      headerText: addressSection.complementLabel,
                      hintText: addressSection.complementHint,
                      validator: (value) =>
                          addressSection.validateComplement(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: addressSection.referenceController,
                      headerText: addressSection.referenceLabel,
                      hintText: addressSection.referenceHint,
                      validator: (value) =>
                          addressSection.validateReference(value),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: AppResponsive.instance.getWidth(24)),
          Expanded(
            child: WidgetFloatingBox(
              model: WidgetFloatingBoxModel(
                label: "Contato",
                padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextfield(
                      controller: contactSection.emailController,
                      headerText: contactSection.emailLabel,
                      hintText: contactSection.emailHint,
                      validator: (value) => contactSection.validateEmail(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: contactSection.phoneController,
                      headerText: contactSection.phoneLabel,
                      hintText: contactSection.phoneHint,
                      validator: (value) => contactSection.validatePhone(value),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    buildTextfield(
                      controller: contactSection.noteController,
                      headerText: contactSection.noteLabel,
                      hintText: contactSection.noteHint,
                      validator: (value) => contactSection.validateNote(value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceForm extends StatelessWidget {
  final CreateController controller;
  final DescriptionSection descriptionSection;
  final OperationSection operationSection;
  final GlobalKey<FormState> formKey;

  const FinanceForm({
    super.key,
    required this.controller,
    required this.descriptionSection,
    required this.operationSection,
    required this.formKey,
  });

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

  bool validate() {
    if (formKey.currentState?.validate() ?? false) {
      controller.stream.value.model = getModel();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.setValidator(validate);
    return Form(
      key: formKey,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetContainBox(
            model: WidgetContainModelBox(
              height: double.maxFinite,
              width: 300,
              widget: WidgetFloatingBox(
                model: WidgetFloatingBoxModel(
                  label: "Dados do Financeiro",
                  padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextfield(
                        controller: descriptionSection.titleController,
                        headerText: descriptionSection.titleLabel,
                        hintText: descriptionSection.titleHint,
                        validator: (value) =>
                            descriptionSection.validateTitle(value),
                      ),
                      SizedBox(height: AppResponsive.instance.getHeight(24)),
                      buildTextfield(
                        controller: descriptionSection.descriptionController,
                        headerText: descriptionSection.descriptionLabel,
                        hintText: descriptionSection.descriptionHint,
                        validator: (value) =>
                            descriptionSection.validateDescription(value),
                      ),
                      SizedBox(height: AppResponsive.instance.getHeight(24)),
                      buildTextfield(
                        controller: operationSection.amountController,
                        headerText: operationSection.amountLabel,
                        hintText: operationSection.amountHint,
                        validator: (value) =>
                            operationSection.validateAmount(value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkflowForm extends StatelessWidget {
  final CreateController controller;
  final DescriptionSection descriptionSection;
  final OperationSection operationSection;
  final GlobalKey<FormState> formKey;

  const WorkflowForm({
    super.key,
    required this.controller,
    required this.descriptionSection,
    required this.operationSection,
    required this.formKey,
  });

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

  bool validate() {
    if (formKey.currentState?.validate() ?? false) {
      controller.stream.value.model = getModel();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.setValidator(validate);
    return Form(
      key: formKey,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(
              AppResponsive.instance.getWidth(12),
            ),
            decoration: BoxDecoration(
              color: AppColor.colorFloating,
              borderRadius: BorderRadius.circular(8),
            ),
            child: WidgetWorkflowBox(controller: controller),
          )),
        ],
      ),
    );
  }
}

//* SECTIONS *//

class PersonalDataSection {
  // LABELS
  String nameLabel = "Nome Completo";
  String documentLabel = "Documento";
  String dobLabel = "Data de Nascimento";
  String genderLabel = "Gênero";

  // HINT TEXTS
  String nameHint = "Digite seu nome completo ...";
  String documentHint = "Digite seu documento ...";
  String dobHint = "Digite sua data de nascimento ...";
  String genderHint = "Digite seu gênero ...";

  // TEXT CONTROLLERS
  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome';
    }
    return null;
  }

  String? validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o documento';
    }
    return null;
  }

  String? validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nascimento';
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o gênero';
    }
    return null;
  }
}

class AddressSection {
  // LABELS
  String countryLabel = "País";
  String cepLabel = "CEP";
  String stateLabel = "Estado";
  String cityLabel = "Cidade";
  String streetLabel = "Rua";
  String numberLabel = "Número";
  String complementLabel = "Complemento";
  String referenceLabel = "Referência";

  // HINT TEXTS
  String countryHint = "Digite o país ...";
  String cepHint = "Digite o CEP ...";
  String stateHint = "Digite o estado ...";
  String cityHint = "Digite a cidade ...";
  String streetHint = "Digite a rua ...";
  String numberHint = "Digite o número ...";
  String complementHint = "Digite o complemento ...";
  String referenceHint = "Digite a referência ...";

  // TEXT CONTROLLERS
  TextEditingController countryController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController referenceController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o país';
    }
    return null;
  }

  String? validateCep(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CEP';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o estado';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a cidade';
    }
    return null;
  }

  String? validateStreet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a rua';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o número';
    }
    return null;
  }

  String? validateComplement(String? value) {
    return null;
  }

  String? validateReference(String? value) {
    return null;
  }
}

class ContactSection {
  // LABELS
  final String phoneLabel = "Telefone";
  final String emailLabel = "E-mail";
  final String noteLabel = "Anotação";

  // HINT TEXTS
  final String phoneHint = "Digite seu telefone...";
  final String emailHint = "Digite seu e-mail...";
  final String noteHint = "Digite uma anotação...";

  // TEXT CONTROLLERS
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o telefone';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o e-mail';
    }
    return null;
  }

  String? validateNote(String? value) {
    return null;
  }
}

class DescriptionSection {
  // LABELS
  final String titleLabel = "Titulo";
  final String descriptionLabel = "Descrição";
  final String mandatoryLabel = "Obrigatório ?";

  // HINT TEXTS
  final String titleHint = "Digite o titulo...";
  final String descriptionHint = "Digite a descrição...";
  final String mandatoryHint = "Selecione ...";

  // TEXT CONTROLLERS
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController mandatoryController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o titulo';
    }
    return null;
  }

  String? validateDescription(String? value) {
    return null;
  }

  String? validateMandatory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione uma opção';
    }
    return null;
  }
}

class OperationSection {
  // LABELS
  final String amountLabel = "Quantia";
  final String descriptionLabel = "Descrição";

  // HINT TEXTS
  final String amountHint = "Digite a quantia...";
  final String descriptionHint = "Digite a descrição...";

  // TEXT CONTROLLERS
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // VALIDATION FUNCTIONS
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a quantia';
    }
    return null;
  }

  String? validateDescription(String? value) {
    return null;
  }
}

class WorkflowSection {
  List<DescriptionSection> steps = [];
  Map<String, List<DescriptionSection>> substeps = {};
}

//* WIDGETS *//

Widget buildTextfield({
  required TextEditingController controller,
  String? headerText,
  String? hintText,
  String? Function(String?)? validator,
}) {
  WidgetTextFieldModel model = WidgetTextFieldModel(
    controller: controller,
    headerText: headerText,
    hintText: hintText,
    validator: validator,
  );
  return WidgetTextField(
    model: model,
  );
}
