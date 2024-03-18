import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'background_layer.dart';

import 'text_layer.dart';
import './image_layer_platform/image_layer_platform.dart';

/// A widget that displays an avatar with various customization options.
///
/// This widget allows you to display avatars with custom dimensions, border
/// radius, background color, and an optional background image. You can specify
/// both network and local images for the avatar, as well as text avatars with
/// various styling options.
///
class Avatar extends StatelessWidget {
  /// The size of the avatar.
  /// 头像的大小。
  final double size;

  /// The border radius of the avatar.
  /// 头像的边框半径。
  final double borderRadius;

  /// The URL for the background image of the avatar.
  /// 头像的背景图像的URL。
  final String? backgroundImage;

  /// The background color of the avatar.
  /// 头像的背景颜色。
  final Color? backgroundColor;

  /// The image for the avatar. This can be a network image, a local asset, or byte data.
  /// 头像的图像（可以是网络图片、本地资源或字节数据）。
  final String? image;

  /// A file image for the avatar, allowing for images stored on the device to be used.
  /// 设备上存储的图像文件，允许使用设备上的图像。
  final File? fileImage;

  /// The text to display if using a text avatar.
  /// 如果使用文字头像，要显示的文本。
  final String text;

  /// Whether to use the text avatar mode. Defaults to false.
  /// 是否启用文本头像模式，默认为 false。
  final bool textMode;

  /// Whether to convert the text to upper case. Defaults to false.
  /// 是否将文本转换为大写，默认为 false。
  final bool upperCase;

  /// The number of words to use from the text for the avatar. Useful for initials.
  /// 从文本中使用的单词数量，用于头像的首字母缩写。
  final int? wordsCount;

  /// The margin around the avatar.
  /// 头像周围的边距。
  final EdgeInsetsGeometry margin;

  /// The padding inside the avatar.
  /// 头像内部的填充。
  final EdgeInsetsGeometry padding;

  /// An optional border to apply between the background and the avatar content.
  /// 可选的边框，应用于背景和头像内容之间。
  final Border? interlayerBorder;

  /// An optional outer border for the avatar.
  /// 头像的可选外边框。
  final Border? border;

  const Avatar({
    super.key,
    this.size = 100,
    this.borderRadius = 50,
    this.backgroundImage,
    this.backgroundColor,
    this.image = '',
    this.text = '?',
    this.margin = EdgeInsets.zero, // 默认内边距为0
    this.padding = EdgeInsets.zero, // 默认内边距为0
    this.interlayerBorder,
    this.border,
    this.textMode = false,
    this.upperCase = false,
    this.wordsCount,
    this.fileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size,
      height: size,
      child: Stack(
        children: [
          // 1. Background Layer
          // 1. 背景层
          BackgroundLayer(
            size: size,
            backgroundColor: _getBgColor(),
            borderRadius: borderRadius,
            backgroundImage: backgroundImage,
          ),

          // 2. 中间层
          // 2. interlayer
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // 透明背景
                    border: interlayerBorder, // 中间层边框
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          ),

          // 3.1 Image Layer
          // 3.1 图像层
          // 3.2 Text Layer
          // 3.2 文字层
          textMode
              ? TextLayer(
                  size: size,
                  padding: padding,
                  text: _getDisplayStr(),
                  borderRadius: borderRadius,
                )
              // : kIsWeb
              //     ? ImagerLayer(
              //         size: size,
              //         padding: padding,
              //         image: image,
              //         borderRadius: borderRadius,
              //         fileImage: fileImage,
              //       )
              //     : ImagerLayer(
              //         size: size,
              //         padding: padding,
              //         image: image,
              //         borderRadius: borderRadius,
              //         fileImage: fileImage,
              //       ),
              : getImageLayerWidget(
                  size,
                  padding,
                  image,
                  borderRadius,
                  fileImage,
                ),

          // 4. 边框层
          // 4. border layer
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // 透明背景
                    border: border, // 边框
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 获取需要显示的字符串
  String _getDisplayStr() {
    String str = String.fromCharCodes(
      text.runes.toList(),
    );

    str = upperCase ? str.toUpperCase() : str;
    List<String> charList = str.trim().split(' ');

    // 如果charList的长度大于 1 且等于 wordsCount
    if (charList.length > 1 && charList.length == wordsCount) {
      // 返回charList的第一个和第二个元素的首字母
      return '${charList[0][0].trim()}${charList[1][0].trim()}';
    }
    debugPrint('AvatarText ====== ${str[0]}');
    // 否则，返回newText的首字母
    return str[0];
  }

  // 配置背景颜色
  Color _getBgColor() {
    if (backgroundColor != null) {
      return backgroundColor!;
    } else if (textMode &&
        RegExp(r'[A-Z]|').hasMatch(
          _getDisplayStr(),
        )) {
      var colorKey = _getDisplayStr()[0].toLowerCase().toString();
      var colorMap = {
        "a": const Color.fromARGB(255, 255, 110, 94),
        "b": const Color.fromARGB(255, 255, 108, 157),
        "c": const Color.fromARGB(255, 236, 128, 255),
        "d": const Color.fromARGB(255, 180, 134, 255),
        "e": const Color.fromARGB(255, 144, 159, 255),
        "f": const Color.fromARGB(255, 95, 153, 255),
        "g": const Color.fromARGB(255, 74, 198, 255),
        "h": const Color.fromARGB(255, 77, 234, 255),
        "i": const Color.fromARGB(255, 60, 255, 235),
        "j": const Color.fromARGB(255, 255, 189, 67),
        "k": const Color.fromARGB(255, 191, 255, 118),
        "l": const Color.fromARGB(255, 97, 69, 224),
        "m": const Color.fromARGB(255, 255, 225, 57),
        "n": const Color.fromARGB(255, 219, 178, 27),
        "o": const Color.fromARGB(255, 243, 164, 7),
        "p": const Color.fromARGB(255, 255, 132, 87),
        "q": const Color.fromARGB(255, 204, 204, 204),
        "r": const Color.fromARGB(255, 169, 194, 207),
        "s": const Color.fromARGB(255, 161, 106, 83),
        "t": const Color.fromARGB(255, 156, 156, 156),
        "u": const Color.fromARGB(255, 169, 175, 224),
        "v": const Color.fromARGB(255, 198, 164, 255),
        "w": const Color.fromARGB(255, 214, 214, 214),
        "x": const Color.fromARGB(255, 132, 241, 255),
        "y": const Color.fromARGB(255, 216, 169, 153),
        "z": const Color.fromARGB(255, 130, 231, 99),
      };

      return colorMap.containsKey(colorKey)
          ? colorMap[colorKey]!
          : const Color.fromARGB(255, 82, 82, 82);
    }
    return const Color.fromARGB(255, 82, 82, 82);
  }
}
