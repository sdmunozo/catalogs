import 'package:flutter/material.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/rappi_data.dart';
import 'package:menu/screens/rappi_concept/rappi_bloc.dart';
import 'package:provider/provider.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0D1863);
const _greenColor = Color(0xFF2BBEBA);

class MainRappiConceptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: _RappiConcept(),
    );
  }
}

class _RappiConcept extends StatefulWidget {
  @override
  __RappiConceptState createState() => __RappiConceptState();
}

class __RappiConceptState extends State<_RappiConcept>
    with SingleTickerProviderStateMixin {
  late RappiBLoC _bloc;

  @override
  void initState() {
    final branchCatalogProvider =
        Provider.of<BranchCatalogProvider>(context, listen: false);
    _bloc = RappiBLoC(branchCatalogProvider: branchCatalogProvider);
    _bloc.init(this);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Homepage',
                        style: TextStyle(
                          color: _blueColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: _greenColor,
                        radius: 17,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                child: TabBar(
                  onTap: _bloc.onCategorySelected,
                  controller: _bloc.tabController,
                  indicatorWeight: 0.1,
                  isScrollable: true,
                  tabs: _bloc.tabs.map((e) => _RappiTabWidget(e)).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _bloc.scrollController,
                  itemCount: _bloc.items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final item = _bloc.items[index];
                    if (item.isCategory) {
                      return _RappiCategoryItem(item.category);
                    } else {
                      return _RappiProductItem(item.product);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RappiTabWidget extends StatelessWidget {
  const _RappiTabWidget(this.tabCategory);
  final RappiTabCategory tabCategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabCategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
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

class _RappiCategoryItem extends StatelessWidget {
  const _RappiCategoryItem(this.category);
  final RappiCategory? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category!.name,
        style: TextStyle(
          color: _blueColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RappiProductItem extends StatelessWidget {
  const _RappiProductItem(this.product);
  final RappiProduct? product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(product!.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product!.name,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product!.description,
                      maxLines: 2,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${product!.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:menu/providers/rappi_data.dart';
import 'package:menu/screens/rappi_concept/rappi_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:provider/provider.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0D1863);
const _greenColor = Color(0xFF2BBEBA);

class MainRappiConceptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: _RappiConcept(),
    );
  }
}

class _RappiConcept extends StatefulWidget {
  @override
  __RappiConceptState createState() => __RappiConceptState();
}

class __RappiConceptState extends State<_RappiConcept>
    with SingleTickerProviderStateMixin {
  late RappiBLoC _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RappiBLoC(
      branchCatalogProvider:
          Provider.of<BranchCatalogProvider>(context, listen: false),
    );
    _bloc.init(this);
  }

  @override
  Widget build(BuildContext context) {
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final brandName =
        branchCatalogProvider.branchCatalog?.brandName ?? 'Nombre de la Marca';
    final branchName = branchCatalogProvider.branchCatalog?.branchName ??
        'Nombre de la Sucursal';

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$brandName - $branchName',
                        style: TextStyle(
                          color: _blueColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: _greenColor,
                        radius: 17,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                child: TabBar(
                  onTap: _bloc.onCategorySelected,
                  controller: _bloc.tabController,
                  indicatorWeight: 0.1,
                  isScrollable: true,
                  tabs: _bloc.tabs.map((e) => _RappiTabWidget(e)).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _bloc.scrollController,
                  itemCount: _bloc.items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final item = _bloc.items[index];
                    if (item.isCategory) {
                      return _RappiCategoryItem(item.category);
                    } else {
                      return _RappiProductItem(item.product);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RappiTabWidget extends StatelessWidget {
  const _RappiTabWidget(this.tabCategory);
  final RappiTabCategory tabCategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabCategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
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

class _RappiCategoryItem extends StatelessWidget {
  const _RappiCategoryItem(this.category);
  final RappiCategory? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category!.name,
        style: TextStyle(
          color: _blueColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RappiProductItem extends StatelessWidget {
  const _RappiProductItem(this.product);
  final RappiProduct? product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(product!.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product!.name,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product!.description,
                      maxLines: 2,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${product!.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


*/

/**

import 'package:flutter/material.dart';
import 'package:menu/providers/rappi_data.dart';
import 'package:menu/screens/rappi_concept/rappi_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:provider/provider.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0D1863);
const _greenColor = Color(0xFF2BBEBA);

class MainRappiConceptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: _RappiConcept(),
    );
  }
}

class _RappiConcept extends StatefulWidget {
  @override
  __RappiConceptState createState() => __RappiConceptState();
}

class __RappiConceptState extends State<_RappiConcept>
    with SingleTickerProviderStateMixin {
  final _bloc = RappiBLoC();

  @override
  void initState() {
    _bloc.init(this);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchCatalogProvider = Provider.of<BranchCatalogProvider>(context);
    final brandName =
        branchCatalogProvider.branchCatalog?.brandName ?? 'Nombre de la Marca';
    final branchName = branchCatalogProvider.branchCatalog?.branchName ??
        'Nombre de la Sucursal';

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$brandName - $branchName',
                        style: TextStyle(
                          color: _blueColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: _greenColor,
                        radius: 17,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                child: TabBar(
                  onTap: _bloc.onCategorySelected,
                  controller: _bloc.tabController,
                  indicatorWeight: 0.1,
                  isScrollable: true,
                  tabs: _bloc.tabs.map((e) => _RappiTabWidget(e)).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _bloc.scrollController,
                  itemCount: _bloc.items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final item = _bloc.items[index];
                    if (item.isCategory) {
                      return _RappiCategoryItem(item.category);
                    } else {
                      return _RappiProductItem(item.product);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RappiTabWidget extends StatelessWidget {
  const _RappiTabWidget(this.tabCategory);
  final RappiTabCategory tabCategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabCategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
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

class _RappiCategoryItem extends StatelessWidget {
  const _RappiCategoryItem(this.category);
  final RappiCategory? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category!.name,
        style: TextStyle(
          color: _blueColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RappiProductItem extends StatelessWidget {
  const _RappiProductItem(this.product);
  final RappiProduct? product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(product!.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product!.name,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product!.description,
                      maxLines: 2,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${product!.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/



/* CODIGO ORIGINAL
import 'package:flutter/material.dart';
import 'package:menu/providers/rappi_data.dart';
import 'package:menu/screens/rappi_concept/rappi_bloc.dart';

const _backgroundColor = Color(0xFFF6F9FA);
const _blueColor = Color(0xFF0D1863);
const _greenColor = Color(0xFF2BBEBA);

class MainRappiConceptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: _RappiConcept(),
    );
  }
}

class _RappiConcept extends StatefulWidget {
  @override
  __RappiConceptState createState() => __RappiConceptState();
}

class __RappiConceptState extends State<_RappiConcept>
    with SingleTickerProviderStateMixin {
  final _bloc = RappiBLoC();

  @override
  void initState() {
    _bloc.init(this);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _bloc,
          builder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Homepage',
                        style: TextStyle(
                          color: _blueColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: _greenColor,
                        radius: 17,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                child: TabBar(
                  onTap: _bloc.onCategorySelected,
                  controller: _bloc.tabController,
                  indicatorWeight: 0.1,
                  isScrollable: true,
                  tabs: _bloc.tabs.map((e) => _RappiTabWidget(e)).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _bloc.scrollController,
                  itemCount: _bloc.items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final item = _bloc.items[index];
                    if (item.isCategory) {
                      return _RappiCategoryItem(item.category);
                    } else {
                      return _RappiProductItem(item.product);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RappiTabWidget extends StatelessWidget {
  const _RappiTabWidget(this.tabCategory);
  final RappiTabCategory tabCategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabCategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tabCategory.category.name,
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

class _RappiCategoryItem extends StatelessWidget {
  const _RappiCategoryItem(this.category);
  final RappiCategory? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(
        category!.name,
        style: TextStyle(
          color: _blueColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RappiProductItem extends StatelessWidget {
  const _RappiProductItem(this.product);
  final RappiProduct? product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(product!.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product!.name,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product!.description,
                      maxLines: 2,
                      style: TextStyle(
                        color: _blueColor,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${product!.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _greenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/