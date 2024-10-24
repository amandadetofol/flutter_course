import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/cache.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  const storage = FlutterSecureStorage();

  return LocalStorageAdapter(
    flutterSecureStorage: storage,
  );
}
