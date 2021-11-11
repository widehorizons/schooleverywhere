import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:schooleverywhere/Constants/StringConstants.dart';
import 'package:schooleverywhere/Modules/EventObject.dart';
import 'package:schooleverywhere/Networking/Futures.dart';

part 'chatcubit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatcubitInitial());
  sendReply(
      String role,
      List fileslist,
      String? message,
      String regno,
      String id,
      String staffid,
      String staffName,
      String subjectId,
      String year) async {
    print("send Reply messages from cubit is working well");

    if (role == STUDENT_TYPE) {
      EventObject eventObject = await replyReplySendtoclassStudent(
          fileslist, message!, regno, id, staffid, staffName, subjectId, year);
      if (eventObject.success!) {
        emit(ChatcubitSendSuccess(eventObject));
        getAllMessages(STUDENT_TYPE, id, regno);
      } else {
        emit(ChatcubitError(eventObject.object as String));
      }
    }
    if (role == STAFF_TYPE) {
      EventObject eventObject = await replyReplySendtoclassReadStaffStudent(
          fileslist, message!, regno, id, staffid, staffName, subjectId, year);
      if (eventObject.success!) {
        emit(ChatcubitSendSuccess(eventObject));
        getAllMessages(STAFF_TYPE, id, regno, staffid: staffid);
      } else {
        emit(ChatcubitError(eventObject.object as String));
      }
    }
  }

  getAllMessages(String role, String messageId, String regno,
      {String? staffid}) async {
    print(
        "get messages from cubit is working well [$role] [$messageId] [$regno]");
    if (role == STUDENT_TYPE) {
      EventObject eventObject = await getStudentMessages(messageId, regno);
      if (eventObject.success!) {
        emit(ChatcubitRepliesSuccess(eventObject));
      } else {
        emit(ChatcubitError(eventObject.object as String));
      }
    }
    if (role == STAFF_TYPE) {
      EventObject eventObject =
          await readReplySentToClass(messageId, regno, staffid!);
      if (eventObject.success!) {
        emit(ChatcubitRepliesSuccess(eventObject));
      } else {
        emit(ChatcubitError(eventObject.object as String));
      }
    }
  }
}
