import 'package:flutter/material.dart';

class CadastroFuncionarioPage extends StatefulWidget {
  @override
  _CadastroFuncionarioPageState createState() => _CadastroFuncionarioPageState();
}

class _CadastroFuncionarioPageState extends State<CadastroFuncionarioPage> {

  String nome = '';
  String endereco = '';
  String telefone = '';
  String dataAdmissao = '';
  String email = '';
  String cargo = '';
  String nivelAcesso = '';
  String sexo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Funcionário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (value) {
                setState(() {
                  nome = value;
                });
              },
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Cargo'),
              onChanged: (value) {
                setState(() {
                  cargo = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Endereço'),
              onChanged: (value) {
                setState(() {
                  endereco = value;
                });
              },
            ),

            ElevatedButton(
              onPressed: () {
                // Ação do botão "Salvar"
                // Salve os dados do funcionário
              },
              child: Text('Salvar'),
            ),
                     ],
        ),
      ),
    );
  }
}
