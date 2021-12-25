class ChatMessages {
  String? mainid;
  String? mainDate;
  String? staffid;
  String? staffname;
  String? comment;
  String? subject;
  List<MessageFile>? mainFiles;
  String? voice;
  String? url;
  List<ReplyMessage>? replyMessages;

  ChatMessages(
      {this.mainid,
      this.mainDate,
      this.staffid,
      this.staffname,
      this.comment,
      this.subject,
      this.mainFiles,
      this.voice,
      this.url,
      this.replyMessages});

  ChatMessages.fromJson(Map<String, dynamic> json) {
    mainid = json['mainid'];
    mainDate = json['mainDate'];
    staffid = json['staffid'];
    staffname = json['staffname'];
    comment = json['Comment'];
    subject = json['Subject'];
    if (json['mainFile'] != null) {
      mainFiles = <MessageFile>[];
      json['mainFile'].forEach((v) {
        mainFiles!.add(new MessageFile.fromJson(v));
      });
    }
    voice = json['voice'];
    url = json['url'];
    if (json['data'] != null) {
      replyMessages = <ReplyMessage>[];
      json['data'].forEach((v) {
        replyMessages!.add(new ReplyMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainid'] = this.mainid;
    data['mainDate'] = this.mainDate;
    data['staffid'] = this.staffid;
    data['staffname'] = this.staffname;
    data['Comment'] = this.comment;
    data['Subject'] = this.subject;
    if (this.mainFiles != null) {
      data['mainFile'] = this.mainFiles!.map((v) => v.toJson()).toList();
    }
    data['voice'] = this.voice;
    data['url'] = this.url;
    if (this.replyMessages != null) {
      data['data'] = this.replyMessages!.map((v) => v.toJson()).toList();
    }
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
  int? timestamp;
  String? replymessage;
  String? sendertype;
  String? staffname;
  String? studentname;
  String? voice;
  String? url;
  List<MessageFile>? files;

  ReplyMessage(
      {this.id,
      this.date,
      this.timestamp,
      this.replymessage,
      this.sendertype,
      this.staffname,
      this.studentname,
      this.voice,
      this.url,
      this.files});

  ReplyMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['Date'];
    timestamp = json['timestamp'];
    replymessage = json['replymessage'];
    sendertype = json['sendertype'];
    staffname = json['staffname'];
    studentname = json['studentname'];
    if (json['File'] != null) {
      files = <MessageFile>[];
      json['File'].forEach((v) {
        files!.add(new MessageFile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Date'] = this.date;
    data['timestamp'] = this.timestamp;
    data['replymessage'] = this.replymessage;
    data['sendertype'] = this.sendertype;
    data['staffname'] = this.staffname;
    data['studentname'] = this.studentname;
    if (this.files != null) {
      data['File'] = this.files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
