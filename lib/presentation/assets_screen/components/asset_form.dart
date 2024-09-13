import 'dart:convert';
import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/asset/Asset.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class AssetForm extends StatefulWidget {
  Asset? asset;
  Function(List<Map<String, dynamic>>) submitForm;

  AssetForm({
    required this.asset,
    required this.submitForm,
    super.key,
  });

  @override
  State<AssetForm> createState() => _AssetFormState();
}

class _AssetFormState extends State<AssetForm> {
  List<Property> properties = [];
  bool isLoading = true;
  Admin admin = PrefUtils().getAdmin();
  final _formKey = GlobalKey<FormState>();
  List<Property> selectedProperties = [];

  dynamic imagePreview = Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: appTheme.gray400),
      borderRadius: BorderRadius.circular(10),
    ),
    child: PhosphorIcon(
      IconsList.getIcon('plus'),
      color: theme.colorScheme.secondary,
      size: 40,
    ),
  );

  List<Map<String, dynamic>> fields = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getProperties();
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
                  if (!['image', 'properties', 'id'].contains(field['name']))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomTextFormField(
                        field['controller'],
                        field['label'],
                        'Digite aqui',
                        inputType: ['value', 'year'].contains(field['name'])
                            ? TextInputType.number
                            : TextInputType.text,
                        formatters: field['formatters'] ?? [],
                        validatorFunction:
                            ['name', 'type', 'value'].contains(field['name']),
                      ),
                    )
                  else if (field['name'] == 'properties')
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 15),
                    //   child: DropdownSearchComponent(
                    //     items: properties
                    //         .map((e) =>
                    //             DropdownSearchModel(id: e.id, name: e.name))
                    //         .toList(),
                    //     label: 'Propriedade',
                    //     hintText: 'Selecione a propriedade',
                    //     selectedId: field['value'],
                    //     style: 'inline',
                    //     onChanged: (value) => {
                    //       setState(() {
                    //         field['value'] = value.id;
                    //       })
                    //     },
                    //   ),
                    // )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          DropdownSearchComponent(
                            items: properties
                                .map((e) => DropdownSearchModel(
                                    id: e.id, name: "${e.name}"))
                                .toList(),
                            label: 'Propriedades',
                            hintText: 'Selecione',
                            selectedId: null,
                            style: 'inline',
                            onChanged: _selectProperty,
                            validatorFunction: selectedProperties.length == 0,
                          ),
                          const SizedBox(height: 8),
                          selectedProperties.length > 0
                              ? SelectedItemList(
                                  itemList: selectedProperties
                                      .map<Widget>(
                                        (property) => SelectedItemComponent(
                                          value: "${property.name}",
                                          onItemRemoved: (propertyName) {
                                            setState(() {
                                              selectedProperties.removeWhere(
                                                (property) =>
                                                    "${property.name}" ==
                                                    propertyName,
                                              );
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    )
                  else if (field['name'] == 'image')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () async {
                          final image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (image != null) {
                            setState(() {
                              field['image'] = image;
                              imagePreview = Image.file(
                                File(image.path),
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            });
                          }
                        },
                        child: Container(
                          height: 120.v,
                          width: 120.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imagePreview,
                          ),
                        ),
                      ),
                    ),
                CustomFilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // atualizando o campo de propriedades
                      fields.firstWhere(
                        (field) => field['name'] == 'properties',
                      )['value'] = selectedProperties.map((e) => e.id).toList();

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

  void _selectProperty(DropdownSearchModel? newProperty) {
    if (newProperty == null) return;
    var property = properties.firstWhere(
      (item) => item.id == newProperty.id,
    );

    var propertyIndex = selectedProperties.indexOf(property);
    if (propertyIndex != -1) return;

    setState(() {
      selectedProperties.add(property);
    });
  }

  _getProperties() async {
    final response = await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listProperties}/${admin.id}",
      context,
      showSnackBar: 0,
    );
    final data = jsonDecode(response.body);

    if (data['properties'] != null) {
      setState(() {
        properties = Property.fromJsonList(data['properties']);
      });
    }

    _initFields();
  }

  _initFields() {
    fields = [
      {
        'name': 'id',
        'value': widget.asset != null ? widget.asset!.id : 0,
      },
      {
        'name': 'name',
        'label': 'Nome do bem',
        'controller': TextEditingController(
            text: widget.asset != null ? widget.asset!.name : ''),
      },
      {
        'name': 'type',
        'label': 'Tipo',
        'controller': TextEditingController(
            text: widget.asset != null ? widget.asset!.type : ''),
      },
      {
        'name': 'value',
        'label': 'Valor aproximado',
        'controller': TextEditingController(
            text: widget.asset != null
                ? Formatters.formatToBrl(widget.asset!.value)
                : ''),
        "formatters": [
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter(casasDecimais: 3, moeda: true),
        ],
      },
      {
        'name': 'properties',
        'label': 'Propriedades',
        'value': selectedProperties,
      },
      {
        'name': 'year',
        'label': 'Ano',
        'controller': TextEditingController(
            text: widget.asset != null ? widget.asset!.year : ''),
        "formatters": [
          FilteringTextInputFormatter.digitsOnly,
        ],
      },
      {
        'name': 'buy_date',
        'label': 'Data de compra',
        'controller': TextEditingController(
            text: widget.asset != null &&
                    widget.asset!.buy_date != '' &&
                    widget.asset!.buy_date != null
                ? Formatters.formatDateString(widget.asset!.buy_date ?? '')
                : ''),
        "formatters": [
          FilteringTextInputFormatter.digitsOnly,
          DataInputFormatter(),
        ],
      },
      {
        'name': 'lifespan',
        'label': 'Vida útil',
        'controller': TextEditingController(
            text: widget.asset != null ? widget.asset!.lifespan : ''),
      },
      {
        'name': 'observations',
        'label': 'Observações',
        'controller': TextEditingController(
            text: widget.asset != null ? widget.asset!.observations : ''),
      },
      {
        'name': 'image',
        'label': 'Imagem',
        'image': widget.asset != null ? widget.asset!.image : null,
      },
    ];

    if (widget.asset != null && widget.asset!.properties.isNotEmpty) {
      setState(() {
        selectedProperties = widget.asset!.properties;
      });
    }

    if (widget.asset != null &&
        widget.asset!.image != null &&
        widget.asset!.image!.isNotEmpty) {
      setState(() {
        imagePreview = Image.network(
          "${dotenv.env['IMAGE_URL']}/assets/${widget.asset!.image}",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}
