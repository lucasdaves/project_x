import 'package:project_x/services/database/model/system_model.dart';

class SystemStreamModel {
  SystemLogicalModel? system;

  SystemStreamModel({this.system});

  SystemStreamModel copy() {
    return SystemStreamModel(
      system: system != null
          ? SystemLogicalModel(
              model: system!.model?.copy(),
            )
          : null,
    );
  }

  SystemLogicalModel? getOne({int? id, String? userId}) {
    SystemStreamModel aux = copy();
    if (id != null && aux.system?.model?.id == id) {
      return aux.system;
    } else if (userId != null && aux.system?.model?.userId == userId) {
      return aux.system;
    }
    return null;
  }

  Map<int, String> getMap() {
    SystemStreamModel aux = copy();
    Map<int, String> map = {};
    map.addAll({aux.system!.model!.id!: ""});
    return map;
  }
}
