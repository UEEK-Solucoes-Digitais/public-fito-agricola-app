import 'dart:async';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class DiseaseGraph extends StatefulWidget {
  int cropJoinId;
  String initDiseaseDate;
  String endDiseaseDate;

  DiseaseGraph(
      {required this.cropJoinId,
      required this.initDiseaseDate,
      required this.endDiseaseDate,
      super.key});

  @override
  State<DiseaseGraph> createState() => _DiseaseGraphState();
}

class _DiseaseGraphState extends State<DiseaseGraph> {
  TextEditingController controllerInit = TextEditingController();
  TextEditingController controllerEnd = TextEditingController();

  Timer? searchDebounceInit;
  String lastSearchTextInit = '';

  Timer? searchDebounceEnd;
  String lastSearchTextEnd = '';

  bool isLoading = true;

  bool networkOperation = true;

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
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Doenças",
                          style: theme.textTheme.titleMedium,
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
                                          controllerInit.text)),
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
                                          controllerEnd.text)),
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Incidência",
                          style: theme.textTheme.titleMedium,
                        ),
                        CustomElevatedButton(
                          height: 40.v,
                          width: 130.h,
                          leftIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: PhosphorIcon(
                              IconsList.getIcon('arrow-square-out'),
                              size: 18.v,
                              color: Colors.white,
                            ),
                          ),
                          text: "Exportar",
                          buttonTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.v,
                          ),
                          onPressed: () async {
                            try {
                              final url =
                                  "${dotenv.env['SYSTEM_URL']}/dashboard/exportar-graficos/${widget.cropJoinId}?start_date_disease=${Formatters.formatDateStringEn(controllerInit.text)}&end_date_disease=${Formatters.formatDateStringEn(controllerEnd.text)}";

                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  if (networkOperation)
                    Container(
                      height: 250,
                      margin: const EdgeInsets.only(bottom: 30),
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
          'Filtrando doenças',
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
          'Filtrando doenças',
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
      String initDiseaseDate, String endDiseaseDate) {
    print(
        '${dotenv.env['SYSTEM_URL']}/webview-graph/${widget.cropJoinId}?start_date_disease=${initDiseaseDate}&end_date_disease=${endDiseaseDate}');

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
      ..loadRequest(Uri.parse(
              '${dotenv.env['SYSTEM_URL']}/webview-graph/${widget.cropJoinId}?start_date_disease=${initDiseaseDate}&end_date_disease=${endDiseaseDate}'))
          .catchError((error) {
        print("ERROR");
        print(error);
      });
  }

  initFields() async {
    controllerInit.text = widget.initDiseaseDate;
    controllerEnd.text = widget.endDiseaseDate;

    controller = setController(widget.initDiseaseDate, widget.endDiseaseDate);

    controllerInit.text = Formatters.formatDateString(widget.initDiseaseDate);
    controllerEnd.text = Formatters.formatDateString(widget.endDiseaseDate);
    lastSearchTextInit = controllerInit.text;
    lastSearchTextEnd = controllerEnd.text;
    isLoading = false;

    setState(() {});
  }
}
