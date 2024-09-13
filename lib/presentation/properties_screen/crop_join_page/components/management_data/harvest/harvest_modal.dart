import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/data_harvest/data_harvest.dart';
import 'package:fitoagricola/data/models/data_seed/data_seed.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HarvestModal extends StatefulWidget {
  dynamic harvest;
  List<DataSeed> dataSeeds;
  Function(dynamic) submitForm;

  HarvestModal(this.harvest, this.dataSeeds, this.submitForm, {super.key});

  @override
  State<HarvestModal> createState() => _HarvestModalState();
}

class _HarvestModalState extends State<HarvestModal> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  List<Map<dynamic, dynamic>> culturesCodes = [];

  List<Map<String, dynamic>> fields = [
    {
      "name": 'id',
      "value": 0,
    },
    {
      "name": "date",
      "controller": "",
      "label": "Data",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        DataInputFormatter(),
      ],
    },
    {
      "name": "total_production",
      "controller": "",
      "label": "Produção total (kg)",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 2),
      ],
    },
    {
      "name": 'property_management_data_seed_id',
      "value": 0,
      "label": "Cultivar",
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      initFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Form(
            key: _formKey,
            child: Column(
              children: [
                for (var field in fields)
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
                  else if (field['name'] == 'property_management_data_seed_id')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownSearchComponent(
                        items: [
                          DropdownSearchModel(
                            id: 0,
                            name: "Selecione o cultivar",
                          ),
                          ...widget.dataSeeds
                              .map((e) => DropdownSearchModel(
                                  id: e.id, name: e.productVariant!))
                              .toList()
                        ],
                        label: 'Cultivar',
                        hintText: 'Selecione o cultivar',
                        selectedId: field['value'],
                        style: 'inline',
                        onChanged: (value) => {
                          setState(() {
                            field['value'] = value.id;
                          })
                        },
                        validatorFunction: false,
                      ),
                    ),
                CustomFilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.submitForm(fields);
                    }
                  },
                  text: "Enviar",
                ),
                const SizedBox(height: 10),
                CustomOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Cancelar",
                )
              ],
            ),
          );
  }

  initFields() async {
    final harvest = widget.harvest as DataHarvest?;

    for (var field in fields) {
      // switch do field name
      switch (field['name']) {
        case 'id':
          field['value'] = harvest != null ? harvest.id : 0;
          break;

        case 'property_management_data_seed_id':
          if (harvest != null) {
            field['value'] = harvest.propertyManagementDataSeedId;
          }
          break;
        case 'date':
          field['controller'] = TextEditingController(
              text: harvest != null
                  ? Formatters.formatDateString(harvest.date)
                  : Formatters.formatDateString(
                      DateTime.now().toString().split(" ")[0]));
          break;
        case 'total_production':
          field['controller'] = TextEditingController(
              text: harvest != null
                  ? Formatters.formatToBrl(harvest.totalProduction)
                  : '');
          break;
        default:
          break;
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
