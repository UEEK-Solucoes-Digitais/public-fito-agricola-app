import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/data/models/intereference_factor/interference_factor.dart';
import 'package:fitoagricola/data/models/property_disease/property_disease.dart';
import 'package:fitoagricola/data/models/property_monitoring/property_monitoring.dart';
import 'package:fitoagricola/data/models/property_observation/property_observation.dart';
import 'package:fitoagricola/data/models/property_pest/property_pest.dart';
import 'package:fitoagricola/data/models/property_stage/property_stage.dart';
import 'package:fitoagricola/data/models/property_weed/property_weed.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/tabs/diseases_tab.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/tabs/observation_tab.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/tabs/pests_tab.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/tabs/stage_tab.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/tabs/weeds_tab.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ignore: must_be_immutable
class MonitoringModal extends StatefulWidget {
  PropertyMonitoring? monitoring;
  Crop? crop;
  int cropJoin;
  List<CropJoin> cropsJoin;
  Function(bool) reloadFunction;
  String? date;
  bool isEditing;

  MonitoringModal({
    this.monitoring,
    required this.crop,
    required this.cropJoin,
    required this.reloadFunction,
    required this.cropsJoin,
    required this.isEditing,
    this.date,
    super.key,
  });

  @override
  State<MonitoringModal> createState() => _MonitoringModalState();
}

