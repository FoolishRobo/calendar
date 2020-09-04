// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bookings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBookings _$UserBookingsFromJson(Map<String, dynamic> json) {
  return UserBookings(
    json['count'] as int,
    json['next'] as int,
    json['previous'] as int,
    (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Booking.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserBookingsToJson(UserBookings instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return Booking(
    json['id'] as String,
    json['description'] as String,
    json['start_datetime'] as String,
    json['end_datetime'] as String,
    json['created_at'] as String,
    json['modified_at'] as String,
  );
}

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'start_datetime': instance.start_datetime,
      'end_datetime': instance.end_datetime,
      'created_at': instance.created_at,
      'modified_at': instance.modified_at,
    };
