import 'dart:developer';

import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class CreateController {
  final stream = BehaviorSubject<CreateModel>.seeded(CreateModel());

  void dispose() {
    stream.close();
  }

  void setType(EntityType value) {
    stream.value.type = value;
    stream.sink.add(stream.value);
  }

  dynamic getType() {
    return stream.valueOrNull?.type;
  }

  void setModel(dynamic value) {
    stream.valueOrNull?.model = value;
    stream.sink.add(stream.value);
  }

  dynamic getModel() {
    return stream.valueOrNull?.model;
  }

  void setValidator(Function()? value) {
    stream.valueOrNull?.validator = value;
    stream.sink.add(stream.value);
  }

  dynamic getValidator() {
    return stream.valueOrNull?.validator;
  }

  Future<bool> createEntity() async {
    bool result = false;
    try {
      switch (stream.value.type!) {
        case EntityType.User:
          break;
        case EntityType.Client:
          result = await ClientController.instance.createClient(
            model: stream.value.model,
          );
          break;
        case EntityType.Project:
          break;
        case EntityType.Finance:
          break;
        case EntityType.Workflow:
          break;
      }
    } catch (error) {
      log(error.toString());
      result = false;
    }
    return result;
  }
}

class CreateModel {
  EntityType? type;
  dynamic model;
  Function()? validator;

  CreateModel({
    this.type,
    this.model,
    this.validator,
  });
}
