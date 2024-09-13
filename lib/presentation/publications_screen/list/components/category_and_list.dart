import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/data/models/content/content.dart';
import 'package:fitoagricola/data/models/content_category/content_category.dart';
import 'package:fitoagricola/presentation/publications_screen/details/bottom_sheet.dart';
import 'package:fitoagricola/widgets/custom_action_button.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:fitoagricola/widgets/default_circular_progress.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:fitoagricola/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/custom_search_view.dart';

class CategoryAndList extends StatefulWidget {
  int? publicationId;
  int? contentType;
  CategoryAndList({this.publicationId, this.contentType, super.key});

  @override
  State<CategoryAndList> createState() => _CategoryAndListState();
}

class _CategoryAndListState extends State<CategoryAndList> {
  List<ContentCategory> categories = [];
  List<Content> courses = [];
  List<Content> contents = [];
  List<Content> keepWatching = [];
  List<Content> savedContents = [];
  List<Content> mostWatched = [];
  List<Content> allContents = [];
  List<Content> newestContents = [];
  Map<int, List<Content>> groupedContent = {};
  int currentCategory = 0;
  bool isLoading = true;
  bool hasInternet = true;
  bool accessEnabled = true;
  Admin admin = PrefUtils().getAdmin();
  double cardHeight = SizeUtils.width > 420
      ? 170.v
      : (SizeUtils.width > 405
          ? 190.v
          : (SizeUtils.width >= 390 ? 160.v : 185.v));

  String searchText = '';

  double generalViewportFraction = SizeUtils.width > 420 ? 0.9 : 0.85;
  double courseViewportFraction = 0.6;
  double mostWatchedViewportFraction = 0.58;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      hasInternet = await NetworkOperations.checkConnection();
      print(SizeUtils.width);

