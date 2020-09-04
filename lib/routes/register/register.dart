import 'package:calendar/app_colors.dart';
import 'package:calendar/routes/register/register_vm.dart';
import 'package:calendar/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String _email;
  String _fName;
  String _lName;
  String _address;
  String _no;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER"),
      ),
      body: ChangeNotifierProvider(
        create: (_) => RegisterVM(),
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    child: Hero(
                      tag: "gCalendar",
                      child: Image.asset(
                        "assets/gifs/gCalendar.gif",
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  getTextField("Email"),
                  SizedBox(height: 25.0),
                  getTextField("First Name"),
                  SizedBox(height: 25.0),
                  getTextField("Last Name"),
                  SizedBox(height: 25.0),
                  getTextField("Address"),
                  SizedBox(height: 25.0),
                  getTextField("Phone Number"),
                  SizedBox(
                    height: 35.0,
                  ),
                  getCTAButton(),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCTAButton(){
    return Builder(
      builder: (context) {
        return Consumer<RegisterVM>(
          builder: (_, vm, child){
            Color color;
            String text;
            if(vm.isSuccessful){
              text = "Successfully Registered";
              color = AppColors.highlightColor;
            }
            else if(vm.isError){
              text = "NOT REGISTERED! Please try again";
              color = AppColors.error;
            }
            else{
              text = "REGISTER";
              color = AppColors.primaryColor;
            }
            return Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: color,
              child: MaterialButton(
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  //Client Side Validator
                  if (_email != null || _fName != null || _lName != null ||
                      _address != null || _no != null) {
                    if (validateEmail(_email) == false) {
                      showToast(context, "Invalid Email!", color: AppColors.error);
                    }
                    else if (_fName.length < 3) {
                      showToast(context,
                          "First Name should be minimum three characters long!",
                          color: AppColors.error);
                    }
                    else if (_lName.length < 3) {
                      showToast(context,
                          "Last Name should be minimum three characters long!",
                          color: AppColors.error);
                    }
                    else if (_no.length != 10) {
                      print("no length = ${_no.length}");
                      showToast(
                          context, "Invalid Phone Number!", color: AppColors.error);
                    }
                    else if(vm.isSuccessful == false){
                      vm.setAllVariables(email: _email, fname: _fName, lname: _lName, address: _address, no: _no);
                    }
                  }
                  else {
                    showToast(
                        context, "Please Fill All Fields!", color: AppColors.error);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    vm.isRegistering?CircularProgressIndicator(backgroundColor: AppColors.whiteColor,):Text(text,
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
  
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
  
  Widget getTextField(String hint){
    return TextField(
      keyboardType: hint == "Phone Number"?TextInputType.number:hint == "Email"?TextInputType.emailAddress:TextInputType.text,
      obscureText: false,
      style: style,
      onChanged: (value){
        if(hint == "Email"){
          _email = value;
        }
        else if(hint == "First Name"){
          _fName = value;
        }
        else if(hint == "Last Name"){
          _lName = value;
        }
        else if(hint == "Address"){
          _address = value;
        }
        else if(hint == "Phone Number"){
          _no = value;
        }
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hint,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }
}