class _MonitoringModalState extends State<MonitoringModal>
    with SingleTickerProviderStateMixin {
  String currentTab = "stage";
  bool isLoading = true;
  late TabController _tabController;

  String urlForm = ApiRoutes.formMonitoring;

  List<Map<String, dynamic>> stageFields = [];
  List<Map<String, dynamic>> diseasesFields = [];
  List<Map<String, dynamic>> pestsFields = [];
  List<Map<String, dynamic>> weedsFields = [];
  List<Map<String, dynamic>> observationsFields = [];

  List diseasesImages = [];
  List pestsImages = [];
  List weedsImages = [];

  List<InterferenceFactor> diseasesOptions = [];
  List<InterferenceFactor> pestsOptions = [];
  List<InterferenceFactor> weedsOptions = [];

  String stageSubmitState = 'pending';
  String diseaseSubmitState = 'pending';
  String pestSubmitState = 'pending';
  String weedSubmitState = 'pending';
  String observationSubmitState = 'pending';

  List<int> selectedCrops = [];

  TextEditingController openDate = TextEditingController();

  List tabs = [
    {
      "title": "Estádio",
      "code": "stage",
    },
    {
      "title": "Doenças",
      "code": "disease",
    },
    {
      "title": "Praga",
      "code": "pest",
    },
    {
      "title": "Daninha",
      "code": "weed",
    },
    {
      "title": "Observação",
      "code": "observation",
    },
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    openDate.text = widget.date ?? "";

    Future.delayed(Duration.zero, () {
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(_handleTabSelection);
      getFactorItens();
      initFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isEditing)
                Column(
                  children: [
                    DropdownSearchComponent(
                      label: 'Lavouras',
                      hintText: 'Selecione',
                      style: 'inline',
                      selectedId: null,
                      onChanged: _selectCrop,
                      items: widget.cropsJoin
                          .map<DropdownSearchModel>(
                            (crop) => DropdownSearchModel(
                                id: crop.id,
                                name:
                                    "${crop.crop!.name} ${crop.subharvestName ?? ''}"),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    selectedCrops.length > 0
                        ? SelectedItemList(
                            itemList: selectedCrops
                                .map<Widget>(
                                  (selectedCrop) => SelectedItemComponent(
                                    value: "${widget.cropsJoin.firstWhere(
                                          (crop) => crop.id == selectedCrop,
                                        ).crop!.name} ${widget.cropsJoin.firstWhere(
                                          (crop) => crop.id == selectedCrop,
                                        ).subharvestName ?? ''}",
                                    onItemRemoved: (cropName) {
                                      setState(() {
                                        // selectedCrops.removeWhere(
                                        //   (crop) =>
                                        //       crop ==
                                        //       widget.cropsJoin
                                        //           .firstWhere(
                                        //             (crop) =>
                                        //                 crop.crop!.name ==
                                        //                 cropName,
                                        //           )
                                        //           .id,
                                        // );

                                        selectedCrops.removeWhere(
                                          (crop) => crop == selectedCrop,
                                        );
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 20),
                  ],
                ),
              IgnorePointer(
                ignoring: isSubmiting(),
                child: TabBar(
                  controller: _tabController,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.only(right: 10),
                  labelStyle: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: theme.textTheme.bodyLarge,
                  indicatorColor: theme.colorScheme.secondary,
                  indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 4,
                      ),
                    ),
                  ),
                  tabs: [
                    for (var tab in tabs)
                      Tab(
                        child: Container(
                          height: 35,
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (stateTab(tab['code']) == 'submiting')
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: DefaultCircularIndicator.getIndicator(
                                    size: 15,
                                  ),
                                )
                              else if (stateTab(tab['code']) == 'success')
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: PhosphorIcon(
                                    IconsList.getIcon('check'),
                                    color: appTheme.green400,
                                    size: 16,
                                  ),
                                )
                              else if (stateTab(tab['code']) == 'error')
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: PhosphorIcon(
                                    IconsList.getIcon('x'),
                                    color: appTheme.red600,
                                    size: 16,
                                  ),
                                )
                              else if (stateTab(tab['code']) == 'modified')
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              Text(
                                tab['title'],
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Container(
                // height: 300,
                margin: EdgeInsets.only(top: 20),
                // Adicionando o widget Expanded aqui
                child: Center(
                  child: [
                    getStageTab(),
                    getDiseaseTab(),
                    getPestTab(),
                    getWeedTab(),
                    getObservationTab(),
                  ][_tabController.index],
                ),
              ),
              const SizedBox(height: 20),
              CustomFilledButton(
                text: "Enviar",
                onPressed: _submitFunction,
                isDisabled: isSubmiting(),
              ),
            ],
          );
  }

  void _selectCrop(DropdownSearchModel? newSelectedCrop) {
    if (newSelectedCrop == null) return;

    var cropIndex = selectedCrops.indexOf(newSelectedCrop.id);
    if (cropIndex != -1) return;
    setState(() {
      selectedCrops.add(newSelectedCrop.id);
    });
  }

  String stateTab(String code) {
    switch (code) {
      case 'stage':
        return stageSubmitState;
      case 'disease':
        return diseaseSubmitState;
      case 'pest':
        return pestSubmitState;
      case 'weed':
        return weedSubmitState;
      case 'observation':
        return observationSubmitState;
      default:
        return '';
    }
  }

  bool isSubmiting() {
    return stageSubmitState == 'submiting' ||
        diseaseSubmitState == 'submiting' ||
        pestSubmitState == 'submiting' ||
        weedSubmitState == 'submiting' ||
        observationSubmitState == 'submiting';
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  getFactorItens() async {
    await DefaultRequest.simpleGetRequest(
            '${ApiRoutes.listInterferenceFactorByJoin}/${widget.cropJoin}',
            context,
            showSnackBar: 0)
        .then((value) {
      final data = jsonDecode(value.body);

      if (data['diseases'] != null) {
        diseasesOptions = InterferenceFactor.fromJsonList(data['diseases']);
      }

      if (data['pests'] != null) {
        pestsOptions = InterferenceFactor.fromJsonList(data['pests']);
      }
    });

    await DefaultRequest.simpleGetRequest(
      ApiRoutes.listWeeds,
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      if (data['interference_factors_items'] != null) {
        weedsOptions =
            InterferenceFactor.fromJsonList(data['interference_factors_items']);
      }
    });

    isLoading = false;
    setState(() {});
  }

  initFields() {
    stageFields = _getStageFields();
    diseasesFields = _getDiseasesFields();
    pestsFields = _getPestsFields();
    weedsFields = _getWeedsFields();
    observationsFields = _getObservationsFields();

    selectedCrops.add(widget.cropJoin);

    if (diseasesOptions.isNotEmpty &&
        pestsOptions.isNotEmpty &&
        weedsOptions.isNotEmpty) {
      isLoading = false;
    }

    setState(() {});
  }

  _getStageFields() {
    PropertyStage? stage = widget.monitoring != null &&
            widget.monitoring!.stages != null &&
            widget.monitoring!.stages!.isNotEmpty
        ? widget.monitoring!.stages![0]
        : null;

    var fields = [
      {
        "name": 'id',
        "value": stage != null ? stage.id : 0,
      },
      {
        "name": 'risk',
        "value": stage != null ? stage.risk : 1,
      },
      {
        "name": 'vegetative_age_value',
        "value": stage != null ? stage.vegetativeAgeValue : 0,
      },
      {
        "name": 'vegetative_age_text',
        "controller": TextEditingController(
            text: stage != null ? stage.vegetativeAgeText : ""),
      },
      {
        "name": 'reprodutive_age_value',
        "value": stage != null ? stage.reprodutiveAgeValue : 0,
      },
      {
        "name": 'reprodutive_age_text',
        "controller": TextEditingController(
            text: stage != null ? stage.reprodutiveAgeText : ""),
      },
      {
        "name": 'longitude',
        "value": stage != null && stage.coordinates != null
            ? stage.coordinates['coordinates'][1]
            : 0,
      },
      {
        "name": 'latitude',
        "value": stage != null && stage.coordinates != null
            ? stage.coordinates['coordinates'][0]
            : 0,
      },
      {
        "name": 'images',
        "images": [],
      },
    ];

    if (stage != null && stage.images != null) {
      for (var image in stage.images!) {
        fields[8]['images'].add({
          "id": image.id,
          "image": image.image,
        });
      }
    }

    return fields;
  }

  _getObservationsFields() {
    PropertyObservation? observation = widget.monitoring != null &&
            widget.monitoring!.observations != null &&
            widget.monitoring!.observations!.isNotEmpty
        ? widget.monitoring!.observations![0]
        : null;

    var fields = [
      {
        "name": 'id',
        "value": observation != null ? observation.id : 0,
      },
      {
        "name": 'risk',
        "value": observation != null ? observation.risk : 1,
      },
      {
        "name": 'observations',
        "controller": observation != null
            ? TextEditingController(text: observation.observations)
            : TextEditingController(),
      },
      {
        "name": 'longitude',
        "value": observation != null && observation.coordinates != null
            ? observation.coordinates['coordinates'][1]
            : 0,
      },
      {
        "name": 'latitude',
        "value": observation != null && observation.coordinates != null
            ? observation.coordinates['coordinates'][0]
            : 0,
      },
      {
        "name": 'images',
        "images": [],
      },
    ];

    if (observation != null && observation.images != null) {
      for (var image in observation.images!) {
        fields[5]['images'].add({
          "id": image.id,
          "image": image.image,
        });
      }
    }

    return fields;
  }

  _getDiseasesFields() {
    List<PropertyDisease>? diseases = widget.monitoring != null &&
            widget.monitoring!.diseases != null &&
            widget.monitoring!.diseases!.isNotEmpty
        ? widget.monitoring!.diseases
        : null;

    if (diseases != null) {
      diseasesFields = diseases.map((disease) {
        if (disease.images != null) {
          for (var image in disease.images!) {
            diseasesImages.add({
              "id": image.id,
              "image": image.image,
            });
          }
        }

        return {
          "id": disease.id,
          "interference_factors_item_id": disease.interferenceFactorsItemId,
          "incidency": TextEditingController(
              text: Formatters.formatToBrl(disease.incidency)),
          "risk": disease.risk,
          "longitude": disease.coordinates != null
              ? disease.coordinates['coordinates'][1]
              : 0,
          "latitude": disease.coordinates != null
              ? disease.coordinates['coordinates'][0]
              : 0,
        };
      }).toList();
    } else {
      diseasesFields = [
        {
          "id": 0,
          "interference_factors_item_id": 0,
          "incidency": TextEditingController(),
          "risk": 1,
          "longitude": 0,
          "latitude": 0,
        }
      ];
    }

    return diseasesFields;
  }

  _getPestsFields() {
    List<PropertyPest>? pests = widget.monitoring != null &&
            widget.monitoring!.pests != null &&
            widget.monitoring!.pests!.isNotEmpty
        ? widget.monitoring!.pests
        : null;

    if (pests != null) {
      pestsFields = pests.map((pest) {
        if (pest.images != null) {
          for (var image in pest.images!) {
            pestsImages.add({
              "id": image.id,
              "image": image.image,
            });
          }
        }

        return {
          "id": pest.id,
          "interference_factors_item_id": pest.interferenceFactorsItemId,
          "incidency": TextEditingController(
              text: Formatters.formatToBrl(pest.incidency)),
          "quantity_per_meter": TextEditingController(
              text: Formatters.formatToBrl(pest.quantityPerMeter)),
          "quantity_per_square_meter": TextEditingController(
              text: Formatters.formatToBrl(pest.quantityPerSquareMeter)),
          "risk": pest.risk,
          "longitude":
              pest.coordinates != null ? pest.coordinates['coordinates'][1] : 0,
          "latitude":
              pest.coordinates != null ? pest.coordinates['coordinates'][0] : 0,
        };
      }).toList();
    } else {
      pestsFields = [
        {
          "id": 0,
          "interference_factors_item_id": 0,
          "incidency": TextEditingController(),
          "quantity_per_meter": TextEditingController(),
          "quantity_per_square_meter": TextEditingController(),
          "risk": 1,
          "longitude": 0,
          "latitude": 0,
        }
      ];
    }

    return pestsFields;
  }

  _getWeedsFields() {
    List<PropertyWeed>? weeds = widget.monitoring != null &&
            widget.monitoring!.weeds != null &&
            widget.monitoring!.weeds!.isNotEmpty
        ? widget.monitoring!.weeds
        : null;

    if (weeds != null) {
      weedsFields = weeds.map((weed) {
        if (weed.images != null) {
          for (var image in weed.images!) {
            weedsImages.add({
              "id": image.id,
              "image": image.image,
            });
          }
        }

        return {
          "id": weed.id,
          "interference_factors_item_id": weed.interferenceFactorsItemId,
          "risk": weed.risk,
          "longitude":
              weed.coordinates != null ? weed.coordinates['coordinates'][1] : 0,
          "latitude":
              weed.coordinates != null ? weed.coordinates['coordinates'][0] : 0,
        };
      }).toList();
    } else {
      weedsFields = [
        {
          "id": 0,
          "interference_factors_item_id": 0,
          "risk": 1,
          "longitude": 0,
          "latitude": 0,
        }
      ];
    }

    return weedsFields;
  }

  Widget getStageTab() {
    return StageTab(
      stageFields: stageFields,
      crop: widget.crop,
      updateState: () {
        setState(() {
          stageSubmitState = 'modified';
        });
      },
    );
  }

  Widget getObservationTab() {
    return ObservationTab(
      observationFields: observationsFields,
      crop: widget.crop,
      updateState: () {
        setState(() {
          observationSubmitState = 'modified';
        });
      },
    );
  }

  Widget getDiseaseTab() {
    return DiseasesTab(
      diseasesFields: diseasesFields,
      crop: widget.crop,
      diseasesImages: diseasesImages,
      diseasesOptions: diseasesOptions,
      addDisease: () {
        setState(() {
          diseasesFields.add({
            "id": 0,
            "interference_factors_item_id": 0,
            "incidency": TextEditingController(),
            "risk": 1,
            "longitude": 0,
            "latitude": 0,
          });
        });
      },
      updateState: () {
        setState(() {
          diseaseSubmitState = 'modified';
        });
      },
    );
  }

  Widget getWeedTab() {
    return WeedsTab(
      weedsFields: weedsFields,
      crop: widget.crop,
      weedsImages: weedsImages,
      weedsOptions: weedsOptions,
      addWeed: () {
        setState(() {
          weedsFields.add({
            "id": 0,
            "interference_factors_item_id": 0,
            "risk": 1,
            "longitude": 0,
            "latitude": 0,
          });
        });
      },
      updateState: () {
        setState(() {
          weedSubmitState = 'modified';
        });
      },
    );
  }

  Widget getPestTab() {
    return PestsTab(
      pestsFields: pestsFields,
      crop: widget.crop,
      pestsImages: pestsImages,
      pestsOptions: pestsOptions,
      addPest: () {
        setState(() {
          pestsFields.add({
            "id": 0,
            "interference_factors_item_id": 0,
            "incidency": TextEditingController(),
            "quantity_per_meter": TextEditingController(),
            "quantity_per_square_meter": TextEditingController(),
            "risk": 1,
            "longitude": 0,
            "latitude": 0,
          });
        });
      },
      updateState: () {
        setState(() {
          pestSubmitState = 'modified';
        });
      },
    );
  }

  _submitFunction() async {
    // validando se todos os selects de doenças, pragas e daninhas foram inseridas
    bool showValidateModal = false;
    String text = "";

    if (diseaseSubmitState != 'pending') {
      for (var disease in diseasesFields) {
        if (disease['interference_factors_item_id'] == null ||
            disease['interference_factors_item_id'] == '' ||
            disease['interference_factors_item_id'].toString() == '0') {
          showValidateModal = true;
          if (!text.contains("Doenças")) text += "- Doenças\n";
        }
      }
    }

    if (pestSubmitState != 'pending') {
      for (var pest in pestsFields) {
        if (pest['interference_factors_item_id'] == null ||
            pest['interference_factors_item_id'] == '' ||
            pest['interference_factors_item_id'].toString() == '0') {
          showValidateModal = true;
          if (!text.contains("Pragas")) text += "- Pragas\n";
        }
      }
    }

    if (weedSubmitState != 'pending') {
      for (var weed in weedsFields) {
        if (weed['interference_factors_item_id'] == null ||
            weed['interference_factors_item_id'] == '' ||
            weed['interference_factors_item_id'].toString() == '0') {
          showValidateModal = true;
          if (!text.contains("Daninhas")) text += "- Daninhas\n";
        }
      }
    }

    if (showValidateModal) {
      Dialogs.showGeralDialog(context,
          title: "Campos incorretos",
          text:
              "Verifique se os campos foram corretamente selecionados nas abas:\n\n${text}",
          widget: Column(
            children: [
              CustomFilledButton(
                text: "Entendi",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
      return;
    }

    if (openDate.text.isEmpty ||
        openDate.text.contains('/') ||
        openDate.text.contains('00')) {
      openDate.text =
          Formatters.formatDateString(DateTime.now().toString().split(" ")[0]);
      dynamic hasFilledDate = await Dialogs.showGeralDialog(
        context,
        title: "Inserir data",
        text: "Informa a data do monitoramento",
        widget: Column(
          children: [
            CustomTextFormField(
              openDate,
              "Data",
              "Digite aqui",
              readonly: true,
              tapFunction: () async {
                final DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (newDate != null) {
                  setState(() {
                    openDate.text =
                        Formatters.formatDateString(newDate.toString());
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            CustomFilledButton(
              text: "Concluir",
              onPressed: () {
                if (openDate.text.isNotEmpty) {
                  // formatting date
                  openDate.text = Formatters.formatDateStringEn(openDate.text);

                  Navigator.pop(context, "filled");
                  _submitFunction();
                } else {
                  Navigator.pop(context,
                      "empty"); // Retorna "empty" se o campo estiver vazio
                }
              },
            )
          ],
        ),
      );

      if (hasFilledDate == null ||
          hasFilledDate != "filled" ||
          openDate.text.isEmpty) return;

      if (openDate.text.contains('/')) {
        openDate.text = Formatters.formatDateStringEn(openDate.text);
      }
    }

    Admin admin = PrefUtils().getAdmin();

    String crops = selectedCrops.join(',');

    if (stageSubmitState != 'pending') {
      await _submitStage({
        "admin_id": admin.id.toString(),
        "property_crop_join_id": widget.cropJoin.toString(),
        "open_date": openDate.text,
        "crops": crops,
      });
    }

    if (diseaseSubmitState != 'pending') {
      await _submitDiseases({
        "admin_id": admin.id.toString(),
        "property_crop_join_id": widget.cropJoin.toString(),
        "open_date": openDate.text,
        "crops": crops,
      });
    }

    if (pestSubmitState != 'pending') {
      await _submitPests({
        "admin_id": admin.id.toString(),
        "property_crop_join_id": widget.cropJoin.toString(),
        "open_date": openDate.text,
        "crops": crops,
      });
    }

    if (weedSubmitState != 'pending') {
      await _submitWeeds({
        "admin_id": admin.id.toString(),
        "property_crop_join_id": widget.cropJoin.toString(),
        "open_date": openDate.text,
        "crops": crops,
      });
    }

    if (observationSubmitState != 'pending') {
      await _submitObservations({
        "admin_id": admin.id.toString(),
        "property_crop_join_id": widget.cropJoin.toString(),
        "open_date": openDate.text,
        "crops": crops,
      });
    }

    if (stageSubmitState != 'error' &&
        diseaseSubmitState != 'error' &&
        pestSubmitState != 'error' &&
        weedSubmitState != 'error' &&
        observationSubmitState != 'error') {
      Navigator.pop(context);

      widget.reloadFunction(true);
    }
  }

  _submitStage(Map<String, String> body) async {
    Map<String, String> finalBody = body;

    if (mounted)
      setState(() {
        stageSubmitState = 'submiting';
        _tabController.animateTo(0);
      });

    finalBody['type'] = '1';
    // finalBody['stages'] = [];

    Map<String, dynamic> stage = {};
    List<http.MultipartFile> images = [];
    List imagesOffline = [];
    int imageIndex = 0;

    for (var field in stageFields) {
      if (field['name'] != 'images') {
        if (field['value'] != null) {
          stage[field['name']] = field['value'] is String
              ? field['value']
              : field['value'].toString();
        } else if (field['controller'] != null) {
          stage[field['name']] = field['controller'].text;
        }
      } else {
        for (var image in field['images']) {
          if (image is XFile) {
            // var stream = http.ByteStream(image.openRead());
            // var length = await image.length();
            // Cada imagem é um MultipartFile e nomeada especificamente para ser reconhecida como parte de 'stages'
            var multipartFile = await http.MultipartFile.fromPath(
              'stages_images[$imageIndex]',
              image.path,
              filename: path.basename(image.path),
              contentType: MediaType('image', path.extension(image.path)),
            );
            images.add(multipartFile);
            imagesOffline.add(image);
            imageIndex++;
          }
        }
      }
    }

    finalBody['stages'] = jsonEncode([stage]);

    await DefaultRequest.simplePostRequest(
      urlForm,
      finalBody,
      context,
      showSnackBar: 0,
      isMultipart: true,
      files: images,
      offlineFiles: imagesOffline,
    ).then((value) {
      if (value) {
        if (mounted)
          setState(() {
            stageSubmitState = 'success';
          });
      } else {
        if (mounted)
          setState(() {
            stageSubmitState = 'error';
          });
      }
    }).catchError((error) {
      if (mounted)
        setState(() {
          stageSubmitState = 'error';
        });
    });
  }

  _submitDiseases(Map<String, String> body) async {
    Map<String, String> finalBody = body;

    if (mounted)
      setState(() {
        diseaseSubmitState = 'submiting';
        _tabController.animateTo(1);
      });

    finalBody['type'] = '2';
    List diseases = [];

    for (var disease in diseasesFields) {
      Map<String, dynamic> diseaseBody = {
        "id": disease['id'],
        "interference_factors_item_id": disease['interference_factors_item_id'],
        "incidency": Formatters.formatToBrl(disease['incidency'].text),
        "risk": disease['risk'],
        "latitude": disease['latitude'],
        "longitude": disease['longitude'],
      };

      diseases.add(diseaseBody);
    }

    finalBody['diseases'] = jsonEncode(diseases);

    List<http.MultipartFile> images = [];
    List imagesOffline = [];
    int imageIndex = 0;

    for (var image in diseasesImages) {
      if (image is XFile) {
        try {
          // var stream = http.ByteStream(image.openRead());
          // var length = await image.length();
          // Cada imagem é um MultipartFile e nomeada especificamente para ser reconhecida como parte de 'diseases'

          var multipartFile = await http.MultipartFile.fromPath(
            'diseases_images[$imageIndex]',
            image.path,
            filename: path.basename(image.path),
            contentType: MediaType('image', path.extension(image.path)),
          );
          images.add(multipartFile);
          imagesOffline.add(image);
        } catch (e) {}
      }
    }

    await DefaultRequest.simplePostRequest(
      urlForm,
      finalBody,
      context,
      showSnackBar: 0,
      isMultipart: true,
      files: images,
      offlineFiles: imagesOffline,
    ).then((value) {
      if (value) {
        if (mounted)
          setState(() {
            diseaseSubmitState = 'success';
          });
      } else {
        if (mounted)
          setState(() {
            diseaseSubmitState = 'error';
          });
      }
    }).catchError((error) {
      if (mounted)
        setState(() {
          diseaseSubmitState = 'error';
        });
    });
  }

  _submitPests(Map<String, String> body) async {
    Map<String, String> finalBody = body;

    if (mounted)
      setState(() {
        pestSubmitState = 'submiting';
        _tabController.animateTo(2);
      });

    finalBody['type'] = '3';
    List pests = [];

    for (var pest in pestsFields) {
      Map<String, dynamic> pestBody = {
        "id": pest['id'],
        "interference_factors_item_id": pest['interference_factors_item_id'],
        "incidency": Formatters.formatToBrl(pest['incidency'].text),
        "quantity_per_meter":
            Formatters.formatToBrl(pest['quantity_per_meter'].text),
        "quantity_per_square_meter":
            Formatters.formatToBrl(pest['quantity_per_square_meter'].text),
        "risk": pest['risk'],
        "latitude": pest['latitude'],
        "longitude": pest['longitude'],
      };

      pests.add(pestBody);
    }

    finalBody['pests'] = jsonEncode(pests);

    List<http.MultipartFile> images = [];
    List imagesOffline = [];
    int imageIndex = 0;

    for (var image in pestsImages) {
      if (image is XFile) {
        // var stream = http.ByteStream(image.openRead());
        // var length = await image.length();
        // Cada imagem é um MultipartFile e nomeada especificamente para ser reconhecida como parte de 'pests'
        var multipartFile = await http.MultipartFile.fromPath(
          'pests_images[$imageIndex]', // Isso vai permitir que você acesse as imagens como parte do objeto pests no Laravel
          image.path,
          filename: path.basename(image.path),
          contentType: MediaType('image', path.extension(image.path)),
        );
        images.add(multipartFile);
        imagesOffline.add(image);
        imageIndex++;
      }
    }

    await DefaultRequest.simplePostRequest(
      urlForm,
      finalBody,
      context,
      showSnackBar: 0,
      isMultipart: true,
      files: images,
      offlineFiles: imagesOffline,
    ).then((value) {
      if (value) {
        if (mounted)
          setState(() {
            pestSubmitState = 'success';
          });
      } else {
        if (mounted)
          setState(() {
            pestSubmitState = 'error';
          });
      }
    }).catchError((error) {
      if (mounted)
        setState(() {
          pestSubmitState = 'error';
        });
    });
  }

  _submitWeeds(Map<String, String> body) async {
    Map<String, String> finalBody = body;

    if (mounted)
      setState(() {
        weedSubmitState = 'submiting';
        _tabController.animateTo(3);
      });

    finalBody['type'] = '4';
    List weeds = [];

    for (var weed in weedsFields) {
      Map<String, dynamic> weedBody = {
        "id": weed['id'],
        "interference_factors_item_id": weed['interference_factors_item_id'],
        "risk": weed['risk'],
        "latitude": weed['latitude'],
        "longitude": weed['longitude'],
      };

      weeds.add(weedBody);
    }

    finalBody['weeds'] = jsonEncode(weeds);

    List<http.MultipartFile> images = [];
    int imageIndex = 0;
    List imagesOffline = [];
    for (var image in weedsImages) {
      if (image is XFile) {
        // var stream = http.ByteStream(image.openRead());
        // var length = await image.length();
        // Cada imagem é um MultipartFile e nomeada especificamente para ser reconhecida como parte de 'weeds'
        var multipartFile = await http.MultipartFile.fromPath(
          'weeds_images[$imageIndex]', // Isso vai permitir que você acesse as imagens como parte do objeto weeds no Laravel
          image.path,
          filename: path.basename(image.path),
          contentType: MediaType('image', path.extension(image.path)),
        );
        images.add(multipartFile);
        imagesOffline.add(image);
        imageIndex++;
      }
    }

    await DefaultRequest.simplePostRequest(
      urlForm,
      finalBody,
      context,
      showSnackBar: 0,
      isMultipart: true,
      files: images,
      offlineFiles: imagesOffline,
    ).then((value) {
      if (value) {
        if (mounted)
          setState(() {
            weedSubmitState = 'success';
          });
      } else {
        if (mounted)
          setState(() {
            weedSubmitState = 'error';
          });
      }
    }).catchError((error) {
      if (mounted)
        setState(() {
          weedSubmitState = 'error';
        });
    });
  }

  _submitObservations(Map<String, String> body) async {
    Map<String, String> finalBody = body;

    if (mounted)
      setState(() {
        observationSubmitState = 'submiting';
        _tabController.animateTo(4);
      });

    finalBody['type'] = '5';

    Map<String, dynamic> observation = {};
    List<http.MultipartFile> images = [];
    List imagesOffline = [];
    int imageIndex = 0;

    for (var field in observationsFields) {
      if (field['name'] != 'images') {
        if (field['value'] != null) {
          observation[field['name']] = field['value'] is String
              ? field['value']
              : field['value'].toString();
        } else if (field['controller'] != null) {
          observation[field['name']] = field['controller'].text;
        }
      } else {
        for (var image in field['images']) {
          if (image is XFile) {
            // var stream = http.ByteStream(image.openRead());
            // var length = await image.length();
            // Cada imagem é um MultipartFile e nomeada especificamente para ser reconhecida como parte de 'observations'
            var multipartFile = await http.MultipartFile.fromPath(
              'observations_images[$imageIndex]', // Isso vai permitir que você acesse as imagens como parte do objeto observations no Laravel
              image.path,
              filename: path.basename(image.path),
              contentType: MediaType('image', path.extension(image.path)),
            );
            images.add(multipartFile);
            imagesOffline.add(image);
            imageIndex++;
          }
        }
      }
    }

    finalBody['observations'] = jsonEncode([observation]);

    await DefaultRequest.simplePostRequest(
      urlForm,
      finalBody,
      context,
      showSnackBar: 0,
      isMultipart: true,
      files: images,
      offlineFiles: imagesOffline,
    ).then((value) {
      if (value) {
        if (mounted)
          setState(() {
            observationSubmitState = 'success';
          });
      } else {
        if (mounted)
          setState(() {
            observationSubmitState = 'error';
          });
      }
    }).catchError((error) {
      if (mounted)
        setState(() {
          observationSubmitState = 'error';
        });
    });
  }
}
