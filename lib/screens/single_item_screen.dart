import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/models/branch_catalog_response.dart'; // Asegúrate de tener esta clase definida o ajusta según tu modelo
import 'package:url_launcher/url_launcher.dart';

class SingleItemScreen extends StatelessWidget {
  final Item item; // Asegúrate de que 'Item' esté definido en tu modelo

  const SingleItemScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _launchUrl(Uri url) async {
      if (!await launchUrl(url)) {
        // Maneja el error o muestra un mensaje si es necesario
      }
    }

    Widget buildItemImage() {
      // Widget para la imagen con margen y bordes redondeados
      Widget imageWidget(String imageUrl) {
        return Padding(
          padding:
              const EdgeInsets.all(30.0), // Ajusta el padding según necesites
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                50.0), // Ajusta el radio del borde según necesites
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Retorna una imagen predeterminada en caso de error
                return Image.asset(
                  "images/tools/cooking.png",
                  width: double.infinity,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
        );
      }

      // Decide cuál widget de imagen usar basado en si item.icon es null o no
      if (item.icon != null) {
        return imageWidget(item.icon!);
      } else {
        // Usa una imagen predeterminada si item.icon es null
        return imageWidget("images/tools/cooking.png");
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 520,
            height: 932,
            child: Column(
              children: [
                // Barra superior
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              item.alias, // Asegúrate de que 'alias' es un campo válido de 'Item'
                              style: GoogleFonts.pacifico(
                                  color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Contenedor expandible entre la barra superior e inferior
                Expanded(
                  child: SingleChildScrollView(
                    // Permite el desplazamiento
                    child: Container(
                      color: Colors.grey[200], // Ejemplo de color de fondo
                      child: Column(
                        children: [
                          buildItemImage(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.description,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (item.modifiersGroups.isEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "\$${item.price?.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize:
                                      24, // Aumentando el tamaño de la letra
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          if (item.modifiersGroups.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Personalizalo a tu gusto",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      24, // Aumentando el tamaño de la letra
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Importante para evitar el desplazamiento anidado
                              itemCount: item.modifiersGroups.length,
                              itemBuilder: (context, index) {
                                final group = item.modifiersGroups[index];
                                return ListTile(
                                  title: Text(
                                    group.alias,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        NeverScrollableScrollPhysics(), // Esto previene el scrolling interno de esta lista
                                    itemCount: group.modifiers.length,
                                    itemBuilder: (context, modIndex) {
                                      final modifier =
                                          group.modifiers[modIndex];
                                      return Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                            child: Icon(Icons.circle, size: 10),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            modifier.alias,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 23),
                                          ),
                                          Spacer(),
                                          Text(
                                            modifier.price != 0
                                                ? "\$${modifier.price.toString()}"
                                                : '-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 23),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Barra inferior
                Container(
                  color: Colors.black,
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _launchUrl(Uri.parse('https://www.4urest.mx')),
                        child: Text(
                          'Diseñado por ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 5), // Usa SizedBox para espacio horizontal
                      GestureDetector(
                        onTap: () {
                          _launchUrl(Uri.parse('https://www.4urest.mx'));
                        },
                        child: Image.asset(
                          'images/tools/4uRestFont-white.png',
                          height:
                              35, // Ajusta esto según sea necesario para que coincida con el diseño deseado
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(
          Icons.arrow_back, // Icono de flecha hacia atrás
          color: Colors.white,
        ),
        backgroundColor: Color(0xFFE57734),
      ),
    );
  }
}
