import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String placeholderImage;
  final BoxFit fit;
  final double opacity;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl,
    this.placeholderImage = 'images/bg.png',
    this.fit = BoxFit.cover,
    this.opacity = 0.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Image.asset(
          placeholderImage,
          fit: fit,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Opacity(
          opacity: opacity,
          child: Image.asset(
            placeholderImage,
            fit: fit,
          ),
        );
      },
    );
  }
}
