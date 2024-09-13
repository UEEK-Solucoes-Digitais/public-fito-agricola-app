import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class SelectHarvestedComponent extends StatelessWidget {
  const SelectHarvestedComponent({
    required this.value,
    this.onChanged,
    super.key,
  });

  final bool value;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform.scale(
          scale: 0.6,
          child: Switch(
            value: value,
            thumbColor: WidgetStatePropertyAll(appTheme.green400),
            activeColor: appTheme.whiteA70001,
            trackOutlineColor: WidgetStatePropertyAll(Colors.black),
            trackOutlineWidth: WidgetStatePropertyAll(1),
            onChanged: onChanged,
          ),
        ),
        Text(
          'Lavouras colhidas',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
