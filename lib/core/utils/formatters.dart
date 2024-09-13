import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Formatters {
  static String formatToBrl(dynamic value) {
    if (value == null) return NumberFormat("#,##0.00", "pt_BR").format(0.0);

    if (value is String) {
      if (value.contains(',')) {
        value =
            double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ??
                0.0;
      } else {
        value = double.tryParse(value) ?? 0.0;
      }
    }

    return NumberFormat("#,##0.00", "pt_BR").format(value);
  }

  static String formatRemoveDecimalBrl(dynamic value) {
    value = formatToBrl(value);
    return value.substring(0, value.length - 3);
  }

  static String formatDateString(String date) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }

  static String formatDateStringWithHours(String date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(date));
  }

  static String formatDateStringEn(String date, {String divider = "/"}) {
    if (date.contains(divider)) {
      final dateSplit = date.split(divider);
      return "${dateSplit[2]}-${dateSplit[1]}-${dateSplit[0]}";
    } else {
      return date;
    }
  }

  static String getProductObjectType(int type) {
    switch (type) {
      case 1:
        return "Adjuvante";
      case 2:
        return "Biológico";
      case 3:
        return "Fertilizante foliar";
      case 4:
        return "Fungicida";
      case 5:
        return "Herbicida";
      case 6:
        return "Inseticida";
      default:
        return "--";
    }
  }

  static String getStageText(stage) {
    if (stage.vegetativeAgeValue == 0.0 && stage.reprodutiveAgeValue == 0.0) {
      return 'V0';
    } else {
      return "${stage.vegetativeAgeValue != null && stage.vegetativeAgeValue != 0 ? "V${stage.vegetativeAgeValue.toString().replaceAll('.0', '')}" : ''}${stage.vegetativeAgeValue != null && stage.vegetativeAgeValue != 0.0 && (stage.reprodutiveAgeValue != null && stage.reprodutiveAgeValue != 0.0) ? ' - ' : ''}${stage.reprodutiveAgeValue != null && stage.reprodutiveAgeValue != 0.0 ? "R${stage.reprodutiveAgeValue.toString().replaceAll('.0', '')}" : ''}";
    }
  }

  static Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
  }

  static bool validateDate(String date) {
    final dateSplit = date.split('/');
    final day = int.parse(dateSplit[0]);
    final month = int.parse(dateSplit[1]);
    final year = int.parse(dateSplit[2]);

    if (day > 31 || day < 1) return false;
    if (month > 12 || month < 1) return false;
    if (year < 2020) return false;

    return true;
  }
}
