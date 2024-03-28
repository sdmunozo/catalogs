import 'dart:convert'; // Importa este paquete para usar json.decode
import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;
  bool _isLoading = true; // Añadir estado de carga

  BranchCatalogResponse? get branchCatalog => _branchCatalog;
  bool get isLoading => _isLoading; // Exponer el estado de carga

  Future<void> fetchBranchCatalog(String branchPath) async {
    _isLoading = true; // Comenzar carga
    notifyListeners();

    try {
      final response =
          await Api4uRest.httpGet('/digital-menu/get-digital-menu/$branchPath');
      _branchCatalog = BranchCatalogResponse.fromJson(response);
    } catch (e) {
      print('Error al obtener el catálogo de la sucursal: $e');
    } finally {
      _isLoading = false; // Finalizar carga
      notifyListeners();
    }
  }
}



/*//http://localhost:59520/digital-menu/get-digital-menu/fruteria-la-unica-rio

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

*/