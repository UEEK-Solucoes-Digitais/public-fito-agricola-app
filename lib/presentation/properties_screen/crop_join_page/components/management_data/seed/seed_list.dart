import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/data_seed/data_seed.dart';
import 'package:fitoagricola/data/models/products/product.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SeedList extends StatelessWidget {
  dynamic itens;
  List<Product> products;
  Function(int) deleteFunction;
  Function(dynamic) openAddModal;
  double totalArea;
  double availableArea;

  SeedList({
    required this.itens,
    required this.products,
    required this.deleteFunction,
    required this.openAddModal,
    required this.totalArea,
    required this.availableArea,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataSeeds = DataSeed.fromJsonList(itens);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: Text(
            "Área total: ${Formatters.formatToBrl(totalArea)} ${PrefUtils().getAreaUnit()}\nÁrea disponível: ${Formatters.formatToBrl(availableArea)} ${PrefUtils().getAreaUnit()}",
            style: theme.textTheme.bodyMedium,
          ),
        ),
        TableComponent(
          isVertical: true,
          columns: [
            TableElements.getDataColumn(
              'Cultura',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Cultivar',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Data',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Área',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              "Kg/${PrefUtils().getAreaUnit()}",
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Espaçamento (m)',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Semente/m',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'PMS',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Sementes/m2',
              isVertical: true,
            ),
            TableElements.getDataColumn(
              "Qtd/${PrefUtils().getAreaUnit()}",
              isVertical: true,
            ),
            TableElements.getDataColumn(
              'Ações',
              isVertical: true,
            ),
          ],
          rows: [
            for (var dataSeed in dataSeeds)
              DataRow(
                cells: [
                  TableElements.getDataCell(
                    dataSeed.product!.name,
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    dataSeed.productVariant!,
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatDateString(
                      dataSeed.date!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.area!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.kilogramPerHa!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.spacing!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.seedPerLinearMeter!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.pms!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.seedPerSquareMeter!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Formatters.formatToBrl(
                      dataSeed.quantityPerHa!,
                    ),
                    isVertical: true,
                  ),
                  TableElements.getDataCell(
                    Row(
                      children: [
                        TableElements.getIconButton(
                          dataSeed.systemLog != null &&
                                  dataSeed.systemLog!['admin'] != null
                              ? dataSeed.systemLog!['admin']!['name']!
                              : '--',
                          "user",
                          () {},
                          isVertical: true,
                        ),
                        TableElements.getIconButton(
                          "Editar lançamento",
                          "pencil-simple",
                          () {
                            openAddModal(dataSeed);
                          },
                          isVertical: true,
                        ),
                        TableElements.getIconButton(
                          "Remover lançamento",
                          "trash",
                          () {
                            deleteFunction(dataSeed.id);
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
        ),
      ],
    );
  }
}
