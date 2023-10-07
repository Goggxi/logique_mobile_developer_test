import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.radius = 10,
    this.width,
    this.height,
    this.widthLoading,
    this.heightLoading,
  });

  final String url;
  final BoxFit fit;
  final double radius;
  final double? width;
  final double? height;
  final double? widthLoading;
  final double? heightLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        cacheKey: url,
        placeholder: (_, __) {
          return _buildContainer(context, icon: Icons.image_rounded);
        },
        errorWidget: (_, __, ___) {
          return _buildContainer(context, icon: Icons.broken_image_rounded);
        },
      ),
    );
  }

  Container _buildContainer(BuildContext context, {required IconData icon}) {
    final highlightColor = Theme.of(context).highlightColor;
    final disabledColor = Theme.of(context).disabledColor;
    return Container(
      width: widthLoading ?? width,
      height: heightLoading ?? height,
      color: highlightColor,
      child: Center(child: Icon(icon, color: disabledColor)),
    );
  }
}
