import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/ref_utils.dart';
import '../utils/widget_utils.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController(), _num = TextEditingController(), _skey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print('auth');
    return Scaffold(
      key: _skey,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                RefUtils.logo,
                height: MediaQuery.of(context).size.width / 4,
                width: MediaQuery.of(context).size.width / 4,
              ),
              SizedBox(height: 10),
              Text(
                RefUtils.appName,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.orangeAccent[400]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _name,
                decoration: WidgetUtils.customInputDecoration(context).copyWith(
                  hintText: 'Name',
                  prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                ),
                style: WidgetUtils.customInputDecoration(context).hintStyle,
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _num,
                decoration: WidgetUtils.customInputDecoration(context).copyWith(
                  hintText: 'Mobile',
                  prefixIcon: Icon(Icons.phone, color: Theme.of(context).primaryColor),
                ),
                style: WidgetUtils.customInputDecoration(context).hintStyle,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                maxLengthEnforced: true,
              ),
              SizedBox(height: 45),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.orange,
                textColor: Colors.white,
                child: Text('Proceed'),
                onPressed: () async {
                  if (_name.text.trim().isNotEmpty && _num.text.length == 10) {
                    await AuthService.setAuth(Auth(name: _name.text.trim(), num: _num.text));
                    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                  } else {
                    _skey.currentState
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text('Invalid Name or number!')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
