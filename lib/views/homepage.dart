import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Controller/provider_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  int index = 1;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  //---Text editing controller

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  late SharedPreferences prefs;

  String? get title => null;

  String? get dexcr => null;

  String? get time => null;

  @override
  void initState() {
    //---TODO: implement initState

    super.initState();
    _selectedDate = _focusedDay;
    timeinput.text = "";
    initPrefs();
  }

  Map<String, List> mySelectedEvents = {};

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  ///---Shared Preference---------------------------------------------------------

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      mySelectedEvents = Map<String, List<dynamic>>.from(
          (json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarState>(
        builder: ((context, value, _) => SafeArea(
              child: Scaffold(
                backgroundColor: const Color.fromARGB(243, 236, 230, 230),
                bottomNavigationBar: CurvedNavigationBar(
                  index: 1,
                  items: const <Widget>[
                    Icon(
                      Icons.home,
                      size: 30,
                    ),
                    Icon(Icons.add, size: 30),
                    Icon(Icons.notification_add_rounded, size: 30),
                  ],
                  color: const Color.fromARGB(255, 89, 92, 97),
                  buttonBackgroundColor: const Color.fromARGB(255, 202, 192, 192),
                  backgroundColor: const Color.fromARGB(255, 216, 216, 216),
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 600),
                  onTap: (index) {
                    setState(() {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          elevation: 0,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                autofocus: true,
                                style: const TextStyle(height: 0.40, fontSize: 14),
                                controller: titleController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 254, 254, 254),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: 'Title',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //---pick your time

                              const Text("pick your time"),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 5,
                                child: TextField(
                                  controller: timeinput,
                                  style: const TextStyle(height: 0.40, fontSize: 14),
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (pickedTime != null) {
                                      print(pickedTime
                                          .format(context)); //output 10:51 PM
                                      DateTime parsedTime = DateFormat.jm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());

                                      String formattedTime = DateFormat("h:mma")
                                          .format(parsedTime);

                                      timeinput.text =
                                          formattedTime; //set the value of text field.

                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.timer_sharp,
                                      color: Color.fromARGB(255, 72, 59, 59),
                                    ),
                                    hintText: "",
                                    filled: true,
                                    fillColor:
                                        const Color.fromARGB(255, 255, 255, 255),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //---Descrption

                              TextField(
                                controller: descpController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: 'Descrption',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            MaterialButton(
                              color: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              onPressed: () => Navigator.pop(context),
                              textColor: Colors.white,
                              child: const Text('Cancel'),
                            ),

                            //---Add

                            MaterialButton(
                              color: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              textColor: Colors.white,
                              onPressed: () {
                                if (titleController.text.isEmpty &&
                                    descpController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Required title and description'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  return;
                                } else {
                                  if (mySelectedEvents[DateFormat('yyyy-MM-dd')
                                          .format(_selectedDate!)] !=
                                      null) {
                                    mySelectedEvents[DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate!)]
                                        ?.add({
                                      "eventTitle": titleController.text,
                                      "eventDescp": descpController.text,
                                      "time": timeinput.text,
                                    });
                                  } else {
                                    mySelectedEvents[DateFormat('yyyy-MM-dd')
                                        .format(_selectedDate!)] = [
                                      {
                                        "eventTitle": titleController.text,
                                        "eventDescp": descpController.text,
                                        "time": timeinput.text,
                                      }
                                    ];
                                  }

                                  prefs.setString("events",
                                      json.encode((mySelectedEvents)));
                                  titleController.clear();
                                  descpController.clear();
                                  timeinput.clear();

                                  Navigator.pop(context);
                                  value.addEvent(title, dexcr, time);
                                  return;
                                }
                              },
                              child: const Text('Add '),
                            )
                          ],
                        ),
                      );
                    });
                  },
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),

                      //---TableCalendar------------------------------------------------

                      TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime(2030),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,

                        //---Header Style-----------------------------------------------

                        headerStyle: const HeaderStyle(
                          headerMargin: EdgeInsets.all(8.0),
                          leftChevronVisible: false,
                          rightChevronVisible: false,
                          formatButtonVisible: false,
                          formatButtonShowsNext: false,
                          titleTextStyle: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        ),

                        //---CalendarStyle----------------------------------------------

                        calendarStyle: const CalendarStyle(
                          defaultTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          weekendTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),

                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDate, selectedDay)) {
                            // Call `setState()` when updating the selected day
                            setState(() {
                              _selectedDate = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDate, day);
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            CalendarFormat.week;
                          }
                        },
                        onPageChanged: (focusedDay) {
                          // No need to call `setState()` here
                          _focusedDay = focusedDay;
                        },
                        eventLoader: _listOfDayEvents,
                      ),

                      //---EventCalendarScreen------------------------------------------

                      const SizedBox(
                        height: 10,
                      ),
                      ..._listOfDayEvents(_selectedDate!).map(
                        (myEvents) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 105,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(166, 89, 92, 97),
                              border: Border.all(width: .01),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                title: Text(' ${myEvents['eventTitle']}',
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20))),
                                subtitle: Text(
                                  '   ${myEvents['eventDescp']}',
                                ),
                                trailing: Text('  ${myEvents['time']}',
                                    style: GoogleFonts.robotoSlab(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18))),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
