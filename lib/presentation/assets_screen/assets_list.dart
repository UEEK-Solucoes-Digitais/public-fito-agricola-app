import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/asset/Asset.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/presentation/assets_screen/components/asset_form.dart';
import 'package:fitoagricola/presentation/assets_screen/components/assets_table.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_export_modal.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/page_header/page_header.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class AssetsList extends StatefulWidget {
  const AssetsList({super.key});

  @override
  State<AssetsList> createState() => _AssetsListState();
}

class _AssetsListState extends State<AssetsList> {
  Admin admin = PrefUtils().getAdmin();
  int propertyId = 0;
  bool isLoading = true;
  List<Asset> assets = [];
  List<Property> properties = [];
  bool needsToUpdate = false;

  initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getAssets();
      needsToUpdate = PrefUtils().needsToUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: needsToUpdate ? null : _buildAppBar(context),
        body: needsToUpdate
            ? UpdateWidget()
            : SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(shrinkWrap: true, children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 30,
                            right: 20,
                            bottom: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PageHeader(
                                title: 'Bens',
                                text:
                                    'Todas os bens cadastrados no sistema estão listados abaixo. Para editar, clique no botão com lápis',
                                icon: 'car',
                                buttons: [
                                  CustomActionButton(
                                    icon: 'faders',
                                    backgroundColor: Colors.transparent,
                                    iconColor: theme.colorScheme.primary,
                                    borderColor: theme.colorScheme.primary,
                                    onTap: () async {
                                      if (properties.isEmpty) {
                                        await _getProperties().then((value) {
                                          print(value);
                                          if (value) {
                                            _openFilterModal();
                                          }
                                        });
                                      } else {
                                        _openFilterModal();
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  CustomActionButton(
                                    icon: 'arrow-square-out',
                                    backgroundColor: Colors.transparent,
                                    iconColor: theme.colorScheme.primary,
                                    borderColor: theme.colorScheme.primary,
                                    onTap: () {
                                      Dialogs.showGeralDialog(
                                        context,
                                        title: "Exportar bens",
                                        widget: MonitoringExportModal(
                                          exportFile: exportFile,
                                          currentTabCode: '',
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  CustomActionButton(
                                    icon: 'plus',
                                    onTap: () {
                                      Dialogs.showGeralDialog(
                                        context,
                                        title: 'Adicionar bem',
                                        widget: AssetForm(
                                          asset: null,
                                          submitForm: _submitForm,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        AssetsTable(
                          getAssets: _getAssets,
                          isLoading: isLoading,
                          assets: assets,
                          submitForm: _submitForm,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
        drawer: needsToUpdate ? null : DrawerComponent(),
      ),
    );
  }

  _submitForm(List<Map<String, dynamic>> fields) async {
    Map<String, String> body = {
      'admin_id': admin.id.toString(),
    };

    List<http.MultipartFile> files = [];
    List filesOffline = [];

    for (var field in fields) {
      if (field['controller'] != null) {
        body[field['name']] = field['name'] == 'buy_date'
            ? Formatters.formatDateStringEn(field['controller'].text)
            : field['controller'].text.toString().replaceAll("R\$ ", "");
      } else if (field['name'] == 'image' &&
          field['image'] != null &&
          field['image'] != '' &&
          field['image'] is String == false) {
        files.add(await http.MultipartFile.fromPath(
          'image',
          field['image'].path,
          filename: path.basename(field['image'].path),
          contentType: MediaType('image', path.extension(field['image'].path)),
        ));

        filesOffline.add(field['image']);
      } else if (field['value'] != null) {
        body[field['name']] = field['name'] == 'properties'
            ? field['value'].join(',')
            : field['value'].toString();
      }
    }

    Navigator.pop(context);

    DefaultRequest.simplePostRequest(
      ApiRoutes.formAssets,
      body,
      context,
      isMultipart: true,
      files: files,
      offlineFiles: filesOffline,
    ).then((value) {
      if (value) {
        _getAssets();
      }
    }).catchError((error) {
      print(error);
    });
  }

  _getAssets() {
    setState(() {
      isLoading = true;
    });

    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listAssets}/${admin.id}${propertyId != 0 ? '?property=${propertyId}' : ''}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      assets = Asset.fromJsonList(data['assets']);
      isLoading = false;
      setState(() {});
    });
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return BaseAppBar();
  }

  exportFile(int type) {
    Admin admin = PrefUtils().getAdmin();

    final url =
        "${ApiRoutes.listReports}/${admin.id}/assets?property_id=${propertyId}&export=true&export_type=${type}";

    DefaultRequest.exportFile(context, url);
  }

  Future<bool> _getProperties() async {
    final response = await DefaultRequest.simpleGetRequest(
      "${ApiRoutes.listProperties}/${admin.id}",
      context,
      showSnackBar: 1,
      durationSnackbar: 3,
    );
    final data = jsonDecode(response.body);

    if (data['properties'] != null) {
      setState(() {
        properties = Property.fromJsonList(data['properties']);
      });

      return true;
    }

    return false;
  }

  _openFilterModal() {
    Dialogs.showGeralDialog(
      context,
      title: "Filtrar bens",
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: DropdownSearchComponent(
              items: properties
                  .map((e) => DropdownSearchModel(id: e.id, name: e.name))
                  .toList(),
              label: 'Propriedade',
              hintText: 'Selecione a propriedade',
              selectedId: propertyId,
              style: 'inline',
              onChanged: (value) {
                setState(() {
                  propertyId = value.id;
                });

                _getAssets();
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
