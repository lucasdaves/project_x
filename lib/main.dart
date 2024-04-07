import 'package:flutter/material.dart';
import 'package:project_x/controller/app_controller.dart';
import 'package:project_x/view/splash/splash_view.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await AppController.instance.initAppConfigs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          AppController.instance.changeDeviceSize();
          return SplashView();
        },
      ),
    );
  }

  @override
  void onWindowResize() {
    if (mounted) {
      setState(() {
        AppController.instance.changeDeviceSize();
      });
    }
  }
}
