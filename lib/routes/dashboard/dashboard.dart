import 'package:calendar/POJO/user_bookings.dart';
import 'package:calendar/app_colors.dart';
import 'package:calendar/routes/dashboard/dashboar_vm.dart';
import 'package:calendar/service/Service.dart';
import 'package:calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Dashboard extends StatefulWidget {
  final String token;

  Dashboard({this.token});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  CalendarController _calendarController;
  AnimationController _animationController;

  PanelController _panelController;
  bool isAddingEvent = false;

  String startHr, startMin, endHr, endMin, desc;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _panelController = PanelController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<DashboardVm>(create: (_) => DashboardVm()),
            ],
            child: Consumer<DashboardVm>(
              builder: (_, vm, child) {
                if (vm.isLoading) {
                  vm.fetchBookings(widget.token);
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.whiteColor,
                    ),
                  );
                } else if (vm.isError) {
                  return Center(
                    child: Text("Api Error"),
                  );
                } else if (vm.isFetched) {
                  return SlidingUpPanel(
                    controller: _panelController,
                    minHeight: 250,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    panel: getSlidablePanel(vm),
                    body: getCalendar(vm),
                  );
                } else {
                  return Center(child: Text("Unknown Error occurred"));
                }
              },
            )),
      ),
    );
  }

  Widget getCalendar(DashboardVm vm) {
    return TableCalendar(
      calendarController: _calendarController,
      locale: 'en_US',
      events: vm.eventList,
      onDaySelected: (DateTime date, List<dynamic> data) {
        _animationController.forward(from: 0.0);
        vm.setCalendarTappedDate(date);
      },
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.none,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      calendarStyle: CalendarStyle(
        weekdayStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12),
        weekendStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12),
        outsideStyle: TextStyle(color: AppColors.lightWhite, fontSize: 12),
        unavailableStyle: TextStyle(color: AppColors.lightWhite, fontSize: 12),
        outsideWeekendStyle: TextStyle(color: AppColors.lightWhite, fontSize: 12),
        todayColor: AppColors.whiteColor,
        todayStyle: TextStyle(color: AppColors.primaryColor, fontSize: 12),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (date, locale) {
          return DateFormat.E(locale)
              .format(date)
              .substring(0, 3)
              .toUpperCase();
        },
        weekdayStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12),
        weekendStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12),
      ),
      headerVisible: true,
      headerStyle: HeaderStyle(
        titleTextStyle:
            TextStyle(color: AppColors.whiteColor, fontSize: 24, letterSpacing: 0.8),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: AppColors.whiteColor,
          size: 24,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: AppColors.whiteColor,
          size: 24,
        ),
      ),
      builders: CalendarBuilders(
        todayDayBuilder: (context, date, _) {
          return Container(
            decoration:
                new BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle),
            margin: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          return [
            Container(
              decoration: new BoxDecoration(
                color: AppColors.highlightColor,
                borderRadius: BorderRadius.circular(40),
              ),
              margin: const EdgeInsets.only(
                bottom: 12,
              ),
              width: 4,
              height: 4,
            )
          ];
        },
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: new BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(4.0),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getSlidablePanel(DashboardVm vm) {
    DateFormat dateFormat = DateFormat.yMMMMd('en_US');
    String tappedDate = dateFormat.format(vm.tappedDate);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          getSlideLines(),
          SizedBox(
            height: 16,
          ),
          getTimeAndAddButton(tappedDate),
          SizedBox(
            height: 16,
          ),
          isAddingEvent ? addEventView(vm) : eventListView(vm),
        ],
      ),
    );
  }

  Widget addEventView(DashboardVm vm) {
    return SingleChildScrollView(
      child: Column(
        children: [
          getTimeView("Start time :"),
          SizedBox(
            height: 16,
          ),
          getTimeView("End time :  "),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 100,
            child: getDescriptionTextField("Description"),
          ),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: (){
              vm.addNewEvent(widget.token, startHr, startMin, endHr, endMin, vm.tappedDate, desc);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SAVE",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.whiteColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTimeView(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          height: 34,
          width: 70,
          child: getTextField("Hr", text),
        ),
        SizedBox(
          width: 4,
        ),
        Text(":"),
        SizedBox(
          width: 4,
        ),
        Container(
          height: 34,
          width: 70,
          child: getTextField("Min", text),
        ),
      ],
    );
  }

  Widget eventListView(DashboardVm vm) {
    Booking booking;
    DateFormat dateFormat = DateFormat.jm();
    String startTime;
    String endTime;
//    String lastModifiedTime;
//    String createdTime;
    String bookingId;
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height/2,
        child: ListView.builder(
          itemCount: vm.eventList[vm.tappedDate]!=null?vm.eventList[vm.tappedDate].length:0,
          itemBuilder: (BuildContext context, int index) {
            booking = vm.eventList[vm.tappedDate][index];
            bookingId = booking.id;
            startTime = dateFormat.format(DateTime.parse(booking.start_datetime));
            endTime = dateFormat.format(DateTime.parse(booking.end_datetime));
//            lastModifiedTime = dateFormat.format(DateTime.parse(booking.modified_at));
//            createdTime = dateFormat.format(DateTime.parse(booking.created_at));
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.alarm,
                                  color: AppColors.whiteColor,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  startTime + " - " + endTime,
                                  style: TextStyle(
                                      color: AppColors.whiteColor, fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              booking.description,
                              maxLines: 4,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColors.whiteColor,
                            size: 16,
                          ),
                          InkWell(
                            onTap: (){
                              vm.deleteUserBooking(widget.token, bookingId);
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: AppColors.lightWhite,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getTimeAndAddButton(String tappedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tappedDate,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isAddingEvent
                  ? _panelController.close()
                  : _panelController.open();
              isAddingEvent = !isAddingEvent;
            });
          },
          child: isAddingEvent
              ? Icon(
                  Icons.cancel,
                  color: AppColors.primaryColor,
                  size: 24,
                )
              : Container(
                  width: 70,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: AppColors.whiteColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget getSlideLines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 2,
          color: AppColors.primaryColor,
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          width: 50,
          height: 2,
          color: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget getTextField(String hint, String text) {
    return TextField(
      keyboardType: TextInputType.number,
      obscureText: false,
      style: style,
      onChanged: (value) {
        if(text == "Start time :"){
          if(hint =="Hr"){
            startHr = value;
          }
          else{
            startMin = value;
          }
        }
        else{
          if(hint =="Hr"){
            endHr = value;
          }
          else{
            endMin = value;
          }
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12, color: AppColors.primaryColor),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget getDescriptionTextField(String hint){
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (value){
        desc = value;
      },
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12, color: AppColors.primaryColor),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    );
  }
}
