import 'package:flutter/material.dart';

class CustomDialog {
  Future<bool?> buildFullScreenDialog(BuildContext context, Widget child) {
    return showDialog<bool>(
      // useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Material(
                child: Stack(children: [
          Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: Row(
              children: [
                CloseButton(
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          child,
        ])));
      },
    );
  }
}
