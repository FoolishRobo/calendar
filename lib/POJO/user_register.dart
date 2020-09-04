import 'package:json_annotation/json_annotation.dart';


part 'user_register.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class UserRegistration{
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String phone_number;
  final String address;
  final String auth_token;


  UserRegistration(this.id, this.first_name, this.last_name, this.email, this.phone_number, this.address, this.auth_token);

  factory UserRegistration.fromJson(Map<String, dynamic> json) => _$UserRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationToJson(this);

}