import 'package:flutter_test/flutter_test.dart';
import 'package:gyro_calc/data/lat_long.dart';

var ne = LatLong(1, 1.1, 2, 2.2);
var nw = LatLong(1, 1.1, -3, 3.3);
var se = LatLong(-4, 4.4, 2, 2.2);
var sw = LatLong(-4, 4.4, -3, 3.3);
var zero = LatLong(0, 0, 0, 0);

var dne = LatLong.fromDoubles(1.1, 2.2);
var dnw = LatLong.fromDoubles(1.1, -3.3);
var dse = LatLong.fromDoubles(-4.4, 2.2);
var dsw = LatLong.fromDoubles(-4.4, -3.3);
var dzero = LatLong.fromDoubles(0, 0);

main() {
  test("Constructor keeps signs", (){
    expect(ne.latSign, equals(LatSign.N));
    expect(ne.longSign, equals(LongSign.E));
    expect(nw.latSign, equals(LatSign.N));
    expect(nw.longSign, equals(LongSign.W));
    expect(se.latSign, equals(LatSign.S));
    expect(se.longSign, equals(LongSign.E));
    expect(sw.latSign, equals(LatSign.S));
    expect(sw.longSign, equals(LongSign.W));
    expect(zero.latSign, equals(LatSign.N));
    expect(zero.longSign, equals(LongSign.E));
  });

  test("FromDoubles keeps signs", (){
    expect(dne.latSign, equals(LatSign.N));
    expect(dne.longSign, equals(LongSign.E));
    expect(dnw.latSign, equals(LatSign.N));
    expect(dnw.longSign, equals(LongSign.W));
    expect(dse.latSign, equals(LatSign.S));
    expect(dse.longSign, equals(LongSign.E));
    expect(dsw.latSign, equals(LatSign.S));
    expect(dsw.longSign, equals(LongSign.W));
    expect(dzero.latSign, equals(LatSign.N));
    expect(dzero.longSign, equals(LongSign.E));
  });

  test("Decimal results agree to constructor sign", (){
    expect(ne.getLatDecimal().isNegative, equals(false));
    expect(ne.getLongDecimal().isNegative, equals(false));
    expect(nw.getLatDecimal().isNegative, equals(false));
    expect(nw.getLongDecimal().isNegative, equals(true));
    expect(se.getLatDecimal().isNegative, equals(true));
    expect(se.getLongDecimal().isNegative, equals(false));
    expect(sw.getLatDecimal().isNegative, equals(true));
    expect(sw.getLongDecimal().isNegative, equals(true));
    expect(zero.getLatDecimal().isNegative, equals(false));
    expect(zero.getLongDecimal().isNegative, equals(false));
  });

  test("Change lat signs", () {
    var coord = LatLong.fromDoubles(1, 1);
    expect(coord.latSign, equals(LatSign.N));
    expect(coord.getLatDecimal().isNegative, equals(false));
    expect(coord.longSign, equals(LongSign.E));
    expect(coord.getLongDecimal().isNegative, equals(false));

    coord.latSign = LatSign.S;
    expect(coord.latSign, equals(LatSign.S));
    expect(coord.getLatDecimal().isNegative, equals(true));
    expect(coord.longSign, equals(LongSign.E));
    expect(coord.getLongDecimal().isNegative, equals(false));
  });

  test("Change long signs", () {
    var coord = LatLong.fromDoubles(1, 1);
    expect(coord.latSign, equals(LatSign.N));
    expect(coord.getLatDecimal().isNegative, equals(false));
    expect(coord.longSign, equals(LongSign.E));
    expect(coord.getLongDecimal().isNegative, equals(false));

    coord.longSign = LongSign.W;
    expect(coord.latSign, equals(LatSign.N));
    expect(coord.getLatDecimal().isNegative, equals(false));
    expect(coord.longSign, equals(LongSign.W));
    expect(coord.getLongDecimal().isNegative, equals(true));
  });
}