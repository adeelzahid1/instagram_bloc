import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:instagram_bloc/models/failure_model.dart';

class ErrorDialog extends StatelessWidget {
 final Failure e;

  const ErrorDialog({Key? key, required this.e,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
  }

    CupertinoAlertDialog _showIOSDialog(BuildContext context){
        return CupertinoAlertDialog(
          title: Text('${e.code}'),
          content: Text('${e.message}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
    }

    AlertDialog _showAndroidDialog(BuildContext context){
      return AlertDialog(
        title: Text('${e.code}'),
         content: Text('${e.message}'),
        actions: [ TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),],
      );
    }

}