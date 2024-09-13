import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsWeedsFilterParams extends ReportsFilterParams {
  ReportsWeedsFilterParams({
    this.weedsId,
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

  String? weedsId;
  String? riskLevel;

  factory ReportsWeedsFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    String? weedsId,
    String? riskLevel,
    DateTime? initialDate,
    DateTime? endDate,
    DateTime? initialDateDap,
    DateTime? endDateDap,
  }) {
    return ReportsWeedsFilterParams(
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
      weedsId: weedsId,
      riskLevel: riskLevel,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.weedsId != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'weeds_id=${this.weedsId}';
    }

    if (this.riskLevel != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'risk=${this.riskLevel}';
    }
    return paramsString;
  }

  @override
  ReportsWeedsFilterParams copyWith({
    String? weedsId,
    String? riskLevel,
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
    return ReportsWeedsFilterParams(
      weedsId: weedsId ?? this.weedsId,
      riskLevel: riskLevel ?? this.riskLevel,
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
