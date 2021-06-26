import 'dart:convert';

import 'package:flutter/foundation.dart';

class Beverage {
  String name, img, size;
  double price;

  Beverage({@required this.name, @required this.size, @required this.img, @required this.price});

  Beverage.fromList(List d) {
    name = d[0];
    size = d[1];
    img = 'assets/images/beverages/' + d[2];
    price = double.tryParse(d[3].toString()) ?? 0.0;
  }

  Beverage.fromJSON(String data) {
    final d = json.decode(data);
    name = d['name'];
    size = d['size'];
    img = d['img'];
    price = d['price'];
  }

  String get toJSON => json.encode({'name': name, 'size': size, 'img': img, 'price': price});

  @override
  String toString() => 'Beverage: $name | $size | $img | $price';
}
