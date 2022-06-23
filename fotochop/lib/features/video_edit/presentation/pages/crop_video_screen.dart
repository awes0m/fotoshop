//-----------------//
//CROP VIDEO SCREEN//
//-----------------//
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:video_editor/video_editor.dart';

class CropScreen extends StatelessWidget {
  const CropScreen({Key? key, required this.controller}) : super(key: key);

  final VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.left),
                  icon: const Icon(Icons.rotate_left),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      controller.rotate90Degrees(RotateDirection.right),
                  icon: const Icon(Icons.rotate_right),
                ),
              )
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: AnimatedInteractiveViewer(
                maxScale: 2.4,
                child: CropGridViewer(
                    controller: controller, horizontalMargin: 60),
              ),
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Center(
                    child: Text(
                      "CANCEL",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              buildSplashTap("16:9", 16 / 9,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              buildSplashTap("1:1", 1 / 1),
              buildSplashTap("4:5", 4 / 5,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              buildSplashTap("NO", null,
                  padding: const EdgeInsets.only(right: 10)),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    //2 WAYS TO UPDATE CROP
                    //WAY 1:
                    controller.updateCrop();
                    /*WAY 2:
                    controller.minCrop = controller.cacheMinCrop;
                    controller.maxCrop = controller.cacheMaxCrop;
                    */
                    Navigator.pop(context);
                  },
                  icon: const Center(
                    child: Text(
                      "OK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget buildSplashTap(
    String title,
    double? aspectRatio, {
    EdgeInsetsGeometry? padding,
  }) {
    return InkWell(
      onTap: () => controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.aspect_ratio, color: Colors.white),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
