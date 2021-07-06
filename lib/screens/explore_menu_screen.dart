import 'dart:math';

import 'package:flutter/material.dart';

import '../models/demo_data.dart';
import 'menu_tabs/beverage_list_tab.dart';
import 'menu_tabs/pizza_list_tab.dart';
import 'menu_tabs/topping_list_tab.dart';

class ExploreMenuScreen extends StatefulWidget {
  static const routeName = '/explore-menu';

  @override
  _ExploreMenuScreenState createState() => _ExploreMenuScreenState();
}

class _ExploreMenuScreenState extends State<ExploreMenuScreen> with TickerProviderStateMixin {
  bool vegOnly = false;
  TabController _controller;
  final restTabs = 5;

  @override
  void initState() {
    _controller = TabController(length: (vegOnly ? 0 : 1) + restTabs, vsync: this);
    Future.delayed(Duration.zero).then((value) {
      final idx = ModalRoute.of(context).settings.arguments as int;
      if (idx != null) _controller.animateTo(idx);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _controller.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Explore Menu'),
          actions: [
            Checkbox(
              value: vegOnly,
              onChanged: (val) {
                vegOnly = val;
                final idx = _controller.index;
                final len = _controller.length;
                _controller.dispose();
                _controller = TabController(
                  length: (vegOnly ? 0 : 1) + restTabs,
                  vsync: this,
                  initialIndex: idx == 2
                      ? vegOnly
                          ? idx
                          : idx + 1
                      : idx < 2
                          ? idx
                          : idx == len - 1
                              ? vegOnly
                                  ? restTabs - 1
                                  : restTabs + 1
                              : vegOnly
                                  ? idx - 1
                                  : min(idx + 1, _controller.length - 1),
                );
                setState(() {});
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            isScrollable: true,
            controller: _controller,
            tabs: [
              Tab(text: 'Best Seller'),
              Tab(text: 'Veg Pizza'),
              if (!vegOnly) Tab(text: 'Non-Veg Pizza'),
              Tab(text: 'Pizza Mania'),
              Tab(text: 'Beverages'),
              Tab(text: 'Toppings'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            PizzaListTab(pizzas: DemoData.bestSellers, vegOnly: vegOnly),
            PizzaListTab(pizzas: DemoData.pizzas[true]),
            if (!vegOnly) PizzaListTab(pizzas: DemoData.pizzas[false]),
            PizzaListTab(
              vegOnly: vegOnly,
              pizzas: (DemoData.pizzaManias[true] + DemoData.pizzaManias[false])
                ..sort(
                  (a, b) => a.name.compareTo(b.name),
                ),
            ),
            BeverageListTab(beverages: DemoData.beverages),
            ToppingListTab(toppings: DemoData.toppings)
          ],
        ),
      ),
    );
  }
}
