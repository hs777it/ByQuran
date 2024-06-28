import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../constant.dart';

class BottomNavigationBarX extends StatelessWidget {
  const BottomNavigationBarX({super.key, required this.cIndex, this.func});

  final int cIndex;
  final Function(int)? func;

//  (index) {checkCurrentIndex(index);}

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: func,
      type: BottomNavigationBarType.fixed,
      currentIndex: cIndex,
      unselectedFontSize: 15.sp,
      selectedFontSize: 17.sp,
      backgroundColor: kBlueBackgroundColor,
      selectedItemColor: (ThemeProvider.themeOf(context).id == "dark_theme")
          ? kMainColor
          : kBlueDarkColor,
      unselectedItemColor: (ThemeProvider.themeOf(context).id == "dark_theme")
          ? kBlueGrey
          : kBlueGrey,
      items: [
        BottomNavigationBarItem(
          label: 'الرئيسية',
          icon: SvgPicture.asset('assets/icons/main_icon.svg', height: 23),
          // activeIcon: SvgPicture.asset('assets/icons/explore_colored.svg',
        ),
        BottomNavigationBarItem(
          label: 'المكتبة',
          icon: SvgPicture.asset('assets/icons/library_icon.svg', height: 23),
          // activeIcon: SvgPicture.asset('assets/icons/explore_colored.svg',
        ),
        const BottomNavigationBarItem(
          label: 'المفضلة',
          icon: Icon(
            Icons.bookmark,
            color: Color(0xff305F71),
          ),
          // activeIcon: SvgPicture.asset('assets/icons/explore_colored.svg',
        ),
        const BottomNavigationBarItem(
          label: 'الإعدادات',
          icon: Icon(
            Icons.settings,
            color: Color(0xff305F71),
          ),
          // activeIcon: SvgPicture.asset('assets/icons/explore_colored.svg',
        ),
      ],
    );
  }
}
