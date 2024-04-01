import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NotFoundScreen extends StatelessWidget {
  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      print('No se pudo lanzar $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri _urlInstagram = Uri.parse('https://www.instagram.com/4urest/');
    final Uri _urlWhatsApp = Uri.parse(
        'https://api.whatsapp.com/send?phone=5218180836587&text=%C2%A1Hola%204uRest!%20estoy%20interesado%20en%3A');
    final Uri _urlWeb = Uri.parse('https://www.4urest.mx');

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/tools/4uRest-DM-3.png', width: 200),
                SizedBox(height: 40),
                Text(
                  'Página no encontrada',
                  style:
                      GoogleFonts.pacifico(fontSize: 24, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Lo sentimos, la página que buscas no existe. Visita nuestras redes sociales.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(
                        "assets/images/tools/whatsapp1.png", _urlWhatsApp),
                    SizedBox(width: 20),
                    _buildCircularButton(
                        "assets/images/tools/insta.png", _urlInstagram),
                    SizedBox(width: 20),
                    _buildCircularButton(
                        "assets/images/tools/link.png", _urlWeb),
                  ],
                ),
                SizedBox(height: 40),
              ],
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
          color: Color.fromRGBO(36, 169, 225, 1),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
