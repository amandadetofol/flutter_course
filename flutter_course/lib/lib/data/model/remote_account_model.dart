import 'package:flutter_course/lib/data/http/http_error.dart';
import 'package:flutter_course/lib/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel({required this.token});

  AccountEntity toEntity() => AccountEntity(token: token);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(token: json['accessToken']);
  }
}
