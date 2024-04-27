import 'package:project_x/services/database/model/system_model.dart';
import 'package:project_x/utils/app_enum.dart';

class SystemStreamModel {
  EntityStatus status;
  SystemLogicalModel? system;

  SystemStreamModel({this.status = EntityStatus.Idle, this.system});

  SystemStreamModel copy() {
    return SystemStreamModel(
      status: this.status,
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
