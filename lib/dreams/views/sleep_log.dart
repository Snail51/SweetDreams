import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/dreams_view.dart';
import '../presenter/dreams_presenter.dart';
import '../views/create_log.dart';

class SleepLogPage extends StatefulWidget {
  final UNITSPresenter presenter;

  SleepLogPage(this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SleepLogPageState createState() => _SleepLogPageState();
}

class _SleepLogPageState extends State<SleepLogPage>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Sleep Log"),
          ),
          body: Center(
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
                  child: Text('Sleep Log'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return CreateLogScreen();
                    }));
                  },
                )
              ],
            )
          ),
        )
      )
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
    return new CreateLogPage(new BasicPresenter(), title: 'Create Log', key: Key("UNITS"),);
  }
}