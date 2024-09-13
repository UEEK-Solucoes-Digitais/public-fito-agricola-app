import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/data_seed/data_seed.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/defensive/defensive_add.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/defensive/defensive_list.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/defensive/defensive_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/fertilizer/fertilizer_add.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/fertilizer/fertilizer_list.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/fertilizer/fertilizer_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/harvest/harvest_list.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/harvest/harvest_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/population/population_list.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/population/population_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/seed/seed_list.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/management_data/seed/seed_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_export_modal.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/dropdown/dropdown_button_component.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManagementData extends StatefulWidget {
  final int propertyCropJoinId;
  final Crop crop;
  final Function() getPropertyCropJoin;
  final String? pageSubType;

  const ManagementData(
    this.propertyCropJoinId,
    this.crop,
    this.getPropertyCropJoin, {
    this.pageSubType,
    super.key,
  });

  @override
  State<ManagementData> createState() => _ManagementDataState();
}

class _ManagementDataState extends State<ManagementData> {
  int currentTab = 1;
  dynamic itens = [];
  bool isLoading = true;
  Admin admin = PrefUtils().getAdmin();
  List<Product> products = [];
  List<DataSeed> dataSeeds = [];

  TextEditingController dateFinishedController = TextEditingController(
    text: Formatters.formatDateString(DateTime.now().toString().split(" ")[0]),
  );

  double totalArea = 0;
  double usedArea = 0;

  bool isFinishedHarvest = false;
  int finishedHarvestId = 0;

  final formKey = GlobalKey<FormState>();

