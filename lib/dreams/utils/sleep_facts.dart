import 'package:flutter/material.dart';

import 'dart:math';

class FactContainer{

  List<String> facts = [
    "Dolphins sleep with only one hemisphere of their brain at a time",
    "Tiredness peaks around 2am and 2pm each day",
    "Humans spend an average of 1/3 of their life sleeping",
    "Sea Otters hold hands when sleeping to not drift apart",
    "Around 1/4 of adults use their phone to track their sleep",
    "The amount of sleep you need per night depends on your age. Generally, adults need 7 hours, teenagers need 9, and young chilren need 10+ hours",
    "Exercise can help your sleep quality",
    "Going to bed at the same time each night can help you fall asleep better",
    "Minnesotans generally sleep the best in the US, with only 29% under-sleeping",
    "None of the developers slept during the development of this app",
    "Most dreams are forgotten shortly after waking up",

  ];


  getFactContainer() {
    return Container(
        height: 125,
        color: Colors.deepPurple,


        child: Column( mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /**
            Flex(direction: Axis.horizontal,
                children: [
                  Text("Fun Fact"),
                  Text(getRandomFact())
                ]),
             **/
            Padding(padding: EdgeInsets.all(5), child: Column(
                children: <Widget>[
                  Text("Fun Fact: ", style: TextStyle(
                    fontSize: 30,
                    color: Colors.white
                  ),),
                ],
              ),
              ),
    Padding(padding: EdgeInsets.all(5), child: Column(
                children: <Widget>[
                  Text(getRandomFact(), style: TextStyle(color: Colors.white), softWrap: true),
                ],
              )),
          ],

                )
    );
  }

  getRandomFact() { // https://stackoverflow.com/questions/11674820/how-do-i-generate-random-numbers-in-dart
    var rng = Random();
    int index = rng.nextInt(facts.length);

    return facts[index];
  }
}