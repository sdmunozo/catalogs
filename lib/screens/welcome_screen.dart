import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/providers/branch_catalog_provider.dart';
import 'package:menu/providers/device_info_provider.dart';
import 'package:menu/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      print('No se pudo lanzar $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceInfoProvider =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    deviceInfoProvider.trackDevice(deviceInfoProvider.deviceInfo);

    return Consumer<BranchCatalogProvider>(
      builder: (context, branchCatalogProvider, child) {
        if (branchCatalogProvider.branchCatalog == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildContent(context, branchCatalogProvider);
      },
    );
  }

  Widget _buildContent(
      BuildContext context, BranchCatalogProvider branchCatalogProvider) {
    final brandName =
        branchCatalogProvider.branchCatalog?.brandName ?? 'Tu Empresa';
    final branchName =
        branchCatalogProvider.branchCatalog?.branchName ?? 'Tu Sucursal';
    final Uri _url_insta = Uri.parse(
        branchCatalogProvider.branchCatalog?.instagramLink ??
            'https://www.instagram.com/');
    final Uri _url_fb = Uri.parse(
        branchCatalogProvider.branchCatalog?.facebookLink ??
            'https://www.facebook.com/');
    final Uri _url_web = Uri.parse(
        branchCatalogProvider.branchCatalog?.websiteLink ??
            'https://www.4urest.mx/');
    final brand_slogan = branchCatalogProvider.branchCatalog?.brandSlogan ??
        '¡Visitanos en nuestras redes sociales!';

    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            width: 520,
            height: 932,
            child: Container(
              padding: EdgeInsets.only(top: 100, bottom: 40),
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(branchCatalogProvider
                          .branchCatalog?.menuBackground ??
                      'https://api4urest.blob.core.win2dows.net/brands/System.Func%601%5BSystem.Guid%5D'),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                        child: Text(
                          brandName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.pacifico(
                              fontSize: 35, color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Text(
                          branchName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.pacifico(
                              fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        brand_slogan,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCircularButton(
                              "assets/images/tools/insta.png", _url_insta),
                          SizedBox(width: 20),
                          _buildCircularButton(
                              "assets/images/tools/fb.png", _url_fb),
                          SizedBox(width: 20),
                          _buildCircularButton(
                              "assets/images/tools/link.png", _url_web),
                        ],
                      ),
                      SizedBox(height: 40),
                      Material(
                        color: Color(0xFFE57734),
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            decoration: BoxDecoration(),
                            child: Text(
                              "Ver Menú",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          _launchUrl(Uri.parse('https://www.4urest.mx'));
                        },
                        child: Text(
                          'Diseñado por',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          _launchUrl(Uri.parse('https://www.4urest.mx'));
                        },
                        child: Image.asset(
                          'assets/images/tools/4uRestFont-white.png',
                          height: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(String assetPath, Uri url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        width: 60, // Tamaño del botón
        height: 60, // Tamaño del botón
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey.withOpacity(0.6), // Color de fondo del botón
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
