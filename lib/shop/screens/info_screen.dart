import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static const routeName = '/info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('in Bearbeitung...', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
