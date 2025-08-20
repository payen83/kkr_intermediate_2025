import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

final ApiServices api = ApiServices();

class ApiServices {

  var baseURL = 'http://10.0.2.2:8888/api';

  Future getDio(String path, {Map<String, dynamic>? params}) async {
    var headers = {'accept': 'application/json'};
    String fullURL = baseURL + path;
      
    try {
      var response = await Dio().get(
        fullURL,
        queryParameters: params,
        options: Options(headers: headers)
      );

      if(response.statusCode == 200){
        log('success!!');
        log(jsonEncode(response.data));
        return response.data;
      } else {
        log('Request failed. Status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}