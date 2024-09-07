import 'package:flutter/material.dart';
import 'package:main_file/MaterialPage/currency_converter_material_page.dart';
import 'package:main_file/api/storage/securestorageservice.dart';
import 'package:main_file/config/appconfig.dart';

void
    main() async {
  const String
      flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'prod');
      
      final SecureStorageService
      secureStorage =
      SecureStorageService();
  await secureStorage.storeApiKey();

  AppConfig
      config =
      await fetchAppConfig(flavor);

  runApp(
      MyApp(config: config));
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
    );
  }
}
