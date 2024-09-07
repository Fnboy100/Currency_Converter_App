import 'dart:async';
import 'package:flutter/material.dart';
import 'package:main_file/api/get_exchangerate.dart';
import 'package:main_file/MaterialPage/UtilityMaterialPage/moving_text.dart';

class CurrencyConverterMaterialPage
    extends StatefulWidget {
  final String
      apikey;
  const CurrencyConverterMaterialPage(
      {super.key,
      required this.apikey});
  @override
  CurrencyConverterMaterialPageState
      createState() =>
    CurrencyConverterMaterialPageState();
  
}

class CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {

  late GetExchangeRateData
      getExchangeRateData;

  double
      exchangeRate =
      0.0;

  double
      result =
      0.0;

  final TextEditingController
      textEditingController =
      TextEditingController();

  Timer?
      resetTimer;

      @override
  void initState() {
    super.initState();
    getExchangeRateData = GetExchangeRateData(widget.apikey);
  }

  void
      _convertValue() async {
    double
        rate =
        await getExchangeRateData.fetchExchangeRate();
    exchangeRate =
        rate;

    if (resetTimer !=
        null) {
      resetTimer!.cancel();
    }

    setState(() {
      if (textEditingController.text.isEmpty || exchangeRate == 0.0) {
        result = 0.0;
        return;
      }

      try {
        double input = double.parse(textEditingController.text);
        result = input / exchangeRate;
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
        backgroundColor: Colors.white38,
        elevation: 10,
        title: MovingText(),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.only(right: 1.0),
                      child: const Icon(Icons.attach_money, size: 35, color: Colors.white),
                    ),
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                  ),
                  TextSpan(
                    text: result.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Please enter the amount in Naira",
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: const Icon(
                    IconData(0x20A6, fontFamily: "RalewayVariable"),
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
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
