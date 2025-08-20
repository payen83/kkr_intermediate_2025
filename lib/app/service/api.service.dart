import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kkr_intermediate_2025/app/service/sharedpreference.service.dart';

final ApiServices api = ApiServices();

class ApiServices {

  var baseURL = 'http://10.0.2.2:8888/api';


  Future<Response?> postDio(String path, FormData? formdata) async {
    String token = await UserSharedPreferences.getLocalStorage('token');
    String fullURL = baseURL + path;

    var headers = {
      'accept': 'application/json'
    };

    if(token.isNotEmpty){
      headers['authorization'] = 'Bearer $token';
    }
    var response = await Dio().post(
      fullURL, data: formdata, options: Options(headers: headers));
      
    return response;
  }

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
        // log('success!!');
        // log(jsonEncode(response.data));
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