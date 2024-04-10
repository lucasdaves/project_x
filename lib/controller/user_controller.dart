import 'dart:developer';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/model/user_controller_model.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/services/memory/memory_service.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:rxdart/rxdart.dart';

class UserController {
  static final UserController instance = UserController._();
  UserController._();

  //* SERVICE INSTANCES *//

  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;
  final storage = MemoryService.instance;

  //* STREAMS *//

  final userStream = BehaviorSubject<UserStreamModel>();

  //* DISPOSE *//

  void dispose() {
    userStream.close();
  }

  //* METHODS *//

  Future<int?> getUserId() async {
    int? id = userStream.valueOrNull?.user?.model?.id;
    return id;
  }

  Future<bool> hasLogin() async {
    try {
      if (!(await readUser())) {
        throw "Não há usuário logado";
      }
      return true;
    } catch (error) {
      log(error.toString());
      await setLogout();
      return false;
    }
  }

  Future<bool> setLogin(
      {required String login, required String password}) async {
    try {
      userStream.sink.add(UserStreamModel(status: EntityStatus.Loading));
      List<String> credential = [login, password];
      await storage.setLogin("${credential.first},${credential.last}");
      if (!(await readUser())) {
        throw "Não há usuário logado";
      }
      return true;
    } catch (error) {
      log(error.toString());
      await setLogout();
      userStream.sink.add(UserStreamModel(status: EntityStatus.Idle));
      return false;
    }
  }

  Future<bool> setLogout() async {
    try {
      await storage.setLogout();
      userStream.sink.add(UserStreamModel());
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> createUser({required UserLogicalModel model}) async {
    try {
      if (model.model == null) throw "O modelo do usuário é nulo";

      //* VERIFY USER *//
      Map<String, dynamic> argsA = {};
      argsA['atr_login'] = model.model!.login;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.user, args: argsA);

      if (mapA != null && mapA.isNotEmpty) {
        throw "Usuário já cadastrado";
      }

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
      }

      //* RECOVER *//
      int? recoverId;
      if (model.recover != null) {
        RecoverDatabaseModel recoverModel = model.recover!.model!;
        recoverId = await methods.create(
          consts.recover,
          map: recoverModel.toMap(),
        );
      }

      //* USER *//
      int? userId;
      if (model.model != null) {
        UserDatabaseModel userModel = model.model!;
        if (personalId != null) {
          userModel.personalId = personalId;
        }
        if (recoverId != null) {
          userModel.recoverId = recoverId;
        }
        userId = await methods.create(
          consts.user,
          map: userModel.toMap(),
        );
      }

      //* SYSTEM *//
      final systemModel =
          SystemController.instance.systemStream.valueOrNull?.system;
      final isLoggedIn = userId != null;

      if (systemModel != null &&
          isLoggedIn &&
          systemModel.model?.userId == null) {
        systemModel.model?.userId = userId;
        SystemController.instance.updateSystem(model: systemModel);
      }

      await readUser();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> readUser() async {
    try {
      UserStreamModel model = UserStreamModel();

      String? credentials = await storage.getLogin();

      if (credentials == null || credentials.isEmpty) {
        throw "Não há credenciais";
      }

      //* USER *//
      Map<String, dynamic> argsA = {};
      argsA['atr_login'] = credentials.split(",").first;
      argsA['atr_password'] = credentials.split(",").last;

      List<Map<String, Object?>>? mapA =
          await methods.read(consts.user, args: argsA);

      if (mapA == null || mapA.isEmpty) {
        throw "Usuário não encontrado";
      }

      model.user = UserLogicalModel(
        model: UserDatabaseModel.fromMap(mapA.first),
      );

      //* PERSONAL *//
      if (model.user?.model?.personalId != null) {
        Map<String, dynamic> argsB = {};
        argsB['atr_id'] = model.user!.model!.personalId;

        List<Map<String, Object?>>? mapB =
            await methods.read(consts.personal, args: argsB);

        if (mapB != null && mapB.isNotEmpty) {
          model.user!.personal = PersonalLogicalModel(
            model: PersonalDatabaseModel.fromMap(mapB.first),
          );
        }
      }

      //* ADDRESS *//
      if (model.user?.personal?.model?.addressId != null) {
        Map<String, dynamic> argsC = {};
        argsC['atr_id'] = model.user!.personal!.model!.addressId;

        List<Map<String, Object?>>? mapC =
            await methods.read(consts.address, args: argsC);

        if (mapC != null && mapC.isNotEmpty) {
          model.user!.personal!.address = AddressLogicalModel(
            model: AddressDatabaseModel.fromMap(mapC.first),
          );
        }
      }

      //* RECOVER *//
      if (model.user?.recover?.model?.id != null) {
        Map<String, dynamic> argsD = {};
        argsD['atr_id'] = model.user?.recover?.model?.id;

        List<Map<String, Object?>>? mapD =
            await methods.read(consts.recover, args: argsD);

        if (mapD != null && mapD.isNotEmpty) {
          model.user?.recover = RecoverLogicalModel(
            model: RecoverDatabaseModel.fromMap(mapD.first),
          );
        }
      }

      model.status = EntityStatus.Completed;
      userStream.sink.add(model);

      await SystemController.instance.readSystem();

      return true;
    } catch (error) {
      log(error.toString());
      await setLogout();
      return false;
    }
  }

  Future<bool> updateUser({required UserLogicalModel model}) async {
    try {
      int? userId = await getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do usuário é nulo";

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

      //* RECOVER *//
      if (model.recover?.model != null) {
        Map<String, dynamic> argsC = {};
        argsC['atr_id'] = model.recover!.model!.id;

        await methods.update(consts.recover,
            map: model.recover!.model!.toMap(), args: argsC);
      }

      //* USER *//
      if (model.model != null) {
        Map<String, dynamic> argsD = {};
        argsD['atr_id'] = model.model!.id;

        await methods.update(consts.user,
            map: model.model!.toMap(), args: argsD);
      }

      await readUser();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  Future<bool> deleteUser({required UserLogicalModel model}) async {
    try {
      int? userId = await getUserId();
      if (userId == null) throw "Usuário ainda não logado";
      if (model.model == null) throw "O modelo do usuário é nulo";

      //* USER *//
      if (model.model != null) {
        Map<String, dynamic> argsA = {};
        argsA['atr_id'] = model.model!.id;

        await methods.delete(consts.user, args: argsA);
      }

      userStream.sink.add(UserStreamModel());

      await setLogout();

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  //* MOCK *//
  Future<void> mockUser() async {
    UserLogicalModel model = UserLogicalModel(
      model: UserDatabaseModel(
        login: "lucasdaves",
        password: "1234",
        type: 1,
      ),
    );
    await UserController.instance.createUser(model: model);
  }
}
