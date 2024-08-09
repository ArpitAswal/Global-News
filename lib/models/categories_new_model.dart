import 'articles_model.dart';

class CategoriesNewsModel {
  String? status;
  int? totalResults;
  late List<Articles> articles;

  CategoriesNewsModel({this.status, this.totalResults, required this.articles});

  CategoriesNewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles.add(Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
      data['articles'] = articles.map((v) => v.toJson()).toList();
    return data;
  }
}

