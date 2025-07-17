// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_injection_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TokenInjectionState {
  Status get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  TokenInjectionResponse? get response => throw _privateConstructorUsedError;

  /// Create a copy of TokenInjectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenInjectionStateCopyWith<TokenInjectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenInjectionStateCopyWith<$Res> {
  factory $TokenInjectionStateCopyWith(
          TokenInjectionState value, $Res Function(TokenInjectionState) then) =
      _$TokenInjectionStateCopyWithImpl<$Res, TokenInjectionState>;
  @useResult
  $Res call(
      {Status status, String? errorMessage, TokenInjectionResponse? response});

  $TokenInjectionResponseCopyWith<$Res>? get response;
}

/// @nodoc
class _$TokenInjectionStateCopyWithImpl<$Res, $Val extends TokenInjectionState>
    implements $TokenInjectionStateCopyWith<$Res> {
  _$TokenInjectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenInjectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as TokenInjectionResponse?,
    ) as $Val);
  }

  /// Create a copy of TokenInjectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInjectionResponseCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $TokenInjectionResponseCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TokenInjectionStateImplCopyWith<$Res>
    implements $TokenInjectionStateCopyWith<$Res> {
  factory _$$TokenInjectionStateImplCopyWith(_$TokenInjectionStateImpl value,
          $Res Function(_$TokenInjectionStateImpl) then) =
      __$$TokenInjectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Status status, String? errorMessage, TokenInjectionResponse? response});

  @override
  $TokenInjectionResponseCopyWith<$Res>? get response;
}

/// @nodoc
class __$$TokenInjectionStateImplCopyWithImpl<$Res>
    extends _$TokenInjectionStateCopyWithImpl<$Res, _$TokenInjectionStateImpl>
    implements _$$TokenInjectionStateImplCopyWith<$Res> {
  __$$TokenInjectionStateImplCopyWithImpl(_$TokenInjectionStateImpl _value,
      $Res Function(_$TokenInjectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenInjectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? errorMessage = freezed,
    Object? response = freezed,
  }) {
    return _then(_$TokenInjectionStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as TokenInjectionResponse?,
    ));
  }
}

/// @nodoc

class _$TokenInjectionStateImpl implements _TokenInjectionState {
  const _$TokenInjectionStateImpl(
      {this.status = Status.idle, this.errorMessage, this.response});

  @override
  @JsonKey()
  final Status status;
  @override
  final String? errorMessage;
  @override
  final TokenInjectionResponse? response;

  @override
  String toString() {
    return 'TokenInjectionState(status: $status, errorMessage: $errorMessage, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenInjectionStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, errorMessage, response);

  /// Create a copy of TokenInjectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenInjectionStateImplCopyWith<_$TokenInjectionStateImpl> get copyWith =>
      __$$TokenInjectionStateImplCopyWithImpl<_$TokenInjectionStateImpl>(
          this, _$identity);
}

abstract class _TokenInjectionState implements TokenInjectionState {
  const factory _TokenInjectionState(
      {final Status status,
      final String? errorMessage,
      final TokenInjectionResponse? response}) = _$TokenInjectionStateImpl;

  @override
  Status get status;
  @override
  String? get errorMessage;
  @override
  TokenInjectionResponse? get response;

  /// Create a copy of TokenInjectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenInjectionStateImplCopyWith<_$TokenInjectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
