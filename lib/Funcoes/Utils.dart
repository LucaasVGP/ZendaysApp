import 'package:shared_preferences/shared_preferences.dart';
import 'package:zendays/Configs/EHttpMethod.dart';
import 'package:zendays/Configs/Appsettings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zendays/Configs/ReturnAPI.dart';

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
        return new ReturnAPI(true,data['message'],data['data']);
      }else{
        return new ReturnAPI(false, "Erro externo",null);
      }

    } catch (e) {
      return new  ReturnAPI(false,"Erro externo $e",null);
    }
  }

}