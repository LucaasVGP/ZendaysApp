import 'package:flutter/material.dart';
import '../Configs/Rotas.dart';
import '../Configs/EHttpMethod.dart';
import '../Configs/Utils.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(text: "admin@admin.com");
  final TextEditingController _passwordController = TextEditingController(text: "123456");

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
    /*SizedBox(height: 50),
                Image.network(
                'https://cdn.discordapp.com/attachments/1009260536992632953/1221586075387170877/ZENDAYS-removebg-preview.png?ex=66131db0&is=6600a8b0&hm=d7b82e1e1753c70a734e6efd90fb1181ab4e6da287d83c28a6119a1b1e6b5faf&',
                height: 200,
              ),

     */
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
      final tipo = resultado.Obj['tipoUsuario'];
      switch (tipo) {
        case '0':
          //colaborador
          Navigator.pushNamed(context, '/home_adm');
          break;
        case '1':
          //Supervisor
          Navigator.pushNamed(context, '/home_adm');
          break;
        case '2':
          Navigator.pushNamed(context, '/home_adm');
          break;
        default:
          Utils.showToast('Falha no login. Verifique o tipo de usuario');
      }
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