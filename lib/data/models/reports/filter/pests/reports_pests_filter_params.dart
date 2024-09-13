import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsPestsFilterParams extends ReportsFilterParams {
  ReportsPestsFilterParams({
    this.pestsId,
    this.riskLevel,
    this.minIncidency,
    this.maxIncidency,
    this.minQuantityPerMeter,
    this.maxQuantityPerMeter,
    this.minQuantityPerSquareMeter,
    this.maxQuantityPerSquareMeter,
    super.searchHarvested = 0,
    super.propertiesId,
    super.cultureId,
    super.cultureCode,
    super.cropsId,
    super.harvestsId,
    super.initialDateDap,
    super.endDateDap,
    super.initialDate,
    super.endDate,
  });

  String? pestsId;
  String? riskLevel;
  String? minIncidency;
  String? maxIncidency;
  String? minQuantityPerMeter;
  String? maxQuantityPerMeter;
  String? minQuantityPerSquareMeter;
  String? maxQuantityPerSquareMeter;

  factory ReportsPestsFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    String? pestsId,
    String? riskLevel,
    String? minIncidency,
    String? maxIncidency,
    String? minQuantityPerMeter,
    String? maxQuantityPerMeter,
    String? minQuantityPerSquareMeter,
    String? maxQuantityPerSquareMeter,
    DateTime? initialDate,
    DateTime? endDate,
    DateTime? initialDateDap,
    DateTime? endDateDap,
  }) {
    return ReportsPestsFilterParams(
      propertiesId: reportsFilterParams.propertiesId,
      cropsId: reportsFilterParams.cropsId,
      harvestsId: reportsFilterParams.harvestsId,
      cultureId: reportsFilterParams.cultureId,
      cultureCode: reportsFilterParams.cultureCode,
      searchHarvested: reportsFilterParams.searchHarvested,
      initialDate: initialDate,
      endDate: endDate,
      initialDateDap: initialDateDap,
      endDateDap: endDateDap,
      pestsId: pestsId,
      riskLevel: riskLevel,
      minIncidency: minIncidency,
      maxIncidency: maxIncidency,
      minQuantityPerMeter: minQuantityPerMeter,
      maxQuantityPerMeter: maxQuantityPerMeter,
      minQuantityPerSquareMeter: minQuantityPerSquareMeter,
      maxQuantityPerSquareMeter: maxQuantityPerSquareMeter,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.pestsId != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'pests_id=${this.pestsId}';
    }

    if (this.riskLevel != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'risk=${this.riskLevel}';
    }

    if (this.minIncidency != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'incidency_min=${this.minIncidency}';
    }
    if (this.maxIncidency != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'incidency_max=${this.maxIncidency}';
    }
    if (this.minQuantityPerMeter != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'quantity_per_meter_min=${this.minQuantityPerMeter}';
    }
    if (this.maxQuantityPerMeter != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'quantity_per_meter_max=${this.maxQuantityPerMeter}';
    }
    if (this.minQuantityPerSquareMeter != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString +=
          'quantity_per_square_meter_min=${this.minQuantityPerSquareMeter}';
    }
    if (this.maxQuantityPerSquareMeter != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString +=
          'quantity_per_square_meter_max=${this.maxQuantityPerSquareMeter}';
    }

    return paramsString;
  }

  @override
  ReportsPestsFilterParams copyWith({
    String? pestsId,
    String? riskLevel,
    String? minIncidency,
    String? maxIncidency,
    String? minQuantityPerMeter,
    String? maxQuantityPerMeter,
    String? minQuantityPerSquareMeter,
    String? maxQuantityPerSquareMeter,
    int? searchHarvested,
    String? propertiesId,
    int? cultureId,
    String? cultureCode,
    String? cropsId,
    String? harvestsId,
    DateTime? initialDateDap,
    DateTime? endDateDap,
    DateTime? initialDate,
    DateTime? endDate,
  }) {
    return ReportsPestsFilterParams(
      pestsId: pestsId ?? this.pestsId,
      riskLevel: riskLevel ?? this.riskLevel,
      minIncidency: minIncidency ?? this.minIncidency,
      maxIncidency: maxIncidency ?? this.maxIncidency,
      minQuantityPerMeter: minQuantityPerMeter ?? this.minQuantityPerMeter,
      maxQuantityPerMeter: maxQuantityPerMeter ?? this.maxQuantityPerMeter,
      minQuantityPerSquareMeter:
          minQuantityPerSquareMeter ?? this.minQuantityPerSquareMeter,
      maxQuantityPerSquareMeter:
          maxQuantityPerSquareMeter ?? this.maxQuantityPerSquareMeter,
      searchHarvested: searchHarvested ?? this.searchHarvested,
      propertiesId: propertiesId ?? this.propertiesId,
      cultureId: cultureId ?? this.cultureId,
      cultureCode: cultureCode ?? this.cultureCode,
      cropsId: cropsId ?? this.cropsId,
      harvestsId: harvestsId ?? this.harvestsId,
      initialDateDap: initialDateDap ?? this.initialDateDap,
      endDateDap: endDateDap ?? this.endDateDap,
      initialDate: initialDate ?? this.initialDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
