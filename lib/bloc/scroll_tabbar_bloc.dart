// Creditos a diegoveloper de youtube https://www.youtube.com/watch?v=Al4K2ImlMww&ab_channel=diegoveloper

import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:provider/provider.dart';

const categoryHeight = 55.0;
const productHeight = 132.0;

class ScrollTabBarBLoC with ChangeNotifier {
  List<CategoryTab> tabs = [];
  List<Section> items = [];
  String? catalogId;
  TabController? categoryTabController;
  ScrollController scrollController = ScrollController();
  bool _listen = true;

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
    scrollController.addListener(_onScrollListener);
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
