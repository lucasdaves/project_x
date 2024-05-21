import 'package:project_x/controller/association_controller.dart';
import 'package:project_x/controller/finance_controller.dart';
import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/project_finance_client_model.dart';
import 'package:project_x/utils/app_enum.dart';
import 'package:project_x/utils/app_extension.dart';

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

  void filter() {
    if (this.finances != null) {
      this.finances!.sort((a, b) {
        if (a?.operations != null && b?.operations != null) {
          DateTime? actionA = a?.getLastActionDate().formatDatetime();
          DateTime? actionB = b?.getLastActionDate().formatDatetime();

          if (actionA == null) return 1;
          if (actionB == null) return -1;

          return actionA.compareTo(actionB);
        }
        return 0;
      });
    }
  }

  List<FinanceLogicalModel?>? getSearched() {
    List<FinanceLogicalModel?>? filtered = (this.finances ?? []).where(
      (element) {
        String modelValue = element!.model!.name!.toLowerCase();
        String searchValue =
            FinanceController.instance.search.text.toLowerCase();
        return modelValue.contains(searchValue);
      },
    ).toList();
    return filtered;
  }

  List<FinanceLogicalModel?>? getAssociated(int index) {
    FinanceStreamModel aux = copy();
    List<AssociationLogicalModel?> associations =
        AssociationController.instance.stream.value.getAllClient(index);
    aux.finances?.removeWhere((element) => !associations
        .map((e) => e?.model?.projectId)
        .contains(element?.model?.id));
    return aux.finances;
  }

  Map<List<String>, List<double>> getReport() {
    FinanceStreamModel aux = copy();
    Map<List<String>, List<double>> map = {};
    try {
      double totalPaid = 0;
      double totalToPay = 0;
      double totalLate = 0;

      for (FinanceLogicalModel? entity in aux.finances ?? []) {
        entity?.operations?.removeWhere((element) {
          bool inInterval;
          if (element?.model?.concludedAt != null ||
              element?.model?.expiresAt != null) {
            if (element?.model?.concludedAt != null) {
              inInterval = FinanceController.instance.reportMinDate!
                      .isBefore(element!.model!.concludedAt!) &&
                  FinanceController.instance.reportMaxDate!
                      .isAfter(element.model!.concludedAt!);
            } else if (element?.model?.expiresAt != null) {
              inInterval = FinanceController.instance.reportMinDate!
                      .isBefore(element!.model!.expiresAt!) &&
                  FinanceController.instance.reportMaxDate!
                      .isAfter(element.model!.expiresAt!);
            } else {
              inInterval = false;
            }
          } else {
            inInterval = false;
          }

          return !inInterval;
        });

        double paid = entity?.getPaidAmount().entries.first.value ?? 0;
        double toPay = entity?.getToPayAmount().entries.first.value ?? 0;
        double late = entity?.getLateAmount().entries.first.value ?? 0;

        if (paid > 0 || toPay > 0 || late > 0) {
          map[["${entity?.model?.name}"]] = [paid, toPay, late];
          totalPaid = totalPaid + paid;
          totalToPay = totalToPay + toPay;
          totalLate = totalLate + late;
        }
      }

      if (totalPaid > 0 || totalToPay > 0 || totalLate > 0) {
        map[["Total"]] = [totalPaid, totalToPay, totalLate];
      }
    } catch (_) {}

    return map;
  }
}
