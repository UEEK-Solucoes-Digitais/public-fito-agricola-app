// ignore_for_file: must_be_immutable

part of 'home_notifier.dart';

/// Represents the state of Home in the application.
class HomeState extends Equatable {
  HomeState({
    this.user,
    this.homeModelObj,
  });

  HomeModel? homeModelObj;

  var user;

  @override
  List<Object?> get props => [
        user,
        homeModelObj,
      ];

  HomeState copyWith({
    var user,
    HomeModel? homeModelObj,
  }) {
    return HomeState(
      user: user ?? this.user,
      homeModelObj: homeModelObj ?? this.homeModelObj,
    );
  }
}
