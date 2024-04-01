import 'package:flutter/material.dart';
import 'package:menu/api/api_4uRest.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BranchCatalogProvider extends ChangeNotifier {
  BranchCatalogResponse? _branchCatalog;
  bool _isLoading = true;
  String? _sessionId;

  BranchCatalogResponse? get branchCatalog => _branchCatalog;
  bool get isLoading => _isLoading;
  String get sessionId => _sessionId ?? 'No Session ID';

  BranchCatalogProvider() {
    _loadSessionId();
  }

  Future<void> _loadSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionId = prefs.getString('sessionId') ?? Uuid().v4();
    await prefs.setString('sessionId', _sessionId!);
    notifyListeners();
  }

  Future<void> fetchBranchCatalog(String branchPath) async {
    if (branchPath.isNotEmpty) {
      _isLoading = true;
      notifyListeners();

      try {
        final response = await Api4uRest.httpGet(
            '/digital-menu/get-digital-menu/$branchPath');
        _branchCatalog = BranchCatalogResponse.fromJson(response);
      } catch (e) {
        print('Error al obtener el catálogo de la sucursal: $e');
        throw Exception('Error al obtener el catálogo de la sucursal');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
