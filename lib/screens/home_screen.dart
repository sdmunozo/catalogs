import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/shared/items_widget.dart';
import 'package:menu/screens/single_item_screen.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0D1863);
const _greenColor = Color(0xFF2BBEBA);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _bloc = ScrollTabBarBLoC();

  void _launchUrl(Uri url) async {
    try {
      final bool launched = await launchUrl(url);
      if (!launched) {}
    } catch (e) {}
  }

  TabController? _catalogTabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final catalogs = branchCatalogProvider.branchCatalog?.catalogs ?? [];

    _catalogTabController?.dispose();
    if (catalogs.isNotEmpty) {
      _catalogTabController =
          TabController(length: catalogs.length, vsync: this);

      _bloc.setCatalogId(catalogs.first.id, this, context);
      _catalogTabController!.animateTo(0);

      _catalogTabController!.addListener(() {
        if (!_catalogTabController!.indexIsChanging) {
          final selectedCatalogId = catalogs[_catalogTabController!.index].id;
          _bloc.setCatalogId(selectedCatalogId, this, context);
        }
      });
    } else {
      print('No catalogs found, TabController not initialized.');
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    _catalogTabController?.dispose();
    _bloc.categoryTabController?.dispose();
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
    return ChangeNotifierProvider.value(
      value: _bloc,
      child: Scaffold(
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
                        padding: EdgeInsets.only(top: 2, bottom: 2),
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
                            Container(
                              height: 50,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: brandName + " - ",
                                        style: GoogleFonts.pacifico(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: branchName,
                                        style: GoogleFonts.pacifico(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TabBar(
                              isScrollable: true,
                              controller: _catalogTabController,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor:
                                  Colors.white.withOpacity(0.5),
                              tabs: catalogs
                                  .map((catalog) => Tab(text: catalog.name))
                                  .toList(),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      //color: _backgroundColor,
                                      height: 45,
                                      child: Consumer<ScrollTabBarBLoC>(
                                        builder: (context, bloc, child) {
                                          if (bloc.categoryTabController ==
                                              null) {
                                            print(
                                                'categoryTabController es nulo');
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            return AnimatedBuilder(
                                              animation:
                                                  bloc.categoryTabController!,
                                              builder: (context, child) {
                                                assert(bloc
                                                        .categoryTabController!
                                                        .length ==
                                                    bloc.tabs.length);
                                                return TabBar(
                                                  onTap:
                                                      _bloc.onCategorySelected,
                                                  controller: bloc
                                                      .categoryTabController,
                                                  isScrollable: true,
                                                  tabs: bloc.tabs
                                                      .map((e) => _TabWidget(e))
                                                      .toList(),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        //color: _backgroundColor,
                                        child: Consumer<ScrollTabBarBLoC>(
                                          builder: (context, bloc, child) {
                                            return ListView.builder(
                                              controller: bloc.scrollController,
                                              itemCount: bloc.items.length,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              itemBuilder: (context, index) {
                                                final item = bloc.items[index];
                                                if (item.isCategory) {
                                                  return _CategoryItem(
                                                      item.category!);
                                                } else {
                                                  if (item.item != null) {
                                                    return _ProductItem(
                                                        item.item!);
                                                  } else {
                                                    return Container();
                                                  }
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black,
                                      height: 25,
                                      padding: EdgeInsets.only(top: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _launchUrl(Uri.parse(
                                                  'https://www.4urest.mx'));
                                            },
                                            child: Text(
                                              'Diseñado por ',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          GestureDetector(
                                            onTap: () {
                                              _launchUrl(Uri.parse(
                                                  'https://www.4urest.mx'));
                                            },
                                            child: Image.asset(
                                              'images/tools/4uRestFont-white.png',
                                              height: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
        floatingActionButton: _buildFloatingActionButtons(),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Icon(Icons.arrow_back_ios),
              heroTag: "homeFAB",
              backgroundColor: Color(0xFFE57734),
            ),
            FloatingActionButton(
              onPressed: () {
                _bloc.scrollController.animateTo(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              },
              child: Icon(Icons.keyboard_double_arrow_up_outlined),
              backgroundColor: Colors.blue,
              heroTag: "upFAB",
            ),
          ],
        ),
      ),
    );
  }
}

class _TabWidget extends StatelessWidget {
  const _TabWidget(this.categoryTab);

  final CategoryTab categoryTab;

  @override
  Widget build(BuildContext context) {
    final selected = categoryTab.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            categoryTab.category.name,
            style: TextStyle(
              color: _blueColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem(this.category);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: categoryHeight,
        alignment: Alignment.centerLeft,
        child: Text(
          category.name,
          style: GoogleFonts.pacifico(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem(this.product);
  final Item product;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: productHeight,
        alignment: Alignment.centerLeft,
        child: MenuItemCard(
            cardType: "product",
            item: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleItemScreen(item: product),
                ),
              );
            }));
  }
}
