// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kolam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kolam _$KolamFromJson(Map<String, dynamic> json) => Kolam(
      id: (json['id'] as num).toInt(),
      temperature: (json['temperature'] as num).toDouble(),
      tds: (json['tds'] as num).toDouble(),
      ph: (json['ph'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$KolamToJson(Kolam instance) => <String, dynamic>{
      'id': instance.id,
      'temperature': instance.temperature,
      'tds': instance.tds,
      'ph': instance.ph,
      'timestamp': instance.timestamp.toIso8601String(),
    };
