import 'dart:convert';

class Pizza {
  String name, desc, imgFile;
  bool veg;
  double priceINR;

  Pizza({this.desc, this.name, this.imgFile, this.priceINR, this.veg});

  Pizza.fromList(List data) {
    name = data[0];
    desc = data[1];
    imgFile = 'assets/images/pizzas/' + data[2];
    veg = data[3] == 'true';
    priceINR = double.tryParse(data[4].toString()) ?? 0.0;
  }

  Pizza.fromJSON(String d) {
    final data = json.decode(d);
    name = data['name'];
    desc = data['desc'];
    imgFile = data['imgFile'];
    veg = data['veg'];
    priceINR = data['priceINR'];
  }

  String get toJsonMap => json.encode({'name': name, 'desc': desc, 'imgFile': imgFile, 'veg': veg, 'priceINR': priceINR});

  @override
  String toString() => 'Pizza: $name | $imgFile | $priceINR | $veg';
}
