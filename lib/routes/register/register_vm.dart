import 'package:calendar/POJO/user_register.dart';
import 'package:calendar/service/Service.dart';
import 'package:flutter/material.dart';

class RegisterVM extends ChangeNotifier{
  bool isRegistering = false;
  bool isSuccessful = false;
  bool isError = false;

  String _email;
  String _fName;
  String _lName;
  String _address;
  String _no;

  void setAllVariables({String email,String fname,String lname,String address,String no}) async{
    isRegistering = true;
    notifyListeners();
    _email = email;
    _fName = fname;
    _lName = lname;
    _address = address;
    _no = "+91"+no;

     UserRegistration response = await registerNewUser(_email, _fName, _lName, _address, _no);
     if(response == null){
       print("Recieved null data");
       isRegistering = false;
       isError = true;
       notifyListeners();
     }
     else {
       isRegistering = false;
       isSuccessful = true;
       isError = false;
       print("Response = ${response.toJson()}");
       notifyListeners();
     }
  }

}