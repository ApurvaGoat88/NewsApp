import 'package:flutter/material.dart';
import 'package:news_project/model/news_model.dart';
import 'package:news_project/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final _service = NewsService();
  bool isLoading = false;
  NewsModel _news = NewsModel();
  NewsModel _k = NewsModel();
  NewsModel get news => _news;
  Map<String, int> fav = {};
  Map<String, int> get _fav => fav;
  Map<News, bool> bookmark = {};
  Map<News, bool> get _bookmark => bookmark;
  // List<NewsModel> get _bookmark => bookmark ;
  int count = 0;
  List<News> list = [];
  List<News> get _list => list;

  int get _count => _count;
  void add_list(News news) {
    if (bookmark[news] == false || bookmark[news] == null) {
      list.add(news);
      bookmark[news] = true;
      notifyListeners();
    } else {
      list.remove(news);
      bookmark[news] = false;
      notifyListeners();
    }
  }

  Future<NewsModel> get_news(String text) async {
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
