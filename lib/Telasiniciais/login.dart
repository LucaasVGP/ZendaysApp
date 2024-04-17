import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zendays/Configs/Appsettings.dart';
import 'package:zendays/Funcoes/Utils.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Image.network(
                'https://cdn.discordapp.com/attachments/1009260536992632953/1221586075387170877/ZENDAYS-removebg-preview.png?ex=66131db0&is=6600a8b0&hm=d7b82e1e1753c70a734e6efd90fb1181ab4e6da287d83c28a6119a1b1e6b5faf&',
                height: 200,
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _performLogin(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Color(0xFF275657).withOpacity(0.8); // Cor de fundo com opacidade ao passar o mouse
                      }
                      return Color(0xFF275657); // Cor de fundo padrão
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white; // Cor do texto ao passar o mouse
                      }
                      return Colors.white; // Cor do texto padrão
                    },
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text('Acessar'),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _login(String email, String senha) async {
    final apiUrl = Appsettings.api_url;
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
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['data']['token'];
      final tipo = jsonResponse['data']['tipoUsuario'];
      final id = jsonResponse['data']['id'];
      final email = jsonResponse['data']['email'];
      final departamento = jsonResponse['data']['idDepartamento'];
      await Utils.saveInfo("token",token);
      await Utils.saveInfo("id",id);
      await Utils.saveInfo("tipo",tipo);
      await Utils.saveInfo("email",email);
      await Utils.saveInfo("departamento",departamento);
      return token;
    } else {
      return null;
    }
  }

  Future<void> _performLogin(BuildContext context) async {
    final email = _usernameController.text;
    final senha = _passwordController.text;
    final token = await _login(email, senha);
    if (token != null) {
      Navigator.pushNamed(context, '/home_user');
    } else {
      Fluttertoast.showToast(msg: 'Falha no login. Verifique suas credenciais.');
    }
  }
}
