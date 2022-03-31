import 'dart:io';

import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({Key? key}) : super(key: key);

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
      durationToAlertAgain: Duration.zero,
      child: Center(child: Text('Please Check App Update...')),
    );
  }
}
