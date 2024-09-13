import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';

class SeedsFieldsActivity extends StatefulWidget {
  List<Map<String, dynamic>> fields;
  List<Product> seeds;
  int selectedCropsLength;

  SeedsFieldsActivity({
    required this.fields,
    required this.seeds,
    required this.selectedCropsLength,
    super.key,
  });

  @override
  State<SeedsFieldsActivity> createState() => _SeedsFieldsActivityState();
}

class _SeedsFieldsActivityState extends State<SeedsFieldsActivity> {
  List<Map<dynamic, dynamic>> culturesCodes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var field in widget.fields)
          if (!['product_id', 'culture_code', 'id'].contains(field['name']))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: field['name'] == 'area' ? 5 : 15),
                  child: CustomTextFormField(
                    field['controller'],
                    field['label'],
                    'Digite aqui',
                    inputType: TextInputType.number,
                    formatters: field['formatters'],
                    readonly: widget.selectedCropsLength == 1
                        ? false
                        : (field['name'] == 'area'),
                    enabled: widget.selectedCropsLength == 1
                        ? true
                        : (field['name'] != 'area'),
                    validatorFunction: ['area', 'date'].contains(field['name']),
                  ),
                ),
                if (field['name'] == 'area' && widget.selectedCropsLength > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                        "O lançamento de plantio utilizará a área disponível de cada lavoura"),
                  ),
              ],
            )
          else if (field['name'] == 'product_id')
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownSearchComponent(
                items: widget.seeds
                    .map((e) => DropdownSearchModel(id: e.id, name: e.name))
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
          else if (field['name'] == 'culture_code' && culturesCodes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DropdownSearchComponent(
                items: culturesCodes
                    .map((e) =>
                        DropdownSearchModel(id: e['id'], name: e['name']))
                    .toList(),
                label: 'Cultivar',
                hintText: 'Selecione o cultivar',
                selectedId: field['value'],
                style: 'inline',
                validateZero: false,
                onChanged: (value) => {
                  setState(() {
                    field['value'] = value.id;
                  })
                },
              ),
            ),
      ],
    );
  }

  setCultureCodes() async {
    final product = widget.seeds.firstWhere((element) =>
        element.id ==
        widget.fields
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

    widget.fields[1]['value'] =
        culturesCodes.length > 0 ? culturesCodes[0]['id'] : '';

    setState(() {});
  }
}
