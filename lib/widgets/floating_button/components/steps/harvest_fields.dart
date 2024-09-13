import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class HarvestFieldsActivity extends StatefulWidget {
  final List<Map<String, dynamic>> fields;
  const HarvestFieldsActivity({
    required this.fields,
    super.key,
  });

  @override
  State<HarvestFieldsActivity> createState() => _HarvestFieldsActivityState();
}

class _HarvestFieldsActivityState extends State<HarvestFieldsActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var field in widget.fields)
          if (!['property_management_data_seed_id', 'id']
              .contains(field['name']))
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: CustomTextFormField(
                field['controller'],
                field['label'],
                'Digite aqui',
                inputType: TextInputType.number,
                formatters: field['formatters'],
              ),
            )
      ],
    );
  }
}
