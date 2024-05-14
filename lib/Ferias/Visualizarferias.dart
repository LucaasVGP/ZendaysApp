import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zendays/Configs/Utils.dart';
import 'package:zendays/Configs/EHttpMethod.dart';

import '../Telasiniciais/admin_menu.dart';

class VisualizarFeriasPage extends StatefulWidget {
  @override
  _VisualizarFeriasPageState createState() => _VisualizarFeriasPageState();
}

class _VisualizarFeriasPageState extends State<VisualizarFeriasPage> {

  List<dynamic> ferias = [];
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _dataFimController = TextEditingController();
  List<dynamic> departamentosList = [];

  Future<void> fetchData() async {
    try {
      var url = "/Ferias";
      var tipoUsuario = await Utils.returnInfo("tipo");
      switch(tipoUsuario){
        case "1":
          var departamentoId = await Utils.returnInfo("departamento");
          var usuarioId = await Utils.returnInfo("id");
          url += "?idDepartamento=$departamentoId&idUsuarioExcluir=$usuarioId&tipoUsuarioExcluir=1";
          break;
        case "2":
          url += "?tipoUsuario=1";
          break;
      }
      var response = await Utils.GetRetornoAPI(null, HttpMethod.GET, url, true);
      if (response.Sucesso) {
        setState(() {
          ferias = Utils.ConvertResponseToMapList(response.Obj);
        });
      } else {
        var erro = response.Mensagem;
        Utils.showToast("$erro");
      }
    } catch (e) {
      Utils.showToast("$e");
    }
  }

  Future<void> fetchDataFiltro(String? dataInicio,String? dataFim,String? status,String? departamento) async {
    setState(() {
      ferias = [];
    });
    try {
      var url = "/Ferias";
      var tipoUsuario = await Utils.returnInfo("tipo");
      switch(tipoUsuario){
        case "1":
          var departamentoId = await Utils.returnInfo("departamento");
          var usuarioId = await Utils.returnInfo("id");
          url += "?idDepartamento=$departamentoId&idUsuarioExcluir=$usuarioId&tipoUsuarioExcluir=1";
          break;
        case "2":
          url += "?tipoUsuario=1";
          break;
      }

      if(dataInicio != null && dataInicio != "" && dataFim != null && dataFim != ""){

        var dataInicioFormatada = dataInicio.replaceAll("/", "%2F");
        var dataFimFormatada = dataFim.replaceAll("/", "%2F");
        url+= "&dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada";
      }

      if(departamento != null && departamento != ""){
        url+= "&idDepartamento=$departamento";
      }

      if((status != null && status != "" ) || status != "3" && status != ""){
        url+= "&status=$status";
      }
      var response = await Utils.GetRetornoAPI(null, HttpMethod.GET, url, true);
      if (response.Sucesso) {
        setState(() {
          ferias = Utils.ConvertResponseToMapList(response.Obj);
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
      var response = await Utils.GetRetornoAPI(null, HttpMethod.GET, "/Departamento/GetAll", true);
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

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDepartamentos();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualização de Férias', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF275657),
      ),
      drawer: AdminMenu(
        currentPage: 'visualizarFerias',
        onMenuTap: (String page) {},
      ),
      body: FutureBuilder<String?>(
        future: Utils.returnInfo("tipo"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String? tipoUsuario = snapshot.data;
            return Column(
              children: [
               Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dataInicioController,
                            decoration: InputDecoration(
                              labelText: 'Data Inicio',
                              suffixIcon: IconButton(
                                onPressed: () => _selectData(context,_dataInicioController),
                                icon: Icon(Icons.calendar_today),
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectData(context,_dataInicioController),
                          ),
                        ),
                        SizedBox(width: 16), // Espaço entre os campos
                        Expanded(
                          child: TextFormField(
                            controller: _dataFimController,
                            decoration: InputDecoration(
                              labelText: 'Data Fim',
                              suffixIcon: IconButton(
                                onPressed: () => _selectData(context,_dataInicioController),
                                icon: Icon(Icons.calendar_today),
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectData(context,_dataFimController),
                          ),
                        ),

                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: DropdownButtonFormField(
                    value: _statusController.text == null || _statusController.text == ""?"3":_statusController.text,
                    items: <String>['0', '1', '2','3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(getDropdownText(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _statusController.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Status Ferias'),
                  ),
                ),
                tipoUsuario == "2" ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: DropdownButtonFormField(
                    value: _departamentoController.text.isNotEmpty
                        ? _departamentoController.text
                        : null,
                    items: departamentosList.map((departamento) {
                      return DropdownMenuItem(
                        value: departamento['id'],
                        child: Text(departamento['nome']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _departamentoController.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Departamento'),
                  ),
                ):Container(),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              fetchDataFiltro(_dataInicioController.text, _dataFimController.text, _statusController.text, _departamentoController.text);
                            });

                          },
                          child: Text('Botão'),
                        )

                      ],
                    )
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: ferias.length,
                    separatorBuilder: (context, index) => Divider(height: 1.0),
                    itemBuilder: (context, index) {
                      final feriasAtual = ferias[index];
                      var nomeUsuario = feriasAtual['nomeUsuario'];
                      var nomeDepartamento = feriasAtual['nomeDepartamento'];
                      return Card(
                        child: ListTile(
                          title: Text("$nomeUsuario - $nomeDepartamento"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Data Início: ${feriasAtual['dataInicio']}'),
                              Text('Data Fim: ${feriasAtual['dataFim']}'),
                              Text('Data Pedido: ${feriasAtual['dataPedido']}'),
                              Text('Vendido: ${feriasAtual['diasVendidos']} dias'),
                              Text('Status: ${feriasAtual['status']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
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
      case '3':
        return 'Todos';
      default:
        return '';
    }
  }

  Future<void> _selectData(BuildContext context,TextEditingController dataController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
        initialDate: DateTime(2024),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100)
    );
    if (picked != null) {
      setState(() {
        dataController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

}