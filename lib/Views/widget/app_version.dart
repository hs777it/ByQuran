import 'package:flutter/material.dart';
import 'package:welivewithquran/services/services.dart';

import '../../constant.dart';
import 'custom_text.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>?>(
        future: DataServices.getAppDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            Map<String, String> data = snapshot.data!;

            return CustomText(
              text: "V${data["app_version"]!}",
              //color: (ThemeProvider.themeOf(context).id == "dark_theme")? kWhiteColor : kBlueLightColor,
              color: kBlueGrey,
              fontSize: 16, //16.sp,
            );
          } else
            return Center(
              child: LinearProgressIndicator(color: kMainColor),
            );
        });
  }
}
