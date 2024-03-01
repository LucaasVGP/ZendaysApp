import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zendays/main.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _usernameController.text;
                final senha = _passwordController.text;
                final token = await _login(email, senha);
                if (token != null) {
                  // Login successful, save token and navigate to HomeUserPage
                  saveToken(token);

                  Navigator.pushNamed(context, '/home_user');
                } else {
                  // Login failed, display error message
                  Fluttertoast.showToast(msg: 'Falha no login. Verifique suas credenciais.');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
//GET URL
  Future<String?> _login(String email, String senha) async {
    final apiUrl = await TokenManager.getUrl();
    final url = '$apiUrl/Auth/Login';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      // Login successful, return token
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['data']['token'];
      return token;
    } else {
      // Problema no login, token retornou vazio.
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}



