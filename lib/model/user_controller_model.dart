import 'package:project_x/services/database/model/address_model.dart';
import 'package:project_x/services/database/model/personal_model.dart';
import 'package:project_x/services/database/model/recover_model.dart';
import 'package:project_x/services/database/model/user_model.dart';

class UserStreamModel {
  UserLogicalModel? user;

  UserStreamModel({this.user});

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
}
