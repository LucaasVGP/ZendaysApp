import 'package:flutter/material.dart';
import 'package:zendays/nossowidget/admin_menu.dart';

class RelatorioFeriasAdmPage extends StatefulWidget {
  @override
  _RelatorioFeriasAdmPageState createState() => _RelatorioFeriasAdmPageState();
}

class _RelatorioFeriasAdmPageState extends State<RelatorioFeriasAdmPage> {
  List<String> departamentos = ['Financeiro', 'Departamento 2', 'Departamento 3'];
  String selectedDepartamento = 'Financeiro';
  List<String> supervisores = ['Maria Souza', 'Supervisor 2', 'Supervisor 3'];
  String selectedSupervisor = 'Maria Souza';
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Férias'),
      ),
      drawer: AdminMenu(
        currentPage: 'relatorios',
        onMenuTap: (String page) {
          // Implementar a navegação para outras páginas aqui
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            buildFilterDropdown('Departamento', departamentos, selectedDepartamento, (String? value) {
              setState(() {
                selectedDepartamento = value!;
              });
            }),
            SizedBox(height: 16.0),
            buildFilterDropdown('Supervisor', supervisores, selectedSupervisor, (String? value) {
              setState(() {
                selectedSupervisor = value!;
              });
            }),
            SizedBox(height: 16.0),
            buildDateRangePicker(),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Aplicar Filtros'),
              onPressed: () {
                // Aplicar os filtros aqui
                // filtrarFeriasSolicitadas(selectedDepartamento, selectedSupervisor, startDate, endDate)
              },
            ),
            SizedBox(height: 16.0),
            buildFeriasSolicitadasCard('João Silva', '10', 'Sim', 'Maria Souza'),
            SizedBox(height: 16.0),
            buildFeriasSolicitadasCard('Maria Souza', '15', 'Não', 'José Santos'),
          ],
        ),
      ),
    );
  }

  Widget buildFilterDropdown(String label, List<String> options, String selectedOption, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
      ),
      value: selectedOption,
      onChanged: onChanged,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Período',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final pickedStartDate = await showDatePicker(
              context: context,
              initialDate: startDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedStartDate != null) {
              final pickedEndDate = await showDatePicker(
                context: context,
                initialDate: endDate ?? pickedStartDate,
                firstDate: pickedStartDate,
                lastDate: DateTime(2100),
              );

              if (pickedEndDate != null) {
                setState(() {
                  startDate = pickedStartDate;
                  endDate = pickedEndDate;
                });
              }
            }
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    startDate != null ? _formatDate(startDate!) : 'Data Início',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 8.0),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final pickedEndDate = await showDatePicker(
              context: context,
              initialDate: endDate ?? DateTime.now(),
              firstDate: startDate ?? DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedEndDate != null) {
              setState(() {
                endDate = pickedEndDate;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    endDate != null ? _formatDate(endDate!) : 'Data Fim',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(width: 8.0),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}';
  }

  Widget buildFeriasSolicitadasCard(String funcionario, String dias, String validado, String supervisor) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Funcionário: $funcionario',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Dias Vendidos: $dias',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Validado: $validado',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Supervisor: $supervisor',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetalhesFuncionarioPage()),
                );
              },
              child: Text('Ver mais'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalhesFuncionarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Funcionário'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Funcionário: João Silva'),
            SizedBox(height: 8.0),
            Text('Dias Vendidos: 10'),
            SizedBox(height: 8.0),
            Text('Salário: R\$ 5.000'),
            SizedBox(height: 8.0),
            Text('Custo: R\$ 10.000'),
            SizedBox(height: 8.0),
            Text('Supervisor: Maria Souza'),
          ],
        ),
      ),
    );
  }
}
