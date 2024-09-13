import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/utils/filter_crop.dart';
import 'package:fitoagricola/core/utils/formatters.dart';
import 'package:fitoagricola/data/models/crop/crop.dart';
import 'package:fitoagricola/data/models/crop_join/crop_join.dart';
import 'package:fitoagricola/widgets/custom_text_form_field.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CropList extends StatefulWidget {
  final dynamic crops;
  final double? height;
  const CropList(this.crops, {this.height, super.key});

  @override
  State<CropList> createState() => _CropListState();
}

class _CropListState extends State<CropList> {
  TextEditingController searchController = TextEditingController();
  dynamic crops = [];

  @override
  void initState() {
    super.initState();

    searchController.addListener(_onSearchChanged);

    crops = widget.crops;

    Future.delayed(Duration.zero, () {
      searchController.addListener(_onSearchChanged);
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: widget.height ?? 0.89,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PhosphorIcon(
                      IconsList.getIcon('list-dashes'),
                      size: 20,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Lavouras em lista",
                      style: theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  color: appTheme.gray400,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: CustomTextFormField(
                searchController,
                '',
                'Pesquisar lavoura',
                icon: 'magnifying-glass',
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // primary: false,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: crops.length,
                itemBuilder: (context, index) {
                  final crop = crops[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      vertical: -4,
                      horizontal: -4,
                    ),
                    onTap: () {
                      if (crop is CropJoin) {
                        // Logger().e(crop.harvest!.id);
                        FilterCrop.filterCrop(context, crop.id);
                      } else {
                        FilterCrop.filterCropByCropId(context, crop.id);
                      }
                    },
                    title: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: appTheme.gray300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop is Crop
                                ? crop.name
                                : "${crop.crop.name} ${crop.subharvestName ?? ''}",
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${Formatters.formatToBrl(double.parse(crop is Crop ? crop.area : crop.crop.area))} ${PrefUtils().getFullAreaUnit()}",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged() {
    if (searchController.text == "" || searchController.text.isEmpty) {
      setState(() {
        crops = widget.crops;
      });
    } else {
      setState(() {
        crops = widget.crops.where((element) {
          String cropItem = element is Crop ? element.name : element.crop.name;
          return cropItem
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }).toList();
      });
    }
  }
}
