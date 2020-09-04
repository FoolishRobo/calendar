import 'dart:convert';
import 'package:calendar/POJO/user_bookings.dart';
import 'package:calendar/POJO/user_register.dart';
import 'package:calendar/service/endpoints.dart';
import 'package:calendar/utils.dart';
import 'package:http/http.dart' as http;


Future<UserRegistration> registerNewUser(String email, String fname, String lname, String address, String no) async {
  final http.Response response = await http.post(
    AuthApi.getRegister,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "first_name": fname,
      "last_name": lname,
      "address": address,
      "phone_number": no
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
//    print("Respinse.body = ${response.body}");
    return UserRegistration.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to registered user ${response.body}');
    return null;
  }
}

Future<UserRegistration> sendOTP(String no) async {
  final http.Response response = await http.post(
    VerificationApi.getOtp,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "phone_number": no
    }),
  );
  print("no = $no");
  if (response.statusCode == 204) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
//    print("Respinse.body = ${response.body}");
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to registered user ${response.body}');
    return null;
  }
}

Future<UserRegistration> loginUser(String no, String otp) async {
  final http.Response response = await http.post(
    AuthApi.getLogin,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "otp": otp,
      "phone_number": no
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    UserRegistration userRegistration = UserRegistration.fromJson(json.decode(response.body));
    print("Response.body = ${response.body}");
    storeStringSharedPref("id", userRegistration.id);
    storeStringSharedPref("first_name", userRegistration.first_name);
    storeStringSharedPref("last_name", userRegistration.last_name);
    storeStringSharedPref("email", userRegistration.email);
    storeStringSharedPref("phone_number", userRegistration.phone_number);
    storeStringSharedPref("address", userRegistration.address);
    storeStringSharedPref("auth_token", userRegistration.auth_token);
    return userRegistration;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to registered user ${response.body}');
    return null;
  }
}


Future<UserBookings> fetchUserBookings(String token) async {
  final http.Response response = await http.get(
    BookingsApi.getBooking,
    headers: <String, String>{
      'Authorization': "Token "+token,
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    UserBookings userBookings = UserBookings.fromJson(json.decode(response.body));
    print("Bookings = ${userBookings.toJson()}");
    return userBookings;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to registered user ${response.body}');
    return null;
  }
}

Future<Booking> addEventBooking(String token, String startTime, String endTime, String desc) async {
  final http.Response response = await http.post(
    BookingsApi.getBooking,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Token "+token,
    },
    body: jsonEncode(<String, String>{
      "description": desc,
      "start_datetime": startTime,
      "end_datetime": endTime,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Booking bookings = Booking.fromJson(json.decode(response.body));
    print("Bookings = ${bookings.toJson()}");
    return bookings;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to registered user ${response.body}');
    return null;
  }
}

Future<bool> deleteBooking(String token, String id) async {
  final http.Response response = await http.delete(
    BookingsApi.getBooking +'/'+ id,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Token " + token,
    },
  );
  if (response.statusCode == 204) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print('Failed to registered user ${response.body}');
    return false;
  }
}
