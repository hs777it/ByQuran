import 'package:flutter/material.dart';

import '../../constant.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
        indent: 16,
        endIndent: 16,
        thickness: 1.25,
        color: kMainColor,
        height: 16);
  }
}
