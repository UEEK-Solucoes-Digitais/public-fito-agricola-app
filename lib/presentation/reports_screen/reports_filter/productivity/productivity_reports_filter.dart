import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/data/models/reports/productivity/reports_productivity_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/date_dap_fields.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProductivityReportsFilter extends StatefulWidget {
  ProductivityReportsFilter({
    required this.filters,
    required this.activeFilter,
    required this.onFiltersChanged,
    required this.convertParams,
    super.key,
  });

  final ReportFilters filters;
  final ReportsFilterParams? activeFilter;
  final Function(ReportsFilterParams?) onFiltersChanged;
  final ReportsFilterParams Function(ReportsFilterParams?) convertParams;

  @override
  State<ProductivityReportsFilter> createState() =>
      _ProductivityReportsFilterState();
}

class _ProductivityReportsFilterState extends State<ProductivityReportsFilter> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  TextEditingController initialDateDapController = TextEditingController();
  TextEditingController endDateDapController = TextEditingController();
  TextEditingController minimumPopulationController = TextEditingController();
  TextEditingController maximumPopulationController = TextEditingController();
  DateTime? initialDateDap;
  DateTime? endDateDap;

  @override
  void initState() {
    super.initState();
    if (widget.activeFilter != null &&
        widget.activeFilter is ReportsProductivityFilterParams) {
      _initializeFields(
        widget.activeFilter as ReportsProductivityFilterParams,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        CustomTextFormField(
          minimumPopulationController,
          'População (min)',
          'Digite aqui',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          maximumPopulationController,
          'População (max)',
          'Digite aqui',
          inputType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
          ],
          validatorFunction: true,
        ),
        const SizedBox(height: 20),
        CustomFilledButton(
          text: 'Filtrar',
          onPressed: () {
            var productivityFilter = ReportsProductivityFilterParams(
              initialDateDap: initialDateDap,
              endDateDap: endDateDap,
              minPopulation: minimumPopulationController.text,
              maxPopulation: maximumPopulationController.text,
            );

            var defaultParams = widget.convertParams(productivityFilter);

            widget.onFiltersChanged(
              defaultParams,
            );
          },
        ),
      ],
    );
  }

  void _initializeFields(ReportsProductivityFilterParams activeFilter) {
    initialDateDapController.text = activeFilter.initialDateDap != null
        ? dateFormat.format(activeFilter.initialDate!)
        : '';
    endDateDapController.text = activeFilter.endDateDap != null
        ? dateFormat.format(activeFilter.endDateDap!)
        : '';

    minimumPopulationController.text = activeFilter.minPopulation ?? '';
    maximumPopulationController.text = activeFilter.maxPopulation ?? '';

    setState(() {
      initialDateDap = activeFilter.initialDate;
      endDateDap = activeFilter.endDate;
    });
  }
}
