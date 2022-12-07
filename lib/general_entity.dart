import 'package:kpr_flutter_project/currency_entity.dart';

class GeneralEntity {
  final  Map<String,CurrencyEntity> valute;
  final String date;
  final String previousDate;

  const GeneralEntity({
    required this.valute,
    required this.date,
    required this.previousDate,
  });


  factory GeneralEntity.fromJson(Map<String, dynamic> json) {
    Map<String,CurrencyEntity> newValute = {};
    Map.from(json['Valute']).forEach((k,v) => newValute[k]=CurrencyEntity.fromJson(v));
    return GeneralEntity(
      valute: newValute,
      date: json['Date'] as String,
      previousDate: json['PreviousDate'] as String,
    );
  }
}