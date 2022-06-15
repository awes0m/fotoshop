import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const bool kIsWeb = identical(0, 0.0);

/// This class is used to get the screen height and width
/// Functions- screenHeight() and screenWidth()
class ScrnSizer {
  /// return the current available screen height
  static double screenWidth() =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;

  /// return the current available screen width
  static double screenHeight() =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
}

/// This function is used to show a snackbar with a message
/// Parameters- [context], [message]
showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 8,
      content: Text(message),
      duration: const Duration(seconds: 5),
    ),
  );
}

///This function is used to validate the email string
///Parameters- [email] String
bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

Future <bool> requestPermission(Permission permission)async{
  var status = await permission.isGranted;
  if(status){
    return true;
  }
  else{
    var status = await permission.request();
    if(status.isGranted){
      return true;
    }
    else{
      return false;
    }
  }
}