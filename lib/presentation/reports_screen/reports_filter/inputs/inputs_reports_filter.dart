import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/inputs/reports_inputs_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/date_dap_fields.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputsReportsFilter extends StatefulWidget {
  InputsReportsFilter({
    required this.filters,
    required this.activeFilter,
    required this.onFiltersChanged,
    required this.convertParams,
    required this.isSelectHarvestedActive,
    required this.onChangeSelectHarvested,
    super.key,
  });

  final ReportFilters filters;
  final ReportsFilterParams? activeFilter;
  final Function(ReportsFilterParams?) onFiltersChanged;
  final ReportsFilterParams Function(ReportsFilterParams?) convertParams;
  final bool isSelectHarvestedActive;
  final Function(bool? newSelectHarvestedValue) onChangeSelectHarvested;

  @override
  State<InputsReportsFilter> createState() => _InputsReportsFilterState();
}

class _InputsReportsFilterState extends State<InputsReportsFilter> {
  List<DropdownSearchModel> selectedProducts = [];
  DropdownSearchModel? visualizationType = null;

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  var initialDateController = TextEditingController();
  var endDateController = TextEditingController();
  var initialDateDapController = TextEditingController();
  var endDateDapController = TextEditingController();
  DateTime? initialDate;
  DateTime? endDate;
  DateTime? initialDateDap;
  DateTime? endDateDap;

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsInputsFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsInputsFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearchComponent(
          label: 'Produtos',
          hintText: 'Selecione',
          style: 'inline',
          selectedId: null,
          onChanged: (DropdownSearchModel newSelectedProduct) {
            setState(() {
              selectedProducts.add(newSelectedProduct);
            });
          },
          items: widget.filters.products
                  ?.map<DropdownSearchModel>(
                    (property) => DropdownSearchModel(
                        id: property.id, name: property.name),
                  )
                  .toList() ??
              [],
        ),
        const SizedBox(height: 8),
        selectedProducts.length > 0
            ? SelectedItemList(
                itemList: selectedProducts
                    .map<Widget>(
                      (selectedProduct) => SelectedItemComponent(
                        value: selectedProduct.name,
                        onItemRemoved: (productName) {
                          setState(() {
                            selectedProducts.removeWhere(
                              (product) => product.name == productName,
                            );
                          });
                        },
                      ),
                    )
                    .toList(),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 16),
        CustomDateFormField(
          controller: initialDateController,
          labelText: 'Data inicial',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newInitialDateValue) {
            setState(() {
              initialDate = newInitialDateValue;
              if (newInitialDateValue == null) {
                initialDateController.text = '';
                return;
              }
              initialDateController.text =
                  dateFormat.format(newInitialDateValue);
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDateFormField(
          controller: endDateController,
          labelText: 'Data final',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newEndDateValue) {
            setState(() {
              endDate = newEndDateValue;
              if (newEndDateValue == null) {
                endDateController.text = '';
                return;
              }
              endDateController.text = dateFormat.format(newEndDateValue);
            });
          },
        ),
        // const SizedBox(height: 16),
        // CustomDateFormField(
        //   controller: initialDateDapController,
        //   labelText: 'Data inicial (DAP)',
        //   hintText: 'dd/mm/aaaa',
        //   onDateChanged: (newInitialDateDapValue) {
        //     setState(() {
        //       initialDateDap = newInitialDateDapValue;
        //       if (newInitialDateDapValue == null) {
        //         initialDateDapController.text = '';
        //         return;
        //       }
        //       initialDateDapController.text =
        //           dateFormat.format(newInitialDateDapValue);
        //     });
        //   },
        // ),
        // const SizedBox(height: 16),
        // CustomDateFormField(
        //   controller: endDateDapController,
        //   labelText: 'Data final (DAP)',
        //   hintText: 'dd/mm/aaaa',
        //   onDateChanged: (newEndDateDapValue) {
        //     setState(() {
        //       endDateDap = newEndDateDapValue;
        //       if (newEndDateDapValue == null) {
        //         endDateDapController.text = '';
        //         return;
        //       }
        //       endDateDapController.text = dateFormat.format(newEndDateDapValue);
        //     });
        //   },
        // ),
        DateDapFields(
          initialDateDapController: initialDateDapController,
          endDateDapController: endDateDapController,
          onChangedInitialDateDap: (newInitialDateDapValue) {
            setState(() {
              initialDateDap = newInitialDateDapValue;
              if (newInitialDateDapValue == null) {
                initialDateDapController.text = '';
                return;
              }
              initialDateDapController.text =
                  dateFormat.format(newInitialDateDapValue);
            });
          },
          onChangedEndDateDap: (newEndDateDapValue) {
            setState(() {
              endDateDap = newEndDateDapValue;
              if (newEndDateDapValue == null) {
                endDateDapController.text = '';
                return;
              }
              endDateDapController.text = dateFormat.format(newEndDateDapValue);
            });
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Color.fromRGBO(210, 255, 184, 1),
            ),
          ),
          child: DropdownSearchComponent(
            label: 'Tipo de Visualização',
            hintText: 'Selecione',
            style: 'inline',
            selectedId: visualizationType?.id,
            onChanged: (DropdownSearchModel? newSelectedType) {
              setState(() {
                visualizationType = newSelectedType;
              });
            },
            items: [
              DropdownSearchModel(id: 1, name: 'Data'),
              DropdownSearchModel(id: 2, name: 'Produto por lavoura'),
              DropdownSearchModel(id: 3, name: 'Produto por propriedade'),
            ],
          ),
        ),
        SelectHarvestedComponent(
          value: widget.isSelectHarvestedActive,
          onChanged: widget.onChangeSelectHarvested,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var inputFilter = ReportsInputsFilterParams(
              productsId: _productToParams(),
              initialDate: initialDate,
              endDate: endDate,
              initialDateDap: initialDateDap,
              endDateDap: endDateDap,
              visualizationType: visualizationType?.id,
            );

            var activeFilter = widget.convertParams(inputFilter);

            widget.onFiltersChanged(
              activeFilter,
            );
          },
        ),
      ],
    );
  }

  String _productToParams() {
    var products = selectedProducts
        .map<int?>(
          (product) => product.id,
        )
        .toList();
    return products.join(',');
  }

  String visualizationIdToName(int? visualizationId) {
    switch (visualizationId) {
      case 3:
        return 'Produto por propriedade';
      case 2:
        return 'Produto por lavoura';
      case 1:
      default:
        return 'Data';
    }
  }

  void _initializeFields(ReportsInputsFilterParams activeFilter) {
    initialDateDapController.text = activeFilter.initialDateDap != null
        ? dateFormat.format(activeFilter.initialDateDap!)
        : '';
    endDateDapController.text = activeFilter.endDateDap != null
        ? dateFormat.format(activeFilter.endDateDap!)
        : '';

    setState(() {
      initialDateDap = activeFilter.initialDateDap;
      endDateDap = activeFilter.endDateDap;
      visualizationType = DropdownSearchModel(
        id: activeFilter.visualizationType ?? 1,
        name: visualizationIdToName(activeFilter.visualizationType),
      );
    });
  }
}
