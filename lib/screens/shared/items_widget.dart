import 'package:flutter/material.dart';
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
