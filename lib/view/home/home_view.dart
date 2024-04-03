import 'package:flutter/material.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/model/user_model.dart';
import 'package:project_x/services/database/database_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final databaseService = DatabaseService.instance;
  final userController = UserController.instance;

  @override
  void initState() {
    databaseService.initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> functions = {
      "Cadastrar usuário": test1,
      "Cadastrar pessoal": test2,
      "Cadastrar profissao": test3,
      "Cadastrar endereço": test4,
      "Ler usário": test5,
      "Ler usário do banco": test6,
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("TESTES"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ...functions.entries.map(
            (e) {
              return GestureDetector(
                onTap: () async => e.value(),
                child: Container(
                  width: double.maxFinite,
                  height: 24,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(e.key),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> test1() async {
    await userController.createUser();
  }

  Future<void> test2() async {
    await userController.createPersonal();
  }

  Future<void> test3() async {
    await userController.createProfession();
  }

  Future<void> test4() async {
    await userController.createAddress();
  }

  Future<void> test5() async {
    UserModel? model = userController.getUserModel();
    print(model?.toMap());
  }

  Future<void> test6() async {
    UserModel? model = await userController.getUserModelBd();
    print(model?.toMap());
  }
}
