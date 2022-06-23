import 'package:flutter/material.dart';


///Return a Seamless Neomorphic IconButton, use backgroundColor same as app background color
class CustomNeuIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;
  final double height;
  final double width;
  final String label;
  final String toolTip;

  final VoidCallback onPressed;
  final double boxRadius;
  const CustomNeuIconButton({
    Key? key,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    this.label = '',
    this.boxRadius = 5,
    this.iconSize = 30,
    this.width = 80,
    this.iconColor = Colors.white,
    this.height = 80,
    this.toolTip = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(boxRadius),
          color: backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.white54,
              blurRadius: 10,
              offset: Offset(-5, -5),
            ),
            BoxShadow(
              color: Colors.black87,
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: toolTip,
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
              if (label.isNotEmpty) const SizedBox(height: 5),
              if (label.isNotEmpty)
                Text(
                  label,
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.parent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
