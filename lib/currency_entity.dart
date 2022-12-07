class CurrencyEntity {
  final String charCode;
  final int nominal;
  final String name;
  final double value;
  final double previous;

  const CurrencyEntity({
    required this.charCode,
    required this.nominal,
    required this.name,
    required this.value,
    required this.previous,
  });

  factory CurrencyEntity.fromJson(Map<String, dynamic> json) {
    return CurrencyEntity(
      charCode: json['CharCode'] as String,
      nominal: json['Nominal'] as int,
      name: json['Name'] as String,
      value: json['Value'] as double,
      previous: json['Previous'] as double,
    );
  }
}
