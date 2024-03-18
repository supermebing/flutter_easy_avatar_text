import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BackgroundLayer extends StatelessWidget {
  final double size;
  final String? backgroundImage;
  final Color backgroundColor;
  final double borderRadius;

  const BackgroundLayer({
    super.key,
    required this.size,
    this.backgroundImage,
    required this.backgroundColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: backgroundImage != null
          // 如果指定了背景图片，则使用背景图片
          ? SizedBox(
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: CachedNetworkImage(
                  imageUrl: backgroundImage!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
            )
          // 未指定背景图时，采用纯色默认背景图
          : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: backgroundColor,
              ),
            ),
    );
  }
}
