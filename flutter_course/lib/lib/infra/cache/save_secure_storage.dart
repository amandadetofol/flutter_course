import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage flutterSecureStorage;

  LocalStorageAdapter({required this.flutterSecureStorage});

  @override
  Future<void> saveSecure(
    String key,
    String value,
  ) async {
    await flutterSecureStorage.write(
      key: key,
      value: value,
    );
  }
}
