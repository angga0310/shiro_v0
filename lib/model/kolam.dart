// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'kolam.g.dart';

@JsonSerializable()
class Kolam {
  int id;
  double temperature;
  double tds;
  double ph;
  DateTime timestamp;

  Kolam({
    required this.id,
    required this.temperature,
    required this.tds,
    required this.ph,
    required this.timestamp,
  });

  
  /// Mengubah JSON menjadi instance User
  factory Kolam.fromJson(Map<String, dynamic> json) => _$KolamFromJson(json);

  /// Mengubah instance User menjadi JSON
  Map<String, dynamic> toJson() => _$KolamToJson(this);

}
