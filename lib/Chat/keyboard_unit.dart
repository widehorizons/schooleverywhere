import 'package:flutter/cupertino.dart';

class KeyboardUtil {
  void hideKeyboard(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
