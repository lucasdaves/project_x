import 'package:project_x/model/personal_model.dart';
import 'package:project_x/model/profession_model.dart';
import 'package:project_x/model/user_model.dart';
import 'package:project_x/services/database/database_query.dart';
import 'package:project_x/services/database/database_service.dart';

class UserController {
  static final UserController instance = UserController._();
  UserController._();

  UserModel? userModel;

  final databaseService = DatabaseService.instance;

  Future<void> createUser() async {
    if (userModel == null) {
      UserModel model = UserModel(
        type: 1,
        login: "lucasdaves",
        password: "1234",
      );
      int id = await DatabaseQuery.instance.createUser(
        databaseService.getDatabase(),
        model: model,
      );
      model.id = id;
      userModel = model;
    }
  }

  Future<void> createPersonal() async {
    PersonalModel model = PersonalModel(
      name: "Lucas Daves de Melo",
      document: "12345678901",
    );
    int id = await DatabaseQuery.instance.createPersonal(
      databaseService.getDatabase(),
      model: model,
    );
    userModel!.personalId = id;
    DatabaseQuery.instance.updateUser(
      databaseService.getDatabase(),
      model: userModel!,
      id: userModel!.id!,
    );
  }

  Future<void> createProfession() async {
    ProfessionModel model = ProfessionModel(
      name: "Arquiteto",
      document: "ABC123",
      personalId: userModel!.personalId!,
    );
    int id = await DatabaseQuery.instance.createProfession(
      databaseService.getDatabase(),
      model: model,
    );
  }

  Future<void> createAddress() async {}

  UserModel? getUser() {
    return userModel;
  }
}
