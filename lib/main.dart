import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:menu/providers/branch_catalog_provider.dart';
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
    await Future.delayed(
        Duration.zero); // Espera hasta que el frame actual esté dibujado
    String currentUrl = js.context['location']['href'];
    print('URL actual: $currentUrl'); // Impresión de depuración
    List<String> urlParts = currentUrl.split('/');
    String branchLink = urlParts.last;
    print('Branch link obtenido: $branchLink'); // Impresión de depuración
    return branchLink;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
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
                      print(
                          'Iniciando la carga del catálogo con branch link: ${snapshot.data}');
                      // Aquí llamarías a tu función para cargar los datos usando el provider
                      Provider.of<BranchCatalogProvider>(context, listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                    }
                  });
                  return WelcomeScreen(); // La app está lista para ser mostrada
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

se agrego la parte de dio solamente, un waiting screen

import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:menu/screens/welcome_screen.dart';

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
    await Future.delayed(Duration(seconds: 2));
    String currentUrl = js.context['location']['href'];
    List<String> urlParts = currentUrl.split('/');
    String branchLink = urlParts.last;
    return branchLink;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF212325),
      ),
      home: FutureBuilder<String>(
        future: _branchLinkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text("Error al obtener branch link")));
          } else {
            // Aquí es donde continuarías construyendo tu app, sabiendo que tienes el branch_link
            // Puedes llamar al endpoint aquí o pasar el branch_link a donde lo necesites
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
*/


/*

Codigo original, simple, sin nada de apis o endpoints, solo imprime el branch_name en terminal

import 'package:flutter/material.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'dart:js' as js; // Importa el paquete dart:js

void main() {
  // Obtiene la URL actual
  String currentUrl = js.context['location']['href'];

  // Procesa la URL para obtener la parte que te interesa
  List<String> urlParts = currentUrl.split('/');
  String branch_link =
      urlParts.last; // Asumiendo que la parte que necesitas está al final

  // Imprime en la consola del navegador. Considera cómo quieres imprimir en la terminal.
  print(branch_link);

  // Corre la aplicación Flutter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF212325),
      ),
      home: WelcomeScreen(),
    );
  }
}

*/