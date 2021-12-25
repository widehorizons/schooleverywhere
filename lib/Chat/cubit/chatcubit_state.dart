part of 'chatcubit_cubit.dart';

@immutable
abstract class ChatState {}

class ChatcubitInitial extends ChatState {}

class ChatcubitRepliesSuccess extends ChatState {
  final EventObject data;

  ChatcubitRepliesSuccess(this.data);
}

class ChatcubitSendSuccess extends ChatState {
  final EventObject data;

  ChatcubitSendSuccess(this.data);
}

class ChatcubitError extends ChatState {
  final String error;

  ChatcubitError(this.error);
}
