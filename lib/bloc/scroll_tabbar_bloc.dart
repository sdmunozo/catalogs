// Creditos a diegoveloper de youtube https://www.youtube.com/watch?v=Al4K2ImlMww&ab_channel=diegoveloper

import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:provider/provider.dart';

const categoryHeight = 55.0;
const productHeight = 160.0;

class ScrollTabBarBLoC with ChangeNotifier {
  List<CategoryTab> tabs = [];
  List<Section> items = [];
  String? catalogId;
  TabController? categoryTabController;
  ScrollController scrollController = ScrollController();
  bool _listen = true;
  bool _scrollEnabled = true;

  // Método _onScrollListener
  void onScrollListener() {
    if (_listen && scrollController.hasClients) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];
        if (scrollController.offset >= tab.offsetFrom &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);
          categoryTabController!.animateTo(i);
          break;
        }
      }
    }
  }

  void initCategoryTabController(TickerProvider ticker, BuildContext context,
      {required String catalogId}) {
    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    this.catalogId = catalogId;
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);

    final catalog = branchCatalogProvider.branchCatalog?.catalogs
        .firstWhere((c) => c.id == catalogId);

    if (catalog != null) {
      categoryTabController?.dispose();
      categoryTabController =
          TabController(vsync: ticker, length: catalog.categories.length);
      tabs.clear();
      items.clear();

      for (int i = 0; i < catalog.categories.length; i++) {
        final category = catalog.categories[i];

        offsetFrom = offsetTo;
        offsetTo = offsetFrom +
            catalog.categories[i].products.length * productHeight +
            categoryHeight;

        tabs.add(CategoryTab(
            category: category,
            selected: (i == 0),
            offsetFrom: offsetFrom,
            offsetTo: offsetTo));
        items.add(Section(category: category));
        for (int j = 0; j < category.products.length; j++) {
          final product = category.products[j];
          items.add(Section(item: product));
        }
      }
    } else {
      print(
          'initCategoryTabController - No se encontró el catálogo o está vacío');
    }
    //scrollController.addListener(_onScrollListener);
    scrollController.addListener(onScrollListener);
    notifyListeners();
  }

  void _onScrollListener() {
    if (_listen && scrollController.hasClients) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];
        if (scrollController.offset >= tab.offsetFrom &&
            scrollController.offset <= tab.offsetTo &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);
          categoryTabController!.animateTo(i);
          break;
        }
      }
    }
  }

  void updateFilteredSections(List<Section> filteredSections) {
    items.clear();
    items.addAll(filteredSections);

    final selectedCategoryName =
        tabs.firstWhere((tab) => tab.selected).category.name;
    final filteredCategory = filteredSections.firstWhere(
        (section) =>
            section.isCategory &&
            section.category!.name == selectedCategoryName,
        orElse: () => Section());

    if (filteredCategory != null) {
      final filteredCategoryIndex = items.indexOf(filteredCategory);
      onCategorySelected(filteredCategoryIndex, animationRequired: false);
    }

    notifyListeners();
  }

  void setCatalogId(String id, TickerProvider ticker, BuildContext context) {
    scrollController.dispose();
    scrollController = ScrollController();
    scrollController.addListener(_onScrollListener);

    initCategoryTabController(ticker, context, catalogId: id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });
    scrollController.addListener(_onScrollListener);
  }

  void onFilteredCategorySelected(int index) {
    if (categoryTabController != null && index >= 0 && index < tabs.length) {
      for (int i = 0; i < tabs.length; i++) {
        final isSelected = i == index;
        tabs[i] = tabs[i].copyWith(isSelected);
      }
      notifyListeners();
      categoryTabController!.animateTo(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      print(
          "Índice de categoría fuera de rango o TabController no inicializado.");
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.category.name == tabs[i].category.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();

    if (animationRequired && _scrollEnabled) {
      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
      _listen = true;
    }
  }

/*

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
  }*/

  void setScrollEnabled(bool enabled) {
    _scrollEnabled = enabled;
    // Si el scroll está deshabilitado, podríamos necesitar detener cualquier desplazamiento actual
    if (!enabled) {
      scrollController.jumpTo(scrollController.offset);
    }
  }

  void dispose() {
    scrollController.removeListener(_onScrollListener);
    scrollController.dispose();
    categoryTabController?.dispose();
    super.dispose();
  }
}

class CategoryTab {
  const CategoryTab({
    required this.category,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  CategoryTab copyWith(bool selected) => CategoryTab(
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

class Section {
  const Section({
    this.category,
    this.item,
  });

  final Category? category;
  final Item? item;
  bool get isCategory => category != null;
}
