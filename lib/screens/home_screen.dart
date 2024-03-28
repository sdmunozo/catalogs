import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/shared/background_image.dart';
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
    final backgroundImage =
        branchCatalogProvider.branchCatalog?.menuBackground ?? '';
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
                      padding: EdgeInsets.only(top: 2, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: backgroundImage.isNotEmpty
                              ? NetworkImage(backgroundImage)
                                  as ImageProvider<Object>
                              : AssetImage(
                                      'images/tools/FruteriaLaUnica_bg.jpg')
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                          opacity: 1,
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          TabBar(
                            controller: _catalogTabController,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            labelColor: Colors
                                .white, // Establece el color de las etiquetas activas a blanco
                            unselectedLabelColor: Colors.white.withOpacity(
                                0.5), // Etiquetas inactivas en blanco con opacidad
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
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            labelColor: Colors
                                                .white, // Color de las etiquetas activas
                                            unselectedLabelColor: Colors.white
                                                .withOpacity(
                                                    0.5), // Color de las etiquetas inactivas
                                            isScrollable: true,
                                            tabs: catalog.categories
                                                .map((category) =>
                                                    Tab(text: category.name))
                                                .toList(),
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
                                                        cardType: "item",
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
                                                        cardType: "product",
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
            color: Colors.black,
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
                      color: Colors.white.withOpacity(0.8),
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
                  child: Image.asset(
                    'images/tools/4uRestFont-white.png',
                    height:
                        35, // Ajusta esto según sea necesario para que coincida con el diseño deseado
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
        backgroundColor: Color(0xFFE57734),
      ),
    );
  }
}
