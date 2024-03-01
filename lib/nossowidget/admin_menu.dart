import 'package:flutter/material.dart';
import 'package:zendays/contatos.dart';
import 'package:zendays/homeadm.dart';
import 'package:zendays/login.dart';
import 'package:zendays/tabeladepartamento.dart';
import 'package:zendays/tabelafuncionario.dart';
import 'package:zendays/relatorioferiasadm.dart';
import 'package:zendays/relatoriocustoadm.dart';

class AdminMenu extends StatelessWidget {
  final String currentPage;
  final Function(String) onMenuTap;

  const AdminMenu({
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
                  'Administrador',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeAdministradorPage()),
              );
            },
            selected: currentPage == 'home',
          ),
          ExpansionTile(
            leading: Icon(Icons.table_chart),
            title: Text('Tabelas'),
            children: [
              ListTile(
                title: Text('Funcionários'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TabelaFuncionarioPage()),
                  );
                },
                selected: currentPage == 'funcionarios',
              ),
              ListTile(
                title: Text('Departamentos'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TabelaDepartamentosPage()),
                  );
                },
                selected: currentPage == 'departamentos',
              ),
              ListTile(
                title: Text('Férias'),
                onTap: () {
                  onMenuTap('ferias');
                },
                selected: currentPage == 'ferias',
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.insert_chart),
            title: Text('Relatórios'),
            children: [
              ListTile(
                title: Text('Relatório de Férias'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RelatorioFeriasAdmPage()),
                  );
                },
                selected: currentPage == 'relatorioferias',
              ),
              ListTile(
                title: Text('Relatório de Custos'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RelatorioCustoAdmPage()),
                  );
                },
                selected: currentPage == 'relatoriocustos',
              ),
            ],
          ),
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
}
