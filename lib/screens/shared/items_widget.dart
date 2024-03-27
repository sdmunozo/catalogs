import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart'; // Asegúrate de que este import corresponda con tus modelos.

class MenuItemCard extends StatelessWidget {
  final String cardType;
  final Item item;
  final VoidCallback onTap;

  const MenuItemCard({
    Key? key,
    required this.cardType,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldShowPrice = cardType == "item" &&
        item.price != null &&
        item.price.isNotEmpty &&
        item.price != '0';

    final String priceString = shouldShowPrice
        ? "\$${double.parse(item.price).toStringAsFixed(2)}"
        : 'Varias Opciones de \$';

    List<Widget> buildModifiersWidgets() {
      List<Widget> widgetsList = [];
      for (var group in item.modifiersGroups) {
        List<Widget> modifierWidgets = group.modifiers
            .map((modifier) => Text(
                  '• ${modifier.alias} - \$${double.parse(modifier.price).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14),
                ))
            .toList();

        if (modifierWidgets.isNotEmpty) {
          widgetsList.add(Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.alias,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                ...modifierWidgets,
              ],
            ),
          ));
        }
      }
      return widgetsList;
    }

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      //const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenedor de texto agrupado en una columna
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.alias,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16) ??
                          const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontSize: 14) ??
                            const TextStyle(fontSize: 14),
                      ),
                    ],
                    if (shouldShowPrice) ...[
                      const SizedBox(height: 0),
                      Text(
                        priceString,
                        style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.green, fontSize: 16) ??
                            const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                    // Incluyendo los widgets de modificadores aquí para mantenerlos dentro de la columna de texto
                    ...buildModifiersWidgets(),
                  ],
                ),
              ),
              // Columna de la imagen
              if (item.icon != null && item.icon!.isNotEmpty) ...[
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.icon!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(width: 0, height: 0),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
