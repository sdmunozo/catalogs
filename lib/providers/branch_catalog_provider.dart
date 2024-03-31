import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/branch_catalog_response.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;
  bool _isLoading = true;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;
  bool get isLoading => _isLoading;

  Future<void> fetchBranchCatalog(String branchPath) async {
    if (branchPath.isNotEmpty && branchPath.isNotEmpty) {
      _isLoading = true;
      notifyListeners();

      try {
        final response = await Api4uRest.httpGet(
            '/digital-menu/get-digital-menu/$branchPath');
        _branchCatalog = BranchCatalogResponse.fromJson(response);
      } catch (e) {
        print('Error al obtener el catálogo de la sucursal: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
