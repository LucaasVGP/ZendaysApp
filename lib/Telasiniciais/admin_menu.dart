import 'package:flutter/material.dart';
import 'package:zendays/Contatos/contatos.dart';
import 'package:zendays/Telasiniciais/homeadm.dart';
import 'package:zendays/Telasiniciais/login.dart';
import 'package:zendays/Departamentos/TelaDepartamentos.dart';
import 'package:zendays/Funcionarios/TelaFuncionarios.dart';
import 'package:zendays/Configs/Utils.dart';

class AdminMenu extends StatelessWidget {
  final String currentPage;
  final Function(String) onMenuTap;

  const AdminMenu({
    required this.currentPage,
    required this.onMenuTap,
  });


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Utils.returnInfo('tipo'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibir algum indicador de carregamento enquanto a função está sendo executada.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Tratar possíveis erros que podem ocorrer durante a execução da função.
          return Text('Erro: ${snapshot.error}');
        } else {
          String? tipo = snapshot.data;
          return Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF275657),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Tela Inicial'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeAdministradorPage()),
                    );
                  },
                  selected: currentPage == 'telainicial',
                ),
                tipo == "1" || tipo == "2"?ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Funcionários'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TabelaFuncionarioPage()),
                    );
                  },
                  selected: currentPage == 'funcionarios',
                ):Container(),
                tipo == "2"?ListTile(
                  leading: Icon(Icons.paste),
                  title: Text('Departamentos'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TabelaDepartamentosPage()),
                    );
                  },
                  selected: currentPage == 'departamentos',
                ):Container(),


                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Contatos'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ContatosPage()),
                    );
                  },
                  selected: currentPage == 'contatos',
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}