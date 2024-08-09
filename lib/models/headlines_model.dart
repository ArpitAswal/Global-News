import 'articles_model.dart';

class HeadlinesModel {
  String? status;
  int? totalResults;
  late List<Articles> articles;

  HeadlinesModel({this.status, this.totalResults, required this.articles});

  HeadlinesModel.fromJson(Map<String, dynamic> json) {
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
