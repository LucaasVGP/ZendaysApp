import 'package:flutter/material.dart';

class AprovacaoFeriasPage extends StatefulWidget {
  @override
  _AprovacaoFeriasPageState createState() => _AprovacaoFeriasPageState();
}

class _AprovacaoFeriasPageState extends State<AprovacaoFeriasPage> {
  final List<SolicitacaoFerias> solicitacoes = [
    SolicitacaoFerias(
      dataInicio: DateTime(2023, 1, 1),
      dataFim: DateTime(2023, 1, 15),
      dataPedido: DateTime(2023, 1, 1),
      funcionario: 'João Silva',
      diasParaVender: 5,
      validado: false,
    ),
    SolicitacaoFerias(
      dataInicio: DateTime(2023, 2, 1),
      dataFim: DateTime(2023, 2, 15),
      dataPedido: DateTime(2023, 2, 1),
      funcionario: 'Maria Souza',
      diasParaVender: 3,
      validado: true,
    ),
    SolicitacaoFerias(
      dataInicio: DateTime(2023, 3, 1),
      dataFim: DateTime(2023, 3, 15),
      dataPedido: DateTime(2023, 3, 1),
      funcionario: 'Carlos Ferreira',
      diasParaVender: 10,
      validado: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprovação de Férias'),
      ),
      body: ListView.separated(
        itemCount: solicitacoes.length,
        separatorBuilder: (context, index) => Divider(height: 1.0),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(solicitacoes[index].funcionario),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data Início: ${solicitacoes[index].dataInicio.toString()}'),
                  Text('Data Fim: ${solicitacoes[index].dataFim.toString()}'),
                  Text('Data Pedido: ${solicitacoes[index].dataPedido.toString()}'),
                  Text('Vendido: ${solicitacoes[index].diasParaVender} dias'),
                  Text('Validado: ${solicitacoes[index].validado ? 'Sim' : 'Não'}'),
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
                                  // Lógica para aprovar a solicitação
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
                                  // Lógica para recusar a solicitação
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

class SolicitacaoFerias {
  final DateTime dataInicio;
  final DateTime dataFim;
  final DateTime dataPedido;
  final String funcionario;
  final int diasParaVender;
  final bool validado;

  SolicitacaoFerias({
    required this.dataInicio,
    required this.dataFim,
    required this.dataPedido,
    required this.funcionario,
    required this.diasParaVender,
    required this.validado,
  });
}
