import 'package:flutter/material.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'dart:js'
    as js; // Asume el uso de la biblioteca dart:js para interoperabilidad con JavaScript
import 'dart:async'; // Importante para usar Timer
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
      return branchLink;
    } else {
      throw Exception("URL no válida");
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
                  // Muestra el CircularProgressIndicator si aún está cargando
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  // Muestra ScreenNotFound si hay un error
                  return ScreenNotFound();
                } else {
                  // Ejecuta una acción después de construir el widget
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (snapshot.hasData) {
                      Provider.of<BranchCatalogProvider>(context, listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                    }
                  });
                  // Muestra WelcomeScreen en caso de éxito
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