  final tabs = [
    // seed, population, fertilizer, defensive, harvest
    {
      'id': 1,
      'icon': 'circles-three',
      'code': 'seed',
      'title': 'Sementes',
    },
    {
      'id': 2,
      'icon': 'tree-evergreen',
      'code': 'population',
      'title': 'População',
    },
    {
      'id': 3,
      'icon': 'waves',
      'code': 'fertilizer',
      'title': 'Fertilizantes',
    },
    {
      'id': 4,
      'icon': 'shield-check',
      'code': 'defensive',
      'title': 'Defensivos',
    },
    {
      'id': 5,
      'icon': 'selection',
      'code': 'harvest',
      'title': 'Colheitas',
    },
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getItens();

      if (widget.crop.area != null) {
        totalArea = double.parse(widget.crop.area!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: EdgeInsets.all(10),
            child: DefaultCircularIndicator.getIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: isFinishedHarvest
                  ? [
                      Text("Essa lavoura foi encerrada sem colheita",
                          style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 10),
                      CustomFilledButton(
                        onPressed: () {
                          deleteItem(finishedHarvestId);
                        },
                        text: "Reativar colheita",
                      )
                    ]
                  : [
                      DropdownButtonComponent(
                        itens: tabs,
                        value: currentTab,
                        onChanged: (value) {
                          setState(() {
                            currentTab = value!;
                          });
                          getItens();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: appTheme.gray300,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${tabs.firstWhere((element) => element['id'] == currentTab)['title'].toString()} (${itens.length})",
                                    style: theme.textTheme.displayMedium,
                                  ),
                                  Row(
                                    children: [
                                      if (currentTab == 4)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: CustomActionButton(
                                            icon: 'arrow-square-out',
                                            onTap: () {
                                              Dialogs.showGeralDialog(context,
                                                  title: "Exportar defensivos",
                                                  widget: MonitoringExportModal(
                                                    exportFile: exportFile,
                                                    currentTabCode: '',
                                                  ));
                                            },
                                          ),
                                        ),
                                      if (currentTab == 5)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: CustomActionButton(
                                            icon: 'plant',
                                            onTap: () {
                                              Dialogs.showGeralDialog(
                                                context,
                                                title: "Encerrar sem colheita",
                                                widget: Form(
                                                  key: formKey,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 15),
                                                        child:
                                                            CustomTextFormField(
                                                          dateFinishedController,
                                                          "Data",
                                                          'Digite aqui',
                                                          inputType:
                                                              TextInputType
                                                                  .number,
                                                          formatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            DataInputFormatter()
                                                          ],
                                                        ),
                                                      ),
                                                      CustomFilledButton(
                                                        onPressed: () {
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            _submitFinishedHarvest();
                                                          }
                                                        },
                                                        text: "Enviar",
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      CustomOutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        text: "Cancelar",
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      CustomFilledButton(
                                        text: "+ Adicionar",
                                        onPressed: () {
                                          openAddModal(null);
                                        },
                                        height: 35.v,
                                        width: 100.h,
                                        buttonTextStyle:
                                            CustomTextStyles.bodyMediumWhite,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            getTab(),
                          ],
                        ),
                      ),
                    ],
            ),
          );
  }

  Widget getTab() {
    switch (currentTab) {
      case 1:
        return SeedList(
          itens: itens,
          products: products,
          deleteFunction: deleteItem,
          openAddModal: openAddModal,
          totalArea: totalArea,
          availableArea: totalArea - usedArea,
        );
      case 2:
        return PopulationList(
          itens: itens,
          dataSeeds: dataSeeds,
          deleteFunction: deleteItem,
          openAddModal: openAddModal,
        );
      case 3:
        return FertilizerList(
          itens: itens,
          deleteFunction: deleteItem,
          openAddModal: openAddModal,
          crop: widget.crop,
        );
      case 4:
        return DefensiveList(
          itens: itens,
          deleteFunction: deleteItem,
          openAddModal: openAddModal,
          crop: widget.crop,
        );
      case 5:
        return HarvestList(
          itens: itens,
          crop: widget.crop,
          deleteFunction: deleteItem,
          openAddModal: openAddModal,
        );
      default:
        return Container();
    }
  }

  getItens() {
    setState(() {
      isLoading = true;
      isFinishedHarvest = false;
      finishedHarvestId = 0;
    });

    var code = '';
    if (widget.pageSubType != null &&
        widget.pageSubType != '' &&
        widget.pageSubType != 'null') {
      final tab =
          tabs.firstWhere((element) => element['code'] == widget.pageSubType);
      currentTab = int.parse(tab['id'].toString());
      code = tab['code'].toString();
      setState(() {});
    } else {
      code = tabs
          .firstWhere((element) => element['id'] == currentTab)['code']
          .toString();
    }

    print(code);

    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listManagamentData}/${widget.propertyCropJoinId}/${admin.id}/${code}',
      context,
      showSnackBar: 0,
    ).then((value) {
      print(value);
      final data = jsonDecode(value.body);

      if (data['management_data'] != null &&
          data['products'] != null &&
          data['data_seeds'] != null) {
        itens = data['management_data'];
        products = Product.fromJsonList(data['products']);

        dataSeeds = DataSeed.fromJsonList(data['data_seeds']);

        if (code == 'seed') {
          usedArea = 0;

          for (var item in itens) {
            usedArea += item['area'] is String
                ? double.parse(item['area'])
                : item['area'];
          }
        }

        if (code == 'harvest') {
          for (var item in itens) {
            if (item['without_harvest'] == 1) {
              isFinishedHarvest = true;
              finishedHarvestId = item['id'];
            }
          }
        }

        setState(() {});
      } else {
        SnackbarComponent.showSnackBar(
            context, 'error', 'Ocorreu um erro ao carregar os dados.');
      }
    }).catchError((error) {
      setState(() {
        itens = [];
        products = [];
        dataSeeds = [];
      });

      SnackbarComponent.showSnackBar(
          context, 'error', 'Ocorreu um erro ao carregar os dados.');
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  openAddModal(dynamic item, {int isEdit = 0}) {
    Widget modal = Container();

    switch (currentTab) {
      case 1:
        modal = SeedModal(
          item,
          products,
          submitForm,
          widget.crop,
          totalArea - usedArea,
        );
        break;
      case 2:
        modal = PopulationModal(item, dataSeeds, submitForm);
        break;
      case 3:
        modal = isEdit == 1
            ? FertilizerModal(item, products, submitForm)
            : FertilizerAdd(item, products, submitForm);
        break;
      case 4:
        modal = isEdit == 1
            ? DefensiveModal(item, products, submitForm)
            : DefensiveAdd(item, products, submitForm);
        break;
      case 5:
        modal = HarvestModal(item, dataSeeds, submitForm);
        break;
    }

    Dialogs.showGeralDialog(
      context,
      title: item != null ? "Editar lançamento" : "Adicionar lançamento",
      widget: modal,
    );
  }

  deleteItem(int id) {
    final code =
        tabs.firstWhere((element) => element['id'] == currentTab)['code'];

    Dialogs.showDeleteDialog(
      context,
      title: isFinishedHarvest ? "Reativar colheita" : "Remover lançamento",
      text: isFinishedHarvest
          ? "Deseja reativar a colheita?"
          : "Deseja realmente remover este lançamento?",
      textButton: isFinishedHarvest ? "Reativar colheita" : "Sim, excluir",
      onClick: () {
        DefaultRequest.simplePostRequest(
          '${ApiRoutes.deleteManagamentData}/${code}',
          {
            "_method": "put",
            "id": id.toString(),
            "admin_id": admin.id.toString(),
          },
          context,
        ).then((value) {
          getItens();
          widget.getPropertyCropJoin();
        }).catchError((error) {
          print(error);
        });
      },
    );
  }

  validateArea(fields) {
    double totalArea = 0;

    final areaField = fields.firstWhere((element) => element['name'] == 'area');
    totalArea += double.parse(
        areaField['controller'].text.replaceAll('.', '').replaceAll(',', '.'));

    for (var item in itens) {
      if (item['id'] !=
          fields.firstWhere((element) => element['name'] == 'id')['value']) {
        totalArea += double.parse(item['area']);
      }
    }

    if (totalArea > double.parse(widget.crop.area!)) {
      Navigator.pop(context);
      SnackbarComponent.showSnackBar(context, 'error',
          'A área total das sementes não pode ser maior que a área da lavoura (${Formatters.formatToBrl(double.parse(widget.crop.area!))} ${PrefUtils().getAreaUnit()})');
      return false;
    }

    return true;
  }

  submitForm(dynamic fields, {dynamic productsFields}) {
    final code =
        tabs.firstWhere((element) => element['id'] == currentTab)['code'];

    if (code == "seed" && !validateArea(fields)) {
      return;
    }

    Map<String, dynamic> body = {
      "admin_id": admin.id,
      "properties_crops_id": widget.propertyCropJoinId,
      "type": code,
    };

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

    if (['fertilizer', 'defensive'].contains(code) && productsFields != null) {
      body["products_id"] = [];
      body["dosages"] = [];

      for (var productField in productsFields) {
        body["products_id"].add(productField['product_id']);
        body["dosages"].add(productField['dosage'].text);
      }
    }

    DefaultRequest.simplePostRequest(
      '${ApiRoutes.formManagamentData}',
      body,
      context,
    ).then((value) {
      getItens();
      widget.getPropertyCropJoin();
    }).catchError((error) {
      print(error);
    });
  }

  exportFile(int type) {
    Admin admin = PrefUtils().getAdmin();

    final url =
        "${ApiRoutes.listReports}/${admin.id}/defensives?export=true&export_type=${type}&property_crop_join_id=${widget.propertyCropJoinId}";

    DefaultRequest.exportFile(context, url);
  }

  _submitFinishedHarvest() {
    Map<String, dynamic> body = {
      "admin_id": admin.id,
      "properties_crops_id": widget.propertyCropJoinId,
      "type": 'harvest',
      "date": Formatters.formatDateStringEn(dateFinishedController.text),
      "total_production": 0,
      "without_harvest": 1,
      "id": 0,
    };

    DefaultRequest.simplePostRequest(
      '${ApiRoutes.formManagamentData}',
      body,
      context,
    ).then((value) {
      getItens();
      widget.getPropertyCropJoin();
    }).catchError((error) {
      print(error);
    });
  }
}
