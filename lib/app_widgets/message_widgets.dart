
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MessageWidgets{

  static void toast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void showSnackBar(String message, {int? duration}) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: Duration(
        seconds: duration ?? 3,
      ),
    ));
  }
}