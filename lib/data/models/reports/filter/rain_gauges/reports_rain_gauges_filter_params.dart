import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsRainGaugesFilterParams extends ReportsFilterParams {
  ReportsRainGaugesFilterParams({
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

  factory ReportsRainGaugesFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    DateTime? initialDate,
    DateTime? endDate,
  }) {
    return ReportsRainGaugesFilterParams(
      propertiesId: reportsFilterParams.propertiesId,
      cropsId: reportsFilterParams.cropsId,
      harvestsId: reportsFilterParams.harvestsId,
      cultureId: reportsFilterParams.cultureId,
      cultureCode: reportsFilterParams.cultureCode,
      searchHarvested: reportsFilterParams.searchHarvested,
      initialDate: initialDate,
      endDate: endDate,
    );
  }

  @override
  ReportsRainGaugesFilterParams copyWith({
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
    return ReportsRainGaugesFilterParams(
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
