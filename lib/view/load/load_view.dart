import 'package:flutter/material.dart';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_layout.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/utils/app_route.dart';
import 'package:project_x/utils/app_text_style.dart';
import 'package:project_x/view/home/home_view.dart';
import 'package:project_x/view/widgets/box/widget_contain_box.dart';
import 'package:project_x/view/widgets/box/widget_floating_box.dart';
import 'package:project_x/view/widgets/appbar/widget_app_bar.dart';
import 'package:project_x/view/widgets/fields/widget_checkbox.dart';
import 'package:project_x/view/widgets/loader/widget_circular_loader.dart';

class LoadView extends StatefulWidget {
  static const String tag = "/load_view";
  const LoadView({super.key});

  @override
  State<LoadView> createState() => _LoadViewState();
}

class _LoadViewState extends State<LoadView> {
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
    return WidgetContainBox(
      model: WidgetContainModelBox(
        height: double.maxFinite,
        width: 360,
        widget: _buildStreamContent(),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Container();
  }

  Widget _buildStreamContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WidgetFloatingBox(
          model: WidgetFloatingBoxModel(
            label: "Project X",
            padding: EdgeInsets.all(AppResponsive.instance.getWidth(24)),
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Carregando informações",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.size16(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: AppResponsive.instance.getHeight(36)),
                _buildUserStatus(),
                SizedBox(height: AppResponsive.instance.getHeight(12)),
                _buildClientStatus(),
                SizedBox(height: AppResponsive.instance.getHeight(12)),
                _buildProjectStatus(),
                SizedBox(height: AppResponsive.instance.getHeight(12)),
                _buildFinanceStatus(),
                SizedBox(height: AppResponsive.instance.getHeight(12)),
                _buildWorkflowStatus(),
                SizedBox(height: AppResponsive.instance.getHeight(12)),
                _buildAssociationStatus(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserStatus() {
    return StreamBuilder(
      stream: UserController.instance.stream,
      builder: (context, snapshot) {
        return _buildStatusRow(
          title: "Carregando dados do usuário",
          status: snapshot.data?.status,
        );
      },
    );
  }

  Widget _buildClientStatus() {
    return StreamBuilder(
      stream: ClientController.instance.stream,
      builder: (context, snapshot) {
        return _buildStatusRow(
          title: "Carregando clientes",
          status: snapshot.data?.status,
        );
      },
    );
  }

  Widget _buildProjectStatus() {
    return StreamBuilder(
      stream: ProjectController.instance.stream,
      builder: (context, snapshot) {
        return _buildStatusRow(
          title: "Carregando projetos",
          status: snapshot.data?.status,
        );
      },
    );
  }

  Widget _buildFinanceStatus() {
    return StreamBuilder(
      stream: FinanceController.instance.stream,
      builder: (context, snapshot) {
        return _buildStatusRow(
          title: "Carregando financeiros",
          status: snapshot.data?.status,
        );
      },
    );
  }

  Widget _buildWorkflowStatus() {
    return StreamBuilder(
      stream: WorkflowController.instance.stream,
      builder: (context, snapshot) {
        return _buildStatusRow(
          title: "Carregando workflows",
          status: snapshot.data?.status,
        );
      },
    );
  }

  Widget _buildAssociationStatus() {
    return StreamBuilder(
      stream: AssociationController.instance.stream,
      builder: (context, snapshot) {
        return _buildStatusRow(
          title: "Carregando associações",
          status: snapshot.data?.status,
        );
      },
    );
  }

  Widget _buildStatusRow({required String title, EntityStatus? status}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.size12(fontWeight: FontWeight.w200),
        ),
        (status == EntityStatus.Loading)
            ? WidgetCircularLoader(
                model: WidgetCircularLoaderModel(
                  size: 14,
                  color: AppColor.colorSecondary,
                ),
              )
            : WidgetCheckBox(
                model: WidgetCheckBoxModel(
                  size: 20,
                  color: AppColor.colorPositiveStatus,
                  checked: true,
                ),
              )
      ],
    );
  }

  Future<void> _onAllStreamsLoaded() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    AppRoute(
      tag: HomeView.tag,
      screen: HomeView(),
    ).navigate(context);
  }

  @override
  void initState() {
    super.initState();
    Future.wait([
      UserController.instance.readUser(),
      ClientController.instance.readClient(),
      ProjectController.instance.readProject(),
      FinanceController.instance.readFinance(),
      WorkflowController.instance.readWorkflow(),
      AssociationController.instance.readAssociation(),
    ]).then((_) {
      _onAllStreamsLoaded();
    });
  }
}
