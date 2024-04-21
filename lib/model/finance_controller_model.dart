import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/utils/app_enum.dart';

class FinanceStreamModel {
  EntityStatus status;
  List<FinanceLogicalModel?>? finances;

  FinanceStreamModel({this.status = EntityStatus.Idle, this.finances});

  FinanceStreamModel copy() {
    return FinanceStreamModel(
      status: this.status,
      finances: this.finances?.map((finance) => finance?.copy()).toList(),
    );
  }

  List<FinanceLogicalModel?> getAll() {
    FinanceStreamModel aux = copy();
    return aux.finances ?? [];
  }

  FinanceLogicalModel? getOne({int? id, String? name}) {
    FinanceStreamModel aux = copy();
    for (FinanceLogicalModel? entity in aux.finances ?? []) {
      if (id != null && entity?.model?.id == id) {
        return entity;
      } else if (name != null && entity?.model?.name == name) {
        return entity;
      }
    }
    return null;
  }

  Map<int, String> getMap() {
    FinanceStreamModel aux = copy();
    Map<int, String> map = {};
    for (FinanceLogicalModel? entity in aux.finances ?? []) {
      map.addAll({entity!.model!.id!: entity.model!.name!});
    }
    return map;
  }
}
