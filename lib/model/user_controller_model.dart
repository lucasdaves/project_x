import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/services/database/model/user_model.dart';
import 'package:project_x/utils/app_enum.dart';

class UserStreamModel {
  EntityStatus status;
  UserLogicalModel? user;

  UserStreamModel({this.status = EntityStatus.Idle, this.user});

  UserStreamModel copy() {
    return UserStreamModel(
      status: status,
      user: user != null
          ? UserLogicalModel(
              model: user!.model?.copy(),
              recover: user!.recover != null
                  ? RecoverLogicalModel(model: user!.recover!.model?.copy())
                  : null,
              personal: user!.personal != null
                  ? PersonalLogicalModel(
                      model: user!.personal!.model?.copy(),
                      address: user!.personal!.address != null
                          ? AddressLogicalModel(
                              model: user!.personal!.address!.model?.copy())
                          : null,
                    )
                  : null,
            )
          : null,
    );
  }

  UserLogicalModel? getOne({int? id, String? name}) {
    UserStreamModel aux = copy();
    if (id != null && aux.user?.model?.id == id) {
      return aux.user;
    } else if (name != null && aux.user?.personal?.model?.name == name) {
      return aux.user;
    }
    return null;
  }

  Map<int, String> getMap() {
    UserStreamModel aux = copy();
    Map<int, String> map = {};
    map.addAll({aux.user!.model!.id!: aux.user!.personal!.model!.name});
    return map;
  }
}
