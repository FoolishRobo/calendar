import 'package:calendar/routes/login/otp.dart';
import 'package:calendar/service/Service.dart';
import 'package:calendar/utils.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  String no;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    child: Hero(
                      tag: "gCalendar",
                      child: Image.asset(
                        "assets/gifs/gCalendar.gif",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Column(
                    children: [
                      Text(
                        "We will send you an One Time Password on this mobile number",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo,
                          letterSpacing: 1
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      getTextField("Phone Number"),
                      SizedBox(
                        height: 16.0,
                      ),
                      getCTAButton("Next", context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget getTextField(String hint) {
    return TextField(
      keyboardType: TextInputType.number,
      obscureText: false,
      style: style,
      onChanged: (value) {
        no = value;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  Widget getCTAButton(String text, BuildContext context) {
    return Builder(
      builder: (context) =>
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.indigo,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                if(no == null){
                  showToast(context,
                      "Invalid Phone Number!",
                      color: Colors.red);
                }
                else {
                  if (no.length != 10) {
                    showToast(context,
                        "Invalid Phone Number!",
                        color: Colors.red);
                  }
                  else{
                    sendOTP("+91"+no);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OTP(no: no,)),
                    );
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
