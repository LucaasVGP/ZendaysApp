import 'package:flutter/material.dart';
import 'package:zendays/nossowidget/user_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Usuário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeUsuarioPage(),
    );
  }
}

class HomeUsuarioPage extends StatelessWidget {
  final List<CardItem> cards = [
    CardItem(
      title: 'Solicitar Férias',
      icon: Icons.beach_access,
    ),
    CardItem(
      title: 'Minhas Férias',
      icon: Icons.date_range,
    ),
    CardItem(
      title: 'Dados Pessoais',
      icon: Icons.person,
    ),
    CardItem(
      title: 'Aprovar Férias',
      icon: Icons.check_circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Usuário'),
      ),
      drawer: UserMenu(
        currentPage: 'home',
        onMenuTap: (page) {
          // Implementar ação para ir para a página correspondente
          // baseada no valor `page`
        },
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: cards.map((card) => CardWidget(card: card)).toList(),
      ),
    );
  }
}

class CardItem {
  final String title;
  final IconData icon;

  CardItem({required this.title, required this.icon});
}

class CardWidget extends StatelessWidget {
  final CardItem card;

  CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          // Implementar ação para cada card
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                card.icon,
                size: 48.0,
                color: Colors.blue,
              ),
              SizedBox(height: 8.0),
              Text(
                card.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
