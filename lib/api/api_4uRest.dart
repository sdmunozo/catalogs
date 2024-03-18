import 'package:dio/dio.dart';
import 'dart:convert';

class Api4uRest {
  static Dio _dio = Dio();

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
