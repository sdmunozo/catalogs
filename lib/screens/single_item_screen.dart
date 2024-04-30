import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:url_launcher/url_launcher.dart';

final TextStyle myHeadlineTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

final TextStyle myBodyTextStyle = TextStyle(
  fontSize: 14,
);

class SingleItemScreen extends StatelessWidget {
  final Item item;

  const SingleItemScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _launchUrl(Uri url) async {
      if (!await launchUrl(url)) {}
    }

    Widget buildItemImage() {
      Widget imageWidget(String imageUrl) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      "assets/images/tools/4uRestIcon-black.png",
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }

      return imageWidget(item.icon);
    }

    bool isAnyGroupSelectable =
        item.modifiersGroups.any((group) => group.isSelectable == 'True');

    final priceTextStyle = TextStyle(
      color: Colors.green, // Color del texto del precio
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 520,
            height: 932,
            child: Column(
              children: [
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
                              style: GoogleFonts.montserratAlternates(
                                  color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          buildItemImage(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          isAnyGroupSelectable &&
                                  item.price.isNotEmpty &&
                                  item.price != '0'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "\$${double.parse(item.price).toStringAsFixed(2)}",
                                    style: priceTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                          if (item.modifiersGroups.isEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                (item.price != '0')
                                    ? "\$${double.parse(item.price)?.toStringAsFixed(2)}"
                                    : 'Varias Opciones de \$',
                                style: priceTextStyle,
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
                                  fontSize: 18,
                                ),
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
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
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
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            (modifier.price.isNotEmpty &&
                                                    modifier.price != '0')
                                                ? "\$${double.parse(modifier.price)?.toStringAsFixed(2)}"
                                                : '',
                                            style: priceTextStyle,
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
                            _launchUrl(Uri.parse('https://landing.4urest.mx/')),
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
                          _launchUrl(Uri.parse('https://landing.4urest.mx/'));
                        },
                        child: Image.asset(
                          'assets/images/tools/4uRestFont-white.png',
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
