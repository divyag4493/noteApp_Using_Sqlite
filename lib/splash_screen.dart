import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NotesPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000),
      child: Image.network(
        'https://thumbs.dreamstime.com/b/notes-icon-isolated-black-background-simple-vector-logo-notes-icon-isolated-black-background-164106419.jpg',
      ),
    );
  }
}
