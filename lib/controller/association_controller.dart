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

      int? associationId = await methods.create(
        consts.association,
        map: model.model!.toMap(),
      );

      if (associationId == null) throw "Associação não criada";

      await readAssociation();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> readAssociation({int? id, int? userId}) async {
    try {
      if (userId == null) throw "Usuário ainda não logado";

      AssociationStreamModel model = AssociationStreamModel();

      List<Map<String, Object?>>? mapA = await methods.read(
        consts.association,
        id: id,
        userId: userId,
      );

      model.associations = mapA!.map((a) {
        return AssociationLogicalModel(
          model: AssociationDatabaseModel.fromMap(a),
        );
      }).toList();

      associationStream.sink.add(model);

      log(associationStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> updateAssociation(
      {required AssociationLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();

      if (userId == null) throw "Usuário ainda não logado";

      if (model.model == null) throw "O modelo da associação é nulo";

      await methods.update(consts.association,
          map: model.model!.toMap(), id: model.model!.id!);

      await readAssociation();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> deleteAssociation(
      {required AssociationLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();

      if (userId == null) throw "Usuário ainda não logado";

      if (model.model == null) throw "O modelo da associação é nulo";

      await methods.delete(consts.association, id: model.model?.id);

      await readAssociation();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }
}
