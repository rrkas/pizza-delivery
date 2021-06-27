import 'package:flutter/material.dart';
import 'package:pizza_delivery/models/demo_data.dart';
import 'package:pizza_delivery/utils/ref_utils.dart';
import 'package:pizza_delivery/widgets/home_bestseller_widget.dart';
import 'package:pizza_delivery/widgets/home_explore_menu_widget.dart';
import 'package:pizza_delivery/widgets/home_navigation_drawer.dart';

import '../widgets/home_float_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bestSellers = DemoData.bestSellers;
    return Scaffold(
      drawer: HomeNavigationDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(RefUtils.appName),
        // automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          _SectionHeading('Explore Menu'),
          GridView.count(
            physics: ScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            shrinkWrap: true,
            childAspectRatio: 1.7,
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: [
              HomeExploreMenuWidget(
                name: 'Veg Pizza',
                imgName: 'pizza_slice.jpg',
              ),
              HomeExploreMenuWidget(
                name: 'Non-Veg Pizza',
                imgName: 'pizza_slice.jpg',
              ),
              HomeExploreMenuWidget(
                name: 'Pizza Mania',
                imgName: 'pizza_mania.png',
              ),
              HomeExploreMenuWidget(
                name: 'Beverage',
                imgName: 'beverages.jpg',
              ),
            ],
          ),
          _SectionHeading('Best Sellers'),
          Container(
            height: 270,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, idx) => HomeBestSellerWidget(bestSellers[idx]),
              itemCount: bestSellers.length,
            ),
          ),
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

class _SectionHeading extends StatelessWidget {
  final String heading;

  const _SectionHeading(this.heading);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
