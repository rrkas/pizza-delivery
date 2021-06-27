class Pizza {
  static int _count = 0;

  int id;
  String name, desc, imgFile;
  bool veg;
  double priceINR;

  Pizza({this.desc, this.name, this.imgFile, this.priceINR, this.veg}) {
    id = ++_count;
  }

  Pizza.fromList(List data) {
    id = ++_count;
    name = data[0].toString().toUpperCase();
    desc = data[1];
    imgFile = 'assets/images/pizzas/' + data[2];
    veg = data[3] == 'true';
    priceINR = double.tryParse(data[4].toString()) ?? 0.0;
  }

  @override
  String toString() => 'Pizza($id): $name | $imgFile | $priceINR | $veg';
}
