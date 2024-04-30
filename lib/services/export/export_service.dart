import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_x/services/export/utils/export_consts.dart';
import 'package:project_x/utils/app_const.dart';
import 'package:screenshot/screenshot.dart';

class ExportService {
  static final ExportService instance = ExportService._();

  ExportService._() {}

  final ExportConsts consts = ExportConsts.instance;

  //* CORE METHODS *//

  ScreenshotController getController() {
    return ScreenshotController();
  }

  Future<Map<bool, String>> print(ScreenshotController controller) async {
    Map<bool, String> map = {};
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final path = join(
        appDocumentsDir.path,
        AppConst.basePath,
        consts.exportSubpath,
      );
      final imageName =
          "${consts.exportName}_${DateTime.now().microsecondsSinceEpoch.toString()}.png";

      await controller
          .captureAndSave(path, fileName: imageName)
          .then((value) {})
          .catchError((onError) {
        throw Exception(onError);
      });

      map[true] = "Arquivo exportado para: ${path}";
      return map;
    } catch (error) {
      map[false] = "Houve um erro ao exportar o arquivo";
      return map;
    }
  }
}
