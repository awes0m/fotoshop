import 'package:flutter/material.dart';
import 'package:fotochop/features/image_edit/domain/edit_image_viewmodel.dart';
import 'package:fotochop/features/image_edit/presentation/widgets/image_canvas_widget.dart';

import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/text_styles.dart';
import '../../../../core/common/utils.dart';
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
  late double canvasHeight = ScrnSizer.screenHeight() * 0.8;
  late double canvasWidth = ScrnSizer.screenWidth() * 0.8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      endDrawer: isTextEditing ? textEditingEndDrawer() : null,
      appBar: _appBar,
      floatingActionButton: _addnewTextFab,
      body: SafeArea(
        child: SizedBox(
          child: Screenshot(
            controller: screenshotController,
            child: Stack(fit: StackFit.passthrough, children: [
              ImageCanvasWidget(
                imagePath: widget.selectedImage.path,
                maxHeight: canvasHeight,
                maxWidth: canvasWidth,
              ),
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
            ]),
          ),
        ),
      ),
    );
  }

// Widgets // //////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: backgroundColor),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_camera),
            const SizedBox(width: 15),
            Text(
              'FotoChop',
              style: AppTextStyle.mediumNormal(color: backgroundColor),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.play_circle)
          ],
        ),
      );

  Widget textEditingEndDrawer() {
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
          const Divider(thickness: 2, color: Colors.white),
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.crop),
            color: iconColor,
            onPressed: () => buildAspectRatioSelector,
            tooltip: 'Corp Image',
          ),
        ],
      ),
    );
  }
}
