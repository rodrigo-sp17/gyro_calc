import 'package:flutter_test/flutter_test.dart';
import 'package:gyro_calc/util/bearing_calc.dart';

void main() {
  test('Bearing differences are correct', () {
    var ref = 350.0;
    var hdg = 10.0;

    expect(BearingCalc.getBearingDiff(ref, hdg), equals(20.0));

    ref = 10.0;
    hdg = 350.0;

    expect(BearingCalc.getBearingDiff(ref, hdg), equals(-20.0));

    ref = 20.0;
    hdg = 30.0;

    expect(BearingCalc.getBearingDiff(ref, hdg), equals(10.0));

    ref = 30.0;
    hdg = 20.0;

    expect(BearingCalc.getBearingDiff(ref, hdg), equals(-10.0));
  });
}
