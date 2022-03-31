import 'dart:io';

import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      showIgnore: false,
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      showReleaseNotes: false,
      showLater: false,
      durationToAlertAgain: Duration(hours: 8),
      child: Center(child: widget.child),
    );
  }
}
