import 'package:flutter/material.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_feedback.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/view/forms/form_view.dart';
import 'package:project_x/view/forms/sections/widget_entity_sections.dart';
import 'package:project_x/view/load/load_view.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/buttons/widget_solid_button.dart';
import 'package:project_x/view/widgets/fields/widget_selectorfield.dart';
import 'package:project_x/view/widgets/fields/widget_textfield.dart';

class RecoverView extends StatefulWidget {
  static const String tag = "/recover_view";
  const RecoverView({super.key});

  @override
  State<RecoverView> createState() => _RecoverViewState();
}

class _RecoverViewState extends State<RecoverView> {
  final userSection = UserSection();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      backgroundColor: AppColor.colorPrimary,
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return WidgetAppBar();
  }

  Widget _buildBody() {
    return AppLayout(
      landscape: _buildLandscape(context),
      portrait: _buildPortrait(context),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    Widget buildLoginTextField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: userSection.loginController,
        headerText: userSection.loginLabel,
        hintText: userSection.loginHint,
        validator: (value) => userSection.validateLogin(value),
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildRecoverField() {
      WidgetSelectorFieldModel model = WidgetSelectorFieldModel(
        controller: userSection.recoverController,
        headerText: userSection.recoverLabel,
        hintText: userSection.recoverHint,
        validator: (value) => userSection.validateRecover(value),
        options: RecoverDatabaseModel.questionMap.values.toList(),
      );
      return WidgetSelectorField(
        model: model,
      );
    }

    Widget buildRecoverRespField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: userSection.recoverRespController,
        headerText: userSection.recoverRespLabel,
        hintText: userSection.recoverRespHint,
        validator: (value) => userSection.validateRecoverResp(value),
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildRecoverButton(bool loading) {
      WidgetSolidButtonModel model = WidgetSolidButtonModel(
        label: "Recuperar",
        loading: loading,
        function: () async {
          await functionLogin();
        },
      );
      return WidgetSolidButton(
        model: model,
      );
    }

    return WidgetContainBox(
      model: WidgetContainModelBox(
        height: double.maxFinite,
        width: 300,
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: WidgetFloatingBox(
                  model: WidgetFloatingBoxModel(
                    label: "Project X",
                    padding:
                        EdgeInsets.all(AppResponsive.instance.getWidth(24)),
                    widget: SingleChildScrollView(
                      child: StreamBuilder<Object>(
                        stream: UserController.instance.stream,
                        builder: (context, snapshot) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.chevron_left_rounded,
                                        color: AppColor.colorSecondary,
                                        size:
                                            AppResponsive.instance.getWidth(32),
                                      ),
                                    ),
                                    SizedBox(
                                        width: AppResponsive.instance
                                            .getWidth(12)),
                                    Text(
                                      "Recuperar conta",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColor.text_1,
                                        fontSize:
                                            AppResponsive.instance.getWidth(16),
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildLoginTextField(),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildRecoverField(),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(24)),
                                buildRecoverRespField(),
                                SizedBox(
                                    height:
                                        AppResponsive.instance.getHeight(36)),
                                buildRecoverButton(
                                  UserController.instance.stream.value.status ==
                                      EntityStatus.Loading,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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

  Future<void> functionLogin() async {
    FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      try {
        bool success = await UserController.instance.recoverUser(
          login: userSection.loginController.text,
          recover: userSection.recoverController.text,
          recoverResp: userSection.recoverRespController.text,
        );

        if (success) {
          AppFeedback(
            text: 'Conta recuperada - Senha alterada para 1234',
            color: AppColor.colorPositiveStatus,
          ).showSnackbar(context);
          AppRoute(
            tag: LoadView.tag,
            screen: LoadView(),
          ).navigate(context);
        } else {
          AppFeedback(
            text: 'Credênciais de recuperação erradas!',
            color: AppColor.colorNegativeStatus,
          ).showSnackbar(context);
        }
      } catch (error) {
        print("Erro durante a recuperação: $error");
      }
    }
  }

  Future<void> functionRecover() async {
    try {} catch (error) {
      print("Erro durante o login: $error");
    }
  }

  Future<void> functionRegister() async {
    try {
      AppRoute(
        tag: EntityFormView.tag,
        screen: EntityFormView(
          type: EntityType.User,
          operation: EntityOperation.Create,
          hasHeader: false,
        ),
      ).navigate(context);
    } catch (error) {
      print("Erro durante o login: $error");
    }
  }
}
