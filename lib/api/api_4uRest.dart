import 'dart:convert';
import 'package:dio/dio.dart';

class Api4uRest {
  static Dio _dio = Dio()
    ..options.baseUrl = 'https://netship20240323121328.azurewebsites.net/api'
    ..options.headers = {
      'ngrok-skip-browser-warning': 'true',
      'Content-Type': 'application/json',
    };

  static Future<dynamic> httpGet(String path,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        return response.data is String
            ? jsonDecode(response.data)
            : response.data;
      } else {
        throw Exception(
            'Respuesta no exitosa: ${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      throw Exception('Error en el GET: $e');
    }
  }
}
