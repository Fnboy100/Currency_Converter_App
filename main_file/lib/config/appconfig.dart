import 'package:logger/logger.dart';
import 'package:main_file/api/storage/securestorageservice.dart';

class AppConfig {
  final String
      apiUrl;

  AppConfig(
      {required this.apiUrl});
}

Future<AppConfig>
    fetchAppConfig(String flavor) async {
  final Logger
      logger =
      Logger(
    printer:
        PrettyPrinter(),
  );

  final SecureStorageService
      secureStorage =
      SecureStorageService();

  
  String?
      apiKey;
  switch (
      flavor) {
    case 'dev':
      apiKey = await secureStorage.retrieveApiKey();
      break;
    case 'staging':
      apiKey = await secureStorage.retrieveApiKey();
      break;
    case 'prod':
      apiKey = await secureStorage.retrieveApiKey();
      break;
    default:
      throw Exception('Invalid flavor: $flavor');
  }

  String
      apiUrl;
  if (apiKey !=
      null) {
    apiUrl =
        'https://v6.exchangerate-api.com/v6/$apiKey/pair/USD/NGN';
  } else {
    apiUrl =
        '';
    logger.e("NO API KEY FOUND!");
  }

  return AppConfig(
      apiUrl: apiUrl);
}
