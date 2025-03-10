import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  final double? width;
  final String cellText;
  final TextStyle? style;
  final void Function()? onClick;

  const CustomTableCell({
    super.key,
    required this.cellText,
    this.width,
    this.style,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    var text = InkWell(
      onTap: onClick,
      child: Text(
        cellText,
        style: style,
      ),
    );
    if (width == null) {
      return Expanded(
        child: text,
      );
    }
    return SizedBox(
      width: width,
      child: text,
    );
  }
}
