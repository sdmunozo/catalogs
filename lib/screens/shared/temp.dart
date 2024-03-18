/*Column(
                        children: [
                          if (item.icon != null) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  item.icon!,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.description,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (item.modifiersGroups.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Personalizalo a tu gusto",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      24, // Aumentando el tamaño de la letra
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: item.modifiersGroups.length,
                              itemBuilder: (context, index) {
                                final group = item.modifiersGroups[index];
                                return ListTile(
                                  title: Text(
                                    group.alias,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: group.modifiers.length,
                                    itemBuilder: (context, modIndex) {
                                      final modifier =
                                          group.modifiers[modIndex];
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    16.0), // Sangría a la izquierda
                                            child: Icon(
                                              Icons.circle,
                                              size: 10,
                                            ), // Viñeta
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre la viñeta y el texto
                                          Text(
                                            modifier.alias,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 28,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            modifier.price != 0
                                                ? "\$${modifier.price.toString()}"
                                                : '-',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),


                      */


/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/shared/items_widget.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  void _launchUrl(Uri url) async {
    try {
      final bool launched = await launchUrl(url);
      if (!launched) {}
    } catch (e) {}
  }

  TabController? _catalogTabController;
  final Map<int, TabController> _categoryTabControllers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final catalogsCount =
        branchCatalogProvider.branchCatalog?.catalogs.length ?? 0;

    _catalogTabController = TabController(length: catalogsCount, vsync: this);
    branchCatalogProvider.branchCatalog?.catalogs
        .asMap()
        .forEach((index, catalog) {
      final categoriesCount = catalog.categories.length;
      _categoryTabControllers[index] =
          TabController(length: categoriesCount, vsync: this);
    });
  }

  @override
  void dispose() {
    _catalogTabController?.dispose();
    _categoryTabControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final catalogs = branchCatalogProvider.branchCatalog?.catalogs ?? [];
    final brandName =
        branchCatalogProvider.branchCatalog?.brandName ?? 'Empresa';
    final branchName =
        branchCatalogProvider.branchCatalog?.branchName ?? 'Sucursal';

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Material(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: SizedBox(
                    width: 520,
                    height: 932,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(branchCatalogProvider
                                  .branchCatalog?.menuBackground ??
                              ''),
                          fit: BoxFit.cover,
                          opacity: 0.4,
                        ),
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Center(
                                // Centro el texto de la marca
                                child: Text(
                                  brandName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Center(
                                // Centro el texto de la marca
                                child: Text(
                                  branchName, // Usa la variable brandName aquí
                                  textAlign: TextAlign
                                      .center, // Alineo el texto al centro
                                  style: GoogleFonts.pacifico(
                                      fontSize: 30, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          TabBar(
                            controller: _catalogTabController,
                            tabs: catalogs
                                .map((catalog) => Tab(text: catalog.name))
                                .toList(),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _catalogTabController,
                              children: catalogs
                                  .asMap()
                                  .map((index, catalog) {
                                    return MapEntry(
                                      index,
                                      Column(
                                        children: [
                                          TabBar(
                                            controller:
                                                _categoryTabControllers[index],
                                            tabs: catalog.categories
                                                .map((category) =>
                                                    Tab(text: category.name))
                                                .toList(),
                                            isScrollable:
                                                true, // Para hacer scroll si hay muchas categorías
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller:
                                                  _categoryTabControllers[
                                                      index],
                                              children: catalog.categories
                                                  .map((category) {
                                                // Usamos ListView.builder para mostrar los items y los productos con MenuItemCard
                                                return ListView.builder(
                                                  itemCount: category
                                                          .items.length +
                                                      category.products.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    // Determinamos si es un item o un producto
                                                    if (i <
                                                        category.items.length) {
                                                      // Es un item
                                                      final item =
                                                          category.items[i];
                                                      return MenuItemCard(
                                                        alias: item.alias,
                                                        description:
                                                            item.description,
                                                        price: item.price,
                                                        iconUrl: item.icon,
                                                      );
                                                    } else {
                                                      // Es un producto (ajustamos el índice para los productos)
                                                      int productIndex = i -
                                                          category.items.length;
                                                      final product =
                                                          category.products[
                                                              productIndex];
                                                      return MenuItemCard(
                                                        alias: product.alias,
                                                        description:
                                                            product.description,
                                                        price: product.price,
                                                        iconUrl: product.icon,
                                                      );
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .values
                                  .toList(),
                            ),
                          ), // expanded
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Barra estática en la parte inferior
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl(Uri.parse('https://www.4urest.mx'));
                  },
                  child: Text(
                    'Diseñado por ',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    _launchUrl(Uri.parse('https://www.4urest.mx'));
                  },
                  child: Text(
                    '4uRest',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WelcomeScreen()), // Cambia esto según necesites
          );
        },
        child: Icon(
          Icons.home,
          color: Colors.white,
        ), // Elige el ícono que prefieras
        backgroundColor: Colors.black, // Elige el color que prefieras
      ),
    );
  }
}
*/

/*

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/shared/items_widget.dart';
import 'package:menu/screens/single_item_screen.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  void _launchUrl(Uri url) async {
    try {
      final bool launched = await launchUrl(url);
      if (!launched) {}
    } catch (e) {}
  }

  TabController? _catalogTabController;
  final Map<int, TabController> _categoryTabControllers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final catalogsCount =
        branchCatalogProvider.branchCatalog?.catalogs.length ?? 0;

    _catalogTabController = TabController(length: catalogsCount, vsync: this);
    branchCatalogProvider.branchCatalog?.catalogs
        .asMap()
        .forEach((index, catalog) {
      final categoriesCount = catalog.categories.length;
      _categoryTabControllers[index] =
          TabController(length: categoriesCount, vsync: this);
    });
  }

  @override
  void dispose() {
    _catalogTabController?.dispose();
    _categoryTabControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final catalogs = branchCatalogProvider.branchCatalog?.catalogs ?? [];
    final brandName =
        branchCatalogProvider.branchCatalog?.brandName ?? 'Empresa';
    final branchName =
        branchCatalogProvider.branchCatalog?.branchName ?? 'Sucursal';

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Material(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: SizedBox(
                    width: 520,
                    height: 932,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(branchCatalogProvider
                                  .branchCatalog?.menuBackground ??
                              ''),
                          fit: BoxFit.cover,
                          opacity: 0.4,
                        ),
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Center(
                                // Centro el texto de la marca
                                child: Text(
                                  brandName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Center(
                                // Centro el texto de la marca
                                child: Text(
                                  branchName, // Usa la variable brandName aquí
                                  textAlign: TextAlign
                                      .center, // Alineo el texto al centro
                                  style: GoogleFonts.pacifico(
                                      fontSize: 30, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          TabBar(
                            controller: _catalogTabController,
                            tabs: catalogs
                                .map((catalog) => Tab(text: catalog.name))
                                .toList(),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _catalogTabController,
                              children: catalogs
                                  .asMap()
                                  .map((index, catalog) {
                                    return MapEntry(
                                      index,
                                      Column(
                                        children: [
                                          TabBar(
                                            controller:
                                                _categoryTabControllers[index],
                                            tabs: catalog.categories
                                                .map((category) =>
                                                    Tab(text: category.name))
                                                .toList(),
                                            isScrollable:
                                                true, // Para hacer scroll si hay muchas categorías
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller:
                                                  _categoryTabControllers[
                                                      index],
                                              children: catalog.categories
                                                  .map((category) {
                                                // Usamos ListView.builder para mostrar los items y los productos con MenuItemCard
                                                return ListView.builder(
                                                  itemCount: category
                                                          .items.length +
                                                      category.products.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    // Determinamos si es un item o un producto
                                                    if (i <
                                                        category.items.length) {
                                                      // Es un item
                                                      final item =
                                                          category.items[i];
                                                      return MenuItemCard(
                                                        item:
                                                            item, // Asumiendo que 'item' es un objeto de tipo Item
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SingleItemScreen(
                                                                      item:
                                                                          item),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      // Es un producto (ajustamos el índice para los productos)
                                                      int productIndex = i -
                                                          category.items.length;
                                                      final product =
                                                          category.products[
                                                              productIndex];
                                                      return MenuItemCard(
                                                        item:
                                                            product, // Asumiendo que 'item' es un objeto de tipo Item
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SingleItemScreen(
                                                                      item:
                                                                          product),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .values
                                  .toList(),
                            ),
                          ), // expanded
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Barra estática en la parte inferior
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl(Uri.parse('https://www.4urest.mx'));
                  },
                  child: Text(
                    'Diseñado por ',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    _launchUrl(Uri.parse('https://www.4urest.mx'));
                  },
                  child: Text(
                    '4uRest',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WelcomeScreen()), // Cambia esto según necesites
          );
        },
        child: Icon(
          Icons.home,
          color: Colors.white,
        ), // Elige el ícono que prefieras
        backgroundColor: Colors.black, // Elige el color que prefieras
      ),
    );
  }
}

*/