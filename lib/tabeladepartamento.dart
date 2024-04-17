import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zendays/Funcoes/Utils.dart';
import 'package:zendays/Configs/Appsettings.dart';

class TabelaDepartamentosPage extends StatefulWidget {
  @override
  _TabelaDepartamentosPageState createState() => _TabelaDepartamentosPageState();
}

class _TabelaDepartamentosPageState extends State<TabelaDepartamentosPage> {
  List<dynamic> departamentos = [];
  List<dynamic> departamentosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();
  dynamic departamentoSelecionado;
  final TextEditingController _editarNomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final getToken = await Utils.returnInfo("token");
    final apiUrl = Appsettings.api_url;
    final url = '$apiUrl/Departamento/GetAll';
    final headers = {'Authorization': 'Bearer $getToken'};
    print(headers);

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          departamentos = jsonResponse['data'];
          departamentosFiltrados = List.from(departamentos);
        });
      } else {
        // Tratar erros de resposta da API
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão: $e');
    }
  }

  void filtrarDepartamentos(String query) {
    setState(() {
      departamentosFiltrados = departamentos.where((departamento) {
        final nome = departamento['nome'].toString().toLowerCase();
        return nome.contains(query.toLowerCase());
      }).toList();
    });
  }

  void exibirModalEditar(dynamic departamento) {
    _editarNomeController.text = departamento['nome'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Departamento'),
          content: TextField(
            controller: _editarNomeController,
            decoration: InputDecoration(labelText: 'Nome do Departamento'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
            TextButton(
              onPressed: () async {
                final novoNome = _editarNomeController.text;
                final departamentoAtualizado = {
                  'id': departamento['id'],
                  'nome': novoNome,
                };

                await atualizarDepartamento(departamentoAtualizado);

                setState(() {
                  departamento['nome'] = novoNome;
                });

                Navigator.of(context).pop();
              },
              child: Text('Atualizar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> atualizarDepartamento(dynamic departamento) async {

    final getToken = await Utils.returnInfo("token");
    final apiUrl = Appsettings.api_url;
    final url = '$apiUrl/Departamento/Update';

    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $getToken'};

    final requestBody = jsonEncode({
      'id': departamento['id'],
      'nome': departamento['nome'],
    });

    try {
      await http.put(Uri.parse(url), headers: headers, body: requestBody);
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão: $e');
    }
  }

  void exibirModalExclusao(dynamic departamento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Deseja excluir o departamento ${departamento['nome']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await excluirDepartamento(departamento);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> excluirDepartamento(dynamic departamento) async {

    final getToken = await Utils.returnInfo("token");
    final apiUrl = Appsettings.api_url;
    final url = '$apiUrl/Departamento/Disable?id=${departamento['id']}';

    print(departamento['id']);
    final headers = {'Authorization': 'Bearer $getToken'};

    try {
      await http.delete(Uri.parse(url), headers: headers);
      setState(() {
        departamentos.removeWhere((d) => d['id'] == departamento['id']);
        departamentosFiltrados = List.from(departamentos);
      });
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão: $e');
    }
  }

  void exibirModalRegistro() {
    final TextEditingController _registroNomeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar Departamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _registroNomeController,
                decoration: InputDecoration(labelText: 'Nome do Departamento'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final novoNome = _registroNomeController.text;
                final departamento = {'nome': novoNome};

                await registrarDepartamento(departamento);
                atualizarListaDepartamentos();

                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> registrarDepartamento(dynamic departamento) async {

    final getToken = await Utils.returnInfo("token");
    final apiUrl = Appsettings.api_url;
    final url = '$apiUrl/Departamento/Register';

    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $getToken'};

    final requestBody = jsonEncode(departamento);
    print(jsonEncode(departamento));

    try {
      await http.post(Uri.parse(url), headers: headers, body: requestBody);
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão: $e');
    }
  }

  Future<void> atualizarListaDepartamentos() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabela de Departamentos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          exibirModalRegistro();
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: filtrarDepartamentos,
              decoration: InputDecoration(
                labelText: 'Pesquisar Departamento',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: departamentosFiltrados.length,
              itemBuilder: (context, index) {
                final departamento = departamentosFiltrados[index];
                return ListTile(
                  title: Text(departamento['nome']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            departamentoSelecionado = departamento;
                          });
                          exibirModalEditar(departamento);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          exibirModalExclusao(departamento);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
