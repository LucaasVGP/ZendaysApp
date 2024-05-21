import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _registroDataInicioController = TextEditingController();
  final TextEditingController _registroDataFimController = TextEditingController();
  final TextEditingController _registroDiasVendidosController = TextEditingController();
  final TextEditingController _registroMensagemController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    fetchData();
    _registroDataFimController.addListener(_verificarPeriodoMaximo);
  }

  Future<void> fetchData({String status = "3"}) async {
    try {
      var idUsuario = await Utils.returnInfo("id");
      var url = "/Ferias?userId=$idUsuario";

      if (status != "3") url += "&status=$status";
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
      } else {
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
      var response = await Utils.GetRetornoAPI(Ferias, HttpMethod.PUT, "/Ferias/Update", true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Férias', style: TextStyle(color: Colors.white)),
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
              value: "3",
              items: <String>['0', '1', '2', '3'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(getDropdownText(value)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _searchController.text = value.toString();
                  feriasFiltrados = [];
                });

                fetchData(status: value.toString());
              },
              decoration: InputDecoration(labelText: 'Status Férias'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: feriasFiltrados.length,
              itemBuilder: (context, index) {
                final Ferias = feriasFiltrados[index];
                var dataInicio = Ferias['dataInicio'];
                var dataFim = Ferias['dataFim'];
                var status = Ferias['status'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 0, // Removendo a sombra do card
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Período: $dataInicio - $dataFim",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                getStatusIcon(status),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Status: ${getDropdownText(status.toString())}",
                              style: TextStyle(
                                color: getStatusColor(status),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Dias Vendidos: ${Ferias['diasVendidos']}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "Observação: ${Ferias['mensagem']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                          ],
                        ),
                      ),
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

  Icon getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icon(Icons.hourglass_empty, color: Colors.yellow);
      case 1:
        return Icon(Icons.check_circle, color: Colors.green);
      case 2:
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help);
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.yellow[700]!;
      case 1:
        return Colors.green[700]!;
      case 2:
        return Colors.red[700]!;
      default:
        return Colors.transparent;
    }
  }

  String getDropdownText(String value) {
    switch (value) {
      case '0':
        return 'Solicitado';
      case '1':
        return 'Aprovado';
      case '2':
        return 'Rejeitado';
      case '3':
        return 'Todos';
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
          content: Text('Deseja excluir a férias selecionada?'),
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
    _registroDataInicioController.clear();
    _registroDataFimController.clear();
    _registroDiasVendidosController.clear();
    _registroMensagemController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar Férias'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _registroDataInicioController,
                    decoration: InputDecoration(
                      labelText: 'Data Início',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDataInicio(context),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDataInicio(context),
                  ),
                  TextFormField(
                    controller: _registroDataFimController,
                    decoration: InputDecoration(
                      labelText: 'Data Fim',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDataFim(context),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDataFim(context),
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
          title: Text('Editar Férias'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _registroDataInicioController,
                    decoration: InputDecoration(
                      labelText: 'Data Início',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDataInicio(context),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDataInicio(context),
                  ),
                  TextFormField(
                    controller: _registroDataFimController,
                    decoration: InputDecoration(
                      labelText: 'Data Fim',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDataFim(context),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDataFim(context),
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
                final FeriasAtualizado = {
                  'id': Ferias['id'],
                  'dataInicio': _registroDataInicioController.text,
                  'dataFim': _registroDataFimController.text,
                  'diasVendidos': _registroDiasVendidosController.text,
                  'mensagem': _registroMensagemController.text
                };

                await atualizarFerias(FeriasAtualizado);

                Navigator.of(context).pop();
              },
              child: Text('Atualizar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDataInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _registroDataInicioController.text = _dateFormat.format(picked);
        _verificarPeriodoMaximo();
      });
    }
  }

  Future<void> _selectDataFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _registroDataFimController.text = _dateFormat.format(picked);
        _verificarPeriodoMaximo();
      });
    }
  }

  void _verificarPeriodoMaximo() {
    if (_registroDataInicioController.text.isNotEmpty && _registroDataFimController.text.isNotEmpty) {
      DateTime dataInicio = _dateFormat.parse(_registroDataInicioController.text);
      DateTime dataFim = _dateFormat.parse(_registroDataFimController.text);
      if (dataFim.difference(dataInicio).inDays > 30) {
        setState(() {
          _registroDataFimController.clear();
        });
        Utils.showToast("O período máximo de uma solicitação de férias é de 30 dias.");
      }
    }
  }
}
