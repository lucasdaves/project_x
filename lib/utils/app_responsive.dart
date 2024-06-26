import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_x/utils/app_enum.dart';
import 'dart:io';

class AppResponsive {
  static final AppResponsive instance = AppResponsive._();
  AppResponsive._();

  static const double orientationThreshold = 1.7;

  DeviceSpec? realDevice;
  List<DeviceSpec> targetDevices = [
    DeviceSpec(ScreenOrientation.Landscape, 720, 1280),
    DeviceSpec(ScreenOrientation.Portrait, 932, 430),
  ];

  //* SPEC MANIPULATION *//

  void addRealSpec(double height, double width) {
    ScreenOrientation type;
    if (Platform.isAndroid || Platform.isIOS) {
      type = ScreenOrientation.Portrait;
    } else if (Platform.isWindows) {
      type = ScreenOrientation.Landscape;
    } else {
      throw "Unsuported Platform";
    }
    realDevice = (DeviceSpec(type, height, width));
  }

  void updateRealSpec(double height, double width) {
    realDevice?.deviceHeight = height;
    realDevice?.deviceWidth = width;
    realDevice?.type = isLandscape()
        ? ScreenOrientation.Landscape
        : ScreenOrientation.Portrait;
  }

  bool isLandscape() {
    return AppResponsive.instance.getDeviceAspect() > orientationThreshold;
  }

  Future<void> setOrientations() async {
    List<DeviceOrientation> orientations = [];
    if (Platform.isAndroid || Platform.isIOS) {
      orientations.addAll([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else if (Platform.isWindows) {
      orientations.addAll([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
    await SystemChrome.setPreferredOrientations(orientations);
  }

  setGestures() {
    if (Platform.isAndroid || Platform.isIOS) {
      return null;
    } else if (Platform.isWindows) {
      return const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      );
    }
  }

  //* COMPONENT SIZE *//

  DeviceSpec getDeviceSpec() {
    return targetDevices.firstWhere((spec) => spec.type == realDevice!.type);
  }

  double getWidth(double value) {
    DeviceSpec targetDevice = getDeviceSpec();
    double targetProportion = value / targetDevice.deviceWidth;
    double realProportion = targetProportion * realDevice!.deviceWidth;
    return realProportion;
  }

  double getHeight(double value) {
    DeviceSpec targetDevice = getDeviceSpec();
    double targetProportion = value / targetDevice.deviceHeight;
    double realProportion = targetProportion * realDevice!.deviceHeight;
    return realProportion;
  }

  //* DEVICE SIZE *//

  double getDeviceWidth() {
    return realDevice!.deviceWidth;
  }

  double getDeviceHeight() {
    return realDevice!.deviceHeight;
  }

  double getDeviceAspect() {
    return realDevice!.deviceWidth / realDevice!.deviceHeight;
  }
}

class DeviceSpec {
  ScreenOrientation type;
  double deviceHeight;
  double deviceWidth;

  DeviceSpec(this.type, this.deviceHeight, this.deviceWidth);
}
