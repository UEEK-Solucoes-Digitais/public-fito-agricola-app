import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/property/property.dart';
import 'package:fitoagricola/widgets/app_bar/app_bar.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_dialog/custom_dialog.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/drawer/drawer.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/page_header/page_header.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:fitoagricola/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OfflineSyncPage extends StatefulWidget {
  const OfflineSyncPage({super.key});

  @override
  State<OfflineSyncPage> createState() => _OfflineSyncPageState();
}

class _OfflineSyncPageState extends State<OfflineSyncPage> {
  String lastSync = '';
  double step = 0;
  bool isSyncing = false;
  bool isSyncingPost = false;
  bool isLoading = true;
  String textSync = '';
  Admin admin = PrefUtils().getAdmin();
  bool needsToUpdate = false;

  List<Property> properties = [];
  List selectedProperties = [];
  dynamic syncProperties;

  int currentProperty = 1;
  int currentHarvest = 1;
  int currentCrop = 1;

  bool hasInternet = true;
  List operations = [];

  @override
  void initState() {
    super.initState();

    lastSync = PrefUtils().getLastSync();

    Future.delayed(Duration.zero, () async {
      await PrefUtils().reload();
      hasInternet = await NetworkOperations.checkConnection();
      needsToUpdate = PrefUtils().needsToUpdate();

      getProperties();

      operations = PrefUtils().getAllPostRequest();

      Logger().e(operations);
      syncProperties = await PrefUtils().getSyncProperties();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: needsToUpdate ? null : BaseAppBar(),
        body: needsToUpdate
            ? UpdateWidget()
            : SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 30,
                              right: 20,
                              bottom: 10,
                            ),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PageHeader(
                                      title: 'Sincronizar offline',
                                      text:
                                          'Utilize o botão abaixo para sincronizar somente os itens essenciais para cadastros. Isso não irá salvar todas as leituras do sistema.',
                                      icon: 'arrows-clockwise',
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 25,
                                        horizontal: 20,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 30,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: isLoading
                                          ? DefaultCircularIndicator
                                              .getIndicator()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Ultima sincronização",
                                                  style: theme
                                                      .textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  lastSync.isEmpty
                                                      ? 'Nunca sincronizado'
                                                      : lastSync,
                                                  style: theme
                                                      .textTheme.titleLarge!
                                                      .copyWith(
                                                    color: theme
                                                        .colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (properties.length > 3 &&
                                                        hasInternet)
                                                      Column(
                                                        children: [
                                                          getLoadingItens(),
                                                          if (isSyncing ||
                                                              isSyncingPost)
                                                            DefaultCircularIndicator
                                                                .getIndicator()
                                                          else
                                                            CustomFilledButton(
                                                                text:
                                                                    "Selecionar propriedades",
                                                                height: 40.v,
                                                                isDisabled:
                                                                    isSyncing ||
                                                                        isSyncingPost,
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                setState) {
                                                                          return CustomDialog(
                                                                            title:
                                                                                "Selecionar propriedades",
                                                                            text:
                                                                                "",
                                                                            buttons: [
                                                                              Column(
                                                                                children: [
                                                                                  for (var property in properties)
                                                                                    CheckboxListTile(
                                                                                      contentPadding: EdgeInsets.zero,
                                                                                      checkColor: Colors.white,
                                                                                      visualDensity: const VisualDensity(
                                                                                        horizontal: -4,
                                                                                        vertical: -4,
                                                                                      ),
                                                                                      title: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Flexible(
                                                                                            child: Text(property.name),
                                                                                          ),
                                                                                          if (syncProperties != null && syncProperties.contains(property.id.toString()))
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 5.0),
                                                                                              child: PhosphorIcon(
                                                                                                IconsList.getIcon('check'),
                                                                                                color: appTheme.green400,
                                                                                              ),
                                                                                            ),
                                                                                        ],
                                                                                      ),
                                                                                      value: selectedProperties.contains(property.id),
                                                                                      onChanged: (value) {
                                                                                        setState(() {
                                                                                          if (value == true) {
                                                                                            selectedProperties.add(property.id);
                                                                                          } else {
                                                                                            selectedProperties.remove(property.id);
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  CustomFilledButton(
                                                                                    text: "Concluir",
                                                                                    height: 40.v,
                                                                                    onPressed: () {
                                                                                      _syncOffline();
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                })
                                                        ],
                                                      )
                                                    else
                                                      Column(
                                                        children: [
                                                          getLoadingItens(),
                                                          hasInternet
                                                              ? CustomFilledButton(
                                                                  text: isSyncing
                                                                      ? ""
                                                                      : "Sincronizar leituras",
                                                                  height: 40.v,
                                                                  leftIcon:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10.0),
                                                                    child: isSyncing
                                                                        ? DefaultCircularIndicator.getIndicator(
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : PhosphorIcon(
                                                                            IconsList.getIcon('arrows-clockwise'),
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                  ),
                                                                  isDisabled:
                                                                      isSyncing ||
                                                                          isSyncingPost,
                                                                  onPressed:
                                                                      isSyncing ||
                                                                              isSyncingPost
                                                                          ? null
                                                                          : () {
                                                                              _syncOffline();
                                                                            },
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                  ],
                                                )
                                              ],
                                            ),
                                    ),
                                    Container(
                                      // margin: EdgeInsets.only(top: 20, bottom: 20),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 25,
                                        horizontal: 20,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 30,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Requisições à processar",
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                              !isSyncingPost
                                                  ? hasInternet &&
                                                          operations.isNotEmpty
                                                      ? CustomActionButton(
                                                          icon: 'upload-simple',
                                                          onTap: () {
                                                            _syncPost();
                                                          },
                                                        )
                                                      : Container()
                                                  : DefaultCircularIndicator
                                                      .getIndicator(size: 20),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          operations.isNotEmpty
                                              ? ListView(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    for (var operation
                                                        in operations)
                                                      if (!operation['url']
                                                              .contains(ApiRoutes
                                                                  .errorLog) ||
                                                          (operation['url']
                                                                  .contains(
                                                                      ApiRoutes
                                                                          .errorLog) &&
                                                              operation[
                                                                      'status'] ==
                                                                  3))
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: appTheme
                                                                  .gray300,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                operation['name'] !=
                                                                        null
                                                                    ? operation[
                                                                        'name']
                                                                    : 'Requisição genérica',
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 5,
                                                                    width: 5,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
                                                                    decoration: BoxDecoration(
                                                                        color: _getColor(operation[
                                                                            'status']),
                                                                        borderRadius:
                                                                            BorderRadius.circular(999)),
                                                                  ),
                                                                  Text(
                                                                    _getText(
                                                                        operation[
                                                                            'status']),
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                      color: _getColor(
                                                                          operation[
                                                                              'status']),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        drawer: needsToUpdate ? null : DrawerComponent(),
      ),
    );
  }

  Widget getLoadingItens() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textSync != '')
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              textSync,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        LinearProgressIndicator(
          value: step,
          backgroundColor: appTheme.gray300,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  void getProperties() {
    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listProperties}/${admin.id}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        properties = Property.fromJsonList(data['properties']);
        isLoading = false;
      });
    });
  }

  Color _getColor(status) {
    switch (status) {
      case 0:
        return appTheme.gray400;
      case 1:
        return appTheme.amber400;
      case 2:
        return appTheme.green400;
      case 3:
        return appTheme.red600;
      default:
        return appTheme.gray400;
    }
  }

  String _getText(status) {
    switch (status) {
      case 0:
        return "Aguardando conexão";
      case 1:
        return "Na fila/processando";
      case 2:
        return "Enviada";
      case 3:
        return "Erro";
      default:
        return "Aguardando conexão";
    }
  }

  _syncPost() async {
    operations = await PrefUtils().getAllPostRequest();

    if (operations.length == 0) {
      Dialogs.showGeralDialog(
        context,
        title: "Nenhuma requisição",
        text: "Não há requisições para serem sincronizadas",
      );
      setState(() {});
      return;
    }

    setState(() {
      isSyncingPost = true;
    });

    await NetworkOperations.checkPostQueue().then((value) async {
      isSyncingPost = false;
      operations = await PrefUtils().getAllPostRequest();
      setState(() {});
    }).catchError((error) async {
      Logger().e(error);
      isSyncingPost = false;
      operations = await PrefUtils().getAllPostRequest();
      setState(() {});
      SnackbarComponent.showSnackBar(context, "error", "Erro ao sincronizar");
    });
  }

  _syncOffline() async {
    try {
      setState(() {
        // Wakelock.toggle(enable: true);
        isSyncing = true;
        step = 0.1;
        textSync = "Processo iniciado, aguarde...";
      });

      // first part

      dynamic firstPart = await _getRequest(
        "${ApiRoutes.getOfflineFirstPart}/${admin.id}",
        'routes',
        (dynamic value) {
          return value;
        },
      );

      if (firstPart == null) {
        _errorHandling();
        return;
      }

      setState(() {
        step = 0.5;
        textSync = "Sincronizando propriedades e lavouras";
      });

      String urlSecondPart = "${ApiRoutes.getOfflineSecondPart}/${admin.id}";

      Map<String, dynamic> allData = {};
      // List<String> routesToRemove = [];

      if (selectedProperties.length > 3) {
        // fazer a requisição de 3 em 3 para não sobrecarregar o servidor
        for (var i = 0; i < selectedProperties.length; i += 3) {
          final properties = selectedProperties.sublist(
            i,
            i + 3 > selectedProperties.length
                ? selectedProperties.length
                : i + 3,
          );

          final route =
              "${urlSecondPart}?properties_id=${properties.join(",")}";

          dynamic secondPart = await _getRequest(
            route,
            'routes',
            (dynamic value) {
              return value;
            },
          );

          if (secondPart == null) {
            _errorHandling();
            return;
          }

          for (var route in secondPart.keys) {
            allData[route] = secondPart[route];
          }
        }
      } else {
        if (selectedProperties.isNotEmpty) {
          urlSecondPart += "?properties_id=${selectedProperties.join(",")}";
        }

        dynamic secondPart = await _getRequest(
          urlSecondPart,
          'routes',
          (dynamic value) {
            return value;
          },
        );
        if (secondPart == null) {
          _errorHandling();
          return;
        }

        for (var route in secondPart.keys) {
          allData[route] = secondPart[route];
        }
      }

      setState(() {
        step = 0.8;
        textSync = "Finalizando sincronização";
      });

      for (var route in firstPart.keys) {
        allData[route] = firstPart[route];
      }

      // Salva os dados no banco de dados SQLite
      await PrefUtils().setBulkSQLOfflineData(allData);

      if (selectedProperties.isNotEmpty) {
        if (syncProperties == null) {
          syncProperties = [];
        } else {
          syncProperties = syncProperties is String
              ? syncProperties.split(",")
              : syncProperties;
        }

        for (var property in selectedProperties) {
          if (!syncProperties.contains(property.toString())) {
            syncProperties.add(property.toString());
          }
        }

        await PrefUtils()
            .setSyncProperties("sync_properties", syncProperties.join(","));
      }

      selectedProperties = [];

      final dateNow = Formatters.formatDateString(
          DateTime.now().toString().substring(0, 10));

      PrefUtils().setLastSync(dateNow);

      if (mounted) {
        setState(() {
          // Wakelock.toggle(enable: false);
          step = 1;
          textSync = "Sincronização concluída!";
          isSyncing = false;
          lastSync = dateNow;
          currentProperty = 0;
        });
      }
      // });
    } catch (e) {
      Logger().e(e);
      _errorHandling();
    }
  }

  _getRequest(
    String route,
    String indexItem,
    dynamic function, {
    int cropJoinId = 0,
    bool validateError = true,
  }) async {
    try {
      bool isError = false;

      final response = await DefaultRequest.simpleGetRequest(
        route,
        context,
        showSnackBar: 0,
      ).catchError((error) {
        Logger().e(error);
        isError = true;
        _errorHandling();
      });

      if (isError) {
        return null;
      }

      dynamic items = [];

      final data = jsonDecode(response.body);

      if (data[indexItem] != null) {
        if (function != null) {
          items = function(data[indexItem]);
        }
      } else if (validateError) {
        isError = true;
      }

      if (route.contains(ApiRoutes.readPropertyHarvestDetails)) {
        final dateNow = DateTime.now().toString().substring(0, 10);

        final url =
            "${ApiRoutes.filterRainGauge}/${cropJoinId}/custom/${data['last_plant_rain_gauges']}/${data['end_plant_rain_gauges'] != null ? data['last_plant_disease'] : dateNow}";

        await DefaultRequest.simpleGetRequest(
          url,
          context,
          showSnackBar: 0,
        );
      }

      if (isError) {
        _errorHandling();
        return null;
      }

      if (function != null) {
        return items;
      } else {
        return true;
      }
    } catch (e) {
      Logger().e(e);
      _errorHandling();
      return null;
    }
  }

  _errorHandling() {
    if (mounted) {
      setState(() {
        // Wakelock.toggle(enable: false);
        step = 0;
        textSync = "Erro ao sincronizar";
        isSyncing = false;
      });
      SnackbarComponent.showSnackBar(context, "error", "Erro ao sincronizar");
    }
  }
}
