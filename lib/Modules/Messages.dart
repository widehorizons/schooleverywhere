class Messages {
  final String id;
  final String date;
  final String see;
  final String sender;
  final String messageTitle;
  final String messageBody;
  final String messageBodyPart;
  final String messageReplayStatus;
  final List attachment;
  final String senderName;
  final String path;
  final String? url;
  //final String picture;

  // User(this.index, this.about, this.name, this.email, this.picture);
  Messages(
      this.id,
      this.date,
      this.see,
      this.sender,
      this.messageTitle,
      this.messageBody,
      this.messageBodyPart,
      this.attachment,
      this.messageReplayStatus,
      this.senderName,
      this.path,
      this.url);
}
