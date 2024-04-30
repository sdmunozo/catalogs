import 'package:menu/models/branch_catalog_response.dart';

extension BranchCatalogResponseExtension on BranchCatalogResponse {
  String? findCatalogIdForItem(String itemId) {
    for (var catalog in catalogs) {
      for (var category in catalog.categories) {
        if (category.products.any((item) => item.id == itemId)) {
          return catalog.id;
        }
      }
    }
    return null;
  }

  int? findCategoryIndexForItem(String itemId) {
    for (var catalog in catalogs) {
      for (int i = 0; i < catalog.categories.length; i++) {
        var category = catalog.categories[i];
        if (category.products.any((item) => item.id == itemId)) {
          return i;
        }
      }
    }
    return null;
  }
}
