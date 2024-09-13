import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PageHeader extends StatelessWidget {
  String title;
  String? text;
  String? icon;
  List<Widget>? buttons;

  PageHeader({
    required this.title,
    this.text,
    this.icon,
    this.buttons,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon != null
                    ? Row(
                        children: [
                          PhosphorIcon(
                            IconsList.getIcon(icon!),
                            color: theme.colorScheme.secondary,
                            size: 22,
                          ),
                          const SizedBox(width: 15)
                        ],
                      )
                    : Container(),
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            buttons != null
                ? Row(
                    children: buttons!,
                  )
                : SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 20),
        text != null
            ? Text(
                text!,
                style: CustomTextStyles.bodyMediumOnGray,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
