import 'dart:developer';

import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/model/system_controller_model.dart';
import 'package:project_x/model/user_controller_model.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/memory/memory_service.dart';
import 'package:rxdart/rxdart.dart';

class UserController {
  static final UserController instance = UserController._();
  UserController._();

  //* SERVICE INSTANCES *//

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;
  final storage = MemoryService.instance;

  //* CONTROLLER INSTANCES *//

  final systemController = SystemController.instance;

  //* STREAMS *//

  final userStream = BehaviorSubject<UserStreamModel>();

  //* DISPOSE *//

  void dispose() {
    userStream.close();
  }

  //* METHODS *//

  Future<bool> hasLogin() async {
    try {
      String? hasLogin = await storage.getLogin();
      if (hasLogin == null) {
        throw "Não há usuário logado";
      }
      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> setLogin(
      {required String login, required String password}) async {
    try {
      List<String> credential = [login, password];
      await storage.setLogin(credential.toString());
      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> createUser({required UserLogicalModel model}) async {
    try {
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

      int? userId;
      if (model.model != null) {
        UserDatabaseModel userModel = model.model!;
        if (personalId != null) {
          userModel.personalId = personalId;
        }
        userId = await methods.create(
          consts.user,
          map: userModel.toMap(),
        );
      }

      if (model.recover != null && userId != null) {
        RecoverDatabaseModel recoverModel = model.recover!.model!;
        recoverModel.userId = userId;
        await methods.create(
          consts.recover,
          map: recoverModel.toMap(),
        );
      }

      SystemLogicalModel? systemModel =
          systemController.systemStream.valueOrNull?.system;

      if (systemModel != null &&
          systemModel.model?.userId == null &&
          userId != null) {
        systemModel.model?.userId = userId;
        systemController.updateSystem(model: systemModel);
      }

      await readUser(
          login: model.model!.login, password: model.model!.password);

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> readUser(
      {required String login, required String password}) async {
    try {
      UserStreamModel model = UserStreamModel();

      List<Map<String, Object?>>? map = await methods.rawRead(
          query:
              'SELECT * FROM tb_user AS user WHERE user.atr_login = "$login" AND user.atr_password = "$password"');

      if (map == null || map.isEmpty) {
        throw "Usuário não encontrado";
      }

      model.user = UserLogicalModel(
        model: UserDatabaseModel.fromMap(map.first),
      );

      if (model.user!.model!.personalId != null) {
        List<Map<String, Object?>>? personalMap = await methods.read(
          consts.personal,
          id: model.user!.model!.personalId,
        );

        if (personalMap == null || personalMap.isEmpty) {
          throw "Dados pessoais não encontrados";
        }

        model.user!.personal = PersonalLogicalModel(
          model: PersonalDatabaseModel.fromMap(personalMap.first),
        );
      }

      if (model.user!.personal!.model!.addressId != null) {
        List<Map<String, Object?>>? addressMap = await methods.read(
          consts.address,
          id: model.user!.personal!.model!.addressId,
        );

        if (addressMap == null || addressMap.isEmpty) {
          throw "Endereço não encontrado";
        }

        model.user!.personal!.address = AddressLogicalModel(
          model: AddressDatabaseModel.fromMap(addressMap.first),
        );
      }

      var recoverQuery =
          'SELECT * FROM tb_recover AS recover WHERE recover.tb_user_atr_id = ${model.user!.model!.id}';

      List<Map<String, Object?>>? recoverMap =
          await methods.rawRead(query: recoverQuery);

      if (recoverMap == null || recoverMap.isEmpty) {
        throw "Recuperação de conta não encontrada";
      }

      model.user!.recover = RecoverLogicalModel(
        model: RecoverDatabaseModel.fromMap(recoverMap.first),
      );

      await setLogin(
          login: model.user!.model!.login,
          password: model.user!.model!.password);

      await systemController.readSystem(userId: model.user!.model!.id);

      userStream.sink.add(model);

      log(userStream.value.toString());

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }

  Future<bool> updateUser({required UserLogicalModel model}) async {
    try {
      if (model.model == null) {
        throw "O modelo de usuário é nulo";
      }

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
            consts.user,
            map: model.model!.toMap(),
            id: model.model!.id!,
          );
        } else {
          throw "O ID do usuário é nulo";
        }
      }

      if (model.recover != null) {
        if (model.recover!.model == null) {
          throw "O modelo de recuperação de conta é nulo";
        }

        if (model.recover!.model!.id != null) {
          await methods.update(
            consts.recover,
            map: model.recover!.model!.toMap(),
            id: model.recover!.model!.id!,
          );
        } else {
          throw "O ID da recuperação de conta é nulo";
        }
      }

      await systemController.readSystem(userId: model.model!.id);

      await readUser(
          login: model.model!.login, password: model.model!.password);

      return true;
    } catch (error) {
      log(error.toString());
    }
    return false;
  }
}
