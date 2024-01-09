import 'dart:io';

import 'package:note_app/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  ///for singleton database
  AppDatabase._();

  static final AppDatabase db = AppDatabase._();

  /// database variable
  Database? _database;
  static final Note_Table = 'note_table';
  static final Note_Id = 'note_id';
  static final Note_Title = 'note_title';
  static final Note_Desc = 'note_desc';

  Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(documentDirectory.path, 'noteDB.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          'Create table $Note_Table ( $Note_Id integer primary key autoincrement, $Note_Title text, $Note_Desc text)');
    });
  }

  Future<bool> addNote(NoteModel note) async {
    var db = await getDB();
    int rowsEffect = await db.insert(Note_Table, note.toMap());
    if (rowsEffect > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<NoteModel>> fetchAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> notes = await db.query(Note_Table);

    List<NoteModel> listNotes = [];

    for (Map<String, dynamic> note in notes) {
      //NoteModel model = NoteModel.fromMap(note);
      listNotes.add(NoteModel.fromMap(note));
    }
    return listNotes;
  }

  Future<NoteModel?> readOneNote(int id) async{
    var db = await getDB();
    final map = await db!.query(Note_Table ,
        where: '${Note_Id} = ?',
        whereArgs: [id]
    );
    if(map.isNotEmpty){
      return NoteModel.fromMap(map.first);
    }else{
      return null;
    }
  }

  Future<bool> updateNote(NoteModel note) async {
    var db = await getDB();
    var count = await db.update(Note_Table, note.toMap(),
        where: '$Note_Id = ${note.note_id}');
    return count > 0;
  }

  Future<bool> deleteNote(int id) async {
    var db = await getDB();
    var count =
        await db.delete(Note_Table, where: '$Note_Id = ?', whereArgs: ['$id']);
    return count > 0;
  }

  Future<List<int>> getNoteString(String query) async {
    var db = await getDB();
    final result = await db!.query(Note_Table);
    List<int> resultIds = [];
    result.forEach((element) {
      if (element[Note_Title].toString().toLowerCase().contains(query) ||
          element[Note_Desc].toString().toLowerCase().contains(query)) {
        resultIds.add(element[Note_Id] as int);
      }
    });
    return resultIds;
  }
}
