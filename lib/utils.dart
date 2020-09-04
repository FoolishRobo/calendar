import 'package:calendar/app_colors.dart';
import 'package:calendar/routes/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);

Future<bool> storeStringSharedPref(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, value);
}

Future<String> readStringSharedPref(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> clearSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}


void showToast(BuildContext context, String text,
    {String action = "OK", Color color, Function toastAction}) {
  // SnackBar not showing? Try: https://stackoverflow.com/a/51304732/5129047

  final scaffold = Scaffold.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: color!=null?color:null,
      action: SnackBarAction(
        label: action,
        onPressed:
        toastAction != null ? toastAction : scaffold.hideCurrentSnackBar,
        textColor: AppColors.whiteColor,
      ),
    ),
  );
}

void checkLogedIn(BuildContext context)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("auth_token")){
    String auth_token  = await readStringSharedPref("auth_token");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard(token: auth_token,)), (route) => false);
  }
}
