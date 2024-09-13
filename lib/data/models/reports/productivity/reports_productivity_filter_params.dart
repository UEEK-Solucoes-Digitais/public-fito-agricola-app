import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsProductivityFilterParams extends ReportsFilterParams {
  ReportsProductivityFilterParams({
    this.minPopulation,
    this.maxPopulation,
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

  factory ReportsProductivityFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    DateTime? initialDateDap,
    DateTime? endDateDap,
    String? minPopulation,
    String? maxPopulation,
  }) {
    return ReportsProductivityFilterParams(
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
    return paramsString;
  }

  @override
  ReportsProductivityFilterParams copyWith({
    String? minPopulation,
    String? maxPopulation,
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
    return ReportsProductivityFilterParams(
      minPopulation: minPopulation ?? this.minPopulation,
      maxPopulation: maxPopulation ?? this.maxPopulation,
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
