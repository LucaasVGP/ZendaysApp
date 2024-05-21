import 'package:flutter/material.dart';
import 'package:zendays/Departamentos/TelaDepartamentos.dart';
import 'package:zendays/Ferias/TelaFerias.dart';
import 'package:zendays/Ferias/Visualizarferias.dart';
import 'package:zendays/Ferias/aprovacoesferias.dart';
import 'package:zendays/Funcionarios/TelaFuncionarios.dart';
import 'package:zendays/Telasiniciais/admin_menu.dart';
import 'package:zendays/Telasiniciais/login.dart';
import '../Configs/Utils.dart';

class HomeAdministradorPage extends StatefulWidget {
  @override
  _HomeAdministradorPageState createState() => _HomeAdministradorPageState();
}

class _HomeAdministradorPageState extends State<HomeAdministradorPage> {
  final List<CardItem> cards = [];
  String currentPage = 'home';

  void handleMenuTap(String page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Utils.returnInfo("tipo"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao obter o tipo de usuário: ${snapshot.error}'));
        } else {
          String? tipoUsuario = snapshot.data;
          List<CardItem> cards = [];
          switch (tipoUsuario) {
            case '0':
              cards.add(CardItem(
                title: 'Minhas Férias',
                icon: Icons.account_circle_sharp,
                pagina: TelaFeriasPage(),
              ));
              break;
            case '1':
              cards.add(CardItem(
                title: 'Funcionários',
                icon: Icons.people,
                pagina: TabelaFuncionarioPage(),
              ));
              cards.add(CardItem(
                title: 'Minhas Férias',
                icon: Icons.account_circle_sharp,
                pagina: TelaFeriasPage(),
              ));
              cards.add(CardItem(
                title: 'Gerenciar Férias',
                icon: Icons.settings,
                pagina: AprovacaoFeriasPage(),
              ));
              cards.add(CardItem(
                title: 'Visualizar Férias',
                icon: Icons.bar_chart,
                pagina: VisualizarFeriasPage(),
              ));
              break;
            case '2':
              cards.add(CardItem(
                title: 'Funcionário',
                icon: Icons.people,
                pagina: TabelaFuncionarioPage(),
              ));
              cards.add(CardItem(
                title: 'Departamento',
                icon: Icons.apartment,
                pagina: TabelaDepartamentosPage(),
              ));
              cards.add(CardItem(
                title: 'Gerenciar Férias',
                icon: Icons.ac_unit_sharp,
                pagina: AprovacaoFeriasPage(),
              ));
              cards.add(CardItem(
                title: 'Visualizar Férias',
                icon: Icons.ac_unit_sharp,
                pagina: VisualizarFeriasPage(),
              ));
              break;
          }
          cards.add(CardItem(
            title: 'Sair',
            icon: Icons.logout,
            pagina: LoginPage(),
          ));

          return Scaffold(
            appBar: AppBar(
              title: Text('Tela Inicial', style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xFF275657),
            ),
            drawer: AdminMenu(
              currentPage: currentPage,
              onMenuTap: handleMenuTap,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF275657),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, bem vindo!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Desconectar para recarregar.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.beach_access,
                          color: Colors.white,
                          size: 48.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: cards.map((card) => CardWidget(card: card)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.grey[200],
          );
        }
      },
    );
  }
}

class CardItem {
  final String title;
  final IconData icon;
  final Widget pagina;

  CardItem({required this.title, required this.icon, required this.pagina});
}

class CardWidget extends StatelessWidget {
  final CardItem card;

  CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => card.pagina),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                card.icon,
                size: 48.0,
                color: Color(0xFF275657),
              ),
              SizedBox(height: 8.0),
              Text(
                card.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
