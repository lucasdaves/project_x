import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/client_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';

class ClientStreamModel {
  List<ClientLogicalModel?>? clients;

  ClientStreamModel({this.clients});

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
}