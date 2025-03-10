import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? enabled;
  final String label;
  final void Function(bool? value) onChanged;
  const CustomCheckbox({
    super.key,
    this.enabled,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 17.0),
        ),
        const SizedBox(width: 10),
        Checkbox(
          tristate: true,
          value: enabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
