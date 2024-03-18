import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data.dart';

class ImagerLayer extends StatelessWidget {
  /// 图像的尺寸。
  final double size;

  /// 图像的内边距。
  final EdgeInsetsGeometry padding;
  final String? image;

  /// 图像的URL或资源路径。
  final double borderRadius;

  /// 从文件系统加载的图像。
  final File? fileImage;

  const ImagerLayer({
    super.key,
    required this.size,
    required this.padding,
    required this.image,
    required this.borderRadius,
    this.fileImage,
  });

  @override
  Widget build(BuildContext context) {
    // 默认图像，当加载失败时显示。
    Widget imageWidget = memoryImage;

    if (image != null) {
      if (Uri.tryParse(image!)?.hasAbsolutePath == true) {
        if (image!.endsWith('svg')) {
          // SVG网络图片。
          imageWidget = SvgPicture.network(
            image!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        } else {
          // 其他网络图片。
          imageWidget = CachedNetworkImage(
            imageUrl: image!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            placeholder: (context, url) => memoryImage,
            errorWidget: (context, url, error) => memoryImage,
          );
        }
      } else {
        // 本地资源图片。
        if (image!.endsWith('svg')) {
          imageWidget = SvgPicture.asset(
            image!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        } else {
          imageWidget = Image.asset(
            image!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (context, error, stackTrace) => memoryImage,
          );
        }
      }
    } else if (fileImage != null) {
      // 从文件系统加载的图像。
      imageWidget = Image.file(
        fileImage!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: size,
              height: size,
              margin: padding,
              child: imageWidget,
            ),
          ),
        ),
      ),
    );
  }
}
