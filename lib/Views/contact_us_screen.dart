import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/constant.dart';
import 'package:welivewithquran/Views/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/services.dart';
import 'moshaf_screen.dart';
import 'widget/app_version.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor:
            (ThemeProvider.themeOf(context).id == "dark_theme") ? null : kBlueDarkColor,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor:
          (ThemeProvider.themeOf(context).id == "dark_theme") ? kSecondryColor : kBackgroundColor,
      body: Column(
        children: [
          Container(
            height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  (ThemeProvider.themeOf(context).id == "dark_theme") ? kBlueDarkColor : kMainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$appName  \n $appSubtitle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: (ThemeProvider.themeOf(context).id == "dark_theme")
                            ? null
                            : kSecondryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomText(
                      text: "اتصل بنا",
                      fontSize: 24.sp,
                      color: (ThemeProvider.themeOf(context).id == "dark_theme")
                          ? Colors.white
                          : kSecondryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          FutureBuilder<Map<String, String>?>(
            future: DataServices.getAppDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                Map<String, String> data = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: (ThemeProvider.themeOf(context).id == "dark_theme")
                          ? kBlueDarkColor
                          : kWhiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CustomText(
                          text: "وسائل الاتصال",
                          color: (ThemeProvider.themeOf(context).id == "dark_theme")
                              ? kWhiteColor
                              : kMainColor,
                          fontSize: 16.sp,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.email,
                              color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                  ? kWhiteColor
                                  : kMainColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri(
                                    scheme: 'mailto',
                                    path: data["app_email"]!,
                                  ),
                                );
                              },
                              child: CustomText(
                                text: "البريد الالكتروني :\n ${data["app_email"]!}",
                                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                    ? kWhiteColor
                                    : kMainColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.phone_android_outlined,
                                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                    ? kWhiteColor
                                    : kMainColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                text: "الهاتف: ",
                                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                    ? kWhiteColor
                                    : kMainColor,
                                fontSize: 15.sp,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrl(
                                    Uri(
                                      scheme: 'tel',
                                      path: data["app_contact"]!,
                                    ),
                                  );
                                },
                                child: CustomText(
                                  textDirection: TextDirection.ltr,
                                  text: data["app_contact"]!,
                                  color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                      ? kWhiteColor
                                      : kMainColor,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.language_outlined,
                              color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                  ? kWhiteColor
                                  : kMainColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => MoshafScreen(
                                    fileURL: data["app_website"]!,
                                  ),
                                );
                              },
                              child: CustomText(
                                text: "موقع الويب :\n${data["app_website"]!}",
                                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                    ? kWhiteColor
                                    : kMainColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40),
                          child: Divider(
                            thickness: 3,
                            color: kBackgroundColor,
                          ),
                        ),
                        AppVersion(),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(color: kMainColor),
              );
            },
          ),
        ],
      ),
    );
  }
}
