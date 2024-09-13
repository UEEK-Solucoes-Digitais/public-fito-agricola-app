import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsGenericFilterParams extends ReportsFilterParams {
  ReportsGenericFilterParams({
    this.initialDateDae,
    this.endDateDae,
    this.initialDateDaa,
    this.endDateDaa,
    super.searchHarvested = 0,
    super.propertiesId,
    super.cultureId,
    super.cultureCode,
    super.cropsId,
    super.harvestsId,
    super.initialDateDap,
    super.endDateDap,
  });

  DateTime? initialDateDae;
  DateTime? endDateDae;
  DateTime? initialDateDaa;
  DateTime? endDateDaa;

  factory ReportsGenericFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    DateTime? initialDateDap,
    DateTime? endDateDap,
    DateTime? initialDateDae,
    DateTime? endDateDae,
    DateTime? initialDateDaa,
    DateTime? endDateDaa,
  }) {
    return ReportsGenericFilterParams(
      propertiesId: reportsFilterParams.propertiesId,
      cropsId: reportsFilterParams.cropsId,
      harvestsId: reportsFilterParams.harvestsId,
      cultureId: reportsFilterParams.cultureId,
      cultureCode: reportsFilterParams.cultureCode,
      searchHarvested: reportsFilterParams.searchHarvested,
      initialDateDap: initialDateDap,
      endDateDap: endDateDap,
      initialDateDae: initialDateDae,
      endDateDae: endDateDae,
      initialDateDaa: initialDateDaa,
      endDateDaa: endDateDaa,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.initialDateDae != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'dae_begin=${dateFormat.format(initialDateDae!)}';
    }
    if (this.endDateDae != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'dae_end=${dateFormat.format(endDateDae!)}';
    }

    if (this.initialDateDaa != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'daa_begin=${dateFormat.format(initialDateDaa!)}';
    }
    if (this.endDateDaa != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'daa_end=${dateFormat.format(endDateDaa!)}';
    }

    return paramsString;
  }

  ReportsGenericFilterParams copyWith({
    DateTime? initialDateDae,
    DateTime? endDateDae,
    DateTime? initialDateDaa,
    DateTime? endDateDaa,
    int? searchHarvested,
    String? propertiesId,
    int? cultureId,
    String? cultureCode,
    String? cropsId,
    String? harvestsId,
    DateTime? initialDateDap,
    DateTime? endDateDap,
  }) {
    return ReportsGenericFilterParams(
      initialDateDae: initialDateDae ?? this.initialDateDae,
      endDateDae: endDateDae ?? this.endDateDae,
      initialDateDaa: initialDateDaa ?? this.initialDateDaa,
      endDateDaa: endDateDaa ?? this.endDateDaa,
      searchHarvested: searchHarvested ?? this.searchHarvested,
      propertiesId: propertiesId ?? this.propertiesId,
      cultureId: cultureId ?? this.cultureId,
      cultureCode: cultureCode ?? this.cultureCode,
      cropsId: cropsId ?? this.cropsId,
      harvestsId: harvestsId ?? this.harvestsId,
      initialDateDap: initialDateDap ?? this.initialDateDap,
      endDateDap: endDateDap ?? this.endDateDap,
    );
  }
}
