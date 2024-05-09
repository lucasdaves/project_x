// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/finance_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class FinanceController {
  static final FinanceController instance = FinanceController._();
  FinanceController._();

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final stream = BehaviorSubject<FinanceStreamModel>();

  //* VARIABLES *//

  DateTime? reportMinDate;
  DateTime? reportMaxDate;

  //* DISPOSE *//

  void dispose() {
    stream.close();
  }

  //* METHODS *//

  void initDate() {
    DateTime now = DateTime.now();
    reportMinDate = reportMinDate ?? DateTime(now.year, now.month, 1);
    reportMaxDate = reportMaxDate ?? DateTime(now.year, now.month + 1, 0);
  }

  void setDate(DateTime? start, DateTime? end) {
    if (start != null) reportMinDate = start;
    if (end != null) reportMaxDate = end;
  }

  List<DateTime> getDate() {
    return [reportMinDate!, reportMaxDate!];
  }

  Future<bool> createFinance({required FinanceLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";

      model.model?.userId = userId;

      //* FINANCE *//
      int? financeId;
      if (model.model != null) {
        model.model?.status = FinanceDatabaseModel.statusMap[0];
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

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readFinance();
    }
  }

  Future<bool> readFinance() async {
    try {
      stream.sink.add(FinanceStreamModel(status: EntityStatus.Loading));
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

      model.status = EntityStatus.Completed;
      stream.sink.add(model);

      return true;
    } catch (error) {
      stream.sink.add(FinanceStreamModel(status: EntityStatus.Completed));
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
          if (operation?.model?.id == null) {
            operation?.model?.financeId = model.model!.id;
            operation?.model?.id = await methods.create(consts.financeOperation,
                map: operation.model!.toMap());
          } else {
            Map<String, dynamic> argsB = {};
            argsB['atr_id'] = operation!.model!.id;

            await methods.update(consts.financeOperation,
                map: operation.model!.toMap(), args: argsB);
          }
        }
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readFinance();
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

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    } finally {
      await readFinance();
      await AssociationController.instance.readAssociation();
    }
  }
}
