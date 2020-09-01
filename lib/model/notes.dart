import 'package:hive/hive.dart';
part 'notes.g.dart';
@HiveType(typeId : 1)
class Notes {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  Notes(this.id, this.title, this.body);
}
