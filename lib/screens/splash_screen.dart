import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/ref_utils.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3)).then((_) async {
      if (await AuthService.checkAuth())
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      else
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              RefUtils.logo,
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
            ),
            SizedBox(height: 10),
            Text(
              RefUtils.appName,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orangeAccent[400]),
            ),
          ],
        ),
      ),
    );
  }
}
