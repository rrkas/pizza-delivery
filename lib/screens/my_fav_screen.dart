import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizza_delivery/screens/explore_menu_screen.dart';
import 'package:pizza_delivery/services/database_services.dart';
import 'package:pizza_delivery/widgets/beverage_list_widget.dart';
import 'package:pizza_delivery/widgets/pizza_list_widget.dart';
import 'package:pizza_delivery/widgets/topping_list_widget.dart';

class MyFavScreen extends StatefulWidget {
  static const routeName = '/fav-screen';

  @override
  _MyFavScreenState createState() => _MyFavScreenState();
}

class _MyFavScreenState extends State<MyFavScreen> {
  @override
  Widget build(BuildContext context) {
    final ch = [
      ...FavDatabaseHandler.fav.pizzas.map((e) => PizzaListWidget(pizza: e, refresh: setState)).toList(),
      ...FavDatabaseHandler.fav.pizzaManias.map((e) => PizzaListWidget(pizza: e, refresh: setState)).toList(),
      ...FavDatabaseHandler.fav.beverages.map((e) => BeverageListWidget(bev: e, refresh: setState)).toList(),
      ...FavDatabaseHandler.fav.toppings.map((e) => ToppingListWidget(topping: e, refresh: setState)).toList(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: ch.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FontAwesome5.heart_broken, size: 30),
                  SizedBox(height: 10),
                  Text(
                    'No Favorites Yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    elevation: 3,
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushReplacementNamed(ExploreMenuScreen.routeName),
                    child: Text(
                      'Explore Menu',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.all(5),
              children: ch,
            ),
    );
  }
}
