import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_x/services/database/utils/database_consts.dart';
import 'package:project_x/services/database/utils/database_scripts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  final DatabaseConsts consts = DatabaseConsts.instance;
  final DatabaseScripts scripts = DatabaseScripts.instance;

  late DatabaseModel databaseModel;

  //* CORE METHODS *//

  Database getDatabase() {
    return databaseModel.database!;
  }

  Future<void> clearDatabase() async {
    if (!(Platform.isWindows ||
        Platform.isLinux ||
        Platform.isAndroid ||
        Platform.isIOS)) {
      throw Exception("Unsupported platform");
    }

    await databaseModel.database!.close();

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      await databaseFactory.deleteDatabase(databaseModel.databasePath!);
    } else if (Platform.isAndroid || Platform.isIOS) {
      await deleteDatabase(databaseModel.databasePath!);
    }
  }

  Future<void> initDatabase() async {
    late Database database;

    if (!(Platform.isWindows ||
        Platform.isLinux ||
        Platform.isAndroid ||
        Platform.isIOS)) {
      throw Exception("Unsupported platform");
    }

    await _initInformation();

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final winLinuxDB = await databaseFactory.openDatabase(
        databaseModel.databasePath!,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ),
      );
      database = winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS) {
      final iOSAndroidDB = await openDatabase(
        databaseModel.databasePath!,
        version: 1,
        onCreate: _onCreate,
      );
      database = iOSAndroidDB;
    }

    databaseModel.database = database;

    //await DatabaseService.instance.clearDatabase();
  }

  Future<void> _initInformation() async {
    databaseModel = DatabaseModel();
    databaseModel.databaseName = consts.databaseName;
    databaseModel.databaseVersion = consts.databaseVersion;
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final path = join(
      appDocumentsDir.path,
      "databases",
      databaseModel.databaseName,
    );
    databaseModel.databasePath = path;
  }

  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(scripts.createTablesScript());
  }
}

class DatabaseModel {
  Database? database;
  String? databaseName;
  String? databasePath;
  int? databaseVersion;

  DatabaseModel({
    this.database,
    this.databaseName,
    this.databasePath,
    this.databaseVersion,
  });
}
