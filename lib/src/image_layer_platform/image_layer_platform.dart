import 'package:flutter/material.dart';

import 'image_layer_web.dart'
    if (dart.library.io) 'image_layer.dart' show ImagerLayer
    // ignore: unused_shown_name
    if (dart.library.html) 'image_layer_web.dart' show ImagerLayer;


Widget getImageLayerWidget(size,padding,image,borderRadius,fileImage) {
  return ImagerLayer(
      size: size,
      padding: padding,
      image: image,
      borderRadius: borderRadius,
      fileImage: fileImage,
    );
}

