class GeneratorModel {
  String name;
  String code;
  double capacity;
  double usageRate;

  GeneratorModel({
    required this.name,
    required this.code,
    required this.capacity,
    required this.usageRate,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'capacity': capacity,
    'usageRate': usageRate,
  };

  factory GeneratorModel.fromJson(Map<String, dynamic> json) {
    return GeneratorModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      capacity: _toDouble(json['capacity']),
      usageRate: _toDouble(json['usageRate']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static double calculateRemaining({
    required double capacity,
    required double usageRate,
    required double hours,
    required double fuelAdded,
  }) {
    double used = usageRate * hours;
    return capacity - used + fuelAdded;
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 NEW: HOURS PER LITER
  ///////////////////////////////////////////////////////////
  double get hoursPerLiter => 1 / usageRate;
}
