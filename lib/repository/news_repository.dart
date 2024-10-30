import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';
import '../exceptions/app_exception.dart';

class NewsRepository {
  final String _apiKey = "8ca987d0aff74f569c19d2094098f9b2";

  Future<dynamic> fetchCountryNews(String? query,
      {required String country, required int dataSize}) async {
    try {
      String newsUrl;
      if (query == null) {
        newsUrl =
            "https://newsapi.org/v2/everything?apiKey=$_apiKey&q=$country&pageSize=$dataSize";
      } else {
        newsUrl =
            'https://newsapi.org/v2/everything?q=($query)&apiKey=$_apiKey&pageSize=$dataSize';
      }
      final response = await http.get(Uri.parse(newsUrl));
      return returnResponse(response);
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }

  Future<dynamic> fetchCategoryCountryBased(
      {required String category,
      required String country,
      required int dataSize}) async {
    try {
      String newsUrl =
          'https://newsapi.org/v2/everything?apiKey=$_apiKey&pageSize=$dataSize&q=("$category" AND "$country")';
      final response = await http.get(Uri.parse(newsUrl));
      return returnResponse(response);
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }

  Future<dynamic> fetchCountryTopHeadlines(String? query,
      {required String countryCode, required int dataSize}) async {
    try {
      String url;
      if (query == null) {
        url =
            "https://newsapi.org/v2/top-headlines?apiKey=$_apiKey&country=$countryCode&pageSize=$dataSize";
      } else {
        url =
            'https://newsapi.org/v2/top-headlines?apiKey=$_apiKey&pageSize=$dataSize&q=("$query")';
      }
      final response = await http.get(Uri.parse(url));
      return returnResponse(response);
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }
}
