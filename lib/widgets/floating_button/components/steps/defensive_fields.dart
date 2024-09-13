import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DefensiveFieldsActivity extends StatefulWidget {
  final List<Product> defensives;
  final dynamic productsFields;
  final List<Map<String, dynamic>> fields;

  const DefensiveFieldsActivity({
    required this.defensives,
    required this.productsFields,
    required this.fields,
    super.key,
  });

  @override
  State<DefensiveFieldsActivity> createState() =>
      _DefensiveFieldsActivityState();
}

class _DefensiveFieldsActivityState extends State<DefensiveFieldsActivity> {
  List productTypes = [
    {"id": 1, "name": "Adjuvante"},
    {"id": 2, "name": "Biológico"},
    {"id": 3, "name": "Fertilizante foliar"},
    {"id": 4, "name": "Fungicida"},
    {"id": 5, "name": "Herbicida"},
    {"id": 6, "name": "Inseticida"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var field in widget.fields)
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
        for (var productItem in widget.productsFields)
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
                        items: widget.defensives
                            .where((element) =>
                                element.objectType ==
                                productItem['product_type'])
                            .map((e) =>
                                DropdownSearchModel(id: e.id, name: e.name))
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
                      widget.productsFields.remove(productItem);
                    });
                  },
                ),
              ),
            ],
          ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.productsFields.add({
                "product_id": 0,
                "dosage": TextEditingController(),
                "product_type": 1
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
      ],
    );
  }
}
