import 'package:flutter/material.dart';

class SizedBoxAppBarMaxHeight extends StatelessWidget {
  const SizedBoxAppBarMaxHeight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Scaffold.of(context).appBarMaxHeight);
  }
}
