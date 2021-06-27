import 'package:flutter/foundation.dart';

class Beverage {
  static int _count = 0;

  int id;
  String name, img, size;
  double priceINR;

  Beverage({@required this.name, @required this.size, @required this.img, @required this.priceINR}) {
    id = ++_count;
  }

  Beverage.fromList(List d) {
    id = ++_count;
    name = d[0];
    size = d[1];
    img = 'assets/images/beverages/' + d[2];
    priceINR = double.tryParse(d[3].toString()) ?? 0.0;
  }

  @override
  String toString() => 'Beverage($id): $name | $size | $img | $priceINR';
}
