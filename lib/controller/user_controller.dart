import 'package:project_x/model/address_model.dart';
import 'package:project_x/model/personal_model.dart';
import 'package:project_x/model/recover_model.dart';
import 'package:project_x/model/system_model.dart';
import 'package:project_x/model/user_model.dart';
import 'package:project_x/services/database/datavase_files.dart';

class UserController {
  static final UserController instance = UserController._();
  UserController._();

  final service = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  User? userModel;
  Address? addressModel;
  Personal? personalModel;
  Recover? recoverModel;
  System? systemModel;

  Future<bool> createSystem() async {
    try {
      System system = System(
        language: 1,
      );

      int? createSystem =
          await methods.create(consts.system, map: system.toMap());

      if (createSystem == null) throw "";

      return true;
    } catch (_) {
      print(_);
    }
    return false;
  }

  Future<bool> readSystem() async {
    try {
      List<Map<String, Object?>>? map = await methods.read(consts.system);

      if (map == null) throw "";

      systemModel = System.fromMap(map.first);

      return true;
    } catch (_) {
      print(_);
    }
    return false;
  }

  Future<bool> createUser() async {
    try {
      Address address = Address(
        country: 'Brasil',
        state: 'Sao Paulo',
        city: 'Sao Paulo',
        postalCode: '12345000',
        street: 'Rua',
        number: '0',
      );

      int? createAddress =
          await methods.create(consts.address, map: address.toMap());

      if (createAddress == null) throw "";

      Personal personal = Personal(
        name: 'Lucas D. M. Goncalves',
        document: '12345678900',
        addressId: createAddress,
      );

      int? createPersonal =
          await methods.create(consts.personal, map: personal.toMap());

      if (createPersonal == null) throw "";

      User user = User(
        type: 1,
        login: 'lucasdaves',
        password: '1234',
        personalId: createPersonal,
      );

      int? createUser = await methods.create(consts.user, map: user.toMap());

      if (createUser == null) throw "";

      Recover recover = Recover(
        code: '4321',
        userId: createUser,
      );

      int? createRecover =
          await methods.create(consts.recover, map: recover.toMap());

      if (createRecover == null) throw "";

      if (systemModel != null && systemModel!.userId == null) {
        System system = systemModel!;
        system.userId = createUser;

        int? updateSystem = await methods.update(consts.system,
            map: system.toMap(), id: systemModel!.id);

        if (updateSystem == null) throw "";
      }

      return true;
    } catch (_) {
      print(_);
    }
    return false;
  }

  Future<bool> readUser({
    required String login,
    required String password,
  }) async {
    try {
      var query = '''
        SELECT * FROM tb_user AS user 
        WHERE 
          user.atr_login = "$login"
        AND 
          user.atr_password = "$password"
      ''';

      List<Map<String, Object?>>? map = await methods.rawRead(query: query);

      if (map == null) throw "";

      for (var element in map) {
        userModel = User.fromMap(element);
      }

      if (userModel!.personalId != null) {
        List<Map<String, Object?>>? map = await methods.read(
          consts.personal,
          id: userModel!.personalId,
        );

        if (map == null) throw "";

        for (var element in map) {
          personalModel = Personal.fromMap(element);
        }
      }

      if (personalModel!.addressId != null) {
        List<Map<String, Object?>>? map = await methods.read(
          consts.address,
          id: personalModel!.addressId,
        );

        if (map == null) throw "";

        for (var element in map) {
          addressModel = Address.fromMap(element);
        }
      }

      // RECOVER

      var queryRec = '''
        SELECT * FROM tb_recover AS recover 
        WHERE 
          recover.tb_user_atr_id = "${userModel!.id}"
      ''';

      List<Map<String, Object?>>? mapRec = await methods.rawRead(
        query: queryRec,
      );

      if (mapRec != null) {
        for (var element in mapRec) {
          recoverModel = Recover.fromMap(element);
        }
      }

      // SYSTEM

      var querySys = '''
        SELECT * FROM tb_system AS system 
        WHERE 
          system.tb_user_atr_id = "${userModel!.id}"
      ''';

      List<Map<String, Object?>>? mapSys = await methods.rawRead(
        query: querySys,
      );

      if (mapSys != null) {
        for (var element in mapSys) {
          systemModel = System.fromMap(element);
        }
      }

      return true;
    } catch (_) {
      print(_);
    }
    return false;
  }
}
