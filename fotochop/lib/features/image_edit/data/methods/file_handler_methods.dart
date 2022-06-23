import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileHandlerMethods {
  const FileHandlerMethods();

  Future<XFile?> pickGaleryImage(
      BuildContext context, VoidCallback onSuccess) async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    onSuccess.call();
    return file;
  }
}
