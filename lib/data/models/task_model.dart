import 'package:intl/intl.dart';

class TaskModel {
  TaskModel({
    this.id,
    required this.content,
    required this.date,
    required this.state,
  });

  final int? id;
  final String content;
  final bool state;
  final DateTime date;

  Map<String, dynamic> toMapSqlite() {
    return {
      'id': id,
      'content': content,
      'state': state? 1 : 0,
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'state': state,
      'date': date,
    };
  }
}