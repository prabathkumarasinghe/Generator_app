class Generator {
  String name;
  String code;
  double capacity;
  double usageRate;

  Generator({
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

  factory Generator.fromJson(Map<String, dynamic> json) {
    return Generator(
      name: json['name'],
      code: json['code'],
      capacity: json['capacity'],
      usageRate: json['usageRate'],
    );
  }
}