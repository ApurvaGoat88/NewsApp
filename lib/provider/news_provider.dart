import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:news_project/adapter/hive_adp.dart';
import 'package:news_project/model/dbmodel.dart';
import 'package:news_project/model/news_model.dart';
import 'package:news_project/screens/BookMarks.dart';
import 'package:news_project/services/db_service.dart';
import 'package:news_project/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final _service = NewsService();
  bool isLoading = false;
  // Box<News> _myboomarks = Hive.box('BookMarks');
  // Box<News> get bookmarksList => _myboomarks;
  final DBService _dbService = DBService();
  late List<HiveModel> _hiveList = _dbService.getlist();
  List<HiveModel> get hivelist => _hiveList;
  void addTask(int? index,HiveModel task) {
    _dbService.addList(index,task);
    notifyListeners();
  }

  // void updateTask(Task task) {
  //   _taskService.updateTask(task);
  //   notifyListeners();
  // }

  void deleteTask(int key) {
    _dbService.deletelist(key);
    notifyListeners();
  }

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
  void addInHive() {}
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
