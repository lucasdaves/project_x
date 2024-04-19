import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/utils/app_enum.dart';

class ClientStreamModel {
  EntityStatus status;
  List<ClientLogicalModel?>? clients;

  ClientStreamModel({this.status = EntityStatus.Idle, this.clients});

  ClientStreamModel copy() {
    return ClientStreamModel(
      clients: clients?.map((client) {
        return ClientLogicalModel(
          model: client?.model,
          personal: client?.personal != null
              ? PersonalLogicalModel(
                  model: client?.personal?.model,
                  address: client?.personal?.address != null
                      ? AddressLogicalModel(
                          model: client?.personal?.address?.model,
                        )
                      : null,
                )
              : null,
        );
      }).toList(),
    );
  }

  List<ClientLogicalModel?> getAll() {
    return clients ?? [];
  }

  ClientLogicalModel? getOne({int? id, String? name}) {
    for (ClientLogicalModel? entity in clients ?? []) {
      if (id != null && entity?.model?.id == id) {
        return entity;
      } else if (name != null && entity?.personal?.model?.name == name) {
        return entity;
      }
    }
    return null;
  }

  Map<int, String> getMap() {
    Map<int, String> map = {};
    for (ClientLogicalModel? entity in clients ?? []) {
      map.addAll({entity!.model!.id!: entity.personal!.model!.name});
    }
    return map;
  }
}
