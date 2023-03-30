import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import '../views/youtube_page.dart';

class InfoPage extends StatefulWidget {

  InfoPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Information"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent
                ),
                child: Text('Youtube Videos'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePage(database: widget.database)));
                },
              ),
            ],
          )
      ),
    );
  }
}