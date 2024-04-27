import 'dart:developer';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/controller/project_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/model/system_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/system_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_responsive.dart';
import 'package:rxdart/rxdart.dart';

class SystemController {
  static final SystemController instance = SystemController._();
  SystemController._();

  //* APP INSTANCES *//

  final responsive = AppResponsive.instance;

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final stream = BehaviorSubject<SystemStreamModel>();

  //* DISPOSE *//

  void dispose() {
    stream.close();
  }

  //* METHODS *//

  Future<bool> createSystem({required SystemLogicalModel model}) async {
    try {
      if (model.model?.userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do sistema é nulo";

      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = model.model?.userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.system, args: argsA);

      if (mapA != null && mapA.isNotEmpty) {
        throw "Sistema já criado para usuário";
      }

      int? mapB =
          await methods.create(consts.system, map: model.model!.toMap());

      if (mapB == null) {
        throw "Sistema não criado";
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readSystem();
    }
  }

  Future<bool> readSystem() async {
    try {
      stream.sink.add(SystemStreamModel(status: EntityStatus.Loading));
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";

      SystemStreamModel model = SystemStreamModel();

      //* SYSTEM *//
      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.system, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Sistema não encontrado";
      }

      model.system = SystemLogicalModel(
        model: SystemDatabaseModel.fromMap(mapA.first),
      );

      stream.sink.add(model);

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await WorkflowController.instance.readWorkflow();
      await ProjectController.instance.readProject();
      await FinanceController.instance.readFinance();
      //await UserController.instance.readUser();
    }
  }

  Future<bool> updateSystem({required SystemLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do sistema é nulo";

      //* SYSTEM *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        model.model!.userId = userId;
        argsA['tb_user_atr_id'] = userId;

        await methods.update(consts.system,
            map: model.model!.toMap(), args: argsA);
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readSystem();
    }
  }

  //* MOCK *//
  Future<void> mockSystem({required int userId}) async {
    SystemLogicalModel model = SystemLogicalModel(
      model: SystemDatabaseModel(
        userId: userId,
        financeReminderDate: "30",
        workflowReminderDate: "15",
      ),
    );
    await createSystem(model: model);
  }
}
