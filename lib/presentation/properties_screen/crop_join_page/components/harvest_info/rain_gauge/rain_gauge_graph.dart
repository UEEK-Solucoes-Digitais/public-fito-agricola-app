import 'dart:async';
import 'dart:convert';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/harvest_info/rain_gauge/rain_gauge_add_modal.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/harvest_info/rain_gauge/rain_gauge_list_modal.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class RainGaugeGraph extends StatefulWidget {
  int cropJoinId;
  String initRainGaugeDate;
  String endRainGaugeDate;

  RainGaugeGraph(
      {required this.cropJoinId,
      required this.initRainGaugeDate,
      required this.endRainGaugeDate,
      super.key});

  @override
  State<RainGaugeGraph> createState() => _RainGaugeGraphState();
}

class _RainGaugeGraphState extends State<RainGaugeGraph> {
  TextEditingController controllerInit = TextEditingController();
  TextEditingController controllerEnd = TextEditingController();

  dynamic rainGaugesInfos;

  Timer? searchDebounceInit;
  String lastSearchTextInit = '';

  Timer? searchDebounceEnd;
  String lastSearchTextEnd = '';

  bool networkOperation = false;

  bool isLoading = true;

  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      networkOperation = await NetworkOperations.checkConnection();

      await initFields();
      controllerInit.addListener(_onSearchChangedInit);
      controllerEnd.addListener(_onSearchChangedEnd);
    });
  }

  @override
  void dispose() {
    controllerInit.removeListener(_onSearchChangedInit);
    controllerInit.dispose();
    searchDebounceInit?.cancel();

    controllerEnd.removeListener(_onSearchChangedEnd);
    controllerEnd.dispose();
    searchDebounceEnd?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pluviômetro",
                          style: theme.textTheme.titleMedium,
                        ),
                        CustomFilledButton(
                          text: "+ Adicionar registro",
                          onPressed: () {
                            Dialogs.showGeralDialog(
                              context,
                              title: "Adicionar registro",
                              widget: RainGaugeAddModal(
                                cropJoinId: widget.cropJoinId,
                                reloadItens: initFields,
                              ),
                            );
                          },
                          height: 40.v,
                          width: 170.h,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                "Inicial",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: appTheme.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            CustomTextFormField(
                              controllerInit,
                              '',
                              controllerInit.text,
                              inputTextStyle: 'secondary',
                              icon: 'calendar',
                              readonly: true,
                              tapFunction: () async {
                                final DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(
                                    Formatters.formatDateStringEn(
                                        controllerInit.text),
                                  ),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (newDate != null) {
                                  setState(() {
                                    controllerInit.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(newDate)
                                            .toString();
                                  });
                                }
                              },
                              width: 150.h,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                "Final",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: appTheme.gray400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            CustomTextFormField(
                              controllerEnd,
                              '',
                              controllerEnd.text,
                              inputTextStyle: 'secondary',
                              icon: 'calendar',
                              readonly: true,
                              tapFunction: () async {
                                final DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(
                                    Formatters.formatDateStringEn(
                                        controllerEnd.text),
                                  ),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (newDate != null) {
                                  setState(() {
                                    controllerEnd.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(newDate)
                                            .toString();
                                  });
                                }
                              },
                              width: 150.h,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Precipitação",
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomOutlinedButton(
                                    height: 35.v,
                                    text: "Consultar registros",
                                    onPressed: () {
                                      Dialogs.showGeralDialog(
                                        context,
                                        title: "Registros pluviômetros",
                                        widget: RaingGaugeListModal(
                                          cropJoinId: widget.cropJoinId,
                                          initDate:
                                              Formatters.formatDateStringEn(
                                                  controllerInit.text),
                                          endDate:
                                              Formatters.formatDateStringEn(
                                                  controllerEnd.text),
                                          reloadItens: initFields,
                                        ),
                                      );
                                    },
                                    buttonTextStyle: TextStyle(
                                      fontSize: 14.v,
                                    ),
                                  ),
                                ),
                                if (networkOperation)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CustomOutlinedButton(
                                        height: 35.v,
                                        leftIcon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: PhosphorIcon(
                                            IconsList.getIcon(
                                                'arrow-square-out'),
                                            size: 20.v,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        text: "Exportar",
                                        buttonTextStyle: TextStyle(
                                          fontSize: 14.v,
                                        ),
                                        onPressed: () async {
                                          try {
                                            final url =
                                                "${dotenv.env['SYSTEM_URL']}/dashboard/exportar-graficos/${widget.cropJoinId}?start_date_rain_gauge=${Formatters.formatDateStringEn(controllerInit.text)}&end_date_rain_gauge=${Formatters.formatDateStringEn(controllerEnd.text)}";

                                            await launchUrl(
                                              Uri.parse(url),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (networkOperation)
                    Container(
                      height: 250,
                      margin: EdgeInsets.only(
                          top: 10, right: 20, bottom: 20, left: 10),
                      // width: 1100,
                      child: WebViewWidget(
                        controller: controller,
                      ),
                      // child: Container(),
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                        bottom: 30,
                      ),
                      child: Text(
                          "Os gráficos só estão disponíveis com conexão para internet. Utilize o botão \"Consultar registros\""),
                    ),
                  rainGaugesInfos != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 30,
                          ),
                          child: Wrap(
                            spacing: 20.h,
                            runSpacing: 20.v,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rainGaugesInfos['total_volume'],
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18.v,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Total(mm)",
                                      style: theme.textTheme.displayMedium),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rainGaugesInfos['avg_volume'] is String
                                        ? rainGaugesInfos['avg_volume']
                                        : rainGaugesInfos['avg_volume']
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18.v,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Média(mm)",
                                      style: theme.textTheme.displayMedium),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rainGaugesInfos['days_with_rain']
                                        .toString(),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18.v,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Dias\ncom chuva",
                                      style: theme.textTheme.displayMedium),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rainGaugesInfos['rain_interval'].toString(),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18.v,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Maior\nintervalo\nsem chuva",
                                      style: theme.textTheme.displayMedium),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rainGaugesInfos['days_without_rain']
                                        .toString(),
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 18.v,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Dias\nsem chuva",
                                      style: theme.textTheme.displayMedium),
                                ],
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          );
  }

  void _onSearchChangedInit() {
    if (Formatters.formatDateStringEn(controllerInit.text) ==
        Formatters.formatDateStringEn(lastSearchTextInit)) {
      return; // Não faz nada se o texto não mudou
    }

    if (searchDebounceInit?.isActive ?? false) searchDebounceInit?.cancel();

    searchDebounceInit = Timer(const Duration(milliseconds: 500), () {
      lastSearchTextInit = controllerInit.text;

      if (mounted) {
        SnackbarComponent.showSnackBar(
          context,
          'loading',
          'Filtrando pluviômetro',
          duration: Duration(seconds: 1),
        );
        controller = setController(
            Formatters.formatDateStringEn(controllerInit.text),
            Formatters.formatDateStringEn(controllerEnd.text));
        setState(() {});
      }
    });
  }

  void _onSearchChangedEnd() {
    if (Formatters.formatDateStringEn(controllerEnd.text) ==
        Formatters.formatDateStringEn(lastSearchTextEnd)) {
      return; // Não faz nada se o texto não mudou
    }

    if (searchDebounceEnd?.isActive ?? false) searchDebounceEnd?.cancel();

    searchDebounceEnd = Timer(const Duration(milliseconds: 500), () {
      lastSearchTextEnd = controllerEnd.text;

      if (mounted) {
        SnackbarComponent.showSnackBar(
          context,
          'loading',
          'Filtrando pluviômetro',
          duration: Duration(seconds: 1),
        );
        controller = setController(
            Formatters.formatDateStringEn(controllerInit.text),
            Formatters.formatDateStringEn(controllerEnd.text));
        setState(() {});
      }
    });
  }

  WebViewController setController(
    String initRainGaugeDate,
    String endRainGaugeDate,
  ) {
    _filterRainGauge();
    print(
        '${dotenv.env['SYSTEM_URL']}/webview-graph/${widget.cropJoinId}?start_date_rain_gauge=${initRainGaugeDate}&end_date_rain_gauge=${endRainGaugeDate}');
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
            '${dotenv.env['SYSTEM_URL']}/webview-graph/${widget.cropJoinId}?start_date_rain_gauge=${initRainGaugeDate}&end_date_rain_gauge=${endRainGaugeDate}'),
      ).catchError((error) {
        print("ERROR");
        print(error);
      });
  }

  _filterRainGauge() async {
    final init = controllerInit.text.contains("/")
        ? Formatters.formatDateStringEn(controllerInit.text)
        : controllerInit.text;

    final end = controllerInit.text.contains("/")
        ? Formatters.formatDateStringEn(controllerEnd.text)
        : controllerEnd.text;

    final url =
        "${ApiRoutes.filterRainGauge}/${widget.cropJoinId}/custom/${init}/${end}";

    await DefaultRequest.simpleGetRequest(
      url,
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      setState(() {
        rainGaugesInfos = data['rain_gauge_infos'];
      });
    }).catchError((error) {
      print(error);
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  initFields() async {
    controllerInit.text = widget.initRainGaugeDate;
    controllerEnd.text = widget.endRainGaugeDate;

    controller =
        setController(widget.initRainGaugeDate, widget.endRainGaugeDate);

    // await _filterRainGauge();

    controllerInit.text = Formatters.formatDateString(widget.initRainGaugeDate);
    controllerEnd.text = Formatters.formatDateString(widget.endRainGaugeDate);
    lastSearchTextInit = controllerInit.text;
    lastSearchTextEnd = controllerEnd.text;
    isLoading = false;

    setState(() {});
  }
}
