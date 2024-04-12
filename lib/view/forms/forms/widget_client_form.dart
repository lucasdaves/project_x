import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
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
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';
import 'package:project_x/view/widgets/textfield/widget_textfield.dart';

class WidgetClientForm extends StatefulWidget {
  static const String tag = "/client_form_view";
  final EntityOperation operation;

  const WidgetClientForm({super.key, required this.operation});

  @override
  State<WidgetClientForm> createState() => _WidgetClientFormState();
}

class _WidgetClientFormState extends State<WidgetClientForm> {
  final personalDataSection = PersonalDataSection();
  final addressSection = AddressSection();
  final contactSection = ContactSection();
  final formKey = GlobalKey<FormState>();
  final controller = FormsController();
  final entity = "Cliente";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.setType(EntityType.Client);
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: WidgetFloatingBox(
                        model: WidgetFloatingBoxModel(
                          label: "Dados Pessoais",
                          padding: EdgeInsets.all(
                              AppResponsive.instance.getWidth(24)),
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
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildTextfield(
                                controller:
                                    personalDataSection.documentController,
                                headerText: personalDataSection.documentLabel,
                                hintText: personalDataSection.documentHint,
                                validator: (value) =>
                                    personalDataSection.validateDocument(value),
                              ),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildTextfield(
                                controller: personalDataSection.dobController,
                                headerText: personalDataSection.dobLabel,
                                hintText: personalDataSection.dobHint,
                                validator: (value) =>
                                    personalDataSection.validateDob(value),
                              ),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildTextfield(
                                controller:
                                    personalDataSection.genderController,
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
                          padding: EdgeInsets.all(
                              AppResponsive.instance.getWidth(24)),
                          widget: SingleChildScrollView(
                            child: Column(
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
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller: addressSection.cepController,
                                  headerText: addressSection.cepLabel,
                                  hintText: addressSection.cepHint,
                                  validator: (value) =>
                                      addressSection.validateCep(value),
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller: addressSection.stateController,
                                  headerText: addressSection.stateLabel,
                                  hintText: addressSection.stateHint,
                                  validator: (value) =>
                                      addressSection.validateState(value),
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller: addressSection.cityController,
                                  headerText: addressSection.cityLabel,
                                  hintText: addressSection.cityHint,
                                  validator: (value) =>
                                      addressSection.validateCity(value),
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller: addressSection.streetController,
                                  headerText: addressSection.streetLabel,
                                  hintText: addressSection.streetHint,
                                  validator: (value) =>
                                      addressSection.validateStreet(value),
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller: addressSection.numberController,
                                  headerText: addressSection.numberLabel,
                                  hintText: addressSection.numberHint,
                                  validator: (value) =>
                                      addressSection.validateNumber(value),
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller:
                                      addressSection.complementController,
                                  headerText: addressSection.complementLabel,
                                  hintText: addressSection.complementHint,
                                  validator: (value) =>
                                      addressSection.validateComplement(value),
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildTextfield(
                                  controller:
                                      addressSection.referenceController,
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
                    ),
                    SizedBox(width: AppResponsive.instance.getWidth(24)),
                    Expanded(
                      child: WidgetFloatingBox(
                        model: WidgetFloatingBoxModel(
                          label: "Contato",
                          padding: EdgeInsets.all(
                              AppResponsive.instance.getWidth(24)),
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextfield(
                                controller: contactSection.emailController,
                                headerText: contactSection.emailLabel,
                                hintText: contactSection.emailHint,
                                validator: (value) =>
                                    contactSection.validateEmail(value),
                              ),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildTextfield(
                                controller: contactSection.phoneController,
                                headerText: contactSection.phoneLabel,
                                hintText: contactSection.phoneHint,
                                validator: (value) =>
                                    contactSection.validatePhone(value),
                              ),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildTextfield(
                                controller: contactSection.noteController,
                                headerText: contactSection.noteLabel,
                                hintText: contactSection.noteHint,
                                validator: (value) =>
                                    contactSection.validateNote(value),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
}
