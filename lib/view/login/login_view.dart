import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/widgets/widget_app_bar.dart';
import 'package:project_x/view/widgets/widget_textfield.dart';

class LoginView extends StatefulWidget {
  static const String tag = "/login_view";
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      );
      return WidgetTextField(
        model: model,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
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
                      SizedBox(height: AppResponsive.instance.getHeight(24)),
                      buildLoginTextField(),
                      SizedBox(height: AppResponsive.instance.getHeight(24)),
                      buildPasswordTextField(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }
}
