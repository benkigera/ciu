import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_injection_model.freezed.dart';
part 'token_injection_model.g.dart';

@freezed
class TokenInjectionResponse with _$TokenInjectionResponse {
  const factory TokenInjectionResponse({
    required String status,
    required String message,
    List<InjectionData>? data,
  }) = _TokenInjectionResponse;

  factory TokenInjectionResponse.fromJson(Map<String, Object?> json) =>
      _$TokenInjectionResponseFromJson(json);
}

@freezed
class InjectionData with _$InjectionData {
  const factory InjectionData({
    required String n,
    dynamic v, // Can be String or int
    required int t,
  }) = _InjectionData;

  factory InjectionData.fromJson(Map<String, Object?> json) =>
      _$InjectionDataFromJson(json);
}
