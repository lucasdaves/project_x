import 'package:project_x/model/address_model.dart';
import 'package:project_x/model/personal_model.dart';
import 'package:project_x/model/profession_model.dart';
import 'package:project_x/model/user_model.dart';
import 'package:project_x/services/database/database_service.dart';
import 'package:project_x/services/database/utils/database_consts.dart';
import 'package:project_x/services/database/utils/database_methods.dart';

class UserController {
  static final UserController instance = UserController._();
  UserController._();

  UserModel? userModel;

  final databaseService = DatabaseService.instance;
  final methods = DatabaseMethods.instance;
  final consts = DatabaseConsts.instance;

  Future<void> createUser() async {
    if (userModel == null) {
      UserModel model = UserModel(
        type: 1,
        login: "lucasdaves",
        password: "1234",
      );
      int id = await methods.create(
        databaseService.getDatabase(),
        consts.user,
        map: model.toMap(),
      );
      model.id = id;
      userModel = model;
    }
  }

  Future<void> createPersonal() async {
    PersonalModel model = PersonalModel(
      name: "Lucas Daves de Melo",
      document: "12345678901",
      email: "teste@teste.com",
      phone: "11912341234",
    );
    int id = await methods.create(
      databaseService.getDatabase(),
      consts.personal,
      map: model.toMap(),
    );
    model.id = id;

    userModel!.personalId = model.id;
    userModel!.personalModel = model;

    await methods.update(
      databaseService.getDatabase(),
      consts.user,
      map: userModel!.toMap(),
      id: userModel!.id!,
    );
  }

  Future<void> createProfession() async {
    ProfessionModel model = ProfessionModel(
      name: "Arquiteto",
      document: "ABC123",
      personalId: userModel!.personalId!,
    );
    int id = await methods.create(
      databaseService.getDatabase(),
      consts.profession,
      map: model.toMap(),
    );
    model.id = id;

    if (userModel!.personalModel!.professionModel == null) {
      userModel!.personalModel!.professionModel = [];
    }
    userModel!.personalModel!.professionModel!.add(model);
  }

  Future<void> createAddress() async {
    AddressModel model = AddressModel(
      country: "Brasil",
      state: "SP",
      city: "São Paulo",
      postalCode: "12345000",
      street: "rua fulano",
      number: "70",
      complement: "complemento",
    );
    int id = await methods.create(
      databaseService.getDatabase(),
      consts.address,
      map: model.toMap(),
    );
    model.id = id;

    userModel!.personalModel!.addressId = model.id;
    userModel!.personalModel!.addressModel = model;

    await methods.update(
      databaseService.getDatabase(),
      consts.personal,
      map: userModel!.personalModel!.toMap(),
      id: userModel!.personalModel!.id,
    );
  }

  UserModel? getUserModel() {
    return userModel;
  }

  Future<UserModel?> getUserModelBd() async {
    UserModel model;
    var map1 = await methods.read(databaseService.getDatabase(), consts.user);
    model = UserModel.fromMap(map1.first);

    var map2 =
        await methods.read(databaseService.getDatabase(), consts.personal);

    for (var element in map2) {
      PersonalModel aux = PersonalModel.fromMap(element);
      if (aux.id == model.personalId) {
        model.personalModel = aux;
      }
    }

    model.personalModel!.professionModel = [];

    var map3 =
        await methods.read(databaseService.getDatabase(), consts.profession);

    for (var element in map3) {
      ProfessionModel aux = ProfessionModel.fromMap(element);
      if (aux.personalId == model.personalId) {
        model.personalModel!.professionModel!.add(aux);
      }
    }

    var map4 =
        await methods.read(databaseService.getDatabase(), consts.address);

    for (var element in map4) {
      AddressModel aux = AddressModel.fromMap(element);
      if (aux.id == model.personalModel!.addressId) {
        model.personalModel!.addressModel = aux;
      }
    }

    return model;
  }
}
