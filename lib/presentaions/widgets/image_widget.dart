import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.radius = 16,
    this.width,
    this.height,
  });

  final String url;
  final BoxFit fit;
  final double radius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _buildContainer(context, icon: Icons.image_rounded);
        },
        errorBuilder: (_, __, ___) {
          return _buildContainer(context, icon: Icons.broken_image_rounded);
        },
      ),
    );
  }

  Container _buildContainer(BuildContext context, {required IconData icon}) {
    final highlightColor = Theme.of(context).highlightColor;
    final disabledColor = Theme.of(context).disabledColor;
    return Container(
      width: width,
      height: height,
      color: highlightColor,
      child: Center(child: Icon(icon, color: disabledColor)),
    );
  }
}