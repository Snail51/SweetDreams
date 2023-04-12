import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:units/database.dart';
import '../views/youtube_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

  linksToWidget() {
    List<Widget> content = [];
    List<String> links = [
      "https://www.cdc.gov/sleep/features/getting-enough-sleep.html",
      "https://www.cdc.gov/sleep/data-and-statistics/adults.html",
      "https://www.sleepfoundation.org/sleep-disorders",
      "https://www.mayoclinic.org/healthy-lifestyle/adult-health/in-depth/sleep/art-20048379",
      "https://www.sleepfoundation.org/stages-of-sleep",
      "https://www.sleepfoundation.org/mental-health",
      "https://www.sleepfoundation.org/nutrition",
      "https://www.sleepfoundation.org/snoring"
    ];
    List<String> names = ["How Much Sleep Should I Get?",
      "National Trends in Under-Sleeping",
      "Symptoms of Common Sleep Disorders",
      "Mayo Clinic Sleep Tips",
      "The 4 Stages of Sleep",
      "Sleep and Mental Health",
      "Nutrition and Sleep",
      "Information About Snoring"
    ];
    List<String> desc = ["The CDC recommends how much sleep you need to get per night based on your age, and here is a table for every age range.",
      "Nationally, many adults struggle with getting enough sleep, as outlined here.",
      "Many people struggle with sleep disorders, here are some of the common symptoms that they have.",
      "The Mayo Clinic recommends 6 steps that everyone take in order to sleep better.",
      "There are 4 stages of sleep, and knowing each stage and its purpose allows you to make more informed choices.",
      "While everyone is aware that sleep affects mental health, the specific effects of sleep are often unknown to people.",
      "Good nutrition can help one sleep better. Here are its effects and how to improve nutrition for sleep.",
      "Snoring is commonly associated with sleep, but it comes in many forms. "
    ];


    for(int i = 0; i < links.length; i++) {
      content.add(ListTile(
        leading: InkWell(
          onTap: () => _launchUrl(Uri.parse(links[i])),
          child: Icon(Icons.open_in_new, color: Colors.white),
        ),
        title: Text(names[i], style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white)),
        subtitle:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: <Widget>[
                  Expanded(child: Text(desc[i], style: const TextStyle(
                      color: Colors.white)))
                ]
                ),
              ],
            ),
        ),
      );
    }


    return Expanded(child: ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index)
      {
        return Container(
          height: 75,
          color: Colors.deepPurple,
          child: content[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      addAutomaticKeepAlives: false,
    ));
  }


  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Information"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                ),
                child: Text('Youtube Videos'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePage(database: widget.database)));
                },
              )
              ),
              linksToWidget()
            ],
          )
      ),
    );
  }
}