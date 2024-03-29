import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_dialy_guide/models/surah.dart';
import 'package:muslim_dialy_guide/widgets/app_bar.dart';
import 'package:muslim_dialy_guide/widgets/arabic_quraan/bookmarks.dart';
import 'package:pdfx/pdfx.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_dialy_guide/globals/globals.dart' as globals;

class SurahViewBuilder extends StatefulWidget {
  SurahViewBuilder({
    Key? key,
    this.readingMode = false,
    required this.surah,
  }) : super(key: key);
  final Surah surah;
  final bool readingMode;

  @override
  _SurahViewBuilderState createState() => _SurahViewBuilderState();
}

class _SurahViewBuilderState extends State<SurahViewBuilder> {
  // PdfControllerPinch quranPdfController;
  late PdfController quranPdfController;

  /// My Document
  // PDFDocument _document;
  static const List<double> _doubleTapScales = <double>[1.0, 1.1];
  int? currentPage;
  // PageController pageController;

  bool isBookmarked = false;
  Widget _bookmarkWidget = Container();

  late SharedPreferences prefs;

  /*-----------------------------------------------------------------------------------------------*/
  /*----------------------------- Load PDF Documents -----------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  ///
  // Future<PDFDocument> _getDocument() async {
  //   if (_document != null) {
  //     return _document;
  //   }

  //   /*-----------------------------------------------------------------------------------------------*/
  //   /*----------------------------- Check Compatibility's [Android 5.0+] -----------------------*/
  //   /*-----------------------------------------------------------------------------------------------*/
  //   if (await hasSupport()) {
  //     _document = await PDFDocument.openAsset('assets/pdf/quran.pdf');
  //     return _document;
  //   } else {
  //     throw Exception(
  //       'المعذرة لا يمكن طباعة المحتوى'
  //           'يرجي التحقق من أن جهازك يدعم نظام أندرويد بنسخته 5 على الأقل',
  //     );
  //   }
  // }

  // PageController _pageControllerBuilder() {
  //   return new PageController(
  //       initialPage: widget.pages, viewportFraction: 1.1, keepPage: true);
  // }

