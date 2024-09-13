import 'package:fitoagricola/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class CollapsableTable extends StatefulWidget {
  const CollapsableTable({
    required this.cols,
    required this.rowItems,
    required this.rowBuilder,
    required this.collapsableChildBuilder,
    required this.columnCount,
    required this.rowHeight,
    required this.tableWidth,
    this.mainAxisSpacing = 8,
    this.paginate = false,
    this.currentPage,
    this.totalPages,
    this.updatePage,
    super.key,
  });

  final List<String> cols;
  final List rowItems;
  final int columnCount;
  final double tableWidth;
  final double rowHeight;
  final double mainAxisSpacing;
  final List<Widget> Function(dynamic) rowBuilder;
  final Widget Function(dynamic) collapsableChildBuilder;
  final bool? paginate;
  final int? currentPage;
  final int? totalPages;
  final Function(int)? updatePage;

  @override
  State<CollapsableTable> createState() => _CollapsableTableState();
}

class _CollapsableTableState extends State<CollapsableTable> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: widget.tableWidth,
      child: Column(
        children: widget.rowItems.map(
          (rowItem) {
            final index = widget.rowItems.indexOf(rowItem);
            final heightMultiplier = index == 0 ? 2.5 : 1.75;
            final aspectRatioMultiplier = index == 0 ? 0.2 : 0.15;
            return Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: widget.rowHeight * heightMultiplier,
                  child: GridView.count(
                    crossAxisCount: widget.columnCount,
                    // aumentar de alguma forma o rowWidth
                    childAspectRatio: (widget.tableWidth / widget.rowHeight) *
                        aspectRatioMultiplier,
                    mainAxisSpacing: widget.mainAxisSpacing,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ...index == 0
                          ? widget.cols
                              .map<Widget>(
                                (colName) => Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    colName,
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                          : [],
                      ...widget.rowBuilder(widget.rowItems[index]).map<Widget>(
                        (child) {
                          return Container(
                            padding: EdgeInsets.only(
                                bottom: 8, top: index == 0 ? 0 : 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: const BorderSide(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                                top: index == 0
                                    ? BorderSide.none
                                    : const BorderSide(
                                        width: 1.0,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            height: double.maxFinite,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: child,
                            ),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
                widget.collapsableChildBuilder(widget.rowItems[index]),
                const SizedBox(height: 8),
              ],
            );
          },
        ).toList(),
      ),
      // child: ListView.builder(
      //   itemCount: widget.rowItems.length,
      //   addAutomaticKeepAlives: false,
      //   physics: NeverScrollableScrollPhysics(),
      //   itemBuilder: (context, index) {

      //   },
      // ),
    );
  }

  List<dynamic> removeFirstItem() {
    return widget.rowItems.sublist(1);
  }
}
