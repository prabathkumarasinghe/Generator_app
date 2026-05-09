import 'package:flutter_test/flutter_test.dart';

///////////////////////////////////////////////////////////
/// FUEL CALCULATION FUNCTION
///////////////////////////////////////////////////////////
double calculateRemainingFuel({
  required double capacity,
  required double usageRate,
  required double hours,
  required double fuelAdded,
}) {
  double usedFuel = usageRate * hours;
  return capacity - usedFuel + fuelAdded;
}

///////////////////////////////////////////////////////////
/// UNIT TEST
///////////////////////////////////////////////////////////
void main() {
  test('Fuel calculation test', () {

    double result = calculateRemainingFuel(
      capacity: 100,
      usageRate: 10,
      hours: 5,
      fuelAdded: 20,
    );

    expect(result, 70);

  });
}