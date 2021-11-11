import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:schooleverywhere/Chat/cubit/chatcubit_cubit.dart';
import 'package:schooleverywhere/Modules/EventObject.dart';
import 'package:schooleverywhere/Modules/Staff.dart';
import 'package:schooleverywhere/Modules/Student.dart';
import 'package:schooleverywhere/Networking/ApiConstants.dart';
import 'package:schooleverywhere/Networking/Futures.dart';
import 'package:schooleverywhere/Pages/DownloadList.dart';
import 'package:schooleverywhere/SharedPreferences/Prefs.dart';
import 'package:schooleverywhere/Style/theme.dart';
import 'package:schooleverywhere/widget/full_photo.dart';
import 'package:schooleverywhere/widget/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/chat_messages.dart';
import 'components/chat_player_widget.dart';
import 'keyboard_unit.dart';

class Chat extends StatefulWidget {
  Chat(
    this.regno,
    this.id,
    this.type,
  );

  final String id;
  final String regno;

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
      body: ChatScreen(widget.type, widget.id, widget.regno),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(this.type, this.id, this.regno);
  final String type;
  final String regno;

  final String id;
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState();
  String Url = ApiConstants.REPLY_SENDTOCLASS_STUDENT_API;

  late String id;
  ChatMessages? chatMessages;
  List<ReplyMessage>? listMessage;
  late String groupChatId;
  late SharedPreferences prefs;
  Staff? loggedStaff;

