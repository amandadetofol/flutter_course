import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../cache/cache.dart';

class LocalStorageAdapter
    implements SaveSecureCacheStorage, FetchSecureCacheStorage {
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

  @override
  Future<String> fetchSecure(String key) async {
    final response = await flutterSecureStorage.read(key: key);

    if (response?.isNotEmpty ?? false) {
      return response!;
    }
    return 'error';
  }
}
