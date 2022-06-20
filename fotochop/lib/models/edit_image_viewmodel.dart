import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:fotochop/models/text_info.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../screen/edit_image_screen.dart';
import '../utils/utils.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  final List<String> _myGoogleFonts = [
    "Abril Fatface",
    "Aclonica",
    "Alegreya Sans",
    "Architects Daughter",
    "Archivo",
    "Archivo Narrow",
    "Bebas Neue",
    "Bitter",
    "Bree Serif",
    "Bungee",
    "Cabin",
    "Cairo",
    "Coda",
    "Comfortaa",
    "Comic Neue",
    "Cousine",
    "Croissant One",
    "Faster One",
    "Forum",
    "Great Vibes",
    "Heebo",
    "Inconsolata",
    "Josefin Slab",
    "Lato",
    "Libre Baskerville",
    "Lobster",
    "Lora",
    "Merriweather",
    "Montserrat",
    "Mukta",
    "Nunito",
    "Offside",
    "Open Sans",
    "Oswald",
    "Overlock",
    "Pacifico",
    "Playfair Display",
    "Poppins",
    "Raleway",
    "Roboto",
    "Roboto Mono",
    "Source Sans Pro",
    "Space Mono",
    "Spicy Rice",
    "Squada One",
    "Sue Ellen Francisco",
    "Trade Winds",
    "Ubuntu",
    "Varela",
    "Vollkorn",
    "Work Sans",
    "Zilla Slab"
  ];
  Color pickerColor = Colors.white;
  String? selectedFont;
  TextStyle? selectedFontTextStyle;
  List<TextInfo> texts = [];
  int currentIndex = 0;

  /// Save the image from memory to the gallery
  saveToGallery(BuildContext context) {
    if (texts.isNotEmpty) {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        showSnackBar(context, "Image saved to gallery");
      }).catchError((e) {
        showSnackBar(context, e.toString());
      });
    }
  }

  /// Takes image Screenshot and saves it to memory
  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "MugShot_$time.png";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  /// deletes the text from the list
  removeText(context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    showSnackBar(context, 'Text removed');
  }

  /// Applies the color changes to the text
  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      changeTextColor(color);
    });
  }

  /// builds a Material color Picker
  void buildColorPicker() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MaterialPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                enableLabel: true, // only on portrait mode
              ),
              // BlockPicker(
              //   pickerColor: pickerColor,
              //   onColorChanged: changeColor,
              // ),
              // ColorPicker(
              //   pickerColor: pickerColor,
              //   onColorChanged: changeColor,
              // ),
            )));
  }

  /// Builds a  Google fonts picker
  void buildFontPicker() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: FontPicker(
                    showInDialog: true,
                    initialFontFamily: 'Anton',
                    onFontChanged: (font) {
                      setState(() {
                        selectedFont = font.fontFamily;
                        selectedFontTextStyle = font.toTextStyle();
                        changeTextFont(selectedFont!);
                      });
                      debugPrint(
                          "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}");
                    },
                    googleFonts: _myGoogleFonts),
              ),
            )));

    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Expanded(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Pick a font: ',
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.w700)),
          )),
          Expanded(
            child: TextField(
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                  hintText: selectedFont != null
                      ? selectedFont.toString()
                      : 'Select a font'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FontPicker(
                          onFontChanged: (font) {
                            setState(() {
                              selectedFont = font.fontFamily;
                              selectedFontTextStyle = font.toTextStyle();
                            });
                            debugPrint(
                                "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}");
                          },
                          googleFonts: _myGoogleFonts)),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 2.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text('Font: $selectedFont',
                            style: selectedFontTextStyle),
                        Text('The quick brown fox jumped',
                            style: selectedFontTextStyle),
                        Text('over the lazy dog', style: selectedFontTextStyle),
                      ])),
                ),
              ),
            ),
          )
        ]);
  }

  /// Finds the current index of the selected text in the list
  setCurrentIndex(BuildContext context, int index) {
    setState(() {
      currentIndex = index;
    });
    showSnackBar(context, 'Selected for styling');
  }

  /// Changes the text color in the list [texts]
  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  /// Changes the text font in the list [texts]
  changeTextFont(String font) {
    setState(() {
      texts[currentIndex].fontFamily = font;
    });
  }

  /// Changes the text font size in the list [texts]
  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  /// Changes the text font size in the list [texts]
  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  /// Changes to [Alingment.Left]in the list [texts]
  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  /// Changes to [Alingment.Right]in the list [texts]
  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  /// Changes to [Alingment.Center]in the list [texts]
  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  /// Toggles between [FontWeight.bold] and [FontWeight.normal] in the list [texts]
  boldText() {
    if (texts[currentIndex].fontWeight == FontWeight.bold) {
      setState(() {
        texts[currentIndex].fontWeight = FontWeight.normal;
      });
    } else {
      setState(() {
        texts[currentIndex].fontWeight = FontWeight.bold;
      });
    }
  }

  /// Toggles between [FontStyle.italic] and [FontStyle.normal] in the list [texts]
  italicText() {
    if (texts[currentIndex].fontStyle == FontStyle.italic) {
      setState(() {
        texts[currentIndex].fontStyle = FontStyle.normal;
      });
    } else {
      setState(() {
        texts[currentIndex].fontStyle = FontStyle.italic;
      });
    }
  }

  /// Changes all spaces to nextline
  columnizeText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  /// Adds a new text to the list [texts]
  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(
        text: textEditingController.text,
        left: ScrnSizer.screenWidth() / 2,
        top: ScrnSizer.screenHeight() / 2,
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontSize: 40,
        textAlign: TextAlign.left,
        fontFamily: 'Roboto',
      ));
      Navigator.of(context).pop();
    });
  }

  /// builds a [showDialog] to add a new text
  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new text'),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your text here',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () => addNewText(context),
          ),
        ],
      ),
    );
  }

  // editText(BuildContext context) {
  //   setState(() {
  //     texts[currentIndex].text = textEditingController.text;
  //   });
  //   Navigator.of(context).pop();
  // }

  // editDialog(BuildContext context, String oldText) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Add new text'),
  //       content: TextFormField(
  //         initialValue: oldText,
  //         controller: textEditingController,
  //         maxLines: 5,
  //         decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           // labelText: 'Your text here',
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('Back'),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //         TextButton(
  //           onPressed: () => editText(context),
  //           child: const Text('Edit'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
