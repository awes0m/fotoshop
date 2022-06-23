import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/common/utils.dart';

class SelectedImageWidget extends StatelessWidget {
  const SelectedImageWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) => Center(
          child: Container(
        constraints: BoxConstraints(
          maxWidth: ScrnSizer.screenWidth() * 0.85,
          maxHeight: ScrnSizer.screenHeight() * 0.85,
        ),
        child: ClipRRect(
            child: kIsWeb
                ? CommonExampleRouteWrapper(
                    imageProvider: NetworkImage(imagePath),
                    backgroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.grey[100]!],
                        stops: const [0.1, 1.0],
                      ),
                    )
                    // ? PhotoView(
                    //     imageProvider: NetworkImage(imagePath),
                    //     maxScale: PhotoViewComputedScale.covered * 2.0,
                    //     minScale: PhotoViewComputedScale.contained * 0.8,
                    //     initialScale: PhotoViewComputedScale.covered,
                    //   )
                    // : PhotoView(
                    //     imageProvider: FileImage(
                    //       File(imagePath),
                    //     ),
                    //     maxScale: PhotoViewComputedScale.covered * 2.0,
                    //     minScale: PhotoViewComputedScale.contained * 0.8,
                    //     initialScale: PhotoViewComputedScale.covered,
                    //   ),
                    )
                : CommonExampleRouteWrapper(
                    imageProvider: FileImage(File(imagePath)),
                    backgroundDecoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.grey],
                        stops: [0.1, 1.0],
                      ),
                    ))),
      ));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
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
