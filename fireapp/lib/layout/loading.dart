import 'dart:async';
import 'package:flutter/material.dart';

/// Loading Animation
@immutable
class NetLoadingDialog extends StatefulWidget {
  final String loadingText;
  // The async method which need some time to execute
  final Future<dynamic> loadingMethod;
  // Deal with the return value of loadingMethod,
  // which is the only input of operation
  final Function operation;

  const NetLoadingDialog(
      {key,
      this.loadingText = 'Loading...',
      required this.loadingMethod,
      required this.operation
      })
      : super(key: key);

  @override
  State<NetLoadingDialog> createState() => _LoadingDialog();
}

class _LoadingDialog extends State<NetLoadingDialog> {
  @override
  void initState() {
    super.initState();
    // Method execution completed
    widget.loadingMethod.then((value) {
      // Hide loading dialog
      Navigator.pop(context);
      // Execute the operation
      widget.operation(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: const ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(
                    widget.loadingText,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
