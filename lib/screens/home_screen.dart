import 'package:flutter/material.dart';
import 'package:pizza_delivery/widgets/home_navigation_drawer.dart';

import '../models/demo_data.dart';
import '../widgets/home_float_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeNavigationDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('PizzaMan'),
        // automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [],
            ),
          ),
          ...(DemoData.pizzas[true]?.map((e) => Text(e.name))?.toList() ?? []),
          Divider(),
          ...(DemoData.pizzas[false]?.map((e) => Text(e.name))?.toList() ?? []),
          Divider(),
          ...(DemoData.beverages?.map((e) => Text(e.name))?.toList() ?? []),
          Divider(),
          ...(DemoData.toppings?.map((e) => Text(e.name))?.toList() ?? []),
        ],
      ),
      floatingActionButton: _HomeFloatingWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _HomeFloatingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HomeFloatButton(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              bottomLeft: Radius.circular(100),
            ),
            onClick: () {},
            icon: Icons.local_pizza,
            text: 'Menu',
          ),
          SizedBox(width: 1),
          HomeFloatButton(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
            onClick: () {},
            icon: Icons.shopping_cart,
            text: 'Cart',
          ),
        ],
      ),
    );
  }
}
