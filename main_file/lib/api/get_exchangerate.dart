import 'dart:convert';
import 'package:http/http.dart'
    as http;
import 'package:logger/logger.dart';

class GetExchangeRateData {
  final Logger
      logger =
      Logger(
    printer:
        PrettyPrinter(), // Log with colors and timestamp
  );

  Future<double>
      fetchExchangeRate() async {
    dynamic
        exchangeRate;
    try {
      final response = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/60a164d0fcf7dd8e0e6bfafb//pair/USD/NGN'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logger.i(data);
        exchangeRate = data['conversion_rate'];
      } else {
        logger.e("Failed to load exchange rate, response code:${response.statusCode}");
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      logger.wtf("Find above for the error details:", [
        e
      ]);
    }

    return exchangeRate ?? 0.0;
  }
}
