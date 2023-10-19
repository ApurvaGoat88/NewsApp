import 'package:flutter/material.dart';
import 'package:news_project/model/news_model.dart';
import 'package:news_project/services/news_service.dart';

class ListProvider extends ChangeNotifier {
  final _service = NewsService();
  bool isLoading = false;
  NewsModel _news = NewsModel();
  NewsModel _k = NewsModel();
  NewsModel get news => _news;
 
  // List<NewsModel> get _bookmark => bookmark 


  Future<NewsModel> get_list(String text) async {
    isLoading = true;
    notifyListeners();

    try {
      _news = await _service.fetch_news(text);
      return _news;
    } catch (e) {
      print('error');
      return _k;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
