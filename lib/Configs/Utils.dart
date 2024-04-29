import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zendays/Configs/EHttpMethod.dart';
import 'package:zendays/Configs/Appsettings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zendays/Configs/ReturnAPI.dart';
import 'package:zendays/Configs/TokenInfo.dart';

class Utils {
  static Future<void> saveInfo(String info,String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(info,value);
  }

  static Future<String?> returnInfo(String info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(info);
    return token;
  }

  static Future<TokenInfo> returnAllInfoToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tipo = prefs.getString("tipo");
    String? email = prefs.getString("email");

    var tipoUsuario = "";

    switch (tipo) {
      case '0':
      //colaborador
        tipoUsuario = "Colaborador";
        break;
      case '1':
        tipoUsuario = "Supervisor";
        break;
      case '2':
        tipoUsuario = "Administrador";
        break;
    }

    return new TokenInfo(TipoUsuarioExibicao: tipoUsuario, Email: email!,TipoUsuario:tipo!);
  }

  static Future<ReturnAPI> GetRetornoAPI(dynamic obj,HttpMethod method,String url,bool autenticado) async{

    var headers = {'Content-Type': 'application/json'};
    if(autenticado == true) {
      final getToken = await returnInfo("token");
      headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $getToken'};
    }
    final apiUrl = Appsettings.api_url;
    final urlCompleta = apiUrl + url;
    final requestBody = jsonEncode(obj);
    try {
      http.Response response;
      switch(method){
        case HttpMethod.POST:
          response = await http.post(Uri.parse(urlCompleta), headers: headers, body: requestBody);
          break;
        case HttpMethod.GET:
          response = await http.get(Uri.parse(urlCompleta), headers: headers);
          break;
        case HttpMethod.PUT:
          response = await http.put(Uri.parse(urlCompleta), headers: headers, body: requestBody);
          break;
        case HttpMethod.DELETE:
          response = await http.delete(Uri.parse(urlCompleta), headers: headers);
          break;
      }
      if(response.statusCode != 500)
      {
        Map<String, dynamic> data = json.decode(response.body);
        return new ReturnAPI(data['success'],data['message'],data['data']);
      }else{
        return new ReturnAPI(false, "Erro externo",null);
      }

    } catch (e) {
      return new  ReturnAPI(false,"Erro externo $e",null);
    }
  }

  static List<Map<String, dynamic>> ConvertResponseToMapList(dynamic responseObject) {
    List<Map<String, dynamic>> objList = [];
    if (responseObject != null && responseObject is List) {
      for (dynamic department in responseObject) {
        if (department is Map<String, dynamic>) {
          objList.add(department);
        }
      }
    }
    return objList;
  }

  static void showToast(String message,[int? tempo]) {
    var tempoToast = 5;
    if(tempo != null) tempoToast = tempo;
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: tempoToast,
    );
  }
}