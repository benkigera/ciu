// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_reading_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeterReadingPayload _$MeterReadingPayloadFromJson(Map<String, dynamic> json) =>
    MeterReadingPayload(
      name: json['n'] as String,
      value: json['v'],
      unit: json['u'] as String?,
      timestamp: (json['t'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MeterReadingPayloadToJson(
        MeterReadingPayload instance) =>
    <String, dynamic>{
      'n': instance.name,
      'v': instance.value,
      'u': instance.unit,
      't': instance.timestamp,
    };
