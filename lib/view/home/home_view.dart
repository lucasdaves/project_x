import 'package:flutter/material.dart';
import 'package:project_x/controller/system_controller.dart';
import 'package:project_x/controller/user_controller.dart';
import 'package:project_x/controller/workflow_controller.dart';
import 'package:project_x/model/system_controller_model.dart';
import 'package:project_x/model/user_controller_model.dart';
import 'package:project_x/model/workflow_controller_model.dart';
import 'package:project_x/services/database/database_service.dart';
import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/services/database/model/step_model.dart';
import 'package:project_x/services/database/model/substep_model.dart';
import 'package:project_x/services/database/model/system_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/services/database/model/workflow_model.dart';
import 'package:project_x/services/memory/memory_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final databaseService = DatabaseService.instance;
  final memoryService = MemoryService.instance;

  final systemController = SystemController.instance;
  final userController = UserController.instance;
  final workflowController = WorkflowController.instance;

  @override
  void initState() {
    databaseService.initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> testFunctions = {
      "Apagar banco": testDeleteDatabase,
      "Validar login": testHasLogin,
    };

    Map<String, dynamic> systemFunctions = {
      "Cadastrar Sistema": testCreateSystem,
      "Atualizar sistema": testUpdateSystem,
      "Ler sistema": testReadSystem,
    };

    Map<String, dynamic> userFunctions = {
      "Cadastrar usuario": testCreateUser,
      "Atualizar usuario": testUpdateUser,
      "Ler usuario": testReadSystem,
    };

    Map<String, dynamic> workflowFunctions = {
      "Cadastrar workflow": testCreateWorkflow,
      "Atualizar Workflow": testUpdateWorkflow,
      "Ler workflow": testReadWorkflow,
    };

    Map<String, dynamic> clientFunctions = {
      "Cadastrar cliente": testCreateWorkflow,
      "Atualizar Cliente": testUpdateWorkflow,
      "Ler cliente": testReadWorkflow,
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("TESTES"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
                stream: workflowController.workflowStream,
                builder: (context, snapshopt) {
                  if (snapshopt.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: workflowController
                          .workflowStream.value.workflows!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              workflowController.workflowStream.value
                                  .workflows![index]!.model!.name,
                            ),
                            Text(
                              "Quantidade de Steps: " +
                                  workflowController.workflowStream.value
                                      .workflows![index]!.steps!.length
                                      .toString(),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
            ...testFunctions.entries.map(
              (e) {
                return GestureDetector(
                  onTap: () async => e.value(),
                  child: Container(
                    width: double.maxFinite,
                    height: 24,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Text(e.key),
                  ),
                );
              },
            ),
            Container(
              height: 8,
              width: double.maxFinite,
              color: Colors.purple,
            ),
            ...systemFunctions.entries.map(
              (e) {
                return GestureDetector(
                  onTap: () async => e.value(),
                  child: Container(
                    width: double.maxFinite,
                    height: 24,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Text(e.key),
                  ),
                );
              },
            ),
            Container(
              height: 8,
              width: double.maxFinite,
              color: Colors.purple,
            ),
            ...userFunctions.entries.map(
              (e) {
                return GestureDetector(
                  onTap: () async => e.value(),
                  child: Container(
                    width: double.maxFinite,
                    height: 24,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Text(e.key),
                  ),
                );
              },
            ),
            Container(
              height: 8,
              width: double.maxFinite,
              color: Colors.purple,
            ),
            ...workflowFunctions.entries.map(
              (e) {
                return GestureDetector(
                  onTap: () async => e.value(),
                  child: Container(
                    width: double.maxFinite,
                    height: 24,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Text(e.key),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testDeleteDatabase() async {
    await databaseService.clearDatabase();
    await memoryService.clearMemory();
  }

  Future<void> testHasLogin() async {
    bool aux = await userController.hasLogin();
    print(aux);
  }

  Future<void> testCreateSystem() async {
    SystemLogicalModel aux = SystemLogicalModel();
    aux = SystemLogicalModel(
      model: SystemDatabaseModel(language: 1),
    );
    print(await systemController.createSystem(model: aux));
  }

  Future<void> testReadSystem() async {
    print(await systemController.readSystem());
  }

  Future<void> testUpdateSystem() async {
    SystemStreamModel aux = systemController.systemStream.value.copy();
    aux.system!.model!.language = 2;
    print(await systemController.updateSystem(model: aux.system!));
  }

  Future<void> testCreateUser() async {
    UserLogicalModel aux = UserLogicalModel();
    aux = UserLogicalModel(
      model: UserDatabaseModel(
        type: 1,
        login: 'lucadaves',
        password: '1234',
      ),
      recover: RecoverLogicalModel(
        model: RecoverDatabaseModel(
          code: '4321',
        ),
      ),
      personal: PersonalLogicalModel(
        model: PersonalDatabaseModel(
          name: 'Lucas D. M. Goncalves',
          document: '12345678900',
        ),
        address: AddressLogicalModel(
          model: AddressDatabaseModel(
            country: 'Brasil',
            state: 'Sao Paulo',
            city: 'Sao Paulo',
            postalCode: '12345000',
            street: 'Rua',
            number: '0',
          ),
        ),
      ),
    );
    print(await userController.createUser(model: aux));
  }

  Future<void> testUpdateUser() async {
    UserStreamModel aux = userController.userStream.value.copy();
    aux.user?.personal?.model?.name = "SHREK";
    aux.user?.personal?.model?.document = "VrAu";
    print(await userController.updateUser(model: aux.user!));
  }

  Future<void> testReadUser() async {
    print(await userController.readUser(login: 'lucasdaves', password: '1234'));
  }

  Future<void> testCreateWorkflow() async {
    WorkflowLogicalModel aux = WorkflowLogicalModel();
    aux = WorkflowLogicalModel(
      model: WorkflowDatabaseModel(
        name: 'Fluxo 1 - Arquiteto',
        description: 'Fluxo criado para seguir em frente no trabalho',
        userId: userController.userStream.valueOrNull?.user?.model?.id,
      ),
      steps: [
        StepLogicalModel(
          model: StepDatabaseModel(
            name: 'Etapa 1',
            description: 'AAA',
            status: false,
            mandatory: false,
          ),
          substeps: [
            SubstepLogicalModel(
              model: SubstepDatabaseModel(
                name: 'Subetapa 1',
                description: '123',
                status: false,
                mandatory: true,
              ),
            ),
          ],
        ),
        StepLogicalModel(
          model: StepDatabaseModel(
            name: 'Estapa 2',
            description: 'BBB',
            status: false,
            mandatory: true,
          ),
          substeps: [
            SubstepLogicalModel(
              model: SubstepDatabaseModel(
                name: 'Subetapa 2',
                description: '123',
                status: false,
                mandatory: true,
              ),
            ),
            SubstepLogicalModel(
              model: SubstepDatabaseModel(
                name: 'Subetapa 3',
                status: false,
                mandatory: true,
              ),
            ),
          ],
        ),
      ],
    );
    print(await workflowController.createWorkflow(model: aux));
  }

  Future<void> testUpdateWorkflow() async {
    WorkflowStreamModel aux = workflowController.workflowStream.value.copy();
    aux.workflows!.first!.model!.name = "VRAU";
    aux.workflows!.first!.steps!.first!.model!.name = "BLINBLIN";
    aux.workflows!.first!.steps!.first!.substeps!.first!.model!.name =
        "KATCHAU";
    print(
        await workflowController.updateWorkflow(model: aux.workflows!.first!));
  }

  Future<void> testReadWorkflow() async {
    print(await workflowController.readWorkflow());
  }

  Future<void> testDeleteWorkflow() async {
    WorkflowStreamModel? stream = workflowController.workflowStream.valueOrNull;
    if (stream != null) {
      Future.wait(stream.workflows!.map((e) async {
        print(await workflowController.deleteWorkflow(model: e!));
      }));
    }
  }

  Future<void> testCreateClient() async {
    print(await workflowController.readWorkflow());
  }

  Future<void> testUpdateClient() async {}

  Future<void> testReadClient() async {
    print(await workflowController.readWorkflow());
  }

  Future<void> testDeleteClient() async {
    print(await workflowController.readWorkflow());
  }
}
