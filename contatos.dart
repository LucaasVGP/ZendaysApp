import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zendays/Telasiniciais/admin_menu.dart';

class ContatosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF275657),
      ),
      drawer: AdminMenu(
        currentPage: 'Contatos',
        onMenuTap: (String page) {
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(FontAwesomeIcons.phone),
              title: Text('Telefone'),
              subtitle: Text('(123) 456-7890'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.envelope),
              title: Text('E-mail'),
              subtitle: Text('contato@zendays.com'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.mapMarkerAlt),
              title: Text('Endereço'),
              subtitle: Text('123, Rua dos Exemplos, Cidade, Estado'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.twitter),
              title: Text('Twitter'),
              subtitle: Text('@zendays'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.instagram),
              title: Text('Instagram'),
              subtitle: Text('@zendays'),
            ),
          ],
        ),
      ),
    );
  }
}
