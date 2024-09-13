import 'package:flutter/material.dart';
import 'package:fitoagricola/core/app_export.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgClock,
                    height: 46.v,
                    width: 51.h,
                    margin: EdgeInsets.only(top: 3.v),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 11.h),
                      child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "lbl_geren".tr,
                                style: CustomTextStyles.headlineLarge32,
                              ),
                              TextSpan(
                                text: "lbl_cit".tr,
                                style: CustomTextStyles.headlineLargeff63d9ff32,
                              )
                            ],
                          ),
                          textAlign: TextAlign.left))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
