import 'package:project_x/services/database/model/finance_model.dart';
import 'package:project_x/services/database/model/finance_operation_model.dart';
import 'package:project_x/utils/app_enum.dart';

class FinanceStreamModel {
  EntityStatus status;
  List<FinanceLogicalModel?>? finances;

  FinanceStreamModel({this.status = EntityStatus.Idle, this.finances});

  FinanceStreamModel copy() {
    return FinanceStreamModel(
      finances: finances?.map((finance) {
        return FinanceLogicalModel(
          model: finance?.model,
          operations: finance?.operations?.map((operation) {
            return FinanceOperationLogicalModel(model: operation?.model);
          }).toList(),
        );
      }).toList(),
    );
  }
}
