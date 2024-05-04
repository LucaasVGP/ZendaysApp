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
  final List<CardItem> cards = [

  ];

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
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao obter o tipo de usuário: ${snapshot.error}');
        } else {
          String? tipoUsuario = snapshot.data;
          List<CardItem> cards = [];
          switch (tipoUsuario) {
            case '0':
            //MinhasFerias
              cards.add(CardItem(
                  title: 'Minhas Férias',
                  icon: Icons.beach_access,
                  pagina: TelaFeriasPage()
              ));
              break;
            case '1':
              cards.add(CardItem(
                  title: 'Funcionário',
                  icon: Icons.people,
                  pagina: TabelaFuncionarioPage()
              ));
              //MinhasFerias
              cards.add(CardItem(
                  title: 'Minhas Férias',
                  icon: Icons.beach_access,
                  pagina: TelaFeriasPage()
              ));
              cards.add(CardItem(
                  title: 'Gerenciar Ferias',
                  icon: Icons.ac_unit_sharp,
                  pagina: AprovacaoFeriasPage()
              ));
              cards.add(CardItem(
                  title: 'Visualizar Ferias',
                  icon: Icons.ac_unit_sharp,
                  pagina: VisualizarFeriasPage()
              ));
              break;
            case '2':
              cards.add(CardItem(
                  title: 'Funcionário',
                  icon: Icons.people,
                  pagina: TabelaFuncionarioPage()
              ));
              cards.add(CardItem(
                  title: 'Departamento',
                  icon: Icons.people,
                  pagina: TabelaDepartamentosPage()
              ));
              cards.add(CardItem(
                  title: 'Gerenciar Ferias',
                  icon: Icons.ac_unit_sharp,
                  pagina: AprovacaoFeriasPage()
              ));
              cards.add(CardItem(
                  title: 'Visualizar Ferias',
                  icon: Icons.ac_unit_sharp,
                  pagina: VisualizarFeriasPage()
              ));
              break;
          }
          cards.add(CardItem(
              title: 'Sair',
              icon: Icons.login,
              pagina: LoginPage()
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
            body: GridView.count(
              crossAxisCount: 2,
              children: cards.map((card) => CardWidget(card: card)).toList(),
            ),
            backgroundColor: Colors.grey[200], // Cor de fundo suave
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

  CardItem({required this.title, required this.icon,required this.pagina});
}

class CardWidget extends StatelessWidget {
  final CardItem card;

  CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Mais elevação para uma aparência mais tridimensional
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Borda arredondada
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
                color: Color(0xFF275657), // Cor personalizada para o ícone
              ),
              SizedBox(height: 8.0),
              Text(
                card.title,
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
