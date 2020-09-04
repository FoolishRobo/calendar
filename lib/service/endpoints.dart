
class Api{
  static const domain = "https://calendlio.sarayulabs.com/api";
}

class AuthApi{
  static const apiView = "/auth";

  static String get getLogin {
    return Api.domain + apiView + "/login";
  }

  static String get getRegister {
    return Api.domain + apiView + "/register";
  }
}

class VerificationApi{
  static const apiView = "/verification";

  static String get getOtp {
    return Api.domain + apiView + "/phone";
  }
}

class BookingsApi{
  static const apiView = "/bookings";

  static String get getBooking {
    return Api.domain + apiView;
  }
}