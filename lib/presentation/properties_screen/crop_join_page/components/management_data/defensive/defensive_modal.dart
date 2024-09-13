import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefensiveModal extends StatefulWidget {
  dynamic input;
  List<Product> products;
  Function(dynamic) submitForm;

  DefensiveModal(this.input, this.products, this.submitForm, {super.key});

  @override
  State<DefensiveModal> createState() => _DefensiveModalState();
}

class _DefensiveModalState extends State<DefensiveModal> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  List<Map<dynamic, dynamic>> culturesCodes = [];

  List productTypes = [
    {"id": 1, "name": "Adjuvante"},
    {"id": 2, "name": "Biológico"},
    {"id": 3, "name": "Fertilizante foliar"},
    {"id": 4, "name": "Fungicida"},
    {"id": 5, "name": "Herbicida"},
    {"id": 6, "name": "Inseticida"},
  ];

  List<Map<String, dynamic>> fields = [
    {
      "name": 'id',
      "value": 0,
    },
    {
      "name": 'product_type',
      "value": 0,
      "label": "Tipo de insumo",
    },
    {
      "name": 'product_id',
      "value": 0,
      "label": "Defensivo",
    },
    {
      "name": 'date',
      "label": "Data",
      "controller": "",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        DataInputFormatter(),
      ],
    },
    {
      "name": 'dosage',
      "label": "Dose/${PrefUtils().getAreaUnit()}",
      "controller": "",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 3),
      ],
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
                  if (!['product_id', 'product_type', 'id']
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
                  else if (field['name'] == 'product_id')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownSearchComponent(
                        items: widget.products
                            .where((element) =>
                                element.objectType == fields[1]['value'])
                            .map((e) =>
                                DropdownSearchModel(id: e.id, name: e.name))
                            .toList(),
                        label: 'Defensivo',
                        hintText: 'Selecione o produto',
                        selectedId: field['value'],
                        style: 'inline',
                        onChanged: (value) => {
                          setState(() {
                            field['value'] = value.id;
                          })
                        },
                      ),
                    )
                  else if (field['name'] == 'product_type')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownSearchComponent(
                        items: productTypes
                            .map((e) => DropdownSearchModel(
                                id: e['id'], name: e['name']))
                            .toList(),
                        label: 'Tipo de insumo',
                        hintText: 'Selecione o tipo',
                        selectedId: field['value'],
                        style: 'inline',
                        onChanged: (value) => {
                          setState(() {
                            field['value'] = value.id;
                            fields[2]['value'] = 0;
                          })
                        },
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
    final input = widget.input;

    for (var field in fields) {
      // switch do field name
      switch (field['name']) {
        case 'id':
          field['value'] = input != null ? input.id : 0;
          break;
        case 'date':
          field['controller'] = TextEditingController(
              text: input != null
                  ? Formatters.formatDateString(input.date!)
                  : '');
          break;
        case 'dosage':
          field['controller'] = TextEditingController(
              text: input != null ? Formatters.formatToBrl(input.dosage!) : '');
          break;
        case 'product_id':
          field['value'] = input != null ? input.product!.id : 0;
          break;
        case 'product_type':
          field['value'] = input != null ? input.product!.objectType : 0;
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
