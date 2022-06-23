import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fotochop/models/edit_image_viewmodel.dart';
import 'package:fotochop/utils/colors.dart';
import 'package:fotochop/utils/text_styles.dart';
import 'package:fotochop/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/image_text.dart';

class EditImageScreen extends StatefulWidget {
  static const routeName = '/edit_image';
  final XFile selectedImage;
  const EditImageScreen({Key? key, required this.selectedImage})
      : super(key: key);

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      endDrawer: buildEndDrawer(),
      appBar: _appBar,
      floatingActionButton: _addnewTextFab,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: ScrnSizer.screenHeight() * 0.8,
            child: Stack(children: [
              _selectedImage,
              for (int i = 0; i < texts.length; i++)
                Positioned(
                  left: texts[i].left,
                  top: texts[i].top,
                  child: GestureDetector(
                    // onDoubleTap: editDialog(context, texts[i].text),
                    onLongPress: () => removeText(context),
                    onTap: () => setCurrentIndex(context, i),
                    child: Draggable(
                      feedback: ImageText(textInfo: texts[i]),
                      child: ImageText(textInfo: texts[i]),
                      onDragEnd: (drag) {
                        final renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset off = renderBox.globalToLocal(drag.offset);
                        setState(() {
                          texts[i].left = off.dx;
                          texts[i].top = off.dy - 96;
                        });
                      },
                    ),
                  ),
                ),
              creatorText.text.isNotEmpty
                  ? Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        creatorText.text,
                        style: AppTextStyle.mediumBold(color: Colors.black45),
                      ),
                    )
                  : const SizedBox.shrink(),
              creatorText.text.isNotEmpty
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: DragTarget(
                          builder: (context, candidateData, rejectedData) {
                        removeText(context);
                        return Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                            )),
                            width: double.infinity,
                            height: 300,
                            child: const Text('Delete'));
                      }),
                    )
                  : const SizedBox.shrink(),
            ]),
          ),
        ),
      ),
    );
  }

// Widgets // //////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget get _selectedImage => Center(
      child: kIsWeb
          ? PhotoView(
              imageProvider: NetworkImage(widget.selectedImage.path),
            )
          : PhotoView(
              imageProvider: FileImage(File(widget.selectedImage.path)),
            ));
  Widget get _addnewTextFab => FloatingActionButton(
        elevation: 70,
        shape: ShapeBorder.lerp(
          BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          0.5,
        ),
        backgroundColor: backgroundColor,
        tooltip: 'Add new text',
        onPressed: () => addNewDialog(context),
        child: const Icon(Icons.edit_note),
      );

  AppBar get _appBar => AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: SizedBox(
        height: 50,
        child: Text('FotoChop', style: AppTextStyle.mediumBold()),
      ));

  Widget buildEndDrawer() {
    return Drawer(
      backgroundColor: backgroundColor,
      width: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Text(''),
          ),

          //save to gallery button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.save),
            color: iconColor,
            onPressed: () => saveToGallery(context),
            tooltip: 'Save To Gallery',
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          ),
          //Increse font size button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.add),
            color: iconColor,
            onPressed: increaseFontSize,
            tooltip: 'Increase Font Size',
          ),
          //Decrease font size button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.remove),
            color: iconColor,
            onPressed: decreaseFontSize,
            tooltip: 'Decrease Font Size',
          ),
          // Align Left button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.format_align_left),
            color: iconColor,
            onPressed: alignLeft,
            tooltip: 'Align Left',
          ),
          // Align Center button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.format_align_center),
            color: iconColor,
            onPressed: alignCenter,
            tooltip: 'Align Center',
          ),
          // Align Right button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.format_align_right),
            color: iconColor,
            onPressed: alignRight,
            tooltip: 'Align Right',
          ),
          // Text Bold button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.format_bold),
            color: iconColor,
            onPressed: boldText,
            tooltip: 'Bold',
          ),
          // Text Italic button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.format_italic),
            color: iconColor,
            onPressed: italicText,
            tooltip: 'Italic',
          ),
          // Columize/Vertical Text button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.align_horizontal_center),
            color: iconColor,
            onPressed: columnizeText,
            tooltip: 'Columnize text',
          ),
          // Color Picker button
          Tooltip(
            message: 'Pick a color',
            child: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.circle),
              color: pickerColor,
              onPressed: buildColorPicker,
              tooltip: 'Pick a color',
            ),
          ),
          Tooltip(
            message: 'Choose Font',
            child: TextButton(
              onPressed: buildFontPicker,
              child: Text(
                'Font',
                style: selectedFontTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: backgroundColor,
      width: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Text(''),
          ),
          //save to gallery button
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.save),
            color: iconColor,
            onPressed: () => saveToGallery(context),
            tooltip: 'Save To Gallery',
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          ),
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.crop),
            color: iconColor,
            onPressed: increaseFontSize,
            tooltip: 'Corp Image',
          ),
        ],
      ),
    );
  }
}
