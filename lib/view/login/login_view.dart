import 'package:flutter/material.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/user_controller_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/view/home/home_view.dart';
import 'package:project_x/view/widgets/buttons/widget_text_button.dart';
import 'package:project_x/view/widgets/header/widget_app_bar.dart';
import 'package:project_x/view/widgets/buttons/widget_solid_button.dart';
import 'package:project_x/view/widgets/textfield/widget_textfield.dart';

class LoginView extends StatefulWidget {
  static const String tag = "/login_view";
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      backgroundColor: AppColor.colorPrimary,
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return CustomAppBar();
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
        controller: loginController,
        headerText: "Conta",
        hintText: "Digite sua conta ...",
        feedbackText: "Preencha um login valido ...",
        validator: (value) {
          return (value != null && value.isNotEmpty);
        },
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildPasswordTextField() {
      WidgetTextFieldModel model = WidgetTextFieldModel(
        controller: passwordController,
        headerText: "Senha",
        hintText: "Digite sua senha ...",
        feedbackText: "Preencha uma senha valida ...",
        validator: (value) {
          return (value != null && value.isNotEmpty);
        },
      );
      return WidgetTextField(
        model: model,
      );
    }

    Widget buildLoginButton(bool loading) {
      WidgetSolidButtonModel model = WidgetSolidButtonModel(
        label: "Entrar",
        loading: loading,
        function: () async {
          FormState? form = _formKey.currentState;
          if (form != null && form.validate()) {
            try {
              bool success = await UserController.instance.setLogin(
                login: loginController.text,
                password: passwordController.text,
              );

              if (success) {
                AppRoute(
                  tag: HomeView.tag,
                  screen: HomeView(),
                ).navigate(context);
              }
            } catch (e) {
              print("Erro durante o login: $e");
            }
          }
        },
      );
      return WidgetSolidButton(
        model: model,
      );
    }

    Widget buildRecoverButton() {
      WidgetTextButtonModel model = WidgetTextButtonModel(
        label: "Recuperar a conta",
        labelColor: AppColor.colorNeutralStatus,
        function: () {},
      );
      return Center(
        child: WidgetTextButton(
          model: model,
        ),
      );
    }

    Widget buildRegisterButton() {
      WidgetTextButtonModel model = WidgetTextButtonModel(
        preLabel: "Não possuí conta ?",
        label: "Cadastre-se",
        labelColor: AppColor.colorSecondary,
        function: () {},
      );
      return Center(
        child: WidgetTextButton(
          model: model,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<Object>(
            stream: UserController.instance.userStream,
            builder: (context, snapshot) {
              return Container(
                width: AppResponsive.instance.getWidth(300),
                height: AppResponsive.instance.getHeight(530),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ProjectX",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.text_1,
                        fontSize: AppResponsive.instance.getWidth(24),
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      height: AppResponsive.instance.getHeight(16),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppResponsive.instance.getHeight(24),
                          vertical: AppResponsive.instance.getWidth(24),
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.colorFloating,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.text_1,
                                  fontSize: AppResponsive.instance.getWidth(16),
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                ),
                              ),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildLoginTextField(),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildPasswordTextField(),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(36)),
                              buildLoginButton(
                                UserController
                                        .instance.userStream.value.status ==
                                    EntityStatus.Loading,
                              ),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildRecoverButton(),
                              SizedBox(
                                  height: AppResponsive.instance.getHeight(24)),
                              buildRegisterButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }
}
