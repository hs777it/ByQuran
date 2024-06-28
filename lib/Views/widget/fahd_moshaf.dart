import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant.dart';
import 'custom_text.dart';

class FahdMoshaf extends StatelessWidget {
  const FahdMoshaf({super.key});

  @override
  Widget build(BuildContext context) {
    var url = 'https://livebyquran.net/zbook/quran/';
    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception(
            'Could not launch ${url}',
          );
        }
      },
      // onTap: () {
      //   Get.to(
      //     () => MoshafScreen(
      //       fileURL: "https://livebyquran.net/zbook/quran/",
      //     ),
      //   );
      // },
      child: Container(
        height: 50.h,
        width: 0.5.sw,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: (ThemeProvider.themeOf(context).id == "dark_theme")
              ? kSecondryColor
              : kBlueDarkColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CustomText(
            text: "مصحف مجمع الملك فهد",
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
