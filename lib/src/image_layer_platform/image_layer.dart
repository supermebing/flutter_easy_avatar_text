import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  /// 下载SVG图像并保存到应用支持目录。
  ///
  /// 如果不是Web平台，则尝试下载SVG文件并保存到应用支持目录中。
  /// 如果下载的内容不是有效的SVG，则打印一条消息。
  Future<File?> downloadSvg(String url, String fileName) async {
    if (!kIsWeb) {
      final directory = await getApplicationSupportDirectory();
      final filePath = path.join(directory.path, fileName);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String responseBody = String.fromCharCodes(response.bodyBytes);
        if (responseBody.contains('<svg') && responseBody.contains('</svg>')) {
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          return file;
        } else {
          debugPrint("Downloaded content is not SVG.");
        }
      }
    }
    return null;
  }

  /// 获取缓存的SVG图像，如果不存在则下载并缓存。
  ///
  /// 对于Web平台，直接使用网络SVG图像。
  /// 对于非Web平台，检查本地是否已缓存，如果未缓存则下载。
  Future<Widget> getCachedSvg(String url, double size) async {
    if (kIsWeb) {
      return SvgPicture.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else {
      final fileName = Uri.parse(url).pathSegments.last;
      final directory = await getApplicationSupportDirectory();
      final filePath = path.join(directory.path, fileName);
      final file = File(filePath);

      if (await file.exists()) {
        String svgData = await file.readAsString();
        return SvgPicture.string(
          svgData,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      } else {
        final File? downloadedFile = await downloadSvg(url, fileName);
        if (downloadedFile != null) {
          return SvgPicture.file(
            downloadedFile,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        }
        return memoryImage;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 默认图像，当加载失败时显示。
    Widget imageWidget = memoryImage;

    if (image != null) {
      if (Uri.tryParse(image!)?.hasAbsolutePath == true) {
        if (image!.endsWith('svg')) {
          // SVG网络图片。
          imageWidget = FutureBuilder<Widget>(
            future: getCachedSvg(image!, size),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data!;
              } else {
                // 加载中显示进度指示器。
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          imageWidget = CachedNetworkImage(
            imageUrl: image!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            placeholder: (context, url) => memoryImage,
            errorWidget: (context, url, error) => memoryImage,
          );
        }
      }
      // 其他网络图片。
      else {
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
