import 'package:calendar/app_colors.dart';
import 'package:calendar/routes/login/login.dart';
import 'package:calendar/routes/register/register.dart';
import 'package:calendar/utils.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  String title;
  HomePage({this.title});

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    checkLogedIn(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: "gCalendar",
                child: Image(
                  image: AssetImage('assets/gifs/gCalendar.gif'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    getCTAButton("LOGIN", context),
                    SizedBox(
                      height: 16,
                    ),
                    getCTAButton("REGISTER", context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCTAButton(String text, BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: AppColors.primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (text == "LOGIN") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Register()),
            );
          }
        },
        child: Text(text,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: AppColors.whiteColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
