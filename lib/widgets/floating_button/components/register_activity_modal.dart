import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/floating_button/components/steps/defensive_fields.dart';
import 'package:fitoagricola/widgets/floating_button/components/steps/fertilizer_fields.dart';
import 'package:fitoagricola/widgets/floating_button/components/steps/harvest_fields.dart';
import 'package:fitoagricola/widgets/floating_button/components/steps/rain_gauge_fields.dart';
import 'package:fitoagricola/widgets/floating_button/components/steps/seeds_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class RegisterActivityModal extends StatefulWidget {
  final int? propertyId;
  final int? harvestId;
  final String code;
  final BuildContext contextScreen;

  const RegisterActivityModal({
    this.harvestId,
    this.propertyId,
    required this.code,
    required this.contextScreen,
    super.key,
  });

  @override
  State<RegisterActivityModal> createState() => _RegisterActivityModalState();
}

class _RegisterActivityModalState extends State<RegisterActivityModal> {
  bool isLoading = false;
  List<Crop> crops = [];

  int selectedPropertyId = 0;
  int selectedHarvestId = 0;

  bool isSubmitting = false;

  Admin admin = PrefUtils().getAdmin();

  List<Harvest> harvests = [];
  List<Property> properties = [];
  List<Crop> selectedCrops = [];

  List<Product> products = [];

  List<Map<String, dynamic>> fields = [];

  List<Map<String, dynamic>> productsFields = [];

