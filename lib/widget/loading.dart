import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Style/theme.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: const SpinKitPouringHourGlass(
          color: AppTheme.appColor,
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
