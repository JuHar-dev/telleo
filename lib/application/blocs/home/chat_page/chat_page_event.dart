part of 'chat_page_bloc.dart';

@freezed
class ChatPageEvent with _$ChatPageEvent {
  const factory ChatPageEvent.started() = _Started;
}