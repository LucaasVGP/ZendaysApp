import 'package:flutter/material.dart';
import 'package:zendays/Configs/TokenInfo.dart';
import 'package:zendays/Contatos/contatos.dart';
import 'package:zendays/Ferias/Visualizarferias.dart';
import 'package:zendays/Ferias/aprovacoesferias.dart';
import 'package:zendays/Telasiniciais/homeadm.dart';
import 'package:zendays/Telasiniciais/login.dart';
import 'package:zendays/Departamentos/TelaDepartamentos.dart';
import 'package:zendays/Funcionarios/TelaFuncionarios.dart';
import 'package:zendays/Configs/Utils.dart';

import '../Ferias/TelaFerias.dart';

class AdminMenu extends StatelessWidget {
  final String currentPage;
  final Function(String) onMenuTap;

  const AdminMenu({
    required this.currentPage,
    required this.onMenuTap,
  });


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TokenInfo>(
      future: Utils.returnAllInfoToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibir algum indicador de carregamento enquanto a função está sendo executada.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Tratar possíveis erros que podem ocorrer durante a execução da função.
          return Text('Erro: ${snapshot.error}');
        } else {
          String? tipo = snapshot.data?.TipoUsuario;
          String? tipoUsuario = snapshot.data?.TipoUsuarioExibicao;
          String? email = snapshot.data?.Email;
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
                      Text(
                        '$tipoUsuario',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      Text(
                        '$email',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
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

                tipo == "0" || tipo == "1"?ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Minhas Férias'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TelaFeriasPage()),
                    );
                  },
                  selected: currentPage == 'minhasFerias',
                ):Container(),

                tipo == "1" || tipo == "2"?ListTile(
                  leading: Icon(Icons.beach_access),
                  title: Text('Gerenciar Férias'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AprovacaoFeriasPage()),
                    );
                  },
                  selected: currentPage == 'gerenciarFerias',
                ):Container(),

                tipo == "1" || tipo == "2"?ListTile(
                  leading: Icon(Icons.beach_access),
                  title: Text('Visualizar Férias'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => VisualizarFeriasPage()),
                    );
                  },
                  selected: currentPage == 'visualizarFerias',
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
