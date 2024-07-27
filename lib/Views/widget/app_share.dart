import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:welivewithquran/constant.dart';
import 'custom_setting_item.dart';

class AppShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomSettingItem(
      title: 'مشاركة التطبيق',
      onPress: () async {
        await Share.share(
            "$appName - $appSubtitle \n ${shareLink}",
            subject: 'لنحيا بالقرآن');
      },
      image: 'assets/icons/share.svg',
    );
  }
}
