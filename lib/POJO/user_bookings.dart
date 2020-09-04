import 'package:json_annotation/json_annotation.dart';


part 'user_bookings.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class UserBookings{
  final int count;
  final int next;
  final int previous;
  final List<Booking> results;


  UserBookings(this.count, this.next, this.previous, this.results);

  factory UserBookings.fromJson(Map<String, dynamic> json) => _$UserBookingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserBookingsToJson(this);

}

@JsonSerializable()
class Booking{
  final String id;
  final String description;
  final String start_datetime;
  final String end_datetime;
  final String created_at;
  final String modified_at;


  Booking(this.id, this.description, this.start_datetime, this.end_datetime, this.created_at, this.modified_at);

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);

}