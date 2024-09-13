import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomDateFormField extends StatefulWidget {
  const CustomDateFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function(DateTime?) onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  @override
  State<CustomDateFormField> createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      widget.controller,
      widget.labelText,
      widget.hintText,
      icon: 'calendar',
      readonly: true,
      tapFunction: () {
        showDatePicker(
          context: context,
          firstDate: widget.firstDate ?? DateTime(1900),
          lastDate: widget.lastDate ?? DateTime(2100),
          initialDate: widget.initialDate,
        ).then(
          widget.onDateChanged,
        );
      },
    );
  }
}
