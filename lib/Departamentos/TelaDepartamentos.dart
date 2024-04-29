import 'package:flutter/material.dart';
import 'package:zendays/Configs/EHttpMethod.dart';
import 'package:zendays/Configs/Utils.dart';
import 'package:zendays/Telasiniciais/admin_menu.dart';

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

  Future<void> fetchData() async {
    try {
      final response = await Utils.GetRetornoAPI(null,HttpMethod.GET, "/Departamento/GetAll", true);
      if (response.Sucesso) {
        setState(() {
          departamentos = Utils.ConvertResponseToMapList(response.Obj);
          departamentosFiltrados = List.from(departamentos);
        });
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");

      }
    } catch (e) {
      Utils.showToast("$e");
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

  Future<void> atualizarDepartamento(dynamic departamento) async {
    final requestBody = {
      'id': departamento['id'],
      'nome': departamento['nome'],
    };
    try {
      var response = await Utils.GetRetornoAPI(requestBody, HttpMethod.PUT, "/Departamento/Update'", true);
      var mensagem = response.Mensagem;
      Utils.showToast("$mensagem");
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> excluirDepartamento(dynamic departamento) async {
    try {
      var response = await Utils.GetRetornoAPI(null, HttpMethod.DELETE, "/Departamento/Disable?id=${departamento['id']}", true);
      if(response.Sucesso) {
        fetchData();
      }
      else{
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> registrarDepartamento(dynamic departamento) async {
    try {
      var response = await Utils.GetRetornoAPI(departamento, HttpMethod.POST, "/Departamento/Register", true);

      if(response.Sucesso){
        fetchData();
      }
      else{
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  //Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departamentos', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF275657),
      ),
      drawer: AdminMenu(
        currentPage: 'Departamentos',
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
              onChanged: filtrarDepartamentos,
              decoration: InputDecoration(
                labelText: 'Pesquisar Departamentos',
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

  @override
  void initState() {
    super.initState();
    fetchData();
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
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
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

}
