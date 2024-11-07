import 'package:flutter_course/lib/domain/usecases/load_current_account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../data/usecases/usecases.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
      fetchSecureCacheStorage: LocalStorageAdapter(
          flutterSecureStorage: const FlutterSecureStorage()));
}
