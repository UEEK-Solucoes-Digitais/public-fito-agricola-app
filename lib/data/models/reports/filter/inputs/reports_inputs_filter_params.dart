import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsInputsFilterParams extends ReportsFilterParams {
  ReportsInputsFilterParams({
    this.visualizationType,
    this.productsId,
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

  String? productsId;
  int? visualizationType;

  factory ReportsInputsFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    String? productsId,
    int? visualizationType,
    DateTime? initialDate,
    DateTime? endDate,
    DateTime? initialDateDap,
    DateTime? endDateDap,
  }) {
    return ReportsInputsFilterParams(
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
      productsId: productsId,
      visualizationType: visualizationType,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (this.productsId != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'products_id=${this.productsId}';
    }

    if (this.visualizationType != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'visualization_type=${this.visualizationType}';
    }

    return paramsString;
  }

  @override
  ReportsInputsFilterParams copyWith({
    String? productsId,
    int? visualizationType,
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
    return ReportsInputsFilterParams(
      productsId: productsId ?? this.productsId,
      visualizationType: visualizationType ?? this.visualizationType,
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
