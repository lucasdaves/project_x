import 'dart:developer';
import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/client_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class FormsController {
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
        case EntityType.System:
          result = await SystemController.instance.createSystem(
            model: stream.value.model[0],
          );
          break;
        case EntityType.User:
          result = await UserController.instance.createUser(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Client:
          result = await ClientController.instance.createClient(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Project:
          result = await ProjectController.instance.createProject(
            projectModel: stream.value.model[0],
            workflowModel: stream.value.model[1],
          );
          break;
        case EntityType.Finance:
          result = await FinanceController.instance.createFinance(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Workflow:
          result = await WorkflowController.instance.createWorkflow(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Association:
          result = await AssociationController.instance.createAssociation(
            model: stream.value.model[0],
          );
          break;
        default:
          break;
      }
    } catch (error) {
      log(error.toString());
      result = false;
    }
    return result;
  }

  Future<bool> updateEntity() async {
    bool result = false;
    try {
      switch (stream.value.type!) {
        case EntityType.System:
          result = await SystemController.instance.updateSystem(
            model: stream.value.model[0],
          );
          break;
        case EntityType.User:
          result = await UserController.instance.updateUser(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Client:
          result = await ClientController.instance.updateClient(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Project:
          result = await ProjectController.instance.updateProject(
            projectModel: stream.value.model[0],
            workflowModel: stream.value.model[1],
          );
          break;
        case EntityType.Finance:
          result = await FinanceController.instance.updateFinance(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Workflow:
          result = await WorkflowController.instance.updateWorkflow(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Association:
          result = await AssociationController.instance.updateAssociation(
            model: stream.value.model[0],
          );
          break;
        default:
          break;
      }
    } catch (error) {
      log(error.toString());
      result = false;
    }
    return result;
  }

  Future<bool> deleteEntity() async {
    bool result = false;
    try {
      switch (stream.value.type!) {
        case EntityType.User:
          result = await UserController.instance.deleteUser(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Client:
          result = await ClientController.instance.deleteClient(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Project:
          result = await ProjectController.instance.deleteProject(
            projectModel: stream.value.model[0],
            workflowModel: stream.value.model[1],
          );
          break;
        case EntityType.Finance:
          result = await FinanceController.instance.deleteFinance(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Workflow:
          result = await WorkflowController.instance.deleteWorkflow(
            model: stream.value.model[0],
          );
          break;
        case EntityType.Association:
          result = await AssociationController.instance.deleteAssociation(
            model: stream.value.model[0],
          );
          break;
        default:
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
