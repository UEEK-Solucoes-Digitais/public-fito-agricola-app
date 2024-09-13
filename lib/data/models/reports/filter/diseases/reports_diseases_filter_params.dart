import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsDiseasesFilterParams extends ReportsFilterParams {
  ReportsDiseasesFilterParams({
    this.diseasesId,
    this.riskLevel,
    this.minIncidency,
    this.maxIncidency,
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

  String? diseasesId;
  String? riskLevel;
  String? minIncidency;
  String? maxIncidency;

  factory ReportsDiseasesFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    String? diseasesId,
    String? riskLevel,
    DateTime? initialDate,
    DateTime? endDate,
    DateTime? initialDateDap,
    DateTime? endDateDap,
    String? minIncidency,
    String? maxIncidency,
  }) {
    return ReportsDiseasesFilterParams(
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
      diseasesId: diseasesId,
      riskLevel: riskLevel,
      minIncidency: minIncidency,
      maxIncidency: maxIncidency,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.diseasesId != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'diseases_id=${this.diseasesId}';
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
    return paramsString;
  }

  @override
  ReportsDiseasesFilterParams copyWith({
    String? diseasesId,
    String? riskLevel,
    String? minIncidency,
    String? maxIncidency,
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
    return ReportsDiseasesFilterParams(
      diseasesId: diseasesId ?? this.diseasesId,
      riskLevel: riskLevel ?? this.riskLevel,
      minIncidency: minIncidency ?? this.minIncidency,
      maxIncidency: maxIncidency ?? this.maxIncidency,
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