  // formKey
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.propertyId != null && widget.harvestId != null) {
      setState(() {
        selectedPropertyId = widget.propertyId!;
        selectedHarvestId = widget.harvestId!;
      });
      _getCrops();
    } else {
      _loadInitialData();
    }

    _initFields();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.propertyId == null) _buildPropertyDropdown(),
                if (widget.harvestId == null) _buildHarvestDropdown(),
                _buildCropsDropdown(),
                const SizedBox(height: 10),
                if (fields.length != 0) _buildFields(),
                const SizedBox(height: 10),
                CustomFilledButton(
                  isDisabled: isSubmitting,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  text: "Enviar",
                ),
                const SizedBox(height: 10),
                CustomOutlinedButton(
                  isDisabled: isSubmitting,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Cancelar",
                )
              ],
            ),
          );
  }

  _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      _getProperties(),
      _getHarvests(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getProperties() async {
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
  }

  Future<void> _getHarvests() async {
    final response = await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listHarvest}",
      context,
      showSnackBar: 0,
    );
    final data = jsonDecode(response.body);

    if (data['harvests'] != null) {
      setState(() {
        harvests = Harvest.fromJsonList(data['harvests']);

        if (PrefUtils().getActualHarvest() == null) {
          for (var harvest in harvests) {
            if (harvest.isLastHarvert == 1) {
              selectedHarvestId = harvest.id;
              break;
            }
          }
        } else {
          selectedHarvestId = PrefUtils().getActualHarvest()!;
        }
      });
    }
  }

  List<Crop> _convertCrops(List<Crop> crops) {
    return crops.map((crop) {
      crop.id = crop.joinId!; // Supondo que Crop tenha a propriedade join_id
      return crop;
    }).toList();
  }

  _getCrops() async {
    setState(() {
      isLoading = true;
    });

    await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.getLinkedCrops}/$selectedPropertyId?harvest_id=$selectedHarvestId",
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      if (data['linked_crops'] != null) {
        setState(() {
          crops = _convertCrops(Crop.fromJsonList(data['linked_crops']));
          isLoading = false;
          selectedCrops = [];
        });

        Logger().e(crops.map((e) => e.id).toList());
      }
    });
  }

  _buildPropertyDropdown() {
    return Column(
      children: [
        DropdownSearchComponent(
          items: properties
              .map((e) => DropdownSearchModel(id: e.id, name: e.name))
              .toList(),
          label: 'Propriedade',
          hintText: 'Selecione',
          selectedId: selectedPropertyId,
          style: 'inline',
          onChanged: (value) {
            setState(() {
              selectedPropertyId = value.id;

              if (selectedPropertyId != 0 && selectedHarvestId != 0)
                _getCrops();
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _buildHarvestDropdown() {
    return Column(
      children: [
        DropdownSearchComponent(
          items: harvests
              .map((e) => DropdownSearchModel(id: e.id, name: e.name))
              .toList(),
          label: 'Ano Agrícola',
          hintText: 'Selecione',
          selectedId: selectedHarvestId,
          style: 'inline',
          onChanged: (value) {
            setState(() {
              selectedHarvestId = value.id;

              if (selectedPropertyId != 0 && selectedHarvestId != 0)
                _getCrops();
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _buildCropsDropdown() {
    return Column(
      children: [
        DropdownSearchComponent(
          items: crops
              .map((e) => DropdownSearchModel(
                  id: e.id, name: "${e.name} ${e.subharvestName ?? ''}"))
              .toList(),
          label: 'Lavouras',
          hintText: 'Selecione',
          selectedId: null,
          style: 'inline',
          onChanged: _selectCrop,
        ),
        const SizedBox(height: 8),
        selectedCrops.length > 0
            ? SelectedItemList(
                itemList: selectedCrops
                    .map<Widget>(
                      (crop) => SelectedItemComponent(
                        value: "${crop.name} ${crop.subharvestName ?? ''}",
                        onItemRemoved: (cropName) {
                          setState(() {
                            selectedCrops.removeWhere(
                              (crop) =>
                                  "${crop.name} ${crop.subharvestName ?? ''}" ==
                                  cropName,
                            );
                          });

                          if (widget.code == 'seed') {
                            _sumArea();
                          }
                        },
                      ),
                    )
                    .toList(),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  void _sumArea() {
    // somando a area de todas as selectedCrops e colocando na area dos fields
    double totalArea = 0;
    double usedArea = 0;
    for (var crop in selectedCrops) {
      totalArea += double.parse(crop.area!);
      usedArea += double.parse(crop.usedArea.toString());
    }

    print((totalArea - usedArea).toString());
    fields
        .firstWhere((element) => element['name'] == 'area')['controller']
        .text = Formatters.formatToBrl(totalArea - usedArea);
  }

  void _selectCrop(DropdownSearchModel? newCrop) {
    if (newCrop == null) return;
    var crop = crops.firstWhere(
      (item) => item.id == newCrop.id,
    );

    var cropIndex = selectedCrops.indexOf(crop);
    if (cropIndex != -1) return;

    setState(() {
      selectedCrops.add(crop);
    });

    if (widget.code == 'seed') {
      _sumArea();
    }
  }

  Widget _buildFields() {
    switch (widget.code) {
      case 'seed':
        return SeedsFieldsActivity(
          fields: fields,
          seeds: products,
          selectedCropsLength: selectedCrops.length,
        );
      case 'fertilizer':
        return FertilizerFieldActivity(
          fields: fields,
          fertilizers: products,
          productsFields: productsFields,
        );
      case 'defensive':
        return DefensiveFieldsActivity(
          fields: fields,
          defensives: products,
          productsFields: productsFields,
        );
      case 'harvest':
        return HarvestFieldsActivity(fields: fields);
      case 'rain':
        return RainGaugeFieldsActivity(fields: fields);
      default:
        return SeedsFieldsActivity(
          fields: fields,
          seeds: products,
          selectedCropsLength: selectedCrops.length,
        );
    }
  }

  void _initFields() {
    switch (widget.code) {
      case 'seed':
        _initSeedsFields();
        break;
      case 'fertilizer':
        _initFertilizerFields();
        break;
      case 'defensive':
        _initDefensiveFields();
        break;
      case 'harvest':
        _initHarvestFields();
        break;
      case 'rain':
        _initRainFields();
        break;
    }
  }

  void _initSeedsFields() {
    setState(() {
      isLoading = true;
    });

    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listSeeds}/${admin.id}",
      context,
      showSnackBar: 0,
    ).then((value) {
      setState(() {
        products = Product.fromJsonList(jsonDecode(value.body)['cultures']);
        fields = [
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
            "controller": TextEditingController(
                text: Formatters.formatDateString(
                    DateTime.now().toString().split(" ")[0])),
            "label": "Data",
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
          },
          {
            "name": "area",
            "controller": TextEditingController(),
            "label": "Área",
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2),
            ],
          },
          {
            "name": "kilogram_per_ha",
            "controller": TextEditingController(),
            "label": "Kg/${PrefUtils().getAreaUnit()}",
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2),
            ],
          },
          {
            "name": "spacing",
            "controller": TextEditingController(),
            "label": "Espaçamento (m)",
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2),
            ],
          },
          {
            "name": "seed_per_linear_meter",
            "controller": TextEditingController(),
            "label": "Semente/m",
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2),
            ],
          },
          {
            "name": "pms",
            "controller": TextEditingController(),
            "label": "PMS",
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              CentavosInputFormatter(casasDecimais: 2),
            ],
          },
        ];
      });
    });
  }

  void _initFertilizerFields() {
    setState(() {
      isLoading = true;
    });

    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listFertilizers}/${admin.id}",
      context,
      showSnackBar: 0,
    ).then((value) {
      setState(() {
        products = Product.fromJsonList(jsonDecode(value.body)['fertilizers']);
        fields = [
          {
            "name": 'date',
            "label": "Data",
            "controller": TextEditingController(
              text: Formatters.formatDateString(
                  DateTime.now().toString().split(" ")[0]),
            ),
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
          },
        ];

        productsFields = [
          {"product_id": 0, "dosage": TextEditingController()}
        ];
      });
    });
  }

  void _initDefensiveFields() {
    setState(() {
      isLoading = true;
    });

    DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listDefensives}/${admin.id}",
      context,
      showSnackBar: 0,
    ).then((value) {
      setState(() {
        products = Product.fromJsonList(jsonDecode(value.body)['defensives']);
        fields = [
          {
            "name": 'date',
            "label": "Data",
            "controller": TextEditingController(
              text: Formatters.formatDateString(
                  DateTime.now().toString().split(" ")[0]),
            ),
            "formatters": [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
          },
        ];

        productsFields = [
          {
            "product_id": 0,
            "dosage": TextEditingController(),
            'product_type': 1,
          }
        ];
      });
    });
  }

  void _initHarvestFields() {
    setState(() {
      fields = [
        {
          "name": "date",
          "controller": TextEditingController(
              text: Formatters.formatDateString(
                  DateTime.now().toString().split(" ")[0])),
          "label": "Data",
          "formatters": [
            FilteringTextInputFormatter.digitsOnly,
            DataInputFormatter(),
          ],
        },
        {
          "name": "total_production",
          "controller": TextEditingController(),
          "label": "Produção total (kg)",
          "formatters": [
            FilteringTextInputFormatter.digitsOnly,
            CentavosInputFormatter(casasDecimais: 2),
          ],
        },
      ];
    });
  }

  void _initRainFields() {
    setState(() {
      fields = [
        {
          "volume": TextEditingController(),
          "date": TextEditingController(
            text: Formatters.formatDateString(
                DateTime.now().toString().split(" ")[0]),
          ),
        },
      ];
    });
  }

  void _submitForm() {
    setState(() {
      isSubmitting = true;
    });

    final body =
        widget.code == 'rain' ? _mountRainGaugeBody() : _mountBodyGeneral();
    final url = widget.code == 'rain'
        ? ApiRoutes.formRainGauge
        : ApiRoutes.registerActivity;

    Logger().e(body);
    DefaultRequest.simplePostRequest(
      url,
      body,
      widget.contextScreen,
      showSnackBar: 0,
      closeModal: false,
    ).then((value) {
      if (value) {
        Dialogs.showGeralDialog(
          context,
          title: "Sucesso!",
          text: "Atividade registrada com sucesso",
          doubleClose: true,
          widget: Column(
            children: [
              CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                text: "Fechar",
              )
            ],
          ),
        );
      } else {
        Dialogs.showGeralDialog(
          context,
          title: "Erro",
          text: "Erro ao registrar atividade",
          widget: Column(
            children: [
              CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Fechar",
              )
            ],
          ),
        );
      }
    }).catchError((error) {
      print(error);
      Dialogs.showGeralDialog(
        context,
        title: "Erro",
        text: "Erro ao registrar atividade",
        widget: Column(
          children: [
            CustomFilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Fechar",
            )
          ],
        ),
      );
    }).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
    });
  }

  _mountBodyGeneral() {
    // lista com id de crops

    Map<String, dynamic> body = {
      "admin_id": admin.id,
      "property_id": selectedPropertyId,
      "harvest_id": selectedHarvestId,
      "type": widget.code,
      "crops": selectedCrops.map((e) => e.id).toList(),
    };

    print(body['crops']);

    for (var field in fields) {
      if (field['name'] == "culture_code") {
        final productField =
            fields.firstWhere((element) => element['name'] == "product_id");

        final product = products.firstWhere((element) =>
            element.id == int.parse(productField['value'].toString()));

        final customCodes = product.extra_column!.split(',');

        if (customCodes.length > 0) {
          body["${field['name']}"] =
              customCodes[int.parse(field['value'].toString())];
        }
      } else if (field['controller'] != null) {
        body["${field['name']}"] = field['name'].toString().contains('date')
            ? Formatters.formatDateStringEn(field['controller'].text)
            : field['controller'].text;
      } else if (field['value'] != null) {
        body["${field['name']}"] = field['value'];
      } else {
        body["${field['name']}"] = null;
      }
    }

    if (['fertilizer', 'defensive'].contains(widget.code)) {
      body["products_id"] = [];
      body["dosages"] = [];

      for (var productField in productsFields) {
        body["products_id"].add(productField['product_id']);
        body["dosages"].add(productField['dosage'].text);
      }
    }

    return body;
  }

  _mountRainGaugeBody() {
    Map<String, dynamic> body = {
      "admin_id": admin.id,
      "property_id": selectedPropertyId,
      "harvest_id": selectedHarvestId,
      "crops": selectedCrops.map((e) => e.id).toList(),
      "volumes": [],
      "dates": [],
    };

    for (var rainGauge in fields) {
      body['volumes'].add(rainGauge['volume'].text);
      body['dates'].add(Formatters.formatDateStringEn(rainGauge['date'].text));
    }

    return body;
  }
}
