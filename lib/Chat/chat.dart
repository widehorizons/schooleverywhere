import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:schooleverywhere/Modules/EventObject.dart';
import 'package:schooleverywhere/Modules/Parent.dart';
import 'package:schooleverywhere/Modules/Student.dart';
import 'package:schooleverywhere/Networking/Futures.dart';
import 'package:schooleverywhere/Pages/DownloadList.dart';
import 'package:schooleverywhere/SharedPreferences/Prefs.dart';
import 'package:schooleverywhere/Style/theme.dart';
import 'package:schooleverywhere/widget/full_photo.dart';
import 'package:schooleverywhere/widget/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/chat_messages.dart';
import 'components/chat_player_widget.dart';

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
  @override
  void initState() {
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
  ChatMessages? chatMessages;
  List<ReplyMessage>? listMessage;
  late String groupChatId;
  late SharedPreferences prefs;
  Parent? loggedParent;

  Student? loggedStudent;
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
    getLoggedStudent();
  }

  Future<void> getLoggedStudent() async {
    print("User Type in Chat module ${widget.type}");
    if (widget.type == "Student") {
      loggedStudent = await getUserData() as Student;
      print("studentData " + loggedStudent!.id! + " " + widget.id);
      getData();
    } else {
      loggedParent = await getUserData() as Parent;
      print("ParentData " + loggedParent!.regno.toString() + widget.id);
      getData();
    }
    // InsertSeenRec();
  }

  Future<void> getData() async {
    print("ID:" + widget.id.toString());
    if (widget.type == 'Student') {
      EventObject eventObject =
          await getStudentMessages(widget.id.toString(), loggedStudent!.id!);
      if (eventObject.success!) {
        Map<String, dynamic> data = eventObject.object as Map<String, dynamic>;
        chatMessages = ChatMessages.fromJson(data);
        setState(() {
          print(chatMessages);
          chatMessages;
          listMessage = chatMessages!.replyMessages ?? [];
          print("Messages here ===> ${chatMessages!.comment}");
        });
      } else {
        String? msg = eventObject.object as String?;

        Fluttertoast.showToast(
            msg: msg.toString(),
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
      listScrollController.animateTo(MediaQuery.of(context).size.height * 0.8,
          duration: Duration(milliseconds: 700), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  bool isCurrentUserMessage(ReplyMessage message) {
    return message.sendertype.toString().toLowerCase() ==
        widget.type.toLowerCase();
  }

  Widget buildItem(int index, ReplyMessage message) {
    print("message Role ===> ${message.sendertype} ${widget.type} ");

    return Row(
      children: <Widget>[
        // Text
        Column(
          children: [
            if (message.file != null)
              message.file!.filetype == "image"
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Loading(),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'img/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: message.file!.link!,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullPhoto(url: message.file!.link)));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      height: 100,
                      width: 200,
                      child: DownloadList(
                        [message.file!.toJson()],
                        platform: Theme.of(context).platform,
                        title: '',
                      ),
                    ),
            if (message.voice != null)
              Container(
                child: ChatPlayerWidget(url: message.voice!),
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: isCurrentUserMessage(message)
                        ? Colors.grey.shade300
                        : AppTheme.appColor,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(
                    bottom: isLastMessageRight(index) ? 20.0 : 5.0,
                    right: 10.0),
              ),
            Column(
              children: [
                Container(
                  child: Text(
                    message.replymessage!,
                    style: TextStyle(
                        color: isCurrentUserMessage(message)
                            ? AppTheme.appColor
                            : Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: isCurrentUserMessage(message)
                          ? Colors.grey.shade300
                          : AppTheme.appColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 5.0,
                      right: 10.0),
                ),
                Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                            DateTime.parse(message.date!)
                                .millisecondsSinceEpoch
                                .toString()))),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                  margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
                )
              ],
            ),
          ],
        ),
      ],
      mainAxisAlignment: isCurrentUserMessage(message)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage![index - 1].sendertype == widget.type) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage![index - 1].sendertype != widget.type) ||
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
              (chatMessages != null)
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
                  hintStyle: TextStyle(color: Colors.grey),
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
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage(List<ReplyMessage>? messages) {
    return Flexible(
      child: Builder(
        builder: (context) {
          messages = [
            ReplyMessage(
                date: chatMessages!.mainDate,
                file: (chatMessages!.mainFile != null)
                    ? chatMessages!.mainFile![0]
                    : null,
                replymessage: chatMessages!.comment,
                sendertype: "staff",
                voice: chatMessages!.voice),
            ...messages!
          ];
          messages!.sort((a, b) => DateTime.parse(a.date!)
              .millisecondsSinceEpoch
              .toString()
              .compareTo(
                  DateTime.parse(a.date!).millisecondsSinceEpoch.toString()));
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildItem(index, messages![index]),
            itemCount: messages!.length,
            reverse: false,
            controller: listScrollController,
          );
        },
      ),
    );
  }
}
