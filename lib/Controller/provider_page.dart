
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CalendarState with ChangeNotifier {
  CalendarFormat calendarFormat = CalendarFormat.week;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDate = DateTime.now();
   late SharedPreferences prefs;



  Map<String, List<Map<String, String>>> mySelectedEvents = {};

  void addEvent(title, dexcr, time) {
    mySelectedEvents[DateFormat('yyyy-MM-dd').format(selectedDate!)]?.add({
      "eventTitle": title,
      "eventDescp": dexcr,
      "time": time,
    });

    notifyListeners();
  }

  //  void initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   mySelectedEvents = Map<String, List<dynamic>>.from(
  //       json.decode(prefs.getString("events") ?? "{}"));
  //   notifyListeners();
  // }

  // void addEvent( date, String title, String descp, String time) {
  //   if (mySelectedEvents[date] != null) {
  //     mySelectedEvents[date]?.add({
  //       "eventTitle": title,
  //       "eventDescp": descp,
  //       "time": time,
  //     });
  //   } else {
  //     mySelectedEvents[date] = [
  //       {
  //         "eventTitle": title,
  //         "eventDescp": descp,
  //         "time": time,
  //       }
  //     ];
  //   }
  //   notifyListeners();
  // }
}
