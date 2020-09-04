import 'package:calendar/POJO/user_register.dart';
import 'package:calendar/app_colors.dart';
import 'package:calendar/routes/dashboard/dashboard.dart';
import 'package:calendar/service/Service.dart';
import 'package:calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class OTP extends StatelessWidget {
  String no;

  OTP({@required this.no});
  String otp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CALENDLIO"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter OTP"
          ),
          PinEntryTextField(
            fields: 6,
            onSubmit: (String pin){
              otp = pin;
            }, // end onSubmit
          ),
          SizedBox(height: 34,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: getCTAButton("LOGIN", context),
          ),
        ],
      ),
    );
  }

  Widget getCTAButton(String text, BuildContext context) {
    return Builder(
      builder: (context) =>
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: AppColors.primaryColor,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: ()async {
                if(otp == null){
                  showToast(context,
                      "Invalid OTP!",
                      color: AppColors.error);
                }
                else {
                  if (otp.length != 6) {
                    showToast(context,
                        "Invalid OTP!",
                        color: AppColors.error);
                  }
                  else{
                    UserRegistration userRegistration = await loginUser("+91"+no, otp);
                    if(userRegistration.auth_token!=null) {
                      print("Logged in");
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard(token: userRegistration.auth_token)), (route) => false);
                    }
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
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
