import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/forms/controller/forms_controller.dart';
import 'package:project_x/view/forms/sections/widget_entity_sections.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/drawer/widget_flow_drawer.dart';
import 'package:project_x/view/widgets/drawer/widget_user_drawer.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';

class WidgetUserForm extends StatefulWidget {
  static const String tag = "/user_form_view";
  final EntityOperation operation;

  const WidgetUserForm({super.key, required this.operation});

  @override
  State<WidgetUserForm> createState() => _WidgetUserFormState();
}

class _WidgetUserFormState extends State<WidgetUserForm> {
  final userSection = UserSection();
  final personalDataSection = PersonalDataSection();
  final addressSection = AddressSection();
  final contactSection = ContactSection();
  final formKey = GlobalKey<FormState>();
  final controller = FormsController();
  final entity = "Usuário";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.setType(EntityType.User);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(),
      body: _buildBody(),
      drawer: WidgetStartDrawer(),
      endDrawer: WidgetEndDrawer(),
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

  Future<bool> getFunction() async {
    try {
      bool formValidation = (formKey.currentState?.validate() ?? false);
      if (formValidation) {
        controller.setModel(getModel());
        switch (widget.operation) {
          case EntityOperation.Create:
            await controller.createEntity();
            break;
          case EntityOperation.Read:
            break;
          case EntityOperation.Update:
            break;
          case EntityOperation.Delete:
            break;
        }
      }
      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  UserLogicalModel getModel() {
    UserLogicalModel model = UserLogicalModel(
      model: UserDatabaseModel(
        type: 0,
        login: "",
        password: "",
      ),
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
}
