import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _auth = 'auth';

  static Future<bool> checkAuth() async {
    final sp = await SharedPreferences.getInstance();
    return sp.containsKey(_auth);
  }

  static Future setAuth(Auth auth) async {
    final sp = await SharedPreferences.getInstance();
    sp.setStringList(_auth, [auth.name, auth.num]);
  }

  static Future<Auth> get getAuth async {
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(_auth)) {
      final a = sp.getStringList(_auth);
      return Auth(name: a[0], num: a[1]);
    }
    return null;
  }
}

class Auth {
  String name, num;

  Auth({this.name, this.num});
}
