// list of api routes

class ApiRoutes {
  static const String login = '/api/admin/login';
  static const String loginApi = '/api/login';
  static const String appVersion = '/api/settings/app-version';

  // seeds
  static const String listSeeds = '/api/inputs/cultures/list';
  static const String listDefensives = '/api/inputs/defensives/list';
  static const String listFertilizers = '/api/inputs/fertilizers/list';

  // notifications
  static const String listNotifications = '/api/notifications/list';

  // admin
  static const String listAdmins = '/api/admin/list';
  static const String readAdmin = '/api/admin/read';
  static const String updateAdmin = '/api/admin/update';
  static const String updateToken = '/api/admin/update-notification-token';
  static const String updateActualHarvest = '/api/admin/update-actual-harvest';
  static const String removeNotificationToken =
      '/api/admin/remove-notification-token';

  // contents
  static const String listContents = '/api/contents/list';
  static const String readContent = '/api/contents/read';
  static const String formContent = '/api/contents/form';

  static const String formComment = '/api/contents/form-comment';
  static const String likeComment = '/api/contents/like-comment';
  static const String removeComment = '/api/contents/remove-comment';

  static const String saveInteraction = '/api/contents/save-interaction';
  static const String updateWatched = '/api/contents/update-watched';

  // contentCategories
  static const String listContentCategories = '/api/contents/categories/list';
  static const String readContentCategory = '/api/contents/categories/read';

  // harvest
  static const String listHarvest = '/api/harvests/list';

  // rainGauge
  static const String formRainGauge = '/api/properties/rain-gauge/form';
  static const String filterRainGauge = '/api/properties/filter-rain-gauge';
  static const String deleteRainGauge = '/api/properties/rain-gauge/delete';

  // property
  static const String listProperties = '/api/properties/list';
  static const String readProperties = '/api/properties/read';
  static const String formProperties = '/api/properties/form';

  // assets
  static const String listAssets = '/api/assets/list';
  static const String formAssets = '/api/assets/form';
  static const String removeAssets = '/api/assets/delete';

  static const String readPropertyHarvest =
      '/api/properties/read-property-harvest';
  static const String readPropertyHarvestDetails =
      '/api/properties/read-crop-havest-details-mobile';

  // crops
  static const String getCrops = '/api/dashboard/get-crops';
  static const String getLinkedCrops = '/api/properties/read-linked-crops';
  static const String linkCrops = '/api/properties/link-crops';
  static const String getCropsByPropertyAndHarvest =
      '/api/properties/read-crops-by-property-and-harvest';

  // cropJoin
  static const String readCropJoin =
      '/api/properties/read-property-crop-join?crop_id=';
  static const String deleteCropJoin = '/api/properties/delete-crop-join';

  // managamentData
  static const String listManagamentData =
      '/api/properties/management-data/list';
  static const String deleteManagamentData =
      '/api/properties/management-data/delete';
  static const String formManagamentData =
      '/api/properties/management-data/form';
// register activity
  static const String registerActivity =
      '/api/properties/management-data/multipleForm';

  // interferenceFactor
  static const String listInterferenceFactorByJoin =
      '/api/interference-factors/list-by-join';
  static const String listWeeds = '/api/interference-factors/list/1';

  // monitoring
  static const String listMonitoring = '/api/properties/monitoring/list';
  static const String formMonitoring = '/api/properties/monitoring/form';
  static const String deleteMonitoring = '/api/properties/monitoring/delete';
  static const String changeDate = "/api/properties/monitoring/change-date";
  static const String deleteItem = '/api/properties/monitoring/delete-item';
  static const String deleteImage = '/api/properties/monitoring/delete-image';

  // reports
  static const String listReports = '/api/reports/list';

  // dashboard
  static const String getItens = '/api/dashboard/get-itens';

  // offline
  static const String getOfflineFirstPart = '/api/offline/get-first-part';
  static const String getOfflineSecondPart = '/api/offline/get-second-part';
  static const String getPartialSincronization =
      '/api/offline/get-partial-sync';

  // error-log
  static const String errorLog = '/api/error-log/form';
}
