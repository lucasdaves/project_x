import 'dart:developer';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/association_controller_model.dart';
import 'package:project_x/services/database/model/project_finance_client_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:rxdart/rxdart.dart';

class AssociationController {
  static final AssociationController instance = AssociationController._();
  AssociationController._();

  //* DATABASE INSTANCES *//

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* CONTROLLER INSTANCES *//

  final userController = UserController.instance;

  //* STREAMS *//

  final associationStream = BehaviorSubject<AssociationStreamModel>();

  //* DISPOSE *//

  void dispose() {
    associationStream.close();
  }

  //* METHODS *//

  Future<bool> createAssociation(
      {required AssociationLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo da associação é nulo";

      model.model?.userId = userId;

      //* ASSOCIATION *//
      int? associationId;
      if (model.model != null) {
        AssociationDatabaseModel associationModel = model.model!;
        associationModel.userId = userId;
        associationId = await methods.create(
          consts.association,
          map: associationModel.toMap(),
        );
      }

      if (associationId == null) throw "Erro ao criar associação";

      await readAssociation();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> readAssociation() async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      AssociationStreamModel model = AssociationStreamModel();

      //* ASSOCIATION *//
      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.association, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Associação não encontrada";
      }

      associationStream.sink.add(model);

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateAssociation(
      {required AssociationLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo da associação é nulo";

      model.model!.userId = userId;

      //* ASSOCIATION *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.update(consts.association,
            map: model.model!.toMap(), args: argsA);

        if (model.model!.clientId == null &&
            model.model!.clientId == null &&
            model.model!.clientId == null) {
          deleteAssociation(model: model);
        }
      }

      await readAssociation();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteAssociation(
      {required AssociationLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo da associação é nulo";

      //* ASSOCIATION *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.delete(consts.association, args: argsA);
      }

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
