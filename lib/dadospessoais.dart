import 'package:flutter/material.dart';

class DadosPessoaisPage extends StatefulWidget {
  @override
  _DadosPessoaisPageState createState() => _DadosPessoaisPageState();
}

class _DadosPessoaisPageState extends State<DadosPessoaisPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _dataNascController = TextEditingController();
  TextEditingController _ultimasFeriasController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _departamentoController = TextEditingController();
  TextEditingController _cargoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Pessoais'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: 'Salário'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _dataNascController,
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
            ),
            TextField(
              controller: _ultimasFeriasController,
              decoration: InputDecoration(labelText: 'Últimas Férias'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextField(
              controller: _departamentoController,
              decoration: InputDecoration(labelText: 'Departamento'),
            ),
            TextField(
              controller: _cargoController,
              decoration: InputDecoration(labelText: 'Cargo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para atualizar os dados pessoais
                // Utilize os valores dos controllers para atualizar os campos
              },
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
