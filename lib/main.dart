import 'package:flutter/material.dart';
import 'package:pizza_delivery/screens/auth_screen.dart';
import 'package:pizza_delivery/screens/cart_screen.dart';
import 'package:pizza_delivery/screens/explore_menu_screen.dart';
import 'package:pizza_delivery/screens/my_fav_screen.dart';
import 'package:pizza_delivery/screens/order_list_screen.dart';
import 'package:pizza_delivery/screens/order_track_screen.dart';

import 'models/demo_data.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DemoData.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Delivery Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.deepOrange[800],
        ),
        primaryColor: Colors.deepOrange[800],
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.deepOrange,
          contentTextStyle: TextStyle(fontSize: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        AuthScreen.routeName: (_) => AuthScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        OrderListScreen.routeName: (_) => OrderListScreen(),
        CartScreen.routeName: (_) => CartScreen(),
        ExploreMenuScreen.routeName: (_) => ExploreMenuScreen(),
        MyFavScreen.routeName: (_) => MyFavScreen(),
        OrderTrackScreen.routeName: (_) => OrderTrackScreen(),
      },
    );
  }
}
