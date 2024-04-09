// ignore_for_file: unnecessary_null_comparison

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

  //* STREAMS *//

  final financeStream = BehaviorSubject<FinanceStreamModel>();

  //* DISPOSE *//

  void dispose() {
    financeStream.close();
  }

  //* METHODS *//

  Future<bool> createFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da finança é nulo";

      model.model!.userId = userId;

      //* FINANCE *//
      int? financeId;
      if (model.model != null) {
        financeId = await methods.create(
          consts.finance,
          map: model.model!.toMap(),
        );
      }

      if (financeId == null) throw "Erro ao criar finança";

      //* FINANCE OPERATIONS *//
      for (FinanceOperationLogicalModel? operation in model.operations ?? []) {
        if (operation?.model != null) {
          operation!.model!.financeId = financeId;
          await methods.create(
            consts.financeOperation,
            map: operation.model!.toMap(),
          );
        }
      }

      await readFinance();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> readFinance() async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";

      FinanceStreamModel model = FinanceStreamModel();

      //* FINANCE *//
      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.finance, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Finança não encontrada";
      }

      model.finances = mapA.map((a) {
        return FinanceLogicalModel(
          model: FinanceDatabaseModel.fromMap(a),
          operations: [],
        );
      }).toList();

      //* FINANCE OPERATIONS *//
      for (FinanceLogicalModel? finance in model.finances ?? []) {
        Map<String, dynamic> argsB = {};
        argsB['tb_finance_atr_id'] = finance?.model?.id;

        List<Map<String, Object?>>? mapB =
            await methods.read(consts.financeOperation, args: argsB);

        if (mapB != null && mapB.isNotEmpty) {
          finance!.operations = mapB.map((b) {
            return FinanceOperationLogicalModel(
              model: FinanceOperationDatabaseModel.fromMap(b),
            );
          }).toList();
        }
      }

      financeStream.sink.add(model);

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da finança é nulo";

      model.model!.userId = userId;

      //* FINANCE *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.update(consts.finance,
            map: model.model!.toMap(), args: argsA);
      }

      //* FINANCE OPERATIONS *//
      for (FinanceOperationLogicalModel? operation in model.operations ?? []) {
        if (operation?.model != null) {
          Map<String, dynamic> argsB = {};
          argsB['atr_id'] = operation!.model!.id;

          await methods.update(consts.financeOperation,
              map: operation.model!.toMap(), args: argsB);
        }
      }

      await readFinance();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da finança é nulo";

      //* FINANCE *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.delete(consts.finance, args: argsA);
      }

      await readFinance();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
