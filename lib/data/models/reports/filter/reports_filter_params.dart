import 'package:intl/intl.dart';

class ReportsFilterParams {
  ReportsFilterParams({
    this.searchHarvested = 0,
    this.propertiesId,
    this.cultureId,
    this.cultureCode,
    this.cropsId,
    this.harvestsId,
    this.initialDate,
    this.endDate,
    this.initialDateDap,
    this.endDateDap,
  });
  String? propertiesId;
  int? cultureId;
  String? cultureCode;
  String? cropsId;
  String? harvestsId;
  int searchHarvested;
  DateTime? initialDate;
  DateTime? endDate;
  DateTime? initialDateDap;
  DateTime? endDateDap;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  String toRequestQueryParams() {
    String paramsString = '';
    if (this.propertiesId != null && this.propertiesId!.isNotEmpty)
      paramsString += 'properties_id=${this.propertiesId}';
    if (this.cropsId != null && this.cropsId!.isNotEmpty) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'crops_id=${this.cropsId}';
    }
    if (this.harvestsId != null && this.harvestsId!.isNotEmpty) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'harvests_id=${this.harvestsId}';
    }
    if (this.cultureId != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'culture_id=${this.cultureId}';
    }
    if (this.initialDate != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'date_begin=${dateFormat.format(initialDate!)}';
    }

    if (this.endDate != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'date_end=${dateFormat.format(endDate!)}';
    }

    if (this.initialDateDap != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'dap_begin=${dateFormat.format(initialDateDap!)}';
    }

    if (this.endDateDap != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'dap_end=${dateFormat.format(endDateDap!)}';
    }

    if (this.cultureCode != null) {
      if (paramsString.isNotEmpty) {
        paramsString += '&';
      }
      paramsString += 'culture_code=${this.cultureCode}';
    }

    if (paramsString.isNotEmpty) {
      paramsString += '&';
    }
    paramsString += 'search_harvested=$searchHarvested';
    return paramsString;
  }

  ReportsFilterParams copyWith({
    String? propertiesId,
    String? cropsId,
    String? harvestsId,
    int? cultureId,
    String? cultureCode,
    int? searchHarvested,
  }) {
    return ReportsFilterParams(
      propertiesId: propertiesId ?? this.propertiesId,
      cropsId: cropsId ?? this.cropsId,
      harvestsId: harvestsId ?? this.harvestsId,
      cultureId: cultureId ?? this.cultureId,
      cultureCode: cultureCode ?? this.cultureCode,
      searchHarvested: searchHarvested ?? this.searchHarvested,
    );
  }
}
