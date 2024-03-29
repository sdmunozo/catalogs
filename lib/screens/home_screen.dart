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
                            isScrollable: true,
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



/*

Scaffold(
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
        ],
      ),
    ); 

 */

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            height: 100,
          ),
          if (_bloc != null) ...[
            Container(
              height: 60,
              child: AnimatedBuilder(
                animation: _bloc,
                builder: (_, __) => TabBar(
                  controller: _bloc.tabControllerCategories,
                  indicatorWeight: 0.1,
                  isScrollable: true,
                  tabs: _bloc.tabs
                      .map(
                          (tabCategory) => Tab(text: tabCategory.category.name))
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: TabBarView(
                  controller: _bloc.tabControllerCategories,
                  children: _bloc.tabs.map((tabCategory) {
                    return Center(child: Text(tabCategory.category.name));
                  }).toList(),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
*/



/*import 'package:flutter/material.dart';
import 'package:menu/BLoC/home_screen_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:provider/provider.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0F1863);
const _greenColor = Color(0xFF2BBEBA);
const _categoryHeight = 55.0;
const _productHeight = 100.0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeScreenBLoC _bloc;

  @override
  void initState() {
    super.initState();
    // Asegúrate de que el BLoC se inicialice después de que se haya creado el widget para tener acceso al contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc = HomeScreenBLoC();
      // Pasamos el ticker (this) y el contexto para tener acceso al Provider
      _bloc.init(this, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            height: 60,
            child: AnimatedBuilder(
              animation: _bloc,
              builder: (_, __) => TabBar(
                controller: _bloc.tabControllerCategories,
                indicatorWeight: 0.1,
                isScrollable: true,
                tabs: _bloc.tabs
                    .map((tabCategory) => Tab(text: tabCategory.category.name))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount:
                    20, // Aquí deberías ajustar el itemCount basado en tus datos
                itemBuilder: (context, index) {
                  // Tu lógica para construir cada item de la lista
                  return Container(); // Sustituye esto por tu widget correspondiente
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

*/

/*import 'package:flutter/material.dart';
import 'package:menu/BLoC/home_screen_bloc.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0F1863);
const _greenColor = Color(0xFF2BBEBA);
const _categoryHeight = 55.0;
const _productHeight = 100.0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _bloc = HomeScreenBLoC();
  @override
  void initState() {
    _bloc.init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
              height: 60,
              child: TabBar(
                controller: _bloc.tabControllerCategories,
                indicatorWeight: 0.1,
                isScrollable: true,
                tabs: _bloc.tabs.map((e) => _CategoryTabWidget(e)).toList(),
              )),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: 20,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return _CategoryTitleWidget();
                  } else {
                    return _ProductItem();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

*/



/*class _CategoryTabWidget extends StatelessWidget {
  final TabCategory tabCategory;

  const _CategoryTabWidget(this.tabCategory);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: tabCategory.selected ? 1 : 0.5,
      child: Card(
        elevation: tabCategory.selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
            style: TextStyle(
                color: _blueColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }
}*/

/*
class _CategoryTabWidget extends StatelessWidget {
  const _CategoryTabWidget(this.tabCategory);
  final _CategoryTabWidget tabCategory;
  final selected = tabCategory.selected;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: selected? 1 : 0.5,
      child: Card(
        elevation: selected? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
            style: TextStyle(
                color: _blueColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }
}*/


/*
RESPALDO:

//https://www.youtube.com/watch?v=gBQmI1kBHC0

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
 */

/*
RESPALDO CODIGO LIMPIO:

//https://www.youtube.com/watch?v=gBQmI1kBHC0

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
        ],
      ),
    );
  }
}

 */
