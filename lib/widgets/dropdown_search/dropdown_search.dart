import 'package:dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DropdownSearchComponent extends StatefulWidget {
  final String label;
  final String hintText;
  final dynamic selectedId;
  final List<DropdownSearchModel> items;
  final String? icon;
  final String? style;
  final Function(DropdownSearchModel)? onChanged;
  final bool validatorFunction;
  final bool showSearch;
  final bool validateZero;

  const DropdownSearchComponent({
    Key? key,
    this.icon,
    this.onChanged,
    this.style = 'primary',
    required this.items,
    required this.label,
    required this.hintText,
    required this.selectedId,
    this.validatorFunction = true,
    this.validateZero = true,
    this.showSearch = true,
  }) : super(key: key);

  @override
  State<DropdownSearchComponent> createState() =>
      _DropdownSearchComponentState();
}

class _DropdownSearchComponentState extends State<DropdownSearchComponent> {
  dynamic selectedId = 0;
  bool isError = false;
  String errorText = "";

  void changeSelectedId(dynamic id) {
    setState(() {
      selectedId = id;
    });
  }

  bool isPrimary() {
    return widget.style == 'primary';
  }

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    final _focusNode = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != ''
            ? Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  widget.label,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: Color(0xFF152536),
                  ),
                ),
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isPrimary() ? 20 : 0),
            // border bottom no else
            border: isPrimary()
                ? Border.all(
                    color:
                        isError ? appTheme.red600 : theme.colorScheme.secondary,
                  )
                : Border(
                    bottom: BorderSide(
                      color: isError ? appTheme.red600 : appTheme.gray400,
                      width: 1,
                    ),
                  ),
          ),
          child: DropdownSearch<DropdownSearchModel>(
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                errorStyle: const TextStyle(height: 0),
                labelText: null,
                errorText: null,
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isPrimary() ? 15 : 0,
                  vertical: 15,
                ),
                border: InputBorder.none,
                prefixIcon: widget.icon != null && widget.icon!.isNotEmpty
                    ? Container(
                        width: 20,
                        child: PhosphorIcon(
                          IconsList.getIcon(widget.icon!),
                          color: theme.colorScheme.secondary,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
            dropdownButtonProps: DropdownButtonProps(
              icon: PhosphorIcon(
                PhosphorIcons.caretDown(),
                color: theme.colorScheme.secondary,
                size: 20,
              ),
            ),
            validator: widget.validatorFunction
                ? (value) {
                    if (value == null ||
                        (value.id == 0 && widget.validateZero) ||
                        value.id == '') {
                      setState(() {
                        isError = true;
                        errorText = "Selecione uma opção";
                      });
                      return '';
                    } else {
                      setState(() {
                        isError = false;
                        errorText = "";
                      });
                    }
                    return null;
                  }
                : null,
            popupProps: PopupProps.menu(
              showSearchBox: widget.showSearch,
              searchDelay: Duration(milliseconds: 500),
              searchFieldProps: TextFieldProps(
                padding: EdgeInsets.symmetric(horizontal: 15),
                focusNode: _focusNode,
                decoration: InputDecoration(
                  errorText: null,
                  hintText: "Pesquise",
                  hintStyle: isPrimary()
                      ? theme.textTheme.bodyMedium
                          ?.copyWith(color: appTheme.gray400)
                      : theme.textTheme.bodyLarge,
                  prefixIcon: Container(
                    width: 20,
                    child: PhosphorIcon(
                      PhosphorIcons.magnifyingGlass(),
                      color: appTheme.gray400,
                      size: 20,
                    ),
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: appTheme.gray300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: appTheme.gray300),
                  ),
                  // contentPadding: EdgeInsets.only(bottom: 8),
                ),
              ),
              menuProps: MenuProps(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: appTheme.gray400,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              scrollbarProps: ScrollbarProps(
                radius: Radius.circular(10),
                thumbColor: theme.colorScheme.secondary,
                trackColor: theme.colorScheme.secondary.withOpacity(0.2),
              ),
              itemBuilder: (context, item, isSelected) {
                return Container(
                  decoration: BoxDecoration(
                    color: item.id == selectedId
                        ? theme.colorScheme.secondary
                        : Colors.transparent,
                    border: Border(
                      top: BorderSide(
                        color: appTheme.gray400,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical:
                          0, // Ajuste o preenchimento vertical conforme necessário
                    ),
                    title: Text(
                      item.name,
                      style: item.id == selectedId
                          ? CustomTextStyles.bodyLargeOnWhite
                          : theme.textTheme.bodyLarge,
                    ),
                    selected: isSelected,
                  ),
                );
              },
              containerBuilder: (context, popupWidget) {
                return FractionallySizedBox(
                  child: Container(
                    padding: EdgeInsets.zero,
                    child: popupWidget,
                  ),
                );
              },
              fit: FlexFit.loose,
              emptyBuilder: (context, searchEntry) => ListTile(
                title: Text(
                  'Nenhum resultado encontrado',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            items: widget.items,
            itemAsString: (DropdownSearchModel item) => item.name,
            onChanged: (value) => {
              changeSelectedId(value!.id),
              if (widget.onChanged != null) {widget.onChanged!(value)}
            },
            selectedItem: widget.selectedId != null &&
                    (widget.selectedId != 0 ||
                        (widget.selectedId == 0 && !widget.validatorFunction))
                ? widget.items.firstWhere(
                    (element) => element.id == widget.selectedId,
                    orElse: () => widget.items.first,
                  )
                : null,
            compareFn: (item1, item2) => item1.id == item2.id,
          ),
        ),
        if (errorText != "")
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorText,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: appTheme.red600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
