import 'package:fitoagricola/core/utils/url_param_utils.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/culture/culture.dart';
import 'package:fitoagricola/data/models/harvest/harvest.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter.dart';
import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/application/application_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/select_harvested_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_component.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/components/selected_item_list.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/diseases/diseases_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/generic/generic_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/inputs/inputs_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/monitoring/monitoring_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/pests/pests_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/productivity/productivity_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/rain-gauges/rain_gauges_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/seeds/seeds_reports_filter.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_filter/weeds/weeds_reports_filter.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search.dart';
import 'package:fitoagricola/widgets/dropdown_search/dropdown_search_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsFilterModal extends StatefulWidget {
  const ReportsFilterModal({
    required this.filters,
    required this.activeFilter,
    required this.onFiltersChanged,
    required this.currentTabCode,
    super.key,
  });

  final ReportFilters filters;
  final ReportsFilterParams? activeFilter;
  final Function(ReportsFilterParams?) onFiltersChanged;
  final String currentTabCode;

  @override
  State<ReportsFilterModal> createState() => _ReportsFilterModalState();
}

class _ReportsFilterModalState extends State<ReportsFilterModal> {
  List<Property> selectedProperties = [];
  List<Crop> selectedCrops = [];
  List<Harvest> selectedHarvests = [];
  Culture? selectedCulture;
  String? selectedCultureCode;
  bool isSelectHarvestedActive = true;
  List<Crop> cropList = [];

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    if (widget.activeFilter != null) {
      _initializeFields(widget.activeFilter);
    } else {
      cropList = widget.filters.crops ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          defaultFilters,
          _getTabFilters(),
        ],
      ),
    );
  }

  Widget get defaultFilters => Column(
        children: [
          DropdownSearchComponent(
            label: 'Propriedade',
            hintText: 'Selecione',
            style: 'inline',
            selectedId: null,
            onChanged: _selectProperty,
            items: widget.filters.properties
                    ?.map<DropdownSearchModel>(
                      (property) => DropdownSearchModel(
                          id: property.id, name: property.name),
                    )
                    .toList() ??
                [],
          ),
          const SizedBox(height: 8),
          selectedProperties.length > 0
              ? SelectedItemList(
                  itemList: selectedProperties
                      .map<Widget>(
                        (selectedProperty) => SelectedItemComponent(
                          value: selectedProperty.name,
                          onItemRemoved: (propertyName) {
                            final property = selectedProperties.firstWhere(
                                (property) => property.name == propertyName);
                            setState(() {
                              selectedProperties.remove(property);
                              selectedCrops.removeWhere(
                                (crop) => crop.propertyId == property.id,
                              );
                            });
                            updateCropList();
                          },
                        ),
                      )
                      .toList(),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16),
          DropdownSearchComponent(
            label: 'Ano Agrícola',
            hintText: 'Selecione',
            style: 'inline',
            selectedId: null,
            onChanged: _selectHarvest,
            items: widget.filters.harvests
                    ?.map<DropdownSearchModel>(
                      (harvest) => DropdownSearchModel(
                          id: harvest.id, name: harvest.name),
                    )
                    .toList() ??
                [],
          ),
          const SizedBox(height: 8),
          selectedHarvests.length > 0
              ? SelectedItemList(
                  itemList: selectedHarvests
                      .map<Widget>(
                        (selectedHarvest) => SelectedItemComponent(
                          value: selectedHarvest.name,
                          onItemRemoved: (harvestName) {
                            setState(() {
                              selectedHarvests.removeWhere(
                                (harvest) => harvest.name == harvestName,
                              );
                            });
                          },
                        ),
                      )
                      .toList(),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16),
          DropdownSearchComponent(
            label: 'Lavoura',
            hintText: 'Selecione',
            style: 'inline',
            selectedId: null,
            onChanged: _selectCrop,
            items: cropList
                .map<DropdownSearchModel>(
                  (crop) => DropdownSearchModel(id: crop.id, name: crop.name),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          selectedCrops.length > 0
              ? SelectedItemList(
                  itemList: selectedCrops
                      .map<Widget>(
                        (selectedCrop) => SelectedItemComponent(
                          value: selectedCrop.name,
                          onItemRemoved: (cropName) {
                            setState(() {
                              selectedCrops.removeWhere(
                                (crop) => crop.name == cropName,
                              );
                            });
                          },
                        ),
                      )
                      .toList(),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16),
          DropdownSearchComponent(
            label: 'Cultura',
            hintText: 'Selecione',
            style: 'inline',
            selectedId: selectedCulture?.id,
            onChanged: (newSelectedItem) {
              setState(() {
                if (newSelectedItem.id == null) {
                  selectedCulture = null;
                  selectedCultureCode = null;
                  return;
                }
                selectedCulture = widget.filters.cultures?.firstWhere(
                  (culture) => culture.id == newSelectedItem.id,
                );
              });
            },
            items: [
              DropdownSearchModel(id: null, name: 'Selecione'),
              ...widget.filters.cultures
                      ?.map<DropdownSearchModel>(
                        (culture) => DropdownSearchModel(
                            id: culture.id, name: culture.name ?? '-'),
                      )
                      .toList() ??
                  [],
            ],
          ),
          const SizedBox(height: 16),
          DropdownSearchComponent(
            label: 'Cultivar',
            hintText: 'Selecione',
            style: 'inline',
            selectedId: selectedCultureCode,
            onChanged: (item) {
              setState(() {
                if (item.id == null) return selectedCultureCode = null;
                selectedCultureCode = item.name;
              });
            },
            items: [
              DropdownSearchModel(id: null, name: 'Selecione'),
              ...selectedCulture != null && selectedCulture?.extraColumn != null
                  ? selectedCulture!.extraColumn!
                      .split(',')
                      .map(
                        (e) => DropdownSearchModel(id: e, name: e),
                      )
                      .toList()
                  : [],
            ],
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget _getTabFilters() {
    switch (widget.currentTabCode) {
      case 'monitoring':
        return MonitoringReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'cultures':
        return Column(
          children: [
            SelectHarvestedComponent(
              value: isSelectHarvestedActive,
              onChanged: _onChangeSelectHarvested,
            ),
            const SizedBox(height: 20),
            CustomFilledButton(
              text: 'Filtrar',
              onPressed: () {
                var defaultParams = _convertFilterToParams(null);

                widget.onFiltersChanged(
                  defaultParams,
                );
              },
            ),
          ],
        );
      case 'productivity':
        return ProductivityReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
        );
      case 'rain-gauges':
        return RainGaugesReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onSelectHarvestedChanged: _onChangeSelectHarvested,
        );
      case 'application':
        return ApplicationReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'inputs':
        return InputsReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'data-seeds':
        return SeedsReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'diseases':
        return DiseasesReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'weeds':
        return WeedsReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'pests':
        return PestsReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
      case 'geral':
      default:
        return GenericReportsFilter(
          filters: widget.filters,
          activeFilter: widget.activeFilter,
          onFiltersChanged: widget.onFiltersChanged,
          convertParams: _convertFilterToParams,
          isSelectHarvestedActive: isSelectHarvestedActive,
          onChangeSelectHarvested: _onChangeSelectHarvested,
        );
    }
  }

  ReportsFilterParams _convertFilterToParams(
      ReportsFilterParams? activeFilter) {
    var propertiesIdParam = _propertiesToQueryParams();
    var cropsIdParam = _cropsToQueryParams();
    var harvestsIdParam = _harvestsToQueryParams();
    var searchHarvested = isSelectHarvestedActive ? 1 : 0;

    if (activeFilter != null) {
      return activeFilter.copyWith(
        propertiesId: propertiesIdParam,
        cropsId: cropsIdParam,
        harvestsId: harvestsIdParam,
        cultureId: selectedCulture?.id,
        cultureCode: selectedCultureCode,
        searchHarvested: searchHarvested,
      );
    }

    return ReportsFilterParams(
      propertiesId: propertiesIdParam,
      cropsId: cropsIdParam,
      harvestsId: harvestsIdParam,
      cultureId: selectedCulture?.id,
      cultureCode: selectedCultureCode,
      searchHarvested: searchHarvested,
    );
  }

  String _propertiesToQueryParams() {
    var properties = selectedProperties.map<int?>((e) => e.id).toList();
    return properties.join(',');
  }

  String _cropsToQueryParams() {
    var crops = selectedCrops.map<int?>((e) => e.id).toList();
    return crops.join(',');
  }

  String _harvestsToQueryParams() {
    var harvests = selectedHarvests.map<int?>((e) => e.id).toList();
    return harvests.join(',');
  }

  void _onChangeSelectHarvested(bool? newSelectHarvestedValue) {
    if (newSelectHarvestedValue == null) return;
    setState(() {
      isSelectHarvestedActive = newSelectHarvestedValue;
    });
  }

  void _selectProperty(DropdownSearchModel? newSelectedProperty) {
    if (newSelectedProperty == null) return;
    var property = widget.filters.properties!.firstWhere(
      (item) => item.id == newSelectedProperty.id,
    );

    var propertyIndex = selectedProperties.indexOf(property);
    if (propertyIndex != -1) return;

    setState(() {
      selectedProperties.add(property);
    });
    updateCropList();
  }

  void updateCropList() {
    if (selectedProperties.isEmpty) {
      cropList = widget.filters.crops ?? [];
      return;
    }

    cropList = widget.filters.crops!
        .where((crop) => selectedProperties
            .any((property) => crop.propertyId == property.id))
        .toList();
  }

  void _selectCrop(DropdownSearchModel? newSelectedCrop) {
    if (newSelectedCrop == null) return;
    var crop = widget.filters.crops!.firstWhere(
      (item) => item.id == newSelectedCrop.id,
    );

    var cropIndex = selectedCrops.indexOf(crop);
    if (cropIndex != -1) return;
    setState(() {
      selectedCrops.add(crop);
    });
  }

  void _selectHarvest(DropdownSearchModel? newSelectedHarvest) {
    if (newSelectedHarvest == null) return;
    var harvest = widget.filters.harvests!.firstWhere(
      (item) => item.id == newSelectedHarvest.id,
    );

    var propertyIndex = selectedHarvests.indexOf(harvest);
    if (propertyIndex != -1) return;
    setState(() {
      selectedHarvests.add(harvest);
    });
  }

  void _initializeFields(ReportsFilterParams? activeFilter) {
    isSelectHarvestedActive = activeFilter?.searchHarvested == 1;
    selectedCulture = activeFilter?.cultureId != null
        ? widget.filters.cultures
            ?.firstWhere((element) => element.id == activeFilter!.cultureId)
        : null;
    selectedCultureCode = activeFilter?.cultureCode;
    selectedProperties = activeFilter?.propertiesId.toObjectList<Property>(
          comparableList: widget.filters.properties,
          testFunction: (property, propertyParam) =>
              property.id.toString() == propertyParam,
        ) ??
        [];
    if (selectedProperties.isNotEmpty) {
      cropList = widget.filters.crops
              ?.where(
                (crop) => selectedProperties
                    .any((property) => property.id == crop.propertyId),
              )
              .toList() ??
          [];
    } else {
      cropList = widget.filters.crops ?? [];
    }
    selectedCrops = activeFilter?.cropsId.toObjectList<Crop>(
          comparableList: widget.filters.crops,
          testFunction: (crop, cropParam) => crop.id.toString() == cropParam,
        ) ??
        [];
    selectedHarvests = activeFilter?.harvestsId.toObjectList<Harvest>(
          comparableList: widget.filters.harvests,
          testFunction: (harvest, harvestParam) =>
              harvest.id.toString() == harvestParam,
        ) ??
        [];
  }
}
