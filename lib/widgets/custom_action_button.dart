import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class CustomActionButton extends StatefulWidget {
  String icon;
  Color? backgroundColor;
  Color? borderColor;
  Color? iconColor;
  Function()? onTap;
  double? height;
  double? width;
  double? iconSize;

  CustomActionButton({
    required this.icon,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    required this.onTap,
    this.height,
    this.width,
    this.iconSize,
    super.key,
  });

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? 35.v,
        height: widget.height ?? 35.v,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Color(0xFF064e43),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: widget.borderColor ?? Color(0xFF064e43),
            width: 1,
          ),
        ),
        child: Center(
          child: PhosphorIcon(
            IconsList.getIcon(widget.icon),
            size: widget.iconSize ?? 20,
            color: widget.iconColor ?? Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
