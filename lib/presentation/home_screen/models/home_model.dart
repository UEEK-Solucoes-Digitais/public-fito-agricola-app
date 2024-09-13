// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:fitoagricola/presentation/home_screen/models/event_item_model.dart';
import 'grid_item_model.dart';
import 'list_item_model.dart';

/// This class defines the variables used in the [home_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class HomeModel extends Equatable {
  HomeModel({
    this.gridItemList = const [],
    this.listItemList = const [],
    this.eventItemList = const [],
  });

  List<GridItemModel> gridItemList;

  List<ListItemModel> listItemList;

  List<EventItemModel> eventItemList;

  HomeModel copyWith({
    List<GridItemModel>? gridItemList,
    List<ListItemModel>? listItemList,
    List<EventItemModel>? eventItemList,
  }) {
    return HomeModel(
      gridItemList: gridItemList ?? this.gridItemList,
      listItemList: listItemList ?? this.listItemList,
      eventItemList: eventItemList ?? this.eventItemList,
    );
  }

  @override
  List<Object?> get props => [gridItemList, listItemList, eventItemList];
}
