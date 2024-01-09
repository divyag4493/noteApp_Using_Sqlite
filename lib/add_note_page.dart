import 'package:flutter/material.dart';
import 'package:note_app/app_database.dart';
import 'package:note_app/main.dart';
import 'package:note_app/note_model.dart';

class AddNotePage extends StatefulWidget {
  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late AppDatabase myDB;
  List<NoteModel> arrNotes = [];

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myDB = AppDatabase.db;
  }

  void getNotes() async {
    arrNotes = await myDB.fetchAllNotes();
    setState(() {});
  }

  void addNotes(String title, String desc) async {
    bool check = await myDB.addNote(NoteModel(title: title, desc: desc));
    if (check) {
      arrNotes = await myDB.fetchAllNotes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF252525),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0XFF3B3B3B),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_new,
                            color: Color(0XFFFFFFFF)),
                      )),
                  InkWell(
                    onTap: () {
                      var title = titleController.text.toString();
                      var desc = descController.text.toString();
                      if (title != '' && desc != '') {
                        addNotes(title, desc);
                        getNotes();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotesPage()));
                       // Navigator.pop(context);
                      }
                     // Navigator.pop(context);

                    },
                    child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color(0XFF3B3B3B),
                        ),
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 22,
                              color: Color(0XFFFFFFFF),
                              fontWeight: FontWeight.bold),
                        ))),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextField(
              style: TextStyle(color: Color(0XFFFFFFFF)),
              controller: titleController,
              decoration: InputDecoration(
                  hintText: 'Title here!',
                  hintStyle: TextStyle(color: Color(0XFF8C8C8C)),
                  label: Text('Title',
                      style: TextStyle(fontSize: 40, color: Color(0XFF8C8C8C))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide(color: Colors.transparent))),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              style: TextStyle(color: Color(0XFFFFFFFF)),
              maxLines: 7,
              controller: descController,
              decoration: InputDecoration(
                  hintText: 'Type something...',
                  hintStyle: TextStyle(color: Color(0XFF8C8C8C)),
                  label: Text('Description',
                      style: TextStyle(fontSize: 26, color: Color(0XFF8C8C8C))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide(color: Colors.transparent))),
            ),
          ],
        ),
      ),
    );
  }
}
