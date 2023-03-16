import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/dreams_view.dart';
import '../presenter/dreams_presenter.dart';

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
    return Text(
          'Wake up at',
          style: TextStyle(color: Colors.blueAccent.shade700),
        );
  }

}