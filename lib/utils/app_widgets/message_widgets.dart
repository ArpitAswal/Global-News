import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageWidgets {
  static void toast(String msg, {required ToastGravity gravity}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showSnackBar(String message, {int? duration}) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: Duration(
        seconds: duration ?? 5,
      ),
    ));
  }

  static Widget errorContainer(
      {required String msg,
      double? font,
      Color? textColor,
      FontWeight? weight,
      TextAlign? align,
      required double height,
      required String head}) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: Get.height * height,
        width: Get.width * 0.65,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(vertical: 16.0),
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
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 7,
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
            Spacer(),
            Flexible(
                flex: 3,
                child: RichText(
                    softWrap: true,
                    textAlign: align ?? TextAlign.center,
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                        text: "$head\n",
                        style: GoogleFonts.almendra(
                            fontSize: font ?? 16,
                            color: textColor ?? Colors.black,
                            fontWeight: weight ?? FontWeight.bold,
                            letterSpacing: 0.15),
                        children: <InlineSpan>[
                          TextSpan(
                            text: msg,
                            style: GoogleFonts.alumniSans(
                                fontSize: font ?? 14,
                                color: textColor ?? Colors.blue,
                                fontWeight: weight ?? FontWeight.w400,
                                letterSpacing: 0.15),
                          )
                        ])))
          ],
        ),
      ),
    );
  }

  static Widget imageError({double? textSize}) {
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

  static Widget showNoMoreArticles() {
    return Card(
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: Colors.white, width: 2)),
      shadowColor: Colors.grey,
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

  static Widget loadingError() {
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
}
