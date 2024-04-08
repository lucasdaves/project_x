import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:window_manager/window_manager.dart';

class AppController {
  static final AppController instance = AppController._();
  AppController._();

  //* DATABASE INSTANCES *//

  final responsive = AppResponsive.instance;
  final service = DatabaseService.instance;

  //* CONTROLLER INSTANCES *//

  //* METHODS *//

  void dispose() {
    WidgetsFlutterBinding.ensureInitialized();

    final associationController = AssociationController.instance;
    final clientController = ClientController.instance;
    final financeController = FinanceController.instance;
    final projectController = ProjectController.instance;
    final systemController = SystemController.instance;
    final userController = UserController.instance;
    final workflowController = WorkflowController.instance;

    associationController.dispose();
    clientController.dispose();
    financeController.dispose();
    projectController.dispose();
    systemController.dispose();
    userController.dispose();
    workflowController.dispose();
  }

  Future<void> initAppConfigs() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        size: Size(960, 540),
        minimumSize: Size(960, 540),
        title: 'Project X',
        center: true,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
      windowManager.setAspectRatio(16 / 9);
    }
    final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    Size screenSize = data.size;
    AppResponsive.instance.addRealSpec(screenSize.height, screenSize.width);
    await DatabaseService.instance.initDatabase();
    //await DatabaseService.instance.clearDatabase();
  }

  void changeDeviceSize() {
    final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    Size screenSize = data.size;
    AppResponsive.instance.updateRealSpec(screenSize.height, screenSize.width);
  }
}
