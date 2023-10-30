import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_project/Features/Hive/hive_adp.dart';

import 'package:news_project/Model/news_model.dart';

class BookmarkProvider extends ChangeNotifier {
  Box<NewsModelAdp> _box = Hive.box<NewsModelAdp>('BookMark');
  Box<NewsModelAdp> get box => _box;
  late List<NewsModelAdp> _list = getlist();
  List<NewsModelAdp> get list => _list;
  void add_bookmark(News news) {
    if (_box.containsKey(news.id)) {
      deleteFromBookmark(news.id);

      print(_box.keys);
    } else {
      _box.put(news.id, NewsModelAdp.fromNews(news));
      addtolist(news);
    }
    notifyListeners();
  }

  void deleteFromBookmark(id) {
    print('delete called');
    print(id);
    _box.delete(id);
    // if (index == 0) {
    //   list.clear();
    //   _box.clear();
    //   notifyListeners();
    // }

    notifyListeners();
  }

  void addtolist(News news) {
    print('to list called');
    _list.add(NewsModelAdp.fromNews(news));
    notifyListeners();
  }

  List<NewsModelAdp> getlist() {
    print(_box.keys.toList());
    return box.values.toList();
  }
}
