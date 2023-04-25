import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:units/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
                    //Example Code by vijaycreations's tutorial on Youtube: https://www.youtube.com/watch?v=T6Wg0AmIESE
void main() {
  tz.initializeTimeZones();
}
class NotiPage extends StatefulWidget {

  NotiPage({Key? key, required this.database}) : super (key: key);
  SleepData database;

  @override
  _NotiPageState createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage>  {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: const[
              SelectDateTxt(),
              ScheduleButton(),
              //Insert the build within here
            ],
          )
      ),
    );
  }

}
class SelectDateTxt extends StatefulWidget{
  const SelectDateTxt({
    Key? key,
  }) : super(key:key);
  @override
  State<SelectDateTxt> createState() => _SelectDateTxtState();


}
class _SelectDateTxtState extends State<SelectDateTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:  () {
        DateTime scheduleTime;
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {
            setState(() {

            });
          },
        );
      },
      child: const Text(
          'Select Date and Time',
          style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
class ScheduleButton extends StatelessWidget{
  const ScheduleButton({
    Key? key,
  }) : super(key: key);

  get scheduleTime => null;


  @override
  Widget build(BuildContext context){
    return ElevatedButton(
        child: const Text('Schedule Notification'),
        onPressed: () {
          debugPrint('Notification Scheduled by $scheduleTime');
          NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);

        },
    );
  }

}



















