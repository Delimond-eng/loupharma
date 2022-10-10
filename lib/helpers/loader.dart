import 'package:flutter/material.dart';

void showCircularProgress(context, {String title}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ignore: prefer_const_constructors
              CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 3,
              ),
              if (title.isNotEmpty)
                const SizedBox(
                  width: 10,
                ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
