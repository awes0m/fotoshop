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

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "MugShot_$time.png";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  removeText(context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    showSnackBar(context, 'Text removed');
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      changeTextColor(color);
    });
  }

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

  setCurrentIndex(BuildContext context, int index) {
    setState(() {
      currentIndex = index;
    });
    showSnackBar(context, 'Selected for styling');
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  changeTextFont(String font) {
    setState(() {
      texts[currentIndex].fontFamily = font;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

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

  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(
        text: textEditingController.text,
        left: 0,
        top: 0,
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
}
