import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_exception.dart';

dynamic returnResponse(http.Response response) {
  dynamic responseJson = jsonDecode(response.body);
  switch (response.statusCode) {
    case 200:
      return responseJson;
    case 201:
      return responseJson;
    case 400:
      throw AppException(
          type: ExceptionType.api, message: responseJson['message']);
    case 401:
      throw AppException(
          type: ExceptionType.api, message: responseJson['message']);
    case 404:
      throw AppException(
          type: ExceptionType.api, message: responseJson['message']);
    case 500:
    default:
      throw AppException(
          type: ExceptionType.api, message: responseJson['message']);
  }
}