import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zendays/Configs/EHttpMethod.dart';
import 'package:zendays/Configs/Utils.dart';
import 'package:zendays/Telasiniciais/admin_menu.dart';

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
  final TextEditingController _registroCpfController = TextEditingController();
  final TextEditingController _registroEnderecoController =
      TextEditingController();
  final TextEditingController _registroSalarioController =
      TextEditingController();
  final TextEditingController _registroTelefoneController =
      TextEditingController();
  final TextEditingController _registroDataNascimentoController =
      TextEditingController();
  final TextEditingController _registroUltimasFeriasController =
      TextEditingController();
  final TextEditingController _registroEmailController =
      TextEditingController();
  final TextEditingController _registroIdDepartamentoController =
      TextEditingController();
  final TextEditingController _registroCargoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDepartamentos();
  }

  Future<void> fetchData() async {
    try {
      var url = "/Usuario/GetAll";
      var tipoUsuario = await Utils.returnInfo("tipo");
      if (tipoUsuario != "2") {
        var departamento = await Utils.returnInfo("departamento");
        url = "/Usuario/GetAllFiltros?departamentoId=${departamento}";
      }
      var response = await Utils.GetRetornoAPI(null, HttpMethod.GET, url, true);
      if (response.Sucesso) {
        setState(() {
          funcionarios = Utils.ConvertResponseToMapList(response.Obj);
          funcionariosFiltrados = List.from(funcionarios);
        });
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> fetchDepartamentos() async {
    try {
      var response = await Utils.GetRetornoAPI(
          null, HttpMethod.GET, "/Departamento/GetAll", true);
      if (response.Sucesso) {
        setState(() {
          departamentosList = Utils.ConvertResponseToMapList(response.Obj);
        });
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> excluirFuncionario(dynamic funcionario) async {
    var usuarioLogado = await Utils.returnInfo("id");
    if (usuarioLogado == funcionario['id']) {
      Utils.showToast("ação Invalida");
    } else {
      try {
        var response = await Utils.GetRetornoAPI(null, HttpMethod.DELETE,
            "/Usuario/Delete?id=${funcionario['id']}", true);
        if (response.Sucesso) {
          fetchData();
        } else {
          var erro = response.Mensagem;
          Utils.showToast("$erro");
        }
      } catch (e) {
        Utils.showToast("$e");
      }
    }
  }

  Future<void> registrarFuncionario(dynamic funcionario) async {
    var tipoUsuario = await Utils.returnInfo("tipo");
    final requestBody = {
      "Nome": funcionario['nome'],
      "Cpf": funcionario['cpf'],
      "Endereco": funcionario['endereco'],
      "Salario": funcionario['salario'],
      "Telefone": funcionario['telefone'],
      "DataNascimento": funcionario['dataNascimento'],
      "ultimasFerias": funcionario['ultimasFerias'], // Alteração aqui
      "Email": funcionario['email'],
      "Senha": funcionario['senha'],
      "IdDepartamento": funcionario['idDepartamento'],
      "Cargo": funcionario['cargo'],
      "TipoUsuario": tipoUsuario == "2" ? "1" : "0"
    };

    try {
      var response = await Utils.GetRetornoAPI(
          requestBody, HttpMethod.POST, "/Usuario/Register", true);
      if (response.Sucesso) {
        fetchData();
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> atualizarFuncionario(dynamic funcionario) async {
    try {
      var response = await Utils.GetRetornoAPI(
          funcionario, HttpMethod.PUT, "/Usuario/Update", true);
      if (response.Sucesso) {
        fetchData();
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  void filtrarFuncionarios(String query) {
    setState(() {
      funcionariosFiltrados = funcionarios.where((funcionario) {
        final nome = funcionario['nome'].toString().toLowerCase();
        return nome.contains(query.toLowerCase());
      }).toList();
    });
  }

  String getNomeDepartamento(String idDepartamento) {
    final departamento = departamentosList.firstWhere(
          (departamento) => departamento['id'].toString() == idDepartamento,
      orElse: () => {'nome': 'Desconhecido'},
    );
    return departamento['nome'];
  }



  //Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funcionarios', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF275657),
      ),
      drawer: AdminMenu(
        currentPage: 'Funcionarios',
        onMenuTap: (String page) {},
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
                final nomeDepartamento = getNomeDepartamento(funcionario['idDepartamento'].toString());
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF275657),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      funcionario['nome'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('$nomeDepartamento - ${funcionario['cargo']}'),
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
                  ),
                );
              },
            ),
          ),




        ],
      ),
    );
  }

  void exibirModalExclusao(dynamic funcionario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Deseja excluir o funcionário ${funcionario['nome']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await excluirFuncionario(funcionario);
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void exibirModalRegistro() {
    TextEditingController _registroNomeController = TextEditingController();
    TextEditingController _registroCpfController = TextEditingController();
    TextEditingController _registroEnderecoController = TextEditingController();
    TextEditingController _registroSalarioController = TextEditingController();
    TextEditingController _registroTelefoneController = TextEditingController();
    TextEditingController _registroDataNascimentoController =
        TextEditingController();
    TextEditingController _registroUltimasFeriasController =
        TextEditingController();
    TextEditingController _registroEmailController = TextEditingController();
    TextEditingController _registroSenhaController = TextEditingController();
    TextEditingController _registroIdDepartamentoController =
        TextEditingController();
    TextEditingController _registroCargoController = TextEditingController();

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
                    decoration:
                        InputDecoration(labelText: 'Nome do Funcionário'),
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
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      suffixIcon: IconButton(
                        onPressed: () => _selectData(
                            context, _registroDataNascimentoController),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () =>
                        _selectData(context, _registroDataNascimentoController),
                  ),
                  TextFormField(
                    controller: _registroUltimasFeriasController,
                    decoration: InputDecoration(
                      labelText: 'Últimas Férias',
                      suffixIcon: IconButton(
                        onPressed: () => _selectData(
                            context, _registroUltimasFeriasController),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () =>
                        _selectData(context, _registroUltimasFeriasController),
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
                        _registroIdDepartamentoController.text =
                            value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Departamento'),
                  ),
                  TextFormField(
                    controller: _registroCargoController,
                    decoration: InputDecoration(labelText: 'Cargo'),
                  )
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
                if (_registroIdDepartamentoController.text == null ||
                    _registroIdDepartamentoController.text == "") {

                  Utils.showToast("Departamento obrigatorio",2);
                } else {
                  final novoNome = _registroNomeController.text;
                  final novoCpf = _registroCpfController.text;
                  final novoEndereco = _registroEnderecoController.text;
                  final novoSalario =
                      double.parse(_registroSalarioController.text);
                  final novoTelefone = _registroTelefoneController.text;
                  final novoDataNascimento =
                      _registroDataNascimentoController.text;
                  final novoUltimasFerias =
                      _registroUltimasFeriasController.text;
                  final novoEmail = _registroEmailController.text;
                  final novoSenha = _registroSenhaController.text;
                  final novoIdDepartamento =
                      _registroIdDepartamentoController.text;
                  final novoCargo = _registroCargoController.text;

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
                    'cargo': novoCargo
                  };

                  await registrarFuncionario(funcionario);

                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void exibirModalEditar(dynamic funcionario) {
    // Preencher os controladores com os dados do funcionário selecionado
    _editarNomeController.text = funcionario['nome'];
    _registroCpfController.text = funcionario['cpf'];
    _registroEnderecoController.text = funcionario['endereco'];
    _registroSalarioController.text = funcionario['salario'].toString();
    _registroTelefoneController.text = funcionario['telefone'];
    _registroDataNascimentoController.text = funcionario['dataNascimento'];
    _registroUltimasFeriasController.text = funcionario['ultimasFerias'];
    _registroEmailController.text = funcionario['email'];
    _registroIdDepartamentoController.text = funcionario['idDepartamento'];
    _registroCargoController.text = funcionario['cargo'];

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
                    decoration:
                        InputDecoration(labelText: 'Nome do Funcionário'),
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
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      suffixIcon: IconButton(
                        onPressed: () => _selectData(
                            context, _registroDataNascimentoController),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () =>
                        _selectData(context, _registroDataNascimentoController),
                  ),
                  TextFormField(
                    controller: _registroUltimasFeriasController,
                    decoration: InputDecoration(
                      labelText: 'Últimas Férias',
                      suffixIcon: IconButton(
                        onPressed: () => _selectData(
                            context, _registroUltimasFeriasController),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () =>
                        _selectData(context, _registroUltimasFeriasController),
                  ),
                  TextFormField(
                    controller: _registroEmailController,
                    decoration: InputDecoration(labelText: 'Email'),
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
                        _registroIdDepartamentoController.text =
                            value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Departamento'),
                  ),
                  TextFormField(
                    controller: _registroCargoController,
                    decoration: InputDecoration(labelText: 'Cargo'),
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
                // Coletar os valores atualizados dos campos
                final funcionarioAtualizado = {
                  'id': funcionario['id'],
                  'nome': _editarNomeController.text,
                  'cpf': _registroCpfController.text,
                  'endereco': _registroEnderecoController.text,
                  'salario': double.parse(_registroSalarioController.text),
                  'telefone': _registroTelefoneController.text,
                  'dataNascimento': _registroDataNascimentoController.text,
                  'ultimasFerias': _registroUltimasFeriasController.text,
                  'email': _registroEmailController.text,
                  'idDepartamento': _registroIdDepartamentoController.text,
                  'cargo': _registroCargoController.text,
                };

                await atualizarFuncionario(funcionarioAtualizado);

                // Fechar o diálogo de edição
                Navigator.of(context).pop();
              },
              child: Text('Atualizar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectData(
      BuildContext context, TextEditingController dataController) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1900),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        dataController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}
