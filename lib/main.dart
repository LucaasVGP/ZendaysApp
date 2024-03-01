import 'package:flutter/material.dart';
import 'package:zendays/homeadm.dart';
import 'package:zendays/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  static Future<String?> getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('api_url');
    return url;
  }

  static Future<void> salvarURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_url', 'https://zendays.azurewebsites.net/api/v1');
  }
}

void main() {
  TokenManager.salvarURL();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home_user': (context) => HomeAdministradorPage(),
      },
    );
  }
}