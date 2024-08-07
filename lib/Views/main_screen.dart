import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/Controller/ebook_controller.dart';
import 'package:welivewithquran/Models/category.dart';
import 'package:welivewithquran/Services/services.dart';
import 'package:welivewithquran/Views/category_view.dart';
import 'package:welivewithquran/Views/details_screen.dart';
import 'package:welivewithquran/Views/query_view.dart';
import 'package:welivewithquran/Views/widget/custom_text.dart';
import 'package:welivewithquran/models/ebook_org.dart';
import 'package:welivewithquran/models/search_query.dart';
import 'package:welivewithquran/models/surah.dart';

import '../constant.dart';
import 'widget/custom_divider.dart';
import 'widget/fahd_moshaf.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final BookController bookController = Get.put(BookController());

  int currentPage = 0;
  TextEditingController searchController = TextEditingController();
  int selectedSura = 1;

  bool? isLoading = null;
  Surah? surah;
  List<SearchQuery> data = List<SearchQuery>.empty();
  List<Ebook> featuredList = List<Ebook>.empty();
  int groupVal = 0;

  Future<void> setFeatured() async {
    var list = (await ApiService.getFeaturedEbooks())!;
    setState(() {
      featuredList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.put(BookController());

    return Obx(
      () => bookController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(color: kMainColor),
            )
          : RefreshIndicator(
              onRefresh: bookController.getCats,
              color: kMainColor,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: (ThemeProvider.themeOf(context).id == "dark_theme")
                      ? kBlueDarkColor
                      : kWhiteColor,
                  // image:  DecorationImage(
                  //   image:  AssetImage('assets/images/main_background.png'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 90.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Container(
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: TextFormField(
                              onChanged: (v) {
                                setState(() {
                                  if (searchController.text.isEmpty) {
                                    data = <SearchQuery>[];
                                  }
                                });
                              },
                              controller: searchController,
                              style: TextStyle(
                                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                    ? kMainColor
                                    : kSecondryColor,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'ابحث هنا',
                                hintStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                      ? kMainColor
                                      : kSecondryColor,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    // search
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    color: kSecondryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      switchWidget()
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  searchWidget() {
    return Column(
      children: [
        SizedBox(
          height: 15.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            children: [
              Radio<int>(
                value: 0,
                groupValue: groupVal,
                onChanged: (value) {
                  setState(() {
                    groupVal = value!;
                  });
                },
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                text: 'بحث فى الكل',
                fontSize: 18.sp,
                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                    ? kMainColor
                    : kSecondryColor,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: groupVal,
                onChanged: (value) {
                  setState(() {
                    groupVal = value!;
                  });
                },
              ),
              SizedBox(
                width: 5.w,
              ),
              CustomText(
                text: 'بحث فى سورة',
                fontSize: 18.sp,
                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                    ? kMainColor
                    : kSecondryColor,
              ),
              SizedBox(
                width: 20.w,
              ),
              FutureBuilder<List<Surah>?>(
                future: ApiService.getSurahs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    List<Surah> surahList = snapshot.data!;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff305F72),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          dropdownColor: const Color(0xff305F72),
                          icon: Padding(
                            padding: EdgeInsetsDirectional.only(start: 30.w),
                            child: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            color: Colors.white,
                          ),
                          value: selectedSura,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSura = newValue!;
                              surah = surahList.firstWhere(
                                (element) => int.parse(element.id) == newValue,
                              );
                            });
                          },
                          items: surahList.map<DropdownMenuItem<int>>((valueItem) {
                            return DropdownMenuItem(
                              value: int.parse(valueItem.id),
                              child: Text(
                                valueItem.surah,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: InkWell(
            onTap: () async {
              List<SearchQuery> list = (groupVal == 0 && surah == null)
                  ? (await ApiService.searchBooks(
                        searchController.text.trim(),
                      )) ??
                      []
                  : (await ApiService.searchBooksSpecific(
                        searchController.text.trim(),
                        surah!,
                      )) ??
                      [];
              setState(() {
                data = list;
                isLoading = false;
              });
            },
            child: Container(
              height: 40.h,
              width: 190.w,
              decoration: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CustomText(
                  text: 'بحث',
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        (isLoading != null && isLoading!)
            ? Center(
                child: CircularProgressIndicator(
                  color: kMainColor,
                ),
              )
            : (data.isEmpty && isLoading == false)
                ? Center(
                    child: Text("لا توجد نتائج بحث"),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      SearchQuery item = data[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => QueryView(item: item, query: searchController.text),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Card(
                              child: ListTile(
                                leading: Text("${item.surahTitle}"),
                                title: Text("${item.surahTitle} و ترتيبها رقم: ${item.surahNum}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("رقم الصفحة: ${item.pageNum}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
      ],
    );
  }

  mainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bookController.featuredList.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(color: kMainColor),
                ),
              )
            : Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: SizedBox(
                        child: CarouselSlider.builder(
                          itemCount: bookController.featuredList.length,
                          options: CarouselOptions(
                            onPageChanged: (page, reason) {
                              setState(() {
                                print(page);
                                currentPage = page;
                              });
                            },
                            reverse: true,
                            viewportFraction: .5,
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          itemBuilder: (context, index, realIdx) {
                            Ebook book = bookController.featuredList[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => DetailsScreen(),
                                  arguments: [
                                    {
                                      'id': book.id,
                                    },
                                    {
                                      'title': book.bookTitle,
                                    },
                                    {
                                      'bookCover': book.bookCoverImg,
                                    },
                                    {
                                      'bookPages': book.bookPages,
                                    },
                                    {
                                      'bookDescription': book.bookDescription,
                                    },
                                    {
                                      'bookFile': book.bookFileUrl,
                                    },
                                    {
                                      'authorName': book.authorName,
                                    },
                                    {
                                      'categoryName': book.categoryName,
                                    },
                                    {
                                      "book": book,
                                    },
                                    {
                                      "books": bookController,
                                    },
                                    {
                                      "condition": false,
                                    },
                                    // {
                                    //   "condition": false,
                                    // },
                                    {
                                      'audioFile': book.audioFile,
                                    },
                                  ],
                                );
                                // Navigator.of(context).push(_createRoute());
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: imagesUrl + book.bookCoverImg,
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          SizedBox(
                                        width: double.infinity,
                                        child: LinearProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: kBlueDarkColor.withOpacity(0.3)),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      book.bookTitle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: SizedBox(
                        height: 15.h,
                        width: 70,
                        child: ListView.builder(
                          itemCount: bookController.featuredList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                              child: CircleAvatar(
                                radius: 8.h,
                                backgroundColor:
                                    currentPage == index ? kMainColor : kBlueLightColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

        /// ------------------------------ Latest Books -----------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Text(
            "المضاف أخيرًا",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Padding(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: 0.3.sh,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bookController.latestBook.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => DetailsScreen(),
                        arguments: [
                          {
                            'id': bookController.latestBook[index].id,
                          },
                          {
                            'title': bookController.latestBook[index].bookTitle,
                          },
                          {
                            'bookCover': bookController.latestBook[index].bookCoverImg,
                          },
                          {
                            'bookPages': bookController.latestBook[index].bookPages,
                          },
                          {
                            'bookDescription': bookController.latestBook[index].bookDescription,
                          },
                          {
                            'bookFile': bookController.latestBook[index].bookFileUrl,
                          },
                          {
                            'authorName': bookController.latestBook[index].authorName,
                          },
                          {
                            'categoryName': bookController.latestBook[index].categoryName,
                          },
                          {
                            "book": bookController.latestBook[index],
                          },
                          {
                            "books": bookController,
                          },
                          {
                            "condition": false,
                          },
                          {
                            'audioFile': bookController.latestBook[index].audioFile,
                          },
                        ],
                      );
                      // Navigator.of(context).push(_createRoute());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: context.height * 0.2,
                            width: context.width * 0.50, //0.65
                            child: CachedNetworkImage(
                              imageUrl: imagesUrl + bookController.latestBook[index].bookCoverImg,
                              fit: BoxFit.fill, // content
                              progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
                                padding: const EdgeInsets.all(32.0).add(
                                  EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                                ),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: kBlueDarkColor,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            // Image.network(
                            //   imagesUrl + bookController.latestBook[index].bookCoverImg,
                            //   fit: BoxFit.contain,
                            // ),
                          ),
                          Text(
                            bookController.latestBook[index].bookTitle.split(" ").length > 4
                                ? bookController.latestBook[index].bookTitle
                                        .split(" ")
                                        .getRange(0, 4)
                                        .join(" ") +
                                    "\n" +
                                    bookController.latestBook[index].bookTitle
                                        .split(" ")
                                        .getRange(
                                          4,
                                          bookController.latestBook[index].bookTitle
                                              .split(" ")
                                              .length,
                                        )
                                        .join(" ")
                                : bookController.latestBook[index].bookTitle,
                            style: TextStyle(fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        // --------------------------------------------------------------------

        /// ------------------------------ Categories -----------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
          child: Text(
            'الأقسام',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 50.h,
          child: Obx(
            () => bookController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bookController.catList.map(
                      (Category cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () async {
                              Get.to(
                                () => CategoryScreen(
                                  cat: cat,
                                  ctrl: bookController,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: (ThemeProvider.themeOf(context).id == "dark_theme")
                                    ? kBlueLightColor
                                    : kSecondryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Center(
                                  child: Text(
                                    cat.categoryName,
                                    style: TextStyle(
                                      color: (ThemeProvider.themeOf(context).id == "dark_theme")
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
          ),
        ),
        // --------------------------------------------------------------------
        SizedBox(height: 15),
        CustomDivider(),
        SizedBox(height: 15),
        Center(child: FahdMoshaf()),
        SizedBox(height: 20),
      ],
    );
  }

  Widget switchWidget() {
    if (searchController.text.isNotEmpty) {
      return searchWidget();
    } else {
      return mainWidget();
    }
  }
}
