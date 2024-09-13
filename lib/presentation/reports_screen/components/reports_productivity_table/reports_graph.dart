import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class ReportGraph extends StatefulWidget {
  dynamic productivityGraph;
  ReportGraph({required this.productivityGraph, super.key});

  @override
  State<ReportGraph> createState() => _ReportGraphState();
}

class _ReportGraphState extends State<ReportGraph> {
  String keyToUse = 'productivity_per_hectare';
  String textToUse = 'kg';

  num maxWidth = 0;
  num maxWidthSc = 0;

  // Map<String, dynamic> data = {
  //   'reports': {
  //     'cultures': {
  //       'SOJA 23/24': {
  //         'productivity_per_hectare': 25942.00,
  //         'productivity_per_hectare_sc': 432.373,
  //         'codes': {
  //           'A1': {
  //             'productivity_per_hectare': 44300.0,
  //             'productivity_per_hectare_sc': 738.33
  //           }
  //         }
  //       },
  //       'MILHO 23/24': {
  //         'productivity_per_hectare': 7629.00,
  //         'productivity_per_hectare_sc': 127.0,
  //         'codes': {
  //           'B1': {
  //             'productivity_per_hectare': 10500,
  //             'productivity_per_hectare_sc': 175.0
  //           }
  //         }
  //       },
  //     }
  //   }
  // };

  @override
  void initState() {
    super.initState();

    print(widget.productivityGraph);

    Future.delayed(Duration.zero, () {
      _findMaxValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: appTheme.gray300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Média ponderada",
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _setTextToUse('kg');
                      _setKeyToUse('productivity_per_hectare');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: textToUse == 'kg'
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Kg",
                        style: theme.textTheme.displaySmall!.copyWith(
                          color: textToUse == 'kg'
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _setTextToUse('sc');
                      _setKeyToUse('productivity_per_hectare_sc');
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: textToUse == 'sc'
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Sc",
                        style: theme.textTheme.displaySmall!.copyWith(
                          color: textToUse == 'sc'
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(
                      color: Color(0xFFDEE2E6),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.productivityGraph.length > 0 &&
                        widget.productivityGraph['cultures'] != null &&
                        widget.productivityGraph['cultures'].length > 0)
                      for (var culture
                          in widget.productivityGraph['cultures'].keys)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                culture,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.v,
                                ),
                              ),
                              const SizedBox(height: 6),
                              for (var code in widget
                                  .productivityGraph['cultures'][culture]
                                      ['codes']
                                  .keys)
                                Column(
                                  children: [
                                    Text(
                                      code,
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        fontSize: 10.v,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                  ],
                                ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 120.h,
                    child: Stack(
                      children: [
                        // Expanded(
                        //   child: Container(
                        //     width: double.infinity,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.black),
                        //     ),
                        //   ),
                        // ),
                        Column(
                          children: [
                            if (maxWidth > 0)
                              ...widget.productivityGraph['cultures'].entries
                                  .map<Widget>((entry) {
                                var culture = entry.value;
                                double cultureWidth =
                                    (culture['productivity_per_hectare'] /
                                            maxWidth) *
                                        130.h *
                                        0.6;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 14.v,
                                              width: cultureWidth,
                                              decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.primary,
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .only(
                                                  topEnd: Radius.circular(10),
                                                  bottomEnd:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                textToUse == 'kg'
                                                    ? Formatters.formatToBrl(
                                                            culture[keyToUse])
                                                        .split(',')[0]
                                                    : Formatters.formatToBrl(
                                                        culture[keyToUse]),
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  fontSize: 10.v,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...culture['codes']
                                          .entries
                                          .map<Widget>((codeEntry) {
                                        var code = codeEntry.value;
                                        double codeWidth =
                                            (code['productivity_per_hectare'] /
                                                    maxWidth) *
                                                130.h *
                                                0.6;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .only(
                                                    topEnd: Radius.circular(10),
                                                    bottomEnd:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                height: 14.v,
                                                width: codeWidth,
                                              ),
                                              Container(
                                                child: Text(
                                                  textToUse == 'kg'
                                                      ? Formatters.formatToBrl(
                                                              code[keyToUse])
                                                          .split(',')[0]
                                                      : Formatters.formatToBrl(
                                                          code[keyToUse]),
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    fontSize: 10.v,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  _setTextToUse(String tab) {
    setState(() {
      textToUse = tab;
    });
  }

  _setKeyToUse(String tab) {
    setState(() {
      keyToUse = tab;
    });
  }

  _findMaxValue() {
    num max = 0;
    num maxSc = 0;

    if (widget.productivityGraph.length > 0 &&
        widget.productivityGraph['cultures'] != null &&
        widget.productivityGraph['cultures'].length > 0) {
      for (var culture in widget.productivityGraph['cultures'].values) {
        if (culture['productivity_per_hectare'] > max) {
          max = culture['productivity_per_hectare'];
        }

        if (culture['productivity_per_hectare_sc'] > maxSc) {
          maxSc = culture['productivity_per_hectare_sc'];
        }

        for (var code in culture['codes'].values) {
          if (code['productivity_per_hectare'] > max) {
            max = code['productivity_per_hectare'];
          }

          if (code['productivity_per_hectare_sc'] > maxSc) {
            maxSc = code['productivity_per_hectare_sc'];
          }
        }
      }
    }

    setState(() {
      maxWidth = max;
      maxWidthSc = maxSc;
    });

    print(maxWidth);
  }
}
