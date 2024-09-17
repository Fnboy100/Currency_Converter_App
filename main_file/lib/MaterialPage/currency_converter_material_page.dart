import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:main_file/MaterialPage/UtilityMaterialPage/change_notifier_provider.dart';
import 'package:main_file/MaterialPage/currency_converter_materialpage_reverse_conversion_materialpage.dart';
import 'package:main_file/api/get_exchangerate.dart';
import 'package:main_file/MaterialPage/UtilityMaterialPage/moving_text.dart';
import 'package:provider/provider.dart';

class CurrencyConverterMaterialPage
    extends StatefulWidget {
  final String
      apikey;
  const CurrencyConverterMaterialPage(
      {super.key,
      required this.apikey});
  @override
  CurrencyConverterMaterialPageState createState() =>
      CurrencyConverterMaterialPageState();
}

class CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  late GetExchangeRateData
      getExchangeRateData;

  double
      result =
      0.0;
  final TextEditingController
      textEditingController =
      TextEditingController();

  Timer?
      resetTimer;
  Timer?
      updateTimer;
  Timer?
      dateTimeTimer;

  final Logger
      logger =
      Logger(
    printer:
        PrettyPrinter(),
  );

  @override
  void
      initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDateTime();
    });
    _startDateTimeUpdate();
  }

  void
      _setDateTime() {
    DateTime
        now =
        DateTime.now().toLocal();
    DateFormat
        formatter =
        DateFormat('d MMMM, yyyy');
    String
        initialDateTime =
        formatter.format(now);

    Provider.of<CurrencyConverterChangeProvider>(context, listen: false).updateDateTime(initialDateTime);

    _initializeTimer();
  }

  void
      _startDateTimeUpdate() {
    dateTimeTimer =
        Timer.periodic(const Duration(hours: 23), (Timer timer) {
      _setDateTime();
    });
  }

  void
      _initializeTimer() async {
    await _updateExchangeRate();

    _scheduleUpdateAtMidnightGMT();
  }

  void
      _scheduleUpdateAtMidnightGMT() {
    DateTime
        now =
        DateTime.now().toUtc();
    DateTime
        nextMidnight =
        DateTime(now.year, now.month, now.day + 1);
    Duration
        timeUntilMidnight =
        nextMidnight.difference(now);

    updateTimer =
        Timer(timeUntilMidnight, () async {
      await _updateExchangeRate();

      updateTimer = Timer.periodic(const Duration(minutes: 24), (Timer timer) async {
        await _updateExchangeRate();
      });
    });
  }

  Future<void>
      _updateExchangeRate() async {
    try {
      getExchangeRateData = GetExchangeRateData(widget.apikey);
      double updatedRate = await getExchangeRateData.fetchExchangeRate();

      if (Provider.of<CurrencyConverterChangeProvider>(context, listen: false).exchangeRate != updatedRate) {
        Provider.of<CurrencyConverterChangeProvider>(context, listen: false).updateExchangeRate(updatedRate);
      }
    } catch (e) {
      logger.e("Error fetching exchange rate: $e");
    }
  }

  void
      _convertValue() {
    if (resetTimer !=
        null) {
      resetTimer!.cancel();
    }

    setState(() {
      if (textEditingController.text.isEmpty || Provider.of<CurrencyConverterChangeProvider>(context, listen: false).exchangeRate == 0.0) {
        result = 0.0;
        return;
      }

      try {
        double input = double.parse(textEditingController.text);
        result = input / Provider.of<CurrencyConverterChangeProvider>(context, listen: false).exchangeRate;
      } catch (e) {
        result = 0.0;
      }

      resetTimer = Timer(const Duration(seconds: 30), () {
        setState(() {
          result = 0.0;
        });
      });
    });
  }

  @override
  void
      dispose() {
    resetTimer?.cancel();
    updateTimer?.cancel();
    dateTimeTimer?.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget
      build(BuildContext context) {
    final border =
        OutlineInputBorder(borderSide: const BorderSide(color: Colors.blueGrey, width: 3, style: BorderStyle.solid), borderRadius: BorderRadius.circular(10));

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        title: MovingText(),
        centerTitle: true,
      ),
      body: Provider.of<CurrencyConverterChangeProvider>(context).exchangeRate == 0
          ? Center(child: const CircularProgressIndicator.adaptive())
          : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  Consumer<CurrencyConverterChangeProvider>(builder: (context, updatedDateTimeProvider, child) {
                    return Text(
                      "${updatedDateTimeProvider.updatedTime}",
                      style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w800),
                    );
                  }),
                  const SizedBox(
                    height: 150.0,
                  ),
                  Consumer<CurrencyConverterChangeProvider>(
                    builder: (context, exchangeRateProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '1 \$ = ',
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            const IconData(0x20A6, fontFamily: "Roboto"),
                            size: 18,
                            color: Colors.white,
                          ),
                          Text(
                            exchangeRateProvider.exchangeRate.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Center(
                    child: Text(
                      "Exchange rate are updated every 00.00 GMT",
                      style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '\$ ',
                          style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: result.toStringAsFixed(2),
                          style: const TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "Please enter the amount in Naira",
                        hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(
                          IconData(0x20A6, fontFamily: "Roboto"),
                          size: 20,
                        ),
                        prefixIconColor: Colors.black,
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _convertValue();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 15.0,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Convert",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(
                    height: 100.0,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CurrencyConverterMaterialpageReverseConversionMaterialpage(
                                          exchangeRate: Provider.of<CurrencyConverterChangeProvider>(context).exchangeRate,
                                          currentDateTime: Provider.of<CurrencyConverterChangeProvider>(context).updatedTime,
                                        )));
                          });
                        },
                        child: Text(
                          "Click for reverse conversion",
                          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, fontFamily: "RobotoRegular", color: Colors.black),
                        )),
                  ),
                  const SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
