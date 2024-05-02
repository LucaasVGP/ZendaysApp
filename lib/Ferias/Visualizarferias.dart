import 'package:flutter/material.dart';
import 'package:zendays/Configs/Utils.dart';
import 'package:zendays/Configs/EHttpMethod.dart';

import '../Telasiniciais/admin_menu.dart';

class VisualizarFeriasPage extends StatefulWidget {
  @override
  _VisualizarFeriasPageState createState() => _VisualizarFeriasPageState();
}

class _VisualizarFeriasPageState extends State<VisualizarFeriasPage> {

  List<dynamic> ferias = [];


  Future<void> fetchData() async {
    try {
      var url = "/Ferias/";
      var tipoUsuario = await Utils.returnInfo("tipo");
      switch(tipoUsuario){
        case "1":
          var departamentoId = await Utils.returnInfo("departamento");
          url += "departamento?idDepartamento=$departamentoId";
          break;
        case "2":
          url += "tipoUsuario?tipoUsuario=1";
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

  @override
  void initState() {
    super.initState();
    fetchData();
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
      body: ListView.separated(
        itemCount: ferias.length,
        separatorBuilder: (context, index) => Divider(height: 1.0),
        itemBuilder: (context, index) {
          final feriasAtual = ferias[index];
          var dataInicio = feriasAtual['dataInicio'];
          var dataFim = feriasAtual['dataFim'];
          return Card(
            child: ListTile(
              title: Text("$dataInicio - $dataFim"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data Início: ${feriasAtual['dataInicio']}'),
                  Text('Data Fim: ${feriasAtual['dataFim']}'),
                  Text('Data Pedido: ${feriasAtual['dataPedido']}'),
                  Text('Vendido: ${feriasAtual['diasVendidos']} dias'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}