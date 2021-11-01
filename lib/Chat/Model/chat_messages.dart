class ChatMessages {
  String? mainid;
  String? mainDate;
  String? comment;
  String? subject;
  List<MessageFile>? mainFile;
  String? voice;
  List<ReplyMessage>? replyMessages;
  bool? success;

  ChatMessages(
      {this.mainid,
      this.mainDate,
      this.comment,
      this.subject,
      this.mainFile,
      this.voice,
      this.replyMessages,
      this.success});

  ChatMessages.fromJson(Map<String, dynamic> json) {
    mainid = json['mainid'];
    mainDate = json['mainDate'];
    comment = json['Comment'];
    subject = json['Subject'];
    if (json['mainFile'] != null) {
      mainFile = <MessageFile>[];
      json['mainFile'].forEach((v) {
        mainFile!.add(new MessageFile.fromJson(v));
      });
    }
    voice = json['voice'];
    if (json['data'] != null) {
      replyMessages = <ReplyMessage>[];
      json['data'].forEach((v) {
        replyMessages!.add(new ReplyMessage.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainid'] = this.mainid;
    data['mainDate'] = this.mainDate;
    data['Comment'] = this.comment;
    data['Subject'] = this.subject;
    if (this.mainFile != null) {
      data['mainFile'] = this.mainFile!.map((v) => v.toJson()).toList();
    }
    data['voice'] = this.voice;
    if (this.replyMessages != null) {
      data['replyMessages'] =
          this.replyMessages!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class MessageFile {
  String? name;
  String? link;
  String? filetype;

  MessageFile({this.name, this.link, this.filetype});

  MessageFile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
    filetype = json['filetype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['link'] = this.link;
    data['filetype'] = this.filetype;
    return data;
  }
}

class ReplyMessage {
  String? id;
  String? date;
  String? replymessage;
  String? sendertype;
  String? staffname;
  String? studentname;
  MessageFile? file;

  ReplyMessage(
      {this.id,
      this.date,
      this.replymessage,
      this.sendertype,
      this.staffname,
      this.studentname,
      this.file});

  ReplyMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['Date'];
    replymessage = json['replymessage'];
    sendertype = json['sendertype'];
    staffname = json['staffname'];
    studentname = json['studentname'];
    file = json['File'] != null ? new MessageFile.fromJson(json['File']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Date'] = this.date;
    data['replymessage'] = this.replymessage;
    data['sendertype'] = this.sendertype;
    data['staffname'] = this.staffname;
    data['studentname'] = this.studentname;
    if (this.file != null) {
      data['File'] = this.file!.toJson();
    }
    return data;
  }
}