  Student? loggedStudent;
  late File imageFile;
  late bool isLoading;
  late bool isShowSticker;
  late String imageUrl;
  FileType? _pickingType;
  File? filepath;
  bool loadingPath = false;
  bool _hasValidMime = false;
  List<File> selectedFilesList = [];
  List<String> selectedFilesNameList = [];
  List<File> tempSelectedFilesList = [];
  List NewFileName = [];
  bool dataSend = false;
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
      loggedStaff = await getUserData() as Staff;
      print("staffData " + loggedStaff!.id.toString() + widget.id);
      getData();
    }
    // InsertSeenRec();
  }

  Future<void> getData() async {
    print("ID:" + widget.id.toString());
    if (widget.type == 'Student') {
      BlocProvider.of<ChatCubit>(context).getAllMessages(
        widget.type,
        widget.id,
        widget.regno,
      );
    }
    if (widget.type == 'Staff') {
      EventObject eventObject = await readReplySentToClass(
          widget.id.toString(), widget.regno, loggedStaff!.id!);
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

  // Future getImage() async {
  //   XFile? pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   imageFile = File(pickedFile!.path);
  //   if (imageFile != null) {
  //     if (!selectedFilesNameList.contains(p.basename(imageFile.path))) {
  //       setState(() {
  //         selectedFilesList.add(imageFile);
  //         selectedFilesNameList.add(p.basename(imageFile.path));
  //         tempSelectedFilesList = [];
  //       });
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "File ${p.basename(imageFile.path)} already selected",
  //           toastLength: Toast.LENGTH_LONG,
  //           timeInSecForIosWeb: 3,
  //           backgroundColor: AppTheme.appColor,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //     // uploadFile();
  //   }
  // }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => loadingPath = true);
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.any);

        if (result != null) {
          tempSelectedFilesList
              .addAll(result.paths.map((path) => File(path!)).toList());
        }
        ;
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        loadingPath = false;
        if (tempSelectedFilesList.length > 0) {
          tempSelectedFilesList.forEach((element) {
            if (!selectedFilesNameList.contains(p.basename(element.path))) {
              selectedFilesList.add(element);
              selectedFilesNameList.add(p.basename(element.path));
            } else {
              Fluttertoast.showToast(
                  msg:
                      "File ${p.basenameWithoutExtension(element.path)} already selected",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 3,
                  backgroundColor: AppTheme.appColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            ;
          });
          tempSelectedFilesList = [];
        }
      });
    }
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

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '' || selectedFilesList.isNotEmpty) {
      textEditingController.clear();
      // NewFileName = await uploadFile(selectedFilesList, Url);
      EventObject eventObject = await replyReplySendtoclassStudent(
          selectedFilesList,
          content,
          widget.regno,
          widget.id,
          chatMessages!.staffid!,
          chatMessages!.staffname!,
          "1627",
          "2019/2020");
      if (eventObject.success!) {
        Fluttertoast.showToast(
            msg: "Message Sent",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          selectedFilesList.clear();
          selectedFilesNameList.clear();
        });
        listScrollController.animateTo(MediaQuery.of(context).size.height * 0.8,
            duration: Duration(milliseconds: 700), curve: Curves.easeOut);
      } else {
        String msg = eventObject.object.toString();
        /*   Flushbar(
                          title: "Failed",
                          message: msg,
                          icon: Icon(Icons.close),
                          backgroundColor: AppTheme.appColor,
                          duration: Duration(seconds: 3),
                        )..show(context);*/
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
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
            if (message.files != null)
              Column(
                children: List.generate(
                  message.files!.length,
                  (index) => (message.files![index].filetype == "image")
                      ? Container(
                          padding: EdgeInsets.all(3),
                          // width: 200.0,
                          decoration: BoxDecoration(
                              color: isCurrentUserMessage(message)
                                  ? Colors.grey.shade800
                                  : AppTheme.appColor,
                              borderRadius: BorderRadius.circular(8.0)),

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
                                imageUrl: message.files![index].link!,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitWidth,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullPhoto(
                                          url: message.files![index].link)));
                            },
                            padding: EdgeInsets.all(0),
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        )
                      : Container(
                          height: 60,
                          width: 200,
                          child: DownloadList(
                            message.files!.map((e) => e.toJson()).toList(),
                            platform: Theme.of(context).platform,
                            title: '',
                          )),
                ),
              ),
            if (message.voice != null)
              Container(
                child: ChatPlayerWidget(url: message.voice!),
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: isCurrentUserMessage(message)
                        ? AppTheme.appColor
                        : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(
                    bottom: isLastMessageRight(index) ? 20.0 : 5.0,
                    right: 10.0),
              ),
            Column(
              children: [
                (message.replymessage!.trim() != '')
                    ? Container(
                        child: Text(
                          message.replymessage!,
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: isCurrentUserMessage(message)
                                ? AppTheme.appColor
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(bottom: 5.0, right: 10.0),
                      )
                    : Container(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                DateTime.parse(message.date!)
                                    .millisecondsSinceEpoch
                                    .toString()))),
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text((message.sendertype == "student")
                            ? message.studentname!.split(' ').first
                            : message.staffname!),
                      )
                    ],
                  ),
                  // margin: EdgeInsets.only(top: .0, bottom: 2.0),
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
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatcubitRepliesSuccess) {
          Map<String, dynamic> data = state.data.object as Map<String, dynamic>;
          chatMessages = ChatMessages.fromJson(data);

          setState(() {
            print(chatMessages);
            chatMessages;
            listMessage = chatMessages!.replyMessages ?? [];
            print("Messages here ===> ${chatMessages!.comment}");
          });
        }
        if (state is ChatcubitError) {
          String msg = state.error;
          Fluttertoast.showToast(
              msg: msg.toString(),
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                (chatMessages != null)
                    ? buildListMessage(listMessage!)
                    : Flexible(child: Center(child: Loading())),

                // Sticker
                (selectedFilesList.isNotEmpty
                    ? buildFilesContainer(selectedFilesList)
                    : Container()),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildFilesContainer(List<File> filesList) {
    return Container(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filesList
            .map((e) => Stack(
                  children: [
                    Positioned(
                      right: 0,
                      left: 0,
                      child: CloseButton(
                        color: Colors.red,
                        onPressed: () => {},
                      ),
                    ),
                    FlatButton(
                      onPressed: () => {
                        setState(() {
                          filesList.removeWhere((element) => element == e);
                          selectedFilesList
                              .removeWhere((element) => element == e);
                          selectedFilesNameList.removeWhere(
                              (element) => element == p.basename(e.path));
                        })
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            fileIconPath(e),
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                          Container(
                              width: 50,
                              child: Text(
                                "${p.basenameWithoutExtension(e.path)}",
                                overflow: TextOverflow.ellipsis,
                              )),
                          Text("${p.extension(e.path)}")
                        ],
                      ),
                    ),
                  ],
                ))
            .toList(),
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 100.0,
    );
  }

  String fileIconPath(File file) {
    print(p.extension(file.path));
    if ([".png", ".jpg", ".svg", ".jpeg"]
        .contains(p.extension(file.path).toString())) {
      print("is Image");
      return "assets/icons/file-image.svg";
    }
    if ((p.extension(file.path).toString()) == ".pdf") {
      print("is Image");
      return "assets/icons/file-pdf.svg";
    } else {
      print("is File");
      return "assets/icons/file.svg";
    }
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
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 1.0),
          //     child: IconButton(
          //       icon: Icon(Icons.image),
          //       onPressed: getImage,
          //       color: AppTheme.appColor,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: _openFileExplorer,
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
          BlocListener<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatcubitSendSuccess) {
                Fluttertoast.showToast(
                    msg: "Message Sent",
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 3,
                    backgroundColor: AppTheme.appColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
                textEditingController.clear();
                setState(() {
                  selectedFilesList.clear();
                  selectedFilesNameList.clear();
                  listScrollController.animateTo(
                      listScrollController.position.maxScrollExtent,
                      duration: Duration(seconds: 2),
                      curve: Curves.easeOut);
                });
              }
              if (state is ChatcubitError) {
                String msg = state.error;

                Fluttertoast.showToast(
                    msg: msg,
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 3,
                    backgroundColor: AppTheme.appColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (textEditingController.text.trim() != '' ||
                        selectedFilesList.isNotEmpty) {
                      KeyboardUtil().hideKeyboard(context);
                      BlocProvider.of<ChatCubit>(context).sendReply(
                          widget.type,
                          selectedFilesList,
                          textEditingController.text,
                          widget.regno,
                          widget.id,
                          chatMessages!.staffid!,
                          "manar",
                          "1627",
                          "2019/2020");
                    } else {
                      Fluttertoast.showToast(msg: 'Nothing to send');
                    }
                  },
                  color: AppTheme.appColor,
                ),
              ),
              color: Colors.white,
            ),
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
    Timer(
      Duration(milliseconds: 300),
      () => listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut),
    );
    return Flexible(
      child: Builder(
        builder: (context) {
          messages = [
            ReplyMessage(
                date: chatMessages!.mainDate,
                files: (chatMessages!.mainFiles != null)
                    ? chatMessages!.mainFiles!
                    : null,
                replymessage: chatMessages!.comment,
                sendertype: "staff",
                staffname: (widget.type == "Staff") ? "" : "",
                studentname: "",
                voice: chatMessages!.voice),
            ...messages!
          ];
          // messages!.sort((a, b) => DateTime.parse(a.date!)
          //     .millisecondsSinceEpoch
          //     .toString()
          //     .compareTo(
          //         DateTime.parse(a.date!).millisecondsSinceEpoch.toString()));
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildItem(index, messages![index]),
            itemCount: messages!.length,
            reverse: false,
            shrinkWrap: true,
            controller: listScrollController,
          );
        },
      ),
    );
  }
}
