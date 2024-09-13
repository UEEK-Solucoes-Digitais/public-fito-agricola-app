import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DropdownButtonComponent extends StatefulWidget {
  final List<Map<String, dynamic>> itens;
  final int value;
  final Function(int?) onChanged;
  final bool isDisabled;

  const DropdownButtonComponent(
      {required this.itens,
      required this.value,
      required this.onChanged,
      this.isDisabled = false,
      Key? key})
      : super(key: key);

  @override
  State<DropdownButtonComponent> createState() =>
      _DropdownButtonComponentState();
}

class _DropdownButtonComponentState extends State<DropdownButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 0,
        left: 20,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.white,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: Color(0xFF064e43),
            // fontWeight:
          ),
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          icon: PhosphorIcon(
            PhosphorIcons.caretDown(),
            color: theme.colorScheme.secondary,
            size: 18,
          ),
          isExpanded: true,
          value: widget.value,
          onChanged: widget.isDisabled
              ? null
              : (Object? newValue) {
                  widget.onChanged(int.tryParse(newValue.toString()));
                },
          items: <DropdownMenuItem<int>>[
            for (var item in widget.itens)
              DropdownMenuItem(
                value: item['id'],
                child: Row(
                  children: [
                    if (item['icon'] != null && item['icon'] != '')
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: PhosphorIcon(
                          IconsList.getIcon(item['icon']),
                          color: theme.colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                    Text(
                      item['title'],
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
