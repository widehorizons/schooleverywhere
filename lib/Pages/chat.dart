import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:schooleverywhere/Modules/EventObject.dart';
import 'package:schooleverywhere/Modules/Parent.dart';
import 'package:schooleverywhere/Modules/Student.dart';
import 'package:schooleverywhere/Networking/Futures.dart';
import 'package:schooleverywhere/SharedPreferences/Prefs.dart';
import 'package:schooleverywhere/Style/theme.dart';
import 'package:schooleverywhere/widget/full_photo.dart';
import 'package:schooleverywhere/widget/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  Chat(
    this.id,
    this.type,
  );
  final String id;
  final String type;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Parent? loggedParent;

  Student? loggedStudent;

  Future<void> getLoggedStudent() async {
    print("User Type in Chat module ${widget.type}");
    if (widget.type == "Student") {
      loggedStudent = await getUserData() as Student;
      print("studentData " + loggedStudent!.toString() + widget.id);
    } else {
      loggedParent = await getUserData() as Parent;
      print("ParentData " + loggedParent!.regno.toString() + widget.id);
    }
    // InsertSeenRec();
  }

  @override
  void initState() {
    getLoggedStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        title: Text(
          'CHAT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(widget.type, widget.id),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(this.type, this.id);
  final String type;
  final String id;

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState();

  late String id;

  List<dynamic>? listMessage;
  late String groupChatId;
  late SharedPreferences prefs;

  late File imageFile;
  late bool isLoading;
  late bool isShowSticker;
  late String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    getData();
    // readLocal();
  }

  Future<void> getData() async {
    print("ID:" + widget.id.toString());
    EventObject eventObject = await getUserMessages(widget.id.toString());
    if (eventObject.success!) {
      Map? MessageReplies = eventObject.object as Map?;
      setState(() {
        print(MessageReplies);
        MessageReplies;
        listMessage = MessageReplies!['data'];
        print("Messages here ===> $listMessage");
      });
    } else {
      String? msg = eventObject.object as String?;
      /*   Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  // readLocal() async {
  //   prefs = await SharedPreferences.getInstance();
  //   id = prefs.getString('id') ?? '';
  //   if (id.hashCode <= peerId.hashCode) {
  //     groupChatId = '$id-$peerId';
  //   } else {
  //     groupChatId = '$peerId-$id';
  //   }

  //   Firestore.instance
  //       .collection('users')
  //       .document(id)
  //       .updateData({'chattingWith': peerId});

  //   setState(() {});
  // }

  Future getImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      // uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  // Future uploadFile() async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
  //   StorageUploadTask uploadTask = reference.putFile(imageFile);
  //   StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  //   storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
  //     imageUrl = downloadUrl;
  //     setState(() {
  //       isLoading = false;
  //       onSendMessage(imageUrl, 1);
  //     });
  //   }, onError: (err) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(msg: 'This file is not an image');
  //   });
  // }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      // var documentReference = Firestore.instance
      //     .collection('messages')
      //     .document(groupChatId)
      //     .collection(groupChatId)
      //     .document(DateTime.now().millisecondsSinceEpoch.toString());

      // Firestore.instance.runTransaction((transaction) async {
      //   await transaction.set(
      //     documentReference,
      //     {
      //       'idFrom': id,
      //       'idTo': peerId,
      //       'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      //       'content': content,
      //       'type': type
      //     },
      //   );
      // });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, Map message) {
    print("message Role ===> ${message['sendertype']} ${widget.type} ");
    if (message['sendertype'].toString().toLowerCase() ==
        widget.type.toLowerCase()) {
      print("message from me");
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
            child: Text(
              message['replymessage'],
              style: TextStyle(color: AppTheme.appColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
          // : message['type'] == 1
          //     // Image
          //     ? Container(
          //         child: FlatButton(
          //           child: Material(
          //             child: CachedNetworkImage(
          //               placeholder: (context, url) => Container(
          //                 child: CircularProgressIndicator(
          //                   valueColor:
          //                       AlwaysStoppedAnimation<Color>(Colors.red),
          //                 ),
          //                 width: 200.0,
          //                 height: 200.0,
          //                 padding: EdgeInsets.all(70.0),
          //                 decoration: BoxDecoration(
          //                   color: Colors.grey.shade300,
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(8.0),
          //                   ),
          //                 ),
          //               ),
          //               errorWidget: (context, url, error) => Material(
          //                 child: Image.asset(
          //                   'images/img_not_available.jpeg',
          //                   width: 200.0,
          //                   height: 200.0,
          //                   fit: BoxFit.cover,
          //                 ),
          //                 borderRadius: BorderRadius.all(
          //                   Radius.circular(8.0),
          //                 ),
          //                 clipBehavior: Clip.hardEdge,
          //               ),
          //               imageUrl: message['content'],
          //               width: 200.0,
          //               height: 200.0,
          //               fit: BoxFit.cover,
          //             ),
          //             borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //             clipBehavior: Clip.hardEdge,
          //           ),
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) =>
          //                         FullPhoto(url: message['content'])));
          //           },
          //           padding: EdgeInsets.all(0),
          //         ),
          //         margin: EdgeInsets.only(
          //             bottom: isLastMessageRight(index) ? 20.0 : 10.0,
          //             right: 10.0),
          //       )
          //     // Sticker
          //     : Container(
          //         child: Image.asset(
          //           'images/${message['content']}.gif',
          //           width: 100.0,
          //           height: 100.0,
          //           fit: BoxFit.cover,
          //         ),
          //         margin: EdgeInsets.only(
          //             bottom: isLastMessageRight(index) ? 20.0 : 10.0,
          //             right: 10.0),
          //       ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      print("message to me");

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: '',
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                // message['type'] == 0
                //     ?
                Container(
                  child: Text(
                    message['replymessage'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: AppTheme.appColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                // : message['type'] == 1
                //     ? Container(
                //         child: FlatButton(
                //           child: Material(
                //             child: CachedNetworkImage(
                //               placeholder: (context, url) => Container(
                //                 child: CircularProgressIndicator(
                //                   valueColor: AlwaysStoppedAnimation<Color>(
                //                       Colors.red),
                //                 ),
                //                 width: 200.0,
                //                 height: 200.0,
                //                 padding: EdgeInsets.all(70.0),
                //                 decoration: BoxDecoration(
                //                   color: Colors.grey.shade300,
                //                   borderRadius: BorderRadius.all(
                //                     Radius.circular(8.0),
                //                   ),
                //                 ),
                //               ),
                //               errorWidget: (context, url, error) =>
                //                   Material(
                //                 child: Image.asset(
                //                   'images/img_not_available.jpeg',
                //                   width: 200.0,
                //                   height: 200.0,
                //                   fit: BoxFit.cover,
                //                 ),
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(8.0),
                //                 ),
                //                 clipBehavior: Clip.hardEdge,
                //               ),
                //               imageUrl: message['replymessage'],
                //               width: 200.0,
                //               height: 200.0,
                //               fit: BoxFit.cover,
                //             ),
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(8.0)),
                //             clipBehavior: Clip.hardEdge,
                //           ),
                //           onPressed: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => FullPhoto(
                //                         url: message['content'])));
                //           },
                //           padding: EdgeInsets.all(0),
                //         ),
                //         margin: EdgeInsets.only(left: 10.0),
                //       )
                //     : Container(
                //         child: Image.asset(
                //           'images/${message['content']}.gif',
                //           width: 100.0,
                //           height: 100.0,
                //           fit: BoxFit.cover,
                //         ),
                //         margin: EdgeInsets.only(
                //             bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                //             right: 10.0),
                //       ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse('1635416153444'))),
                      style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage![index - 1]['sendertype'] == widget.type) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage![index - 1]['sendertype'] != widget.type) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      // Firestore.instance
      //     .collection('users')
      //     .message(id)
      //     .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              (listMessage != null)
                  ? buildListMessage(listMessage!)
                  : Flexible(child: Center(child: Loading())),

              // Sticker
              // (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  // Widget buildSticker() {
  //   return Container(
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi1', 2),
  //               child: Image.asset(
  //                 'images/mimi1.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi2', 2),
  //               child: Image.asset(
  //                 'images/mimi2.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi3', 2),
  //               child: Image.asset(
  //                 'images/mimi3.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi4', 2),
  //               child: Image.asset(
  //                 'images/mimi4.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi5', 2),
  //               child: Image.asset(
  //                 'images/mimi5.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi6', 2),
  //               child: Image.asset(
  //                 'images/mimi6.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi7', 2),
  //               child: Image.asset(
  //                 'images/mimi7.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi8', 2),
  //               child: Image.asset(
  //                 'images/mimi8.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi9', 2),
  //               child: Image.asset(
  //                 'images/mimi9.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         )
  //       ],
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     ),
  //     decoration: BoxDecoration(
  //         border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
  //         color: Colors.white),
  //     padding: EdgeInsets.all(5.0),
  //     height: 180.0,
  //   );
  // }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: AppTheme.appColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: AppTheme.appColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: AppTheme.appColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: AppTheme.appColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage(List<dynamic> messages) {
    return Flexible(
      child: (messages.isEmpty || messages == null)
          ? Center(child: Loading())
          : Builder(
              builder: (context) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(index, messages[index]),
                  itemCount: messages.length,
                  reverse: true,
                  controller: listScrollController,
                );
              },
            ),
    );
  }
}
