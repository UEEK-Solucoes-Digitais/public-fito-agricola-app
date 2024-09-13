import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class PropertyDetailTable extends StatelessWidget {
  Property? property;
  Function() reloadFunction;
  Admin admin = PrefUtils().getAdmin();

  PropertyDetailTable(this.property, this.reloadFunction, {super.key});

  @override
  Widget build(BuildContext context) {
    return property == null || property!.crops == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 05),
            child: TableComponent(
              columns: [
                TableElements.getDataColumn('Cultura'),
                TableElements.getDataColumn('Lavoura'),
                TableElements.getDataColumn('Emergência'),
                TableElements.getDataColumn('Plantio'),
                TableElements.getDataColumn('Última aplicação'),
                TableElements.getDataColumn(''),
              ],
              rows: [
                for (var crop in property!.crops!)
                  DataRow(
                    cells: [
                      TableElements.getDataCell(crop.cultureTable ?? '--'),
                      TableElements.getDataCell(
                          "${crop.crop!.name} ${crop.subharvestName ?? ''}"),
                      TableElements.getDataCell(crop.emergencyTable ?? '--'),
                      TableElements.getDataCell(crop.plantTable ?? '--'),
                      TableElements.getDataCell(crop.applicationTable ?? '--'),
                      TableElements.getDataCell(
                        Row(
                          children: [
                            TableElements.getIconButton(
                              "Remover vínculo",
                              "trash",
                              () {
                                Dialogs.showDeleteDialog(
                                  context,
                                  title: "Remover lavoura",
                                  text:
                                      "Deseja realmente remover a lavoura ${crop.crop!.name} do ano agrícola dessa propriedade?",
                                  textButton: "Remover",
                                  onClick: () {
                                    removeCrop(crop.id, context);
                                  },
                                );
                              },
                            )
                          ],
                        ),
                        isText: 0,
                      ),
                    ],
                    onSelectChanged: (value) => {
                      NavigatorService.pushNamed(
                        AppRoutes.cropJoinPage,
                        arguments: {
                          'cropJoinId': crop.id,
                          // 'harvestId': property.harvestId,
                        },
                      )
                    },
                  ),
              ],
            ),
          );
  }

  removeCrop(int id, BuildContext context) {
    DefaultRequest.simplePostRequest(
      ApiRoutes.deleteCropJoin,
      {
        "_method": "put",
        "property_crop_join_id": id.toString(),
        "admin_id": admin.id.toString(),
      },
      context,
    ).then((value) {
      reloadFunction();
    }).catchError((error) {
      print(error);
    });
  }
}
