import 'dart:async';
import 'package:flutter/material.dart';
import 'package:main_file/MaterialPage/UtilityMaterialPage/moving_text.dart';

class CurrencyConverterMaterialpageReverseConversionMaterialpage
    extends StatefulWidget {
  final double
      exchangeRate;
  final String
      currentDateTime;

  const CurrencyConverterMaterialpageReverseConversionMaterialpage(
      {super.key,
      required this.exchangeRate,
      required this.currentDateTime});

  @override
  CurrencyConverterMaterialpageReverseConversionMaterialpagestate createState() =>
      CurrencyConverterMaterialpageReverseConversionMaterialpagestate();
}

class CurrencyConverterMaterialpageReverseConversionMaterialpagestate
    extends State<CurrencyConverterMaterialpageReverseConversionMaterialpage> {
  Timer?
      resetTimer;

  double
      result =
      0.0;
  final TextEditingController
      textEditingController =
      TextEditingController();

  void
      _convertValue() {
    if (resetTimer !=
        null) {
      resetTimer!.cancel();
    }

    setState(() {
      if (textEditingController.text.isEmpty || widget.exchangeRate == 0.0) {
        result = 0.0;
        return;
      }

      try {
        double input = double.parse(textEditingController.text);
        result = input * widget.exchangeRate;
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
      body: widget.exchangeRate == 0
          ? Center(child: const CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "${widget.currentDateTime}",
                      style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 150.0,
                    ),
                    Row(
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
                          widget.exchangeRate.toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          IconData(0x20A6, fontFamily: "Roboto"),
                          size: 35.0,
                          weight: 600.00,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          result.toStringAsFixed(2),
                          style: const TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "Please enter the amount in Dollar",
                          hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                          prefixIcon: const Icon(
                            Icons.attach_money,
                            size: 25.0,
                            color: Colors.black,
                            weight: 500,
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
                      height: 300.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
