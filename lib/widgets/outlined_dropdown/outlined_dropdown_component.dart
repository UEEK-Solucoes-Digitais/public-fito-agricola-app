import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OutlinedDropdownComponent<T> extends StatelessWidget {
  const OutlinedDropdownComponent({
    required this.onChanged,
    required this.items,
    this.selectedItem,
    this.label,
    this.isDisabled = false,
    super.key,
  });

  final String? label;
  final Function(T?) onChanged;
  final bool isDisabled;
  final List<T> items;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Text(
                label!,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              )
            : const SizedBox.shrink(),
        DropdownButton<T>(
          hint: Text('Selecione'),
          dropdownColor: Colors.white,
          underline: Divider(
            thickness: 1,
            color: Color(0xFF999999),
          ),
          style: theme.textTheme.bodyLarge!.copyWith(
            color: Color(0xFF064e43),
            // fontWeight:
          ),
          borderRadius: BorderRadius.circular(20),
          icon: PhosphorIcon(
            PhosphorIconsBold.caretDown,
            color: theme.colorScheme.secondary,
            size: 16,
          ),
          isExpanded: true,
          value: selectedItem,
          onChanged: isDisabled
              ? null
              : (T? newValue) {
                  onChanged(newValue);
                },
          items: <DropdownMenuItem<T>>[
            for (var item in items)
              DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    Text(item.toString()),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
