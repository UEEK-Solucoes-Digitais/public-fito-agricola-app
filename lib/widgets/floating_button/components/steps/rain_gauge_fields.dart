import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RainGaugeFieldsActivity extends StatefulWidget {
  final List<Map<String, dynamic>> fields;

  const RainGaugeFieldsActivity({
    required this.fields,
    super.key,
  });

  @override
  State<RainGaugeFieldsActivity> createState() =>
      _RainGaugeFieldsActivityState();
}

class _RainGaugeFieldsActivityState extends State<RainGaugeFieldsActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var rainGauge in widget.fields)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                child: Column(
                  children: [
                    CustomTextFormField(
                      rainGauge['date'],
                      "Data",
                      'Digite aqui',
                      inputType: TextInputType.numberWithOptions(),
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DataInputFormatter(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      rainGauge['volume'],
                      "Volume",
                      'Digite aqui',
                      inputType: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(casasDecimais: 2),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -5,
                right: -10,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: appTheme.red600,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: PhosphorIcon(
                      IconsList.getIcon('trash'),
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      widget.fields.remove(rainGauge);
                    });
                  },
                ),
              ),
            ],
          ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.fields.add({
                "volume": TextEditingController(),
                "date": TextEditingController(
                  text: Formatters.formatDateString(
                      DateTime.now().toString().split(" ")[0]),
                )
              });
            });
          },
          child: Text(
            "+ Adicionar registro",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
