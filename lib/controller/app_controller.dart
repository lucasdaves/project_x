import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:window_manager/window_manager.dart';

class AppController {
  static final AppController instance = AppController._();
  AppController._();

  //* DATABASE INSTANCES *//

  final responsive = AppResponsive.instance;
  final service = DatabaseService.instance;

  //* METHODS *//

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
  }

  void changeDeviceSize() {
    //Size screenSize = PlatformDispatcher.instance.views.first.physicalSize;
    final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    Size screenSize = data.size;
    AppResponsive.instance.updateRealSpec(screenSize.height, screenSize.width);
  }
}
