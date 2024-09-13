import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/data_population/data_population.dart';
import 'package:fitoagricola/data/models/data_seed/data_seed.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class PopulationList extends StatelessWidget {
  dynamic itens;
  List<DataSeed> dataSeeds;
  Function(int) deleteFunction;
  Function(dynamic) openAddModal;

  PopulationList(
      {required this.itens,
      required this.dataSeeds,
      required this.deleteFunction,
      required this.openAddModal,
      key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final populations = DataPopulation.fromJsonList(itens);

    return TableComponent(
      isVertical: true,
      columns: [
        TableElements.getDataColumn(
          'Cultivar',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Plantas/m. linear',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Plantas/m2',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Plantas/${PrefUtils().getFullAreaUnit()}',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          "% de emergência",
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Data de emergência',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Qtd/${PrefUtils().getAreaUnit()}',
          isVertical: true,
        ),
        TableElements.getDataColumn(
          'Ações',
          isVertical: true,
        ),
      ],
      rows: [
        for (var population in populations)
          DataRow(
            cells: [
              TableElements.getDataCell(
                dataSeeds
                    .firstWhere(
                        (element) =>
                            element.id ==
                            population.propertyManagementDataSeedId,
                        orElse: () => DataSeed(
                              id: 0,
                              propertiesCropsId: 0,
                              productVariant: "--",
                            ) // Garanta que corresponda ao tipo esperado
                        )
                    .productVariant,
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  population.seedPerLinearMeter,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  population.seedPerSquareMeter,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  population.plantsPerHectare,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  population.emergencyPercentage,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatDateString(
                  population.emergencyPercentageDate,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  population.quantityPerHa,
                ),
                isVertical: true,
              ),
              TableElements.getDataCell(
                Row(
                  children: [
                    TableElements.getIconButton(
                      "Editar lançamento",
                      "pencil-simple",
                      () {
                        openAddModal(population);
                      },
                      isVertical: true,
                    ),
                    TableElements.getIconButton(
                      "Remover lançamento",
                      "trash",
                      () {
                        deleteFunction(population.id);
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
