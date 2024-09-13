import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/base_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomTextButton extends BaseButton {
  CustomTextButton({
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

  final String? leftIcon;

  final String? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildTextButtonWidget,
          )
        : buildTextButtonWidget;
  }

  Widget get buildTextButtonWidget => Container(
        height: this.height ?? 50.v,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: TextButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: PhosphorIcon(
                        IconsList.getIcon(leftIcon!),
                        size: 20,
                        color: theme.colorScheme.secondary,
                      ),
                    )
                  : const SizedBox.shrink(),
              Text(
                text,
                textAlign: textAlignment ?? TextAlign.center,
                style: buttonTextStyle ??
                    theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onPrimary,
                      decoration: TextDecoration.underline,
                    ),
              ),
              rightIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: PhosphorIcon(
                        IconsList.getIcon(leftIcon!),
                        size: 20,
                        color: theme.colorScheme.secondary,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
}
