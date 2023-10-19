import 'package:hive/hive.dart';
import 'package:news_project/adapter/hive_adp.dart';

class DBService {
  final Box<HiveModel> _box = Hive.box<HiveModel>('BookMark');
  List<HiveModel> getlist() => _box.values.toList();
  void addList(int? index,HiveModel model) => _box.put(index ,model);
  void deletelist(int index ) => _box.delete(index);
}