      if (hasInternet) {
        await _getCategories();
        await _getContents();

        if (widget.publicationId != null) {
          Content? content;
          for (var item in allContents) {
            if (item.id == widget.publicationId) {
              content = item;
              break;
            }
          }

          if (content != null) {
            onTapContent(context, content);
          }
        }
      }
      isLoading = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? DefaultCircularIndicator.getIndicator(color: Colors.white)
        : hasInternet
            ? accessEnabled
                ? allContents.length > 0
                    ? _buildContent()
                    : _buildEmptyCourse()
                : _buildNoPermission()
            : _buildNoInternet();
  }

  _buildNoPermission() {
    return Container(
      height: SizeUtils.height - 130.v,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo-w-border.png',
            width: 100,
          ),
          SizedBox(height: 20),
          Text(
            "Acesso restrito",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: 20.v,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Caso queira liberar esse acesso, entre em contato.",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: 14.v,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          CustomElevatedButton(
            text: "Ir para o WhatsApp",
            onPressed: () {
              launchUrl(
                Uri.parse(
                  'https://wa.me/+555496219771?text=Olá, me chamo ${admin.name} e tenho interesse na área M.A',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _buildNoInternet() {
    return Container(
      height: SizeUtils.height - 130.v,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo-w-border.png',
            width: 100,
          ),
          SizedBox(height: 20),
          Text(
            "Sem conexão com a internet",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: appTheme.gray400,
              fontSize: 22.v,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buildEmptyCourse() {
    return Container(
      height: SizeUtils.height - 130.v,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo-w-border.png',
            width: 100,
          ),
          SizedBox(height: 20),
          Text(
            "Nenhum curso \nadicionado no momento",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: appTheme.gray400,
              fontSize: 22.v,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buildCategoryContents() {
    final contentCategories = allContents
        .where((content) =>
            content.categoriesIds.contains(currentCategory.toString()))
        .toList();

    if (contentCategories.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(5, 20, 0, 14),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Nenhum resultado encontrado",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20.fSize,
                  // fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                text: "Limpar filtros",
                onPressed: () {
                  currentCategory = 0;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cardContent(contentCategories, currentCategory, clearFilter: true),
      ],
    );
  }

  _getCategories() async {
    await DefaultRequest.simpleGetRequest(
      ApiRoutes.listContentCategories,
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);
      if (data != null) {
        categories = ContentCategory.listFromJson(data['categories']);
        setState(() {});
      }
    });
  }

  _getContents() async {
    final admin = PrefUtils().getAdmin();
    await DefaultRequest.simpleGetRequest(
      '${ApiRoutes.listContents}/${admin.id}/${widget.contentType}',
      context,
      showSnackBar: 0,
    ).then((value) {
      final data = jsonDecode(value.body);
      if (data != null) {
        courses = Content.listFromJson(data['courses']);
        contents = Content.listFromJson(data['contents']);
        savedContents = Content.listFromJson(data['saved_contents']);
        keepWatching = Content.listFromJson(data['keep_watching']);
        mostWatched = Content.listFromJson(data['most_viewed']);
        allContents = Content.listFromJson(data['all_contents']);
        newestContents = Content.listFromJson(data['newest']);
        groupedContent = groupContentsByCategoryId(
          contents,
          ContentCategory.listFromJson(data['content_categories']),
        );
        accessEnabled = data['access_enabled'];
        setState(() {});
      }
    });
  }

  _buildContent() {
    return OrientationBuilder(builder: (context, orientation) {
      final isLandscape = MediaQuery.of(context).size.width >
          MediaQuery.of(context).size.height;

      if (isLandscape) {
        generalViewportFraction = 0.4;
        courseViewportFraction = 0.3;
        mostWatchedViewportFraction = 0.3;
      } else {
        generalViewportFraction = SizeUtils.width > 420 ? 0.9 : 0.85;
        courseViewportFraction = 0.6;
        mostWatchedViewportFraction = 0.58;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilter(),
          //_buildCategories(),
          currentCategory != 0 ? _buildCategoryContents() : _buildContents(),
        ],
      );
    });
  }

  void onTapContent(BuildContext context, Content content,
      {bool keepWatching = false}) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(0.4),
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              bottomSheet: Container(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 1.5,
                    sigmaY: 1.5,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 0.95,
                    child: Container(
                      height: double.infinity,
                      decoration: new BoxDecoration(
                        color: appTheme.black300,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0),
                        ),
                      ),
                      child: Bottomsheet(
                        contentUrl: content.url,
                        reloadItems: _getContents,
                        keepWatching: keepWatching,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildFilter() {
    return Row(
      children: [
        Expanded(
          child: CustomSearchView(
            width: 200.h,
            autofocus: false,
            fillColor: appTheme.black600,
            iconColor: appTheme.whiteA700,
            hintText: "Pesquisar",
            hintStyle: CustomTextStyles.bodyLargeOnWhite!.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            textStyle: CustomTextStyles.bodyLargeOnWhite,
            borderDecoration: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.h),
              borderSide: BorderSide(
                color: appTheme.whiteA700,
                width: 1,
              ),
            ),
            onChanged: (value) {
              searchText = value;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: CustomFilledButton(
            text: 'Filtrar',
            width: 100.h,
            height: 50.v,
            buttonStyle: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(appTheme.black600),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.h),
              border: Border.all(
                width: 1.0,
                color: appTheme.whiteA700,
              ),
            ),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ),
      ],
    );
  }

  Map<int, List<Content>> groupContentsByCategoryId(
      List<Content> contents, List<ContentCategory> categories) {
    Map<int, List<Content>> groupedContents = {};

    categories.forEach((category) {
      groupedContents[category.id] = [];
    });

    for (var content in contents) {
      if (content.highlightCategoryId != null &&
          content.highlightCategoryId != 0) {
        if (!groupedContents.containsKey(content.highlightCategoryId)) {
          groupedContents[content.highlightCategoryId!] = [];
        }
        groupedContents[content.highlightCategoryId]!.add(content);
        continue;
      }

      final categories = content.categoriesIds;

      for (var categoryId in categories) {
        if (!groupedContents.containsKey(int.parse(categoryId))) {
          groupedContents[int.parse(categoryId)] = [];
        }
        groupedContents[int.parse(categoryId)]!.add(content);
      }
    }

    return groupedContents;
  }

  _buildContents() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: searchText != ''
                ? _buildSearchResponse()
                : [
                    _buildCourse(),
                    _defaultList('Minha lista', savedContents, false),
                    _defaultList('Continuar assistindo', keepWatching, true),
                    _buildMostWatched(mostWatched),
                    if (widget.contentType == 2)
                      _defaultList('Novidades', newestContents, false),
                    ...groupedContent.entries.map<Widget>((entry) {
                      List<Content> categoryContents = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardContent(categoryContents, entry.key),
                        ],
                      );
                    }).toList(),
                  ],
          ),
        );
      }),
    );
  }

  _buildSearchResponse() {
    final contentsFiltered = allContents.where((content) =>
        content.title.toLowerCase().contains(searchText.toLowerCase()));

    if (contentsFiltered.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 0, 14),
          child: Container(
            width: double.infinity,
            child: Text(
              "Nenhum resultado encontrado",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20.fSize,
                // fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ];
    }

    return [
      Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 20, 0, 14),
              child: Container(
                width: double.infinity,
                child: Text(
                  "Resultados da pesquisa",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20.fSize,
                    // fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 20 / 9,
                viewportFraction: generalViewportFraction,
                initialPage: 0,
                height: 200.v,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                padEnds: false,
              ),
              items: contentsFiltered
                  .map(
                    (content) => Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          height: cardHeight,
                          width: 320.h,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: GestureDetector(
                              onTap: () {
                                if (content.isAvailable != 0) {
                                  onTapContent(context, content);
                                } else {
                                  _launchWhatsApp(content);
                                }
                              },
                              child: Stack(
                                children: [
                                  ImageNetworkComponent.getImageNetwork(
                                    "${dotenv.env['IMAGE_URL']}/contents/${_getImage(content.image, content)}",
                                    370,
                                    double.infinity,
                                    BoxFit.cover,
                                  ),
                                  if (content.isAvailable == 0)
                                    Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: cardHeight,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        child: BackdropFilter(
                                          filter: ui.ImageFilter.blur(
                                            sigmaX: 1.5,
                                            sigmaY: 1.5,
                                          ),
                                          child: Image.asset(
                                            'assets/images/content_images/lock.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      )
    ];
  }

  _buildCourse() {
    if (courses.isEmpty) return SizedBox();

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 30, 0, 14),
            child: Container(
              width: double.infinity,
              child: Text(
                "Cursos",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20.fSize,
                  // fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 375,
              aspectRatio: 9 / 16,
              initialPage: 0,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              enableInfiniteScroll: courses.length > 3 ? true : false,
              padEnds: false,
              viewportFraction: courseViewportFraction,
            ),
            items: courses
                .map(
                  (content) => Container(
                    margin: EdgeInsets.all(10.0),
                    height: 370,
                    width: 212,
                    child: GestureDetector(
                      onTap: () {
                        if (content.isAvailable != 0) {
                          onTapContent(context, content);
                        } else {
                          _launchWhatsApp(content);
                        }
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            child: ImageNetworkComponent.getImageNetwork(
                              "${dotenv.env['IMAGE_URL']}/contents/${_getImage(content.courseCover, content)}",
                              370,
                              double.infinity,
                              BoxFit.contain,
                            ),
                          ),
                          if (content.isAvailable == 0)
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                alignment: Alignment.center,
                                height: 370,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: 2,
                                    sigmaY: 2,
                                  ),
                                  child: Image.asset(
                                    'assets/images/content_images/lock.png',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  _cardContent(List<Content> contents, int categoryId,
      {bool clearFilter = false}) {
    if (contents.isEmpty) return SizedBox();
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 20, 0, 14),
            child: Container(
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      categories
                          .firstWhere((element) => element.id == categoryId,
                              orElse: () {
                            return ContentCategory(id: 0, name: '--');
                          })
                          .name
                          .trim(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20.fSize,
                        // fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (clearFilter)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: CustomActionButton(
                        icon: "x",
                        onTap: () {
                          currentCategory = 0;
                          setState(() {});
                        },
                        backgroundColor: appTheme.red600,
                        borderColor: appTheme.red600,
                        iconColor: Colors.white,
                        height: 25,
                        width: 25,
                        iconSize: 16,
                      ),
                    )
                ],
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: cardHeight,
              aspectRatio: 20 / 9,
              viewportFraction: generalViewportFraction,
              initialPage: 0,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              enableInfiniteScroll: contents.length > 4 ? true : false,
              padEnds: false,
            ),
            items: contents
                .map(
                  (content) => Container(
                    margin: EdgeInsets.all(8.0),
                    height: cardHeight,
                    width: 320.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: GestureDetector(
                        onTap: () {
                          if (content.isAvailable != 0) {
                            onTapContent(context, content);
                          } else {
                            _launchWhatsApp(content);
                          }
                        },
                        child: Stack(
                          children: [
                            ImageNetworkComponent.getImageNetwork(
                              "${dotenv.env['IMAGE_URL']}/contents/${_getImage(content.image, content)}",
                              cardHeight,
                              double.infinity,
                              BoxFit.cover,
                            ),
                            if (content.isAvailable == 0)
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: cardHeight,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                      sigmaX: 1.5,
                                      sigmaY: 1.5,
                                    ),
                                    child: Image.asset(
                                      'assets/images/content_images/lock.png',
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  _defaultList(String title, List<Content> contents, bool showBar) {
    if (contents.iterator.moveNext() && contents.first.isAvailable != 0) {
      return Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 20, 0, 14),
              child: Container(
                width: double.infinity,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20.fSize,
                    // fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: showBar ? 230.v : cardHeight,
                aspectRatio: 20 / 9,
                viewportFraction: generalViewportFraction,
                initialPage: 0,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: false,
                enableInfiniteScroll: contents.length > 4 ? true : false,
                padEnds: false,
              ),
              items: contents
                  .map(
                    (content) => Container(
                      margin: EdgeInsets.all(8.0),
                      height: cardHeight,
                      width: 320.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: GestureDetector(
                          onTap: () {
                            if (content.isAvailable != 0) {
                              onTapContent(
                                context,
                                content,
                                keepWatching: showBar,
                              );
                            } else {
                              _launchWhatsApp(content);
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: cardHeight,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: ImageNetworkComponent.getImageNetwork(
                                  "${dotenv.env['IMAGE_URL']}/contents/${_getImage(content.image, content)}",
                                  double.infinity,
                                  double.infinity,
                                  BoxFit.cover,
                                ),
                              ),
                              if (content.isAvailable == 0)
                                Positioned(
                                  top: 0,
                                  height: cardHeight,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: cardHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                    child: BackdropFilter(
                                      filter: ui.ImageFilter.blur(
                                        sigmaX: 1.5,
                                        sigmaY: 1.5,
                                      ),
                                      child: Image.asset(
                                        'assets/images/content_images/lock.png',
                                      ),
                                    ),
                                  ),
                                ),
                              if (showBar)
                                Positioned(
                                  height: cardHeight,
                                  top: 0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: cardHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PhosphorIcon(
                                          IconsList.getIcon('play-fill'),
                                          size: 40,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if (showBar)
                                Positioned(
                                  bottom: 15,
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            60, 0, 60, 0),
                                        child: LinearProgressIndicator(
                                          value: _getProgressBar(
                                            content.videoSeconds!,
                                            content.watchedSeconds,
                                            content.countFinishedUser!,
                                            content.countVideos!,
                                          ),
                                          backgroundColor: appTheme.gray200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            theme.colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  _buildMostWatched(List<Content> newContent) {
    if (newContent.isEmpty) return SizedBox();
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 30, 0, 10),
            child: Container(
              width: double.infinity,
              child: Text(
                "Mais assistidos",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 190,
              initialPage: 0,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              padEnds: false,
              viewportFraction: mostWatchedViewportFraction,
            ),
            items: newContent.asMap().entries.map((entry) {
              int index = entry.key;
              Content content = entry.value;
              return Container(
                padding: const EdgeInsets.only(right: 10.0),
                // width: index > 0 ? 350 : 275,
                decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: appTheme.whiteA700,
                    //   width: 1,
                    // ),
                    ),
                child: GestureDetector(
                  onTap: () {
                    if (content.isAvailable != 0) {
                      onTapContent(context, content);
                    } else {
                      _launchWhatsApp(content);
                    }
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/images/content_images/${index + 1}.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        right: index == 0 ? 15 : 0,
                        bottom: 0,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: ImageNetworkComponent.getImageNetwork(
                            "${dotenv.env['IMAGE_URL']}/contents/${_getImage(content.mostWatchedCover, content)}",
                            180,
                            130,
                            BoxFit.cover,
                          ),
                        ),
                      ),
                      if (content.isCourse == 0 || content.isAvailable == 0)
                        Positioned(
                          right: index == 0 ? 15 : 0,
                          bottom: 0,
                          child: Container(
                            width: 130,
                            height: 180,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              // gradient: LinearGradient(
                              //   colors: [
                              //     Color.fromARGB(200, 0, 0, 0),
                              //     Color.fromARGB(0, 0, 0, 0)
                              //   ],
                              //   begin: Alignment.bottomCenter,
                              //   end: Alignment.topCenter,
                              // ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            child: content.isAvailable == 0
                                ? BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                      sigmaX: 1.5,
                                      sigmaY: 1.5,
                                    ),
                                    child: Image.asset(
                                      'assets/images/content_images/lock.png',
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Flexible(
                                      //   child: Text(
                                      //     '${content.title}',
                                      //     overflow: TextOverflow.ellipsis,
                                      //     maxLines: 2,
                                      //     style: TextStyle(
                                      //       color: Colors.white,
                                      //       fontSize: 16.0,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _getProgressBar(
    String duration,
    String watchedSeconds,
    int watchedVideos,
    int countVideos,
  ) {
    if (countVideos > 1) {
      return watchedVideos / countVideos;
    } else {
      return duration != '' && watchedSeconds != ''
          ? _getSeconds(duration, watchedSeconds)
          : 0.00;
    }
  }

  _getSeconds(String duration, String watchedSeconds) {
    // duration e watchedSeconds estão em formato hh:mm:ii
    int durationSeconds = _convertToSeconds(duration);
    int watchedSecondsInt = _convertToSeconds(watchedSeconds);

    return watchedSecondsInt / durationSeconds;
  }

  _convertToSeconds(String time) {
    List<String> timeList = time.split(':');

    if (timeList.length != 3) return 0;

    return int.parse(timeList[0]) * 3600 +
        int.parse(timeList[1]) * 60 +
        int.parse(timeList[2]);
  }

  _launchWhatsApp(Content content) {
    Dialogs.showGeralDialog(context,
        title: "Conteúdo bloqueado",
        text: "Para acessar o conteúdo, entre em contato.",
        widget: Column(
          children: [
            CustomElevatedButton(
              text: "Ir para o WhatsApp",
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://wa.me/+555496219771?text=Olá, me chamo ${admin.name} e tenho interesse no curso ${content.title}.',
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            CustomOutlinedButton(
              text: "Cancelar",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  _showFilterDialog() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(0.4),
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                extendBodyBehindAppBar: true,
                resizeToAvoidBottomInset: false,
                body: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: appTheme.black300,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Filtrar",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.v,
                                    fontWeight: FontWeight.w300),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Categorias",
                                  style:
                                      theme.textTheme.displayMedium!.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.v,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildFilterOption(
                                  "Todas as categorias",
                                  currentCategory,
                                  0,
                                  _changeCategory,
                                ),
                                for (var category in categories)
                                  _buildFilterOption(
                                    category.name,
                                    currentCategory,
                                    category.id,
                                    _changeCategory,
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _changeCategory(int value) {
    currentCategory = value;
    setState(() {});
  }

  _buildFilterOption(
    String text,
    int selectedValue,
    int newValue,
    dynamic action,
  ) {
    return GestureDetector(
      onTap: () {
        action(newValue);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Text(
          text.trim(),
          style: theme.textTheme.bodyMedium!.copyWith(
            color: selectedValue == newValue
                ? theme.colorScheme.secondary
                : Colors.white,
            fontSize: 16.v,
          ),
        ),
      ),
    );
  }

  _getImage(String? image, Content content) {
    if (image != null && image != '') {
      return image;
    } else {
      if (content.image != '') {
        return content.image;
      } else if (content.courseCover != '') {
        return content.courseCover;
      } else if (content.mostWatchedCover != '') {
        return content.mostWatchedCover;
      } else {
        return '';
      }
    }
  }
}
