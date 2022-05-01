import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_bloc/models/failure_model.dart';

void errorDialog(BuildContext context, Failure e) {
  print('code: ${e.code}\nmessage: ${e.message}\nplugin:');

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('${e.code}'),
          content: Text('${e.message}'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  else{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('${e.code}'),
         content: Text('${e.message}'),
        actions: [ TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),],
      );
    });
  }


}