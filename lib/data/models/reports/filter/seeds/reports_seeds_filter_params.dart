import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsSeedsFilterParams extends ReportsFilterParams {
  ReportsSeedsFilterParams({
    this.minPopulation,
    this.maxPopulation,
    this.minEmergency,
    this.maxEmergency,
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

  String? minPopulation;
  String? maxPopulation;
  String? minEmergency;
  String? maxEmergency;

  factory ReportsSeedsFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    DateTime? initialDateDap,
    DateTime? endDateDap,
    String? minPopulation,
    String? maxPopulation,
    String? minEmergency,
    String? maxEmergency,
  }) {
    return ReportsSeedsFilterParams(
      propertiesId: reportsFilterParams.propertiesId,
      cropsId: reportsFilterParams.cropsId,
      harvestsId: reportsFilterParams.harvestsId,
      cultureId: reportsFilterParams.cultureId,
      cultureCode: reportsFilterParams.cultureCode,
      searchHarvested: reportsFilterParams.searchHarvested,
      initialDateDap: initialDateDap,
      endDateDap: endDateDap,
      minPopulation: minPopulation,
      maxPopulation: maxPopulation,
      minEmergency: minEmergency,
      maxEmergency: maxEmergency,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.minPopulation != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'min_population=${this.minPopulation}';
    }

    if (this.maxPopulation != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'max_population=${this.maxPopulation}';
    }

    if (this.minEmergency != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += ' min_emergency=${this.minEmergency}';
    }

    if (this.maxEmergency != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += ' max_emergency=${this.maxEmergency}';
    }

    return paramsString;
  }

  @override
  ReportsSeedsFilterParams copyWith({
    String? minPopulation,
    String? maxPopulation,
    String? minEmergency,
    String? maxEmergency,
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
    return ReportsSeedsFilterParams(
      minPopulation: minPopulation ?? this.minPopulation,
      maxPopulation: maxPopulation ?? this.maxPopulation,
      minEmergency: minEmergency ?? this.minEmergency,
      maxEmergency: maxEmergency ?? this.maxEmergency,
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
