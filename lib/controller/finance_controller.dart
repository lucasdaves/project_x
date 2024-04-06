import 'dart:developer';

import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/finance_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:rxdart/rxdart.dart';

class FinanceController {
  static final FinanceController instance = FinanceController._();
  FinanceController._();

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* CONTROLLER INSTANCES *//

  final userController = UserController.instance;

  //* STREAMS *//

  final financeStream = BehaviorSubject<FinanceStreamModel>();

  //* DISPOSE *//

  void dispose() {
    financeStream.close();
  }

  //* METHODS *//

  Future<bool> createFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da finança é nulo";

      model.model!.userId = userId;

      int? financeId = await methods.create(
        consts.finance,
        map: model.model!.toMap(),
      );

      if (financeId != null) {
        if (model.operations != null) {
          await Future.forEach(model.operations!, (operation) async {
            if (operation?.model != null) {
              operation!.model!.financeId = financeId;
              await methods.create(
                consts.financeOperation,
                map: operation.model!.toMap(),
              );
            }
          });
        }
      }

      await readFinance();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> readFinance({int? id, int? userId}) async {
    try {
      if (userId == null) throw "O id do usuário é nulo";

      FinanceStreamModel model = FinanceStreamModel();

      List<Map<String, Object?>>? mapA = await methods.read(
        consts.finance,
        id: id,
        userId: userId,
      );

      model.finances = mapA!.map((a) {
        FinanceLogicalModel financeModel = FinanceLogicalModel(
          model: FinanceDatabaseModel.fromMap(a),
          operations: [],
        );
        return financeModel;
      }).toList();

      await Future.forEach(model.finances!, (finance) async {
        List<Map<String, Object?>>? mapB = await methods.rawRead(
          query:
              'SELECT * FROM tb_finance_operation WHERE tb_finance_atr_id = ${finance?.model?.id}',
        );

        finance!.operations = mapB!.map((b) {
          return FinanceOperationLogicalModel(
              model: FinanceOperationDatabaseModel.fromMap(b));
        }).toList();
      });

      financeStream.sink.add(model);

      log(financeStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da finança é nulo";

      await methods.update(consts.finance,
          map: model.model!.toMap(), id: model.model!.id!);

      await Future.forEach(model.operations!, (operation) async {
        if (operation?.model != null) {
          await methods.update(consts.financeOperation,
              map: operation!.model!.toMap(), id: operation.model!.id!);
        }
      });

      await readFinance();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da finança é nulo";

      await Future.forEach(model.operations!, (operation) async {
        if (operation?.model != null) {
          await methods.delete(
            consts.financeOperation,
            id: operation!.model?.id,
          );
        }
      });

      await methods.delete(consts.finance, id: model.model?.id);

      await readFinance();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
