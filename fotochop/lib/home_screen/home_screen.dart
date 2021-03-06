import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fotochop/features/image_edit/presentation/pages/edit_image_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../core/common/colors.dart';
import '../core/common/text_styles.dart';
import '../core/common/utils.dart';
import '../core/widgets/custom_neu_icon_button.dart';
import '../../features/video_edit/presentation/pages/video_editor_screen.dart';
import '../exp/photoexperiment.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: buildDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.photo_camera),
            SizedBox(width: 15),
            Text('FotoChop'),
            SizedBox(width: 10),
            Icon(Icons.play_circle)
          ],
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Photos Section
            Text("Photos", style: AppTextStyle.smallBold(color: Colors.white)),
            Divider(
              indent: ScrnSizer.screenWidth() * 0.4,
              endIndent: ScrnSizer.screenWidth() * 0.4,
              color: Colors.white,
              thickness: 1,
              height: 10,
            ),
            const SizedBox(height: 20),
            // Image from CAMERA
            CustomNeuIconButton(
                icon: Icons.camera_alt,
                backgroundColor: backgroundColor,
                width: ScrnSizer.screenWidth() * 0.5,
                boxRadius: ScrnSizer.screenWidth() * 6,
                onPressed: () async {
                  await ImagePicker()
                      .pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) =>
                              EditImageScreen(selectedImage: file))));
                    }
                    return null;
                  });
                }),
            const SizedBox(height: 20),
            //Image from gallery
            CustomNeuIconButton(
                icon: Icons.image_search,
                toolTip: 'Upload Image',
                backgroundColor: backgroundColor,
                width: ScrnSizer.screenWidth() * 0.5,
                boxRadius: ScrnSizer.screenWidth() * 6,
                onPressed: () async {
                  await ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((file) {
                    if (file != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) =>
                              EditImageScreen(selectedImage: file))));
                    }
                    return null;
                  });
                }),
            const SizedBox(height: 40),
            // Videos Section
            Text('Videos', style: AppTextStyle.smallBold(color: Colors.white)),
            Divider(
              indent: ScrnSizer.screenWidth() * 0.4,
              endIndent: ScrnSizer.screenWidth() * 0.4,
              color: Colors.white,
              thickness: 1,
              height: 10,
            ),
            const SizedBox(height: 20),
            //Recird Video Button
            CustomNeuIconButton(
              icon: Icons.videocam,
              backgroundColor: backgroundColor,
              toolTip: 'Record a video',
              width: ScrnSizer.screenWidth() * 0.5,
              boxRadius: ScrnSizer.screenWidth() * 6,
              onPressed: () async {
                final XFile? file =
                    await ImagePicker().pickVideo(source: ImageSource.camera);
                if (mounted && file != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              VideoEditor(file: File(file.path))));
                }
              },
            ),
            const SizedBox(height: 20),
            //Pick video file
            CustomNeuIconButton(
                icon: Icons.video_file,
                toolTip: 'Choose a video',
                backgroundColor: backgroundColor,
                width: ScrnSizer.screenWidth() * 0.5,
                boxRadius: ScrnSizer.screenWidth() * 6,
                onPressed: () async {
                  final XFile? file = await ImagePicker()
                      .pickVideo(source: ImageSource.gallery);
                  if (mounted && file != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                VideoEditor(file: File(file.path))));
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Text('FotoChop'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Experiments'),
            onTap: () {
              Navigator.pushNamed(context, CommonUseCasesExamples.routeName);
            },
          ),
        ],
      ),
    );
  }
}
