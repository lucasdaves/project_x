import 'package:project_x/services/database/model/project_finance_client_model.dart';
import 'package:project_x/utils/app_enum.dart';

class AssociationStreamModel {
  EntityStatus status;

  List<AssociationLogicalModel?>? associations;

  AssociationStreamModel({this.status = EntityStatus.Idle, this.associations});

  AssociationStreamModel copy() {
    return AssociationStreamModel(
      associations: this.associations?.map((association) {
        return AssociationLogicalModel(model: association?.model?.copy());
      }).toList(),
    );
  }

  List<AssociationLogicalModel?> getAll() {
    AssociationStreamModel aux = copy();
    return aux.associations ?? [];
  }

  AssociationLogicalModel? getOne({
    int? id,
    int? projectId,
    int? clientId,
    int? financeId,
  }) {
    AssociationStreamModel aux = copy();
    for (AssociationLogicalModel? entity in aux.associations ?? []) {
      if (id != null && entity?.model?.id == id) {
        return entity;
      } else if (projectId != null && entity?.model?.clientId == projectId) {
        return entity;
      } else if (clientId != null && entity?.model?.clientId == clientId) {
        return entity;
      } else if (financeId != null && entity?.model?.financeId == financeId) {
        return entity;
      }
    }
    return null;
  }

  Map<int, String> getMap() {
    AssociationStreamModel aux = copy();
    Map<int, String> map = {};
    for (AssociationLogicalModel? entity in aux.associations ?? []) {
      map.addAll({entity!.model!.id!: ""});
    }
    return map;
  }
}
