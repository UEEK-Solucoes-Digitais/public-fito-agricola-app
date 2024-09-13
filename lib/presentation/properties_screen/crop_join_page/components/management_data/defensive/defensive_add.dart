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
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DefensiveAdd extends StatefulWidget {
  dynamic input;
  List<Product> products;
  Function(dynamic, {dynamic productsFields}) submitForm;

  DefensiveAdd(this.input, this.products, this.submitForm, {super.key});

  @override
  State<DefensiveAdd> createState() => _DefensiveAddState();
}

class _DefensiveAddState extends State<DefensiveAdd> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  List<Map<dynamic, dynamic>> culturesCodes = [];

  List<Map<String, dynamic>> fields = [
    {
      "name": 'id',
      "value": 0,
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
  ];

  List productTypes = [
    {"id": 1, "name": "Adjuvante"},
    {"id": 2, "name": "Biológico"},
    {"id": 3, "name": "Fertilizante foliar"},
    {"id": 4, "name": "Fungicida"},
    {"id": 5, "name": "Herbicida"},
    {"id": 6, "name": "Inseticida"},
  ];

  List<Map<String, dynamic>> products = [
    {"product_id": 0, "dosage": '', 'product_type': 1}
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var field in fields)
                  if (!['id'].contains(field['name']))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CustomTextFormField(
                        field['controller'],
                        field['label'],
                        'Digite aqui',
                        inputType: TextInputType.number,
                        formatters: field['formatters'],
                      ),
                    ),
                for (var productItem in products)
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: DropdownSearchComponent(
                                items: productTypes
                                    .map((e) => DropdownSearchModel(
                                        id: e['id'], name: e['name']))
                                    .toList(),
                                label: 'Tipo de insumo',
                                hintText: 'Selecione o tipo',
                                selectedId: productItem['product_type'],
                                style: 'inline',
                                onChanged: (value) => {
                                  setState(() {
                                    productItem['product_type'] = value.id;
                                    productItem['product_id'] = 0;
                                  })
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: DropdownSearchComponent(
                                items: widget.products
                                    .where((element) =>
                                        element.objectType ==
                                        productItem['product_type'])
                                    .map((e) => DropdownSearchModel(
                                        id: e.id, name: e.name))
                                    .toList(),
                                label: 'Defensivo',
                                hintText: 'Selecione o produto',
                                selectedId: productItem['product_id'],
                                style: 'inline',
                                onChanged: (value) => {
                                  setState(() {
                                    productItem['product_id'] = value.id;
                                  })
                                },
                              ),
                            ),
                            CustomTextFormField(
                              productItem['dosage'],
                              "Dose/${PrefUtils().getAreaUnit()}",
                              'Digite aqui',
                              inputType: TextInputType.number,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(casasDecimais: 3),
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
                              products.remove(productItem);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      products.add({
                        "product_id": 0,
                        "dosage": TextEditingController(),
                        "product_type": 1,
                      });
                    });
                  },
                  child: Text(
                    "+ Adicionar defensivo",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomFilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.submitForm(fields, productsFields: products);
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
                  : Formatters.formatDateString(
                      DateTime.now().toString().split(" ")[0]));
          break;
        default:
          break;
      }
    }

    for (var productItem in products) {
      productItem['dosage'] = TextEditingController();
    }

    setState(() {
      isLoading = false;
    });
  }
}
