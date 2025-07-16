// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuicDatagramException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicDatagramException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicDatagramException()';
}


}

/// @nodoc
class $QuicDatagramExceptionCopyWith<$Res>  {
$QuicDatagramExceptionCopyWith(QuicDatagramException _, $Res Function(QuicDatagramException) __);
}


/// Adds pattern-matching-related methods to [QuicDatagramException].
extension QuicDatagramExceptionPatterns on QuicDatagramException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuicDatagramException_UnsupportedByPeer value)?  unsupportedByPeer,TResult Function( QuicDatagramException_TooLarge value)?  tooLarge,TResult Function( QuicDatagramException_ConnectionLost value)?  connectionLost,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuicDatagramException_UnsupportedByPeer() when unsupportedByPeer != null:
return unsupportedByPeer(_that);case QuicDatagramException_TooLarge() when tooLarge != null:
return tooLarge(_that);case QuicDatagramException_ConnectionLost() when connectionLost != null:
return connectionLost(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuicDatagramException_UnsupportedByPeer value)  unsupportedByPeer,required TResult Function( QuicDatagramException_TooLarge value)  tooLarge,required TResult Function( QuicDatagramException_ConnectionLost value)  connectionLost,}){
final _that = this;
switch (_that) {
case QuicDatagramException_UnsupportedByPeer():
return unsupportedByPeer(_that);case QuicDatagramException_TooLarge():
return tooLarge(_that);case QuicDatagramException_ConnectionLost():
return connectionLost(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuicDatagramException_UnsupportedByPeer value)?  unsupportedByPeer,TResult? Function( QuicDatagramException_TooLarge value)?  tooLarge,TResult? Function( QuicDatagramException_ConnectionLost value)?  connectionLost,}){
final _that = this;
switch (_that) {
case QuicDatagramException_UnsupportedByPeer() when unsupportedByPeer != null:
return unsupportedByPeer(_that);case QuicDatagramException_TooLarge() when tooLarge != null:
return tooLarge(_that);case QuicDatagramException_ConnectionLost() when connectionLost != null:
return connectionLost(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unsupportedByPeer,TResult Function( BigInt maxSize)?  tooLarge,TResult Function( String field0)?  connectionLost,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuicDatagramException_UnsupportedByPeer() when unsupportedByPeer != null:
return unsupportedByPeer();case QuicDatagramException_TooLarge() when tooLarge != null:
return tooLarge(_that.maxSize);case QuicDatagramException_ConnectionLost() when connectionLost != null:
return connectionLost(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unsupportedByPeer,required TResult Function( BigInt maxSize)  tooLarge,required TResult Function( String field0)  connectionLost,}) {final _that = this;
switch (_that) {
case QuicDatagramException_UnsupportedByPeer():
return unsupportedByPeer();case QuicDatagramException_TooLarge():
return tooLarge(_that.maxSize);case QuicDatagramException_ConnectionLost():
return connectionLost(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unsupportedByPeer,TResult? Function( BigInt maxSize)?  tooLarge,TResult? Function( String field0)?  connectionLost,}) {final _that = this;
switch (_that) {
case QuicDatagramException_UnsupportedByPeer() when unsupportedByPeer != null:
return unsupportedByPeer();case QuicDatagramException_TooLarge() when tooLarge != null:
return tooLarge(_that.maxSize);case QuicDatagramException_ConnectionLost() when connectionLost != null:
return connectionLost(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class QuicDatagramException_UnsupportedByPeer extends QuicDatagramException {
  const QuicDatagramException_UnsupportedByPeer(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicDatagramException_UnsupportedByPeer);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicDatagramException.unsupportedByPeer()';
}


}




/// @nodoc


class QuicDatagramException_TooLarge extends QuicDatagramException {
  const QuicDatagramException_TooLarge({required this.maxSize}): super._();
  

 final  BigInt maxSize;

/// Create a copy of QuicDatagramException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicDatagramException_TooLargeCopyWith<QuicDatagramException_TooLarge> get copyWith => _$QuicDatagramException_TooLargeCopyWithImpl<QuicDatagramException_TooLarge>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicDatagramException_TooLarge&&(identical(other.maxSize, maxSize) || other.maxSize == maxSize));
}


@override
int get hashCode => Object.hash(runtimeType,maxSize);

@override
String toString() {
  return 'QuicDatagramException.tooLarge(maxSize: $maxSize)';
}


}

/// @nodoc
abstract mixin class $QuicDatagramException_TooLargeCopyWith<$Res> implements $QuicDatagramExceptionCopyWith<$Res> {
  factory $QuicDatagramException_TooLargeCopyWith(QuicDatagramException_TooLarge value, $Res Function(QuicDatagramException_TooLarge) _then) = _$QuicDatagramException_TooLargeCopyWithImpl;
@useResult
$Res call({
 BigInt maxSize
});




}
/// @nodoc
class _$QuicDatagramException_TooLargeCopyWithImpl<$Res>
    implements $QuicDatagramException_TooLargeCopyWith<$Res> {
  _$QuicDatagramException_TooLargeCopyWithImpl(this._self, this._then);

  final QuicDatagramException_TooLarge _self;
  final $Res Function(QuicDatagramException_TooLarge) _then;

/// Create a copy of QuicDatagramException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? maxSize = null,}) {
  return _then(QuicDatagramException_TooLarge(
maxSize: null == maxSize ? _self.maxSize : maxSize // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

/// @nodoc


class QuicDatagramException_ConnectionLost extends QuicDatagramException {
  const QuicDatagramException_ConnectionLost(this.field0): super._();
  

 final  String field0;

/// Create a copy of QuicDatagramException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicDatagramException_ConnectionLostCopyWith<QuicDatagramException_ConnectionLost> get copyWith => _$QuicDatagramException_ConnectionLostCopyWithImpl<QuicDatagramException_ConnectionLost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicDatagramException_ConnectionLost&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicDatagramException.connectionLost(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicDatagramException_ConnectionLostCopyWith<$Res> implements $QuicDatagramExceptionCopyWith<$Res> {
  factory $QuicDatagramException_ConnectionLostCopyWith(QuicDatagramException_ConnectionLost value, $Res Function(QuicDatagramException_ConnectionLost) _then) = _$QuicDatagramException_ConnectionLostCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicDatagramException_ConnectionLostCopyWithImpl<$Res>
    implements $QuicDatagramException_ConnectionLostCopyWith<$Res> {
  _$QuicDatagramException_ConnectionLostCopyWithImpl(this._self, this._then);

  final QuicDatagramException_ConnectionLost _self;
  final $Res Function(QuicDatagramException_ConnectionLost) _then;

/// Create a copy of QuicDatagramException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicDatagramException_ConnectionLost(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$QuicError {

 String get field0;
/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicErrorCopyWith<QuicError> get copyWith => _$QuicErrorCopyWithImpl<QuicError>(this as QuicError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicErrorCopyWith<$Res>  {
  factory $QuicErrorCopyWith(QuicError value, $Res Function(QuicError) _then) = _$QuicErrorCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicErrorCopyWithImpl<$Res>
    implements $QuicErrorCopyWith<$Res> {
  _$QuicErrorCopyWithImpl(this._self, this._then);

  final QuicError _self;
  final $Res Function(QuicError) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field0 = null,}) {
  return _then(_self.copyWith(
field0: null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuicError].
extension QuicErrorPatterns on QuicError {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuicError_Connection value)?  connection,TResult Function( QuicError_Endpoint value)?  endpoint,TResult Function( QuicError_Stream value)?  stream,TResult Function( QuicError_Tls value)?  tls,TResult Function( QuicError_Config value)?  config,TResult Function( QuicError_Network value)?  network,TResult Function( QuicError_Write value)?  write,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuicError_Connection() when connection != null:
return connection(_that);case QuicError_Endpoint() when endpoint != null:
return endpoint(_that);case QuicError_Stream() when stream != null:
return stream(_that);case QuicError_Tls() when tls != null:
return tls(_that);case QuicError_Config() when config != null:
return config(_that);case QuicError_Network() when network != null:
return network(_that);case QuicError_Write() when write != null:
return write(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuicError_Connection value)  connection,required TResult Function( QuicError_Endpoint value)  endpoint,required TResult Function( QuicError_Stream value)  stream,required TResult Function( QuicError_Tls value)  tls,required TResult Function( QuicError_Config value)  config,required TResult Function( QuicError_Network value)  network,required TResult Function( QuicError_Write value)  write,}){
final _that = this;
switch (_that) {
case QuicError_Connection():
return connection(_that);case QuicError_Endpoint():
return endpoint(_that);case QuicError_Stream():
return stream(_that);case QuicError_Tls():
return tls(_that);case QuicError_Config():
return config(_that);case QuicError_Network():
return network(_that);case QuicError_Write():
return write(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuicError_Connection value)?  connection,TResult? Function( QuicError_Endpoint value)?  endpoint,TResult? Function( QuicError_Stream value)?  stream,TResult? Function( QuicError_Tls value)?  tls,TResult? Function( QuicError_Config value)?  config,TResult? Function( QuicError_Network value)?  network,TResult? Function( QuicError_Write value)?  write,}){
final _that = this;
switch (_that) {
case QuicError_Connection() when connection != null:
return connection(_that);case QuicError_Endpoint() when endpoint != null:
return endpoint(_that);case QuicError_Stream() when stream != null:
return stream(_that);case QuicError_Tls() when tls != null:
return tls(_that);case QuicError_Config() when config != null:
return config(_that);case QuicError_Network() when network != null:
return network(_that);case QuicError_Write() when write != null:
return write(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String field0)?  connection,TResult Function( String field0)?  endpoint,TResult Function( String field0)?  stream,TResult Function( String field0)?  tls,TResult Function( String field0)?  config,TResult Function( String field0)?  network,TResult Function( String field0)?  write,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuicError_Connection() when connection != null:
return connection(_that.field0);case QuicError_Endpoint() when endpoint != null:
return endpoint(_that.field0);case QuicError_Stream() when stream != null:
return stream(_that.field0);case QuicError_Tls() when tls != null:
return tls(_that.field0);case QuicError_Config() when config != null:
return config(_that.field0);case QuicError_Network() when network != null:
return network(_that.field0);case QuicError_Write() when write != null:
return write(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String field0)  connection,required TResult Function( String field0)  endpoint,required TResult Function( String field0)  stream,required TResult Function( String field0)  tls,required TResult Function( String field0)  config,required TResult Function( String field0)  network,required TResult Function( String field0)  write,}) {final _that = this;
switch (_that) {
case QuicError_Connection():
return connection(_that.field0);case QuicError_Endpoint():
return endpoint(_that.field0);case QuicError_Stream():
return stream(_that.field0);case QuicError_Tls():
return tls(_that.field0);case QuicError_Config():
return config(_that.field0);case QuicError_Network():
return network(_that.field0);case QuicError_Write():
return write(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String field0)?  connection,TResult? Function( String field0)?  endpoint,TResult? Function( String field0)?  stream,TResult? Function( String field0)?  tls,TResult? Function( String field0)?  config,TResult? Function( String field0)?  network,TResult? Function( String field0)?  write,}) {final _that = this;
switch (_that) {
case QuicError_Connection() when connection != null:
return connection(_that.field0);case QuicError_Endpoint() when endpoint != null:
return endpoint(_that.field0);case QuicError_Stream() when stream != null:
return stream(_that.field0);case QuicError_Tls() when tls != null:
return tls(_that.field0);case QuicError_Config() when config != null:
return config(_that.field0);case QuicError_Network() when network != null:
return network(_that.field0);case QuicError_Write() when write != null:
return write(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class QuicError_Connection extends QuicError {
  const QuicError_Connection(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_ConnectionCopyWith<QuicError_Connection> get copyWith => _$QuicError_ConnectionCopyWithImpl<QuicError_Connection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Connection&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.connection(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_ConnectionCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_ConnectionCopyWith(QuicError_Connection value, $Res Function(QuicError_Connection) _then) = _$QuicError_ConnectionCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_ConnectionCopyWithImpl<$Res>
    implements $QuicError_ConnectionCopyWith<$Res> {
  _$QuicError_ConnectionCopyWithImpl(this._self, this._then);

  final QuicError_Connection _self;
  final $Res Function(QuicError_Connection) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Connection(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicError_Endpoint extends QuicError {
  const QuicError_Endpoint(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_EndpointCopyWith<QuicError_Endpoint> get copyWith => _$QuicError_EndpointCopyWithImpl<QuicError_Endpoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Endpoint&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.endpoint(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_EndpointCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_EndpointCopyWith(QuicError_Endpoint value, $Res Function(QuicError_Endpoint) _then) = _$QuicError_EndpointCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_EndpointCopyWithImpl<$Res>
    implements $QuicError_EndpointCopyWith<$Res> {
  _$QuicError_EndpointCopyWithImpl(this._self, this._then);

  final QuicError_Endpoint _self;
  final $Res Function(QuicError_Endpoint) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Endpoint(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicError_Stream extends QuicError {
  const QuicError_Stream(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_StreamCopyWith<QuicError_Stream> get copyWith => _$QuicError_StreamCopyWithImpl<QuicError_Stream>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Stream&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.stream(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_StreamCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_StreamCopyWith(QuicError_Stream value, $Res Function(QuicError_Stream) _then) = _$QuicError_StreamCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_StreamCopyWithImpl<$Res>
    implements $QuicError_StreamCopyWith<$Res> {
  _$QuicError_StreamCopyWithImpl(this._self, this._then);

  final QuicError_Stream _self;
  final $Res Function(QuicError_Stream) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Stream(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicError_Tls extends QuicError {
  const QuicError_Tls(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_TlsCopyWith<QuicError_Tls> get copyWith => _$QuicError_TlsCopyWithImpl<QuicError_Tls>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Tls&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.tls(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_TlsCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_TlsCopyWith(QuicError_Tls value, $Res Function(QuicError_Tls) _then) = _$QuicError_TlsCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_TlsCopyWithImpl<$Res>
    implements $QuicError_TlsCopyWith<$Res> {
  _$QuicError_TlsCopyWithImpl(this._self, this._then);

  final QuicError_Tls _self;
  final $Res Function(QuicError_Tls) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Tls(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicError_Config extends QuicError {
  const QuicError_Config(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_ConfigCopyWith<QuicError_Config> get copyWith => _$QuicError_ConfigCopyWithImpl<QuicError_Config>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Config&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.config(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_ConfigCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_ConfigCopyWith(QuicError_Config value, $Res Function(QuicError_Config) _then) = _$QuicError_ConfigCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_ConfigCopyWithImpl<$Res>
    implements $QuicError_ConfigCopyWith<$Res> {
  _$QuicError_ConfigCopyWithImpl(this._self, this._then);

  final QuicError_Config _self;
  final $Res Function(QuicError_Config) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Config(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicError_Network extends QuicError {
  const QuicError_Network(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_NetworkCopyWith<QuicError_Network> get copyWith => _$QuicError_NetworkCopyWithImpl<QuicError_Network>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Network&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.network(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_NetworkCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_NetworkCopyWith(QuicError_Network value, $Res Function(QuicError_Network) _then) = _$QuicError_NetworkCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_NetworkCopyWithImpl<$Res>
    implements $QuicError_NetworkCopyWith<$Res> {
  _$QuicError_NetworkCopyWithImpl(this._self, this._then);

  final QuicError_Network _self;
  final $Res Function(QuicError_Network) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Network(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicError_Write extends QuicError {
  const QuicError_Write(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicError_WriteCopyWith<QuicError_Write> get copyWith => _$QuicError_WriteCopyWithImpl<QuicError_Write>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicError_Write&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicError.write(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicError_WriteCopyWith<$Res> implements $QuicErrorCopyWith<$Res> {
  factory $QuicError_WriteCopyWith(QuicError_Write value, $Res Function(QuicError_Write) _then) = _$QuicError_WriteCopyWithImpl;
@override @useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicError_WriteCopyWithImpl<$Res>
    implements $QuicError_WriteCopyWith<$Res> {
  _$QuicError_WriteCopyWithImpl(this._self, this._then);

  final QuicError_Write _self;
  final $Res Function(QuicError_Write) _then;

/// Create a copy of QuicError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicError_Write(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$QuicReadException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicReadException()';
}


}

/// @nodoc
class $QuicReadExceptionCopyWith<$Res>  {
$QuicReadExceptionCopyWith(QuicReadException _, $Res Function(QuicReadException) __);
}


/// Adds pattern-matching-related methods to [QuicReadException].
extension QuicReadExceptionPatterns on QuicReadException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuicReadException_Reset value)?  reset,TResult Function( QuicReadException_ConnectionLost value)?  connectionLost,TResult Function( QuicReadException_ZeroRttRejected value)?  zeroRttRejected,TResult Function( QuicReadException_ClosedStream value)?  closedStream,TResult Function( QuicReadException_IllegalOrderedRead value)?  illegalOrderedRead,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuicReadException_Reset() when reset != null:
return reset(_that);case QuicReadException_ConnectionLost() when connectionLost != null:
return connectionLost(_that);case QuicReadException_ZeroRttRejected() when zeroRttRejected != null:
return zeroRttRejected(_that);case QuicReadException_ClosedStream() when closedStream != null:
return closedStream(_that);case QuicReadException_IllegalOrderedRead() when illegalOrderedRead != null:
return illegalOrderedRead(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuicReadException_Reset value)  reset,required TResult Function( QuicReadException_ConnectionLost value)  connectionLost,required TResult Function( QuicReadException_ZeroRttRejected value)  zeroRttRejected,required TResult Function( QuicReadException_ClosedStream value)  closedStream,required TResult Function( QuicReadException_IllegalOrderedRead value)  illegalOrderedRead,}){
final _that = this;
switch (_that) {
case QuicReadException_Reset():
return reset(_that);case QuicReadException_ConnectionLost():
return connectionLost(_that);case QuicReadException_ZeroRttRejected():
return zeroRttRejected(_that);case QuicReadException_ClosedStream():
return closedStream(_that);case QuicReadException_IllegalOrderedRead():
return illegalOrderedRead(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuicReadException_Reset value)?  reset,TResult? Function( QuicReadException_ConnectionLost value)?  connectionLost,TResult? Function( QuicReadException_ZeroRttRejected value)?  zeroRttRejected,TResult? Function( QuicReadException_ClosedStream value)?  closedStream,TResult? Function( QuicReadException_IllegalOrderedRead value)?  illegalOrderedRead,}){
final _that = this;
switch (_that) {
case QuicReadException_Reset() when reset != null:
return reset(_that);case QuicReadException_ConnectionLost() when connectionLost != null:
return connectionLost(_that);case QuicReadException_ZeroRttRejected() when zeroRttRejected != null:
return zeroRttRejected(_that);case QuicReadException_ClosedStream() when closedStream != null:
return closedStream(_that);case QuicReadException_IllegalOrderedRead() when illegalOrderedRead != null:
return illegalOrderedRead(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BigInt field0)?  reset,TResult Function( String field0)?  connectionLost,TResult Function()?  zeroRttRejected,TResult Function()?  closedStream,TResult Function()?  illegalOrderedRead,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuicReadException_Reset() when reset != null:
return reset(_that.field0);case QuicReadException_ConnectionLost() when connectionLost != null:
return connectionLost(_that.field0);case QuicReadException_ZeroRttRejected() when zeroRttRejected != null:
return zeroRttRejected();case QuicReadException_ClosedStream() when closedStream != null:
return closedStream();case QuicReadException_IllegalOrderedRead() when illegalOrderedRead != null:
return illegalOrderedRead();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BigInt field0)  reset,required TResult Function( String field0)  connectionLost,required TResult Function()  zeroRttRejected,required TResult Function()  closedStream,required TResult Function()  illegalOrderedRead,}) {final _that = this;
switch (_that) {
case QuicReadException_Reset():
return reset(_that.field0);case QuicReadException_ConnectionLost():
return connectionLost(_that.field0);case QuicReadException_ZeroRttRejected():
return zeroRttRejected();case QuicReadException_ClosedStream():
return closedStream();case QuicReadException_IllegalOrderedRead():
return illegalOrderedRead();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BigInt field0)?  reset,TResult? Function( String field0)?  connectionLost,TResult? Function()?  zeroRttRejected,TResult? Function()?  closedStream,TResult? Function()?  illegalOrderedRead,}) {final _that = this;
switch (_that) {
case QuicReadException_Reset() when reset != null:
return reset(_that.field0);case QuicReadException_ConnectionLost() when connectionLost != null:
return connectionLost(_that.field0);case QuicReadException_ZeroRttRejected() when zeroRttRejected != null:
return zeroRttRejected();case QuicReadException_ClosedStream() when closedStream != null:
return closedStream();case QuicReadException_IllegalOrderedRead() when illegalOrderedRead != null:
return illegalOrderedRead();case _:
  return null;

}
}

}

/// @nodoc


class QuicReadException_Reset extends QuicReadException {
  const QuicReadException_Reset(this.field0): super._();
  

 final  BigInt field0;

/// Create a copy of QuicReadException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicReadException_ResetCopyWith<QuicReadException_Reset> get copyWith => _$QuicReadException_ResetCopyWithImpl<QuicReadException_Reset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadException_Reset&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicReadException.reset(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicReadException_ResetCopyWith<$Res> implements $QuicReadExceptionCopyWith<$Res> {
  factory $QuicReadException_ResetCopyWith(QuicReadException_Reset value, $Res Function(QuicReadException_Reset) _then) = _$QuicReadException_ResetCopyWithImpl;
@useResult
$Res call({
 BigInt field0
});




}
/// @nodoc
class _$QuicReadException_ResetCopyWithImpl<$Res>
    implements $QuicReadException_ResetCopyWith<$Res> {
  _$QuicReadException_ResetCopyWithImpl(this._self, this._then);

  final QuicReadException_Reset _self;
  final $Res Function(QuicReadException_Reset) _then;

/// Create a copy of QuicReadException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicReadException_Reset(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

/// @nodoc


class QuicReadException_ConnectionLost extends QuicReadException {
  const QuicReadException_ConnectionLost(this.field0): super._();
  

 final  String field0;

/// Create a copy of QuicReadException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicReadException_ConnectionLostCopyWith<QuicReadException_ConnectionLost> get copyWith => _$QuicReadException_ConnectionLostCopyWithImpl<QuicReadException_ConnectionLost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadException_ConnectionLost&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicReadException.connectionLost(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicReadException_ConnectionLostCopyWith<$Res> implements $QuicReadExceptionCopyWith<$Res> {
  factory $QuicReadException_ConnectionLostCopyWith(QuicReadException_ConnectionLost value, $Res Function(QuicReadException_ConnectionLost) _then) = _$QuicReadException_ConnectionLostCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicReadException_ConnectionLostCopyWithImpl<$Res>
    implements $QuicReadException_ConnectionLostCopyWith<$Res> {
  _$QuicReadException_ConnectionLostCopyWithImpl(this._self, this._then);

  final QuicReadException_ConnectionLost _self;
  final $Res Function(QuicReadException_ConnectionLost) _then;

/// Create a copy of QuicReadException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicReadException_ConnectionLost(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class QuicReadException_ZeroRttRejected extends QuicReadException {
  const QuicReadException_ZeroRttRejected(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadException_ZeroRttRejected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicReadException.zeroRttRejected()';
}


}




/// @nodoc


class QuicReadException_ClosedStream extends QuicReadException {
  const QuicReadException_ClosedStream(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadException_ClosedStream);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicReadException.closedStream()';
}


}




/// @nodoc


class QuicReadException_IllegalOrderedRead extends QuicReadException {
  const QuicReadException_IllegalOrderedRead(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadException_IllegalOrderedRead);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicReadException.illegalOrderedRead()';
}


}




/// @nodoc
mixin _$QuicReadToEndException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadToEndException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicReadToEndException()';
}


}

/// @nodoc
class $QuicReadToEndExceptionCopyWith<$Res>  {
$QuicReadToEndExceptionCopyWith(QuicReadToEndException _, $Res Function(QuicReadToEndException) __);
}


/// Adds pattern-matching-related methods to [QuicReadToEndException].
extension QuicReadToEndExceptionPatterns on QuicReadToEndException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuicReadToEndException_Read value)?  read,TResult Function( QuicReadToEndException_TooLong value)?  tooLong,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuicReadToEndException_Read() when read != null:
return read(_that);case QuicReadToEndException_TooLong() when tooLong != null:
return tooLong(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuicReadToEndException_Read value)  read,required TResult Function( QuicReadToEndException_TooLong value)  tooLong,}){
final _that = this;
switch (_that) {
case QuicReadToEndException_Read():
return read(_that);case QuicReadToEndException_TooLong():
return tooLong(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuicReadToEndException_Read value)?  read,TResult? Function( QuicReadToEndException_TooLong value)?  tooLong,}){
final _that = this;
switch (_that) {
case QuicReadToEndException_Read() when read != null:
return read(_that);case QuicReadToEndException_TooLong() when tooLong != null:
return tooLong(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( QuicReadException field0)?  read,TResult Function()?  tooLong,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuicReadToEndException_Read() when read != null:
return read(_that.field0);case QuicReadToEndException_TooLong() when tooLong != null:
return tooLong();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( QuicReadException field0)  read,required TResult Function()  tooLong,}) {final _that = this;
switch (_that) {
case QuicReadToEndException_Read():
return read(_that.field0);case QuicReadToEndException_TooLong():
return tooLong();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( QuicReadException field0)?  read,TResult? Function()?  tooLong,}) {final _that = this;
switch (_that) {
case QuicReadToEndException_Read() when read != null:
return read(_that.field0);case QuicReadToEndException_TooLong() when tooLong != null:
return tooLong();case _:
  return null;

}
}

}

/// @nodoc


class QuicReadToEndException_Read extends QuicReadToEndException {
  const QuicReadToEndException_Read(this.field0): super._();
  

 final  QuicReadException field0;

/// Create a copy of QuicReadToEndException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicReadToEndException_ReadCopyWith<QuicReadToEndException_Read> get copyWith => _$QuicReadToEndException_ReadCopyWithImpl<QuicReadToEndException_Read>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadToEndException_Read&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicReadToEndException.read(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicReadToEndException_ReadCopyWith<$Res> implements $QuicReadToEndExceptionCopyWith<$Res> {
  factory $QuicReadToEndException_ReadCopyWith(QuicReadToEndException_Read value, $Res Function(QuicReadToEndException_Read) _then) = _$QuicReadToEndException_ReadCopyWithImpl;
@useResult
$Res call({
 QuicReadException field0
});


$QuicReadExceptionCopyWith<$Res> get field0;

}
/// @nodoc
class _$QuicReadToEndException_ReadCopyWithImpl<$Res>
    implements $QuicReadToEndException_ReadCopyWith<$Res> {
  _$QuicReadToEndException_ReadCopyWithImpl(this._self, this._then);

  final QuicReadToEndException_Read _self;
  final $Res Function(QuicReadToEndException_Read) _then;

/// Create a copy of QuicReadToEndException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicReadToEndException_Read(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as QuicReadException,
  ));
}

/// Create a copy of QuicReadToEndException
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuicReadExceptionCopyWith<$Res> get field0 {
  
  return $QuicReadExceptionCopyWith<$Res>(_self.field0, (value) {
    return _then(_self.copyWith(field0: value));
  });
}
}

/// @nodoc


class QuicReadToEndException_TooLong extends QuicReadToEndException {
  const QuicReadToEndException_TooLong(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicReadToEndException_TooLong);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuicReadToEndException.tooLong()';
}


}




/// @nodoc
mixin _$QuicWriteException {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicWriteException&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'QuicWriteException(field0: $field0)';
}


}

/// @nodoc
class $QuicWriteExceptionCopyWith<$Res>  {
$QuicWriteExceptionCopyWith(QuicWriteException _, $Res Function(QuicWriteException) __);
}


/// Adds pattern-matching-related methods to [QuicWriteException].
extension QuicWriteExceptionPatterns on QuicWriteException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuicWriteException_Stopped value)?  stopped,TResult Function( QuicWriteException_ConnectionLost value)?  connectionLost,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuicWriteException_Stopped() when stopped != null:
return stopped(_that);case QuicWriteException_ConnectionLost() when connectionLost != null:
return connectionLost(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuicWriteException_Stopped value)  stopped,required TResult Function( QuicWriteException_ConnectionLost value)  connectionLost,}){
final _that = this;
switch (_that) {
case QuicWriteException_Stopped():
return stopped(_that);case QuicWriteException_ConnectionLost():
return connectionLost(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuicWriteException_Stopped value)?  stopped,TResult? Function( QuicWriteException_ConnectionLost value)?  connectionLost,}){
final _that = this;
switch (_that) {
case QuicWriteException_Stopped() when stopped != null:
return stopped(_that);case QuicWriteException_ConnectionLost() when connectionLost != null:
return connectionLost(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BigInt field0)?  stopped,TResult Function( String field0)?  connectionLost,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuicWriteException_Stopped() when stopped != null:
return stopped(_that.field0);case QuicWriteException_ConnectionLost() when connectionLost != null:
return connectionLost(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BigInt field0)  stopped,required TResult Function( String field0)  connectionLost,}) {final _that = this;
switch (_that) {
case QuicWriteException_Stopped():
return stopped(_that.field0);case QuicWriteException_ConnectionLost():
return connectionLost(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BigInt field0)?  stopped,TResult? Function( String field0)?  connectionLost,}) {final _that = this;
switch (_that) {
case QuicWriteException_Stopped() when stopped != null:
return stopped(_that.field0);case QuicWriteException_ConnectionLost() when connectionLost != null:
return connectionLost(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class QuicWriteException_Stopped extends QuicWriteException {
  const QuicWriteException_Stopped(this.field0): super._();
  

@override final  BigInt field0;

/// Create a copy of QuicWriteException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicWriteException_StoppedCopyWith<QuicWriteException_Stopped> get copyWith => _$QuicWriteException_StoppedCopyWithImpl<QuicWriteException_Stopped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicWriteException_Stopped&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicWriteException.stopped(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicWriteException_StoppedCopyWith<$Res> implements $QuicWriteExceptionCopyWith<$Res> {
  factory $QuicWriteException_StoppedCopyWith(QuicWriteException_Stopped value, $Res Function(QuicWriteException_Stopped) _then) = _$QuicWriteException_StoppedCopyWithImpl;
@useResult
$Res call({
 BigInt field0
});




}
/// @nodoc
class _$QuicWriteException_StoppedCopyWithImpl<$Res>
    implements $QuicWriteException_StoppedCopyWith<$Res> {
  _$QuicWriteException_StoppedCopyWithImpl(this._self, this._then);

  final QuicWriteException_Stopped _self;
  final $Res Function(QuicWriteException_Stopped) _then;

/// Create a copy of QuicWriteException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicWriteException_Stopped(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

/// @nodoc


class QuicWriteException_ConnectionLost extends QuicWriteException {
  const QuicWriteException_ConnectionLost(this.field0): super._();
  

@override final  String field0;

/// Create a copy of QuicWriteException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuicWriteException_ConnectionLostCopyWith<QuicWriteException_ConnectionLost> get copyWith => _$QuicWriteException_ConnectionLostCopyWithImpl<QuicWriteException_ConnectionLost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuicWriteException_ConnectionLost&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'QuicWriteException.connectionLost(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $QuicWriteException_ConnectionLostCopyWith<$Res> implements $QuicWriteExceptionCopyWith<$Res> {
  factory $QuicWriteException_ConnectionLostCopyWith(QuicWriteException_ConnectionLost value, $Res Function(QuicWriteException_ConnectionLost) _then) = _$QuicWriteException_ConnectionLostCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$QuicWriteException_ConnectionLostCopyWithImpl<$Res>
    implements $QuicWriteException_ConnectionLostCopyWith<$Res> {
  _$QuicWriteException_ConnectionLostCopyWithImpl(this._self, this._then);

  final QuicWriteException_ConnectionLost _self;
  final $Res Function(QuicWriteException_ConnectionLost) _then;

/// Create a copy of QuicWriteException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(QuicWriteException_ConnectionLost(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
