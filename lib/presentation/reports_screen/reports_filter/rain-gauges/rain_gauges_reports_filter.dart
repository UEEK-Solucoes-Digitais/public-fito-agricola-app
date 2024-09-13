import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/data/models/reports/filter/rain_gauges/reports_rain_gauges_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/widgets/custom_date_form_field/custom_date_form_field.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RainGaugesReportsFilter extends StatefulWidget {
  RainGaugesReportsFilter({
    required this.filters,
    required this.activeFilter,
    required this.onFiltersChanged,
    required this.convertParams,
    required this.isSelectHarvestedActive,
    required this.onSelectHarvestedChanged,
    super.key,
  });

  final ReportFilters filters;
  final ReportsFilterParams? activeFilter;
  final Function(ReportsFilterParams?) onFiltersChanged;
  final ReportsFilterParams Function(ReportsFilterParams?) convertParams;
  final bool isSelectHarvestedActive;
  final Function(bool? newSelectHarvestedValue) onSelectHarvestedChanged;

  @override
  State<RainGaugesReportsFilter> createState() =>
      _RainGaugesReportsFilterState();
}

class _RainGaugesReportsFilterState extends State<RainGaugesReportsFilter> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  TextEditingController initialDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? initialDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsRainGaugesFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsRainGaugesFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SelectHarvestedComponent(
          value: widget.isSelectHarvestedActive,
          onChanged: widget.onSelectHarvestedChanged,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var rainGaugesFilter = ReportsRainGaugesFilterParams(
              initialDate: initialDate,
              endDate: endDate,
            );

            var activeFilter = widget.convertParams(rainGaugesFilter);

            widget.onFiltersChanged(activeFilter);
          },
        ),
      ],
    );
  }

  void _initializeFields(ReportsRainGaugesFilterParams activeFilter) {
    initialDateController.text = activeFilter.initialDate != null
        ? dateFormat.format(activeFilter.initialDate!)
        : '';
    endDateController.text = activeFilter.endDate != null
        ? dateFormat.format(activeFilter.endDate!)
        : '';

    setState(() {
      initialDate = activeFilter.initialDate;
      endDate = activeFilter.endDate;
    });
  }
}
