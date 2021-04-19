import 'package:validate/validate.dart';

class BearingCalc {
  /// Gets the bearing diff between a [ref] reference and a [hdg] heading
  ///
  /// Positive results are E deviations, negative are W
  static double getBearingDiff(double ref, double hdg) {
    Validate.inclusiveBetween(0, 360, ref);
    Validate.inclusiveBetween(0, 360, hdg);

    // 350 and 10 -> diff = 340, exp -20
    var diff = hdg - ref;
    return diff.abs() > 180 ? (360 - diff.abs()) * (-1 * diff.sign) : diff;
  }
}
