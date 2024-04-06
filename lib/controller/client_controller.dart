import 'dart:developer';

import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/client_controller_model.dart';
import 'package:project_x/model/user_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:rxdart/rxdart.dart';

class ClientController {
  static final ClientController instance = ClientController._();
  ClientController._();

  //* DATABASE INSTANCES *//

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* CONTROLLER INSTANCES *//

  final systemController = SystemController.instance;
  final userController = UserController.instance;

  //* STREAMS *//

  final clientStream = BehaviorSubject<ClientStreamModel>();

  //* DISPOSE *//

  void dispose() {
    clientStream.close();
  }

  //* METHODS *//

  Future<bool> createClient({required ClientLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "O id do usuário é nulo";
      if (model.model == null) throw "O modelo do cliente é nulo";

      model.model!.userId = userId;

      int? addressId;
      if (model.personal?.address != null) {
        addressId = await methods.create(
          consts.address,
          map: model.personal!.address!.model!.toMap(),
        );
      }

      int? personalId;
      if (model.personal != null) {
        PersonalDatabaseModel personalModel = model.personal!.model!;
        if (addressId != null) {
          personalModel.addressId = addressId;
        }
        personalId = await methods.create(
          consts.personal,
          map: personalModel.toMap(),
        );
      }

      int? clientId;
      if (model.model != null) {
        ClientDatabaseModel clientModel = model.model!;
        if (personalId != null) {
          clientModel.personalId = personalId;
        }
        clientId = await methods.create(
          consts.client,
          map: clientModel.toMap(),
        );
      }

      if (clientId != null) {
        await methods.create(
          consts.client,
          map: {'tb_user_atr_id': userId, 'tb_client_atr_id': clientId},
        );
      }

      await readClient();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> readClient({int? id}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";

      ClientStreamModel model = ClientStreamModel();

      List<Map<String, Object?>>? mapA = await methods.read(
        consts.client,
        id: id,
        userId: userId,
      );

      if (mapA == null || mapA.isEmpty) throw "Cliente não encontrado";

      model.clients = mapA.map((a) {
        return ClientLogicalModel(model: ClientDatabaseModel.fromMap(a));
      }).toList();

      clientStream.sink.add(model);

      log(clientStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> updateClient({required ClientLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do cliente é nulo";

      model.model!.userId = userId;

      if (model.personal?.address != null) {
        if (model.personal!.address!.model == null) {
          throw "O modelo de endereço é nulo";
        }

        if (model.personal!.address!.model!.id != null) {
          await methods.update(
            consts.address,
            map: model.personal!.address!.model!.toMap(),
            id: model.personal!.address!.model!.id!,
          );
        } else {
          throw "O ID do endereço é nulo";
        }
      }

      if (model.personal != null) {
        if (model.personal!.model == null) {
          throw "O modelo de dados pessoais é nulo";
        }

        if (model.personal!.model!.id != null) {
          await methods.update(
            consts.personal,
            map: model.personal!.model!.toMap(),
            id: model.personal!.model!.id!,
          );
        } else {
          throw "O ID dos dados pessoais é nulo";
        }
      }

      if (model.model != null) {
        if (model.model!.id != null) {
          await methods.update(
            consts.client,
            map: model.model!.toMap(),
            id: model.model!.id!,
          );
        } else {
          throw "O ID do cliente é nulo";
        }
      }

      await readClient();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> deleteClient({required ClientLogicalModel model}) async {
    try {
      int? userId = await userController.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do cliente é nulo";
      if (model.model!.id != null) throw "O id do modelo é nulo";

      await methods.delete(consts.client, id: model.model!.id);

      await readClient();

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }
}
