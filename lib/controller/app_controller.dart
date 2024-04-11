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
import 'package:project_x/services/memory/memory_service.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:window_manager/window_manager.dart';

class AppController {
  static final AppController instance = AppController._();
  AppController._();

  //* DATABASE INSTANCES *//

  final responsive = AppResponsive.instance;
  final service = DatabaseService.instance;

  //* METHODS *//

  void dispose() {
    WidgetsFlutterBinding.ensureInitialized();
    AssociationController.instance.dispose();
    ClientController.instance.dispose();
    FinanceController.instance.dispose();
    ProjectController.instance.dispose();
    SystemController.instance.dispose();
    UserController.instance.dispose();
    WorkflowController.instance.dispose();
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
    await AppResponsive.instance.setOrientations();
    await DatabaseService.instance.initDatabase();
    //await clearAppConfigs();
  }

  Future<void> clearAppConfigs() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DatabaseService.instance.clearDatabase();
    await MemoryService.instance.clearMemory();
  }

  void changeDeviceSize() {
    final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    Size screenSize = data.size;
    AppResponsive.instance.updateRealSpec(screenSize.height, screenSize.width);
  }
}
