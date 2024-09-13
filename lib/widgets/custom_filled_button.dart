import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/base_button.dart';

class CustomFilledButton extends BaseButton {
  CustomFilledButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    TextAlign? textAlignment,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          textAlignment: textAlignment,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildFilledButtonWidget,
          )
        : buildFilledButtonWidget;
  }

  Widget get buildFilledButtonWidget => Container(
        height: this.height ?? 50.v,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: FilledButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                textAlign: textAlignment ?? TextAlign.center,
                style: buttonTextStyle ?? CustomTextStyles.bodyLargeOnWhite,
              ),
              rightIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );
}
