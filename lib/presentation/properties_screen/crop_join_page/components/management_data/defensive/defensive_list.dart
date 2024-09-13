import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/data_input/data_input.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefensiveList extends StatelessWidget {
  dynamic itens;
  Function(int) deleteFunction;
  Function(dynamic, {int isEdit}) openAddModal;
  Crop crop;

  DefensiveList(
      {required this.itens,
      required this.deleteFunction,
      required this.openAddModal,
      required this.crop,
      key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataInputs = DataInput.fromJsonList(itens);

    return TableComponent(
      columns: [
        TableElements.getDataColumn(
          'Data',
        ),
        TableElements.getDataColumn(
          'N•',
        ),
        TableElements.getDataColumn(
          'Tipo de insumo',
        ),
        TableElements.getDataColumn(
          'Produto',
        ),
        TableElements.getDataColumn(
          "Dose",
        ),
        TableElements.getDataColumn(
          'Total',
        ),
        TableElements.getDataColumn(
          'Ações',
        ),
      ],
      rows: [
        for (var dataInput in dataInputs)
          DataRow(
            cells: [
              TableElements.getDataCell(
                Formatters.formatDateString(
                  dataInput.date!,
                ),
              ),
              TableElements.getDataCell(
                dataInput.applicationNumber!,
              ),
              TableElements.getDataCell(
                Formatters.getProductObjectType(dataInput.product!.objectType!),
              ),
              TableElements.getDataCell(
                dataInput.product!.name,
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  dataInput.dosage!,
                ),
              ),
              TableElements.getDataCell(
                Formatters.formatToBrl(
                  dataInput.dosage! * crop.usedArea!,
                ).replaceAll(',00', ''),
              ),
              TableElements.getDataCell(
                Row(
                  children: [
                    TableElements.getIconButton(
                      dataInput.systemLog != null &&
                              dataInput.systemLog!['admin'] != null
                          ? dataInput.systemLog!['admin']!['name']!
                          : '--',
                      "user",
                      () {},
                    ),
                    TableElements.getIconButton(
                      "Editar lançamento",
                      "pencil-simple",
                      () {
                        openAddModal(dataInput, isEdit: 1);
                      },
                    ),
                    TableElements.getIconButton(
                      "Remover lançamento",
                      "trash",
                      () {
                        deleteFunction(dataInput.id);
                      },
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
