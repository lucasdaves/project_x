import 'dart:developer';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/client_controller_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class ClientController {
  static final ClientController instance = ClientController._();
  ClientController._();

  //* DATABASE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  //* STREAMS *//

  final stream = BehaviorSubject<ClientStreamModel>();

  //* DISPOSE *//

  void dispose() {
    stream.close();
  }

  //* METHODS *//

  Future<bool> createClient({required ClientLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";

      model.model = ClientDatabaseModel(userId: userId);

      //* ADDRESS *//
      int? addressId;
      if (model.personal?.address != null) {
        addressId = await methods.create(
          consts.address,
          map: model.personal!.address!.model!.toMap(),
        );
      }

      //* PERSONAL *//
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
        model.model?.personalId = personalId;
      }

      //* CLIENT *//
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

      if (clientId == null) throw "Erro ao criar cliente";

      await readClient();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> readClient() async {
    try {
      stream.sink.add(ClientStreamModel(status: EntityStatus.Loading));
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "O id do usuário é nulo";

      ClientStreamModel model = ClientStreamModel();

      //* CLIENT *//
      Map<String, dynamic> argsA = {};
      argsA['tb_user_atr_id'] = userId;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.client, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Cliente não encontrado";
      }

      model.clients = mapA.map((a) {
        return ClientLogicalModel(model: ClientDatabaseModel.fromMap(a));
      }).toList();

      for (ClientLogicalModel? client in model.clients ?? []) {
        //* PERSONAL *//
        if (client?.model?.personalId != null) {
          Map<String, dynamic> argsB = {};
          if (client?.model?.personalId != null) {
            argsB['atr_id'] = client?.model?.personalId;
          }

          List<Map<String, Object?>>? mapB =
              await methods.read(consts.personal, args: argsB);

          if (mapB != null && mapB.isNotEmpty) {
            client!.personal = PersonalLogicalModel(
              model: PersonalDatabaseModel.fromMap(mapB.first),
            );
          }
        }

        //* ADDRESS *//
        if (client?.personal?.model?.addressId != null) {
          Map<String, dynamic> argsC = {};
          if (client?.personal?.model?.addressId != null) {
            argsC['atr_id'] = client?.personal?.model?.addressId;
          }

          List<Map<String, Object?>>? mapC =
              await methods.read(consts.address, args: argsC);

          if (mapC != null && mapC.isNotEmpty) {
            client!.personal!.address = AddressLogicalModel(
              model: AddressDatabaseModel.fromMap(mapC.first),
            );
          }
        }
      }

      model.status = EntityStatus.Completed;
      stream.sink.add(model);

      return true;
    } catch (error) {
      stream.sink.add(ClientStreamModel(status: EntityStatus.Completed));
      log(error.toString());
      return false;
    }
  }

  Future<bool> updateClient({required ClientLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do cliente é nulo";

      model.model!.userId = userId;

      //* ADDRESS *//
      if (model.personal?.address?.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.personal!.address!.model!.id;

        await methods.update(consts.address,
            map: model.personal!.address!.model!.toMap(), args: argsA);
      }

      //* PERSONAL *//
      if (model.personal?.model != null) {
        Map<String, dynamic> argsB = {};
        argsB['atr_id'] = model.personal!.model!.id;

        await methods.update(consts.personal,
            map: model.personal!.model!.toMap(), args: argsB);
      }

      //* CLIENT *//
      if (model.model != null) {
        Map<String, dynamic> argsC = {};
        argsC['atr_id'] = model.model!.id;

        await methods.update(consts.client,
            map: model.model!.toMap(), args: argsC);
      }

      await readClient();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteClient({required ClientLogicalModel model}) async {
    try {
      int? userId = await UserController.instance.getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do cliente é nulo";

      //* CLIENT *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.delete(consts.client, args: argsA);
      }

      await readClient();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
