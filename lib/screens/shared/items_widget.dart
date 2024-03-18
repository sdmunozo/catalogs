import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';

class MenuItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const MenuItemCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String priceString = (item.price != null && item.price != 0)
        ? "\$${item.price?.toStringAsFixed(2)}"
        : 'Varias Opciones de \$';

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.alias,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ) ??
                          const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontSize: 12,
                              ) ??
                          const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceString,
                      style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.green, fontSize: 16) ??
                          const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
              if (item.icon != null) ...[
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.icon!,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(), // No muestra nada si hay un error
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

/*
import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';

class MenuItemCard extends StatelessWidget {
  final String alias;
  final String description;
  final double? price; // Permite que price sea null
  final String? iconUrl;

  const MenuItemCard({
    Key? key,
    required this.alias,
    required this.description,
    this.price, // No es obligatorio que price sea proporcionado
    this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Asigna un valor predeterminado si price es null
    final String priceString = price != null
        ? "\$${price?.toStringAsFixed(2)}"
        : 'Varias Opciones de \$';

    return Card(
      elevation:
          4.0, // Agrega sombra alrededor de la tarjeta para un efecto elevado
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        // Hace la tarjeta interactiva al tocarla
        onTap: () {
          // Acción al tocar la tarjeta
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alias,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ) ??
                          const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontSize: 12,
                              ) ??
                          const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceString,
                      style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: Colors.green, fontSize: 16) ??
                          const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
              if (iconUrl != null) ...[
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    iconUrl!,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(), // No muestra nada si hay un error
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


*/
/*import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  final String alias;
  final String description;
  final double? price; // Permite que price sea null
  final String? iconUrl;

  const MenuItemCard({
    Key? key,
    required this.alias,
    required this.description,
    this.price, // No es obligatorio que price sea proporcionado
    this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Asigna un valor predeterminado si price es null
    final String priceString = price != null
        ? "\$${price?.toStringAsFixed(2)}"
        : 'Varias Opciones de \$';

    return Card(
      elevation:
          4.0, // Agrega sombra alrededor de la tarjeta para un efecto elevado
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        // Hace la tarjeta interactiva al tocarla
        onTap: () {
          // Aquí puedes agregar una acción al tocar la tarjeta
          // Por ejemplo, navegar a una pantalla de detalles del menú
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alias,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontWeight: FontWeight.bold, // Negrita
                              ) ??
                          TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight
                                  .bold), // Proporciona un estilo por defecto si el tema no tiene headline6
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontSize:
                                    14, // Ajusta el tamaño para una mejor legibilidad
                              ) ??
                          TextStyle(
                              fontSize:
                                  14), // Proporciona un estilo por defecto si el tema no tiene bodyText2
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceString,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                color: Colors.green, // Color personalizado
                              ) ??
                          TextStyle(
                              fontSize: 14,
                              color: Colors
                                  .green), // Proporciona un estilo por defecto si el tema no tiene subtitle1
                    ),
                  ],
                ),
              ),
              if (iconUrl != null) ...[
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      8), // Suaviza las esquinas de la imagen
                  child: Image.network(
                    iconUrl!,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons
                        .error), // Muestra un ícono de error si la imagen no carga
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

*/