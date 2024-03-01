import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zendays/main.dart';

class TabelaFuncionarioPage extends StatefulWidget {
  @override
  _TabelaFuncionarioPageState createState() => _TabelaFuncionarioPageState();
}

class _TabelaFuncionarioPageState extends State<TabelaFuncionarioPage> {
  List<dynamic> funcionarios = [];
  List<dynamic> departamentosList = [];
  List<dynamic> funcionariosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();
  dynamic funcionarioSelecionado;
  final TextEditingController _editarNomeController = TextEditingController();

  // Controladores no início da classe
  final TextEditingController _registroNomeController = TextEditingController();
  final TextEditingController _registroCpfController = TextEditingController();
  final TextEditingController _registroEnderecoController = TextEditingController();
  final TextEditingController _registroSalarioController = TextEditingController();
  final TextEditingController _registroTelefoneController = TextEditingController();
  final TextEditingController _registroDataNascimentoController = TextEditingController();
  final TextEditingController _registroUltimasFeriasController = TextEditingController();
  final TextEditingController _registroEmailController = TextEditingController();
  final TextEditingController _registroSenhaController = TextEditingController();
  final TextEditingController _registroIdDepartamentoController = TextEditingController();
  final TextEditingController _registroCargoController = TextEditingController();
  final TextEditingController _registroTipoUsuarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDepartamentos();
  }


  Future<void> fetchData() async {
    final getToken = await TokenManager.getToken();
    final apiUrl = await TokenManager.getUrl();
    final url = '$apiUrl/Usuario/GetAll';
    final headers = {'Ngrok-Skip-Browser-Warning': 'true',  'Authorization': 'Bearer $getToken'};
    print(headers);

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          funcionarios = jsonResponse['data'];
          funcionariosFiltrados = List.from(funcionarios);
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

  Future<void> fetchDepartamentos() async {
    final getToken = await TokenManager.getToken();
    final apiUrl = await TokenManager.getUrl();
    final url = '$apiUrl/Departamento/GetAll';
    final headers = {'Ngrok-Skip-Browser-Warning': 'true',  'Authorization': 'Bearer $getToken'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          departamentosList = jsonResponse['data'];
        });
      } else {
        // Tratar erros de resposta da API
        print('Erro na requisição de departamentos: ${response.statusCode}');
      }
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão ao buscar departamentos: $e');
    }
  }


  Future<void> excluirFuncionario(dynamic funcionario) async {
    // Implemente a lógica para excluir o funcionário na API
    // ...
  }

  Future<void> registrarFuncionario(dynamic funcionario) async {
    final getToken = await TokenManager.getToken();
    final apiUrl = await TokenManager.getUrl();
    final url = '$apiUrl/Usuario/Register';

    final headers = {
      'Ngrok-Skip-Browser-Warning': 'true',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $getToken',
      'Accept': 'application/json',
    };

    final requestBody = jsonEncode({
      "Nome": funcionario['nome'], // Ajuste para o nome do campo conforme esperado pela API
      "Cpf": funcionario['cpf'],
      "Endereco": funcionario['endereco'],
      "Salario": funcionario['salario'],
      "Telefone": funcionario['telefone'],
      "DataNascimento": funcionario['dataNascimento'],
      "UltimasFerias": funcionario['ultimasFerias'],
      "Email": funcionario['email'],
      "Senha": funcionario['senha'],
      "IdDepartamento": funcionario['idDepartamento'],
      "Cargo": funcionario['cargo'],
      "TipoUsuario": funcionario['tipoUsuario'],
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: requestBody);

      if (response.statusCode == 200) {
        print('Funcionário registrado com sucesso!');
        await atualizarListaFuncionarios();
      } else {
        // Tratar erros de resposta da API
        print('Erro na requisição: ${response.statusCode}');
        print('Resposta da API: ${response.body}');
      }
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão: $e');
    }
  }


  Future<void> atualizarFuncionario(dynamic funcionario) async {
    final getToken = await TokenManager.getToken();
    final apiUrl = await TokenManager.getUrl();
    final url = '$apiUrl/Usuario/Update';

    final headers = {
      'Ngrok-Skip-Browser-Warning': 'true',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $getToken',
    };

    final requestBody = jsonEncode(funcionario);

    try {
      await http.put(Uri.parse(url), headers: headers, body: requestBody);
      await atualizarListaFuncionarios();
    } catch (e) {
      // Tratar erros de conexão
      print('Erro de conexão: $e');
    }
  }

  void exibirModalRegistro() {
    TextEditingController _registroNomeController = TextEditingController();
    TextEditingController _registroCpfController = TextEditingController();
    TextEditingController _registroEnderecoController = TextEditingController();
    TextEditingController _registroSalarioController = TextEditingController();
    TextEditingController _registroTelefoneController = TextEditingController();
    TextEditingController _registroDataNascimentoController = TextEditingController();
    TextEditingController _registroUltimasFeriasController = TextEditingController();
    TextEditingController _registroEmailController = TextEditingController();
    TextEditingController _registroSenhaController = TextEditingController();
    TextEditingController _registroIdDepartamentoController = TextEditingController();
    TextEditingController _registroCargoController = TextEditingController();
    TextEditingController _registroTipoUsuarioController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar Funcionário'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _registroNomeController,
                    decoration: InputDecoration(labelText: 'Nome do Funcionário'),
                  ),
                  TextFormField(
                    controller: _registroCpfController,
                    decoration: InputDecoration(labelText: 'CPF'),
                  ),
                  TextFormField(
                    controller: _registroEnderecoController,
                    decoration: InputDecoration(labelText: 'Endereço'),
                  ),
                  TextFormField(
                    controller: _registroSalarioController,
                    decoration: InputDecoration(labelText: 'Salário'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _registroTelefoneController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                  ),
                  TextFormField(
                    controller: _registroDataNascimentoController,
                    decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  ),
                  TextFormField(
                    controller: _registroUltimasFeriasController,
                    decoration: InputDecoration(labelText: 'Últimas Férias'),
                  ),
                  TextFormField(
                    controller: _registroEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _registroSenhaController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  DropdownButtonFormField(
                    value: _registroIdDepartamentoController.text.isNotEmpty
                        ? _registroIdDepartamentoController.text
                        : null,
                    items: departamentosList.map((departamento) {
                      return DropdownMenuItem(
                        value: departamento['id'],
                        child: Text(departamento['nome']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _registroIdDepartamentoController.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Departamento'),
                  ),


                  TextFormField(
                    controller: _registroCargoController,
                    decoration: InputDecoration(labelText: 'Cargo'),
                  ),
                  DropdownButtonFormField(
                    value: _registroTipoUsuarioController.text.isNotEmpty
                        ? _registroTipoUsuarioController.text
                        : null,
                    items: [
                      DropdownMenuItem(
                        value: '0',
                        child: Text('Comum'),
                      ),
                      DropdownMenuItem(
                        value: '1',
                        child: Text('Adm'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _registroTipoUsuarioController.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Tipo de Usuário'),
                  ),

                ],
              ),
            ),
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
                final novoCpf = _registroCpfController.text;
                final novoEndereco = _registroEnderecoController.text;
                final novoSalario = double.parse(_registroSalarioController.text);
                final novoTelefone = _registroTelefoneController.text;
                final novoDataNascimento = _registroDataNascimentoController.text;
                final novoUltimasFerias = _registroUltimasFeriasController.text;
                final novoEmail = _registroEmailController.text;
                final novoSenha = _registroSenhaController.text;
                final novoIdDepartamento = _registroIdDepartamentoController.text;
                final novoCargo = _registroCargoController.text;
                final novoTipoUsuario = int.parse(_registroTipoUsuarioController.text);

                final funcionario = {
                  'nome': novoNome,
                  'cpf': novoCpf,
                  'endereco': novoEndereco,
                  'salario': novoSalario,
                  'telefone': novoTelefone,
                  'dataNascimento': novoDataNascimento,
                  'ultimasFerias': novoUltimasFerias,
                  'email': novoEmail,
                  'senha': novoSenha,
                  'idDepartamento': novoIdDepartamento,
                  'cargo': novoCargo,
                  'tipoUsuario': novoTipoUsuario,
                };

                await registrarFuncionario(funcionario);

                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void filtrarFuncionarios(String query) {
    setState(() {
      funcionariosFiltrados = funcionarios.where((funcionario) {
        final nome = funcionario['nome'].toString().toLowerCase();
        return nome.contains(query.toLowerCase());
      }).toList();
    });
  }

  void exibirModalEditar(dynamic funcionario) {
    _editarNomeController.text = funcionario['nome'];
    _registroCpfController.text = funcionario['cpf'];
    _registroEnderecoController.text = funcionario['endereco'];
    _registroSalarioController.text = funcionario['salario'].toString();
    _registroTelefoneController.text = funcionario['telefone'];
    _registroDataNascimentoController.text = funcionario['dataNascimento'];
    _registroUltimasFeriasController.text = funcionario['ultimasFerias'];
    _registroEmailController.text = funcionario['email'];
    _registroSenhaController.text = funcionario['senha'];
    _registroIdDepartamentoController.text = funcionario['idDepartamento'];
    _registroCargoController.text = funcionario['cargo'];
    _registroTipoUsuarioController.text = funcionario['tipoUsuario'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Funcionário'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _editarNomeController,
                    decoration: InputDecoration(labelText: 'Nome do Funcionário'),
                  ),
                  TextFormField(
                    controller: _registroCpfController,
                    decoration: InputDecoration(labelText: 'CPF'),
                  ),
                  TextFormField(
                    controller: _registroEnderecoController,
                    decoration: InputDecoration(labelText: 'Endereço'),
                  ),
                  TextFormField(
                    controller: _registroSalarioController,
                    decoration: InputDecoration(labelText: 'Salário'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _registroTelefoneController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                  ),
                  TextFormField(
                    controller: _registroDataNascimentoController,
                    decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  ),
                  TextFormField(
                    controller: _registroUltimasFeriasController,
                    decoration: InputDecoration(labelText: 'Últimas Férias'),
                  ),
                  TextFormField(
                    controller: _registroEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _registroSenhaController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  TextFormField(
                    controller: _registroIdDepartamentoController,
                    decoration: InputDecoration(labelText: 'ID do Departamento'),
                  ),
                  TextFormField(
                    controller: _registroCargoController,
                    decoration: InputDecoration(labelText: 'Cargo'),
                  ),
                  TextFormField(
                    controller: _registroTipoUsuarioController,
                    decoration: InputDecoration(labelText: 'Tipo de Usuário'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
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
    final funcionarioAtualizado = {
    'nome': _editarNomeController.text,
    'cpf': _registroCpfController.text,
    'endereco': _registroEnderecoController.text,
    'salario': double.parse(_registroSalarioController.text),
    'telefone': _registroTelefoneController.text,
    'dataNascimento': _registroDataNascimentoController.text,
    'ultimasFerias': _registroUltimasFeriasController.text,
    'email': _registroEmailController.text,
    'senha': _registroSenhaController.text,
    'idDepartamento': _registroIdDepartamentoController.text,
    'cargo': _registroCargoController.text,
    'tipoUsuario': int.parse(_registroTipoUsuarioController.text),
    };
    await atualizarFuncionario(funcionarioAtualizado);

    Navigator.of(context).pop();
    },
      child: Text('Atualizar'),
    ),
          ],
      );
        },
    );
  }


        void exibirModalExclusao(dynamic funcionario) {
    // Implemente o código para exibir o modal de exclusão
    // ...
  }



  Future<void> atualizarListaFuncionarios() async {
    // Implemente a lógica para atualizar a lista de funcionários
    // Pode envolver chamar a função de busca novamente
    // ...

    setState(() {
      // Atualize a lista de funcionários
      // funcionarios = ...
      // funcionariosFiltrados = ...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabela de Funcionários'),
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
              onChanged: filtrarFuncionarios,
              decoration: InputDecoration(
                labelText: 'Pesquisar Funcionário',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: funcionariosFiltrados.length,
              itemBuilder: (context, index) {
                final funcionario = funcionariosFiltrados[index];
                return ListTile(
                  title: Text(funcionario['nome']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            funcionarioSelecionado = funcionario;
                          });
                          exibirModalEditar(funcionario);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          exibirModalExclusao(funcionario);
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
