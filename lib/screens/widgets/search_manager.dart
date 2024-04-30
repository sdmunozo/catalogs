import 'package:flutter/material.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/models/branch_catalog_response.dart'; // Asegúrate de importar tus modelos y proveedores correctamente
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:provider/provider.dart';

class SearchManager {
  final TextEditingController searchController = TextEditingController();
  List<Section> filteredItems = [];
  bool isSearching = false;

  void onSearchChanged(BuildContext context) {
    String searchText = searchController.text.trim();
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);
    List<Item> allItems = branchCatalogProvider.branchCatalog?.catalogs
            .expand((catalog) =>
                catalog.categories.expand((category) => category.products))
            .toList() ??
        [];

    if (searchText.length >= 2) {
      List<Item> filteredItems = allItems
          .where((item) =>
              item.alias.toLowerCase().contains(searchText.toLowerCase()))
          .toList();

      if (filteredItems.isNotEmpty) {
        // Aquí puedes manejar la lógica para actualizar el UI basado en los ítems filtrados
        this.filteredItems =
            filteredItems.map((item) => Section(item: item)).toList();
      }
    } else {
      this.filteredItems = [];
    }
    // Notificar al widget que necesita reconstruirse
  }

  void dispose() {
    searchController.dispose();
  }
}
