import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../views/create_log.dart';
import 'package:units/database.dart';
import '../views/edit_log.dart';

class SleepLogPage extends StatefulWidget {

  String fileLocation = "";
  SleepLogPage({Key? key, required this.database, required String file}) : super (key: key) {
    fileLocation = file;
  }

  SleepData database = SleepData();

  @override
  _SleepLogPageState createState() => _SleepLogPageState();

}

class _SleepLogPageState extends State<SleepLogPage> {
  @override
  void initState() {
    super.initState();
  }

  DateTime selectedDate = DateTime.fromMicrosecondsSinceEpoch(0);
  String labelSelectButton = "Find Log by Date";

  bool isOnSameDay(DateTime first, DateTime second)
  {
    Duration diff = first.difference(second);
    diff = diff.abs();
    if(diff.inDays <= 1)
    {
      return true;
    }
    else
    {
      return false;
    }

  }

  DateTime returnEpoch()
  {
    return DateTime.fromMicrosecondsSinceEpoch(0);
  }

  Widget sleepLogToWidget() {
    List<Widget> content = [];
    for (int i = 0; i < widget.database.getData().length; i++)
    {
      if(selectedDate != returnEpoch())
      {
        if(isOnSameDay(widget.database.getData()[i].sleep, selectedDate))
        {
          content.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flex(direction: Axis.horizontal,
                  children: [widget.database.getData(index: i)[0].toWidget()]),
              IconButton(
                  onPressed: () async{
                    await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EditLogPage(database: widget.database, log: widget.database.getData(index: i)[0])));
                    nullDateSelection();
                  },
                  //=> editEvent(i),
                  icon: const Icon(Icons.edit)),
            ],
          ),);
        }
      }
      else {
        content.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flex(direction: Axis.horizontal,
                children: [widget.database.getData(index: i)[0].toWidget()]),
            IconButton(
                onPressed: () async{
                  await Navigator.push(context, MaterialPageRoute(
                      builder: (context) => EditLogPage(database: widget.database, log: widget.database.getData(index: i)[0])));
                  nullDateSelection();
                },
                icon: const Icon(Icons.edit)),
          ],
        ),);
      }
    }
    return Expanded(child: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index)
      {
        return Container(
          height: 100,
          color: Colors.blueAccent,
          child: content[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      addAutomaticKeepAlives: false,
    ));

  }

  void editEvent(int index)
  {
    print("MESSAGE" + index.toString());


  }

  void nullDateSelection()
  {
    setState(() {
      selectedDate = returnEpoch();
      labelSelectButton = "Find Log by Date";
    });
  }

  @override
  Widget build(BuildContext context) {

    _selectDate(BuildContext context) async{ //Date Picker Popup
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked.add(Duration(hours: 12));
          labelSelectButton = DateFormat.MMMd().format(selectedDate) + ", " + DateFormat.y().format(selectedDate);
        });
    }

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
              onPressed: () async{
                await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateLogPage(database: widget.database)));
                nullDateSelection();
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 47),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                    ),
                    child: Text(labelSelectButton),
                    onPressed: () => _selectDate(context)
                ),
                IconButton(onPressed: () => nullDateSelection(), icon: const Icon(Icons.delete_forever), color: Colors.blueAccent,)
              ],
            ),
            ),
            sleepLogToWidget()
          ],
        ),
      ),
    );
  }
}