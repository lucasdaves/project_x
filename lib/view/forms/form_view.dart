import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/project_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/services/database/model/system_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_extension.dart';
import 'package:project_x/utils/app_feedback.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/forms/controller/forms_controller.dart';
import 'package:project_x/view/forms/sections/widget_entity_sections.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/drawer/widget_flow_drawer.dart';
import 'package:project_x/view/widgets/drawer/widget_user_drawer.dart';
import 'package:project_x/view/widgets/fields/widget_selectorfield.dart';
import 'package:project_x/view/widgets/fields/widget_textfield.dart';
import 'package:project_x/view/widgets/finances/widget_finance_box.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';
import 'package:project_x/view/widgets/workflows/widget_workflow_box.dart';

class EntityFormView extends StatefulWidget {
  static const String tag = "/form_view";

  final EntityType type;
  final EntityOperation operation;
  final int? entityIndex;
  final bool hasHeader;

  const EntityFormView({
    Key? key,
    required this.type,
    required this.operation,
    this.entityIndex,
    this.hasHeader = true,
  }) : super(key: key);

  @override
  State<EntityFormView> createState() => _EntityFormViewState();
}

class _EntityFormViewState extends State<EntityFormView> {
  final formKey = GlobalKey<FormState>();
  final controller = FormsController();

