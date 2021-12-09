part of 'home_page_bloc.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    required AsyncValue<UserEntity> user,
  }) = _HomePageState;

  factory HomePageState.initial({required AsyncValue<UserEntity> user}) =>
      HomePageState(user: user);
}