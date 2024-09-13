import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeedModal extends StatefulWidget {
  dynamic dataSeed;
  List<Product> products;
  Function(dynamic) submitForm;
  final Crop crop;
  double availableArea;

  SeedModal(
    this.dataSeed,
    this.products,
    this.submitForm,
    this.crop,
    this.availableArea, {
    super.key,
  });

  @override
  State<SeedModal> createState() => _SeedModalState();
}

class _SeedModalState extends State<SeedModal> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  List<Map<dynamic, dynamic>> culturesCodes = [];

  List<Map<String, dynamic>> fields = [
    {
      "name": 'id',
      "value": 0,
    },
    {
      "name": 'product_id',
      "value": 0,
      "label": "Cultura",
    },
    {
      "name": 'culture_code',
      "value": '',
      "label": "Cultivar",
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
      "name": "area",
      "controller": "",
      "label": "Área",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 2),
      ],
    },
    {
      "name": "kilogram_per_ha",
      "controller": "",
      "label": "Kg/${PrefUtils().getAreaUnit()}",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 2),
      ],
    },
    {
      "name": "spacing",
      "controller": "",
      "label": "Espaçamento (m)",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 2),
      ],
    },
    {
      "name": "seed_per_linear_meter",
      "controller": "",
      "label": "Semente/m",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 2),
      ],
    },
    {
      "name": "pms",
      "controller": "",
      "label": "PMS",
      "formatters": [
        FilteringTextInputFormatter.digitsOnly,
        CentavosInputFormatter(casasDecimais: 2),
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
                  if (!['product_id', 'culture_code', 'id']
                      .contains(field['name']))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CustomTextFormField(
                        field['controller'],
                        field['label'],
                        'Digite aqui',
                        inputType: TextInputType.number,
                        formatters: field['formatters'],
                        validatorFunction:
                            ['area', 'date'].contains(field['name']),
                      ),
                    )
                  else if (field['name'] == 'product_id')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownSearchComponent(
                        items: widget.products
                            .map((e) =>
                                DropdownSearchModel(id: e.id, name: e.name))
                            .toList(),
                        label: 'Cultura',
                        hintText: 'Selecione a cultura',
                        selectedId: field['value'],
                        style: 'inline',
                        onChanged: (value) => {
                          setState(() {
                            field['value'] = value.id;
                            setCultureCodes();
                          })
                        },
                      ),
                    )
                  else if (field['name'] == 'culture_code' &&
                      culturesCodes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownSearchComponent(
                        items: culturesCodes
                            .map((e) => DropdownSearchModel(
                                id: e['id'], name: e['name']))
                            .toList(),
                        label: 'Cultivar',
                        hintText: 'Selecione o cultivar',
                        selectedId: field['value'],
                        validateZero: false,
                        style: 'inline',
                        onChanged: (value) => {
                          setState(() {
                            field['value'] = value.id;
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

  setCultureCodes() async {
    final product = widget.products.firstWhere((element) =>
        element.id ==
        fields
            .firstWhere((element) => element['name'] == 'product_id')['value']);

    culturesCodes.clear();
    int index = 0;

    if (product.extra_column != null) {
      for (var cultureCode in product.extra_column!.split(',')) {
        culturesCodes.add({
          'id': index,
          'name': cultureCode,
        });
        index++;
      }
    }

    fields[2]['value'] = culturesCodes.length > 0 ? culturesCodes[0]['id'] : '';

    setState(() {});
  }

  initFields() async {
    final dataSeed = widget.dataSeed;

    for (var field in fields) {
      // switch do field name
      switch (field['name']) {
        case 'id':
          field['value'] = dataSeed != null ? dataSeed.id : 0;
          break;
        case 'product_id':
          field['value'] = dataSeed != null ? dataSeed.product!.id : 0;
          if (dataSeed != null) {
            await setCultureCodes();
          }
          break;
        case 'culture_code':
          if (dataSeed != null) {
            field['value'] = culturesCodes.firstWhere((element) =>
                element['name'] == dataSeed.productVariant!.toString())['id'];
          }
          break;
        case 'date':
          field['controller'] = TextEditingController(
              text: dataSeed != null
                  ? Formatters.formatDateString(dataSeed.date!)
                  : Formatters.formatDateString(
                      DateTime.now().toString().split(" ")[0]));
          break;
        case 'area':
          field['controller'] = TextEditingController(
              text: dataSeed != null
                  ? Formatters.formatToBrl(dataSeed.area!)
                  : widget.availableArea > 0
                      ? Formatters.formatToBrl(widget.availableArea)
                      : '');
          break;
        case 'kilogram_per_ha':
          field['controller'] = TextEditingController(
              text: dataSeed != null
                  ? Formatters.formatToBrl(dataSeed.kilogramPerHa!)
                  : '');
          break;
        case 'spacing':
          field['controller'] = TextEditingController(
              text: dataSeed != null
                  ? Formatters.formatToBrl(dataSeed.spacing!)
                  : '');
          break;
        case 'seed_per_linear_meter':
          field['controller'] = TextEditingController(
              text: dataSeed != null
                  ? Formatters.formatToBrl(dataSeed.seedPerLinearMeter!)
                  : '');
          break;
        case 'pms':
          field['controller'] = TextEditingController(
              text: dataSeed != null
                  ? Formatters.formatToBrl(dataSeed.pms!)
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
