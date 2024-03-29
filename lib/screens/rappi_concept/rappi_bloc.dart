import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/rappi_data.dart';

const categoryHeight = 55.0;
const productHeight = 110.0;

class RappiBLoC with ChangeNotifier {
  final BranchCatalogProvider branchCatalogProvider;
  RappiBLoC({required this.branchCatalogProvider});
  List<RappiTabCategory> tabs = [];
  List<RappiItem> items = [];
  TabController? tabController;
  ScrollController scrollController = ScrollController();
  bool _listen = true;
  void init(TickerProvider ticker) {
    if (branchCatalogProvider.branchCatalog != null) {
      final branchCatalog = branchCatalogProvider.branchCatalog!;
      for (var catalog in branchCatalog.catalogs) {
        print('Catálogo: ${catalog.name}');
        for (var category in catalog.categories) {
          print('  Categoría: ${category.name}');

          // Aquí asumimos que tanto items como products se deben tratar igual
          var allProducts = [...category.items, ...category.products];

          for (var product in allProducts) {
            print('    Producto: ${product.alias}, Precio: ${product.price}');
          }
        }
      }
    } else {
      print('El catálogo de la sucursal está vacío o no se ha cargado aún.');
    }

    // Aquí debes ajustar cómo inicializas las tabs y los items
    // basándote en la estructura de datos actualizada.
    // El siguiente código es solo un punto de partida y necesitará ser ajustado.

    tabController = TabController(
        vsync: ticker,
        length: branchCatalogProvider.branchCatalog?.catalogs.length ?? 0);

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    // Esta es solo una aproximación, necesitarás ajustar esto
    for (var catalog in branchCatalogProvider.branchCatalog!.catalogs) {
      for (var category in catalog.categories) {
        var allProducts = [...category.items, ...category.products];

        offsetFrom = offsetTo;
        offsetTo += allProducts.length * productHeight + categoryHeight;

        tabs.add(RappiTabCategory(
          category:
              category, // Asegúrate de que RappiTabCategory pueda aceptar tu nuevo tipo de categoría
          selected: tabs.isEmpty, // El primer tab se selecciona por defecto
          offsetFrom: offsetFrom,
          offsetTo: offsetTo,
        ));

        // Aquí necesitas agregar la lógica para añadir tanto items como products a tu lista de items.
      }
    }

    scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];
        if (scrollController.offset >= tab.offsetFrom &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);
          tabController!.animateTo(i);
          break;
        }
      }
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();

    if (animationRequired) {
      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
      _listen = true;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScrollListener);
    scrollController.dispose();
    tabController!.dispose();
    super.dispose();
  }
}

class RappiTabCategory {
  const RappiTabCategory({
    required this.category,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  RappiTabCategory copyWith(bool selected) => RappiTabCategory(
        category: category,
        selected: selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );

  final Category category;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;
}

class RappiItem {
  const RappiItem({
    this.category,
    this.product,
  });
  final RappiCategory? category;
  final RappiProduct? product;
  bool get isCategory => category != null;
}


/*
  void init(TickerProvider ticker) {
    if (branchCatalogProvider.branchCatalog != null) {
      final branchCatalog = branchCatalogProvider.branchCatalog!;
      for (var catalog in branchCatalog.catalogs) {
        print('Catálogo: ${catalog.name}');
        for (var category in catalog.categories) {
          print('  Categoría: ${category.name}');
          for (var item in category.items) {
            print('    Producto: ${item.alias}, Precio: ${item.price}');
          }
        }
      }
    } else {
      print('El catálogo de la sucursal está vacío o no se ha cargado aún.');
    }

    tabController =
        TabController(vsync: ticker, length: rappiCategories.length);

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < rappiCategories.length; i++) {
      final category = rappiCategories[i];

      offsetFrom = offsetTo;
      offsetTo = offsetFrom +
          rappiCategories[i].products.length * productHeight +
          categoryHeight;

      tabs.add(RappiTabCategory(
        category: category,
        selected: (i == 0),
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      ));
      items.add(RappiItem(category: category));
      for (int j = 0; j < category.products.length; j++) {
        final product = category.products[j];
        items.add(RappiItem(product: product));
      }
    }

    scrollController.addListener(_onScrollListener);
  }

  */