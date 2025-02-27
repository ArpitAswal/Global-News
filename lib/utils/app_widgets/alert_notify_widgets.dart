import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertNotifyWidgets {
  static final AlertNotifyWidgets _instance = AlertNotifyWidgets._internal();
  factory AlertNotifyWidgets() => _instance;
  AlertNotifyWidgets._internal();
  bool _isBottomSheetOpen = false;

  void showSnackBar(String message, {int? duration}) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: Duration(
        seconds: duration ?? 3,
      ),
    ));
  }

  Widget errorContainer({
    required String msg,
    double? font,
    Color? textColor,
    FontWeight? weight,
    TextAlign? align,
    required double height,
    required String head,
  }) {
    return Align(
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final maxHeight = screenHeight * height; // Maximum height constraint
          final containerWidth = screenWidth * 0.65;
          final currentFont = font ?? 16;
          final adjustedFont = currentFont * (screenWidth / 360); // Adjust font

          return Container(
            constraints: BoxConstraints(
              maxWidth: containerWidth,
              maxHeight: maxHeight,
            ),
            padding: EdgeInsets.zero,
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.white, blurRadius: 6.0, spreadRadius: 4.0),
                BoxShadow(
                    color: Colors.purpleAccent.shade200,
                    blurRadius: 8.0,
                    spreadRadius: 2.0),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded( // Expand the image to fill available space
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      "images/error.jpg",
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02).copyWith(bottom:
                   screenHeight * 0.005),
                  child: RichText(
                    softWrap: true,
                    textAlign: align ?? TextAlign.center,
                    text: TextSpan(
                      text: "$head\n",
                      style: GoogleFonts.almendra(
                        fontSize: adjustedFont,
                        color: textColor ?? Colors.black,
                        fontWeight: weight ?? FontWeight.bold,
                        letterSpacing: 0.15,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: msg,
                          style: GoogleFonts.alumniSans(
                            fontSize: adjustedFont * 0.9,
                            color: textColor ?? Colors.blue,
                            fontWeight: weight ?? FontWeight.w400,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget imageError({double? textSize}) {
    return ColoredBox(
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: 48,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: textSize ?? 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget showNoMoreArticles() {
    return Card(
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: Colors.white, width: 2)),
      shadowColor: Colors.grey,
      margin: EdgeInsets.only(bottom: 10),
      elevation: 8,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            "No More Articles!",
            style: GoogleFonts.alumniSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.lightBlue),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    );
  }

  Widget loadingError() {
    return Container(
      height: 120,
      width: 120,
      margin: EdgeInsets.only(left: 6.0),
      decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black87, spreadRadius: 1.0, blurRadius: 8.0)
          ]),
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 32,
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            "Error in loading more articles!",
            style: GoogleFonts.almendra(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          )
        ],
      ),
    );
  }

  void bottomSheet({required String status, required String msg}) {
    if (!_isBottomSheetOpen) {
      _isBottomSheetOpen = true;
      Get.bottomSheet(
          elevation: 8.0,
          ignoreSafeArea: true,
          persistent: true,
          isDismissible: false,
          enableDrag: false,
          Card(
            elevation: 5,
            shadowColor: Colors.grey[400],
            color: Colors.white,
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              width: Get.width,
              height: Get.height * .12,
              margin:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_off_rounded,
                      color: Colors.red,
                      size: Get.height * .04,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            msg,
                            softWrap: true,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(color: Colors.white),
                          backgroundColor: Colors.red[500],
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 12.0)),
                      child: const Text(
                        'Enable',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        Geolocator.openLocationSettings().whenComplete(() {
                          _isBottomSheetOpen = false;
                          Get.back();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ));
    }
  }

  Widget dataLoading() {
   return SpinKitFadingCircle(
      color: Colors.cyan,
      size: 50,
    );
  }
}
