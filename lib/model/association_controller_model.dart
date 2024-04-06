import 'package:project_x/services/database/model/project_finance_client_model.dart';

class AssociationStreamModel {
  List<AssociationLogicalModel?>? associations;

  AssociationStreamModel({this.associations});

  AssociationStreamModel copy() {
    return AssociationStreamModel(
      associations: associations?.map((projectFinanceClient) {
        return AssociationLogicalModel(model: projectFinanceClient?.model);
      }).toList(),
    );
  }
}
