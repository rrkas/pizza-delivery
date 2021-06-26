import 'dart:convert';

class Topping {
  String name, desc, imgFileName;
  double price;

  Topping({this.name, this.desc, this.price, this.imgFileName});

  Topping.fromList(List d) {
    name = d[0];
    desc = d[1];
    imgFileName = 'assets/images/toppings/' + d[2];
    price = double.tryParse(d[3].toString());
  }

  Topping.fromJSON(String data) {
    final d = json.decode(data);
    name = d['name'];
    desc = d['desc'];
    imgFileName = d['imgFileName'];
    price = d['price'];
  }

  String get toJSON => json.encode({'name': name, 'desc': desc, 'imgFileName': imgFileName, 'price': price});

  @override
  String toString() => 'Topping: $name | $desc | $imgFileName | $price';
}
