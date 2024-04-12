import 'package:flutter/material.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_feedback.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/create/create_controller.dart';
import 'package:project_x/view/home/home_view.dart';
import 'package:project_x/view/widgets/actions/widget_action_back.dart';
import 'package:project_x/view/widgets/actions/widget_action_card.dart';
import 'package:project_x/view/widgets/actions/widget_action_icon.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/forms/widget_entity_form.dart';
import 'package:project_x/view/widgets/header/widget_action_header.dart';
import 'package:project_x/view/widgets/header/widget_title_header.dart';

class CreateView extends StatefulWidget {
  static const String tag = "/create_view";

  final EntityType type;

  const CreateView({super.key, required this.type});

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  CreateController controller = CreateController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.setType(widget.type);
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
              model: WidgetTitleHeaderModel(title: _getTitle()),
            ),
            SizedBox(height: AppResponsive.instance.getHeight(24)),
            WidgetActionHeader(
              model: WidgetActionHeaderModel(
                backAction: WidgetActionBack(
                  model: WidgetActionBackModel(
                    icon: Icons.chevron_left_rounded,
                    label: _getActionTitle(),
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
                          icon: Icons.add,
                          label: "Cadastrar",
                          function: () {
                            _createFunction();
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
              child: WidgetEntityForm(
                controller: controller,
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

  Future<void> _createFunction() async {
    if (controller.getValidator()()) {
      if (await controller.createEntity()) {
        AppFeedback(
          text: "Sucesso ao cadastrar",
          color: AppColor.colorPositiveStatus,
        ).showTopSnackBar(context);
        Navigator.popUntil(
          context,
          ModalRoute.withName(HomeView.tag),
        );
      } else {
        AppFeedback(
          text: "Erro ao cadastrar",
          color: AppColor.colorNegativeStatus,
        ).showTopSnackBar(context);
      }
    } else {}
  }

  String _getTitle() {
    String title = "";
    switch (controller.stream.value.type!) {
      case EntityType.User:
        title = "Usuário";
      case EntityType.Client:
        title = "Clientes";
      case EntityType.Project:
        title = "Projetos";
      case EntityType.Finance:
        title = "Finanças";
      case EntityType.Workflow:
        title = "Workflows";
    }
    return title;
  }

  String _getActionTitle() {
    String action = "";
    switch (controller.stream.value.type!) {
      case EntityType.User:
        action = "Cadastro de Usuário";
      case EntityType.Client:
        action = "Cadastro de Clientes";
      case EntityType.Project:
        action = "Cadastro de Projetos";
      case EntityType.Finance:
        action = "Cadastro de Finanças";
      case EntityType.Workflow:
        action = "Cadastro de Workflows";
    }
    return action;
  }
}
