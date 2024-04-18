import 'package:flutter/material.dart';
import 'package:zendays/Ferias/aprovacoesferias.dart';
import 'package:zendays/Telasiniciais/login.dart';
import 'package:zendays/Ferias/tabelaferias.dart';
import 'package:zendays/Funcionarios/dadospessoais.dart';

class UserMenu extends StatelessWidget {
  final String currentPage;
  final Function(String) onMenuTap;

  const UserMenu({
    required this.currentPage,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 64.0,
                  color: Colors.white,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Usuário',
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
            title: Text('Home'),
            onTap: () {
              onMenuTap('home');
            },
            selected: currentPage == 'home',
          ),
          ExpansionTile(
            leading: Icon(Icons.beach_access),
            title: Text('Férias'),
            children: [
              ListTile(
                title: Text('Solicitar Férias'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DataListPage()),
                  );
                },
                selected: currentPage == 'solicitar',
              ),
              ListTile(
                title: Text('Consultar Pedidos'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AprovacaoFeriasPage()),
                  );
                },
                selected: currentPage == 'consultar_pedidos',
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Dados Pessoais'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DadosPessoaisPage()),
              );
            },
            selected: currentPage == 'dados_pessoais',
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
}
