import '../../../../data/usecases/save_secure_cache_storage/save_secure_cache_stoage_impl.dart';

import '../../../../domain/usecases/usecases.dart';
import '../../factoys.dart';

SaveCurrentAccount makeSaveCurrentAccount() {
  final localSaveCurrentAccount = LocalSaveCurrentAccount(
    saveCacheStorage: makeLocalStorageAdapter(),
  );

  return localSaveCurrentAccount;
}