  _saveToBookMark() {
    setState(() {
      globals.bookmarkedPage = globals.currentPage;
      print("toSave: ${globals.bookmarkedPage}");
    });
    if (globals.bookmarkedPage != null) {
      setBookmark(globals.bookmarkedPage!);
    }
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*----------------------------- set bookmarkPage in sharedPreferences  -----------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  void setBookmark(int _page) async {
    prefs = await SharedPreferences.getInstance();
    if (_page != null && !_page.isNaN) {
      await prefs.setInt(globals.BOOKMARKED_PAGE, _page);
    }
  }

  /*-----------------------------------------------------------------------------------------------*/
  /*-----------------------------  set lastViewedPage in sharedPreferences  -----------------------*/
  /*-----------------------------------------------------------------------------------------------*/
  Future<void> setLastViewedPage(int _currentPage) async {
    prefs = await SharedPreferences.getInstance();
    if (_currentPage != null && !_currentPage.isNaN) {
      globals.lastViewedPage = _currentPage;
      prefs.setInt(globals.LAST_VIEWED_PAGE, _currentPage);
      print('current page: $_currentPage');
    }
  }

  closePage(page) async {
    await page.close();
  }

  @override
  void initState() {
    /*-----------------------------------------------------------------------------------------------*/
    /*---------------------- Prevent screen from going into sleep mode ------------------------------*/
    /*-----------------------------------------------------------------------------------------------*/
    // Screen.keepOn(true);
    setState(() {
      /*-----------------------------------------------------------------------------------------------*/
      /*--------------------------------- init current page ------------------------------*/
      /*-----------------------------------------------------------------------------------------------*/
      globals.currentPage = widget.surah.pageIndex;
      // quranPdfController = PdfControllerPinch(
      //   document: PdfDocument.openAsset('assets/pdf/quran.pdf'),
      //   initialPage: globals.currentPage ?? 1,
      // );
      quranPdfController = PdfController(
        document: PdfDocument.openAsset('assets/pdf/quran.pdf'),
        initialPage: globals.currentPage ?? 1,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    quranPdfController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // pageController = _pageControllerBuilder();
    return Scaffold(
      appBar: buildAppBar(
        title: 'المصحف الشريف',
        actions: [
          IconButton(
            onPressed: () {
              if (globals.currentPage! < 569) {
                quranPdfController.nextPage(
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.ease,
                );
              }
            },
            icon: Icon(
              Icons.navigate_next,
              size: 35,
            ),
          ),
        ],
        context: context,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     quranPdfController.nextPage(
      //       duration: Duration(milliseconds: 500),
      //       curve: Curves.ease,
      //     );
      //   },
      //   child: Icon(Icons.next_plan),
      // ),
      body: quranPdfController == null
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : PdfView(
              controller: quranPdfController,
              scrollDirection: Axis.vertical,
              backgroundDecoration: BoxDecoration(
                color: Colors.white,
              ),
              builders: PdfViewBuilders<DefaultBuilderOptions>(
                options: DefaultBuilderOptions(),
                documentLoaderBuilder: (context) => Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                pageLoaderBuilder: (context) => Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),

              onDocumentError: (e) {
                print(e);
                Navigator.of(context).pop();
              },
              // renderer: (PdfPage page) => page.render(
              //   width: page.width * 2,
              //   height: page.height * 2,
              //   format: PdfPageImageFormat.jpeg,
              //   backgroundColor: '#FFFFFF',
              // ),
              onDocumentLoaded: (PdfDocument doc) {
                globals.lastViewedPage = widget.surah.pageIndex!;
                setLastViewedPage(globals.lastViewedPage);
                // if (currentPage == globals.bookmarkedPage) {
                //   isBookmarked = true;
                // } else {
                //   isBookmarked = false;
                // }
                // print("$isBookmarked:$currentPage");

                // if (isBookmarked) {
                //   _bookmarkWidget = Bookmark();
                // } else {
                //   _bookmarkWidget = Container();
                // }

                // Widget image = Stack(
                //   fit: StackFit.expand,
                //   children: <Widget>[
                //     Container(
                //       child: ExtendedImage.memory(
                //         pageImage.bytes,
                //         mode: ExtendedImageMode.gesture,
                //         initGestureConfigHandler: (_) => GestureConfig(
                //           //minScale: 1,
                //           // animationMinScale:1,
                //           // maxScale: 1.1,
                //           //animationMaxScale: 1,
                //           speed: 1,
                //           inertialSpeed: 100,
                //           //inPageView: true,
                //           initialScale: 1,
                //           cacheGesture: false,
                //         ),
                //         onDoubleTap: (ExtendedImageGestureState state) {
                //           final pointerDownPosition = state.pointerDownPosition;
                //           final begin = state.gestureDetails.totalScale;
                //           double end;
                //           if (begin == _doubleTapScales[0]) {
                //             end = _doubleTapScales[1];
                //           } else {
                //             end = _doubleTapScales[0];
                //           }
                //           state.handleDoubleTap(
                //             scale: end,
                //             doubleTapPosition: pointerDownPosition,
                //           );
                //         },
                //       ),
                //     ),
                //     isBookmarked == true ? _bookmarkWidget : Container(),
                //   ],
                // );
                // if (isCurrentIndex) {
                //   //currentPage=pageImage.pageNumber.round().toInt();
                //   image = Hero(
                //     tag: pageImage.pageNumber.toString(),
                //     child: Container(child: image),
                //     transitionOnUserGestures: true,
                //   );
                // }
                // return image;
              },
              onPageChanged: (page) {
                // globals.lastViewedPage = page;
                /// Update lastViewedPage
                setLastViewedPage(page);
              },
              // loaderSwitchDuration: Duration(seconds: 3),
              // pageSnapping: false,
            ),
    );
  }
}
