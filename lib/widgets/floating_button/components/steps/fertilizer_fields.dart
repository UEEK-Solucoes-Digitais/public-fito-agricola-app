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

class FertilizerFieldActivity extends StatefulWidget {
  final List<Product> fertilizers;
  final dynamic productsFields;
  final List<Map<String, dynamic>> fields;

  const FertilizerFieldActivity({
    required this.fertilizers,
    required this.productsFields,
    required this.fields,
    super.key,
  });

  @override
  State<FertilizerFieldActivity> createState() =>
      _FertilizerFieldActivityState();
}

class _FertilizerFieldActivityState extends State<FertilizerFieldActivity> {
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
                        items: widget.fertilizers
                            .map((e) =>
                                DropdownSearchModel(id: e.id, name: e.name))
                            .toList(),
                        label: 'Fertilizante',
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
              widget.productsFields
                  .add({"product_id": 0, "dosage": TextEditingController()});
            });
          },
          child: Text(
            "+ Adicionar fertilizante",
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
