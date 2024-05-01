import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/models/feedback_info.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/shared/items_widget.dart';
import 'package:menu/screens/single_item_screen.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

const _blueColor = Color(0xFF0D1863);

const secFeedbackTimer = 30;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _bloc = ScrollTabBarBLoC();
  Timer? _timer;
  bool _isFeedbackSubmitted = false;

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
    _startFeedbackTimer();
  }

  void _startFeedbackTimer() async {
    final prefs = await SharedPreferences.getInstance();
    // Revisa si el feedback ya fue enviado antes
    _isFeedbackSubmitted = prefs.getBool('feedbackSubmitted') ?? false;

    if (!_isFeedbackSubmitted) {
      _timer = Timer(Duration(seconds: secFeedbackTimer), () {
        _showFeedbackModal();
      });
    }
  }

  String? _selectedFeedback;
  String _userComment = '';

  void _showFeedbackModal() {
    String? _errorFeedback;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '¿Qué tál tu experiencia con el Menú Digital?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...['sad', 'normal', 'happy']
                          .map((type) {
                            String assetName;
                            switch (type) {
                              case 'sad':
                                assetName = 'assets/feedback/triste.png';
                                break;
                              case 'normal':
                                assetName = 'assets/feedback/confuso.png';
                                break;
                              case 'happy':
                              default:
                                assetName = 'assets/feedback/feliz.png';
                                break;
                            }
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFeedback = type;
                                      _errorFeedback = null;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedFeedback == type
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                    child: Opacity(
                                      opacity:
                                          _selectedFeedback == type ? 1.0 : 0.5,
                                      child: Image.asset(assetName, width: 40),
                                    ),
                                  ),
                                ),
                                if (type != 'happy') SizedBox(width: 20),
                              ],
                            );
                          })
                          .expand((widget) => [widget])
                          .toList(),
                    ],
                  ),
                  TextField(
                    decoration:
                        InputDecoration(hintText: 'Deja un comentario...'),
                    onChanged: (value) {
                      _userComment = value;
                    },
                  ),
                  if (_errorFeedback != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _errorFeedback!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_selectedFeedback == null) {
                      setState(() {
                        _errorFeedback =
                            'Por favor, selecciona un emoji antes de enviar.';
                      });
                    } else {
                      _submitFeedback('withComment');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitFeedback(String feedbackType) async {
    if (_selectedFeedback == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecciona un emoji antes de enviar.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);
    final feedbackProvider =
        Provider.of<FeedbackProvider>(context, listen: false);

    int score = _selectedFeedback == 'sad'
        ? 1
        : (_selectedFeedback == 'normal' ? 2 : 3);
    FeedbackInfo feedbackInfo = FeedbackInfo(
      sessionId: branchCatalogProvider.sessionId,
      branchId: branchCatalogProvider.branchCatalog?.branchId ?? '',
      score: score,
      comment: _userComment ?? "",
    );
    feedbackProvider.submitFeedback(feedbackInfo).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Gracias por ayudarnos a mejorar!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocurrió un error al enviar tu feedback.'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedbackSubmitted', true);

    setState(() {
      _isFeedbackSubmitted = true;
      _selectedFeedback = null;
      _userComment = '';
    });
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
    _timer?.cancel();
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
        body: Stack(children: [
          Column(
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
                                          'assets/images/tools/FruteriaLaUnica_bg.jpg')
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
                              Container(
                                height: 40,
                                child: TabBar(
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
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
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
                                                    onTap: _bloc
                                                        .onCategorySelected,
                                                    controller: bloc
                                                        .categoryTabController,
                                                    isScrollable: true,
                                                    tabs: bloc.tabs
                                                        .map((e) =>
                                                            _TabWidget(e))
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
                                          child: Consumer<ScrollTabBarBLoC>(
                                            builder: (context, bloc, child) {
                                              return ListView.builder(
                                                controller:
                                                    bloc.scrollController,
                                                itemCount: bloc.items.length,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                itemBuilder: (context, index) {
                                                  final item =
                                                      bloc.items[index];
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _launchUrl(Uri.parse(
                                                        'https://www.4urest.mx'));
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/tools/4uRestFont-white.png',
                                                    height: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
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
          Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
              child: Icon(Icons.arrow_back_ios),
              heroTag: "homeFAB",
              backgroundColor: Color(0xFFE57734),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  _bloc.scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                },
                child: Icon(Icons.keyboard_double_arrow_up_outlined),
                backgroundColor: Colors.blue,
                heroTag: "upFAB",
              )),
        ]),
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
