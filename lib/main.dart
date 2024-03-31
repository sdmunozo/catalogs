import 'package:flutter/material.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'dart:js' as js;
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/screen_not_found.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _branchLinkFuture;

  @override
  void initState() {
    super.initState();
    _branchLinkFuture = _getBranchLink();
  }

  Future<String> _getBranchLink() async {
    await Future.delayed(Duration.zero);
    String currentUrl = js.context['location']['href'];
    List<String> urlParts = currentUrl.split('/');
    String branchLink = urlParts.last;

    if (branchLink == branchLink.toLowerCase() && branchLink.contains('-')) {
      return branchLink; // Texto válido
    } else {
      throw Exception(
          "URL no válida"); // Lanza una excepción para indicar que la URL no es válida
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
        ChangeNotifierProvider(create: (_) => ScrollTabBarBLoC()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFF212325),
        ),
        home: Builder(
          builder: (BuildContext context) {
            return FutureBuilder<String>(
              future: _branchLinkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  // Aquí se maneja el error mostrando ScreenNotFound
                  return ScreenNotFound();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (snapshot.hasData) {
                      Provider.of<BranchCatalogProvider>(context, listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                    }
                  });
                  return WelcomeScreen();
                }
              },
            );
          },
        ),
      ),
    );
  }
}


/*

import 'package:flutter/material.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'dart:js' as js;
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/screen_not_found.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _branchLinkFuture;

  @override
  void initState() {
    super.initState();
    _branchLinkFuture = _getBranchLink();
  }

  Future<String> _getBranchLink() async {
    await Future.delayed(Duration.zero);
    String currentUrl = js.context['location']['href'];
    List<String> urlParts = currentUrl.split('/');
    String branchLink = urlParts.last;

    // Verifica que el branchLink esté en minúsculas y contenga al menos un guion medio
    if (branchLink == branchLink.toLowerCase() && branchLink.contains('-')) {
      return branchLink; // Texto válido
    } else {
      return ""; // Indica inválido
    }
  }

  /*Future<String> _getBranchLink() async {
    await Future.delayed(Duration.zero);
    String currentUrl = js.context['location']['href'];
    List<String> urlParts = currentUrl.split('/');
    String branchLink = urlParts.last;
    return branchLink;
  }*/

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
        ChangeNotifierProvider(create: (_) => ScrollTabBarBLoC()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFF212325),
        ),
        home: Builder(
          builder: (BuildContext context) {
            return FutureBuilder<String>(
              future: _branchLinkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  print('Error al inicializar la app: ${snapshot.error}');
                  return Scaffold(
                      body: Center(
                          child: Text(
                              "Error al inicializar la app: ${snapshot.error}")));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (snapshot.hasData) {
                      Provider.of<BranchCatalogProvider>(context, listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                    }
                  });
                  return WelcomeScreen();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

*/