  final systemSection = SystemSection();
  final userSection = UserSection();
  final personalDataSection = PersonalDataSection();
  final addressSection = AddressSection();
  final contactSection = ContactSection();
  final projectSection = ProjectSection();
  final workflowOperationSection = WorkflowOperationSection();
  final descriptionSection = DescriptionSection();
  final operationSection = OperationSection();
  final associationSection = AssociationSection();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.setType(widget.type);
    _setSectionValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: WidgetStartDrawer(),
      endDrawer: WidgetEndDrawer(),
      backgroundColor: AppColor.colorPrimary,
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
              model: WidgetTitleHeaderModel(
                title: getTitle(),
                hasHeader: widget.hasHeader,
              ),
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
                    cards: getActionCards(),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppResponsive.instance.getHeight(24)),
            Expanded(
              child: Form(
                key: formKey,
                child: _buildEntityForm(),
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

  //* VALUE BUILDER *//

  void _setSectionValues() {
    switch (widget.type) {
      case EntityType.System:
        _setSectionValuesForSystem();
        break;
      case EntityType.User:
        _setSectionValuesForUser();
        break;
      case EntityType.Client:
        _setSectionValuesForClient();
        break;

      case EntityType.Project:
        _setSectionValuesForProject();
        break;

      case EntityType.Workflow:
        _setSectionValuesForWorkflow();
        break;

      case EntityType.Finance:
        _setSectionValuesForFinance();
        break;
      default:
        throw Exception("Tipo de entidade não suportado");
    }
  }

  void _setSectionValuesForSystem() {
    if (widget.entityIndex != null) {
      SystemLogicalModel existingModel = SystemController.instance.stream.value
          .getOne(id: widget.entityIndex)!;
      controller.setModel([existingModel]);
      systemSection.fianceDateController.text =
          existingModel.model?.financeReminderDate ?? "";
      systemSection.workflowDateController.text =
          existingModel.model?.workflowReminderDate ?? "";
    } else {
      SystemLogicalModel newModel = SystemLogicalModel(
        model: SystemDatabaseModel(
          financeReminderDate: systemSection.fianceDateController.text,
          workflowReminderDate: systemSection.workflowDateController.text,
        ),
      );
      controller.setModel([newModel]);
    }
  }

  void _setSectionValuesForUser() {
    if (widget.entityIndex != null) {
      UserLogicalModel existingModel =
          UserController.instance.stream.value.getOne(id: widget.entityIndex)!;
      controller.setModel([existingModel]);
      userSection.loginController.text = existingModel.model?.login ?? '';
      userSection.passwordController.text = existingModel.model?.password ?? '';
      userSection.recoverController.text =
          existingModel.recover?.model?.question ?? '';
      userSection.recoverRespController.text =
          existingModel.recover?.model?.response ?? '';
      personalDataSection.nameController.text =
          existingModel.personal?.model?.name ?? '';
      personalDataSection.documentController.text =
          existingModel.personal?.model?.document ?? '';
      personalDataSection.dobController.text =
          existingModel.personal?.model?.birth?.formatString() ?? '';
      personalDataSection.genderController.text =
          existingModel.personal?.model?.gender ?? '';
      contactSection.emailController.text =
          existingModel.personal?.model?.email ?? '';
      contactSection.phoneController.text =
          existingModel.personal?.model?.phone ?? '';
      addressSection.countryController.text =
          existingModel.personal?.address?.model?.country ?? '';
      addressSection.stateController.text =
          existingModel.personal?.address?.model?.state ?? '';
      addressSection.cityController.text =
          existingModel.personal?.address?.model?.city ?? '';
      addressSection.cepController.text =
          existingModel.personal?.address?.model?.postalCode ?? '';
      addressSection.streetController.text =
          existingModel.personal?.address?.model?.street ?? '';
      addressSection.numberController.text =
          existingModel.personal?.address?.model?.number ?? '';
      addressSection.complementController.text =
          existingModel.personal?.address?.model?.complement ?? '';
    } else {
      UserLogicalModel newModel = UserLogicalModel(
        model: UserDatabaseModel(
          type: 0,
          login: userSection.loginController.text,
          password: userSection.passwordController.text,
        ),
        recover: RecoverLogicalModel(
          model: RecoverDatabaseModel(
            question: userSection.recoverController.text,
            response: userSection.recoverRespController.text,
            code: personalDataSection.documentController.text,
          ),
        ),
        personal: PersonalLogicalModel(
          model: PersonalDatabaseModel(
            name: personalDataSection.nameController.text,
            document: personalDataSection.documentController.text,
            email: contactSection.emailController.text,
            phone: contactSection.phoneController.text,
            birth: personalDataSection.dobController.text.formatDatetime(),
            gender: personalDataSection.genderController.text,
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
      controller.setModel([newModel]);
    }
  }

  void _setSectionValuesForClient() {
    if (widget.entityIndex != null) {
      ClientLogicalModel existingModel = ClientController.instance.stream.value
          .getOne(id: widget.entityIndex)!;
      controller.setModel([existingModel]);
      personalDataSection.nameController.text =
          existingModel.personal?.model?.name ?? '';
      personalDataSection.documentController.text =
          existingModel.personal?.model?.document ?? '';
      personalDataSection.dobController.text =
          existingModel.personal?.model?.birth?.formatString() ?? '';
      personalDataSection.genderController.text =
          existingModel.personal?.model?.gender ?? '';
      personalDataSection.documentController.text =
          existingModel.personal?.model?.document ?? '';
      contactSection.emailController.text =
          existingModel.personal?.model?.email ?? '';
      contactSection.phoneController.text =
          existingModel.personal?.model?.phone ?? '';
      contactSection.noteController.text =
          existingModel.personal?.model?.annotation ?? '';
      addressSection.countryController.text =
          existingModel.personal?.address?.model?.country ?? '';
      addressSection.stateController.text =
          existingModel.personal?.address?.model?.state ?? '';
      addressSection.cityController.text =
          existingModel.personal?.address?.model?.city ?? '';
      addressSection.cepController.text =
          existingModel.personal?.address?.model?.postalCode ?? '';
      addressSection.streetController.text =
          existingModel.personal?.address?.model?.street ?? '';
      addressSection.numberController.text =
          existingModel.personal?.address?.model?.number ?? '';
      addressSection.complementController.text =
          existingModel.personal?.address?.model?.complement ?? '';
    } else {
      ClientLogicalModel newModel = ClientLogicalModel(
        personal: PersonalLogicalModel(
          model: PersonalDatabaseModel(
            name: personalDataSection.nameController.text,
            document: personalDataSection.documentController.text,
            email: contactSection.emailController.text,
            phone: contactSection.phoneController.text,
            annotation: contactSection.noteController.text,
            birth: personalDataSection.dobController.text.formatDatetime(),
            gender: personalDataSection.genderController.text,
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
      controller.setModel([newModel]);
    }
  }

  void _setSectionValuesForProject() {
    if (widget.entityIndex != null) {
      ProjectLogicalModel existingProjectModel = ProjectController
          .instance.stream.value
          .getOne(id: widget.entityIndex)!;

      WorkflowLogicalModel existingWorkflowModel;
      if ((existingProjectModel.model?.workflowId != null &&
          existingProjectModel.model?.workflowId != "")) {
        existingWorkflowModel = WorkflowController.instance.stream.value
            .getOne(id: existingProjectModel.model?.workflowId)!;
        existingWorkflowModel.model?.isCopy = true;
      } else {
        existingWorkflowModel = WorkflowLogicalModel(
          model: WorkflowDatabaseModel(
            name: descriptionSection.titleController.text,
            description: descriptionSection.descriptionController.text,
            isCopy: true,
          ),
          steps: [],
        );
      }

      projectSection.workflowController.text =
          existingWorkflowModel.model?.name ?? "";
      projectSection.titleController.text =
          existingProjectModel.model?.name ?? '';
      projectSection.descriptionController.text =
          existingProjectModel.model?.description ?? '';

      FinanceLogicalModel? existingFinanceModel = FinanceController
          .instance.stream.value
          .getOne(id: existingProjectModel.model?.financeId);
      ClientLogicalModel? existingClientModel = ClientController
          .instance.stream.value
          .getOne(id: existingProjectModel.model?.clientId);

      associationSection.financeController.text =
          existingFinanceModel?.model?.name ?? "";
      associationSection.clientController.text =
          existingClientModel?.personal?.model?.name ?? "";

      controller.setModel([existingProjectModel, existingWorkflowModel]);
    } else {
      ProjectLogicalModel newProjectModel = ProjectLogicalModel(
        model: ProjectDatabaseModel(
          name: projectSection.titleController.text,
          description: projectSection.descriptionController.text,
        ),
      );

      WorkflowLogicalModel newWorkflowModel = WorkflowLogicalModel(
        model: WorkflowDatabaseModel(
          name: descriptionSection.titleController.text,
          description: descriptionSection.descriptionController.text,
          isCopy: true,
        ),
        steps: [],
      );

      controller.setModel([newProjectModel, newWorkflowModel]);
    }
  }

  void _setSectionValuesForWorkflow() {
    if (widget.entityIndex != null) {
      WorkflowLogicalModel existingModel = WorkflowController
          .instance.stream.value
          .getOne(id: widget.entityIndex)!;
      controller.setModel([existingModel]);
      descriptionSection.titleController.text = existingModel.model?.name ?? '';
      descriptionSection.descriptionController.text =
          existingModel.model?.description ?? '';
    } else {
      WorkflowLogicalModel newModel = WorkflowLogicalModel(
        model: WorkflowDatabaseModel(
          name: descriptionSection.titleController.text,
          description: descriptionSection.descriptionController.text,
          isCopy: false,
        ),
        steps: [],
      );
      controller.setModel([newModel]);
    }
  }

  void _setSectionValuesForFinance() {
    if (widget.entityIndex != null) {
      FinanceLogicalModel existingModel = FinanceController
          .instance.stream.value
          .getOne(id: widget.entityIndex)!;
      controller.setModel([existingModel]);
      descriptionSection.titleController.text = existingModel.model?.name ?? '';
      descriptionSection.descriptionController.text =
          existingModel.model?.description ?? '';

      ProjectLogicalModel? existingProjectModel = ProjectController
          .instance.stream.value
          .getAll()
          .where(
              (element) => element?.model?.financeId == existingModel.model?.id)
          .firstOrNull;
      ClientLogicalModel? existingClientModel =
          ClientController.instance.stream.value.getOne(
              id: existingModel.model?.clientId ??
                  existingProjectModel?.model?.clientId);

      associationSection.projectController.text =
          existingProjectModel?.model?.name ?? "";
      associationSection.clientController.text =
          existingClientModel?.personal?.model?.name ?? "";
    } else {
      FinanceLogicalModel newModel = FinanceLogicalModel(
        model: FinanceDatabaseModel(
          name: descriptionSection.titleController.text,
          description: descriptionSection.descriptionController.text,
          status: FinanceDatabaseModel.statusMap[0],
        ),
        operations: [],
      );
      controller.setModel([newModel]);
    }
  }

  //* FORM BUILDER *//

  Widget _buildEntityForm() {
    switch (widget.type) {
      case EntityType.System:
        return _buildSystemForm();
      case EntityType.User:
        return _buildUserForm();
      case EntityType.Client:
        return _buildClientForm();
      case EntityType.Project:
        return _buildProjectForm();
      case EntityType.Workflow:
        return _buildWorkflowForm();
      case EntityType.Finance:
        return _buildFinanceForm();
      default:
        throw Exception("Tipo de entidade não suportado");
    }
  }

  Widget _buildSystemForm() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox.shrink(),
        ),
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Expanded(
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Configurações do Sistema",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: systemSection.fianceDateController,
                        headerText: systemSection.financeDateLabel,
                        hintText: systemSection.financeDateHint,
                        validator: (value) =>
                            systemSection.validateFinanceDate(value),
                        changed: (value) =>
                            (controller.getModel()[0] as SystemLogicalModel)
                                .model
                                ?.financeReminderDate = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: systemSection.workflowDateController,
                        headerText: systemSection.workflowDateLabel,
                        hintText: systemSection.workflowDateHint,
                        validator: (value) =>
                            systemSection.validateWorkflowDate(value),
                        changed: (value) =>
                            (controller.getModel()[0] as SystemLogicalModel)
                                .model
                                ?.workflowReminderDate = value!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Expanded(
          child: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildUserForm() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Dados de acesso",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: userSection.loginController,
                        headerText: userSection.loginLabel,
                        hintText: userSection.loginHint,
                        validator: (value) => userSection.validateLogin(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .model
                                ?.login = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: userSection.passwordController,
                        headerText: userSection.passwordLabel,
                        hintText: userSection.passwordHint,
                        validator: (value) =>
                            userSection.validatePassword(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .model
                                ?.password = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetSelectorField(
                      model: WidgetSelectorFieldModel(
                        controller: userSection.recoverController,
                        headerText: userSection.recoverLabel,
                        hintText: userSection.recoverHint,
                        validator: (value) =>
                            userSection.validateRecover(value),
                        options:
                            RecoverDatabaseModel.questionMap.values.toList(),
                        function: () =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .recover
                                ?.model
                                ?.question = userSection.recoverController.text,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: userSection.recoverRespController,
                        headerText: userSection.recoverRespLabel,
                        hintText: userSection.recoverRespHint,
                        validator: (value) =>
                            userSection.validateRecoverResp(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .recover
                                ?.model
                                ?.response = value,
                      ),
                    )
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
              label: "Dados Pessoais",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.nameController,
                        headerText: personalDataSection.nameLabel,
                        hintText: personalDataSection.nameHint,
                        validator: (value) =>
                            personalDataSection.validateName(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .personal
                                ?.model
                                ?.name = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.documentController,
                        headerText: personalDataSection.documentLabel,
                        hintText: personalDataSection.documentHint,
                        validator: (value) =>
                            personalDataSection.validateDocument(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .personal
                                ?.model
                                ?.document = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.dobController,
                        headerText: personalDataSection.dobLabel,
                        hintText: personalDataSection.dobHint,
                        validator: (value) =>
                            personalDataSection.validateDob(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .personal
                                ?.model
                                ?.birth = value?.formatDatetime(),
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.genderController,
                        headerText: personalDataSection.genderLabel,
                        hintText: personalDataSection.genderHint,
                        validator: (value) =>
                            personalDataSection.validateGender(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .personal
                                ?.model
                                ?.gender = value,
                      ),
                    )
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
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: contactSection.emailController,
                        headerText: contactSection.emailLabel,
                        hintText: contactSection.emailHint,
                        validator: (value) =>
                            contactSection.validateEmail(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .personal
                                ?.model
                                ?.email = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: contactSection.phoneController,
                        headerText: contactSection.phoneLabel,
                        hintText: contactSection.phoneHint,
                        validator: (value) =>
                            contactSection.validatePhone(value),
                        changed: (value) =>
                            (controller.getModel()[0] as UserLogicalModel)
                                .personal
                                ?.model
                                ?.phone = value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientForm() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Dados Pessoais",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.nameController,
                        headerText: personalDataSection.nameLabel,
                        hintText: personalDataSection.nameHint,
                        validator: (value) =>
                            personalDataSection.validateName(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.name = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.documentController,
                        headerText: personalDataSection.documentLabel,
                        hintText: personalDataSection.documentHint,
                        validator: (value) =>
                            personalDataSection.validateDocument(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.document = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.dobController,
                        headerText: personalDataSection.dobLabel,
                        hintText: personalDataSection.dobHint,
                        validator: (value) =>
                            personalDataSection.validateDob(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.birth = value?.formatDatetime(),
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: personalDataSection.genderController,
                        headerText: personalDataSection.genderLabel,
                        hintText: personalDataSection.genderHint,
                        validator: (value) =>
                            personalDataSection.validateGender(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.gender = value,
                      ),
                    )
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
              label: "Endereço",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.countryController,
                        headerText: addressSection.countryLabel,
                        hintText: addressSection.countryHint,
                        validator: (value) =>
                            addressSection.validateCountry(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.country = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.cepController,
                        headerText: addressSection.cepLabel,
                        hintText: addressSection.cepHint,
                        validator: (value) => addressSection.validateCep(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.postalCode = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.stateController,
                        headerText: addressSection.stateLabel,
                        hintText: addressSection.stateHint,
                        validator: (value) =>
                            addressSection.validateState(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.state = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.cityController,
                        headerText: addressSection.cityLabel,
                        hintText: addressSection.cityHint,
                        validator: (value) =>
                            addressSection.validateCity(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.city = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.streetController,
                        headerText: addressSection.streetLabel,
                        hintText: addressSection.streetHint,
                        validator: (value) =>
                            addressSection.validateStreet(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.street = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.numberController,
                        headerText: addressSection.numberLabel,
                        hintText: addressSection.numberHint,
                        validator: (value) =>
                            addressSection.validateNumber(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.number = value!,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: addressSection.complementController,
                        headerText: addressSection.complementLabel,
                        hintText: addressSection.complementHint,
                        validator: (value) =>
                            addressSection.validateComplement(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.address
                                ?.model
                                ?.complement = value,
                      ),
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
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: contactSection.emailController,
                        headerText: contactSection.emailLabel,
                        hintText: contactSection.emailHint,
                        validator: (value) =>
                            contactSection.validateEmail(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.email = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: contactSection.phoneController,
                        headerText: contactSection.phoneLabel,
                        hintText: contactSection.phoneHint,
                        validator: (value) =>
                            contactSection.validatePhone(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.phone = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: contactSection.noteController,
                        headerText: contactSection.noteLabel,
                        hintText: contactSection.noteHint,
                        validator: (value) =>
                            contactSection.validateNote(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ClientLogicalModel)
                                .personal
                                ?.model
                                ?.annotation = value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Expanded(
          flex: 1,
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Dados do Projeto",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: projectSection.titleController,
                        headerText: projectSection.titleLabel,
                        hintText: projectSection.titleHint,
                        validator: (value) =>
                            projectSection.validateTitle(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ProjectLogicalModel)
                                .model
                                ?.name = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: projectSection.descriptionController,
                        headerText: projectSection.descriptionLabel,
                        hintText: projectSection.descriptionHint,
                        validator: (value) =>
                            projectSection.validateDescription(value),
                        changed: (value) =>
                            (controller.getModel()[0] as ProjectLogicalModel)
                                .model
                                ?.description = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetSelectorField(
                      model: WidgetSelectorFieldModel(
                        controller: projectSection.workflowController,
                        headerText: projectSection.workflowLabel,
                        hintText: projectSection.workflowHint,
                        validator: (value) =>
                            projectSection.validateWorkflow(value),
                        options:
                            (projectSection.workflowController.text != "" &&
                                    widget.operation == EntityOperation.Update)
                                ? [projectSection.workflowController.text]
                                : WorkflowController.instance.stream.value
                                    .getAll(removeCopy: true)
                                    .map((e) => e!.model!.name!)
                                    .toList(),
                        function: () {
                          setState(() {
                            ProjectLogicalModel projectModel = (controller
                                .getModel()[0] as ProjectLogicalModel);

                            WorkflowLogicalModel? workflowModel =
                                WorkflowController.instance.stream.value.getOne(
                              name: projectSection.workflowController.text,
                            );
                            ClientLogicalModel? clientModel =
                                ClientController.instance.stream.value.getOne(
                              name: associationSection.clientController.text,
                            );
                            FinanceLogicalModel? financeModel =
                                FinanceController.instance.stream.value.getOne(
                              name: associationSection.financeController.text,
                            );

                            projectModel.model?.workflowId =
                                workflowModel?.model?.id;
                            projectModel.model?.clientId =
                                clientModel?.model?.id;
                            projectModel.model?.financeId =
                                financeModel?.model?.id;

                            controller.setModel([
                              projectModel,
                              workflowModel,
                            ]);
                          });
                        },
                        isDisabled:
                            (projectSection.workflowController.text != "" &&
                                    widget.operation == EntityOperation.Update)
                                ? true
                                : false,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetSelectorField(
                      model: WidgetSelectorFieldModel(
                        controller: associationSection.clientController,
                        headerText: associationSection.clientLabel,
                        hintText: associationSection.clientHint,
                        validator: (value) =>
                            associationSection.validateClient(value),
                        options:
                            (associationSection.clientController.text != "" &&
                                    widget.operation == EntityOperation.Update)
                                ? [associationSection.clientController.text]
                                : ClientController.instance.stream.value
                                    .getAll()
                                    .map((e) => e!.personal!.model!.name)
                                    .toList(),
                        function: () {
                          setState(() {
                            ProjectLogicalModel projectModel = (controller
                                .getModel()[0] as ProjectLogicalModel);

                            WorkflowLogicalModel? workflowModel =
                                WorkflowController.instance.stream.value.getOne(
                              name: projectSection.workflowController.text,
                            );
                            ClientLogicalModel? clientModel =
                                ClientController.instance.stream.value.getOne(
                              name: associationSection.clientController.text,
                            );
                            FinanceLogicalModel? financeModel =
                                FinanceController.instance.stream.value.getOne(
                              name: associationSection.financeController.text,
                            );

                            projectModel.model?.workflowId =
                                workflowModel?.model?.id;
                            projectModel.model?.clientId =
                                clientModel?.model?.id;
                            projectModel.model?.financeId =
                                financeModel?.model?.id;

                            controller.setModel([
                              projectModel,
                              workflowModel,
                            ]);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetSelectorField(
                      model: WidgetSelectorFieldModel(
                        controller: associationSection.financeController,
                        headerText: associationSection.financeLabel,
                        hintText: associationSection.financeHint,
                        validator: (value) =>
                            associationSection.validateFinance(value),
                        options:
                            (associationSection.financeController.text != "" &&
                                    widget.operation == EntityOperation.Update)
                                ? [associationSection.financeController.text]
                                : FinanceController.instance.stream.value
                                    .getAll()
                                    .map((e) => e!.model!.name!)
                                    .toList(),
                        function: () {
                          setState(() {
                            ProjectLogicalModel projectModel = (controller
                                .getModel()[0] as ProjectLogicalModel);

                            WorkflowLogicalModel? workflowModel =
                                WorkflowController.instance.stream.value.getOne(
                              name: projectSection.workflowController.text,
                            );
                            ClientLogicalModel? clientModel =
                                ClientController.instance.stream.value.getOne(
                              name: associationSection.clientController.text,
                            );
                            FinanceLogicalModel? financeModel =
                                FinanceController.instance.stream.value.getOne(
                              name: associationSection.financeController.text,
                            );

                            projectModel.model?.workflowId =
                                workflowModel?.model?.id;
                            projectModel.model?.clientId =
                                clientModel?.model?.id;
                            projectModel.model?.financeId =
                                financeModel?.model?.id;

                            controller.setModel([
                              projectModel,
                              workflowModel,
                            ]);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Expanded(
          flex: 2,
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Fluxo de trabalho",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (projectSection.workflowController.text != "") ...[
                    Flexible(
                      child: WidgetWorkflowBox(
                        model:
                            (controller.getModel()[1] as WorkflowLogicalModel),
                        operation: EntityOperation.Update,
                      ),
                    ),
                  ] else ...[
                    Text(
                      (WorkflowController.instance.stream.value
                                  .getAll(removeCopy: true)
                                  .length >
                              0)
                          ? "Selecione uma workflow"
                          : "Crie uma Workflow para prosseguir",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.size16(fontWeight: FontWeight.w300),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Expanded(
          flex: 1,
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Dados da Workflow",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetTextField(
                    model: WidgetTextFieldModel(
                      controller: descriptionSection.titleController,
                      headerText: descriptionSection.titleLabel,
                      hintText: descriptionSection.titleHint,
                      validator: (value) =>
                          descriptionSection.validateTitle(value),
                      changed: (value) =>
                          (controller.getModel()[0] as WorkflowLogicalModel)
                              .model
                              ?.name = value,
                    ),
                  ),
                  SizedBox(height: AppResponsive.instance.getHeight(24)),
                  WidgetTextField(
                    model: WidgetTextFieldModel(
                      controller: descriptionSection.descriptionController,
                      headerText: descriptionSection.descriptionLabel,
                      hintText: descriptionSection.descriptionHint,
                      validator: (value) =>
                          descriptionSection.validateDescription(value),
                      changed: (value) =>
                          (controller.getModel()[0] as WorkflowLogicalModel)
                              .model
                              ?.description = value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppResponsive.instance.getWidth(24),
        ),
        Expanded(
          flex: 2,
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Fluxo de trabalho",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: WidgetWorkflowBox(
                      model: controller.getModel()[0],
                      operation: widget.operation,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: AppResponsive.instance.getWidth(24)),
        Expanded(
          flex: 1,
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Dados da finança",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: descriptionSection.titleController,
                        headerText: descriptionSection.titleLabel,
                        hintText: descriptionSection.titleHint,
                        validator: (value) =>
                            descriptionSection.validateTitle(value),
                        changed: (value) =>
                            (controller.getModel()[0] as FinanceLogicalModel)
                                .model
                                ?.name = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetTextField(
                      model: WidgetTextFieldModel(
                        controller: descriptionSection.descriptionController,
                        headerText: descriptionSection.descriptionLabel,
                        hintText: descriptionSection.descriptionHint,
                        validator: (value) =>
                            descriptionSection.validateDescription(value),
                        changed: (value) =>
                            (controller.getModel()[0] as FinanceLogicalModel)
                                .model
                                ?.description = value,
                      ),
                    ),
                    SizedBox(height: AppResponsive.instance.getHeight(24)),
                    WidgetSelectorField(
                      model: WidgetSelectorFieldModel(
                        controller: associationSection.clientController,
                        headerText: associationSection.clientLabel,
                        hintText: associationSection.clientHint,
                        validator: (value) =>
                            associationSection.validateClient(value),
                        options: ClientController.instance.stream.value
                            .getAll()
                            .map((e) => e!.personal!.model!.name)
                            .toList(),
                        function: () {
                          setState(() {
                            FinanceLogicalModel financeModel = (controller
                                .getModel()[0] as FinanceLogicalModel);

                            ClientLogicalModel? clientModel =
                                ClientController.instance.stream.value.getOne(
                              name: associationSection.clientController.text,
                            );
                            ProjectLogicalModel? projectModel =
                                ProjectController.instance.stream.value.getOne(
                              name: associationSection.financeController.text,
                            );

                            financeModel.model?.clientId =
                                clientModel?.model?.id;
                            projectModel?.model?.financeId =
                                financeModel.model?.id;

                            controller.setModel([financeModel]);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: AppResponsive.instance.getWidth(24),
        ),
        Expanded(
          flex: 2,
          child: WidgetFloatingBox(
            model: WidgetFloatingBoxModel(
              label: "Dados Financeiros",
              padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: WidgetFinanceBox(
                      model: controller.getModel()[0],
                      operation: widget.operation,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //* UTILITÁRIOS *//

  String getTitle() {
    switch (widget.type) {
      case EntityType.System:
        return "Sistema";
      case EntityType.User:
        return "Usuário";
      case EntityType.Client:
        return "Cliente";
      case EntityType.Project:
        return "Projeto";
      case EntityType.Workflow:
        return "Workflow";
      case EntityType.Finance:
        return "Finanças";
      default:
        throw Exception("Tipo de entidade não suportado");
    }
  }

  String getActionHeaderText() {
    String operationText;
    switch (widget.operation) {
      case EntityOperation.Create:
        operationText = "Cadastrar";
        break;
      case EntityOperation.Read:
        operationText = "Ler";
        break;
      case EntityOperation.Update:
        operationText = "Atualizar";
        break;
      case EntityOperation.Delete:
        operationText = "Deletar";
        break;
      default:
        throw Exception("Operação não suportada");
    }
    return "$operationText ${getTitle()}";
  }

  List<WidgetActionIcon> getActionCards() {
    List<WidgetActionIcon> cards = [];
    switch (widget.operation) {
      case EntityOperation.Create:
        cards = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: getActionIcon(operation: EntityOperation.Create),
              label: getActionText(operation: EntityOperation.Create),
              function: () async {
                await handleAction(operation: EntityOperation.Create);
              },
            ),
          ),
        ];
      case EntityOperation.Read:
        break;
      case EntityOperation.Update:
        cards = [
          WidgetActionIcon(
            model: WidgetActionIconModel(
              icon: getActionIcon(operation: EntityOperation.Update),
              label: getActionText(operation: EntityOperation.Update),
              function: () async {
                await handleAction(operation: EntityOperation.Update);
              },
            ),
          ),
          if (widget.type != EntityType.User &&
              widget.type != EntityType.System) ...[
            WidgetActionIcon(
              model: WidgetActionIconModel(
                icon: getActionIcon(operation: EntityOperation.Delete),
                label: getActionText(operation: EntityOperation.Delete),
                function: () async {
                  await handleAction(operation: EntityOperation.Delete);
                },
              ),
            ),
          ],
        ];
      case EntityOperation.Delete:
        break;
      default:
        throw Exception("Operação não suportada");
    }
    return cards;
  }

  String getActionText({required EntityOperation operation}) {
    switch (operation) {
      case EntityOperation.Create:
        return "Cadastrar";
      case EntityOperation.Read:
        return "Ler";
      case EntityOperation.Update:
        return "Atualizar";
      case EntityOperation.Delete:
        return "Deletar";
      default:
        throw Exception("Operação não suportada");
    }
  }

  IconData getActionIcon({required EntityOperation operation}) {
    switch (operation) {
      case EntityOperation.Create:
        return Icons.add;
      case EntityOperation.Read:
        return Icons.read_more;
      case EntityOperation.Update:
        return Icons.update;
      case EntityOperation.Delete:
        return Icons.delete;
      default:
        throw Exception("Operação não suportada");
    }
  }

  Future<void> handleAction({required EntityOperation operation}) async {
    try {
      bool isFormValid = formKey.currentState?.validate() ?? false;
      bool controllerResult = false;

      switch (operation) {
        case EntityOperation.Create:
          if (isFormValid) controllerResult = await controller.createEntity();
          break;
        case EntityOperation.Read:
          break;
        case EntityOperation.Update:
          if (isFormValid) controllerResult = await controller.updateEntity();
          break;
        case EntityOperation.Delete:
          controllerResult = await controller.deleteEntity();
          break;
      }

      if (controllerResult) {
        AppFeedback(
          text: "Sucesso ao ${getActionHeaderText()}",
          color: AppColor.colorPositiveStatus,
        ).showSnackbar(context);

        if (operation == EntityOperation.Delete) {
          Navigator.of(context).popUntil(
            ModalRoute.withName("/home_view"),
          );
        } else {
          Navigator.pop(context);
        }
      } else {
        AppFeedback(
          text: "Erro ao ${getActionHeaderText()}",
          color: AppColor.colorNegativeStatus,
        ).showSnackbar(context);
      }
    } catch (error) {
      log(error.toString());
    }
  }
}
