import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/reports/input/input_report.dart';
import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:fitoagricola/widgets/tables/table.dart';
import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputsCollapsableTable extends StatefulWidget {
  const InputsCollapsableTable({
    required this.report,
    required this.visualizationType,
    required this.rowWidth,
    super.key,
  });
  final InputReport report;
  final int visualizationType;
  final double rowWidth;

  @override
  State<InputsCollapsableTable> createState() => _InputsCollapsableTableState();
}

class _InputsCollapsableTableState extends State<InputsCollapsableTable> {
  final doubleFormatter = NumberFormat.decimalPattern();
  final dateFormatter = DateFormat('dd/MM/yyyy');
  final List<DataColumn> collapsableTableCols = [];
  final List<DataRow> rows = [];

  @override
  void initState() {
    super.initState();
    collapsableTableCols.addAll([
      if (widget.visualizationType == 1) TableElements.getDataColumn('Data'),
      TableElements.getDataColumn('Tipo'),
      TableElements.getDataColumn('Produto'),
      TableElements.getDataColumn('Dose/ha'),
      TableElements.getDataColumn('Quantidade'),
    ]);
    rows.addAll(
      widget.report.mergedDataInput!
          .map<DataRow>(
            (dataInput) => DataRow(
              cells: [
                if (widget.visualizationType == 1)
                  TableElements.getDataCell(
                    dateFormatter.format(dataInput.date ?? DateTime.now()),
                  ),
                TableElements.getDataCell(
                  dataInput.type != null
                      ? dataInput.type == 1
                          ? 'Fertilizante'
                          : getProductType(dataInput.product != null
                              ? dataInput.product!.objectType
                              : 1)
                      : 'Sementes',
                ),
                TableElements.getDataCell(dataInput.product?.name ?? '--'),
                TableElements.getDataCell(
                  dataInput.type != null
                      ? dataInput.dosage
                      : dataInput.kilogramPerHa,
                ),
                TableElements.getDataCell(
                  Formatters.formatToBrl(
                    widget.visualizationType != 3
                        ? dataInput.type != null
                            ? doubleFormatter.parse(dataInput.dosage!) *
                                (widget.report.crop != null
                                    ? doubleFormatter
                                        .parse(widget.report.crop!.area!)
                                    : 0)
                            : doubleFormatter.parse(dataInput.kilogramPerHa!) *
                                (widget.report.crop != null
                                    ? doubleFormatter
                                        .parse(widget.report.crop!.area!)
                                    : 0)
                        : dataInput.totalDosage ?? 0,
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
    rows.add(
      DataRow(
        cells: [
          if (widget.visualizationType == 1)
            TableElements.getDataCell(
              SizedBox(width: 150),
              isText: 0,
            ),
          TableElements.getDataCell(
            SizedBox(width: 150),
            isText: 0,
          ),
          TableElements.getDataCell('TOTAL'),
          TableElements.getDataCell(
            Formatters.formatToBrl(widget.report.sumDosages),
          ),
          TableElements.getDataCell(
            Formatters.formatToBrl(widget.visualizationType != 3
                ? widget.report.sumDosages ??
                    0 *
                        (widget.report.crop != null
                            ? double.parse(widget.report.crop!.area!)
                            : 0)
                : widget.report.totalProducts ?? 0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.rowWidth,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: appTheme.green400,
            width: 1,
          ),
        ),
      ),
      child: TableComponent(
        borderWidth: 1,
        needsStretch: true,
        isScrollable: false,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Color(0xFFE7E7E7),
        ),
        columns: collapsableTableCols,
        rows: rows,
      ),
    );
  }

  String getProductType(int? type) {
    switch (type) {
      case 1:
        return 'Adjuvante';
      case 2:
        return 'Biológico';
      case 3:
        return 'Fertilizante foliar';
      case 4:
        return 'Fungicida';
      case 5:
        return 'Herbicida';
      case 6:
        return 'Inseticida';
      default:
        return 'Adjuvante';
    }
  }
}
