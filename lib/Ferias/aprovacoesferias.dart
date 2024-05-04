import 'package:flutter/material.dart';
import 'package:zendays/Configs/Utils.dart';
import 'package:zendays/Configs/EHttpMethod.dart';

import '../Telasiniciais/admin_menu.dart';

class AprovacaoFeriasPage extends StatefulWidget {
  @override
  _AprovacaoFeriasPageState createState() => _AprovacaoFeriasPageState();
}

class _AprovacaoFeriasPageState extends State<AprovacaoFeriasPage> {

  List<dynamic> ferias = [];


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


      url+="&status=0";
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

  Future<void> UpdateFerias(String IdFerias,String status) async{
    try {
    var url = "/Ferias/Status?id=$IdFerias&status=$status";
    var response = await Utils.GetRetornoAPI(null, HttpMethod.PATCH, url, true);
    if (response.Sucesso) {
      setState(() {
        ferias = [];
      });
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
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprovacão de férias', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF275657),
      ),
      drawer: AdminMenu(
        currentPage: 'ferias',
        onMenuTap: (String page) {},
      ),
      body: ListView.separated(
        itemCount: ferias.length,
        separatorBuilder: (context, index) => Divider(height: 1.0),
        itemBuilder: (context, index) {
          final feriasAtual = ferias[index];
          var IdFerias = feriasAtual['id'];
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
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para aprovar a solicitação de férias
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Aprovar Solicitação'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Deseja aprovar a solicitação de férias?'),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Observação',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  UpdateFerias(IdFerias, "1");
                                },
                                child: Text('Aprovar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Aprovar'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para recusar a solicitação de férias
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Recusar Solicitação'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Deseja recusar a solicitação de férias?'),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Observação',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  UpdateFerias(IdFerias, "2");
                                },
                                child: Text('Recusar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancelar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Recusar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}