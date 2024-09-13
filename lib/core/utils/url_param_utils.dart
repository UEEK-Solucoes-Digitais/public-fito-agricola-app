extension UrlParamExtension on String? {
  List<T> toObjectList<T>({
    required List<T>? comparableList,
    required bool Function(T, String) testFunction,
  }) {
    if (this == null && comparableList == null && comparableList!.isEmpty)
      return [];
    List<T> objectList = [];
    final paramsList = this!.split(',');
    for (var param in paramsList) {
      if (param.isEmpty) continue;
      objectList.add(
        comparableList!.firstWhere(
          (element) => testFunction(element, param),
        ),
      );
    }
    return objectList;
  }
}
