// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/Controller/ebook_controller.dart';
import 'package:welivewithquran/Models/category.dart';
import 'package:welivewithquran/Views/category_view.dart';
import 'package:welivewithquran/Views/favourite_screen.dart';
import 'package:welivewithquran/Views/library_screen.dart';
import 'package:welivewithquran/Views/main_screen.dart';
import 'package:welivewithquran/Views/settings_screen.dart';
import 'package:welivewithquran/constant.dart';
import 'widget/app_share.dart';
import 'widget/bottom_navigation.dart';
import 'widget/custom_divider.dart';
import 'widget/custom_text.dart';
import 'widget/fahd_moshaf.dart';
import 'widget/notify_button.dart';

class HomeScreen extends StatefulWidget {
  final int? index;
  HomeScreen({Key? key, int? this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late int currentIndex;
  PageController _pageController = PageController();

  GlobalKey<DrawerControllerState> drawerKey =
      GlobalKey<DrawerControllerState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> setPushState() async {
    var device = await OneSignal.shared.getDeviceState();
    return !device!.pushDisabled;
  }

  final BookController bookController = Get.put(BookController());
  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    if (_pageController.hasClients) {
      _pageController.jumpToPage(currentIndex);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> screen = [
    MainScreen(),
    LibraryScreen(),
    FavouriteScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Theme(
        data: ThemeProvider.themeOf(context).data,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            backgroundColor: kBackgroundColor,

            appBar: AppBar(
              elevation: 0,
              foregroundColor:
                  (ThemeProvider.themeOf(context).id == "dark_theme")
                      ? null
                      : kBlueDarkColor,
              backgroundColor: currentIndex == 0
                  ? (ThemeProvider.themeOf(context).id == "dark_theme")
                      ? kBlueDarkColor
                      : kBlueBackgroundColor
                  : Colors.transparent,
              toolbarHeight: 85.h,
              title: Text(
                'لنحيا بالقرآن\nد.فاطمة بنت عمر نصيف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: (ThemeProvider.themeOf(context).id == "dark_theme")
                      ? kBlueBackgroundColor
                      : kMainColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Image.asset(
                    'assets/images/app_bar_icon_new.png',
                    width: 40.w,
                    height: 40.h,
                  ),
                )
              ],
            ),
            drawer: FutureBuilder<bool>(
              future: setPushState(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  bool isListening = snapshot.data!;
                  return Drawer(
                    key: drawerKey,
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لنحيا بالقرآن',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: (ThemeProvider.themeOf(context).id ==
                                        "dark_theme")
                                    ? kBlueLightColor
                                    : kMainColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                              child: Image.asset(
                                'assets/images/app_bar_icon_new.png',
                                width: 30.h,
                                height: 30.h,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Text(
                        //   'الاقسام',
                        //   style: TextStyle(
                        //     fontSize: 24.sp,
                        //     color: (ThemeProvider.themeOf(context).id ==
                        //             "dark_theme")
                        //         ? kBlueLightColor
                        //         : kMainColor,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bookController.catList.map(
                            (Category cat) {
                              return InkWell(
                                onTap: () async {
                                  Get.to(
                                    () => CategoryScreen(
                                      cat: cat,
                                      ctrl: bookController,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    height: 50.h,
                                    width: 0.5.sw,
                                    decoration: BoxDecoration(
                                      color:
                                          (ThemeProvider.themeOf(context).id ==
                                                  "dark_theme")
                                              ? kBlueLightColor
                                              : kMainColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Center(
                                        child: Text(
                                          cat.categoryName,
                                          style: TextStyle(
                                            color:
                                                (ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "dark_theme")
                                                    ? kBlueDarkColor
                                                    : Colors.white,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        CustomDivider(),
                        const SizedBox(height: 10),
                        FahdMoshaf(),
                        const SizedBox(height: 10),
                        CustomDivider(),

                        AppShare(),
                        const SizedBox(height: 4),
                        /* GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Switch(
                                  activeColor: kBlueColor,
                                  value: isListening,
                                  onChanged: (value) async {
                                    await OneSignal.shared.disablePush(!value);
                                    setState(() {});
                                  },
                                ),
                                CustomText(
                                  text: 'تفعيل الإشعارات',
                                  color: kBlueColor,
                                  fontSize: 17.sp,
                                )
                              ],
                            ),
                          ),
                        ), */
                        NotifyButton(
                          active: isListening,
                          onChanged: (value) async {
                            await OneSignal.shared.disablePush(!value);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Switch(
                                  activeColor: kBlueColor,
                                  value: (ThemeProvider.themeOf(context).id ==
                                      "dark_theme"),
                                  onChanged: (bool val) {
                                    val
                                        ? ThemeProvider.controllerOf(context)
                                            .setTheme("dark_theme")
                                        : ThemeProvider.controllerOf(context)
                                            .setTheme("light_theme");
                                    // settingController.changeMode();
                                  },
                                ),
                                CustomText(
                                  text: 'الوضع الليلي',
                                  color: kBlueColor,
                                  fontSize: 17.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // CustomSettingItem(
                        //   image: 'assets/icons/exit.svg',
                        //   title: 'تسجيل خروج',
                        //   onPress: () {
                        //     logoutDialog(context);
                        //   },
                        //   icon: null,
                        // )
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: kBlueColor,
                  ),
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBarX(
                cIndex: currentIndex,
                func: (index) {
                  setState(() {
                    currentIndex = index;
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  });
                }),
            // --------------------------------------------------------
            /// Body
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              children: screen,
            ),
          ),
        ),
      ),
    );
  }

  // checkCurrentIndex(int index) {
  //   setState(() {
  //     currentIndex = index;
  //     _pageController.animateToPage(index,
  //         duration: Duration(milliseconds: 500), curve: Curves.ease);
  //   });
  // }
}
