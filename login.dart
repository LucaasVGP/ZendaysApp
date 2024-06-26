import 'package:flutter/material.dart';
import '../Configs/Rotas.dart';
import '../Configs/EHttpMethod.dart';
import '../Configs/Utils.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(text: "lucass@email.com");
  final TextEditingController _passwordController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                'https://i.imgur.com/3ahDrtu.png',
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

  Future<void> _performLogin(BuildContext context) async {
    var obj = {'email': _usernameController.text, 'senha': _passwordController.text};
    var resultado = await Utils.GetRetornoAPI(obj,HttpMethod.POST,Rotas.login,false);
    if (resultado.Sucesso) {
      _saveInfoToken(resultado.Obj);
      Navigator.pushNamed(context, '/home_adm');
    }
    else{
      Utils.showToast('Falha no login. Verifique as credenciais');
    }
  }

  Future<void> _saveInfoToken(Map<String, dynamic> json) async {
    final token = json['token'];
    final tipo = json['tipoUsuario'];
    final id = json['id'];
    final email = json['email'];
    final departamento = json['idDepartamento'];
    await Utils.saveInfo("token",token);
    await Utils.saveInfo("id",id);
    await Utils.saveInfo("tipo",tipo);
    await Utils.saveInfo("email",email);
    await Utils.saveInfo("departamento",departamento);
  }
}