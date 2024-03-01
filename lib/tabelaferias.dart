import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

      class Data {
      final String id;
      final String idUsuario;

      Data({required this.id, required this.idUsuario});

      factory Data.fromJson(Map<String, dynamic> json) {
      return Data(
      id: json['id'],
        idUsuario: json['idUsuario'],
    );
  }
}

class DataListPage extends StatefulWidget {
@override
_DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
List<Data> dataList = [];

@override
void initState() {
super.initState();
fetchData();
}

Future<void> fetchData() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final String? token = preferences.getString('token');

  final response = await http.get(
    Uri.parse('https://2cee-2804-431-c7d3-ed9c-941f-2fb8-a25f-c0ad.ngrok-free.app/api/v1/Ferias/GetAll'),
    headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
  );

if (response.statusCode == 200) {
final jsonData = json.decode(response.body);
List<Data> tempList = [];

for (var item in jsonData) {
Data data = Data.fromJson(item);
tempList.add(data);
}

setState(() {
dataList = tempList;
});
} else {
throw Exception('Failed to fetch data');
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Data List'),
),
body: ListView.builder(
itemCount: dataList.length,
itemBuilder: (context, index) {
return ListTile(
title: Text(dataList[index].idUsuario),
subtitle: Text('ID: ${dataList[index].id}'),
);
},
),
);
}
}