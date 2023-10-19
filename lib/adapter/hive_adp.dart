import 'package:hive/hive.dart';
import 'package:news_project/model/news_model.dart';

part 'hive_adp.g.dart';

@HiveType(typeId: 1)
class HiveModel extends HiveObject {
  @HiveField(0)
  News news;

  @HiveField(1)
  int id;
    HiveModel({required this.news, required this.id});
}
