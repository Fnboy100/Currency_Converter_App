import 'package:flutter/material.dart';
import 'package:main_file/MaterialPage/UtilityMaterialPage/change_notifier_provider.dart';
import 'package:main_file/MaterialPage/currency_converter_material_page.dart';
import 'package:main_file/api/storage/apikeys/api_config_key.dart';
import 'package:main_file/api/storage/securestorageservice.dart';
import 'package:main_file/config/appconfig.dart';
import 'package:provider/provider.dart';

void
    main() async {
  WidgetsFlutterBinding
      .ensureInitialized();

  const String
      flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'prod');
  try {
    final SecureStorageService
        secureStorage =
        SecureStorageService();
    await secureStorage.storeApiKey(ApiKeys.exchangeRateKey);
    print('Stored API key...');

    AppConfig
        config =
        await fetchAppConfig(flavor);
    print('App config fetched: ${config.apiUrl}');

    runApp(ChangeNotifierProvider(
        create: (context) => CurrencyConverterChangeProvider(),
        child: MyApp(config: config)));
  } catch (e) {
    print('Error during initialization: $e');
    // Handle initialization error, maybe display an error page
  }
}

// Type of state
// 1. StatelessWidget
// 2. StatefulWidget
// 3. InheritedWidget
// key are use to updateWidgets in the WidgetTress. Serves as a unqiue identifier.
// const use during the instantiation of class are use to create a single instance of the widget class
// design guidelines are : 1. Material design  (created by google) 2. Cupertino design (created by apple)
// Scaffold looks after the local parts while MaterialApp looks after the global part!
// BuildContext class shows the particular local of the returned widget in the WidgeTree during rendering

class MyApp
    extends StatelessWidget {
  final AppConfig
      config;

  const MyApp(
      {required this.config,
      super.key});

  @override
  Widget
      build(BuildContext context) {
    return MaterialApp(
      home: CurrencyConverterMaterialPage(
        apikey: config.apiUrl,
      ),
      title: "Real-time exchange rate of Naira to Dollar",
      theme: ThemeData.light(
        //fontFamily: "RobotoRegular",
        useMaterial3: true,
      ),
    );
  }
}
