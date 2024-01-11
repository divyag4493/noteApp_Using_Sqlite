import 'package:flutter/material.dart';
import 'package:note_app/add_note_page.dart';
import 'package:note_app/app_database.dart';
import 'package:note_app/note_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/note_serch.dart';
import 'dart:math' as math show Random;

import 'package:note_app/splash_screen.dart';
import 'package:note_app/update_note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class NotesPage extends StatefulWidget {

  /* String? mTitle = '';
  String? mDesc = '';
  NotesPage({required this.mTitle,required this.mDesc});*/

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late AppDatabase myDB;
  List<NoteModel> arrNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();


  @override
  void initState() {
    super.initState();

      myDB = AppDatabase.db;
      getNotes();
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
      body: SingleChildScrollView(
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
                  Text('Notes',
                      style: TextStyle(fontSize: 40, color: Color(0XFFFFFFFF))),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(0XFF3B3B3B),
                      ),
                      child: InkWell(
                        onTap: () {
                          //TextFieldForSearch();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteSearch()));
                        },
                        child: Icon(Icons.search_rounded,
                            color: Color(0XFFB3B3B3), size: 40),
                      )),
                ],
              ),
            ),
            NoteSectionAll(),
            /* ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: arrNotes.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(arrNotes[index].title,style: TextStyle(fontSize: 22,color: Colors.white)),
                    subtitle: Text(arrNotes[index].desc,style: TextStyle(fontSize: 18,color: Colors.white)));
                }),*/
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          backgroundColor: Color(0XFF252525),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNotePage()));
            getNotes();

            /* showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).viewInsets.bottom > 0.0
                        ? 1000
                        : 600,
                    child: Column(
                      children: [
                        Text(
                          'Add Notes',
                          style: TextStyle(fontSize: 24),
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                              hintText: 'Enter Title Here..!',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: descController,
                          decoration: InputDecoration(
                              hintText: 'Enter Description Here..!',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              var title = titleController.text.toString();
                              var desc = descController.text.toString();
                              addNotes(title, desc);
                              titleController.text = '';
                              descController.text = '';
                              Navigator.pop(context);
                            },
                            child: Text('Save Note'))
                      ],
                    ),
                  );
                });*/
          },
          /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddUpdateNotePage()));*/ /*
          },*/
          child: Icon(Icons.add_card, color: Color(0XFFFFFFFF)),
        ),
      ),
    );
  }

  Widget NoteSectionAll() {
    return Container(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            child: MasonryGridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: arrNotes.length,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                crossAxisCount: 2,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        /*titleController.text = arrNotes[index].title;
                        descController.text = arrNotes[index].desc;*/

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateNote(
                                      mTitle: arrNotes[index].title,
                                      mDesc: arrNotes[index].desc,
                                      id: arrNotes[index].note_id,
                                    )));
                        getNotes();
                        /*showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom >
                                            0.0
                                        ? 1000
                                        : 600,
                                child: Column(
                                  children: [
                                    Text(
                                      'Update Notes',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                          hintText: 'Enter Title Here..!',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(21),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: descController,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Enter Description Here..!',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(21),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          var title =
                                              titleController.text.toString();
                                          var desc =
                                              descController.text.toString();
                                          await myDB.updateNote(NoteModel(
                                              note_id:
                                                  arrNotes[index].note_id,
                                              title: title,
                                              desc: desc));
                                          getNotes();
                                          titleController.text = '';
                                          descController.text = '';
                                          Navigator.pop(context);
                                        },
                                        child: Text('Update Note'))
                                  ],
                                ),
                              );
                            });*/
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.white.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.primaries[
                              math.Random().nextInt(Colors.primaries.length)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    index.isFinite
                                        ? arrNotes[index].title.length > 10
                                            ? "${arrNotes[index].title.substring(0, 10)}..."
                                            : arrNotes[index].title
                                        : arrNotes[index].title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                InkWell(
                                    onTap: () async {
                                      await myDB
                                          .deleteNote(arrNotes[index].note_id!);
                                      getNotes();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 26,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              index.isFinite
                                  ? arrNotes[index].desc.length > 200
                                      ? "${arrNotes[index].desc.substring(0, 200)}..."
                                      : arrNotes[index].desc
                                  : arrNotes[index].desc,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ))),
      ],
    ));
  }


}
