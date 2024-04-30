import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLandingWidget extends StatefulWidget {
  @override
  _LinkLandingWidgetState createState() => _LinkLandingWidgetState();
}

class _LinkLandingWidgetState extends State<LinkLandingWidget>
    with SingleTickerProviderStateMixin {
  final String url = 'https://landing.4urest.mx/';
  late AnimationController _animationController;
  late Animation<double> _moveAnimation;
  late Animation<Color?> _backgroundColor;
  Timer? _timer;
  int _logoIndex = 0;
  List<String> logos = [
    'assets/tools/4uRest-DM-3.png',
    'assets/tools/McDonaldsLogotipo.png',
  ];

  Future<void> launchUrlLink(Uri url, BuildContext context) async {
    try {
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        //print('No se pudo lanzar $url');
      } else {
        //print('Enlace lanzado con éxito: $url');
      }
    } catch (e) {
      //print('Error al lanzar $url: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _moveAnimation =
        Tween<double>(begin: -1, end: 1).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _backgroundColor = ColorTween(begin: Colors.white, end: Colors.white)
        .animate(_animationController);

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _logoIndex = (_logoIndex + 1) % logos.length;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _moveAnimation.value),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return InkWell(
            onTap: () => launchUrlLink(Uri.parse(url), context),
            child: Container(
              width: 400,
              height: 160,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _backgroundColor.value,
                border: Border.all(
                  color: Colors.blue, // Color del borde
                  width: 4.0, // Ancho del borde
                ),
                borderRadius: BorderRadius.circular(20.0), // Redondeo del borde
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(logos[_logoIndex], width: 50),
                    const Expanded(
                      child: Text(
                        'Menu Digital Demo Aquí',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Image.asset(logos[(_logoIndex + 1) % logos.length],
                        width: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkMenuDemoWidget extends StatefulWidget {
  @override
  _LinkMenuDemoWidgetState createState() => _LinkMenuDemoWidgetState();
}

class _LinkMenuDemoWidgetState extends State<LinkMenuDemoWidget>
    with SingleTickerProviderStateMixin {
  final String url = 'https://menu.4urest.mx/mcdonalds-macroplaza';
  late AnimationController _animationController;
  late Animation<double> _moveAnimation;
  late Animation<Color?> _backgroundColor;
  Timer? _timer;
  int _logoIndex = 0;
  List<String> logos = [
    'assets/tools/4uRest-DM-3.png',
    'assets/tools/McDonaldsLogotipo.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _moveAnimation =
        Tween<double>(begin: -12.5, end: 12.5).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _backgroundColor =
        ColorTween(begin: Colors.white, end: Colors.lightBlue[100])
            .animate(_animationController);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _logoIndex = (_logoIndex + 1) % logos.length;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _moveAnimation.value),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return InkWell(
            onTap: () => _launchURL(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: _backgroundColor.value,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(logos[_logoIndex], width: 50),
                    Expanded(
                      child: Text(
                        'Menu Digital Demo Aquí',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Image.asset(logos[(_logoIndex + 1) % logos.length],
                        width: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}

*/
/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkMenuDemoWidget extends StatefulWidget {
  @override
  _LinkMenuDemoWidgetState createState() => _LinkMenuDemoWidgetState();
}

class _LinkMenuDemoWidgetState extends State<LinkMenuDemoWidget>
    with SingleTickerProviderStateMixin {
  final String url = 'https://menu.4urest.mx/mcdonalds-macroplaza';
  late AnimationController _animationController;
  late Animation<double> _moveAnimation;
  late Animation<Color?> _backgroundColor;
  Timer? _timer;
  int _logoIndex = 0;
  List<String> logos = [
    'assets/tools/4uRest-DM-3.png',
    'assets/tools/McDonaldsLogotipo.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _moveAnimation =
        Tween<double>(begin: 0, end: 25).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });

    _backgroundColor =
        ColorTween(begin: Colors.white, end: Colors.lightBlue[100])
            .animate(_animationController);

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _logoIndex = (_logoIndex + 1) % logos.length;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
          0,
          _moveAnimation.value -
              25), // Centrar el movimiento alrededor de la posición original
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return InkWell(
            onTap: () => _launchURL(),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: _backgroundColor.value,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(logos[_logoIndex], width: 50),
                    Expanded(
                      child: Text(
                        'Menu Digital Demo Aquí',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Image.asset(logos[(_logoIndex + 1) % logos.length],
                        width: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}

*/

/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkMenuDemoWidget extends StatefulWidget {
  @override
  _LinkMenuDemoWidgetState createState() => _LinkMenuDemoWidgetState();
}

class _LinkMenuDemoWidgetState extends State<LinkMenuDemoWidget>
    with SingleTickerProviderStateMixin {
  final String url = 'https://menu.4urest.mx/mcdonalds-macroplaza';
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColor;
  Timer? _timer;
  int _logoIndex = 0;
  List<String> logos = [
    'assets/tools/4uRest-DM-3.png',
    'assets/tools/McDonaldsLogotipo.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    _backgroundColor =
        ColorTween(begin: Colors.white, end: Colors.lightBlue[100])
            .animate(_animationController);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _logoIndex = (_logoIndex + 1) % logos.length;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return InkWell(
          onTap: () => _launchURL(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: _backgroundColor.value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(logos[_logoIndex], width: 50),
                  Expanded(
                    child: Text(
                      'Menu Digital Demo Aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Image.asset(logos[(_logoIndex + 1) % logos.length],
                      width: 50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkMenuDemoWidget extends StatefulWidget {
  @override
  _LinkMenuDemoWidgetState createState() => _LinkMenuDemoWidgetState();
}

class _LinkMenuDemoWidgetState extends State<LinkMenuDemoWidget>
    with SingleTickerProviderStateMixin {
  final String url = 'https://tu-enlace-aqui.com';
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColor;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
    _backgroundColor = ColorTween(
            begin: const Color.fromRGBO(246, 246, 246, 1),
            end: Colors.lightBlue[100])
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return InkWell(
          onTap: () => _launchURL(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: _backgroundColor.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/tools/4uRest-DM-3.png', width: 50),
                Expanded(
                  child: Text(
                    'Menu Digital Demo Aquí',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Image.asset('assets/tools/McDonalds-logo.png', width: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}

*/

/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkMenuDemoWidget extends StatelessWidget {
  final String url = 'https://tu-enlace-aqui.com';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/tools/4uRest-DM-3.png', width: 50),
            Expanded(
              child: Text(
                'Menu Digital Demo Aquí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Image.asset('assets/tools/McDonalds-logo.png', width: 50),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
*/
/*
            Image.asset('assets/tools/4uRest-DM-3.png', width: 50),
            Expanded(
              child: Text(
                'Menu Digital Demo Aquí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Image.asset('assets/McDonalds-logo.png', width: 50),
 */
