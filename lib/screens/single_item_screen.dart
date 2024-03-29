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
          padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10), // Ajusta el padding según necesites
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                50.0), // Ajusta el radio del borde según necesites
            child: AspectRatio(
              aspectRatio:
                  1, // Ejemplo de relación de aspecto, ajusta según tus necesidades
              child: Image.network(
                imageUrl,
                fit: BoxFit
                    .cover, // Puedes ajustar esto para cambiar cómo se ajusta la imagen dentro del contenedor
                errorBuilder: (context, error, stackTrace) {
                  // Retorna una imagen predeterminada en caso de error
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      "images/tools/4uRestIcon-black.png",
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
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
                              item.alias,
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
                              style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ) ??
                                  const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (item.modifiersGroups.isEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                (item.price != null &&
                                        item.price.isNotEmpty &&
                                        item.price != '0')
                                    ? "\$${double.parse(item.price)?.toStringAsFixed(2)}"
                                    : 'Varias Opciones de \$',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 24,
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
                                style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(
                                          fontSize: 18,
                                        ) ??
                                    const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: item.modifiersGroups.length,
                              itemBuilder: (context, index) {
                                final group = item.modifiersGroups[index];
                                return ListTile(
                                  title: Text(
                                    group.alias,
                                    style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                              fontSize: 18,
                                            ) ??
                                        const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
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
                                            style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ) ??
                                                const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Spacer(),
                                          Text(
                                            (modifier.price != null &&
                                                    modifier.price.isNotEmpty &&
                                                    modifier.price != '0')
                                                ? "\$${double.parse(modifier.price)?.toStringAsFixed(2)}"
                                                : '',
                                            style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ) ??
                                                const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
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


    /*

    Widget buildItemImage() {
      // Widget para la imagen con margen y bordes redondeados
      Widget imageWidget(String imageUrl) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10), // Ajusta el padding según necesites
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                50.0), // Ajusta el radio del borde según necesites
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Retorna una imagen predeterminada en caso de error
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      "images/tools/4uRestIcon-black.png",
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
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
    }*/
