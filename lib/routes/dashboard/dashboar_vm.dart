import 'package:calendar/POJO/user_bookings.dart';
import 'package:calendar/service/Service.dart';
import 'package:calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardVm extends ChangeNotifier {
  DateFormat format = DateFormat("yyyy-MM-dd");

  DateTime tappedDate;
//  List<Booking> selectedDayEvents;

  Map<DateTime, List<Booking>> eventList;

  UserBookings _bookings;
  bool isLoading = true;
  bool isFetched = false;
  bool isError = false;

  void fetchBookings(String token)async{
    initialiseDefaultDate();
    if(token == null){
      token = await readStringSharedPref("auth_token");
    }
    _bookings = await fetchUserBookings(token);
    if(_bookings!=null) {
      populateEventList();
      isLoading = false;
      isFetched = true;
      isError = false;
    }
    else{
      isLoading = false;
      isFetched = false;
      isError = true;
    }
    notifyListeners();
  }

  void populateEventList(){
    eventList = {};
    String startTime;
    DateTime startDateTime;
    _bookings.results.forEach((element) {
      startTime = element.start_datetime.substring(0,10);
      startDateTime = DateTime.parse(startTime);
      if(!eventList.containsKey(startDateTime)) {
        eventList[startDateTime] = [element];
      }
      else{
        eventList[startDateTime].add(element);
      }
    });
//    print("EventList = ${eventList}");
  }

  void addNewEvent(String token, String strHr, String strMin, String endHr, String endMin, DateTime date, String desc)async{
    DateTime eventStartTime = DateTime.utc(date.year,date.month, date.day, int.parse(strHr), int.parse(strMin), 0,0,0);
    DateTime eventEndTime = DateTime.utc(date.year,date.month, date.day, int.parse(endHr), int.parse(endMin), 0,0,0);
    print("eventStartTime = $eventStartTime");
    print("eventEndTime = $eventEndTime");
    if(token == null){
      token = await readStringSharedPref("auth_token");
    }
    Booking booking = await addEventBooking(token, eventStartTime.toString(), eventEndTime.toString(), desc);
    print("Booking = $booking");
    if(booking == null){
      print("Api Error");
    }
    else{
      isLoading = true;
      notifyListeners();
    }
  }

  void deleteUserBooking(String token, String id)async{

    if(token == null){
      token = await readStringSharedPref("auth_token");
    }
    bool resp = await deleteBooking(token, id);

    if(resp){
      isLoading = true;
      notifyListeners();
    }
    else{
      print("Api Error");
    }
  }

  void setCalendarTappedDate(DateTime dateTime){
    String date = format.format(dateTime);
    tappedDate = DateTime.parse(date);
    notifyListeners();
  }

  void initialiseDefaultDate(){
    tappedDate = DateTime.parse(format.format(DateTime.now()));
  }
}