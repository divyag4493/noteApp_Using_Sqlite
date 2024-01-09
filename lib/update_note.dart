import 'package:flutter/material.dart';
import 'package:note_app/app_database.dart';
import 'package:note_app/main.dart';
import 'package:note_app/note_model.dart';

class UpdateNote extends StatefulWidget {
  String mTitle;

  String mDesc;

  int? id;

  UpdateNote({required this.mTitle, required this.mDesc, this.id});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  late AppDatabase myDB;
  List<NoteModel> arrNotes = [];
  late String newTitle;
  late String newDesc;

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myDB = AppDatabase.db;
    this.newTitle = widget.mTitle.toString();
    this.newDesc = widget.mDesc.toString();
    getNotes();
    //addNotes(titleController.text, descController.text);
  }

  void getNotes() async {
    arrNotes = await myDB.fetchAllNotes();
    setState(() {});
  }

  /*void addNotes(String title, String desc) async {
    bool check = await myDB.addNote(NoteModel(title: title, desc: desc));
    if (check) {
      arrNotes = await myDB.fetchAllNotes();
      setState(() {});
    }*/ /*
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF252525),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                      onTap: () async {
                        if (newTitle != '' && newDesc != '') {
                          await myDB.updateNote(NoteModel(
                              note_id: widget.id, title: newTitle, desc: newDesc));
          
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesPage()));
                          getNotes();
                        }
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
                            'Update',
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
              Form(
                child: TextFormField(
                  initialValue: newTitle,
                  onChanged: (val){
                    newTitle = val;
                  },
                  style: TextStyle(color: Color(0XFFFFFFFF)),
                  // controller: titleController, //titleController != '' ? TextEditingController(text: widget.mTitle) : titleController,
                  decoration: InputDecoration(
                      hintText: 'Title here!',
                      hintStyle: TextStyle(color: Color(0XFF8C8C8C)),
                      label: Text('Title',
                          style:
                              TextStyle(fontSize: 40, color: Color(0XFF8C8C8C))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                child: TextFormField(
                  initialValue: newDesc,
                  onChanged: (val){
                    newDesc = val;
                  },
                  style: TextStyle(color: Color(0XFFFFFFFF)),
                  maxLines: 15,
                  
                  // controller: descController,//descController != '' ? TextEditingController(text: widget.mDesc) : descController,
                  decoration: InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(color: Color(0XFF8C8C8C)),
                      label: Text('Description',
                          style:
                              TextStyle(fontSize: 26, color: Color(0XFF8C8C8C))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
