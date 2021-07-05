import 'package:flutter/material.dart';
import 'package:pizza_delivery/models/beverage.dart';
import 'package:pizza_delivery/widgets/beverage_list_widget.dart';

class BeverageListTab extends StatelessWidget {
  final List<Beverage> beverages;

  const BeverageListTab({Key key, this.beverages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      itemCount: beverages.length,
      itemBuilder: (_, idx) => BeverageListWidget(bev: beverages[idx]),
    );
  }
}
