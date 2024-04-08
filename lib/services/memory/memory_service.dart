import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MemoryService {
  static final MemoryService instance = MemoryService._();
  MemoryService._();

  //* INSTANCES *//

  final storage = const FlutterSecureStorage();

  //* CORE METHODS *//

  Future<void> clearMemory() async {
    await storage.deleteAll();
  }

  Future<void> setLogin(String credentials) async {
    await storage.write(key: "login", value: credentials);
  }

  Future<void> setLogout() async {
    await storage.delete(key: "login");
  }

  Future<String?> getLogin() async {
    return await storage.read(key: "login");
  }
}
