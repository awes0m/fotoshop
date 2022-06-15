import 'package:flutter/material.dart';
import 'package:fotochop/screen/edit_image_screen.dart';
import 'package:fotochop/utils/utils.dart';
import 'package:fotochop/widgets/custom_neu_icon_button.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/colors.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.photo_camera),
            SizedBox(width: 10),
            Text('FotoChop'),
          ],
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: CustomNeuIconButton(
            icon: Icons.file_upload,
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
                          EditImageScreen(selectedImage: file.path))));
                }
                return null;
              });
            }),
      ),
    );
  }
}
