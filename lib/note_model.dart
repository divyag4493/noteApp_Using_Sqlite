
import 'package:note_app/app_database.dart';

class NoteModel {
  int? note_id;
  String title;
  String desc;

  NoteModel({this.note_id, required this.title, required this.desc});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        note_id: map[AppDatabase.Note_Id],
        title: map[AppDatabase.Note_Title],
        desc: map[AppDatabase.Note_Desc]);
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.Note_Id:note_id,
      AppDatabase.Note_Title:title,
      AppDatabase.Note_Desc:desc,
    };
  }
}
