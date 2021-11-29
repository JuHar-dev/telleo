part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.requestUserCheck() = _RequestUserCheck;
  const factory AuthEvent.signOut() = _SignOut;
  const factory AuthEvent.updateUser() = _UpdateUser;
}
