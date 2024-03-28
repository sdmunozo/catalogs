import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> _getBranchLink() async {
    // Esta función permanece igual
    await Future.delayed(Duration.zero);
    String currentUrl = js.context['location']['href'];
    print('URL actual: $currentUrl');
    List<String> urlParts = currentUrl.split('/');
    String branchLink = urlParts.last;
    print('Branch link obtenido: $branchLink');
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
        home: FutureBuilder<String>(
          future: _getBranchLink(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                      child: Text(
                          "Error al inicializar la app: ${snapshot.error}")));
            } else {
              // Aseguramos que el future se haya resuelto antes de acceder al provider
              final branchLink = snapshot.data ?? '';
              // De forma segura podemos ahora inicializar nuestro catalogo con el branchLink
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (snapshot.hasData) {
                  Provider.of<BranchCatalogProvider>(context, listen: false)
                      .fetchBranchCatalog(branchLink);
                }
              });

              return WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  //await dotenv.load(fileName: ".env");
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

*/