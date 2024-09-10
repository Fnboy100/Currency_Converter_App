
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:main_file/api/storage/apikeys/api_config_key.dart';

class SecureStorageService {
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  
  Future<void> storeApiKey(String key) async {
    await _storage.write(key: 'api_exchangerate_key', value: ApiKeys.exchangeRateKey);
  }

  
  Future<String?> retrieveApiKey() async {
    return await _storage.read(key: 'api_exchangerate_key');
  }

  
  Future<void> deleteApiKey() async {
    await _storage.delete(key: 'api_exchangerate_key');
  }
}