import 'package:project_x/services/database/model/system_model.dart';

class SystemStreamModel {
  SystemLogicalModel? system;

  SystemStreamModel({this.system});

  SystemStreamModel copy() {
    return SystemStreamModel(
      system: system != null
          ? SystemLogicalModel(
              model: system!.model,
            )
          : null,
    );
  }
}
