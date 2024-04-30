import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/project_finance_client_model.dart';
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

  List<FinanceLogicalModel?> getAllAssociation({int? associationIndex}) {
    FinanceStreamModel aux = copy();

    aux.finances?.removeWhere((element) {
      for (AssociationLogicalModel? association
          in AssociationController.instance.stream.value.getAll()) {
        if (associationIndex != null &&
            associationIndex == element?.model?.id) {
          return false;
        }
        if (association?.model?.financeId == element?.model?.id) {
          return true;
        }
      }
      return false;
    });

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
