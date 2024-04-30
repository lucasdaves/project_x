import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_x/services/database/database_files.dart';
import 'package:project_x/utils/app_const.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();

  DatabaseService._() {
    sqfliteFfiInit();
    _databaseFactory = databaseFactoryFfi;
  }

  final DatabaseConsts consts = DatabaseConsts.instance;
  final DatabaseScripts scripts = DatabaseScripts.instance;

  late final DatabaseFactory _databaseFactory;

  late DatabaseModel databaseModel;

  //* CORE METHODS *//

  Database getDatabase() {
    return databaseModel.database!;
  }

  Future<void> clearDatabase() async {
    try {
      _checkPlatformSupport();

      await databaseModel.database!.close();
      await _databaseFactory.deleteDatabase(databaseModel.databasePath!);

      log("Banco de dados apagado");
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> initDatabase() async {
    try {
      _checkPlatformSupport();

      await _initInformation();

      final database = await _databaseFactory.openDatabase(
        databaseModel.databasePath!,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
          onConfigure: _onConfigure,
        ),
      );
      databaseModel.database = database;

      log("Banco de dados inicializado");
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> _initInformation() async {
    databaseModel = DatabaseModel();
    databaseModel.databaseName = consts.databaseName;
    databaseModel.databaseVersion = consts.databaseVersion;
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final path = join(
      appDocumentsDir.path,
      AppConst.basePath,
      consts.databaseSubpath,
      consts.databaseName,
    );
    databaseModel.databasePath = path;
  }

  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(scripts.createTablesScript());
  }

  Future<void> _onConfigure(Database database) async {
    final db = database;
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void _checkPlatformSupport() {
    if (!(Platform.isWindows || Platform.isAndroid || Platform.isIOS)) {
      throw Exception("Unsupported platform");
    }
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
