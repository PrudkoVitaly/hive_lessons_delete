
import 'package:hive/hive.dart';

part "data.g.dart";

@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String notes;

  @HiveField(2)
   bool isDone;

  Data({
    required this.title,
    required this.notes,
     this.isDone = false,
  });
}
