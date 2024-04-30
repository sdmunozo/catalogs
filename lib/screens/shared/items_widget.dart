import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:tuple/tuple.dart';

class MenuItemCard extends StatelessWidget {
  final String cardType;
  final Item item;
  final VoidCallback onTap;
  final int maxWidgetsToShow = 5;
  //final int maxLimit = 50;
  //final int minLimit = 25;

  final int maxLimit = 200;
  final int minLimit = 25;
  final TextStyle priceStyle = TextStyle(
    color: Colors.green,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );

  MenuItemCard({
    Key? key,
    required this.cardType,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxWidth =
        MediaQuery.of(context).size.width - 40; // Asumiendo algunos márgenes

    final bool shouldShowPrice =
        item.price.isNotEmpty && item.price != '0' && item.price != '0.00';

    List<Widget> contentWidgets = [
      Text(item.alias,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ];
    int widgetsCount = 1;

    Tuple2<Widget, bool> buildTextWithLimit(
        String description, String price, bool isPrice) {
      bool usesTwoLines = description.length >= minLimit;
      String fullText = isPrice ? '\$$price - $description' : description;
      String adjustedText = fullText.length > maxLimit
          ? '${fullText.substring(0, maxLimit)}...'
          : fullText;
      if (isPrice) {
        int dashPosition = adjustedText.indexOf(' - ');
        return Tuple2(
            RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: adjustedText.substring(0, dashPosition + 1),
                    style: priceStyle,
                  ),
                  TextSpan(
                      text: adjustedText.substring(dashPosition + 1),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            usesTwoLines);
      } else {
        return Tuple2(
            Text(adjustedText,
                style: TextStyle(color: Colors.black),
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            usesTwoLines);
      }
    }

    if (shouldShowPrice || item.description.isNotEmpty) {
      String realDescription = item.description;
      bool descriptionRequiresTwoLines = realDescription.length >= minLimit;
      bool combinedTextRequiresTwoLines = (shouldShowPrice &&
          (item.price.length + realDescription.length >= minLimit));
      bool usesTwoLines =
          descriptionRequiresTwoLines || combinedTextRequiresTwoLines;

      Tuple2<Widget, bool> descriptionAndPriceResult =
          buildTextWithLimit(realDescription, item.price, shouldShowPrice);
      Widget descriptionAndPriceWidget = descriptionAndPriceResult.item1;
      widgetsCount += usesTwoLines ? 2 : 1;
      contentWidgets.add(descriptionAndPriceWidget);
    }

    if (contentWidgets.length == maxWidgetsToShow - 1) {
      contentWidgets.add(
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 100,
                child: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              Text(
                "Ver más",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      );
    } else {
      List<Widget> modifierWidgets = buildModifiersWidgets();
      if ((contentWidgets.length + modifierWidgets.length) <=
          maxWidgetsToShow - 1) {
        contentWidgets.addAll(modifierWidgets);
      } else {
        List<Widget> modifierWidgets = buildModifiersWidgets();
        if ((contentWidgets.length + modifierWidgets.length) <=
            maxWidgetsToShow - 1) {
          contentWidgets.addAll(modifierWidgets);
        } else {
          int remainingSpace = maxWidgetsToShow - 1 - contentWidgets.length;
          contentWidgets.addAll(modifierWidgets.take(remainingSpace));
          contentWidgets.add(
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                  Text(
                    "Ver más",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 15,
                  ),
                  // icono aqui
                ],
              ),
            ),
          );
        }
      }
    }

    String formatTextWithHyphens(String text, int maxLineLength) {
      RegExp wordPattern = RegExp(r'\w+');
      List<String> words =
          wordPattern.allMatches(text).map((m) => m.group(0)!).toList();
      StringBuffer formattedText = StringBuffer();
      String currentLine = '';

      for (var word in words) {
        if (currentLine.length + word.length + 1 > maxLineLength) {
          if (currentLine.length + word.length == maxLineLength) {
            // La palabra cabe exactamente al final de la línea sin necesidad de guion.
            formattedText.write(currentLine + word);
          } else {
            // No cabe, se necesita un guion.
            formattedText.write(currentLine + '-\n');
            word = word + ' ';
          }
          currentLine = word;
        } else {
          currentLine += word + ' ';
        }
      }
      formattedText.write(currentLine.trimRight()); // Agrega lo que queda.
      return formattedText.toString();
    }

    String buildModifiersString() {
      List<String> modifiersList = [];

      for (var group in item.modifiersGroups) {
        for (var modifier in group.modifiers) {
          final bool shouldShowModifierPrice = group.isSelectable != 'True' &&
              modifier.price.isNotEmpty &&
              modifier.price != '0' &&
              modifier.price != '0.00';

          String priceText = shouldShowModifierPrice
              ? ' - \$${double.parse(modifier.price).toStringAsFixed(2)}'
              : '';

          String modifierText = '${modifier.alias}$priceText';
          modifiersList.add(modifierText);
        }
      }

      String modifiersString = modifiersList.join(', ');
      return modifiersString;
    }

    String modifiersString = buildModifiersString();
    //print(modifiersString);

    return Card(
      color: Colors.white.withOpacity(0.85),
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contentWidgets,
                ),
              ),
              if (item.icon != null && item.icon.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.icon,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 0, height: 0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildModifiersWidgets() {
    List<Widget> widgetsList = [];

    for (var group in item.modifiersGroups) {
      List<Widget> modifierWidgets = [];
      for (var modifier in group.modifiers) {
        final bool shouldShowModifierPrice = group.isSelectable != 'True' &&
            modifier.price.isNotEmpty &&
            modifier.price != '0' &&
            modifier.price != '0.00';
        String priceText = shouldShowModifierPrice
            ? ' - \$${double.parse(modifier.price).toStringAsFixed(2)}'
            : '';
        Widget modifierTextWidget = Row(
          children: [
            Text('• ${modifier.alias}'),
            if (shouldShowModifierPrice) buildPriceText(priceText, true),
          ],
        );
        modifierWidgets.add(modifierTextWidget);
      }

      if (modifierWidgets.isNotEmpty) {
        widgetsList.add(Text(group.alias,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)));
        widgetsList.addAll(modifierWidgets);
      }
    }
    return widgetsList;
  }

  Widget buildPriceText(String text, bool isPrice) {
    return Text(text, style: isPrice ? priceStyle : null);
  }
}

/*import 'package:flutter/material.dart';
import 'package:menu/models/branch_catalog_response.dart';
import 'package:tuple/tuple.dart';

class MenuItemCard extends StatelessWidget {
  final String cardType;
  final Item item;
  final VoidCallback onTap;
  final int maxWidgetsToShow = 5;
  final int maxLimit = 50;
  final int minLimit = 25;
  final TextStyle priceStyle = TextStyle(
    color: Colors.green,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );

  MenuItemCard({
    Key? key,
    required this.cardType,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldShowPrice =
        item.price.isNotEmpty && item.price != '0' && item.price != '0.00';

    List<Widget> contentWidgets = [
      Text(item.alias,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ];
    int widgetsCount = 1;

    Tuple2<Widget, bool> buildTextWithLimit(
        String description, String price, bool isPrice) {
      bool usesTwoLines = description.length >= minLimit;
      String fullText = isPrice ? '\$$price - $description' : description;
      String adjustedText = fullText.length > maxLimit
          ? '${fullText.substring(0, maxLimit)}...'
          : fullText;
      if (isPrice) {
        int dashPosition = adjustedText.indexOf(' - ');
        return Tuple2(
            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: adjustedText.substring(0, dashPosition + 1),
                      style: TextStyle(color: Colors.green)),
                  TextSpan(
                      text: adjustedText.substring(dashPosition + 1),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            usesTwoLines);
      } else {
        return Tuple2(
            Text(adjustedText,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            usesTwoLines);
      }
    }

    if (shouldShowPrice || item.description.isNotEmpty) {
      String realDescription = item.description;
      bool descriptionRequiresTwoLines = realDescription.length >= minLimit;
      bool combinedTextRequiresTwoLines = (shouldShowPrice &&
          (item.price.length + realDescription.length >= minLimit));
      bool usesTwoLines =
          descriptionRequiresTwoLines || combinedTextRequiresTwoLines;

      Tuple2<Widget, bool> descriptionAndPriceResult =
          buildTextWithLimit(realDescription, item.price, shouldShowPrice);
      Widget descriptionAndPriceWidget = descriptionAndPriceResult.item1;
      widgetsCount += usesTwoLines ? 2 : 1;
      contentWidgets.add(descriptionAndPriceWidget);
    }

    if (contentWidgets.length == maxWidgetsToShow - 1) {
      contentWidgets.add(
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ver más",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 20,
                ),
                // icono aqui
              ],
            ),
          ),
        ),
      );
    } else {
      List<Widget> modifierWidgets = buildModifiersWidgets();
      if ((contentWidgets.length + modifierWidgets.length) <=
          maxWidgetsToShow - 1) {
        contentWidgets.addAll(modifierWidgets);
      } else {
        int remainingSpace = maxWidgetsToShow - 1 - contentWidgets.length;
        contentWidgets.addAll(modifierWidgets.take(remainingSpace));
        contentWidgets.add(
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ver más",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                    size: 15,
                  ),
                  // icono aqui
                ],
              ),
            ),
          ),
        );
      }
    }

    String buildModifiersString() {
      List<String> modifiersList = [];

      for (var group in item.modifiersGroups) {
        for (var modifier in group.modifiers) {
          final bool shouldShowModifierPrice = group.isSelectable != 'True' &&
              modifier.price.isNotEmpty &&
              modifier.price != '0' &&
              modifier.price != '0.00';

          String priceText = shouldShowModifierPrice
              ? ' - \$${double.parse(modifier.price).toStringAsFixed(2)}'
              : '';

          String modifierText = '${modifier.alias}$priceText';
          modifiersList.add(modifierText);
        }
      }

      String modifiersString = modifiersList.join(', ');
      return modifiersString;
    }

    String modifiersString = buildModifiersString();
    print(modifiersString);

    return Card(
      color: Colors.white.withOpacity(0.85),
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contentWidgets,
                ),
              ),
              if (item.icon != null && item.icon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ClipRRect(
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
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildModifiersWidgets() {
    List<Widget> widgetsList = [];

    for (var group in item.modifiersGroups) {
      List<Widget> modifierWidgets = [];
      for (var modifier in group.modifiers) {
        final bool shouldShowModifierPrice = group.isSelectable != 'True' &&
            modifier.price.isNotEmpty &&
            modifier.price != '0' &&
            modifier.price != '0.00';
        String priceText = shouldShowModifierPrice
            ? ' - \$${double.parse(modifier.price).toStringAsFixed(2)}'
            : '';
        Widget modifierTextWidget = Row(
          children: [
            Text('• ${modifier.alias}'),
            if (shouldShowModifierPrice) buildPriceText(priceText, true),
          ],
        );
        modifierWidgets.add(modifierTextWidget);
      }

      if (modifierWidgets.isNotEmpty) {
        widgetsList.add(Text(group.alias,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)));
        widgetsList.addAll(modifierWidgets);
      }
    }
    return widgetsList;
  }

  Widget buildPriceText(String text, bool isPrice) {
    return Text(text, style: isPrice ? priceStyle : null);
  }
}
*/