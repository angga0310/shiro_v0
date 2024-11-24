import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String username;
  final String? password;

  User({
    required this.username,
    this.password,
  });

  /// Mengubah JSON menjadi instance User
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Mengubah instance User menjadi JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
