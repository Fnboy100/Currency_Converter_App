
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  
  Future<void> storeApiKey() async {
    await _storage.write(key: 'api_exchangerate_key', value: '60a164d0fcf7dd8e0e6bfafb');
  }

  
  Future<String?> retrieveApiKey() async {
    return await _storage.read(key: 'api_exchangerate_key');
  }

  
  Future<void> deleteApiKey() async {
    await _storage.delete(key: 'api_exchangerate_key');
  }
}