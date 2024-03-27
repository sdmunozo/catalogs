import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackAsset;

  const BackgroundImage(
      {Key? key, required this.imageUrl, required this.fallbackAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return FallbackAssetImage(fallbackAsset: fallbackAsset);
      },
      errorBuilder: (context, error, stackTrace) {
        return FallbackAssetImage(fallbackAsset: fallbackAsset);
      },
    );
  }
}

class FallbackAssetImage extends StatelessWidget {
  final String fallbackAsset;

  const FallbackAssetImage({Key? key, required this.fallbackAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(fallbackAsset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
