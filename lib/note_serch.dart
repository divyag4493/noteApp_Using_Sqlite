import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/app_database.dart';
import 'package:note_app/main.dart';
import 'package:note_app/note_model.dart';
import 'package:note_app/update_note.dart';

import 'dart:math' as math show Random;

class NoteSearch extends StatefulWidget {
  const NoteSearch({super.key});

  @override
  State<NoteSearch> createState() => _NoteSearchState();
}

class _NoteSearchState extends State<NoteSearch> {
  late AppDatabase myDB;
  List<NoteModel> arrNotes = [];
  List<int> SearchResultIDs = [];


  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myDB = AppDatabase.db;
    getNotes();
  }
  void getNotes() async {
    arrNotes = await myDB.fetchAllNotes();
    setState(() {});
  }

  void SearchResults(String query) async{
    arrNotes.clear();
    setState(() {
      isLoading = true;
    });
    final ResultIds = await myDB.getNoteString(query); //= [1,2,3,4,5]
    List<NoteModel?> arrNotesLocal = []; //[nOTE1, nOTE2]
    ResultIds.forEach((element) async{
      final SearchNote = await myDB.readOneNote(element);
      arrNotesLocal.add(SearchNote);
      setState(() {

        arrNotesLocal.add(SearchNote);

      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_outlined) , color:  Colors.white, ),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Search Your Notes",
                              hintStyle:
                              TextStyle(color:  Colors.white.withOpacity(0.5), fontSize: 16),
                            ),
                            onSubmitted: (value){
                              setState(() {

                                SearchResults(value.toLowerCase());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) :  NoteSectionAll()

                  ],
                ),
              )
          ),
        )
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
                                        //  getNotes();
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
              ),
        );
  }

  Widget TextFieldForSearch() {
    return Container(
      height: 50,
      width: 60,
      color: Colors.white.withOpacity(0.4),
    );
  }
}
