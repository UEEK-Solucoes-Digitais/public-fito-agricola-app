import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// This class is used in the [list_item_widget] screen.
class ListItemModel {
  ListItemModel({
    this.icon,
    this.title,
    this.description,
    this.iconStatus,
    this.status,
    this.dateText,
    this.id,
  }) {
    icon = icon ?? PhosphorIcons.roadHorizon();
    title = title ?? "Buraco na via";
    description = description ?? "Estrada Geral";
    iconStatus = iconStatus ?? PhosphorIcons.share();
    status = status ?? '';
    dateText = dateText ?? "09/08/21";
    id = id ?? "";
  }

  IconData? icon;

  String? title;

  String? description;

  IconData? iconStatus;

  String? status;

  String? dateText;

  String? id;
}
