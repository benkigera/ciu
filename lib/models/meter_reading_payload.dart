import 'package:json_annotation/json_annotation.dart';

part 'meter_reading_payload.g.dart';

@JsonSerializable()
class MeterReadingPayload {
  @JsonKey(name: 'n')
  final String name;
  @JsonKey(name: 'v')
  final dynamic value;
  @JsonKey(name: 'u')
  final String? unit;
  @JsonKey(name: 't')
  final int? timestamp;

  MeterReadingPayload({
    required this.name,
    required this.value,
    this.unit,
    this.timestamp,
  });

  factory MeterReadingPayload.fromJson(Map<String, dynamic> json) =>
      _$MeterReadingPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$MeterReadingPayloadToJson(this);
}
