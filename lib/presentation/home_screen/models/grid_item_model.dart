import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// This class is used in the [grid_item_widget] screen.
class GridItemModel {
  GridItemModel({
    this.categoryImg,
    this.category,
    this.id,
  }) {
    categoryImg = categoryImg  ?? PhosphorIcons.share();
    category = category ?? "Demanda";
    id = id ?? "";
  }

  IconData? categoryImg;

  String? category;

  String? id;
}
