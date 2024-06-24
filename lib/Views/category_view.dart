import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/Controller/ebook_controller.dart';
import 'package:welivewithquran/Services/services.dart';
import 'package:welivewithquran/Views/details_screen.dart';
import 'package:welivewithquran/Models/category.dart';
import 'package:welivewithquran/models/ebook_org.dart';
import 'package:welivewithquran/constant.dart';
import 'package:welivewithquran/Views/widget/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryScreen extends StatelessWidget {
  final Category cat;
  final BookController ctrl;
  CategoryScreen({required this.cat, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(cat.categoryName),
        foregroundColor: (ThemeProvider.themeOf(context).id == "dark_theme")
            ? null
            : kBlueDarkColor,
        elevation: 0,
        backgroundColor: (ThemeProvider.themeOf(context).id == "dark_theme")
            ? kBlueDarkColor
            : kBlueLightColor,
      ),
      body: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (ThemeProvider.themeOf(context).id == "dark_theme")
              ? kBlueDarkColor
              : kWhiteColor,
          /*
          image: (ThemeProvider.themeOf(context).id == "dark_theme")
              ? null
              : DecorationImage(
                  image: AssetImage('assets/images/main_background1.png'),
                  fit: BoxFit.cover,
                ), 
          */
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h), //70.h
            /*
             Center(
              child: CustomText(
                text: cat.categoryName,
                fontSize: 32.sp,
                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                    ? blueLightColor
                    : mainColor,
                alignment: TextAlign.center,
              ),
            ), 
            */
            FutureBuilder<List<Ebook>?>(
              future: DataServices.getEbooksFromCat(cat.cid),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<Ebook> bookList = snapshot.data ?? [];
                  return bookList.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: bookList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, //2
                                childAspectRatio: .9, //.7
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => DetailsScreen(),
                                      arguments: [
                                        {
                                          'id': bookList[index].id,
                                        },
                                        {
                                          'title': bookList[index].bookTitle,
                                        },
                                        {
                                          'bookCover':
                                              bookList[index].bookCoverImg,
                                        },
                                        {
                                          'bookPages':
                                              bookList[index].bookPages,
                                        },
                                        {
                                          'bookDescription':
                                              bookList[index].bookDescription,
                                        },
                                        {
                                          'bookFile':
                                              bookList[index].bookFileUrl,
                                        },
                                        {
                                          'authorName':
                                              bookList[index].authorName,
                                        },
                                        {
                                          'categoryName':
                                              bookList[index].categoryName,
                                        },
                                        {
                                          "book": bookList[index],
                                        },
                                        {
                                          "books": ctrl,
                                        },
                                        {
                                          "condition": false,
                                        },
                                        {
                                          'audioFile':
                                              bookList[index].audioFile,
                                        },
                                      ],
                                    );
                                    // Navigator.of(context).push(_createRoute());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: SizedBox(
                                      height: 0.1.sh,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: kMainColor,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            child: Center(
                                              child: Text(
                                                bookList[index].bookTitle,
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
                                          SizedBox(height: 7.h),
                                          Expanded(
                                            child: SizedBox(
                                              height: 210.h,

                                              /// lib book width
                                              // width: 130.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: imagesUrl +
                                                      bookList[index]
                                                          .bookCoverImg,
                                                  fit: BoxFit.fill,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                                32.0)
                                                            .add(
                                                      EdgeInsets.symmetric(
                                                        horizontal: 32,
                                                        vertical: 8,
                                                      ),
                                                    ),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress,
                                                        color: kBlueDarkColor,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                                // Image.network(
                                                //   imagesUrl + bookList[index].bookCoverImg,
                                                //   fit: BoxFit.fill,
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(
                          color: (ThemeProvider.themeOf(context).id ==
                                  "dark_theme")
                              ? kBlueDarkColor
                              : null,
                          child: Center(
                            child: CustomText(
                              alignment: TextAlign.center,
                              text: "لا توجد سور في هذا القسم",
                              fontSize: 26.sp,
                              color: (ThemeProvider.themeOf(context).id ==
                                      "dark_theme")
                                  ? kBlueLightColor
                                  : kMainColor,
                            ),
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
          ],
        ),
      ),
    );
  }
}
