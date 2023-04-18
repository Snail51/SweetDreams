import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SomePage extends StatefulWidget {

  SomePage({Key? key}) : super (key: key);

  @override
  _SomePageState createState() => _SomePageState();
}

class _SomePageState extends State<SomePage> { // PAGE CLASS THAT WANTS TO DYNAMICALLY COELLATE WIDGETS THAT WERE GENERATED EXTERNALLY
  List<dynamic> content = [];
  List<Widget> displayables = [];

  @override
  void initState() {
    initContent();
    update();
    super.initState();
  }

  void update()
  {
    setState(() {
      List<Widget> holder = [];
      for (int i = 0; i < content.length; i++) {
        if(content[i].needsUpdating) //ONLY REDRAW WIDGETS THAT ACTUALLY NEED REDRAWING
        {
          holder.add(content[i].toWidget());
          content[i].needsUpdating = false;
        }
        else
        {
          holder.add(displayables[i]);
        }
      }
      displayables = holder;
    });
  }

  void initContent()
  {
    content.add(SomeWidgetClass("SomeWidget_One"));
    content.add(SomeWidgetClass("SomeWidget_Two"));
  }

  @override
  Widget build(BuildContext context) {

    final periodicTimer = Timer.periodic(
      const Duration(milliseconds: 200), //adjust this number for how often you want the screen refreshed
          (timer) {
        update();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Example of updating widgets that were dynamically created outside of a build function, because when they are outside of a build function they don't have access to setState()"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: displayables,
          )
      ),
    );
  }
}

class SomeWidgetClass // CONTENT CLASS THAT HAS NO ACCESS TO setState() BECAUSE IT IS OUTSIDE OF A STATEFUL CLASS
{
  String widgetLabel = "";
  bool buttonState = false;
  Color buttonColor = Colors.red;

  bool needsUpdating = true; // this is the variable that is actually important. make sure it starts true!


  SomeWidgetClass(String label)
  {
    widgetLabel = label;
  }

  void toggle()
  {
    needsUpdating = true; // our widget was interacted with, so we need to mark it as needing to be updated
    buttonState = !buttonState;
    if(buttonState)
    {
      buttonColor = Colors.green;
    }
    else
    {
      buttonColor = Colors.red;
    }
  }

  Widget toWidget() // we only return a widget when the implimenting class asks for it
  {
    return TextButton(
        onPressed: toggle,
        child: Text(widgetLabel),
    );
  }

}