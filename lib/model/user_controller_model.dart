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

class UserLogicalModel {
  UserDatabaseModel? model;
  RecoverLogicalModel? recover;
  PersonalLogicalModel? personal;

  UserLogicalModel({this.model, this.recover, this.personal});
}

class RecoverLogicalModel {
  RecoverDatabaseModel? model;

  RecoverLogicalModel({this.model});
}

class PersonalLogicalModel {
  PersonalDatabaseModel? model;
  AddressLogicalModel? address;

  PersonalLogicalModel({this.model, this.address});
}

class AddressLogicalModel {
  AddressDatabaseModel? model;

  AddressLogicalModel({this.model});
}
