import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/create_log.dart';
import 'package:units/database.dart';

class SleepLogPage extends StatefulWidget {

  SleepData database = SleepData();

  SleepLogPage()  {
    database.addEvent(DateTime.now().subtract(Duration(hours: 3)),wake: DateTime.now().add(Duration(hours: 3)),quality: 3, dream: "Test Dream Description");
    database.addEvent(DateTime.now().subtract(Duration(hours: 4)),wake: DateTime.now().add(Duration(hours: 2)),quality: 3, dream: "Test Dream Description");
  }

  @override
  _SleepLogPageState createState() => _SleepLogPageState();


}

class _SleepLogPageState extends State<SleepLogPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget sleepLogToWidget() {
    List<Widget> content = [];
    for (int i = 0; i < SleepLogPage().database.getData().length; i++) {
      content.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flex(direction: Axis.horizontal,
              children: [SleepLogPage().database.getData(index: i)[0].toWidget()]),
          IconButton(
              onPressed: () => editEvent(i), icon: const Icon(Icons.edit)),
        ],
      ),);
    }
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: content,
        ),
      ],
    );
  }

  void editEvent(int index)
  {
    print("MESSAGE" + index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Log'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text("Sleep Log", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent), textScaleFactor: 3,)
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent
              ),
              child: Text('Create New Log'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return CreateLogScreen();
                }));
                },
            ),
            sleepLogToWidget()
          ],
        ),
      ),
    );
  }
}

class CreateLogScreen extends StatefulWidget {
  @override
  _CreateLogScreen createState() => _CreateLogScreen();
}

class _CreateLogScreen extends State<CreateLogScreen> {
  @override
  Widget build(BuildContext context) {
    return new CreateLogPage(title: 'Create Log', key: Key("UNITS"),);
  }
}