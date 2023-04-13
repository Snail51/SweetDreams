import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import 'create_diary.dart';

class DiaryPage extends StatefulWidget {

  DiaryPage({Key? key, required this.database, required this.fileLocation}) : super (key: key);
  SleepData database;
  String fileLocation = "";

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Diary"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text("Sleep Diary", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple), textScaleFactor: 3,)
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple
                ),
                child: Text('Create New Diary'),
                onPressed: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateDiaryPage(database: widget.database, fileLocation: widget.fileLocation,)));
                },
              ),
            ],
          )
      ),
    );
  }
}