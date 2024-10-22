import 'package:flutter_course/lib/data/cache/cache.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveCacheStorage;

  LocalSaveCurrentAccount({required this.saveCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      saveCacheStorage.saveSecure(
        key: 'token',
        value: account.token,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
