import 'dart:async';
import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/presentation/properties_screen/list/components/property_form.dart';
import 'package:fitoagricola/presentation/properties_screen/list/components/property_info.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class PropertyTable extends StatefulWidget {
  const PropertyTable({super.key});

  @override
  State<PropertyTable> createState() => _PropertyTableState();
}

class _PropertyTableState extends State<PropertyTable> {
  bool isLoading = true;
  List<Property> properties = [];
  Admin admin = PrefUtils().getAdmin();

  TextEditingController searchController = TextEditingController();
  Timer? searchDebounce;
  String lastSearchText = '';

  @override
  void initState() {
    super.initState();

    searchController.addListener(_onSearchChanged);

    Future.delayed(Duration.zero, () {
      getProperties();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  top: 10,
                ),
                child: CustomTextFormField(
                  searchController,
                  '',
                  'Pesquisar propriedade',
                  icon: 'magnifying-glass',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 30,
                ),
                child: TableComponent(columns: [
                  TableElements.getDataColumn('Nome da propriedade'),
                  TableElements.getDataColumn('Município'),
                  TableElements.getDataColumn('Proprietário'),
                  TableElements.getDataColumn('Contato'),
                  TableElements.getDataColumn('Nº de lavouras'),
                  TableElements.getDataColumn('Área'),
                  TableElements.getDataColumn('Ações'),
                ], rows: [
                  for (var property in lastSearchText == ''
                      ? properties
                      : properties
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(lastSearchText.toLowerCase()))
                          .toList())
                    DataRow(
                        cells: [
                          TableElements.getDataCell(property.name),
                          TableElements.getDataCell(property.city ?? '--'),
                          TableElements.getDataCell(
                              property.admin?.name ?? '--'),
                          TableElements.getDataCell(
                              property.admin?.phone ?? '--'),
                          TableElements.getDataCell(
                              property.crops?.length.toString() ?? '--'),
                          TableElements.getDataCell(
                            '${property.totalArea} ${PrefUtils().getAreaUnit()}',
                          ),
                          TableElements.getDataCell(
                            Row(
                              children: [
                                TableElements.getIconButton(
                                  "Editar propriedade",
                                  'pencil-simple',
                                  () {
                                    Dialogs.showGeralDialog(
                                      context,
                                      title: 'Editar propriedade',
                                      widget: PropertyForm(
                                        property.id,
                                        getProperties,
                                      ),
                                    );
                                  },
                                ),
                                TableElements.getIconButton(
                                  "Informações gerais",
                                  'info',
                                  () {
                                    Dialogs.showGeralDialog(
                                      context,
                                      title: 'Informações gerais',
                                      widget: PropertyInfo(property.id),
                                    );
                                  },
                                ),
                              ],
                            ),
                            isText: 0,
                          ),
                        ],
                        onSelectChanged: (value) => {
                              NavigatorService.pushNamed(
                                AppRoutes.propertyDetails,
                                arguments: {
                                  'propertyId': property.id,
                                  // 'harvestId': property.harvestId,
                                },
                              )
                            }),
                ]),
              ),
            ],
          );
  }

  void _onSearchChanged() {
    if (searchController.text == lastSearchText) {
      return; // Não faz nada se o texto não mudou
    }

    if (searchDebounce?.isActive ?? false) searchDebounce?.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 500), () {
      lastSearchText = searchController.text;
      setState(() {
        // isLoading = true;
      });
      // SnackbarComponent.showSnackBar(
      //   context,
      //   'loading',
      //   'Filtrando propriedades',
      //   duration: Duration(seconds: 1),
      // );
      // getProperties();
    });
  }

  void getProperties() {
    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listProperties}/${admin.id}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        properties = Property.fromJsonList(data['properties']);
        isLoading = false;
      });
    });
  }
}
