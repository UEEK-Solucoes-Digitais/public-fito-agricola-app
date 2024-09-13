import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';

// ignore: must_be_immutable
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
    this.status,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  final String? status;

  Color? _color;

  @override
  Widget build(BuildContext context) {
    if (status != '') {
      if (status == 'Enviada') {
        _color = theme.colorScheme.primary;
      } else if (status == 'Em análise') {
        _color = appTheme.amber550;
      } else if (status == 'Resolvida') {
        _color = appTheme.green400;
      } else if (status == "Não encontrada") {
        _color = theme.colorScheme.onPrimaryContainer;
      } else {
        _color = theme.colorScheme.primary;
      }
    } else {
      _color = theme.colorScheme.primary;
    }

    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(10.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillAmber => BoxDecoration(
        color: appTheme.amber400,
        borderRadius: BorderRadius.circular(10.h),
      );
  static BoxDecoration get fillOnPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(10.h),
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green400,
        borderRadius: BorderRadius.circular(10.h),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray300,
        borderRadius: BorderRadius.circular(20.h),
      );
}
