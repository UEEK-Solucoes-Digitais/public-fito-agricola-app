import 'dart:async';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/asset/Asset.dart';
import 'package:fitoagricola/presentation/assets_screen/components/asset_form.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/fullscreen_image.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: must_be_immutable
class AssetsTable extends StatefulWidget {
  Function() getAssets;
  List<Asset> assets;
  bool isLoading;
  Function(List<Map<String, dynamic>>) submitForm;

  AssetsTable({
    required this.getAssets,
    required this.isLoading,
    required this.assets,
    required this.submitForm,
    super.key,
  });

  @override
  State<AssetsTable> createState() => _AssetsTableState();
}

class _AssetsTableState extends State<AssetsTable> {
  Admin admin = PrefUtils().getAdmin();

  TextEditingController searchController = TextEditingController();
  Timer? searchDebounce;
  String lastSearchText = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
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
    return widget.isLoading
        ? DefaultCircularIndicator.getIndicator()
        : _buildTable();
  }

  void _onSearchChanged() {
    if (searchController.text == lastSearchText) {
      return; // Não faz nada se o texto não mudou
    }

    if (searchDebounce?.isActive ?? false) searchDebounce?.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 500), () {
      lastSearchText = searchController.text;

      setState(() {});
    });
  }

  _buildTable() {
    return Column(
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
            'Pesquisar bem',
            icon: 'magnifying-glass',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 30,
          ),
          child: TableComponent(columns: [
            TableElements.getDataColumn('Nome do bem'),
            TableElements.getDataColumn('Tipo'),
            TableElements.getDataColumn('Valor aproximado'),
            TableElements.getDataColumn('Observações'),
            TableElements.getDataColumn('Cadastrado em'),
            TableElements.getDataColumn('Alocado em'),
            TableElements.getDataColumn('Ações'),
          ], rows: [
            for (var asset in lastSearchText == ''
                ? widget.assets
                : widget.assets
                    .where((element) => element.name
                        .toLowerCase()
                        .contains(lastSearchText.toLowerCase()))
                    .toList())
              DataRow(
                cells: [
                  TableElements.getDataCell(
                    Row(
                      children: [
                        if (asset.image != null && asset.image != '')
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                        imageUrl:
                                            "${dotenv.env['IMAGE_URL']}/assets/${asset.image}"),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ImageNetworkComponent.getImageNetwork(
                                  "${dotenv.env['IMAGE_URL']}/assets/${asset.image}",
                                  50,
                                  50,
                                  BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        Text(asset.name),
                      ],
                    ),
                    isText: 0,
                  ),
                  TableElements.getDataCell(asset.type),
                  TableElements.getDataCell(
                      "R\$ ${Formatters.formatToBrl(asset.value)}"),
                  TableElements.getDataCell(asset.observations ?? '--'),
                  TableElements.getDataCell(
                      Formatters.formatDateString(asset.createdAt)),
                  TableElements.getDataCell(asset.propertiesNames),
                  TableElements.getDataCell(
                    Row(
                      children: [
                        TableElements.getIconButton(
                          "Editar bem",
                          'pencil-simple',
                          () {
                            Dialogs.showGeralDialog(
                              context,
                              title: 'Editar bem',
                              widget: AssetForm(
                                asset: asset,
                                submitForm: widget.submitForm,
                              ),
                            );
                          },
                        ),
                        TableElements.getIconButton(
                          "Remover vínculo",
                          "trash",
                          () {
                            Dialogs.showDeleteDialog(
                              context,
                              title: "Remover bem",
                              text:
                                  "Deseja realmente remover o item ${asset.name}?",
                              textButton: "Remover",
                              onClick: () {
                                _removeAsset(asset.id);
                              },
                            );
                          },
                        )
                      ],
                    ),
                    isText: 0,
                  ),
                ],
              ),
          ]),
        ),
      ],
    );
  }

  _removeAsset(int id) {
    DefaultRequest.simplePostRequest(
      ApiRoutes.removeAssets,
      {
        "_method": "put",
        "id": id.toString(),
        "admin_id": admin.id.toString(),
      },
      context,
    ).then((value) {
      widget.getAssets();
    }).catchError((error) {
      print(error);
    });
  }
}
