// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistration _$UserRegistrationFromJson(Map<String, dynamic> json) {
  return UserRegistration(
    json['id'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    json['email'] as String,
    json['phone_number'] as String,
    json['address'] as String,
    json['auth_token'] as String,
  );
}

Map<String, dynamic> _$UserRegistrationToJson(UserRegistration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'phone_number': instance.phone_number,
      'address': instance.address,
      'auth_token': instance.auth_token,
    };
