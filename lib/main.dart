import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kpr_flutter_project/general_entity.dart';
import 'package:kpr_flutter_project/utils.dart';
import 'package:pie_chart/pie_chart.dart';

import 'arrow_canvas.dart';

const colorList = <Color>[
  Colors.greenAccent,
  Colors.redAccent,
  Colors.lightBlueAccent
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Курс Валют',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Курс Валют'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late GeneralEntity generalEntity;

  Utils utils = Utils();
  List<DropdownMenuItem<String>> allDropDownCurrencies = [];

  String? newCurrencyValue;
  String? currencySelected;
  int? currencySelectedNominal;
  String? currencyNominalToShow;


  List<double> splittedCurrenciesCount = [];
  String? pros;
  String? cons;
  String? equals;

  void showSplittedCurrencies(List<List<String>> splittedCurrencies){
    pros = utils.getCurrencyNamesFromList(splittedCurrencies[0]);
    cons = utils.getCurrencyNamesFromList(splittedCurrencies[1]);
    equals = utils.getCurrencyNamesFromList(splittedCurrencies[2]);
  }

  GeneralEntity prepareData(String responseBody) {
    // сериализация
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    generalEntity = GeneralEntity.fromJson(parsed);

    // разделение курсов
    List<List<String>> splittedCurrencies =
        utils.getCurrenciesByDynamics(generalEntity.valute);
    for (var separated in splittedCurrencies) {
      splittedCurrenciesCount.add(separated.length.toDouble());
    }

    allDropDownCurrencies = utils.getCurrenciesForDropDown(generalEntity.valute);

    showSplittedCurrencies(splittedCurrencies);

    return generalEntity;
  }

  Future<GeneralEntity> fetchCurrencies() async {
    final response = await http.Client()
        .get(Uri.parse('https://www.cbr-xml-daily.ru/daily_json.js'));
    return prepareData(response.body);
  }

  void isCurrencySelected(String value) {
    setState(() {
      currencySelected = value;
      if (currencySelectedNominal != null) {
        currencyNominalToShow = utils.showNominalCurrency(
            currencySelectedNominal, generalEntity.valute[currencySelected]);
      }
    });
  }

  void nominalChanged(String nominal_) {
    if (nominal_.isEmpty || currencySelected == null) {
      setState(() {
        currencySelectedNominal = null;
      });
      return;
    }
    setState(() {
      currencySelectedNominal = int.parse(nominal_);

      currencyNominalToShow = utils.showNominalCurrency(
          currencySelectedNominal, generalEntity.valute[currencySelected]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<GeneralEntity>(
        future: fetchCurrencies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Center(
                child: Container(
              width: 400,
              padding: EdgeInsets.only(top: 15.0),
              child: Column(
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        'Валюта:',
                      )),
                  DropdownButton(
                    value: currencySelected,
                    items: allDropDownCurrencies,
                    onChanged: (Object? value) {
                      isCurrencySelected(value as String);
                    },
                  ),
                  if (currencySelected != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                            'Валюта: ${snapshot.data!.valute[currencySelected]?.name}')),
                  Padding(
                      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (Object? value) {
                          nominalChanged(value as String);
                        },
                        decoration: const InputDecoration(
                            label: Center(
                          child: Text("Номинал"),
                        )),
                      )),
                  if (currencySelectedNominal != null &&
                      currencySelectedNominal != 0 &&
                      currencyNominalToShow != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Text(currencyNominalToShow!)),
                  if (currencySelected != null)
                    const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text("Динамика по сравнению с прошлым днем:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                  if (currencySelected != null)
                    CustomPaint(
                      size: const Size(100, 100),
                      painter: ArrowPainter(
                          currentAmount:
                              snapshot.data!.valute[currencySelected]!.value,
                          previousAmount: snapshot
                              .data!.valute[currencySelected]!.previous),
                    ),
                  const Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text('Статистика валют:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: PieChart(
                        dataMap: {
                          "Increase": splittedCurrenciesCount[0],
                          "Decrease": splittedCurrenciesCount[1],
                          "Equels": splittedCurrenciesCount[2],
                        },
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: 100,
                        colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: true,
                          decimalPlaces: 0,
                        ),
                      )),
                  if (pros != null && pros!.isNotEmpty)
                    Text(
                      'Валюты с положительной динамикой: $pros',
                    ),
                  if (cons != null && cons!.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Валюты с отрицательной динамикой: $cons',
                        )),
                  if (equals != null && equals!.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Валюты с отрицательной динамикой: $equals',
                        )),
                ],
              ),
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
