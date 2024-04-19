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
      user: user != null
          ? UserLogicalModel(
              model: user!.model,
              recover: user!.recover != null
                  ? RecoverLogicalModel(
                      model: user!.recover!.model,
                    )
                  : null,
              personal: user!.personal != null
                  ? PersonalLogicalModel(
                      model: user!.personal!.model,
                      address: user!.personal!.address != null
                          ? AddressLogicalModel(
                              model: user!.personal!.address!.model,
                            )
                          : null,
                    )
                  : null,
            )
          : null,
    );
  }

  UserLogicalModel? getOne({int? id, String? name}) {
    if (id != null && user?.model?.id == id) {
      return user;
    } else if (name != null && user?.personal?.model?.name == name) {
      return user;
    }
    return null;
  }

  Map<int, String> getMap() {
    Map<int, String> map = {};
    map.addAll({user!.model!.id!: user!.personal!.model!.name});
    return map;
  }
}
