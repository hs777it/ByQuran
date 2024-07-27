import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/Controller/ebook_controller.dart';
import 'package:welivewithquran/Views/audio_screen.dart';
import 'package:welivewithquran/constant.dart';
import 'package:welivewithquran/Views/widget/custom_text.dart';

import 'widget/appbar_height.dart';

class AudioLibraryScreen extends StatelessWidget {
  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    // print("BookList: ${bookController.bookList.length}");
    //print("BookList: ${bookController.audioList.length}");
    return Obx(
      () => bookController.isLoading.value
          ? Center(child: CircularProgressIndicator(color: kMainColor))
          : RefreshIndicator(
              color: kMainColor,
              onRefresh: () => bookController.getAudio(),
              child: Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (ThemeProvider.themeOf(context).id == "dark_theme")
                      ? kBlueDarkColor
                      : kWhiteColor,
                ),
                child: Column(
                  children: [
                    //SizedBox(height: 70.h),
                    SizedBoxAppBarMaxHeight(),
                    CustomText(
                      text: 'مكتبة الصوتيات',
                      fontSize: 38.sp,
                      color: (ThemeProvider.themeOf(context).id == "dark_theme")
                          ? kBlueLightColor
                          : kSecondryColor,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: bookController.audioList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                          ? kSecondryColor
                                          : kBlueDarkColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        bookController.audioList[index].bookTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.5.sp,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.to(
                                () => AudioScreen(),
                                arguments: [
                                  {
                                    'id': bookController.audioList[index].id,
                                    'title': bookController.audioList[index].bookTitle,
                                    'bookCover': bookController.audioList[index].bookCoverImg,
                                    'bookPages': bookController.audioList[index].bookPages,
                                    'bookDescription':
                                        bookController.audioList[index].bookDescription,
                                    'bookFile': bookController.audioList[index].bookFileUrl,
                                    'authorName': bookController.audioList[index].authorName,
                                    'categoryName': bookController.audioList[index].categoryName,
                                    "book": bookController.audioList[index],
                                    "books": bookController,
                                    "condition": false,
                                    'audioFile': bookController.audioList[index].audioFile,
                                  }
                                ],
                              );
                              // Navigator.of(context).push(_createRoute());
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
