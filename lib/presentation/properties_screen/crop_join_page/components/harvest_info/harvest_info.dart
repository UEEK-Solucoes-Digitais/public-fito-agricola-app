import 'dart:convert';

import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/harvest_info/diseases/diseases_graph.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/harvest_info/rain_gauge/rain_gauge_graph.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dropdown/dropdown_button_component.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HarvestInfo extends StatefulWidget {
  int cropJoinId;

  HarvestInfo(this.cropJoinId, {super.key});

  @override
  State<HarvestInfo> createState() => _HarvestInfoState();
}

class _HarvestInfoState extends State<HarvestInfo> {
  bool isLoading = true;

  String initRainGaugeDate = '';
  String endRainGaugeDate = '';
  String initDiseaseDate = '';

  int currentTab = 1;

  final tabs = [
    // seed, population, fertilizer, defensive, harvest
    {
      'id': 1,
      'icon': 'cloud-rain',
      'code': 'rain',
      'title': 'Chuva',
    },
    {
      'id': 2,
      'icon': 'magnifying-glass',
      'code': 'diseases',
      'title': 'Doenças',
    },
  ];

  initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getItens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: DropdownButtonComponent(
                  itens: tabs,
                  value: currentTab,
                  onChanged: (value) {
                    setState(() {
                      currentTab = value!;
                    });
                  },
                ),
              ),
              currentTab == 1
                  ? RainGaugeGraph(
                      cropJoinId: widget.cropJoinId,
                      initRainGaugeDate: initRainGaugeDate,
                      endRainGaugeDate: endRainGaugeDate,
                    )
                  : DiseaseGraph(
                      cropJoinId: widget.cropJoinId,
                      initDiseaseDate: initDiseaseDate,
                      endDiseaseDate:
                          DateTime.now().toString().substring(0, 10),
                    ),
            ],
          );
  }

  getItens() {
    final dateNow = DateTime.now().toString().substring(0, 10);
    DefaultRequest.simpleGetRequest(
      '${ApiRoutes.readPropertyHarvestDetails}/${widget.cropJoinId}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);

      // date now no formato YYYY-mm-dd

      setState(() {
        initRainGaugeDate = data['last_plant_rain_gauges'] != null
            ? data['last_plant_rain_gauges']
            : dateNow;
        endRainGaugeDate = data['end_plant_rain_gauges'] != null
            ? data['last_plant_rain_gauges']
            : dateNow;
        initDiseaseDate = data['last_plant_disease'] != null
            ? data['last_plant_disease']
            : dateNow;
      });
    }).catchError((error) {
      setState(() {
        initRainGaugeDate = dateNow;
        endRainGaugeDate = dateNow;
        initDiseaseDate = dateNow;
      });

      print(error);
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
}
