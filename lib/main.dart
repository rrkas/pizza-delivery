import 'package:flutter/material.dart';
import 'package:pizza_delivery/screens/auth_screen.dart';

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
          color: Colors.deepOrange,
        ),
        primaryColor: Colors.deepOrange,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        AuthScreen.routeName: (_) => AuthScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
      },
    );
  }
}
