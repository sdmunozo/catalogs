import 'package:flutter/material.dart';
import 'package:menu/bloc/scroll_tabbar_bloc.dart';
import 'dart:js' as js;
import 'dart:async';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/feedback_provider.dart';
import 'package:menu/screens/not_found_screen.dart';
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
  bool _hasError = false;

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
      setState(() {
        _hasError = true;
      });
      return Future.error("URL no válida");
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
