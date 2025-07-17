// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_injection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenInjectionResponseImpl _$$TokenInjectionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TokenInjectionResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => InjectionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TokenInjectionResponseImplToJson(
        _$TokenInjectionResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_$InjectionDataImpl _$$InjectionDataImplFromJson(Map<String, dynamic> json) =>
    _$InjectionDataImpl(
      n: json['n'] as String,
      v: json['v'],
      t: (json['t'] as num).toInt(),
    );

Map<String, dynamic> _$$InjectionDataImplToJson(_$InjectionDataImpl instance) =>
    <String, dynamic>{
      'n': instance.n,
      'v': instance.v,
      't': instance.t,
    };
