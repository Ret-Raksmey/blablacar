import 'package:flutter/material.dart';

class BlaButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isPrimary;
  final bool hasIcon;
  final VoidCallback onPressed;
  
  // Constructor

  const BlaButton({
    required this.label,
    required this.isPrimary,
    this.icon,
    required this.hasIcon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            side: BorderSide(color: Colors.blue),
          );

    return Padding(
      padding: const EdgeInsets.only(top: 20.0), 
      child: ElevatedButton.icon(
        style: buttonStyle,
        onPressed: onPressed,
        icon: hasIcon && icon != null ? Icon(icon) : SizedBox.shrink(),
        label: Text(label),
      ),
    );
  }
}