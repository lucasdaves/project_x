import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_x/controller/app_controller.dart';
import 'package:project_x/utils/app_color.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:project_x/view/splash/splash_view.dart';
// import 'package:project_x/view/widgets/transitions/widget_no_transition.dart';

void main() async {
  await AppController.instance.initAppConfigs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    AppController.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project X',
      theme: ThemeData(
        fontFamily: 'Mulish',
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
        dialogBackgroundColor: AppColor.colorFieldBackground,
        dialogTheme: const DialogTheme(
          backgroundColor: AppColor.colorFieldBackground,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      scrollBehavior: AppResponsive.instance.setGestures(),
      builder: (context, child) {
        AppController.instance.changeDeviceSize();
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.0,
        );
        return MediaQuery(
          key: UniqueKey(),
          data: mediaQueryData.copyWith(textScaler: scale),
          child: child!,
        );
      },
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
