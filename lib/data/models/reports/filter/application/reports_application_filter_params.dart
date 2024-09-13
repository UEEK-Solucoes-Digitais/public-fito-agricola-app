import 'package:fitoagricola/data/models/reports/filter/reports_filter_params.dart';

class ReportsApplicationFilterParams extends ReportsFilterParams {
  ReportsApplicationFilterParams({
    this.depuaBegin,
    this.depuaEnd,
    this.daaBegin,
    this.daaEnd,
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

  int? depuaBegin;
  int? depuaEnd;
  int? daaBegin;
  int? daaEnd;

  factory ReportsApplicationFilterParams.fromReportsFilterParams(
    ReportsFilterParams reportsFilterParams, {
    DateTime? initialDate,
    DateTime? endDate,
    int? depuaBegin,
    int? depuaEnd,
    int? daaBegin,
    int? daaEnd,
  }) {
    return ReportsApplicationFilterParams(
      propertiesId: reportsFilterParams.propertiesId,
      cropsId: reportsFilterParams.cropsId,
      harvestsId: reportsFilterParams.harvestsId,
      cultureId: reportsFilterParams.cultureId,
      cultureCode: reportsFilterParams.cultureCode,
      searchHarvested: reportsFilterParams.searchHarvested,
      initialDate: initialDate,
      endDate: endDate,
      depuaBegin: depuaBegin,
      depuaEnd: depuaEnd,
      daaBegin: daaBegin,
      daaEnd: daaEnd,
    );
  }

  @override
  String toRequestQueryParams() {
    var paramsString = super.toRequestQueryParams();

    if (depuaBegin != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }

      paramsString += 'depua_begin=$depuaBegin';
    }

    if (depuaEnd != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }

      paramsString += 'depua_end=$depuaEnd';
    }

    if (daaBegin != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }

      paramsString += 'daa_begin=$daaBegin';
    }

    if (daaEnd != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }

      paramsString += 'daa_end=$daaEnd';
    }

    return paramsString;
  }

  ReportsApplicationFilterParams copyWith({
    String? propertiesId,
    String? cropsId,
    String? harvestsId,
    int? cultureId,
    String? cultureCode,
    int? searchHarvested,
    DateTime? initialDate,
    DateTime? endDate,
    int? depuaBegin,
    int? depuaEnd,
    int? daaBegin,
    int? daaEnd,
  }) {
    return ReportsApplicationFilterParams(
      propertiesId: propertiesId ?? this.propertiesId,
      cropsId: cropsId ?? this.cropsId,
      harvestsId: harvestsId ?? this.harvestsId,
      cultureId: cultureId ?? this.cultureId,
      cultureCode: cultureCode ?? this.cultureCode,
      searchHarvested: searchHarvested ?? this.searchHarvested,
      initialDate: initialDate ?? this.initialDate,
      endDate: endDate ?? this.endDate,
      depuaBegin: depuaBegin ?? this.depuaBegin,
      depuaEnd: depuaEnd ?? this.depuaEnd,
      daaBegin: daaBegin ?? this.daaBegin,
      daaEnd: daaEnd ?? this.daaEnd,
    );
  }
}
