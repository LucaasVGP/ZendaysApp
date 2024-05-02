import 'package:flutter/material.dart';
import 'package:zendays/Configs/EHttpMethod.dart';
import 'package:zendays/Configs/Utils.dart';
import 'package:zendays/Telasiniciais/admin_menu.dart';

class TelaFeriasPage extends StatefulWidget {
  @override
  _TelaFeriasPageState createState() => _TelaFeriasPageState();
}

class _TelaFeriasPageState extends State<TelaFeriasPage> {
  List<dynamic> ferias = [];
  List<dynamic> departamentosList = [];
  List<dynamic> feriasFiltrados = [];
  final TextEditingController _searchController = TextEditingController();
  dynamic feriasSelecionada;
  // Controladores no início da classe
  final TextEditingController _registroDataInicioController = TextEditingController();
  final TextEditingController _registroDataFimController = TextEditingController();
  final TextEditingController _registroDiasVendidosController = TextEditingController();
  final TextEditingController _registroMensagemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData() async {
    try {

      var idUsuario = await Utils.returnInfo("id");
      var url = "/Ferias/usuario?userId=$idUsuario";
      var response = await Utils.GetRetornoAPI(null, HttpMethod.GET, url, true);
      if (response.Sucesso) {
        setState(() {
          ferias = Utils.ConvertResponseToMapList(response.Obj);
          feriasFiltrados = ferias;
        });
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }


  Future<void> excluirFerias(dynamic Ferias) async {
    try {
      var response = await Utils.GetRetornoAPI(
          null, HttpMethod.DELETE, "/Ferias/Delete?id=${Ferias['id']}",
          true);
      if (response.Sucesso) {
        fetchData();
      }
      else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> registrarFerias(dynamic Ferias) async {
    var idUsuario = await Utils.returnInfo("id");

    final requestBody = {
      'dataInicio': Ferias['dataInicio'],
      'dataFim': Ferias['dataFim'],
      'diasVendidos': Ferias['diasVendidos'],
      'mensagem': Ferias['mensagem'],
      'idUsuario': idUsuario
    };


    try {
      var response = await Utils.GetRetornoAPI(requestBody, HttpMethod.POST, "/Ferias/Register", true);
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

  Future<void> atualizarFerias(dynamic Ferias) async {
    try {
      var response = await Utils.GetRetornoAPI(Ferias, HttpMethod.PUT,"/Ferias/Update",true);
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

  /*void filtrarferias(String query) {
    setState(() {
      feriasFiltrados = ferias.where((Ferias) {
        final nome = Ferias['nome'].toString().toLowerCase();
        return nome.contains(query.toLowerCase());
      }).toList();
    });
  }*/

  //Widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ferias', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF275657),
      ),
      drawer: AdminMenu(
        currentPage: 'ferias',
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
            child: DropdownButtonFormField(
              value: _searchController.text.isNotEmpty
                  ? _searchController.text
                  : null,
              items: <String>['0', '1', '2'] //validar tipo vazio para não filtrar
              .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
              value: value,
              child: Text(getDropdownText(value)),
              );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _searchController.text = value.toString();
                });
              },
              decoration: InputDecoration(labelText: 'Status Ferias'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: feriasFiltrados.length,
              itemBuilder: (context, index) {
                final Ferias = feriasFiltrados[index];
                var dataInicio = Ferias['dataInicio'];
                var dataFim = Ferias['dataFim'];
                return ListTile(
                  title: Text("$dataInicio - $dataFim"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            feriasSelecionada = Ferias;
                          });
                          exibirModalEditar(Ferias);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          exibirModalExclusao(Ferias);
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

String getDropdownText(String value) {
  switch (value) {
    case '0':
      return 'Solicitado';
    case '1':
      return 'Aprovado';
    case '2':
      return 'Rejeitado';
    default:
      return '';
  }
}


  void exibirModalExclusao(dynamic Ferias) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Deseja excluir a ferias seleciona?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await excluirFerias(Ferias);
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar Ferias'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _registroDataInicioController,
                    decoration: InputDecoration(labelText: 'Data Inicio'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextFormField(
                    controller: _registroDataFimController,
                    decoration: InputDecoration(labelText: 'Data Fim'),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextFormField(
                    controller: _registroDiasVendidosController,
                    decoration: InputDecoration(labelText: 'Dias Vendidos'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _registroMensagemController,
                    decoration: InputDecoration(labelText: 'Observação'),
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
                final Ferias = {
                  'dataInicio': _registroDataInicioController.text,
                  'dataFim': _registroDataFimController.text,
                  'diasVendidos': _registroDiasVendidosController.text,
                  'mensagem': _registroMensagemController.text
                };

                await registrarFerias(Ferias);

                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void exibirModalEditar(dynamic Ferias) {
    _registroDataInicioController.text = Ferias['dataInicio'];
    _registroDataFimController.text = Ferias['dataFim'];
    _registroDiasVendidosController.text = Ferias['diasVendidos'].toString();
    _registroMensagemController.text = Ferias['mensagem'];


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Ferias'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _registroDataInicioController,
                    decoration: InputDecoration(labelText: 'Data Inicio'),
                    //keyboardType: TextInputType.datetime,
                  ),
                  TextFormField(
                    controller: _registroDataFimController,
                    decoration: InputDecoration(labelText: 'Data Fim'),
                    //keyboardType: TextInputType.datetime,
                  ),
                  TextFormField(
                    controller: _registroDiasVendidosController,
                    decoration: InputDecoration(labelText: 'Dias Vendidos'),
                    //keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _registroMensagemController,
                    decoration: InputDecoration(labelText: 'Observação'),
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

                final FeriasAtualizado = {
                  'id': Ferias['id'],
                  'dataInicio': _registroDataInicioController.text,
                  'dataFim': _registroDataFimController.text,
                  'diasVendidos': _registroDiasVendidosController.text,
                  'mensagem': _registroMensagemController.text
                };

                await atualizarFerias(FeriasAtualizado);

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

}