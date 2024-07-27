import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/Views/widget/just_audio_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constant.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  //final String audio;

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> with WidgetsBindingObserver {
  dynamic args = Get.arguments;

  //String desc = Helper.stripHtml(Get.arguments[0]['description']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          (ThemeProvider.themeOf(context).id == "dark_theme") ? kBlueDarkColor : kBackgroundColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor:
            (ThemeProvider.themeOf(context).id == "dark_theme") ? kBlueDarkColor : kSecondryColor,
        elevation: 0,
        toolbarHeight: 70.h,
        actions: const [],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kBackgroundColor,
            size: 30.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '$appName  \n $appSubtitle',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            color: kBackgroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),

        // Text(
        //   args[0]["title"].toString().split(" ").length > 4
        //       ? appName +
        //           ' - ' +
        //           args[0]["title"].toString().split(" ").getRange(0, 4).join(" ") +
        //           "\n" +
        //           args[0]["title"]
        //               .toString()
        //               .split(" ")
        //               .getRange(4, args[0]["title"].toString().split(" ").length)
        //               .join(" ")
        //       : appName + ' - ' + args[0]["title"].toString(),
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 15.sp,
        //     color: kBackgroundColor,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(height: 10),
            Text(
              args[0]['title'],
              style: TextStyle(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            CachedNetworkImage(
              width: MediaQuery.of(context).size.width * 0.9,
              imageUrl: imagesUrl + args[0]['bookCover'],
              // placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            SizedBox(height: 5),
            (args[0]['audioFile']?.isEmpty ?? true)
                ? SizedBox()
                : JustAudio(
                    args[0]['audioFile'],
                    speed: true,
                    volume: true,
                  ),
          ]),
        ),
      ),
    );
  }
}
