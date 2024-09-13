import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TableElements {
  static String _getLegend(String text) {
    if (text.contains('DAP')) {
      return 'Dias após plantio';
    }

    if (text.contains('DAE')) {
      return 'Dias após emergência';
    }

    if (text.contains('DAA')) {
      return 'Dias após aplicação';
    }

    if (text.contains('DEPPA')) {
      return 'Dias entre plantio e primeira aplicação';
    }

    if (text.contains('DEPUA')) {
      return 'Dias entre plantio e última aplicação';
    }

    return '';
  }

  static Widget _getCellChildren(String text, isVertical) {
    String textLegend = _getLegend(text);

    Widget textWidget = Text(
      text,
      style: theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: isVertical ? 12 : 14,
      ),
    );

    if (textLegend != '') {
      return Tooltip(
        message: textLegend,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        triggerMode: TooltipTriggerMode.tap,
        child: Row(
          children: [
            textWidget,
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: PhosphorIcon(
                IconsList.getIcon('info'),
                size: 16,
                color: theme.colorScheme.secondary,
              ),
            )
          ],
        ),
      );
    }

    return textWidget;
  }

  static DataCell getDataCell(
    dynamic children, {
    int isText = 1,
    bool isVertical = false,
  }) {
    return DataCell(
      isText == 1
          ? Text(
              children is String ? children : children.toString(),
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: isVertical ? 12 : 14,
              ),
            )
          : children,
    );
  }

  static DataColumn getDataColumn(
    dynamic children, {
    icon = '',
    bool isVertical = false,
    int isText = 1,
  }) {
    return DataColumn(
      label: isText == 1
          ? Row(
              children: [
                if (icon != "")
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: PhosphorIcon(
                      IconsList.getIcon(icon),
                      size: 20,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                _getCellChildren(children, isVertical),
              ],
            )
          : children,
    );
  }

  static Widget getIconButton(
    String text,
    String icon,
    Function() onPressed, {
    bool isVertical = false,
  }) {
    final iconButton = IconButton(
      visualDensity: VisualDensity(
        vertical: isVertical ? -4 : -3,
        horizontal: isVertical ? -4 : -3,
      ),
      padding: EdgeInsets.zero,
      iconSize: isVertical ? 15 : 20,
      icon: PhosphorIcon(
        IconsList.getIcon(icon),
      ),
      color: icon == 'trash' ? appTheme.red600 : appTheme.gray400,
      onPressed: onPressed,
      tooltip: icon == "user" ? null : text,
    );

    return icon == "user"
        ? Tooltip(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: PhosphorIcon(
                IconsList.getIcon(icon),
                color: appTheme.gray400,
                size: isVertical ? 15 : 20,
              ),
            ),
            message: text,
            triggerMode: TooltipTriggerMode.tap,
            waitDuration: Duration(milliseconds: 0),
          )
        : iconButton;
  }

  static Widget getPaginateButtons(
    totalPages,
    currentPage,
    updatePage,
  ) {
    int divisionPages = (totalPages! / 20).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: currentPage != 1
                ? () {
                    updatePage!(currentPage! - 1);
                  }
                : null,
            child: Container(
              alignment: Alignment.center,
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "<",
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          for (int i = 1; i <= divisionPages; i++)
            if (i < 4 || i == currentPage || i == divisionPages)
              Row(
                children: [
                  GestureDetector(
                    onTap: currentPage != i
                        ? () {
                            updatePage!(i);
                          }
                        : () {},
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: currentPage == i
                            ? theme.colorScheme.secondary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        i.toString(),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: currentPage == i
                              ? Colors.white
                              : theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else if ((currentPage != 4 && i == 4) ||
                (currentPage! > 3 &&
                    currentPage! < divisionPages &&
                    i == (currentPage! + 1)))
              Container(
                margin: EdgeInsets.only(right: 5),
                alignment: Alignment.center,
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '...',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
          GestureDetector(
            onTap: currentPage != divisionPages
                ? () {
                    updatePage!(currentPage! + 1);
                  }
                : null,
            child: Container(
              alignment: Alignment.center,
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                ">",
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
