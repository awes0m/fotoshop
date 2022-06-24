import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/common/utils.dart';

class ImageCanvasWidget extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  const ImageCanvasWidget({
    Key? key,
    required this.imagePath,
    this.maxWidth = 400,
    this.maxHeight = 400,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) => Center(
    child: ClipRRect(
          child: kIsWeb
              ? CommonExampleRouteWrapper(
                  maxHeight: maxHeight,
                  maxWidth: maxWidth,
                  imageProvider: NetworkImage(imagePath),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                )
              : CommonExampleRouteWrapper(
                  maxHeight: maxHeight,
                  maxWidth: maxWidth,
                  imageProvider: FileImage(File(imagePath)),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.white,
                  )),
        ),
  );
}

class CommonExampleRouteWrapper extends StatelessWidget {
  const CommonExampleRouteWrapper({
    Key? key,
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.basePosition = Alignment.center,
    this.filterQuality = FilterQuality.none,
    this.disableGestures,
    this.errorBuilder,
    required this.maxHeight,
    required this.maxWidth,
  }) : super(key: key);

  final ImageProvider? imageProvider;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment basePosition;
  final FilterQuality filterQuality;
  final bool? disableGestures;
  final ImageErrorWidgetBuilder? errorBuilder;

  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: maxHeight,
        width: maxWidth,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        loadingBuilder: loadingBuilder,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        initialScale: initialScale,
        basePosition: basePosition,
        filterQuality: filterQuality,
        disableGestures: disableGestures,
        errorBuilder: errorBuilder,
      ),
    );
  }
}
