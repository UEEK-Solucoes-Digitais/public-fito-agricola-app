import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/data_harvest/data_harvest.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HarvestList extends StatelessWidget {
  dynamic itens;
  Crop crop;
  Function(int) deleteFunction;
  Function(dynamic) openAddModal;

  HarvestList(
      {required this.itens,
      required this.crop,
      required this.deleteFunction,
      required this.openAddModal,
      key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataHarvests = DataHarvest.fromJsonList(itens);

    return TableComponent(
      isVertical: true,
      columns: [
        TableElements.getDataColumn(
          'Data',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Produção total (kg)',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Cultivar',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Lavoura (${PrefUtils().getAreaUnit()})',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Produtividade (kg)',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Produtividade (sc)',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Ações',
          isVertical: true,
        ),
      ],
      rows: [
        for (var dataHarvest in dataHarvests)
          DataRow(
            cells: [
              TableElements.getDataCell(
                Formatters.formatDateString(
                  dataHarvest.date,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  dataHarvest.totalProduction,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                dataHarvest.dataSeed != null
                    ? dataHarvest.dataSeed?.productVariant
                    : '--',
                isVertical: true,
              ),
              TableElements.getDataCell(
                "${Formatters.formatToBrl(
                  dataHarvest.dataSeed != null
                      ? dataHarvest.dataSeed!.area!
                      : crop.area!,
                )} ${PrefUtils().getAreaUnit()}",
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  dataHarvest.productivity,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  dataHarvest.productivity / 60,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Row(
                  children: [
                    TableElements.getIconButton(
                      dataHarvest.systemLog != null &&
                              dataHarvest.systemLog!['admin'] != null
                          ? dataHarvest.systemLog!['admin']!['name']!
                          : '--',
                      "user",
                      () {},
                      isVertical: true,
                    ),
                    TableElements.getIconButton(
                      "Editar lançamento",
                      "pencil-simple",
                      () {
                        openAddModal(dataHarvest);
                      },
                      isVertical: true,
                    ),
                    TableElements.getIconButton(
                      "Remover lançamento",
                      "trash",
                      () {
                        deleteFunction(dataHarvest.id);
                      },
                      isVertical: true,
                    )
                  ],
                ),
                isText: 0,
              ),
            ],
          ),
      ],
    );
  }
}
