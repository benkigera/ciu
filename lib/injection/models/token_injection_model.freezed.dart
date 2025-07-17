// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_injection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TokenInjectionResponse _$TokenInjectionResponseFromJson(
    Map<String, dynamic> json) {
  return _TokenInjectionResponse.fromJson(json);
}

/// @nodoc
mixin _$TokenInjectionResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<InjectionData>? get data => throw _privateConstructorUsedError;

  /// Serializes this TokenInjectionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenInjectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenInjectionResponseCopyWith<TokenInjectionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenInjectionResponseCopyWith<$Res> {
  factory $TokenInjectionResponseCopyWith(TokenInjectionResponse value,
          $Res Function(TokenInjectionResponse) then) =
      _$TokenInjectionResponseCopyWithImpl<$Res, TokenInjectionResponse>;
  @useResult
  $Res call({String status, String message, List<InjectionData>? data});
}

/// @nodoc
class _$TokenInjectionResponseCopyWithImpl<$Res,
        $Val extends TokenInjectionResponse>
    implements $TokenInjectionResponseCopyWith<$Res> {
  _$TokenInjectionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenInjectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<InjectionData>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenInjectionResponseImplCopyWith<$Res>
    implements $TokenInjectionResponseCopyWith<$Res> {
  factory _$$TokenInjectionResponseImplCopyWith(
          _$TokenInjectionResponseImpl value,
          $Res Function(_$TokenInjectionResponseImpl) then) =
      __$$TokenInjectionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String message, List<InjectionData>? data});
}

/// @nodoc
class __$$TokenInjectionResponseImplCopyWithImpl<$Res>
    extends _$TokenInjectionResponseCopyWithImpl<$Res,
        _$TokenInjectionResponseImpl>
    implements _$$TokenInjectionResponseImplCopyWith<$Res> {
  __$$TokenInjectionResponseImplCopyWithImpl(
      _$TokenInjectionResponseImpl _value,
      $Res Function(_$TokenInjectionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenInjectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_$TokenInjectionResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<InjectionData>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenInjectionResponseImpl implements _TokenInjectionResponse {
  const _$TokenInjectionResponseImpl(
      {required this.status,
      required this.message,
      final List<InjectionData>? data})
      : _data = data;

  factory _$TokenInjectionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenInjectionResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  final List<InjectionData>? _data;
  @override
  List<InjectionData>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TokenInjectionResponse(status: $status, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenInjectionResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, status, message, const DeepCollectionEquality().hash(_data));

  /// Create a copy of TokenInjectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenInjectionResponseImplCopyWith<_$TokenInjectionResponseImpl>
      get copyWith => __$$TokenInjectionResponseImplCopyWithImpl<
          _$TokenInjectionResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenInjectionResponseImplToJson(
      this,
    );
  }
}

abstract class _TokenInjectionResponse implements TokenInjectionResponse {
  const factory _TokenInjectionResponse(
      {required final String status,
      required final String message,
      final List<InjectionData>? data}) = _$TokenInjectionResponseImpl;

  factory _TokenInjectionResponse.fromJson(Map<String, dynamic> json) =
      _$TokenInjectionResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  List<InjectionData>? get data;

  /// Create a copy of TokenInjectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenInjectionResponseImplCopyWith<_$TokenInjectionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

InjectionData _$InjectionDataFromJson(Map<String, dynamic> json) {
  return _InjectionData.fromJson(json);
}

/// @nodoc
mixin _$InjectionData {
  String get n => throw _privateConstructorUsedError;
  dynamic get v => throw _privateConstructorUsedError; // Can be String or int
  int get t => throw _privateConstructorUsedError;

  /// Serializes this InjectionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InjectionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InjectionDataCopyWith<InjectionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InjectionDataCopyWith<$Res> {
  factory $InjectionDataCopyWith(
          InjectionData value, $Res Function(InjectionData) then) =
      _$InjectionDataCopyWithImpl<$Res, InjectionData>;
  @useResult
  $Res call({String n, dynamic v, int t});
}

/// @nodoc
class _$InjectionDataCopyWithImpl<$Res, $Val extends InjectionData>
    implements $InjectionDataCopyWith<$Res> {
  _$InjectionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InjectionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? n = null,
    Object? v = freezed,
    Object? t = null,
  }) {
    return _then(_value.copyWith(
      n: null == n
          ? _value.n
          : n // ignore: cast_nullable_to_non_nullable
              as String,
      v: freezed == v
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as dynamic,
      t: null == t
          ? _value.t
          : t // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InjectionDataImplCopyWith<$Res>
    implements $InjectionDataCopyWith<$Res> {
  factory _$$InjectionDataImplCopyWith(
          _$InjectionDataImpl value, $Res Function(_$InjectionDataImpl) then) =
      __$$InjectionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String n, dynamic v, int t});
}

/// @nodoc
class __$$InjectionDataImplCopyWithImpl<$Res>
    extends _$InjectionDataCopyWithImpl<$Res, _$InjectionDataImpl>
    implements _$$InjectionDataImplCopyWith<$Res> {
  __$$InjectionDataImplCopyWithImpl(
      _$InjectionDataImpl _value, $Res Function(_$InjectionDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of InjectionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? n = null,
    Object? v = freezed,
    Object? t = null,
  }) {
    return _then(_$InjectionDataImpl(
      n: null == n
          ? _value.n
          : n // ignore: cast_nullable_to_non_nullable
              as String,
      v: freezed == v
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as dynamic,
      t: null == t
          ? _value.t
          : t // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InjectionDataImpl implements _InjectionData {
  const _$InjectionDataImpl({required this.n, this.v, required this.t});

  factory _$InjectionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$InjectionDataImplFromJson(json);

  @override
  final String n;
  @override
  final dynamic v;
// Can be String or int
  @override
  final int t;

  @override
  String toString() {
    return 'InjectionData(n: $n, v: $v, t: $t)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InjectionDataImpl &&
            (identical(other.n, n) || other.n == n) &&
            const DeepCollectionEquality().equals(other.v, v) &&
            (identical(other.t, t) || other.t == t));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, n, const DeepCollectionEquality().hash(v), t);

  /// Create a copy of InjectionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InjectionDataImplCopyWith<_$InjectionDataImpl> get copyWith =>
      __$$InjectionDataImplCopyWithImpl<_$InjectionDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InjectionDataImplToJson(
      this,
    );
  }
}

abstract class _InjectionData implements InjectionData {
  const factory _InjectionData(
      {required final String n,
      final dynamic v,
      required final int t}) = _$InjectionDataImpl;

  factory _InjectionData.fromJson(Map<String, dynamic> json) =
      _$InjectionDataImpl.fromJson;

  @override
  String get n;
  @override
  dynamic get v; // Can be String or int
  @override
  int get t;

  /// Create a copy of InjectionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InjectionDataImplCopyWith<_$InjectionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
