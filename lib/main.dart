import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu/models/device_tracking_info.dart';
import 'package:menu/providers/device_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/not_found_screen.dart';
import 'package:menu/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _branchLinkFuture;
  String _branchId = '';
  String _sessionId = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _branchLinkFuture = _getBranchLink();
  }

  Future<String> _getBranchLink() async {
    var currentUrl = Uri.base.toString();
    var urlParts = currentUrl.split('/');
    var branchLink = urlParts.last;

    if (branchLink == branchLink.toLowerCase() && branchLink.contains('-')) {
      return branchLink;
    } else {
      setState(() {
        _hasError = true;
      });
      return Future.error("URL no válida");
    }
  }

  void _printDeviceInfoAndParseUserAgent() async {
    try {
      var userAgent = html.window.navigator.userAgent;
      var platform = html.window.navigator.platform;
      var vendor = html.window.navigator.vendor;
      var language = html.window.navigator.language;

      var browserMatches = RegExp(r'(Firefox|Chrome|Safari|Opera|Edg)/(\S+)')
          .firstMatch(userAgent);
      var browser = '';
      var browserVersion = '';
      if (browserMatches != null) {
        browser = browserMatches.group(1) ?? '';
        browserVersion = browserMatches.group(2) ?? '';
      }

      var os = '';
      if (userAgent.contains('Windows')) {
        os = 'Windows';
      } else if (userAgent.contains('Mac OS')) {
        os = 'MacOS';
      } else if (userAgent.contains('Linux')) {
        os = 'Linux';
      } else if (userAgent.contains('Android')) {
        os = 'Android';
      } else if (userAgent.contains('iPhone') || userAgent.contains('iPad')) {
        os = 'iOS';
      }

      var pixelRatio = MediaQuery.of(context).devicePixelRatio;
      var screenSize = MediaQuery.of(context).size;
      var orientation = MediaQuery.of(context).orientation.toString();

      var deviceInfo = DeviceTrackingInfo(
        branchId: _branchId,
        sessionId: _sessionId,
        userAgent: userAgent,
        platform: platform ?? "",
        vendor: vendor,
        language: language,
        browser: browser,
        browserVersion: browserVersion,
        os: os,
        pixelRatio: pixelRatio,
        screenWidth: screenSize.width.toInt(),
        screenHeight: screenSize.height.toInt(),
        orientation: orientation,
      );

      // Imprimir el objeto en formato JSON
      print(deviceInfo.toJson());
      if (mounted) {
        Provider.of<DeviceInfoProvider>(context, listen: false)
            .setDeviceInfo(deviceInfo);
      }
    } catch (e) {
      print("Error obteniendo la información del dispositivo: $e");
      // Considera cómo manejar este error en tu UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
        ChangeNotifierProvider(create: (_) => ScrollTabBarBLoC()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProvider(create: (_) => DeviceInfoProvider()),
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
                if (_hasError || snapshot.hasError) {
                  return NotFoundScreen();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    try {
                      await Provider.of<BranchCatalogProvider>(context,
                              listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                      final branchCatalogProvider =
                          Provider.of<BranchCatalogProvider>(context,
                              listen: false);
                      _sessionId = branchCatalogProvider.sessionId;
                      _branchId = branchCatalogProvider.branchCatalog!.branchId;
                      _printDeviceInfoAndParseUserAgent();
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        _hasError = true;
                      });
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/not_found_screen.dart';
import 'package:menu/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _branchLinkFuture;
  String _branchId = '';
  String _sessionId = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _branchLinkFuture = _getBranchLink();
  }

  Future<String> _getBranchLink() async {
    var currentUrl = Uri.base.toString();
    var urlParts = currentUrl.split('/');
    var branchLink = urlParts.last;

    if (branchLink == branchLink.toLowerCase() && branchLink.contains('-')) {
      return branchLink;
    } else {
      setState(() {
        _hasError = true;
      });
      return Future.error("URL no válida");
    }
  }

  void _printDeviceInfoAndParseUserAgent() {
    var userAgent = html.window.navigator.userAgent;
    var platform = html.window.navigator.platform;
    var vendor = html.window.navigator.vendor;
    var language = html.window.navigator.language;

    print("BranchId $_branchId");
    print("SessionId $_sessionId");
    print('Full User Agent: $userAgent');
    print('Platform: $platform');
    print('Vendor: $vendor');
    print('Language: $language');

    var browserMatches = RegExp(r'(Firefox|Chrome|Safari|Opera|Edg)/(\S+)')
        .firstMatch(userAgent);
    if (browserMatches != null) {
      print('Browser: ${browserMatches.group(1)}');
      print('Browser Version: ${browserMatches.group(2)}');
    }

    var os = '';
    if (userAgent.contains('Windows')) {
      os = 'Windows';
    } else if (userAgent.contains('Mac OS')) {
      os = 'MacOS';
    } else if (userAgent.contains('Linux')) {
      os = 'Linux';
    } else if (userAgent.contains('Android')) {
      os = 'Android';
    } else if (userAgent.contains('iPhone') || userAgent.contains('iPad')) {
      os = 'iOS';
    }
    print('OS: $os');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pixelRatio = MediaQuery.of(context).devicePixelRatio;
      var screenSize = MediaQuery.of(context).size;
      var orientation = MediaQuery.of(context).orientation;

      print('Pixel Ratio: $pixelRatio');
      print('Screen Size: ${screenSize.width}x${screenSize.height}');
      print('Orientation: $orientation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
        ChangeNotifierProvider(create: (_) => ScrollTabBarBLoC()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
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
                if (_hasError || snapshot.hasError) {
                  return NotFoundScreen();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    try {
                      await Provider.of<BranchCatalogProvider>(context,
                              listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                      final branchCatalogProvider =
                          Provider.of<BranchCatalogProvider>(context,
                              listen: false);
                      _sessionId = branchCatalogProvider.sessionId;
                      _branchId = branchCatalogProvider.branchCatalog!.branchId;
                      _printDeviceInfoAndParseUserAgent();
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        _hasError = true;
                      });
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

/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/not_found_screen.dart';
import 'package:menu/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _branchLinkFuture;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _branchLinkFuture = _getBranchLink();
    _printDeviceInfo();
  }

  Future<String> _getBranchLink() async {
    var currentUrl = Uri.base.toString();
    var urlParts = currentUrl.split('/');
    var branchLink = urlParts.last;

    if (branchLink == branchLink.toLowerCase() && branchLink.contains('-')) {
      return branchLink;
    } else {
      setState(() {
        _hasError = true;
      });
      return Future.error("URL no válida");
    }
  }

  void _printDeviceInfo() {
    var userAgent = html.window.navigator.userAgent;
    print('Full User Agent: $userAgent');

    _parseAndPrintUserAgent(userAgent);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pixelRatio = MediaQuery.of(context).devicePixelRatio;
      var screenSize = MediaQuery.of(context).size;
      var orientation = MediaQuery.of(context).orientation;

      print('Pixel Ratio: $pixelRatio');
      print('Screen Size: ${screenSize.width}x${screenSize.height}');
      print('Orientation: $orientation');
    });
  }

  void _parseAndPrintUserAgent(String userAgent) {
    var parameters = [
      'Platform: ${html.window.navigator.platform}',
      'Vendor: ${html.window.navigator.vendor}',
      'Language: ${html.window.navigator.language}',
    ];

    var browserMatches = RegExp(r'(Firefox|Chrome|Safari|Opera|Edg)/(\S+)')
        .firstMatch(userAgent);
    if (browserMatches != null) {
      parameters.add('Browser: ${browserMatches.group(1)}');
      parameters.add('Browser Version: ${browserMatches.group(2)}');
    }

    if (userAgent.contains('Windows')) {
      parameters.add('OS: Windows');
    } else if (userAgent.contains('Mac OS')) {
      parameters.add('OS: MacOS');
    } else if (userAgent.contains('Linux')) {
      parameters.add('OS: Linux');
    } else if (userAgent.contains('Android')) {
      parameters.add('OS: Android');
    } else if (userAgent.contains('iPhone') || userAgent.contains('iPad')) {
      parameters.add('OS: iOS');
    }

    for (var parameter in parameters) {
      print(parameter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
        ChangeNotifierProvider(create: (_) => ScrollTabBarBLoC()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
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
                if (_hasError || snapshot.hasError) {
                  return NotFoundScreen();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    try {
                      await Provider.of<BranchCatalogProvider>(context,
                              listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        _hasError = true;
                      });
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
/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/not_found_screen.dart';
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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _branchLinkFuture = _getBranchLink();
    _printDeviceInfo();
  }

  Future<String> _getBranchLink() async {
    await Future.delayed(Duration.zero);
    var currentUrl = Uri.base.toString();
    var urlParts = currentUrl.split('/');
    var branchLink = urlParts.last;

    if (branchLink == branchLink.toLowerCase() && branchLink.contains('-')) {
      return branchLink;
    } else {
      setState(() {
        _hasError = true;
      });
      return Future.error("URL no válida");
    }
  }

  void _printDeviceInfo() {
    // Extracción e impresión de la información del User Agent
    var userAgent = html.window.navigator.userAgent;
    print('Full User Agent: $userAgent');

    _parseAndPrintUserAgent(userAgent);

    // Información adicional sobre el dispositivo y la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pixelRatio = MediaQuery.of(context).devicePixelRatio;
      var screenSize = MediaQuery.of(context).size;
      var orientation = MediaQuery.of(context).orientation;

      print('Pixel Ratio: $pixelRatio');
      print('Screen Size: ${screenSize.width}x${screenSize.height}');
      print('Orientation: $orientation');
    });
  }

  void _parseAndPrintUserAgent(String userAgent) {
    var parameters = [
      'Platform: ${html.window.navigator.platform}',
      'Vendor: ${html.window.navigator.vendor}',
      'Language: ${html.window.navigator.language}',
    ];

    // Intenta identificar el navegador y la versión
    var browserMatches = RegExp(r'(Firefox|Chrome|Safari|Opera|Edg)/(\S+)')
        .firstMatch(userAgent);
    if (browserMatches != null) {
      parameters.add('Browser: ${browserMatches.group(1)}');
      parameters.add('Browser Version: ${browserMatches.group(2)}');
    }

    // Intenta identificar el sistema operativo
    if (userAgent.contains('Windows')) {
      parameters.add('OS: Windows');
    } else if (userAgent.contains('Mac OS')) {
      parameters.add('OS: MacOS');
    } else if (userAgent.contains('Linux')) {
      parameters.add('OS: Linux');
    } else if (userAgent.contains('Android')) {
      parameters.add('OS: Android');
    } else if (userAgent.contains('iPhone') || userAgent.contains('iPad')) {
      parameters.add('OS: iOS');
    }

    // Imprimir cada parámetro identificado
    for (var parameter in parameters) {
      print(parameter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BranchCatalogProvider()),
        ChangeNotifierProvider(create: (_) => ScrollTabBarBLoC()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
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
                if (_hasError || snapshot.hasError) {
                  return NotFoundScreen();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    try {
                      await Provider.of<BranchCatalogProvider>(context,
                              listen: false)
                          .fetchBranchCatalog(snapshot.data!);
                    } catch (e) {
                      if (!mounted) return;
                      setState(() {
                        _hasError = true;
                      });
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