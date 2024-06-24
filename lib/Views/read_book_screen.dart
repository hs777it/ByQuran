// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:welivewithquran/Views/widget/just_audio_widget.dart';
import 'package:welivewithquran/constant.dart';
import 'package:welivewithquran/Views/widget/custom_text.dart';
import 'package:welivewithquran/helpers.dart';

import '../Controller/ebook_controller.dart';
// import '../models/ebook_org.dart';

class ReadBookScreen extends StatefulWidget {
  final bool fromSearch;
  const ReadBookScreen({Key? key, required this.fromSearch}) : super(key: key);

  @override
  State<ReadBookScreen> createState() => _ReadBookScreenState();
}

enum TtsState { playing, stopped, paused, continued }

class _ReadBookScreenState extends State<ReadBookScreen>
    with WidgetsBindingObserver {
  dynamic argumentData = Get.arguments;
  GetStorage storage = GetStorage();

  String desc = Helper.stripHtml(Get.arguments[0]['description']);

  FlutterTts tts = FlutterTts();

  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;
  //bool play = false;

  int end = 0;

  // String? _newVoiceText;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  List<int> savedPages = [];

  @override

  /// for Application state
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // inside didChangeAppLifecycle
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        await tts.stop();
        //setState(()=> play = false);
        break;
      case AppLifecycleState.resumed:
        // appLifeCycleState resumed
        break;
      case AppLifecycleState.paused:
        // appLifeCycleState paused
        break;
      case AppLifecycleState.detached:
        // appLifeCycleState detached
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
    //initTts();
    if (!widget.fromSearch) {
      BookController ctrl = Get.put(argumentData[0]['books']);
      Future.microtask(
        () async {
          final pages = await ctrl.getSavedPages(argumentData[0]["id"]);
          setState(() {
            savedPages = pages;
          });
        },
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tts.stop();
    TtsState.stopped;
    super.dispose();
  }

  initTts() async {
    final defaultV = await tts.getDefaultVoice;
    final List voices = await tts.getVoices;
    log(defaultV.toString());
    log(
      Map.from(
        voices
            .where(
              (element) => element["name"]!.contains("ar"),
            )
            .toList()[1],
      ).toString(),
    );
    log(
      Map.from(
        voices
            .where(
              (element) => element["name"]!.contains("ar"),
            )
            .toList()[0],
      ).toString(),
    );
    await tts.setLanguage('ar');
    await tts.setSpeechRate(rate);
    await tts.setPitch(pitch);
    await tts.setVolume(volume);
    await tts.setVoice(
      Map.from(
        voices
            .where(
              (element) => element["name"]!.contains("ar"),
            )
            .toList()[1],
      ),
    );

    if (isAndroid) {
      _getEngines();
    }

    tts.setStartHandler(() {
      setState(() {
        print('Playing');
        ttsState = TtsState.playing;
      });
    });

    tts.setCompletionHandler(() {
      setState(() {
        print('Complete');
        ttsState = TtsState.stopped;
      });
    });

    tts.setCancelHandler(() {
      setState(() {
        print('Cancel');
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      tts.setPauseHandler(() {
        setState(() {
          print('Paused');
          ttsState = TtsState.paused;
        });
      });

      tts.setContinueHandler(() {
        setState(() {
          print('Continued');
          ttsState = TtsState.continued;
        });
      });
    }

    tts.setErrorHandler((msg) {
      setState(() {
        print('error: $msg');
        ttsState = TtsState.stopped;
      });
    });

    tts.setProgressHandler(
        (String text, int startOffset, int endOffset, String word) {
      setState(() {
        end = endOffset;
      });
    });
  }

  Future _getEngines() async {
    var engines = await tts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  // Future _speak() async {
  //   int chars;
  //   desc.length > 4000 ? chars = 4000 : chars = desc.length;
  //   setState(() {
  //     _newVoiceText = desc.substring(0, chars);
  //   });
  //   if (_newVoiceText != null) {
  //     await tts.awaitSpeakCompletion(true);
  //     await tts.setQueueMode(1);

  //     var count = _newVoiceText!.length;
  //     var max = 2000;
  //     var loopCount = count ~/ max;
  //     for (var i = 0; i <= loopCount; i++) {
  //       if (i != loopCount) {
  //         await tts.speak(_newVoiceText!.substring(i * max, (i + 1) * max));
  //       } else {
  //         var end = (count - ((i * max)) + (i * max));
  //         await tts.speak(_newVoiceText!.substring(i * max, end));
  //       }
  //     }

  //     tts.setCompletionHandler(() {
  //       tts.stop();
  //     });
  //   }
  // }

  // Future _stop() async {
  //   var result = await tts.stop();
  //   if (result == 1)
  //     setState(
  //       () => ttsState = TtsState.stopped,
  //     );
  // }

  // Future _pause() async {
  //   var result = await tts.pause();
  //   if (result == 1)
  //     setState(
  //       () => ttsState = TtsState.paused,
  //     );
  // }

  final prefs = Get.find<SharedPreferences>();
  final PdfViewerController _controller = PdfViewerController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    bool isHorizontal = argumentData[0]["isHorizontal"];
    String? id = argumentData[0]["id"];
    // int? page = argumentData[0]["page"];
    // bool isFromFavs = argumentData[0]["condition"] as bool;
    // Ebook? book = argumentData[0]['book'];
    BookController ctrl = Get.put(argumentData[0]['books'] ?? BookController());

    return Scaffold(
      backgroundColor: (ThemeProvider.themeOf(context).id == "dark_theme")
          ? kBlueDarkColor
          : kBackgroundColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: (ThemeProvider.themeOf(context).id == "dark_theme")
            ? kBlueDarkColor
            : kMainColor,
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
          argumentData[0]["title"].toString().split(" ").length > 4
              ? appName +
                  ' - ' +
                  argumentData[0]["title"]
                      .toString()
                      .split(" ")
                      .getRange(0, 4)
                      .join(" ") +
                  "\n" +
                  argumentData[0]["title"]
                      .toString()
                      .split(" ")
                      .getRange(4,
                          argumentData[0]["title"].toString().split(" ").length)
                      .join(" ")
              : appName + ' - ' + argumentData[0]["title"].toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            color: kBackgroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 5),
            // Text('المؤلف: ' + argumentData[0]['author']),
            // SizedBox(height: 5),
            argumentData[0]['audioFile'].isNotEmpty
                ? JustAudio(argumentData[0]['audioFile'])
                : SizedBox(),
            // _btnSection(),
            // ttsState == TtsState.playing ? _progressBar(end) : const Text(''),
            if (savedPages.isNotEmpty)
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomText(
                        text: "الصفحات المفضلة",
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: savedPages.length,
                        itemBuilder: (context, index) {
                          final page = savedPages[index];
                          return InkWell(
                            onTap: () {
                              _controller.jumpToPage(page);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: kBlueDarkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "$page",
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Stack(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: widget.fromSearch
                          ? ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.difference),
                              child: SfPdfViewer.network(
                                argumentData[0]['pdf'],
                                controller: _controller,
                                pageLayoutMode: isHorizontal
                                    ? PdfPageLayoutMode.single
                                    : PdfPageLayoutMode.continuous,
                                enableDoubleTapZooming: true,
                                onDocumentLoadFailed: (details) {
                                  print(details.description);
                                },
                                onPageChanged: (details) async {
                                  log(details.newPageNumber.toString() +
                                      " " +
                                      _controller.pageNumber.toString());

                                  // setState(() {
                                  //   currentPage = details.newPageNumber;
                                  // });
                                },
                                onTextSelectionChanged: (details) {
                                  log(details.selectedText ?? "NULL");
                                },
                              ),
                            )
                          : SfPdfViewer.file(
                              File(argumentData[0]['pdf']),
                              pageLayoutMode: isHorizontal
                                  ? PdfPageLayoutMode.single
                                  : PdfPageLayoutMode.continuous,
                              enableDoubleTapZooming: true,
                              controller: _controller,
                              onPageChanged: (details) async {
                                log(details.newPageNumber.toString() +
                                    " " +
                                    _controller.pageNumber.toString());

                                // setState(() {
                                //   currentPage = details.newPageNumber;
                                // });
                              },
                              onDocumentLoadFailed: (details) {
                                print(details.description);
                              },
                              onTextSelectionChanged: (details) {
                                log(details.selectedText ?? "");
                              },
                            ),
                    ),
                    Positioned.directional(
                      textDirection: TextDirection.rtl,
                      start: 24,
                      top: 14,
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          !ctrl.isLoading.value
                              ? IconButton(
                                  onPressed: () async {
                                    log("SHARING");
                                    if (!widget.fromSearch) {
                                      await Share.share(
                                        "تدبر كتاب \"${argumentData[0]["title"]}\" :\n ${argumentData[0]["fileUrl"]}",
                                      );
                                    } else {
                                      await Share.share(
                                        "تدبر كتاب \"${argumentData[0]["title"]}\" :\n ${argumentData[0]['pdf']}",
                                      );
                                    }

                                    // await ctrl.share(
                                    //   page ?? _controller.pageNumber,
                                    //   book?.id ?? id!,
                                    // );
                                  },
                                  icon: Icon(Icons.share),
                                  color: (ThemeProvider.themeOf(context).id ==
                                          "dark_theme")
                                      ? kBlueLightColor
                                      : kBlueDarkColor
                                  // : Colors.grey,
                                  )
                              : CircularProgressIndicator(),
                          !widget.fromSearch
                              ? IconButton(
                                  onPressed: () async {
                                    final isBookmarked =
                                        await ctrl.isPageBookmarked(
                                      id!,
                                      _controller.pageNumber,
                                    );
                                    bool? res;
                                    if (isBookmarked) {
                                      res = await ctrl.removeBookmarkPage(
                                        id,
                                        _controller.pageNumber,
                                      );
                                    } else {
                                      res = await ctrl.bookmarkPage(
                                        id,
                                        _controller.pageNumber,
                                      );
                                    }
                                    final data = await ctrl.getSavedPages(id);
                                    setState(() {
                                      log(res.toString());
                                      savedPages = data;
                                    });
                                  },
                                  icon: !savedPages.contains(
                                    _controller.pageNumber,
                                  )
                                      ? Icon(Icons.bookmark_outline)
                                      : Icon(Icons.bookmark),
                                  color: savedPages.contains(
                                    _controller.pageNumber,
                                  )
                                      ? (ThemeProvider.themeOf(context).id ==
                                              "dark_theme")
                                          ? kBlueLightColor
                                          : kBlueDarkColor
                                      : kBlueDarkColor,
                                  // : Colors.grey,
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
