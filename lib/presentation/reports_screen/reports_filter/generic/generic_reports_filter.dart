import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/generic/reports_generic_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/date_dap_fields.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenericReportsFilter extends StatefulWidget {
  GenericReportsFilter({
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
  State<GenericReportsFilter> createState() => _GenericReportsFilterState();
}

class _GenericReportsFilterState extends State<GenericReportsFilter> {
  TextEditingController initialDateDapController = new TextEditingController();
  TextEditingController endDateDapController = new TextEditingController();
  TextEditingController initialDateDaeController = new TextEditingController();
  TextEditingController endDateDaeController = new TextEditingController();
  TextEditingController initialDateDaaController = new TextEditingController();
  TextEditingController endDateDaaController = new TextEditingController();

  DateTime? initialDateDap;
  DateTime? endDateDap;
  DateTime? initialDateDae;
  DateTime? endDateDae;
  DateTime? initialDateDaa;
  DateTime? endDateDaa;

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsGenericFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsGenericFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDateFormField(
          controller: initialDateDaeController,
          labelText: 'Data inicial (DAE)',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newInitialDateDaeValue) {
            setState(() {
              initialDateDae = newInitialDateDaeValue;
              if (newInitialDateDaeValue == null) {
                initialDateDaeController.text = '';
                return;
              }
              initialDateDaeController.text =
                  dateFormat.format(newInitialDateDaeValue);
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDateFormField(
          controller: endDateDaeController,
          labelText: 'Data final (DAE)',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newEndDateDaeValue) {
            setState(() {
              endDateDae = newEndDateDaeValue;
              if (newEndDateDaeValue == null) {
                endDateDaeController.text = '';
                return;
              }
              endDateDaeController.text = dateFormat.format(newEndDateDaeValue);
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDateFormField(
          controller: initialDateDaaController,
          labelText: 'Data inicial (DAA)',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newInitialDateDaaValue) {
            setState(() {
              initialDateDaa = newInitialDateDaaValue;
              if (newInitialDateDaaValue == null) {
                initialDateDaaController.text = '';
                return;
              }
              initialDateDaaController.text =
                  dateFormat.format(newInitialDateDaaValue);
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDateFormField(
          controller: endDateDaaController,
          labelText: 'Data final (DAA)',
          hintText: 'dd/mm/aaaa',
          onDateChanged: (newEndDateDaaValue) {
            setState(() {
              endDateDaa = newEndDateDaaValue;
              if (newEndDateDaaValue == null) {
                endDateDaaController.text = '';
                return;
              }
              endDateDaaController.text = dateFormat.format(newEndDateDaaValue);
            });
          },
        ),
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
        SelectHarvestedComponent(
          value: widget.isSelectHarvestedActive,
          onChanged: widget.onChangeSelectHarvested,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var genericFilter = ReportsGenericFilterParams(
              initialDateDap: initialDateDap,
              initialDateDae: initialDateDae,
              endDateDap: endDateDap,
              endDateDae: endDateDae,
              initialDateDaa: initialDateDaa,
              endDateDaa: endDateDaa,
            );
            var activeFilter = widget.convertParams(genericFilter);

            widget.onFiltersChanged(
              activeFilter,
            );
          },
        ),
      ],
    );
  }

  void _initializeFields(ReportsGenericFilterParams activeFilter) {
    initialDateDaeController.text = activeFilter.initialDateDae != null
        ? dateFormat.format(activeFilter.initialDateDae!)
        : '';
    endDateDaeController.text = activeFilter.endDateDae != null
        ? dateFormat.format(activeFilter.endDateDae!)
        : '';
    initialDateDaaController.text = activeFilter.initialDateDaa != null
        ? dateFormat.format(activeFilter.initialDateDaa!)
        : '';
    endDateDaaController.text = activeFilter.endDateDaa != null
        ? dateFormat.format(activeFilter.endDateDaa!)
        : '';
    initialDateDapController.text = activeFilter.initialDateDap != null
        ? dateFormat.format(activeFilter.initialDateDap!)
        : '';
    endDateDapController.text = activeFilter.endDateDap != null
        ? dateFormat.format(activeFilter.endDateDap!)
        : '';
    setState(() {
      initialDateDae = activeFilter.initialDateDae;
      endDateDae = activeFilter.endDateDae;
      initialDateDaa = activeFilter.initialDateDaa;
      endDateDaa = activeFilter.endDateDaa;
      initialDateDap = activeFilter.initialDateDap;
      endDateDap = activeFilter.endDateDap;
    });
  }
}
