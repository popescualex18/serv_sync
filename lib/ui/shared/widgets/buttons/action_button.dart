import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });
  final void Function() onPressed;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(label),
      ),
    );
  }
}
