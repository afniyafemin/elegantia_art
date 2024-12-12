// import 'dart:convert';
// import 'package:elegantia_art/core/color_constants/color_constant.dart';
// import 'package:elegantia_art/core/image_constants/image_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class CalendarView extends StatefulWidget {
//   const CalendarView({super.key});
//
//   @override
//   State<CalendarView> createState() => _CalendarviewAState();
// }
//
// String? dateOfEvent;
//
// Map<DateTime, List<dynamic>> myEvents = {
//   DateTime(2024-11-18): [
//     {
//       "event title": "abc music show",
//       "event description": "musical event conducted by kalakaar pvt.Ltd",
//       "location": "perinthalmanna",
//       "date": "01-01.2025"
//     },
//   ],
//   DateTime(2024-11-11): [
//     {
//       "event title": "AHM",
//       "event description": "AHM conducted by kerala arts club",
//       "location": "calicut",
//       "date": "12-12-2222"
//     },
//   ],
// };
//
// loadPreviousEvents() {
//   myEvents = {
//     DateTime(2024-11-18): [
//       {
//         "event title": "abc music show",
//         "event description": "musical event conducted by kalakaar pvt.Ltd",
//         "location": "perinthalmanna",
//         "date": "01-01.2025"
//       },
//     ],
//     DateTime(2024-11-11): [
//       {
//         "event title": "AHM",
//         "event description": "AHM conducted by kerala arts club",
//         "location": "calicut",
//         "date": "12-12-2222"
//       },
//     ],
//   };
// }
//
// class _CalendarviewAState extends State<CalendarView> {
//   CalendarFormat calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//
//     loadPreviousEvents(); // Initialize selected day
//   }
//
//   List _listOfDayEvents(DateTime datetime) {
//     if (myEvents[DateFormat('yyyy-MM-dd').format(datetime)] != null) {
//       return myEvents[DateFormat('yyyy-MM-dd').format(datetime)]!;
//     } else {
//       return [];
//     }
//
//   }
//
//   void addEvent() async {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     final locationController = TextEditingController();
//     final dateController = TextEditingController();
//
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           "Add New Event",
//           style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
//         ),
//         content: Container(
//           height: 250,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextFormField(
//                 cursorColor: Colors.black,
//                 controller: titleController,
//                 maxLength: 30,
//                 textCapitalization: TextCapitalization.words,
//                 decoration: InputDecoration(
//                   counterText: "",
//                   hintText: "Event title",
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               TextFormField(
//                 cursorColor: Colors.black,
//                 controller: descriptionController,
//                 maxLength: 30,
//                 textCapitalization: TextCapitalization.words,
//                 decoration: InputDecoration(
//                   counterText: "",
//                   hintText: "Description",
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               TextFormField(
//                 cursorColor: Colors.black,
//                 controller: locationController,
//                 maxLength: 30,
//                 textCapitalization: TextCapitalization.words,
//                 decoration: InputDecoration(
//                   counterText: "",
//                   hintText: "Location",
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//               TextFormField(
//                 cursorColor: Colors.black,
//                 controller: dateController,
//                 maxLength: 30,
//                 textCapitalization: TextCapitalization.words,
//                 decoration: InputDecoration(
//                   counterText: "",
//                   hintText: "Date",
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text(
//               "Cancel",
//               style: TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.w600),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               if (titleController.text.isEmpty &&
//                   descriptionController.text.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text("Required title and description"),
//                   duration: Duration(seconds: 2),
//                 ));
//                 return;
//               } else {
//                 setState(() {
//                   if (myEvents[
//                           DateFormat('yyyy-MM-dd').format(_selectedDay!)] !=
//                       null) {
//                     myEvents[DateFormat('yyyy-MM-dd').format(_selectedDay!)]
//                         ?.add({
//                       "event title": titleController.text,
//                       "event description": descriptionController.text,
//                       "location": descriptionController.text,
//                       "date": descriptionController.text,
//                     });
//                   } else {
//                     myEvents[DateFormat('yyyy-MM-dd').format(_selectedDay!)] = [
//                       {
//                         "event title": titleController.text,
//                         "event description": descriptionController.text,
//                         "location": descriptionController.text,
//                         "date": descriptionController.text,
//                       }
//                     ];
//                   }
//                 });
//                 Navigator.pop(context);
//                 setState(() {
//                   titleController.clear();
//                   descriptionController.clear();
//                   locationController.clear();
//                   dateController.clear();
//                 });
//                 print(myEvents);
//                 return;
//               }
//             },
//             child: Text(
//               "Add Event",
//               style: TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TableCalendar(
//               calendarFormat: calendarFormat,
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 headerPadding: EdgeInsets.only(top: height * 0.03),
//                 titleCentered: true,
//                 titleTextStyle: TextStyle(
//                   color: ColorConstant.primaryColor,
//                   fontSize: width * 0.05,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               calendarStyle: CalendarStyle(
//                 todayTextStyle: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.w900),
//                 todayDecoration: BoxDecoration(
//                   color: ColorConstant.primaryColor,
//                   borderRadius: BorderRadius.circular(width * 1),
//                 ),
//                 isTodayHighlighted: true,
//                 selectedDecoration: BoxDecoration(
//                   color: ColorConstant.primaryColor.withOpacity(0.4),
//                   borderRadius: BorderRadius.circular(width * 1),
//                 ),
//                 selectedTextStyle: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                 ),
//                 defaultTextStyle: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w900,
//                 ),
//                 holidayTextStyle: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w900,
//                 ),
//                 weekendTextStyle: TextStyle(
//                   color: Colors.red.withOpacity(0.75),
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               focusedDay: _focusedDay,
//               firstDay: DateTime(2020),
//               lastDay: DateTime(2050),
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               onPageChanged: (focusedDay) {
//                 _focusedDay = focusedDay;
//               },
//               eventLoader: _listOfDayEvents,
//               onFormatChanged: (format) {
//                 if (calendarFormat != format) {
//                   setState(() {
//                     calendarFormat = format;
//                   });
//                 }
//               },
//             ),
//             Container(
//               // color: Colors.redAccent,
//               height: height * 0.5,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     ..._listOfDayEvents(_selectedDay!).map((event) => Container(
//                           margin: EdgeInsets.all(width * 0.03),
//                           padding: EdgeInsets.all(width * 0.03),
//                           height: height * 0.3,
//                           decoration: BoxDecoration(
//                               color: ColorConstant.primaryColor.withOpacity(0.5),
//                               borderRadius:
//                                   BorderRadius.circular(width * 0.04)),
//                           child:
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 height: height * 0.35,
//                                 width: width * 0.35,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                   image: AssetImage(ImageConstant.product1),
//                                   fit: BoxFit.cover,
//                                 )),
//                               ),
//                               Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Text(
//                                     event["event title"],
//                                     style: TextStyle(
//                                         fontSize: width * 0.025,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Text(
//                                     event["event description"],
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         fontSize: width * 0.025,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Text(
//                                     event["location"],
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         fontSize: width * 0.025,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Text(
//                                     event["date"],
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         fontSize: width * 0.025,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   SizedBox(
//                                     height: height * 0.05,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       dateOfEvent = _selectedDay as String;
//                                       // Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //       builder: (context) => SlotBooking(),
//                                       //     ));
//                                       setState(() {});
//                                     },
//                                     child: Container(
//                                       height: height * 0.03,
//                                       width: width * 0.2,
//                                       decoration: BoxDecoration(
//                                         color: ColorConstant.primaryColor,
//                                         borderRadius:
//                                             BorderRadius.circular(width * 0.5),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           "Book Now",
//                                           style: TextStyle(
//                                             fontSize: width * 0.03,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox()
//                             ],
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => AllUpcomingEvents(),));
//               setState(() {
//
//               });
//             },
//             child: Container(
//               height: height*0.03,
//               width: width*0.225,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(width*0.05)
//               ),
//               margin: EdgeInsets.only(left:width*0.075),
//               child: Center(
//                 child: Text("upcoming events",
//                   style: TextStyle(
//                     fontSize: width*0.02,
//                     color: Colors.white
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           FloatingActionButton(
//             backgroundColor: ColorConstant.primaryColor,
//             onPressed: () {
//               addEvent();
//               // titleController.clear();
//               // descriptionController.clear();
//             },
//             child: Icon(Icons.add, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
