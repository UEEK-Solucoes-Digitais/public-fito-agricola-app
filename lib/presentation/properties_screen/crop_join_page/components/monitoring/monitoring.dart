import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/components/monitoring/components/monitoring_table.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Monitoring extends StatelessWidget {
  int cropJoinId;
  List<CropJoin> cropJoins;

  Monitoring({required this.cropJoinId, required this.cropJoins, super.key});

  @override
  Widget build(BuildContext context) {
    return MonitoringTable(
      cropJoinId: cropJoinId,
      cropJoins: cropJoins,
    );
  }
}
