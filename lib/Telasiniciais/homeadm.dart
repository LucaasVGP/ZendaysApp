import 'package:flutter/material.dart';
import 'package:zendays/Funcionarios/TelaFuncionarios.dart';
import 'package:zendays/Telasiniciais/admin_menu.dart';
import 'package:zendays/Telasiniciais/login.dart';

class HomeAdministradorPage extends StatefulWidget {
  @override
  _HomeAdministradorPageState createState() => _HomeAdministradorPageState();
}

class _HomeAdministradorPageState extends State<HomeAdministradorPage> {
  //definir quis itens entram na lista baseado no tipo de usuario
  final List<CardItem> cards = [
    /*CardItem(
      title: 'Relatório',
      icon: Icons.bar_chart,
    ),*/
    /*CardItem(
      title: 'Férias',
      icon: Icons.beach_access,
    ),*/
    CardItem(
      title: 'Funcionário',
      icon: Icons.people,
      pagina: TabelaFuncionarioPage()
    ),
    CardItem(
      title: 'Sair',
      icon: Icons.login,
      pagina: LoginPage()
    ),
  ];

  String currentPage = 'home';

  void handleMenuTap(String page) {
    setState(() {
      currentPage = page;
    });
    // Adicione aqui qualquer lógica adicional que precisa ser executada quando um item do menu é selecionado
  }

  @override
  Widget build(BuildContext context) {
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
