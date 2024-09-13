import 'package:fitoagricola/core/utils/logout.dart';
import 'package:fitoagricola/presentation/assets_screen/assets_list.dart';
import 'package:fitoagricola/presentation/offline_sync_screen/offline_sync_screen.dart';
import 'package:fitoagricola/presentation/properties_screen/crop_join_page/crop_join_page.dart';
import 'package:fitoagricola/presentation/properties_screen/details/property_details.dart';
import 'package:fitoagricola/presentation/properties_screen/list/property_list.dart';
import 'package:fitoagricola/presentation/publications_screen/details/publication_details.dart';
import 'package:fitoagricola/presentation/publications_screen/list/publication_list.dart';
import 'package:fitoagricola/presentation/publications_screen/video_player/video_player_widget.dart';
import 'package:fitoagricola/presentation/reports_screen/reports_screen.dart';
import 'package:fitoagricola/presentation/settings_screen/settings_screen.dart';
import 'package:fitoagricola/presentation/user_screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitoagricola/presentation/splash_screen/splash_screen.dart';
import 'package:fitoagricola/presentation/login_screen/login_screen.dart';
import 'package:fitoagricola/presentation/home_screen/home_screen.dart';
import 'package:fitoagricola/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';

  static const String loginScreen = '/login_screen';

  static const String homeScreen = '/home_screen';

  static const String registerScreen = '/register_screen';

  static const String notificationScreen = '/notification_screen';

  static const String menuScreen = '/menu_screen';

  static const String updateUserScreen = '/update_user_screen';

  static const String construction_calender = '/construction_calender_screen';

  static const String events_calender = '/events_calender_screen';

  static const String event_detail = '/event_detail_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static const String logout = '/logout';

  static const String reportsScreen = 'reports_screen';

  static const String propertyList = '/properties_screen/list';

  static const String propertyDetails = '/properties_screen/details';

  static const String cropJoinPage = '/properties_screen/crop_join_page';

  static const String settingsPage = '/settings_screen';

  static const String offlinePage = '/offline_sync_screen';

  static const String userPage = '/user_screen';

  static const String publicationListPage = '/publications_screen/list';

  static const String publicationDetailsPage = '/publications_screen/details';

  static const String videoPlayer = '/publications_screen/video_player';

  static const String assetScreen = '/assets_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => LoginScreen(),
    logout: (context) => LogoutFunction(),
    reportsScreen: (context) => ReportsScreen(),
    propertyList: (context) => PropertyList(),
    settingsPage: (context) => SettingsScreen(),
    offlinePage: (context) => OfflineSyncPage(),
    userPage: (context) => UserScreenPage(),
    publicationListPage: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      return PublicationList(
        publicationId: args != null && args['publicationId'] != null
            ? args['publicationId'] is String
                ? int.parse(args['publicationId'])
                : args['publicationId']
            : null,
        contentType: args != null && args['contentType'] != null
            ? args['contentType'] is String
                ? int.parse(args['contentType'])
                : args['contentType']
            : null,
      );
    },
    assetScreen: (context) => AssetsList(),
    propertyDetails: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('propertyId')) {
        return PropertyDetails(
          args['propertyId'],
          harvestId: args['harvestId'],
        );
      } else {
        return PropertyList();
      }
    },
    cropJoinPage: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('cropJoinId')) {
        final page = args.containsKey('page') ? args['page'] : null;
        final pageSubType =
            args.containsKey('pageSubType') ? args['pageSubType'] : null;

        return CropJoinPage(args['cropJoinId'], page, pageSubType);
      } else {
        return PropertyList();
      }
    },
    publicationDetailsPage: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('publicationUrl')) {
        return PublicationDetails(publicationUrl: args['publicationUrl']);
      } else {
        return PublicationList();
      }
    },
    videoPlayer: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('videoUrl')) {
        return VideoPlayerWidget(
          videoUrl: args['videoUrl'],
          videoId: args['videoId'],
          reloadItems: args['reloadItems'],
          startAt: args['startAt'],
          durationTime: args['durationTime'],
          checkNextVideo: args['checkNextVideo'],
        );
      } else {
        return PublicationList();
      }
    },
  };
}
