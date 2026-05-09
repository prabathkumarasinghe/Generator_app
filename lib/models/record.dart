class Record {
  String generator;
  double hours;
  double fuelAdded;
  double fuelUsed; // NEW
  String date;

  Record({
    required this.generator,
    required this.hours,
    required this.fuelAdded,
    required this.fuelUsed,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'generator': generator,
    'hours': hours,
    'fuelAdded': fuelAdded,
    'fuelUsed': fuelUsed,
    'date': date,
  };

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      generator: json['generator'] ?? '',
      hours: _toDouble(json['hours']),
      fuelAdded: _toDouble(json['fuelAdded']),
      fuelUsed: _toDouble(
        json['fuelUsed'],
      ), // Handle old records without fuelUsed
      date: json['date'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
