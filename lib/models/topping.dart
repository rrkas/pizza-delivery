class Topping {
  static int _count = 0;

  int id;
  String name, desc, imgFileName;
  double priceINR;

  Topping({this.name, this.desc, this.priceINR, this.imgFileName}) {
    id = ++_count;
  }

  Topping.fromList(List d) {
    id = ++_count;
    name = d[0];
    desc = d[1];
    imgFileName = 'assets/images/toppings/' + d[2];
    priceINR = double.tryParse(d[3].toString());
  }

  @override
  String toString() => 'Topping($id): $name | $desc | $imgFileName | $priceINR';
}
