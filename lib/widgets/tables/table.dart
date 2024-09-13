import 'package:fitoagricola/widgets/tables/table_elements.dart';
import 'package:flutter/material.dart';

class TableComponent extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool isVertical;
  final bool isScrollable;
  final bool needsStretch;
  final ScrollPhysics? scrollPhysics;
  final Color? borderColor;
  final Decoration? decoration;
  final double? borderWidth;
  final bool? paginate;
  final int? currentPage;
  final int? totalPages;
  final Function(int)? updatePage;
  final EdgeInsetsGeometry? padding;

  const TableComponent({
    Key? key,
    required this.columns,
    required this.rows,
    this.isVertical = false,
    this.borderWidth,
    this.borderColor,
    this.decoration,
    this.paginate = false,
    this.currentPage,
    this.isScrollable = true,
    this.needsStretch = false,
    this.scrollPhysics,
    this.totalPages,
    this.updatePage,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          needsStretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
      children: [
        isVertical
            ? getVerticalTable()
            : isScrollable
                ? SingleChildScrollView(
                    physics: scrollPhysics ?? AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: getDefaultTable(),
                  )
                : getDefaultTable(),
        paginate == true
            ? TableElements.getPaginateButtons(
                totalPages,
                currentPage,
                updatePage,
              )
            : Container()
      ],
    );
  }

  Widget getVerticalTable() {
    return Padding(
      padding: rows.isNotEmpty
          ? const EdgeInsets.only(left: 10, top: 20)
          : const EdgeInsets.all(20),
      child: rows.isNotEmpty
          ? SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(
                          color: Color(0xFFDEE2E6),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var column in columns)
                          Column(
                            children: [
                              column.label,
                              SizedBox(height: 6),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var row in rows)
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  right: BorderSide(
                                    color: Color(0xFFDEE2E6),
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var rowChild in row.cells)
                                    Column(
                                      children: [
                                        rowChild.child,
                                        SizedBox(height: 6),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('Nenhum dado encontrado'),
            ),
      // Stack(
      //   children: [
      //     SingleChildScrollView(
      //       scrollDirection: Axis.horizontal,
      //       child: Padding(
      //         padding: EdgeInsets.only(left: 90),
      //         child: Row(
      //           children: [
      //             Container(
      //               color: Colors.red,
      //               height: 400,
      //               width: 300,
      //             ),
      //             Container(
      //               color: Colors.black,
      //               height: 400,
      //               width: 300,
      //             ),
      //             Container(
      //               color: Colors.purple,
      //               height: 400,
      //               width: 300,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       left: 0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           border: Border(
      //             right: BorderSide(
      //               color: Color(0xFFDEE2E6),
      //             ),
      //           ),
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             for (var column in columns) column.label,
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget getDefaultTable() {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            left: rows.isNotEmpty ? 20 : 10,
            right: rows.isNotEmpty ? 20 : 0,
            bottom: rows.isNotEmpty ? 0 : 20,
          ),
      child: rows.isNotEmpty
          ? DataTable(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: borderColor ?? Color(0xFFc5c5c5),
                  width: borderWidth ?? 0.5,
                ),
              ),
              decoration: decoration,
              horizontalMargin: 0,
              showCheckboxColumn: false,
              columns: columns,
              rows: rows,
            )
          : Center(
              child: Text('Nenhum dado encontrado'),
            ),
    );
  }
}
