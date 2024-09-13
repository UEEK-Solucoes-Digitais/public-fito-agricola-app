import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:flutter/material.dart';

class DateDapFields extends StatelessWidget {
  const DateDapFields({
    required this.initialDateDapController,
    required this.endDateDapController,
    required this.onChangedInitialDateDap,
    required this.onChangedEndDateDap,
    super.key,
  });

  final TextEditingController initialDateDapController;
  final TextEditingController endDateDapController;
  final Function(DateTime?) onChangedInitialDateDap;
  final Function(DateTime?) onChangedEndDateDap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            "Período de plantio",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: Color(0xFF152536),
            ),
          ),
        ),
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CustomDateFormField(
                controller: initialDateDapController,
                labelText: '',
                hintText: 'dd/mm/aaaa',
                onDateChanged: onChangedInitialDateDap,
              ),
            ),
          ),
          Expanded(
            child: CustomDateFormField(
              controller: endDateDapController,
              labelText: '',
              hintText: 'dd/mm/aaaa',
              onDateChanged: onChangedEndDateDap,
            ),
          )
        ]),
      ],
    );
  }
}
