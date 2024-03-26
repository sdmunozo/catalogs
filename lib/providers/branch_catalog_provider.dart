//http://localhost:59520/digital-menu/get-digital-menu/fruteria-la-unica-rio

import 'dart:convert'; // Importa este paquete para usar json.decode
import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;

  Future<void> fetchBranchCatalog(String branchPath) async {
    try {
      // Realiza la solicitud HTTP GET
      final response =
          await Api4uRest.httpGet('/digital-menu/get-digital-menu/$branchPath');

      // Asumiendo que la respuesta ya viene en el formato adecuado,
      // actualiza directamente _branchCatalog
      _branchCatalog = BranchCatalogResponse.fromJson(response);

      // Notifica a los oyentes sobre el cambio
      notifyListeners();
    } catch (e) {
      print('Error al obtener el catálogo de la sucursal: $e');
      // Considera manejar el error de forma que la UI pueda reflejarlo
    }
  }
}



/*import 'dart:convert'; // Importa este paquete para usar json.decode
import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;

  // Simula la carga de datos desde un JSON estático
  Future<void> fetchBranchCatalog(String branchId) async {
    // Simula un retraso si quieres imitar una llamada de red
    await Future.delayed(Duration(seconds: 1));

    String jsonString = '''
{
"brandId": "e9836589-f766-4bc0-ed86-08dc4ba99b9c",
"branchId": "84e2c10c-918b-4fd4-45ed-08dc4ba99bbb",
"brandName": "Frutería La Única",
"branchName": "Río",
"instagramLink": "https://www.instagram.com/fruterialaunica/",
"facebookLink": "https://www.facebook.com/fruterialaunicario/",
"websiteLink": "https://www.fruterialaunica.com.mx/",
"brandLogo": "",
"brandSlogan": "Únicamente La Mejor",
"menuBackground": "https://i0.wp.com/foodandpleasure.com/wp-content/uploads/2022/08/drinks-en-monterrey-terraza-coss.jpeg?fit=1080%2C1350&ssl=1",
"catalogs": [

// CONTINUA JSON

}

    '''; // Asegúrate de incluir todo tu JSON aquí

    // Decodifica el JSON
    final jsonResponse = json.decode(jsonString);

    // Crea la instancia de BranchCatalogResponse a partir del JSON decodificado
    _branchCatalog = BranchCatalogResponse.fromJson(jsonResponse);

    // Notifica a los oyentes sobre el cambio
    notifyListeners();
  }
}


*/

/*import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;

  Future<void> fetchBranchCatalog(String branchId) async {
    final response = await Api4uRest.httpGet(
        'https://tu-endpoint-aqui.com/catalogs/$branchId');
    _branchCatalog = BranchCatalogResponse.fromJson(
        response); // Asume que tienes este método en tu clase model
    notifyListeners();
  }
}
*/