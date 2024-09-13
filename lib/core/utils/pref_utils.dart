//ignore: unused_import
import 'dart:convert';
import 'dart:io';

import 'package:fitoagricola/core/utils/database_helper.dart';
import 'package:fitoagricola/core/utils/logout.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
// void backgroundTask(dynamic obj) {
//   OfflineSync.main();
// }

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  Future<void> clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> clearApiPreferencesData() async {
    for (String key in _sharedPreferences!.getKeys()) {
      if (key.contains('api/') || key.contains('sync_properties')) {
        // print(key);
        _sharedPreferences!.remove(key);
      }
    }
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  String getToken() {
    return _sharedPreferences!.getString('token') ?? '';
  }

  Future<void> setToken(String value) {
    return _sharedPreferences!.setString('token', value);
  }

  String getTokenExpires() {
    return _sharedPreferences!.getString('token_expires') ?? '';
  }

  Future<void> setTokenExpires(String value) {
    return _sharedPreferences!.setString('token_expires', value);
  }

  List<String> getTokenSettings() {
    return [
      _sharedPreferences!.getString('token') ?? '',
      _sharedPreferences!.getString('token_expires') ?? ''
    ];
  }

  Future<bool> isLogged() async {
    bool? isLogged = _sharedPreferences!.getBool('isLogged');
    String? admin = _sharedPreferences!.getString('admin');

    if (isLogged == null || admin == null) {
      return false;
    }

    return isLogged;
  }

  Future<void> setLogged(bool value) {
    return _sharedPreferences!.setBool('isLogged', value);
  }

  Future<void> setAdmin(String value) {
    return _sharedPreferences!.setString('admin', value);
  }

  bool checkAdmin() {
    return jsonDecode(_sharedPreferences!.getString('admin')!) == null
        ? false
        : true;
  }

  dynamic getAdmin() {
    if (jsonDecode(_sharedPreferences!.getString('admin')!) == null) {
      return LogoutFunctionOperation(null);
    }

    return Admin.fromJson(jsonDecode(
        _sharedPreferences!.getString('admin') != null
            ? _sharedPreferences!.getString('admin')!
            : ''));
  }

  String? getAdminString() {
    return _sharedPreferences!.getString('admin');
  }

  String getAreaUnit() {
    return _sharedPreferences!.getString('area_unit') ?? 'ha';
  }

  String getFullAreaUnit() {
    if (_sharedPreferences!.getString('area_unit') != null) {
      if (_sharedPreferences!.getString('area_unit') == 'ha') {
        return 'hectares';
      } else {
        return 'alqueires';
      }
    } else {
      return 'hectares';
    }
  }

  Future<void> setAreaUnit(String value) {
    return _sharedPreferences!.setString('area_unit', value);
  }

  String getLastSync() {
    return _sharedPreferences!.getString('last_sync') ?? '';
  }

  Future<void> setLastSync(String value) {
    return _sharedPreferences!.setString('last_sync', value);
  }

  bool checkSync() {
    var lastSync = getLastSync();

    // Verifica se last_sync é nulo ou vazio e executa a sincronização
    if (lastSync.isEmpty) {
      return false;
    }

    return true;
  }

  Future<bool> syncOffline() async {
    print("sincronizando offline");

    // await DefaultRequest.getOffline().then((value) {
    //   // setLastSync(DateTime.now().toString());
    // });

    // await FlutterIsolate.spawn(backgroundTask, "sincronizando offline");

    for (var i = 0; i < 100000; i++) {
      print(i);
    }
    // Atualiza a data de última sincronização
    return Future.value(true);
  }

  Future<void> setSeed(dynamic value) {
    return _sharedPreferences!
        .setString("seeds", value is String ? value : jsonEncode(value));
  }

  dynamic getSeed() {
    final seeds = _sharedPreferences!.getString("seeds");
    if (seeds != null) {
      return jsonDecode(seeds);
    } else {
      return null;
    }
  }

  Future<void> setOfflineData(String key, dynamic value) {
    // return _sharedPreferences!
    //     .setString(key, value is String ? value : jsonEncode(value));

    final allRoutesData = _sharedPreferences!.getString("all_routes_data");

    if (allRoutesData != null) {
      final allData = jsonDecode(allRoutesData);
      allData[key] = value;
      return _sharedPreferences!
          .setString("all_routes_data", jsonEncode(allData));
    } else {
      return _sharedPreferences!
          .setString("all_routes_data", jsonEncode({key: value}));
    }
  }

  dynamic getAllDataOffline() {
    return _sharedPreferences!.getString("all_routes_data");
  }

  dynamic getOfflineData(String key) {
    final allRoutesData = _sharedPreferences!.getString("all_routes_data");
    if (allRoutesData != null) {
      final allData = jsonDecode(allRoutesData);

      if (allData[key] == null) {
        final allDataNestedKey = allData['all_routes_data'];

        if (allDataNestedKey != null) {
          final allDataNested = jsonDecode(allDataNestedKey);

          return allDataNested[key];
        }
      }

      return allData[key];
    } else {
      return null;
    }
  }

  Future<void> setSQLOfflineData(String key, dynamic value) async {
    return await DatabaseHelper().insertData(key, jsonEncode(value));
  }

  Future<void> setBulkSQLOfflineData(Map<String, dynamic> data) async {
    final dataToInsert =
        data.map((key, value) => MapEntry(key, jsonEncode(value)));
    await DatabaseHelper().insertBulkData(dataToInsert);
  }

  Future<dynamic> getSQLOfflineData(String key) async {
    final jsonData = await DatabaseHelper().getDataByRoute(key);
    if (jsonData == null) return null;
    // Logger().i(jsonDecode(jsonData));
    return jsonDecode(jsonData);
  }

  Future<void> storePostRequest(String key, dynamic body) {
    return _sharedPreferences!.setString(key, jsonEncode(body));
  }

  Future<void> removePostRequest(String key) async {
    await _sharedPreferences!.remove(key);
  }

  dynamic getAllPostRequest() {
    final keys =
        _sharedPreferences!.getKeys().where((k) => k.startsWith("request_"));

    List operations = [];

    for (var key in keys) {
      // _sharedPreferences!.remove(key);
      operations.add(jsonDecode(_sharedPreferences!.getString(key) ?? ''));
    }

    return operations;
  }

  Future<void> setSyncProperties(String key, dynamic value) {
    return _sharedPreferences!.setString(key, value);
  }

  dynamic getSyncProperties() {
    return _sharedPreferences!.getString("sync_properties");
  }

  Future<void> setOfflinePostOption(bool value) {
    // set expiration date of this option for 2 hours
    final date = DateTime.now().add(Duration(hours: 2));
    _sharedPreferences!
        .setString("offline_post_option_expiration", date.toString());

    return _sharedPreferences!.setBool("offline_post_option", value);
  }

  dynamic checkOfflinePostOption() {
    // check if not expired
    final expiration =
        _sharedPreferences!.getString("offline_post_option_expiration");
    if (expiration != null) {
      final date = DateTime.parse(expiration);
      if (date.isAfter(DateTime.now())) {
        return _sharedPreferences!.getBool("offline_post_option");
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  int? getActualHarvest() {
    return _sharedPreferences!.getInt('actualHarvest') ?? null;
  }

  Future<void> setActualHarvest(int? value) {
    return value == null
        ? _sharedPreferences!.remove('actualHarvest')
        : _sharedPreferences!.setInt('actualHarvest', value);
  }

  int getVersion() {
    // android version e ios version no .env
    if (Platform.isAndroid) {
      return int.parse(dotenv.env['ANDROID_VERSION']!);
    } else {
      return int.parse(dotenv.env['IOS_VERSION']!);
    }
  }

  bool needsToUpdate() {
    return _sharedPreferences!.getBool('needsToUpdate') != null
        ? _sharedPreferences!.getBool('needsToUpdate')!
        : false;
  }

  Future<void> setNeedsToUpdate(bool update) {
    return _sharedPreferences!.setBool('needsToUpdate', update);
  }

  String? getFirebaseToken() {
    return _sharedPreferences!.getString('firebase_token');
  }

  Future<void> setFirebaseToken(String token) {
    return _sharedPreferences!.setString('firebase_token', token);
  }

  Future<List<String>> getAllRoutes() {
    return DatabaseHelper().getAllRoutes();
  }
}
