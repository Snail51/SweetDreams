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
    List<String> links = ["https://www.cdc.gov/sleep/features/getting-enough-sleep.html",
        "https://www.cdc.gov/sleep/data-and-statistics/adults.html",
    "https://www.sleepfoundation.org/sleep-disorders"
    ];
    List<String> names = ["How much sleep should I get?",
      "National Trends in undersleeping",
      "Symptoms of common sleep disorders"
    ];
    List<String> desc = ["The CDC recommends how much sleep you need to get per night based on your age, and here is a table for every age range.",
      "Nationally, many adults struggle with getting enough sleep, as outlined here.",
      "Many people struggle with sleep disorders, here are some of the common symptoms that they have."
    ];


    for(int i = 0; i < links.length; i++) {
      content.add(ListTile(
        leading: InkWell(
          onTap: () => _launchUrl(Uri.parse(links[i])),
          child: Icon(Icons.open_in_new),
        ),
        title: Text(names[i]),
        subtitle:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: <Widget>[
                  Expanded(child: Text(desc[i]))]
                ),
              ],
            ),
        ),
      );
    }


    return Expanded(child: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index)
      {
        return Container(
          height: 75,
          color: Colors.greenAccent,
          child: content[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      addAutomaticKeepAlives: false,
    ));
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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
                    backgroundColor: Colors.blueAccent
                ),
                child: Text('Youtube Videos'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePage(database: widget.database)));
                },
              ),
              linksToWidget()
            ],
          )
      ),
    );
  }
}