import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/models/feedback_info.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/branch_catalog_response_extension.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/shared/items_widget.dart';
import 'package:menu/screens/single_item_screen.dart';
import 'package:menu/screens/widgets/feedback_modal.dart';
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
  List<Section> _filteredItems = [];
  final FocusNode _searchFocusNode = FocusNode();

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
    _searchController.addListener(_onSearchChanged);
  }

  void _startFeedbackTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFeedbackTime = prefs.getString('lastFeedbackTime');
    final lastFeedbackDate =
        lastFeedbackTime != null ? DateTime.parse(lastFeedbackTime) : null;
    final currentTime = DateTime.now();

    if (lastFeedbackDate != null &&
        currentTime.difference(lastFeedbackDate).inHours < 8) {
      _isFeedbackSubmitted = true;
    } else {
      _isFeedbackSubmitted = false;
      _timer = Timer(Duration(seconds: secFeedbackTimer), () {
        _showFeedbackModal();
      });
    }
  }

  String? _selectedFeedback;
  String _userComment = '';

  String normalizeText(String input) {
    String normalized =
        input.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '').toLowerCase();
    return normalized;
  }

  void _showFeedbackModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FeedbackDialog(
            onSubmitFeedback: (selectedFeedback, userComment) {
          setState(() {
            _selectedFeedback = selectedFeedback;
            _userComment = normalizeText(userComment);
          });
          _submitFeedback(selectedFeedback, userComment);
        });
      },
    );
  }

  void _submitFeedback(String feedbackType, String userComment) async {
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
    await prefs.setString('lastFeedbackTime', DateTime.now().toIso8601String());

    setState(() {
      _isFeedbackSubmitted = true;
      _selectedFeedback = null;
      _userComment = '';
    });
  }

  void _updateSelectedCatalog(String newCatalogId, int newCategoryIndex) {
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);
    final catalogs = branchCatalogProvider.branchCatalog?.catalogs ?? [];
    int newIndex = catalogs.indexWhere((catalog) => catalog.id == newCatalogId);

    if (newIndex != -1) {
      setState(() {
        _catalogTabController!.animateTo(newIndex);
        print(newCategoryIndex);
        _bloc.onFilteredCategorySelected(newCategoryIndex);
      });
    }
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.trim();
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
        _bloc.scrollController.removeListener(_bloc.onScrollListener);

        String? firstItemCatalogId = branchCatalogProvider.branchCatalog
            ?.findCatalogIdForItem(filteredItems.first.id);
        int? firstItemCategoryId = branchCatalogProvider.branchCatalog
            ?.findCategoryIndexForItem(filteredItems.first.id);

        if (firstItemCatalogId != null) {
          _updateSelectedCatalog(firstItemCatalogId, firstItemCategoryId!);
        }
        List<Section> filteredSections =
            filteredItems.map((item) => Section(item: item)).toList();

        setState(() {
          _filteredItems = filteredSections;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _bloc.scrollController.addListener(_bloc.onScrollListener);
        });
      }
    } else {
      setState(() {
        _filteredItems = [];
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

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
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_left_outlined,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Expanded(
                                        child: AutoSizeText(
                                          brandName + " - " + branchName,
                                          style:
                                              GoogleFonts.montserratAlternates(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                          minFontSize: 10,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                              List<Section> itemsToDisplay =
                                                  _filteredItems.isNotEmpty
                                                      ? _filteredItems
                                                          .cast<Section>()
                                                      : bloc.items
                                                          .cast<Section>();
                                              return ListView.builder(
                                                controller:
                                                    bloc.scrollController,
                                                itemCount:
                                                    itemsToDisplay.length,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                itemBuilder: (context, index) {
                                                  final section =
                                                      itemsToDisplay[index];
                                                  if (section.isCategory) {
                                                    // Si es una categoría
                                                    return _CategoryItem(
                                                        section.category!);
                                                  } else if (section.item !=
                                                      null) {
                                                    return _ProductItem(
                                                        section.item!);
                                                  } else {
                                                    return Container();
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
                                                        'https://landing.4urest.mx/'));
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
                                                        'https://landing.4urest.mx/'));
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
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (_isSearching) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _searchFocusNode.requestFocus();
                        });
                      } else {
                        _searchFocusNode.unfocus();
                        _searchController.clear();
                      }
                    });
                  },
                  child: Icon(Icons.search_rounded),
                  heroTag: "searchFAB",
                  backgroundColor: Color(0xFFE57734),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: AnimatedContainer(
                    width: _isSearching ? 215 : 0,
                    height: 48,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: _isSearching
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                focusNode: _searchFocusNode,
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Buscar...',
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                if (_isSearching) {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                    _filteredItems.clear();
                  });
                } else {
                  _bloc.scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                }
              },
              child: Icon(_isSearching
                  ? Icons.clear
                  : Icons.keyboard_double_arrow_up_outlined),
              backgroundColor: Colors.blue,
              heroTag: "upFAB",
            ),
          ),
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
          style: GoogleFonts.montserratAlternates(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
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



/*
 Version FUNCIONAL
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:menu/models/feedback_info.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/branch_catalog_response_extension.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/shared/items_widget.dart';
import 'package:menu/screens/single_item_screen.dart';
import 'package:menu/screens/widgets/feedback_modal.dart';
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
  List<Section> _filteredItems = [];
  final FocusNode _searchFocusNode = FocusNode();

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
    _searchController.addListener(_onSearchChanged);
  }

  void _startFeedbackTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFeedbackTime = prefs.getString('lastFeedbackTime');
    final lastFeedbackDate =
        lastFeedbackTime != null ? DateTime.parse(lastFeedbackTime) : null;
    final currentTime = DateTime.now();

    if (lastFeedbackDate != null &&
        currentTime.difference(lastFeedbackDate).inHours < 8) {
      _isFeedbackSubmitted = true;
    } else {
      _isFeedbackSubmitted = false;
      _timer = Timer(Duration(seconds: secFeedbackTimer), () {
        _showFeedbackModal();
      });
    }
  }

  String? _selectedFeedback;
  String _userComment = '';

  void _showFeedbackModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FeedbackDialog(
            onSubmitFeedback: (selectedFeedback, userComment) {
          setState(() {
            _selectedFeedback = selectedFeedback;
            _userComment = userComment;
          });
          _submitFeedback(selectedFeedback, userComment);
        });
      },
    );
  }

  void _submitFeedback(String feedbackType, String userComment) async {
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
    await prefs.setString('lastFeedbackTime', DateTime.now().toIso8601String());

    setState(() {
      _isFeedbackSubmitted = true;
      _selectedFeedback = null;
      _userComment = '';
    });
  }

  void _updateSelectedCatalog(String newCatalogId, int newCategoryIndex) {
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);
    final catalogs = branchCatalogProvider.branchCatalog?.catalogs ?? [];
    int newIndex = catalogs.indexWhere((catalog) => catalog.id == newCatalogId);

    if (newIndex != -1) {
      setState(() {
        _catalogTabController!.animateTo(newIndex);
        print(newCategoryIndex);
        _bloc.onFilteredCategorySelected(newCategoryIndex);
      });
    }
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.trim();
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
        _bloc.scrollController.removeListener(_bloc.onScrollListener);

        String? firstItemCatalogId = branchCatalogProvider.branchCatalog
            ?.findCatalogIdForItem(filteredItems.first.id);
        int? firstItemCategoryId = branchCatalogProvider.branchCatalog
            ?.findCategoryIndexForItem(filteredItems.first.id);

        if (firstItemCatalogId != null) {
          _updateSelectedCatalog(firstItemCatalogId, firstItemCategoryId!);
        }
        List<Section> filteredSections =
            filteredItems.map((item) => Section(item: item)).toList();

        setState(() {
          _filteredItems = filteredSections;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _bloc.scrollController.addListener(_bloc.onScrollListener);
        });
      }
    } else {
      setState(() {
        _filteredItems = [];
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

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
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_left_outlined,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FittedBox(
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
                                  ],
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
                                              List<Section> itemsToDisplay =
                                                  _filteredItems.isNotEmpty
                                                      ? _filteredItems
                                                          .cast<Section>()
                                                      : bloc.items
                                                          .cast<Section>();
                                              return ListView.builder(
                                                controller:
                                                    bloc.scrollController,
                                                itemCount:
                                                    itemsToDisplay.length,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                itemBuilder: (context, index) {
                                                  final section =
                                                      itemsToDisplay[index];
                                                  if (section.isCategory) {
                                                    // Si es una categoría
                                                    return _CategoryItem(
                                                        section.category!);
                                                  } else if (section.item !=
                                                      null) {
                                                    return _ProductItem(
                                                        section.item!);
                                                  } else {
                                                    return Container();
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
                                                        'https://landing.4urest.mx/'));
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
                                                        'https://landing.4urest.mx/'));
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
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (_isSearching) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _searchFocusNode.requestFocus();
                        });
                      } else {
                        _searchFocusNode.unfocus();
                        _searchController.clear();
                      }
                    });
                  },
                  child: Icon(Icons.search_rounded),
                  heroTag: "searchFAB",
                  backgroundColor: Color(0xFFE57734),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: AnimatedContainer(
                    width: _isSearching ? 215 : 0,
                    height: 48,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: _isSearching
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                focusNode: _searchFocusNode,
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Buscar...',
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                if (_isSearching) {
                  setState(() {
                    _searchController.clear();
                    _isSearching = false;
                    _filteredItems.clear();
                  });
                } else {
                  _bloc.scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                }
              },
              child: Icon(_isSearching
                  ? Icons.clear
                  : Icons.keyboard_double_arrow_up_outlined),
              backgroundColor: Colors.blue,
              heroTag: "upFAB",
            ),
          ),
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
  */
