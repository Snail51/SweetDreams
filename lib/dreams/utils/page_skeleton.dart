/*

Add to main within the page's button
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return ScreenName();
    }));
  },
]

Add to main at the bottom [
    class ScreenName extends StatefulWidget {
      @override
      _ScreenName createState() => _ScreenName();
    }

    class _ScreenName extends State<ScreenName> {
      @override
      Widget build(BuildContext context) {
        return new PageName();
      }
    }
]

File Skeleton [
    import 'package:flutter/cupertino.dart';
    import 'package:flutter/material.dart';

    class PageName extends StatefulWidget {

      PageName();

      @override
      _PageNameState createState() => _PageNameState();
    }

    class _PageNameState extends State<PageName>  {
      @override
      void initState() {
        super.initState();
      }
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Title"),
            centerTitle: true,
            backgroundColor: Colors.blueAccent.shade700,
          ),
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
                children: <Widget>[
                  //Insert the build within here
                ],
              )
          ),
        );
      }
    }
]
 */