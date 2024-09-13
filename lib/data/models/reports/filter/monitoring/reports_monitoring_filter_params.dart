import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsMonitoringFilterParams extends ReportsFilterParams {
  ReportsMonitoringFilterParams({
    this.riskLevel,
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

  String? riskLevel;

  factory ReportsMonitoringFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    String? diseasesId,
    String? riskLevel,
    DateTime? initialDate,
    DateTime? endDate,
  }) {
    return ReportsMonitoringFilterParams(
      propertiesId: reportsFilterParams.propertiesId,
      cropsId: reportsFilterParams.cropsId,
      harvestsId: reportsFilterParams.harvestsId,
      cultureId: reportsFilterParams.cultureId,
      cultureCode: reportsFilterParams.cultureCode,
      searchHarvested: reportsFilterParams.searchHarvested,
      initialDate: initialDate,
      endDate: endDate,
      riskLevel: riskLevel,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.riskLevel != null && this.riskLevel!.isNotEmpty) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'risk=${this.riskLevel}';
    }

    return paramsString;
  }

  @override
  ReportsMonitoringFilterParams copyWith({
    String? propertiesId,
    int? cultureId,
    String? cultureCode,
    String? cropsId,
    String? harvestsId,
    DateTime? initialDateDap,
    DateTime? endDateDap,
    DateTime? initialDate,
    DateTime? endDate,
    String? riskLevel,
    int? searchHarvested,
  }) {
    return ReportsMonitoringFilterParams(
      propertiesId: propertiesId ?? this.propertiesId,
      cultureId: cultureId ?? this.cultureId,
      cultureCode: cultureCode ?? this.cultureCode,
      cropsId: cropsId ?? this.cropsId,
      harvestsId: harvestsId ?? this.harvestsId,
      initialDateDap: initialDateDap ?? this.initialDateDap,
      endDateDap: endDateDap ?? this.endDateDap,
      initialDate: initialDate ?? this.initialDate,
      endDate: endDate ?? this.endDate,
      riskLevel: riskLevel ?? this.riskLevel,
      searchHarvested: searchHarvested ?? this.searchHarvested,
    );
  }
}
